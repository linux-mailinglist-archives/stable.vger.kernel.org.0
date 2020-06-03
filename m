Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5661ECF35
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgFCMCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 08:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCMCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 08:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83DF320678;
        Wed,  3 Jun 2020 12:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591185721;
        bh=uvpf2rjYWouX2oyg6JUv4xFYLWUsYLbvlK4ad9StXrw=;
        h=From:To:Cc:Subject:Date:From;
        b=1jjmj5IEylPS/qVE6nObXSw3PQKmzrpRXgIDSpcMC28JiY9ygA7y0EG2BbhHkTsc4
         ZaGW/JNoqD9bAvrVtSDIEq599L5HWJE9D6aG91Kanr8R0nFbEFZM/SgP4O1O/2GvI3
         65LVMr0yLca2pj0549H98uWoTwMJ5FkiY6+Z2Kig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.226
Date:   Wed,  3 Jun 2020 14:01:56 +0200
Message-Id: <1591185716246126@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.226 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/parisc/mm/init.c                               |    2 
 arch/x86/include/asm/dma.h                          |    2 
 drivers/gpu/drm/drm_fb_helper.c                     |    2 
 drivers/gpu/drm/msm/msm_gem.c                       |   20 ++---
 drivers/infiniband/hw/qib/qib_sysfs.c               |    9 +-
 drivers/input/evdev.c                               |   19 +----
 drivers/input/joystick/xpad.c                       |   12 +++
 drivers/input/serio/i8042-x86ia64io.h               |    7 +
 drivers/input/touchscreen/usbtouchscreen.c          |    1 
 drivers/iommu/iommu.c                               |    2 
 drivers/net/bonding/bond_sysfs_slave.c              |    4 -
 drivers/net/ethernet/mellanox/mlx4/fw.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       |   15 ++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |    4 -
 drivers/net/ethernet/sun/cassini.c                  |    3 
 drivers/s390/scsi/zfcp_fsf.c                        |   10 ++
 drivers/tty/serial/sc16is7xx.c                      |    2 
 drivers/usb/gadget/legacy/inode.c                   |    3 
 drivers/usb/renesas_usbhs/mod_gadget.c              |    2 
 fs/binfmt_elf.c                                     |    2 
 fs/cachefiles/rdwr.c                                |    2 
 fs/cifs/file.c                                      |    2 
 include/asm-generic/asm-prototypes.h                |    6 +
 include/asm-generic/topology.h                      |    2 
 include/linux/mlx5/driver.h                         |    1 
 include/linux/mm.h                                  |    1 
 include/linux/netfilter/nf_conntrack_pptp.h         |    2 
 include/linux/printk.h                              |   12 +--
 include/rdma/ib_addr.h                              |    6 +
 include/uapi/linux/l2tp.h                           |    7 -
 kernel/irq/migration.c                              |   26 +++++-
 mm/vmalloc.c                                        |    2 
 net/ax25/af_ax25.c                                  |    6 +
 net/bridge/netfilter/nft_reject_bridge.c            |    6 +
 net/core/rtnetlink.c                                |    2 
 net/ipv4/ip_vti.c                                   |   75 ++++++++++----------
 net/ipv4/netfilter/nf_nat_pptp.c                    |    7 -
 net/ipv4/route.c                                    |   14 +--
 net/mac80211/sta_info.c                             |    1 
 net/netfilter/ipset/ip_set_list_set.c               |    2 
 net/netfilter/nf_conntrack_pptp.c                   |   62 +++++++++-------
 net/sctp/sm_statefuns.c                             |    9 +-
 net/xfrm/xfrm_input.c                               |    2 
 net/xfrm/xfrm_output.c                              |    3 
 net/xfrm/xfrm_policy.c                              |    7 -
 security/commoncap.c                                |    1 
 sound/core/hwdep.c                                  |    4 -
 sound/usb/mixer.c                                   |    8 ++
 49 files changed, 241 insertions(+), 162 deletions(-)

Aaron Conole (1):
      printk: help pr_debug and pr_devel to optimize out arguments

Alexander Dahl (1):
      x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Arnd Bergmann (1):
      include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Ben Hutchings (1):
      drm/msm: Fix possible null dereference on failure of get_pages()

Benjamin Block (1):
      scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Brendan Shanks (1):
      Input: evdev - call input_flush_device() on release(), not flush()

Changming Liu (1):
      ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Chris Chiu (1):
      ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Dmitry V. Levin (1):
      uapi: fix linux/if_pppol2tp.h userspace compilation errors

Eric Dumazet (1):
      ax25: fix setsockopt(SO_BINDTODEVICE)

Eric W. Biederman (1):
      exec: Always set cap_ambient in cap_bprm_set_creds

Greg Kroah-Hartman (1):
      Linux 4.4.226

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

Liviu Dudau (1):
      mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Masahiro Yamada (1):
      usb: gadget: legacy: fix redundant initialization warnings

Matt Roper (1):
      drm/fb-helper: Use proper plane mask for fb cleanup

Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Michal Marek (1):
      asm-prototypes: Clear any CPP defines before declaring the functions

Moshe Shemesh (1):
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

Roopa Prabhu (1):
      net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags

Steve French (1):
      cifs: Fix null pointer check in cifs_read

Sudip Mukherjee (1):
      mac80211: fix memory leak

Thomas Gleixner (1):
      genirq/generic_pending: Do not lose pending affinity update

Xin Long (4):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error
      ip_vti: receive ipip packet by calling ip_tunnel_rcv

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: gadget: fix spin_lock_init() for &uep->lock

Yuqi Jin (1):
      net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Łukasz Patron (1):
      Input: xpad - add custom init packet for Xbox One S controllers

