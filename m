Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27929EABE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJ2LgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgJ2Lf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:35:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE712072C;
        Thu, 29 Oct 2020 11:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603971348;
        bh=KOnrK7z1G9Wwo4EHgkP/xMV30S4qkwynPu8jv+3eXRE=;
        h=From:To:Cc:Subject:Date:From;
        b=1uaYRroye4KsQheM1KTRUnBYwWiBncl14GC3QJrPawoHFViIO9HRd9yjz5Ud7od/j
         zKKhtyR6227YV02N77MWMbUvdz8IbyiuMIs+lWulxaSx3u+mXXe5QNQN606fXkfJmw
         h+LYYJkIWw3AfLl2/tKD+fFV9+8FO9dyBDSIMaKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.2
Date:   Thu, 29 Oct 2020 12:35:44 +0100
Message-Id: <16039713428135@kroah.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.2 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                                                |    2 
 Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml                       |    7 
 Documentation/devicetree/bindings/net/socionext-netsec.txt                                     |    4 
 Documentation/networking/ip-sysctl.rst                                                         |    4 
 Makefile                                                                                       |    2 
 arch/arc/plat-hsdk/Kconfig                                                                     |    1 
 arch/arm/boot/dts/imx6sl.dtsi                                                                  |    2 
 arch/arm/boot/dts/iwg20d-q7-common.dtsi                                                        |   15 
 arch/arm/boot/dts/meson8.dtsi                                                                  |    2 
 arch/arm/boot/dts/owl-s500.dtsi                                                                |    6 
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts                                                      |    2 
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi                                                  |   35 
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi                                                   |   38 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi                                             |    6 
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts                                              |   10 
 arch/arm/mach-at91/pm.c                                                                        |    1 
 arch/arm/mach-omap2/cpuidle44xx.c                                                              |    4 
 arch/arm/mach-s3c24xx/mach-at2440evb.c                                                         |    2 
 arch/arm/mach-s3c24xx/mach-h1940.c                                                             |    4 
 arch/arm/mach-s3c24xx/mach-mini2440.c                                                          |    4 
 arch/arm/mach-s3c24xx/mach-n30.c                                                               |    4 
 arch/arm/mach-s3c24xx/mach-rx1950.c                                                            |    4 
 arch/arm/mm/cache-l2x0.c                                                                       |   16 
 arch/arm64/boot/dts/actions/s700.dtsi                                                          |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi                                                   |    6 
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi                                             |    4 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                                                      |    1 
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi                                                   |    9 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                                          |   10 
 arch/arm64/boot/dts/qcom/msm8992.dtsi                                                          |    2 
 arch/arm64/boot/dts/qcom/pm8916.dtsi                                                           |    2 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                                                           |    6 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                                                     |   12 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                                           |    9 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                                           |    4 
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts                                                        |    4 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                                           |   11 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                                                      |    5 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                                                      |    5 
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts                                          |   11 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                                                      |   13 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                                                         |    4 
 arch/arm64/include/asm/insn.h                                                                  |    4 
 arch/arm64/include/asm/memory.h                                                                |    5 
 arch/arm64/include/asm/pgtable.h                                                               |    4 
 arch/arm64/kernel/cpu_errata.c                                                                 |    7 
 arch/arm64/kernel/insn.c                                                                       |    5 
 arch/arm64/kernel/perf_event.c                                                                 |    5 
 arch/arm64/kernel/probes/decode-insn.c                                                         |    3 
 arch/arm64/mm/init.c                                                                           |   30 
 arch/m68k/coldfire/device.c                                                                    |    6 
 arch/microblaze/include/asm/Kbuild                                                             |    1 
 arch/powerpc/Kconfig                                                                           |    2 
 arch/powerpc/include/asm/asm-prototypes.h                                                      |    4 
 arch/powerpc/include/asm/book3s/64/hash-4k.h                                                   |   13 
 arch/powerpc/include/asm/book3s/64/mmu.h                                                       |    2 
 arch/powerpc/include/asm/cputable.h                                                            |    2 
 arch/powerpc/include/asm/drmem.h                                                               |   39 
 arch/powerpc/include/asm/hw_breakpoint.h                                                       |    1 
 arch/powerpc/include/asm/reg.h                                                                 |    2 
 arch/powerpc/include/asm/svm.h                                                                 |    4 
 arch/powerpc/include/asm/tlb.h                                                                 |   13 
 arch/powerpc/kernel/cputable.c                                                                 |   13 
 arch/powerpc/kernel/entry_64.S                                                                 |    8 
 arch/powerpc/kernel/hw_breakpoint.c                                                            |   14 
 arch/powerpc/kernel/irq.c                                                                      |    9 
 arch/powerpc/kernel/ptrace/ptrace-noadv.c                                                      |    1 
 arch/powerpc/kernel/security.c                                                                 |   34 
 arch/powerpc/kernel/tau_6xx.c                                                                  |  147 +--
 arch/powerpc/mm/book3s64/radix_pgtable.c                                                       |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                                                           |   23 
 arch/powerpc/mm/drmem.c                                                                        |    6 
 arch/powerpc/mm/kasan/kasan_init_32.c                                                          |   12 
 arch/powerpc/mm/mem.c                                                                          |    6 
 arch/powerpc/perf/hv-gpci-requests.h                                                           |    6 
 arch/powerpc/perf/isa207-common.c                                                              |   10 
 arch/powerpc/platforms/Kconfig                                                                 |   14 
 arch/powerpc/platforms/powernv/opal-dump.c                                                     |   41 
 arch/powerpc/platforms/pseries/hotplug-memory.c                                                |   24 
 arch/powerpc/platforms/pseries/papr_scm.c                                                      |    8 
 arch/powerpc/platforms/pseries/ras.c                                                           |  118 +-
 arch/powerpc/platforms/pseries/rng.c                                                           |    1 
 arch/powerpc/platforms/pseries/svm.c                                                           |   26 
 arch/powerpc/sysdev/xics/icp-hv.c                                                              |    1 
 arch/powerpc/xmon/xmon.c                                                                       |    1 
 arch/s390/net/bpf_jit_comp.c                                                                   |   61 -
 arch/s390/pci/pci_bus.c                                                                        |    5 
 arch/um/drivers/vector_kern.c                                                                  |    4 
 arch/um/kernel/time.c                                                                          |   14 
 arch/x86/boot/compressed/pgtable_64.c                                                          |    9 
 arch/x86/events/amd/iommu.c                                                                    |    2 
 arch/x86/events/core.c                                                                         |    6 
 arch/x86/events/intel/ds.c                                                                     |   32 
 arch/x86/events/intel/uncore_snb.c                                                             |   31 
 arch/x86/events/intel/uncore_snbep.c                                                           |   19 
 arch/x86/events/perf_event.h                                                                   |    1 
 arch/x86/include/asm/special_insns.h                                                           |   28 
 arch/x86/kernel/cpu/common.c                                                                   |    4 
 arch/x86/kernel/cpu/mce/core.c                                                                 |   99 +-
 arch/x86/kernel/cpu/mce/internal.h                                                             |   10 
 arch/x86/kernel/cpu/mce/severity.c                                                             |   28 
 arch/x86/kernel/dumpstack.c                                                                    |    3 
 arch/x86/kernel/fpu/init.c                                                                     |   30 
 arch/x86/kernel/nmi.c                                                                          |    5 
 arch/x86/kvm/emulate.c                                                                         |    2 
 arch/x86/kvm/ioapic.c                                                                          |    5 
 arch/x86/kvm/kvm_cache_regs.h                                                                  |    2 
 arch/x86/kvm/lapic.c                                                                           |    7 
 arch/x86/kvm/lapic.h                                                                           |    1 
 arch/x86/kvm/mmu/mmu.c                                                                         |    1 
 arch/x86/kvm/svm/avic.c                                                                        |    1 
 arch/x86/kvm/svm/nested.c                                                                      |    2 
 arch/x86/kvm/svm/svm.h                                                                         |    2 
 arch/x86/kvm/vmx/nested.c                                                                      |   14 
 block/blk-core.c                                                                               |    9 
 block/blk-mq-sysfs.c                                                                           |    2 
 block/blk-mq-tag.c                                                                             |    3 
 block/blk-mq.c                                                                                 |    6 
 block/blk-sysfs.c                                                                              |    9 
 crypto/algif_aead.c                                                                            |    7 
 crypto/algif_skcipher.c                                                                        |    2 
 drivers/android/binder.c                                                                       |   37 
 drivers/base/regmap/regmap.c                                                                   |    2 
 drivers/bluetooth/btusb.c                                                                      |    1 
 drivers/bluetooth/hci_ldisc.c                                                                  |    1 
 drivers/bluetooth/hci_serdev.c                                                                 |    2 
 drivers/bus/mhi/core/Makefile                                                                  |    2 
 drivers/char/ipmi/ipmi_si_intf.c                                                               |    2 
 drivers/char/random.c                                                                          |    1 
 drivers/clk/at91/clk-main.c                                                                    |   11 
 drivers/clk/at91/sam9x60.c                                                                     |    2 
 drivers/clk/bcm/clk-bcm2835.c                                                                  |    4 
 drivers/clk/imx/clk-imx8mq.c                                                                   |    4 
 drivers/clk/keystone/sci-clk.c                                                                 |    2 
 drivers/clk/mediatek/clk-mt6779.c                                                              |    2 
 drivers/clk/meson/axg-audio.c                                                                  |  135 ++
 drivers/clk/meson/g12a.c                                                                       |   11 
 drivers/clk/qcom/gcc-sdm660.c                                                                  |    2 
 drivers/clk/qcom/gdsc.c                                                                        |    8 
 drivers/clk/rockchip/clk-half-divider.c                                                        |    2 
 drivers/clocksource/hyperv_timer.c                                                             |    4 
 drivers/cpufreq/armada-37xx-cpufreq.c                                                          |    6 
 drivers/cpufreq/powernv-cpufreq.c                                                              |    9 
 drivers/cpufreq/qcom-cpufreq-hw.c                                                              |   21 
 drivers/crypto/Kconfig                                                                         |    1 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c                                              |    5 
 drivers/crypto/caam/Kconfig                                                                    |    3 
 drivers/crypto/caam/caamalg.c                                                                  |   90 +
 drivers/crypto/caam/caamalg_qi.c                                                               |   90 +
 drivers/crypto/caam/caamalg_qi2.c                                                              |  106 ++
 drivers/crypto/caam/caamalg_qi2.h                                                              |    2 
 drivers/crypto/ccp/ccp-ops.c                                                                   |    2 
 drivers/crypto/ccree/cc_pm.c                                                                   |    6 
 drivers/crypto/chelsio/chtls/chtls_cm.c                                                        |   19 
 drivers/crypto/chelsio/chtls/chtls_io.c                                                        |    5 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                                                     |   16 
 drivers/crypto/ixp4xx_crypto.c                                                                 |    2 
 drivers/crypto/mediatek/mtk-platform.c                                                         |    8 
 drivers/crypto/omap-sham.c                                                                     |    3 
 drivers/crypto/picoxcell_crypto.c                                                              |    9 
 drivers/crypto/sa2ul.c                                                                         |    8 
 drivers/crypto/stm32/Kconfig                                                                   |    1 
 drivers/crypto/stm32/stm32-crc32.c                                                             |   15 
 drivers/dma/dmatest.c                                                                          |    5 
 drivers/dma/dw/core.c                                                                          |    4 
 drivers/dma/dw/dw.c                                                                            |    2 
 drivers/dma/dw/of.c                                                                            |    7 
 drivers/dma/ioat/dma.c                                                                         |    2 
 drivers/dma/ti/k3-udma-glue.c                                                                  |   19 
 drivers/edac/aspeed_edac.c                                                                     |    4 
 drivers/edac/i5100_edac.c                                                                      |   11 
 drivers/edac/ti_edac.c                                                                         |    3 
 drivers/firmware/arm_scmi/mailbox.c                                                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                                                       |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                                                         |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                                              |    3 
 drivers/gpu/drm/amd/display/dc/core/dc.c                                                       |   12 
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c                                            |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c                                      |  146 +++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h                                      |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c                                              |    2 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c                                              |    2 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                                          |    3 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c                                              |    2 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c                                          |    3 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c                                              |    2 
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h                                              |    4 
 drivers/gpu/drm/arm/malidp_planes.c                                                            |    2 
 drivers/gpu/drm/drm_debugfs_crc.c                                                              |    4 
 drivers/gpu/drm/drm_gem_vram_helper.c                                                          |   28 
 drivers/gpu/drm/gma500/cdv_intel_dp.c                                                          |    2 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c                                                 |   55 -
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h                                                |    2 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                                                        |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                                                          |   11 
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                                                    |    2 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                                                        |   10 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                                                       |    8 
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                                                              |   21 
 drivers/gpu/drm/panel/panel-simple.c                                                           |    4 
 drivers/gpu/drm/panfrost/panfrost_device.h                                                     |    3 
 drivers/gpu/drm/panfrost/panfrost_drv.c                                                        |   11 
 drivers/gpu/drm/panfrost/panfrost_gpu.c                                                        |   22 
 drivers/gpu/drm/panfrost/panfrost_gpu.h                                                        |    2 
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c                                                    |   10 
 drivers/gpu/drm/panfrost/panfrost_regs.h                                                       |    4 
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c                                                          |   12 
 drivers/gpu/drm/vc4/vc4_crtc.c                                                                 |   13 
 drivers/gpu/drm/vgem/vgem_drv.c                                                                |    2 
 drivers/gpu/drm/virtio/virtgpu_kms.c                                                           |    2 
 drivers/gpu/drm/virtio/virtgpu_vq.c                                                            |   10 
 drivers/gpu/drm/vkms/vkms_composer.c                                                           |    2 
 drivers/gpu/drm/vkms/vkms_drv.c                                                                |    2 
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                                                            |   27 
 drivers/hid/hid-ids.h                                                                          |    2 
 drivers/hid/hid-input.c                                                                        |    4 
 drivers/hid/hid-ite.c                                                                          |    4 
 drivers/hid/hid-multitouch.c                                                                   |    6 
 drivers/hid/hid-roccat-kone.c                                                                  |   23 
 drivers/hwmon/bt1-pvt.c                                                                        |  138 ++
 drivers/hwmon/bt1-pvt.h                                                                        |    3 
 drivers/hwmon/pmbus/max34440.c                                                                 |    3 
 drivers/hwmon/w83627ehf.c                                                                      |    6 
 drivers/hwtracing/coresight/coresight-cti.c                                                    |   41 
 drivers/hwtracing/coresight/coresight-etm-perf.c                                               |   14 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c                                            |    2 
 drivers/hwtracing/coresight/coresight-etm4x.c                                                  |  105 +-
 drivers/hwtracing/coresight/coresight-etm4x.h                                                  |    3 
 drivers/hwtracing/coresight/coresight-platform.c                                               |   10 
 drivers/hwtracing/coresight/coresight.c                                                        |    2 
 drivers/i2c/busses/Kconfig                                                                     |    1 
 drivers/i2c/i2c-core-acpi.c                                                                    |   11 
 drivers/i3c/master.c                                                                           |   19 
 drivers/i3c/master/i3c-master-cdns.c                                                           |    4 
 drivers/iio/adc/stm32-adc-core.c                                                               |    9 
 drivers/infiniband/core/cma.c                                                                  |  300 ++----
 drivers/infiniband/core/cq.c                                                                   |   30 
 drivers/infiniband/core/ucma.c                                                                 |    6 
 drivers/infiniband/core/umem.c                                                                 |   15 
 drivers/infiniband/core/uverbs_std_types_wq.c                                                  |    2 
 drivers/infiniband/core/verbs.c                                                                |   32 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                                                       |    3 
 drivers/infiniband/hw/bnxt_re/ib_verbs.h                                                       |    2 
 drivers/infiniband/hw/cxgb4/cq.c                                                               |    3 
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h                                                         |    2 
 drivers/infiniband/hw/efa/efa.h                                                                |    2 
 drivers/infiniband/hw/efa/efa_verbs.c                                                          |    3 
 drivers/infiniband/hw/hns/hns_roce_cq.c                                                        |    3 
 drivers/infiniband/hw/hns/hns_roce_device.h                                                    |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c                                                     |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                                                     |   41 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                                                     |    2 
 drivers/infiniband/hw/hns/hns_roce_qp.c                                                        |    6 
 drivers/infiniband/hw/i40iw/i40iw.h                                                            |    9 
 drivers/infiniband/hw/i40iw/i40iw_cm.c                                                         |   10 
 drivers/infiniband/hw/i40iw/i40iw_hw.c                                                         |    4 
 drivers/infiniband/hw/i40iw/i40iw_utils.c                                                      |   59 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c                                                      |   34 
 drivers/infiniband/hw/i40iw/i40iw_verbs.h                                                      |    3 
 drivers/infiniband/hw/mlx4/cm.c                                                                |    3 
 drivers/infiniband/hw/mlx4/cq.c                                                                |    3 
 drivers/infiniband/hw/mlx4/mad.c                                                               |   34 
 drivers/infiniband/hw/mlx4/main.c                                                              |    3 
 drivers/infiniband/hw/mlx4/mlx4_ib.h                                                           |    6 
 drivers/infiniband/hw/mlx4/qp.c                                                                |    3 
 drivers/infiniband/hw/mlx5/counters.c                                                          |    4 
 drivers/infiniband/hw/mlx5/cq.c                                                                |   14 
 drivers/infiniband/hw/mlx5/main.c                                                              |    4 
 drivers/infiniband/hw/mlx5/mlx5_ib.h                                                           |    6 
 drivers/infiniband/hw/mlx5/mr.c                                                                |   64 -
 drivers/infiniband/hw/mlx5/qp.c                                                                |   12 
 drivers/infiniband/hw/mlx5/qp.h                                                                |    4 
 drivers/infiniband/hw/mlx5/qpc.c                                                               |    5 
 drivers/infiniband/hw/mthca/mthca_provider.c                                                   |    3 
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c                                                    |    3 
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h                                                    |    2 
 drivers/infiniband/hw/qedr/main.c                                                              |    2 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                                                        |    6 
 drivers/infiniband/hw/qedr/verbs.c                                                             |   63 -
 drivers/infiniband/hw/qedr/verbs.h                                                             |    2 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c                                                   |    4 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h                                                   |    2 
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c                                                   |    3 
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h                                                |    2 
 drivers/infiniband/sw/rdmavt/cq.c                                                              |    3 
 drivers/infiniband/sw/rdmavt/cq.h                                                              |    2 
 drivers/infiniband/sw/rdmavt/vt.c                                                              |    4 
 drivers/infiniband/sw/rxe/rxe_recv.c                                                           |   20 
 drivers/infiniband/sw/rxe/rxe_verbs.c                                                          |    3 
 drivers/infiniband/sw/siw/siw_verbs.c                                                          |    3 
 drivers/infiniband/sw/siw/siw_verbs.h                                                          |    2 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                                                      |    2 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                                                   |   11 
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c                                                      |    2 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                                                         |   76 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.h                                                         |    7 
 drivers/input/keyboard/ep93xx_keypad.c                                                         |    4 
 drivers/input/keyboard/omap4-keypad.c                                                          |    6 
 drivers/input/keyboard/twl4030_keypad.c                                                        |    8 
 drivers/input/serio/sun4i-ps2.c                                                                |    9 
 drivers/input/touchscreen/elants_i2c.c                                                         |    2 
 drivers/input/touchscreen/imx6ul_tsc.c                                                         |   27 
 drivers/input/touchscreen/stmfts.c                                                             |    2 
 drivers/iommu/arm/arm-smmu/qcom_iommu.c                                                        |    8 
 drivers/irqchip/irq-ti-sci-inta.c                                                              |    4 
 drivers/irqchip/irq-ti-sci-intr.c                                                              |    4 
 drivers/lightnvm/core.c                                                                        |    5 
 drivers/mailbox/mailbox.c                                                                      |   12 
 drivers/mailbox/mtk-cmdq-mailbox.c                                                             |    8 
 drivers/md/dm.c                                                                                |   59 -
 drivers/md/md-bitmap.c                                                                         |    3 
 drivers/md/md-cluster.c                                                                        |    1 
 drivers/media/firewire/firedtv-fw.c                                                            |    6 
 drivers/media/i2c/m5mols/m5mols_core.c                                                         |    3 
 drivers/media/i2c/max9286.c                                                                    |   43 
 drivers/media/i2c/ov5640.c                                                                     |  196 ++--
 drivers/media/i2c/tc358743.c                                                                   |   14 
 drivers/media/pci/bt8xx/bttv-driver.c                                                          |   13 
 drivers/media/pci/saa7134/saa7134-tvaudio.c                                                    |    3 
 drivers/media/platform/exynos4-is/fimc-isp.c                                                   |    4 
 drivers/media/platform/exynos4-is/fimc-lite.c                                                  |    2 
 drivers/media/platform/exynos4-is/media-dev.c                                                  |    8 
 drivers/media/platform/exynos4-is/mipi-csis.c                                                  |    4 
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c                                                  |    2 
 drivers/media/platform/mx2_emmaprp.c                                                           |    7 
 drivers/media/platform/omap3isp/isp.c                                                          |    6 
 drivers/media/platform/qcom/camss/camss-csiphy.c                                               |    4 
 drivers/media/platform/qcom/venus/core.c                                                       |   20 
 drivers/media/platform/qcom/venus/vdec.c                                                       |   10 
 drivers/media/platform/rcar-fcp.c                                                              |    4 
 drivers/media/platform/rcar-vin/rcar-csi2.c                                                    |   24 
 drivers/media/platform/rcar-vin/rcar-dma.c                                                     |    4 
 drivers/media/platform/rcar_drif.c                                                             |   30 
 drivers/media/platform/rockchip/rga/rga-buf.c                                                  |    1 
 drivers/media/platform/s3c-camif/camif-core.c                                                  |    5 
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                                                    |    4 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                                                  |    3 
 drivers/media/platform/sti/delta/delta-v4l2.c                                                  |    4 
 drivers/media/platform/sti/hva/hva-hw.c                                                        |    4 
 drivers/media/platform/stm32/stm32-dcmi.c                                                      |    4 
 drivers/media/platform/ti-vpe/vpe.c                                                            |    2 
 drivers/media/platform/vsp1/vsp1_drv.c                                                         |   11 
 drivers/media/rc/ati_remote.c                                                                  |    4 
 drivers/media/test-drivers/vivid/vivid-meta-out.c                                              |    9 
 drivers/media/tuners/tuner-simple.c                                                            |    5 
 drivers/media/usb/uvc/uvc_ctrl.c                                                               |    6 
 drivers/media/usb/uvc/uvc_entity.c                                                             |   35 
 drivers/media/usb/uvc/uvc_v4l2.c                                                               |   30 
 drivers/memory/brcmstb_dpfe.c                                                                  |   23 
 drivers/memory/fsl-corenet-cf.c                                                                |    6 
 drivers/memory/omap-gpmc.c                                                                     |    8 
 drivers/mfd/sm501.c                                                                            |    8 
 drivers/mfd/syscon.c                                                                           |    2 
 drivers/misc/cardreader/rtsx_pcr.c                                                             |    4 
 drivers/misc/eeprom/at25.c                                                                     |    2 
 drivers/misc/habanalabs/gaudi/gaudi.c                                                          |    8 
 drivers/misc/habanalabs/goya/goya.c                                                            |    8 
 drivers/misc/mic/scif/scif_rma.c                                                               |    4 
 drivers/misc/mic/vop/vop_main.c                                                                |    2 
 drivers/misc/mic/vop/vop_vringh.c                                                              |   24 
 drivers/misc/ocxl/Kconfig                                                                      |    3 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                                                        |   10 
 drivers/mmc/core/sdio_cis.c                                                                    |    3 
 drivers/mtd/hyperbus/hbmc-am654.c                                                              |    4 
 drivers/mtd/lpddr/lpddr2_nvm.c                                                                 |   35 
 drivers/mtd/mtdoops.c                                                                          |   11 
 drivers/mtd/nand/raw/ams-delta.c                                                               |    2 
 drivers/mtd/nand/raw/stm32_fmc2_nand.c                                                         |    2 
 drivers/mtd/nand/raw/vf610_nfc.c                                                               |    6 
 drivers/mtd/nand/spi/gigadevice.c                                                              |   14 
 drivers/mtd/parsers/Kconfig                                                                    |    2 
 drivers/net/can/flexcan.c                                                                      |   34 
 drivers/net/can/m_can/m_can_platform.c                                                         |    2 
 drivers/net/dsa/microchip/ksz_common.c                                                         |   16 
 drivers/net/dsa/ocelot/seville_vsc9953.c                                                       |    2 
 drivers/net/dsa/realtek-smi-core.h                                                             |    4 
 drivers/net/dsa/rtl8366.c                                                                      |  280 +++---
 drivers/net/dsa/rtl8366rb.c                                                                    |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c                                           |  175 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h                                           |   15 
 drivers/net/ethernet/cisco/enic/enic.h                                                         |    1 
 drivers/net/ethernet/cisco/enic/enic_api.c                                                     |    6 
 drivers/net/ethernet/cisco/enic/enic_main.c                                                    |   27 
 drivers/net/ethernet/faraday/ftgmac100.c                                                       |    5 
 drivers/net/ethernet/faraday/ftgmac100.h                                                       |    8 
 drivers/net/ethernet/freescale/fec_main.c                                                      |   35 
 drivers/net/ethernet/ibm/ibmveth.c                                                             |   19 
 drivers/net/ethernet/ibm/ibmvnic.c                                                             |   10 
 drivers/net/ethernet/ibm/ibmvnic.h                                                             |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                                                   |   23 
 drivers/net/ethernet/korina.c                                                                  |    3 
 drivers/net/ethernet/mediatek/Kconfig                                                          |    1 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                                                     |    3 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                                                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c                                            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c                                    |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                                            |    5 
 drivers/net/ethernet/realtek/r8169_main.c                                                      |    8 
 drivers/net/ethernet/sfc/ef100_nic.c                                                           |   12 
 drivers/net/ethernet/sfc/efx_common.c                                                          |    1 
 drivers/net/ethernet/sfc/rx_common.c                                                           |    1 
 drivers/net/ethernet/socionext/netsec.c                                                        |   24 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                                              |   41 
 drivers/net/ipa/ipa_endpoint.c                                                                 |    6 
 drivers/net/wan/hdlc.c                                                                         |   10 
 drivers/net/wan/hdlc_raw_eth.c                                                                 |    1 
 drivers/net/wireless/ath/ath10k/ce.c                                                           |    2 
 drivers/net/wireless/ath/ath10k/htt_rx.c                                                       |    8 
 drivers/net/wireless/ath/ath10k/mac.c                                                          |    2 
 drivers/net/wireless/ath/ath11k/ahb.c                                                          |   10 
 drivers/net/wireless/ath/ath11k/mac.c                                                          |    4 
 drivers/net/wireless/ath/ath11k/qmi.c                                                          |    1 
 drivers/net/wireless/ath/ath11k/spectral.c                                                     |    2 
 drivers/net/wireless/ath/ath6kl/main.c                                                         |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c                                                          |    5 
 drivers/net/wireless/ath/ath9k/hif_usb.c                                                       |   19 
 drivers/net/wireless/ath/ath9k/htc_hst.c                                                       |    2 
 drivers/net/wireless/ath/wcn36xx/main.c                                                        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c                                        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c                                      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c                                 |    4 
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c                                               |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                                              |    9 
 drivers/net/wireless/marvell/mwifiex/scan.c                                                    |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c                                                    |    2 
 drivers/net/wireless/marvell/mwifiex/usb.c                                                     |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c                                            |    5 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                                                |    7 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                                               |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                                                |  176 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h                                             |    6 
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c                                                |    4 
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c                                               |    2 
 drivers/net/wireless/mediatek/mt76/mt7615/testmode.c                                           |    6 
 drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c                                            |    4 
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c                                           |    7 
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c                                                |    9 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                                                |   18 
 drivers/net/wireless/mediatek/mt76/testmode.c                                                  |    8 
 drivers/net/wireless/microchip/wilc1000/mon.c                                                  |    3 
 drivers/net/wireless/microchip/wilc1000/sdio.c                                                 |    5 
 drivers/net/wireless/microchip/wilc1000/spi.c                                                  |    5 
 drivers/net/wireless/quantenna/qtnfmac/commands.c                                              |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c                                          |   10 
 drivers/net/wireless/realtek/rtw88/main.c                                                      |    5 
 drivers/net/wireless/realtek/rtw88/pci.c                                                       |    2 
 drivers/net/wireless/realtek/rtw88/pci.h                                                       |    4 
 drivers/net/wireless/realtek/rtw88/phy.c                                                       |    5 
 drivers/ntb/hw/amd/ntb_hw_amd.c                                                                |    1 
 drivers/ntb/hw/intel/ntb_hw_gen1.c                                                             |    2 
 drivers/nvme/host/zns.c                                                                        |   41 
 drivers/nvme/target/core.c                                                                     |    3 
 drivers/nvme/target/passthru.c                                                                 |    9 
 drivers/nvmem/core.c                                                                           |   38 
 drivers/opp/core.c                                                                             |    6 
 drivers/pci/controller/dwc/pcie-designware-ep.c                                                |    3 
 drivers/pci/controller/pci-aardvark.c                                                          |   13 
 drivers/pci/controller/pci-hyperv.c                                                            |   50 +
 drivers/pci/controller/pcie-iproc-msi.c                                                        |   13 
 drivers/pci/iov.c                                                                              |    1 
 drivers/perf/thunderx2_pmu.c                                                                   |    7 
 drivers/perf/xgene_pmu.c                                                                       |   32 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                                                        |    2 
 drivers/pinctrl/bcm/Kconfig                                                                    |    1 
 drivers/pinctrl/devicetree.c                                                                   |    5 
 drivers/pinctrl/intel/pinctrl-tigerlake.c                                                      |   42 
 drivers/pinctrl/pinctrl-mcp23s08.c                                                             |   24 
 drivers/pinctrl/pinctrl-single.c                                                               |    4 
 drivers/pinctrl/qcom/pinctrl-msm.c                                                             |   10 
 drivers/platform/chrome/cros_ec_lightbar.c                                                     |    2 
 drivers/platform/chrome/cros_ec_typec.c                                                        |    3 
 drivers/platform/x86/mlx-platform.c                                                            |   15 
 drivers/pwm/pwm-img.c                                                                          |    3 
 drivers/pwm/pwm-lpss.c                                                                         |    7 
 drivers/pwm/pwm-rockchip.c                                                                     |    5 
 drivers/rapidio/devices/rio_mport_cdev.c                                                       |   18 
 drivers/ras/cec.c                                                                              |    9 
 drivers/regulator/core.c                                                                       |   21 
 drivers/regulator/qcom_usb_vbus-regulator.c                                                    |    1 
 drivers/remoteproc/mtk_scp_ipi.c                                                               |    4 
 drivers/remoteproc/stm32_rproc.c                                                               |    2 
 drivers/rpmsg/mtk_rpmsg.c                                                                      |    9 
 drivers/rpmsg/qcom_smd.c                                                                       |   32 
 drivers/rtc/rtc-ds1307.c                                                                       |    4 
 drivers/s390/net/qeth_core.h                                                                   |    6 
 drivers/s390/net/qeth_l2_main.c                                                                |   59 -
 drivers/s390/net/qeth_l2_sys.c                                                                 |    1 
 drivers/scsi/be2iscsi/be_main.c                                                                |    4 
 drivers/scsi/bfa/bfad.c                                                                        |    1 
 drivers/scsi/csiostor/csio_hw.c                                                                |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                                                                 |    1 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                                            |   14 
 drivers/scsi/mvumi.c                                                                           |    1 
 drivers/scsi/qedf/qedf_main.c                                                                  |    2 
 drivers/scsi/qedi/qedi_fw.c                                                                    |   23 
 drivers/scsi/qedi/qedi_iscsi.c                                                                 |    2 
 drivers/scsi/qedi/qedi_main.c                                                                  |   10 
 drivers/scsi/qla2xxx/qla_init.c                                                                |   10 
 drivers/scsi/qla2xxx/qla_inline.h                                                              |    5 
 drivers/scsi/qla2xxx/qla_mbx.c                                                                 |    2 
 drivers/scsi/qla2xxx/qla_nvme.c                                                                |    2 
 drivers/scsi/qla2xxx/qla_target.c                                                              |    2 
 drivers/scsi/qla4xxx/ql4_os.c                                                                  |    2 
 drivers/scsi/smartpqi/smartpqi.h                                                               |    2 
 drivers/scsi/smartpqi/smartpqi_init.c                                                          |  101 +-
 drivers/scsi/ufs/ufs-mediatek.c                                                                |   11 
 drivers/scsi/ufs/ufs-qcom.c                                                                    |    5 
 drivers/scsi/ufs/ufshcd.c                                                                      |    3 
 drivers/slimbus/core.c                                                                         |    6 
 drivers/slimbus/qcom-ngd-ctrl.c                                                                |    4 
 drivers/soc/fsl/qbman/bman.c                                                                   |    2 
 drivers/soc/mediatek/mtk-cmdq-helper.c                                                         |    5 
 drivers/soc/qcom/apr.c                                                                         |    2 
 drivers/soc/qcom/pdr_internal.h                                                                |    2 
 drivers/soc/xilinx/zynqmp_power.c                                                              |    2 
 drivers/soundwire/cadence_master.c                                                             |   24 
 drivers/soundwire/cadence_master.h                                                             |    5 
 drivers/soundwire/intel.c                                                                      |   73 +
 drivers/soundwire/stream.c                                                                     |    2 
 drivers/spi/spi-dw-pci.c                                                                       |   16 
 drivers/spi/spi-fsi.c                                                                          |   99 +-
 drivers/spi/spi-imx.c                                                                          |    5 
 drivers/spi/spi-omap2-mcspi.c                                                                  |   17 
 drivers/spi/spi-s3c64xx.c                                                                      |   52 -
 drivers/staging/emxx_udc/emxx_udc.c                                                            |    4 
 drivers/staging/media/atomisp/pci/sh_css.c                                                     |    2 
 drivers/staging/media/hantro/hantro_h264.c                                                     |    2 
 drivers/staging/media/hantro/hantro_postproc.c                                                 |    4 
 drivers/staging/media/ipu3/ipu3-css-params.c                                                   |    2 
 drivers/staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c                            |    1 
 drivers/staging/qlge/qlge.h                                                                    |   20 
 drivers/staging/qlge/qlge_dbg.c                                                                |   28 
 drivers/staging/qlge/qlge_main.c                                                               |    8 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                                              |    2 
 drivers/staging/rtl8712/rtl8712_recv.c                                                         |    9 
 drivers/staging/wfx/data_rx.c                                                                  |    5 
 drivers/staging/wfx/sta.c                                                                      |   19 
 drivers/target/target_core_user.c                                                              |    2 
 drivers/thermal/thermal_netlink.c                                                              |    3 
 drivers/tty/hvc/Kconfig                                                                        |    1 
 drivers/tty/hvc/hvcs.c                                                                         |   14 
 drivers/tty/ipwireless/network.c                                                               |    4 
 drivers/tty/ipwireless/tty.c                                                                   |    2 
 drivers/tty/pty.c                                                                              |    2 
 drivers/tty/serial/8250/8250_dw.c                                                              |   54 -
 drivers/tty/serial/8250/8250_port.c                                                            |    5 
 drivers/tty/serial/Kconfig                                                                     |    2 
 drivers/tty/serial/fsl_lpuart.c                                                                |   16 
 drivers/usb/cdns3/gadget.c                                                                     |    2 
 drivers/usb/class/cdc-acm.c                                                                    |   23 
 drivers/usb/class/cdc-wdm.c                                                                    |   72 +
 drivers/usb/core/urb.c                                                                         |   89 +
 drivers/usb/dwc2/gadget.c                                                                      |   40 
 drivers/usb/dwc2/params.c                                                                      |    2 
 drivers/usb/dwc2/platform.c                                                                    |    6 
 drivers/usb/dwc3/core.c                                                                        |   60 -
 drivers/usb/dwc3/core.h                                                                        |    7 
 drivers/usb/dwc3/dwc3-of-simple.c                                                              |    1 
 drivers/usb/gadget/function/f_ncm.c                                                            |    8 
 drivers/usb/gadget/function/f_printer.c                                                        |   16 
 drivers/usb/gadget/function/u_ether.c                                                          |    2 
 drivers/usb/gadget/function/u_serial.c                                                         |    1 
 drivers/usb/gadget/udc/bcm63xx_udc.c                                                           |    1 
 drivers/usb/host/ohci-hcd.c                                                                    |   16 
 drivers/usb/host/xhci.c                                                                        |    3 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                                              |   12 
 drivers/vfio/pci/vfio_pci_config.c                                                             |   24 
 drivers/vfio/pci/vfio_pci_intrs.c                                                              |    4 
 drivers/vfio/vfio.c                                                                            |    9 
 drivers/vfio/vfio_iommu_type1.c                                                                |    6 
 drivers/video/backlight/sky81452-backlight.c                                                   |    1 
 drivers/video/fbdev/aty/radeon_base.c                                                          |    2 
 drivers/video/fbdev/core/fbmem.c                                                               |    4 
 drivers/video/fbdev/sis/init.c                                                                 |   11 
 drivers/video/fbdev/vga16fb.c                                                                  |   14 
 drivers/virt/fsl_hypervisor.c                                                                  |   17 
 drivers/watchdog/sp5100_tco.h                                                                  |    2 
 drivers/watchdog/watchdog_dev.c                                                                |    6 
 fs/afs/cell.c                                                                                  |  283 +++---
 fs/afs/dynroot.c                                                                               |   23 
 fs/afs/internal.h                                                                              |   15 
 fs/afs/main.c                                                                                  |    2 
 fs/afs/mntpt.c                                                                                 |    4 
 fs/afs/proc.c                                                                                  |   23 
 fs/afs/super.c                                                                                 |   16 
 fs/afs/vl_alias.c                                                                              |    8 
 fs/afs/vl_rotate.c                                                                             |    2 
 fs/afs/volume.c                                                                                |    4 
 fs/btrfs/extent-io-tree.h                                                                      |    1 
 fs/btrfs/volumes.c                                                                             |    7 
 fs/cifs/asn1.c                                                                                 |   16 
 fs/cifs/cifsacl.c                                                                              |    5 
 fs/cifs/cifsproto.h                                                                            |    2 
 fs/cifs/connect.c                                                                              |    5 
 fs/cifs/readdir.c                                                                              |    5 
 fs/cifs/smb2ops.c                                                                              |   21 
 fs/crypto/policy.c                                                                             |    9 
 fs/d_path.c                                                                                    |    6 
 fs/dlm/config.c                                                                                |    3 
 fs/ext4/ext4.h                                                                                 |    2 
 fs/ext4/fsmap.c                                                                                |    3 
 fs/ext4/mballoc.c                                                                              |   37 
 fs/f2fs/inode.c                                                                                |    7 
 fs/f2fs/sysfs.c                                                                                |    1 
 fs/iomap/buffered-io.c                                                                         |   25 
 fs/iomap/direct-io.c                                                                           |   10 
 fs/nfs/fs_context.c                                                                            |    1 
 fs/nfs/nfs4file.c                                                                              |   38 
 fs/nfs/nfs4super.c                                                                             |    5 
 fs/nfs/super.c                                                                                 |   17 
 fs/nfs_common/Makefile                                                                         |    1 
 fs/nfs_common/nfs_ssc.c                                                                        |   94 ++
 fs/nfsd/Kconfig                                                                                |    2 
 fs/nfsd/filecache.c                                                                            |    2 
 fs/nfsd/nfs4proc.c                                                                             |    3 
 fs/ntfs/inode.c                                                                                |    6 
 fs/proc/base.c                                                                                 |    3 
 fs/quota/quota_v2.c                                                                            |    1 
 fs/ramfs/file-nommu.c                                                                          |    2 
 fs/reiserfs/inode.c                                                                            |    3 
 fs/reiserfs/super.c                                                                            |    8 
 fs/udf/inode.c                                                                                 |   25 
 fs/udf/super.c                                                                                 |    6 
 fs/xfs/libxfs/xfs_rtbitmap.c                                                                   |   11 
 fs/xfs/xfs_buf_item_recover.c                                                                  |    2 
 fs/xfs/xfs_file.c                                                                              |   17 
 fs/xfs/xfs_fsmap.c                                                                             |   48 -
 fs/xfs/xfs_fsmap.h                                                                             |    6 
 fs/xfs/xfs_ioctl.c                                                                             |  144 ++-
 fs/xfs/xfs_rtalloc.c                                                                           |   11 
 include/dt-bindings/mux/mux-j721e-wiz.h                                                        |   53 -
 include/dt-bindings/mux/ti-serdes.h                                                            |   71 +
 include/linux/bpf_verifier.h                                                                   |    1 
 include/linux/dma-direct.h                                                                     |    3 
 include/linux/lockdep.h                                                                        |   29 
 include/linux/lockdep_types.h                                                                  |    8 
 include/linux/mailbox/mtk-cmdq-mailbox.h                                                       |    3 
 include/linux/nfs_ssc.h                                                                        |   67 +
 include/linux/notifier.h                                                                       |   15 
 include/linux/oom.h                                                                            |    1 
 include/linux/overflow.h                                                                       |    1 
 include/linux/page_owner.h                                                                     |    6 
 include/linux/pci.h                                                                            |    1 
 include/linux/platform_data/dma-dw.h                                                           |    2 
 include/linux/prandom.h                                                                        |   36 
 include/linux/sched/coredump.h                                                                 |    1 
 include/linux/seqlock.h                                                                        |   23 
 include/linux/soc/mediatek/mtk-cmdq.h                                                          |    5 
 include/net/netfilter/nf_log.h                                                                 |    1 
 include/net/tc_act/tc_tunnel_key.h                                                             |    5 
 include/rdma/ib_umem.h                                                                         |    9 
 include/rdma/ib_verbs.h                                                                        |   74 -
 include/scsi/scsi_common.h                                                                     |    7 
 include/sound/hda_codec.h                                                                      |    1 
 include/trace/events/target.h                                                                  |   12 
 include/uapi/linux/pci_regs.h                                                                  |    1 
 include/uapi/linux/perf_event.h                                                                |    2 
 kernel/bpf/percpu_freelist.c                                                                   |  101 ++
 kernel/bpf/percpu_freelist.h                                                                   |    1 
 kernel/bpf/verifier.c                                                                          |   45 
 kernel/cpu_pm.c                                                                                |   48 -
 kernel/debug/kdb/kdb_io.c                                                                      |    8 
 kernel/dma/mapping.c                                                                           |   11 
 kernel/events/core.c                                                                           |    7 
 kernel/fork.c                                                                                  |   21 
 kernel/locking/lockdep.c                                                                       |  131 +-
 kernel/locking/lockdep_internals.h                                                             |    7 
 kernel/module.c                                                                                |   13 
 kernel/notifier.c                                                                              |  144 +--
 kernel/power/hibernate.c                                                                       |   50 -
 kernel/power/main.c                                                                            |    8 
 kernel/power/power.h                                                                           |    3 
 kernel/power/suspend.c                                                                         |   14 
 kernel/power/user.c                                                                            |   14 
 kernel/rcu/rcutorture.c                                                                        |   13 
 kernel/rcu/refscale.c                                                                          |    8 
 kernel/rcu/tree.c                                                                              |    2 
 kernel/sched/core.c                                                                            |    2 
 kernel/sched/fair.c                                                                            |   20 
 kernel/sched/sched.h                                                                           |   13 
 kernel/time/timer.c                                                                            |    7 
 kernel/trace/trace_events_synth.c                                                              |   18 
 lib/Kconfig.debug                                                                              |    9 
 lib/Makefile                                                                                   |    1 
 lib/crc32.c                                                                                    |    2 
 lib/idr.c                                                                                      |    1 
 lib/random32.c                                                                                 |  464 ++++++----
 lib/test_free_pages.c                                                                          |   42 
 mm/filemap.c                                                                                   |    8 
 mm/huge_memory.c                                                                               |   28 
 mm/memcontrol.c                                                                                |   16 
 mm/mmap.c                                                                                      |    2 
 mm/oom_kill.c                                                                                  |    2 
 mm/page_alloc.c                                                                                |    7 
 mm/page_owner.c                                                                                |    4 
 mm/swapfile.c                                                                                  |    4 
 net/bluetooth/hci_core.c                                                                       |   11 
 net/bluetooth/hci_event.c                                                                      |   17 
 net/bluetooth/l2cap_sock.c                                                                     |    7 
 net/bluetooth/mgmt.c                                                                           |   12 
 net/bridge/netfilter/ebt_dnat.c                                                                |    2 
 net/bridge/netfilter/ebt_redirect.c                                                            |    2 
 net/bridge/netfilter/ebt_snat.c                                                                |    2 
 net/can/j1939/transport.c                                                                      |    2 
 net/core/filter.c                                                                              |    3 
 net/core/skmsg.c                                                                               |   14 
 net/core/sock.c                                                                                |   13 
 net/ipv4/icmp.c                                                                                |    7 
 net/ipv4/ip_gre.c                                                                              |   15 
 net/ipv4/netfilter/nf_log_arp.c                                                                |   19 
 net/ipv4/netfilter/nf_log_ipv4.c                                                               |    6 
 net/ipv4/nexthop.c                                                                             |    2 
 net/ipv4/route.c                                                                               |    4 
 net/ipv4/tcp_input.c                                                                           |    2 
 net/ipv6/ip6_fib.c                                                                             |    4 
 net/ipv6/netfilter/nf_log_ipv6.c                                                               |    8 
 net/mac80211/cfg.c                                                                             |    3 
 net/mac80211/sta_info.c                                                                        |    4 
 net/mptcp/Kconfig                                                                              |    4 
 net/mptcp/options.c                                                                            |   35 
 net/mptcp/protocol.c                                                                           |   17 
 net/mptcp/protocol.h                                                                           |    4 
 net/mptcp/subflow.c                                                                            |   19 
 net/netfilter/ipvs/ip_vs_ctl.c                                                                 |    7 
 net/netfilter/ipvs/ip_vs_xmit.c                                                                |    6 
 net/netfilter/nf_conntrack_proto_tcp.c                                                         |   19 
 net/netfilter/nf_dup_netdev.c                                                                  |    1 
 net/netfilter/nf_log_common.c                                                                  |   12 
 net/netfilter/nft_fwd_netdev.c                                                                 |    1 
 net/nfc/netlink.c                                                                              |    2 
 net/openvswitch/flow_table.c                                                                   |   58 -
 net/openvswitch/flow_table.h                                                                   |    8 
 net/sched/act_ct.c                                                                             |    4 
 net/sched/act_tunnel_key.c                                                                     |    2 
 net/sched/cls_api.c                                                                            |    2 
 net/smc/smc_core.c                                                                             |    2 
 net/smc/smc_llc.c                                                                              |   13 
 net/sunrpc/auth_gss/svcauth_gss.c                                                              |   27 
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                                                          |    3 
 net/tipc/bcast.c                                                                               |   10 
 net/tipc/msg.c                                                                                 |    3 
 net/tipc/name_distr.c                                                                          |   10 
 net/tipc/node.c                                                                                |    2 
 net/tls/tls_device.c                                                                           |   11 
 net/wireless/nl80211.c                                                                         |   21 
 samples/bpf/xdpsock_user.c                                                                     |   10 
 samples/mic/mpssd/mpssd.c                                                                      |    4 
 scripts/package/builddeb                                                                       |    6 
 scripts/package/mkdebian                                                                       |   19 
 security/integrity/ima/ima_crypto.c                                                            |    2 
 security/integrity/ima/ima_main.c                                                              |   10 
 security/integrity/ima/ima_policy.c                                                            |  142 ++-
 sound/core/seq/oss/seq_oss.c                                                                   |    7 
 sound/firewire/bebob/bebob_hwdep.c                                                             |    3 
 sound/pci/hda/hda_intel.c                                                                      |   14 
 sound/pci/hda/hda_jack.c                                                                       |   22 
 sound/pci/hda/patch_ca0132.c                                                                   |   24 
 sound/pci/hda/patch_hdmi.c                                                                     |   20 
 sound/pci/hda/patch_realtek.c                                                                  |   56 +
 sound/soc/codecs/Kconfig                                                                       |    1 
 sound/soc/codecs/tas2770.c                                                                     |   93 --
 sound/soc/codecs/tlv320adcx140.c                                                               |    2 
 sound/soc/codecs/tlv320aic32x4.c                                                               |    9 
 sound/soc/codecs/wm_adsp.c                                                                     |   20 
 sound/soc/fsl/fsl_sai.c                                                                        |   19 
 sound/soc/fsl/fsl_sai.h                                                                        |    1 
 sound/soc/fsl/imx-es8328.c                                                                     |   12 
 sound/soc/intel/boards/sof_rt5682.c                                                            |   13 
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c                                             |    2 
 sound/soc/qcom/lpass-cpu.c                                                                     |   16 
 sound/soc/qcom/lpass-platform.c                                                                |    3 
 sound/soc/soc-topology.c                                                                       |   11 
 sound/soc/sof/control.c                                                                        |   11 
 sound/soc/sof/intel/hda.c                                                                      |    8 
 sound/soc/sof/sof-pci-dev.c                                                                    |   24 
 sound/usb/format.c                                                                             |    1 
 tools/build/Makefile.feature                                                                   |    5 
 tools/build/feature/Makefile                                                                   |    2 
 tools/build/feature/test-all.c                                                                 |   10 
 tools/lib/bpf/libbpf.c                                                                         |   57 -
 tools/lib/perf/evlist.c                                                                        |    3 
 tools/perf/Makefile.config                                                                     |    4 
 tools/perf/Makefile.perf                                                                       |    6 
 tools/perf/builtin-stat.c                                                                      |    4 
 tools/perf/builtin-trace.c                                                                     |    6 
 tools/perf/builtin-version.c                                                                   |    1 
 tools/perf/util/intel-pt.c                                                                     |    8 
 tools/perf/util/metricgroup.c                                                                  |   75 +
 tools/power/pm-graph/sleepgraph.py                                                             |    2 
 tools/testing/radix-tree/idr-test.c                                                            |   29 
 tools/testing/selftests/bpf/bench.c                                                            |    3 
 tools/testing/selftests/bpf/benchs/bench_rename.c                                              |   17 
 tools/testing/selftests/bpf/prog_tests/sk_assign.c                                             |    2 
 tools/testing/selftests/bpf/prog_tests/sockopt_sk.c                                            |    4 
 tools/testing/selftests/bpf/prog_tests/test_overhead.c                                         |   14 
 tools/testing/selftests/bpf/progs/test_overhead.c                                              |    6 
 tools/testing/selftests/bpf/progs/test_sk_lookup.c                                             |  216 ++--
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c                                          |    4 
 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c                                          |    4 
 tools/testing/selftests/bpf/progs/test_vmlinux.c                                               |   12 
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc |    8 
 tools/testing/selftests/livepatch/functions.sh                                                 |    2 
 tools/testing/selftests/lkdtm/run.sh                                                           |    2 
 tools/testing/selftests/net/config                                                             |    1 
 tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh                                     |   10 
 tools/testing/selftests/net/forwarding/vxlan_symmetric.sh                                      |   10 
 tools/testing/selftests/net/mptcp/mptcp_connect.sh                                             |    4 
 tools/testing/selftests/net/mptcp/mptcp_join.sh                                                |    4 
 tools/testing/selftests/net/rtnetlink.sh                                                       |    5 
 tools/testing/selftests/powerpc/alignment/alignment_handler.c                                  |   10 
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh                                               |    9 
 tools/testing/selftests/seccomp/seccomp_bpf.c                                                  |  114 +-
 tools/testing/selftests/vm/config                                                              |    1 
 813 files changed, 7963 insertions(+), 4272 deletions(-)

