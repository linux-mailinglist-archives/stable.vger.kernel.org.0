Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8E2498A4
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 10:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHSIwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 04:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgHSIvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 04:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB8C20825;
        Wed, 19 Aug 2020 08:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597827091;
        bh=FmFzvb6hsK60TKLAnN4bhwXNF2EuObByP28ghVHWJUY=;
        h=From:To:Cc:Subject:Date:From;
        b=boaKAqYTKNj2KtOqf08lu4zj0HmJ7gXFBNwZOz0a3xE4OH7BRhQX3dpoz0W//X6x5
         zc8GGrS096Yjf0rzEFwLqw67KljBs4p1ocYs4MpKda+1ulNR73cK0lmCdyjhytDwYD
         BVJasP9jorglmVDH3LQG+jz02cF4VDaJz/fzDmNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.2
Date:   Wed, 19 Aug 2020 10:51:41 +0200
Message-Id: <1597827101207207@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.2 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                                  |    3 
 Documentation/core-api/cpu_hotplug.rst                                   |    7 
 Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml |    8 
 Makefile                                                                 |    2 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts                              |    2 
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi                            |    6 
 arch/arm/boot/dts/exynos5800.dtsi                                        |    6 
 arch/arm/boot/dts/r8a7793-gose.dts                                       |    4 
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi                                 |  128 ++---
 arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi                       |   18 
 arch/arm/kernel/stacktrace.c                                             |   24 +
 arch/arm/mach-at91/pm.c                                                  |   11 
 arch/arm/mach-exynos/exynos.c                                            |    2 
 arch/arm/mach-exynos/mcpm-exynos.c                                       |   10 
 arch/arm/mach-socfpga/pm.c                                               |    8 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi                  |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi                         |    6 
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi                       |    1 
 arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts                   |    4 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts                          |    1 
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts                        |   11 
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts                           |    2 
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi                               |   10 
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                                |    6 
 arch/arm64/boot/dts/renesas/r8a77951.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a77960.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a77961.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a77965.dtsi                                |    8 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                                |    6 
 arch/arm64/boot/dts/renesas/r8a77995.dtsi                                |    2 
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi                            |    2 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                            |    4 
 arch/m68k/mac/iop.c                                                      |   21 
 arch/mips/cavium-octeon/octeon-usb.c                                     |    5 
 arch/mips/include/asm/cpu-features.h                                     |    4 
 arch/mips/include/asm/cpu.h                                              |    1 
 arch/mips/kernel/cpu-probe.c                                             |   13 
 arch/mips/kernel/traps.c                                                 |    3 
 arch/mips/kvm/vz.c                                                       |    2 
 arch/mips/pci/pci-xtalk-bridge.c                                         |    3 
 arch/parisc/include/asm/barrier.h                                        |   61 ++
 arch/parisc/include/asm/spinlock.h                                       |   33 -
 arch/parisc/kernel/entry.S                                               |   48 +-
 arch/parisc/kernel/syscall.S                                             |   24 -
 arch/powerpc/boot/Makefile                                               |    2 
 arch/powerpc/boot/serial.c                                               |    2 
 arch/powerpc/include/asm/fixmap.h                                        |    2 
 arch/powerpc/include/asm/perf_event.h                                    |    2 
 arch/powerpc/include/asm/ptrace.h                                        |    2 
 arch/powerpc/include/asm/rtas.h                                          |    2 
 arch/powerpc/include/asm/timex.h                                         |    2 
 arch/powerpc/kernel/hw_breakpoint.c                                      |   95 ++--
 arch/powerpc/kernel/rtas.c                                               |  122 -----
 arch/powerpc/kernel/vdso.c                                               |    2 
 arch/powerpc/mm/book3s64/hash_utils.c                                    |    5 
 arch/powerpc/mm/book3s64/pkeys.c                                         |   16 
 arch/powerpc/mm/book3s64/radix_pgtable.c                                 |   16 
 arch/powerpc/platforms/cell/spufs/coredump.c                             |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c                             |  171 -------
 arch/powerpc/platforms/pseries/offline_states.h                          |   38 -
 arch/powerpc/platforms/pseries/pmem.c                                    |    1 
 arch/powerpc/platforms/pseries/smp.c                                     |   28 -
 arch/powerpc/platforms/pseries/suspend.c                                 |   22 
 arch/s390/include/asm/topology.h                                         |    6 
 arch/s390/mm/gmap.c                                                      |   27 -
 arch/s390/net/bpf_jit_comp.c                                             |   54 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S                                  |   14 
 arch/x86/crypto/aesni-intel_asm.S                                        |    6 
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S                                |    2 
 arch/x86/events/intel/uncore_snb.c                                       |    3 
 arch/x86/include/asm/topology.h                                          |    2 
 arch/x86/include/asm/uaccess.h                                           |    5 
 arch/x86/kernel/apic/io_apic.c                                           |    5 
 arch/x86/kernel/cpu/mce/inject.c                                         |    2 
 arch/x86/kernel/process_64.c                                             |    2 
 arch/x86/kernel/smpboot.c                                                |   50 +-
 arch/x86/kvm/svm/svm.c                                                   |    2 
 arch/x86/kvm/vmx/vmx.c                                                   |    2 
 arch/x86/kvm/x86.c                                                       |   38 -
 arch/x86/kvm/x86.h                                                       |    2 
 block/blk-iocost.c                                                       |    2 
 block/blk-zoned.c                                                        |    3 
 drivers/acpi/acpica/exprep.c                                             |    4 
 drivers/acpi/acpica/utdelete.c                                           |    6 
 drivers/base/dd.c                                                        |    7 
 drivers/base/firmware_loader/fallback_platform.c                         |    5 
 drivers/block/loop.c                                                     |    4 
 drivers/bluetooth/btmrvl_sdio.c                                          |    8 
 drivers/bluetooth/btmtksdio.c                                            |   16 
 drivers/bluetooth/btusb.c                                                |   90 +++
 drivers/bluetooth/hci_h5.c                                               |    2 
 drivers/bluetooth/hci_qca.c                                              |  104 +++-
 drivers/bluetooth/hci_serdev.c                                           |    3 
 drivers/bus/ti-sysc.c                                                    |    6 
 drivers/char/agp/intel-gtt.c                                             |    4 
 drivers/char/tpm/tpm-chip.c                                              |    9 
 drivers/char/tpm/tpm.h                                                   |    5 
 drivers/char/tpm/tpm2-space.c                                            |   26 -
 drivers/char/tpm/tpmrm-dev.c                                             |    2 
 drivers/clk/bcm/clk-bcm63xx-gate.c                                       |    1 
 drivers/clk/clk-scmi.c                                                   |   22 
 drivers/clk/qcom/gcc-sc7180.c                                            |    2 
 drivers/clk/qcom/gcc-sdm845.c                                            |    4 
 drivers/cpufreq/Kconfig.arm                                              |    1 
 drivers/cpufreq/armada-37xx-cpufreq.c                                    |    1 
 drivers/cpufreq/cpufreq.c                                                |   58 +-
 drivers/crypto/caam/caamalg.c                                            |    2 
 drivers/crypto/caam/caamalg_qi.c                                         |    2 
 drivers/crypto/caam/caamalg_qi2.c                                        |    2 
 drivers/crypto/cavium/cpt/cptvf_algs.c                                   |    1 
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c                             |   12 
 drivers/crypto/cavium/cpt/request_manager.h                              |    2 
 drivers/crypto/ccp/ccp-dev.h                                             |    1 
 drivers/crypto/ccp/ccp-ops.c                                             |   37 +
 drivers/crypto/ccree/cc_cipher.c                                         |   30 -
 drivers/crypto/hisilicon/sec/sec_algs.c                                  |   34 -
 drivers/crypto/qat/qat_common/qat_algs.c                                 |   22 
 drivers/crypto/qat/qat_common/qat_uclo.c                                 |    9 
 drivers/devfreq/devfreq.c                                                |   11 
 drivers/devfreq/rk3399_dmc.c                                             |   42 -
 drivers/dma-buf/st-dma-fence-chain.c                                     |   43 -
 drivers/edac/edac_device_sysfs.c                                         |    1 
 drivers/edac/edac_pci_sysfs.c                                            |    2 
 drivers/firmware/arm_scmi/scmi_pm_domain.c                               |   12 
 drivers/firmware/qcom_scm.c                                              |    7 
 drivers/gpio/gpiolib-devres.c                                            |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                              |   97 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                                |   19 
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c                                   |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c                 |    6 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                            |    4 
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c                        |   29 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                         |   16 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c              |   11 
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c                             |   14 
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c                                |    3 
 drivers/gpu/drm/arm/malidp_planes.c                                      |    2 
 drivers/gpu/drm/bridge/sil-sii8620.c                                     |    2 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                    |    8 
 drivers/gpu/drm/drm_debugfs.c                                            |    8 
 drivers/gpu/drm/drm_gem.c                                                |    4 
 drivers/gpu/drm/drm_mipi_dsi.c                                           |    6 
 drivers/gpu/drm/drm_mm.c                                                 |    4 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                                    |   19 
 drivers/gpu/drm/imx/dw_hdmi-imx.c                                        |   15 
 drivers/gpu/drm/imx/imx-drm-core.c                                       |    3 
 drivers/gpu/drm/imx/imx-ldb.c                                            |   15 
 drivers/gpu/drm/imx/imx-tve.c                                            |   35 -
 drivers/gpu/drm/imx/ipuv3-crtc.c                                         |   21 
 drivers/gpu/drm/imx/parallel-display.c                                   |   15 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                                    |   18 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                                 |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c                           |   20 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h                           |   13 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c                              |    9 
 drivers/gpu/drm/msm/msm_gem.c                                            |   36 -
 drivers/gpu/drm/nouveau/dispnv50/head.c                                  |   24 -
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                                |    4 
 drivers/gpu/drm/nouveau/nouveau_drm.c                                    |    8 
 drivers/gpu/drm/nouveau/nouveau_gem.c                                    |    4 
 drivers/gpu/drm/nouveau/nouveau_sgdma.c                                  |    9 
 drivers/gpu/drm/panel/panel-simple.c                                     |    2 
 drivers/gpu/drm/panfrost/panfrost_job.c                                  |    5 
 drivers/gpu/drm/radeon/ci_dpm.c                                          |    2 
 drivers/gpu/drm/radeon/radeon_display.c                                  |    4 
 drivers/gpu/drm/radeon/radeon_drv.c                                      |    9 
 drivers/gpu/drm/radeon/radeon_kms.c                                      |    4 
 drivers/gpu/drm/stm/ltdc.c                                               |    3 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c                                    |    6 
 drivers/gpu/drm/ttm/ttm_tt.c                                             |    3 
 drivers/gpu/drm/xen/xen_drm_front.c                                      |    4 
 drivers/gpu/drm/xen/xen_drm_front_gem.c                                  |    8 
 drivers/gpu/drm/xen/xen_drm_front_kms.c                                  |    2 
 drivers/gpu/host1x/debug.c                                               |    4 
 drivers/gpu/ipu-v3/ipu-common.c                                          |    2 
 drivers/hid/hid-input.c                                                  |    6 
 drivers/hwtracing/coresight/coresight-etm4x.c                            |   22 
 drivers/hwtracing/coresight/coresight-etm4x.h                            |    6 
 drivers/hwtracing/coresight/coresight-tmc-etf.c                          |   13 
 drivers/iio/amplifiers/ad8366.c                                          |    7 
 drivers/infiniband/core/device.c                                         |   11 
 drivers/infiniband/core/nldev.c                                          |    3 
 drivers/infiniband/core/verbs.c                                          |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                               |   13 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                               |    1 
 drivers/infiniband/hw/qedr/qedr.h                                        |    5 
 drivers/infiniband/hw/qedr/verbs.c                                       |   42 +
 drivers/infiniband/sw/rxe/rxe_recv.c                                     |    6 
 drivers/infiniband/sw/rxe/rxe_verbs.c                                    |    5 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                                   |   16 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                                   |    2 
 drivers/iommu/intel/dmar.c                                               |    1 
 drivers/iommu/intel/iommu.c                                              |   27 +
 drivers/iommu/intel/irq_remapping.c                                      |    8 
 drivers/irqchip/irq-bcm7038-l1.c                                         |    8 
 drivers/irqchip/irq-gic-v3-its.c                                         |    4 
 drivers/irqchip/irq-loongson-htvec.c                                     |   10 
 drivers/irqchip/irq-loongson-liointc.c                                   |    1 
 drivers/irqchip/irq-loongson-pch-pic.c                                   |   30 -
 drivers/irqchip/irq-mtk-sysirq.c                                         |    8 
 drivers/irqchip/irq-ti-sci-inta.c                                        |    2 
 drivers/leds/led-class.c                                                 |    1 
 drivers/leds/leds-lm355x.c                                               |    7 
 drivers/macintosh/via-macii.c                                            |    9 
 drivers/md/bcache/super.c                                                |    9 
 drivers/md/md-cluster.c                                                  |    1 
 drivers/md/md.c                                                          |    9 
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c                         |    6 
 drivers/media/firewire/firedtv-fw.c                                      |    2 
 drivers/media/i2c/tvp5150.c                                              |    8 
 drivers/media/mc/mc-request.c                                            |   31 -
 drivers/media/platform/exynos4-is/media-dev.c                            |    3 
 drivers/media/platform/marvell-ccic/mcam-core.c                          |    2 
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c                            |   16 
 drivers/media/platform/omap3isp/isppreview.c                             |    4 
 drivers/media/platform/s5p-g2d/g2d.c                                     |   28 -
 drivers/media/usb/dvb-usb/Kconfig                                        |    1 
 drivers/media/usb/go7007/go7007-usb.c                                    |   11 
 drivers/memory/samsung/exynos5422-dmc.c                                  |   12 
 drivers/memory/tegra/tegra186-emc.c                                      |   16 
 drivers/mfd/ioc3.c                                                       |    6 
 drivers/misc/cxl/sysfs.c                                                 |    2 
 drivers/misc/lkdtm/bugs.c                                                |   49 +-
 drivers/misc/lkdtm/lkdtm.h                                               |    2 
 drivers/misc/lkdtm/perms.c                                               |   22 
 drivers/misc/lkdtm/usercopy.c                                            |    7 
 drivers/mmc/host/sdhci-cadence.c                                         |  123 ++---
 drivers/mmc/host/sdhci-of-arasan.c                                       |    4 
 drivers/mmc/host/sdhci-pci-o2micro.c                                     |    6 
 drivers/most/core.c                                                      |    4 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                                 |    5 
 drivers/mtd/nand/raw/qcom_nandc.c                                        |    7 
 drivers/mtd/spi-nor/controllers/intel-spi.c                              |    9 
 drivers/net/dsa/mv88e6xxx/chip.c                                         |    1 
 drivers/net/dsa/rtl8366.c                                                |   35 +
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c                      |    6 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c                |    2 
 drivers/net/ethernet/cadence/macb_main.c                                 |   11 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c                  |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c                         |    8 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                         |    8 
 drivers/net/ethernet/freescale/fman/fman.c                               |    3 
 drivers/net/ethernet/freescale/fman/fman_dtsec.c                         |    4 
 drivers/net/ethernet/freescale/fman/fman_mac.h                           |    2 
 drivers/net/ethernet/freescale/fman/fman_memac.c                         |    3 
 drivers/net/ethernet/freescale/fman/fman_port.c                          |    9 
 drivers/net/ethernet/freescale/fman/fman_tgec.c                          |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                              |    9 
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c                           |    8 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                          |    1 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                        |    9 
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c                 |   42 -
 drivers/net/ethernet/mscc/ocelot.c                                       |   16 
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c                      |    9 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                          |    2 
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                                |    5 
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                               |    1 
 drivers/net/ethernet/sgi/ioc3-eth.c                                      |    4 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                                 |   19 
 drivers/net/ethernet/toshiba/spider_net.c                                |    4 
 drivers/net/ethernet/xilinx/ll_temac_main.c                              |    6 
 drivers/net/hyperv/netvsc_drv.c                                          |    7 
 drivers/net/phy/marvell10g.c                                             |   18 
 drivers/net/phy/mscc/mscc_main.c                                         |    9 
 drivers/net/phy/phy_device.c                                             |    8 
 drivers/net/usb/r8152.c                                                  |    2 
 drivers/net/vmxnet3/vmxnet3_drv.c                                        |    3 
 drivers/net/vxlan.c                                                      |    4 
 drivers/net/wan/lapbether.c                                              |   10 
 drivers/net/wireless/ath/ath10k/htt_tx.c                                 |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h            |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c              |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c                  |    6 
 drivers/net/wireless/intel/iwlegacy/common.c                             |    4 
 drivers/net/wireless/marvell/mwifiex/sdio.h                              |    4 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c                       |   22 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                          |   13 
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c                          |   21 
 drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c                      |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c                      |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                          |   19 
 drivers/net/wireless/quantenna/qtnfmac/core.c                            |    5 
 drivers/net/wireless/realtek/rtw88/coex.c                                |    3 
 drivers/net/wireless/realtek/rtw88/fw.c                                  |    2 
 drivers/net/wireless/realtek/rtw88/main.c                                |   11 
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c                           |    4 
 drivers/net/wireless/ti/wl1251/event.c                                   |    2 
 drivers/nvme/host/multipath.c                                            |   17 
 drivers/nvme/host/rdma.c                                                 |   12 
 drivers/nvme/host/tcp.c                                                  |   12 
 drivers/nvmem/sprd-efuse.c                                               |    4 
 drivers/parisc/sba_iommu.c                                               |    2 
 drivers/pci/access.c                                                     |    8 
 drivers/pci/controller/cadence/pcie-cadence-ep.c                         |    9 
 drivers/pci/controller/cadence/pcie-cadence-host.c                       |   15 
 drivers/pci/controller/pci-loongson.c                                    |    6 
 drivers/pci/controller/pcie-rcar-host.c                                  |    4 
 drivers/pci/controller/vmd.c                                             |    3 
 drivers/pci/pcie/aspm.c                                                  |    1 
 drivers/pci/quirks.c                                                     |    2 
 drivers/phy/cadence/phy-cadence-salvo.c                                  |    2 
 drivers/phy/marvell/phy-armada38x-comphy.c                               |   45 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                                 |   61 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c                                 |    4 
 drivers/pinctrl/pinctrl-single.c                                         |   11 
 drivers/platform/x86/asus-nb-wmi.c                                       |   82 +++
 drivers/platform/x86/intel-hid.c                                         |    2 
 drivers/platform/x86/intel-vbtn.c                                        |    2 
 drivers/power/supply/88pm860x_battery.c                                  |    6 
 drivers/regulator/core.c                                                 |   18 
 drivers/reset/reset-intel-gw.c                                           |   24 -
 drivers/s390/block/dasd_diag.c                                           |   25 -
 drivers/s390/net/qeth_core_main.c                                        |   20 
 drivers/s390/net/qeth_l2_main.c                                          |    4 
 drivers/scsi/arm/cumana_2.c                                              |    2 
 drivers/scsi/arm/eesox.c                                                 |    2 
 drivers/scsi/arm/powertec.c                                              |    2 
 drivers/scsi/megaraid/megaraid_sas_base.c                                |    9 
 drivers/scsi/mesh.c                                                      |    8 
 drivers/scsi/qla2xxx/qla_iocb.c                                          |    4 
 drivers/scsi/scsi_debug.c                                                |    6 
 drivers/scsi/scsi_lib.c                                                  |    4 
 drivers/scsi/ufs/ufshcd.c                                                |   53 +-
 drivers/scsi/ufs/ufshcd.h                                                |    2 
 drivers/soc/qcom/pdr_interface.c                                         |    4 
 drivers/soc/qcom/rpmh-rsc.c                                              |   19 
 drivers/spi/spi-dw-dma.c                                                 |   14 
 drivers/spi/spi-lantiq-ssc.c                                             |   12 
 drivers/spi/spi-rockchip.c                                               |    2 
 drivers/spi/spidev.c                                                     |   21 
 drivers/staging/media/allegro-dvt/allegro-core.c                         |    8 
 drivers/staging/media/rkisp1/rkisp1-resizer.c                            |   12 
 drivers/staging/rtl8192u/r8192U_core.c                                   |    2 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c            |    1 
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c         |    2 
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c                       |    2 
 drivers/usb/cdns3/gadget.c                                               |    3 
 drivers/usb/core/quirks.c                                                |   16 
 drivers/usb/dwc2/platform.c                                              |    4 
 drivers/usb/dwc3/dwc3-meson-g12a.c                                       |   15 
 drivers/usb/gadget/function/f_uac2.c                                     |    7 
 drivers/usb/gadget/udc/bdc/bdc_core.c                                    |   13 
 drivers/usb/gadget/udc/bdc/bdc_ep.c                                      |   16 
 drivers/usb/gadget/udc/net2280.c                                         |    4 
 drivers/usb/mtu3/mtu3_core.c                                             |    6 
 drivers/usb/serial/cp210x.c                                              |   19 
 drivers/usb/serial/iuu_phoenix.c                                         |   14 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                         |   31 +
 drivers/video/console/newport_con.c                                      |   12 
 drivers/video/fbdev/neofb.c                                              |    1 
 drivers/video/fbdev/pxafb.c                                              |    4 
 drivers/video/fbdev/savage/savagefb_driver.c                             |    2 
 drivers/video/fbdev/sm712fb.c                                            |    2 
 drivers/xen/balloon.c                                                    |   12 
 drivers/xen/gntdev-dmabuf.c                                              |    8 
 fs/9p/v9fs.c                                                             |    5 
 fs/btrfs/ctree.h                                                         |    2 
 fs/btrfs/extent-tree.c                                                   |    8 
 fs/btrfs/extent_io.c                                                     |    2 
 fs/btrfs/file.c                                                          |   12 
 fs/btrfs/inode.c                                                         |   44 +
 fs/btrfs/space-info.c                                                    |    2 
 fs/dlm/lockspace.c                                                       |    6 
 fs/erofs/inode.c                                                         |  121 +++--
 fs/io_uring.c                                                            |  235 +++++++---
 fs/kernfs/file.c                                                         |    2 
 fs/minix/inode.c                                                         |   36 +
 fs/minix/itree_common.c                                                  |    8 
 fs/nfs/pnfs.c                                                            |   46 -
 fs/nfsd/nfs4recover.c                                                    |   24 -
 fs/ocfs2/dlmglue.c                                                       |    8 
 fs/pstore/platform.c                                                     |    5 
 fs/xfs/libxfs/xfs_shared.h                                               |    1 
 fs/xfs/libxfs/xfs_trans_space.h                                          |    2 
 fs/xfs/scrub/bmap.c                                                      |   22 
 fs/xfs/xfs_bmap_util.c                                                   |   18 
 fs/xfs/xfs_qm.c                                                          |    1 
 fs/xfs/xfs_reflink.c                                                     |   21 
 fs/xfs/xfs_trans.c                                                       |   19 
 include/asm-generic/vmlinux.lds.h                                        |    1 
 include/linux/bitfield.h                                                 |    2 
 include/linux/dmar.h                                                     |    1 
 include/linux/gpio/driver.h                                              |   13 
 include/linux/gpio/regmap.h                                              |    2 
 include/linux/intel-iommu.h                                              |    2 
 include/linux/tpm.h                                                      |    1 
 include/linux/tpm_eventlog.h                                             |   11 
 include/linux/tracepoint.h                                               |    2 
 include/net/bluetooth/bluetooth.h                                        |    2 
 include/net/bluetooth/hci.h                                              |   11 
 include/net/bluetooth/hci_core.h                                         |    2 
 include/net/inet_connection_sock.h                                       |    4 
 include/net/ip_vs.h                                                      |   10 
 include/net/tcp.h                                                        |    2 
 include/uapi/linux/bpf.h                                                 |    2 
 include/uapi/linux/seccomp.h                                             |    3 
 include/uapi/rdma/qedr-abi.h                                             |   10 
 kernel/bpf/map_iter.c                                                    |   16 
 kernel/bpf/task_iter.c                                                   |    6 
 kernel/rcu/tree.c                                                        |    9 
 kernel/sched/core.c                                                      |   21 
 kernel/sched/fair.c                                                      |   23 
 kernel/sched/topology.c                                                  |    2 
 kernel/seccomp.c                                                         |    9 
 kernel/signal.c                                                          |   16 
 kernel/task_work.c                                                       |    8 
 kernel/time/tick-sched.c                                                 |   22 
 kernel/trace/blktrace.c                                                  |   18 
 kernel/trace/ftrace.c                                                    |    3 
 kernel/trace/trace.c                                                     |   12 
 kernel/trace/trace.h                                                     |    9 
 lib/crc-t10dif.c                                                         |   54 +-
 lib/dynamic_debug.c                                                      |   23 
 lib/kobject.c                                                            |   33 -
 mm/mmap.c                                                                |    1 
 mm/vmstat.c                                                              |   12 
 net/bluetooth/6lowpan.c                                                  |    5 
 net/bluetooth/hci_core.c                                                 |   28 -
 net/bpfilter/bpfilter_kern.c                                             |    1 
 net/core/sock.c                                                          |   25 -
 net/ipv4/inet_connection_sock.c                                          |   97 ++--
 net/ipv4/inet_hashtables.c                                               |    1 
 net/ipv4/sysctl_net_ipv4.c                                               |   16 
 net/ipv4/tcp.c                                                           |   16 
 net/ipv4/tcp_fastopen.c                                                  |   23 
 net/netfilter/ipvs/ip_vs_core.c                                          |   12 
 net/netfilter/nft_meta.c                                                 |    2 
 net/nfc/rawsock.c                                                        |    7 
 net/packet/af_packet.c                                                   |    9 
 net/socket.c                                                             |    2 
 net/sunrpc/auth_gss/gss_krb5_wrap.c                                      |    2 
 net/sunrpc/auth_gss/svcauth_gss.c                                        |    1 
 net/sunrpc/xprtrdma/svc_rdma_rw.c                                        |   28 -
 net/tls/tls_device.c                                                     |    3 
 net/vmw_vsock/af_vsock.c                                                 |    2 
 samples/bpf/fds_example.c                                                |    3 
 samples/bpf/map_perf_test_kern.c                                         |    9 
 samples/bpf/test_map_in_map_kern.c                                       |    9 
 samples/bpf/test_probe_write_user_kern.c                                 |    9 
 scripts/recordmcount.c                                                   |    6 
 scripts/selinux/mdp/mdp.c                                                |   23 
 security/integrity/ima/ima.h                                             |    5 
 security/integrity/ima/ima_policy.c                                      |  102 +++-
 security/smack/smackfs.c                                                 |    6 
 sound/pci/hda/patch_realtek.c                                            |    4 
 sound/soc/codecs/hdac_hda.c                                              |    7 
 sound/soc/codecs/tas2770.c                                               |    3 
 sound/soc/fsl/fsl_easrc.c                                                |    2 
 sound/soc/fsl/fsl_sai.c                                                  |    5 
 sound/soc/fsl/fsl_sai.h                                                  |    2 
 sound/soc/intel/boards/bxt_rt298.c                                       |    2 
 sound/soc/intel/boards/cml_rt1011_rt5682.c                               |   84 +--
 sound/soc/intel/boards/sof_sdw.c                                         |    1 
 sound/soc/meson/axg-card.c                                               |   20 
 sound/soc/meson/axg-tdm-formatter.c                                      |   11 
 sound/soc/meson/axg-tdm-formatter.h                                      |    1 
 sound/soc/meson/axg-tdm-interface.c                                      |   26 -
 sound/soc/meson/axg-tdmin.c                                              |   16 
 sound/soc/meson/axg-tdmout.c                                             |    3 
 sound/soc/meson/gx-card.c                                                |   18 
 sound/soc/meson/meson-card-utils.c                                       |    4 
 sound/soc/soc-core.c                                                     |    5 
 sound/soc/soc-dai.c                                                      |   16 
 sound/soc/soc-pcm.c                                                      |   42 +
 sound/soc/sof/nocodec.c                                                  |    1 
 sound/usb/card.h                                                         |    1 
 sound/usb/mixer_quirks.c                                                 |    1 
 sound/usb/pcm.c                                                          |    6 
 sound/usb/quirks-table.h                                                 |   64 ++
 sound/usb/quirks.c                                                       |    3 
 sound/usb/stream.c                                                       |    1 
 tools/bpf/bpftool/btf.c                                                  |    2 
 tools/bpf/bpftool/gen.c                                                  |    5 
 tools/build/Build.include                                                |    3 
 tools/include/uapi/linux/bpf.h                                           |    2 
 tools/lib/bpf/bpf_tracing.h                                              |    4 
 tools/testing/kunit/kunit.py                                             |   24 -
 tools/testing/kunit/kunit_kernel.py                                      |    6 
 tools/testing/kunit/kunit_tool_test.py                                   |   14 
 tools/testing/selftests/lkdtm/run.sh                                     |    6 
 tools/testing/selftests/lkdtm/tests.txt                                  |    1 
 tools/testing/selftests/net/msg_zerocopy.c                               |    5 
 tools/testing/selftests/powerpc/benchmarks/context_switch.c              |   21 
 tools/testing/selftests/powerpc/eeh/eeh-functions.sh                     |   11 
 tools/testing/selftests/powerpc/utils.c                                  |   37 +
 tools/testing/selftests/seccomp/seccomp_bpf.c                            |    2 
 489 files changed, 3990 insertions(+), 2427 deletions(-)

