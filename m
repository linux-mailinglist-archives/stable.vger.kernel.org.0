Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA972D295C
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 11:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgLHK6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 05:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgLHK6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 05:58:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.82
Date:   Tue,  8 Dec 2020 11:58:15 +0100
Message-Id: <160742509510821@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.82 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/can/tcan4x5x.txt       |    2 
 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt        |    2 
 Documentation/devicetree/bindings/net/nfc/pn544.txt          |    2 
 Makefile                                                     |    2 
 drivers/crypto/chelsio/chtls/chtls_cm.c                      |    1 
 drivers/crypto/chelsio/chtls/chtls_hw.c                      |    1 
 drivers/infiniband/hw/i40iw/i40iw_main.c                     |    5 
 drivers/infiniband/hw/i40iw/i40iw_verbs.c                    |   36 +-----
 drivers/input/joystick/xpad.c                                |    2 
 drivers/input/serio/i8042-x86ia64io.h                        |    4 
 drivers/net/bonding/bond_main.c                              |   61 +++++++----
 drivers/net/bonding/bond_sysfs_slave.c                       |   18 ---
 drivers/net/ethernet/chelsio/cxgb3/sge.c                     |    1 
 drivers/net/ethernet/ibm/ibmvnic.c                           |   22 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c          |   21 +++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c |    5 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  |    1 
 drivers/net/ethernet/pasemi/pasemi_mac.c                     |    8 +
 drivers/net/geneve.c                                         |   20 ++-
 drivers/net/tun.c                                            |   14 +-
 drivers/net/usb/ipheth.c                                     |    2 
 drivers/net/vxlan.c                                          |    4 
 drivers/staging/octeon/ethernet-tx.c                         |    2 
 include/linux/mlx5/mlx5_ifc.h                                |    9 +
 include/net/bonding.h                                        |    8 +
 include/net/inet_ecn.h                                       |    2 
 include/net/tls.h                                            |    6 +
 kernel/sched/fair.c                                          |   36 +++++-
 kernel/trace/trace_hwlat.c                                   |    2 
 net/bridge/br_netfilter_hooks.c                              |    7 -
 net/core/devlink.c                                           |    4 
 net/core/skbuff.c                                            |    5 
 net/ipv4/route.c                                             |    7 -
 net/ipv4/tcp_cong.c                                          |    5 
 net/ipv6/addrlabel.c                                         |   26 +++-
 net/ipv6/ip6_gre.c                                           |   16 ++
 net/iucv/af_iucv.c                                           |    4 
 net/openvswitch/actions.c                                    |    3 
 net/rose/rose_loopback.c                                     |   17 ++-
 net/sched/act_mpls.c                                         |    3 
 net/tls/tls_device.c                                         |    5 
 net/tls/tls_sw.c                                             |    6 +
 net/x25/af_x25.c                                             |    6 -
 security/integrity/ima/ima.h                                 |    2 
 security/integrity/ima/ima_crypto.c                          |   15 ++
 sound/usb/mixer_us16x08.c                                    |    2 
 48 files changed, 303 insertions(+), 131 deletions(-)

Alexander Duyck (1):
      tcp: Set INET_ECN_xmit configuration in tcp_reinit_congestion_control

Anmol Karn (1):
      rose: Fix Null pointer dereference in rose_send_frame()

Antoine Tenart (2):
      netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal
      net: ip6_gre: set dev->hard_header_len when using header_ops

Dan Carpenter (2):
      net/x25: prevent a couple of overflows
      chelsio/chtls: fix a double free in chtls_setkey()

Davide Caratti (3):
      net: skbuff: ensure LSE is pullable before decrementing the MPLS ttl
      net: openvswitch: ensure LSE is pullable before reading it
      net/sched: act_mpls: ensure LSE is pullable before reading it

Eran Ben Elisha (1):
      net/mlx5: Fix wrong address reclaim when command interface is down

Eric Dumazet (1):
      geneve: pull IP header before ECN decapsulation

Greg Kroah-Hartman (1):
      Linux 5.4.82

Guillaume Nault (1):
      ipv4: Fix tos mask in inet_rtm_getroute()

Hector Martin (1):
      ALSA: usb-audio: US16x08: fix value count for level meters

Jamie Iles (1):
      bonding: wait for sysfs kobject destruction before freeing struct slave

Jens Axboe (1):
      tun: honor IOCB_NOWAIT flag

Julian Wiedmann (1):
      net/af_iucv: set correct sk_protocol for child sockets

Krzysztof Kozlowski (1):
      dt-bindings: net: correct interrupt flags in examples

Maurizio Drocco (1):
      ima: extend boot_aggregate with kernel measurements

Maxim Mikityanskiy (1):
      net/tls: Protect from calling tls_dev_del for TLS RX twice

Parav Pandit (1):
      devlink: Hold rtnl lock while reading netdev attributes

Po-Hsu Lin (1):
      Input: i8042 - add ByteSpeed touchpad to noloop table

Randy Dunlap (1):
      staging/octeon: fix up merge error

Sanjay Govind (1):
      Input: xpad - support Ardwiino Controllers

Shiraz Saleem (1):
      RDMA/i40iw: Address an mmap handler exploit in i40iw

Thomas Falcon (2):
      ibmvnic: Ensure that SCRQ entry reads are correctly ordered
      ibmvnic: Fix TX completion error handling

Toke Høiland-Jørgensen (1):
      inet_ecn: Fix endianness of checksum update when setting ECT(1)

Vadim Fedorenko (1):
      net/tls: missing received data after fast remote close

Vasily Averin (1):
      tracing: Remove WARN_ON in start_thread()

Vinay Kumar Yadav (1):
      chelsio/chtls: fix panic during unload reload chtls

Vincent Guittot (1):
      sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list

Wang Hai (2):
      ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init
      net: mvpp2: Fix error return code in mvpp2_open()

Willem de Bruijn (1):
      sock: set sk_err to ee_errno on dequeue from errq

Yevgeny Kliteynik (1):
      net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering

Yves-Alexis Perez (1):
      usbnet: ipheth: fix connectivity with iOS 14

Zhang Changzhong (3):
      cxgb3: fix error return code in t3_sge_alloc_qset()
      net: pasemi: fix error return code in pasemi_mac_open()
      vxlan: fix error return code in __vxlan_dev_create()

