Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF762221E82
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgGPIhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 04:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgGPIhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 04:37:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33952067D;
        Thu, 16 Jul 2020 08:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594888649;
        bh=f8G0CJuyk1F1V9d93+op6iEMY65zJje51rvWTy7e8Is=;
        h=From:To:Cc:Subject:Date:From;
        b=v8DPTknnPedzZ5xOQ3hwhbcJGux+EPJGGBqq6y5WGGLpvEfU7y1CnIlxPntFZ71Ka
         97qaBr2Gmy9dMmBZmjCrhVhL/3kV9VLhKtkliiaJXfGZi4AmWfh/N8KizBLHK630Me
         iqD/93TOqXgj9CQOvmMakD+87YP9LHiSyfNPeI4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.9
Date:   Thu, 16 Jul 2020 10:37:22 +0200
Message-Id: <159488864113460@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.9 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/arc/include/asm/elf.h                                          |    2 
 arch/arc/kernel/entry.S                                             |   16 
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi                      |    4 
 arch/arm/mach-imx/pm-imx6.c                                         |   10 
 arch/arm64/include/asm/arch_gicv3.h                                 |    2 
 arch/arm64/include/asm/arch_timer.h                                 |    1 
 arch/arm64/include/asm/cpufeature.h                                 |    2 
 arch/arm64/include/asm/pgtable-prot.h                               |    2 
 arch/arm64/include/asm/vdso/clocksource.h                           |    7 
 arch/arm64/include/asm/vdso/compat_gettimeofday.h                   |    8 
 arch/arm64/kernel/cpu_errata.c                                      |    2 
 arch/arm64/kernel/cpufeature.c                                      |    2 
 arch/arm64/kernel/kgdb.c                                            |    2 
 arch/arm64/kvm/hyp-init.S                                           |   11 
 arch/arm64/kvm/reset.c                                              |   10 
 arch/powerpc/kernel/exceptions-64s.S                                |    2 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                              |    3 
 arch/s390/include/asm/kvm_host.h                                    |    8 
 arch/s390/include/asm/uaccess.h                                     |    2 
 arch/s390/kernel/early.c                                            |    2 
 arch/s390/kernel/setup.c                                            |    1 
 arch/s390/mm/hugetlbpage.c                                          |    2 
 arch/s390/mm/maccess.c                                              |   19 
 arch/x86/events/Kconfig                                             |    6 
 arch/x86/events/Makefile                                            |    1 
 arch/x86/events/intel/Makefile                                      |    2 
 arch/x86/events/intel/rapl.c                                        |  800 ---------
 arch/x86/events/rapl.c                                              |  803 ++++++++++
 arch/x86/include/asm/processor.h                                    |    2 
 arch/x86/kvm/kvm_cache_regs.h                                       |    2 
 arch/x86/kvm/mmu/mmu.c                                              |    2 
 arch/x86/kvm/vmx/vmx.c                                              |    2 
 arch/x86/kvm/x86.c                                                  |    2 
 block/bio-integrity.c                                               |   23 
 block/blk-mq.c                                                      |    4 
 drivers/base/regmap/regmap.c                                        |  100 -
 drivers/block/nbd.c                                                 |   25 
 drivers/clocksource/arm_arch_timer.c                                |   11 
 drivers/gpio/gpio-pca953x.c                                         |   98 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                             |   63 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                      |   14 
 drivers/gpu/drm/i915/gt/intel_context.c                             |   12 
 drivers/gpu/drm/i915/i915_debugfs.c                                 |    2 
 drivers/gpu/drm/i915/i915_vma.c                                     |   15 
 drivers/gpu/drm/mcde/mcde_drv.c                                     |    3 
 drivers/gpu/drm/mediatek/mtk_drm_plane.c                            |   25 
 drivers/gpu/drm/meson/meson_registers.h                             |    6 
 drivers/gpu/drm/meson/meson_viu.c                                   |   11 
 drivers/gpu/drm/radeon/ci_dpm.c                                     |    7 
 drivers/gpu/drm/tegra/hub.c                                         |    8 
 drivers/gpu/drm/ttm/ttm_bo.c                                        |    4 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                                     |    2 
 drivers/gpu/host1x/bus.c                                            |    9 
 drivers/gpu/host1x/dev.c                                            |    5 
 drivers/infiniband/core/sa_query.c                                  |   38 
 drivers/infiniband/hw/hfi1/init.c                                   |   37 
 drivers/infiniband/hw/hfi1/qp.c                                     |    5 
 drivers/infiniband/hw/hfi1/tid_rdma.c                               |    5 
 drivers/infiniband/hw/mlx5/main.c                                   |    2 
 drivers/infiniband/sw/siw/siw_main.c                                |    3 
 drivers/iommu/intel-iommu.c                                         |   37 
 drivers/irqchip/irq-gic-v3-its.c                                    |    8 
 drivers/md/dm-writecache.c                                          |    6 
 drivers/md/dm.c                                                     |   15 
 drivers/message/fusion/mptscsih.c                                   |    4 
 drivers/mmc/host/meson-gx-mmc.c                                     |    6 
 drivers/mmc/host/owl-mmc.c                                          |    2 
 drivers/mtd/mtdcore.c                                               |    4 
 drivers/net/dsa/microchip/ksz8795.c                                 |    3 
 drivers/net/dsa/microchip/ksz9477.c                                 |    3 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c          |    4 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                     |    2 
 drivers/net/ethernet/cadence/macb_main.c                            |   31 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                   |   10 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                          |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                     |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c                  |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |    5 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    9 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   29 
 drivers/net/ethernet/intel/ice/ice_lib.c                            |    8 
 drivers/net/ethernet/intel/ice/ice_main.c                           |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                        |   12 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                       |   14 
 drivers/net/ethernet/marvell/mvneta.c                               |   88 -
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c                   |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c                  |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c                |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                   |   15 
 drivers/net/ethernet/mellanox/mlx5/core/port.c                      |   93 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c                           |   54 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c               |    2 
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c                 |   52 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                     |   17 
 drivers/net/ethernet/pensando/ionic/ionic_lif.h                     |    4 
 drivers/net/ethernet/qlogic/qed/qed.h                               |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                         |   17 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                           |   12 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                           |    7 
 drivers/net/ethernet/qlogic/qed/qed_mcp.h                           |    7 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c                  |   18 
 drivers/net/ipa/ipa_data-sdm845.c                                   |    1 
 drivers/net/ipa/ipa_qmi_msg.c                                       |    6 
 drivers/net/usb/smsc95xx.c                                          |    9 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   48 
 drivers/net/wireless/ath/ath9k/hif_usb.h                            |    5 
 drivers/nvme/host/rdma.c                                            |    2 
 drivers/pinctrl/intel/pinctrl-baytrail.c                            |   67 
 drivers/scsi/qla2xxx/qla_attr.c                                     |   30 
 drivers/scsi/qla2xxx/qla_def.h                                      |   13 
 drivers/scsi/qla2xxx/qla_gbl.h                                      |    3 
 drivers/scsi/qla2xxx/qla_init.c                                     |    2 
 drivers/scsi/qla2xxx/qla_isr.c                                      |   54 
 drivers/scsi/qla2xxx/qla_os.c                                       |    6 
 drivers/scsi/qla2xxx/qla_tmpl.c                                     |  121 +
 drivers/spi/spi-fsl-dspi.c                                          |   34 
 drivers/spi/spidev.c                                                |   24 
 drivers/staging/wfx/hif_tx.c                                        |    6 
 drivers/staging/wfx/hif_tx.h                                        |    2 
 drivers/staging/wfx/scan.c                                          |    6 
 drivers/usb/dwc3/dwc3-pci.c                                         |    4 
 fs/btrfs/discard.c                                                  |    1 
 fs/btrfs/disk-io.c                                                  |    6 
 fs/btrfs/extent_io.c                                                |   40 
 fs/btrfs/inode.c                                                    |    9 
 fs/btrfs/space-info.c                                               |    2 
 fs/cifs/inode.c                                                     |    9 
 fs/cifs/ioctl.c                                                     |    9 
 fs/cifs/smb2misc.c                                                  |    8 
 fs/cifs/smb2ops.c                                                   |    2 
 fs/io_uring.c                                                       |   20 
 fs/nfs/nfs4namespace.c                                              |    1 
 include/linux/btf.h                                                 |    5 
 include/linux/filter.h                                              |    4 
 include/linux/kallsyms.h                                            |    5 
 include/sound/compress_driver.h                                     |   10 
 kernel/bpf/btf.c                                                    |    4 
 kernel/bpf/syscall.c                                                |   32 
 kernel/kallsyms.c                                                   |   17 
 kernel/kprobes.c                                                    |    4 
 kernel/module.c                                                     |   51 
 kernel/sched/core.c                                                 |    2 
 net/core/skmsg.c                                                    |   23 
 net/core/sysctl_net_core.c                                          |    2 
 net/mac80211/tx.c                                                   |    2 
 net/netfilter/ipset/ip_set_bitmap_ip.c                              |    2 
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                           |    2 
 net/netfilter/ipset/ip_set_bitmap_port.c                            |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                               |    4 
 net/netfilter/nf_conntrack_core.c                                   |    2 
 net/qrtr/qrtr.c                                                     |    6 
 net/sunrpc/xprtrdma/verbs.c                                         |   33 
 net/wireless/nl80211.c                                              |    5 
 sound/core/compress_offload.c                                       |    4 
 sound/drivers/opl3/opl3_synth.c                                     |    2 
 sound/pci/hda/hda_auto_parser.c                                     |    6 
 sound/pci/hda/hda_intel.c                                           |    8 
 sound/pci/hda/patch_realtek.c                                       |   38 
 sound/soc/codecs/hdac_hda.c                                         |   16 
 sound/soc/fsl/fsl_mqs.c                                             |   23 
 sound/soc/sof/sof-pci-dev.c                                         |    2 
 sound/usb/pcm.c                                                     |    1 
 sound/usb/quirks-table.h                                            |   52 
 tools/perf/arch/x86/util/intel-pt.c                                 |    1 
 tools/perf/scripts/python/export-to-postgresql.py                   |    2 
 tools/perf/scripts/python/exported-sql-viewer.py                    |   11 
 tools/perf/ui/browsers/hists.c                                      |   17 
 tools/perf/util/evsel.c                                             |    4 
 tools/perf/util/intel-pt.c                                          |    5 
 tools/testing/selftests/bpf/test_maps.c                             |   12 
 virt/kvm/arm/vgic/vgic-v4.c                                         |    8 
 176 files changed, 2409 insertions(+), 1512 deletions(-)

