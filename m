Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56686B3936
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjCJIua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJItl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BE52CFCE;
        Fri, 10 Mar 2023 00:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06ABAB821F9;
        Fri, 10 Mar 2023 08:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43E9C4339C;
        Fri, 10 Mar 2023 08:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678438149;
        bh=jB/eAUs3fbDdhYhUQGcYMrtAAGeh6tWlHz2mnQRgx/o=;
        h=From:To:Cc:Subject:Date:From;
        b=wQNt/O3JZZ1oSlQGh2RhXjcXbWggvtFvZDET1JNeqs/ig8pO2ZeEZc/8gMCcSC2LA
         mYkSPfEpi6YZ/xA1EQrPVQdHzhFxTwZocQuH9t4urhe/lMYX37WQXMf6q4hdGjkLFj
         Fp/fR5RAevMcax0ULblQnQgu6EXSUXVDl93k8p+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.16
Date:   Fri, 10 Mar 2023 09:48:45 +0100
Message-Id: <1678438125622@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.16 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/cgroup-v1/memory.rst                          |   13 
 Documentation/admin-guide/hw-vuln/spectre.rst                           |   21 
 Documentation/admin-guide/kdump/gdbmacros.txt                           |    2 
 Documentation/bpf/instruction-set.rst                                   |   16 
 Documentation/dev-tools/gdb-kernel-debugging.rst                        |    4 
 Documentation/devicetree/bindings/display/mediatek/mediatek,ccorr.yaml  |    2 
 Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml      |    2 
 Documentation/hwmon/ftsteutates.rst                                     |    4 
 Documentation/virt/kvm/api.rst                                          |   18 
 Documentation/virt/kvm/devices/vm.rst                                   |    4 
 Makefile                                                                |   15 
 arch/alpha/boot/tools/objstrip.c                                        |    2 
 arch/alpha/kernel/traps.c                                               |   30 
 arch/arm/boot/dts/exynos3250-rinato.dts                                 |    2 
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi                              |    2 
 arch/arm/boot/dts/exynos4.dtsi                                          |    2 
 arch/arm/boot/dts/exynos4210.dtsi                                       |    1 
 arch/arm/boot/dts/exynos5250.dtsi                                       |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts                               |    1 
 arch/arm/boot/dts/exynos5420.dtsi                                       |    2 
 arch/arm/boot/dts/exynos5422-odroidhc1.dts                              |   10 
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi                      |   10 
 arch/arm/boot/dts/imx7s.dtsi                                            |    2 
 arch/arm/boot/dts/qcom-sdx55.dtsi                                       |    2 
 arch/arm/boot/dts/qcom-sdx65.dtsi                                       |    2 
 arch/arm/boot/dts/stm32mp131.dtsi                                       |    1 
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts                              |    2 
 arch/arm/configs/bcm2835_defconfig                                      |    1 
 arch/arm/mach-imx/mmdc.c                                                |   24 
 arch/arm/mach-omap1/timer.c                                             |    2 
 arch/arm/mach-omap2/omap4-common.c                                      |    1 
 arch/arm/mach-omap2/timer.c                                             |    1 
 arch/arm/mach-s3c/s3c64xx.c                                             |    3 
 arch/arm/mach-zynq/slcr.c                                               |    1 
 arch/arm64/Kconfig                                                      |    1 
 arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi          |   10 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                              |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                       |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts                   |    1 
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi                             |   20 
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi                  |    2 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                               |    6 
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts                      |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts              |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts               |    1 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts      |    6 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                              |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts                   |    6 
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts                    |   10 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                               |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                               |    2 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                               |    2 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                               |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                                |    1 
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi                               |    3 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                                |   12 
 arch/arm64/boot/dts/mediatek/mt8186.dtsi                                |   17 
 arch/arm64/boot/dts/mediatek/mt8192.dtsi                                |   25 
 arch/arm64/boot/dts/mediatek/mt8195.dtsi                                |   25 
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi                          |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                                   |   63 -
 arch/arm64/boot/dts/qcom/msm8953.dtsi                                   |    2 
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-10.dts                 |    3 
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-101.dts                |    3 
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi                       |   37 
 arch/arm64/boot/dts/qcom/msm8992.dtsi                                   |    3 
 arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi                  |    5 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                   |   22 
 arch/arm64/boot/dts/qcom/pmk8350.dtsi                                   |    5 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                                    |   12 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                                    |    4 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                    |    4 
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi                                  |    6 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                              |    2 
 arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts            |   19 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                                    |    6 
 arch/arm64/boot/dts/qcom/sm6350.dtsi                                    |    7 
 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi                 |    7 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                    |    2 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                                    |    4 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi               |   24 
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi                                |    9 
 arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi                                 |    2 
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts                   |    2 
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi                         |   29 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                                  |    2 
 arch/arm64/kernel/cpufeature.c                                          |    2 
 arch/loongarch/net/bpf_jit.c                                            |    2 
 arch/loongarch/net/bpf_jit.h                                            |   21 
 arch/m68k/68000/entry.S                                                 |    2 
 arch/m68k/Kconfig.devices                                               |    1 
 arch/m68k/coldfire/entry.S                                              |    2 
 arch/m68k/kernel/entry.S                                                |    3 
 arch/mips/boot/dts/ingenic/ci20.dts                                     |    2 
 arch/mips/include/asm/syscall.h                                         |    2 
 arch/powerpc/Makefile                                                   |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                                    |   11 
 arch/riscv/Makefile                                                     |    6 
 arch/riscv/include/asm/ftrace.h                                         |   50 -
 arch/riscv/include/asm/jump_label.h                                     |    2 
 arch/riscv/include/asm/pgtable.h                                        |    2 
 arch/riscv/include/asm/thread_info.h                                    |    1 
 arch/riscv/kernel/ftrace.c                                              |   65 -
 arch/riscv/kernel/mcount-dyn.S                                          |   42 
 arch/riscv/kernel/time.c                                                |    3 
 arch/riscv/kernel/traps.c                                               |    5 
 arch/riscv/mm/fault.c                                                   |   10 
 arch/s390/boot/boot.h                                                   |   26 
 arch/s390/boot/decompressor.c                                           |    1 
 arch/s390/boot/decompressor.h                                           |   26 
 arch/s390/boot/kaslr.c                                                  |    6 
 arch/s390/boot/mem_detect.c                                             |   54 -
 arch/s390/boot/startup.c                                                |   21 
 arch/s390/include/asm/ap.h                                              |   12 
 arch/s390/kernel/early.c                                                |    1 
 arch/s390/kernel/head64.S                                               |    1 
 arch/s390/kernel/idle.c                                                 |    2 
 arch/s390/kernel/kprobes.c                                              |    4 
 arch/s390/kernel/vdso64/Makefile                                        |    2 
 arch/s390/kernel/vmlinux.lds.S                                          |    1 
 arch/s390/kvm/kvm-s390.c                                                |   43 
 arch/s390/mm/dump_pagetables.c                                          |   16 
 arch/s390/mm/extmem.c                                                   |   12 
 arch/s390/mm/fault.c                                                    |   49 -
 arch/s390/mm/vmem.c                                                     |    6 
 arch/s390/net/bpf_jit_comp.c                                            |   12 
 arch/sparc/Kconfig                                                      |    2 
 arch/x86/crypto/ghash-clmulni-intel_glue.c                              |    6 
 arch/x86/events/intel/ds.c                                              |   35 
 arch/x86/events/intel/uncore.c                                          |    7 
 arch/x86/events/intel/uncore.h                                          |    1 
 arch/x86/events/intel/uncore_snb.c                                      |  161 +++
 arch/x86/events/zhaoxin/core.c                                          |    8 
 arch/x86/include/asm/fpu/sched.h                                        |    2 
 arch/x86/include/asm/fpu/xcr.h                                          |    4 
 arch/x86/include/asm/microcode.h                                        |    4 
 arch/x86/include/asm/microcode_amd.h                                    |    4 
 arch/x86/include/asm/msr-index.h                                        |    4 
 arch/x86/include/asm/processor.h                                        |    3 
 arch/x86/include/asm/reboot.h                                           |    2 
 arch/x86/include/asm/special_insns.h                                    |    2 
 arch/x86/include/asm/virtext.h                                          |   16 
 arch/x86/kernel/acpi/boot.c                                             |   19 
 arch/x86/kernel/cpu/bugs.c                                              |   35 
 arch/x86/kernel/cpu/common.c                                            |   45 
 arch/x86/kernel/cpu/microcode/amd.c                                     |   53 -
 arch/x86/kernel/cpu/microcode/core.c                                    |   26 
 arch/x86/kernel/crash.c                                                 |   17 
 arch/x86/kernel/fpu/context.h                                           |    2 
 arch/x86/kernel/fpu/core.c                                              |    6 
 arch/x86/kernel/kprobes/opt.c                                           |    6 
 arch/x86/kernel/reboot.c                                                |   88 +
 arch/x86/kernel/signal.c                                                |    2 
 arch/x86/kernel/smp.c                                                   |    6 
 arch/x86/kvm/lapic.c                                                    |   38 
 arch/x86/kvm/svm/avic.c                                                 |   53 -
 arch/x86/kvm/svm/sev.c                                                  |    4 
 arch/x86/kvm/svm/svm.c                                                  |    2 
 arch/x86/kvm/svm/svm.h                                                  |    2 
 arch/x86/kvm/svm/svm_onhyperv.h                                         |    4 
 arch/x86/kvm/vmx/evmcs.h                                                |   11 
 arch/x86/kvm/vmx/vmx.c                                                  |    9 
 block/bio-integrity.c                                                   |    1 
 block/bio.c                                                             |    1 
 block/blk-cgroup.c                                                      |   39 
 block/blk-core.c                                                        |   33 
 block/blk-iocost.c                                                      |   11 
 block/blk-merge.c                                                       |   35 
 block/blk-mq-sched.c                                                    |    7 
 block/blk-mq.c                                                          |   15 
 block/fops.c                                                            |   21 
 crypto/asymmetric_keys/public_key.c                                     |   24 
 crypto/essiv.c                                                          |    7 
 crypto/rsa-pkcs1pad.c                                                   |   34 
 crypto/seqiv.c                                                          |    2 
 crypto/xts.c                                                            |    8 
 drivers/acpi/acpica/Makefile                                            |    2 
 drivers/acpi/acpica/hwvalid.c                                           |    7 
 drivers/acpi/acpica/nsrepair.c                                          |   12 
 drivers/acpi/battery.c                                                  |    2 
 drivers/acpi/resource.c                                                 |   26 
 drivers/acpi/video_detect.c                                             |    2 
 drivers/ata/ahci.c                                                      |    1 
 drivers/base/core.c                                                     |  452 ++++++----
 drivers/base/physical_location.c                                        |    5 
 drivers/base/power/domain.c                                             |    5 
 drivers/base/regmap/regmap.c                                            |    6 
 drivers/base/transport_class.c                                          |   17 
 drivers/block/brd.c                                                     |   67 -
 drivers/block/rbd.c                                                     |   20 
 drivers/block/ublk_drv.c                                                |   23 
 drivers/bluetooth/btusb.c                                               |   16 
 drivers/bluetooth/hci_qca.c                                             |    7 
 drivers/bus/mhi/ep/main.c                                               |   35 
 drivers/char/applicom.c                                                 |    5 
 drivers/char/ipmi/ipmi_ipmb.c                                           |    2 
 drivers/char/ipmi/ipmi_ssif.c                                           |   74 -
 drivers/char/pcmcia/cm4000_cs.c                                         |    6 
 drivers/clocksource/timer-riscv.c                                       |   10 
 drivers/cpufreq/davinci-cpufreq.c                                       |    4 
 drivers/cpuidle/Kconfig.arm                                             |    2 
 drivers/crypto/amcc/crypto4xx_core.c                                    |   10 
 drivers/crypto/ccp/ccp-dmaengine.c                                      |   21 
 drivers/crypto/ccp/sev-dev.c                                            |   15 
 drivers/crypto/hisilicon/sgl.c                                          |    3 
 drivers/crypto/marvell/octeontx2/Makefile                               |   11 
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c                            |    9 
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h                            |    2 
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h                      |    2 
 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c                 |   14 
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c                           |   11 
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c                      |    2 
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c                      |    2 
 drivers/crypto/qat/qat_common/qat_algs.c                                |    2 
 drivers/cxl/pmem.c                                                      |    1 
 drivers/dax/bus.c                                                       |    2 
 drivers/dax/kmem.c                                                      |    4 
 drivers/dma/Kconfig                                                     |    2 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                          |    2 
 drivers/dma/dw-edma/dw-edma-core.c                                      |    4 
 drivers/dma/dw-edma/dw-edma-v0-core.c                                   |    2 
 drivers/dma/idxd/device.c                                               |    2 
 drivers/dma/idxd/init.c                                                 |    2 
 drivers/dma/idxd/sysfs.c                                                |    4 
 drivers/dma/ptdma/ptdma-dmaengine.c                                     |    2 
 drivers/dma/sf-pdma/sf-pdma.c                                           |    3 
 drivers/dma/sf-pdma/sf-pdma.h                                           |    1 
 drivers/firmware/dmi-sysfs.c                                            |   10 
 drivers/firmware/google/framebuffer-coreboot.c                          |    4 
 drivers/firmware/psci/psci.c                                            |   31 
 drivers/firmware/stratix10-svc.c                                        |   25 
 drivers/fpga/microchip-spi.c                                            |  123 +-
 drivers/gpio/gpio-vf610.c                                               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                        |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                              |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                                 |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h                               |    4 
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c                                  |    5 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                                |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                       |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c                  |    7 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c              |    3 
 drivers/gpu/drm/amd/display/dc/core/dc.c                                |   16 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                           |    6 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                        |   14 
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h                            |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h                       |    3 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c                       |    9 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h                       |    2 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c       |    6 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c                 |    4 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c          |    8 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c        |   10 
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c          |   12 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c                    |    4 
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c                  |    2 
 drivers/gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c            |    6 
 drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c            |    6 
 drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c            |    6 
 drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h                          |    7 
 drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h                |    1 
 drivers/gpu/drm/bridge/lontium-lt9611.c                                 |   65 -
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c                |    6 
 drivers/gpu/drm/bridge/tc358767.c                                       |    8 
 drivers/gpu/drm/bridge/ti-sn65dsi83.c                                   |    2 
 drivers/gpu/drm/drm_edid.c                                              |   43 
 drivers/gpu/drm/drm_fourcc.c                                            |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                                  |   52 -
 drivers/gpu/drm/drm_mipi_dsi.c                                          |   52 +
 drivers/gpu/drm/drm_mode_config.c                                       |    8 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                          |   39 
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                                 |    8 
 drivers/gpu/drm/gud/gud_pipe.c                                          |    4 
 drivers/gpu/drm/i915/display/intel_quirks.c                             |    2 
 drivers/gpu/drm/i915/gt/intel_ring.c                                    |    6 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                                 |    2 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                                  |    1 
 drivers/gpu/drm/mediatek/mtk_drm_gem.c                                  |    4 
 drivers/gpu/drm/mediatek/mtk_dsi.c                                      |    2 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                                 |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                                |    7 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c                          |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                                 |    5 
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                               |   15 
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c                                  |    5 
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c                           |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                               |    5 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                                       |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                                      |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                         |    4 
 drivers/gpu/drm/msm/msm_drv.c                                           |    2 
 drivers/gpu/drm/msm/msm_fence.c                                         |    2 
 drivers/gpu/drm/msm/msm_gem_submit.c                                    |    4 
 drivers/gpu/drm/mxsfb/Kconfig                                           |    2 
 drivers/gpu/drm/omapdrm/dss/dsi.c                                       |   26 
 drivers/gpu/drm/panel/panel-edp.c                                       |    2 
 drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c                           |    4 
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c                        |    3 
 drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c                           |    2 
 drivers/gpu/drm/radeon/atombios_encoders.c                              |    5 
 drivers/gpu/drm/radeon/radeon_device.c                                  |    1 
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c                                  |   31 
 drivers/gpu/drm/rcar-du/rcar_du_drv.c                                   |   49 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.h                                   |    2 
 drivers/gpu/drm/rcar-du/rcar_du_regs.h                                  |    8 
 drivers/gpu/drm/tegra/firewall.c                                        |    3 
 drivers/gpu/drm/tidss/tidss_dispc.c                                     |    4 
 drivers/gpu/drm/tiny/ili9486.c                                          |   13 
 drivers/gpu/drm/vc4/vc4_dpi.c                                           |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                          |   16 
 drivers/gpu/drm/vc4/vc4_hvs.c                                           |   73 +
 drivers/gpu/drm/vc4/vc4_plane.c                                         |    2 
 drivers/gpu/drm/vc4/vc4_regs.h                                          |   17 
 drivers/gpu/drm/vkms/vkms_drv.c                                         |   10 
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h                              |    2 
 drivers/gpu/host1x/hw/hw_host1x07_uclass.h                              |    2 
 drivers/gpu/host1x/hw/hw_host1x08_uclass.h                              |    2 
 drivers/gpu/host1x/hw/syncpt_hw.c                                       |    3 
 drivers/gpu/ipu-v3/ipu-common.c                                         |    1 
 drivers/hid/hid-asus.c                                                  |   37 
 drivers/hid/hid-bigbenff.c                                              |   75 +
 drivers/hid/hid-debug.c                                                 |    1 
 drivers/hid/hid-ids.h                                                   |    2 
 drivers/hid/hid-input.c                                                 |   12 
 drivers/hid/hid-logitech-hidpp.c                                        |   49 -
 drivers/hid/hid-multitouch.c                                            |   39 
 drivers/hid/hid-quirks.c                                                |    2 
 drivers/hid/hid-uclogic-core.c                                          |   26 
 drivers/hid/hid-uclogic-params.c                                        |   14 
 drivers/hid/hid-uclogic-params.h                                        |   24 
 drivers/hid/i2c-hid/i2c-hid-core.c                                      |    6 
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                                |   42 
 drivers/hid/i2c-hid/i2c-hid.h                                           |    3 
 drivers/hwmon/Kconfig                                                   |    2 
 drivers/hwmon/asus-ec-sensors.c                                         |    1 
 drivers/hwmon/coretemp.c                                                |  128 +-
 drivers/hwmon/ftsteutates.c                                             |   19 
 drivers/hwmon/ltc2945.c                                                 |    2 
 drivers/hwmon/mlxreg-fan.c                                              |    6 
 drivers/hwmon/nct6775-core.c                                            |    2 
 drivers/hwmon/nct6775-platform.c                                        |  150 ++-
 drivers/hwmon/peci/cputemp.c                                            |    2 
 drivers/hwtracing/coresight/coresight-cti-core.c                        |   11 
 drivers/hwtracing/coresight/coresight-cti-sysfs.c                       |   13 
 drivers/hwtracing/coresight/coresight-etm4x-core.c                      |   18 
 drivers/hwtracing/ptt/hisi_ptt.c                                        |   10 
 drivers/i2c/busses/i2c-designware-common.c                              |    2 
 drivers/i2c/busses/i2c-designware-core.h                                |    2 
 drivers/idle/intel_idle.c                                               |    8 
 drivers/iio/light/tsl2563.c                                             |    8 
 drivers/infiniband/hw/cxgb4/cm.c                                        |    7 
 drivers/infiniband/hw/cxgb4/restrack.c                                  |    2 
 drivers/infiniband/hw/erdma/erdma_verbs.c                               |    4 
 drivers/infiniband/hw/hfi1/sdma.c                                       |    4 
 drivers/infiniband/hw/hfi1/sdma.h                                       |   15 
 drivers/infiniband/hw/hfi1/user_pages.c                                 |   61 -
 drivers/infiniband/hw/hns/hns_roce_main.c                               |    5 
 drivers/infiniband/hw/irdma/hw.c                                        |    2 
 drivers/infiniband/sw/rxe/rxe_queue.h                                   |  108 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c                                   |  100 --
 drivers/infiniband/sw/siw/siw_mem.c                                     |   23 
 drivers/iommu/amd/init.c                                                |   16 
 drivers/iommu/amd/iommu.c                                               |   22 
 drivers/iommu/apple-dart.c                                              |  204 +++-
 drivers/iommu/intel/iommu.c                                             |   26 
 drivers/iommu/intel/pasid.c                                             |   18 
 drivers/iommu/iommu.c                                                   |    8 
 drivers/irqchip/irq-alpine-msi.c                                        |    1 
 drivers/irqchip/irq-bcm7120-l2.c                                        |    3 
 drivers/irqchip/irq-brcmstb-l2.c                                        |    6 
 drivers/irqchip/irq-mvebu-gicp.c                                        |    1 
 drivers/irqchip/irq-ti-sci-intr.c                                       |    1 
 drivers/irqchip/irqchip.c                                               |    8 
 drivers/leds/led-class.c                                                |    6 
 drivers/leds/leds-is31fl319x.c                                          |    7 
 drivers/leds/simple/simatic-ipc-leds-gpio.c                             |    2 
 drivers/md/dm-bufio.c                                                   |    2 
 drivers/md/dm-cache-background-tracker.c                                |    8 
 drivers/md/dm-cache-target.c                                            |    4 
 drivers/md/dm-flakey.c                                                  |   31 
 drivers/md/dm-ioctl.c                                                   |   13 
 drivers/md/dm-thin.c                                                    |    2 
 drivers/md/dm-zoned-metadata.c                                          |    2 
 drivers/md/dm.c                                                         |   30 
 drivers/md/dm.h                                                         |    2 
 drivers/md/md.c                                                         |    2 
 drivers/media/i2c/imx219.c                                              |  255 ++---
 drivers/media/i2c/max9286.c                                             |    1 
 drivers/media/i2c/ov2740.c                                              |    4 
 drivers/media/i2c/ov5640.c                                              |   56 -
 drivers/media/i2c/ov5675.c                                              |    4 
 drivers/media/i2c/ov7670.c                                              |    2 
 drivers/media/i2c/ov772x.c                                              |    3 
 drivers/media/mc/mc-entity.c                                            |    8 
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c                           |    3 
 drivers/media/pci/saa7134/saa7134-core.c                                |    2 
 drivers/media/platform/amphion/vpu_color.c                              |    6 
 drivers/media/platform/mediatek/mdp3/Kconfig                            |    8 
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c                    |    7 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c                          |   35 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h                          |    4 
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c                |    3 
 drivers/media/platform/ti/cal/cal.c                                     |    4 
 drivers/media/platform/ti/omap3isp/isp.c                                |    9 
 drivers/media/platform/verisilicon/hantro_v4l2.c                        |    7 
 drivers/media/rc/ene_ir.c                                               |    3 
 drivers/media/usb/siano/smsusb.c                                        |    1 
 drivers/media/usb/uvc/uvc_ctrl.c                                        |  154 ++-
 drivers/media/usb/uvc/uvc_driver.c                                      |   18 
 drivers/media/usb/uvc/uvc_v4l2.c                                        |    6 
 drivers/media/usb/uvc/uvcvideo.h                                        |    6 
 drivers/media/v4l2-core/v4l2-h264.c                                     |    4 
 drivers/media/v4l2-core/v4l2-jpeg.c                                     |    4 
 drivers/mfd/Kconfig                                                     |    1 
 drivers/mfd/pcf50633-adc.c                                              |    7 
 drivers/misc/eeprom/idt_89hpesx.c                                       |   10 
 drivers/misc/fastrpc.c                                                  |   13 
 drivers/misc/habanalabs/common/command_submission.c                     |   33 
 drivers/misc/habanalabs/common/device.c                                 |   38 
 drivers/misc/habanalabs/common/memory.c                                 |    5 
 drivers/misc/mei/hdcp/mei_hdcp.c                                        |    4 
 drivers/misc/mei/pxp/mei_pxp.c                                          |    4 
 drivers/misc/vmw_vmci/vmci_host.c                                       |    2 
 drivers/mtd/mtdpart.c                                                   |   10 
 drivers/mtd/spi-nor/core.c                                              |    9 
 drivers/mtd/spi-nor/core.h                                              |    1 
 drivers/mtd/spi-nor/sfdp.c                                              |    6 
 drivers/mtd/spi-nor/spansion.c                                          |    9 
 drivers/net/can/rcar/rcar_canfd.c                                       |    4 
 drivers/net/can/usb/esd_usb.c                                           |   52 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                          |    8 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                            |   11 
 drivers/net/ethernet/intel/ice/ice_main.c                               |   17 
 drivers/net/ethernet/intel/ice/ice_ptp.c                                |    2 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                              |   22 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                     |    3 
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c                    |    4 
 drivers/net/ethernet/qlogic/qede/qede_main.c                            |   16 
 drivers/net/hyperv/netvsc.c                                             |   18 
 drivers/net/ipa/gsi.c                                                   |    3 
 drivers/net/ipa/gsi_reg.h                                               |    1 
 drivers/net/tap.c                                                       |    2 
 drivers/net/tun.c                                                       |    2 
 drivers/net/wireless/ath/ath11k/core.h                                  |    1 
 drivers/net/wireless/ath/ath11k/debugfs.c                               |   48 -
 drivers/net/wireless/ath/ath11k/dp_rx.c                                 |    2 
 drivers/net/wireless/ath/ath11k/pci.c                                   |    2 
 drivers/net/wireless/ath/ath9k/hif_usb.c                                |   33 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                           |    2 
 drivers/net/wireless/ath/ath9k/htc_hst.c                                |    4 
 drivers/net/wireless/ath/ath9k/wmi.c                                    |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c               |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c                 |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c               |    5 
 drivers/net/wireless/intel/ipw2x00/ipw2200.c                            |   11 
 drivers/net/wireless/intel/iwlegacy/3945-mac.c                          |   16 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c                          |   12 
 drivers/net/wireless/intel/iwlegacy/common.c                            |    4 
 drivers/net/wireless/intel/iwlwifi/mei/main.c                           |    6 
 drivers/net/wireless/intersil/orinoco/hw.c                              |    2 
 drivers/net/wireless/marvell/libertas/cmdresp.c                         |    2 
 drivers/net/wireless/marvell/libertas/if_usb.c                          |    2 
 drivers/net/wireless/marvell/libertas/main.c                            |    3 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                       |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                              |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                                |   13 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c                    |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c                     |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c                      |   19 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c                        |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                         |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/main.c                        |    6 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                         |   13 
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c                        |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h                        |    1 
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c                         |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c                    |    7 
 drivers/net/wireless/mediatek/mt76/sdio.c                               |    4 
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c                          |    4 
 drivers/net/wireless/mediatek/mt7601u/dma.c                             |    3 
 drivers/net/wireless/microchip/wilc1000/netdev.c                        |    8 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c                  |    5 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c                   |   19 
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c                     |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c                     |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c                     |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c                    |   52 -
 drivers/net/wireless/realtek/rtw88/coex.c                               |    2 
 drivers/net/wireless/realtek/rtw88/mac.c                                |   10 
 drivers/net/wireless/realtek/rtw88/main.h                               |    2 
 drivers/net/wireless/realtek/rtw88/ps.c                                 |    4 
 drivers/net/wireless/realtek/rtw88/wow.c                                |    2 
 drivers/net/wireless/realtek/rtw89/core.c                               |    3 
 drivers/net/wireless/realtek/rtw89/debug.c                              |    7 
 drivers/net/wireless/realtek/rtw89/fw.c                                 |    4 
 drivers/net/wireless/realtek/rtw89/reg.h                                |    2 
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c                       |   11 
 drivers/net/wireless/rsi/rsi_91x_coex.c                                 |    1 
 drivers/net/wireless/wl3501_cs.c                                        |    2 
 drivers/nvdimm/bus.c                                                    |   19 
 drivers/nvdimm/dimm_devs.c                                              |    5 
 drivers/nvdimm/nd-core.h                                                |    1 
 drivers/opp/debugfs.c                                                   |    2 
 drivers/pci/controller/dwc/pcie-qcom.c                                  |   13 
 drivers/pci/controller/pcie-mt7621.c                                    |    2 
 drivers/pci/endpoint/functions/pci-epf-vntb.c                           |   84 +
 drivers/pci/iov.c                                                       |    2 
 drivers/pci/pci-driver.c                                                |    2 
 drivers/pci/pci.c                                                       |   59 -
 drivers/pci/pci.h                                                       |   59 -
 drivers/pci/pcie/dpc.c                                                  |    4 
 drivers/pci/probe.c                                                     |    2 
 drivers/pci/quirks.c                                                    |    1 
 drivers/pci/switch/switchtec.c                                          |    9 
 drivers/phy/mediatek/phy-mtk-io.h                                       |    4 
 drivers/phy/rockchip/phy-rockchip-typec.c                               |    4 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                                   |    2 
 drivers/pinctrl/mediatek/pinctrl-paris.c                                |    4 
 drivers/pinctrl/pinctrl-at91-pio4.c                                     |    4 
 drivers/pinctrl/pinctrl-at91.c                                          |    2 
 drivers/pinctrl/pinctrl-rockchip.c                                      |    1 
 drivers/pinctrl/qcom/pinctrl-msm8976.c                                  |    8 
 drivers/pinctrl/renesas/pinctrl-rzg2l.c                                 |   17 
 drivers/pinctrl/stm32/pinctrl-stm32.c                                   |    1 
 drivers/platform/chrome/cros_ec_typec.c                                 |    2 
 drivers/power/supply/power_supply_core.c                                |   93 --
 drivers/powercap/powercap_sys.c                                         |   14 
 drivers/regulator/core.c                                                |    6 
 drivers/regulator/max77802-regulator.c                                  |   34 
 drivers/regulator/s5m8767.c                                             |    6 
 drivers/regulator/tps65219-regulator.c                                  |   22 
 drivers/remoteproc/mtk_scp_ipi.c                                        |   11 
 drivers/remoteproc/qcom_q6v5_mss.c                                      |   87 +
 drivers/rpmsg/qcom_glink_native.c                                       |    3 
 drivers/rtc/rtc-pm8xxx.c                                                |   24 
 drivers/s390/block/dasd_eckd.c                                          |    4 
 drivers/s390/char/sclp_early.c                                          |    2 
 drivers/s390/crypto/vfio_ap_ops.c                                       |   12 
 drivers/scsi/aacraid/aachba.c                                           |    5 
 drivers/scsi/aic94xx/aic94xx_task.c                                     |    3 
 drivers/scsi/lpfc/lpfc_sli.c                                            |   19 
 drivers/scsi/mpi3mr/mpi3mr_app.c                                        |   28 
 drivers/scsi/mpi3mr/mpi3mr_os.c                                         |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                     |    6 
 drivers/scsi/qla2xxx/qla_bsg.c                                          |    9 
 drivers/scsi/qla2xxx/qla_def.h                                          |    6 
 drivers/scsi/qla2xxx/qla_dfs.c                                          |   10 
 drivers/scsi/qla2xxx/qla_edif.c                                         |   11 
 drivers/scsi/qla2xxx/qla_edif_bsg.h                                     |   15 
 drivers/scsi/qla2xxx/qla_init.c                                         |   14 
 drivers/scsi/qla2xxx/qla_inline.h                                       |   55 -
 drivers/scsi/qla2xxx/qla_iocb.c                                         |   95 +-
 drivers/scsi/qla2xxx/qla_isr.c                                          |    6 
 drivers/scsi/qla2xxx/qla_nvme.c                                         |   34 
 drivers/scsi/qla2xxx/qla_os.c                                           |    9 
 drivers/scsi/ses.c                                                      |   64 +
 drivers/scsi/snic/snic_debugfs.c                                        |    4 
 drivers/soundwire/cadence_master.c                                      |    3 
 drivers/spi/Kconfig                                                     |    1 
 drivers/spi/spi-bcm63xx-hsspi.c                                         |   12 
 drivers/spi/spi-synquacer.c                                             |    7 
 drivers/staging/media/atomisp/pci/atomisp_fops.c                        |    4 
 drivers/staging/media/imx/imx7-media-csi.c                              |    4 
 drivers/thermal/hisi_thermal.c                                          |    4 
 drivers/thermal/imx_sc_thermal.c                                        |   10 
 drivers/thermal/intel/intel_pch_thermal.c                               |    8 
 drivers/thermal/intel/intel_powerclamp.c                                |   20 
 drivers/thermal/intel/intel_soc_dts_iosf.c                              |    2 
 drivers/thermal/qcom/tsens-v0_1.c                                       |   28 
 drivers/thermal/qcom/tsens-v1.c                                         |   61 -
 drivers/thermal/qcom/tsens.c                                            |    3 
 drivers/thermal/qcom/tsens.h                                            |    2 
 drivers/tty/serial/fsl_lpuart.c                                         |   19 
 drivers/tty/serial/imx.c                                                |   69 +
 drivers/tty/serial/serial-tegra.c                                       |    7 
 drivers/ufs/core/ufshcd.c                                               |   20 
 drivers/ufs/host/ufs-exynos.c                                           |    2 
 drivers/usb/early/xhci-dbc.c                                            |    3 
 drivers/usb/gadget/configfs.c                                           |    6 
 drivers/usb/gadget/udc/fotg210-udc.c                                    |   16 
 drivers/usb/gadget/udc/fusb300_udc.c                                    |   10 
 drivers/usb/host/fsl-mph-dr-of.c                                        |    3 
 drivers/usb/host/max3421-hcd.c                                          |    2 
 drivers/usb/musb/mediatek.c                                             |    3 
 drivers/usb/typec/mux/intel_pmc_mux.c                                   |    4 
 drivers/vfio/vfio_iommu_type1.c                                         |  143 ++-
 drivers/video/fbdev/core/fbcon.c                                        |   17 
 drivers/virt/coco/sev-guest/sev-guest.c                                 |   20 
 drivers/xen/grant-dma-iommu.c                                           |   11 
 fs/btrfs/discard.c                                                      |   41 
 fs/btrfs/scrub.c                                                        |   49 -
 fs/ceph/file.c                                                          |    8 
 fs/cifs/cached_dir.c                                                    |   43 
 fs/cifs/cifsacl.c                                                       |   34 
 fs/cifs/cifssmb.c                                                       |   17 
 fs/cifs/connect.c                                                       |   94 --
 fs/cifs/dir.c                                                           |   19 
 fs/cifs/file.c                                                          |   35 
 fs/cifs/inode.c                                                         |   53 -
 fs/cifs/link.c                                                          |   66 -
 fs/cifs/smb1ops.c                                                       |   72 -
 fs/cifs/smb2inode.c                                                     |   17 
 fs/cifs/smb2ops.c                                                       |  204 ++--
 fs/cifs/smb2pdu.c                                                       |  212 +++-
 fs/cifs/smbdirect.c                                                     |    4 
 fs/coda/upcall.c                                                        |    2 
 fs/cramfs/inode.c                                                       |    2 
 fs/dlm/midcomms.c                                                       |   45 
 fs/erofs/fscache.c                                                      |    2 
 fs/exfat/dir.c                                                          |    7 
 fs/exfat/exfat_fs.h                                                     |    2 
 fs/exfat/file.c                                                         |    3 
 fs/exfat/inode.c                                                        |    6 
 fs/exfat/namei.c                                                        |    2 
 fs/exfat/super.c                                                        |    3 
 fs/ext4/xattr.c                                                         |   35 
 fs/f2fs/data.c                                                          |   10 
 fs/f2fs/inline.c                                                        |   13 
 fs/f2fs/inode.c                                                         |   13 
 fs/fuse/ioctl.c                                                         |    6 
 fs/gfs2/aops.c                                                          |    3 
 fs/gfs2/super.c                                                         |    8 
 fs/hfs/bnode.c                                                          |    1 
 fs/hfsplus/super.c                                                      |    4 
 fs/jbd2/transaction.c                                                   |   50 -
 fs/ksmbd/smb2misc.c                                                     |   31 
 fs/ksmbd/smb2pdu.c                                                      |   28 
 fs/ksmbd/vfs_cache.c                                                    |    5 
 fs/nfs/nfs4proc.c                                                       |    4 
 fs/nfs/nfs4trace.h                                                      |   42 
 fs/nfsd/filecache.c                                                     |   44 
 fs/nfsd/nfs4layouts.c                                                   |    4 
 fs/nfsd/nfs4proc.c                                                      |  160 +--
 fs/nfsd/nfs4state.c                                                     |   53 -
 fs/nfsd/nfssvc.c                                                        |    2 
 fs/nfsd/trace.h                                                         |   31 
 fs/nfsd/xdr4.h                                                          |    2 
 fs/ocfs2/move_extents.c                                                 |   34 
 fs/open.c                                                               |    5 
 fs/super.c                                                              |   21 
 fs/udf/file.c                                                           |   26 
 fs/udf/inode.c                                                          |   74 -
 fs/udf/super.c                                                          |    1 
 fs/udf/udf_i.h                                                          |    3 
 fs/udf/udf_sb.h                                                         |    2 
 include/drm/drm_mipi_dsi.h                                              |    4 
 include/drm/drm_print.h                                                 |    2 
 include/linux/blkdev.h                                                  |    1 
 include/linux/bpf.h                                                     |    7 
 include/linux/context_tracking.h                                        |   27 
 include/linux/device.h                                                  |    1 
 include/linux/fwnode.h                                                  |   12 
 include/linux/hid.h                                                     |    1 
 include/linux/ima.h                                                     |    6 
 include/linux/kernel_stat.h                                             |    2 
 include/linux/kobject.h                                                 |    2 
 include/linux/kprobes.h                                                 |    2 
 include/linux/libnvdimm.h                                               |    3 
 include/linux/mlx4/qp.h                                                 |    1 
 include/linux/nfs_ssc.h                                                 |    2 
 include/linux/poison.h                                                  |    3 
 include/linux/rcupdate.h                                                |   11 
 include/linux/rmap.h                                                    |    2 
 include/linux/sbitmap.h                                                 |   16 
 include/linux/transport_class.h                                         |    8 
 include/linux/uaccess.h                                                 |    4 
 include/linux/wait.h                                                    |    2 
 include/net/sock.h                                                      |    7 
 include/sound/hda_codec.h                                               |    1 
 include/sound/soc-dapm.h                                                |    1 
 include/trace/events/devlink.h                                          |    2 
 include/uapi/linux/io_uring.h                                           |    2 
 include/uapi/linux/vfio.h                                               |   15 
 include/ufs/ufshcd.h                                                    |    4 
 io_uring/io_uring.c                                                     |   13 
 io_uring/io_uring.h                                                     |   10 
 io_uring/net.c                                                          |    2 
 io_uring/rsrc.c                                                         |   13 
 kernel/bpf/btf.c                                                        |   13 
 kernel/bpf/hashtab.c                                                    |    4 
 kernel/bpf/memalloc.c                                                   |    2 
 kernel/context_tracking.c                                               |   12 
 kernel/exit.c                                                           |    7 
 kernel/irq/irqdomain.c                                                  |  283 +++---
 kernel/kprobes.c                                                        |   27 
 kernel/locking/lockdep.c                                                |    3 
 kernel/locking/rwsem.c                                                  |   49 -
 kernel/panic.c                                                          |   49 -
 kernel/pid_namespace.c                                                  |   17 
 kernel/power/energy_model.c                                             |    5 
 kernel/rcu/srcutree.c                                                   |    9 
 kernel/rcu/tasks.h                                                      |   77 +
 kernel/rcu/tree_exp.h                                                   |    2 
 kernel/resource.c                                                       |   14 
 kernel/sched/rt.c                                                       |    5 
 kernel/sched/wait.c                                                     |   18 
 kernel/time/clocksource.c                                               |   45 
 kernel/time/hrtimer.c                                                   |    2 
 kernel/time/posix-stubs.c                                               |    2 
 kernel/time/posix-timers.c                                              |    2 
 kernel/time/test_udelay.c                                               |    2 
 kernel/torture.c                                                        |    2 
 kernel/trace/blktrace.c                                                 |    4 
 kernel/trace/ring_buffer.c                                              |   42 
 kernel/trace/trace.c                                                    |    2 
 kernel/workqueue.c                                                      |   41 
 lib/bug.c                                                               |   15 
 lib/errname.c                                                           |   22 
 lib/kobject.c                                                           |   20 
 lib/mpi/mpicoder.c                                                      |    3 
 lib/sbitmap.c                                                           |  157 ---
 mm/damon/paddr.c                                                        |    7 
 mm/huge_memory.c                                                        |    3 
 mm/memcontrol.c                                                         |    4 
 mm/memory-failure.c                                                     |    8 
 mm/memory-tiers.c                                                       |    4 
 mm/rmap.c                                                               |    2 
 net/bluetooth/hci_conn.c                                                |   12 
 net/bluetooth/l2cap_core.c                                              |   24 
 net/bluetooth/l2cap_sock.c                                              |    8 
 net/can/isotp.c                                                         |    3 
 net/core/scm.c                                                          |    2 
 net/core/sock.c                                                         |   15 
 net/ipv4/inet_hashtables.c                                              |   12 
 net/l2tp/l2tp_ppp.c                                                     |  125 +-
 net/mac80211/cfg.c                                                      |   26 
 net/mac80211/ieee80211_i.h                                              |    3 
 net/mac80211/link.c                                                     |    3 
 net/mac80211/rx.c                                                       |   32 
 net/mac80211/sta_info.c                                                 |    2 
 net/mac80211/tx.c                                                       |    2 
 net/netfilter/nf_tables_api.c                                           |    3 
 net/rds/message.c                                                       |    2 
 net/smc/af_smc.c                                                        |    2 
 net/smc/smc_core.c                                                      |   17 
 net/socket.c                                                            |   11 
 net/sunrpc/clnt.c                                                       |    2 
 net/wireless/nl80211.c                                                  |    2 
 net/wireless/sme.c                                                      |   48 -
 net/xdp/xsk.c                                                           |   59 -
 scripts/gcc-plugins/Makefile                                            |    2 
 scripts/package/mkdebian                                                |    2 
 security/integrity/ima/ima_api.c                                        |    2 
 security/integrity/ima/ima_main.c                                       |    9 
 security/security.c                                                     |    7 
 sound/pci/hda/Kconfig                                                   |   14 
 sound/pci/hda/hda_codec.c                                               |   13 
 sound/pci/hda/hda_controller.c                                          |    1 
 sound/pci/hda/hda_controller.h                                          |    1 
 sound/pci/hda/hda_intel.c                                               |    8 
 sound/pci/hda/patch_ca0132.c                                            |    2 
 sound/pci/hda/patch_realtek.c                                           |    1 
 sound/pci/ice1712/aureon.c                                              |    2 
 sound/soc/atmel/mchp-spdifrx.c                                          |  342 ++++---
 sound/soc/codecs/lpass-rx-macro.c                                       |   12 
 sound/soc/codecs/lpass-tx-macro.c                                       |   12 
 sound/soc/codecs/lpass-va-macro.c                                       |   20 
 sound/soc/codecs/lpass-wsa-macro.c                                      |    9 
 sound/soc/codecs/tlv320adcx140.c                                        |    2 
 sound/soc/fsl/fsl_sai.c                                                 |    1 
 sound/soc/kirkwood/kirkwood-dma.c                                       |    2 
 sound/soc/qcom/qdsp6/q6apm-dai.c                                        |   22 
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c                                 |    5 
 sound/soc/sh/rcar/rsnd.h                                                |    4 
 sound/soc/soc-compress.c                                                |   11 
 sound/soc/soc-topology.c                                                |    2 
 tools/bootconfig/scripts/ftrace2bconf.sh                                |    2 
 tools/bpf/bpftool/Makefile                                              |    3 
 tools/bpf/bpftool/prog.c                                                |   38 
 tools/lib/bpf/bpf_tracing.h                                             |    2 
 tools/lib/bpf/btf.c                                                     |   13 
 tools/lib/bpf/nlattr.c                                                  |    2 
 tools/lib/thermal/sampling.c                                            |    2 
 tools/objtool/check.c                                                   |    2 
 tools/perf/Documentation/perf-intel-pt.txt                              |   30 
 tools/perf/builtin-inject.c                                             |    6 
 tools/perf/builtin-record.c                                             |   16 
 tools/perf/perf-completion.sh                                           |   11 
 tools/perf/tests/bpf.c                                                  |    6 
 tools/perf/tests/shell/stat_all_metrics.sh                              |    2 
 tools/perf/util/auxtrace.c                                              |    3 
 tools/perf/util/intel-pt.c                                              |    6 
 tools/perf/util/llvm-utils.c                                            |   25 
 tools/power/x86/intel-speed-select/isst-config.c                        |    2 
 tools/testing/ktest/ktest.pl                                            |   26 
 tools/testing/ktest/sample.conf                                         |    5 
 tools/testing/selftests/Makefile                                        |    4 
 tools/testing/selftests/arm64/abi/syscall-abi.c                         |    8 
 tools/testing/selftests/arm64/fp/Makefile                               |    2 
 tools/testing/selftests/arm64/signal/testcases/ssve_regs.c              |    4 
 tools/testing/selftests/arm64/signal/testcases/za_regs.c                |    4 
 tools/testing/selftests/arm64/tags/Makefile                             |    2 
 tools/testing/selftests/bpf/Makefile                                    |   14 
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c                |    4 
 tools/testing/selftests/bpf/progs/map_kptr.c                            |   12 
 tools/testing/selftests/bpf/progs/test_bpf_nf.c                         |   11 
 tools/testing/selftests/bpf/xdp_synproxy.c                              |    1 
 tools/testing/selftests/bpf/xskxceiver.c                                |   22 
 tools/testing/selftests/clone3/Makefile                                 |    2 
 tools/testing/selftests/core/Makefile                                   |    2 
 tools/testing/selftests/dmabuf-heaps/Makefile                           |    2 
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c                      |    3 
 tools/testing/selftests/drivers/dma-buf/Makefile                        |    2 
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh                |   18 
 tools/testing/selftests/drivers/s390x/uvdevice/Makefile                 |    3 
 tools/testing/selftests/filesystems/Makefile                            |    2 
 tools/testing/selftests/filesystems/binderfs/Makefile                   |    2 
 tools/testing/selftests/filesystems/epoll/Makefile                      |    2 
 tools/testing/selftests/ftrace/test.d/dynevent/eprobes_syntax_errors.tc |    4 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc     |    2 
 tools/testing/selftests/futex/functional/Makefile                       |    2 
 tools/testing/selftests/gpio/Makefile                                   |    2 
 tools/testing/selftests/ipc/Makefile                                    |    2 
 tools/testing/selftests/kcmp/Makefile                                   |    2 
 tools/testing/selftests/landlock/fs_test.c                              |   47 +
 tools/testing/selftests/landlock/ptrace_test.c                          |  113 ++
 tools/testing/selftests/media_tests/Makefile                            |    2 
 tools/testing/selftests/membarrier/Makefile                             |    2 
 tools/testing/selftests/mount_setattr/Makefile                          |    2 
 tools/testing/selftests/move_mount_set_group/Makefile                   |    2 
 tools/testing/selftests/net/fib_tests.sh                                |    2 
 tools/testing/selftests/net/udpgso_bench_rx.c                           |    6 
 tools/testing/selftests/perf_events/Makefile                            |    2 
 tools/testing/selftests/pid_namespace/Makefile                          |    2 
 tools/testing/selftests/pidfd/Makefile                                  |    2 
 tools/testing/selftests/powerpc/ptrace/Makefile                         |    2 
 tools/testing/selftests/powerpc/security/Makefile                       |    2 
 tools/testing/selftests/powerpc/syscalls/Makefile                       |    2 
 tools/testing/selftests/powerpc/tm/Makefile                             |    2 
 tools/testing/selftests/ptp/Makefile                                    |    2 
 tools/testing/selftests/rseq/Makefile                                   |    2 
 tools/testing/selftests/sched/Makefile                                  |    2 
 tools/testing/selftests/seccomp/Makefile                                |    2 
 tools/testing/selftests/sync/Makefile                                   |    2 
 tools/testing/selftests/user_events/Makefile                            |    2 
 tools/testing/selftests/vm/Makefile                                     |    2 
 tools/testing/selftests/x86/Makefile                                    |    2 
 tools/tracing/rtla/src/osnoise_hist.c                                   |    5 
 virt/kvm/coalesced_mmio.c                                               |    8 
 virt/kvm/kvm_main.c                                                     |   31 
 843 files changed, 8135 insertions(+), 4772 deletions(-)

