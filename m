Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A2134E94D
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhC3Nhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhC3NhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A4F9619D1;
        Tue, 30 Mar 2021 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617111429;
        bh=bc857mWwMP50Gl0NLOyZ2BYdGeDdgpjHQBVDtGOv2xA=;
        h=From:To:Cc:Subject:Date:From;
        b=VGaJToXSP+sOp7X2DCq9Ag2W0MLRclUaWc5KqAH3kk7xL9cHFhw1AEqaDBQNi7LAU
         RchdkbKhsMzTXefiHDklPXHc5bhyhIuTtyKYNNeMU0OUBpFHrCO+6OMBZ3Vq8tBjU3
         TCju+3Nj0aQ/qwGBkqbFcLeO00NoaC3z2Vbu+VrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.109
Date:   Tue, 30 Mar 2021 15:36:51 +0200
Message-Id: <161711141144190@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.109 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi                  |    4 
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi             |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi             |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi             |    1 
 arch/arm64/kernel/crash_dump.c                             |    2 
 arch/ia64/include/asm/syscall.h                            |    2 
 arch/ia64/kernel/ptrace.c                                  |   24 ++-
 arch/powerpc/include/asm/dcr-native.h                      |    8 -
 arch/sparc/kernel/traps_64.c                               |   13 -
 arch/x86/mm/mem_encrypt.c                                  |    2 
 block/blk-merge.c                                          |    8 +
 block/genhd.c                                              |    4 
 drivers/acpi/internal.h                                    |    6 
 drivers/acpi/scan.c                                        |   88 +++++++------
 drivers/acpi/video_detect.c                                |    1 
 drivers/atm/eni.c                                          |    3 
 drivers/atm/idt77105.c                                     |    4 
 drivers/atm/lanai.c                                        |    5 
 drivers/atm/uPD98402.c                                     |    2 
 drivers/base/power/runtime.c                               |   45 +++++-
 drivers/block/xen-blkback/blkback.c                        |    2 
 drivers/bus/omap_l3_noc.c                                  |    4 
 drivers/cpufreq/cpufreq-dt-platdev.c                       |    2 
 drivers/gpio/gpiolib-acpi.c                                |    2 
 drivers/gpu/drm/Kconfig                                    |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                     |    2 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c      |    2 
 drivers/gpu/drm/msm/msm_drv.c                              |    4 
 drivers/infiniband/hw/cxgb4/cm.c                           |    4 
 drivers/irqchip/irq-ingenic-tcu.c                          |    1 
 drivers/irqchip/irq-ingenic.c                              |    1 
 drivers/md/dm-ioctl.c                                      |    2 
 drivers/md/dm-verity-target.c                              |    2 
 drivers/misc/habanalabs/device.c                           |    2 
 drivers/net/can/c_can/c_can.c                              |   24 ---
 drivers/net/can/c_can/c_can_pci.c                          |    3 
 drivers/net/can/c_can/c_can_platform.c                     |    6 
 drivers/net/can/dev.c                                      |    1 
 drivers/net/can/flexcan.c                                  |    8 +
 drivers/net/can/kvaser_pciefd.c                            |    4 
 drivers/net/can/m_can/m_can.c                              |    5 
 drivers/net/dsa/b53/b53_common.c                           |   14 +-
 drivers/net/dsa/bcm_sf2.c                                  |    6 
 drivers/net/ethernet/davicom/dm9000.c                      |    2 
 drivers/net/ethernet/faraday/ftgmac100.c                   |    1 
 drivers/net/ethernet/freescale/fec_ptp.c                   |    7 +
 drivers/net/ethernet/freescale/gianfar.c                   |   15 ++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c              |    4 
 drivers/net/ethernet/intel/e1000e/82571.c                  |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                 |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c                |    3 
 drivers/net/ethernet/intel/igc/igc_ethtool.c               |    7 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c              |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c            |    4 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c        |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c       |    6 
 drivers/net/ethernet/netronome/nfp/flower/metadata.c       |   24 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c       |    3 
 drivers/net/ethernet/socionext/netsec.c                    |    9 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c          |    2 
 drivers/net/ethernet/sun/niu.c                             |    2 
 drivers/net/ethernet/tehuti/tehuti.c                       |    1 
 drivers/net/usb/cdc-phonet.c                               |    2 
 drivers/net/usb/r8152.c                                    |   40 +----
 drivers/net/veth.c                                         |    3 
 drivers/net/wan/fsl_ucc_hdlc.c                             |    8 -
 drivers/nvme/host/core.c                                   |    1 
 drivers/nvme/host/fc.c                                     |    2 
 drivers/nvme/host/pci.c                                    |    1 
 drivers/platform/x86/intel-vbtn.c                          |   12 +
 drivers/regulator/qcom-rpmh-regulator.c                    |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                        |    8 -
 drivers/scsi/qedi/qedi_main.c                              |    1 
 drivers/scsi/qla2xxx/qla_target.c                          |   13 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                         |    4 
 fs/cifs/smb2pdu.c                                          |    6 
 fs/cifs/transport.c                                        |    2 
 fs/ext4/xattr.c                                            |    4 
 fs/hugetlbfs/inode.c                                       |    4 
 fs/nfs/Kconfig                                             |    2 
 fs/nfs/nfs3xdr.c                                           |    3 
 fs/nfs/nfs4proc.c                                          |    3 
 fs/squashfs/export.c                                       |    8 -
 fs/squashfs/id.c                                           |    6 
 fs/squashfs/squashfs_fs.h                                  |    1 
 fs/squashfs/xattr_id.c                                     |    6 
 include/acpi/acpi_bus.h                                    |    1 
 include/linux/bpf.h                                        |    9 -
 include/linux/hugetlb.h                                    |    2 
 include/linux/if_macvlan.h                                 |    3 
 include/linux/mm.h                                         |   15 ++
 include/linux/mutex.h                                      |    2 
 include/linux/netfilter/x_tables.h                         |    7 -
 include/linux/u64_stats_sync.h                             |    7 -
 include/net/inet_connection_sock.h                         |    2 
 include/net/nexthop.h                                      |   24 +++
 include/net/red.h                                          |   10 +
 include/net/rtnetlink.h                                    |    2 
 kernel/gcov/clang.c                                        |   69 ++++++++++
 kernel/power/energy_model.c                                |    2 
 mm/hugetlb.c                                               |   10 -
 mm/userfaultfd.c                                           |    2 
 net/core/dev.c                                             |    2 
 net/ipv4/inet_connection_sock.c                            |    7 -
 net/ipv4/netfilter/arp_tables.c                            |   16 +-
 net/ipv4/netfilter/ip_tables.c                             |   16 +-
 net/ipv4/tcp_minisocks.c                                   |    7 -
 net/ipv6/ip6_fib.c                                         |    2 
 net/ipv6/netfilter/ip6_tables.c                            |   16 +-
 net/mac80211/cfg.c                                         |    4 
 net/mac80211/ibss.c                                        |    2 
 net/netfilter/nf_conntrack_netlink.c                       |    1 
 net/netfilter/x_tables.c                                   |   49 +++++--
 net/qrtr/qrtr.c                                            |    5 
 net/sched/sch_choke.c                                      |    7 -
 net/sched/sch_gred.c                                       |    2 
 net/sched/sch_red.c                                        |    7 -
 net/sched/sch_sfq.c                                        |    2 
 security/integrity/iint.c                                  |    8 +
 sound/hda/intel-nhlt.c                                     |    5 
 tools/lib/bpf/Makefile                                     |    2 
 tools/lib/bpf/btf_dump.c                                   |    2 
 tools/lib/bpf/netlink.c                                    |    2 
 tools/perf/util/auxtrace.c                                 |    4 
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c       |    6 
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh  |    2 
 128 files changed, 621 insertions(+), 304 deletions(-)

