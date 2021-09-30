Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A24D41D752
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349801AbhI3KMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349832AbhI3KMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 06:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5491C61884;
        Thu, 30 Sep 2021 10:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632996626;
        bh=vUvCynd4HakpU1WDkrxNFyHWciINwIx7ZMwMYQ0LnQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=hhO7EiVZzrtHL7WNZ/80zzBXDsr3Q7hAgDjxaOKIiYOp+EV31B5xmC/+zdKuW9mlf
         g65mdtAMNJvo95+7XluywdSdNuoAZRLEsbBuh3Odq1yZ8Ym4ttaOyircuX7dnCXpz6
         2V9hkmzv9Wj7FQoVEJ4qQWccHR7icKUowikjOe0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.70
Date:   Thu, 30 Sep 2021 12:10:19 +0200
Message-Id: <163299662031247@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.70 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/alpha/include/asm/io.h                                      |    6 
 arch/arm64/kernel/process.c                                      |    2 
 arch/arm64/kvm/vgic/vgic-its.c                                   |    8 
 arch/arm64/kvm/vgic/vgic.c                                       |    3 
 arch/m68k/include/asm/raw_io.h                                   |   20 -
 arch/parisc/include/asm/page.h                                   |    2 
 arch/sparc/kernel/ioport.c                                       |    4 
 arch/sparc/kernel/mdesc.c                                        |    3 
 arch/x86/include/asm/special_insns.h                             |    4 
 arch/x86/xen/enlighten_pv.c                                      |   15 
 block/blk-cgroup.c                                               |    8 
 block/blk-integrity.c                                            |    9 
 block/blk-mq-sched.c                                             |    3 
 block/blk-mq-tag.c                                               |    2 
 block/blk-mq.c                                                   |    3 
 drivers/acpi/nfit/core.c                                         |    3 
 drivers/acpi/numa/hmat.c                                         |    3 
 drivers/android/binder.c                                         |   23 -
 drivers/clk/keystone/sci-clk.c                                   |    4 
 drivers/cpufreq/intel_pstate.c                                   |   22 -
 drivers/edac/dmc520_edac.c                                       |    2 
 drivers/edac/synopsys_edac.c                                     |    2 
 drivers/fpga/machxo2-spi.c                                       |    6 
 drivers/gpio/gpio-uniphier.c                                     |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |    3 
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c                        |    2 
 drivers/gpu/drm/drm_modes.c                                      |    3 
 drivers/gpu/drm/i915/gt/intel_engine_user.c                      |    3 
 drivers/gpu/drm/i915/gvt/debugfs.c                               |    2 
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c                    |    3 
 drivers/gpu/drm/radeon/radeon_cs.c                               |    4 
 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c           |    3 
 drivers/interconnect/qcom/bcm-voter.c                            |    2 
 drivers/irqchip/Kconfig                                          |    1 
 drivers/irqchip/irq-gic-v3-its.c                                 |    2 
 drivers/mcb/mcb-core.c                                           |   12 
 drivers/md/md.c                                                  |    5 
 drivers/md/raid5.c                                               |    3 
 drivers/misc/sram.c                                              |    4 
 drivers/net/dsa/realtek-smi-core.c                               |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c             |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                        |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    2 
 drivers/net/ethernet/cadence/macb_pci.c                          |    2 
 drivers/net/ethernet/freescale/enetc/enetc.c                     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c          |   45 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c           |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c        |   52 +-
 drivers/net/ethernet/i825xx/82596.c                              |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                   |    3 
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                      |    8 
 drivers/net/ethernet/qlogic/qed/qed_roce.c                       |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    2 
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/phy/phylink.c                                        |   30 +
 drivers/net/usb/hso.c                                            |   12 
 drivers/nvme/host/core.c                                         |   32 -
 drivers/nvme/host/multipath.c                                    |    7 
 drivers/nvme/host/rdma.c                                         |   16 
 drivers/nvme/host/tcp.c                                          |   13 
 drivers/pci/controller/cadence/pcie-cadence-host.c               |    3 
 drivers/pci/controller/pci-aardvark.c                            |    2 
 drivers/platform/x86/intel_punit_ipc.c                           |    3 
 drivers/s390/net/qeth_core_main.c                                |    3 
 drivers/scsi/lpfc/lpfc_attr.c                                    |    3 
 drivers/scsi/qla2xxx/qla_init.c                                  |    3 
 drivers/scsi/scsi_transport_iscsi.c                              |    8 
 drivers/scsi/sd_zbc.c                                            |    6 
 drivers/spi/spi-loopback-test.c                                  |    3 
 drivers/spi/spi-tegra20-slink.c                                  |    4 
 drivers/staging/comedi/comedi_fops.c                             |    1 
 drivers/staging/greybus/uart.c                                   |   62 +--
 drivers/target/target_core_configfs.c                            |   32 +
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |    5 
 drivers/thermal/thermal_core.c                                   |    7 
 drivers/tty/serial/8250/8250_omap.c                              |    2 
 drivers/tty/serial/mvebu-uart.c                                  |    2 
 drivers/tty/synclink_gt.c                                        |  101 +----
 drivers/usb/class/cdc-acm.c                                      |    7 
 drivers/usb/class/cdc-acm.h                                      |    2 
 drivers/usb/core/hcd.c                                           |   29 +
 drivers/usb/dwc2/gadget.c                                        |  193 +++++-----
 drivers/usb/dwc3/core.c                                          |   30 -
 drivers/usb/gadget/udc/r8a66597-udc.c                            |    2 
 drivers/usb/host/bcma-hcd.c                                      |    5 
 drivers/usb/host/xhci.c                                          |    1 
 drivers/usb/musb/tusb6010.c                                      |    1 
 drivers/usb/serial/cp210x.c                                      |   47 ++
 drivers/usb/serial/mos7840.c                                     |    2 
 drivers/usb/serial/option.c                                      |   11 
 drivers/usb/storage/unusual_devs.h                               |    9 
 drivers/usb/storage/unusual_uas.h                                |    2 
 drivers/xen/balloon.c                                            |   62 ++-
 fs/afs/dir.c                                                     |   46 --
 fs/afs/dir_edit.c                                                |    4 
 fs/afs/inode.c                                                   |   10 
 fs/afs/internal.h                                                |   10 
 fs/afs/write.c                                                   |    2 
 fs/btrfs/raid56.c                                                |    3 
 fs/btrfs/space-info.c                                            |    5 
 fs/btrfs/tree-log.c                                              |    3 
 fs/btrfs/volumes.c                                               |    3 
 fs/cifs/connect.c                                                |    5 
 fs/cifs/file.c                                                   |    2 
 fs/ext4/fsmap.c                                                  |    4 
 fs/gfs2/glock.c                                                  |    3 
 fs/gfs2/log.c                                                    |    2 
 fs/gfs2/lops.c                                                   |    3 
 fs/io_uring.c                                                    |    2 
 fs/iomap/buffered-io.c                                           |    3 
 fs/ocfs2/dlmglue.c                                               |    3 
 fs/qnx4/dir.c                                                    |   69 ++-
 fs/ubifs/gc.c                                                    |    7 
 fs/ubifs/replay.c                                                |    4 
 fs/xfs/scrub/bitmap.c                                            |    4 
 fs/xfs/xfs_bmap_item.c                                           |    4 
 fs/xfs/xfs_buf.c                                                 |    6 
 fs/xfs/xfs_extent_busy.c                                         |    4 
 fs/xfs/xfs_extent_busy.h                                         |    3 
 fs/xfs/xfs_extfree_item.c                                        |    4 
 fs/xfs/xfs_refcount_item.c                                       |    4 
 fs/xfs/xfs_rmap_item.c                                           |    4 
 include/linux/compiler.h                                         |    2 
 include/linux/list_sort.h                                        |    7 
 include/linux/usb/hcd.h                                          |    2 
 include/trace/events/erofs.h                                     |    6 
 kernel/bpf/verifier.c                                            |    2 
 kernel/trace/blktrace.c                                          |    8 
 lib/list_sort.c                                                  |   17 
 lib/test_list_sort.c                                             |    3 
 mm/util.c                                                        |    4 
 net/dsa/dsa2.c                                                   |   12 
 net/ipv6/ip6_fib.c                                               |    3 
 net/smc/smc_clc.c                                                |    3 
 net/smc/smc_core.c                                               |    2 
 net/tipc/name_table.c                                            |    4 
 tools/testing/selftests/arm64/signal/test_signals.h              |    2 
 tools/testing/selftests/arm64/signal/test_signals_utils.c        |   10 
 140 files changed, 861 insertions(+), 592 deletions(-)

Andreas Larsson (1):
      sparc32: page align size in arch_dma_alloc

Andy Shevchenko (1):
      platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()

Antoine Tenart (1):
      thermal/drivers/int340x: Do not set a wrong tcc offset on resume

Anton Eidelman (1):
      nvme-multipath: fix ANA state updates when a namespace is not present

Aya Levin (1):
      net/mlx4_en: Don't allow aRFS for encapsulated packets

Baokun Li (1):
      scsi: iscsi: Adjust iface sysfs attr detection

Bixuan Cui (1):
      bpf: Add oversize check before call kvcalloc()

Borislav Petkov (1):
      EDAC/dmc520: Assign the proper type to dimm->edac_mode

Carlo Lobrano (1):
      USB: serial: option: add Telit LN920 compositions

Chen Jun (1):
      mm: fix uninitialized use in overcommit_policy_handler

Christoph Hellwig (3):
      nvme: keep ctrl->namespaces ordered
      md: fix a lock order reversal in md_alloc
      block: check if a profile is actually registered in blk_integrity_unregister

Claudiu Manoil (2):
      enetc: Fix illegal access when reading affinity_hint
      enetc: Fix uninitialized struct dim_sample field usage

Cristian Marussi (1):
      kselftest/arm64: signal: Skip tests if required features are missing

Dan Carpenter (6):
      usb: gadget: r8a66597: fix a loop in set_feature()
      usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
      mcb: fix error handling in mcb_alloc_bus()
      thermal/core: Potential buffer overflow in thermal_build_list_of_policies()
      cifs: fix a sign extension bug
      scsi: lpfc: Use correct scnprintf() limit

Dan Li (1):
      arm64: Mark __stack_chk_guard as __ro_after_init

Dave Jiang (1):
      x86/asm: Add a missing __iomem annotation in enqcmds()

David Howells (2):
      afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation
      afs: Fix updating of i_blocks on file/dir extension

Dmitry Bogdanov (1):
      scsi: qla2xxx: Restore initiator in dual mode

Doug Smythies (1):
      cpufreq: intel_pstate: Override parameters if HWP forced by BIOS

Gao Xiang (1):
      erofs: fix up erofs_lookup tracepoint

Greg Kroah-Hartman (1):
      Linux 5.10.70

Guenter Roeck (5):
      m68k: Double cast io functions to unsigned long
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy from fixed memory location
      alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
      net: 6pack: Fix tx timeout and slot time

Helge Deller (1):
      parisc: Use absolute_pointer() to define PAGE0

Ian Abbott (1):
      comedi: Fix memory leak in compat_insnlist()

Jan Beulich (1):
      xen/x86: fix PV trap handling on secondary processors

Jens Axboe (1):
      io_uring: put provided buffer meta data under memcg accounting

Jesper Nilsson (1):
      net: stmmac: allow CSR clock of 300MHz

Jian Shen (1):
      net: hns3: fix change RSS 'hfunc' ineffective issue

Jiapeng Chong (1):
      fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Jiri Slaby (1):
      tty: synclink_gt, drop unneeded forward declarations

Johan Hovold (4):
      USB: cdc-acm: fix minor-number release
      staging: greybus: uart: fix tty use after free
      net: hso: fix muxed tty registration
      USB: serial: cp210x: fix dropped characters with CP2102

Juergen Gross (2):
      xen/balloon: use a kernel thread instead a workqueue
      xen/balloon: fix balloon kthread freezing

Julian Sikorski (1):
      Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Julian Wiedmann (1):
      s390/qeth: fix NULL deref in qeth_clear_working_pool_list()

Kaige Fu (1):
      irqchip/gic-v3-its: Fix potential VPE leak on error

Karsten Graul (2):
      net/smc: add missing error check in smc_clc_prfx_set()
      net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work

Kees Cook (1):
      x86/asm: Fix SETZ size enqcmds() build failure

Kishon Vijay Abraham I (2):
      usb: core: hcd: Add support for deferring roothub registration
      xhci: Set HCD flag to defer primary roothub registration

Krzysztof Kozlowski (2):
      USB: serial: mos7840: remove duplicated 0xac24 device ID
      USB: serial: option: remove duplicate USB device ID

Kunihiko Hayashi (1):
      gpio: uniphier: Fix void functions to remove return value

Li Jinlin (1):
      blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd

Li Jun (1):
      usb: dwc3: core: balance phy init and exit

Lihong Kou (1):
      block: flush the integrity workqueue in blk_integrity_unregister

Lijo Lazar (1):
      drm/amd/pm: Update intermediate power state for SI

Linus Torvalds (4):
      sparc: avoid stringop-overread errors
      qnx4: avoid stringop-overread errors
      spi: Fix tegra20 build with CONFIG_PM=n
      qnx4: work around gcc false positive warning bug

Mark Brown (1):
      kselftest/arm64: signal: Add SVE to the set of features we can check for

Maurizio Lombardi (1):
      scsi: target: Fix the pgr/alua_support_store functions

Michael Chan (1):
      bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Minas Harutyunyan (2):
      usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave
      usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

Ming Lei (1):
      blk-mq: avoid to iterate over stale request

Naohiro Aota (1):
      scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE

Nathan Rossi (1):
      net: phylink: Update SFP selected interface on advertising changes

Nishanth Menon (1):
      serial: 8250: 8250_omap: Fix RX_LVL register offset

Ondrej Zary (1):
      usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Pali Rohár (2):
      PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response
      serial: mvebu-uart: fix driver's tx_empty callback

Qu Wenruo (1):
      btrfs: prevent __btrfs_dump_space_info() to underflow its free space

Rafał Miłecki (1):
      Revert "USB: bcma: Add a check for devm_gpiod_get"

Randy Dunlap (2):
      tty: synclink_gt: rename a conflicting function name
      irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build

Ruozhu Li (1):
      nvme-rdma: destroy cm id before destroy qp to avoid use after free

Sagi Grimberg (1):
      nvme-tcp: fix incorrect h2cdata pdu offset accounting

Sai Krishna Potthuri (1):
      EDAC/synopsys: Fix wrong value type assignment for edac_mode

Sami Tolvanen (1):
      treewide: Change list_sort to use const pointers

Shai Malin (1):
      qed: rdma - don't wait for resources under hw error recovery flow

Simon Ser (1):
      amd/display: downgrade validation failure log level

Slark Xiao (1):
      USB: serial: option: add device id for Foxconn T99W265

Steve French (1):
      cifs: fix incorrect check for null pointer in header_assemble

Sudarsana Reddy Kalluru (1):
      atlantic: Fix issue in the pm resume flow.

Todd Kjos (1):
      binder: make sure fd closes complete

Tom Rix (1):
      fpga: machxo2-spi: Return an error on failure

Tong Zhang (1):
      net: macb: fix use after free on rmmod

Uwe Brandt (1):
      USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Vladimir Oltean (2):
      net: dsa: don't allocate the slave_mii_bus using devres
      net: dsa: realtek: register the MDIO bus under devres

Wengang Wang (1):
      ocfs2: drop acl cache for directories too

Yufeng Mo (1):
      net: hns3: check queue id range before using

Zhihao Cheng (1):
      blktrace: Fix uaf in blk_trace access after removing by sysfs

zhang kai (1):
      ipv6: delay fib6_sernum increase in fib6_add