Aaron Ma (1):
      wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read

Abel Vesa (1):
      drm/panel-edp: fix name for IVO product id 854b

Adam Ford (2):
      arm64: dts: renesas: beacon-renesom: Fix gpio expander reference
      media: i2c: imx219: Split common registers from mode tables

Adam Niederer (1):
      ACPI: resource: Add IRQ overrides for MAINGEAR Vector Pro 2 models

Adam Skladowski (1):
      pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins

Akhil P Oommen (1):
      drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()

Al Viro (2):
      alpha/boot/tools/objstrip: fix the check for ELF header
      alpha: fix FEN fault handling

Alex Elder (1):
      net: ipa: generic command param fix

Alexander Aring (3):
      fs: dlm: don't set stop rx flag after node reset
      fs: dlm: move sending fin message into state change handling
      fs: dlm: send FIN ack back in right cases

Alexander Gordeev (2):
      s390/early: fix sclp_early_sccb variable lifetime
      s390/boot: cleanup decompressor header files

Alexander Lobakin (1):
      crypto: octeontx2 - Fix objects shared between several modules

Alexander Mikhalitsyn (1):
      fuse: add inode/permission checks to fileattr_get/fileattr_set

Alexander Stein (1):
      usb: host: fsl-mph-dr-of: reuse device_set_of_node_from_dev

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexandru Matei (1):
      KVM: VMX: Fix crash due to uninitialized current_vmcs