Adrian Hunter (1):
      perf auxtrace: Fix auxtrace queue conflict

Alexander Ovechkin (1):
      tcp: relookup sock for RST+ACK packets handled by obsolete req sock

Andrey Konovalov (1):
      kasan: fix per-page tags for non-page_alloc pages

Andy Shevchenko (1):
      ACPI: scan: Use unique number for instance_no

Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Aurelien Aptel (1):
      cifs: ask for more credit on async read/write code paths

Aya Levin (1):
      net/mlx5e: Fix error path for ethtool set-priv-flag

Bart Van Assche (1):
      scsi: Revert "qla2xxx: Make sure that aborted commands are freed"

Chris Chiu (1):
      ACPI: video: Add missing callback back for Sony VPCEH3U1E

Christian König (1):
      drm/radeon: fix AGP dependency

Claudiu Beznea (1):
      ARM: dts: at91-sama5d27_som1: fix phy address to 7

Corentin Labbe (1):
      net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Daniel Wagner (1):
      block: Suppress uevent for hidden device when removed

David Jeffery (1):
      block: recalculate segment count for multi-segment discards correctly

Denis Efremov (1):
      sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Dinghao Liu (2):
      ixgbe: Fix memleak in ixgbe_configure_clsu32
      e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Dmitry Baryshkov (1):
      drm/msm: fix shutdown hook in case GPU components failed to bind

Dmitry Monakhov (1):
      nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a

Dylan Hung (1):
      ftgmac100: Restart MAC HW once

Eric Dumazet (3):
      macvlan: macvlan_count_rx() needs to be aware of preemption
      net: sched: validate stab values
      net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Florian Fainelli (2):
      net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port
      net: dsa: b53: VLAN filtering is global to all users

