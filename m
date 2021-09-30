Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141AA41D75A
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349894AbhI3KMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349833AbhI3KMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 06:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B585561980;
        Thu, 30 Sep 2021 10:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632996639;
        bh=HNVNNCPMLButTjd7g7wHT6p3qQnyaopAqLj+mBS/qCg=;
        h=From:To:Cc:Subject:Date:From;
        b=ssufaE/LaigeBGfqklUl2oH6W91T5nhom9UwMAs8r5kcuElD0KqEG8hOL1igaTLC4
         wL0AcRejSylDa3phXx/hyt1cHssvWCOsXryg4I8w9/c4JUI2+edh9dnsXOEsaKSnpi
         kSlZDvGvH+RovNEC8EKXq+HI4m0Eo+IZ7mTfCvDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.9
Date:   Thu, 30 Sep 2021 12:10:25 +0200
Message-Id: <1632996626140137@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.9 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/alpha/include/asm/io.h                                      |    6 
 arch/arm64/include/asm/assembler.h                               |    5 
 arch/arm64/include/asm/mte.h                                     |    6 
 arch/arm64/include/asm/string.h                                  |    2 
 arch/arm64/kernel/cpufeature.c                                   |    8 
 arch/arm64/kernel/mte.c                                          |   10 
 arch/arm64/kernel/process.c                                      |    2 
 arch/arm64/lib/strcmp.S                                          |    2 
 arch/arm64/lib/strncmp.S                                         |    2 
 arch/m68k/include/asm/raw_io.h                                   |   20 -
 arch/parisc/include/asm/page.h                                   |    2 
 arch/sparc/kernel/ioport.c                                       |    4 
 arch/sparc/kernel/mdesc.c                                        |    3 
 arch/x86/include/asm/pkeys.h                                     |    2 
 arch/x86/include/asm/special_insns.h                             |    2 
 arch/x86/kernel/setup.c                                          |   26 -
 arch/x86/mm/fault.c                                              |   26 -
 arch/x86/xen/enlighten_pv.c                                      |   15 
 block/blk-cgroup.c                                               |    8 
 block/blk-integrity.c                                            |    9 
 block/blk-mq-tag.c                                               |    2 
 drivers/android/binder.c                                         |   58 ++-
 drivers/android/binder_internal.h                                |    2 
 drivers/base/swnode.c                                            |    3 
 drivers/comedi/comedi_fops.c                                     |    1 
 drivers/cpufreq/intel_pstate.c                                   |   22 -
 drivers/edac/dmc520_edac.c                                       |    2 
 drivers/edac/synopsys_edac.c                                     |    2 
 drivers/fpga/machxo2-spi.c                                       |    6 
 drivers/gpio/gpio-uniphier.c                                     |    4 
 drivers/gpio/gpiolib-acpi.c                                      |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                          |   44 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                            |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                             |  152 +++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   53 ++
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                 |   10 
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c                        |    2 
 drivers/gpu/drm/ttm/ttm_pool.c                                   |    3 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                   |   44 --
 drivers/irqchip/Kconfig                                          |    1 
 drivers/irqchip/irq-armada-370-xp.c                              |    4 
 drivers/irqchip/irq-gic-v3-its.c                                 |    2 
 drivers/mcb/mcb-core.c                                           |   12 
 drivers/md/md.c                                                  |    5 
 drivers/misc/bcm-vk/bcm_vk_tty.c                                 |    6 
 drivers/misc/genwqe/card_base.c                                  |    2 
 drivers/net/dsa/mv88e6xxx/chip.c                                 |   16 
 drivers/net/dsa/mv88e6xxx/devlink.c                              |   73 ---
 drivers/net/dsa/mv88e6xxx/devlink.h                              |    6 
 drivers/net/dsa/realtek-smi-core.c                               |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c             |    4 
 drivers/net/ethernet/broadcom/bgmac-bcma.c                       |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                        |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    2 
 drivers/net/ethernet/cadence/macb_pci.c                          |    2 
 drivers/net/ethernet/freescale/enetc/enetc.c                     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c           |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c          |   80 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c           |   10 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c            |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c        |   52 +-
 drivers/net/ethernet/i825xx/82596.c                              |    2 
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c                  |    3 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                   |    3 
 drivers/net/ethernet/mscc/ocelot.c                               |   11 
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                      |    8 
 drivers/net/ethernet/qlogic/qed/qed_roce.c                       |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    2 
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/phy/phylink.c                                        |   30 +
 drivers/net/usb/hso.c                                            |   12 
 drivers/net/virtio_net.c                                         |    4 
 drivers/net/vxlan.c                                              |    2 
 drivers/nfc/st-nci/spi.c                                         |    1 
 drivers/nvme/host/core.c                                         |   33 -
 drivers/nvme/host/multipath.c                                    |    7 
 drivers/nvme/host/rdma.c                                         |   16 
 drivers/nvme/host/tcp.c                                          |   13 
 drivers/nvme/target/configfs.c                                   |    2 
 drivers/platform/x86/amd-pmc.c                                   |    2 
 drivers/platform/x86/dell/Kconfig                                |    3 
 drivers/platform/x86/intel_punit_ipc.c                           |    3 
 drivers/regulator/max14577-regulator.c                           |    2 
 drivers/regulator/qcom-rpmh-regulator.c                          |    2 
 drivers/s390/net/qeth_core_main.c                                |    3 
 drivers/scsi/lpfc/lpfc_attr.c                                    |    3 
 drivers/scsi/qla2xxx/qla_init.c                                  |    3 
 drivers/scsi/scsi_transport_iscsi.c                              |    8 
 drivers/scsi/sd_zbc.c                                            |    8 
 drivers/scsi/ufs/ufshcd.c                                        |   81 +---
 drivers/scsi/ufs/ufshcd.h                                        |    5 
 drivers/scsi/ufs/ufshci.h                                        |    1 
 drivers/spi/spi-tegra20-slink.c                                  |    4 
 drivers/spi/spi.c                                                |    8 
 drivers/staging/greybus/uart.c                                   |   62 +--
 drivers/target/target_core_configfs.c                            |   32 +
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |    5 
 drivers/thermal/thermal_core.c                                   |    7 
 drivers/tty/serial/8250/8250_omap.c                              |    2 
 drivers/tty/serial/mvebu-uart.c                                  |    2 
 drivers/tty/synclink_gt.c                                        |   44 +-
 drivers/usb/cdns3/cdns3-gadget.c                                 |   14 
 drivers/usb/class/cdc-acm.c                                      |    7 
 drivers/usb/class/cdc-acm.h                                      |    2 
 drivers/usb/core/hcd.c                                           |   29 +
 drivers/usb/dwc2/gadget.c                                        |  193 +++++-----
 drivers/usb/dwc3/core.c                                          |   30 -
 drivers/usb/gadget/function/f_uac2.c                             |   19 
 drivers/usb/gadget/function/u_audio.c                            |   13 
 drivers/usb/gadget/udc/r8a66597-udc.c                            |    2 
 drivers/usb/host/bcma-hcd.c                                      |    5 
 drivers/usb/host/xhci.c                                          |    1 
 drivers/usb/isp1760/isp1760-hcd.c                                |    6 
 drivers/usb/musb/tusb6010.c                                      |    1 
 drivers/usb/serial/cp210x.c                                      |   36 +
 drivers/usb/serial/mos7840.c                                     |    2 
 drivers/usb/serial/option.c                                      |   11 
 drivers/usb/storage/unusual_devs.h                               |    9 
 drivers/usb/storage/unusual_uas.h                                |    2 
 drivers/xen/balloon.c                                            |   62 ++-
 fs/afs/dir.c                                                     |   46 --
 fs/afs/dir_edit.c                                                |    4 
 fs/afs/fs_probe.c                                                |    8 
 fs/afs/fsclient.c                                                |   31 +
 fs/afs/inode.c                                                   |   10 
 fs/afs/internal.h                                                |   11 
 fs/afs/protocol_afs.h                                            |   15 
 fs/afs/protocol_yfs.h                                            |    6 
 fs/afs/write.c                                                   |   12 
 fs/btrfs/space-info.c                                            |    5 
 fs/cifs/cifsglob.h                                               |    1 
 fs/cifs/connect.c                                                |    5 
 fs/cifs/file.c                                                   |    4 
 fs/cifs/misc.c                                                   |    4 
 fs/io_uring.c                                                    |   13 
 fs/lockd/svcxdr.h                                                |   13 
 fs/ocfs2/dlmglue.c                                               |    3 
 fs/qnx4/dir.c                                                    |   69 ++-
 include/linux/compiler.h                                         |    2 
 include/linux/pkeys.h                                            |    2 
 include/linux/usb/hcd.h                                          |    2 
 include/net/dsa.h                                                |    8 
 include/trace/events/erofs.h                                     |    6 
 include/uapi/linux/android/binder.h                              |    7 
 kernel/bpf/verifier.c                                            |    2 
 kernel/dma/debug.c                                               |    3 
 kernel/entry/kvm.c                                               |    4 
 kernel/rseq.c                                                    |   14 
 kernel/trace/blktrace.c                                          |    8 
 mm/debug.c                                                       |    3 
 mm/memory-failure.c                                              |    2 
 mm/util.c                                                        |    4 
 net/core/dev.c                                                   |   16 
 net/dsa/dsa2.c                                                   |   64 ++-
 net/ipv4/nexthop.c                                               |   21 -
 net/ipv6/ip6_fib.c                                               |    3 
 net/mptcp/protocol.c                                             |    4 
 net/smc/smc_clc.c                                                |    3 
 net/smc/smc_core.c                                               |    2 
 tools/lib/perf/evsel.c                                           |   64 ++-
 tools/testing/selftests/arm64/signal/test_signals.h              |    2 
 tools/testing/selftests/arm64/signal/test_signals_utils.c        |   10 
 164 files changed, 1439 insertions(+), 862 deletions(-)

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

