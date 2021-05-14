Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DA4380762
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhENKhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbhENKg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2197D613B5;
        Fri, 14 May 2021 10:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620988547;
        bh=X/DlER5CXbqZRIVkYn/+ZbFB9MxPTUyL9V7GlE8z9/U=;
        h=From:To:Cc:Subject:Date:From;
        b=1PaWelw4IBOsSKAMAeowmg6tlxBQZEOSnUdHVQwBwORHSSsyRMzF1qLAg0AMYdJgv
         piSGwrmNTz3V7QWNZF5CEAXOGcQzALajiPoV2ihkPs3rWeZB/Q3JEVoDrCAMFlXQrO
         HChTf5A8YByXvf69VB5jrlVlBZkIyXlYD0KEWIUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.21
Date:   Fri, 14 May 2021 12:35:42 +0200
Message-Id: <16209885438911@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.21 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                                          |   15 
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml                              |    3 
 Documentation/driver-api/xilinx/eemi.rst                                                 |   31 
 Documentation/userspace-api/media/v4l/subdev-formats.rst                                 |    4 
 Makefile                                                                                 |    2 
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts                                             |    4 
 arch/arm/boot/dts/exynos4210-i9100.dts                                                   |    2 
 arch/arm/boot/dts/exynos4412-midas.dtsi                                                  |    6 
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi                                          |    2 
 arch/arm/boot/dts/exynos4412-p4note.dtsi                                                 |    4 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                                                |    2 
 arch/arm/boot/dts/exynos5250-snow-common.dtsi                                            |    2 
 arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts                                 |    2 
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts                                          |    2 
 arch/arm/boot/dts/r8a7790-lager.dts                                                      |    3 
 arch/arm/boot/dts/r8a7791-koelsch.dts                                                    |    3 
 arch/arm/boot/dts/r8a7791-porter.dts                                                     |    2 
 arch/arm/boot/dts/r8a7793-gose.dts                                                       |    3 
 arch/arm/boot/dts/r8a7794-alt.dts                                                        |    3 
 arch/arm/boot/dts/r8a7794-silk.dts                                                       |    2 
 arch/arm/boot/dts/s5pv210-fascinate4g.dts                                                |    2 
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi                                                 |   21 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                                                     |    2 
 arch/arm/crypto/poly1305-glue.c                                                          |    2 
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts                                              |    2 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                                                 |    7 
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi                                         |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                                             |   35 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                                               |    4 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                                     |    2 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                                     |    2 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                                     |    6 
 arch/arm64/boot/dts/renesas/hihope-common.dtsi                                           |    3 
 arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts                                |    3 
 arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts                                          |    2 
 arch/arm64/boot/dts/renesas/r8a77980.dtsi                                                |   16 
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts                                           |    3 
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi                                                |    5 
 arch/arm64/boot/dts/renesas/salvator-common.dtsi                                         |    3 
 arch/arm64/boot/dts/renesas/ulcb-kf.dtsi                                                 |    1 
 arch/arm64/boot/dts/renesas/ulcb.dtsi                                                    |    2 
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi                                         |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi                                         |    4 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                                                |   17 
 arch/arm64/crypto/poly1305-glue.c                                                        |    2 
 arch/arm64/include/asm/kvm_host.h                                                        |    1 
 arch/arm64/kvm/arm.c                                                                     |    6 
 arch/arm64/kvm/debug.c                                                                   |   88 -
 arch/arm64/kvm/reset.c                                                                   |    5 
 arch/arm64/kvm/vgic/vgic-kvm-device.c                                                    |    7 
 arch/ia64/kernel/efi.c                                                                   |   11 
 arch/m68k/include/asm/mvme147hw.h                                                        |    3 
 arch/m68k/kernel/sys_m68k.c                                                              |    2 
 arch/m68k/mvme147/config.c                                                               |   14 
 arch/m68k/mvme16x/config.c                                                               |   14 
 arch/mips/Kconfig                                                                        |    1 
 arch/mips/boot/dts/brcm/bcm3368.dtsi                                                     |    2 
 arch/mips/boot/dts/brcm/bcm63268.dtsi                                                    |    2 
 arch/mips/boot/dts/brcm/bcm6358.dtsi                                                     |    2 
 arch/mips/boot/dts/brcm/bcm6362.dtsi                                                     |    2 
 arch/mips/boot/dts/brcm/bcm6368.dtsi                                                     |    2 
 arch/mips/crypto/poly1305-glue.c                                                         |    2 
 arch/mips/generic/board-boston.its.S                                                     |   10 
 arch/mips/generic/board-jaguar2.its.S                                                    |   16 
 arch/mips/generic/board-luton.its.S                                                      |    8 
 arch/mips/generic/board-ni169445.its.S                                                   |   10 
 arch/mips/generic/board-ocelot.its.S                                                     |   20 
 arch/mips/generic/board-serval.its.S                                                     |    8 
 arch/mips/generic/board-xilfpga.its.S                                                    |   10 
 arch/mips/generic/vmlinux.its.S                                                          |   10 
 arch/mips/include/asm/asmmacro.h                                                         |    3 
 arch/mips/loongson64/init.c                                                              |    2 
 arch/mips/pci/pci-legacy.c                                                               |    9 
 arch/mips/pci/pci-mt7620.c                                                               |    5 
 arch/mips/pci/pci-rt2880.c                                                               |   37 
 arch/powerpc/Kconfig                                                                     |    2 
 arch/powerpc/Kconfig.debug                                                               |    1 
 arch/powerpc/include/asm/book3s/64/pgtable.h                                             |    4 
 arch/powerpc/include/asm/book3s/64/radix.h                                               |    6 
 arch/powerpc/include/asm/fixmap.h                                                        |    9 
 arch/powerpc/include/asm/nohash/64/pgtable.h                                             |    5 
 arch/powerpc/include/asm/smp.h                                                           |    5 
 arch/powerpc/kernel/Makefile                                                             |    2 
 arch/powerpc/kernel/fadump.c                                                             |    2 
 arch/powerpc/kernel/interrupt.c                                                          |  442 +++++++
 arch/powerpc/kernel/prom.c                                                               |    2 
 arch/powerpc/kernel/smp.c                                                                |   39 
 arch/powerpc/kernel/syscall_64.c                                                         |  441 -------
 arch/powerpc/kvm/book3s_hv.c                                                             |    3 
 arch/powerpc/mm/book3s64/hash_pgtable.c                                                  |    6 
 arch/powerpc/mm/book3s64/radix_pgtable.c                                                 |    4 
 arch/powerpc/mm/mem.c                                                                    |    2 
 arch/powerpc/perf/isa207-common.c                                                        |    4 
 arch/powerpc/perf/power10-events-list.h                                                  |    4 
 arch/powerpc/platforms/52xx/lite5200_sleep.S                                             |    2 
 arch/powerpc/platforms/pseries/iommu.c                                                   |    2 
 arch/powerpc/platforms/pseries/lpar.c                                                    |    4 
 arch/powerpc/platforms/pseries/pci_dlpar.c                                               |    4 
 arch/powerpc/platforms/pseries/vio.c                                                     |    4 
 arch/powerpc/sysdev/xive/common.c                                                        |   35 
 arch/s390/kernel/setup.c                                                                 |    4 
 arch/s390/kvm/gaccess.c                                                                  |   30 
 arch/s390/kvm/gaccess.h                                                                  |   60 
 arch/s390/kvm/kvm-s390.c                                                                 |    4 
 arch/s390/kvm/vsie.c                                                                     |  109 +
 arch/x86/Kconfig                                                                         |    1 
 arch/x86/crypto/poly1305_glue.c                                                          |    6 
 arch/x86/entry/vdso/vdso2c.h                                                             |    2 
 arch/x86/events/amd/iommu.c                                                              |    6 
 arch/x86/events/amd/uncore.c                                                             |    6 
 arch/x86/kernel/apic/x2apic_uv_x.c                                                       |    3 
 arch/x86/kernel/cpu/microcode/core.c                                                     |    8 
 arch/x86/kernel/e820.c                                                                   |    4 
 arch/x86/kernel/kprobes/core.c                                                           |   17 
 arch/x86/kernel/smpboot.c                                                                |   90 -
 arch/x86/kvm/emulate.c                                                                   |   80 -
 arch/x86/kvm/mmu/mmu.c                                                                   |   63 -
 arch/x86/kvm/svm/sev.c                                                                   |   42 
 arch/x86/kvm/svm/svm.c                                                                   |   34 
 arch/x86/kvm/vmx/nested.c                                                                |   17 
 arch/x86/kvm/vmx/vmx.c                                                                   |   13 
 arch/x86/kvm/x86.c                                                                       |    5 
 arch/x86/power/hibernate.c                                                               |   89 -
 crypto/async_tx/async_xor.c                                                              |    1 
 drivers/acpi/cppc_acpi.c                                                                 |   14 
 drivers/ata/libahci_platform.c                                                           |    4 
 drivers/ata/pata_arasan_cf.c                                                             |   15 
 drivers/ata/pata_ixp4xx_cf.c                                                             |    6 
 drivers/ata/sata_mv.c                                                                    |    4 
 drivers/base/devtmpfs.c                                                                  |    2 
 drivers/base/node.c                                                                      |   26 
 drivers/base/regmap/regmap-debugfs.c                                                     |    1 
 drivers/block/ataflop.c                                                                  |   16 
 drivers/block/null_blk/zoned.c                                                           |    1 
 drivers/block/rnbd/rnbd-clt-sysfs.c                                                      |    6 
 drivers/block/xen-blkback/common.h                                                       |    1 
 drivers/block/xen-blkback/xenbus.c                                                       |   38 
 drivers/bus/qcom-ebi2.c                                                                  |    4 
 drivers/bus/ti-sysc.c                                                                    |    6 
 drivers/char/ttyprintk.c                                                                 |   11 
 drivers/clk/clk-ast2600.c                                                                |    4 
 drivers/clk/imx/clk-imx25.c                                                              |   12 
 drivers/clk/imx/clk-imx27.c                                                              |   13 
 drivers/clk/imx/clk-imx35.c                                                              |   10 
 drivers/clk/imx/clk-imx5.c                                                               |   30 
 drivers/clk/imx/clk-imx6q.c                                                              |   16 
 drivers/clk/imx/clk-imx6sl.c                                                             |   16 
 drivers/clk/imx/clk-imx6sll.c                                                            |   24 
 drivers/clk/imx/clk-imx6sx.c                                                             |   16 
 drivers/clk/imx/clk-imx7d.c                                                              |   22 
 drivers/clk/imx/clk-imx7ulp.c                                                            |   31 
 drivers/clk/imx/clk-imx8mm.c                                                             |   18 
 drivers/clk/imx/clk-imx8mn.c                                                             |   18 
 drivers/clk/imx/clk-imx8mp.c                                                             |   17 
 drivers/clk/imx/clk-imx8mq.c                                                             |   18 
 drivers/clk/imx/clk.c                                                                    |   41 
 drivers/clk/imx/clk.h                                                                    |    4 
 drivers/clk/mvebu/armada-37xx-periph.c                                                   |   83 -
 drivers/clk/qcom/a53-pll.c                                                               |    1 
 drivers/clk/qcom/apss-ipq-pll.c                                                          |    1 
 drivers/clk/uniphier/clk-uniphier-mux.c                                                  |    4 
 drivers/clk/zynqmp/pll.c                                                                 |   24 
 drivers/clocksource/ingenic-ost.c                                                        |    4 
 drivers/clocksource/timer-ti-dm-systimer.c                                               |   13 
 drivers/cpufreq/armada-37xx-cpufreq.c                                                    |   76 +
 drivers/cpuidle/Kconfig.arm                                                              |    2 
 drivers/crypto/allwinner/Kconfig                                                         |   14 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c                                        |    9 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c                                        |    4 
 drivers/crypto/ccp/sev-dev.c                                                             |    3 
 drivers/crypto/ccp/tee-dev.c                                                             |   49 
 drivers/crypto/ccp/tee-dev.h                                                             |   20 
 drivers/crypto/chelsio/chcr_algo.c                                                       |   19 
 drivers/crypto/keembay/keembay-ocs-aes-core.c                                            |    4 
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c                                                 |    4 
 drivers/crypto/qat/qat_c62xvf/adf_drv.c                                                  |    4 
 drivers/crypto/qat/qat_common/adf_isr.c                                                  |   29 
 drivers/crypto/qat/qat_common/adf_transport.c                                            |    1 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                                               |   17 
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c                                              |    4 
 drivers/crypto/sa2ul.c                                                                   |    8 
 drivers/devfreq/devfreq.c                                                                |    5 
 drivers/firmware/Kconfig                                                                 |    1 
 drivers/firmware/qcom_scm-smc.c                                                          |   12 
 drivers/firmware/qcom_scm.c                                                              |   88 -
 drivers/firmware/qcom_scm.h                                                              |    7 
 drivers/firmware/xilinx/zynqmp.c                                                         |    5 
 drivers/fpga/xilinx-spi.c                                                                |   24 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c                                                  |   19 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c                                                  |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                                                   |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                                                   |    1 
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                                                    |   13 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                                                    |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c                                                   |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h                                                   |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                                        |   20 
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c                                             |    2 
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c                                            |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c                                        |    2 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                                    |   26 
 drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c                                           |    9 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                                                |    1 
 drivers/gpu/drm/bridge/Kconfig                                                           |    3 
 drivers/gpu/drm/bridge/analogix/Kconfig                                                  |    1 
 drivers/gpu/drm/bridge/panel.c                                                           |   12 
 drivers/gpu/drm/drm_dp_mst_topology.c                                                    |   17 
 drivers/gpu/drm/drm_probe_helper.c                                                       |    7 
 drivers/gpu/drm/i915/gvt/gvt.c                                                           |    8 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                                                |   11 
 drivers/gpu/drm/mcde/mcde_dsi.c                                                          |    2 
 drivers/gpu/drm/msm/msm_debugfs.c                                                        |   14 
 drivers/gpu/drm/msm/msm_drv.c                                                            |    3 
 drivers/gpu/drm/msm/msm_drv.h                                                            |    9 
 drivers/gpu/drm/msm/msm_gem.c                                                            |   14 
 drivers/gpu/drm/msm/msm_gem.h                                                            |   12 
 drivers/gpu/drm/panel/panel-novatek-nt35510.c                                            |    3 
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c                                            |    4 
 drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c                                        |    1 
 drivers/gpu/drm/panel/panel-sony-acx424akp.c                                             |    3 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                                                  |   13 
 drivers/gpu/drm/qxl/qxl_cmd.c                                                            |    2 
 drivers/gpu/drm/qxl/qxl_display.c                                                        |    4 
 drivers/gpu/drm/qxl/qxl_drv.c                                                            |    2 
 drivers/gpu/drm/qxl/qxl_gem.c                                                            |    2 
 drivers/gpu/drm/qxl/qxl_object.c                                                         |    5 
 drivers/gpu/drm/qxl/qxl_object.h                                                         |    1 
 drivers/gpu/drm/qxl/qxl_release.c                                                        |   18 
 drivers/gpu/drm/radeon/radeon_dp_mst.c                                                   |    3 
 drivers/gpu/drm/radeon/radeon_kms.c                                                      |    1 
 drivers/gpu/drm/stm/ltdc.c                                                               |   33 
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c                                                     |    9 
 drivers/gpu/drm/xlnx/zynqmp_dp.c                                                         |    2 
 drivers/hid/hid-ids.h                                                                    |    1 
 drivers/hid/hid-lenovo.c                                                                 |   47 
 drivers/hid/hid-plantronics.c                                                            |   60 
 drivers/hsi/hsi_core.c                                                                   |    3 
 drivers/hv/channel.c                                                                     |    2 
 drivers/hv/channel_mgmt.c                                                                |   30 
 drivers/hv/ring_buffer.c                                                                 |    1 
 drivers/hwmon/pmbus/pxe1610.c                                                            |    9 
 drivers/i2c/busses/i2c-cadence.c                                                         |    9 
 drivers/i2c/busses/i2c-emev2.c                                                           |    5 
 drivers/i2c/busses/i2c-img-scb.c                                                         |    4 
 drivers/i2c/busses/i2c-imx-lpi2c.c                                                       |    2 
 drivers/i2c/busses/i2c-imx.c                                                             |    4 
 drivers/i2c/busses/i2c-jz4780.c                                                          |    5 
 drivers/i2c/busses/i2c-mlxbf.c                                                           |    2 
 drivers/i2c/busses/i2c-mt65xx.c                                                          |    2 
 drivers/i2c/busses/i2c-omap.c                                                            |    8 
 drivers/i2c/busses/i2c-rcar.c                                                            |   64 -
 drivers/i2c/busses/i2c-sh7760.c                                                          |    5 
 drivers/i2c/busses/i2c-sprd.c                                                            |    4 
 drivers/i2c/busses/i2c-stm32f7.c                                                         |   12 
 drivers/i2c/busses/i2c-xiic.c                                                            |    4 
 drivers/i3c/master.c                                                                     |    5 
 drivers/iio/accel/adis16201.c                                                            |    2 
 drivers/iio/adc/Kconfig                                                                  |    2 
 drivers/iio/adc/ad7476.c                                                                 |   18 
 drivers/iio/imu/adis16480.c                                                              |  128 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                                               |   20 
 drivers/iio/proximity/sx9310.c                                                           |   52 
 drivers/infiniband/core/cm.c                                                             |    3 
 drivers/infiniband/core/cma.c                                                            |   12 
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                                                 |    1 
 drivers/infiniband/hw/bnxt_re/qplib_res.c                                                |    1 
 drivers/infiniband/hw/cxgb4/resource.c                                                   |    2 
 drivers/infiniband/hw/hfi1/firmware.c                                                    |    1 
 drivers/infiniband/hw/hfi1/mmu_rb.c                                                      |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                                               |    1 
 drivers/infiniband/hw/i40iw/i40iw_pble.c                                                 |    6 
 drivers/infiniband/hw/mlx5/fs.c                                                          |    9 
 drivers/infiniband/hw/mlx5/qp.c                                                          |   15 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                                                  |    4 
 drivers/infiniband/sw/rxe/rxe_av.c                                                       |    2 
 drivers/infiniband/sw/siw/siw_mem.c                                                      |    4 
 drivers/infiniband/ulp/isert/ib_isert.c                                                  |   16 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                                                   |    2 
 drivers/infiniband/ulp/srpt/ib_srpt.c                                                    |    1 
 drivers/iommu/amd/init.c                                                                 |    2 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h                                              |    2 
 drivers/iommu/dma-iommu.c                                                                |   30 
 drivers/iommu/intel/iommu.c                                                              |   52 
 drivers/iommu/intel/pasid.c                                                              |   16 
 drivers/iommu/intel/pasid.h                                                              |    1 
 drivers/iommu/intel/svm.c                                                                |   18 
 drivers/iommu/iommu.c                                                                    |   24 
 drivers/irqchip/irq-gic-v3-mbi.c                                                         |    2 
 drivers/mailbox/sprd-mailbox.c                                                           |   43 
 drivers/md/md-bitmap.c                                                                   |    2 
 drivers/md/md.c                                                                          |   73 -
 drivers/media/common/saa7146/saa7146_core.c                                              |    2 
 drivers/media/common/saa7146/saa7146_video.c                                             |    3 
 drivers/media/dvb-frontends/m88ds3103.c                                                  |    4 
 drivers/media/i2c/ccs/ccs-core.c                                                         |    4 
 drivers/media/i2c/imx219.c                                                               |   49 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                                                 |    2 
 drivers/media/pci/saa7134/saa7134-core.c                                                 |    2 
 drivers/media/platform/aspeed-video.c                                                    |    9 
 drivers/media/platform/meson/ge2d/ge2d.c                                                 |    4 
 drivers/media/platform/qcom/venus/core.c                                                 |    7 
 drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c                                  |    9 
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c                                     |    4 
 drivers/media/test-drivers/vivid/vivid-vid-out.c                                         |    2 
 drivers/media/tuners/m88rs6000t.c                                                        |    6 
 drivers/media/v4l2-core/v4l2-ctrls.c                                                     |   17 
 drivers/memory/omap-gpmc.c                                                               |    7 
 drivers/memory/pl353-smc.c                                                               |    2 
 drivers/memory/renesas-rpc-if.c                                                          |    2 
 drivers/memory/samsung/exynos5422-dmc.c                                                  |    4 
 drivers/mfd/intel_pmt.c                                                                  |   11 
 drivers/mfd/stm32-timers.c                                                               |    7 
 drivers/mfd/stmpe.c                                                                      |   14 
 drivers/misc/lis3lv02d/lis3lv02d.c                                                       |   21 
 drivers/misc/vmw_vmci/vmci_doorbell.c                                                    |    2 
 drivers/misc/vmw_vmci/vmci_guest.c                                                       |    2 
 drivers/mtd/maps/physmap-core.c                                                          |    4 
 drivers/mtd/mtdchar.c                                                                    |    8 
 drivers/mtd/mtdcore.c                                                                    |    3 
 drivers/mtd/mtdpart.c                                                                    |    2 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                                                 |    6 
 drivers/mtd/nand/raw/fsmc_nand.c                                                         |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                                               |    2 
 drivers/mtd/nand/raw/qcom_nandc.c                                                        |    7 
 drivers/net/dsa/mv88e6xxx/devlink.c                                                      |    2 
 drivers/net/dsa/mv88e6xxx/serdes.c                                                       |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                                                |   10 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h                                    |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c                                       |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                                        |   22 
 drivers/net/ethernet/freescale/Makefile                                                  |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                                          |    3 
 drivers/net/ethernet/marvell/prestera/prestera_main.c                                    |    3 
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c                                     |    2 
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c                                         |    1 
 drivers/net/ethernet/qualcomm/emac/emac-mac.c                                            |    4 
 drivers/net/ethernet/renesas/ravb_main.c                                                 |   35 
 drivers/net/ethernet/sfc/ef10.c                                                          |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                                        |   12 
 drivers/net/ethernet/ti/davinci_emac.c                                                   |    4 
 drivers/net/ethernet/xscale/ixp4xx_eth.c                                                 |    5 
 drivers/net/fddi/Kconfig                                                                 |   15 
 drivers/net/fddi/defxx.c                                                                 |   47 
 drivers/net/geneve.c                                                                     |    4 
 drivers/net/phy/intel-xway.c                                                             |   21 
 drivers/net/phy/marvell.c                                                                |   52 
 drivers/net/phy/smsc.c                                                                   |    7 
 drivers/net/wan/hdlc_fr.c                                                                |    5 
 drivers/net/wan/lapbether.c                                                              |   32 
 drivers/net/wireless/ath/ath10k/htc.c                                                    |    2 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                                                |    3 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                                            |    2 
 drivers/net/wireless/ath/ath9k/hw.c                                                      |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c                                           |    6 
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c                                         |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                                           |   20 
 drivers/net/wireless/marvell/mwl8k.c                                                     |    1 
 drivers/net/wireless/mediatek/mt76/dma.c                                                 |    2 
 drivers/net/wireless/mediatek/mt76/mt76.h                                                |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                                          |   44 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                                         |   12 
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h                                       |   10 
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c                                     |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c                                    |   11 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c                                      |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c                                          |    8 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c                                         |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                                          |   52 
 drivers/net/wireless/mediatek/mt76/mt7915/main.c                                         |   11 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                                          |   85 -
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h                                       |   11 
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c                                          |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h                                         |    3 
 drivers/net/wireless/mediatek/mt76/sdio.c                                                |    3 
 drivers/net/wireless/mediatek/mt76/tx.c                                                  |   28 
 drivers/net/wireless/mediatek/mt7601u/eeprom.c                                           |    2 
 drivers/net/wireless/microchip/wilc1000/sdio.c                                           |    2 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c                                   |  500 ++++++--
 drivers/net/wireless/realtek/rtw88/debug.c                                               |    2 
 drivers/net/wireless/realtek/rtw88/phy.c                                                 |    5 
 drivers/net/wireless/ti/wlcore/boot.c                                                    |   13 
 drivers/net/wireless/ti/wlcore/debugfs.h                                                 |    7 
 drivers/nfc/pn533/pn533.c                                                                |    3 
 drivers/nvme/host/multipath.c                                                            |    4 
 drivers/nvme/host/pci.c                                                                  |    2 
 drivers/nvme/host/tcp.c                                                                  |    4 
 drivers/nvme/target/tcp.c                                                                |   43 
 drivers/nvmem/qfprom.c                                                                   |   21 
 drivers/of/overlay.c                                                                     |    1 
 drivers/pci/controller/dwc/pci-keystone.c                                                |    3 
 drivers/pci/controller/pci-xgene.c                                                       |    3 
 drivers/pci/vpd.c                                                                        |    1 
 drivers/phy/cadence/phy-cadence-sierra.c                                                 |    7 
 drivers/phy/ingenic/phy-ingenic-usb.c                                                    |    4 
 drivers/phy/marvell/Kconfig                                                              |    4 
 drivers/phy/ralink/phy-mt7621-pci.c                                                      |    6 
 drivers/phy/ti/phy-j721e-wiz.c                                                           |   23 
 drivers/pinctrl/pinctrl-single.c                                                         |   63 -
 drivers/platform/x86/dell-wmi-sysman/sysman.c                                            |   32 
 drivers/platform/x86/pmc_atom.c                                                          |   28 
 drivers/power/supply/bq25980_charger.c                                                   |   40 
 drivers/regulator/bd9576-regulator.c                                                     |   11 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                                                   |    6 
 drivers/scsi/ibmvscsi/ibmvfc.c                                                           |   57 
 drivers/scsi/jazz_esp.c                                                                  |    4 
 drivers/scsi/lpfc/lpfc_els.c                                                             |   50 
 drivers/scsi/pm8001/pm8001_hwi.c                                                         |    2 
 drivers/scsi/pm8001/pm80xx_hwi.c                                                         |    4 
 drivers/scsi/sni_53c710.c                                                                |    5 
 drivers/scsi/sun3x_esp.c                                                                 |    4 
 drivers/scsi/ufs/ufshcd-pltfrm.c                                                         |    2 
 drivers/soc/aspeed/aspeed-lpc-snoop.c                                                    |    4 
 drivers/soc/qcom/mdt_loader.c                                                            |   17 
 drivers/soc/qcom/pdr_interface.c                                                         |    2 
 drivers/soc/tegra/regulators-tegra30.c                                                   |    2 
 drivers/soundwire/bus.c                                                                  |    3 
 drivers/soundwire/stream.c                                                               |   10 
 drivers/spi/spi-fsl-lpspi.c                                                              |    2 
 drivers/spi/spi-fsl-spi.c                                                                |   23 
 drivers/spi/spi-rockchip.c                                                               |   13 
 drivers/spi/spi-stm32.c                                                                  |   27 
 drivers/spi/spi-zynqmp-gqspi.c                                                           |  154 +-
 drivers/spi/spi.c                                                                        |    9 
 drivers/staging/comedi/drivers/tests/ni_routes_test.c                                    |    6 
 drivers/staging/fwserial/fwserial.c                                                      |   19 
 drivers/staging/greybus/uart.c                                                           |   13 
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c                                       |   19 
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c                                        |    4 
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c                                           |   13 
 drivers/staging/media/omap4iss/iss.c                                                     |    4 
 drivers/staging/media/rkvdec/rkvdec.c                                                    |   48 
 drivers/staging/media/rkvdec/rkvdec.h                                                    |    1 
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h                                         |   17 
 drivers/staging/rtl8192u/r8192U_core.c                                                   |    2 
 drivers/tty/amiserial.c                                                                  |    1 
 drivers/tty/moxa.c                                                                       |   18 
 drivers/tty/serial/liteuart.c                                                            |    4 
 drivers/tty/serial/omap-serial.c                                                         |   51 
 drivers/tty/serial/sc16is7xx.c                                                           |    2 
 drivers/tty/serial/serial_core.c                                                         |    6 
 drivers/tty/serial/stm32-usart.c                                                         |  610 +++++-----
 drivers/tty/serial/stm32-usart.h                                                         |    5 
 drivers/tty/tty_io.c                                                                     |    8 
 drivers/tty/tty_ioctl.c                                                                  |    4 
 drivers/usb/class/cdc-acm.c                                                              |   16 
 drivers/usb/dwc2/core_intr.c                                                             |  154 +-
 drivers/usb/dwc2/hcd.c                                                                   |   10 
 drivers/usb/gadget/udc/aspeed-vhub/core.c                                                |    3 
 drivers/usb/gadget/udc/aspeed-vhub/epn.c                                                 |    2 
 drivers/usb/gadget/udc/fotg210-udc.c                                                     |   26 
 drivers/usb/gadget/udc/pch_udc.c                                                         |  123 +-
 drivers/usb/gadget/udc/r8a66597-udc.c                                                    |    2 
 drivers/usb/gadget/udc/s3c2410_udc.c                                                     |   24 
 drivers/usb/gadget/udc/snps_udc_plat.c                                                   |    4 
 drivers/usb/host/xhci-mtk-sch.c                                                          |   80 +
 drivers/usb/host/xhci-mtk.h                                                              |    6 
 drivers/usb/roles/class.c                                                                |    2 
 drivers/usb/serial/ti_usb_3410_5052.c                                                    |    9 
 drivers/usb/serial/usb_wwan.c                                                            |    9 
 drivers/usb/typec/stusb160x.c                                                            |    4 
 drivers/usb/typec/tcpm/tcpci.c                                                           |   21 
 drivers/usb/typec/tcpm/tcpm.c                                                            |  116 +
 drivers/usb/typec/tps6598x.c                                                             |    4 
 drivers/usb/usbip/vudc_sysfs.c                                                           |    2 
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                                                        |   74 -
 drivers/vfio/mdev/mdev_sysfs.c                                                           |    2 
 drivers/vfio/pci/vfio_pci.c                                                              |  131 +-
 fs/afs/dir.c                                                                             |    7 
 fs/afs/dir_silly.c                                                                       |    3 
 fs/afs/fs_operation.c                                                                    |    6 
 fs/afs/inode.c                                                                           |   12 
 fs/afs/internal.h                                                                        |    2 
 fs/afs/write.c                                                                           |    1 
 fs/dlm/lowcomms.c                                                                        |    1 
 fs/io_uring.c                                                                            |   14 
 fs/nfsd/nfs4proc.c                                                                       |    4 
 fs/overlayfs/copy_up.c                                                                   |    3 
 fs/overlayfs/overlayfs.h                                                                 |   30 
 fs/overlayfs/readdir.c                                                                   |   12 
 fs/overlayfs/super.c                                                                     |    2 
 fs/overlayfs/util.c                                                                      |   31 
 fs/proc/array.c                                                                          |    2 
 fs/xfs/libxfs/xfs_attr.c                                                                 |    1 
 include/crypto/internal/poly1305.h                                                       |    3 
 include/crypto/poly1305.h                                                                |    6 
 include/keys/trusted-type.h                                                              |    1 
 include/linux/dma-iommu.h                                                                |    2 
 include/linux/firmware/xlnx-zynqmp.h                                                     |    5 
 include/linux/gpio/driver.h                                                              |    9 
 include/linux/hid.h                                                                      |    2 
 include/linux/intel-iommu.h                                                              |    3 
 include/linux/iommu.h                                                                    |    2 
 include/linux/kvm_host.h                                                                 |    4 
 include/linux/platform_device.h                                                          |    3 
 include/linux/pm_runtime.h                                                               |    2 
 include/linux/smp.h                                                                      |    2 
 include/linux/spi/spi.h                                                                  |    3 
 include/linux/tty_driver.h                                                               |    2 
 include/linux/udp.h                                                                      |   16 
 include/net/addrconf.h                                                                   |    1 
 include/net/bluetooth/hci_core.h                                                         |    1 
 include/net/netfilter/nf_tables_offload.h                                                |   12 
 include/uapi/linux/tty_flags.h                                                           |    4 
 init/init_task.c                                                                         |    2 
 kernel/bpf/ringbuf.c                                                                     |   24 
 kernel/bpf/verifier.c                                                                    |   30 
 kernel/kthread.c                                                                         |   33 
 kernel/printk/printk.c                                                                   |    9 
 kernel/rcu/tree.c                                                                        |    1 
 kernel/sched/core.c                                                                      |    2 
 kernel/sched/debug.c                                                                     |   42 
 kernel/sched/fair.c                                                                      |    5 
 kernel/sched/sched.h                                                                     |    7 
 kernel/smp.c                                                                             |   20 
 kernel/up.c                                                                              |    2 
 lib/bug.c                                                                                |   33 
 lib/crypto/poly1305-donna32.c                                                            |    3 
 lib/crypto/poly1305-donna64.c                                                            |    3 
 lib/crypto/poly1305.c                                                                    |    3 
 mm/memcontrol.c                                                                          |   10 
 mm/memory-failure.c                                                                      |    2 
 mm/slab.c                                                                                |    3 
 mm/slab.h                                                                                |    6 
 mm/slab_common.c                                                                         |    2 
 mm/slub.c                                                                                |    9 
 mm/sparse.c                                                                              |    1 
 net/bluetooth/hci_conn.c                                                                 |    4 
 net/bluetooth/hci_event.c                                                                |    3 
 net/bluetooth/hci_request.c                                                              |   12 
 net/bridge/br_multicast.c                                                                |   33 
 net/core/dev.c                                                                           |    8 
 net/ipv4/route.c                                                                         |   42 
 net/ipv4/tcp_cong.c                                                                      |    4 
 net/ipv4/udp.c                                                                           |    3 
 net/ipv6/mcast_snoop.c                                                                   |   12 
 net/mac80211/main.c                                                                      |    7 
 net/mptcp/protocol.c                                                                     |    4 
 net/netfilter/nf_tables_offload.c                                                        |   44 
 net/netfilter/nft_cmp.c                                                                  |   41 
 net/netfilter/nft_payload.c                                                              |   13 
 net/nfc/digital_dep.c                                                                    |    2 
 net/nfc/llcp_sock.c                                                                      |    4 
 net/packet/af_packet.c                                                                   |   15 
 net/packet/internal.h                                                                    |    2 
 net/sctp/socket.c                                                                        |   38 
 net/tipc/crypto.c                                                                        |    2 
 net/vmw_vsock/virtio_transport_common.c                                                  |   28 
 net/vmw_vsock/vmci_transport.c                                                           |    3 
 net/wireless/scan.c                                                                      |    2 
 net/xdp/xsk.c                                                                            |    8 
 samples/kfifo/bytestream-example.c                                                       |    8 
 samples/kfifo/inttype-example.c                                                          |    8 
 samples/kfifo/record-example.c                                                           |    8 
 security/integrity/ima/ima_template.c                                                    |    4 
 security/keys/trusted-keys/trusted_tpm1.c                                                |   32 
 security/keys/trusted-keys/trusted_tpm2.c                                                |   10 
 security/selinux/include/classmap.h                                                      |    5 
 sound/core/init.c                                                                        |    2 
 sound/pci/hda/patch_realtek.c                                                            |  162 +-
 sound/soc/codecs/ak5558.c                                                                |    4 
 sound/soc/codecs/tlv320aic32x4.c                                                         |   12 
 sound/soc/codecs/wm8960.c                                                                |   12 
 sound/soc/generic/audio-graph-card.c                                                     |    2 
 sound/soc/generic/simple-card.c                                                          |    2 
 sound/soc/intel/Makefile                                                                 |    2 
 sound/soc/intel/boards/kbl_da7219_max98927.c                                             |   38 
 sound/soc/intel/boards/sof_wm8804.c                                                      |    6 
 sound/soc/intel/skylake/Makefile                                                         |    2 
 sound/soc/qcom/qdsp6/q6afe-clocks.c                                                      |  209 +--
 sound/soc/qcom/qdsp6/q6afe.c                                                             |    2 
 sound/soc/qcom/qdsp6/q6afe.h                                                             |    2 
 sound/soc/samsung/tm2_wm5110.c                                                           |    2 
 sound/usb/card.c                                                                         |   14 
 sound/usb/midi.c                                                                         |    2 
 sound/usb/quirks.c                                                                       |   16 
 sound/usb/usbaudio.h                                                                     |    2 
 tools/bpf/bpftool/btf.c                                                                  |    3 
 tools/bpf/bpftool/main.c                                                                 |    3 
 tools/bpf/bpftool/map.c                                                                  |    2 
 tools/lib/bpf/bpf_core_read.h                                                            |   16 
 tools/lib/bpf/bpf_tracing.h                                                              |   40 
 tools/lib/bpf/btf.h                                                                      |    1 
 tools/lib/bpf/libbpf.h                                                                   |    1 
 tools/lib/perf/include/perf/event.h                                                      |    7 
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json                                        |    2 
 tools/perf/pmu-events/arch/x86/amdzen1/recommended.json                                  |    6 
 tools/perf/pmu-events/arch/x86/amdzen2/cache.json                                        |    2 
 tools/perf/pmu-events/arch/x86/amdzen2/recommended.json                                  |    6 
 tools/perf/trace/beauty/fsconfig.sh                                                      |    7 
 tools/perf/util/jitdump.c                                                                |   30 
 tools/perf/util/session.c                                                                |   15 
 tools/perf/util/symbol_fprintf.c                                                         |    2 
 tools/power/x86/turbostat/turbostat.c                                                    |   62 -
 tools/testing/selftests/bpf/Makefile                                                     |    5 
 tools/testing/selftests/bpf/prog_tests/core_reloc.c                                      |   51 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c       |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c       |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c         |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c       |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c    |    3 
 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c         |    3 
 tools/testing/selftests/bpf/progs/core_reloc_types.h                                     |   20 
 tools/testing/selftests/bpf/verifier/array_access.c                                      |    2 
 tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh                             |    6 
 tools/testing/selftests/kvm/dirty_log_test.c                                             |   69 -
 tools/testing/selftests/lib.mk                                                           |    3 
 tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh                      |    2 
 tools/testing/selftests/x86/thunks_32.S                                                  |    2 
 virt/kvm/coalesced_mmio.c                                                                |   19 
 virt/kvm/kvm_main.c                                                                      |   20 
 611 files changed, 6042 insertions(+), 4026 deletions(-)

Adam Ford (1):
      clk: imx: Fix reparenting of UARTs not associated with stdout

Alain Volmat (1):
      spi: stm32: Fix use-after-free on unbind

Alexander Lobakin (2):
      xsk: Respect device's headroom and tailroom on generic xmit path
      gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check

Alexandru Ardelean (1):
      iio: adc: Kconfig: make AD9467 depend on ADI_AXI_ADC symbol

Alexandru Elisei (1):
      KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Alison Schofield (1):
      x86, sched: Treat Intel SNC topology as default, COD as exception

Amir Goldstein (1):
      ovl: invalidate readdir cache on changes to dir with origin

Andre Edich (1):
      net: phy: lan87xx: fix access to wrong register of LAN87xx

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Drop error message when 'No request id available'

Andrew Scull (1):
      bug: Remove redundant condition check in report_bug

Andrii Nakryiko (7):
      libbpf: Add explicit padding to bpf_xdp_set_link_opts
      bpftool: Fix maybe-uninitialized warnings
      selftests/bpf: Re-generate vmlinux.h and BPF skeletons if bpftool changed
      selftests/bpf: Fix BPF_CORE_READ_BITFIELD() macro
      selftests/bpf: Fix field existence CO-RE reloc tests
      selftests/bpf: Fix core_reloc test runner
      bpf: Prevent writable memory-mapping of read-only ringbuf pages

Andy Lutomirski (1):
      selftests/x86: Add a missing .note.GNU-stack section to thunks_32.S

Andy Shevchenko (7):
      usb: gadget: pch_udc: Revert d3cb25a12138 completely
      usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
      usb: gadget: pch_udc: Check if driver is present before calling ->setup()
      usb: gadget: pch_udc: Check for DMA mapping error
      usb: gadget: pch_udc: Initialize device pointer before use
      usb: gadget: pch_udc: Provide a GPIO line used on Intel Minnowboard (v1)
      driver core: platform: Declare early_platform_cleanup() prototype

Annaliese McDermond (3):
      ASoC: tlv320aic32x4: Register clocks before registering component
      ASoC: tlv320aic32x4: Increase maximum register in regmap
      sc16is7xx: Defer probe if device read fails

Antonio Borneo (1):
      spi: stm32: drop devres version of spi_register_master

Archie Pusaka (1):
      Bluetooth: verify AMP hci_chan before amp_destroy

Arnaldo Carvalho de Melo (1):
      perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Arnd Bergmann (6):
      spi: rockchip: avoid objtool warning
      crypto: poly1305 - fix poly1305_core_setkey() declaration
      irqchip/gic-v3: Fix OF_BAD_ADDR error handling
      wlcore: fix overlapping snprintf arguments in debugfs
      net: enetc: fix link error again
      smp: Fix smp_call_function_single_async prototype

Artur Petrosyan (2):
      usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.
      usb: dwc2: Fix hibernation between host and device modes.

Arun Easi (1):
      PCI: Allow VPD access for QLogic ISP2722

Aswath Govindraju (1):
      arm64: dts: ti: k3-j721e-main: Update the speed modes supported and their itap delay values for MMCSD subsystems

Athira Rajeev (2):
      powerpc/perf: Fix PMU constraint check for EBB events
      powerpc/perf: Fix the threshold event selection for memory events in power10

Ayush Sawal (1):
      crypto: chelsio - Read rxchannel-id from firmware

Badhri Jagan Sridharan (5):
      usb: typec: tcpm: Address incorrect values of tcpm psy for fixed supply
      usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply
      usb: typec: tcpm: update power supply once partner accepts
      usb: typec: tcpm: Handle vbus shutoff when in source mode
      usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Bas Nieuwenhuizen (1):
      drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode.

Bjorn Andersson (2):
      soc: qcom: mdt_loader: Validate that p_filesz < p_memsz
      soc: qcom: mdt_loader: Detect truncated read of segments

Bob Pearson (1):
      RDMA/rxe: Fix a bug in rxe_fill_ip_info()

Boris Brezillon (2):
      drm/panfrost: Clear MMU irqs before handling the fault
      drm/panfrost: Don't try to map pages that are already mapped

