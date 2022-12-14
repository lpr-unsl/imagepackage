FROM ubuntu:18.04 AS updates
LABEL mantainer=”ctaffer@unsl.edu.ar”
WORKDIR /root
RUN apt update
RUN apt install -y iproute2 net-tools telnet netcat iptables tcpdump iputils-ping openssh-client nano less

FROM ubuntu:18.04
LABEL mantainer=”ctaffer@unsl.edu.ar”
#need to fix take a look there ( dpkg -L iproute2)
#iproute2 package
COPY --from=updates /bin/ip /bin/ip
COPY --from=updates /bin/ss /bin/ss
COPY --from=updates /sbin/bridge /sbin/bridge 
COPY --from=updates /sbin/devlink /sbin/devlink
COPY --from=updates /sbin/rtacct /sbin/rtacct
COPY --from=updates /sbin/rtmon /sbin/rtmon
COPY --from=updates /sbin/tc /sbin/tc
COPY --from=updates /etc/iproute2/* /etc/iproute2/
RUN ln -s /bin/ip /sbin/ip
COPY --from=updates /usr/lib/x86_64-linux-gnu/libelf-0.170.so /usr/lib/x86_64-linux-gnu/libelf-0.170.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libelf-0.170.so /usr/lib/x86_64-linux-gnu/libelf.so.1
COPY --from=updates /lib/x86_64-linux-gnu/libmnl.so.0.2.0 /lib/x86_64-linux-gnu/libmnl.so.0.2.0
RUN ln -s /lib/x86_64-linux-gnu/libmnl.so.0.2.0 /lib/x86_64-linux-gnu/libmnl.so.0
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
#COPY --from=updates /usr/bin/iptables-xml /usr/bin/iptables-xml failed to export image: failed to create image: failed to get layer sha256:edfa9a58e08e591f25a651f0f95a573c0d6d53d45bc2e5048e6de3ed744c9ad9: layer does not exist
COPY --from=updates /usr/sbin/ip6tables-apply /usr/sbin/ip6tables-apply
RUN ln -s /sbin/xtables-multi /sbin/iptables
RUN ln -s /sbin/xtables-multi /sbin/iptables-restore
RUN ln -s /sbin/xtables-multi /sbin/iptables-save
RUN ln -s /sbin/xtables-multi /sbin/ip6tables
RUN ln -s /sbin/xtables-multi /sbin/ip6tables-restore
RUN ln -s /sbin/xtables-multi /sbin/ip6tables-save
#shared libs needed by iptables
COPY --from=updates /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libip4tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip4tc.so.0
COPY --from=updates /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libip6tc.so.0.1.0 /usr/lib/x86_64-linux-gnu/libip6tc.so.0
COPY --from=updates /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0 /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0
RUN ln -s /usr/lib/x86_64-linux-gnu/libxtables.so.12.0.0 /usr/lib/x86_64-linux-gnu/libxtables.so.12
#tcpdump package
COPY --from=updates /usr/sbin/tcpdump /usr/sbin/tcpdump
COPY --from=updates /usr/lib/x86_64-linux-gnu/libcrypto.so.1.* /usr/lib/x86_64-linux-gnu/
COPY --from=updates /usr/lib/x86_64-linux-gnu/libpcap.so.1.8.1 /usr/lib/x86_64-linux-gnu/libpcap.so.1.8.1
RUN ln -s /usr/lib/x86_64-linux-gnu/libpcap.so.1.8.1 /usr/lib/x86_64-linux-gnu/libpcap.so.0.8
#iputils-ping package
COPY --from=updates /bin/ping /bin/ping
RUN ln -s /bin/ping /bin/ping4
RUN ln -s /bin/ping /bin/ping6
COPY --from=updates /lib/x86_64-linux-gnu/libcap.so.2.25 /lib/x86_64-linux-gnu/libcap.so.2.25
RUN ln -s /lib/x86_64-linux-gnu/libcap.so.2.25 /lib/x86_64-linux-gnu/libcap.so.2
COPY --from=updates /lib/x86_64-linux-gnu/libidn.so.11.6.16 /lib/x86_64-linux-gnu/libidn.so.11.6.16
RUN ln -s /lib/x86_64-linux-gnu/libidn.so.11.6.16 /lib/x86_64-linux-gnu/libidn.so.11
#openssh-client package
COPY --from=updates /etc/ssh/* /etc/ssh/
COPY --from=updates /usr/bin/scp /usr/bin/scp
COPY --from=updates /usr/bin/sftp /usr/bin/sftp
COPY --from=updates /usr/bin/ssh* /usr/bin/
RUN ln -s /usr/bin/ssh /usr/bin/slogin
COPY --from=updates /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2.2 /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2.2
RUN ln -s /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2.2 /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2
COPY --from=updates /usr/lib/x86_64-linux-gnu/libkrb5.so.3.3 /usr/lib/x86_64-linux-gnu/libkrb5.so.3.3
RUN ln -s /usr/lib/x86_64-linux-gnu/libkrb5.so.3.3 /usr/lib/x86_64-linux-gnu/libkrb5.so.3
COPY --from=updates /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1
#RUN ln -s /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0
COPY --from=updates /usr/lib/x86_64-linux-gnu/libk5crypto.so.3.1 /usr/lib/x86_64-linux-gnu/libk5crypto.so.3.1
RUN ln -s /usr/lib/x86_64-linux-gnu/libk5crypto.so.3.1 /usr/lib/x86_64-linux-gnu/libk5crypto.so.3
COPY --from=updates /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1
RUN ln -s /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0
COPY --from=updates /lib/x86_64-linux-gnu/libkeyutils.so.1.5 /lib/x86_64-linux-gnu/libkeyutils.so.1.5
RUN ln -s /lib/x86_64-linux-gnu/libkeyutils.so.1.5 /lib/x86_64-linux-gnu/libkeyutils.so.1
#nano package
COPY --from=updates /etc/nanorc /etc/nanorc
COPY --from=updates /bin/nano /bin/nano
COPY --from=updates /usr/share/nano/* /usr/share/nano/
RUN ln -s /bin/nano /bin/rnano
#less package
COPY --from=updates /bin/less /bin/less
COPY --from=updates /bin/lessecho /bin/lessecho
COPY --from=updates /bin/lesskey /bin/lesskey
COPY --from=updates /bin/lesspipe /bin/lesspipe
RUN ln -s /bin/lesspipe /bin/lessfile


#set root pass
RUN echo root:lpr | chpasswd
RUN apt autoremove