Bart Van Assche (4):
      scsi: sd_zbc: Support disks with more than 2**32 logical blocks
      scsi: ufs: Revert "Utilize Transfer Request List Completion Notification Register"
      scsi: ufs: Retry aborted SCSI commands instead of completing these successfully
      scsi: ufs: core: Unbreak the reset handler

Bixuan Cui (1):
      bpf: Add oversize check before call kvcalloc()

Borislav Petkov (1):
      EDAC/dmc520: Assign the proper type to dimm->edac_mode

Carlo Lobrano (1):
      USB: serial: option: add Telit LN920 compositions

Chen Jun (1):
      mm: fix uninitialized use in overcommit_policy_handler

Christian Lamparter (1):
      net: bgmac-bcma: handle deferred probe error due to mac-address

Christoph Hellwig (3):
      nvme: keep ctrl->namespaces ordered
      md: fix a lock order reversal in md_alloc
      block: check if a profile is actually registered in blk_integrity_unregister

Christophe JAILLET (1):
      misc: genwqe: Fixes DMA mask setting

Chuck Lever (1):
      NLM: Fix svcxdr_encode_owner()

Claudiu Manoil (2):
      enetc: Fix illegal access when reading affinity_hint
      enetc: Fix uninitialized struct dim_sample field usage