Brian King (1):
      scsi: ibmvfc: Fix invalid state machine BUG_ON()

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Compile when any configuration is selected

Chen Huang (1):
      powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Chen Hui (2):
      clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE
      clk: qcom: apss-ipq-pll: Add missing MODULE_DEVICE_TABLE

Chris von Recklinghausen (1):
      PM: hibernate: x86: Use crc32 instead of md5 for hibernation e820 integrity check

Christian König (1):
      drm/amdgpu: fix concurrent VM flushes on Vega/Navi v2

Christoph Hellwig (2):
      md: split mddev_find
      md: factor out a mddev_find_locked helper from mddev_find

Christophe JAILLET (3):
      usb: gadget: s3c: Fix incorrect resources releasing
      usb: gadget: s3c: Fix the error handling path in 's3c2410_udc_probe()'
      media: venus: core: Fix some resource leaks in the error path of 'venus_probe()'

Christophe Leroy (4):
      powerpc/syscall: Rename syscall_64.c into interrupt.c
      powerpc/syscall: Change condition to check MSR_RI
      powerpc/64: Fix the definition of the fixmap area
      powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Chunfeng Yun (3):
      usb: xhci-mtk: remove or operator for setting schedule parameters
      usb: xhci-mtk: improve bandwidth scheduling with TT
      arm64: dts: mt8173: fix wrong power-domain phandle of pmic

Claudio Imbrenda (5):
      KVM: s390: VSIE: correctly handle MVPG when in VSIE
      KVM: s390: split kvm_s390_logical_to_effective
      KVM: s390: VSIE: fix MVPG handling for prefixing and MSO
      KVM: s390: split kvm_s390_real_to_abs
      KVM: s390: extend kvm_s390_shadow_fault to return entry pointer

Colin Ian King (22):
      drm/radeon: fix copy of uninitialized variable back to userspace
      memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
      crypto: sun8i-ss - Fix memory leak of object d when dma_iv fails to map
      staging: rtl8192u: Fix potential infinite loop
      crypto: sun8i-ss - Fix memory leak of pad
      crypto: sa2ul - Fix memory leak of rxd
      usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
      media: vivid: fix assignment of dev->fbuf_out_flags
      media: [next] staging: media: atomisp: fix memory leak of object flash
      media: m88rs6000t: avoid potential out-of-bounds reads on arrays
      clk: uniphier: Fix potential infinite loop
      scsi: pm80xx: Fix potential infinite loop
      ASoC: Intel: boards: sof-wm8804: add check for PLL setting
      liquidio: Fix unintented sign extension of a left shift of a u16
      xfs: fix return of uninitialized value in variable error
      mt7601u: fix always true expression
      cxgb4: Fix unintentional sign extension issues
      net: thunderx: Fix unintentional sign extension issue
      net/mlx5: Fix bit-wise and with zero
      ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails
      net: davinci_emac: Fix incorrect masking of tx and rx error channel
      wlcore: Fix buffer overrun by snprintf due to incorrect buffer size

Corentin Labbe (2):
      crypto: sun8i-ss - fix result memory leak on error path
      crypto: allwinner - add missing CRYPTO_ prefix

Cédric Le Goater (2):
      powerpc/xive: Drop check on irq_data in xive_core_debug_show()
      powerpc/xive: Fix xmon command "dxi"

Dafna Hirschfeld (1):
      media: rkisp1: rsz: crash fix when setting src format

Dan Carpenter (20):
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      ovl: fix missing revert_creds() on error path
      mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()
      regulator: bd9576: Fix return from bd957x_probe()
      node: fix device cleanups in error handling code
      Drivers: hv: vmbus: Use after free in __vmbus_open()
      soc: aspeed: fix a ternary sign expansion bug
      drm/amd/display: Fix off by one in hdmi_14_process_transaction()
      media: atomisp: Fix use after free in atomisp_alloc_css_stat_bufs()
      drm: xlnx: zynqmp: fix a memset in zynqmp_dp_train()
      HSI: core: fix resource leaks in hsi_add_client_from_dt()
      ataflop: potential out of bounds in do_format()
      ataflop: fix off by one in ataflop_probe()
      nfc: pn533: prevent potential memory corruption
      rtw88: Fix an error code in rtw_debugfs_set_rsvd_page()
      drm/i915/gvt: Fix error code in intel_gvt_init_device()
      drm/amdgpu: fix an error code in init_pmu_entry_by_type_and_add()
      drm/amd/pm: fix error code in smu_set_power_limit()
      bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
      kfifo: fix ternary sign extension bugs

Daniel Almeida (1):
      media: rkvdec: Do not require all controls to be present in every request

Daniel Borkmann (2):
      bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds
      bpf: Fix alu32 const subreg bound tracking on bitwise operations

Danielle Ratson (1):
      selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test

Dario Binacchi (2):
      serial: omap: don't disable rs485 if rts gpio is missing
      serial: omap: fix rs485 half-duplex filtering

David Bauer (1):
      mtd: don't lock when recursively deleting partitions

David E. Box (1):
      mfd: intel_pmt: Fix nuisance messages and handling of disabled capabilities

David Edmondson (1):
      KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid

David Hildenbrand (1):
      s390: fix detection of vector enhancements facility 1 vs. vector packed decimal facility

David Howells (2):
      afs: Fix updating of i_mode due to 3rd party change
      afs: Fix speculative status fetches

Dejin Zheng (1):
      PCI: xgene: Fix cfg resource mapping

Dima Stepanov (1):
      block/rnbd-clt-sysfs: Remove copy buffer overlap in rnbd_clt_get_path_name

Dmitry Baryshkov (1):
      ASoC: q6afe-clocks: fix reprobing of the driver

Dmitry Osipenko (1):
      soc/tegra: regulators: Fix locking up when voltage-spread is out of range

Dong Aisheng (1):
      PM / devfreq: Use more accurate returned new_freq as resume_freq

Douglas Anderson (1):
      arm64: dts: qcom: sc7180: Avoid glitching SPI CS at bootup on trogdor

Eddie James (1):
      ARM: dts: aspeed: Rainier: Fix humidity sensor bus address

Edward Cree (1):
      sfc: ef10: fix TX queue lookup in TX event handling

Elad Grupi (1):
      nvmet-tcp: fix a segmentation fault during io parsing error

Eric Auger (2):
      KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
      KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read

Eric Dumazet (2):
      inet: use bigger hash table for IP ID generation
      net/packet: remove data races in fanout operations

Erwan Le Ray (14):
      serial: stm32: fix code cleaning warnings and checks
      serial: stm32: add "_usart" prefix in functions name
      serial: stm32: fix probe and remove order for dma
      serial: stm32: fix startup by enabling usart for reception
      serial: stm32: fix incorrect characters on console
      serial: stm32: fix TX and RX FIFO thresholds
      serial: stm32: fix a deadlock condition with wakeup event
      serial: stm32: fix wake-up flag handling
      serial: stm32: fix a deadlock in set_termios
      serial: stm32: fix tx dma completion, release channel
      serial: stm32: call stm32_transmit_chars locked
      serial: stm32: fix FIFO flush in startup and set_termios
      serial: stm32: add FIFO flush when port is closed
      serial: stm32: fix tx_empty condition

Evan Quan (1):
      drm/amdgpu: add new MC firmware for Polaris12 32bit ASIC

Fabian Vogt (6):
      fotg210-udc: Fix DMA on EP0 for length > max packet size
      fotg210-udc: Fix EP0 IN requests bigger than two packets
      fotg210-udc: Remove a dubious condition leading to fotg210_done
      fotg210-udc: Mask GRP2 interrupts we don't handle
      fotg210-udc: Don't DMA more than the buffer can take
      fotg210-udc: Complete OUT requests on short packets

Fabien Parent (1):
      arm64: dts: mediatek: fix reset GPIO level on pumpkin

Fabrice Gasnier (1):
      mfd: stm32-timers: Avoid clearing auto reload register

