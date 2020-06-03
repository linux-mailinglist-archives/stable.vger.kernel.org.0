Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D417E1ECF3D
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgFCMCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 08:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFCMCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 08:02:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C65120738;
        Wed,  3 Jun 2020 12:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591185729;
        bh=Uf0Nvlau47VNr00WkOi6+S7+wYxGyxIXwauq8db98Iw=;
        h=From:To:Cc:Subject:Date:From;
        b=yRyRMPYZgsK6T8EPNDuPfXfm65dy0GvQXBPO8QNbhdqRRB/B4GFOPcdOkKVprfUXc
         OfsG9rl6sCCKyA7tp6mD51ZjtFzmtRcBUsolhXj1dSxk96GDoGSOY50DVcARDhMJrJ
         gV7noxgo9wBI+ZdiL23tE1g2WKkeg62vSpWQQRIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.226
Date:   Wed,  3 Jun 2020 14:02:03 +0200
Message-Id: <15911857234199@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.226 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/imx6q-b450v3.dts                  |    7 -
 arch/arm/boot/dts/imx6q-b650v3.dts                  |    7 -
 arch/arm/boot/dts/imx6q-b850v3.dts                  |   11 --
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                 |   77 ++++++++++++++++++++
 arch/parisc/mm/init.c                               |    2 
 arch/x86/include/asm/dma.h                          |    2 
 drivers/gpio/gpio-tegra.c                           |    1 
 drivers/infiniband/hw/qib/qib_sysfs.c               |    9 +-
 drivers/input/evdev.c                               |   19 +---
 drivers/input/joystick/xpad.c                       |   12 +++
 drivers/input/rmi4/rmi_driver.c                     |    3 
 drivers/input/serio/i8042-x86ia64io.h               |    7 +
 drivers/input/touchscreen/usbtouchscreen.c          |    1 
 drivers/iommu/iommu.c                               |    2 
 drivers/net/bonding/bond_sysfs_slave.c              |    4 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c  |    3 
 drivers/net/ethernet/mellanox/mlx4/fw.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       |   15 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     |    6 +
 drivers/net/ethernet/microchip/encx24j600.c         |    5 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |    4 -
 drivers/net/ethernet/sun/cassini.c                  |    3 
 drivers/s390/scsi/zfcp_fsf.c                        |   10 ++
 drivers/tty/serial/sc16is7xx.c                      |    2 
 drivers/usb/gadget/legacy/inode.c                   |    3 
 fs/binfmt_elf.c                                     |    2 
 fs/cachefiles/rdwr.c                                |    2 
 fs/cifs/file.c                                      |    2 
 fs/gfs2/quota.c                                     |    3 
 fs/gfs2/quota.h                                     |    3 
 include/asm-generic/topology.h                      |    2 
 include/linux/mlx5/driver.h                         |    1 
 include/linux/mm.h                                  |   15 +++
 include/linux/netfilter/nf_conntrack_pptp.h         |    2 
 include/net/act_api.h                               |    3 
 include/rdma/ib_addr.h                              |    6 +
 include/uapi/linux/l2tp.h                           |    7 -
 kernel/irq/migration.c                              |   26 ++++--
 mm/vmalloc.c                                        |    2 
 net/ax25/af_ax25.c                                  |    6 +
 net/bridge/netfilter/nft_reject_bridge.c            |    6 +
 net/ceph/osd_client.c                               |    4 -
 net/core/rtnetlink.c                                |    2 
 net/ipv4/ip_vti.c                                   |   75 ++++++++++---------
 net/ipv4/ipip.c                                     |    2 
 net/ipv4/netfilter/nf_nat_pptp.c                    |    7 -
 net/ipv4/route.c                                    |   14 +--
 net/mac80211/mesh_hwmp.c                            |    7 +
 net/netfilter/ipset/ip_set_list_set.c               |    2 
 net/netfilter/nf_conntrack_pptp.c                   |   62 +++++++++-------
 net/qrtr/qrtr.c                                     |    2 
 net/sctp/sm_statefuns.c                             |    9 +-
 net/xfrm/xfrm_input.c                               |    2 
 net/xfrm/xfrm_output.c                              |    3 
 net/xfrm/xfrm_policy.c                              |    7 -
 security/commoncap.c                                |    1 
 sound/core/hwdep.c                                  |    4 -
 sound/usb/mixer.c                                   |    8 ++
 59 files changed, 337 insertions(+), 181 deletions(-)

