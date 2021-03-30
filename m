Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB134E943
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhC3NhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhC3NhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1D8619D0;
        Tue, 30 Mar 2021 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617111420;
        bh=L3d0XI5H9xkn5RWnzRWHHd5cZuP1r4wfhOOCrat8zsA=;
        h=From:To:Cc:Subject:Date:From;
        b=r9Sfq9Xh5ZNyfZ98l7RFFy4sxD06Eins15TsPwtIQDJJq6T2q8Es5zEtMDks1c31L
         eNTrVlFqitscyYiTHYjHfSKNnvImnvFx9OGItxTpjCjIogoOEr76EDNXIZIDt5U96Q
         a/8Qxy3BKN0aeExZpMuG33eEO6DGUPmy5gFV8Akg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.184
Date:   Tue, 30 Mar 2021 15:36:45 +0200
Message-Id: <16171114066214@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.184 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi            |    4 
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi       |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi       |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi       |    1 
 arch/arm64/kernel/crash_dump.c                       |    2 
 arch/ia64/include/asm/syscall.h                      |    2 
 arch/ia64/kernel/ptrace.c                            |   24 +++--
 arch/powerpc/include/asm/dcr-native.h                |    8 -
 arch/sparc/kernel/traps_64.c                         |   13 +-
 arch/x86/mm/mem_encrypt.c                            |    2 
 block/genhd.c                                        |    4 
 drivers/acpi/internal.h                              |    6 +
 drivers/acpi/scan.c                                  |   88 +++++++++++--------
 drivers/atm/eni.c                                    |    3 
 drivers/atm/idt77105.c                               |    4 
 drivers/atm/lanai.c                                  |    5 -
 drivers/atm/uPD98402.c                               |    2 
 drivers/block/xen-blkback/blkback.c                  |    2 
 drivers/bus/omap_l3_noc.c                            |    4 
 drivers/gpio/gpiolib-acpi.c                          |    2 
 drivers/gpu/drm/Kconfig                              |    1 
 drivers/gpu/drm/msm/msm_drv.c                        |    4 
 drivers/infiniband/hw/cxgb4/cm.c                     |    4 
 drivers/md/dm-ioctl.c                                |    2 
 drivers/md/dm-verity-target.c                        |    2 
 drivers/net/can/c_can/c_can.c                        |   24 -----
 drivers/net/can/c_can/c_can_pci.c                    |    3 
 drivers/net/can/c_can/c_can_platform.c               |    6 +
 drivers/net/can/dev.c                                |    1 
 drivers/net/can/flexcan.c                            |    8 +
 drivers/net/can/m_can/m_can.c                        |    3 
 drivers/net/dsa/bcm_sf2.c                            |    6 -
 drivers/net/ethernet/faraday/ftgmac100.c             |    1 
 drivers/net/ethernet/freescale/fec_ptp.c             |    7 +
 drivers/net/ethernet/freescale/gianfar.c             |   15 +++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |    4 
 drivers/net/ethernet/intel/e1000e/82571.c            |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c           |    6 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    6 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c |    3 
 drivers/net/ethernet/socionext/netsec.c              |    9 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c    |    2 
 drivers/net/ethernet/sun/niu.c                       |    2 
 drivers/net/ethernet/tehuti/tehuti.c                 |    1 
 drivers/net/usb/cdc-phonet.c                         |    2 
 drivers/net/usb/r8152.c                              |   35 +------
 drivers/net/veth.c                                   |    3 
 drivers/net/wan/fsl_ucc_hdlc.c                       |    8 +
 drivers/platform/x86/intel-vbtn.c                    |   12 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                  |    8 +
 drivers/scsi/qedi/qedi_main.c                        |    1 
 fs/ext4/xattr.c                                      |    4 
 fs/nfs/Kconfig                                       |    2 
 fs/nfs/nfs3xdr.c                                     |    3 
 fs/nfs/nfs4proc.c                                    |    3 
 fs/squashfs/export.c                                 |    8 +
 fs/squashfs/id.c                                     |    6 -
 fs/squashfs/squashfs_fs.h                            |    1 
 fs/squashfs/xattr_id.c                               |    6 -
 include/acpi/acpi_bus.h                              |    1 
 include/linux/bpf.h                                  |    9 +
 include/linux/if_macvlan.h                           |    3 
 include/linux/mutex.h                                |    2 
 include/linux/netfilter/x_tables.h                   |    7 -
 include/linux/u64_stats_sync.h                       |    7 -
 include/net/red.h                                    |   10 +-
 include/net/rtnetlink.h                              |    2 
 net/core/dev.c                                       |    2 
 net/ipv4/netfilter/arp_tables.c                      |   16 +--
 net/ipv4/netfilter/ip_tables.c                       |   16 +--
 net/ipv6/netfilter/ip6_tables.c                      |   16 +--
 net/mac80211/cfg.c                                   |    4 
 net/mac80211/ibss.c                                  |    2 
 net/netfilter/nf_conntrack_netlink.c                 |    1 
 net/netfilter/x_tables.c                             |   49 +++++++---
 net/qrtr/qrtr.c                                      |    5 +
 net/sched/sch_choke.c                                |    7 -
 net/sched/sch_gred.c                                 |    2 
 net/sched/sch_red.c                                  |    7 +
 net/sched/sch_sfq.c                                  |    2 
 tools/lib/bpf/Makefile                               |    2 
 tools/perf/util/auxtrace.c                           |    4 
 84 files changed, 357 insertions(+), 229 deletions(-)