Florian Westphal (1):
      netfilter: ctnetlink: fix dump of the expect mask attribute

Frank Sorenson (1):
      NFS: Correct size calculation for create reply length

Geetha sowjanya (1):
      octeontx2-af: Fix irq free in rvu teardown

Georgi Valkov (1):
      libbpf: Fix INSTALL flag order

Greg Kroah-Hartman (1):
      Linux 5.4.109

Grygorii Strashko (1):
      bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Hangbin Liu (2):
      selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed
      selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value

Hannes Reinecke (2):
      nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()
      nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted

Hans de Goede (1):
      platform/x86: intel-vbtn: Stop reporting SW_DOCK events

Hariprasad Kelam (1):
      octeontx2-af: fix infinite loop in unmapping NPC counter

Hayes Wang (2):
      Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
      r8152: limit the RX buffer size of RTL8153A for USB 2.0

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

Jean-Philippe Brucker (1):
      libbpf: Fix BTF dump of pointer-to-array-of-struct

JeongHyeon Lee (1):
      dm verity: fix DM_VERITY_OPTS_MAX value

Jia-Ju Bai (6):
      net: tehuti: fix error return code in bdx_probe()
      net: intel: iavf: fix error return code of iavf_init_get_resources()
      net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
      net: wan: fix error return code of uhdlc_init()
      scsi: qedi: Fix error return code of qedi_alloc_global_queues()
      scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()

Jimmy Assarsson (1):
      can: kvaser_pciefd: Always disable bus load reporting

Johan Hovold (1):
      net: cdc-phonet: fix data-interface release on probe failure

Johannes Berg (1):
      mac80211: fix rate mask reset

Kumar Kartikeya Dwivedi (1):
      libbpf: Use SOCK_CLOEXEC when opening the netlink socket

Louis Peens (1):
      nfp: flower: fix pre_tun mask id allocation

Lukasz Luba (1):
      PM: EM: postpone creating the debugfs dir till fs_initcall

Lv Yunlong (1):
      net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Maciej Fijalkowski (1):
      veth: Store queue_mapping independently of XDP prog presence

Maor Dickman (1):
      net/mlx5e: Don't match on Geneve options in case option masks are all zero

Marc Kleine-Budde (1):
      can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Mark Pearson (1):
      ALSA: hda: ignore invalid NHLT table

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

Mike Kravetz (1):
      hugetlbfs: hugetlb_fault_mutex_hash() cleanup

Mikulas Patocka (1):
      dm ioctl: fix out of bounds array access when no devices

Mimi Zohar (1):
      integrity: double check iint_cache was initialized

Muhammad Husaini Zulkifli (2):
      igc: Fix Pause Frame Advertising
      igc: Fix Supported Pause Frame Link Setting

Nick Desaulniers (1):
      gcov: fix clang-11+ support

Nirmoy Das (1):
      drm/amdgpu: fb BO should be ttm_bo_type_device

Paul Cercueil (2):
      net: davicom: Use platform_get_irq_optional()
      irqchip/ingenic: Add support for the JZ4760

Paulo Alcantara (1):
      cifs: change noisy error message to FYI

Pavel Tatashin (1):
      arm64: kdump: update ppos when reading elfcorehdr

Peter Zijlstra (1):
      u64_stats,lockdep: Fix u64_stats_init() vs lockdep

Phillip Lougher (1):
      squashfs: fix xattr id and id lookup sanity checks

Potnuri Bharat Teja (1):
      RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Rafael J. Wysocki (2):
      PM: runtime: Defer suspending suppliers
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

Sudeep Holla (1):
      cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev

Sung Lee (1):
      drm/amd/display: Revert dram_clock_change_latency for DCN2.1

Thomas Gleixner (1):
      locking/mutex: Fix non debug version of mutex_lock_io_nested()

Timo Rothenpieler (1):
      nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default

Tomer Tayar (1):
      habanalabs: Call put_pid() when releasing control device

Tong Zhang (6):
      atm: eni: dont release is never initialized
      atm: lanai: dont run lanai_dev_close if not open
      atm: uPD98402: fix incorrect allocation
      atm: idt77252: fix null-ptr-dereference
      can: c_can_pci: c_can_pci_remove(): fix use-after-free
      can: c_can: move runtime PM enable/disable to c_can_platform

Torin Cooper-Bennun (2):
      can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
      can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors

Vitaly Lifshits (1):
      e1000e: add rtnl_lock() to e1000_reset_task

Wei Wang (1):
      ipv6: fix suspecious RCU usage warning

Yang Li (1):
      gpiolib: acpi: Add missing IRQF_ONESHOT

satya priya (1):
      regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck

