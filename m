Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C30221E87
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 10:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgGPIhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 04:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgGPIhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 04:37:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E85F2067D;
        Thu, 16 Jul 2020 08:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594888658;
        bh=+4e2VSo8Np5lx/T14FkbzRqpZhUCYT9PmZ7Wi/2ynjs=;
        h=From:To:Cc:Subject:Date:From;
        b=hFxy2YtImF2xBecmGFN2JXF6FEL7pO+Pq8NEV6IsknFS+79fFXoG6AnDpM8vdt39u
         S23qidvyVjlS17olxt7nUBpQ1eLCesu/qTeq1+vRHTBGnjvWvJM664M3F27gaHpLp2
         81xNjzJ1PLUZCzPetqkK6xNMbG3IjLXmBOEgYFKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.52
Date:   Thu, 16 Jul 2020 10:37:28 +0200
Message-Id: <1594888648135246@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.52 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arc/include/asm/elf.h                            |    2 
 arch/arc/kernel/entry.S                               |   16 
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi        |    4 
 arch/arm/mach-imx/pm-imx6.c                           |   10 
 arch/arm64/include/asm/arch_gicv3.h                   |    2 
 arch/arm64/include/asm/cpufeature.h                   |    2 
 arch/arm64/include/asm/pgtable-prot.h                 |    2 
 arch/arm64/kernel/kgdb.c                              |    2 
 arch/arm64/kvm/hyp-init.S                             |   11 
 arch/arm64/kvm/reset.c                                |   10 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                |    3 
 arch/s390/include/asm/kvm_host.h                      |    8 
 arch/s390/include/asm/uaccess.h                       |    2 
 arch/s390/kernel/early.c                              |    2 
 arch/s390/kernel/setup.c                              |    1 
 arch/s390/mm/hugetlbpage.c                            |    2 
 arch/s390/mm/maccess.c                                |   19 
 arch/x86/events/Kconfig                               |    6 
 arch/x86/events/Makefile                              |    1 
 arch/x86/events/intel/Makefile                        |    2 
 arch/x86/events/intel/rapl.c                          |  802 -----------------
 arch/x86/events/rapl.c                                |  805 ++++++++++++++++++
 arch/x86/include/asm/processor.h                      |    2 
 arch/x86/kvm/kvm_cache_regs.h                         |    2 
 arch/x86/kvm/mmu.c                                    |    2 
 arch/x86/kvm/vmx/vmx.c                                |    2 
 arch/x86/kvm/x86.c                                    |    2 
 block/bio-integrity.c                                 |   23 
 block/blk-mq.c                                        |    4 
 drivers/base/regmap/regmap.c                          |  100 +-
 drivers/block/nbd.c                                   |   25 
 drivers/gpio/gpio-pca953x.c                           |   84 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c               |    3 
 drivers/gpu/drm/drm_panel_orientation_quirks.c        |   14 
 drivers/gpu/drm/mcde/mcde_drv.c                       |    3 
 drivers/gpu/drm/mediatek/mtk_drm_plane.c              |   25 
 drivers/gpu/drm/radeon/ci_dpm.c                       |    7 
 drivers/gpu/drm/tegra/hub.c                           |    8 
 drivers/gpu/drm/ttm/ttm_bo.c                          |    4 
 drivers/gpu/host1x/bus.c                              |    9 
 drivers/infiniband/core/sa_query.c                    |   38 
 drivers/infiniband/hw/hfi1/init.c                     |   37 
 drivers/infiniband/hw/hfi1/qp.c                       |    5 
 drivers/infiniband/hw/hfi1/tid_rdma.c                 |    5 
 drivers/infiniband/hw/mlx5/main.c                     |    2 
 drivers/infiniband/sw/siw/siw_main.c                  |    3 
 drivers/iommu/intel-iommu.c                           |   37 
 drivers/md/dm-writecache.c                            |    6 
 drivers/md/dm.c                                       |   15 
 drivers/message/fusion/mptscsih.c                     |    4 
 drivers/mmc/host/meson-gx-mmc.c                       |    6 
 drivers/net/dsa/microchip/ksz8795.c                   |    3 
 drivers/net/dsa/microchip/ksz9477.c                   |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c       |    2 
 drivers/net/ethernet/cadence/macb_main.c              |   12 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c     |   10 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c            |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c    |    9 
 drivers/net/ethernet/ibm/ibmvnic.c                    |    9 
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   29 
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c          |   12 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |   14 
 drivers/net/ethernet/marvell/mvneta.c                 |   88 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c     |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c  |    8 
 drivers/net/ethernet/mellanox/mlx5/core/port.c        |   93 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c             |   54 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c           |    4 
 drivers/net/ethernet/qlogic/qed/qed_dev.c             |   12 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c             |    7 
 drivers/net/ethernet/qlogic/qed/qed_mcp.h             |    7 
 drivers/net/usb/smsc95xx.c                            |    9 
 drivers/net/wireless/ath/ath9k/hif_usb.c              |   48 -
 drivers/net/wireless/ath/ath9k/hif_usb.h              |    5 
 drivers/nvme/host/rdma.c                              |    2 
 drivers/pwm/pwm-jz4740.c                              |    5 
 drivers/spi/spi-fsl-dspi.c                            |   34 
 drivers/spi/spidev.c                                  |   24 
 drivers/usb/dwc3/dwc3-pci.c                           |    4 
 fs/btrfs/extent_io.c                                  |   40 
 fs/btrfs/inode.c                                      |    9 
 fs/cifs/inode.c                                       |    9 
 include/linux/filter.h                                |    4 
 include/linux/kallsyms.h                              |    5 
 include/sound/compress_driver.h                       |   10 
 kernel/bpf/syscall.c                                  |   32 
 kernel/kallsyms.c                                     |   17 
 kernel/kprobes.c                                      |    4 
 kernel/module.c                                       |   51 -
 kernel/sched/core.c                                   |    2 
 net/core/skmsg.c                                      |   23 
 net/core/sysctl_net_core.c                            |    2 
 net/netfilter/ipset/ip_set_bitmap_ip.c                |    2 
 net/netfilter/ipset/ip_set_bitmap_ipmac.c             |    2 
 net/netfilter/ipset/ip_set_bitmap_port.c              |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                 |    4 
 net/netfilter/nf_conntrack_core.c                     |    2 
 net/qrtr/qrtr.c                                       |    6 
 net/wireless/nl80211.c                                |    3 
 sound/core/compress_offload.c                         |    4 
 sound/drivers/opl3/opl3_synth.c                       |    2 
 sound/pci/hda/hda_auto_parser.c                       |    6 
 sound/pci/hda/hda_intel.c                             |    8 
 sound/pci/hda/patch_realtek.c                         |   38 
 sound/soc/sof/sof-pci-dev.c                           |    2 
 sound/usb/pcm.c                                       |    1 
 sound/usb/quirks-table.h                              |   52 +
 tools/perf/arch/x86/util/intel-pt.c                   |    1 
 tools/perf/scripts/python/export-to-postgresql.py     |    2 
 tools/perf/scripts/python/exported-sql-viewer.py      |    7 
 tools/perf/ui/browsers/hists.c                        |   17 
 tools/perf/util/evsel.c                               |    4 
 tools/perf/util/intel-pt.c                            |    5 
 117 files changed, 1824 insertions(+), 1290 deletions(-)