Cristian Marussi (1):
      kselftest/arm64: signal: Skip tests if required features are missing

Dan Carpenter (7):
      usb: gadget: r8a66597: fix a loop in set_feature()
      usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
      mcb: fix error handling in mcb_alloc_bus()
      thermal/core: Potential buffer overflow in thermal_build_list_of_policies()
      cifs: fix a sign extension bug
      scsi: lpfc: Use correct scnprintf() limit
      nvmet: fix a width vs precision bug in nvmet_subsys_attr_serial_show()

Dan Li (1):
      arm64: Mark __stack_chk_guard as __ro_after_init

David Howells (4):
      afs: Fix page leak
      afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation
      afs: Fix corruption in reads at fpos 2G-4G from an OpenAFS server
      afs: Fix updating of i_blocks on file/dir extension

Dmitry Baryshkov (1):
      regulator: qcom-rpmh-regulator: fix pm8009-1 ldo7 resource name

Dmitry Bogdanov (1):
      scsi: qla2xxx: Restore initiator in dual mode

Doug Smythies (1):
      cpufreq: intel_pstate: Override parameters if HWP forced by BIOS

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries

Felix Kuehling (1):
      drm/amdkfd: make needs_pcie_atomics FW-version dependent

Gao Xiang (1):
      erofs: fix up erofs_lookup tracepoint