Aashish Verma (1):
      net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Abel Vesa (1):
      clk: imx8mq: Fix usdhc parents order

Abhishek Pandit-Subedi (3):
      Bluetooth: Clear suspend tasks on unregister
      Bluetooth: Re-order clearing suspend tasks
      Bluetooth: Only mark socket zapped after unlocking

Adam Brickman (1):
      ASoC: wm_adsp: Pass full name to snd_ctl_notify

Adam Goode (1):
      media: uvcvideo: Ensure all probed info is returned to v4l2

Aditya Pakki (1):
      media: st-delta: Fix reference count leak in delta_run_work

Adrian Hunter (1):
      perf intel-pt: Fix "context_switch event has no tid" error

Al Grant (1):
      perf: correct SNOOPX field offset

Alex Dewar (2):
      staging: emxx_udc: Fix passing of NULL to dma_alloc_coherent()
      VMCI: check return value of get_user_pages_fast() for errors

Alex Elder (1):
      net: ipa: skip suspend/resume activities if not set up

Alex Gartrell (1):
      libbpf: Fix unintentional success return code in bpf_object__load

Alex Williamson (1):
      vfio/pci: Clear token on bypass registration failure

Alexander Antonov (1):
      perf/x86/intel/uncore: Fix for iio mapping on Skylake Server

Alexander Aring (1):
      fs: dlm: fix configfs memory leak

Alexandru Elisei (1):
      arm64: perf: Add missing ISB in armv8pmu_enable_counter()

Alexei Starovoitov (1):
      mm/error_inject: Fix allow_error_inject function signatures.

Alvin Lee (1):
      drm/amd/display: Disconnect pipe separetely when disable pipe split

Amit Daniel Kachhap (1):
      arm64: kprobe: add checks for ARMv8.3-PAuth combined instructions

Amit Singh Tomar (1):
      arm64: dts: actions: limit address range for pinctrl node

Anatoly Pugachev (1):
      selftests: vm: add fragment CONFIG_GUP_BENCHMARK

Andreas Färber (2):
      rtw88: Fix probe error handling race with firmware loading
      rtw88: Fix potential probe error handling race with wow firmware loading

Andrei Botila (7):
      crypto: caam - add xts check for block length equal to zero
      crypto: caam/qi - add fallback for XTS with more than 8B IV
      crypto: caam/qi - add support for more XTS key lengths
      crypto: caam/jr - add fallback for XTS with more than 8B IV
      crypto: caam/jr - add support for more XTS key lengths
      crypto: caam/qi2 - add fallback for XTS with more than 8B IV
      crypto: caam/qi2 - add support for more XTS key lengths

Andrew Jeffery (1):
      pinctrl: aspeed: Use the right pinconf mask

Andrii Nakryiko (2):
      selftests/bpf: Fix test_vmlinux test to use bpf_probe_read_user()
      fs: fix NULL dereference due to data race in prepend_path()

Andy Shevchenko (2):
      dmaengine: dmatest: Check list for emptiness before access its last entry
      pinctrl: tigerlake: Fix register offsets for TGL-H variant

Aneesh Kumar K.V (2):
      powerpc/book3s64/hash/4k: Support large linear mapping range with 4K
      powerpc/book3s64/radix: Make radix_mem_block_size 64bit

Ard Biesheuvel (2):
      netsec: ignore 'phy-mode' device property on ACPI systems
      arm64: mm: use single quantity to represent the PA to VA translation

Arnaldo Carvalho de Melo (2):
      perf tools: Make GTK2 support opt-in
      tools feature: Add missing -lzstd to the fast path feature detection

Arnd Bergmann (2):
      mtd: lpddr: fix excessive stack usage with clang
      ARM: s3c24xx: fix mmc gpio lookup tables

Artem Savkov (1):
      pty: do tty_flip_buffer_push without port->lock in pty_write

Arvind Sankar (2):
      x86/fpu: Allow multiple bits in clearcpuid= parameter
      x86/asm: Replace __force_order with a memory clobber