Aditya Pakki (1):
      usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work

Adrian Hunter (6):
      perf intel-pt: Fix recording PEBS-via-PT with registers
      perf intel-pt: Fix PEBS sample for XMM registers
      perf scripts python: export-to-postgresql.py: Fix struct.pack() int argument
      perf scripts python: exported-sql-viewer.py: Fix zero id in call graph 'Find' result
      perf scripts python: exported-sql-viewer.py: Fix zero id in call tree 'Find' result
      perf scripts python: exported-sql-viewer.py: Fix unexpanded 'Find' result

Alexandru Elisei (1):
      KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andre Edich (2):
      smsc95xx: check return value of smsc95xx_reset
      smsc95xx: avoid memory leak in smsc95xx_bind

Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Andy Shevchenko (2):
      gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2
      gpio: pca953x: Fix GPIO resource leak on Intel Galileo Gen 2

Aneesh Kumar K.V (1):
      powerpc/kvm/book3s64: Fix kernel crash with nested kvm & DEBUG_VIRTUAL

Aya Levin (2):
      IB/mlx5: Fix 50G per lane indication
      net/mlx5e: Fix 50G per lane indication

Benjamin Poirier (1):
      ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk subdevice id

Boris Burkov (1):
      btrfs: fix fatal extent_buffer readahead vs releasepage race