Aditya Pakki (1):
      usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work

Adrian Hunter (7):
      perf intel-pt: Fix recording PEBS-via-PT with registers
      perf intel-pt: Fix PEBS sample for XMM registers
      perf scripts python: export-to-postgresql.py: Fix struct.pack() int argument
      perf scripts python: exported-sql-viewer.py: Fix zero id in call graph 'Find' result
      perf scripts python: exported-sql-viewer.py: Fix zero id in call tree 'Find' result
      perf scripts python: exported-sql-viewer.py: Fix unexpanded 'Find' result
      perf scripts python: exported-sql-viewer.py: Fix time chart call tree

Alex Elder (2):
      net: ipa: no checksum offload for SDM845 LAN RX
      net: ipa: fix QMI structure definition bugs

Alexander Lobakin (1):
      net: qed: fix buffer overflow on ethtool -d

Alexandru Elisei (1):
      KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andre Edich (2):
      smsc95xx: check return value of smsc95xx_reset
      smsc95xx: avoid memory leak in smsc95xx_bind

Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Andy Shevchenko (4):
      gpio: pca953x: Synchronize interrupt handler properly
      gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2
      gpio: pca953x: Fix direction setting when configure an IRQ
      gpio: pca953x: Fix GPIO resource leak on Intel Galileo Gen 2

