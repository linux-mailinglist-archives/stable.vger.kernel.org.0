Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B122E7829
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 12:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgL3LfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 06:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgL3LfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 06:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684592222A;
        Wed, 30 Dec 2020 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609328060;
        bh=Mkb/NpTtooxyjltkqmm5R0IOQ0Z/N/xUl9lB911+FSE=;
        h=From:To:Cc:Subject:Date:From;
        b=15IQUnfzQ2MH1nRmChn9lqT7dXNUQxVQpRRiNGs52cPOfFQ+/mpMPu1dX7QOSXn9Y
         TYW3GIfmsJ4huryCd9kcu6ZCZcUpxDx94ck5vCUIAETTd+t46lYCqbho4L2AhVbJWK
         Dljj/lsARY98s1PnkrU6E+KPs7+mRHsKaE1Mjjdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.4
Date:   Wed, 30 Dec 2020 12:35:33 +0100
Message-Id: <1609328133185251@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.4 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/locking/seqlock.rst                           |   21 -
 Documentation/x86/topology.rst                              |    9 
 Makefile                                                    |    2 
 arch/Kconfig                                                |   16 
 arch/arm/boot/compressed/head.S                             |    4 
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi                   |    5 
 arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts         |    5 
 arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts              |    4 
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts                 |    2 
 arch/arm/boot/dts/aspeed-g6.dtsi                            |    2 
 arch/arm/boot/dts/at91-sam9x60ek.dts                        |   13 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts                 |    7 
 arch/arm/boot/dts/at91-sama5d4_xplained.dts                 |    7 
 arch/arm/boot/dts/at91sam9rl.dtsi                           |   19 -
 arch/arm/boot/dts/meson8b-odroidc1.dts                      |    2 
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts                   |    2 
 arch/arm/boot/dts/omap4-panda-es.dts                        |    2 
 arch/arm/boot/dts/sama5d2.dtsi                              |    7 
 arch/arm/boot/dts/tegra20-ventana.dts                       |   11 
 arch/arm/crypto/aes-ce-core.S                               |   32 +
 arch/arm/crypto/aes-neonbs-glue.c                           |    8 
 arch/arm/kernel/entry-armv.S                                |   25 -
 arch/arm/kernel/head.S                                      |    6 
 arch/arm/vfp/entry.S                                        |   17 
 arch/arm/vfp/vfphw.S                                        |    5 
 arch/arm/vfp/vfpmodule.c                                    |   72 +++
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi       |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi            |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts        |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts         |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi        |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi           |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts        |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts       |    4 
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts         |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts              |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi                  |    2 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                     |   12 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts  |   12 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi              |    4 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts      |    2 
 arch/arm64/boot/dts/marvell/armada-7040.dtsi                |    4 
 arch/arm64/boot/dts/marvell/armada-8040.dtsi                |    4 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                    |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                    |    4 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                       |    6 
 arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi  |   11 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                        |    5 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                        |    3 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts        |   39 +-
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts                     |    2 
 arch/arm64/boot/dts/renesas/cat875.dtsi                     |    1 
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi             |    1 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts              |    1 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                    |   16 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                    |    4 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                   |    2 
 arch/arm64/crypto/poly1305-armv8.pl                         |    2 
 arch/arm64/crypto/poly1305-core.S_shipped                   |    2 
 arch/arm64/include/asm/kvm_host.h                           |    1 
 arch/arm64/kernel/mte.c                                     |    3 
 arch/arm64/kvm/sys_regs.c                                   |    1 
 arch/m68k/mac/config.c                                      |   17 
 arch/mips/bcm47xx/Kconfig                                   |    1 
 arch/mips/kernel/setup.c                                    |    4 
 arch/powerpc/boot/Makefile                                  |    2 
 arch/powerpc/include/asm/bitops.h                           |   23 +
 arch/powerpc/include/asm/book3s/32/mmu-hash.h               |    1 
 arch/powerpc/include/asm/book3s/32/pgtable.h                |    4 
 arch/powerpc/include/asm/cpm1.h                             |    1 
 arch/powerpc/include/asm/cputable.h                         |    7 
 arch/powerpc/include/asm/nohash/pgtable.h                   |    4 
 arch/powerpc/kernel/Makefile                                |    3 
 arch/powerpc/kernel/head_32.h                               |   25 -
 arch/powerpc/kernel/head_64.S                               |   10 
 arch/powerpc/kernel/paca.c                                  |    4 
 arch/powerpc/kernel/rtas.c                                  |    2 
 arch/powerpc/kernel/setup-common.c                          |    4 
 arch/powerpc/kernel/setup.h                                 |    6 
 arch/powerpc/kernel/setup_64.c                              |    2 
 arch/powerpc/kernel/smp.c                                   |    2 
 arch/powerpc/lib/sstep.c                                    |   10 
 arch/powerpc/mm/fault.c                                     |    8 
 arch/powerpc/mm/mem.c                                       |    2 
 arch/powerpc/perf/core-book3s.c                             |   13 
 arch/powerpc/perf/isa207-common.c                           |   30 +
 arch/powerpc/perf/isa207-common.h                           |   20 -
 arch/powerpc/perf/power10-pmu.c                             |   11 
 arch/powerpc/platforms/8xx/micropatch.c                     |   11 
 arch/powerpc/platforms/Kconfig.cputype                      |    2 
 arch/powerpc/platforms/powermac/sleep.S                     |  132 +++----
 arch/powerpc/platforms/powernv/memtrace.c                   |   44 ++
 arch/powerpc/platforms/powernv/npu-dma.c                    |   16 
 arch/powerpc/platforms/powernv/pci-sriov.c                  |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c                |    1 
 arch/powerpc/platforms/pseries/suspend.c                    |    4 
 arch/powerpc/xmon/nonstdio.c                                |    2 
 arch/powerpc/xmon/xmon.c                                    |    2 
 arch/riscv/mm/init.c                                        |    2 
 arch/s390/kernel/entry.S                                    |   44 +-
 arch/s390/kernel/smp.c                                      |   18 
 arch/s390/lib/test_unwind.c                                 |    7 
 arch/s390/purgatory/head.S                                  |    9 
 arch/sparc/mm/init_64.c                                     |    2 
 arch/um/drivers/chan_user.c                                 |    4 
 arch/um/drivers/xterm.c                                     |    5 
 arch/um/kernel/time.c                                       |    5 
 arch/um/os-Linux/irq.c                                      |    2 
 arch/um/os-Linux/umid.c                                     |   17 
 arch/x86/events/intel/core.c                                |    5 
 arch/x86/events/intel/lbr.c                                 |    2 
 arch/x86/include/asm/apic.h                                 |    1 
 arch/x86/include/asm/cacheinfo.h                            |    4 
 arch/x86/include/asm/mce.h                                  |    3 
 arch/x86/kernel/apic/apic.c                                 |   14 
 arch/x86/kernel/apic/x2apic_phys.c                          |    9 
 arch/x86/kernel/cpu/amd.c                                   |   11 
 arch/x86/kernel/cpu/cacheinfo.c                             |    6 
 arch/x86/kernel/cpu/hygon.c                                 |   11 
 arch/x86/kernel/cpu/mce/core.c                              |    3 
 arch/x86/kernel/kprobes/core.c                              |    5 
 arch/x86/kernel/tboot.c                                     |    1 
 arch/x86/kvm/cpuid.h                                        |   14 
 arch/x86/kvm/svm/sev.c                                      |   22 -
 arch/x86/kvm/svm/svm.c                                      |   14 
 arch/x86/kvm/vmx/vmx.c                                      |    8 
 arch/x86/mm/ident_map.c                                     |   12 
 crypto/Kconfig                                              |    2 
 crypto/ecdh.c                                               |    9 
 drivers/accessibility/speakup/speakup_dectlk.c              |    2 
 drivers/acpi/acpi_pnp.c                                     |    3 
 drivers/acpi/device_pm.c                                    |   41 --
 drivers/acpi/nfit/core.c                                    |    6 
 drivers/acpi/resource.c                                     |    2 
 drivers/android/binder.c                                    |    1 
 drivers/android/binder_alloc.c                              |   48 ++
 drivers/android/binder_alloc.h                              |    4 
 drivers/base/core.c                                         |    2 
 drivers/block/null_blk_zoned.c                              |   28 +
 drivers/block/rnbd/rnbd-clt-sysfs.c                         |   17 
 drivers/block/rnbd/rnbd-clt.c                               |   13 
 drivers/block/rnbd/rnbd-clt.h                               |    4 
 drivers/block/xen-blkback/xenbus.c                          |    4 
 drivers/bluetooth/btmtksdio.c                               |    2 
 drivers/bluetooth/btusb.c                                   |   10 
 drivers/bluetooth/hci_h5.c                                  |    3 
 drivers/bus/fsl-mc/fsl-mc-allocator.c                       |    4 
 drivers/bus/fsl-mc/fsl-mc-bus.c                             |    5 
 drivers/bus/mhi/core/init.c                                 |    6 
 drivers/bus/mips_cdmm.c                                     |    4 
 drivers/clk/at91/sam9x60.c                                  |    6 
 drivers/clk/at91/sama7g5.c                                  |    6 
 drivers/clk/bcm/clk-bcm2711-dvp.c                           |    1 
 drivers/clk/clk-fsl-sai.c                                   |   12 
 drivers/clk/clk-s2mps11.c                                   |    1 
 drivers/clk/clk-versaclock5.c                               |    4 
 drivers/clk/ingenic/cgu.c                                   |   14 
 drivers/clk/meson/Kconfig                                   |    1 
 drivers/clk/mvebu/armada-37xx-xtal.c                        |    4 
 drivers/clk/qcom/gcc-sc7180.c                               |    4 
 drivers/clk/renesas/r8a779a0-cpg-mssr.c                     |   13 
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                       |    1 
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                         |    1 
 drivers/clk/tegra/clk-dfll.c                                |    4 
 drivers/clk/tegra/clk-id.h                                  |    1 
 drivers/clk/tegra/clk-tegra-periph.c                        |    2 
 drivers/clk/ti/fapll.c                                      |   11 
 drivers/clocksource/Kconfig                                 |    2 
 drivers/clocksource/arm_arch_timer.c                        |   27 -
 drivers/clocksource/ingenic-timer.c                         |    2 
 drivers/clocksource/timer-cadence-ttc.c                     |   18 
 drivers/clocksource/timer-orion.c                           |   11 
 drivers/counter/microchip-tcb-capture.c                     |   16 
 drivers/cpufreq/Kconfig.arm                                 |    2 
 drivers/cpufreq/armada-8k-cpufreq.c                         |    6 
 drivers/cpufreq/highbank-cpufreq.c                          |    7 
 drivers/cpufreq/intel_pstate.c                              |   16 
 drivers/cpufreq/loongson1-cpufreq.c                         |    1 
 drivers/cpufreq/mediatek-cpufreq.c                          |    1 
 drivers/cpufreq/qcom-cpufreq-nvmem.c                        |    1 
 drivers/cpufreq/scpi-cpufreq.c                              |    1 
 drivers/cpufreq/sti-cpufreq.c                               |    7 
 drivers/cpufreq/sun50i-cpufreq-nvmem.c                      |    1 
 drivers/cpufreq/vexpress-spc-cpufreq.c                      |    1 
 drivers/crypto/Kconfig                                      |    1 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c           |   20 -
 drivers/crypto/amcc/crypto4xx_core.c                        |    2 
 drivers/crypto/caam/caamalg.c                               |    4 
 drivers/crypto/caam/caamalg_qi.c                            |    4 
 drivers/crypto/caam/caamalg_qi2.c                           |    3 
 drivers/crypto/inside-secure/safexcel.c                     |    2 
 drivers/crypto/omap-aes.c                                   |    3 
 drivers/crypto/qat/qat_common/qat_hal.c                     |    2 
 drivers/crypto/talitos.c                                    |   10 
 drivers/dax/super.c                                         |    1 
 drivers/dma-buf/dma-resv.c                                  |    2 
 drivers/dma/mv_xor_v2.c                                     |    4 
 drivers/dma/ti/k3-udma.c                                    |    3 
 drivers/edac/amd64_edac.c                                   |   26 -
 drivers/edac/i10nm_base.c                                   |   11 
 drivers/edac/mce_amd.c                                      |    2 
 drivers/extcon/extcon-max77693.c                            |    2 
 drivers/firmware/arm_scmi/notify.c                          |   10 
 drivers/firmware/efi/efi.c                                  |    1 
 drivers/firmware/tegra/bpmp-debugfs.c                       |    6 
 drivers/fsi/fsi-master-aspeed.c                             |   45 +-
 drivers/gpio/gpiolib.c                                      |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c              |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                     |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h                     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c                     |    9 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                      |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |    7 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                       |   13 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |    4 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c     |    2 
 drivers/gpu/drm/aspeed/Kconfig                              |    1 
 drivers/gpu/drm/bridge/ti-tpd12s015.c                       |    2 
 drivers/gpu/drm/drm_dp_aux_dev.c                            |    2 
 drivers/gpu/drm/drm_edid.c                                  |    2 
 drivers/gpu/drm/gma500/cdv_intel_dp.c                       |    2 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c              |    2 
 drivers/gpu/drm/imx/dcss/dcss-plane.c                       |   11 
 drivers/gpu/drm/mcde/mcde_drv.c                             |    4 
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c                 |    2 
 drivers/gpu/drm/meson/meson_drv.c                           |   12 
 drivers/gpu/drm/meson/meson_dw_hdmi.c                       |   60 ++-
 drivers/gpu/drm/msm/Kconfig                                 |    2 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                       |   24 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                       |   11 
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c               |    6 
 drivers/gpu/drm/msm/dp/dp_catalog.c                         |   13 
 drivers/gpu/drm/msm/dp/dp_catalog.h                         |    1 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                            |   28 -
 drivers/gpu/drm/msm/dp/dp_display.c                         |  154 ++++----
 drivers/gpu/drm/msm/dp/dp_link.c                            |   41 +-
 drivers/gpu/drm/msm/dp/dp_link.h                            |    1 
 drivers/gpu/drm/msm/dp/dp_reg.h                             |    2 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c                  |    8 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c                   |    8 
 drivers/gpu/drm/msm/msm_drv.h                               |    5 
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                           |   10 
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c                    |    1 
 drivers/gpu/drm/panel/panel-simple.c                        |    1 
 drivers/gpu/drm/panfrost/panfrost_device.c                  |    1 
 drivers/gpu/drm/panfrost/panfrost_device.h                  |    6 
 drivers/gpu/drm/panfrost/panfrost_job.c                     |  183 +++++++--
 drivers/gpu/drm/tve200/tve200_drv.c                         |    4 
 drivers/gpu/drm/udl/udl_modeset.c                           |    4 
 drivers/hsi/controllers/omap_ssi_core.c                     |    2 
 drivers/hwmon/ina3221.c                                     |    2 
 drivers/hwmon/k10temp.c                                     |   98 -----
 drivers/hwtracing/coresight/coresight-catu.c                |    2 
 drivers/hwtracing/coresight/coresight-cti-core.c            |    2 
 drivers/hwtracing/coresight/coresight-etb10.c               |    2 
 drivers/hwtracing/coresight/coresight-etm3x-core.c          |    4 
 drivers/hwtracing/coresight/coresight-etm4x-core.c          |    4 
 drivers/hwtracing/coresight/coresight-funnel.c              |    6 
 drivers/hwtracing/coresight/coresight-replicator.c          |    6 
 drivers/hwtracing/coresight/coresight-stm.c                 |    2 
 drivers/hwtracing/coresight/coresight-tmc-core.c            |    2 
 drivers/hwtracing/coresight/coresight-tpiu.c                |    2 
 drivers/i2c/busses/i2c-qcom-geni.c                          |    6 
 drivers/iio/adc/Kconfig                                     |    2 
 drivers/iio/adc/ad_sigma_delta.c                            |   18 
 drivers/iio/adc/at91_adc.c                                  |    2 
 drivers/iio/adc/rockchip_saradc.c                           |    2 
 drivers/iio/adc/ti-ads124s08.c                              |   13 
 drivers/iio/imu/bmi160/bmi160.h                             |    7 
 drivers/iio/imu/bmi160/bmi160_core.c                        |    6 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                |   26 +
 drivers/iio/industrialio-buffer.c                           |    6 
 drivers/iio/light/rpr0521.c                                 |   17 
 drivers/iio/light/st_uvis25.h                               |    5 
 drivers/iio/light/st_uvis25_core.c                          |    8 
 drivers/iio/magnetometer/mag3110.c                          |   13 
 drivers/iio/pressure/mpl3115.c                              |    9 
 drivers/iio/trigger/iio-trig-hrtimer.c                      |    4 
 drivers/infiniband/core/cma.c                               |  195 ++++++----
 drivers/infiniband/core/device.c                            |    7 
 drivers/infiniband/core/uverbs_std_types_device.c           |   14 
 drivers/infiniband/core/uverbs_std_types_mr.c               |    4 
 drivers/infiniband/core/verbs.c                             |    4 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                    |    5 
 drivers/infiniband/hw/cxgb4/cq.c                            |    3 
 drivers/infiniband/hw/hns/hns_roce_ah.c                     |   61 +--
 drivers/infiniband/hw/hns/hns_roce_cq.c                     |    5 
 drivers/infiniband/hw/hns/hns_roce_device.h                 |   10 
 drivers/infiniband/hw/hns/hns_roce_hem.c                    |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                  |   56 +--
 drivers/infiniband/hw/hns/hns_roce_main.c                   |   11 
 drivers/infiniband/hw/hns/hns_roce_pd.c                     |   11 
 drivers/infiniband/hw/hns/hns_roce_qp.c                     |   18 
 drivers/infiniband/hw/hns/hns_roce_srq.c                    |   10 
 drivers/infiniband/hw/mlx5/mr.c                             |   21 -
 drivers/infiniband/hw/mthca/mthca_cq.c                      |    2 
 drivers/infiniband/hw/mthca/mthca_dev.h                     |    1 
 drivers/infiniband/sw/rxe/rxe_req.c                         |    3 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                      |    8 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                      |   86 ++--
 drivers/input/keyboard/omap4-keypad.c                       |   89 ++--
 drivers/input/mouse/cyapa_gen6.c                            |    2 
 drivers/input/touchscreen/ads7846.c                         |   52 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c                  |   90 ++++
 drivers/iommu/arm/arm-smmu/arm-smmu.c                       |   13 
 drivers/iommu/arm/arm-smmu/arm-smmu.h                       |    1 
 drivers/iommu/intel/iommu.c                                 |    2 
 drivers/irqchip/irq-alpine-msi.c                            |    3 
 drivers/irqchip/irq-ti-sci-inta.c                           |    2 
 drivers/irqchip/irq-ti-sci-intr.c                           |   14 
 drivers/irqchip/qcom-pdc.c                                  |   21 +
 drivers/leds/leds-lp50xx.c                                  |    6 
 drivers/leds/leds-netxbig.c                                 |   35 +
 drivers/leds/leds-turris-omnia.c                            |    4 
 drivers/macintosh/adb-iop.c                                 |   56 ++-
 drivers/mailbox/arm_mhu_db.c                                |    2 
 drivers/md/dm-ioctl.c                                       |    1 
 drivers/md/md-cluster.c                                     |   67 ++-
 drivers/md/md.c                                             |   14 
 drivers/media/common/siano/smsdvb-main.c                    |    5 
 drivers/media/i2c/imx214.c                                  |    2 
 drivers/media/i2c/imx219.c                                  |   17 
 drivers/media/i2c/max2175.c                                 |    2 
 drivers/media/i2c/max9271.c                                 |    8 
 drivers/media/i2c/ov5640.c                                  |   82 ++--
 drivers/media/i2c/rdacm20.c                                 |   13 
 drivers/media/i2c/tvp5150.c                                 |    1 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                    |   62 +--
 drivers/media/pci/intel/ipu3/ipu3-cio2.h                    |    1 
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c           |    5 
 drivers/media/pci/saa7146/mxb.c                             |   19 -
 drivers/media/pci/solo6x10/solo6x10-g723.c                  |    2 
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c             |    9 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c       |   19 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c       |   26 +
 drivers/media/platform/qcom/venus/core.c                    |   32 +
 drivers/media/platform/qcom/venus/pm_helpers.c              |   10 
 drivers/media/rc/sunxi-cir.c                                |    2 
 drivers/media/usb/gspca/gspca.c                             |    1 
 drivers/media/usb/tm6000/tm6000-video.c                     |    5 
 drivers/media/v4l2-core/v4l2-fwnode.c                       |    6 
 drivers/memory/Kconfig                                      |    2 
 drivers/memory/jz4780-nemc.c                                |    6 
 drivers/memory/renesas-rpc-if.c                             |    7 
 drivers/memstick/core/memstick.c                            |    1 
 drivers/memstick/host/r592.c                                |   12 
 drivers/mfd/Kconfig                                         |    1 
 drivers/mfd/htc-i2cpld.c                                    |    2 
 drivers/mfd/motorola-cpcap.c                                |    6 
 drivers/mfd/stmfx.c                                         |   10 
 drivers/misc/pci_endpoint_test.c                            |    8 
 drivers/mmc/host/pxamci.c                                   |    1 
 drivers/mmc/host/sdhci-tegra.c                              |    2 
 drivers/mtd/mtdcore.c                                       |    4 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |   38 +-
 drivers/mtd/nand/raw/meson_nand.c                           |    7 
 drivers/mtd/nand/raw/qcom_nandc.c                           |    2 
 drivers/mtd/nand/spi/core.c                                 |    4 
 drivers/mtd/parsers/cmdlinepart.c                           |   14 
 drivers/mtd/spi-nor/atmel.c                                 |   77 +++-
 drivers/mtd/spi-nor/core.c                                  |   25 -
 drivers/mtd/spi-nor/core.h                                  |    1 
 drivers/mtd/spi-nor/sst.c                                   |    3 
 drivers/net/can/m_can/m_can.c                               |    4 
 drivers/net/dsa/qca/ar9331.c                                |   33 +
 drivers/net/ethernet/allwinner/sun4i-emac.c                 |    7 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c            |    2 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                  |    5 
 drivers/net/ethernet/intel/ice/ice_xsk.c                    |    5 
 drivers/net/ethernet/korina.c                               |    2 
 drivers/net/ethernet/mellanox/mlx5/core/main.c              |    6 
 drivers/net/ethernet/microchip/lan743x_main.c               |   43 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c                  |    8 
 drivers/net/ethernet/netronome/nfp/flower/main.c            |    6 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c             |   63 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c            |    1 
 drivers/net/virtio_net.c                                    |    1 
 drivers/net/wireless/admtek/adm8211.c                       |    6 
 drivers/net/wireless/ath/ath10k/usb.c                       |    7 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                   |    4 
 drivers/net/wireless/ath/ath10k/wmi.c                       |    9 
 drivers/net/wireless/ath/ath10k/wmi.h                       |    1 
 drivers/net/wireless/ath/ath11k/core.h                      |    2 
 drivers/net/wireless/ath/ath11k/dp_tx.c                     |    5 
 drivers/net/wireless/ath/ath11k/hw.c                        |    4 
 drivers/net/wireless/ath/ath11k/mac.c                       |   54 +-
 drivers/net/wireless/ath/ath11k/qmi.c                       |    6 
 drivers/net/wireless/ath/ath11k/reg.c                       |    6 
 drivers/net/wireless/ath/ath11k/wmi.c                       |   31 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c     |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    1 
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c            |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                |    6 
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c         |   14 
 drivers/net/wireless/marvell/mwifiex/main.c                 |    2 
 drivers/net/wireless/mediatek/mt76/dma.c                    |    2 
 drivers/net/wireless/mediatek/mt76/mac80211.c               |    1 
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c             |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c             |   14 
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c            |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c       |    2 
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c             |    3 
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c             |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c         |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c             |    5 
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c          |    6 
 drivers/net/wireless/rsi/rsi_91x_usb.c                      |   30 -
 drivers/net/wireless/st/cw1200/main.c                       |    2 
 drivers/net/xen-netback/xenbus.c                            |    6 
 drivers/nfc/s3fwrn5/firmware.c                              |    4 
 drivers/nvdimm/label.c                                      |   13 
 drivers/pci/controller/pcie-brcmstb.c                       |    1 
 drivers/pci/controller/pcie-iproc.c                         |   23 -
 drivers/pci/pci-acpi.c                                      |    4 
 drivers/pci/pci.c                                           |   14 
 drivers/pci/quirks.c                                        |   17 
 drivers/pci/slot.c                                          |    6 
 drivers/phy/mediatek/Kconfig                                |    4 
 drivers/phy/mediatek/phy-mtk-hdmi.c                         |    5 
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                    |    6 
 drivers/phy/tegra/xusb.c                                    |    2 
 drivers/pinctrl/core.c                                      |    2 
 drivers/pinctrl/pinctrl-falcon.c                            |   14 
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c                 |    2 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                       |    6 
 drivers/platform/chrome/cros_ec_spi.c                       |    1 
 drivers/platform/x86/dell-smbios-base.c                     |    1 
 drivers/platform/x86/intel-vbtn.c                           |   18 
 drivers/platform/x86/mlx-platform.c                         |   33 -
 drivers/power/supply/axp288_charger.c                       |   28 -
 drivers/power/supply/bq24190_charger.c                      |   20 -
 drivers/power/supply/bq25890_charger.c                      |    2 
 drivers/power/supply/max17042_battery.c                     |    3 
 drivers/ps3/ps3stor_lib.c                                   |    2 
 drivers/pwm/pwm-imx27.c                                     |    3 
 drivers/pwm/pwm-lp3943.c                                    |    1 
 drivers/pwm/pwm-sun4i.c                                     |    6 
 drivers/pwm/pwm-zx.c                                        |    1 
 drivers/regulator/axp20x-regulator.c                        |    2 
 drivers/remoteproc/mtk_common.h                             |   26 -
 drivers/remoteproc/mtk_scp.c                                |    5 
 drivers/remoteproc/qcom_q6v5_adsp.c                         |   13 
 drivers/remoteproc/qcom_q6v5_mss.c                          |    5 
 drivers/remoteproc/qcom_q6v5_pas.c                          |    5 
 drivers/remoteproc/qcom_sysmon.c                            |   25 +
 drivers/remoteproc/ti_k3_dsp_remoteproc.c                   |    4 
 drivers/rtc/rtc-ep93xx.c                                    |    6 
 drivers/rtc/rtc-pcf2127.c                                   |   12 
 drivers/s390/block/dasd_alias.c                             |   22 +
 drivers/s390/cio/device.c                                   |    4 
 drivers/scsi/aacraid/commctrl.c                             |   22 +
 drivers/scsi/aacraid/linit.c                                |   61 ---
 drivers/scsi/fnic/fnic_main.c                               |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                      |   26 -
 drivers/scsi/lpfc/lpfc.h                                    |    2 
 drivers/scsi/lpfc/lpfc_disc.h                               |    2 
 drivers/scsi/lpfc/lpfc_hbadisc.c                            |   35 +
 drivers/scsi/lpfc/lpfc_init.c                               |   46 +-
 drivers/scsi/lpfc/lpfc_mem.c                                |   11 
 drivers/scsi/lpfc/lpfc_nvme.c                               |   18 
 drivers/scsi/lpfc/lpfc_sli.c                                |   74 +++-
 drivers/scsi/lpfc/lpfc_sli4.h                               |    6 
 drivers/scsi/pm8001/pm8001_init.c                           |    3 
 drivers/scsi/pm8001/pm80xx_hwi.c                            |    2 
 drivers/scsi/qedi/qedi_main.c                               |    4 
 drivers/scsi/qla2xxx/qla_init.c                             |   71 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                              |    9 
 drivers/scsi/qla2xxx/qla_tmpl.c                             |    9 
 drivers/scsi/qla2xxx/qla_tmpl.h                             |    2 
 drivers/scsi/scsi_lib.c                                     |  126 ++++--
 drivers/scsi/scsi_transport_iscsi.c                         |    4 
 drivers/scsi/ufs/ufshcd.c                                   |    5 
 drivers/slimbus/qcom-ctrl.c                                 |    9 
 drivers/slimbus/qcom-ngd-ctrl.c                             |    6 
 drivers/soc/amlogic/meson-canvas.c                          |    4 
 drivers/soc/mediatek/mtk-scpsys.c                           |    5 
 drivers/soc/qcom/pdr_interface.c                            |    2 
 drivers/soc/qcom/qcom-geni-se.c                             |   17 
 drivers/soc/qcom/smp2p.c                                    |    5 
 drivers/soc/renesas/rmobile-sysc.c                          |    1 
 drivers/soc/rockchip/io-domain.c                            |    1 
 drivers/soc/ti/knav_dma.c                                   |   13 
 drivers/soc/ti/knav_qmss_queue.c                            |    4 
 drivers/soc/ti/omap_prm.c                                   |    4 
 drivers/soundwire/master.c                                  |   14 
 drivers/soundwire/qcom.c                                    |    2 
 drivers/soundwire/sysfs_slave_dpn.c                         |    1 
 drivers/spi/Kconfig                                         |    1 
 drivers/spi/atmel-quadspi.c                                 |   27 -
 drivers/spi/spi-ar934x.c                                    |   14 
 drivers/spi/spi-bcm63xx-hsspi.c                             |    4 
 drivers/spi/spi-davinci.c                                   |    2 
 drivers/spi/spi-dw-bt1.c                                    |    4 
 drivers/spi/spi-fsl-dspi.c                                  |    6 
 drivers/spi/spi-fsl-spi.c                                   |   11 
 drivers/spi/spi-geni-qcom.c                                 |    3 
 drivers/spi/spi-gpio.c                                      |   15 
 drivers/spi/spi-img-spfi.c                                  |    4 
 drivers/spi/spi-imx.c                                       |    2 
 drivers/spi/spi-mem.c                                       |    1 
 drivers/spi/spi-mt7621.c                                    |   11 
 drivers/spi/spi-mtk-nor.c                                   |    2 
 drivers/spi/spi-mxic.c                                      |   10 
 drivers/spi/spi-mxs.c                                       |    1 
 drivers/spi/spi-npcm-fiu.c                                  |    8 
 drivers/spi/spi-pic32.c                                     |    1 
 drivers/spi/spi-pxa2xx.c                                    |    5 
 drivers/spi/spi-qcom-qspi.c                                 |   42 --
 drivers/spi/spi-rb4xx.c                                     |    2 
 drivers/spi/spi-rpc-if.c                                    |    9 
 drivers/spi/spi-sc18is602.c                                 |   13 
 drivers/spi/spi-sh.c                                        |   13 
 drivers/spi/spi-sprd.c                                      |    1 
 drivers/spi/spi-st-ssc4.c                                   |    5 
 drivers/spi/spi-stm32-qspi.c                                |    8 
 drivers/spi/spi-stm32.c                                     |    1 
 drivers/spi/spi-synquacer.c                                 |   15 
 drivers/spi/spi-tegra114.c                                  |    2 
 drivers/spi/spi-tegra20-sflash.c                            |    1 
 drivers/spi/spi-tegra20-slink.c                             |    2 
 drivers/spi/spi-ti-qspi.c                                   |    1 
 drivers/spi/spi.c                                           |   19 -
 drivers/staging/comedi/drivers/mf6x4.c                      |    3 
 drivers/staging/gasket/gasket_interrupt.c                   |   15 
 drivers/staging/greybus/audio_codec.c                       |    2 
 drivers/staging/greybus/audio_helper.c                      |    3 
 drivers/staging/hikey9xx/hi6421-spmi-pmic.c                 |    4 
 drivers/staging/media/rkisp1/rkisp1-capture.c               |    1 
 drivers/staging/media/sunxi/cedrus/cedrus_video.c           |    4 
 drivers/staging/vc04_services/vchiq-mmal/Kconfig            |    2 
 drivers/thermal/cpufreq_cooling.c                           |    4 
 drivers/tty/serial/8250/8250_mtk.c                          |   13 
 drivers/tty/serial/pmac_zilog.c                             |   14 
 drivers/usb/host/ehci-omap.c                                |    1 
 drivers/usb/host/max3421-hcd.c                              |    3 
 drivers/usb/host/oxu210hp-hcd.c                             |    4 
 drivers/usb/serial/digi_acceleport.c                        |   45 --
 drivers/usb/serial/keyspan_pda.c                            |   63 +--
 drivers/usb/serial/mos7720.c                                |    2 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                           |    5 
 drivers/vfio/pci/vfio_pci.c                                 |    7 
 drivers/vfio/pci/vfio_pci_nvlink2.c                         |    7 
 drivers/vhost/scsi.c                                        |    3 
 drivers/video/fbdev/atmel_lcdfb.c                           |    2 
 drivers/virtio/virtio_ring.c                                |    8 
 drivers/watchdog/Kconfig                                    |    4 
 drivers/watchdog/qcom-wdt.c                                 |    2 
 drivers/watchdog/sprd_wdt.c                                 |   34 -
 drivers/watchdog/watchdog_core.c                            |   22 -
 drivers/xen/xen-pciback/xenbus.c                            |    2 
 drivers/xen/xenbus/xenbus.h                                 |    2 
 drivers/xen/xenbus/xenbus_client.c                          |    8 
 drivers/xen/xenbus/xenbus_probe.c                           |    1 
 drivers/xen/xenbus/xenbus_probe_backend.c                   |    7 
 drivers/xen/xenbus/xenbus_xs.c                              |   34 +
 fs/btrfs/ctree.h                                            |    1 
 fs/btrfs/extent-tree.c                                      |   33 -
 fs/btrfs/ioctl.c                                            |   39 ++
 fs/btrfs/transaction.c                                      |   42 ++
 fs/ceph/caps.c                                              |   11 
 fs/cifs/smb2misc.c                                          |   16 
 fs/cifs/smb2ops.c                                           |    3 
 fs/cifs/smb2pdu.c                                           |    7 
 fs/cifs/smb2pdu.h                                           |   14 
 fs/erofs/data.c                                             |   26 -
 fs/eventpoll.c                                              |   25 -
 fs/ext4/extents.c                                           |    4 
 fs/ext4/inode.c                                             |   19 -
 fs/ext4/mballoc.c                                           |    1 
 fs/ext4/super.c                                             |   14 
 fs/f2fs/node.c                                              |    2 
 fs/f2fs/super.c                                             |    1 
 fs/fuse/virtio_fs.c                                         |    2 
 fs/inode.c                                                  |    4 
 fs/io-wq.h                                                  |    1 
 fs/io_uring.c                                               |  178 +++++----
 fs/jffs2/readinode.c                                        |   16 
 fs/jffs2/super.c                                            |   17 
 fs/jfs/jfs_dmap.h                                           |    2 
 fs/lockd/host.c                                             |   20 -
 fs/nfs/flexfilelayout/flexfilelayout.c                      |    2 
 fs/nfs/inode.c                                              |    2 
 fs/nfs/nfs4proc.c                                           |   10 
 fs/nfs/nfs4xdr.c                                            |   10 
 fs/nfs_common/grace.c                                       |    6 
 fs/nfsd/filecache.c                                         |    2 
 fs/nfsd/nfs4state.c                                         |    1 
 fs/nfsd/nfssvc.c                                            |    3 
 fs/notify/dnotify/dnotify.c                                 |    2 
 fs/notify/fanotify/fanotify.c                               |    7 
 fs/notify/fsnotify.c                                        |  107 +++--
 fs/notify/inotify/inotify.h                                 |    9 
 fs/notify/inotify/inotify_fsnotify.c                        |   51 --
 fs/notify/inotify/inotify_user.c                            |    8 
 fs/open.c                                                   |    4 
 fs/overlayfs/file.c                                         |   87 ----
 fs/proc/generic.c                                           |   24 +
 fs/proc/internal.h                                          |    7 
 fs/proc/proc_net.c                                          |   16 
 fs/proc_namespace.c                                         |    9 
 fs/ubifs/auth.c                                             |    4 
 fs/ubifs/io.c                                               |   13 
 include/acpi/acpi_bus.h                                     |    5 
 include/linux/fs.h                                          |    3 
 include/linux/fsnotify_backend.h                            |    9 
 include/linux/iio/adc/ad_sigma_delta.h                      |    6 
 include/linux/mm_types.h                                    |    8 
 include/linux/of.h                                          |    1 
 include/linux/proc_fs.h                                     |    8 
 include/linux/rmap.h                                        |    1 
 include/linux/seq_buf.h                                     |    2 
 include/linux/sunrpc/xprt.h                                 |    1 
 include/linux/trace_seq.h                                   |    4 
 include/media/v4l2-fwnode.h                                 |    6 
 include/media/v4l2-mediabus.h                               |    2 
 include/rdma/uverbs_ioctl.h                                 |   10 
 include/uapi/linux/android/binder.h                         |    1 
 include/uapi/linux/devlink.h                                |    2 
 include/xen/xenbus.h                                        |   15 
 kernel/audit_fsnotify.c                                     |    2 
 kernel/audit_tree.c                                         |    2 
 kernel/audit_watch.c                                        |    2 
 kernel/cgroup/cpuset.c                                      |   33 +
 kernel/fork.c                                               |    1 
 kernel/irq/irqdomain.c                                      |   11 
 kernel/rcu/tree.c                                           |  118 +++---
 kernel/sched/core.c                                         |    6 
 kernel/sched/deadline.c                                     |    5 
 kernel/sched/sched.h                                        |   42 --
 kernel/trace/bpf_trace.c                                    |    8 
 kernel/trace/ring_buffer.c                                  |   17 
 kernel/trace/trace.c                                        |   19 -
 kernel/trace/trace.h                                        |    5 
 kernel/trace/trace_boot.c                                   |    2 
 kernel/trace/trace_events.c                                 |    2 
 kernel/trace/trace_kprobe.c                                 |    9 
 kernel/trace/trace_selftest.c                               |    2 
 lib/dynamic_debug.c                                         |    9 
 mm/gup.c                                                    |  220 +++++-------
 mm/huge_memory.c                                            |    2 
 mm/hugetlb.c                                                |    1 
 mm/init-mm.c                                                |    1 
 mm/madvise.c                                                |    9 
 mm/memcontrol.c                                             |    5 
 mm/memory-failure.c                                         |    8 
 mm/memory.c                                                 |   13 
 mm/memory_hotplug.c                                         |    2 
 mm/migrate.c                                                |    8 
 mm/page_alloc.c                                             |   13 
 mm/rmap.c                                                   |    9 
 mm/vmalloc.c                                                |    6 
 mm/vmscan.c                                                 |   14 
 mm/z3fold.c                                                 |  174 ++++-----
 net/bluetooth/hci_event.c                                   |    5 
 net/bluetooth/hci_request.c                                 |   12 
 net/bluetooth/sco.c                                         |    5 
 net/mac80211/rx.c                                           |    2 
 net/mac80211/vht.c                                          |   14 
 net/sunrpc/debugfs.c                                        |    4 
 net/sunrpc/sched.c                                          |   65 +--
 net/sunrpc/xprt.c                                           |   65 ++-
 net/sunrpc/xprtrdma/module.c                                |    1 
 net/sunrpc/xprtrdma/rpc_rdma.c                              |   40 +-
 net/sunrpc/xprtrdma/transport.c                             |    1 
 net/sunrpc/xprtsock.c                                       |    7 
 net/wireless/scan.c                                         |    2 
 samples/bpf/lwt_len_hist.sh                                 |    2 
 samples/bpf/xdpsock_user.c                                  |    2 
 scripts/checkpatch.pl                                       |    2 
 scripts/kconfig/preprocess.c                                |    2 
 scripts/kernel-doc                                          |    4 
 security/integrity/ima/ima_crypto.c                         |   20 -
 security/selinux/hooks.c                                    |   16 
 security/smack/smack_access.c                               |    5 
 sound/core/memalloc.c                                       |    3 
 sound/core/oss/pcm_oss.c                                    |   22 -
 sound/pci/hda/hda_codec.c                                   |    2 
 sound/pci/hda/hda_sysfs.c                                   |    2 
 sound/pci/hda/patch_ca0132.c                                |    4 
 sound/pci/hda/patch_hdmi.c                                  |   98 ++++-
 sound/pci/hda/patch_realtek.c                               |   46 ++
 sound/soc/amd/acp-da7219-max98357a.c                        |    9 
 sound/soc/amd/raven/pci-acp3x.c                             |    4 
 sound/soc/amd/renoir/rn-pci-acp3x.c                         |   32 +
 sound/soc/atmel/Kconfig                                     |    1 
 sound/soc/codecs/cros_ec_codec.c                            |    2 
 sound/soc/codecs/cx2072x.c                                  |    4 
 sound/soc/codecs/max98390.c                                 |    2 
 sound/soc/codecs/wm8994.c                                   |    6 
 sound/soc/codecs/wm8997.c                                   |    2 
 sound/soc/codecs/wm8998.c                                   |    4 
 sound/soc/codecs/wm_adsp.c                                  |    5 
 sound/soc/intel/Kconfig                                     |    2 
 sound/soc/intel/boards/sof_maxim_common.c                   |    4 
 sound/soc/jz4740/jz4740-i2s.c                               |    4 
 sound/soc/meson/Kconfig                                     |    2 
 sound/soc/qcom/Kconfig                                      |    1 
 sound/soc/qcom/common.c                                     |   13 
 sound/soc/qcom/lpass-hdmi.c                                 |    2 
 sound/soc/qcom/qdsp6/q6afe-clocks.c                         |    1 
 sound/soc/soc-pcm.c                                         |    2 
 sound/soc/sof/intel/Kconfig                                 |    2 
 sound/soc/sunxi/sun4i-i2s.c                                 |    4 
 sound/usb/card.c                                            |    3 
 sound/usb/clock.c                                           |    6 
 sound/usb/quirks.c                                          |    1 
 tools/build/feature/Makefile                                |    2 
 tools/lib/bpf/libbpf.c                                      |   12 
 tools/perf/tests/expand-cgroup.c                            |    2 
 tools/perf/tests/pmu-events.c                               |    2 
 tools/perf/util/parse-regs-options.c                        |    2 
 tools/perf/util/probe-file.c                                |   13 
 tools/testing/selftests/bpf/Makefile                        |    3 
 tools/testing/selftests/bpf/progs/local_storage.c           |   24 -
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c        |   42 --
 tools/testing/selftests/bpf/test_sockmap.c                  |   36 +
 tools/testing/selftests/bpf/test_tunnel.sh                  |   43 ++
 tools/testing/selftests/run_kselftest.sh                    |    2 
 tools/testing/selftests/seccomp/config                      |    1 
 725 files changed, 5417 insertions(+), 3421 deletions(-)

