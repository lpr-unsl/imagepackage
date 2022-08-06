FROM ubuntu:18.04 AS updates
LABEL mantainer=”ctaffer@unsl.edu.ar”
WORKDIR /root
RUN apt update
RUN apt install -y iproute2 net-tools telnet netcat iptables tcpdump iputils-ping openssh-client nano less

FROM ubuntu:18.04
LABEL mantainer=”ctaffer@unsl.edu.ar”
#need to fix take a look there ( dpkg -L iproute2)
#COPY --from=updates /bin/ip /bin/ip
#COPY --from=updates /sbin/ip /sbin/ip
#net-tool packages
COPY --from=updates /bin/netstat /bin/netstat
COPY --from=updates /sbin/ifconfig /sbin/ifconfig
COPY --from=updates /sbin/ipmaddr /sbin/ipmaddr
COPY --from=updates /sbin/iptunnel /sbin/iptunnel
COPY --from=updates /sbin/mii-tool /sbin/mii-tool
COPY --from=updates /sbin/nameif /sbin/nameif
COPY --from=updates /sbin/plipconfig /sbin/plipconfig
COPY --from=updates /sbin/rarp /sbin/rarp
COPY --from=updates /sbin/route /sbin/route
COPY --from=updates /sbin/slattach /sbin/slattach
COPY --from=updates /usr/sbin/arp /usr/sbin/arp
#telnet package
COPY --from=updates /usr/bin/telnet.netkit /usr/bin/telnet.netkit
#netcat package
COPY --from=updates /bin/nc.traditional /bin/nc.traditional
#iptables package
COPY --from=updates /sbin/xtables-multi /sbin/xtables-multi
COPY --from=updates /usr/lib/x86_64-linux-gnu/xtables/* /usr/lib/x86_64-linux-gnu/xtables/
COPY --from=updates /usr/sbin/iptables-apply /usr/sbin/iptables-apply
COPY --from=updates /usr/sbin/nfnl_osf /usr/sbin/nfnl_osf
COPY --from=updates /usr/share/iptables/iptables.xslt /usr/share/iptables/iptables.xslt
COPY --from=updates /usr/sbin/ip6tables* /usr/sbin/
COPY --from=updates /usr/sbin/iptables* /usr/sbin/
COPY --from=updates /usr/bin/iptables-xml /usr/bin/iptables-xml
COPY --from=updates /usr/sbin/ip6tables-apply /usr/sbin/ip6tables-apply
RUN echo root:lpr | chpasswd
RUN apt autoremove
