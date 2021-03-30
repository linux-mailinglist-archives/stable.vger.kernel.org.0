Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9C34E93D
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhC3NhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhC3Ngs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42C5619D0;
        Tue, 30 Mar 2021 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617111408;
        bh=AhnznUC877+54yrViVNKugzilUI11KJ/a12fEi5tv2w=;
        h=From:To:Cc:Subject:Date:From;
        b=IbH3jQ98mOdqxB3w9UcLwqVrYZO5zBXk90OolYMYguN58wtZr2Y++7zniLWjU41/Q
         /7f1WygO5FPPlcUCOgTbdF4ogDGIQedGVWcWhsb9qPNtXRHJoY14tVEPL4X4X5rPp0
         TN0XTOK1mAXxvfTXdaCBecRGkUmMgAGFeYwJuCF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.264
Date:   Tue, 30 Mar 2021 15:36:33 +0200
Message-Id: <16171113938164@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.264 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi       |    1 
 arch/arm64/include/asm/futex.h                       |   59 +-
 arch/ia64/include/asm/syscall.h                      |    2 
 arch/ia64/kernel/ptrace.c                            |   24 -
 arch/powerpc/include/asm/dcr-native.h                |    8 
 arch/x86/include/asm/tlbflush.h                      |   11 
 drivers/acpi/internal.h                              |    6 
 drivers/acpi/scan.c                                  |   88 ++--
 drivers/atm/eni.c                                    |    3 
 drivers/atm/idt77105.c                               |    4 
 drivers/atm/lanai.c                                  |    5 
 drivers/atm/uPD98402.c                               |    2 
 drivers/block/xen-blkback/blkback.c                  |    2 
 drivers/bus/omap_l3_noc.c                            |    4 
 drivers/infiniband/hw/cxgb4/cm.c                     |    4 
 drivers/net/can/c_can/c_can.c                        |   24 -
 drivers/net/can/c_can/c_can_pci.c                    |    3 
 drivers/net/can/c_can/c_can_platform.c               |    6 
 drivers/net/can/dev.c                                |    1 
 drivers/net/can/m_can/m_can.c                        |    3 
 drivers/net/dsa/bcm_sf2.c                            |    6 
 drivers/net/ethernet/freescale/fec_ptp.c             |    7 
 drivers/net/ethernet/intel/e1000e/82571.c            |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c           |    6 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |    6 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c |    3 
 drivers/net/ethernet/sun/niu.c                       |    2 
 drivers/net/ethernet/tehuti/tehuti.c                 |    1 
 drivers/net/usb/cdc-phonet.c                         |    2 
 drivers/net/wan/fsl_ucc_hdlc.c                       |    8 
 drivers/usb/gadget/function/f_hid.c                  |    6 
 drivers/usb/gadget/function/f_printer.c              |    6 
 fs/nfs/Kconfig                                       |    2 
 fs/nfs/nfs3xdr.c                                     |    3 
 fs/nfs/nfs4proc.c                                    |    3 
 fs/squashfs/export.c                                 |    8 
 fs/squashfs/id.c                                     |    6 
 fs/squashfs/squashfs_fs.h                            |    1 
 fs/squashfs/xattr_id.c                               |    6 
 include/acpi/acpi_bus.h                              |    1 
 include/linux/idr.h                                  |    5 
 include/linux/if_macvlan.h                           |    3 
 include/linux/u64_stats_sync.h                       |    7 
 include/net/red.h                                    |   10 
 include/net/rtnetlink.h                              |    2 
 kernel/futex.c                                       |  393 +++++++++++++------
 kernel/locking/rtmutex.c                             |  106 +++--
 kernel/locking/rtmutex_common.h                      |    5 
 net/core/dev.c                                       |    2 
 net/mac80211/cfg.c                                   |    4 
 net/mac80211/ibss.c                                  |    2 
 net/qrtr/qrtr.c                                      |    5 
 net/sched/sch_choke.c                                |    7 
 net/sched/sch_gred.c                                 |    2 
 net/sched/sch_red.c                                  |    7 
 net/sched/sch_sfq.c                                  |    2 
 tools/perf/util/auxtrace.c                           |    4 
 58 files changed, 607 insertions(+), 306 deletions(-)

Adrian Hunter (1):
      perf auxtrace: Fix auxtrace queue conflict

Andy Shevchenko (1):
      ACPI: scan: Use unique number for instance_no

Borislav Petkov (1):
      x86/tlb: Flush global mappings when KAISER is disabled

Denis Efremov (1):
      sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Dinghao Liu (2):
      ixgbe: Fix memleak in ixgbe_configure_clsu32
      e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Eric Dumazet (3):
      macvlan: macvlan_count_rx() needs to be aware of preemption
      net: sched: validate stab values
      net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Florian Fainelli (1):
      net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port

Frank Sorenson (1):
      NFS: Correct size calculation for create reply length

Greg Kroah-Hartman (1):
      Linux 4.9.264

Grygorii Strashko (1):
      bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Heiko Thiery (1):
      net: fec: ptp: avoid register access when ipg clock is disabled

Horia Geantă (1):
      arm64: dts: ls1043a: mark crypto engine dma coherent

J. Bruce Fields (1):
      nfs: we don't support removing system.nfs4_acl

Jan Beulich (1):
      xen-blkback: don't leak persistent grants from xen_blkbk_map()

Jia-Ju Bai (2):
      net: tehuti: fix error return code in bdx_probe()
      net: wan: fix error return code of uhdlc_init()

Johan Hovold (1):
      net: cdc-phonet: fix data-interface release on probe failure

Johannes Berg (1):
      mac80211: fix rate mask reset

Lv Yunlong (1):
      net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Markus Theil (1):
      mac80211: fix double free in ibss_leave

Martin Willi (1):
      can: dev: Move device back to init netns on owning netns delete

Mateusz Nosek (1):
      futex: Fix incorrect should_fail_futex() handling

Matthew Wilcox (1):
      idr: add ida_is_empty

Michael Ellerman (1):
      powerpc/4xx: Fix build errors from mfdcr()

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Peter Zijlstra (7):
      u64_stats,lockdep: Fix u64_stats_init() vs lockdep
      futex: Use smp_store_release() in mark_wake_futex()
      futex,rt_mutex: Introduce rt_mutex_init_waiter()
      futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
      futex: Drop hb->lock before enqueueing on the rtmutex
      futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
      futex: Fix (possible) missed wakeup

Phillip Lougher (1):
      squashfs: fix xattr id and id lookup sanity checks

Potnuri Bharat Teja (1):
      RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Rafael J. Wysocki (1):
      ACPI: scan: Rearrange memory allocation in acpi_device_add()

Sean Nyekjaer (1):
      squashfs: fix inode lookup sanity checks

Sergei Trofimovich (2):
      ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls
      ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Thomas Gleixner (2):
      futex: Avoid freeing an active timer
      futex: Handle early deadlock return correctly

Timo Rothenpieler (1):
      nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default

Tong Zhang (6):
      atm: eni: dont release is never initialized
      atm: lanai: dont run lanai_dev_close if not open
      atm: uPD98402: fix incorrect allocation
      atm: idt77252: fix null-ptr-dereference
      can: c_can_pci: c_can_pci_remove(): fix use-after-free
      can: c_can: move runtime PM enable/disable to c_can_platform

Torin Cooper-Bennun (1):
      can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning

Vitaly Lifshits (1):
      e1000e: add rtnl_lock() to e1000_reset_task

Will Deacon (2):
      locking/futex: Allow low-level atomic operations to return -EAGAIN
      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Yang Tao (1):
      futex: Prevent robust futex exit race