Abhinav Kumar (1):
      drm/msm/dp: do not notify audio subsystem if sink doesn't support audio

Ahmed S. Darwish (2):
      scsi: pm80xx: Do not sleep in atomic context
      Documentation: seqlock: s/LOCKTYPE/LOCKNAME/g

Alan Stern (1):
      media: gspca: Fix memory leak in probe

Aleksa Sarai (1):
      openat2: reject RESOLVE_BENEATH|RESOLVE_IN_ROOT

Alex Deucher (2):
      drm/amdgpu: fix regression in vbios reservation handling on headless
      drm/amdgpu: only set DP subconnector type on DP and eDP connectors

Alex Dewar (1):
      ath11k: Handle errors if peer creation fails

Alex Elder (1):
      arm64: dts: qcom: sc7180: limit IPA iommu streams

Alexander Sverdlin (1):
      MIPS: Don't round up kernel sections size for memblock_add()

Alexandre Belloni (2):
      ARM: dts: at91: at91sam9rl: fix ADC triggers
      clk: at91: sam9x60: remove atmel,osc-bypass support

Alexandre Courbot (1):
      remoteproc/mtk_scp: surround DT device IDs with CONFIG_OF

Alexandru Ardelean (1):
      iio: adc: at91_adc: add Kconfig dep on the OF symbol and remove of_match_ptr()