Aneesh Kumar K.V (1):
      powerpc/kvm/book3s64: Fix kernel crash with nested kvm & DEBUG_VIRTUAL

Arun Easi (1):
      scsi: qla2xxx: Fix MPI failure AEN (8200) handling

Aya Levin (4):
      IB/mlx5: Fix 50G per lane indication
      net/mlx5e: Fix VXLAN configuration restore after function reload
      net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
      net/mlx5e: Fix 50G per lane indication

Benjamin Poirier (1):
      ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk subdevice id

Boris Burkov (1):
      btrfs: fix fatal extent_buffer readahead vs releasepage race

Chengguang Xu (1):
      block: release bip in a right way in error path

Chris Wilson (4):
      drm/i915/gt: Pin the rings before marking active
      drm/i915: Skip stale object handle for debugfs per-file-stats
      drm/i915: Drop vm.ref for duplicate vma on construction
      drm/i915: Also drop vm.ref along error paths for vma construction

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Christophe JAILLET (1):
      gpu: host1x: Clean up debugfs in error handling path

Chuck Lever (1):
      xprtrdma: Prevent dereferencing r_xprt->rx_ep after it is freed

Ciara Loftus (3):
      ixgbe: protect ring accesses with READ- and WRITE_ONCE
      i40e: protect ring accesses with READ- and WRITE_ONCE
      ice: protect ring accesses with WRITE_ONCE

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

