Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424052802EE
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732688AbgJAPgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbgJAPgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 11:36:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C957206C1;
        Thu,  1 Oct 2020 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601566567;
        bh=H6oA41gHQj+3KGiaGpgcOcqwQ/7aDkr2rKx2Ym4bCeg=;
        h=From:To:Cc:Subject:Date:From;
        b=fngRven08Z0cUUX4mdiYRowaST6UmKsXnEhltaRD4fAUuj8SeCxSqSJHtt4y3qUPJ
         ABUIdb79/RoVseMKFf3Pj5PcN/DP6vKeGlCspqS4/jOTH9OinAc9Gz3SdSGfKcoRjA
         OymGAFStZQCVmBrdrmN0bdXD5k3KRNB4Uuog0qQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.69
Date:   Thu,  1 Oct 2020 17:35:56 +0200
Message-Id: <1601566555156100@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.69 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/wm8994.txt               |   18 
 Documentation/driver-api/libata.rst                              |    2 
 Makefile                                                         |    2 
 arch/arm/include/asm/kvm_emulate.h                               |   11 
 arch/arm/kernel/stacktrace.c                                     |    2 
 arch/arm/kernel/traps.c                                          |    6 
 arch/arm/mach-omap2/cpuidle34xx.c                                |    9 
 arch/arm/mach-omap2/cpuidle44xx.c                                |   26 
 arch/arm/mach-omap2/pm34xx.c                                     |    8 
 arch/arm64/include/asm/kvm_emulate.h                             |   12 
 arch/arm64/include/asm/sections.h                                |    1 
 arch/arm64/kernel/acpi.c                                         |   25 
 arch/arm64/kernel/cpufeature.c                                   |   12 
 arch/arm64/kernel/insn.c                                         |   22 
 arch/arm64/kernel/vmlinux.lds.S                                  |    3 
 arch/arm64/kvm/hyp/switch.c                                      |    2 
 arch/arm64/mm/fault.c                                            |   12 
 arch/m68k/q40/config.c                                           |    1 
 arch/mips/include/asm/cpu-type.h                                 |    1 
 arch/powerpc/include/asm/kvm_asm.h                               |    3 
 arch/powerpc/kernel/Makefile                                     |    2 
 arch/powerpc/kernel/eeh.c                                        |    2 
 arch/powerpc/kernel/traps.c                                      |    6 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                           |    5 
 arch/powerpc/kvm/book3s_hv_tm.c                                  |   28 
 arch/powerpc/kvm/book3s_hv_tm_builtin.c                          |   16 
 arch/powerpc/mm/book3s64/iommu_api.c                             |   39 
 arch/powerpc/perf/imc-pmu.c                                      |  173 +++-
 arch/riscv/include/asm/ftrace.h                                  |    7 
 arch/riscv/kernel/ftrace.c                                       |   19 
 arch/s390/include/asm/pgtable.h                                  |   44 -
 arch/s390/include/asm/stacktrace.h                               |   11 
 arch/s390/kernel/irq.c                                           |    8 
 arch/s390/kernel/perf_cpum_sf.c                                  |    9 
 arch/s390/kernel/setup.c                                         |   15 
 arch/s390/kernel/smp.c                                           |    2 
 arch/x86/include/asm/crash.h                                     |    6 
 arch/x86/include/asm/nospec-branch.h                             |    4 
 arch/x86/include/asm/pkeys.h                                     |    5 
 arch/x86/kernel/apic/io_apic.c                                   |    1 
 arch/x86/kernel/crash.c                                          |   15 
 arch/x86/kernel/fpu/xstate.c                                     |    9 
 arch/x86/kvm/emulate.c                                           |    2 
 arch/x86/kvm/lapic.c                                             |    2 
 arch/x86/kvm/mmutrace.h                                          |    2 
 arch/x86/kvm/svm.c                                               |   11 
 arch/x86/kvm/vmx/vmx.c                                           |   26 
 arch/x86/kvm/x86.c                                               |   13 
 arch/x86/lib/usercopy_64.c                                       |    2 
 arch/x86/realmode/init.c                                         |    2 
 arch/xtensa/kernel/entry.S                                       |    4 
 arch/xtensa/kernel/ptrace.c                                      |   18 
 drivers/acpi/ec.c                                                |   16 
 drivers/ata/acard-ahci.c                                         |    6 
 drivers/ata/libahci.c                                            |    6 
 drivers/ata/libata-core.c                                        |    9 
 drivers/ata/libata-sff.c                                         |   12 
 drivers/ata/pata_macio.c                                         |    6 
 drivers/ata/pata_pxa.c                                           |    8 
 drivers/ata/pdc_adma.c                                           |    7 
 drivers/ata/sata_fsl.c                                           |    4 
 drivers/ata/sata_inic162x.c                                      |    4 
 drivers/ata/sata_mv.c                                            |   34 
 drivers/ata/sata_nv.c                                            |   18 
 drivers/ata/sata_promise.c                                       |    6 
 drivers/ata/sata_qstor.c                                         |    8 
 drivers/ata/sata_rcar.c                                          |    6 
 drivers/ata/sata_sil.c                                           |    8 
 drivers/ata/sata_sil24.c                                         |    6 
 drivers/ata/sata_sx4.c                                           |    6 
 drivers/atm/eni.c                                                |    2 
 drivers/base/arch_topology.c                                     |    4 
 drivers/base/regmap/internal.h                                   |    2 
 drivers/base/regmap/regcache.c                                   |    2 
 drivers/base/regmap/regmap.c                                     |   33 
 drivers/bluetooth/btrtl.c                                        |   20 
 drivers/bus/hisi_lpc.c                                           |   27 
 drivers/char/ipmi/bt-bmc.c                                       |   12 
 drivers/char/random.c                                            |   12 
 drivers/char/tlclk.c                                             |   17 
 drivers/char/tpm/tpm_crb.c                                       |  123 ++-
 drivers/char/tpm/tpm_ibmvtpm.c                                   |    9 
 drivers/char/tpm/tpm_ibmvtpm.h                                   |    1 
 drivers/clk/imx/clk-pfdv2.c                                      |    6 
 drivers/clk/socfpga/clk-pll-s10.c                                |    4 
 drivers/clk/ti/adpll.c                                           |   11 
 drivers/clocksource/h8300_timer8.c                               |    2 
 drivers/cpufreq/powernv-cpufreq.c                                |   13 
 drivers/crypto/chelsio/chcr_algo.c                               |    5 
 drivers/crypto/chelsio/chtls/chtls_io.c                          |   10 
 drivers/dax/bus.c                                                |    2 
 drivers/dax/bus.h                                                |    2 
 drivers/dax/dax-private.h                                        |    2 
 drivers/devfreq/tegra30-devfreq.c                                |    4 
 drivers/dma-buf/dma-buf.c                                        |    2 
 drivers/dma-buf/dma-fence.c                                      |   78 -
 drivers/dma/mediatek/mtk-hsdma.c                                 |    4 
 drivers/dma/stm32-dma.c                                          |    9 
 drivers/dma/stm32-mdma.c                                         |    9 
 drivers/dma/tegra20-apb-dma.c                                    |    3 
 drivers/dma/xilinx/zynqmp_dma.c                                  |   24 
 drivers/edac/ghes_edac.c                                         |    4 
 drivers/firmware/arm_sdei.c                                      |   26 
 drivers/gpio/gpio-rcar.c                                         |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c               |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c                |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                 |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                         |   31 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                       |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c                          |   10 
 drivers/gpu/drm/amd/amdgpu/atom.c                                |    4 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                           |   58 -
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                            |   40 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                            |   40 -
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c                            |   16 
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h                   |  139 +--
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm           |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c            |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   32 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c          |    2 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                    |   67 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c                |   52 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c               |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c                |   26 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c                 |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c            |    5 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c                |   35 
 drivers/gpu/drm/amd/display/dc/inc/hw/dsc.h                      |    1 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c                 |    7 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c               |    7 
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                          |   20 
 drivers/gpu/drm/gma500/cdv_intel_display.c                       |    2 
 drivers/gpu/drm/mcde/mcde_display.c                              |   10 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                            |   27 
 drivers/gpu/drm/msm/msm_drv.c                                    |    6 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                          |    4 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                        |    5 
 drivers/gpu/drm/nouveau/nouveau_gem.c                            |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowpci.c             |   17 
 drivers/gpu/drm/omapdrm/dss/dss.c                                |   43 -
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c                  |    4 
 drivers/gpu/drm/radeon/radeon_bios.c                             |   30 
 drivers/gpu/drm/scheduler/sched_main.c                           |   27 
 drivers/gpu/drm/sun4i/sun8i_csc.h                                |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                   |    1 
 drivers/hwtracing/coresight/coresight-etm4x.c                    |    1 
 drivers/hwtracing/intel_th/intel_th.h                            |    2 
 drivers/hwtracing/intel_th/msu.c                                 |   11 
 drivers/hwtracing/intel_th/pci.c                                 |    8 
 drivers/i2c/busses/i2c-aspeed.c                                  |    2 
 drivers/i2c/busses/i2c-tegra.c                                   |   93 +-
 drivers/i2c/i2c-core-base.c                                      |    2 
 drivers/infiniband/core/cm.c                                     |   25 
 drivers/infiniband/hw/cxgb4/cm.c                                 |    4 
 drivers/infiniband/hw/i40iw/i40iw_cm.c                           |    2 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                          |    2 
 drivers/infiniband/sw/rxe/rxe.c                                  |    2 
 drivers/infiniband/sw/rxe/rxe_qp.c                               |    7 
 drivers/infiniband/ulp/iser/iser_memory.c                        |   21 
 drivers/leds/leds-mlxreg.c                                       |    4 
 drivers/md/bcache/bcache.h                                       |    1 
 drivers/md/bcache/btree.c                                        |   12 
 drivers/md/bcache/super.c                                        |    1 
 drivers/md/dm-table.c                                            |   27 
 drivers/md/dm.c                                                  |   23 
 drivers/media/dvb-frontends/tda10071.c                           |    9 
 drivers/media/i2c/smiapp/smiapp-core.c                           |    3 
 drivers/media/mc/mc-device.c                                     |   65 -
 drivers/media/platform/qcom/venus/vdec.c                         |    5 
 drivers/media/platform/ti-vpe/cal.c                              |    6 
 drivers/media/usb/go7007/go7007-usb.c                            |    4 
 drivers/mfd/mfd-core.c                                           |   10 
 drivers/mmc/core/mmc.c                                           |    9 
 drivers/mtd/chips/cfi_cmdset_0002.c                              |    1 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                       |    4 
 drivers/mtd/nand/raw/omap_elm.c                                  |    1 
 drivers/mtd/parsers/cmdlinepart.c                                |   23 
 drivers/mtd/ubi/fastmap-wl.c                                     |   46 -
 drivers/mtd/ubi/fastmap.c                                        |   14 
 drivers/mtd/ubi/ubi.h                                            |    6 
 drivers/mtd/ubi/wl.c                                             |   32 
 drivers/mtd/ubi/wl.h                                             |    1 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                 |    4 
 drivers/net/ethernet/intel/e1000/e1000_main.c                    |   18 
 drivers/net/ethernet/intel/iavf/iavf_main.c                      |    8 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                     |   14 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                        |   11 
 drivers/net/ethernet/qlogic/qed/qed_l2.c                         |    3 
 drivers/net/ethernet/qlogic/qed/qed_main.c                       |    2 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                      |    1 
 drivers/net/ethernet/qlogic/qede/qede_filter.c                   |    3 
 drivers/net/ethernet/qlogic/qede/qede_main.c                     |   11 
 drivers/net/ethernet/realtek/r8169_main.c                        |    3 
 drivers/net/ethernet/xilinx/xilinx_axienet.h                     |    2 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                |   50 -
 drivers/net/ieee802154/adf7242.c                                 |    4 
 drivers/net/ieee802154/ca8210.c                                  |    1 
 drivers/net/wireless/ath/ar5523/ar5523.c                         |    2 
 drivers/net/wireless/ath/ath10k/debug.c                          |    3 
 drivers/net/wireless/ath/ath10k/sdio.c                           |   18 
 drivers/net/wireless/ath/ath10k/wmi.c                            |   49 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c      |    3 
 drivers/net/wireless/marvell/mwifiex/fw.h                        |    2 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c               |    4 
 drivers/net/wireless/mediatek/mt76/agg-rx.c                      |    1 
 drivers/net/wireless/mediatek/mt76/dma.c                         |    9 
 drivers/net/wireless/mediatek/mt76/mac80211.c                    |   12 
 drivers/net/wireless/mediatek/mt76/mt7603/main.c                 |    2 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                 |    2 
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                |    2 
 drivers/net/wireless/ti/wlcore/main.c                            |    4 
 drivers/net/wireless/ti/wlcore/tx.c                              |    1 
 drivers/nvme/host/Kconfig                                        |    1 
 drivers/nvme/host/core.c                                         |   14 
 drivers/nvme/host/fc.c                                           |    4 
 drivers/nvme/host/multipath.c                                    |   21 
 drivers/nvme/host/nvme.h                                         |   19 
 drivers/nvme/host/pci.c                                          |    1 
 drivers/nvme/host/rdma.c                                         |    3 
 drivers/nvme/host/tcp.c                                          |    3 
 drivers/nvme/target/loop.c                                       |    3 
 drivers/nvme/target/rdma.c                                       |   30 
 drivers/opp/core.c                                               |   48 -
 drivers/opp/of.c                                                 |   30 
 drivers/opp/opp.h                                                |    6 
 drivers/pci/controller/dwc/pcie-tegra194.c                       |    5 
 drivers/pci/controller/pci-tegra.c                               |    3 
 drivers/pci/hotplug/pciehp_hpc.c                                 |   26 
 drivers/pci/iov.c                                                |    8 
 drivers/pci/rom.c                                                |   17 
 drivers/pci/setup-bus.c                                          |   38 
 drivers/phy/samsung/phy-s5pv210-usb2.c                           |    4 
 drivers/power/supply/max17040_battery.c                          |    2 
 drivers/rapidio/devices/rio_mport_cdev.c                         |   14 
 drivers/regulator/axp20x-regulator.c                             |    7 
 drivers/rtc/rtc-ds1374.c                                         |   15 
 drivers/rtc/rtc-sa1100.c                                         |   18 
 drivers/s390/block/dasd_fba.c                                    |    9 
 drivers/s390/cio/airq.c                                          |    8 
 drivers/s390/cio/cio.c                                           |    8 
 drivers/s390/crypto/zcrypt_api.c                                 |    3 
 drivers/scsi/aacraid/aachba.c                                    |    8 
 drivers/scsi/aacraid/commsup.c                                   |    2 
 drivers/scsi/aacraid/linit.c                                     |   46 -
 drivers/scsi/cxlflash/main.c                                     |    1 
 drivers/scsi/fnic/fnic_scsi.c                                    |    3 
 drivers/scsi/hpsa.c                                              |   80 +-
 drivers/scsi/libfc/fc_rport.c                                    |   13 
 drivers/scsi/lpfc/lpfc_attr.c                                    |   40 -
 drivers/scsi/lpfc/lpfc_ct.c                                      |  137 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c                                 |   76 +
 drivers/scsi/lpfc/lpfc_hw.h                                      |   36 
 drivers/scsi/lpfc/lpfc_init.c                                    |    1 
 drivers/scsi/lpfc/lpfc_nportdisc.c                               |  233 +++++
 drivers/scsi/lpfc/lpfc_sli.c                                     |    4 
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                               |    6 
 drivers/scsi/pm8001/pm8001_sas.c                                 |   50 -
 drivers/scsi/qedi/qedi_iscsi.c                                   |    3 
 drivers/scsi/qla2xxx/qla_init.c                                  |   43 -
 drivers/scsi/qla2xxx/qla_iocb.c                                  |  101 ++
 drivers/scsi/qla2xxx/qla_target.c                                |   21 
 drivers/scsi/ufs/ufshcd.c                                        |   14 
 drivers/soundwire/bus.c                                          |    2 
 drivers/soundwire/cadence_master.c                               |   80 +-
 drivers/soundwire/cadence_master.h                               |    1 
 drivers/soundwire/intel.c                                        |   14 
 drivers/staging/media/imx/imx-media-capture.c                    |    2 
 drivers/staging/rtl8188eu/core/rtw_recv.c                        |   19 
 drivers/thermal/rcar_thermal.c                                   |    6 
 drivers/tty/serial/8250/8250_omap.c                              |    8 
 drivers/tty/serial/8250/8250_port.c                              |   16 
 drivers/tty/serial/samsung.c                                     |    8 
 drivers/tty/serial/sifive.c                                      |   28 
 drivers/tty/serial/xilinx_uartps.c                               |    8 
 drivers/tty/vcc.c                                                |    1 
 drivers/usb/dwc3/gadget.c                                        |    2 
 drivers/usb/host/ehci-mv.c                                       |    8 
 drivers/vfio/pci/vfio_pci.c                                      |   13 
 fs/block_dev.c                                                   |   10 
 fs/btrfs/disk-io.c                                               |   11 
 fs/btrfs/extent-tree.c                                           |    2 
 fs/btrfs/inode.c                                                 |  201 ++---
 fs/btrfs/relocation.c                                            |   45 +
 fs/btrfs/tree-checker.c                                          |   40 -
 fs/ceph/caps.c                                                   |   14 
 fs/ceph/inode.c                                                  |    5 
 fs/cifs/cifsglob.h                                               |    9 
 fs/cifs/file.c                                                   |   21 
 fs/cifs/misc.c                                                   |   17 
 fs/cifs/smb1ops.c                                                |    8 
 fs/cifs/smb2misc.c                                               |   32 
 fs/cifs/smb2ops.c                                                |   89 +-
 fs/cifs/smb2pdu.h                                                |    2 
 fs/dcache.c                                                      |    4 
 fs/exec.c                                                        |   22 
 fs/ext4/inode.c                                                  |    2 
 fs/ext4/mballoc.c                                                |   11 
 fs/f2fs/gc.c                                                     |   10 
 fs/f2fs/node.c                                                   |    1 
 fs/fuse/dev.c                                                    |    1 
 fs/fuse/inode.c                                                  |    7 
 fs/gfs2/inode.c                                                  |   13 
 fs/iomap/buffered-io.c                                           |    7 
 fs/nfs/nfstrace.h                                                |   15 
 fs/nfs/pagelist.c                                                |   67 +
 fs/nfs/write.c                                                   |   10 
 fs/nfsd/filecache.c                                              |    8 
 fs/nfsd/nfs4state.c                                              |   73 +
 fs/nfsd/trace.h                                                  |   12 
 fs/proc/base.c                                                   |   10 
 fs/ubifs/io.c                                                    |   16 
 fs/ubifs/journal.c                                               |    1 
 fs/ubifs/orphan.c                                                |    9 
 fs/xfs/libxfs/xfs_attr_leaf.c                                    |   22 
 fs/xfs/libxfs/xfs_bmap.c                                         |   25 
 fs/xfs/libxfs/xfs_dir2_node.c                                    |    1 
 fs/xfs/libxfs/xfs_dir2_sf.c                                      |    2 
 fs/xfs/libxfs/xfs_iext_tree.c                                    |    2 
 fs/xfs/libxfs/xfs_inode_fork.c                                   |    8 
 fs/xfs/libxfs/xfs_inode_fork.h                                   |   14 
 fs/xfs/libxfs/xfs_trans_resv.c                                   |   96 +-
 fs/xfs/scrub/dir.c                                               |    3 
 fs/xfs/scrub/scrub.c                                             |    9 
 fs/xfs/xfs_bmap_util.c                                           |    8 
 fs/xfs/xfs_file.c                                                |   30 
 fs/xfs/xfs_fsmap.c                                               |    9 
 fs/xfs/xfs_ioctl.c                                               |    1 
 fs/xfs/xfs_trans.c                                               |    5 
 include/asm-generic/pgtable.h                                    |   10 
 include/linux/binfmts.h                                          |    8 
 include/linux/debugfs.h                                          |    5 
 include/linux/kprobes.h                                          |    5 
 include/linux/libata.h                                           |   13 
 include/linux/mmc/card.h                                         |    2 
 include/linux/nfs_page.h                                         |    2 
 include/linux/pci.h                                              |    1 
 include/linux/qed/qed_if.h                                       |    1 
 include/linux/sched/signal.h                                     |    9 
 include/linux/seqlock.h                                          |   11 
 include/linux/skbuff.h                                           |   14 
 include/linux/sunrpc/svc_rdma.h                                  |    5 
 include/net/sock.h                                               |    4 
 include/sound/hda_codec.h                                        |    5 
 include/trace/events/sctp.h                                      |    9 
 include/trace/events/sunrpc.h                                    |    1 
 init/init_task.c                                                 |    1 
 init/main.c                                                      |    2 
 kernel/Makefile                                                  |    2 
 kernel/audit_watch.c                                             |    2 
 kernel/bpf/hashtab.c                                             |    8 
 kernel/bpf/inode.c                                               |    4 
 kernel/events/core.c                                             |   12 
 kernel/fork.c                                                    |    5 
 kernel/kcmp.c                                                    |    8 
 kernel/kprobes.c                                                 |   44 -
 kernel/locking/lockdep.c                                         |   40 -
 kernel/locking/lockdep_internals.h                               |    6 
 kernel/notifier.c                                                |    5 
 kernel/printk/printk.c                                           |    3 
 kernel/sched/core.c                                              |    3 
 kernel/sched/fair.c                                              |   79 +-
 kernel/sys.c                                                     |    4 
 kernel/sysctl-test.c                                             |  392 ++++++++++
 kernel/time/timekeeping.c                                        |    3 
 kernel/trace/trace.c                                             |   20 
 kernel/trace/trace_entries.h                                     |    2 
 kernel/trace/trace_events.c                                      |    2 
 kernel/trace/trace_events_hist.c                                 |    1 
 kernel/trace/trace_preemptirq.c                                  |    4 
 kernel/workqueue.c                                               |    6 
 lib/Kconfig.debug                                                |   11 
 lib/string.c                                                     |   24 
 mm/filemap.c                                                     |    8 
 mm/gup.c                                                         |   18 
 mm/kmemleak.c                                                    |    2 
 mm/madvise.c                                                     |    2 
 mm/memcontrol.c                                                  |   26 
 mm/memory.c                                                      |  121 ++-
 mm/mmap.c                                                        |    2 
 mm/pagewalk.c                                                    |    4 
 mm/slub.c                                                        |   45 -
 mm/swap_state.c                                                  |    5 
 mm/swapfile.c                                                    |   12 
 mm/vmscan.c                                                      |   45 -
 net/atm/lec.c                                                    |    6 
 net/atm/proc.c                                                   |    3 
 net/batman-adv/bridge_loop_avoidance.c                           |  145 ++-
 net/batman-adv/bridge_loop_avoidance.h                           |    4 
 net/batman-adv/multicast.c                                       |   46 -
 net/batman-adv/multicast.h                                       |   15 
 net/batman-adv/routing.c                                         |    4 
 net/batman-adv/soft-interface.c                                  |   11 
 net/bluetooth/hci_event.c                                        |   25 
 net/bluetooth/l2cap_core.c                                       |   29 
 net/bluetooth/l2cap_sock.c                                       |   18 
 net/core/devlink.c                                               |    7 
 net/core/filter.c                                                |    4 
 net/core/neighbour.c                                             |    1 
 net/ipv4/route.c                                                 |    1 
 net/ipv4/tcp.c                                                   |    2 
 net/ipv6/ip6_fib.c                                               |    7 
 net/llc/af_llc.c                                                 |    2 
 net/mac80211/tx.c                                                |    6 
 net/mac802154/tx.c                                               |    8 
 net/netfilter/nf_conntrack_proto.c                               |    2 
 net/netfilter/nf_tables_api.c                                    |    3 
 net/openvswitch/meter.c                                          |    4 
 net/openvswitch/meter.h                                          |    2 
 net/sctp/outqueue.c                                              |    6 
 net/sunrpc/sched.c                                               |   20 
 net/sunrpc/svc_xprt.c                                            |   19 
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c                       |   39 
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                          |   11 
 net/tipc/socket.c                                                |   53 -
 net/tipc/topsrv.c                                                |    4 
 net/unix/af_unix.c                                               |   11 
 net/wireless/Kconfig                                             |    1 
 security/device_cgroup.c                                         |    3 
 security/selinux/hooks.c                                         |   12 
 security/selinux/selinuxfs.c                                     |    1 
 sound/hda/hdac_bus.c                                             |    4 
 sound/hda/hdac_regmap.c                                          |    1 
 sound/pci/asihpi/hpioctl.c                                       |    4 
 sound/pci/hda/hda_codec.c                                        |   28 
 sound/pci/hda/hda_controller.c                                   |   11 
 sound/pci/hda/hda_controller.h                                   |    2 
 sound/pci/hda/hda_intel.c                                        |   40 -
 sound/pci/hda/patch_realtek.c                                    |   13 
 sound/soc/codecs/max98090.c                                      |    8 
 sound/soc/codecs/pcm3168a.c                                      |    7 
 sound/soc/codecs/wm8994.c                                        |   10 
 sound/soc/codecs/wm_hubs.c                                       |    3 
 sound/soc/codecs/wm_hubs.h                                       |    1 
 sound/soc/img/img-i2s-out.c                                      |    8 
 sound/soc/intel/boards/bytcr_rt5640.c                            |   10 
 sound/soc/kirkwood/kirkwood-dma.c                                |    2 
 sound/soc/sof/ipc.c                                              |   12 
 sound/usb/midi.c                                                 |   29 
 sound/usb/mixer.c                                                |   10 
 sound/usb/quirks.c                                               |    7 
 tools/gpio/gpio-hammer.c                                         |   17 
 tools/objtool/check.c                                            |    2 
 tools/perf/builtin-stat.c                                        |    2 
 tools/perf/pmu-events/jevents.c                                  |   15 
 tools/perf/tests/shell/lib/probe_vfs_getname.sh                  |    2 
 tools/perf/tests/shell/record+zstd_comp_decomp.sh                |    3 
 tools/perf/trace/beauty/arch_errno_names.sh                      |    2 
 tools/perf/util/cpumap.c                                         |   10 
 tools/perf/util/cs-etm.c                                         |  126 ++-
 tools/perf/util/evsel.c                                          |    7 
 tools/perf/util/mem2node.c                                       |    3 
 tools/perf/util/metricgroup.c                                    |    3 
 tools/perf/util/parse-events.c                                   |    9 
 tools/perf/util/sort.c                                           |    2 
 tools/perf/util/symbol-elf.c                                     |    7 
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py       |   22 
 tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c             |    1 
 tools/testing/selftests/bpf/test_tcpbpf.h                        |    1 
 tools/testing/selftests/bpf/test_tcpbpf_user.c                   |   25 
 tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc |    2 
 tools/testing/selftests/ptrace/Makefile                          |    4 
 tools/testing/selftests/ptrace/vmaccess.c                        |   86 ++
 tools/testing/selftests/x86/syscall_nt.c                         |    1 
 virt/kvm/arm/mmio.c                                              |    2 
 virt/kvm/arm/mmu.c                                               |    2 
 virt/kvm/arm/vgic/vgic-init.c                                    |   11 
 virt/kvm/arm/vgic/vgic-its.c                                     |   11 
 virt/kvm/kvm_main.c                                              |    1 
 469 files changed, 5173 insertions(+), 2466 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Fix module map when there are no modules loaded

