# Разрешить все:
# iptables -P INPUT ACCEPT &&
# iptables -P FORWARD ACCEPT &&
# iptables -P OUTPUT ACCEPT &&
# ip6tables -P INPUT ACCEPT &&
# ip6tables -P FORWARD ACCEPT &&
# ip6tables -P OUTPUT ACCEPT

# 1. Сброс и разрешение ssh:
iptables -F && ip6tables -F && 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT && 
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT


# 2. loopback:
iptables -A INPUT -i lo -j ACCEPT &&
# ip6tables -A INPUT -i lo -j ACCEPT

# 3. Разрешаем только по портам 80, 443
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
./add_cloudflare_ips.sh
./update_iptables.sh

# 4. Разрешаем TOR и MongoDB
iptables -A INPUT -p tcp --dport 9050 -j ACCEPT
iptables -A INPUT -p tcp --dport 27017 -j ACCEPT

# 5. Разрешаем подключение по outline (VPN)
iptables -A INPUT -p tcp --dport 32364 -j ACCEPT

# 6. Блокируем ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j DROP

# 7. Остальное дропаем
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# ip6tables -P INPUT DROP
# ip6tables -P FORWARD DROP
# ip6tables -P OUTPUT ACCEPT






# === ./add_cloudflare_ips.sh

#!/bin/bash

# Получаем списки IP-адресов
ipv4_addresses=$(curl -s https://www.cloudflare.com/ips-v4)
# ipv6_addresses=$(curl -s https://www.cloudflare.com/ips-v6)

# Функция добавления адресов в iptables и ip6tables
add_rules() {
    local ip_list="$1"
    local version="$2"
    local ipt_cmd

    if [ "$version" == "ipv4" ]; then
        ipt_cmd="iptables"
    else
        ipt_cmd="ip6tables"
    fi

    for ip in $ip_list; do
        $ipt_cmd -A INPUT -p tcp -s $ip --dport 80 -j ACCEPT
        $ipt_cmd -A INPUT -p tcp -s $ip --dport 443 -j ACCEPT
    done
}

# Добавляем правила
add_rules "$ipv4_addresses" "ipv4"
# add_rules "$ipv6_addresses" "ipv6"

# Выводим сообщение о завершении
echo "Rules added successfully!"

# === конец копирования








### === контент ./update_iptables.sh

#!/bin/bash

# Функция для проверки, является ли строка валидным IP-адресом
is_valid_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi

    return $stat
}

# Функция для проверки, является ли строка валидным IP-адресом
is_valid_ip6() {
    local ip=$1
    local stat=1

    local ipv6regex="^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$"

    if [[ $ip =~ $ipv6regex ]]; then
        stat=0
    fi

    return $stat
}

# Список доменов
DOMAINS=("api.telegram.org" "github.com")

# Для каждого домена из списка
for DOMAIN in "${DOMAINS[@]}"; do
    # Получить текущие IP-адреса для домена
    IPs=$(dig $DOMAIN A +short)

    for IP in $IPs; do
        if is_valid_ip $IP; then
            # Добавить правило в iptables для каждого IP-адреса
            iptables -A OUTPUT -d $IP -j ACCEPT
            iptables -A INPUT -s $IP -j ACCEPT
            echo "Added ipv4 ${IP} to ${DOMAIN}"
        fi
    done
done

# Для каждого домена из списка
# for DOMAIN in "${DOMAINS[@]}"; do
#     # Получить текущие IP-адреса для домена
#     IPs=$(dig $DOMAIN AAAA +short)

#     for IP in $IPs; do
#         if is_valid_ip6 $IP; then
#             # Добавить правило в iptables для каждого IP-адреса
#             ip6tables -A OUTPUT -d $IP -j ACCEPT
#             ip6tables -A INPUT -s $IP -j ACCEPT
#             echo "Added ipv6 ${IP} to ${DOMAIN}"
#         fi
#     done
# done

echo "Rules added successfully!"
### ===== конец копирования