Alexei Starovoitov (1):
      selftests/bpf: Fix map_kptr test.

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alexey V. Vissarionov (2):
      ALSA: hda/ca0132: minor fix for allocation size
      PCI/IOV: Enlarge virtfn sysfs name buffer

Allen Ballway (2):
      HID: multitouch: Add quirks for flipped axes
      drm: panel-orientation-quirks: Add quirk for DynaBook K50

Allen-KH Cheng (2):
      arm64: dts: mediatek: mt7986: Fix watchdog compatible
      dt-bindings: display: mediatek: Fix the fallback for mediatek,mt8186-disp-ccorr

Alok Tiwari (1):
      netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Alper Nebi Yasak (1):
      firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Amadeusz Sławiński (1):
      ASoC: topology: Properly access value coming from topology file

Anders Roxell (1):
      powerpc/mm: Rearrange if-else block to avoid clang warning

Andreas Gruenbacher (2):
      gfs2: jdata writepage fix
      gfs2: Improve gfs2_make_fs_rw error handling

Andreas Kemnade (1):
      power: supply: remove faulty cooling logic

Andreas Ziegler (1):
      tools/tracing/rtla: osnoise_hist: use total duration for average calculation

Andrei Otcheretianski (1):
      wifi: mac80211: Don't translate MLD addresses for multicast

Andrew Davis (1):
      arm64: dts: ti: k3-am62: Enable SPI nodes at the board level

Andrew Morton (1):
      fs/cramfs/inode.c: initialize file_ra_state

Andrii Nakryiko (2):
      libbpf: Fix btf__align_of() by taking into account field offsets
      bpf: Fix global subprog context argument resolution logic

Andy Chiu (1):
      riscv: jump_label: Fixup unaligned arch_static_branch function

Andy Shevchenko (5):
      pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()
      leds: is31fl319x: Wrap mutex_destroy() for devm_add_action_or_rest()
      usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count
      mei: pxp: Use correct macros to initialize uuid_le
      misc/mei/hdcp: Use correct macros to initialize uuid_le

AngeloGioacchino Del Regno (7):
      arm64: dts: mediatek: mt8195: Add power domain to U3PHY1 T-PHY
      arm64: dts: mt8195: Fix CPU map for single-cluster SoC
      arm64: dts: mt8192: Fix CPU map for single-cluster SoC
      arm64: dts: mt8186: Fix CPU map for single-cluster SoC
      arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node
      arm64: dts: mediatek: mt8186: Fix watchdog compatible
      arm64: dts: mediatek: mt8195: Fix watchdog compatible

Angus Chen (1):
      ARM: imx: Call ida_simple_remove() for ida_simple_get

Antonio Alvarez Feijoo (1):
      tools/bootconfig: fix single & used for logical condition

Armin Wolf (2):
      ACPI: battery: Fix missing NUL-termination with large strings
      hwmon: (ftsteutates) Fix scaling of measurements

Arnd Bergmann (9):
      ARM: s3c: fix s3c64xx_set_timer_source prototype
      wifi: mac80211: avoid u32_encode_bits() warning
      spi: dw_bt1: fix MUX_MMIO dependencies
      drm/amdgpu: fix enum odm_combine_mode mismatch
      printf: fix errname.c list
      objtool: add UACCESS exceptions for __tsan_volatile_read/write
      media: camss: csiphy-3ph: avoid undefined behavior
      media: platform: mtk-mdp3: fix Kconfig dependencies
      cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies

Artem Savkov (1):
      selftests/bpf: Use consistent build-id type for liburandom_read.so

Arun Easi (1):
      scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests

Asahi Lina (2):
      drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()
      drm/shmem-helper: Revert accidental non-GPL export

Ashok Raj (3):
      x86/microcode: Add a parameter to microcode_check() to store CPU capabilities
      x86/microcode: Check CPU capabilities after late microcode update correctly
      x86/microcode: Adjust late loading result reporting message

Athira Rajeev (1):
      perf test bpf: Skip test if kernel-debuginfo is not present

Bart Van Assche (1):
      scsi: ufs: exynos: Fix DMA alignment for PAGE_SIZE != 4096

Bastian Germann (1):
      builddeb: clean generated package content

Bastien Nocera (2):
      HID: logitech-hidpp: Hard-code HID++ 1.0 fast scroll support
      HID: logitech-hidpp: Don't restart communication if not necessary

Benjamin Coddington (2):
      nfs4trace: fix state manager flag printing
      nfsd: fix race to check ls_layouts

Bernard Metzler (1):
      RDMA/siw: Fix user page pinning accounting

Bitterblue Smith (2):
      wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU
      wifi: rtl8xxxu: Use a longer retry limit of 48

Bjorn Andersson (3):
      arm64: dts: qcom: sc8280xp: Vote for CX in USB controllers
      rpmsg: glink: Avoid infinite loop on intent for missing channel
      rpmsg: glink: Release driver_override

Bjorn Helgaas (1):
      PCI: switchtec: Return -EFAULT for copy_to_user() errors

Björn Töpel (1):
      riscv, mm: Perform BPF exhandler fixup on page fault

Bob Pearson (1):
      RDMA/rxe: Fix missing memory barriers in rxe_queue.h

Boris Burkov (1):
      btrfs: hold block group refcount during async discard

Borislav Petkov (AMD) (3):
      x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter
      x86/microcode/AMD: Add a @cpu parameter to the reloading functions
      x86/microcode/AMD: Fix mixed steppings support

Brandon Syu (1):
      drm/amd/display: fix mapping to non-allocated address

Breno Leitao (1):
      x86/bugs: Reset speculation control settings on init

Carlo Caione (1):
      drm/tiny: ili9486: Do not assume 8-bit only SPI controllers

Catalin Marinas (1):
      arm64: mm: hugetlb: Disable HUGETLB_PAGE_OPTIMIZE_VMEMMAP

Chen Hui (1):
      ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Chen Zhongjin (1):
      firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle

Chen-Yu Tsai (6):
      arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description
      arm64: dts: mediatek: mt8192: Fix systimer 13 MHz clock description
      arm64: dts: mediatek: mt8195: Fix systimer 13 MHz clock description
      arm64: dts: mediatek: mt8186: Fix systimer 13 MHz clock description
      arm64: dts: mediatek: mt8192: Mark scp_adsp clock as broken
      remoteproc/mtk_scp: Move clk ops outside send_lock

Christian Hewitt (3):
      arm64: dts: meson: remove CPU opps below 1GHz for G12A boards
      arm64: dts: meson: radxa-zero: allow usb otg mode
      arm64: dts: meson: bananapi-m5: switch VDDIO_C pin to OPEN_DRAIN

Christoph Hellwig (1):
      Revert "remoteproc: qcom_q6v5_mss: map/unmap metadata region before/after use"

Christophe JAILLET (6):
      s390/vfio-ap: fix an error handling path in vfio_ap_mdev_probe_queue()
      x86/signal: Fix the value returned by strict_sas_size()
      spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()
      misc: fastrpc: Fix an error handling path in fastrpc_rpmsg_probe()
      usb: early: xhci-dbc: Fix a potential out-of-bound memory access
      ipmi: ipmb: Fix the MODULE_PARM_DESC associated to 'retry_time_ms'

Chuck Lever (1):
      NFSD: copy the whole verifier in nfsd_copy_write_verifier

Chunfeng Yun (1):
      phy: mediatek: remove temporary variable @mask_

Claudiu Beznea (5):
      ASoC: mchp-spdifrx: fix controls which rely on rsr register
      ASoC: mchp-spdifrx: fix return value in case completion times out
      ASoC: mchp-spdifrx: fix controls that works with completion mechanism
      ASoC: mchp-spdifrx: disable all interrupts in mchp_spdifrx_dai_remove()
      pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Conor Dooley (2):
      RISC-V: time: initialize hrtimer based broadcast clock event device
      RISC-V: add a spin_shadow_stack declaration

Corey Minyard (2):
      ipmi:ssif: resend_msg() cannot fail
      ipmi_ssif: Rename idle state and check

D. Wythe (2):
      net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()
      net/smc: fix application data exception

Dai Ngo (3):
      NFSD: enhance inter-server copy cleanup
      NFSD: fix leaked reference count of nfsd4_ssc_umount_item
      NFSD: fix problems with cleanup on errors in nfsd4_copy

Damien Le Moal (2):
      ata: ahci: Revert "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller"
      PCI: Avoid FLR for AMD FCH AHCI adapters

Dan Carpenter (3):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      usb: musb: mediatek: don't unregister something that wasn't registered
      iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()

Dan Williams (2):
      cxl/pmem: Fix nvdimm registration races
      dax/kmem: Fix leak of memory-hotplug resources

Daniel Golle (1):
      regmap: apply reg_base and reg_downshift for single register ops

Daniel Mentz (1):
      drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Daniel T. Lee (2):
      libbpf: Fix invalid return address register in s390
      selftests/bpf: Fix vmtest static compilation error

Daniil Tatianin (1):
      ACPICA: nsrepair: handle cases without a return value correctly

Darrell Kavanagh (1):
      drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5

Dave Stevenson (6):
      drm/vc4: dpi: Fix format mapping for RGB565
      drm/vc4: hvs: Set AXI panic modes
      drm/vc4: hvs: SCALER_DISPBKGND_AUTOHS is only valid on HVS4
      drm/vc4: hvs: Correct interrupt masking bit assignment for HVS5
      drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5
      drm/vc4: hdmi: Correct interlaced timings again

Dave Thaler (1):
      bpf, docs: Fix modulo zero, division by zero, overflow, and underflow

David Lamparter (1):
      io_uring: remove MSG_NOSIGNAL from recvmsg

David Rientjes (1):
      crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2

Denis Kenzior (1):
      KEYS: asymmetric: Fix ECDSA use via keyctl uapi

Denis Pauk (2):
      hwmon: (nct6775) Directly call ASUS ACPI WMI method
      hwmon: (nct6775) B650/B660/X670 ASUS boards support

Deren Wu (3):
      wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host
      wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()
      wifi: mt76: add memory barrier to SDIO queue kick

Dhruva Gole (1):
      arm64: dts: ti: k3-am62-main: Fix clocks for McSPI

Dillon Varone (1):
      drm/amd/display: Reduce expected sdp bandwidth for dcn321

Dmitry Baryshkov (17):
      arm64: dts: qcom: qcs404: use symbol names for PCIe resets
      arm64: dts: qcom: msm8996: support using GPLL0 as kryocc input
      arm64: dts: qcom: msm8996 switch from RPM_SMD_BB_CLK1 to RPM_SMD_XO_CLK_SRC
      thermal/drivers/tsens: Drop msm8976-specific defines
      thermal/drivers/tsens: Sort out msm8976 vs msm8956 data
      thermal/drivers/tsens: fix slope values for msm8939
      thermal/drivers/tsens: limit num_sensors to 9 for msm8939
      drm/msm: clean event_thread->worker in case of an error
      drm/bridge: lt9611: fix sleep mode setup
      drm/bridge: lt9611: fix HPD reenablement
      drm/bridge: lt9611: fix polarity programming
      drm/bridge: lt9611: fix programming of video modes
      drm/bridge: lt9611: fix clock calculation
      drm/bridge: lt9611: pass a pointer to the of node
      drm/msm/dpu: sc7180: add missing WB2 clock control
      drm/msm: use strscpy instead of strncpy
      drm/msm/dpu: set pdpu->is_rt_pipe early in dpu_plane_sspp_atomic_update()

Dmitry Fomin (1):
      ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Dmitry Goncharov (1):
      kbuild: Port silent mode detection to future gnu make.

Dmitry Torokhov (1):
      HID: retain initial quirks set up when creating HID devices

Dominik Kobinski (1):
      arm64: dts: msm8992-bullhead: add memory hole region

Dong Chuanjian (1):
      media: drivers/media/v4l2-core/v4l2-h264 : add detection of null pointers

Dongliang Mu (1):
      fs: hfsplus: fix UAF issue in hfsplus_put_super

Doug Berger (1):
      net: bcmgenet: fix MoCA LED control

Duoming Zhou (3):
      Revert "char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol"
      media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
      media: usb: siano: Fix use after free bugs caused by do_submit_urb

Elvira Khabirova (1):
      mips: fix syscall_get_nr

Eric Biggers (3):
      crypto: x86/ghash - fix unaligned access in ghash_setkey()
      f2fs: fix information leak in f2fs_move_inline_dirents()
      f2fs: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (1):
      scm: add user copy checks to put_cmsg()

Eric Pilmore (1):
      dmaengine: ptdma: check for null desc before calling pt_cmd_callback

Eugene Shalygin (1):
      hwmon: (asus-ec-sensors) add missing mutex path

Fabian Vogt (1):
      fotg210-udc: Add missing completion handler

Fedor Pchelkin (2):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Feng Tang (1):
      clocksource: Suspend the watchdog temporarily when high read latency detected

Fenghua Yu (1):
      dmaengine: idxd: Set traffic class values in GRPCFG on DSA 2.0

Ferry Toth (1):
      iio: light: tsl2563: Do not hardcode interrupt trigger type

Florian Fainelli (3):
      irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
      irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
      net: bcmgenet: Add a check for oversized packets

Frank Jungclaus (2):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
      can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL

Frank Li (1):
      PCI: endpoint: pci-epf-vntb: Clean up kernel_doc warning

Frederic Weisbecker (3):
      rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose
      rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls
      rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()

Frieder Schrempf (1):
      drm/bridge: ti-sn65dsi83: Fix delay after reset deassert to match spec

Gabriel Krisman Bertazi (4):
      sbitmap: Use single per-bitmap counting to wake up queued tags
      sbitmap: Advance the queue index before waking up a queue
      wait: Return number of exclusive waiters awaken
      sbitmap: Try each queue to wake up at least one waiter

Gaosheng Cui (2):
      usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()
      media: ti: cal: fix possible memory leak in cal_ctx_create()

Gavrilov Ilia (1):
      iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Geert Uytterhoeven (6):
      can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
      drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats
      drm: mxsfb: DRM_IMX_LCDIF should depend on ARCH_MXC
      drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
      dmaengine: HISI_DMA should depend on ARCH_HISI
      PCI: Fix dropping valid root bus resources with .end = zero

George Kennedy (1):
      VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Gerald Schaefer (1):
      s390/extmem: return correct segment type in __segment_load()

Giovanni Cabiddu (1):
      crypto: qat - fix out-of-bounds read

Greg Kroah-Hartman (7):
      kobject: modify kobject_get_path() to take a const *
      trace/blktrace: fix memory leak with using debugfs_lookup()
      time/debug: Fix memory leak with using debugfs_lookup()
      PM: domains: fix memory leak with using debugfs_lookup()
      PM: EM: fix memory leak with using debugfs_lookup()
      scsi: snic: Fix memory leak with using debugfs_lookup()
      Linux 6.1.16

Gregory Greenman (1):
      wifi: iwlwifi: mei: fix compilation errors in rfkill()

Guilherme G. Piccoli (1):
      panic: fix the panic_print NMI backtrace setting

Guillaume Tucker (2):
      selftests: find echo binary to use -ne options
      selftests: use printf instead of echo -ne

Guo Ren (2):
      riscv: ftrace: Remove wasted nops for !RISCV_ISA_C
      riscv: ftrace: Reduce the detour code size to half

Guodong Liu (2):
      pinctrl: mediatek: Initialize variable pullen and pullup to zero
      pinctrl: mediatek: Initialize variable *buf to zero

H. Nikolaus Schaller (1):
      MIPS: DTS: CI20: fix otg power gpio

Haibo Chen (1):
      gpio: vf610: connect GPIO label to dev name

Halil Pasic (3):
      s390: vfio-ap: tighten the NIB validity check
      s390/ap: fix status returned by ap_aqic()
      s390/ap: fix status returned by ap_qact()

Hamza Mahfooz (1):
      drm/amd/display: don't call dc_interrupt_set() for disabled crtcs

Hangyu Hua (1):
      ksmbd: fix possible memory leak in smb2_lock()

Hanjun Guo (1):
      driver core: location: Free struct acpi_pld_info *pld before return false

Hanna Hawa (1):
      i2c: designware: fix i2c_dw_clk_rate() return size to be u32

Hans Verkuil (2):
      media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()
      media: i2c: ov7670: 0 instead of -EINVAL was returned

Hans de Goede (4):
      leds: led-class: Add missing put_device() to led_put()
      media: atomisp: Only set default_run_mode on first open of a stream/asd
      ACPI: video: Fix Lenovo Ideapad Z570 DMI match
      drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Tab 3 X90F

Hector Martin (2):
      iommu: dart: Add suspend/resume support
      iommu: dart: Support >64 stream IDs

Heiko Carstens (2):
      s390/idle: mark arch_cpu_idle() noinstr
      s390/kfence: fix page fault reporting

Heming Zhao via Ocfs2-devel (2):
      ocfs2: fix defrag path triggering jbd2 ASSERT
      ocfs2: fix non-auto defrag path not working issue

Hengqi Chen (1):
      LoongArch, bpf: Use 4 instructions for function address in JIT