Dmitry Bogdanov (1):
      net: atlantic: fix ip dst and ipv6 address filters

Eli Britstein (1):
      net/mlx5e: CT: Fix memory leak in cleanup

Eran Ben Elisha (1):
      net/mlx5: Fix eeprom support for SFP module

Eric Dumazet (1):
      netfilter: ipset: call ip_set_free() instead of kfree()

Filipe Manana (1):
      btrfs: fix reclaim_size counter leak after stealing from global reserve

Greg Kroah-Hartman (2):
      Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
      Linux 5.7.9

Hans de Goede (3):
      drm: panel-orientation-quirks: Add quirk for Asus T101HA panel
      drm: panel-orientation-quirks: Use generic orientation-data for Acer S1003
      pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)

Hector Martin (1):
      ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hsin-Yi Wang (1):
      drm/mediatek: Check plane visibility in atomic_update

Huang Rui (2):
      drm/amdgpu: add TMR destory function for psp
      drm/amdgpu: asd function needs to be unloaded in suspend phase

Huazhong Tan (3):
      net: hns3: check reset pending after FLR prepare
      net: hns3: fix for mishandle of asserting VF reset fail
      net: hns3: add a missing uninit debugfs when unload driver

Hui Wang (1):
      ALSA: hda - let hs_mic be picked ahead of hp_mic

Ido Schimmel (2):
      mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()
      mlxsw: pci: Fix use-after-free in case of failed devlink reload

Janosch Frank (1):
      s390/mm: fix huge pte soft dirty copying

Jens Axboe (1):
      io_uring: account user memory freed when exit has been queued

Jens Thoms Toerring (1):
      regmap: fix alignment issue

Jian-Hong Pan (3):
      ALSA: hda/realtek - Enable audio jacks of Acer vCopperbox with ALC269VC
      ALSA: hda/realtek: Enable headset mic of Acer C20-820 with ALC269VC
      ALSA: hda/realtek: Enable headset mic of Acer Veriton N4660G with ALC269VC

John Fastabend (3):
      bpf: Do not allow btf_ctx_access with __int128 types
      bpf, sockmap: RCU splat with redirect and strparser error or TLS
      bpf, sockmap: RCU dereferenced psock may be used outside RCU block

Josef Bacik (2):
      btrfs: reset tree root pointer after error in init_tree_roots
      btrfs: fix double put of block group with nocow

Josh Poimboeuf (1):
      s390: Change s390_kernel_write() return type to match memcpy()

Jérôme Pouiller (1):
      staging: wfx: fix coherency of hif_scan() prototype

Kaike Wan (2):
      IB/hfi1: Do not destroy hfi1_wq when the device is shut down
      IB/hfi1: Do not destroy link_wq when the device is shut down

Kamal Dasu (1):
      mtd: set master partition panic write flag

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

Lorenz Bauer (1):
      selftests: bpf: Fix detach from sockmap tests

Luca Coelho (2):
      nl80211: don't return err unconditionally in nl80211_start_ap()
      nl80211: fix memory leak when parsing NL80211_ATTR_HE_BSS_COLOR

Manivannan Sadhasivam (1):
      mmc: owl-mmc: Get rid of of_match_ptr() macro