Chengguang Xu (1):
      block: release bip in a right way in error path

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Ciara Loftus (2):
      ixgbe: protect ring accesses with READ- and WRITE_ONCE
      i40e: protect ring accesses with READ- and WRITE_ONCE

Codrin Ciubotariu (1):
      net: dsa: microchip: set the correct number of ports

Dan Carpenter (1):
      net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

Dany Madden (1):
      ibmvnic: continue to init in CRQ reset returns H_CLOSED

Davide Caratti (1):
      bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Divya Indi (1):
      IB/sa: Resolv use-after-free in ib_nl_make_request()

Eran Ben Elisha (1):
      net/mlx5: Fix eeprom support for SFP module

Eric Dumazet (1):
      netfilter: ipset: call ip_set_free() instead of kfree()

Greg Kroah-Hartman (2):
      Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
      Linux 5.4.52

Hans de Goede (2):
      drm: panel-orientation-quirks: Add quirk for Asus T101HA panel
      drm: panel-orientation-quirks: Use generic orientation-data for Acer S1003

Hector Martin (1):
      ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hsin-Yi Wang (1):
      drm/mediatek: Check plane visibility in atomic_update

Huazhong Tan (1):
      net: hns3: add a missing uninit debugfs when unload driver

Hui Wang (1):
      ALSA: hda - let hs_mic be picked ahead of hp_mic

Ido Schimmel (2):
      mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()
      mlxsw: pci: Fix use-after-free in case of failed devlink reload

Janosch Frank (1):
      s390/mm: fix huge pte soft dirty copying

Jens Thoms Toerring (1):
      regmap: fix alignment issue

Jian-Hong Pan (3):
      ALSA: hda/realtek - Enable audio jacks of Acer vCopperbox with ALC269VC
      ALSA: hda/realtek: Enable headset mic of Acer C20-820 with ALC269VC
      ALSA: hda/realtek: Enable headset mic of Acer Veriton N4660G with ALC269VC

John Fastabend (2):
      bpf, sockmap: RCU splat with redirect and strparser error or TLS
      bpf, sockmap: RCU dereferenced psock may be used outside RCU block

Josef Bacik (1):
      btrfs: fix double put of block group with nocow

Josh Poimboeuf (1):
      s390: Change s390_kernel_write() return type to match memcpy()

Kaike Wan (2):
      IB/hfi1: Do not destroy hfi1_wq when the device is shut down
      IB/hfi1: Do not destroy link_wq when the device is shut down

Kamal Heib (1):
      RDMA/siw: Fix reporting vendor_part_id

Kees Cook (5):
      kallsyms: Refactor kallsyms_show_value() to take cred
      module: Refactor section attr into bin attribute
      module: Do not expose section addresses to non-CAP_SYSLOG
      kprobes: Do not expose probe addresses to non-CAP_SYSLOG
      bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()

Krzysztof Kozlowski (1):
      spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer

Li Heng (1):
      net: cxgb4: fix return error value in t4_prep_fw

Linus Walleij (1):
      drm: mcde: Fix display initialization problem

Luca Coelho (1):
      nl80211: don't return err unconditionally in nl80211_start_ap()

