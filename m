Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3AC2787F5
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgIYMvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgIYMvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C1A2072E;
        Fri, 25 Sep 2020 12:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038283;
        bh=RW3YEwhVHlPegURL2Ra5IJ8i2+hPljE2BehwjJQMZo4=;
        h=From:To:Cc:Subject:Date:From;
        b=yrPbMFxAktYi3/Hj1ja4SShZHSl7k/0XPiobEU4hf4311NNmWDvA4VTjshLGpOvsb
         l0GRjkof5iO1Zios6UiDy8g0Tcz9ItHu8OV5X6pyf4bqP10FFQXXDXbiTgOrBO/58C
         8eQxbtDHurGGd18tlZ2TPU2NaitONo4NR23RiK3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/43] 5.4.68-rc1 review
Date:   Fri, 25 Sep 2020 14:48:12 +0200
Message-Id: <20200925124723.575329814@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.68-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.68-rc1
X-KernelTest-Deadline: 2020-09-27T12:47+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.68 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.68-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.68-rc1

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE

Xunlei Pang <xlpang@linux.alibaba.com>
    mm: memcg: fix memcg reclaim soft lockup

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

Ralph Campbell <rcampbell@nvidia.com>
    mm/thp: fix __split_huge_pmd_locked() for migration PMD

Muchun Song <songmuchun@bytedance.com>
    kprobes: fix kill kprobe which has been marked as gone

Jakub Kicinski <kuba@kernel.org>
    ibmvnic: add missing parenthesis in do_reset()

Mingming Cao <mmc@linux.vnet.ibm.com>
    ibmvnic fix NULL tx_pools and rx_tools issue at do_reset

Mark Salyzyn <salyzyn@android.com>
    af_key: pfkey_dump needs parameter validation


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/iommu/Kconfig                              |  2 +-
 drivers/iommu/amd_iommu.c                          | 17 +++++--
 drivers/iommu/amd_iommu_init.c                     | 21 ++++++++-
 drivers/net/dsa/rtl8366.c                          | 20 ++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 32 ++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  4 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 31 ++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  9 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c     |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 21 +++++++--
 drivers/net/ethernet/lantiq_xrx200.c               | 21 +++++----
 .../mellanox/mlx5/core/en_accel/tls_stats.c        | 12 +++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 52 ++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  8 ++--
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  4 +-
 drivers/net/geneve.c                               | 37 ++++++++++-----
 drivers/net/phy/phy.c                              |  2 +-
 drivers/net/phy/phy_device.c                       |  3 +-
 drivers/net/wan/hdlc_ppp.c                         | 16 ++++---
 include/linux/skbuff.h                             |  7 +--
 include/net/flow.h                                 |  1 +
 include/net/sctp/structs.h                         |  8 ++--
 kernel/kprobes.c                                   |  9 +++-
 mm/huge_memory.c                                   | 40 ++++++++++-------
 mm/vmscan.c                                        |  8 ++++
 net/bridge/br_vlan.c                               | 27 ++++++-----
 net/core/dev.c                                     |  2 +-
 net/core/filter.c                                  |  1 +
 net/dcb/dcbnl.c                                    |  8 ++++
 net/ipv4/fib_frontend.c                            |  1 +
 net/ipv4/ip_output.c                               |  3 +-
 net/ipv4/route.c                                   | 14 +++---
 net/ipv6/Kconfig                                   |  1 +
 net/ipv6/ip6_fib.c                                 | 13 ++++--
 net/key/af_key.c                                   |  7 +++
 net/qrtr/qrtr.c                                    | 20 +++++----
 net/sched/act_ife.c                                | 44 +++++++++++++-----
 net/sched/sch_generic.c                            | 49 +++++++++++++-------
 net/sched/sch_taprio.c                             | 28 +++++++-----
 net/sctp/socket.c                                  |  9 ++--
 net/tipc/group.c                                   | 14 ++++--
 net/tipc/msg.c                                     |  3 +-
 net/tipc/socket.c                                  |  5 +--
 44 files changed, 429 insertions(+), 211 deletions(-)