Alexey Dobriyan (1):
      proc: fix lookup in /proc/net subdirectories after setns(2)

Alexey Kardashevskiy (2):
      vfio/pci/nvlink2: Do not attempt NPU2 setup on POWER8NVL NPU
      powerpc/powernv/npu: Do not attempt NPU2 setup on POWER8NVL NPU

Amadej Kastelic (1):
      ALSA: usb-audio: Add VID to support native DSD reproduction on FiiO devices

Amelie Delaunay (1):
      mfd: stmfx: Fix dev_err_probe() call in stmfx_chip_init()

Amir Goldstein (3):
      fsnotify: generalize handle_inode_event()
      inotify: convert to handle_inode_event() interface
      fsnotify: fix events reported to watching parent and child

Anant Thazhemadam (1):
      Bluetooth: hci_h5: fix memory leak in h5_close

Andrew Jeffery (1):
      ARM: dts: tacoma: Fix node vs reg mismatch for flash memory

Andrii Nakryiko (2):
      bpf: Fix bpf_put_raw_tracepoint()'s use of __module_address()
      selftests/bpf: Fix invalid use of strncat in test_sockmap

Andy Shevchenko (2):
      scripts: kernel-doc: Restore anonymous enum parsing
      PCI: Disable MSI for Pericom PCIe-USB adapter

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Anton Ivanov (4):
      um: Monitor error events in IRQ controller
      um: tty: Fix handling of close in tty lines
      um: chan_xterm: Fix fd leak
      um: Remove use of asprinf in umid.c

Ard Biesheuvel (7):
      ARM: p2v: fix handling of LPAE translation in BE mode
      crypto: arm64/poly1305-neon - reorder PAC authentication with SP update
      powerpc: Avoid broken GCC __attribute__((optimize))
      ARM: 9030/1: entry: omit FP emulation for UND exceptions taken in kernel mode
      ARM: 9044/1: vfp: use undef hook for VFP support detection
      crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
      crypto: arm/aes-ce - work around Cortex-A57/A72 silion errata

Arnaldo Carvalho de Melo (1):
      perf probe: Fix memory leak when synthesizing SDT probes

Arnd Bergmann (19):
      drm/amdgpu: fix incorrect enum type
      drm/amdgpu: fix build_coefficients() argument
      scsi: aacraid: Improve compat_ioctl handlers
      firmware: tegra: fix strncpy()/strncat() confusion
      RDMa/mthca: Work around -Wenum-conversion warning
      ASoC: cros_ec_codec: fix uninitialized memory read
      ASoC: atmel: mchp-spdifrx needs COMMON_CLK
      ASoC: qcom: fix QDSP6 dependencies, attempt #3
      phy: mediatek: allow compile-testing the hdmi phy
      memory: ti-emif-sram: only build for ARMv7
      drm/msm: add IOMMU_SUPPORT dependency
      cpufreq: imx: fix NVMEM_IMX_OCOTP dependency
      staging: bcm2835: fix vchiq_mmal dependencies
      seq_buf: Avoid type mismatch for seq_buf_init
      coresight: remove broken __exit annotations
      crypto: atmel-i2c - select CONFIG_BITREVERSE
      watchdog: coh901327: add COMMON_CLK dependency
      Input: cyapa_gen6 - fix out-of-bounds stack access
      platform/x86: mlx-platform: remove an unused variable

Artem Lapkin (1):
      arm64: dts: meson: fix spi-max-frequency on Khadas VIM2

Arun Easi (2):
      scsi: qla2xxx: Fix FW initialization error on big endian machines
      scsi: qla2xxx: Fix crash during driver load on big endian machines

Arvind Sankar (1):
      x86/mm/ident_map: Check for errors from ident_pud_init()