Al Viro (1):
      fix dget_parent() fastpath race

Alain Michaud (1):
      Bluetooth: guard against controllers sending zero'd events

Alex Deucher (2):
      drm/amdgpu/powerplay: fix AVFS handling with custom powerplay table
      drm/amdgpu/powerplay/smu7: fix AVFS handling with custom powerplay table

Alex Williamson (1):
      vfio/pci: Clear error and request eventfd ctx after releasing

Alexander Duyck (1):
      e1000: Do not perform reset in reset_task if we are already down

Alexander Shishkin (1):
      intel_th: Disallow multi mode on devices where it's broken

Alexandre Belloni (2):
      rtc: sa1100: fix possible race condition
      rtc: ds1374: fix possible race condition

Alexey Kardashevskiy (1):
      powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()

Amelie Delaunay (2):
      dmaengine: stm32-mdma: use vchan_terminate_vdesc() in .terminate_all
      dmaengine: stm32-dma: use vchan_terminate_vdesc() in .terminate_all

Amol Grover (1):
      device_cgroup: Fix RCU list debugging warning

Andre Przywara (2):
      net: axienet: Convert DMA error handler to a work queue
      net: axienet: Propagate failure of DMA descriptor setup

Andreas Gruenbacher (1):
      iomap: Fix overflow in iomap_page_mkwrite