Henning Schild (1):
      leds: simatic-ipc-leds-gpio: Make sure we have the GPIO providing driver

Herbert Xu (6):
      lib/mpi: Fix buffer overrun when SG is too long
      crypto: essiv - Handle EBUSY correctly
      crypto: seqiv - Handle EBUSY correctly
      crypto: xts - Handle EBUSY correctly
      crypto: rsa-pkcs1pad - Use akcipher_request_complete
      crypto: crypto4xx - Call dma_unmap_page when done

Holger Hoffstätte (1):
      bpftool: Always disable stack protection for BPF objects

Horatiu Vultur (1):
      net: lan966x: Fix possible deadlock inside PTP

Hou Tao (2):
      bpf: Zeroing allocated object from slab in bpf memory allocator
      md: don't update recovery_cp when curr_resync is ACTIVE

Howard Hsu (1):
      wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work

Hui Tang (1):
      drm/msm/dpu: check for null return of devm_kzalloc() in dpu_writeback_init()

Ian Chen (1):
      drm/amd/display: Revert Reduce delay when sink device not able to ACK 00340h write

Ian Rogers (1):
      perf llvm: Fix inadvertent file creation

Ilya Dryomov (1):
      rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Ilya Leoshkevich (6):
      s390/bpf: Add expoline to tail calls
      selftests/bpf: Initialize tc in xdp_synproxy
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
      selftests/bpf: Fix out-of-srctree build
      selftests/bpf: Fix xdp_do_redirect on s390x
      s390: discard .interp section

Ivan Bornyakov (2):
      fpga: microchip-spi: move SPI I/O buffers out of stack
      fpga: microchip-spi: rewrite status polling in a time measurable way

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Jacob Pan (2):
      iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
      iommu/vt-d: Fix PASID directory pointer coherency

Jaegeuk Kim (2):
      f2fs: retry to update the inode page given data corruption
      f2fs: fix kernel crash due to null io->bio

Jagan Teki (1):
      drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags

Jai Luthra (3):
      media: ov5640: Fix soft reset sequence and timings
      media: ov5640: Handle delays when no reset_gpio set
      media: i2c: imx219: Fix binning for RAW8 capture

Jakob Koschel (1):
      docs/scripts/gdb: add necessary make scripts_gdb step

Jakub Sitnicki (1):
      selftests/net: Interpret UDP_GRO cmsg data as an int value

James Bottomley (1):
      scsi: ses: Don't attach if enclosure has no components

James Clark (1):
      coresight: cti: Prevent negative values of enable count

Jamie Douglass (1):
      arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions

Jan Kara (7):
      udf: Define EFSCORRUPTED error code
      udf: Truncate added extents on failed expansion
      udf: Do not bother merging very long extents
      udf: Do not update file length for failed writes to inline files
      udf: Preserve link count of system files
      udf: Detect system inodes linked into directory hierarchy
      udf: Fix file corruption when appending just after end of preallocated extent

Jani Nikula (2):
      drm/edid: fix AVI infoframe aspect ratio handling
      drm/edid: fix parsing of 3D modes from HDMI VSDB

Jann Horn (2):
      fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are detected
      timers: Prevent union confusion from unexpected restart_syscall()

Jaroslav Kysela (1):
      ALSA: hda: Fix the control element identification for multiple codecs

Jason Gunthorpe (1):
      iommu: Fix error unwind in iommu_group_alloc()

Jeff Layton (5):
      nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
      nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open
      nfsd: don't fsync nfsd_files on last close
      nfsd: zero out pointers after putting nfsd_files on COPY setup error
      nfsd: don't hand out delegation on setuid files being opened for write

Jeff Xu (2):
      selftests/landlock: Skip overlayfs tests when not supported
      selftests/landlock: Test ptrace as much as possible with Yama

Jens Axboe (12):
      block: use proper return value from bio_failfast()
      x86/fpu: Don't set TIF_NEED_FPU_LOAD for PF_IO_WORKER threads
      block: don't allow multiple bios for IOCB_NOWAIT issue
      block: clear bio->bi_bdev when putting a bio back in the cache
      block: be a bit more careful in checking for NULL bdev while polling
      io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
      io_uring: add a conditional reschedule to the IOPOLL cancelation loop
      io_uring: add reschedule point to handle_tw_list()
      io_uring: mark task TASK_RUNNING before handling resume/task work
      brd: mark as nowait compatible
      brd: return 0/-error from brd_insert_page()
      brd: check for REQ_NOWAIT and set correct page allocation mask

Jerome Brunet (1):
      ASoC: dt-bindings: meson: fix gx-card codec node regex

Jerome Neanne (1):
      regulator: tps65219: use generic set_bypass()

Jesse Brandeburg (1):
      ice: add missing checks for PF vsi type

Jiasheng Jiang (11):
      wifi: rtw89: Add missing check for alloc_workqueue
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()
      drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
      drm/msm/gem: Add check for kmalloc
      drm/msm/dpu: Add check for cstate
      drm/msm/dpu: Add check for pstates
      drm/msm/mdp5: Add check for kzalloc
      scsi: aic94xx: Add missing check for dma_map_single()
      media: platform: ti: Add missing check for devm_regulator_get
      drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Jingbo Xu (1):
      erofs: relinquish volume with mutex held

Jingyuan Liang (1):
      HID: Add Mapping for System Microphone Mute

Jinke Han (1):
      block: Fix io statistics for cgroup in throttle path

Jiri Pirko (1):
      sefltests: netdevsim: wait for devlink instance after netns removal

Jisoo Jang (3):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds
      wifi: mt7601u: fix an integer underflow

Joe Thornber (1):
      dm cache: free background tracker's queued work in btracker_destroy

Joel Fernandes (Google) (1):
      torture: Fix hang during kthread shutdown phase

Johan Hovold (8):
      PCI: qcom: Fix host-init error handling
      rtc: pm8xxx: fix set-alarm race
      irqdomain: Fix association race
      irqdomain: Fix disassociation race
      irqdomain: Look for existing mapping only once
      irqdomain: Drop bogus fwspec-mapping error handling
      irqdomain: Refactor __irq_domain_alloc_irqs()
      irqdomain: Fix mapping-creation race

Johannes Berg (2):
      wifi: mac80211: fix off-by-one link setting
      wifi: mac80211: pass 'sta' to ieee80211_rx_data_set_sta()

Johannes Weiner (1):
      mm: memcontrol: deprecate charge moving

John Harrison (2):
      drm/i915: Don't use stolen memory for ring buffers with LLC
      drm/i915: Don't use BAR mappings for ring buffers with LLC

John Ogness (1):
      docs: gdbmacros: print newest record

Jonathan Cormier (1):
      hwmon: (ltc2945) Handle error case in ltc2945_value_store

Joseph Qi (1):
      io_uring: fix fget leak when fs don't support nowait buffered read

José Expósito (4):
      HID: uclogic: Add frame type quirk
      HID: uclogic: Add battery quirk
      HID: uclogic: Add support for XP-PEN Deco Pro SW
      HID: uclogic: Add support for XP-PEN Deco Pro MW

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Jun Nie (2):
      ext4: optimize ea_inode block expansion
      ext4: refuse to create ea block when umounted

Junhao He (1):
      coresight: etm4x: Fix accesses to TRCSEQRSTEVR and TRCSEQSTR

Justin Tee (1):
      scsi: lpfc: Fix use-after-free KFENCE violation during sysfs firmware write

KP Singh (2):
      x86/speculation: Allow enabling STIBP with legacy IBRS
      Documentation/hw-vuln: Document the interaction between IBRS and STIBP

Kajol Jain (1):
      perf tests stat_all_metrics: Change true workload to sleep workload for system wide check

Kalle Valo (1):
      wifi: ath11k: debugfs: fix to work with multiple PCI devices

Kan Liang (2):
      perf/x86/intel/ds: Fix the conversion from TSC to perf time
      perf/x86/intel/uncore: Add Meteor Lake support

Karthikeyan Periyasamy (1):
      wifi: mac80211: fix non-MLO station association

Kees Cook (11):
      Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds
      net/mlx4_en: Introduce flexible array to silence overflow warning
      dmaengine: dw-axi-dmac: Do not dereference NULL structure
      crypto: hisilicon: Wipe entire pool on error
      coda: Avoid partial allocation of sig_inputArgs
      uaccess: Add minimum bounds check on kernel buffer size
      ASoC: kirkwood: Iterate over array indexes instead of using pointer math
      regulator: max77802: Bounds check regulator id against opmode
      regulator: s5m8767: Bounds check id indexing into arrays
      io_uring: Replace 0-length array with flexible array
      scsi: aacraid: Allocate cmd_priv with scsicmd

Kemeng Shi (7):
      sbitmap: remove redundant check in __sbitmap_queue_get_batch
      sbitmap: correct wake_batch recalculation to avoid potential IO hung
      blk-mq: avoid sleep in blk_mq_alloc_request_hctx
      blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
      blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait
      blk-mq: Fix potential io hung for shared sbitmap per tagset
      blk-mq: correct stale comment of .get_budget

Kishon Vijay Abraham I (1):
      x86/acpi/boot: Do not register processors that cannot be onlined for x2APIC

Koba Ko (1):
      crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Konrad Dybcio (7):
      arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up
      arm64: dts: qcom: sm6350: Fix up the ramoops node
      arm64: dts: qcom: msm8992-*: Fix up comments
      arm64: dts: qcom: pmk8350: Specify PBS register for PON
      arm64: dts: qcom: pmk8350: Use the correct PON compatible
      drm/msm/dsi: Allow 2 CTRLs on v2.5.0
      arm64: dts: qcom: msm8996: Add additional A2NoC clocks

Konstantin Meskhidze (1):
      drm: amd: display: Fix memory leakage

Krzysztof Kozlowski (15):
      arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name
      arm64: dts: qcom: sc7180: correct SPMI bus address cells
      arm64: dts: qcom: sc7280: correct SPMI bus address cells
      arm64: dts: qcom: sc8280xp: correct SPMI bus address cells
      ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
      arm64: dts: qcom: sm8350: drop incorrect cells from serial
      arm64: dts: qcom: sm8450: drop incorrect cells from serial
      arm64: dts: qcom: msm8953: correct TLMM gpio-ranges
      ARM: dts: exynos: correct HDMI phy compatible in Exynos4
      ARM: dts: exynos: correct TMU phandle in Exynos4210
      ARM: dts: exynos: correct TMU phandle in Exynos4
      ARM: dts: exynos: correct TMU phandle in Odroid XU3 family
      ARM: dts: exynos: correct TMU phandle in Exynos5250
      ARM: dts: exynos: correct TMU phandle in Odroid XU
      ARM: dts: exynos: correct TMU phandle in Odroid HC1

Kuninori Morimoto (2):
      ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()
      ASoC: rsnd: fixup #endif position

Lad Prabhakar (1):
      pinctrl: renesas: rzg2l: Fix configuring the GPIO pins as interrupts

Lai Jiangshan (1):
      workqueue: Protects wq_unbound_cpumask with wq_pool_attach_mutex

Laurent Pinchart (1):
      media: mc: Get media_device directly from pad

Len Brown (1):
      wifi: ath11k: allow system suspend to survive ath11k

Leo Liu (1):
      drm/amdgpu: Use the sched from entity for amdgpu_cs trace

Li Nan (1):
      blk-iocost: fix divide by 0 error in calc_lcoefs()

Li Zetao (1):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Liang He (2):
      gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
      ARM: OMAP2+: omap4-common: Fix refcount leak bug

Liu Shixin (1):
      hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Liu Xiaodong (1):
      block: ublk: check IO buffer based on flag need_get_data

Liwei Song (1):
      drm/radeon: free iio for atombios when driver shutdown

Lorenzo Bianconi (3):
      wifi: mt76: mt7915: fix memory leak in mt7915_mcu_exit
      wifi: mac80211: move color collision detection report in a delayed work
      wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup

Louis Rannou (1):
      mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type

Lu Baolu (2):
      iommu/vt-d: Set No Execute Enable bit in PASID table entry
      iommu/vt-d: Fix error handling in sva enable/disable paths

Lucas Tanure (1):
      ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix potential user-after-free

Lukas Wunner (4):
      PCI/PM: Observe reset delay irrespective of bridge_d3
      PCI: Unify delay handling for reset and resume
      PCI: hotplug: Allow marking devices as disconnected during bind/unbind
      PCI/DPC: Await readiness of secondary bus after reset

Maciej Fijalkowski (1):
      xsk: check IFF_UP earlier in Tx path

Magnus Karlsson (2):
      selftests/xsk: print correct payload for packet dump
      selftests/xsk: print correct error codes when exiting

Manish Chopra (1):
      qede: fix interrupt coalescing configuration

Manivannan Sadhasivam (5):
      ARM: dts: qcom: sdx65: Add Qcom SMMU-500 as the fallback for IOMMU node
      ARM: dts: qcom: sdx55: Add Qcom SMMU-500 as the fallback for IOMMU node
      bus: mhi: ep: Only send -ENOTCONN status if client driver is available
      bus: mhi: ep: Move chan->lock to the start of processing queued ch ring
      bus: mhi: ep: Save channel state locally during suspend and resume

Mao Jinlong (1):
      coresight: cti: Add PM runtime call in enable_store

Marc Bornand (1):
      wifi: cfg80211: Set SSID if it is not already set

Marc Zyngier (1):
      irqdomain: Fix domain registration race

Marcel Holtmann (1):
      Bluetooth: Fix issue with Actions Semi ATS2851 based devices

Marek Vasut (3):
      arm64: dts: imx8m: Align SoC unique ID node unit address
      drm/bridge: tc358767: Set default CLRSIPO count
      tty: serial: imx: Handle RS485 DE signal active high

Marijn Suijten (5):
      arm64: dts: qcom: sm8150-kumano: Panel framebuffer is 2.5k instead of 4k
      arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings
      arm64: dts: qcom: sm6125-seine: Clean up gpio-keys (volume down)
      drm/msm/dpu: Disallow unallocated resources to be returned
      drm/msm/dpu: Add DSC hardware blocks to register snapshot

Mario Limonciello (5):
      ACPICA: Drop port I/O validation for some regions
      Bluetooth: btusb: Add new PID/VID 0489:e0f2 for MT7921
      drm/amd: Avoid BUG() for case of SRIOV missing IP version
      drm/amd: Avoid ASSERT for some message failures
      drm/amd: Fix initialization for nbio 7.5.1

Mark Brown (3):
      arm64/cpufeature: Fix field sign for DIT hwcap detection
      kselftest/arm64: Fix syscall-abi for systems without 128 bit SME
      kselftest/arm64: Fix enumeration of systems without 128 bit SME

Mark Hawrylak (1):
      drm/radeon: Fix eDP for single-display iMac11,2

Mark Rutland (2):
      cpuidle: drivers: firmware: psci: Dont instrument suspend code
      ACPI: Don't build ACPICA with '-Os'

Mark Tomlinson (1):
      usb: max-3421: Fix setting of I/O pins

Markuss Broks (1):
      ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Martin Blumenstingl (6):
      arm64: dts: meson-gxl: jethub-j80: Fix WiFi MAC address node
      arm64: dts: meson-gxl: jethub-j80: Fix Bluetooth MAC node name
      arm64: dts: meson-axg: jethub-j1xx: Fix MAC address node names
      arm64: dts: meson-gx: Fix Ethernet MAC address unit name
      arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
      arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin K. Petersen (1):
      block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Masami Hiramatsu (Google) (4):
      selftests/ftrace: Fix bash specific "==" operator
      selftests/ftrace: Fix eprobe syntax test case to check filter support
      kprobes: Fix to handle forcibly unoptimized kprobes on freeing_list
      tracing/eprobe: Fix to add filter on eprobe description in README file

Mason Zhang (1):
      scsi: ufs: core: Fix device management cmd timeout flow

Mathieu Desnoyers (26):
      selftests: x86: Fix incorrect kernel headers search path
      selftests/powerpc: Fix incorrect kernel headers search path
      selftests: sched: Fix incorrect kernel headers search path
      selftests: core: Fix incorrect kernel headers search path
      selftests: pid_namespace: Fix incorrect kernel headers search path
      selftests: arm64: Fix incorrect kernel headers search path
      selftests: clone3: Fix incorrect kernel headers search path
      selftests: pidfd: Fix incorrect kernel headers search path
      selftests: membarrier: Fix incorrect kernel headers search path
      selftests: kcmp: Fix incorrect kernel headers search path
      selftests: media_tests: Fix incorrect kernel headers search path
      selftests: gpio: Fix incorrect kernel headers search path
      selftests: filesystems: Fix incorrect kernel headers search path
      selftests: user_events: Fix incorrect kernel headers search path
      selftests: ptp: Fix incorrect kernel headers search path
      selftests: sync: Fix incorrect kernel headers search path
      selftests: rseq: Fix incorrect kernel headers search path
      selftests: move_mount_set_group: Fix incorrect kernel headers search path
      selftests: mount_setattr: Fix incorrect kernel headers search path
      selftests: perf_events: Fix incorrect kernel headers search path
      selftests: ipc: Fix incorrect kernel headers search path
      selftests: futex: Fix incorrect kernel headers search path
      selftests: drivers: Fix incorrect kernel headers search path
      selftests: dmabuf-heaps: Fix incorrect kernel headers search path
      selftests: vm: Fix incorrect kernel headers search path
      selftests: seccomp: Fix incorrect kernel headers search path

Matt Bobrowski (1):
      ima: fix error handling logic when file measurement failed

Matt Evans (1):
      clocksource/drivers/riscv: Patch riscv_clock_next_event() jump before first use

Matthias Kaehlcke (1):
      regulator: core: Use ktime_get_boottime() to determine how long a regulator was off

Mattias Nissler (1):
      riscv: Avoid enabling interrupts in die()

Mavroudis Chatzilaridis (1):
      drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Maíra Canal (1):
      drm/vc4: drop all currently held locks if deadlock happens

Miaoqian Lin (10):
      wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
      irqchip: Fix refcount leak in platform_irqchip_probe
      irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
      irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
      irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe
      pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain
      pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
      leds: led-core: Fix refcount leak in of_led_get()
      RDMA/erdma: Fix refcount leak in erdma_mmap
      RDMA/hns: Fix refcount leak in hns_roce_mmap

Michael Grzeschik (1):
      arm64: zynqmp: Enable hs termination flag for USB dwc3 controller

Michael Kelley (1):
      hv_netvsc: Check status in SEND_RNDIS_PKT completion message

Michael Schmitz (1):
      m68k: Check syscall_trace_enter() return code

Michal Schmidt (1):
      qede: avoid uninitialized entries in coal_entry array

Mike Snitzer (5):
      dm: improve shrinker debug names
      dm: remove flush_scheduled_work() during local_exit()
      dm thin: add cond_resched() to various workqueue loops
      dm cache: add cond_resched() to various workqueue loops
      dm: add cond_resched() to dm_wq_requeue_work()

Mikko Perttunen (3):
      gpu: host1x: Fix mask for syncpoint increment register
      gpu: host1x: Don't skip assigning syncpoints to channels
      drm/tegra: firewall: Check for is_addr_reg existence in IMM check

Mikulas Patocka (4):
      dm: send just one event on resize, not two
      dm flakey: fix logic when corrupting a bio
      dm flakey: don't corrupt the zero page
      dm flakey: fix a bug with 32-bit highmem systems

Miles Chen (1):
      drm/mediatek: Use NULL instead of 0 for NULL pointer

Ming Lei (3):
      ublk_drv: remove nr_aborted_queues from ublk_device
      ublk_drv: don't probe partitions if the ubq daemon isn't trusted
      block: sync mixed merged request's failfast with 1st bio's

Ming Qian (4):
      media: v4l2-jpeg: correct the skip count in jpeg_parse_app14_data
      media: v4l2-jpeg: ignore the unknown APP14 marker
      media: imx-jpeg: Apply clk_bulk api instead of operating specific clk
      media: amphion: correct the unspecified color space

Minsuk Kang (2):
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()
      wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()

Moises Cardona (1):
      Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Moshe Shemesh (1):
      devlink: Fix TP_STRUCT_entry in trace of devlink health report

Moti Haimovski (1):
      habanalabs: extend fatal messages to contain PCI info

Moudy Ho (1):
      media: platform: mtk-mdp3: remove unused VIDEO_MEDIATEK_VPU config

Mukesh Ojha (1):
      ring-buffer: Handle race between rb_move_tail and rb_check_pages

Mustafa Ismail (1):
      RDMA/irdma: Cap MSIX used to online CPUs + 1

Nagarajan Maran (1):
      wifi: ath11k: fix monitor mode bringup crash

Namhyung Kim (2):
      perf inject: Use perf_data__read() for auxtrace
      perf intel-pt: Do not try to queue auxtrace data on pipe

Namjae Jeon (2):
      ksmbd: fix wrong data area length for smb2 lock request
      ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length

Naoya Horiguchi (1):
      mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON

Nathan Chancellor (3):
      ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()
      powerpc: Remove linker flag from KBUILD_AFLAGS
      s390/vdso: Drop '-shared' from KBUILD_CFLAGS_64

Neil Armstrong (14):
      arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
      arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix supply name of USB controller node
      arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property
      arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
      arm64: dts: amlogic: meson-gxl-s905w-jethome-jethub-j80: fix invalid rtc node name
      arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix invalid rtc node name
      arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name
      arm64: dts: amlogic: meson-gx-libretech-pc: fix update button name
      arm64: dts: amlogic: meson-sm1-bananapi-m5: fix adc keys node names
      arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name
      arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name
      arm64: dts: amlogic: meson-sm1-odroid-hc4: fix active fan thermal trip

NeilBrown (1):
      NFS: fix disabling of swap

Neill Kapron (1):
      phy: rockchip-typec: fix tcphy_get_mode error case

Nicholas Kazlauskas (3):
      drm/amd/display: Defer DIG FIFO disable after VID stream enable
      drm/amd/display: Enable P-state validation checks for DCN314
      drm/amd/display: Disable HUBP/DPP PG on DCN314 for now

Nicholas Piggin (1):
      exit: Detect and fix irq disabled state in oops

Nico Boehr (1):
      KVM: s390: disable migration mode when dirty tracking is disabled

Nicolas Dufresne (1):
      media: hantro: Fix JPEG encoder ENUM_FRMSIZE on RK3399

Nikita Zhandarovich (2):
      RDMA/cxgb4: add null-ptr-check after ip_dev_find()
      RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()

Noralf Trønnes (1):
      drm/gud: Fix UBSAN warning

Nícolas F. R. A. Prado (1):
      drm/mediatek: Clean dangling pointer on bind error path

Oleksandr Tyshchenko (1):
      xen/grant-dma-iommu: Implement a dummy probe_device() callback

Oliver Hartkopp (1):
      can: isotp: check CAN address family in isotp_bind()

Orlando Chamberlain (1):
      ALSA: hda/hdmi: Register with vga_switcheroo on Dual GPU Macbooks

Pankaj Raghav (1):
      brd: use radix_tree_maybe_preload instead of radix_tree_preload

Patrick Delaunay (1):
      ARM: dts: stm32: Update part number NVMEM description on stm32mp131

Patrick Kelsey (2):
      IB/hfi1: Fix math bugs in hfi1_can_pin_pages()
      IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors

Paul E. McKenney (2):
      rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks
      rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Paulo Alcantara (2):
      cifs: prevent data race in smb2_reconnect()
      cifs: fix mount on old smb servers

Pavel Begunkov (2):
      io_uring: use user visible tail in io_uring_poll()
      io_uring/rsrc: disallow multi-source reg buffers

Peng Fan (2):
      ARM: dts: imx7s: correct iomuxc gpr mux controller cells
      tty: serial: imx: disable Ageing Timer interrupt request irq

Peter Gonda (1):
      KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

Peter Zijlstra (4):
      cpuidle, intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE *again*
      context_tracking: Fix noinstr vs KASAN
      cpuidle, intel_idle: Fix CPUIDLE_FLAG_INIT_XSTATE
      cpuidle: lib/bug: Disable rcu_is_watching() during WARN/BUG

Petr Vorel (3):
      arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size
      arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem
      arm64: dts: qcom: msm8992-lg-bullhead: Enable regulators

Philip Yang (1):
      drm/amdkfd: Page aligned memory reserve size

Pietro Borrello (12):
      HID: asus: use spinlock to protect concurrent accesses
      HID: asus: use spinlock to safely schedule workers
      sched/rt: pick_next_rt_entity(): check list_entry
      net: add sock_init_data_uid()
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid
      rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
      HID: bigben: use spinlock to protect concurrent accesses
      HID: bigben_worker() remove unneeded check on report_field
      HID: bigben: use spinlock to safely schedule workers
      hid: bigben_probe(): validate report count
      inet: fix fast path in __inet_hash_connect()

Ping-Ke Shih (3):
      wifi: rtw89: 8852c: rfk: correct DACK setting
      wifi: rtw89: 8852c: rfk: correct DPK settings
      wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice

Pingfan Liu (2):
      srcu: Delegate work to the boot cpu if using SRCU_SIZE_SMALL
      dm: add cond_resched() to dm_wq_work()

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Update port DP VDO

Qi Zheng (1):
      OPP: fix error checking in opp_migrate_dentry()

Qiheng Lin (4):
      ARM: zynq: Fix refcount leak in zynq_early_slcr_init
      s390/dasd: Fix potential memleak in dasd_eckd_init()
      mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()
      media: platform: mtk-mdp3: Fix return value check in mdp_probe()

Qu Wenruo (1):
      btrfs: scrub: improve tree block error reporting

Quinn Tran (6):
      scsi: qla2xxx: Fix exchange oversubscription
      scsi: qla2xxx: Fix exchange oversubscription for management commands
      scsi: qla2xxx: edif: Fix clang warning
      scsi: qla2xxx: Fix link failure in NPIV environment
      scsi: qla2xxx: Remove unintended flag clearing
      scsi: qla2xxx: Fix erroneous link down

Randolph Sapp (1):
      drm: tidss: Fix pixel format definition

Randy Dunlap (5):
      m68k: /proc/hardware should depend on PROC_FS
      regulator: tps65219: use IS_ERR() to detect an error pointer
      sparc: allow PM configs for sparc32 COMPILE_TEST
      mfd: cs5535: Don't build on UML
      KVM: SVM: hyper-v: placate modpost section mismatch error

Ricardo Ribalda (3):
      media: uvcvideo: Implement mask for V4L2_CTRL_TYPE_MENU
      media: uvcvideo: Refactor uvc_ctrl_mappings_uvcXX
      media: uvcvideo: Refactor power_line_frequency_controls_limited

Richard Fitzgerald (1):
      soundwire: cadence: Don't overflow the command FIFOs