Athira Rajeev (5):
      powerpc/perf: Fix crash with is_sier_available when pmu is not set
      powerpc/perf: Fix to update radix_scope_qual in power10
      powerpc/perf: Update the PMU group constraints for l2l3 events in power10
      powerpc/perf: Fix the PMU group constraints for threshold events in power10
      powerpc/perf: Exclude kernel samples while counting events in user space.

Atish Patra (1):
      RISC-V: Fix usage of memblock_enforce_memory_limit

Avihai Horon (1):
      RDMA/uverbs: Fix incorrect variable type

Balamuruhan S (1):
      powerpc/sstep: Emulate prefixed instructions only when CPU_FTR_ARCH_31 is set

Bharat Gooty (1):
      PCI: iproc: Fix out-of-bound array accesses

Bhaumik Bhatt (1):
      bus: mhi: core: Remove double locking from mhi_driver_remove()

Biju Das (2):
      arm64: dts: renesas: hihope-rzg2-ex: Drop rxc-skew-ps from ethernet-phy node
      arm64: dts: renesas: cat875: Remove rxc-skew-ps from ethernet-phy node

Billy Tsai (1):
      ARM: dts: aspeed-g6: Fix the GPIO memory size

Bjorn Andersson (8):
      arm64: dts: qcom: sdm845: Limit ipa iommu streams
      slimbus: qcom-ngd-ctrl: Avoid sending power requests without QMI
      arm64: dts: qcom: c630: Polish i2c-hid devices
      arm64: dts: qcom: c630: Fix pinctrl pins properties
      iommu/arm-smmu: Allow implementation specific write_s2cr
      iommu/arm-smmu-qcom: Read back stream mappings
      iommu/arm-smmu-qcom: Implement S2CR quirk
      remoteproc: sysmon: Ensure remote notification ordering

Bjorn Helgaas (1):
      PCI: Bounds-check command-line resource alignment requests

Björn Töpel (3):
      selftests/bpf: Fix broken riscv build
      ice, xsk: clear the status bits for the next_to_use descriptor
      i40e, xsk: clear the status bits for the next_to_use descriptor

Bob Pearson (1):
      RDMA/rxe: Compute PSN windows correctly

Bongsu Jeon (1):
      nfc: s3fwrn5: Release the nfc firmware

Boris Brezillon (2):
      drm/panfrost: Fix job timeout handling
      drm/panfrost: Move the GPU reset bits outside the timeout handler

Borislav Petkov (1):
      EDAC/amd64: Fix PCI component registration

Calum Mackay (1):
      lockd: don't use interval-based rebinding over TCP

Carl Yin (1):
      bus: mhi: core: Fix null pointer access when parsing MHI configuration

Carlos Garnacho (1):
      platform/x86: intel-vbtn: Allow switch events on Acer Switch Alpha 12

Casey Schaufler (1):
      Smack: Handle io_uring kernel thread privileges

Cezary Rojewski (1):
      ASoC: pcm: DRAIN support reactivation

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
      arm64: dts: rockchip: Fix UART pull-ups on rk3328

Cheng Lin (1):
      nfs_common: need lock during iterate through the list

Chris Chiu (5):
      ALSA: hda/realtek - Enable headset mic of ASUS X430UN with ALC256
      ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255
      ALSA/hda: apply jack fixup for the Acer Veriton N4640G/N6640G/N2510G
      ALSA: hda/realtek: Apply jack fixup for Quanta NL3
      ALSA: hda/realtek: Remove dummy lineout on Acer TravelMate P648/P658

Chris Packham (1):
      ARM: dts: Remove non-existent i2c1 from 98dx3236

Chris Wilson (1):
      drm/i915: Fix mismatch between misplaced vma check and vma insert

Christophe JAILLET (8):
      leds: lp50xx: Fix an error handling path in 'lp50xx_probe_dt()'
      ath11k: Fix an error handling path
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: mscc: ocelot: Fix a resource leak in the error handling path of the probe function
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
      clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Christophe Leroy (11):
      crypto: talitos - Endianess in current_desc_hdr()
      crypto: talitos - Fix return type of current_desc_hdr()
      powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
      powerpc/powermac: Fix low_sleep_handler with CONFIG_VMAP_STACK
      powerpc/mm: sanity_check_fault() should work for all, not only BOOK3S
      powerpc/32: Fix vmap stack - Properly set r1 before activating MMU on syscall too
      powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()
      powerpc/feature: Add CPU_FTR_NOEXECUTE to G2_LE
      powerpc/xmon: Change printk() to pr_cont()
      powerpc/8xx: Fix early debug when SMC1 is relocated
      powerpc/mm: Fix verification of MMU_FTR_TYPE_44x

Chuck Lever (1):
      xprtrdma: Fix XDRBUF_SPARSE_PAGES support

Chuhong Yuan (2):
      ASoC: jz4740-i2s: add missed checks for clk_get()
      ASoC: amd: change clk_get() to devm_clk_get() and add missed checks

Chunguang Xu (1):
      ext4: fix a memory leak of ext4_free_data

Claudiu Beznea (3):
      ARM: dts: at91: sam9x60ek: remove bypass property
      ARM: dts: at91: sama5d2: map securam as device
      clk: at91: sama7g5: fix compilation error

Clément Péron (1):
      ASoC: sun4i-i2s: Fix lrck_period computation for I2S justified mode

Colin Ian King (7):
      ASoC: qcom: fix unsigned int bitwidth compared to less than zero
      crypto: inside-secure - Fix sizeof() mismatch
      nl80211/cfg80211: fix potential infinite loop
      media: tm6000: Fix sizeof() mismatches
      PCI: Fix overflow in command-line resource alignment requests
      block/rnbd: fix a null pointer dereference on dev->blk_symlink_name
      drm/mediatek: avoid dereferencing a null hdmi_phy on an error message

Connor McAdams (2):
      ALSA: hda/ca0132 - Change Input Source enum strings.
      ALSA: hda/ca0132 - Fix AE-5 rear headphone pincfg.

Corentin Labbe (1):
      crypto: sun8i-ce - fix two error path's memory leak

Cristian Birsan (3):
      ARM: dts: at91: sam9x60: add pincontrol for USB Host
      ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
      ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Cédric Le Goater (1):
      powerpc/smp: Add __init to init_big_cores()

Dai Ngo (1):
      NFSD: Fix 5 seconds delay when doing inter server copy

Damien Le Moal (2):
      null_blk: Fix zone size initialization
      null_blk: Fail zone append to conventional zones

Dan Aloni (1):
      sunrpc: fix xs_read_xdr_buf for partial pages receive

Dan Carpenter (16):
      soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
      rtc: pcf2127: fix pcf2127_nvmem_read/write() returns
      ASoC: qcom: common: Fix refcounting in qcom_snd_parse_of()
      drm/udl: Fix missing error code in udl_handle_damage()
      media: max2175: fix max2175_set_csm_mode() error code
      media: saa7146: fix array overflow in vidioc_s_audio()
      ASoC: max98390: Fix error codes in max98390_dsm_init()
      mtd: rawnand: meson: Fix a resource leak in init
      ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
      hugetlb: fix an error code in hugetlb_reserve_pages()
      qlcnic: Fix error code in probe
      virtio_ring: Cut and paste bugs in vring_create_virtqueue_packed()
      virtio_net: Fix error code in probe()
      virtio_ring: Fix two use after free bugs
      ext4: fix an IS_ERR() vs NULL check
      memory: jz4780_nemc: Fix an error pointer vs NULL check in probe()

Dan Williams (2):
      ACPI: NFIT: Fix input validation of bus-family
      libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels

Daniel Gomez (1):
      media: imx214: Fix stop streaming

Daniel Jordan (1):
      cpuset: fix race between hotplug work and later CPU offline

Daniel Lezcano (1):
      clocksource/drivers/ingenic: Fix section mismatch

Daniel Scally (1):
      Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Daniel T. Lee (1):
      samples: bpf: Fix lwt_len_hist reusing previous BPF map

Danil Kipnis (1):
      RDMA/rtrs-clt: Remove destroy_con_cq_qp in case route resolving failed

Dave Kleikamp (1):
      jfs: Fix array index bounds check in dbAdjTree

David Hildenbrand (2):
      powerpc/powernv/memtrace: Don't leak kernel memory to user space
      powerpc/powernv/memtrace: Fix crashing the kernel when enabling concurrently

David Jander (1):
      Input: ads7846 - fix race that causes missing releases

David Woodhouse (1):
      x86/apic: Fix x2apic enablement without interrupt remapping

DingHua Ma (1):
      regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x

Dmitry Baryshkov (4):
      drm/msm/dsi_pll_7nm: restore VCO rate during restore_state
      drm/msm/dsi_pll_10nm: restore VCO rate during restore_state
      drm/msm/dpu: fix clock scaling on non-sc7180 board
      arm64: dts: qcom: sm8250: correct compatible for sm8250-mtp

Dmitry Osipenko (1):
      clk: tegra: Fix duplicated SE clock entry

Dmitry Torokhov (1):
      Input: ads7846 - fix unaligned access on 7845

Dongjin Kim (1):
      arm64: dts: meson-sm1: fix typo in opp table

Douglas Anderson (5):
      arm64: dts: qcom: sc7180: Fix one forgotten interconnect reference
      soc: qcom: geni: More properly switch to DMA mode
      Revert "i2c: i2c-qcom-geni: Fix DMA transfer race"
      clk: qcom: gcc-sc7180: Use floor ops for sdcc clks
      irqchip/qcom-pdc: Fix phantom irq when changing between rising/falling

Dwaipayan Ray (1):
      checkpatch: fix unescaped left brace

Eddie James (1):
      fsi: Aspeed: Add mutex to protect HW access

Eli Cohen (1):
      vdpa/mlx5: Use write memory barrier after updating CQ index

Enric Balletbo i Serra (1):
      drm/mediatek: Use correct aliases name for ovl

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Evan Green (1):
      soc: qcom: smp2p: Safely acquire spinlock without IRQs

Fabien Parent (1):
      arm64: dts: mediatek: mt8183: fix gce incorrect mbox-cells value

Fedor Tokarev (1):
      net: sunrpc: Fix 'snprintf' return value check in 'do_xprt_debugfs'

Felix Fietkau (1):
      mt76: add back the SUPPORTS_REORDERING_BUFFER flag

Filipe Manana (1):
      btrfs: fix race when defragmenting leads to unnecessary IO

Finn Thain (3):
      macintosh/adb-iop: Always wait for reply message from IOP
      macintosh/adb-iop: Send correct poll command
      m68k: Fix WARNING splat in pmac_zilog driver

Geert Uytterhoeven (5):
      ASoC: intel: SND_SOC_INTEL_KEEMBAY should depend on ARCH_KEEMBAY
      mfd: MFD_SL28CPLD should depend on ARCH_LAYERSCAPE
      clk: renesas: r8a779a0: Fix R and OSC clocks
      clk: vc5: Use "idt,voltage-microvolt" instead of "idt,voltage-microvolts"
      ARM: 9036/1: uncompress: Fix dbgadtb size parameter name

Gioh Kim (1):
      RDMA/rtrs-clt: Missing error from rtrs_rdma_conn_established

Greg Kroah-Hartman (1):
      Linux 5.10.4

Guenter Roeck (3):
      hwmon: (k10temp) Remove support for displaying voltage and current on Zen CPUs
      watchdog: armada_37xx: Add missing dependency on HAS_IOMEM
      watchdog: sirfsoc: Add missing dependency on HAS_IOMEM

Guido Günther (1):
      drm: mxsfb: Silence -EPROBE_DEFER while waiting for bridge

Guoqing Jiang (1):
      RDMA/rtrs-srv: Don't guard the whole __alloc_srv with srv_mutex

H. Nikolaus Schaller (1):
      ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES

Han Xu (1):
      mtd: rawnand: gpmi: Fix the random DMA timeout issue

Hangbin Liu (2):
      selftests/run_kselftest.sh: fix dry-run typo
      selftest/bpf: Add missed ip6ip6 test back

Hanjun Guo (1):
      drm/amdkfd: Put ACPI table after using it

Hans Verkuil (1):
      media: i2c: imx219: Selection compliance fixes

Hans de Goede (3):
      power: supply: axp288_charger: Fix HP Pavilion x2 10 DMI matching
      Bluetooth: btusb: Fix detection of some fake CSR controllers with a bcdDevice val of 0x0134
      platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on some HP x360 models

Hao Li (1):
      fs: Handle I_DONTCACHE in iput_final() instead of generic_drop_inode()

He Zhe (1):
      pinctrl: core: Add missing #ifdef CONFIG_GPIOLIB

Heiko Carstens (1):
      s390/test_unwind: fix CALL_ON_STACK tests

Horia Geantă (2):
      crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
      crypto: caam - fix printing on xts fallback allocation error path

Huang Jianan (1):
      erofs: avoid using generic_block_bmap

Hugues Fruchet (1):
      media: ov5640: fix support of BT656 bus mode

Hui Wang (2):
      ACPI: PNP: compare the string length in the matching_id()
      ALSA: hda/realtek: make bass spk volume adjustable on a yoga laptop

Hyeongseok Kim (1):
      f2fs: fix double free of unicode map

Ian Abbott (1):
      staging: comedi: mf6x4: Fix AI end-of-conversion detection

Ioana Ciornei (1):
      dpaa2-eth: fix the size of the mapped SGT buffer

JC Kuo (1):
      phy: tegra: xusb: Fix usb_phy device driver field

Jack Morgenstein (1):
      RDMA/core: Do not indicate device ready when device enablement fails

Jack Wang (1):
      block/rnbd-clt: Fix possible memleak

Jack Xu (1):
      crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()

Jacopo Mondi (2):
      media: max9271: Fix GPIO enable/disable
      media: rdacm20: Enable GPIO1 explicitly

Jaegeuk Kim (3):
      f2fs: call f2fs_get_meta_page_retry for nat page
      scsi: ufs: Avoid to call REQ_CLKS_OFF to CLKS_OFF
      scsi: ufs: Fix clkgating on/off

James Smart (3):
      scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()
      scsi: lpfc: Fix scheduling call while in softirq context in lpfc_unreg_rpi
      scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()

Jan Kara (2):
      ext4: fix deadlock with fs freezing and EA inodes
      ext4: don't remount read-only with errors=continue on reboot

Jaroslav Kysela (2):
      ASoC: AMD Renoir - add DMI table to avoid the ACP mic probe (broken BIOS)
      ASoC: AMD Raven/Renoir - fix the PCI probe (PCI revision)

Jason A. Donenfeld (1):
      crypto: Kconfig - CRYPTO_MANAGER_EXTRA_TESTS requires the manager

Jason Gunthorpe (6):
      RDMA/mlx5: Fix corruption of reg_pages in mlx5_ib_rereg_user_mr()
      RDMA/cma: Fix deadlock on &lock in rdma_cma_listen_on_all() error unwind
      vfio-pci: Use io_remap_pfn_range() for PCI IO memory
      mm/gup: reorganize internal_get_user_pages_fast()
      mm/gup: prevent gup_fast from racing with COW during fork
      mm/gup: combine put_compound_head() and unpin_user_page()

Jens Axboe (1):
      io_uring: make ctx cancel on exit targeted to actual ctx

Jernej Skrabec (1):
      clk: sunxi-ng: Make sure divider tables have sentinel

Jerome Brunet (1):
      ASoC: meson: fix COMPILE_TEST error

Jim Cromie (1):
      dyndbg: fix use before null check

Jim Quinlan (1):
      PCI: brcmstb: Initialize "tmp" before use

Jing Xiangfeng (7):
      RDMA/core: Fix error return in _ib_modify_qp()
      staging: gasket: interrupt: fix the missed eventfd_ctx_put() in gasket_interrupt.c
      mfd: htc-i2cpld: Add the missed i2c_put_adapter() in htcpld_register_chip_i2c()
      HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()
      memstick: r592: Fix error return in r592_probe()
      Bluetooth: btusb: Add the missed release_firmware() in btusb_mtk_setup_firmware()
      Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_firmware()

Jiri Olsa (1):
      tools build: Add missing libcap to test-all.bin target

Joel Stanley (1):
      ARM: dts: aspeed: s2600wf: Fix VGA memory region location

Johan Hovold (9):
      USB: serial: mos7720: fix parallel-port state restore
      USB: serial: digi_acceleport: fix write-wakeup deadlocks
      USB: serial: keyspan_pda: fix dropped unthrottle interrupts
      USB: serial: keyspan_pda: fix write deadlock
      USB: serial: keyspan_pda: fix stalled writes
      USB: serial: keyspan_pda: fix write-wakeup use-after-free
      USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
      USB: serial: keyspan_pda: fix write unthrottling
      of: fix linker-section match-table corruption

Johannes Berg (4):
      iwlwifi: dbg-tlv: fix old length in is_trig_data_contained()
      iwlwifi: mvm: hook up missing RX handlers
      mac80211: don't set set TDLS STA bandwidth wider than possible
      um: Fix time-travel mode

Johannes Weiner (1):
      mm: don't wake kswapd prematurely when watermark boosting is disabled

Jon Hunter (1):
      ARM: tegra: Populate OPP table for Tegra20 Ventana

Jonathan Cameron (8):
      iio:light:rpr0521: Fix timestamp alignment and prevent data leak.
      iio:light:st_uvis25: Fix timestamp alignment and prevent data leak.
      iio:magnetometer:mag3110: Fix alignment and data leak issues.
      iio:pressure:mpl3115: Force alignment of buffer
      iio:imu:bmi160: Fix too large a buffer.
      iio:imu:bmi160: Fix alignment and data leak issues
      iio:adc:ti-ads124s08: Fix buffer being too long.
      iio:adc:ti-ads124s08: Fix alignment and data leak issues.

Jordan Niethe (2):
      powerpc/64: Set up a kernel stack for secondaries before cpu_restore()
      powerpc/64: Fix an EMIT_BUG_ENTRY in head_64.S

Josef Bacik (2):
      btrfs: do not shorten unpin len for caching block groups
      btrfs: update last_byte_to_unpin in switch_commit_roots

Jubin Zhong (1):
      PCI: Fix pci_slot_release() NULL pointer dereference

KP Singh (1):
      bpf: Fix tests for local_storage

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix silent stream for first playback to DP

Kailang Yang (2):
      ALSA: hda/realtek - Add supported for more Lenovo ALC285 Headset Button
      ALSA: hda/realtek - Supported Dell fixed type headset

Kaixu Xia (1):
      powerpc/powernv/sriov: fix unsigned int win compared to less than zero

Kajol Jain (1):
      perf test: Fix metric parsing test

Kamal Heib (2):
      RDMA/bnxt_re: Set queue pair state when being queried
      RDMA/cxgb4: Validate the number of CQEs

Kan Liang (3):
      perf/x86/intel: Add event constraint for CYCLE_ACTIVITY.STALLS_MEM_ANY
      perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake
      perf/x86/intel/lbr: Fix the return type of get_lbr_cycles()

Karthikeyan Periyasamy (1):
      ath11k: fix wmi init configuration

Kathiravan T (1):
      arm64: dts: ipq6018: update the reserved-memory node

Kefeng Wang (1):
      clocksource/drivers/riscv: Make RISCV_TIMER depends on RISCV_SBI

Keita Suzuki (1):
      media: siano: fix memory leak of debugfs members in smsdvb_hotplug

Keqian Zhu (2):
      clocksource/drivers/arm_arch_timer: Use stable count reader in erratum sne
      clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Kevin Hilman (1):
      clk: meson: Kconfig: fix dependency for G12A

Krzysztof Kozlowski (2):
      drm/mcde: Fix handling of platform_get_irq() error
      drm/tve200: Fix handling of platform_get_irq() error

Kuogee Hsieh (2):
      drm/msm/dp: return correct connection status after suspend
      drm/msm/dp: skip checking LINK_STATUS_UPDATED bit

Lad Prabhakar (4):
      media: v4l2-fwnode: Return -EINVAL for invalid bus-type
      memory: renesas-rpc-if: Fix a node reference leak in rpcif_probe()
      memory: renesas-rpc-if: Return correct value to the caller of rpcif_manual_xfer()
      memory: renesas-rpc-if: Fix unbalanced pm_runtime_enable in rpcif_{enable,disable}_rpm

Lang Cheng (1):
      RDMA/hns: Fix 0-length sge calculation error

Lars-Peter Clausen (2):
      iio: hrtimer-trigger: Mark hrtimer to expire in hard interrupt context
      iio: ad_sigma_delta: Don't put SPI transfer buffer on the stack

Laurentiu Palcu (1):
      drm/imx/dcss: fix rotations for Vivante tiled formats

Laurentiu Tudor (1):
      bus: fsl-mc: add back accidentally dropped error check

Leon Romanovsky (4):
      RDMA/cma: Add missing error handling of listen_id
      RDMA/core: Track device memory MRs
      net/mlx5: Properly convey driver version to firmware
      RDMA/cma: Don't overwrite sgid_attr after device is released

Lingling Xu (2):
      watchdog: sprd: remove watchdog disable from resume fail path
      watchdog: sprd: check busy bit before new loading rather than after that

Linus Torvalds (2):
      proc mountinfo: make splice available again
      drm/edid: fix objtool warning in drm_cvt_modes()

Lokesh Vutla (3):
      irqchip/ti-sci-inta: Fix printing of inta id on probe success
      irqchip/ti-sci-intr: Fix freeing of irqs
      pwm: lp3943: Dynamically allocate PWM chip base

Lorenzo Bianconi (5):
      mt76: mt7663s: fix a possible ple quota underflow
      mt76: dma: fix possible deadlock running mt76_dma_cleanup
      mt76: fix memory leak if device probing fails
      mt76: fix tkip configuration for mt7615/7663 devices
      iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Luis Henriques (1):
      ceph: fix race in concurrent __ceph_remove_cap invocations

Lukas Bulwahn (1):
      iommu/vt-d: include conditionally on CONFIG_INTEL_IOMMU_SVM

Lukas Wunner (21):
      media: netup_unidvb: Don't leak SPI master in probe error path
      spi: pxa2xx: Fix use-after-free on unbind
      spi: spi-sh: Fix use-after-free on unbind
      spi: atmel-quadspi: Fix use-after-free on unbind
      spi: spi-mtk-nor: Don't leak SPI master in probe error path
      spi: ar934x: Don't leak SPI master in probe error path
      spi: davinci: Fix use-after-free on unbind
      spi: gpio: Don't leak SPI master in probe error path
      spi: mxic: Don't leak SPI master in probe error path
      spi: npcm-fiu: Disable clock in probe error path
      spi: pic32: Don't leak DMA channels in probe error path
      spi: rb4xx: Don't leak SPI master in probe error path
      spi: rpc-if: Fix use-after-free on unbind
      spi: sc18is602: Don't leak SPI master in probe error path
      spi: spi-geni-qcom: Fix use-after-free on unbind
      spi: spi-qcom-qspi: Fix use-after-free on unbind
      spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path
      spi: synquacer: Disable clock in probe error path
      spi: mt7621: Disable clock in probe error path
      spi: mt7621: Don't leak SPI master in probe error path
      spi: atmel-quadspi: Disable clock in probe error path

Lyude Paul (1):
      drm/edid: Fix uninitialized variable in drm_cvt_modes()

Maarten Lankhorst (1):
      dma-buf/dma-resv: Respect num_fences when initializing the shared fence list.

Madhavan Srinivasan (1):
      powerpc/perf: Fix Threshold Event Counter Multiplier width for P10

Magnus Karlsson (1):
      samples/bpf: Fix possible hang in xdpsock with multiple threads

Maharaja Kennadyrajan (1):
      ath11k: Fix the rx_filter flag setting for peer rssi stats

Manivannan Sadhasivam (1):
      watchdog: qcom: Avoid context switch in restart handler

Mansur Alisha Shaik (4):
      media: venus: core: change clk enable and disable order in resume and suspend
      media: venus: core: vote for video-mem path
      media: venus: core: vote with average bandwidth and peak bandwidth as zero
      media: venus: put dummy vote on video-mem path after last session release