Aswath Govindraju (1):
      spi: omap2-mcspi: Improve performance waiting for CHSTAT

Athira Rajeev (1):
      powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Azhar Shaikh (1):
      platform/chrome: cros_ec_typec: Send enum values to usb_role_switch_set_role()

Bard Liao (1):
      soundwire: intel: reinitialize IP+DSP in .prepare(), but only when resuming

Barry Song (1):
      sched/fair: Use dst group while checking imbalance for NUMA balancer

Bartosz Golaszewski (1):
      net: ethernet: mtk-star-emac: select REGMAP_MMIO

Biju Das (1):
      ARM: dts: iwg20d-q7-common: Fix touch controller probe failure

Bo YU (1):
      ath11k: Add checked value for ath11k_ahb_remove

Bob Pearson (2):
      RDMA/rxe: Fix skb lifetime in rxe_rcv_mcast_pkt()
      RDMA/rxe: Handle skb_clone() failure in rxe_recv.c

Borislav Petkov (3):
      x86/mce: Add Skylake quirk for patrol scrub reported errors
      x86/mce: Annotate mce_rd/wrmsrl() with noinstr
      x86/mce: Make mce_rdmsrl() panic on an inaccessible MSR

Brad Bishop (3):
      spi: fsi: Handle 9 to 15 byte transfers lengths
      spi: fsi: Fix use of the bneq+ sequencer instruction
      spi: fsi: Fix clock running too fast

Brian Norris (1):
      rtw88: don't treat NULL pointer as an array

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Bryan O'Donoghue (1):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Camel Guo (1):
      ASoC: tlv320adcx140: Fix digital gain range

Can Guo (1):
      scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Charles Keepax (1):
      regmap: debugfs: Fix more error path regressions

Chris Chiu (1):
      rtl8xxxu: prevent potential memory leak

Chris Packham (1):
      rtc: ds1307: Clear OSF flag on DS1388 when setting time

Christian Eggers (4):
      net: dsa: microchip: fix race condition
      socket: fix option SO_TIMESTAMPING_NEW
      socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
      eeprom: at25: set minimum read/write access stride to 1

Christian Hewitt (1):
      drm/panfrost: increase readl_relaxed_poll_timeout values

Christian König (1):
      drm/amdgpu: fix max_entries calculation v4

Christoph Hellwig (2):
      nvme: fix error handling in nvme_ns_report_zones
      PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Christophe JAILLET (7):
      crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call
      media: staging/intel-ipu3: css: Correctly reset some memory
      ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
      mwifiex: Do not use GFP_KERNEL in atomic context
      staging: rtl8192u: Do not use GFP_KERNEL in atomic context
      scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'
      scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call

Christophe Kerello (1):
      mtd: rawnand: stm32_fmc2: fix a buffer overflow

Christophe Leroy (1):
      powerpc/kasan: Fix CONFIG_KASAN_VMALLOC for 8xx

Chunfeng Yun (1):
      usb: gadget: bcm63xx_udc: fix up the error of undeclared usb_debug_root

Claudiu Beznea (3):
      clk: at91: clk-main: update key before writing AT91_CKGR_MOR
      clk: at91: sam9x60: support only two programmable clocks
      ARM: at91: pm: of_node_put() after its usage

Coiby Xu (1):
      staging: qlge: fix build breakage with dumping enabled

Colin Ian King (9):
      x86/events/amd/iommu: Fix sizeof mismatch
      media: i2c: fix error check on max9286_read call
      drm/amd/display: fix potential integer overflow when shifting 32 bit variable bl_pwm
      video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error
      qtnfmac: fix resource leaks on unsupported iftype error return path
      refperf: Avoid null pointer dereference when buf fails to allocate
      IB/rdmavt: Fix sizeof mismatch
      remoteproc/mediatek: fix null pointer dereference on null scp pointer
      lightnvm: fix out-of-bounds write to array devices->info[]

Cong Wang (3):
      tipc: fix the skb_unshare() in tipc_buf_append()
      can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt
      ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Connor McAdams (2):
      ALSA: hda/ca0132 - Add AE-7 microphone selection commands.
      ALSA: hda/ca0132 - Add new quirk ID for SoundBlaster AE-7.

Corentin Labbe (2):
      crypto: sun8i-ce - handle endianness of t_common_ctl
      dt-bindings: crypto: Specify that allwinner, sun8i-a33-crypto needs reset

Cristian Ciocaltea (1):
      ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Dafna Hirschfeld (2):
      media: mtk-mdp: Fix Null pointer dereference when calling list_add
      arm64: dts: mt8173-elm: fix supported values for regulator-allowed-modes of da9211

Dai Ngo (1):
      NFSv4.2: Fix NFS4ERR_STALE error when doing inter server copy

Dan Aloni (1):
      svcrdma: fix bounce buffers for unaligned offsets and multiple pages

Dan Carpenter (16):
      ALSA: bebob: potential info leak in hwdep_read()
      cifs: remove bogus debug code
      crypto: sa2ul - Fix pm_runtime_get_sync() error checking
      hwmon: (w83627ehf) Fix a resource leak in probe
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      HID: roccat: add bounds checking in kone_sysfs_write_settings()
      ath11k: fix uninitialized return in ath11k_spectral_process_data()
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()
      mfd: sm501: Fix leaks in probe()
      staging: rtl8712: Fix enqueue_reorder_recvframe()
      scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
      rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()
      Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()
      soc: xilinx: Fix error code in zynqmp_pm_probe()
      memory: omap-gpmc: Fix a couple off by ones

Dan Murphy (5):
      ASoC: tas2770: Fix calling reset in probe
      ASoC: tas2770: Add missing bias level power states
      ASoC: tas2770: Fix required DT properties in the code
      ASoC: tas2770: Fix error handling with update_bits
      ASoC: tas2770: Fix unbalanced calls to pm_runtime

Daniel Axtens (1):
      powerpc: PPC_SECURE_BOOT should not require PowerNV

Daniel Jordan (1):
      module: statically initialize init section freeing data

Daniel Thompson (1):
      kdb: Fix pager search for multi-line strings

Daniel Vetter (1):
      drm/xlnx: Use devm_drm_dev_alloc

Daniel Wagner (1):
      scsi: qla2xxx: Warn if done() or free() are called on an already freed srb

Darrick J. Wong (6):
      xfs: force the log after remapping a synchronous-writes file
      xfs: limit entries returned when counting fsmap records
      xfs: fix deadlock and streamline xfs_getfsmap performance
      xfs: fix high key handling in the rt allocator's query_range function
      ext4: limit entries returned when counting fsmap records
      xfs: make sure the rt allocator doesn't run off the end

Dave Chinner (1):
      xfs: fix finobt btree block recovery ordering

David Ahern (1):
      ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Howells (4):
      afs: Fix rapid cell addition/removal by not using RCU on cells tree
      afs: Fix cell refcounting by splitting the usage counter
      afs: Fix cell purging with aliases
      afs: Fix cell removal

David Wilder (2):
      ibmveth: Switch order of ibmveth_helper calls.
      ibmveth: Identify ingress large send packets.

Davide Caratti (2):
      net: mptcp: make DACK4/DACK8 usage consistent among all subflows
      net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels

Defang Bo (1):
      nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Denis Efremov (1):
      net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()

Dennis YC Hsieh (2):
      soc: mediatek: cmdq: add clear option in cmdq_pkt_wfe api
      drm/mediatek: reduce clear event

Dexuan Cui (1):
      PCI: hv: Fix hibernation in case interrupts are not re-created

Dinghao Liu (17):
      EDAC/i5100: Fix error handling order in i5100_init_one()
      media: omap3isp: Fix memleak in isp_probe
      media: mx2_emmaprp: Fix memleak in emmaprp_probe
      wilc1000: Fix memleak in wilc_sdio_probe
      wilc1000: Fix memleak in wilc_bus_probe
      drm/crc-debugfs: Fix memleak in crc_control_write
      video: fbdev: radeon: Fix memleak in radeonfb_pci_register
      watchdog: Fix memleak in watchdog_cdev_register
      watchdog: Use put_device on error
      ntb: intel: Fix memleak in intel_ntb_pci_probe
      media: vsp1: Fix runtime PM imbalance on error
      media: platform: s3c-camif: Fix runtime PM imbalance on error
      media: platform: sti: hva: Fix runtime PM imbalance on error
      media: bdisp: Fix runtime PM imbalance on error
      media: atomisp: fix memleak in ia_css_stream_create
      media: venus: core: Fix runtime PM imbalance in venus_probe
      Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb

Dirk Behme (1):
      i2c: rcar: Auto select RESET_CONTROLLER

Dmitry Torokhov (1):
      HID: hid-input: fix stylus battery reporting

Doug Horn (1):
      Fix use after free in get_capset_info callback.

Drew Fustini (2):
      pinctrl: single: fix pinctrl_spec.args_count bounds check
      pinctrl: single: fix debug output when #pinctrl-cells = 2

Dylan Hung (1):
      net: ftgmac100: Fix Aspeed ast2600 TX hang issue

Eddie James (1):
      spi: fsi: Implement restricted size for certain controllers

Edward Cree (2):
      sfc: move initialisation of efx->filter_sem to efx_init_struct()
      sfc: don't double-down() filters in ef100_reset()

Eelco Chaudron (1):
      net: openvswitch: fix to make sure flow_lookup() is not preempted

Eli Billauer (1):
      usb: core: Solve race condition in anchor cleanup functions

Eli Cohen (3):
      vdpa/mlx5: Make use of a specific 16 bit endianness API
      vdpa/mlx5: Fix failure to bring link up
      vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK

Emmanuel Grumbach (1):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC

Eran Ben Elisha (1):
      net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Eric Biggers (4):
      fscrypt: restrict IV_INO_LBLK_32 to ino_bits <= 32
      scsi: ufs: Make ufshcd_print_trs() consider UFSHCD_QUIRK_PRDT_BYTE_GRAN
      f2fs: reject CASEFOLD inode flag without casefold feature
      reiserfs: only call unlock_new_inode() if I_NEW

Eric Dumazet (2):
      icmp: randomize the global rate limiter
      quota: clear padding in v2r1_mem2diskdqb()

Evgeny Novikov (1):
      mtd: rawnand: vf610: disable clk on error handling path in probe

Ezequiel Garcia (2):
      media: hantro: h264: Get the correct fallback reference buffer
      media: hantro: postproc: Fix motion vector space allocation

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix runtime autosuspend delay when slow polling

Felix Fietkau (1):
      mt76: mt7915: do not do any work in napi poll after calling napi_complete_done()

Finn Thain (5):
      powerpc/tau: Use appropriate temperature sample interval
      powerpc/tau: Convert from timer to workqueue
      powerpc/tau: Remove duplicated set_thresholds() call
      powerpc/tau: Check processor type before enabling TAU interrupt
      powerpc/tau: Disable TAU between measurements

Florian Fainelli (1):
      mtd: parsers: bcm63xx: Do not make it modular

Francesco Ruggeri (1):
      netfilter: conntrack: connection timeout after re-register

Ganesh Goudar (1):
      powerpc/pseries: Avoid using addr_to_pfn in real mode

Geert Uytterhoeven (3):
      mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead of selecting it
      arm64: dts: renesas: r8a77990: Fix MSIOF1 DMA channels
      arm64: dts: renesas: r8a774c0: Fix MSIOF1 DMA channels

Geliang Tang (1):
      mptcp: initialize mptcp_options_received's ahmac

George Kennedy (1):
      fbmem: add margin check to fb_check_caps()

George Spelvin (1):
      random32: make prandom_u32() output unpredictable

Greg Kroah-Hartman (1):
      Linux 5.9.2

Greg Ungerer (1):
      m68knommu: include SDHC support only when hardware has it

Grygorii Strashko (1):
      dmaengine: ti: k3-udma-glue: fix channel enable functions

Guenter Roeck (2):
      hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}
      watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3

Guillaume Nault (1):
      net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()

Guillaume Tucker (1):
      ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Gwendal Grignou (1):
      platform/chrome: cros_ec_lightbar: Reduce ligthbar get version command

Hamish Martin (1):
      usb: ohci: Default to per-port over-current protection

Hangbin Liu (1):
      libbpf: Close map fd if init map slots failed

Hanks Chen (1):
      clk: mediatek: add UART0 clock support

Hans de Goede (4):
      pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()
      pwm: lpss: Add range limit check for the base_unit register value
      i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs
      HID: ite: Add USB id match for Acer One S1003 keyboard dock

Hauke Mehrtens (3):
      mtd: spinand: gigadevice: Only one dummy byte in QUADIO
      mtd: spinand: gigadevice: Add QE Bit
      pwm: img: Fix null pointer access in probe

Heiner Kallweit (1):
      r8169: fix operation under forced interrupt threading

Herat Ramani (1):
      cxgb4: handle 4-tuple PEDIT to NAT mode translation

Herbert Xu (3):
      crypto: algif_aead - Do not set MAY_BACKLOG on the async path
      crypto: algif_skcipher - EBUSY on aio should be an error
      crypto: sa2ul - Select CRYPTO_AUTHENC

Hoang Huu Le (3):
      tipc: fix NULL pointer dereference in tipc_named_rcv
      tipc: re-configure queue limit for broadcast link
      tipc: fix incorrect setting window for bcast link

Holger Assmann (1):
      ARM: dts: stm32: lxa-mc1: Fix kernel warning about PHY delays

Horia Geantă (1):
      ARM: dts: imx6sl: fix rng node

Hou Zhiqiang (1):
      PCI: designware-ep: Fix the Header Type check

Hsin-Yi Wang (1):
      arm64: dts: mt8173: elm: Fix nor_flash node property

Huang Guobin (1):
      net: wilc1000: clean up resource in error path of init mon interface

Huang Ying (1):
      mm: fix a race during THP splitting

Hui Wang (3):
      ALSA: hda - Don't register a cb func if it is registered already
      ALSA: hda - Fix the return value if cb func is already registered
      ALSA: hda/realtek - set mic to auto detect on a HP AIO machine

Håkon Bugge (2):
      IB/mlx4: Fix starvation in paravirt mux/demux
      IB/mlx4: Adjust delayed work when a dup is observed

Ian Rogers (1):
      perf metricgroup: Fix uncore metric expressions

Ido Schimmel (2):
      nexthop: Fix performance regression in nexthop deletion
      selftests: forwarding: Add missing 'rp_filter' configuration

Ilya Leoshkevich (4):
      s390/bpf: Fix multiple tail calls
      selftests/bpf: Fix endianness issue in sk_assign
      selftests/bpf: Fix endianness issue in test_sockopt_sk
      selftests/bpf: Fix endianness issues in sk_lookup/ctx_narrow_access

J. Bruce Fields (1):
      nfsd: Cache R, RW, and W opens separately

Jakub Kicinski (1):
      ixgbe: fix probing of multi-port devices with one MDIO

Jamie Iles (1):
      f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Jan Kara (4):
      ext4: discard preallocations before releasing group lock
      udf: Limit sparing table size
      udf: Avoid accessing uninitialized data on failed inode read
      reiserfs: Fix memory leak in reiserfs_parse_options()

Jann Horn (1):
      binder: Remove bogus warning on failed same-process transaction

Janusz Krzysztofik (1):
      mtd: rawnand: ams-delta: Fix non-OF build warning

Jason Gunthorpe (12):
      RDMA/ucma: Fix locking for ctx->events_reported
      RDMA/ucma: Add missing locking around rdma_leave_multicast()
      RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()
      RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page boundary
      RDMA/umem: Prevent small pages from being returned by ib_umem_find_best_pgsz()
      RDMA/cma: Combine cma_ndev_work with cma_work
      RDMA/cma: Remove dead code for kernel rdmacm multicast
      RDMA/cma: Consolidate the destruction of a cma_multicast in one place
      RDMA/cma: Fix use after free race in roce multicast join
      RDMA/mlx5: Use set_mkc_access_pd_addr_fields() in reg_create()
      RDMA/mlx5: Make mkeys always owned by the kernel's PD when not enabled
      RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR can't work

Jassi Brar (1):
      mailbox: avoid timer start from callback

Jay Fang (1):
      spi: dw-pci: free previously allocated IRQs if desc->setup() fails

Jeremy Szu (1):
      ALSA: hda/realtek - The front Mic on a HP machine doesn't work

Jernej Skrabec (1):
      ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator

Jerome Brunet (2):
      clk: meson: axg-audio: separate axg and g12a regmap tables
      arm64: dts: meson: vim3: correct led polarity

Jia Yang (1):
      drm: fix double free for gbo in drm_gem_vram_init and drm_gem_vram_create

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887

Jiaran Zhang (2):
      RDMA/hns: Add check for the validity of sl configuration
      RDMA/hns: Solve the overflow of the calc_pg_sz()

Jin Yao (1):
      perf stat: Skip duration_time in setup_system_wide

Jing Xiangfeng (6):
      i3c: master: Fix error return in cdns_i3c_master_probe()
      thermal: core: Adding missing nlmsg_free() in thermal_genl_sampling_temp()
      rapidio: fix the missed put_device() for rio_mport_add_riodev
      scsi: bfa: Fix error return in bfad_pci_init()
      scsi: mvumi: Fix error return in mvumi_io_attach()
      scsi: ibmvfc: Fix error return in ibmvfc_probe()

Jiri Olsa (1):
      perf/core: Fix race in the perf_mmap_close() function

Jiri Slaby (1):
      perf trace: Fix off by ones in memset() after realloc() in arches using libaudit

Joakim Zhang (1):
      can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Johan Hovold (1):
      USB: cdc-acm: handle broken union descriptors

Johannes Berg (2):
      nl80211: fix non-split wiphy information
      um: time-travel: Fix IRQ handling in time_travel_handle_message()

John Donnelly (1):
      scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

John Fastabend (1):
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup

Johnny Chuang (1):
      Input: elants_i2c - fix typo for an attribute to show calibration count

Jonathan Lemon (1):
      mlx4: handle non-napi callers to napi_poll

Jonathan Marek (2):
      regulator: set of_node for qcom vbus regulator
      arm64: dts: qcom: sm8150: fix up primary USB nodes

Jonathan Zhou (2):
      coresight: etm4x: Fix issues within reset interface of sysfs
      coresight: etm4x: Fix issues on trcseqevr access

Jordan Crouse (1):
      drm/msm: Fix the a650 hw_apriv check

Jordan Niethe (2):
      selftests/powerpc: Fix prefixes in alignment_handler signal handler
      powerpc/64s: Remove TM from Power10 features

Julian Anastasov (1):
      ipvs: clear skb->tstamp in forwarding path

Julian Wiedmann (2):
      s390/qeth: strictly order bridge address events
      s390/qeth: don't let HW override the configured port role

Juri Lelli (1):
      sched/features: Fix !CONFIG_JUMP_LABEL case

Jérôme Pouiller (3):
      staging: wfx: fix frame reordering
      staging: wfx: fix BA sessions for older firmwares
      staging: wfx: fix handling of MMIC error

KP Singh (1):
      ima: Fix NULL pointer dereference in ima_file_hash

Kai Vehmanen (2):
      ALSA: hda: fix jack detection with Realtek codecs when in D3
      ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

Kai-Heng Feng (1):
      rtw88: pci: Power cycle device during shutdown

Kaige Li (1):
      NTB: hw: amd: fix an issue about leak system resources

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix starting index value

Kamal Heib (1):
      RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces

Kan Liang (4):
      perf/x86/intel/ds: Fix x86_pmu_stop warning for large PEBS
      perf/x86/intel/uncore: Update Ice Lake uncore units
      perf/x86/intel/uncore: Reduce the number of CBOX counters
      perf/x86/intel/uncore: Fix the scale of the IMC free-running events

Karsten Graul (2):
      net/smc: fix use-after-free of delayed events
      net/smc: fix valid DMBE buffer sizes

Ke Li (1):
      net: Properly typecast int values to set sk_max_pacing_rate

Kees Cook (4):
      selftests/seccomp: Use __NR_mknodat instead of __NR_mknod
      selftests/seccomp: Refactor arch register macros to avoid xtensa special case
      selftests/seccomp: powerpc: Fix seccomp return value testing
      selftests/lkdtm: Use "comm" instead of "diff" for dmesg

Keita Suzuki (3):
      RDMA/qedr: Fix resource leak in qedr_create_qp
      misc: rtsx: Fix memory leak in rtsx_pci_probe
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Kevin Barnett (1):
      scsi: smartpqi: Avoid crashing kernel for controller issues

Kirill A. Shutemov (1):
      mm/huge_memory: fix split assumption of page size

Konrad Dybcio (1):
      clk: qcom: gcc-sdm660: Fix wrong parent_map

Krish Sadhukhan (1):
      KVM: nSVM: CR3 MBZ bits are only 63:52

Krzysztof Kozlowski (11):
      EDAC/aspeed: Fix handling of platform_get_irq() error
      EDAC/ti: Fix handling of platform_get_irq() error
      maiblox: mediatek: Fix handling of platform_get_irq() error
      Input: ep93xx_keypad - fix handling of platform_get_irq() error
      Input: omap4-keypad - fix handling of platform_get_irq() error
      Input: twl4030_keypad - fix handling of platform_get_irq() error
      Input: sun4i-ps2 - fix handling of platform_get_irq() error
      arm64: dts: qcom: msm8992: Fix UART interrupt property
      memory: fsl-corenet-cf: Fix handling of platform_get_irq() error
      arm64: dts: imx8mq: Add missing interrupts to GPC
      soc: fsl: qbman: Fix return value on success

Lad Prabhakar (3):
      media: i2c: ov5640: Remain in power down for DVP mode unless streaming
      media: i2c: ov5640: Separate out mipi configuration from s_power
      media: i2c: ov5640: Enable data pins on poweron for DVP mode

Lai Jiangshan (1):
      KVM: x86: Intercept LA57 to inject #GP fault when it's reserved

Lang Cheng (1):
      RDMA/hns: Add a check for current state before modifying QP

Laurent Pinchart (9):
      media: uvcvideo: Set media controller entity functions
      media: uvcvideo: Silence shift-out-of-bounds warning
      media: rcar_drif: Fix fwnode reference leak when parsing DT
      media: rcar_drif: Allocate v4l2_async_subdev dynamically
      media: rcar-csi2: Allocate v4l2_async_subdev dynamically
      media: i2c: max9286: Allocate v4l2_async_subdev dynamically
      drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel
      drm: panel: Fix bpc for OrtusTech COM43H4M85ULC panel
      drm: rcar-du: Put reference to VSP device

Leon Romanovsky (7):
      net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info
      RDMA/mlx5: Fix potential race between destroy and CQE poll
      RDMA/core: Delete function indirection for alloc/free kernel CQ
      RDMA: Allow fail of destroy CQ
      RDMA: Change XRCD destroy return value
      RDMA: Restore ability to return error for destroy WQ
      overflow: Include header file with SIZE_MAX declaration

Liao Pingfang (1):
      mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()

Libing Zhou (1):
      x86/nmi: Fix nmi_handle() duration miscalculation

Lijun Ou (1):
      RDMA/hns: Set the unsupported wr opcode

Lijun Pan (2):
      ibmvnic: save changed mac address to adapter->mac_addr
      ibmvnic: set up 200GBPS speed