Andreas Steinmetz (1):
      ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Andrey Grodzovsky (1):
      drm/scheduler: Avoid accessing freed bad job.

Andy Lutomirski (1):
      selftests/x86/syscall_nt: Clear weird flags after each test

Anju T Sudhakar (1):
      powerpc/perf: Implement a global lock to avoid races between trace, core and thread imc events.

Anshuman Khandual (1):
      arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register

Anson Huang (1):
      clk: imx: Fix division by zero warning on pfdv2

Anthony Iliopoulos (1):
      nvme: explicitly update mpath disk capacity on revalidation

Aric Cyr (1):
      drm/amd/display: dal_ddc_i2c_payloads_create can fail causing panic

Arnd Bergmann (1):
      mt76: fix LED link time failure

Aya Levin (1):
      devlink: Fix reporter's recovery condition

Ayush Sawal (1):
      crypto: chelsio - This fixes the kernel panic which occurs during a libkcapi test

Balsundar P (1):
      scsi: aacraid: fix illegal IO beyond last LBA

Bart Van Assche (3):
      scsi: ufs: Make ufshcd_add_command_trace() easier to read
      scsi: ufs: Fix a race condition in the tracing code
      RDMA/rxe: Fix configuration of atomic queue pair attributes

Bernd Edlinger (6):
      exec: Fix a deadlock in strace
      selftests/ptrace: add test cases for dead-locks
      kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
      proc: Use new infrastructure to fix deadlocks in execve
      proc: io_accounting: Use new infrastructure to fix deadlocks in execve
      perf: Use new infrastructure to fix deadlocks in execve

Bob Peterson (1):
      gfs2: clean up iopen glock mess in gfs2_create_inode

Boris Brezillon (1):
      mtd: parser: cmdline: Support MTD names containing one or more colons

Borislav Petkov (1):
      EDAC/ghes: Check whether the driver is on the safe list correctly

Bradley Bolen (1):
      mmc: core: Fix size overflow for mmc partitions

Brian Foster (1):
      xfs: fix attr leaf header freemap.size underflow

Charan Teja Reddy (1):
      dmabuf: fix NULL pointer dereference in dma_buf_release()

Chris Wilson (1):
      dma-fence: Serialise signal enabling (dma_fence_enable_sw_signaling)

Christian Borntraeger (1):
      s390/zcrypt: Fix ZCRYPT_PERDEV_REQCNT ioctl

Christophe JAILLET (5):
      RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'
      perf cpumap: Fix snprintf overflow check
      SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'
      scsi: aacraid: Fix error handling paths in aac_probe_one()
      drm/exynos: dsi: Remove bridge node reference in error handling path in probe function

Chuck Lever (4):
      SUNRPC: Capture completion of all RPC tasks
      svcrdma: Fix leak of transport addresses
      svcrdma: Fix backchannel return code
      NFS: nfs_xdr_status should record the procedure name

