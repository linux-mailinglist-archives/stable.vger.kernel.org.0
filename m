Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DAF1236DF
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfLQUQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfLQUQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:16:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714912176D;
        Tue, 17 Dec 2019 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613789;
        bh=iJ+bQ/+NcBBtmyAde9K0JT+XHSMTuSP4HkjLQZOgIR0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ud4GzmfFm18E66o3nofUwX1UbkfY1CYe6lcDJT0fWalXrb/sMJFnd9ixhorR64MG7
         M2Xr84IWYXuZkNIttgVLBHN2aMriSTdRjNW5nPadMWUeC+8UD/jAPKNBBBhCqUs+5Q
         qUSPvxOSRiGFCSybMt5+UaoFP9Wlllp1DxQIEDXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 00/25] 5.3.18-stable review
Date:   Tue, 17 Dec 2019 21:15:59 +0100
Message-Id: <20191217200903.179327435@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.18-rc1
X-KernelTest-Deadline: 2019-12-19T20:09+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.18 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Note, this is the LAST 5.3.y kernel to be released, after this one, it
will be end-of-life.  You should have moved to the 5.4.y series already
by now.

Responses should be made by Thu, 19 Dec 2019 20:08:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.18-rc1

Jonathan Lemon <jonathan.lemon@gmail.com>
    xdp: obtain the mem_id mutex before trying to remove an entry.

Jonathan Lemon <jonathan.lemon@gmail.com>
    page_pool: do not release pool until inflight == 0.

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5e: Fix TXQ indices to be sequential

Martin Varghese <martin.varghese@nokia.com>
    net: Fixed updating of ethertype in skb_mpls_push()

Taehee Yoo <ap420073@gmail.com>
    hsr: fix a NULL pointer dereference in hsr_dev_xmit()

Martin Varghese <martin.varghese@nokia.com>
    Fixed updating of ethertype in function skb_mpls_pop

Cong Wang <xiyou.wangcong@gmail.com>
    gre: refetch erspan header from skb->data after pskb_may_pull()

Guillaume Nault <gnault@redhat.com>
    tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Guillaume Nault <gnault@redhat.com>
    tcp: tighten acceptance of ACKs not matching a child socket

Guillaume Nault <gnault@redhat.com>
    tcp: fix rejected syncookies due to stale timestamps

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6: add net argument to ip6_dst_lookup_flow

Huy Nguyen <huyn@mellanox.com>
    net/mlx5e: Query global pause state before setting prio2buffer

Taehee Yoo <ap420073@gmail.com>
    tipc: fix ordering of tipc module init and exit routine

Eric Dumazet <edumazet@google.com>
    tcp: md5: fix potential overestimation of TCP option space

Aaron Conole <aconole@redhat.com>
    openvswitch: support asymmetric conntrack

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net/tls: Fix return values to avoid ENOTSUPP

Mian Yousaf Kaukab <ykaukab@suse.de>
    net: thunderx: start phy before starting autonegotiation

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in netdev_queue_add_kobject

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix extra rx interrupt

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: fix flow dissection on Tx path

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: deny dev_set_mac_address() when unregistering

Vladyslav Tarasiuk <vladyslavt@mellanox.com>
    mqprio: Fix out-of-bounds access in mqprio_dump

Eric Dumazet <edumazet@google.com>
    inet: protect against too small mtu values.


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/infiniband/core/addr.c                     |   7 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   8 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  27 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  31 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/geneve.c                               |   4 +-
 drivers/net/vxlan.c                                |   8 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/skbuff.h                             |   5 +-
 include/linux/time.h                               |  13 +++
 include/net/ip.h                                   |   5 +
 include/net/ipv6.h                                 |   2 +-
 include/net/ipv6_stubs.h                           |   6 +-
 include/net/page_pool.h                            |  52 +++------
 include/net/tcp.h                                  |  27 +++--
 include/net/xdp_priv.h                             |   4 -
 include/trace/events/xdp.h                         |  19 +---
 net/bridge/br_device.c                             |   6 +
 net/core/dev.c                                     |   3 +-
 net/core/flow_dissector.c                          |   5 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/net-sysfs.c                               |   7 +-
 net/core/page_pool.c                               | 122 +++++++++++++--------
 net/core/skbuff.c                                  |  10 +-
 net/core/xdp.c                                     | 117 +++++++-------------
 net/dccp/ipv6.c                                    |   6 +-
 net/hsr/hsr_device.c                               |   9 +-
 net/ipv4/devinet.c                                 |   5 -
 net/ipv4/gre_demux.c                               |   2 +-
 net/ipv4/ip_output.c                               |  13 ++-
 net/ipv4/tcp_output.c                              |   5 +-
 net/ipv6/addrconf_core.c                           |  11 +-
 net/ipv6/af_inet6.c                                |   4 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/inet6_connection_sock.c                   |   4 +-
 net/ipv6/ip6_output.c                              |   8 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/syncookies.c                              |   2 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/mpls/af_mpls.c                                 |   7 +-
 net/openvswitch/actions.c                          |   6 +-
 net/openvswitch/conntrack.c                        |  11 ++
 net/sched/act_mpls.c                               |   7 +-
 net/sched/sch_mq.c                                 |   1 +
 net/sched/sch_mqprio.c                             |   3 +-
 net/sctp/ipv6.c                                    |   4 +-
 net/tipc/core.c                                    |  29 ++---
 net/tipc/udp_media.c                               |   9 +-
 net/tls/tls_device.c                               |   8 +-
 net/tls/tls_main.c                                 |   4 +-
 net/tls/tls_sw.c                                   |   8 +-
 tools/testing/selftests/net/tls.c                  |   8 +-
 60 files changed, 375 insertions(+), 332 deletions(-)