Marek Olšák (1):
      drm/amdgpu: don't do soft recovery if gpu_recovery=0

Max Gurtovoy (1):
      nvme-rdma: assign completion vector correctly

Michal Suchanek (1):
      dm writecache: reject asynchronous pmem devices

Mikulas Patocka (1):
      dm: use noio when sending kobject event

Ming Lei (1):
      blk-mq: consider non-idle request as "inflight" in blk_mq_rq_inflight()

Neil Armstrong (1):
      mmc: meson-gx: limit segments to 1 when dram-access-quirk is needed

Nicolas Ferre (3):
      net: macb: fix wakeup test in runtime suspend/resume routines
      net: macb: mark device wake capable when "magic-packet" property present
      net: macb: fix call to pm_runtime in the suspend/resume functions

Nicolin Chen (1):
      drm/tegra: hub: Do not enable orphaned window group

Pablo Neira Ayuso (1):
      netfilter: conntrack: refetch conntrack after nf_conntrack_update()

Paolo Bonzini (1):
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Pavel Hofman (1):
      ALSA: usb-audio: Add implicit feedback quirk for RTX6001

Peng Ma (1):
      spi: spi-fsl-dspi: Adding shutdown hook

Peter Zijlstra (1):
      x86/entry: Increase entry_stack size to a full page

Pierre-Louis Bossart (2):
      ASoC: SOF: Intel: add PCI ID for CometLake-S
      ALSA: hda: Intel: add missing PCI IDs for ICL-H, TGL-H and EKL

Rahul Lakkireddy (1):
      cxgb4: fix all-mask IP address comparison

Rajat Jain (1):
      iommu/vt-d: Don't apply gfx quirks to untrusted devices

Russell King (1):
      net: mvneta: fix use of state->speed

Sascha Hauer (2):
      net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy
      net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy

Scott Wood (1):
      sched/core: Check cpus_mask, not cpus_ptr in __set_cpus_allowed_ptr(), to fix mask corruption

Sean Christopherson (2):
      KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
      KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Stephane Eranian (2):
      perf/x86/rapl: Move RAPL support to common x86 code
      perf/x86/rapl: Fix RAPL config variable bug

Steven Price (1):
      KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

Sudarsana Reddy Kalluru (1):
      qed: Populate nvm-file attributes while reading nvm config partition.

Thierry Reding (1):
      gpu: host1x: Detach driver on unregister

Tom Rix (1):
      drm/radeon: fix double free

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

Tony Lindgren (1):
      ARM: dts: omap4-droid4: Fix spi configuration and increase rate

Uwe Kleine-König (1):
      pwm: jz4740: Fix build failure

Vasily Gorbik (3):
      s390/kasan: fix early pgm check handler execution
      s390/setup: init jump labels before command line parsing
      s390/maccess: add no DAT mode to kernel_write

Vineet Gupta (2):
      ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE
      ARC: elf: use right ELF_ARCH

Vinod Koul (1):
      ALSA: compress: fix partial_drain completion state

Wei Li (2):
      perf report TUI: Fix segmentation fault in perf_evsel__hists_browse()
      arm64: kgdb: Fix single-step exception handling oops

Will Deacon (1):
      KVM: arm64: Fix definition of PAGE_HYP_DEVICE

Xiyu Yang (1):
      drm/ttm: Fix dma_fence refcnt leak when adding move fence

Yonglong Liu (1):
      net: hns3: fix use-after-free when doing self test

Zhang Xiaoxu (1):
      cifs: update ctime and mtime during truncate

Zheng Bin (1):
      nbd: Fix memory leak in nbd_add_socket

Zhenzhong Duan (2):
      spi: spidev: fix a race between spidev_release and spidev_remove
      spi: spidev: fix a potential use-after-free in spidev_release()

xidongwang (1):
      ALSA: opl3: fix infoleak in opl3

yu kuai (1):
      ARM: imx6: add missing put_device() call in imx6q_suspend_init()