Colin Ian King (2):
      media: tda10071: fix unsigned sign extension overflow
      USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Cong Wang (1):
      atm: fix a memory leak of vcc->user_back

Dan Carpenter (1):
      media: staging/imx: Missing assignment in imx_media_capture_device_register()

Dan Williams (1):
      dax: Fix alloc_dax_region() compile warning

Daniel Borkmann (1):
      bpf: Fix clobbering of r2 in bpf_gen_ld_abs

Darrick J. Wong (4):
      xfs: fix log reservation overflows when allocating large rt extents
      xfs: don't ever return a stale pointer from __xfs_dir3_free_read
      xfs: mark dir corrupt when lookup-by-hash fails
      xfs: prohibit fs freezing when using empty transactions

Dave Chinner (2):
      xfs: fix inode fork extent count overflow
      xfs: properly serialise fallocate against AIO+DIO

Dave Hansen (1):
      x86/pkeys: Add check for pkey "overflow"

David Francis (1):
      drm/amd/display: Initialize DSC PPS variables to 0

David Sterba (1):
      btrfs: don't force read-only after error in drop snapshot

Dennis Li (1):
      drm/amdkfd: fix a memory leak issue

Dinghao Liu (11):
      drm/nouveau/debugfs: fix runtime pm imbalance on error
      drm/nouveau: fix runtime pm imbalance on error
      drm/nouveau/dispnv50: fix runtime pm imbalance on error
      gpio: rcar: Fix runtime PM imbalance on error
      PCI: tegra194: Fix runtime PM imbalance on error
      ASoC: img-i2s-out: Fix runtime PM imbalance on error
      wlcore: fix runtime pm imbalance in wl1271_tx_work
      wlcore: fix runtime pm imbalance in wlcore_regdomain_config
      mtd: rawnand: gpmi: Fix runtime PM imbalance on error
      mtd: rawnand: omap_elm: Fix runtime PM imbalance on error
      PCI: tegra: Fix runtime PM imbalance on error

Dinh Nguyen (1):
      clk: stratix10: use do_div() for 64-bit calculation

Divya Indi (2):
      tracing: Verify if trace array exists before destroying it.
      tracing: Adding NULL checks for trace_array descriptor pointer

Dmitry Baryshkov (2):
      regmap: fix page selection for noinc reads
      regmap: fix page selection for noinc writes

Dmitry Bogdanov (3):
      net: qed: Disable aRFS for NPAR and 100G
      net: qede: Disable aRFS for NPAR and 100G
      net: qed: RDMA personality shouldn't fail VF load

Dmitry Monakhov (1):
      ext4: mark block bitmap corrupted when found instead of BUGON

Dmitry Osipenko (3):
      PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out
      i2c: tegra: Prevent interrupt triggering after transfer timeout
      dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Don Brace (1):
      scsi: hpsa: correct race condition in offload enabled

Doug Smythies (1):
      tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility

Douglas Anderson (1):
      bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Eddie James (1):
      i2c: aspeed: Mask IRQ status to relevant bits

Eelco Chaudron (1):
      netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled

Eric Dumazet (2):
      net: silence data-races on sk_backlog.tail
      mac802154: tx: fix use-after-free

Eric W. Biederman (1):
      exec: Add exec_update_mutex to replace cred_guard_mutex