Maor Gottlieb (1):
      RDMA/mlx5: Fix MR cache memory leak

Marc Zyngier (9):
      drm/meson: Free RDMA resources after tearing down DRM
      drm/meson: Unbind all connectors on module removal
      drm/meson: dw-hdmi: Register a callback to disable the regulator
      drm/meson: dw-hdmi: Ensure that clocks are enabled before touching the TOP registers
      drm/meson: dw-hdmi: Disable clocks on driver teardown
      drm/meson: dw-hdmi: Enable the iahb clock early enough
      genirq/irqdomain: Don't try to free an interrupt that has no mapping
      irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
      KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Marek Behún (2):
      leds: turris-omnia: check for LED_COLOR_ID_RGB instead LED_COLOR_ID_MULTI
      arm64: dts: armada-3720-turris-mox: update ethernet-phy handle name

Marek Szyprowski (1):
      extcon: max77693: Fix modalias string

Marijn Suijten (1):
      drm/msm: a5xx: Make preemption reset case reentrant

Martin Wilck (1):
      scsi: core: Fix VPD LUN ID designator priorities

Masahiro Yamada (1):
      kconfig: fix return value of do_error_if()

Masami Hiramatsu (2):
      x86/kprobes: Restore BTF if the single-stepping is cancelled
      tracing: Disable ftrace selftests when any tracer is running

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Matthew Wilcox (Oracle) (1):
      sparc: fix handling of page table constructor failure

Mauro Carvalho Chehab (1):
      scripts: kernel-doc: fix parsing function-like typedefs

Maxim Kochetkov (1):
      spi: spi-fsl-dspi: Use max_native_cs instead of num_chipselect to set SPI_MCR

Md Haris Iqbal (2):
      block/rnbd-clt: Dynamically alloc buffer for pathname & blk_symlink_name
      block/rnbd-clt: Get rid of warning regarding size argument in strlcpy

Michael Ellerman (2):
      powerpc/32s: Fix cleanup_cpu_mmu_context() compile bug
      powerpc/boot: Fix build of dts/fsl

Michael Walle (8):
      arm64: dts: ls1028a: fix ENETC PTP clock input
      arm64: dts: ls1028a: fix FlexSPI clock input
      arm64: dts: freescale: sl28: combine SPI MTD partitions
      mtd: spi-nor: sst: fix BPn bits for the SST25VF064C
      mtd: spi-nor: ignore errors in spi_nor_unlock_all()
      mtd: spi-nor: atmel: remove global protection flag
      mtd: spi-nor: atmel: fix unlock_all() for AT25FS010/040
      clk: fsl-sai: fix memory leak

Mickaël Salaün (1):
      selftests/seccomp: Update kernel config

Miklos Szeredi (2):
      virtiofs fix leak in setup
      ovl: make ioctl() safe

Miquel Raynal (1):
      mtd: spinand: Fix OOB read

Muchun Song (2):
      mm: memcg/slab: fix return of child memcg objcg for root memcg
      mm: memcg/slab: fix use after free in obj_cgroup_charge

Namhyung Kim (1):
      perf test: Use generic event for expand_libpfm_events()

Nathan Chancellor (1):
      crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd

Nathan Lynch (2):
      powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops
      powerpc/pseries/hibernation: remove redundant cacheinfo update

Necip Fazil Yildiran (1):
      MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

NeilBrown (1):
      NFS: switch nfsiod to be an UNBOUND workqueue.

Nicolas Boichat (1):
      soc: mediatek: Check if power domains can be powered on at boot time

Nicolas Ferre (1):
      ARM: dts: at91: sama5d2: fix CAN message ram offset and size

Nicolas Saenz Julienne (1):
      clk: bcm: dvp: Add MODULE_DEVICE_TABLE()

Nicolin Chen (1):
      clk: tegra: Do not return 0 on failure

Nikita Shubin (2):
      gpiolib: irq hooks: fix recursion in gpiochip_irq_unmask
      rtc: ep93xx: Fix NULL pointer dereference in ep93xx_rtc_read_time

Nikita Travkin (1):
      arm64: dts: qcom: msm8916-samsung-a2015: Disable muic i2c pin bias

Nirmoy Das (1):
      drm/amdgpu: fix compute queue priority if num_kcq is less than 4

Nishanth Menon (1):
      arm64: dts: ti: k3-am65*/j721e*: Fix unit address format error for dss node

Nuno Sá (1):
      iio: buffer: Fix demux update

Oleksij Rempel (2):
      Input: ads7846 - fix integer overflow on Rt calculation
      net: dsa: qca: ar9331: fix sleeping function called from invalid context bug

Olga Kornievskaia (1):
      NFSv4.2: condition READDIR's mask for security label based on LSM state

Oscar Salvador (1):
      mm,memory_failure: always pin the page in madvise_inject_error

Pali Rohár (9):
      cpufreq: ap806: Add missing MODULE_DEVICE_TABLE
      cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
      cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE
      cpufreq: qcom: Add missing MODULE_DEVICE_TABLE
      cpufreq: st: Add missing MODULE_DEVICE_TABLE
      cpufreq: sun50i: Add missing MODULE_DEVICE_TABLE
      cpufreq: loongson1: Add missing MODULE_ALIAS
      cpufreq: scpi: Add missing MODULE_ALIAS
      cpufreq: vexpress-spc: Add missing MODULE_ALIAS

Paolo Bonzini (1):
      KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits

Paul Cercueil (1):
      clk: ingenic: Fix divider calculation with div tables

Paul Moore (1):
      selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Pavel Begunkov (8):
      io_uring: cancel only requests of current task
      io_uring: fix racy IOPOLL flush overflow
      io_uring: cancel reqs shouldn't kill overflow list
      io_uring: fix io_cqring_events()'s noflush
      io_uring: fix racy IOPOLL completions
      io_uring: fix 0-iov read buffer select
      io_uring: fix ignoring xa_store errors
      io_uring: fix double io_uring free

Pawel Wieczorkiewicz (1):
      xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Paweł Chmiel (2):
      arm64: dts: exynos: Include common syscon restart/poweroff for Exynos7
      arm64: dts: exynos: Correct psci compatible used on Exynos7

Peng Liu (1):
      sched/deadline: Fix sched_dl_global_validate()

Peter Collingbourne (1):
      arm64: mte: fix prctl(PR_GET_TAGGED_ADDR_CTRL) if TCF0=NONE

Peter Ujfalusi (1):
      dmaengine: ti: k3-udma: Correct normal channel offset when uchan_cnt is not 0

Peter Zijlstra (2):
      rcu: Allow rcu_irq_enter_check_tick() from NMI
      rcu,ftrace: Fix ftrace recursion

Philipp Rudo (1):
      s390/kexec_file: fix diag308 subcode when loading crash kernel

Pierre-Louis Bossart (2):
      ASoC: SOF: Intel: fix Kconfig dependency for SND_INTEL_DSP_CONFIG
      soundwire: master: use pm_runtime_set_active() on add

Pradeep Kumar Chitrapu (1):
      ath11k: Fix incorrect tlvs in scan start command

Praveenkumar I (1):
      mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read

Qinglang Miao (13):
      spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
      spi: bcm63xx-hsspi: fix missing clk_disable_unprepare() on error in bcm63xx_hsspi_resume
      firmware: arm_scmi: Fix missing destroy_workqueue()
      media: solo6x10: fix missing snd_card_free in error handling case
      memstick: fix a double-free bug in memstick_check
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
      mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
      platform/x86: dell-smbios-base: Fix error return code in dell_smbios_init
      dm ioctl: fix error return code in target_message
      scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
      scsi: iscsi: Fix inappropriate use of put_device()
      s390/cio: fix use-after-free in ccw_device_destroy_console
      iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Qiuxu Zhuo (1):
      EDAC/i10nm: Use readl() to access MMIO registers

Quinn Tran (1):
      scsi: qla2xxx: Fix N2N and NVMe connect retry failure

Rafael J. Wysocki (2):
      PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()
      cpufreq: intel_pstate: Use most recent guaranteed performance values

Rakesh Pillai (1):
      ath10k: Fix the parsing error in service available event

Randy Dunlap (2):
      drm/aspeed: Fix Kconfig warning & subsequent build errors
      spi: dw: fix build error by selecting MULTIPLEXER

Rasmus Villemoes (1):
      spi: fsl: fix use of spisel_boot signal on MPC8309

Ravi Bangoria (2):
      powerpc/xmon: Fix build failure for 8xx
      powerpc/sstep: Cover new VSX instructions under CONFIG_VSX

Richard Weinberger (2):
      ubifs: wbuf: Don't leak kernel memory to flash
      mtd: core: Fix refcounting for unpartitioned MTDs

Rob Clark (2):
      drm/msm/a6xx: Clear shadow on suspend
      drm/msm/a5xx: Clear shadow on suspend

Roberto Sassu (1):
      ima: Don't modify file descriptor mode on the fly

Robin Gong (1):
      ALSA: core: memalloc: add page alignment for iram

Robin Murphy (1):
      drm/msm: Add missing stub definition

Roman Bacik (1):
      PCI: iproc: Invalidate correct PAXB inbound windows

Sakari Ailus (6):
      media: v4l2-fwnode: v4l2_fwnode_endpoint_parse caller must init vep argument
      media: ipu3-cio2: Remove traces of returned buffers
      media: ipu3-cio2: Return actual subdev format
      media: ipu3-cio2: Serialise access to pad format
      media: ipu3-cio2: Validate mbus format in setting subdev format
      media: ipu3-cio2: Make the field on subdev format V4L2_FIELD_NONE

Sathish Narasimman (1):
      Bluetooth: Fix: LL PRivacy BLE device fails to connect

Sathyanarayana Nujella (1):
      ASoC: Intel: Boards: tgl_max98373: update TDM slot_width

Sean Nyekjaer (1):
      can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit

Sean Young (1):
      media: sunxi-cir: ensure IR is handled when it is continuous

Sebastian Andrzej Siewior (1):
      orinoco: Move context allocation after processing the skb

Sebastian Krzyszkowiak (2):
      power: supply: bq25890: Use the correct range for IILIM register
      power: supply: max17042_battery: Fix current_{avg,now} hiding with no current sense

Selvin Xavier (1):
      RDMA/bnxt_re: Fix entry size during SRQ create

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Sergei Antonov (1):
      mtd: rawnand: meson: fix meson_nfc_dma_buffer_release() arguments

Seung-Woo Kim (1):
      brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}

Shakeel Butt (1):
      mm/rmap: always do TTU_IGNORE_ACCESS

Shannon Nelson (3):
      ionic: use mc sync for multicast filters
      ionic: flatten calls to ionic_lif_rx_mode
      ionic: change set_rx_mode from_ndo to can_sleep

Simon Horman (1):
      nfp: move indirect block cleanup to flower app stop callback

Soheil Hassas Yeganeh (1):
      epoll: check for events when removing a timed out thread from the wait queue

Srinivas Kandagatla (2):
      soundwire: Fix DEBUG_LOCKS_WARN_ON for uninitialized attribute
      ASoC: q6afe-clocks: Add missing parent clock rate

Stefan Agner (5):
      arm64: dts: meson: g12b: odroid-n2: fix PHY deassert timing requirements
      arm64: dts: meson: fix PHY deassert timing requirements
      ARM: dts: meson: fix PHY deassert timing requirements
      arm64: dts: meson: g12a: x96-max: fix PHY deassert timing requirements
      arm64: dts: meson: g12b: w400: fix PHY deassert timing requirements

Stefan Haberland (4):
      s390/dasd: fix hanging device offline processing
      s390/dasd: prevent inconsistent LCU device data
      s390/dasd: fix list corruption of pavgroup group list
      s390/dasd: fix list corruption of lcu list

Stephen Boyd (2):
      drm/panel: simple: Add flags to boe_nv133fhm_n61
      platform/chrome: cros_ec_spi: Don't overwrite spi::mode

Steve French (3):
      SMB3: avoid confusing warning message on mount to Azure
      SMB3.1.1: remove confusing mount warning when no SPNEGO info on negprot rsp
      SMB3.1.1: do not log warning message if server doesn't populate salt

