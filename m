Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A433A279AF0
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgIZQ3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbgIZQ3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:29:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D62235F9;
        Sat, 26 Sep 2020 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601137753;
        bh=DL8DqMiUWHfQiLQev/BiGvw05OD/78RYlysbkhUMlWo=;
        h=From:To:Cc:Subject:Date:From;
        b=HsaP3BheEbk1dWS1pohOrBSuF6dqFsEBpoeIZD6bmt9lDBLBs2jjjiCXmT/dPtI/f
         vLXzxsgGI7pkgLmWtezfN6lemhVEcvS3eERkK8HXQxZG6dQkk/JiaybDf6wOuJw+Fr
         Efv5tP/O0Au5Trwp6aLXOfVETTT1xmTaDBGTWNC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.12
Date:   Sat, 26 Sep 2020 18:29:16 +0200
Message-Id: <160113775678120@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.12 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 drivers/net/dsa/microchip/ksz8795.c                          |    2 
 drivers/net/dsa/rtl8366.c                                    |   20 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                    |   40 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                    |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c            |   31 +++--
 drivers/net/ethernet/cadence/macb_main.c                     |    3 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c            |    9 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c               |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c            |   16 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c               |   24 ++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c                 |   18 ---
 drivers/net/ethernet/ibm/ibmvnic.c                           |   21 +++
 drivers/net/ethernet/lantiq_xrx200.c                         |   21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c          |   14 --
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c            |   65 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c              |   12 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              |   39 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c            |   17 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   |   52 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c            |    8 -
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c         |    4 
 drivers/net/ethernet/ti/cpsw_new.c                           |   53 ++++++++
 drivers/net/geneve.c                                         |   37 ++++--
 drivers/net/hyperv/netvsc_drv.c                              |   16 +-
 drivers/net/ipa/ipa_table.c                                  |    4 
 drivers/net/phy/phy.c                                        |    2 
 drivers/net/phy/phy_device.c                                 |   11 +
 drivers/net/wan/hdlc_ppp.c                                   |   16 +-
 drivers/net/wireguard/noise.c                                |    5 
 drivers/net/wireguard/peerlookup.c                           |   11 +
 include/linux/skbuff.h                                       |    7 -
 include/net/flow.h                                           |    1 
 include/net/sctp/structs.h                                   |    8 -
 net/bridge/br_vlan.c                                         |   27 ++--
 net/core/dev.c                                               |    2 
 net/core/filter.c                                            |    1 
 net/core/net_namespace.c                                     |   22 +--
 net/dcb/dcbnl.c                                              |    8 +
 net/dsa/slave.c                                              |   18 ++-
 net/ipv4/fib_frontend.c                                      |    1 
 net/ipv4/ip_output.c                                         |    3 
 net/ipv4/route.c                                             |   14 +-
 net/ipv6/Kconfig                                             |    1 
 net/ipv6/ip6_fib.c                                           |   13 +-
 net/qrtr/qrtr.c                                              |   21 +--
 net/sched/act_ife.c                                          |   44 +++++--
 net/sched/cls_flower.c                                       |    1 
 net/sched/sch_generic.c                                      |   48 +++++---
 net/sched/sch_taprio.c                                       |   28 ++--
 net/sctp/socket.c                                            |    9 -
 net/tipc/group.c                                             |   14 +-
 net/tipc/msg.c                                               |    3 
 net/tipc/socket.c                                            |    5 
 58 files changed, 572 insertions(+), 325 deletions(-)

Cong Wang (1):
      act_ife: load meta modules before tcf_idr_check_alloc()

Dan Carpenter (1):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()

David Ahern (2):
      ipv4: Initialize flowi4_multipath_hash in data path
      ipv4: Update exception handling for multipath routes via same device

Dexuan Cui (1):
      hv_netvsc: Fix hibernation for mlx5 VF driver