Felix Fietkau (4):
      mt76: do not use devm API for led classdev
      mt76: add missing locking around ampdu action
      mt76: clear skb pointers from rx aggregation reorder buffer during cleanup
      mt76: fix handling full tx queues in mt76_dma_tx_queue_skb_raw

Fuqian Huang (1):
      m68k: q40: Fix info-leak in rtc_ioctl

Gabriel Ravier (1):
      tools: gpio-hammer: Avoid potential overflow in main

Gao Xiang (1):
      mm, THP, swap: fix allocating cluster for swapfile by mistake

Greg Kroah-Hartman (1):
      Linux 5.4.69

Guoju Fang (1):
      bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Gustavo Romero (1):
      KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones

Hans de Goede (2):
      ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1
      i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()

He Zhe (1):
      KVM: LAPIC: Mark hrtimer for period or oneshot mode to expire in hard interrupt context

Heiner Kallweit (1):
      r8169: improve RTL8168b FIFO overflow workaround

Hillf Danton (1):
      Bluetooth: prefetch channel before killing sock

Hou Tao (2):
      mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()
      ubi: fastmap: Free unused fastmap anchor peb during detach

Howard Chung (1):
      Bluetooth: L2CAP: handle l2cap config request during open state

Hui Wang (1):
      ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged

Ian Rogers (5):
      perf parse-events: Fix 3 use after frees found with clang ASAN
      perf mem2node: Avoid double free related to realloc
      perf evsel: Fix 2 memory leaks
      perf trace: Fix the selection for architectures to generate the errno name tables
      perf metricgroup: Free metric_events on error

Icenowy Zheng (1):
      regulator: axp20x: fix LDO2/4 description

Ilya Leoshkevich (1):
      s390/init: add missing __init annotations

Israel Rukshin (3):
      nvme: Fix ctrl use-after-free during sysfs deletion
      nvme: Fix controller creation races with teardown flow
      nvmet-rdma: fix double free of rdma queue

Iurii Zaikin (1):
      kernel/sysctl-test: Add null pointer test for sysctl.c:proc_dointvec()

Ivan Lazeev (1):
      tpm_crb: fix fTPM on AMD Zen+ CPUs

Ivan Safonov (1):
      staging:r8188eu: avoid skb_clone for amsdu to msdu conversion

Jack Zhang (1):
      drm/amdgpu/sriov add amdgpu_amdkfd_pre_reset in gpu reset

Jaegeuk Kim (2):
      f2fs: avoid kernel panic on corruption test
      f2fs: stop GC when the victim becomes fully valid

Jaewon Kim (1):
      mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

James Morse (2):
      firmware: arm_sdei: Use cpus_read_lock() to avoid races with cpuhp
      arm64: acpi: Make apei_claim_sea() synchronise with APEI's irq work

James Smart (7):
      scsi: lpfc: Fix pt2pt discovery on SLI3 HBAs
      scsi: lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce
      scsi: lpfc: Fix incomplete NVME discovery when target
      scsi: lpfc: Fix RQ buffer leakage when no IOCBs available
      scsi: lpfc: Fix release of hwq to clear the eq relationship
      scsi: lpfc: Fix coverity errors in fmdi attribute handling
      scsi: lpfc: Fix initial FLOGI failure due to BBSCN not supported

James Zhu (1):
      drm/amdgpu/vcn2.0: stall DPG when WPTR/RPTR reset

Jan Höppner (1):
      s390/dasd: Fix zero write for FBA devices

Jaska Uimonen (1):
      ASoC: SOF: ipc: check ipc return value before data copy

Jason Gunthorpe (1):
      RDMA/cm: Remove a race freeing timewait_info

Javed Hasan (2):
      scsi: libfc: Handling of extra kref
      scsi: libfc: Skip additional kref updating work event

Jay Cornwall (1):
      drm/amdkfd: Fix race in gfx10 context restore handler

Jeff Layton (2):
      ceph: ensure we have a new cap before continuing in fill_inode
      ceph: fix potential race in ceph_check_caps

Jia He (1):
      mm: fix double page fault on arm64 if PTE_AF is cleared

Jin Yao (1):
      perf parse-events: Use strcmp() to compare the PMU name

Jing Xiangfeng (1):
      atm: eni: fix the missed pci_disable_device() for eni_init_one()

Jiri Olsa (1):
      perf stat: Fix duration_time value for higher intervals

Jiri Pirko (1):
      iavf: use tc_cls_can_offload_and_chain0() instead of chain check

Jiri Slaby (3):
      ata: define AC_ERR_OK
      ata: make qc_prep return ata_completion_errors
      ata: sata_mv, avoid trigerrable BUG_ON

Joakim Tjernlund (1):
      ALSA: usb-audio: Add delay quirk for H570e USB headsets

Joe Perches (1):
      kernel/sys.c: avoid copying possible padding bytes in copy_to_user

Johannes Thumshirn (1):
      btrfs: fix overflow when copying corrupt csums for a message

Johannes Weiner (1):
      mm: memcontrol: fix stat-corrupting race in charge moving

John Clements (1):
      drm/amdgpu: increase atombios cmd timeout

John Garry (2):
      bus: hisi_lpc: Fixup IO ports addresses to avoid use-after-free in host removal
      perf jevents: Fix leak of mapfile memory

John Meneghini (1):
      nvme-multipath: do not reset on unknown status

Jonathan Bakker (3):
      power: supply: max17040: Correct voltage reading
      phy: samsung: s5pv210-usb2: Add delay after reset
      tty: serial: samsung: Correct clock selection logic

Jonathan Lebon (1):
      selinux: allow labeling before policy is loaded

Jordan Crouse (1):
      drm/msm/a5xx: Always set an OPP supported hardware value

Josef Bacik (4):
      tracing: Set kernel_stack's caller size properly
      btrfs: do not init a reloc root if we aren't relocating
      btrfs: free the reloc_control in a consistent way
      btrfs: fix setting last_trans for reloc roots

Josh Poimboeuf (1):
      objtool: Fix noreturn detection for ignored functions

Jun Lei (1):
      drm/amd/display: update nv1x stutter latencies

Kai Vehmanen (1):
      ALSA: hda: enable regmap internal locking

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520

Kangjie Lu (1):
      gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Kevin Kou (1):
      sctp: move trace_sctp_probe_path into sctp_outq_sack

Kirill A. Shutemov (1):
      mm: avoid data corruption on CoW fault into PFN-mapped VMA

Krzysztof Kozlowski (1):
      dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion

Kuninori Morimoto (1):
      ASoC: pcm3168a: ignore 0 Hz settings

Kusanagi Kouichi (1):
      debugfs: Fix !DEBUG_FS debugfs_create_automount

Laurent Pinchart (1):
      drm/omap: dss: Cleanup DSS ports on initialisation failure

Lee Jones (1):
      mfd: mfd-core: Protect against NULL call-back function pointer

Leo Yan (2):
      perf cs-etm: Swap packets for instruction samples
      perf cs-etm: Correct synthesizing instruction samples

Lianbo Jiang (1):
      x86/kdump: Always reserve the low 1M when the crashkernel option is specified