Steven Rostedt (VMware) (1):
      Revert: "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"

Stylon Wang (1):
      drm/amd/display: Fix memory leaks in S3 resume

Sudeep Holla (1):
      mailbox: arm_mhu_db: Fix mhu_db_shutdown by replacing kfree with devm_kfree

Sven Eckelmann (5):
      ath11k: Initialize complete alpha2 for regulatory change
      ath11k: Fix number of rules in filtered ETSI regdomain
      ath11k: Don't cast ath11k_skb_cb to ieee80211_tx_info.control
      ath11k: Reset ath11k_skb_cb before setting new flags
      mtd: parser: cmdline: Fix parsing of part-names with colons

Sven Schnelle (3):
      s390/smp: perform initial CPU reset also for SMT siblings
      s390/idle: add missing mt_cycles calculation
      s390/idle: fix accounting with machine checks

Sven Van Asbroeck (1):
      lan743x: fix rx_napi_poll/interrupt ping-pong

Taehee Yoo (2):
      mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
      mt76: set fops_tx_stats.owner to THIS_MODULE

Takashi Iwai (7):
      ALSA: hda: Fix regressions on clear and reconfig sysfs
      ALSA: pcm: oss: Fix a few more UBSAN fixes
      ALSA: hda/realtek: Add quirk for MSI-GP73
      ALSA: usb-audio: Disable sample read check if firmware doesn't give back
      ALSA: usb-audio: Add alias entry for ASUS PRIME TRX40 PRO-S
      ASoC: cx2072x: Fix doubly definitions of Playback and Capture streams
      driver: core: Fix list corruption after device_del()

Tanmay Shah (1):
      drm/msm/dp: DisplayPort PHY compliance tests fixup

Terry Zhou (1):
      clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Thierry Reding (1):
      pwm: sun4i: Remove erroneous else branch

Thomas Gleixner (1):
      sched: Reenable interrupts in do_sched_yield()

Tianyue Ren (1):
      selinux: fix error initialization in inode_doinit_with_dentry()

Tobias Klauser (1):
      devlink: use _BITUL() macro instead of BIT() in the UAPI header

Todd Kjos (1):
      binder: add flag to clear buffer on txn complete

Toke Høiland-Jørgensen (1):
      libbpf: Sanitise map names before pinning

Tom Lendacky (1):
      KVM: SVM: Remove the call to sev_platform_status() during setup

Tom Rix (2):
      drm/gma500: fix double free of gma_connector
      soc: qcom: initialize local variable

Tomasz Nowicki (1):
      arm64: dts: marvell: keep SMMU disabled by default for Armada 7040 and 8040

Tomi Valkeinen (1):
      arm64: dts: ti: k3-am65: mark dss as dma-coherent

Tony Lindgren (2):
      soc: ti: omap-prm: Do not check rstst bit on deassert if already deasserted
      mfd: cpcap: Fix interrupt regression with regmap clear_ack

Trond Myklebust (4):
      SUNRPC: rpc_wake_up() should wake up tasks in the correct order
      SUNRPC: xprt_load_transport() needs to support the netid "rdma6"
      NFSv4: Fix the alignment of page data in the getdeviceinfo reply
      NFS/pNFS: Fix a typo in ff_layout_resend_pnfs_read()

Tsuchiya Yuto (1):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure

Tudor Ambarus (1):
      spi: atmel-quadspi: Fix AHB memory accesses

Tyrel Datwyler (1):
      powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter

Tzung-Bi Shih (2):
      remoteproc/mediatek: change MT8192 CFG register base
      remoteproc/mediatek: unprepare clk if scp_before_load fails

Uladzislau Rezki (Sony) (1):
      rcu/tree: Defer kvfree_rcu() allocation to a clean context

Uwe Kleine-König (3):
      spi: fix resource leak for drivers without .remove callback
      pwm: zx: Add missing cleanup in error path
      pwm: imx27: Fix overflow for bigger periods

Vadim Pasternak (4):
      platform/x86: mlx-platform: Remove PSU EEPROM from default platform configuration
      platform/x86: mlx-platform: Remove PSU EEPROM from MSN274x platform configuration
      platform/x86: mlx-platform: Fix item counter assignment for MSN2700, MSN24xx systems
      platform/x86: mlx-platform: Fix item counter assignment for MSN2700/ComEx system

Vidya Sagar (1):
      arm64: tegra: Fix DT binding for IO High Voltage entry

Vijay Khemka (1):
      ARM: dts: aspeed: tiogapass: Remove vuart

Vincent Stehlé (2):
      powerpc/ps3: use dma_mapping_error()
      net: korina: fix return value

Vincenzo Frascino (1):
      mm/vmalloc.c: fix kasan shadow poisoning size

Vinod Koul (1):
      soundwire: qcom: Fix build failure when slimbus is module

Vitaly Wool (2):
      z3fold: simplify freeing slots
      z3fold: stricter locking and more careful reclaim

Waiman Long (1):
      mm/vmalloc: Fix unlock order in s_stop()

Wang Hai (4):
      staging: mfd: hi6421-spmi-pmic: fix error return code in hi6421_spmi_pmic_probe()
      qtnfmac: fix error return code in qtnf_pcie_probe()
      staging: greybus: audio: Fix possible leak free widgets in gbaudio_dapm_free_controls
      device-dax/core: Fix memory leak when rmmod dax.ko

Wang Li (1):
      phy: renesas: rcar-gen3-usb2: disable runtime pm in case of failure

Wang ShaoBo (1):
      ubifs: Fix error return code in ubifs_init_authentication()

Wang Wensheng (1):
      watchdog: Fix potential dereferencing of null pointer

Wei Yongjun (1):
      Bluetooth: sco: Fix crash when using BT_SNDMTU/BT_RCVMTU option

Weihang Li (4):
      RDMA/hns: Only record vlan info for HIP08
      RDMA/hns: Fix missing fields in address vector
      RDMA/hns: Avoid setting loopback indicator when smac is same as dmac
      RDMA/hns: Do shift on traffic class when using RoCEv2

Wen Gong (1):
      mac80211: fix a mistake check for rx_stats update

Wenpeng Liang (2):
      RDMA/hns: Limit the length of data copied between kernel and userspace
      RDMA/hns: Normalization the judgment of some features

William Breathitt Gray (1):
      counter: microchip-tcb-capture: Fix CMR value check

Wolfram Sang (1):
      mmc: sdhci: tegra: fix wrong unit with busy_timeout

Xiang Chen (1):
      scsi: hisi_sas: Fix up probe error handling for v3 hw

Xiaoguang Wang (3):
      io_uring: always let io_iopoll_complete() complete polled io
      io_uring: fix io_wqe->work_list corruption
      io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()

Xiongfeng Wang (1):
      misc: pci_endpoint_test: fix return value of error branch

Yang Yingliang (5):
      video: fbdev: atmel_lcdfb: fix return error code in atmel_lcdfb_of_init()
      drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
      usb/max3421: fix return error code in max3421_probe()
      clocksource/drivers/orion: Add missing clk_disable_unprepare() on error path
      speakup: fix uninitialized flush_lock

Yangtao Li (2):
      pinctrl: sunxi: fix irq bank map for the Allwinner A100 pin controller
      pinctrl: sunxi: Always call chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler

Yangyang Li (1):
      RDMA/hns: Bugfix for calculation of extended sge

Yazen Ghannam (2):
      EDAC/mce_amd: Use struct cpuinfo_x86.cpu_die_id for AMD NodeId
      x86/CPU/AMD: Save AMD NodeId as cpu_die_id

Yu Kuai (9):
      media: platform: add missing put_device() call in mtk_jpeg_clk_init()
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_dec_pm()
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_enc_pm()
      media: platform: add missing put_device() call in mtk_jpeg_probe() and mtk_jpeg_remove()
      leds: netxbig: add missing put_device() call in netxbig_leds_get_of_pdata()
      soc: amlogic: canvas: add missing put_device() call in meson_canvas_get()
      clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()
      pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

YueHaibing (2):
      drm/bridge: tpd12s015: Fix irq registering in tpd12s015_probe
      remoteproc: k3-dsp: Fix return value check in k3_dsp_rproc_of_get_memories()

Zhang Changzhong (11):
      brcmfmac: fix error return code in brcmf_cfg80211_connect()
      rsi: fix error return code in rsi_reset_card()
      soc: rockchip: io-domain: Fix error return code in rockchip_iodomain_probe()
      memory: jz4780_nemc: Fix potential NULL dereference in jz4780_nemc_probe()
      spi: dw: Fix error return code in dw_spi_bt1_probe()
      adm8211: fix error return code in adm8211_probe()
      scsi: fnic: Fix error return code in fnic_probe()
      bus: fsl-mc: fix error return code in fsl_mc_object_allocate()
      slimbus: qcom: fix potential NULL dereference in qcom_slim_prg_slew()
      remoteproc: qcom: Fix potential NULL dereference in adsp_init_mmio()
      vhost scsi: fix error return code in vhost_scsi_set_endpoint()

Zhang Qilong (33):
      spi: img-spfi: fix reference leak in img_spfi_resume
      spi: spi-mem: fix reference leak in spi_mem_access_start
      spi: stm32: fix reference leak in stm32_spi_resume
      spi: stm32-qspi: fix reference leak in stm32 qspi operations
      spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
      spi: tegra20-slink: fix reference leak in slink ops of tegra20
      spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
      spi: tegra114: fix reference leak in tegra spi ops
      spi: imx: fix reference leak in two imx operations
      ASoC: wm8994: Fix PM disable depth imbalance on error
      ASoC: wm8998: Fix PM disable depth imbalance on error
      spi: sprd: fix reference leak in sprd_spi_remove
      ASoC: arizona: Fix a wrong free in wm8997_probe
      staging: greybus: codecs: Fix reference counter leak in error handling
      media: staging: rkisp1: cap: fix runtime PM imbalance on error
      media: cedrus: fix reference leak in cedrus_start_streaming
      spi: mxs: fix reference leak in mxs_spi_probe
      crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
      soc: ti: knav_qmss: fix reference leak in knav_queue_probe
      soc: ti: Fix reference imbalance in knav_dma_probe
      Input: omap4-keypad - fix runtime PM error handling
      serial: 8250-mtk: Fix reference leak in mtk8250_probe
      power: supply: bq24190_charger: fix reference leak
      hwmon: (ina3221) Fix PM usage counter unbalance in ina3221_write_enable
      scsi: pm80xx: Fix error return in pm8001_pci_probe()
      usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
      usb: oxu210hp-hcd: Fix memory leak in oxu_create
      remoteproc: q6v5-mss: fix error handling in q6v5_pds_enable
      remoteproc: qcom: fix reference leak in adsp_start
      remoteproc: qcom: pas: fix error handling in adsp_pds_enable
      mtd: rawnand: gpmi: fix reference count leak in gpmi ops
      libnvdimm/label: Return -ENXIO for no slot in __blk_label_update
      clk: ti: Fix memleak in ti_fapll_synth_setup

Zhang Xiaoxu (2):
      Revert "powerpc/pseries/hotplug-cpu: Remove double free in error path"
      media: tvp5150: Fix wrong return value of tvp5150_parse_dt()

Zhao Heming (2):
      md/cluster: block reshape with remote resync job
      md/cluster: fix deadlock when node is doing resync job

Zhe Li (1):
      jffs2: Fix GC exit abnormally

Zhen Lei (1):
      x86/mce: Correct the detection of invalid notifier priorities

Zheng Zengkai (1):
      perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhihao Cheng (3):
      drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe
      mmc: pxamci: Fix error return code in pxamci_probe
      dmaengine: mv_xor_v2: Fix error return code in mv_xor_v2_probe()

Zhuguangqing (1):
      thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed

Zwane Mwaikambo (1):
      drm/dp_aux_dev: check aux_dev before use in drm_dp_aux_dev_get_by_minor()

kazuo ito (1):
      nfsd: Fix message level for normal termination

lizhe (1):
      jffs2: Fix ignoring mounting options problem during remounting

