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
ip6tables -A INPUT -i lo -j ACCEPT

# 3. Разрешаем только по портам 80, 443
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
./add_cloudflare_ips.sh

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

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT






# === ./add_cloudflare_ips.sh

#!/bin/bash

# Получаем списки IP-адресов
ipv4_addresses=$(curl -s https://www.cloudflare.com/ips-v4)
ipv6_addresses=$(curl -s https://www.cloudflare.com/ips-v6)

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
add_rules "$ipv6_addresses" "ipv6"

# Выводим сообщение о завершении
echo "Rules added successfully!"

# === конец копирования