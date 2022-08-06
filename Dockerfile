FROM ubuntu:18.04 AS updates
LABEL mantainer=”ctaffer@unsl.edu.ar”
WORKDIR /root
RUN apt update
RUN apt install -y iproute2 net-tools telnet netcat iptables tcpdump iputils-ping openssh-client nano less

FROM ubuntu:18.04
LABEL mantainer=”ctaffer@unsl.edu.ar”
COPY --from=updates /usr/bin/telnet /usr/bin/telnet
COPY --from=updates /bin/nc /bin/nc
#need to fix
#COPY --from=updates /sbin/ip /sbin/ip
COPY --from=updates /sbin/route /sbin/route
COPY --from=updates /bin/netstat /bin/netstat
#iptables package
COPY --from=updates /sbin/xtables-multi /sbin/xtables-multi
COPY --from=updates /usr/lib/x86_64-linux-gnu/xtables/* /usr/lib/x86_64-linux-gnu/xtables/
COPY --from=updates /usr/sbin/iptables-apply /usr/sbin/iptables-apply
COPY --from=updates /usr/sbin/nfnl_osf /usr/sbin/nfnl_osf
COPY --from=updates /usr/bin/iptables-xml /usr/bin/iptables-xml
COPY --from=updates /usr/sbin/ip6tables* /usr/sbin/
COPY --from=updates /usr/sbin/iptables* /usr/sbin/
RUN echo root:lpr | chpasswd
RUN apt autoremove
