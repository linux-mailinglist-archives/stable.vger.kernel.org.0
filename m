Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075772788DD
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgIYMsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbgIYMsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3869921741;
        Fri, 25 Sep 2020 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038114;
        bh=U1r8xnAYWQTV7EhmyB7CMzZNZohDdtKaAoQTTNme8Ug=;
        h=From:To:Cc:Subject:Date:From;
        b=hmg02/P5dygaOz3QB2UWWJh7T1iW6JBVuu9++FzksxZ9JXBMikBjLjhNwAUC9++0k
         3VKs718IT72i/o4GWZ8MI3fUCvE4Tejf0hFYhbStV0JfWs2D9SwA6+fofEgagl3JOU
         ruUZZ2lE5TJL7kIu0POmcZHVLR3DwJl0XKw9i0qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 00/56] 5.8.12-rc1 review
Date:   Fri, 25 Sep 2020 14:47:50 +0200
Message-Id: <20200925124727.878494124@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.12-rc1
X-KernelTest-Deadline: 2020-09-27T12:47+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.12 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.12-rc1

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix endianness when calculating pedit mask first bit

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use synchronize_rcu to sync with NAPI

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use RCU to protect rq->xdp_prog

Taehee Yoo <ap420073@gmail.com>
    Revert "netns: don't disable BHs when locking "nsid_lock""

Parshuram Thombare <pthombar@cadence.com>
    net: macb: fix for pause frame receive enable bit

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: microchip: ksz8795: really set the correct number of ports

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: link interfaces with the DSA master to get rid of lockdep warnings

Dexuan Cui <decui@microsoft.com>
    hv_netvsc: Fix hibernation for mlx5 VF driver

Luo bin <luobin9@huawei.com>
    hinic: fix rewaking txq after netif_tx_disable

Jianbo Liu <jianbol@mellanox.com>
    net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready

Vadym Kochan <vadym.kochan@plvision.eu>
    net: ipa: fix u32_replace_bits by u32p_xxx version

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: peerlookup: take lock before checking hash in replace operation

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: take lock when removing handshake entry from table

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw_new: fix suspend/resume

Eric Dumazet <edumazet@google.com>
    net: add __must_check to skb_put_padto()

Eric Dumazet <edumazet@google.com>
    net: qrtr: check skb_put_padto() return value

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Do not warn in phy_stop() on PHY_DOWN

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid NPD upon phy_detach() when driver is unbound

Hauke Mehrtens <hauke@hauke-m.de>
    net: lantiq: Disable IRQs only if NAPI gets scheduled

Hauke Mehrtens <hauke@hauke-m.de>
    net: lantiq: Use napi_complete_done()

Hauke Mehrtens <hauke@hauke-m.de>
    net: lantiq: use netif_tx_napi_add() for TX NAPI

Hauke Mehrtens <hauke@hauke-m.de>
    net: lantiq: Wake TX queue again

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: return proper error codes in bnxt_show_temp

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Use memcpy to copy VPD field info.

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported

Maor Dickman <maord@mellanox.com>
    net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported

Xin Long <lucien.xin@gmail.com>
    tipc: use skb_unshare() instead in tipc_buf_append()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tipc: fix shutdown() of connection oriented socket

Peilin Ye <yepeilin.cs@gmail.com>
    tipc: Fix memory leak in tipc_group_create_member()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Fix allowing too small intervals

Jakub Kicinski <kuba@kernel.org>
    nfp: use correct define to return NONE fec

Henry Ptasinski <hptasinski@google.com>
    net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant

Yunsheng Lin <linyunsheng@huawei.com>
    net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc

Xin Long <lucien.xin@gmail.com>
    net: sched: initialize with 0 before setting erspan md->u

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: phy: call phy_disable_interrupts() in phy_attach_direct() instead

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix FTE cleanup

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Ido Schimmel <idosch@nvidia.com>
    net: Fix bridge enslavement failure

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Properly clear member config

Petr Machata <petrm@nvidia.com>
    net: DCB: Validate DCB_ATTR_DCB_BUFFER argument

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: br_vlan_get_pvid_rcu() should dereference the VLAN group under RCU