Edwin Peer (1):
      bnxt_en: return proper error codes in bnxt_show_temp

Eric Dumazet (3):
      ipv6: avoid lockdep issue in fib6_del()
      net: qrtr: check skb_put_padto() return value
      net: add __must_check to skb_put_padto()

Florian Fainelli (2):
      net: phy: Avoid NPD upon phy_detach() when driver is unbound
      net: phy: Do not warn in phy_stop() on PHY_DOWN

Ganji Aravind (1):
      cxgb4: Fix offset when clearing filter byte counters

Greg Kroah-Hartman (1):
      Linux 5.8.12

Grygorii Strashko (1):
      net: ethernet: ti: cpsw_new: fix suspend/resume

Hauke Mehrtens (4):
      net: lantiq: Wake TX queue again
      net: lantiq: use netif_tx_napi_add() for TX NAPI
      net: lantiq: Use napi_complete_done()
      net: lantiq: Disable IRQs only if NAPI gets scheduled

Henry Ptasinski (1):
      net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant

Ido Schimmel (1):
      net: Fix bridge enslavement failure

Jakub Kicinski (2):
      ibmvnic: add missing parenthesis in do_reset()
      nfp: use correct define to return NONE fec

Jason A. Donenfeld (2):
      wireguard: noise: take lock when removing handshake entry from table
      wireguard: peerlookup: take lock before checking hash in replace operation

Jianbo Liu (1):
      net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready

Linus Walleij (1):
      net: dsa: rtl8366: Properly clear member config

Luo bin (2):
      hinic: bump up the timeout of SET_FUNC_STATE cmd
      hinic: fix rewaking txq after netif_tx_disable

Maor Dickman (2):
      net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported
      net/mlx5e: Fix endianness when calculating pedit mask first bit

Maor Gottlieb (1):
      net/mlx5: Fix FTE cleanup

Mark Gray (1):
      geneve: add transport ports in route lookup for geneve

Matthias Schiffer (1):
      net: dsa: microchip: ksz8795: really set the correct number of ports

Maxim Mikityanskiy (2):
      net/mlx5e: Use RCU to protect rq->xdp_prog
      net/mlx5e: Use synchronize_rcu to sync with NAPI

Michael Chan (1):
      bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Mingming Cao (1):
      ibmvnic fix NULL tx_pools and rx_tools issue at do_reset

Necip Fazil Yildiran (1):
      net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Parshuram Thombare (1):
      net: macb: fix for pause frame receive enable bit

Peilin Ye (1):
      tipc: Fix memory leak in tipc_group_create_member()

Petr Machata (1):
      net: DCB: Validate DCB_ATTR_DCB_BUFFER argument

Raju Rangoju (1):
      cxgb4: fix memory leak during module unload

Taehee Yoo (1):
      Revert "netns: don't disable BHs when locking "nsid_lock""

Tariq Toukan (1):
      net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported

Tetsuo Handa (1):
      tipc: fix shutdown() of connection oriented socket

Vadym Kochan (1):
      net: ipa: fix u32_replace_bits by u32p_xxx version

Vasundhara Volam (3):
      bnxt_en: Avoid sending firmware messages when AER error is detected.
      bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
      bnxt_en: Use memcpy to copy VPD field info.

Vinicius Costa Gomes (1):
      taprio: Fix allowing too small intervals

Vladimir Oltean (2):
      net: bridge: br_vlan_get_pvid_rcu() should dereference the VLAN group under RCU
      net: dsa: link interfaces with the DSA master to get rid of lockdep warnings

Wei Wang (1):
      ip: fix tos reflection in ack and reset packets

Xin Long (2):
      net: sched: initialize with 0 before setting erspan md->u
      tipc: use skb_unshare() instead in tipc_buf_append()

Yoshihiro Shimoda (1):
      net: phy: call phy_disable_interrupts() in phy_attach_direct() instead

Yunsheng Lin (1):
      net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc

