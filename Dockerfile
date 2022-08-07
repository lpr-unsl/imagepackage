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
###COPY --from=updates /bin/netstat /bin/netstat
###COPY --from=updates /sbin/ifconfig /sbin/ifconfig
###COPY --from=updates /sbin/ipmaddr /sbin/ipmaddr
###COPY --from=updates /sbin/iptunnel /sbin/iptunnel
###COPY --from=updates /sbin/mii-tool /sbin/mii-tool
###COPY --from=updates /sbin/nameif /sbin/nameif
###COPY --from=updates /sbin/plipconfig /sbin/plipconfig
###COPY --from=updates /sbin/rarp /sbin/rarp
###COPY --from=updates /sbin/route /sbin/route
###COPY --from=updates /sbin/slattach /sbin/slattach
###COPY --from=updates /usr/sbin/arp /usr/sbin/arp
#telnet package
COPY --from=updates /usr/bin/telnet.netkit /usr/bin/telnet.netkit
RUN ln -s /usr/bin/telnet.netkit /etc/alternatives/telnet
RUN ln -s /etc/alternatives/telnet /usr/bin/telnet
#netcat package
COPY --from=updates /bin/nc.traditional /bin/nc.traditional
RUN ln -s /bin/nc.traditional /etc/alternatives/nc
RUN ln -s /etc/alternatives/nc /bin/nc
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
RUN ln -s /sbin/xtables-multi /sbin/iptables
RUN ln -s /sbin/xtables-multi /sbin/iptables-restore
RUN ln -s /sbin/xtables-multi /sbin/iptables-save
###RUN ln -s /sbin/xtables-multi /sbin/ip6tables
###RUN ln -s /sbin/xtables-multi /sbin/ip6tables-restore
###RUN ln -s /sbin/xtables-multi /sbin/ip6tables-save
#shared libs needed by iptables
COPY --from=updates /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip4tc.so.0
COPY --from=updates /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip6tc.so.0
COPY --from=updates /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0 /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0 /usr/lib/x86_64-linux-gnu/libxtables.so.12

#set root pass
RUN echo root:lpr | chpasswd
RUN apt autoremove