Linus Walleij (4):
      net: dsa: rtl8366: Check validity of passed VLANs
      net: dsa: rtl8366: Refactor VLAN/PVID init
      net: dsa: rtl8366: Skip PVID setting if not requested
      net: dsa: rtl8366rb: Support all 4096 VLANs

Liu Shixin (1):
      RDMA/mlx5: Fix type warning of sizeof in __mlx5_ib_alloc_counters()

Logan Gunthorpe (2):
      dmaengine: ioat: Allocate correct size for descriptor chunk
      nvmet: limit passthru MTDS by BIO_MAX_PAGES

Longfang Liu (1):
      crypto: hisilicon - fixed memory allocation error

Lorenzo Bianconi (9):
      mt76: mt7615: hold mt76 lock queueing wd in mt7615_queue_key_update
      mt76: mt7615: release mutex in mt7615_reset_test_set
      mt76: mt7615: fix possible memory leak in mt7615_tm_set_tx_power
      mt76: mt7615: fix a possible NULL pointer dereference in mt7615_pm_wake_work
      mt76: fix a possible NULL pointer dereference in mt76_testmode_dump
      mt76: mt7663u: fix dma header initialization
      mt76: mt7615: move drv_own/fw_own in mt7615_mcu_ops
      mt76: mt7622: fix fw hang on mt7622
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_beacon

Lorenzo Colitti (3):
      usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.
      usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well
      usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Luca Stefani (1):
      RAS/CEC: Fix cec_init() prototype

Luca Weiss (1):
      drm/msm/adreno: fix probe without iommu

Lucas Stach (1):
      can: m_can_platform: don't call m_can_class_suspend in runtime suspend

Lukasz Halman (1):
      ALSA: usb-audio: Line6 Pod Go interface requires static clock rate quirk

Lukasz Luba (1):
      sched/fair: Fix wrong negative conversion in find_energy_efficient_cpu()

Maciej Fijalkowski (1):
      bpf: Limit caller's stack depth 256 for subprogs with tailcalls

Madhuparna Bhowmik (1):
      crypto: picoxcell - Fix potential race condition bug

Manivannan Sadhasivam (2):
      bus: mhi: core: Fix the building of MHI module
      arm64: dts: qcom: sm8250: Rename UART2 node to UART12

Marc Kleine-Budde (1):
      net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt

Marc Zyngier (2):
      arm64: Make use of ARCH_WORKAROUND_1 even when KVM is not enabled
      mfd: syscon: Don't free allocated name for regmap_config

Marek Vasut (7):
      net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
      net: fec: Fix PHY init after phy_reset_after_clk_enable()
      spi: imx: Fix freeing of DMA channels if spi_bitbang_start() fails
      ARM: dts: stm32: Fix sdmmc2 pins on AV96
      ARM: dts: stm32: Move ethernet PHY into DH SoM DT
      ARM: dts: stm32: Swap PHY reset GPIO and TSC2004 IRQ on DHCOM SOM
      ARM: dts: stm32: Fix DH PDK2 display PWM channel

Mark Mossberg (1):
      x86/dumpstack: Fix misleading instruction pointer error message

Mark Salter (2):
      drivers/perf: xgene_pmu: Fix uninitialized resource struct
      drivers/perf: thunderx2_pmu: Fix memory resource error handling

Mark Tomlinson (2):
      mtd: mtdoops: Don't write panic data twice
      PCI: iproc: Set affinity mask on MSI interrupts

Markus Mayer (1):
      memory: brcmstb_dpfe: fix array index out of bounds

Martijn de Gouw (1):
      SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()

Martin Blumenstingl (2):
      usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails
      ARM: dts: meson8: remove two invalid interrupt lines from the GPU node

Martin KaFai Lau (1):
      bpf: Enforce id generation for all may-be-null register type

Masahiro Yamada (1):
      kbuild: deb-pkg: do not build linux-headers package if CONFIG_MODULES=n

Mathias Nyman (1):
      xhci: don't create endpoint debugfs entry before ring buffer is set.

Mathieu Poirier (1):
      remoteproc: stm32: Fix pointer assignement

Matthew Rosato (3):
      PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY
      s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY
      vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn

Matthew Wilcox (Oracle) (7):
      iomap: Clear page error before beginning a write
      iomap: Mark read blocks uptodate in write_begin
      iomap: Use kzalloc to allocate iomap_page
      mm/page_alloc.c: fix freeing non-compound pages
      ida: Free allocated bitmap in error path
      mm/page_owner: change split_page_owner to take a count
      ramfs: fix nommu mmap with gaps in the page cache

Matthias Kaehlcke (1):
      cpufreq: qcom: Don't add frequencies without an OPP

Matthieu Baerts (1):
      selftests: mptcp: interpret \n as a new line

Maulik Shah (2):
      pinctrl: qcom: Set IRQCHIP_SET_TYPE_MASKED and IRQCHIP_MASK_ON_SUSPEND flags
      pinctrl: qcom: Use return value from irq_set_wake() call

Mauro Carvalho Chehab (2):
      media: saa7134: avoid a shift overflow
      usb: dwc3: simple: add support for Hikey 970

Maxim Kochetkov (1):
      net: dsa: seville: the packet buffer is 2 megabits, not megabytes

Maxime Ripard (1):
      drm/vc4: crtc: Rework a bit the CRTC state code

Md Haris Iqbal (1):
      RDMA/rtrs-srv: Incorporate ib_register_client into rtrs server init

Melissa Wen (1):
      drm/vkms: fix xrgb on compute crc

Mian Yousaf Kaukab (1):
      coresight: fix offset by one error in counting ports

Miaohe Lin (1):
      mm/swapfile.c: fix potential memory leak in sys_swapon

Michal Kalderon (5):
      RDMA/qedr: Fix qp structure memory leak
      RDMA/qedr: Fix doorbell setting
      RDMA/qedr: Fix use of uninitialized field
      RDMA/qedr: Fix return code if accept is called on a destroyed qp
      RDMA/qedr: Fix inline size returned for iWARP

Michal Simek (1):
      arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Michał Mirosław (1):
      regulator: resolve supply after creating regulator

Mikael Wikström (1):
      HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons

Mike Leach (3):
      coresight: etm4x: Ensure default perf settings filter user/kernel
      coresight: cti: Fix remove sysfs link error
      coresight: cti: Fix bug clearing sysfs links on callback

Mike Snitzer (2):
      dm: fix missing imposition of queue_limits from dm_wq_work() thread
      dm: fix request-based DM to not bounce through indirect dm_submit_bio

Minas Harutyunyan (1):
      usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Ming Lei (1):
      blk-mq: always allow reserved allocation in hctx_may_queue

Miquel Raynal (1):
      ASoC: tlv320aic32x4: Fix bdiv clock rate derivation

Miroslav Benes (1):
      selftests/livepatch: Do not check order when using "comm" for dmesg checking

Mohammed Gamal (1):
      hv: clocksource: Add notrace attribute to read_hv_sched_clock_*() functions

Mordechay Goodstein (2):
      iwlwifi: dbg: remove no filter condition
      iwlwifi: dbg: run init_cfg function once per driver load

Moshe Tal (1):
      net/mlx5: Fix uninitialized variable warning

Namhyung Kim (1):
      perf stat: Fix out of bounds CPU map access when handling armv8_pmu events

Nathan Chancellor (1):
      usb: dwc2: Fix parameter type in function pointer prototype

Nathan Lynch (1):
      powerpc/pseries: explicitly reschedule during drmem_lmb list traversal

Navid Emamdoost (2):
      clk: bcm2835: add missing release if devm_clk_hw_register fails
      drm/panfrost: perfcnt: fix ref count leak in panfrost_perfcnt_enable_locked

Neal Cardwell (1):
      tcp: fix to update snd_wl1 in bulk receiver fast path

Necip Fazil Yildiran (4):
      pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB
      ASoC: cros_ec_codec: fix kconfig dependency warning for SND_SOC_CROS_EC_CODEC
      ocxl: fix kconfig dependency warning for OCXL
      arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Neeraj Upadhyay (1):
      rcu/tree: Force quiescent state on callback overload

Neil Armstrong (3):
      drm/panfrost: add Amlogic GPU integration quirks
      drm/panfrost: add amlogic reset quirk callback
      drm/panfrost: add support for vendor quirk

Nicholas Mc Guire (2):
      powerpc/pseries: Fix missing of_node_put() in rng_init()
      powerpc/icp-hv: Fix missing of_node_put() in success path

Nicholas Piggin (4):
      powerpc/64s/radix: Fix mm_cpumask trimming race vs kthread_use_mm
      powerpc/64: fix irq replay missing preempt
      powerpc/64: fix irq replay pt_regs->softe value
      powerpc/security: Fix link stack flush instruction

Nicolas Boichat (1):
      rpmsg: Avoid double-free in mtk_rpmsg_register_device

Nicolas Toromanoff (1):
      crypto: stm32/crc32 - Avoid lock if hardware is already used

Nilesh Javali (3):
      scsi: qedi: Mark all connections for recovery on link down event
      scsi: qedi: Protect active command list to avoid list corruption
      scsi: qedi: Fix list_del corruption while removing active I/O

Oded Gabbay (1):
      habanalabs: cast to u64 before shift > 31 bits

Oliver Neukum (2):
      media: ati_remote: sanity check for both endpoints
      USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Oliver O'Halloran (1):
      selftests/powerpc: Fix eeh-basic.sh exit codes

Ong Boon Leong (1):
      net: stmmac: use netif_tx_start|stop_all_queues() function

Pablo Neira Ayuso (2):
      netfilter: nf_log: missing vlan offload tag and proto
      netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Pali Rohár (4):
      cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE
      PCI: aardvark: Fix compilation on s390
      PCI: aardvark: Check for errors from pci_bridge_emul_init() call
      mmc: sdio: Check for CISTPL_VERS_1 buffer size

Paolo Abeni (2):
      mptcp: fix fallback for MP_JOIN subflows
      mptcp: subflows garbage collection

Parshuram Thombare (1):
      i3c: master add i3c_master_attach_boardinfo to preserve boardinfo

Paul E. McKenney (1):
      rcutorture: Properly set rcu_fwds for OOM handling

Paul Kocialkowski (1):
      media: ov5640: Correct Bit Div register in clock tree diagram

Pavel Machek (2):
      crypto: ccp - fix error handling
      media: firewire: fix memory leak

Peilin Ye (3):
      media: vivid: Fix global-out-of-bounds read in precalculate_color()
      Bluetooth: Fix memory leak in read_adv_mon_features()
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Peng Fan (2):
      tty: serial: lpuart: fix lpuart32_write usage
      tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Peter Chen (1):
      usb: cdns3: gadget: free interrupt after gadget has deleted

Peter Ujfalusi (1):
      dmaengine: ti: k3-udma-glue: Fix parameters for rx ring pair request

Peter Zijlstra (4):
      lockdep: Fix usage_traceoverflow
      lockdep: Fix lockdep recursion
      lockdep: Revert "lockdep: Use raw_cpu_*() for per-cpu variables"
      notifier: Fix broken error handling pattern

Pierre-Louis Bossart (5):
      soundwire: stream: fix NULL/IS_ERR confusion
      soundwire: intel: fix NULL/ERR_PTR confusion
      ASoC: topology: disable size checks for bytes_ext controls if needed
      ASoC: SOF: control: add size checks for ext_bytes control .put()
      soundwire: cadence: fix race condition between suspend and Slave device alerts

Po-Hsu Lin (1):
      selftests: rtnetlink: load fou module for kci_test_encap_fou() test

Qian Cai (1):
      iomap: fix WARN_ON_ONCE() from unprivileged users

Qiang Yu (1):
      arm64: dts: allwinner: h5: remove Mali GPU PMU module

Qinglang Miao (2):
      drm/vgem: add missing platform_device_unregister() in vgem_init()
      drm/vkms: add missing platform_device_unregister() in vkms_init()

Qingqing Zhuo (1):
      drm/amd/display: Screen corruption on dual displays (DP+USB-C)

Qiu Wenbo (1):
      ALSA: hda/realtek - Add mute Led support for HP Elitebook 845 G7

Qiushi Wu (11):
      media: rcar-vin: Fix a reference count leak.
      media: rockchip/rga: Fix a reference count leak.
      media: platform: fcp: Fix a reference count leak.
      media: camss: Fix a reference count leak.
      media: s5p-mfc: Fix a reference count leak
      media: stm32-dcmi: Fix a reference count leak
      media: ti-vpe: Fix a missing check and reference count leak
      media: sti: Fix reference count leaks
      media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak

Qu Wenruo (1):
      btrfs: add owner and fs_info to alloc_state io_tree

Rajendra Nayak (2):
      arm64: dts: sdm845: Fixup OPP table for all qup devices
      media: venus: core: Fix error handling in probe

Rajkumar Manoharan (1):
      nl80211: fix OBSS PD min and max offset validation

Ralph Campbell (1):
      mm/memcg: fix device private memcg accounting

Randy Dunlap (1):
      microblaze: fix kbuild redundant file warning

Ravi Bangoria (3):
      powerpc/watchpoint: Fix quadword instruction handling on p10 predecessors
      powerpc/watchpoint: Fix handling of vector instructions
      powerpc/watchpoint: Add hw_len wherever missing

Robert Hoo (1):
      KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Roberto Sassu (1):
      ima: Don't ignore errors from crypto_shash_update()

Roger Quadros (1):
      arm64: dts: ti: k3-j721e: Rename mux header and update macro names