Rob Clark (1):
      drm/mediatek: Drop unbalanced obj unref

Robert Marko (6):
      arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names
      arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY
      arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY
      arm64: dts: qcom: ipq8074: correct Gen2 PCIe ranges
      arm64: dts: qcom: ipq8074: fix Gen3 PCIe node
      arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names

Roberto Sassu (1):
      ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Robin Murphy (1):
      hwmon: (coretemp) Simplify platform device handling

Roman Li (2):
      drm/amd/display: Fix potential null-deref in dm_resume
      drm/amd/display: Set hvm_enabled flag for S/G mode

Ronnie Sahlberg (2):
      cifs: Check the lease context if we actually got a lease
      cifs: return a single-use cfid if we did not get a lease

Roxana Nicolescu (1):
      selftest: fib_tests: Always cleanup before exit

Ryder Lee (4):
      wifi: mt76: mt7915: check return value before accessing free_block_num
      wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()
      wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()
      wifi: mt76: mt7915: fix WED TxS reporting

Sakari Ailus (1):
      media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Sam James (1):
      gcc-plugins: drop -std=gnu++11 to fix GCC 13 build

Samuel Holland (1):
      ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference

Saravana Kannan (8):
      driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links
      driver core: fw_devlink: Don't purge child fwnode's consumer links
      driver core: fw_devlink: Allow marking a fwnode link as being part of a cycle
      driver core: fw_devlink: Consolidate device link flag computation
      driver core: fw_devlink: Improve check for fwnode with no device/driver
      driver core: fw_devlink: Make cycle detection more robust
      mtd: mtdpart: Don't create platform device that'll never probe
      driver core: fw_devlink: Avoid spurious error message

Saurav Kashyap (1):
      scsi: qla2xxx: Remove increment of interface err cnt

Sean Christopherson (15):
      KVM: Destroy target device if coalesced MMIO unregistration fails
      KVM: Register /dev/kvm as the _very_ last thing during initialization
      KVM: x86: Purge "highest ISR" cache when updating APICv state
      KVM: x86: Blindly get current x2APIC reg value on "nodecode write" traps
      KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is disabled
      KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to 32-bit ID
      KVM: SVM: Flush the "current" TLB when activating AVIC
      KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target
      KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
      KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
      KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Serge Semin (2):
      dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers
      dmaengine: dw-edma: Fix readq_ch() return value truncation

Sergey Matyukevich (1):
      riscv: mm: fix regression due to update_mmu_cache change

Sergio Paracuellos (1):
      PCI: mt7621: Delay phy ports initialization

Shang XiaoJing (4):
      drm: Fix potential null-ptr-deref due to drmm_mode_config_init()
      media: max9286: Fix memleak in max9286_v4l2_register()
      media: ov2740: Fix memleak in ov2740_init_controls()
      media: ov5675: Fix memleak in ov5675_init_controls()

Shay Drory (1):
      net/mlx5: fw_tracer: Fix debug print

Shayne Chen (1):
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Shengjiu Wang (1):
      ASoC: fsl_sai: initialize is_dsp_mode flag

Shenwei Wang (1):
      serial: fsl_lpuart: fix RS485 RTS polariy inverse issue

Sherry Sun (3):
      tty: serial: fsl_lpuart: disable Rx/Tx DMA in lpuart32_shutdown()
      tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()
      tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case

Shigeru Yoshida (1):
      l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Shin'ichiro Kawasaki (3):
      scsi: mpi3mr: Fix missing mrioc->evtack_cmds initialization
      scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()
      scsi: mpi3mr: Remove unnecessary memcpy() to alltgt_info->dmi

Shivani Baranwal (1):
      wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()

Shravan Chippa (1):
      dmaengine: sf-pdma: pdma_desc memory leak fix

Shreyas Deodhar (1):
      scsi: qla2xxx: Check if port is online before sending ELS

Shyam Prasad N (1):
      cifs: use tcon allocation functions even for dummy tcon

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Siddaraju DH (1):
      ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Sreekanth Reddy (1):
      scsi: mpt3sas: Remove usage of dma_get_required_mask() API

Srinivas Kandagatla (5):
      ASoC: qcom: q6apm-lpass-dai: unprepare stream if its already prepared
      ASoC: qcom: q6apm-dai: fix race condition while updating the position pointer
      ASoC: qcom: q6apm-dai: Add SNDRV_PCM_INFO_BATCH flag
      ASoC: codecs: lpass: register mclk after runtime pm
      ASoC: codecs: lpass: fix incorrect mclk rate

Srinivas Pandruvada (1):
      thermal: intel: powerclamp: Fix cur_state for multi package system

Stefan Metzmacher (3):
      cifs: introduce cifs_io_parms in smb2_async_writev()
      cifs: split out smb3_use_rdma_offload() helper
      cifs: don't try to use rdma offload on encrypted connections

Stefan Wahren (1):
      ARM: bcm2835_defconfig: Enable the framebuffer

Steffen Aschbacher (1):
      ASoC: tlv320adcx140: fix 'ti,gpio-config' DT property init

Steve Sistare (4):
      vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
      vfio/type1: prevent underflow of locked_vm via exec()
      vfio/type1: track locked_vm per dma
      vfio/type1: restore locked_vm

Steven Rostedt (3):
      ktest.pl: Give back console on Ctrt^C on monitor
      ktest.pl: Fix missing "end_monitor" when machine check fails
      ktest.pl: Add RUN_TIMEOUT option with default unlimited

Sungjong Seo (1):
      exfat: redefine DIR_DELETED as the bad cluster number

Sven Peter (1):
      iommu/dart: Fix apple_dart_device_group for PCI groups

Takahiro Kuwano (1):
      mtd: spi-nor: sfdp: Fix index value for SCCR dwords

Tasos Sahanidis (1):
      media: saa7134: Use video_unregister_device for radio_dev

Thadeu Lima de Souza Cascardo (1):
      net: avoid double iput when sock_alloc_file fails

Thierry Reding (1):
      arm64: tegra: Fix duplicate regulator on Jetson TX1

Thomas Zimmermann (1):
      Revert "fbcon: don't lose the console font across generic->chip driver switch"

Tiezhu Yang (1):
      selftests/bpf: Fix build errors if CONFIG_NF_CONNTRACK=m

Tim Zimmermann (1):
      thermal: intel: intel_pch: Add support for Wellsburg PCH

Tina Zhang (1):
      iommu/vt-d: Allow to use flush-queue when first level is default

Tom Lendacky (2):
      crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware
      virt/sev-guest: Return -EIO if certificate buffer is not large enough

Tomas Henzl (5):
      scsi: mpt3sas: Fix a memory leak
      scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
      scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
      scsi: ses: Fix possible desc_ptr out-of-bounds accesses
      scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Tomi Valkeinen (3):
      drm/omap: dsi: Fix excessive stack usage
      drm: rcar-du: Add quirk for H3 ES1.x pclk workaround
      drm: rcar-du: Fix setting a reserved bit in DPLLCR

Tong Tiangen (1):
      memory tier: release the new_memtier in find_create_memory_tier()

Tonghao Zhang (1):
      bpftool: profile online CPUs instead of possible

Tudor Ambarus (1):
      mtd: spi-nor: spansion: Consider reserved bits in CFR5 register

Udipto Goswami (1):
      usb: gadget: configfs: Restrict symlink creation is UDC already binded

Uwe Kleine-König (2):
      thermal/drivers/imx_sc_thermal: Drop empty platform remove function
      cpufreq: davinci: Fix clk use after free

Vadim Pasternak (1):
      hwmon: (mlxreg-fan) Return zero speed for broken fan

Vaishnav Achath (1):
      arm64: dts: ti: k3-j7200: Fix wakeup pinmux range

Vasant Hegde (2):
      iommu/amd: Do not identity map v2 capable device when snp is enabled
      iommu/amd: Improve page fault error reporting

Vasily Gorbik (7):
      s390/mem_detect: fix detect_memory() error handling
      s390/vmem: fix empty page tables cleanup under KASAN
      s390/mem_detect: rely on diag260() if sclp_early_get_memsize() fails
      s390/boot: fix mem_detect extended area allocation
      s390/mm,ptdump: avoid Kasan vs Memcpy Real markers swapping
      s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
      s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vincent Guittot (1):
      tools/lib/thermal: Fix thermal_sampling_exit()

Viorel Suman (1):
      thermal/drivers/imx_sc_thermal: Fix the loop condition

Vitaly Prosyak (1):
      Revert "drm/amdgpu: TA unload messages are not actually sent to psp when amdgpu is uninstalled"

Vladimir Stempen (1):
      drm/amd/display: fix FCLK pstate change underflow

Volker Lendecke (2):
      cifs: Fix uninitialized memory read in smb3_qfs_tcon()
      cifs: Fix uninitialized memory reads for oparms.mode

Waiman Long (2):
      locking/rwsem: Disable preemption in all down_read*() and up_read() code paths
      locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath

Wang Hai (1):
      kobject: Fix slab-out-of-bounds in fill_kobj_path()

Wang Yufen (2):
      wifi: mt76: mt7915: add missing of_node_put()
      wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()

Wayne Lin (1):
      drm/drm_print: correct format problem

Werner Sembach (1):
      ACPI: resource: Do IRQ override on all TongFang GMxRGxx

Wesley Chalmers (1):
      drm/amd/display: Do not commit pipe when updating DRR

William Zhang (1):
      spi: bcm63xx-hsspi: Fix multi-bit mode setting

Xinlei Lee (1):
      drm/mediatek: dsi: Reduce the time of dsi from LP11 to sending cmd

Xiongfeng Wang (1):
      applicom: Fix PCI device refcount leak in applicom_init()

Xiubo Li (1):
      ceph: update the time stamps and try to drop the suid/sgid

Yang Jihong (3):
      perf record: Fix segfault with --overwrite and --max-size
      x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
      x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Li (1):
      thermal: intel: Fix unsigned comparison with less than zero

Yang Yingliang (20):
      ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
      wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()
      wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      powercap: fix possible name leak in powercap_register_zone()
      driver core: fix potential null-ptr-deref in device_add()
      PCI: endpoint: pci-epf-vntb: Add epf_ntb_mw_bar_clear() num_mws kernel-doc
      firmware: stratix10-svc: add missing gen_pool_destroy() in stratix10_svc_drv_probe()
      firmware: stratix10-svc: fix error handle while alloc/add device failed
      drivers: base: transport_class: fix possible memory leak
      drivers: base: transport_class: fix resource leak when transport_add_device() fails
      media: imx: imx7-media-csi: fix missing clk_disable_unprepare() in imx7_csi_init()

Yi Yang (1):
      serial: tegra: Add missing clk_disable_unprepare() in tegra_uart_hw_init()

Yicong Yang (2):
      perf tools: Fix auto-complete on aarch64
      hwtracing: hisi_ptt: Only add the supported devices to the filters list

Yin Fengwei (1):
      mm/thp: check and bail out if page in deferred queue already

Yongqin Liu (1):
      thermal/drivers/hisi: Drop second sensor hi3660

Yu Kuai (2):
      blk-cgroup: dropping parent refcount after pd_free_fn() is done
      blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()

Yuan Can (6):
      wifi: rsi: Fix memory leak in rsi_coex_attach()
      drm/bridge: megachips: Fix error handling in i2c_register_driver()
      drm/vkms: Fix memory leak in vkms_init()
      drm/vkms: Fix null-ptr-deref in vkms_release()
      eeprom: idt_89hpesx: Fix error handling in idt_init()
      media: i2c: ov772x: Fix memleak in ov772x_probe()

Yuezhang Mo (3):
      exfat: fix reporting fs error when reading dir beyond EOF
      exfat: fix unexpected EOF while reading dir
      exfat: fix inode->i_blocks for non-512 byte sector size device

Yunsheng Lin (1):
      RDMA/rxe: cleanup some error handling in rxe_verbs.c

Zev Weiss (2):
      hwmon: (peci/cputemp) Fix off-by-one in coretemp_label allocation
      hwmon: (nct6775) Fix incorrect parenthesization in nct6775_write_fan_div()

Zhang Changzhong (2):
      wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhang Rui (1):
      tools/power/x86/intel-speed-select: Add Emerald Rapid quirk

Zhang Xiaoxu (2):
      cifs: Fix lost destroy smbd connection when MR allocate failed
      cifs: Fix warning and UAF when destroy the MR list

Zhen Lei (1):
      genirq: Fix the return type of kstat_cpu_irqs_sum()

Zhengchao Shao (4):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
      driver core: fix resource leak in device_add()

Zhengping Jiang (1):
      Bluetooth: hci_qca: get wakeup status from serdev device handle

Zhihao Cheng (1):
      jbd2: fix data missing when reusing bh which is ready to be checkpointed

Zong-Zhe Yang (2):
      wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
      wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30

Zqiang (2):
      rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug
      rcu-tasks: Handle queue-shrink/callback-enqueue race condition

andrew.yang (1):
      mm/damon/paddr: fix missing folio_put()

farah kassabri (2):
      habanalabs: bugs fixes in timestamps buff alloc
      habanalabs: fix bug in timestamps registration code

ruanjinjie (1):
      drm/mediatek: mtk_drm_crtc: Add checks for devm_kcalloc

silviazhao (1):
      x86/perf/zhaoxin: Add stepping check for ZXC

Łukasz Stelmach (1):
      ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

강신형 (1):
      ASoC: soc-compress: Reposition and add pcm_mutex