Felix Fietkau (5):
      mt76: fix potential DMA mapping leak
      mt76: mt7615: fix tx skb dma unmap
      mt76: mt7915: fix tx skb dma unmap
      mt76: reduce q->lock hold time
      mt76: mt7915: bring up the WA event rx queue for band1

Felix Kuehling (1):
      drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Finn Thain (1):
      m68k: mvme147,mvme16x: Don't wipe PCC timer config bits

Florent Revest (1):
      libbpf: Initialize the bpf_seq_printf parameters array field by field

Geert Uytterhoeven (1):
      phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Geliang Tang (1):
      mptcp: fix format specifiers for unsigned int

Gerd Hoffmann (2):
      drm/qxl: use ttm bo priorities
      Revert "drm/qxl: do not run release if qxl failed to init"

Gioh Kim (1):
      RDMA/rtrs-clt: destroy sysfs after removing session from active list

Giovanni Cabiddu (1):
      crypto: qat - fix error path in adf_isr_resource_alloc()

Giuseppe Scrivano (1):
      ovl: show "userxattr" in the mount data

Greg Kroah-Hartman (1):
      Linux 5.11.21

Gwendal Grignou (2):
      iio: sx9310: Fix write_.._debounce()
      iio: sx9310: Fix access to variable DT array

Hanna Hawa (2):
      pinctrl: pinctrl-single: remove unused parameter
      pinctrl: pinctrl-single: fix pcs_pin_dbg_show() when bits_per_mux is not zero

Hannes Reinecke (1):
      nvme: retrigger ANA log update if group descriptor isn't found

Hans Verkuil (1):
      media: v4l2-ctrls.c: fix race condition in hdl->requests list

Hans de Goede (7):
      usb: roles: Call try_module_get() from usb_role_switch_find_by_fwnode()
      misc: lis3lv02d: Fix false-positive WARN on various HP models
      platform/x86: dell-wmi-sysman: Make init_bios_attributes() ACPI object parsing more robust
      HID: lenovo: Use brightness_set_blocking callback for setting LEDs brightness
      HID: lenovo: Fix lenovo_led_set_tp10ubkbd() error handling
      HID: lenovo: Check hid_get_drvdata() returns non NULL in lenovo_event()
      HID: lenovo: Map mic-mute button to KEY_F20 instead of KEY_MICMUTE

Harry Wentland (1):
      drm/amd/display: Reject non-zero src_y and src_x for video planes

He Ying (2):
      cpuidle: Fix ARM_QCOM_SPM_CPUIDLE configuration
      firmware: qcom-scm: Fix QCOM_SCM configuration

Heiko Carstens (1):
      KVM: s390: fix guarded storage control register handling

Heming Zhao (1):
      md-cluster: fix use-after-free issue when removing rdev

Hsin-Yi Wang (1):
      arm64: dts: mt8183: Add gce client reg for display subcomponents

Huang Pei (2):
      MIPS: fix local_irq_{disable,enable} in asmmacro.h
      MIPS: loongson64: fix bug when PAGE_SIZE > 16KB

Håkon Bugge (1):
      RDMA/core: Fix corrupted SL on passive side

Ian Abbott (1):
      staging: comedi: tests: ni_routes_test: Fix compilation error

Igor Pylypiv (1):
      scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()

Ilya Leoshkevich (1):
      selftests: fix prepending $(OUTPUT) to $(TEST_PROGS)

Ilya Lipnitskiy (3):
      MIPS: pci-mt7620: fix PLL lock check
      MIPS: pci-rt2880: fix slot 0 configuration
      MIPS: pci-legacy: stop using of_pci_range_to_resource

Ingo Molnar (1):
      x86/platform/uv: Fix !KEXEC build failure

Jacob Pan (1):
      iommu/vt-d: Reject unsupported page request modes

Jae Hyun Yoo (2):
      Revert "i3c master: fix missing destroy_workqueue() on error in i3c_master_register"
      media: aspeed: fix clock handling logic

James Bottomley (1):
      security: keys: trusted: fix TPM2 authorizations

James Smart (1):
      scsi: lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()

Jan Glauber (1):
      md: Fix missing unused status line of /proc/mdstat

Jane Chu (1):
      mm/memory-failure: unnecessary amount of unmapping

Jason Gunthorpe (4):
      vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
      vfio/pci: Move VGA and VF initialization to functions
      vfio/pci: Re-order vfio_pci_probe()
      vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Jernej Skrabec (1):
      media: cedrus: Fix H265 status definitions

Jia Zhou (1):
      ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Jia-Ju Bai (2):
      mtd: maps: fix error return code of physmap_flash_remove()
      media: platform: sunxi: sun6i-csi: fix error return code of sun6i_video_start_streaming()

Jiri Kosina (1):
      Bluetooth: avoid deadlock between hci_dev->lock and socket lock

Jiri Slaby (1):
      x86/vdso: Use proper modifier for len's format specifier in extract()

Johan Hovold (18):
      Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"
      tty: moxa: fix TIOCSSERIAL jiffies conversions
      tty: amiserial: fix TIOCSSERIAL permission check
      USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions
      staging: greybus: uart: fix TIOCSSERIAL jiffies conversions
      USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check
      staging: fwserial: fix TIOCSSERIAL jiffies conversions
      tty: moxa: fix TIOCSSERIAL permission check
      staging: fwserial: fix TIOCSSERIAL permission check
      staging: fwserial: fix TIOCSSERIAL implementation
      staging: fwserial: fix TIOCGSERIAL implementation
      staging: greybus: uart: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix TIOCGSERIAL implementation
      tty: actually undefine superseded ASYNC flags
      tty: fix return value for unsupported ioctls
      tty: fix return value for unsupported termiox ioctls
      serial: core: return early on unsupported ioctls

Johannes Berg (2):
      cfg80211: scan: drop entry from hidden_list on overflow
      mac80211: bail out if cipher schemes are invalid

John Ogness (1):
      printk: limit second loop of syslog_print_all

Jonathan Cameron (2):
      iio:accel:adis16201: Fix wrong axis assignment that prevents loading
      iio:adc:ad7476: Fix remove handling

Jonathon Reinhart (1):
      net: Only allow init netns to set default tcp cong to a restricted algo

Jordan Niethe (1):
      powerpc/64s: Fix pte update for kernel memory on radix

KP Singh (1):
      libbpf: Add explicit padding to btf_dump_emit_type_decl_opts

Kenta.Tada@sony.com (1):
      seccomp: Fix CONFIG tests for Seccomp_filters

Kishon Vijay Abraham I (4):
      PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c
      phy: cadence: Sierra: Fix PHY power_on sequence
      phy: ti: j721e-wiz: Invoke wiz_init() before of_platform_device_create()
      phy: ti: j721e-wiz: Delete "clk_div_sel" clk provider during cleanup

Krzysztof Kozlowski (15):
      ARM: dts: exynos: correct fuel gauge interrupt trigger level on GT-I9100
      ARM: dts: exynos: correct fuel gauge interrupt trigger level on P4 Note family
      ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
      ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
      ARM: dts: exynos: correct PMIC interrupt trigger level on P4 Note family
      ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
      ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
      ARM: dts: s5pv210: correct fuel gauge interrupt trigger level on Fascinate family
      ARM: dts: qcom: msm8974-lge-nexus5: correct fuel gauge interrupt trigger level
      ARM: dts: qcom: msm8974-samsung-klte: correct fuel gauge interrupt trigger level
      memory: renesas-rpc-if: fix possible NULL pointer dereference of resource
      memory: samsung: exynos5422-dmc: handle clk_set_parent() failure
      ASoC: simple-card: fix possible uninitialized single_cpu local variable

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
      arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Lad Prabhakar (2):
      media: i2c: imx219: Move out locking/unlocking of vflip and hflip controls from imx219_set_stream
      media: i2c: imx219: Balance runtime PM use-count

Lars-Peter Clausen (1):
      iio: inv_mpu6050: Fully validate gyro and accel scale writes

Len Brown (1):
      Revert "tools/power turbostat: adjust for temperature offset"

Leo Yan (3):
      perf tools: Change fields type in perf_record_time_conv
      perf jit: Let convert_timestamp() to be backwards-compatible
      perf session: Add swap operation for event TIME_CONV

Leonardo Bras (1):
      powerpc/pseries/iommu: Fix window size for direct mapping with pmem

Li Huafei (1):
      ima: Fix the error code for restoring the PCR value

Liam Howlett (1):
      m68k: Add missing mmap_read_lock() to sys_cacheflush()

Lianbo Jiang (1):
      dma-iommu: use static-key to minimize the impact in the fast-path

Lin Ma (1):
      bluetooth: eliminate the potential race condition when removing the HCI controller

Linus Lüssing (1):
      net: bridge: mcast: fix broken length + header check for MRDv6 Adv.

Linus Walleij (2):
      drm/mcde/panel: Inverse misunderstood flag
      net: ethernet: ixp4xx: Set the DMA masks explicitly

Liu Ying (1):
      media: docs: Fix data organization of MEDIA_BUS_FMT_RGB101010_1X30

Lorenzo Bianconi (3):
      mt76: mt7915: fix aggr len debugfs node
      mt76: mt7615: fix mib stats counter reporting to mac80211
      mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list

Lu Baolu (6):
      iommu/vt-d: Don't set then clear private data in prq_event_thread()
      iommu/vt-d: Report right snoop capability when using FL for IOVA
      iommu/vt-d: Report the right page fault address
      iommu/vt-d: Preset Access/Dirty bits for IOVA over FL
      iommu/vt-d: Remove WO permissions on second-level paging entries
      iommu/vt-d: Invalidate PASID cache when root/context entry changed

Luca Ceresoli (1):
      fpga: fpga-mgr: xilinx-spi: fix error messages on -EPROBE_DEFER

Lukasz Luba (1):
      PM / devfreq: Unlock mutex and free devfreq struct in error path

Lukasz Majczak (1):
      ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function

Lv Yunlong (10):
      mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
      crypto: qat - Fix a double free in adf_create_ring
      drivers/block/null_blk/main: Fix a double free in null_init.
      IB/isert: Fix a use after free in isert_connect_request
      mwl8k: Fix a double Free in mwl8k_probe_hw
      ath10k: Fix a use after free in ath10k_htc_send_bundle
      net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
      RDMA/siw: Fix a use after free in siw_alloc_mr
      RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res
      net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Maciej W. Rozycki (2):
      FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR
      FDDI: defxx: Make MMIO the configuration default except for EISA