Greg Kroah-Hartman (1):
      Linux 5.14.9

Guenter Roeck (5):
      m68k: Double cast io functions to unsigned long
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy from fixed memory location
      alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
      net: 6pack: Fix tx timeout and slot time

Hamza Mahfooz (1):
      dma-debug: prevent an error message from causing runtime problems

Hans de Goede (1):
      gpiolib: acpi: Make set-debounce-timeout failures non fatal

Hao Xu (2):
      io_uring: fix race between poll completion and cancel_hash insertion
      io_uring: fix missing set of EPOLLONESHOT for CQ ring overflow

Helge Deller (1):
      parisc: Use absolute_pointer() to define PAGE0

Huang Rui (1):
      drm/ttm: fix type mismatch error on sparc64

Ian Abbott (1):
      comedi: Fix memory leak in compat_insnlist()

Ian Rogers (1):
      libperf evsel: Make use of FD robust.

Ido Schimmel (2):
      nexthop: Fix division by zero while replacing a resilient group
      nexthop: Fix memory leaks in nexthop notification chain listeners

Jack Pham (2):
      usb: gadget: f_uac2: Add missing companion descriptor for feedback EP
      usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval

Jan Beulich (1):
      xen/x86: fix PV trap handling on secondary processors

Jason Wang (1):
      virtio-net: fix pages leaking when building skb in big mode

Jens Axboe (2):
      io_uring: put provided buffer meta data under memcg accounting
      io_uring: don't punt files update to io-wq unconditionally

Jesper Nilsson (1):
      net: stmmac: allow CSR clock of 300MHz

Jian Shen (2):
      net: hns3: fix change RSS 'hfunc' ineffective issue
      net: hns3: fix inconsistent vf id print

Jiapeng Chong (1):
      fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Jiaran Zhang (1):
      net: hns3: fix misuse vf id and vport id in some logs

Jiashuo Liang (1):
      x86/fault: Fix wrong signal when vsyscall fails with pkey

Johan Hovold (5):
      USB: cdc-acm: fix minor-number release
      staging: greybus: uart: fix tty use after free
      misc: bcm-vk: fix tty registration race
      net: hso: fix muxed tty registration
      USB: serial: cp210x: fix dropped characters with CP2102

Juergen Gross (3):
      xen/balloon: use a kernel thread instead a workqueue
      x86/setup: Call early_reserve_memory() earlier
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

Krzysztof Kozlowski (3):
      USB: serial: mos7840: remove duplicated 0xac24 device ID
      USB: serial: option: remove duplicate USB device ID
      regulator: max14577: Revert "regulator: max14577: Add proper module aliases strings"

Kunihiko Hayashi (1):
      gpio: uniphier: Fix void functions to remove return value

Laurentiu Tudor (1):
      software node: balance refcount for managed software nodes

Li Jinlin (1):
      blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd

Li Jun (1):
      usb: dwc3: core: balance phy init and exit

Li Li (1):
      binder: fix freeze race

Lihong Kou (1):
      block: flush the integrity workqueue in blk_integrity_unregister

Lijo Lazar (1):
      drm/amd/pm: Update intermediate power state for SI

Linus Torvalds (5):
      sparc: avoid stringop-overread errors
      qnx4: avoid stringop-overread errors
      spi: Fix tegra20 build with CONFIG_PM=n
      Revert drm/vc4 hdmi runtime PM changes
      qnx4: work around gcc false positive warning bug