Aaron Ma (1):
      rtw88: 8822ce: add support for device ID 0xc82f

Abhishek Pandit-Subedi (2):
      Bluetooth: Allow suspend even when preparation has failed
      Bluetooth: Fix suspend notifier race

Aditya Pakki (3):
      drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync
      drm/nouveau: fix reference count leak in nouveau_debugfs_strap_peek
      drm/nouveau: fix multiple instances of reference count leaks

Ahmad Fatoum (1):
      gpio: don't use same lockdep class for all devm_gpiochip_add_data users

Akhil P Oommen (2):
      drm: msm: a6xx: fix gpu failure after system resume
      drm/msm: Fix a null pointer access in msm_gem_shrinker_count()

Alex Deucher (3):
      drm/amdgpu/debugfs: fix ref count leak when pm_runtime_get_sync fails
      drm/amdgpu/display bail early in dm_pp_get_static_clocks
      drm/amdgpu/display: properly guard the calls to swSMU functions

Alex Vesker (1):
      net/mlx5: DR, Change push vlan action sequence

Alexander Gordeev (1):
      s390/numa: set node distance to LOCAL_DISTANCE

Alexander Sverdlin (1):
      mtd: spi-nor: intel-spi: Simulate WRDI command

Alexandre Belloni (1):
      ARM: dts: at91: sama5d3_xplained: change phy-mode

Alexei Starovoitov (1):
      bpfilter: Initialize pos variable

Alim Akhtar (1):
      arm64: dts: exynos: Fix silent hang after boot on Espresso

Amir Goldstein (1):
      kernfs: do not call fsnotify() with name without a parent

Andrii Nakryiko (2):
      bpf: Fix bpf_ringbuf_output() signature to return long
      tools, build: Propagate build failures from tools/build/Makefile.build

Aneesh Kumar K.V (1):
      powerpc/book3s64/pkeys: Use PVR check instead of cpu feature

Antoine Tenart (1):
      net: phy: mscc: restore the base page in vsc8514/8584_config_init

Aric Cyr (1):
      drm/amd/display: Improve DisplayPort monitor interop

Armas Spann (1):
      platform/x86: asus-nb-wmi: add support for ASUS ROG Zephyrus G14 and G15

Arnd Bergmann (3):
      crypto: x86/crc32c - fix building with clang ias
      leds: lm355x: avoid enum conversion warning
      media: cxusb-analog: fix V4L2 dependency

Balakrishna Godavarthi (1):
      Bluetooth: hci_qca: Increase SoC idle timeout to 200ms

Baoquan He (1):
      Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"

Bart Van Assche (1):
      scsi: qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of request_t.handle

Bartosz Golaszewski (1):
      irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Bharata B Rao (1):
      powerpc/mm/radix: Free PUD table when freeing pagetable

Bjorn Helgaas (1):
      PCI: Fix pci_cfg_wait queue locking problem

Bolarinwa Olayemi Saheed (1):
      iwlegacy: Check the return value of pcie_capability_read_*()

Brant Merryman (2):
      USB: serial: cp210x: re-enable auto-RTS on open
      USB: serial: cp210x: enable usb generic throttle/unthrottle

Brendan Higgins (2):
      kunit: tool: fix broken default args in unit tests
      kunit: tool: fix improper treatment of file location

Brian Foster (2):
      xfs: preserve rmapbt swapext block reservation from freed blocks
      xfs: fix inode allocation block res calculation precedence

Chanwoo Choi (1):
      PM / devfreq: Fix indentaion of devfreq_summary debugfs node

Charles Keepax (1):
      ASoC: soc-core: Fix regression causing sysfs entries to disappear

Chen Tao (1):
      drm/amdgpu/debugfs: fix memory leak when amdgpu_virt_enable_access_debugfs failed

Chen-Yu Tsai (2):
      ARM: dts: sunxi: bananapi-m2-plus-v1.2: Add regulator supply to all CPU cores
      ARM: dts: sunxi: bananapi-m2-plus-v1.2: Fix CPU supply voltages

Chengming Zhou (1):
      iocost: Fix check condition of iocg abs_vdebt