Manivannan Sadhasivam (2):
      mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
      mtd: rawnand: qcom: Return actual error code instead of -ENODEV

Maor Gottlieb (1):
      RDMA/mlx5: Fix drop packet rule in egress table

Marc Zyngier (1):
      KVM: arm64: Fully zero the vcpu state on reset

Marcus Folkesson (1):
      wilc1000: write value to WILC_INTR2_ENABLE register

Marek Behún (2):
      cpufreq: armada-37xx: Fix setting TBG parent for load levels
      clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Marek Vasut (1):
      drm/stm: Fix bus_flags handling

Mark Zhang (1):
      RDMA/mlx5: Fix mlx5 rates to IB rates map

Martin Schiller (1):
      net: phy: intel-xway: enable integrated led functions

Masami Hiramatsu (1):
      x86/kprobes: Fix to check non boostable prefixes correctly

Matthias Kaehlcke (1):
      arm64: dts: qcom: sc7180: trogdor: Fix trip point config of charger thermal zone

Maxim Kochetkov (2):
      net: phy: marvell: fix m88e1011_set_downshift
      net: phy: marvell: fix m88e1111_set_downshift

Maxim Mikityanskiy (1):
      HID: plantronics: Workaround for double volume key presses

Meng Li (1):
      regmap: set debugfs_name to NULL after it is freed

Michael Chan (1):
      bnxt_en: Fix RX consumer index logic in the error path.

Michael Ellerman (3):
      powerpc/pseries: Only register vio drivers if vio bus exists
      powerpc/pseries: Add key to flags in pSeries_lpar_hpte_updateboltedpp()
      powerpc/64s: Use htab_convert_pte_flags() in hash__mark_rodata_ro()

Michael Kelley (1):
      Drivers: hv: vmbus: Increase wait time for VMbus unload

Michael Walle (1):
      mtd: require write permissions for locking and badblock ioctls

Mike Marciniszyn (1):
      IB/hfi1: Use kzalloc() for mmu_rb_handler allocation

Mike Travis (1):
      x86/platform/uv: Set section block size for hubless architectures

Mordechay Goodstein (1):
      iwlwifi: rs-fw: don't support stbc for HE 160

Muchun Song (1):
      mm: memcontrol: slab: fix obtain a reference to a freeing memcg

Mukesh Sisodiya (1):
      iwlwifi: dbg: disable ini debug in 9000 family and below

Nathan Chancellor (6):
      MIPS: generic: Update node names to avoid unit addresses
      ACPI: CPPC: Replace cppc_attr with kobj_attribute
      x86/events/amd/iommu: Fix sysfs type mismatch
      perf/amd/uncore: Fix sysfs type mismatch
      powerpc/fadump: Mark fadump_calculate_reserve_size as __init
      powerpc/prom: Mark identical_pvr_fixup as __init

Neil Armstrong (1):
      media: meson-ge2d: fix rotation parameters

Nicholas Piggin (1):
      KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit

Niklas Cassel (1):
      nvme-pci: don't simple map sgl when sgls are disabled

Nikolay Borisov (1):
      mm/sl?b.c: remove ctor argument from kmem_cache_flags

Nirmoy Das (1):
      drm/amd/display: use GFP_ATOMIC in dcn20_resource_construct

Nobuhiro Iwamatsu (1):
      firmware: xilinx: Remove zynqmp_pm_get_eemi_ops() in IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)

Noralf Trønnes (1):
      drm/probe-helper: Check epoch counter in output_poll_execute()

Nuno Sa (1):
      iio: adis16480: fix pps mode sampling frequency math

Olga Kornievskaia (1):
      NFSv4.2: fix copy stateid copying for the async copy

Ong Boon Leong (1):
      net: stmmac: fix TSO and TBS feature enabling during driver open

Or Cohen (1):
      net/nfc: fix use-after-free llcp_sock_bind/connect

Orson Zhai (1):
      mailbox: sprd: Introduce refcnt when clients requests/free channels

Otavio Pontes (1):
      x86/microcode: Check for offline CPUs before requesting new microcode

Pablo Neira Ayuso (3):
      netfilter: nft_payload: fix C-VLAN offload support
      netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector
      netfilter: nftables_offload: special ethertype handling for VLAN

Pali Rohár (5):
      cpufreq: armada-37xx: Fix the AVS value for load L1
      clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz
      clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0
      cpufreq: armada-37xx: Fix driver cleanup when registration failed
      cpufreq: armada-37xx: Fix determining base CPU frequency

Pan Bian (1):
      bus: qcom: Put child node before return

Paolo Abeni (1):
      udp: never accept GSO_FRAGLIST packets

Paolo Bonzini (1):
      KVM: selftests: Always run vCPU thread with blocked SIG_IPI

Paul Cercueil (2):
      drm/ingenic: Fix non-OSD mode
      drm: bridge/panel: Cleanup connector on bridge detach

Paul Durrant (1):
      xen-blkback: fix compatibility bug with single page rings

Paul Fertser (1):
      hwmon: (pmbus/pxe1610) don't bail out when not all pages are active

Paul Menzel (1):
      iommu/amd: Put newline after closing bracket in warning

Paul Moore (1):
      selinux: add proper NULL termination to the secclass_map permissions

Pavel Begunkov (1):
      io_uring: fix overflows checks in provide buffers

Peter Xu (1):
      KVM: selftests: Sync data verify of dirty logging with guest sync

Peter Zijlstra (1):
      kthread: Fix PF_KTHREAD vs to_kthread() race

Petr Machata (1):
      selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static

Phillip Potter (1):
      net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Pierre-Louis Bossart (1):
      ASoC: samsung: tm2_wm5110: check of of_parse return value

Ping-Ke Shih (2):
      rtw88: Fix array overrun in rtw_get_tx_power_params()
      rtlwifi: 8821ae: upgrade PHY and RF parameters

Potnuri Bharat Teja (1):
      RDMA/cxgb4: add missing qpid increment

Qii Wang (1):
      i2c: mediatek: Fix wrong dma sync flag

Qinglang Miao (9):
      soc: qcom: pdr: Fix error return code in pdr_register_listener
      i2c: cadence: fix reference leak when pm_runtime_get_sync fails
      i2c: img-scb: fix reference leak when pm_runtime_get_sync fails
      i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails
      i2c: imx: fix reference leak when pm_runtime_get_sync fails
      i2c: omap: fix reference leak when pm_runtime_get_sync fails
      i2c: sprd: fix reference leak when pm_runtime_get_sync fails
      i2c: stm32f7: fix reference leak when pm_runtime_get_sync fails
      i2c: xiic: fix reference leak when pm_runtime_get_sync fails

Quanyang Wang (11):
      spi: spi-zynqmp-gqspi: use wait_for_completion_timeout to make zynqmp_qspi_exec_op not interruptible
      spi: spi-zynqmp-gqspi: add mutex locking for exec_op
      spi: spi-zynqmp-gqspi: transmit dummy circles by using the controller's internal functionality
      spi: spi-zynqmp-gqspi: fix incorrect operating mode in zynqmp_qspi_read_op
      spi: spi-zynqmp-gqspi: fix clk_enable/disable imbalance issue
      spi: spi-zynqmp-gqspi: fix hang issue when suspend/resume
      spi: spi-zynqmp-gqspi: fix use-after-free in zynqmp_qspi_exec_op
      spi: spi-zynqmp-gqspi: return -ENOMEM if dma_map_single fails
      drm/tilcdc: send vblank event when disabling crtc
      clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback
      clk: zynqmp: pll: add set_pll_mode to check condition in zynqmp_pll_enable

Rander Wang (1):
      soundwire: stream: fix memory leak in stream config error path

Randy Dunlap (3):
      drm: bridge: fix LONTIUM use of mipi_dsi_() functions
      drm: bridge: fix ANX7625 use of mipi_dsi_() functions
      powerpc: iommu: fix build when neither PCI or IBMVIO is set

Rasmus Villemoes (1):
      devtmpfs: fix placement of complete() call

Ravi Kumar Bokka (1):
      drivers: nvmem: Fix voltage settings for QTI qfprom-efuse

Ricardo Rivera-Matos (1):
      power: supply: bq25980: Move props from battery node

Rijo Thomas (1):
      crypto: ccp - fix command queuing to TEE ring buffer

Rikard Falkeborn (1):
      mfd: stmpe: Revert "Constify static struct resource"

Rob Clark (1):
      drm/msm: Fix debugfs deadlock

Robin Murphy (1):
      iommu/dma: Resurrect the "forcedac" option

Ryder Lee (8):
      mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()
      mt76: mt7915: fix mib stats counter reporting to mac80211
      mt76: mt7915: fix rxrate reporting
      mt76: mt7915: fix txrate reporting
      mt76: mt7615: cleanup mcu tx queue in mt7615_dma_reset()
      mt76: mt7915: cleanup mcu tx queue in mt7915_dma_reset()
      mt76: mt7615: fix memleak when mt7615_unregister_device()
      mt76: mt7915: fix memleak when mt7915_unregister_device()

Sagi Grimberg (2):
      nvme-tcp: block BH in sk state_change sk callback
      nvmet-tcp: fix incorrect locking in state_change sk callback

Sai Prakash Ranjan (2):
      arm64: dts: qcom: sm8250: Fix level triggered PMU interrupt polarity
      arm64: dts: qcom: sm8250: Fix timer interrupt to specify EL2 physical timer

Sakari Ailus (2):
      media: ccs: Fix sub-device function
      media: ipu3-cio2: Fix pixel-rate derived link frequency

Salil Mehta (1):
      net: hns3: Limiting the scope of vector_ring_chain variable

Sami Loone (1):
      ALSA: hda/realtek: ALC285 Thinkpad jack pin quirk is unreachable