Linus Lüssing (5):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
      batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Liu Jian (1):
      ieee802154: fix one possible memleak in ca8210_dev_com_init

Liu Song (1):
      ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Madhuparna Bhowmik (2):
      drivers: char: tlclk.c: Avoid data race between init and interrupt handler
      rapidio: avoid data race between file operation callbacks and mport_cdev_add().

Manish Mandlik (1):
      Bluetooth: Fix refcount use-after-free issue

Marc Zyngier (1):
      KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch

Marco Elver (1):
      seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Marek Szyprowski (1):
      drm/vc4/vc4_hdmi: fill ASoC card owner

Mark Rutland (1):
      arm64: insn: consistently handle exit text

Markus Elfring (1):
      CIFS: Use common error handling code in smb2_ioctl_query_info()

Markus Theil (1):
      mac80211: skip mpath lookup also for control port tx

Martin Cerveny (1):
      drm/sun4i: sun8i-csc: Secondary CSC register correction

Masami Hiramatsu (2):
      kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()
      kprobes: tracing/kprobes: Fix to kill kprobes on initmem after boot

Matthias Fend (1):
      dmaengine: zynqmp_dma: fix burst length configuration

Max Filippov (1):
      xtensa: fix system_call interaction with ptrace

Maxim Mikityanskiy (1):
      Bluetooth: btrtl: Use kvmalloc for FW allocations

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Mert Dirik (1):
      ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Miaohe Lin (1):
      KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()

Miaoqing Pan (2):
      ath10k: fix array out-of-bounds access
      ath10k: fix memory leak for tpc_stats_final

Michael Ellerman (1):
      powerpc/64s: Always disable branch profiling for prom_init.o

Michel Dänzer (1):
      drm/amdgpu/dc: Require primary plane to be enabled whenever the CRTC is

Mike Snitzer (2):
      dm table: do not allow request-based DM to stack on partitions
      dm: fix bio splitting and its bio completion order for regular IO

Mikel Rychliski (1):
      PCI: Use ioremap(), not phys_to_virt() for platform ROM

Miklos Szeredi (2):
      fuse: don't check refcount after stealing page
      fuse: update attr_version counter on fuse_notify_inval_inode()

Mikulas Patocka (1):
      arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback

Minchan Kim (1):
      mm: validate pmd after splitting

Mohan Kumar (1):
      ALSA: hda: Clear RIRB status before reading WP

Monk Liu (1):
      drm/amdgpu: fix calltrace during kmd unload(v3)

Muchun Song (1):
      kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE

Nathan Chancellor (2):
      tracing: Use address-of operator on section symbols
      mm/kmemleak.c: use address-of operator on section symbols

Necip Fazil Yildiran (2):
      nvme-tcp: fix kconfig dependency warning when !CRYPTO
      lib80211: fix unmet direct dependendices config warning when !CRYPTO

Nicholas Johnson (1):
      PCI: Avoid double hpmemsize MMIO window assignment

Nicholas Kazlauskas (1):
      drm/amd/display: Free gamma after calculating legacy transfer function

Nicholas Piggin (1):
      powerpc/traps: Make unrecoverable NMIs die instead of panic

Nick Desaulniers (1):
      lib/string.c: implement stpcpy

Nikhil Devshatwar (1):
      media: ti-vpe: cal: Restrict DMA to avoid memory corruption

Niklas Söderlund (1):
      thermal: rcar_thermal: Handle probe error gracefully

Nilesh Javali (1):
      scsi: qedi: Fix termination timeouts in session logout

Oleh Kravchenko (1):
      leds: mlxreg: Fix possible buffer overflow

Oliver O'Halloran (1):
      powerpc/eeh: Only dump stack once if an MMIO loop is detected

Omar Sandoval (2):
      xfs: fix realtime file data space leak
      btrfs: fix double __endio_write_update_ordered in direct I/O

Palmer Dabbelt (2):
      tty: sifive: Finish transmission before changing the clock
      RISC-V: Take text_mutex in ftrace_init_nop()

Pan Bian (3):
      scsi: fnic: fix use after free
      RDMA/qedr: Fix potential use after free
      RDMA/i40iw: Fix potential use after free

Paolo Bonzini (2):
      KVM: x86: fix incorrect comparison in trace event
      KVM: x86: handle wrap around 32-bit address space

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Close race with page faults around memslot flushes

Paul Turner (1):
      sched/fair: Eliminate bandwidth race between throttling and distribution

Pavel Machek (1):
      drm/msm: fix leaks if initialization fails

Pavel Shilovsky (1):
      CIFS: Properly process SMB3 lease breaks

Peter Ujfalusi (1):
      serial: 8250_omap: Fix sleeping function called from invalid context during probe

Philip Yang (1):
      drm/amdkfd: fix restore worker race condition

Pierre Crégut (1):
      PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes

Pierre-Louis Bossart (2):
      soundwire: intel/cadence: fix startup sequence
      soundwire: bus: disable pm_runtime in sdw_slave_delete