Marc Zyngier (1):
      irqchip/armada-370-xp: Fix ack/eoi breakage

Mario Limonciello (1):
      platform/x86: amd-pmc: Increase the response register timeout

Mark Brown (3):
      kselftest/arm64: signal: Add SVE to the set of features we can check for
      spi: Revert modalias changes
      nfc: st-nci: Add SPI ID matching DT compatible

Maurizio Lombardi (1):
      scsi: target: Fix the pgr/alua_support_store functions

Meenakshikumar Somasundaram (1):
      drm/amd/display: Link training retry fix for abort case

Michael Chan (1):
      bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Minas Harutyunyan (2):
      usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave
      usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

Ming Lei (1):
      blk-mq: avoid to iterate over stale request

Naohiro Aota (1):
      scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE

Naoya Horiguchi (1):
      mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()

Nathan Rossi (1):
      net: phylink: Update SFP selected interface on advertising changes

Nishanth Menon (1):
      serial: 8250: 8250_omap: Fix RX_LVL register offset

Ondrej Zary (1):
      usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Pali Rohár (1):
      serial: mvebu-uart: fix driver's tx_empty callback

Paolo Abeni (1):
      mptcp: ensure tx skbs always have the MPTCP ext

Pavel Hofman (1):
      usb: gadget: u_audio: EP-OUT bInterval in fback frequency

Pawel Laszczak (1):
      usb: cdns3: fix race condition before setting doorbell

Peter Collingbourne (1):
      arm64: add MTE supported check to thread switching and syscall entry/exit

Philip Yang (2):
      drm/amdkfd: map SVM range with correct access permission
      drm/amdkfd: fix dma mapping leaking warning

Qingqing Zhuo (1):
      drm/amd/display: Fix unstable HPCP compliance on Chrome Barcelo

Qu Wenruo (1):
      btrfs: prevent __btrfs_dump_space_info() to underflow its free space

Rafał Miłecki (1):
      Revert "USB: bcma: Add a check for devm_gpiod_get"

Randy Dunlap (3):
      platform/x86: dell: fix DELL_WMI_PRIVACY dependencies & build error
      tty: synclink_gt: rename a conflicting function name
      irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build

Robin Murphy (1):
      arm64: Mitigate MTE issues with str{n}cmp()

Rohith Surabattula (2):
      cifs: Not to defer close on file when lock is set
      cifs: Fix soft lockup during fsstress

Rui Miguel Silva (1):
      usb: isp1760: do not sleep in field register poll

Ruozhu Li (1):
      nvme-rdma: destroy cm id before destroy qp to avoid use after free

Sagi Grimberg (1):
      nvme-tcp: fix incorrect h2cdata pdu offset accounting

Sai Krishna Potthuri (1):
      EDAC/synopsys: Fix wrong value type assignment for edac_mode

Sean Christopherson (1):
      KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest

Shai Malin (1):
      qed: rdma - don't wait for resources under hw error recovery flow

Simon Ser (2):
      amd/display: downgrade validation failure log level
      amd/display: enable panel orientation quirks

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

Vladimir Oltean (5):
      net: dsa: tear down devlink port regions when tearing down the devlink port on error
      net: dsa: fix dsa_tree_setup error path
      net: dsa: don't allocate the slave_mii_bus using devres
      net: dsa: realtek: register the MDIO bus under devres
      net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled

Weizhao Ouyang (1):
      mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN

Wengang Wang (1):
      ocfs2: drop acl cache for directories too

Xuan Zhuo (1):
      napi: fix race inside napi_enable

Yufeng Mo (2):
      net: hns3: check queue id range before using
      net: hns3: fix a return value error in hclge_get_reset_status()

Zhihao Cheng (1):
      blktrace: Fix uaf in blk_trace access after removing by sysfs

dann frazier (1):
      arm64: Restore forced disabling of KPTI on ThunderX

liaoguojia (1):
      net: hns3: check vlan id before using it

zhang kai (1):
      ipv6: delay fib6_sernum increase in fib6_add