Sean Christopherson (20):
      KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
      KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with 64-bit
      KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4 loads
      KVM: nSVM: Set the shadow root level to the TDP level for nested NPT
      KVM: SVM: Don't strip the C-bit from CR2 on #PF interception
      KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
      KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
      KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are created
      KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP unsupported
      KVM: nVMX: Defer the MMU reload to the normal path on an EPTP switch
      KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit
      KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
      KVM: Destroy I/O bus devices on unregister failure _after_ sync'ing SRCU
      KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
      KVM: x86/mmu: Retry page faults that hit an invalid memslot
      crypto: ccp: Detect and reject "invalid" addresses destined for PSP
      KVM: VMX: Intercept FS/GS_BASE MSR accesses for 32-bit KVM
      KVM: SVM: Zero out the VMCB array used to track SEV ASID association
      KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
      KVM: SVM: Disable SEV/SEV-ES if NPT is disabled

Sean Wang (3):
      mt76: mt7663: fix when beacon filter is being applied
      mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation
      mt76: mt7663s: fix the possible device hang in high traffic

Sebastian Andrzej Siewior (1):
      powerpc/mm: Move the linear_mapping_mutex to the ifdef where it is used

Sefa Eyeoglu (1):
      drm/amd/display: check fb of primary plane

Sergei Trofimovich (1):
      ia64: fix EFI_DEBUG build

Sergey Shtylyov (16):
      pata_arasan_cf: fix IRQ check
      pata_ipx4xx_cf: fix IRQ check
      sata_mv: add IRQ checks
      ata: libahci_platform: fix IRQ check
      scsi: ufs: ufshcd-pltfrm: Fix deferred probing
      scsi: hisi_sas: Fix IRQ checks
      scsi: jazz_esp: Add IRQ check
      scsi: sun3x_esp: Add IRQ check
      scsi: sni_53c710: Add IRQ check
      i2c: cadence: add IRQ check
      i2c: emev2: add IRQ check
      i2c: jz4780: add IRQ check
      i2c: mlxbf: add IRQ check
      i2c: rcar: add IRQ check
      i2c: sh7760: add IRQ check
      i2c: sh7760: fix IRQ error path

Sergio Paracuellos (1):
      phy: ralink: phy-mt7621-pci: fix XTAL bitmask

Shameer Kolothum (1):
      iommu: Check dev->iommu in iommu_dev_xxx functions

Shawn Guo (3):
      arm64: dts: qcom: sdm845: fix number of pins in 'gpio-ranges'
      arm64: dts: qcom: sm8150: fix number of pins in 'gpio-ranges'
      arm64: dts: qcom: sm8250: fix number of pins in 'gpio-ranges'

Shay Drory (1):
      RDMA/core: Add CM to restrack after successful attachment to a device

Shengjiu Wang (2):
      ASoC: wm8960: Remove bitclk relax condition in wm8960_configure_sysclk
      ASoC: ak5558: correct reset polarity

Shuah Khan (1):
      ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Sindhu Devale (1):
      RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Smita Koralahalli (1):
      perf vendor events amd: Fix broken L2 Cache Hits from L2 HWPF metric

Souptick Joarder (1):
      media: atomisp: Fixed error handling path

Srikar Dronamraju (1):
      powerpc/smp: Reintroduce cpu_core_mask

Srinivas Kandagatla (2):
      arm64: dts: qcom: db845c: fix correct powerdown pin for WSA881x
      soundwire: bus: Fix device found flag correctly

Stefano Garzarella (2):
      vsock/vmci: log once the failed queue pair allocation
      vsock/virtio: free queued packets when closing socket

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Stephen Boyd (4):
      serial: stm32: Use of_device_get_match_data()
      firmware: qcom_scm: Make __qcom_scm_is_call_available() return bool
      firmware: qcom_scm: Reduce locking section for __get_convention()
      firmware: qcom_scm: Workaround lack of "is available" call on SC7180

Sudhakar Panneerselvam (1):
      md/bitmap: wait for external bitmap writes to complete during tear down

Takashi Iwai (14):
      ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries
      ALSA: hda/realtek: Re-order ALC269 HP quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries
      ALSA: hda/realtek: Re-order ALC269 ASUS quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries
      ALSA: hda/realtek: Re-order remaining ALC269 quirk table entries
      ALSA: hda/realtek: Re-order ALC662 quirk table entries
      ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices
      ALSA: hda/realtek: Fix speaker amp on HP Envy AiO 32
      ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Tao Ren (1):
      usb: gadget: aspeed: fix dma map failure

Tasos Sahanidis (2):
      media: saa7134: use sg_dma_len when building pgtable
      media: saa7146: use sg_dma_len when building pgtable

Tejas Patel (1):
      firmware: xilinx: Fix dereferencing freed memory

Tetsuo Handa (3):
      misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct
      misc: vmw_vmci: explicitly initialize vmci_datagram payload
      ttyprintk: Add TTY hangup callback.

Thadeu Lima de Souza Cascardo (2):
      io_uring: truncate lengths larger than MAX_RW_COUNT on provide buffers
      bpf, ringbuf: Deny reserve of buffers larger than ringbuf

Tiezhu Yang (1):
      MIPS/bpf: Enable bpf_probe_read{, str}() on MIPS again

Tobias Waldekranz (2):
      net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
      net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE

Toke Høiland-Jørgensen (1):
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Tong Zhang (2):
      crypto: qat - don't release uninitialized resources
      crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Tony Lindgren (3):
      bus: ti-sysc: Fix initializing module_pa for modules without sysc register
      clocksource/drivers/timer-ti-dm: Fix posted mode status check order
      clocksource/drivers/timer-ti-dm: Add missing set_state_oneshot_stopped

Tyrel Datwyler (1):
      powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Vadym Kochan (1):
      net: marvell: prestera: fix port event handling on init

Valentin CARON - foss (1):
      ARM: dts: stm32: fix usart 2 & 3 pinconf to wake up with flow control

Valentin Schneider (1):
      sched/fair: Fix shift-out-of-bounds in load_balance()

Vitaly Chikunov (1):
      perf beauty: Fix fsconfig generator

Vladimir Barinov (1):
      arm64: dts: renesas: r8a77980: Fix vin4-7 endpoint binding

Waiman Long (1):
      sched/debug: Fix cgroup_path[] serialization

Wang Li (1):
      spi: fsl-lpspi: Fix PM reference leak in lpspi_prepare_xfer_hardware()

Wang Wensheng (6):
      KVM: arm64: Fix error return code in init_hyp_mode()
      RDMA/qedr: Fix error return code in qedr_iw_connect()
      IB/hfi1: Fix error return code in parse_platform_config()
      RDMA/bnxt_re: Fix error return code in bnxt_qplib_cq_process_terminal()
      RDMA/srpt: Fix error return code in srpt_cm_req_recv()
      mm/sparse: add the missing sparse_buffer_fini() in error branch

Wanpeng Li (1):
      KVM: X86: Fix failure to boost kernel lock holder candidate in SEV-ES guests

Wayne Lin (2):
      drm/dp_mst: Revise broadcast msg lct & lcr
      drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast

Wei Yongjun (9):
      crypto: keembay-ocs-aes - Fix error return code in kmb_ocs_aes_probe()
      serial: liteuart: fix return value check in liteuart_probe()
      usb: typec: tps6598x: Fix return value check in tps6598x_probe()
      usb: typec: stusb160x: fix return value check in stusb160x_probe()
      phy: ralink: phy-mt7621-pci: fix return value check in mt7621_pci_phy_probe()
      phy: ingenic: Fix a typo in ingenic_usb_phy_probe()
      clocksource/drivers/ingenic_ost: Fix return value check in ingenic_ost_probe()
      spi: spi-zynqmp-gqspi: Fix missing unlock on error in zynqmp_qspi_exec_op()
      media: m88ds3103: fix return value check in m88ds3103_probe()

Weihang Li (1):
      RDMA/hns: Fix missing assignment of max_inline_data

William A. Kennington III (1):
      spi: Fix use-after-free with devm_spi_alloc_*

Wolfram Sang (2):
      i2c: rcar: make sure irq is not threaded on Gen2 and earlier
      i2c: rcar: protect against supurious interrupts on V3U

Xiang Chen (1):
      iommu: Fix a boundary issue to avoid performance drop

Xiao Ni (1):
      async_xor: increase src_offs when dropping destination page

Xie He (2):
      Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"
      net: lapbether: Prevent racing when checking whether the netif is running

Xin Long (2):
      Revert "net/sctp: fix race condition in sctp_destroy_sock"
      sctp: delay auto_asconf init until binding the first addr

Yang Yingliang (5):
      USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
      spi: fsl: add missing iounmap() on error in of_fsl_spi_probe()
      media: omap4iss: return error code when omap4iss_get() failed
      fs: dlm: fix missing unlock on error in accept_from_sock()
      net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()

Ye Bin (1):
      usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

Yingjie Wang (1):
      drm/radeon: Fix a missing check bug in radeon_dp_mst_detect()

Yinjun Zhang (1):
      nfp: devlink: initialize the devlink port attribute "lanes"

Yoshihiro Shimoda (4):
      ARM: dts: renesas: Add mmc aliases into R-Car Gen2 board dts files
      arm64: dts: renesas: Add mmc aliases into board dts files
      arm64: dts: renesas: r8a779a0: Fix PMU interrupt
      net: renesas: ravb: Fix a stuck issue when a lot of frames are received

YueHaibing (1):
      PM: runtime: Replace inline function pm_runtime_callbacks_present()

Zhao Heming (1):
      md: md_open returns -EBUSY when entering racing area

Zhen Lei (1):
      iommu/arm-smmu-v3: add bit field SFM into GERROR_ERR_MASK

Zhouyi Zhou (1):
      rcu: Remove spurious instrumentation_end() in rcu_nmi_enter()

dillon min (1):
      dt-bindings: serial: stm32: Use 'type: object' instead of false for 'additionalProperties'

gexueyuan (1):
      memory: pl353: fix mask of ECC page_size config register

kernel test robot (1):
      of: overlay: fix for_each_child.cocci warnings

Álvaro Fernández Rojas (3):
      mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC
      gpio: guard gpiochip_irqchip_add_domain() with GPIOLIB_IRQCHIP
      mips: bmips: fix syscon-reboot nodes