Chris Packham (1):
      net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Christian Eggers (1):
      spi: spidev: Align buffers for DMA

Christian Hewitt (2):
      arm64: dts: meson: misc fixups for w400 dtsi
      arm64: dts: meson: fix mmc0 tuning error on Khadas VIM3

Christian König (1):
      drm/radeon: disable AGP by default

Christoph Hellwig (1):
      powerpc/spufs: Fix the type of ret in spufs_arch_write_note

Christophe JAILLET (8):
      memory: tegra: Fix an error handling path in tegra186_emc_probe()
      video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call
      scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
      scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      media: s5p-g2d: Fix a memory leak in an error handling path in 'g2d_probe()'
      net: sgi: ioc3-eth: Fix the size used in some 'dma_free_coherent()' calls
      net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Christophe Leroy (1):
      powerpc/fixmap: Fix FIX_EARLY_DEBUG_BASE when page size is 256k

Chuck Lever (2):
      svcrdma: Fix page leak in svc_rdma_recv_read_chunk()
      SUNRPC: Fix ("SUNRPC: Add "@len" parameter to gss_unwrap()")

Chuhong Yuan (6):
      iio: amplifiers: ad8366: Change devm_gpiod_get() to optional and add the missed check
      media: marvell-ccic: Add missed v4l2_async_notifier_cleanup()
      media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()
      media: tvp5150: Add missed media_entity_cleanup()
      media: exynos4-is: Add missed check for pinctrl_lookup_state()
      mmc: sdhci-of-arasan: Add missed checks for devm_clk_register()

Chunfeng Yun (1):
      usb: mtu3: clear dual mode of u3port when disable device

Colin Ian King (6):
      md: raid0/linear: fix dereference before null check on pointer mddev
      drm/arm: fix unintentional integer overflow on left shift
      staging: most: avoid null pointer dereference when iface is null
      drm/amdgpu: ensure 0 is returned for success in jpeg_v2_5_wait_for_idle
      drm/radeon: fix array out-of-bounds read and write issues
      staging: rtl8192u: fix a dubious looking mask before a shift

Coly Li (1):
      bcache: fix super block seq numbers comparision in register_cache_set()

Cristian Marussi (1):
      firmware: arm_scmi: Fix SCMI genpd domain probing

Dafna Hirschfeld (1):
      media: staging: rkisp1: rsz: supported formats are the isp's src formats, not sink formats

Dan Carpenter (10):
      drm/gem: Fix a leak in drm_gem_objects_lookup()
      Bluetooth: hci_qca: Fix an error pointer dereference
      media: firewire: Using uninitialized values in node_probe()
      media: allegro: Fix some NULL vs IS_ERR() checks in probe
      mwifiex: Prevent memory corruption handling keys
      thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()
      mt76: mt7915: potential array overflow in mt7915_mcu_tx_rate_report()
      Smack: fix another vsscanf out of bounds
      Smack: prevent underflow in smk_set_cipso()
      media: mtk-mdp: Fix a refcounting bug on error in init

Dan Murphy (1):
      ASoC: tas2770: Fix reset gpio property name

Dan Robertson (1):
      usb: dwc3: meson-g12a: fix shared reset control use

Danesh Petigara (1):
      usb: bdc: Halt controller on suspend

Daniel T. Lee (1):
      samples: bpf: Fix bpf programs with kprobe/sys_connect event

Danil Kipnis (1):
      RDMA/rtrs-clt: add an additional random 8 seconds before reconnecting

Dariusz Marcinkiewicz (1):
      media: cros-ec-cec: do not bail on device_init_wakeup failure

Darrick J. Wong (3):
      xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork
      xfs: fix reflink quota reservation accounting error
      xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush

Dave Airlie (1):
      drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Dean Nelson (1):
      net: thunderx: initialize VF's mailbox mutex before first usage

Dejin Zheng (3):
      reset: intel: fix a compile warning about REG_OFFSET redefined
      video: fbdev: sm712fb: fix an issue about iounmap for a wrong address
      console: newport_con: fix an issue about leak related system resources

Dilip Kota (1):
      spi: lantiq: fix: Rx overflow error in full duplex mode

Dinghao Liu (1):
      PCI: rcar: Fix runtime PM imbalance on error

Dmitry Osipenko (1):
      gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Dmitry Vyukov (1):
      io_uring: fix sq array offset calculation

Douglas Anderson (3):
      soc: qcom: rpmh-rsc: Don't use ktime for timeout in write_tcs_reg_sync()
      drm/bridge: ti-sn65dsi86: Clear old error bits before AUX transfers
      drm/bridge: ti-sn65dsi86: Fix off-by-one error in clock choice

Drew Fustini (1):
      pinctrl-single: fix pcs_parse_pinconf() return value

Emil Velikov (2):
      drm/amdgpu: use the unlocked drm_gem_object_put
      drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Eric Biggers (3):
      fs/minix: check return value of sb_getblk()
      fs/minix: don't allow getting deleted inodes
      fs/minix: reject too-large maximum file size

Eric Dumazet (1):
      x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Erik Kaneda (1):
      ACPICA: Do not increment operation_region reference counts for field units

Erwan Le Ray (2):
      ARM: dts: stm32: fix uart nodes ordering in stm32mp15-pinctrl
      ARM: dts: stm32: fix uart7_pins_a comments in stm32mp15-pinctrl

Evan Green (1):
      ath10k: Acquire tx_lock in tx error paths

Evan Quan (2):
      drm/amd/powerplay: fix compile error with ARCH=arc
      drm/amd/powerplay: suppress compile error around BUG_ON

Evgeny Novikov (3):
      video: fbdev: savage: fix memory leak on error handling path in probe
      video: fbdev: neofb: fix memory leak in neo_scan_monitor()
      usb: gadget: net2280: fix memory leak on probe error handling paths

Finn Thain (4):
      m68k: mac: Don't send IOP message until channel is idle
      m68k: mac: Fix IOP status/control register writes
      scsi: mesh: Fix panic after host or bus reset
      macintosh/via-macii: Access autopoll_devs when inside lock

Florian Fainelli (1):
      irqchip/irq-bcm7038-l1: Guard uses of cpu_logical_map

Florian Westphal (1):
      netfilter: nft_meta: fix iifgroup matching

Florinel Iordache (5):
      fsl/fman: use 32-bit unsigned integer
      fsl/fman: fix dereference null return value
      fsl/fman: fix unreachable code
      fsl/fman: check dereferencing null pointer
      fsl/fman: fix eth hash table allocation

Fred Oh (1):
      ASoC: Intel: Boards: cml_rt1011_rt5682: use statically define codec config

Frederic Weisbecker (1):
      tick/nohz: Narrow down noise while setting current task's tick dependency

Gao Xiang (1):
      erofs: fix extended inode could cross boundary

Gerald Schaefer (1):
      s390/gmap: improve THP splitting

Gilad Ben-Yossef (1):
      crypto: ccree - fix resource leak on error path

Giovanni Cabiddu (1):
      crypto: qat - allow xts requests not multiple of block

Giovanni Gherdovich (3):
      x86, sched: check for counters overflow in frequency invariant accounting
      x86, sched: Bail out of frequency invariance if turbo frequency is unknown
      x86, sched: Bail out of frequency invariance if turbo_freq/base_freq gives 0

Grant Likely (1):
      HID: input: Fix devices that return multiple bytes in battery report

Greg Kroah-Hartman (1):
      Linux 5.8.2

Gregory Herrero (1):
      recordmcount: only record relocation of type R_AARCH64_CALL26 on arm64.

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while down/up

Guillaume Tucker (1):
      ARM: exynos: clear L310_AUX_CTRL_FULL_LINE_ZERO in default l2c_aux_val

Guoyu Huang (1):
      io_uring: Fix NULL pointer dereference in loop_rw_iter()

Hangbin Liu (1):
      Revert "vxlan: fix tos value before xmit"

Hanjun Guo (1):
      PCI: Release IVRS table in AMD ACS quirk

Hannes Reinecke (1):
      nvme-multipath: do not fall back to __nvme_find_path() for non-optimized paths

Harish (1):
      selftests/powerpc: Fix CPU affinity for child process

Hauke Mehrtens (1):
      spi: lantiq-ssc: Fix warning by using WQ_MEM_RECLAIM

Hector Martin (3):
      ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
      ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109
      ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Heikki Krogerus (1):
      kobject: Avoid premature parent object freeing in kobject_cleanup()

Heiko Stuebner (3):
      arm64: dts: rockchip: fix rk3368-lion gmac reset gpio
      arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio
      arm64: dts: rockchip: fix rk3399-puma gmac reset gpio

Helen Koike (1):
      media: staging: rkisp1: rsz: fix resolution limitation on sink pad

Helge Deller (4):
      Revert "parisc: Improve interrupt handling in arch_spin_lock_flags()"
      Revert "parisc: Drop LDCW barrier in CAS code when running UP"
      Revert "parisc: Use ldcw instruction for SMP spinlock release barrier"
      Revert "parisc: Revert "Release spinlocks using ordered store""

Herbert Xu (1):
      crc-t10dif: Fix potential crypto notify dead-lock

Horia Geantă (1):
      crypto: caam - silence .setkey in case of bad key length

Huacai Chen (2):
      irqchip/loongson-pch-pic: Fix the misused irq flow handler
      MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64

Hui Wang (2):
      ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO
      ALSA: hda - reverse the setting value in the micmute_led_set

Ilya Leoshkevich (3):
      s390/bpf: Fix sign extension in branch_ku
      s390/bpf: Use brcl for jumping to exit_ip if necessary
      s390/bpf: Tolerate not converging code shrinking

Ioana Ciornei (1):
      dpaa2-eth: fix condition for number of buffer acquire retries

Ira Weiny (1):
      net/tls: Fix kmap usage

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers

Ivan Kokshaysky (1):
      cpufreq: dt: fix oops on armada37xx

Jack Wang (1):
      RDMA/rtrs: remove WQ_MEM_RECLAIM for rtrs_wq

Jack Xiao (1):
      drm/amdgpu: avoid dereferencing a NULL pointer

Jakub Kicinski (1):
      bitfield.h: don't compile-time validate _val in FIELD_FIT

Jarkko Sakkinen (1):
      tpm: Unify the mismatching TPM space buffer sizes

Jason Baron (1):
      tcp: correct read of TFO keys on big endian systems

Jason Gunthorpe (1):
      RDMA/core: Fix bogus WARN_ON during ib_unregister_device_queued()

Jens Axboe (9):
      io_uring: abstract out task work running
      io_uring: set ctx sq/cq entry count earlier
      io_uring: use TWA_SIGNAL for task_work uncondtionally
      io_uring: fail poll arm on queue proc failure
      io_uring: sanitize double poll handling
      io_uring: hold 'ctx' reference around task_work queue + execute
      io_uring: add missing REQ_F_COMP_LOCKED for nested requests
      io_uring: enable lookup of links holding inflight files
      task_work: only grab task signal lock when needed

Jerome Brunet (4):
      ASoC: meson: axg-tdm-interface: fix link fmt setup
      ASoC: meson: axg-tdmin: fix g12a skew
      ASoC: meson: axg-tdm-formatters: fix sclk inversion
      ASoC: meson: cards: deal dpcm flag change

Jerry Crunchtime (1):
      libbpf: Fix register in PT_REGS MIPS macros

Jian Cai (1):
      crypto: aesni - add compatibility with IAS

Jim Cromie (1):
      dyndbg: fix a BUG_ON in ddebug_describe_flags

Jing Xiangfeng (1):
      ASoC: meson: fixes the missed kfree() for axg_card_add_tdm_loopback

Joe Perches (1):
      powerpc/mm: Fix typo in IS_ENABLED()

Johan Hovold (2):
      USB: serial: iuu_phoenix: fix led-activity helpers
      net: phy: fix memory leak in device-create error path

Johannes Thumshirn (1):
      block: don't do revalidate zones on invalid devices

John Allen (1):
      crypto: ccp - Fix use of merged scatterlists

John David Anglin (2):
      parisc: Do not use an ordered store in pa_tlb_lock()
      parisc: Implement __smp_store_release and __smp_load_acquire barriers

John Garry (1):
      scsi: scsi_debug: Add check for sdebug_max_queue during module init

John Ogness (1):
      af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jon Derrick (1):
      irqdomain/treewide: Free firmware node after domain removal

Jon Lin (1):
      spi: rockchip: Fix error in SPI slave pio read

Jonathan Marek (1):
      drm/msm/dpu: don't use INTF_INPUT_CTRL feature on sdm845

Jonathan McDowell (1):
      firmware: qcom_scm: Fix legacy convention SCM accessors

Josef Bacik (2):
      btrfs: fix lockdep splat from btrfs_dump_space_info
      ftrace: Fix ftrace_trace_task return value

Julian Anastasov (1):
      ipvs: allow connection reuse for unconfirmed conntrack

Julian Wiedmann (2):
      s390/qeth: tolerate pre-filled RX buffer
      s390/qeth: don't process empty bridge port events

Kai Vehmanen (1):
      ASoC: hdac_hda: fix deadlock after PCM open error

Kai-Heng Feng (1):
      leds: core: Flush scheduled work for system suspend

Kamal Dasu (1):
      mtd: rawnand: brcmnand: Don't default to edu transfer

Kan Liang (1):
      perf/x86/intel/uncore: Fix oops when counting IMC uncore events on some TGL

Kars Mulder (1):
      usb: core: fix quirks_param_set() writing to a const pointer

Kees Cook (5):
      seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID
      lkdtm: Avoid more compiler optimizations for bad writes
      selftests/lkdtm: Reset WARN_ONCE to avoid false negatives
      lkdtm: Make arch-specific tests always available
      firmware_loader: EFI firmware loader must handle pre-allocated buffer

Kishon Vijay Abraham I (2):
      PCI: cadence: Fix cdns_pcie_{host|ep}_setup() error path
      PCI: cadence: Fix updating Vendor ID and Subsystem Vendor ID register

Krzysztof Kozlowski (1):
      memory: samsung: exynos5422-dmc: Do not ignore return code of regmap_read()

Kunihiko Hayashi (1):
      dt-bindings: phy: uniphier: Fix incorrect clocks and clock-names for PXs3 usb3-hsphy

Lang Cheng (1):
      RDMA/hns: Fix error during modify qp RTS2RTS

Laurent Pinchart (1):
      drm: panel: simple: Fix bpc for LG LB070WV8 panel

Leon Romanovsky (1):
      net/mlx5: Delete extra dump stack that gives nothing

Li Heng (1):
      RDMA/core: Fix return error value in _ib_modify_qp() to negative

Lihong Kou (1):
      Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Linus Walleij (2):
      net: dsa: rtl8366: Fix VLAN semantics
      net: dsa: rtl8366: Fix VLAN set-up

Lionel Landwerlin (1):
      dma-buf: fix dma-fence-chain out of order test

Lorenzo Bianconi (2):
      mt76: mt7615: fix possible memory leak in mt7615_mcu_wtbl_sta_add
      net: mvpp2: fix memory leak in mvpp2_rx

Lu Baolu (1):
      iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu

Lu Wei (2):
      platform/x86: intel-hid: Fix return value check in check_acpi_dev()
      platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()

Lubomir Rintel (1):
      drm/etnaviv: Fix error path on failure to enable bus clk

Luis Chamberlain (2):
      blktrace: fix debugfs use after free
      loop: be paranoid on exit and prevent new additions / removals

Lyude Paul (1):
      drm/nouveau/kms/nv50-: Fix disabling dithering

Madhavan Srinivasan (1):
      powerpc/perf: Fix missing is_sier_aviable() during build

Marc Zyngier (1):
      PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent

Marco Felsch (1):
      drm/imx: tve: fix regulator_disable error path

Marek Behún (1):
      net: phy: marvell10g: fix null pointer dereference

Marek Szyprowski (5):
      ARM: exynos: MCPM: Restore big.LITTLE cpuidle support
      ARM: dts: exynos: Disable frequency scaling for FSYS bus on Odroid XU3 family
      phy: exynos5-usbdrd: Calibrating makes sense only for USB2.0 PHY
      usb: dwc2: Fix error path in gadget registration
      ARM: dts: exynos: Extend all Exynos5800 A15's OPPs with max voltage data

Marek Vasut (1):
      drm/stm: repair runtime power management

Mark Starovoytov (1):
      net: atlantic: MACSec offload statistics checkpatch fix

Mark Zhang (1):
      RDMA/netlink: Remove CAP_NET_RAW check when dump a raw QP

Martin Wilck (1):
      nvme-multipath: fix logic for non-optimized paths

Masahiro Yamada (1):
      mmc: sdhci-cadence: do not use hardware tuning for SD mode

Matteo Croce (1):
      pstore: Fix linking when crypto API disabled

Matthias Kaehlcke (1):
      Bluetooth: hci_qca: Only remove TX clock vote after TX is completed

Maulik Shah (1):
      soc: qcom: rpmh-rsc: Set suppress_bind_attrs flag

Max Gurtovoy (1):
      vdpasim: protect concurrent access to iommu iotlb

Maxim Levitsky (1):
      kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host

Miaohe Lin (2):
      net: Fix potential memory leak in proto_register()
      net: Set fput_needed iff FDPUT_FPUT is set

Michael Ellerman (2):
      powerpc/32s: Fix CONFIG_BOOK3S_601 uses
      powerpc/boot: Fix CONFIG_PPC_MPC52XX references

Michael Tretter (1):
      drm/debugfs: fix plain echo to connector "force" attribute

Michael Walle (1):
      gpio: regmap: fix type clash

Michal Kalderon (2):
      RDMA/qedr: Add EDPM mode type for user-fw compatibility
      RDMA/qedr: Add EDPM max size to alloc ucontext response

Mike Leach (2):
      coresight: etmv4: Fix resource selector constant
      coresight: etmv4: Counter values not saved on disable

Mikhail Malygin (1):
      RDMA/rxe: Prevent access to wr->next ptr afrer wr is posted to send queue

Mikulas Patocka (2):
      crypto: hisilicon - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
      crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified

Milton Miller (1):
      powerpc/vdso: Fix vdso cpu truncation

Mirko Dietrich (1):
      ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Nathan Huckleberry (1):
      ARM: 8992/1: Fix unwind_frame for clang-built kernels

Nathan Lynch (3):
      powerpc/pseries: remove cede offline state for CPUs
      powerpc/rtas: don't online CPUs for partition suspend
      powerpc/pseries/hotplug-cpu: Remove double free in error path

Navid Emamdoost (1):
      drm/etnaviv: fix ref count leak via pm_runtime_get_sync

Nick Desaulniers (2):
      tracepoint: Mark __tracepoint_string's __used
      x86/uaccess: Make __get_user_size() Clang compliant on 32-bit

Nicolas Boichat (2):
      Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
      Bluetooth: hci_serdev: Only unregister device if it was registered

Niklas Söderlund (2):
      ARM: dts: gose: Fix ports node name for adv7180
      ARM: dts: gose: Fix ports node name for adv7612

Nirmoy Das (1):
      drm/mm: fix hole size comparison

Oleksandr Andrushchenko (2):
      xen/gntdev: Fix dmabuf import with non-zero sgt offset
      drm/xen-front: Fix misused IS_ERR_OR_NULL checks

Oliver Neukum (1):
      go7007: add sanity checking for endpoints

Oliver O'Halloran (1):
      selftests/powerpc: Squash spurious errors due to device removal

Ondrej Jirman (1):
      arm64: dts: sun50i-pinephone: dldo4 must not be >= 1.8V

Pali Rohár (4):
      mwifiex: Fix firmware filename for sd8977 chipset
      mwifiex: Fix firmware filename for sd8997 chipset
      btmrvl: Fix firmware filename for sd8977 chipset
      btmrvl: Fix firmware filename for sd8997 chipset

Patrick Delaunay (1):
      ARM: dts: stm32: Fix spi4 pins in stm32mp15-pinctrl

Patrick Steinhardt (1):
      Bluetooth: Fix update of connection state in `hci_encrypt_cfm`

Paul E. McKenney (2):
      fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls
      mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Pavel Begunkov (3):
      io_uring: fix req->work corruption
      io_uring: fix racy overflow count reporting
      io_uring: fix stalled deferred requests

Pavel Machek (1):
      ocfs2: fix unbalanced locking

Peng Liu (1):
      sched: correct SD_flags returned by tl->sd_flags()

Peter Chen (2):
      phy: cadence: salvo: fix wrong bit definition
      usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint

Phil Elwell (1):
      staging: vchiq_arm: Add a matching unregister call

Philipp Zabel (1):
      drm/imx: fix use after free

Pierre-Louis Bossart (5):
      ASoC: SOF: nocodec: add missing .owner field
      ASoC: Intel: cml_rt1011_rt5682: add missing .owner field
      ASoC: Intel: sof_sdw: add missing .owner field
      ASoC: Intel: bxt_rt298: add missing .owner field
      ASoC: core: use less strict tests for dailink capabilities

Prasanna Kerekoppa (1):
      brcmfmac: To fix Bss Info flag definition Bug

Qais Yousef (1):
      sched/uclamp: Fix initialization of struct uclamp_rq

Qingyu Li (1):
      net/nfc/rawsock.c: add CAP_NET_RAW check.

Qiushi Wu (2):
      EDAC: Fix reference count leaks
      agp/intel: Fix a memory leak on module initialisation failure

Qu Wenruo (2):
      btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation
      btrfs: qgroup: free per-trans reserved space when a subvolume gets dropped

Ravi Bangoria (3):
      powerpc/watchpoint: Fix 512 byte boundary limit
      powerpc/watchpoint: Fix DAWR exception constraint
      powerpc/watchpoint: Fix DAWR exception for CACHEOP

Ricardo Cañuelo (1):
      arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Rob Clark (1):
      drm/msm: ratelimit crtc event overflow error

Roger Pau Monne (2):
      xen/balloon: fix accounting in alloc_xenballooned_pages error path
      xen/balloon: make the balloon wait interruptible

Romain Naour (1):
      include/asm-generic/vmlinux.lds.h: align ro_after_init

Ronak Doshi (1):
      vmxnet3: use correct tcp hdr length when packet is encapsulated

Ruslan Bilovol (1):
      usb: gadget: f_uac2: fix AC Interface Header Descriptor wTotalLength

Russell King (1):
      phy: armada-38x: fix NETA lockup when repeatedly switching speeds

Ryder Lee (1):
      mt76: mt7915: add missing CONFIG_MAC80211_DEBUGFS

Sagi Grimberg (2):
      nvme-tcp: fix controller reset hang during traffic
      nvme-rdma: fix controller reset hang during traffic

Sai Prakash Ranjan (1):
      coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Sandipan Das (1):
      selftests/powerpc: Fix online CPU selection

Sasi Kumar (1):
      bdc: Fix bug causing crash after multiple disconnects

Scott Mayhew (1):
      nfsd: avoid a NULL dereference in __cld_pipe_upcall()

Sean Wang (5):
      Bluetooth: btusb: fix up firmware download sequence
      Bluetooth: btmtksdio: fix up firmware download sequence
      mt76: mt7663u: fix memory leak in set key
      mt76: mt7663u: fix potential memory leak in mcu message handler
      mt76: mt7615: fix potential memory leak in mcu message handler