Alexander Dahl (1):
      x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Arnd Bergmann (1):
      include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Benjamin Block (1):
      scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Bob Peterson (1):
      gfs2: move privileged user check to gfs2_quota_lock_check

Brendan Shanks (1):
      Input: evdev - call input_flush_device() on release(), not flush()

Changming Liu (1):
      ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Chris Chiu (1):
      ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Chuhong Yuan (1):
      net: microchip: encx24j600: add missed kthread_stop

Dmitry V. Levin (1):
      uapi: fix linux/if_pppol2tp.h userspace compilation errors

Eric Dumazet (1):
      ax25: fix setsockopt(SO_BINDTODEVICE)

Eric W. Biederman (1):
      exec: Always set cap_ambient in cap_bprm_set_creds

Greg Kroah-Hartman (1):
      Linux 4.9.226

Guoqing Jiang (1):
      sc16is7xx: move label 'err_spi' to correct section

Helge Deller (1):
      parisc: Fix kernel panic in mem_init()

James Hilliard (1):
      Input: usbtouchscreen - add support for BonXeon TP

Jere Leppänen (1):
      sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Jeremy Sowden (1):
      vti4: eliminated some duplicate code.

Jerry Lee (1):
      libceph: ignore pool overlay and cache logic on redirects

Kaike Wan (1):
      IB/qib: Call kobject_put() when kobject_init_and_add() fails

Kalderon, Michal (1):
      IB/cma: Fix reference count leak when no ipv4 addresses are set

Kevin Locke (1):
      Input: i8042 - add ThinkPad S230u to i8042 reset list

Konstantin Khlebnikov (1):
      mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Lei Xue (1):
      cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Liviu Dudau (1):
      mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Manivannan Sadhasivam (1):
      net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Martyn Welch (1):
      ARM: dts: imx: Correct B850v3 clock assignment

Masahiro Yamada (1):
      usb: gadget: legacy: fix redundant initialization warnings

Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Moshe Shemesh (2):
      net/mlx5e: Update netdev txq on completions during closure
      net/mlx5: Add command entry handling completion

Pablo Neira Ayuso (2):
      netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
      netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Phil Sutter (1):
      netfilter: ipset: Fix subcounter update skip

Qiushi Wu (5):
      net: sun: fix missing release regions in cas_init_one().
      net/mlx4_core: fix a memory leak bug.
      iommu: Fix reference count leak in iommu_group_alloc.
      qlcnic: fix missing release in qlcnic_83xx_interrupt_test.
      bonding: Fix reference count leak in bond_sysfs_slave_add.

Robert Beckett (1):
      ARM: dts/imx6q-bx50v3: Set display interface clock parents

Roman Mashak (1):
      net sched: fix reporting the first-time use timestamp

Roopa Prabhu (1):
      net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags

Salil Mehta (1):
      net: hns: Fixes the missing put_device in positive leg for roce reset

Sebastian Reichel (1):
      ARM: dts: imx6q-bx50v3: Add internal switch

Stephen Warren (1):
      gpio: tegra: mask GPIO IRQs during IRQ shutdown

Steve French (1):
      cifs: Fix null pointer check in cifs_read

Thomas Gleixner (1):
      genirq/generic_pending: Do not lose pending affinity update

Vadim Fedorenko (1):
      net: ipip: fix wrong address family in init error path

Wei Yongjun (1):
      Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Xin Long (4):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error
      ip_vti: receive ipip packet by calling ip_tunnel_rcv

Yuqi Jin (1):
      net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Łukasz Patron (1):
      Input: xpad - add custom init packet for Xbox One S controllers