Marc Zyngier (4):
      KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
      arm64: Introduce a way to disable the 32bit vdso
      arm64: arch_timer: Allow an workaround descriptor to disable compat vdso
      arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040

Marek Olšák (1):
      drm/amdgpu: don't do soft recovery if gpu_recovery=0

Martin Blumenstingl (1):
      drm/meson: viu: fix setting the OSD burst length in VIU_OSD1_FIFO_CTRL_STAT

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

Nicholas Piggin (1):
      powerpc/64s/exception: Fix 0x1500 interrupt handler crash

Nicolas Ferre (5):
      net: macb: fix wakeup test in runtime suspend/resume routines
      net: macb: mark device wake capable when "magic-packet" property present
      net: macb: fix macb_get/set_wol() when moving to phylink
      net: macb: fix macb_suspend() by removing call to netif_carrier_off()
      net: macb: fix call to pm_runtime in the suspend/resume functions

Nicolin Chen (1):
      drm/tegra: hub: Do not enable orphaned window group

Pablo Neira Ayuso (1):
      netfilter: conntrack: refetch conntrack after nf_conntrack_update()

Paolo Bonzini (1):
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Pavel Begunkov (1):
      io_uring: fix missing msg_name assignment

Pavel Hofman (1):
      ALSA: usb-audio: Add implicit feedback quirk for RTX6001

Peng Ma (1):
      spi: spi-fsl-dspi: Adding shutdown hook

Peter Zijlstra (1):
      x86/entry: Increase entry_stack size to a full page

Pierre-Louis Bossart (3):
      ASoC: SOF: Intel: add PCI ID for CometLake-S
      ASoC: hdac_hda: fix memleak with regmap not freed on remove
      ALSA: hda: Intel: add missing PCI IDs for ICL-H, TGL-H and EKL

Qu Wenruo (1):
      btrfs: discard: add missing put when grabbing block group from unused list

Rahul Lakkireddy (1):
      cxgb4: fix all-mask IP address comparison

Rajat Jain (1):
      iommu/vt-d: Don't apply gfx quirks to untrusted devices

Ronnie Sahlberg (1):
      cifs: fix reference leak for tlink

Russell King (1):
      net: mvneta: fix use of state->speed

Sai Prakash Ranjan (2):
      arm64: kpti: Add KRYO{3, 4}XX silver CPU cores to kpti safelist
      arm64: Add KRYO{3,4}XX silver CPU cores to SSB safelist

Sascha Hauer (2):
      net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy
      net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy

Scott Wood (1):
      sched/core: Check cpus_mask, not cpus_ptr in __set_cpus_allowed_ptr(), to fix mask corruption

Sean Christopherson (2):
      KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
      KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Seevalamuthu Mariappan (1):
      mac80211: Fix dropping broadcast packets in 802.11 encap

Shannon Nelson (1):
      ionic: centralize queue reset code

Shengjiu Wang (2):
      ASoC: fsl_mqs: Don't check clock is NULL before calling clk API
      ASoC: fsl_mqs: Fix unchecked return value for clk_prepare_enable

Stephane Eranian (2):
      perf/x86/rapl: Move RAPL support to common x86 code
      perf/x86/rapl: Fix RAPL config variable bug

Steve French (2):
      smb3: fix access denied on change notify request to some servers
      smb3: fix unneeded error message on change notify

Steven Price (1):
      KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

Sudarsana Reddy Kalluru (1):
      qed: Populate nvm-file attributes while reading nvm config partition.

Taehee Yoo (2):
      net: rmnet: fix lower interface leak
      net: rmnet: do not allow to add multiple bridge interfaces

Thierry Reding (1):
      gpu: host1x: Detach driver on unregister

Tom Rix (2):
      nfs: Fix memory leak of export_path
      drm/radeon: fix double free

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

Tony Lindgren (1):
      ARM: dts: omap4-droid4: Fix spi configuration and increase rate

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

Xiyu Yang (2):
      drm/ttm: Fix dma_fence refcnt leak in ttm_bo_vm_fault_reserved
      drm/ttm: Fix dma_fence refcnt leak when adding move fence

Yang Yingliang (2):
      io_uring: fix memleak in __io_sqe_files_update()
      io_uring: fix memleak in io_sqe_files_register()

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