Sedat Dilek (1):
      crypto: aesni - Fix build with LLVM_IAS=1

Serge Semin (1):
      spi: dw-dma: Fix Tx DMA channel working too fast

Shannon Nelson (2):
      ionic: rearrange reset and bus-master control
      ionic: update eid test for overflow

Shengjiu Wang (2):
      ASoC: fsl_easrc: Fix uninitialized scalar variable in fsl_easrc_set_ctx_format
      ASoC: fsl_sai: Fix value of FSL_SAI_CR1_RFW_MASK

Sibi Sankar (1):
      soc: qcom: pdr: Reorder the PD state indication ack

Sivaprakash Murugesan (1):
      mtd: rawnand: qcom: avoid write to unavailable register

Stanley Chu (2):
      scsi: ufs: Fix imprecise load calculation in devfreq window
      scsi: ufs: Disable WriteBooster capability for non-supported UFS devices

Stefan Haberland (1):
      s390/dasd: fix inability to use DASD with DIAG driver

Stefan Roese (1):
      net: macb: Properly handle phylink on at91sam9x

Stefano Garzarella (1):
      vsock: fix potential null pointer dereference in vsock_poll()

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

Stephen Hemminger (1):
      hv_netvsc: do not use VF device if link is down

Stephen Smalley (1):
      scripts/selinux/mdp: fix initial SID handling

Steve Longerbeam (1):
      gpu: ipu-v3: Restore RGB32, BGR32

Steven Price (1):
      drm/panfrost: Fix inbalance of devfreq record_busy/idle()

Steven Rostedt (VMware) (1):
      tracing: Move pipe reference to trace array instead of current_tracer

Sudeep Holla (1):
      clk: scmi: Fix min and max rate when registering clocks with discrete rates

Sumeet Pawnikar (1):
      thermal: int340x: processor_thermal: fix: update Jasper Lake PCI id

Surabhi Boob (1):
      ice: Graceful error handling in HW table calloc failure

Suzuki K Poulose (1):
      coresight: etm4x: Fix save/restore during cpu idle

Sven Auhagen (1):
      cpufreq: ap806: fix cpufreq driver needs ap cpu clk

Sven Schnelle (1):
      parisc: mask out enable and reserved bits from sba imask

Taniya Das (1):
      clk: qcom: gcc: Make disp gpll0 branch aon for sc7180/sdm845

Tetsuo Handa (1):
      driver core: Fix probe_count imbalance in really_probe()

Thierry Reding (1):
      r8152: Use MAC address from correct device tree node

Tianjia Zhang (3):
      tools, bpftool: Fix wrong return value in do_dump()
      net: ethernet: aquantia: Fix wrong return value
      liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tiezhu Yang (7):
      irqchip/ti-sci-inta: Fix return value about devm_ioremap_resource()
      irqchip/loongson-htvec: Fix potential resource leak
      irqchip/loongson-htvec: Check return value of irq_domain_translate_onecell()
      irqchip/loongson-pch-pic: Check return value of irq_domain_translate_twocell()
      irqchip/loongson-liointc: Fix potential dead lock
      PCI: loongson: Use DECLARE_PCI_FIXUP_EARLY for bridge_class_quirk()
      nvmem: sprd: Fix return value of sprd_efuse_probe()

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tom Rix (3):
      drm/bridge: sil_sii8620: initialize return of sii8620_readb
      power: supply: check if calc_soc succeeded in pm860x_init_battery
      crypto: qat - fix double free in qat_uclo_create_batch_init_list

Tomas Henzl (1):
      scsi: megaraid_sas: Clear affinity hint

Tomasz Duszynski (1):
      iio: improve IIO_CONCENTRATION channel type description

Tomi Valkeinen (1):
      drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Tony Lindgren (1):
      bus: ti-sysc: Add missing quirk flags for usb_host_hs

Tony Nguyen (1):
      iavf: Fix updating statistics

Trond Myklebust (2):
      NFS: Don't move layouts to plh_return_segs list while in use
      NFS: Don't return layout segments that are in use

Tsang-Shian Lin (2):
      rtw88: fix LDPC field for RA info
      rtw88: fix short GI capability based on current bandwidth

Tuomas Tynkkynen (1):
      media: media-request: Fix crash if memory allocation fails

Tyler Hicks (7):
      tpm: Require that all digests are present in TCG_PCR_EVENT2 structures
      ima: Have the LSM free its audit rule
      ima: Free the entire rule when deleting a list of rules
      ima: Free the entire rule if it fails to parse
      ima: Fail rule parsing when buffer hook functions have an invalid action
      ima: Fail rule parsing when the KEXEC_CMDLINE hook is combined with an invalid cond
      ima: Fail rule parsing when the KEY_CHECK hook is combined with an invalid cond

Uladzislau Rezki (Sony) (1):
      rcu/tree: Repeat the monitor if any free channel is busy

Venkata Lakshmi Narayana Gubba (3):
      Bluetooth: hci_qca: Bug fixes for SSR
      Bluetooth: hci_qca: Bug fix during SSR timeout
      Bluetooth: hci_qca: Stop collecting memdump again for command timeout during SSR

Vignesh Sridhar (1):
      ice: Clear and free XLT entries on reset

Vincent Guittot (1):
      sched/fair: Fix NOHZ next idle balance

Viresh Kumar (1):
      cpufreq: Fix locking issues with governors

Vladimir Oltean (1):
      net: mscc: ocelot: fix encoding destination ports into multicast IPv4 address

Vladimir Zapolskiy (1):
      regulator: fix memory leak on error path of regulator_register()

WANG Xuerui (1):
      MIPS: only register FTLBPar exception handler for supported models

Wang Hai (5):
      cxl: Fix kobject memleak
      net: ll_temac: Use devm_platform_ioremap_resource_byname()
      qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()
      wl1251: fix always return 0 error
      dlm: Fix kobject memleak

Wei Yongjun (1):
      iavf: fix error return code in iavf_init_get_resources()

Wenbo Zhang (1):
      bpf: Fix fds_example SIGSEGV error

Wenjing Liu (1):
      drm/amd/display: allow query ddc data over aux to be read only operation

Will Chen (1):
      kunit: capture stderr on all make subprocess calls

Willem de Bruijn (1):
      selftests/net: relax cpu affinity requirement in msg_zerocopy test

Wright Feng (2):
      brcmfmac: keep SDIO watchdog running when console_interval is non-zero
      brcmfmac: set state of hanger slot to FREE when flushing PSQ

Xi Wang (1):
      RDMA/hns: Fix the unneeded process when getting a general type of CQE error

Xie He (1):
      drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

Xin Long (1):
      net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()

Xiongfeng Wang (1):
      PCI/ASPM: Add missing newline in sysfs 'policy'

Yan-Hsuan Chuang (1):
      rtw88: coex: only skip coex triggered by BT info

Ye Bin (1):
      scsi: core: Add missing scsi_device_put() in scsi_host_block()

Yonghong Song (1):
      bpf: Fix pos computation for bpf_iter seq_ops->start()

Yoshihiro Shimoda (2):
      arm64: dts: renesas: Fix SD Card/eMMC interface device node names
      phy: renesas: rcar-gen3-usb2: move irq registration to init

Yu Kuai (2):
      ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()
      MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

YueHaibing (2):
      tools/bpftool: Fix error handing in do_skeleton()
      dpaa2-eth: Fix passing zero to 'PTR_ERR' warning

Yuval Basson (2):
      RDMA/qedr: SRQ's bug fixes
      qed: Fix ILT and XRCD bitmap memory leaks

Zenghui Yu (1):
      irqchip/gic-v4.1: Use GFP_ATOMIC flag in allocate_vpe_l1_table()

Zhao Heming (1):
      md-cluster: fix wild pointer of unlock_all_bitmaps()

Zheng Bin (1):
      9p: Fix memory leak in v9fs_mount

Zhenzhong Duan (1):
      x86/mce/inject: Fix a wrong assignment of i_mce.status

Zhu Yanjun (1):
      RDMA/rxe: Skip dgid check in loopback mode

shirley her (1):
      mmc: sdhci-pci-o2micro: Bug fix for O2 host controller Seabird1

yu kuai (1):
      ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

Álvaro Fernández Rojas (1):
      clk: bcm63xx-gate: fix last clock availability