Pratik Rajesh Sampat (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_work_fn

Qian Cai (7):
      skbuff: fix a data race in skb_queue_len()
      random: fix data races at timer_rand_state
      netfilter: nf_tables: silence a RCU-list warning in nft_table_lookup()
      mm/swapfile: fix data races in try_to_unuse()
      mm/vmscan.c: fix data races using kswapd_classzone_idx
      vfio/pci: fix memory leaks of eventfd ctx
      mm/swap_state: fix a data race in swapin_nr_pages

Qiujun Huang (1):
      ext4: fix a data race at inode->i_disksize

Qu Wenruo (2):
      btrfs: tree-checker: Check leaf chunk item size
      btrfs: qgroup: fix data leak caused by race between writeback and truncate

Quinn Tran (3):
      scsi: qla2xxx: Add error handling for PLOGI ELS passthrough
      scsi: qla2xxx: Fix stuck session in GNL
      scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure

Rafael J. Wysocki (1):
      ACPI: EC: Reference count query handlers under lock

Raveendran Somu (1):
      brcmfmac: Fix double freeing in the fmac usb data path

Raviteja Narayanam (1):
      serial: uartps: Wait for tx_empty in console setup

Rodrigo Siqueira (1):
      drm/amd/display: Stop if retimer is not available

Russell King (1):
      ASoC: kirkwood: fix IRQ error handling

Sagar Biradar (1):
      scsi: aacraid: Disabling TM path and only processing IOP reset

Sagi Grimberg (1):
      nvme: fix possible deadlock when I/O is blocked

Sakari Ailus (1):
      media: smiapp: Fix error handling at NVM reading

Sascha Hauer (1):
      ubi: Fix producing anchor PEBs

Satendra Singh Thakur (1):
      dmaengine: mediatek: hsdma_probe: fixed a memory leak when devm_request_irq fails

Sean Christopherson (1):
      KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE

Sebastian Andrzej Siewior (1):
      workqueue: Remove the warning in wq_worker_sleeping()

Sergey Gorenko (1):
      IB/iser: Always check sig MR before putting it to the free pool

Shreyas Joshi (1):
      printk: handle blank console arguments passed in.

Sonny Sasaka (1):
      Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Sreekanth Reddy (1):
      scsi: mpt3sas: Free diag buffer without any status check

Stanimir Varbanov (1):
      media: venus: vdec: Init registered list unconditionally

Stanislav Fomichev (1):
      selftests/bpf: De-flake test_tcpbpf

Stefan Berger (1):
      tpm: ibmvtpm: Wait for buffer to be set before proceeding

Stephan Gerhold (1):
      drm/mcde: Handle pending vblank while disabling display

Stephane Eranian (1):
      perf stat: Force error in fallback on :k events

Stephen Kitt (1):
      clk/ti/adpll: allocate room for terminating null

Steve Grubb (1):
      audit: CONFIG_CHANGE don't log internal bookkeeping as an event

Steve Rutherford (1):
      KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Steven Price (1):
      mm: pagewalk: fix termination condition in walk_pte_range()

Steven Rostedt (VMware) (1):
      module: Remove accidental change of module_enable_x()

Stuart Hayes (1):
      PCI: pciehp: Fix MSI interrupt race

Suzuki K Poulose (1):
      coresight: etm4x: Fix use-after-free of per-cpu etm drvdata

Sven Eckelmann (1):
      batman-adv: Add missing include for in_interrupt()

Sven Schnelle (2):
      selftests/ftrace: fix glob selftest
      lockdep: fix order in trace_hardirqs_off_caller()

Sylwester Nawrocki (2):
      ASoC: wm8994: Skip setting of the WM8994_MICBIAS register for WM1811
      ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions

Takashi Iwai (6):
      ALSA: usb-audio: Don't create a mixer element with bogus volume range
      media: go7007: Fix URB type for interrupt handling
      ALSA: hda: Skip controller resume if not needed
      ALSA: hda: Fix potential race in unsol event handler
      ALSA: hda: Always use jackpoll helper for jack update after resume
      ALSA: hda: Workaround for spurious wakeups on some Intel platforms

Tang Bin (2):
      USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()
      ipmi:bt-bmc: Fix error handling and status check

Thierry Reding (1):
      i2c: tegra: Restore pinmux on system resume

Thomas Gleixner (3):
      bpf: Remove recursion prevention from rcu free callback
      x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline
      x86/ioapic: Unbreak check_timer()

Thomas Richter (3):
      s390/cpum_sf: Use kzalloc and minor changes
      perf test: Fix test trace+probe_vfs_getname.sh on s390
      perf tests: Fix test 68 zstd compression for s390

Tianjia Zhang (1):
      clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Lendacky (1):
      KVM: SVM: Add a dedicated INVD intercept routine

Tom Rix (3):
      ieee802154/adf7242: check status of adf7242_read_reg
      ALSA: asihpi: fix iounmap in error handler
      tracing: fix double free

Tonghao Zhang (2):
      net: openvswitch: use u64 for meter bucket
      net: openvswitch: use div_u64() for 64-by-32 divisions

Tony Cheng (1):
      drm/amd/display: fix workaround for incorrect double buffer register for DLG ADL and TTU

Tony Lindgren (1):
      ARM: OMAP2+: Handle errors for cpu_pm

Trond Myklebust (5):
      nfsd: Fix a soft lockup race in nfsd_file_mark_find_or_create()
      nfsd: Fix a perf warning
      nfsd: Don't add locks to closed or closing open stateids
      NFS: Fix races nfs_page_group_destroy() vs nfs_destroy_unlinked_subrequests()
      SUNRPC: Don't start a timer on an already queued rpc task

Tuong Lien (2):
      tipc: fix link overflow issue at socket shutdown
      tipc: fix memory leak in service subscripting

Tzung-Bi Shih (1):
      ASoC: max98090: remove msleep in PLL unlocked workaround

Usha Ketineni (1):
      ice: Fix to change Rx/Tx ring descriptor size via ethtool with DCBx

Vasily Averin (6):
      vcc_seq_next should increase position index
      neigh_stat_seq_next() should increase position index
      rt_cpu_seq_next should increase position index
      ipv6_route_seq_next should increase position index
      mm/swapfile.c: swap_next should increase position index
      selinux: sel_avc_get_stat_idx should increase position index

Vasily Gorbik (2):
      s390: avoid misusing CALL_ON_STACK for task stack setup
      mm/gup: fix gup_fast with dynamic page table folding

Vignesh Raghavendra (2):
      serial: 8250_port: Don't service RX FIFO if throttled
      serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout

Vincent Whitchurch (1):
      ARM: 8948/1: Prevent OOB access in stacktrace

Viresh Kumar (1):
      opp: Replace list_kref with a local counter

Waiman Long (2):
      locking/lockdep: Decrement IRQ context counters when removing lock chain
      mm/slub: fix incorrect interpretation of s->offset

Walter Lozano (1):
      opp: Increase parsed_static_opps in _of_add_opp_table_v1()

Wei Li (1):
      MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Wei Yongjun (3):
      sparc64: vcc: Fix error return code in vcc_probe()
      dpaa2-eth: fix error return code in setup_dpni()
      scsi: cxlflash: Fix error return code in cxlflash_probe()

Wen Gong (1):
      ath10k: use kzalloc to read for ath10k_sdio_hif_diag_read

Wen Yang (2):
      drm/omap: fix possible object reference leak
      timekeeping: Prevent 32bit truncation in scale64_check_overflow()

Wenjing Liu (1):
      drm/amd/display: fix image corruption with ODM 2:1 DSC 2 slice

Wesley Chalmers (1):
      drm/amd/display: Do not double-buffer DTO adjustments

Will Deacon (1):
      arm64: cpufeature: Relax checks for AArch32 support at EL[0-2]

Xianting Tian (1):
      mm/filemap.c: clear page error before actual read

Xiaoming Ni (1):
      kernel/notifier.c: intercept duplicate registrations to avoid infinite loops

Xie XiuQi (1):
      perf util: Fix memory leak of prefix_if_not_in

Yonghong Song (1):
      bpf: Fix a rcu warning for bpffs map pretty-print

Yu Chen (1):
      usb: dwc3: Increase timeout for CmdAct cleared by device controller

Zeng Tao (2):
      cpu-topology: Fix the potential data corruption
      vfio/pci: fix racy on error and request eventfd ctx

Zenghui Yu (2):
      KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
      KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()

Zhang Xiaoxu (1):
      cifs: Fix double add page to memcg when cifs_readpages

Zhihao Cheng (2):
      ubifs: ubifs_jnl_write_inode: Fix a memory leak bug
      ubifs: ubifs_add_orphan: Fix a memory leak bug

Zhu Yanjun (1):
      RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices

Zhuang Yanying (1):
      KVM: fix overflow of zero page refcount with ksm running

afzal mohammed (1):
      s390/irq: replace setup_irq() by request_irq()

peter chang (1):
      scsi: pm80xx: Cleanup command when a reset times out

wanpeng li (1):
      KVM: nVMX: Hold KVM's srcu lock when syncing vmcs12->shadow

zhengbin (1):
      media: mc-device.c: fix memleak in media_device_register_entity