Adrian Hunter (1):
      perf auxtrace: Fix auxtrace queue conflict

Andy Shevchenko (1):
      ACPI: scan: Use unique number for instance_no

Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Aya Levin (1):
      net/mlx5e: Fix error path for ethtool set-priv-flag

Christian König (1):
      drm/radeon: fix AGP dependency

Claudiu Beznea (1):
      ARM: dts: at91-sama5d27_som1: fix phy address to 7

Corentin Labbe (1):
      net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Daniel Wagner (1):
      block: Suppress uevent for hidden device when removed

Denis Efremov (1):
      sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Dinghao Liu (2):
      ixgbe: Fix memleak in ixgbe_configure_clsu32
      e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Dmitry Baryshkov (1):
      drm/msm: fix shutdown hook in case GPU components failed to bind

Dylan Hung (1):
      ftgmac100: Restart MAC HW once

Eric Dumazet (3):
      macvlan: macvlan_count_rx() needs to be aware of preemption
      net: sched: validate stab values
      net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Florian Fainelli (1):
      net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port

Florian Westphal (1):
      netfilter: ctnetlink: fix dump of the expect mask attribute

Frank Sorenson (1):
      NFS: Correct size calculation for create reply length

Georgi Valkov (1):
      libbpf: Fix INSTALL flag order

Greg Kroah-Hartman (1):
      Linux 4.19.184

Grygorii Strashko (1):
      bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Hans de Goede (1):
      platform/x86: intel-vbtn: Stop reporting SW_DOCK events

Hayes Wang (1):
      Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"

Heiko Thiery (1):
      net: fec: ptp: avoid register access when ipg clock is disabled

Horia Geantă (3):
      arm64: dts: ls1046a: mark crypto engine dma coherent
      arm64: dts: ls1012a: mark crypto engine dma coherent
      arm64: dts: ls1043a: mark crypto engine dma coherent

Isaku Yamahata (1):
      x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()

J. Bruce Fields (1):
      nfs: we don't support removing system.nfs4_acl

Jan Beulich (1):
      xen-blkback: don't leak persistent grants from xen_blkbk_map()

Jan Kara (1):
      ext4: add reclaim checks to xattr code

JeongHyeon Lee (1):
      dm verity: add root hash pkcs#7 signature verification

Jia-Ju Bai (5):
      net: tehuti: fix error return code in bdx_probe()
      net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
      net: wan: fix error return code of uhdlc_init()
      scsi: qedi: Fix error return code of qedi_alloc_global_queues()
      scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()

Johan Hovold (1):
      net: cdc-phonet: fix data-interface release on probe failure

Johannes Berg (1):
      mac80211: fix rate mask reset

Lv Yunlong (1):
      net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Maciej Fijalkowski (1):
      veth: Store queue_mapping independently of XDP prog presence

Marc Kleine-Budde (1):
      can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Mark Tomlinson (3):
      Revert "netfilter: x_tables: Switch synchronization to RCU"
      netfilter: x_tables: Use correct memory barriers.
      Revert "netfilter: x_tables: Update remaining dereference to RCU"

Markus Theil (1):
      mac80211: fix double free in ibss_leave

Martin Willi (1):
      can: dev: Move device back to init netns on owning netns delete

Mian Yousaf Kaukab (1):
      netsec: restore phy power state after controller reset

Michael Braun (1):
      gianfar: fix jumbo packets+napi+rx overrun crash

Michael Ellerman (1):
      powerpc/4xx: Fix build errors from mfdcr()

Mikulas Patocka (1):
      dm ioctl: fix out of bounds array access when no devices

Pavel Tatashin (1):
      arm64: kdump: update ppos when reading elfcorehdr

Peter Zijlstra (1):
      u64_stats,lockdep: Fix u64_stats_init() vs lockdep

Phillip Lougher (1):
      squashfs: fix xattr id and id lookup sanity checks

Potnuri Bharat Teja (1):
      RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Rafael J. Wysocki (1):
      ACPI: scan: Rearrange memory allocation in acpi_device_add()

Rob Gardner (1):
      sparc64: Fix opcode filtering in handling of no fault loads

Sasha Levin (1):
      bpf: Don't do bpf_cgroup_storage_set() for kuprobe/tp programs

Sean Nyekjaer (1):
      squashfs: fix inode lookup sanity checks

Sergei Trofimovich (2):
      ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls
      ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Stephane Grosjean (1):
      can: peak_usb: add forgotten supported devices

Thomas Gleixner (1):
      locking/mutex: Fix non debug version of mutex_lock_io_nested()

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

Yang Li (1):
      gpiolib: acpi: Add missing IRQF_ONESHOT