Eric Dumazet <edumazet@google.com>
    ipv6: avoid lockdep issue in fib6_del()

David Ahern <dsahern@kernel.org>
    ipv4: Update exception handling for multipath routes via same device

David Ahern <dsahern@gmail.com>
    ipv4: Initialize flowi4_multipath_hash in data path

Wei Wang <weiwan@google.com>
    ip: fix tos reflection in ack and reset packets

Luo bin <luobin9@huawei.com>
    hinic: bump up the timeout of SET_FUNC_STATE cmd

Dan Carpenter <dan.carpenter@oracle.com>
    hdlc_ppp: add range checks in ppp_cp_parse_cr()

Mark Gray <mark.d.gray@redhat.com>
    geneve: add transport ports in route lookup for geneve

Ganji Aravind <ganji.aravind@chelsio.com>
    cxgb4: Fix offset when clearing filter byte counters

Raju Rangoju <rajur@chelsio.com>
    cxgb4: fix memory leak during module unload

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Avoid sending firmware messages when AER error is detected.

Cong Wang <xiyou.wangcong@gmail.com>
    act_ife: load meta modules before tcf_idr_check_alloc()

Jakub Kicinski <kuba@kernel.org>
    ibmvnic: add missing parenthesis in do_reset()

Mingming Cao <mmc@linux.vnet.ibm.com>
    ibmvnic fix NULL tx_pools and rx_tools issue at do_reset


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/net/dsa/microchip/ksz8795.c                |  2 +-
 drivers/net/dsa/rtl8366.c                          | 20 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 40 ++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  4 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 31 +++++++----
 drivers/net/ethernet/cadence/macb_main.c           |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  9 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c     |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  | 16 ++++--
 drivers/net/ethernet/huawei/hinic/hinic_main.c     | 24 ++++++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       | 18 +-----
 drivers/net/ethernet/ibm/ibmvnic.c                 | 21 ++++++-
 drivers/net/ethernet/lantiq_xrx200.c               | 21 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    | 14 +----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  3 +-
 .../mellanox/mlx5/core/en_accel/tls_stats.c        | 12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 65 ++++++++++------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 12 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 39 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  | 17 ++++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 52 +++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  8 +--
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  4 +-
 drivers/net/ethernet/ti/cpsw_new.c                 | 53 ++++++++++++++++++
 drivers/net/geneve.c                               | 37 ++++++++----
 drivers/net/hyperv/netvsc_drv.c                    | 16 ++++--
 drivers/net/ipa/ipa_table.c                        |  4 +-
 drivers/net/phy/phy.c                              |  2 +-
 drivers/net/phy/phy_device.c                       | 11 ++--
 drivers/net/wan/hdlc_ppp.c                         | 16 ++++--
 drivers/net/wireguard/noise.c                      |  5 +-
 drivers/net/wireguard/peerlookup.c                 | 11 +++-
 include/linux/skbuff.h                             |  7 ++-
 include/net/flow.h                                 |  1 +
 include/net/sctp/structs.h                         |  8 ++-
 net/bridge/br_vlan.c                               | 27 +++++----
 net/core/dev.c                                     |  2 +-
 net/core/filter.c                                  |  1 +
 net/core/net_namespace.c                           | 22 ++++----
 net/dcb/dcbnl.c                                    |  8 +++
 net/dsa/slave.c                                    | 18 +++++-
 net/ipv4/fib_frontend.c                            |  1 +
 net/ipv4/ip_output.c                               |  3 +-
 net/ipv4/route.c                                   | 14 +++--
 net/ipv6/Kconfig                                   |  1 +
 net/ipv6/ip6_fib.c                                 | 13 +++--
 net/qrtr/qrtr.c                                    | 21 +++----
 net/sched/act_ife.c                                | 44 +++++++++++----
 net/sched/cls_flower.c                             |  1 +
 net/sched/sch_generic.c                            | 48 +++++++++++-----
 net/sched/sch_taprio.c                             | 28 ++++++----
 net/sctp/socket.c                                  |  9 +--
 net/tipc/group.c                                   | 14 +++--
 net/tipc/msg.c                                     |  3 +-
 net/tipc/socket.c                                  |  5 +-
 58 files changed, 573 insertions(+), 326 deletions(-)