Rohit Maheshwari (1):
      net/tls: sendfile fails with ktls offload

Rohit kumar (2):
      ASoC: qcom: lpass-platform: fix memory leak
      ASoC: qcom: lpass-cpu: fix concurrency issue

Rohith Surabattula (1):
      SMB3: Resolve data corruption of TCP server info fields

Roi Dayan (1):
      net/sched: act_ct: Fix adding udp port mangle operation

Roman Bolshakov (1):
      scsi: target: core: Add CONTROL field for trace events

Roman Gushchin (1):
      mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()

Rustam Kovhaev (1):
      ntfs: add check for mft record size in superblock

Sai Prakash Ranjan (3):
      coresight: etm4x: Fix etm4_count race by moving cpuhp callbacks to init
      coresight: etm4x: Fix save and restore of TRCVMIDCCTLR1 register
      arm64: dts: qcom: sc7180: Fix the LLCC base register size

Samuel Holland (1):
      Bluetooth: hci_uart: Cancel init work before unregistering

Sasha Levin (1):
      perf/x86: Fix n_pair for cancelled txn

Sathyanarayana Nujella (2):
      ASoC: SOF: Add topology filename override based on dmi data match
      ASoC: Intel: sof_rt5682: override quirk data for tgl_max98373_rt5682

Saurav Kashyap (1):
      scsi: qedf: Return SUCCESS if stale rport is encountered

Scott Cheloha (1):
      pseries/drmem: don't cache node id in drmem_lmb struct

Scott Mayhew (1):
      nfs: add missing "posix" local_lock constant table definition

Sean Christopherson (4):
      KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI
      KVM: nVMX: Reset the segment cache when stuffing guest segs
      KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
      KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Sean Wang (1):
      mt76: mt7663s: fix resume failure

Serge Semin (8):
      hwmon: (bt1-pvt) Test sensor power supply on probe
      hwmon: (bt1-pvt) Cache current update timeout
      hwmon: (bt1-pvt) Wait for the completion with timeout
      serial: 8250: Discard RTS/DTS setting from clock update method
      serial: 8250: Skip uninitialized TTY port baud rate update
      serial: 8250_dw: Fix clk-notifier/port suspend deadlock
      dmaengine: dw: Add DMA-channels mask cell support
      dmaengine: dw: Activate FIFO-mode for memory peripherals only

Shengjiu Wang (1):
      ASoC: fsl_sai: Instantiate snd_soc_dai_driver

Sherry Sun (2):
      mic: vop: copy data to kernel space then write to io memory
      misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Shyam Prasad N (1):
      cifs: Return the error from crypt_message when enc/dec key not found.

Sibi Sankar (2):
      soc: qcom: pdr: Fixup array type of get_domain_list_resp message
      soc: qcom: apr: Fixup the error displayed on lookup failure

Simon South (1):
      pwm: rockchip: Keep enabled PWMs running while probing

Sindhu, Devale (1):
      i40iw: Add support to make destroy QP synchronous

Song Liu (1):
      bpf: Use raw_spin_trylock() for pcpu_freelist_push/pop in NMI

Sonny Sasaka (1):
      Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

Souptick Joarder (3):
      drivers/virt/fsl_hypervisor: Fix error handling path
      misc: mic: scif: Fix error handling path
      rapidio: fix error handling path

Srikar Dronamraju (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Srinivas Kandagatla (3):
      slimbus: core: check get_addr before removing laddr ida
      slimbus: core: do not enter to clock pause mode in core
      slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback

Stanley Chu (2):
      scsi: ufs: ufs-mediatek: Eliminate error message for unbound mphy
      scsi: ufs: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk

Stefan Agner (2):
      drm: mxsfb: check framebuffer pitch
      clk: meson: g12a: mark fclk_div2 as critical

Stephan Gerhold (3):
      arm64: dts: qcom: msm8916: Remove one more thermal trip point unit name
      arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec
      arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Stephen Boyd (4):
      drm/msm: Avoid div-by-zero in dpu_crtc_atomic_check()
      clk: rockchip: Initialize hw to error to avoid undefined behavior
      clk: qcom: gdsc: Keep RETAIN_FF bit set if gdsc is already on
      arm64: dts: qcom: sc7180: Drop flags on mdss irqs

Steve French (3):
      SMB3.1.1: Fix ids returned in POSIX query dir
      smb3: do not try to cache root directory if dir leases not supported
      smb3: fix stat when special device file and mounted with modefromsid

Steven Price (1):
      drm/panfrost: Ensure GPU quirks are always initialised

Sudeep Holla (1):
      firmware: arm_scmi: Fix NULL pointer dereference in mailbox_chan_free

Suravee Suthikulpanit (1):
      KVM: SVM: Initialize prev_ga_tag before use

Suren Baghdasaryan (1):
      mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Suzuki K Poulose (1):
      coresight: etm4x: Handle unreachable sink in perf mode

Sylwester Nawrocki (1):
      media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

Takashi Iwai (1):
      ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Tero Kristo (3):
      crypto: sa2ul - fix compiler warning produced by clang
      crypto: omap-sham - fix digcnt register handling with export/import
      clk: keystone: sci-clk: fix parsing assigned-clock data during probe

Tetsuo Handa (2):
      block: ratelimit handle_bad_sector() message
      mwifiex: don't call del_timer_sync() on uninitialized timer

Thiago Jung Bauermann (1):
      powerpc/pseries/svm: Allocate SWIOTLB buffer anywhere in memory

Thierry Reding (1):
      pinctrl: devicetree: Keep deferring even on timeout

Thinh Nguyen (1):
      usb: dwc3: core: Properly default unspecified speed

Thomas Gleixner (1):
      net: enic: Cure the enic api locking trainwreck

Thomas Pedersen (1):
      mac80211: handle lack of sband->bitrates in rates

Thomas Preston (2):
      pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
      pinctrl: mcp23s08: Fix mcp23x17 precious range

Thomas Tai (1):
      dma-direct: Fix potential NULL pointer dereference

Thomas Zimmermann (1):
      drm/malidp: Use struct drm_gem_object_funcs.get_sg_table internally

Tian Tao (1):
      drm/hisilicon: Code refactoring for hibmc_drv_de

Tianjia Zhang (6):
      crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
      drm/amd/display: Fix wrong return value in dm_update_plane_state()
      scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
      scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
      scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
      ipmi_si: Fix wrong return value in try_smi_init()

Tiezhu Yang (1):
      um: vector: Use GFP_ATOMIC under spin lock

Timothée COCAULT (1):
      netfilter: ebtables: Fixes dropping of small packets in bridge nat

Tingwei Zhang (4):
      coresight: cti: disclaim device only when it's claimed
      coresight: cti: remove pm_runtime_get_sync() from CPU hotplug
      coresight: cti: Write regsiters directly in cti_enable_hw()
      coresight: etm: perf: Fix warning caused by etm_setup_aux failure

Tobias Jordan (1):
      lib/crc32.c: fix trivial typo in preprocessor condition

Todd Kjos (1):
      binder: fix UAF when releasing todo list

Toke Høiland-Jørgensen (2):
      bpf: disallow attaching modify_return tracing functions to other BPF programs
      selftests: Remove fmod_ret from test_overhead

Tom Rix (9):
      media: tuner-simple: fix regression in simple_set_radio_freq
      media: m5mols: Check function pointer in m5mols_sensor_power
      media: tc358743: initialize variable
      media: tc358743: cleanup tc358743_cec_isr
      brcmfmac: check ndev pointer
      drm/gma500: fix error check
      ath11k: fix a double free and a memory leak
      video: fbdev: sis: fix null ptr dereference
      mwifiex: fix double free

Tom Zanussi (3):
      tracing: Fix parse_synth_field() error handling
      selftests/ftrace: Change synthetic event name for inter-event-combined test
      tracing: Handle synthetic event array field type checking correctly

Tomas Henzl (1):
      scsi: mpt3sas: Fix sync irqs

Tomasz Figa (1):
      phy: rockchip-dphy-rx0: Include linux/delay.h

Tong Zhang (2):
      tty: serial: earlycon dependency
      tty: ipwireless: fix error handling

Tony Lindgren (1):
      ARM: OMAP2+: Restore MPU power domain if cpu_cluster_pm_enter() fails

Tyler Hicks (2):
      ima: Pre-parse the list of keyrings in a KEY_CHECK rule
      ima: Fail rule parsing when asymmetric key measurement isn't supportable

Tyrel Datwyler (1):
      tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Tzu-En Huang (1):
      rtw88: increse the size of rx buffer size

Tzung-Bi Shih (1):
      ASoC: mediatek: mt8183-da7219: fix wrong ops for I2S3

Vadim Pasternak (1):
      platform/x86: mlx-platform: Remove PSU EEPROM configuration

Vadym Kochan (2):
      nvmem: core: fix missing of_node_put() in of_nvmem_device_get()
      nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()

Vaibhav Jain (2):
      powerpc/papr_scm: Fix warning triggered by perf_stats_show()
      powerpc/papr_scm: Add PAPR command family to pass-through command-set

Valentin Vidic (2):
      net: korina: fix kfree of rx/tx descriptor array
      net: korina: cast KSEG0 address to pointer in kfree

Vasant Hegde (1):
      powerpc/powernv/dump: Fix race while processing OPAL dump

Venkateswara Naralasetty (1):
      ath10k: provide survey info as accumulated data

Vignesh Raghavendra (1):
      mtd: hyperbus: hbmc-am654: Fix direct mapping setup flash access

Vikash Garodia (1):
      media: venus: fixes for list corruption

Vinay Kumar Yadav (6):
      chelsio/chtls: fix socket lock
      chelsio/chtls: correct netdevice for vlan interface
      chelsio/chtls: fix panic when server is on ipv6
      chelsio/chtls: Fix panic when listen on multiadapter
      chelsio/chtls: correct function return and return type
      chelsio/chtls: fix writing freed memory

Vincent Mailhol (1):
      usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Vinod Koul (1):
      arm64: dts: qcom: sdm845-db845c: Fix hdmi nodes

Viresh Kumar (1):
      opp: Prevent memory leak in dev_pm_opp_attach_genpd()

Vitaly Kuznetsov (1):
      KVM: ioapic: break infinite recursion on lazy EOI

Wang Yufen (2):
      ath11k: Fix possible memleak in ath11k_qmi_init_service
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Weihang Li (2):
      RDMA/hns: Fix configuration of ack_req_freq in QPC
      RDMA/hns: Fix missing sq_sig_type when querying QP

Wenpeng Liang (1):
      RDMA/hns: Fix the wrong value of rnr_retry when querying qp

Weqaar Janjua (1):
      samples/bpf: Fix to xdpsock to avoid recycling frames

Xiao Yang (1):
      ext4: disallow modifying DAX inode flag if inline_data has been set

Xiaoliang Pang (1):
      cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Xiaolong Huang (1):
      media: media/pci: prevent memory leak in bttv_probe

Xiaoyang Xu (1):
      vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Xie He (2):
      net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
      net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Xunlei Pang (1):
      sched/fair: Fix wrong cpu selecting from isolated domain

Yan Zhao (3):
      vfio: add a singleton check for vfio_group_pin_pages
      vfio: fix a missed vfio group put in vfio_pin_pages
      vfio/type1: fix dirty bitmap calculation in vfio_dma_rw

Yang Yang (1):
      blk-mq: move cancel of hctx->run_work to the front of blk_exit_queue

Yang Yingliang (2):
      tty: hvc: fix link error with CONFIG_SERIAL_CORE_CONSOLE=n
      tty: serial: imx: fix link error with CONFIG_SERIAL_CORE_CONSOLE=n

Ye Bin (2):
      drm/amdgpu: Fix invalid number of character '{' in amdgpu_acpi_init
      ext4: fix dead loop in ext4_mb_new_blocks

Yonghong Song (2):
      net: fix pos incrementment in ipv6_route_seq_next
      selftests/bpf: Fix test_sysctl_loop{1, 2} failure due to clang change

Yoshihiro Shimoda (1):
      usb: gadget: u_serial: clear suspended flag when disconnecting

Yu Chen (1):
      usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc

Yu Kuai (2):
      ASoC: fsl: imx-es8328: add missing put_device() call in imx_es8328_probe()
      iommu/qcom: add missing put_device() call in qcom_iommu_of_xlate()

YueHaibing (4):
      irqchip/ti-sci-inta: Fix unsigned comparison to zero
      irqchip/ti-sci-intr: Fix unsigned comparison to zero
      Input: stmfts - fix a & vs && typo
      memory: omap-gpmc: Fix build error without CONFIG_OF

Zekun Shen (1):
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zhao Heming (1):
      md/bitmap: fix memory leak of temporary bitmap

Zhenzhong Duan (1):
      drm/msm/a6xx: fix a potential overflow issue

Zqiang (1):
      usb: gadget: function: printer: fix use-after-free in __lock_acquire

dinghao.liu@zju.edu.cn (2):
      crypto: ccree - fix runtime PM imbalance on error
      backlight: sky81452-backlight: Fix refcount imbalance on error

peterz@infradead.org (1):
      seqlock: Unbreak lockdep

zhenwei pi (1):
      nvmet: fix uninitialized work for zero kato

Łukasz Stelmach (2):
      spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()
      spi: spi-s3c64xx: Check return values

