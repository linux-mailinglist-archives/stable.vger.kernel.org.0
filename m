Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9937749E37B
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiA0NdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:33:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39792 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbiA0Ncp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:32:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2137261BD9;
        Thu, 27 Jan 2022 13:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AD5C340E8;
        Thu, 27 Jan 2022 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290364;
        bh=guYrAsa9PsP8sP/V0k1f1ksfQuaO6UpyXUoUQYD9TZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=Z1lLbEYyGqSnuCBhkI1mnmW1qocZDL4CwS2cozvrbHwJLvouvpfhfHOVitTphDLUv
         ZY24XKVrjJQO8sUnf1w93ASvNDJ3KEfeuNm3CbN7BIBH38fvZtv8FN7hYA4LJAeK1n
         PMubGUmy0AyOsZUJov5r8D8qEaMA/tAPtFkEHQ98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.17
Date:   Thu, 27 Jan 2022 14:32:16 +0100
Message-Id: <1643290337145237@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.17 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/cifs/usage.rst                             |    7 
 Documentation/admin-guide/devices.txt                                |    8 
 Documentation/admin-guide/hw-vuln/spectre.rst                        |    2 
 Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml |    5 
 Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml     |    6 
 Documentation/devicetree/bindings/input/hid-over-i2c.txt             |    2 
 Documentation/devicetree/bindings/thermal/thermal-zones.yaml         |    9 
 Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml          |    5 
 Documentation/driver-api/dmaengine/dmatest.rst                       |    7 
 Documentation/driver-api/firewire.rst                                |    4 
 Documentation/firmware-guide/acpi/dsd/data-node-references.rst       |   10 
 Documentation/trace/coresight/coresight-config.rst                   |   16 
 Makefile                                                             |    2 
 arch/arm/Kconfig.debug                                               |   14 
 arch/arm/boot/compressed/efi-header.S                                |   22 
 arch/arm/boot/compressed/head.S                                      |    3 
 arch/arm/boot/dts/armada-38x.dtsi                                    |    4 
 arch/arm/boot/dts/gemini-nas4220b.dts                                |    2 
 arch/arm/boot/dts/omap3-n900.dts                                     |   50 
 arch/arm/boot/dts/qcom-sdx55.dtsi                                    |    6 
 arch/arm/boot/dts/sama7g5-pinfunc.h                                  |    2 
 arch/arm/boot/dts/stm32f429-disco.dts                                |    2 
 arch/arm/configs/cm_x300_defconfig                                   |    1 
 arch/arm/configs/ezx_defconfig                                       |    1 
 arch/arm/configs/imote2_defconfig                                    |    1 
 arch/arm/configs/nhk8815_defconfig                                   |    1 
 arch/arm/configs/pxa_defconfig                                       |    1 
 arch/arm/configs/spear13xx_defconfig                                 |    1 
 arch/arm/configs/spear3xx_defconfig                                  |    1 
 arch/arm/configs/spear6xx_defconfig                                  |    1 
 arch/arm/include/debug/imx-uart.h                                    |   18 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c                   |    5 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                    |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi                |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi                    |    3 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts                    |   14 
 arch/arm64/boot/dts/marvell/cn9130.dtsi                              |   15 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                             |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                             |    5 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                |    4 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                |    3 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                 |    2 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts                 |   27 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                 |    2 
 arch/arm64/boot/dts/renesas/cat875.dtsi                              |    1 
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a77951.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a77960.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a77961.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a77965.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/r8a77980.dtsi                            |    4 
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi                            |   10 
 arch/arm64/boot/dts/ti/k3-am642.dtsi                                 |    2 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                            |    2 
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                                 |    6 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                            |    2 
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                                 |    6 
 arch/arm64/include/asm/mte-kasan.h                                   |    8 
 arch/arm64/kernel/process.c                                          |   39 
 arch/arm64/lib/clear_page.S                                          |   10 
 arch/arm64/lib/mte.S                                                 |    8 
 arch/mips/Kconfig                                                    |    6 
 arch/mips/bcm63xx/clk.c                                              |    6 
 arch/mips/boot/compressed/Makefile                                   |    2 
 arch/mips/boot/compressed/clz_ctz.c                                  |    2 
 arch/mips/cavium-octeon/octeon-platform.c                            |    2 
 arch/mips/cavium-octeon/octeon-usb.c                                 |    1 
 arch/mips/configs/fuloong2e_defconfig                                |    1 
 arch/mips/configs/malta_qemu_32r6_defconfig                          |    1 
 arch/mips/configs/maltaaprp_defconfig                                |    1 
 arch/mips/configs/maltasmvp_defconfig                                |    1 
 arch/mips/configs/maltasmvp_eva_defconfig                            |    1 
 arch/mips/configs/maltaup_defconfig                                  |    1 
 arch/mips/include/asm/mach-loongson64/kernel-entry-init.h            |    4 
 arch/mips/include/asm/octeon/cvmx-bootinfo.h                         |    4 
 arch/mips/lantiq/clk.c                                               |    6 
 arch/openrisc/include/asm/syscalls.h                                 |    2 
 arch/openrisc/kernel/entry.S                                         |    5 
 arch/parisc/include/asm/special_insns.h                              |   44 
 arch/parisc/kernel/traps.c                                           |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi                        |    2 
 arch/powerpc/configs/ppc6xx_defconfig                                |    1 
 arch/powerpc/configs/pseries_defconfig                               |    1 
 arch/powerpc/include/asm/hw_irq.h                                    |   40 
 arch/powerpc/kernel/btext.c                                          |    4 
 arch/powerpc/kernel/fadump.c                                         |    8 
 arch/powerpc/kernel/head_40x.S                                       |    9 
 arch/powerpc/kernel/interrupt.c                                      |    2 
 arch/powerpc/kernel/interrupt_64.S                                   |   10 
 arch/powerpc/kernel/module.c                                         |   11 
 arch/powerpc/kernel/prom_init.c                                      |    2 
 arch/powerpc/kernel/smp.c                                            |   42 
 arch/powerpc/kernel/watchdog.c                                       |   41 
 arch/powerpc/kvm/book3s_hv.c                                         |    8 
 arch/powerpc/kvm/book3s_hv_nested.c                                  |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c                             |    4 
 arch/powerpc/mm/kasan/book3s_32.c                                    |    3 
 arch/powerpc/mm/pgtable_64.c                                         |   14 
 arch/powerpc/perf/core-book3s.c                                      |   58 
 arch/powerpc/platforms/cell/iommu.c                                  |    1 
 arch/powerpc/platforms/cell/pervasive.c                              |    1 
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c                        |    1 
 arch/powerpc/platforms/powermac/low_i2c.c                            |    3 
 arch/powerpc/platforms/powernv/opal-lpc.c                            |    1 
 arch/powerpc/sysdev/xive/spapr.c                                     |    3 
 arch/riscv/Kconfig                                                   |   23 
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi                    |    3 
 arch/riscv/configs/nommu_k210_defconfig                              |    2 
 arch/riscv/configs/nommu_k210_sdcard_defconfig                       |    2 
 arch/riscv/configs/nommu_virt_defconfig                              |    1 
 arch/riscv/include/asm/smp.h                                         |   10 
 arch/riscv/kernel/kexec_relocate.S                                   |   20 
 arch/riscv/kernel/machine_kexec.c                                    |    3 
 arch/riscv/kernel/setup.c                                            |   10 
 arch/riscv/kernel/smp.c                                              |   10 
 arch/riscv/mm/init.c                                                 |   19 
 arch/s390/mm/pgalloc.c                                               |    4 
 arch/sh/configs/titan_defconfig                                      |    1 
 arch/um/.gitignore                                                   |    1 
 arch/um/drivers/virt-pci.c                                           |    8 
 arch/um/drivers/virtio_uml.c                                         |    4 
 arch/um/include/asm/delay.h                                          |    4 
 arch/um/include/asm/irqflags.h                                       |    4 
 arch/um/include/shared/longjmp.h                                     |    2 
 arch/um/include/shared/os.h                                          |    4 
 arch/um/include/shared/registers.h                                   |    4 
 arch/um/kernel/ksyms.c                                               |    2 
 arch/um/os-Linux/registers.c                                         |    4 
 arch/um/os-Linux/sigio.c                                             |    6 
 arch/um/os-Linux/signal.c                                            |    8 
 arch/um/os-Linux/start_up.c                                          |    2 
 arch/x86/boot/compressed/Makefile                                    |    7 
 arch/x86/configs/i386_defconfig                                      |    1 
 arch/x86/configs/x86_64_defconfig                                    |    1 
 arch/x86/crypto/aesni-intel_glue.c                                   |    4 
 arch/x86/include/asm/realmode.h                                      |    1 
 arch/x86/include/asm/topology.h                                      |    2 
 arch/x86/include/asm/uaccess.h                                       |    5 
 arch/x86/kernel/cpu/mce/core.c                                       |   42 
 arch/x86/kernel/cpu/mce/inject.c                                     |    2 
 arch/x86/kernel/early-quirks.c                                       |   10 
 arch/x86/kernel/reboot.c                                             |   12 
 arch/x86/kvm/mmu/tdp_mmu.c                                           |    6 
 arch/x86/kvm/vmx/posted_intr.c                                       |   16 
 arch/x86/realmode/init.c                                             |   26 
 arch/x86/um/syscalls_64.c                                            |    3 
 block/bfq-iosched.c                                                  |   44 
 block/blk-flush.c                                                    |    4 
 block/blk-pm.c                                                       |   22 
 block/genhd.c                                                        |   15 
 block/mq-deadline.c                                                  |    4 
 crypto/jitterentropy.c                                               |    3 
 drivers/acpi/acpica/exfield.c                                        |    7 
 drivers/acpi/acpica/exoparg1.c                                       |    3 
 drivers/acpi/acpica/hwesleep.c                                       |    4 
 drivers/acpi/acpica/hwsleep.c                                        |    4 
 drivers/acpi/acpica/hwxfsleep.c                                      |    2 
 drivers/acpi/acpica/utdelete.c                                       |    1 
 drivers/acpi/battery.c                                               |   22 
 drivers/acpi/bus.c                                                   |    4 
 drivers/acpi/cppc_acpi.c                                             |    2 
 drivers/acpi/ec.c                                                    |   57 
 drivers/acpi/internal.h                                              |    2 
 drivers/acpi/scan.c                                                  |   13 
 drivers/acpi/x86/utils.c                                             |  116 -
 drivers/android/binder.c                                             |   98 -
 drivers/base/core.c                                                  |    3 
 drivers/base/power/runtime.c                                         |   41 
 drivers/base/property.c                                              |    4 
 drivers/base/regmap/regmap.c                                         |    1 
 drivers/base/swnode.c                                                |    2 
 drivers/block/floppy.c                                               |    6 
 drivers/bluetooth/btintel.c                                          |   26 
 drivers/bluetooth/btmtksdio.c                                        |    2 
 drivers/bluetooth/btusb.c                                            |    5 
 drivers/bluetooth/hci_bcm.c                                          |    7 
 drivers/bluetooth/hci_qca.c                                          |    9 
 drivers/bluetooth/hci_vhci.c                                         |    2 
 drivers/bluetooth/virtio_bt.c                                        |    3 
 drivers/bus/mhi/core/init.c                                          |    1 
 drivers/bus/mhi/core/pm.c                                            |   35 
 drivers/bus/mhi/pci_generic.c                                        |    2 
 drivers/char/mwave/3780i.h                                           |    2 
 drivers/char/random.c                                                |   19 
 drivers/char/tpm/tpm-chip.c                                          |   18 
 drivers/char/tpm/tpm_tis_core.c                                      |   14 
 drivers/clk/bcm/clk-bcm2835.c                                        |   13 
 drivers/clk/clk-bm1880.c                                             |   20 
 drivers/clk/clk-si5341.c                                             |    2 
 drivers/clk/clk-stm32f4.c                                            |    4 
 drivers/clk/clk.c                                                    |   18 
 drivers/clk/imx/clk-imx8mn.c                                         |    6 
 drivers/clk/meson/gxbb.c                                             |   44 
 drivers/clk/qcom/gcc-sc7280.c                                        |    2 
 drivers/clk/renesas/rzg2l-cpg.c                                      |   17 
 drivers/cpufreq/cpufreq.c                                            |    4 
 drivers/cpufreq/qcom-cpufreq-hw.c                                    |    7 
 drivers/crypto/atmel-aes.c                                           |    6 
 drivers/crypto/caam/caamalg.c                                        |    6 
 drivers/crypto/caam/caamalg_qi2.c                                    |    2 
 drivers/crypto/caam/caamhash.c                                       |    3 
 drivers/crypto/caam/caampkc.c                                        |    3 
 drivers/crypto/ccp/sev-dev.c                                         |   30 
 drivers/crypto/hisilicon/hpre/hpre_crypto.c                          |    2 
 drivers/crypto/hisilicon/qm.c                                        |    2 
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c                   |    9 
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c                  |    3 
 drivers/crypto/omap-aes.c                                            |    2 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c                        |   45 
 drivers/crypto/qce/aead.c                                            |    2 
 drivers/crypto/qce/sha.c                                             |    2 
 drivers/crypto/qce/skcipher.c                                        |    2 
 drivers/crypto/stm32/stm32-crc32.c                                   |    4 
 drivers/crypto/stm32/stm32-cryp.c                                    |  938 +++-------
 drivers/crypto/stm32/stm32-hash.c                                    |    6 
 drivers/cxl/pmem.c                                                   |   17 
 drivers/dma-buf/dma-fence-array.c                                    |    6 
 drivers/dma/at_xdmac.c                                               |   57 
 drivers/dma/idxd/device.c                                            |   12 
 drivers/dma/mmp_pdma.c                                               |    6 
 drivers/dma/pxa_dma.c                                                |    7 
 drivers/dma/stm32-mdma.c                                             |    2 
 drivers/dma/uniphier-xdmac.c                                         |    5 
 drivers/edac/synopsys_edac.c                                         |    3 
 drivers/firmware/efi/efi-init.c                                      |    5 
 drivers/firmware/google/Kconfig                                      |    6 
 drivers/firmware/sysfb_simplefb.c                                    |    8 
 drivers/gpio/gpio-aspeed-sgpio.c                                     |   32 
 drivers/gpio/gpio-aspeed.c                                           |   52 
 drivers/gpio/gpio-idt3243x.c                                         |    4 
 drivers/gpio/gpio-mpc8xxx.c                                          |    4 
 drivers/gpio/gpiolib-acpi.c                                          |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                              |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                              |    4 
 drivers/gpu/drm/amd/amdgpu/cik.c                                     |    4 
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                               |    4 
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                                |   13 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                                |    4 
 drivers/gpu/drm/amd/amdgpu/vi.c                                      |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                                 |  138 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                    |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c            |    5 
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c                     |    3 
 drivers/gpu/drm/amd/display/dc/core/dc.c                             |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                        |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c                |    3 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                                   |    6 
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c                    |   14 
 drivers/gpu/drm/bridge/display-connector.c                           |    2 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c             |   40 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c                  |   10 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h                      |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c                  |    9 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                            |   12 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                |    1 
 drivers/gpu/drm/drm_dp_helper.c                                      |   40 
 drivers/gpu/drm/drm_drv.c                                            |    9 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                       |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c                         |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                                |    1 
 drivers/gpu/drm/etnaviv/etnaviv_sched.c                              |    4 
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c                   |   10 
 drivers/gpu/drm/lima/lima_device.c                                   |    1 
 drivers/gpu/drm/msm/Kconfig                                          |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                              |    4 
 drivers/gpu/drm/msm/dsi/dsi.c                                        |   10 
 drivers/gpu/drm/msm/dsi/dsi.h                                        |    1 
 drivers/gpu/drm/msm/dsi/dsi_manager.c                                |   17 
 drivers/gpu/drm/msm/msm_gem_submit.c                                 |    2 
 drivers/gpu/drm/nouveau/dispnv04/disp.c                              |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c                       |   37 
 drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c                |    8 
 drivers/gpu/drm/panel/panel-innolux-p079zca.c                        |   10 
 drivers/gpu/drm/panel/panel-jdi-lt070me05000.c                       |    8 
 drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c                   |    8 
 drivers/gpu/drm/panel/panel-novatek-nt36672a.c                       |    8 
 drivers/gpu/drm/panel/panel-panasonic-vvx10f034n00.c                 |    8 
 drivers/gpu/drm/panel/panel-ronbo-rb070d30.c                         |    8 
 drivers/gpu/drm/panel/panel-samsung-s6e88a0-ams452ef01.c             |    1 
 drivers/gpu/drm/panel/panel-samsung-sofef00.c                        |    1 
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c                      |    8 
 drivers/gpu/drm/radeon/radeon_kms.c                                  |   42 
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c                               |   20 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                      |   82 
 drivers/gpu/drm/tegra/drm.c                                          |   15 
 drivers/gpu/drm/tegra/gr2d.c                                         |   33 
 drivers/gpu/drm/tegra/submit.c                                       |    4 
 drivers/gpu/drm/tegra/vic.c                                          |    7 
 drivers/gpu/drm/ttm/ttm_bo.c                                         |    2 
 drivers/gpu/drm/vboxvideo/vbox_main.c                                |    4 
 drivers/gpu/drm/vc4/vc4_crtc.c                                       |   31 
 drivers/gpu/drm/vc4/vc4_drv.h                                        |   29 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                       |  136 +
 drivers/gpu/drm/vc4/vc4_hvs.c                                        |   26 
 drivers/gpu/drm/vc4/vc4_kms.c                                        |    3 
 drivers/gpu/drm/vc4/vc4_txp.c                                        |    4 
 drivers/gpu/drm/vmwgfx/Makefile                                      |    3 
 drivers/gpu/drm/vmwgfx/ttm_memory.c                                  |   99 -
 drivers/gpu/drm/vmwgfx/ttm_memory.h                                  |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c                                  |    7 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                  |   48 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                                  |   20 
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                                  |   12 
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c                                 |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c                       |   90 
 drivers/gpu/drm/vmwgfx/vmwgfx_thp.c                                  |  184 -
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c                           |   58 
 drivers/gpu/host1x/Kconfig                                           |    1 
 drivers/gpu/host1x/dev.c                                             |   15 
 drivers/hid/hid-apple.c                                              |    2 
 drivers/hid/hid-ids.h                                                |    1 
 drivers/hid/hid-input.c                                              |    8 
 drivers/hid/hid-magicmouse.c                                         |   95 -
 drivers/hid/hid-uclogic-params.c                                     |   31 
 drivers/hid/hid-vivaldi.c                                            |   34 
 drivers/hid/i2c-hid/i2c-hid-acpi.c                                   |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                                   |    4 
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c                              |    2 
 drivers/hid/i2c-hid/i2c-hid-of.c                                     |   10 
 drivers/hid/i2c-hid/i2c-hid.h                                        |    2 
 drivers/hid/uhid.c                                                   |   29 
 drivers/hid/wacom_wac.c                                              |   39 
 drivers/hsi/hsi_core.c                                               |    1 
 drivers/hwmon/mr75203.c                                              |    2 
 drivers/i2c/busses/i2c-designware-pcidrv.c                           |    8 
 drivers/i2c/busses/i2c-i801.c                                        |   15 
 drivers/i2c/busses/i2c-mpc.c                                         |   23 
 drivers/iio/adc/ti-adc081c.c                                         |   22 
 drivers/iio/industrialio-trigger.c                                   |   36 
 drivers/infiniband/core/cma.c                                        |   18 
 drivers/infiniband/core/device.c                                     |    3 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c                           |    6 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h                           |    1 
 drivers/infiniband/hw/cxgb4/qp.c                                     |    1 
 drivers/infiniband/hw/hns/hns_roce_main.c                            |    5 
 drivers/infiniband/hw/qedr/verbs.c                                   |    2 
 drivers/infiniband/sw/rxe/rxe_opcode.c                               |    2 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                               |    2 
 drivers/interconnect/qcom/icc-rpm.c                                  |    1 
 drivers/iommu/amd/amd_iommu_types.h                                  |    2 
 drivers/iommu/amd/init.c                                             |  107 -
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c                           |    2 
 drivers/iommu/io-pgtable-arm-v7s.c                                   |    6 
 drivers/iommu/io-pgtable-arm.c                                       |    9 
 drivers/iommu/iommu.c                                                |    3 
 drivers/iommu/iova.c                                                 |    3 
 drivers/irqchip/irq-gic-v3.c                                         |   16 
 drivers/leds/leds-lp55xx-common.c                                    |    4 
 drivers/mailbox/mailbox-mpfs.c                                       |    2 
 drivers/mailbox/mtk-cmdq-mailbox.c                                   |    2 
 drivers/md/dm.c                                                      |    4 
 drivers/md/md.c                                                      |   27 
 drivers/md/md.h                                                      |    2 
 drivers/md/persistent-data/dm-btree.c                                |    8 
 drivers/md/persistent-data/dm-space-map-common.c                     |    5 
 drivers/md/raid0.c                                                   |   38 
 drivers/md/raid5.c                                                   |   41 
 drivers/media/Kconfig                                                |    8 
 drivers/media/cec/core/cec-adap.c                                    |   38 
 drivers/media/cec/core/cec-api.c                                     |    6 
 drivers/media/cec/core/cec-core.c                                    |    3 
 drivers/media/cec/core/cec-pin.c                                     |   31 
 drivers/media/common/saa7146/saa7146_fops.c                          |    2 
 drivers/media/common/videobuf2/videobuf2-dma-contig.c                |    8 
 drivers/media/dvb-core/dmxdev.c                                      |   18 
 drivers/media/dvb-frontends/dib8000.c                                |    4 
 drivers/media/i2c/imx274.c                                           |    5 
 drivers/media/i2c/ov8865.c                                           |   16 
 drivers/media/pci/b2c2/flexcop-pci.c                                 |    3 
 drivers/media/pci/saa7146/hexium_gemini.c                            |    7 
 drivers/media/pci/saa7146/hexium_orion.c                             |    8 
 drivers/media/pci/saa7146/mxb.c                                      |    8 
 drivers/media/platform/aspeed-video.c                                |   14 
 drivers/media/platform/coda/coda-common.c                            |    8 
 drivers/media/platform/coda/coda-jpeg.c                              |   21 
 drivers/media/platform/coda/imx-vdoa.c                               |    6 
 drivers/media/platform/imx-pxp.c                                     |    4 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c               |    2 
 drivers/media/platform/qcom/venus/core.c                             |   11 
 drivers/media/platform/qcom/venus/pm_helpers.c                       |   32 
 drivers/media/platform/rcar-vin/rcar-csi2.c                          |   18 
 drivers/media/platform/rcar-vin/rcar-v4l2.c                          |   15 
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c                  |    2 
 drivers/media/radio/si470x/radio-si470x-i2c.c                        |    3 
 drivers/media/rc/igorplugusb.c                                       |    4 
 drivers/media/rc/mceusb.c                                            |    8 
 drivers/media/rc/redrat3.c                                           |   22 
 drivers/media/tuners/msi001.c                                        |    7 
 drivers/media/tuners/si2157.c                                        |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                                 |   10 
 drivers/media/usb/b2c2/flexcop-usb.h                                 |   12 
 drivers/media/usb/cpia2/cpia2_usb.c                                  |    4 
 drivers/media/usb/dvb-usb/dib0700_core.c                             |    2 
 drivers/media/usb/dvb-usb/dw2102.c                                   |  338 ++-
 drivers/media/usb/dvb-usb/m920x.c                                    |   12 
 drivers/media/usb/em28xx/em28xx-cards.c                              |   18 
 drivers/media/usb/em28xx/em28xx-core.c                               |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                              |    8 
 drivers/media/usb/s2255/s2255drv.c                                   |    4 
 drivers/media/usb/stk1160/stk1160-core.c                             |    4 
 drivers/media/usb/uvc/uvcvideo.h                                     |    2 
 drivers/media/v4l2-core/v4l2-ioctl.c                                 |    4 
 drivers/memory/renesas-rpc-if.c                                      |    2 
 drivers/mfd/atmel-flexcom.c                                          |   11 
 drivers/mfd/tps65910.c                                               |   22 
 drivers/misc/eeprom/at25.c                                           |   13 
 drivers/misc/habanalabs/common/firmware_if.c                         |   17 
 drivers/misc/habanalabs/common/habanalabs.h                          |    2 
 drivers/misc/lattice-ecp3-config.c                                   |   12 
 drivers/misc/lkdtm/Makefile                                          |    2 
 drivers/misc/mei/hbm.c                                               |   20 
 drivers/mmc/core/sdio.c                                              |    4 
 drivers/mmc/host/meson-mx-sdhc-mmc.c                                 |    5 
 drivers/mmc/host/meson-mx-sdio.c                                     |    5 
 drivers/mmc/host/mtk-sd.c                                            |   64 
 drivers/mmc/host/sdhci-pci-gli.c                                     |   11 
 drivers/mmc/host/tmio_mmc_core.c                                     |   15 
 drivers/mtd/hyperbus/rpc-if.c                                        |    8 
 drivers/mtd/mtdcore.c                                                |    4 
 drivers/mtd/mtdpart.c                                                |    2 
 drivers/mtd/nand/raw/davinci_nand.c                                  |   73 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                           |   37 
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c                      |    5 
 drivers/mtd/nand/raw/nand_base.c                                     |   67 
 drivers/net/bonding/bond_main.c                                      |   40 
 drivers/net/can/flexcan.c                                            |  150 +
 drivers/net/can/rcar/rcar_canfd.c                                    |    5 
 drivers/net/can/softing/softing_cs.c                                 |    2 
 drivers/net/can/softing/softing_fw.c                                 |   11 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                       |    6 
 drivers/net/can/xilinx_can.c                                         |    7 
 drivers/net/dsa/hirschmann/hellcreek.c                               |   87 
 drivers/net/ethernet/broadcom/bnxt/Makefile                          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                            |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                            |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c                   |  372 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h                   |   51 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                    |  355 ---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h                    |   43 
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c                       |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h                       |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                       |   10 
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c                    |    3 
 drivers/net/ethernet/cortina/gemini.c                                |    9 
 drivers/net/ethernet/freescale/fman/mac.c                            |   21 
 drivers/net/ethernet/freescale/xgmac_mdio.c                          |   28 
 drivers/net/ethernet/i825xx/sni_82596.c                              |    3 
 drivers/net/ethernet/intel/igc/igc_main.c                            |    4 
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c                      |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                          |   55 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                          |   16 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                        |   36 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                  |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                    |   19 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                     |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                      |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                      |  120 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c                     |    6 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                       |    8 
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c                 |    5 
 drivers/net/ethernet/mellanox/mlxsw/cmd.h                            |   12 
 drivers/net/ethernet/mellanox/mlxsw/pci.c                            |    7 
 drivers/net/ethernet/mscc/ocelot.c                                   |   31 
 drivers/net/ethernet/mscc/ocelot_flower.c                            |   15 
 drivers/net/ethernet/mscc/ocelot_net.c                               |    6 
 drivers/net/ethernet/renesas/ravb_main.c                             |    6 
 drivers/net/ethernet/rocker/rocker_ofdpa.c                           |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c              |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                    |    3 
 drivers/net/ethernet/ti/cpsw.c                                       |    6 
 drivers/net/ethernet/ti/cpsw_new.c                                   |    6 
 drivers/net/ethernet/ti/cpsw_priv.c                                  |    2 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                    |  135 -
 drivers/net/ipa/ipa_endpoint.c                                       |    7 
 drivers/net/phy/marvell.c                                            |   62 
 drivers/net/phy/mdio_bus.c                                           |    2 
 drivers/net/phy/micrel.c                                             |   36 
 drivers/net/phy/phy-core.c                                           |    2 
 drivers/net/phy/sfp.c                                                |   25 
 drivers/net/ppp/ppp_generic.c                                        |    7 
 drivers/net/usb/mcs7830.c                                            |   12 
 drivers/net/usb/smsc95xx.c                                           |    3 
 drivers/net/wireless/ath/ar5523/ar5523.c                             |    4 
 drivers/net/wireless/ath/ath10k/core.c                               |   19 
 drivers/net/wireless/ath/ath10k/htt_tx.c                             |    3 
 drivers/net/wireless/ath/ath10k/hw.h                                 |    3 
 drivers/net/wireless/ath/ath10k/txrx.c                               |    2 
 drivers/net/wireless/ath/ath11k/ahb.c                                |   28 
 drivers/net/wireless/ath/ath11k/core.c                               |   27 
 drivers/net/wireless/ath/ath11k/core.h                               |   15 
 drivers/net/wireless/ath/ath11k/dp.h                                 |    3 
 drivers/net/wireless/ath/ath11k/dp_tx.c                              |    2 
 drivers/net/wireless/ath/ath11k/hal.c                                |   22 
 drivers/net/wireless/ath/ath11k/hal.h                                |    2 
 drivers/net/wireless/ath/ath11k/hw.c                                 |    2 
 drivers/net/wireless/ath/ath11k/mac.c                                |   52 
 drivers/net/wireless/ath/ath11k/pci.c                                |   22 
 drivers/net/wireless/ath/ath11k/qmi.c                                |    2 
 drivers/net/wireless/ath/ath11k/reg.c                                |  103 -
 drivers/net/wireless/ath/ath11k/wmi.c                                |    5 
 drivers/net/wireless/ath/ath9k/hif_usb.c                             |    7 
 drivers/net/wireless/ath/ath9k/htc.h                                 |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                        |   13 
 drivers/net/wireless/ath/ath9k/wmi.c                                 |    4 
 drivers/net/wireless/ath/wcn36xx/dxe.c                               |   49 
 drivers/net/wireless/ath/wcn36xx/main.c                              |   34 
 drivers/net/wireless/ath/wcn36xx/smd.c                               |   10 
 drivers/net/wireless/ath/wcn36xx/txrx.c                              |   41 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                           |    1 
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                         |    5 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                         |   17 
 drivers/net/wireless/intel/iwlwifi/iwl-io.c                          |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c               |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                    |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                        |   27 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                        |   23 
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                  |   36 
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                         |    7 
 drivers/net/wireless/intel/iwlwifi/queue/tx.c                        |    1 
 drivers/net/wireless/marvell/mwifiex/sta_event.c                     |    8 
 drivers/net/wireless/marvell/mwifiex/usb.c                           |    3 
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c                      |    4 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                      |    9 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                     |    8 
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c                 |    8 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                      |    9 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                      |    9 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c                     |    6 
 drivers/net/wireless/microchip/wilc1000/netdev.c                     |    1 
 drivers/net/wireless/microchip/wilc1000/sdio.c                       |    2 
 drivers/net/wireless/microchip/wilc1000/spi.c                        |    2 
 drivers/net/wireless/realtek/rtw88/main.c                            |    2 
 drivers/net/wireless/realtek/rtw88/pci.c                             |   61 
 drivers/net/wireless/realtek/rtw88/pci.h                             |    2 
 drivers/net/wireless/realtek/rtw88/rtw8821c.h                        |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822b.c                        |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822c.c                        |    2 
 drivers/net/wireless/rsi/rsi_91x_main.c                              |    4 
 drivers/net/wireless/rsi/rsi_91x_usb.c                               |    9 
 drivers/net/wireless/rsi/rsi_usb.h                                   |    2 
 drivers/net/wwan/mhi_wwan_mbim.c                                     |    4 
 drivers/nvmem/core.c                                                 |    2 
 drivers/of/base.c                                                    |   11 
 drivers/of/fdt.c                                                     |   25 
 drivers/of/unittest.c                                                |   21 
 drivers/parisc/pdc_stable.c                                          |    4 
 drivers/pci/controller/pci-aardvark.c                                |    4 
 drivers/pci/controller/pci-mvebu.c                                   |    8 
 drivers/pci/controller/pci-xgene.c                                   |    2 
 drivers/pci/hotplug/pciehp.h                                         |    3 
 drivers/pci/hotplug/pciehp_core.c                                    |    2 
 drivers/pci/hotplug/pciehp_hpc.c                                     |   21 
 drivers/pci/msi.c                                                    |   26 
 drivers/pci/pci-bridge-emul.c                                        |   70 
 drivers/pci/quirks.c                                                 |    3 
 drivers/pcmcia/cs.c                                                  |    8 
 drivers/pcmcia/rsrc_nonstatic.c                                      |    6 
 drivers/perf/arm-cmn.c                                               |    5 
 drivers/phy/cadence/phy-cadence-sierra.c                             |   31 
 drivers/phy/mediatek/phy-mtk-mipi-dsi.c                              |    2 
 drivers/phy/mediatek/phy-mtk-tphy.c                                  |  162 +
 drivers/phy/socionext/phy-uniphier-usb3ss.c                          |   10 
 drivers/pinctrl/pinctrl-rockchip.c                                   |    2 
 drivers/power/reset/mt6323-poweroff.c                                |    3 
 drivers/ptp/ptp_vclock.c                                             |   10 
 drivers/regulator/da9121-regulator.c                                 |    5 
 drivers/regulator/qcom-labibb-regulator.c                            |    2 
 drivers/regulator/qcom_smd-regulator.c                               |  100 -
 drivers/remoteproc/imx_rproc.c                                       |    1 
 drivers/rpmsg/rpmsg_core.c                                           |   20 
 drivers/rtc/rtc-cmos.c                                               |    3 
 drivers/rtc/rtc-pxa.c                                                |    4 
 drivers/scsi/lpfc/lpfc.h                                             |    2 
 drivers/scsi/lpfc/lpfc_attr.c                                        |   62 
 drivers/scsi/lpfc/lpfc_els.c                                         |   11 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                     |    8 
 drivers/scsi/lpfc/lpfc_init.c                                        |    8 
 drivers/scsi/lpfc/lpfc_nportdisc.c                                   |    6 
 drivers/scsi/lpfc/lpfc_sli.c                                         |    6 
 drivers/scsi/mpi3mr/mpi3mr.h                                         |    3 
 drivers/scsi/mpi3mr/mpi3mr_fw.c                                      |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                                     |    4 
 drivers/scsi/scsi.c                                                  |    4 
 drivers/scsi/scsi_debugfs.c                                          |    1 
 drivers/scsi/scsi_pm.c                                               |    2 
 drivers/scsi/sr.c                                                    |    2 
 drivers/scsi/sr_vendor.c                                             |    4 
 drivers/scsi/ufs/tc-dwc-g210-pci.c                                   |    1 
 drivers/scsi/ufs/ufs-mediatek.c                                      |    2 
 drivers/scsi/ufs/ufshcd-pci.c                                        |    2 
 drivers/scsi/ufs/ufshcd-pltfrm.c                                     |    2 
 drivers/scsi/ufs/ufshcd.c                                            |   22 
 drivers/soc/imx/gpcv2.c                                              |    2 
 drivers/soc/mediatek/mtk-scpsys.c                                    |   15 
 drivers/soc/qcom/cpr.c                                               |    2 
 drivers/soc/ti/pruss.c                                               |    2 
 drivers/spi/spi-hisi-kunpeng.c                                       |   15 
 drivers/spi/spi-meson-spifc.c                                        |    1 
 drivers/spi/spi-uniphier.c                                           |   11 
 drivers/spi/spi.c                                                    |   13 
 drivers/staging/greybus/audio_topology.c                             |   15 
 drivers/staging/media/atomisp/i2c/ov2680.h                           |   24 
 drivers/staging/media/atomisp/pci/atomisp_cmd.c                      |   82 
 drivers/staging/media/atomisp/pci/atomisp_fops.c                     |   11 
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c            |    2 
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c                    |  188 +-
 drivers/staging/media/atomisp/pci/atomisp_subdev.c                   |   15 
 drivers/staging/media/atomisp/pci/atomisp_subdev.h                   |    3 
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c                     |   13 
 drivers/staging/media/atomisp/pci/atomisp_v4l2.h                     |    3 
 drivers/staging/media/atomisp/pci/sh_css.c                           |   27 
 drivers/staging/media/atomisp/pci/sh_css_mipi.c                      |   41 
 drivers/staging/media/atomisp/pci/sh_css_params.c                    |    8 
 drivers/staging/media/hantro/hantro_drv.c                            |    3 
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c                    |    2 
 drivers/staging/media/hantro/hantro_hw.h                             |    3 
 drivers/staging/media/hantro/rockchip_vpu2_hw_jpeg_enc.c             |   17 
 drivers/staging/media/hantro/rockchip_vpu_hw.c                       |    5 
 drivers/staging/rtl8192e/rtllib.h                                    |    2 
 drivers/staging/rtl8192e/rtllib_module.c                             |   16 
 drivers/staging/rtl8192e/rtllib_softmac.c                            |    6 
 drivers/tee/tee_core.c                                               |    4 
 drivers/thermal/imx8mm_thermal.c                                     |    3 
 drivers/thermal/imx_thermal.c                                        |  145 -
 drivers/thunderbolt/acpi.c                                           |   13 
 drivers/tty/mxser.c                                                  |    5 
 drivers/tty/serial/8250/8250_bcm7271.c                               |   11 
 drivers/tty/serial/amba-pl010.c                                      |    3 
 drivers/tty/serial/amba-pl011.c                                      |   29 
 drivers/tty/serial/atmel_serial.c                                    |   14 
 drivers/tty/serial/imx.c                                             |    7 
 drivers/tty/serial/liteuart.c                                        |    2 
 drivers/tty/serial/serial_core.c                                     |    7 
 drivers/tty/serial/stm32-usart.c                                     |    6 
 drivers/tty/serial/uartlite.c                                        |    2 
 drivers/usb/core/hub.c                                               |    5 
 drivers/usb/dwc2/gadget.c                                            |   13 
 drivers/usb/dwc2/hcd.c                                               |    7 
 drivers/usb/dwc3/dwc3-meson-g12a.c                                   |   17 
 drivers/usb/dwc3/dwc3-qcom.c                                         |    7 
 drivers/usb/gadget/function/f_fs.c                                   |    4 
 drivers/usb/gadget/function/u_audio.c                                |    4 
 drivers/usb/host/ehci-brcm.c                                         |    6 
 drivers/usb/host/uhci-platform.c                                     |    3 
 drivers/usb/misc/ftdi-elan.c                                         |    1 
 drivers/vdpa/ifcvf/ifcvf_base.c                                      |   41 
 drivers/vdpa/ifcvf/ifcvf_base.h                                      |    9 
 drivers/vdpa/ifcvf/ifcvf_main.c                                      |   24 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                    |    6 
 drivers/video/backlight/qcom-wled.c                                  |  122 -
 drivers/virtio/virtio_mem.c                                          |    2 
 drivers/virtio/virtio_ring.c                                         |    4 
 drivers/w1/slaves/w1_ds28e04.c                                       |   26 
 drivers/xen/gntdev.c                                                 |    6 
 fs/btrfs/backref.c                                                   |   21 
 fs/btrfs/ctree.c                                                     |   19 
 fs/btrfs/inode.c                                                     |   11 
 fs/btrfs/qgroup.c                                                    |   19 
 fs/debugfs/file.c                                                    |    2 
 fs/dlm/lock.c                                                        |    9 
 fs/dlm/lowcomms.c                                                    |   44 
 fs/ext4/ext4.h                                                       |    1 
 fs/ext4/ext4_jbd2.c                                                  |    2 
 fs/ext4/extents.c                                                    |    2 
 fs/ext4/fast_commit.c                                                |   18 
 fs/ext4/inode.c                                                      |   51 
 fs/ext4/ioctl.c                                                      |    2 
 fs/ext4/mballoc.c                                                    |   48 
 fs/ext4/migrate.c                                                    |   23 
 fs/ext4/super.c                                                      |   27 
 fs/f2fs/checkpoint.c                                                 |    4 
 fs/f2fs/compress.c                                                   |   50 
 fs/f2fs/data.c                                                       |    7 
 fs/f2fs/f2fs.h                                                       |   11 
 fs/f2fs/file.c                                                       |   10 
 fs/f2fs/gc.c                                                         |    8 
 fs/f2fs/inode.c                                                      |    5 
 fs/f2fs/segment.h                                                    |    3 
 fs/f2fs/super.c                                                      |   44 
 fs/f2fs/sysfs.c                                                      |    4 
 fs/fuse/file.c                                                       |    2 
 fs/io_uring.c                                                        |    1 
 fs/jffs2/file.c                                                      |   40 
 fs/ksmbd/connection.c                                                |    1 
 fs/ksmbd/connection.h                                                |    4 
 fs/ksmbd/ksmbd_netlink.h                                             |   12 
 fs/ksmbd/smb2misc.c                                                  |   18 
 fs/ksmbd/smb2ops.c                                                   |   16 
 fs/ksmbd/smb2pdu.c                                                   |   87 
 fs/ksmbd/smb2pdu.h                                                   |    1 
 fs/ksmbd/smb_common.h                                                |    1 
 fs/ksmbd/transport_ipc.c                                             |    2 
 fs/ksmbd/transport_tcp.c                                             |    3 
 fs/ubifs/super.c                                                     |    1 
 fs/udf/ialloc.c                                                      |    2 
 include/acpi/acpi_bus.h                                              |    5 
 include/acpi/actypes.h                                               |   10 
 include/asm-generic/bitops/find.h                                    |    5 
 include/linux/blk-pm.h                                               |    2 
 include/linux/bpf_verifier.h                                         |    7 
 include/linux/hid.h                                                  |    2 
 include/linux/iio/trigger.h                                          |    2 
 include/linux/ipv6.h                                                 |    2 
 include/linux/mmzone.h                                               |    9 
 include/linux/mtd/rawnand.h                                          |    2 
 include/linux/of_fdt.h                                               |    2 
 include/linux/pm_runtime.h                                           |    3 
 include/linux/psi_types.h                                            |   13 
 include/linux/ptp_clock_kernel.h                                     |   12 
 include/linux/skbuff.h                                               |    7 
 include/linux/stmmac.h                                               |    1 
 include/media/cec.h                                                  |   11 
 include/net/inet_frag.h                                              |   11 
 include/net/ipv6_frag.h                                              |    3 
 include/net/pkt_sched.h                                              |    5 
 include/net/sch_generic.h                                            |    5 
 include/net/seg6.h                                                   |   21 
 include/net/xfrm.h                                                   |    7 
 include/sound/hda_codec.h                                            |    8 
 include/trace/events/cgroup.h                                        |   12 
 include/uapi/linux/xfrm.h                                            |    1 
 kernel/audit.c                                                       |   18 
 kernel/bpf/btf.c                                                     |    3 
 kernel/bpf/inode.c                                                   |   14 
 kernel/bpf/verifier.c                                                |   28 
 kernel/dma/pool.c                                                    |    4 
 kernel/rcu/rcutorture.c                                              |    5 
 kernel/rcu/tree_exp.h                                                |    1 
 kernel/sched/cpuacct.c                                               |   79 
 kernel/sched/cputime.c                                               |    4 
 kernel/sched/fair.c                                                  |    4 
 kernel/sched/psi.c                                                   |   45 
 kernel/sched/rt.c                                                    |   23 
 kernel/sched/stats.h                                                 |    5 
 kernel/time/clocksource.c                                            |   50 
 kernel/trace/bpf_trace.c                                             |    6 
 kernel/trace/trace_kprobe.c                                          |    5 
 kernel/trace/trace_osnoise.c                                         |   20 
 kernel/trace/trace_syscalls.c                                        |    6 
 kernel/tsacct.c                                                      |    7 
 lib/kunit/test.c                                                     |   18 
 lib/logic_iomem.c                                                    |   19 
 lib/mpi/mpi-mod.c                                                    |    2 
 lib/test_hmm.c                                                       |   24 
 lib/test_meminit.c                                                   |    1 
 mm/hmm.c                                                             |    5 
 mm/page_alloc.c                                                      |   19 
 mm/shmem.c                                                           |   37 
 net/ax25/af_ax25.c                                                   |   10 
 net/batman-adv/netlink.c                                             |   30 
 net/bluetooth/cmtp/core.c                                            |    4 
 net/bluetooth/hci_core.c                                             |    1 
 net/bluetooth/hci_event.c                                            |   14 
 net/bluetooth/hci_request.c                                          |    2 
 net/bluetooth/hci_sysfs.c                                            |    2 
 net/bluetooth/l2cap_sock.c                                           |   45 
 net/bluetooth/mgmt.c                                                 |  248 +-
 net/bridge/br_netfilter_hooks.c                                      |    7 
 net/core/dev.c                                                       |    6 
 net/core/devlink.c                                                   |    2 
 net/core/filter.c                                                    |    8 
 net/core/flow_dissector.c                                            |    3 
 net/core/net-sysfs.c                                                 |    3 
 net/core/net_namespace.c                                             |    4 
 net/core/sock.c                                                      |    2 
 net/core/sock_map.c                                                  |   21 
 net/dsa/switch.c                                                     |    4 
 net/ipv4/fib_semantics.c                                             |   47 
 net/ipv4/inet_fragment.c                                             |    8 
 net/ipv4/ip_fragment.c                                               |    3 
 net/ipv4/ip_gre.c                                                    |    5 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                                   |    5 
 net/ipv4/tcp_bpf.c                                                   |   27 
 net/ipv6/icmp.c                                                      |    6 
 net/ipv6/ip6_gre.c                                                   |    5 
 net/ipv6/seg6.c                                                      |   59 
 net/ipv6/seg6_local.c                                                |   33 
 net/ipv6/udp.c                                                       |    3 
 net/mac80211/rx.c                                                    |    2 
 net/mptcp/options.c                                                  |   10 
 net/mptcp/pm_netlink.c                                               |   18 
 net/netfilter/nft_payload.c                                          |    3 
 net/netfilter/nft_set_pipapo.c                                       |    8 
 net/netrom/af_netrom.c                                               |   12 
 net/nfc/llcp_sock.c                                                  |    5 
 net/openvswitch/flow.c                                               |   20 
 net/sched/act_ct.c                                                   |    7 
 net/sched/cls_api.c                                                  |    3 
 net/sched/cls_flower.c                                               |    3 
 net/sched/sch_api.c                                                  |    2 
 net/sched/sch_generic.c                                              |    1 
 net/smc/af_smc.c                                                     |    8 
 net/smc/smc_core.c                                                   |   29 
 net/smc/smc_core.h                                                   |    2 
 net/socket.c                                                         |    9 
 net/unix/garbage.c                                                   |   14 
 net/unix/scm.c                                                       |    6 
 net/xfrm/xfrm_compat.c                                               |    6 
 net/xfrm/xfrm_interface.c                                            |   14 
 net/xfrm/xfrm_output.c                                               |   30 
 net/xfrm/xfrm_policy.c                                               |   24 
 net/xfrm/xfrm_state.c                                                |   23 
 net/xfrm/xfrm_user.c                                                 |   41 
 samples/bpf/Makefile                                                 |   56 
 samples/bpf/Makefile.target                                          |   11 
 samples/bpf/hbm_kern.h                                               |    2 
 samples/bpf/lwt_len_hist_kern.c                                      |    7 
 samples/bpf/xdp_sample_user.h                                        |    2 
 scripts/dtc/dtx_diff                                                 |    8 
 scripts/sphinx-pre-install                                           |    4 
 security/selinux/hooks.c                                             |   12 
 sound/core/jack.c                                                    |    3 
 sound/core/misc.c                                                    |    2 
 sound/core/oss/pcm_oss.c                                             |    2 
 sound/core/pcm.c                                                     |    6 
 sound/core/seq/seq_queue.c                                           |   14 
 sound/hda/hdac_stream.c                                              |   14 
 sound/pci/hda/hda_bind.c                                             |    5 
 sound/pci/hda/hda_codec.c                                            |   45 
 sound/pci/hda/hda_controller.c                                       |    1 
 sound/pci/hda/hda_local.h                                            |    1 
 sound/pci/hda/patch_cs8409-tables.c                                  |    3 
 sound/pci/hda/patch_cs8409.c                                         |    9 
 sound/pci/hda/patch_cs8409.h                                         |    1 
 sound/soc/codecs/Kconfig                                             |    3 
 sound/soc/codecs/rt5663.c                                            |   12 
 sound/soc/fsl/fsl_asrc.c                                             |   69 
 sound/soc/fsl/fsl_mqs.c                                              |    2 
 sound/soc/fsl/imx-card.c                                             |   32 
 sound/soc/fsl/imx-hdmi.c                                             |    2 
 sound/soc/intel/boards/sof_sdw.c                                     |    2 
 sound/soc/intel/catpt/dsp.c                                          |   14 
 sound/soc/intel/skylake/skl-pcm.c                                    |    1 
 sound/soc/mediatek/mt8173/mt8173-max98090.c                          |    3 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                            |    2 
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c                   |    6 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c           |    7 
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c              |    6 
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c                           |    2 
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c                           |   73 
 sound/soc/mediatek/mt8195/mt8195-reg.h                               |    1 
 sound/soc/samsung/idma.c                                             |    2 
 sound/soc/uniphier/Kconfig                                           |    2 
 sound/usb/format.c                                                   |    2 
 sound/usb/mixer_quirks.c                                             |    2 
 sound/usb/quirks.c                                                   |    2 
 tools/bpf/bpftool/Documentation/Makefile                             |    1 
 tools/bpf/bpftool/Documentation/bpftool-btf.rst                      |    2 
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst                   |    2 
 tools/bpf/bpftool/Documentation/bpftool-gen.rst                      |    2 
 tools/bpf/bpftool/Documentation/bpftool-link.rst                     |    2 
 tools/bpf/bpftool/Documentation/bpftool-map.rst                      |    6 
 tools/bpf/bpftool/Documentation/bpftool-prog.rst                     |    8 
 tools/bpf/bpftool/Documentation/bpftool.rst                          |    6 
 tools/bpf/bpftool/Makefile                                           |    1 
 tools/bpf/bpftool/main.c                                             |    2 
 tools/bpf/bpftool/prog.c                                             |   15 
 tools/include/nolibc/nolibc.h                                        |   33 
 tools/lib/bpf/btf.c                                                  |   55 
 tools/lib/bpf/btf.h                                                  |    2 
 tools/lib/bpf/btf_dump.c                                             |    2 
 tools/lib/bpf/gen_loader.c                                           |    4 
 tools/lib/bpf/libbpf.c                                               |    5 
 tools/lib/bpf/linker.c                                               |    6 
 tools/perf/Makefile.config                                           |    5 
 tools/perf/util/debug.c                                              |    2 
 tools/perf/util/evsel.c                                              |   25 
 tools/perf/util/probe-event.c                                        |    3 
 tools/testing/selftests/bpf/btf_helpers.c                            |    9 
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c                    |    5 
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c           |    4 
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c                     |    2 
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c                 |    7 
 tools/testing/selftests/clone3/clone3.c                              |    6 
 tools/testing/selftests/ftrace/test.d/kprobe/profile.tc              |    2 
 tools/testing/selftests/kselftest_harness.h                          |    2 
 tools/testing/selftests/powerpc/security/spectre_v2.c                |    2 
 tools/testing/selftests/powerpc/signal/.gitignore                    |    1 
 tools/testing/selftests/powerpc/signal/Makefile                      |    1 
 tools/testing/selftests/powerpc/signal/sigreturn_kernel.c            |  132 +
 tools/testing/selftests/vm/hmm-tests.c                               |   42 
 890 files changed, 9002 insertions(+), 5089 deletions(-)

Aaron Ma (1):
      ath11k: qmi: avoid error messages when dma allocation fails

Adam Ford (1):
      clk: imx8mn: Fix imx8mn_clko1_sels

Adam Ward (1):
      regulator: da9121: Prevent current limit change when enabled

Adrian Hunter (1):
      perf script: Fix hex dump character output

Alan Maguire (1):
      libbpf: Silence uninitialized warning/error in btf_dump_dump_type_data

Alan Stern (1):
      scsi: block: pm: Always set request queue runtime active in blk_post_runtime_resume()

Alex Deucher (2):
      drm/amdgpu/display: set vblank_disable_immediate for DC
      drm/amdgpu: don't do resets on APUs which don't support it

Alex Elder (2):
      ARM: dts: qcom: sdx55: fix IPA interconnect definitions
      net: ipa: fix atomic update in ipa_endpoint_replenish()

Alexander Aring (3):
      fs: dlm: don't call kernel_getpeername() in error_report()
      fs: dlm: fix build with CONFIG_IPV6 disabled
      fs: dlm: filter user dlm messages for kernel locks

Alexander Gordeev (1):
      s390/mm: fix 2KB pgtable release race

Alexander Lobakin (2):
      samples: bpf: Fix xdp_sample_user.o linking with Clang
      samples: bpf: Fix 'unknown warning group' build warning on Clang

Alexander Stein (4):
      arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name
      arm64: dts: amlogic: Fix SPI NOR flash node name for ODROID N2/N2+
      dt-bindings: display: meson-dw-hdmi: add missing sound-name-prefix property
      dt-bindings: display: meson-vpu: Add missing amlogic,canvas property

Alexander Usyskin (1):
      mei: hbm: fix client dma reply status

Alexandre Ghiti (3):
      riscv: Get rid of MAXPHYSMEM configs
      Documentation, arch: Remove leftovers from raw device
      Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH

Alexei Starovoitov (2):
      libbpf: Clean gen_loader's attach kind.
      bpf: Adjust BTF log size limit.

Alexey Kardashevskiy (2):
      KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
      KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST

Alistair Francis (2):
      HID: quirks: Allow inverting the absolute X/Y values
      HID: i2c-hid-of: Expose the touchscreen-inverted properties

Alistair Popple (1):
      mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault

Alyssa Ross (2):
      serial: liteuart: fix MODULE_ALIAS
      ASoC: fsl_mqs: fix MODULE_ALIAS

Amelie Delaunay (1):
      dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK

Amjad Ouled-Ameur (1):
      usb: dwc3: meson-g12a: fix shared reset control use

Ammar Faizi (2):
      tools/nolibc: x86-64: Fix startup code bug
      powerpc/xive: Add missing null check after calling kmalloc

Anders Roxell (2):
      selftests: clone3: clone3: add case CLONE3_ARGS_NO_TEST
      powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Andre Przywara (1):
      ARM: 9159/1: decompressor: Avoid UNPREDICTABLE NOP encoding

Andreas Oetken (1):
      mtd: Fixed breaking list in __mtd_del_partition.

Andrew Lunn (3):
      seg6: export get_srh() for ICMP handling
      icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
      udp6: Use Segment Routing Header for dest address if present

Andrey Konovalov (1):
      lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Andrey Ryabinin (2):
      cputime, cpuacct: Include guest time in user time in cpuacct.stat
      sched/cpuacct: Fix user/system in shown cpuacct.usage*

Andrii Nakryiko (9):
      libbpf: Free up resources used by inner map definition
      libbpf: Fix potential misaligned memory access in btf_ext__new()
      libbpf: Fix glob_syms memory leak in bpf_linker
      libbpf: Fix using invalidated memory in bpf_linker
      samples/bpf: Clean up samples/bpf build failes
      selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
      selftests/bpf: Destroy XDP link correctly
      selftests/bpf: Fix bpf_object leak in skb_ctx selftest
      libbpf: Accommodate DWARF/compiler bug with duplicated structs

Andy Shevchenko (1):
      misc: at25: Make driver OF independent again

AngeloGioacchino Del Regno (1):
      mmc: mtk-sd: Use readl_poll_timeout instead of open-coded polling

Anilkumar Kolli (1):
      ath11k: Use host CE parameters for CE interrupts configuration

Antoine Tenart (1):
      net-sysfs: update the queue counts in the unregistration path

Anton Vasilyev (1):
      media: dw2102: Fix use after free

Antony Antony (3):
      xfrm: interface with if_id 0 should return error
      xfrm: state and policy should fail if XFRMA_IF_ID 0
      xfrm: rate limit SA mapping change message to user space

Archie Pusaka (1):
      Bluetooth: Fix removing adv when processing cmd complete

Ard Biesheuvel (1):
      net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account

Arnaud Pouliquen (1):
      rpmsg: core: Clean up resources on announce_create failure.

Arnd Bergmann (2):
      gpu: host1x: select CONFIG_DMA_SHARED_BUFFER
      dmaengine: pxa/mmp: stop referencing config->slave_id

Arseny Demidov (1):
      hwmon: (mr75203) fix wrong power-up delay value

Athira Rajeev (1):
      powerpc/perf: Fix PMU callbacks to clear pending PMI before resetting an overflown PMC

Avihai Horon (2):
      RDMA/core: Let ib_find_gid() continue search even after empty entry
      RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry

Avraham Stern (3):
      iwlwifi: mvm: perform 6GHz passive scan after suspend
      iwlwifi: mvm: set protected flag only for NDP ranging
      iwlwifi: mvm: fix AUX ROC removal

Aya Levin (3):
      net/mlx5e: Fix page DMA map/unmap attributes
      Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
      Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"

Baochen Qiang (2):
      ath11k: Fix crash caused by uninitialized TX ring
      ath11k: Avoid false DEADLOCK warning reported by lockdep

Baoquan He (3):
      mm_zone: add function to check if managed dma zone exists
      dma/pool: create dma atomic pool only if dma zone has managed pages
      mm/page_alloc.c: do not warn allocation failure on zone DMA if no managed pages

Bart Van Assche (4):
      scsi: core: Fix scsi_device_max_queue_depth()
      scsi: ufs: Fix race conditions related to driver data
      scsi: ufs: Fix a kernel crash during shutdown
      scsi: core: Show SCMD_LAST in text form

Baruch Siach (3):
      arm64: dts: qcom: ipq6018: Fix gpio-ranges property
      of: base: Fix phandle argument length mismatch error message
      of: base: Improve argument length mismatch error

Ben Greear (1):
      ath11k: Fix napi related hang

Ben Hutchings (1):
      firmware: Update Kconfig help text for Google firmware

Ben Skeggs (1):
      drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

Benjamin Li (3):
      wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
      wcn36xx: populate band before determining rate on RX
      wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

Bernard Zhao (1):
      selinux: fix potential memleak in selinux_add_opt()

Bhaumik Bhatt (1):
      bus: mhi: core: Fix reading wake_capable channel configuration

Bhupesh Sharma (1):
      net: stmmac: Add platform level debug register dump feature

Biju Das (2):
      arm64: dts: renesas: cat875: Add rx/tx delays
      mmc: tmio: reinit card irqs in reset routine

Biwen Li (1):
      arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus

Bixuan Cui (1):
      ALSA: oss: fix compile error when OSS_DEBUG is enabled

Borislav Petkov (4):
      x86/mce: Allow instrumentation during task work queueing
      x86/mce: Mark mce_panic() noinstr
      x86/mce: Mark mce_end() noinstr
      x86/mce: Mark mce_read_aux() noinstr

Brian Chen (1):
      psi: Fix PSI_MEM_FULL state when tasks are in memstall and doing reclaim

Brian Norris (9):
      drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure
      drm/panel: innolux-p079zca: Delete panel on attach() failure
      drm/rockchip: dsi: Fix unbalanced clock on probe error
      drm/rockchip: dsi: Hold pm-runtime across bind/unbind
      drm/rockchip: dsi: Disable PLL clock on bind error
      drm/rockchip: dsi: Reconfigure hardware on resume()
      mwifiex: Fix possible ABBA deadlock
      drm/panel: Delete panel on mipi_dsi_attach() failure
      drm/bridge: analogix_dp: Make PSR-exit block less

Bryan O'Donoghue (4):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
      wcn36xx: Fix DMA channel enable/disable cycle
      wcn36xx: Release DMA channel descriptor allocations
      wcn36xx: Put DXE block into reset before freeing memory

Cezary Rojewski (1):
      ASoC: Intel: catpt: Test dmaengine_submit() result before moving on

Changcheng Deng (1):
      PM: AVS: qcom-cpr: Use div64_ul instead of do_div

Chao Yu (5):
      f2fs: fix to do sanity check on inode type during garbage collection
      f2fs: fix to do sanity check in is_alive()
      f2fs: fix to avoid panic in is_alive() if metadata is inconsistent
      f2fs: fix to reserve space for IO align feature
      f2fs: fix to check available space of CP area correctly in update_ckpt_flags()

Chen Jun (1):
      tpm: add request_locality before write TPM_INT_ENABLE

Chen-Yu Tsai (1):
      media: hantro: Hook up RK3399 JPEG encoder output

Chengfeng Ye (4):
      crypto: qce - fix uaf on qce_aead_register_one
      crypto: qce - fix uaf on qce_ahash_register_one
      crypto: qce - fix uaf on qce_skcipher_register_one
      HSI: core: Fix return freed object in hsi_new_client

Chengguang Xu (1):
      RDMA/rxe: Fix a typo in opcode name

Christian A. Ehrhardt (2):
      ALSA: hda/cs8409: Increase delay during jack detection
      ALSA: hda/cs8409: Fix Jack detection after resume

Christian Eggers (1):
      mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings

Christian Hewitt (2):
      arm64: dts: meson-gxbb-wetek: fix HDMI in early boot
      arm64: dts: meson-gxbb-wetek: fix missing GPIO binding

Christian König (1):
      drm/radeon: fix error handling in radeon_driver_open_kms

Christian Lamparter (1):
      ARM: dts: gemini: NAS4220-B: fis-index-block with 128 KiB sectors

Christoph Hellwig (3):
      block: fix error unwinding in device_add_disk
      dm: fix alloc_dax error handling in alloc_dev
      scsi: sr: Don't use GFP_DMA

Christophe JAILLET (5):
      media: venus: core: Fix a potential NULL pointer dereference in an error handling path
      media: venus: core: Fix a resource leak in the error handling path of 'venus_probe()'
      RDMA/bnxt_re: Scan the whole bitmap when checking if "disabling RCFW with pending cmd-bit"
      HID: magicmouse: Fix an error handling path in magicmouse_probe()
      remoteproc: imx_rproc: Fix a resource leak in the remove function

Christophe Jaillet (1):
      tpm_tis: Fix an error handling path in 'tpm_tis_core_init()'

Christophe Leroy (7):
      lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
      powerpc/modules: Don't WARN on first module allocation attempt
      powerpc/32s: Fix shift-out-of-bounds in KASAN init
      powerpc/powermac: Add additional missing lockdep_register_key()
      powerpc/powermac: Add missing lockdep_register_key()
      w1: Misuse of get_user()/put_user() reported by sparse
      powerpc/40x: Map 32Mbytes of memory at startup

Chunfeng Yun (1):
      phy: phy-mtk-tphy: add support efuse setting

Chunguang Xu (1):
      ext4: fix a possible ABBA deadlock due to busy PA

Claudiu Beznea (3):
      mfd: atmel-flexcom: Remove #ifdef CONFIG_PM_SLEEP
      mfd: atmel-flexcom: Use .resume_noirq
      net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices

Clément Léger (1):
      software node: fix wrong node passed to find nargs_prop

Conor Dooley (2):
      clk: bm1880: remove kfrees on static allocations
      mailbox: change mailbox-mpfs compatible string

D Scott Phillips (1):
      arm64: errata: Fix exec handling in erratum 1418040 workaround

Dafna Hirschfeld (1):
      media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Dan Carpenter (11):
      ksmbd: uninitialized variable in create_socket()
      drm/bridge: display-connector: fix an uninitialized pointer in probe()
      media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()
      drm/vboxvideo: fix a NULL vs IS_ERR() check
      wilc1000: fix double free error in probe()
      crypto: octeontx2 - prevent underflow in get_cores_bmap()
      rocker: fix a sleeping in atomic bug
      Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
      ax25: uninitialized variable in ax25_setsockopt()
      netrom: fix api breakage in nr_setsockopt()
      crypto: octeontx2 - uninitialized variable in kvf_limits_store()

Dan Williams (1):
      cxl/pmem: Fix reference counting for delayed work

Daniel Borkmann (2):
      bpf: Don't promote bogus looking registers after null check.
      bpf: Mark PTR_TO_FUNC register initially with zero offset

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix return values and refactor MDIO ops

Daniel Scally (1):
      media: i2c: Re-order runtime pm initialisation

Daniel Thompson (1):
      Documentation: dmaengine: Correctly describe dmatest with channel unset

Danielle Ratson (2):
      mlxsw: pci: Add shutdown method in PCI driver
      mlxsw: pci: Avoid flow control for EMAD packets

Dario Binacchi (1):
      can: flexcan: allow to change quirks at runtime

Dave Jiang (1):
      dmaengine: idxd: fix wq settings post wq disable

David Gow (1):
      kunit: Don't crash if no parameters are generated

David Heidelberg (1):
      arm64: dts: qcom: msm8996: drop not documented adreno properties

David Matlack (1):
      KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU

Dillon Min (3):
      media: videobuf2: Fix the size printk format
      ARM: dts: stm32: fix dtbs_check warning on ili9341 dts binding on stm32f429 disco
      clk: stm32: Fix ltdc's clock turn off by clk_disable_unused() after system enter shell

Dinh Nguyen (2):
      usb: dwc2: do not gate off the hardware if it does not support clock gating
      EDAC/synopsys: Use the quirk for version instead of ddr version

Dmitry Baryshkov (3):
      arm64: dts: qcom: msm8916: fix MMC controller aliases
      drm/msm/dsi: fix initialization in the bonded DSI case
      drm/msm/dpu: fix safe status debugfs file

Dmitry Osipenko (4):
      gpu: host1x: Add back arm_iommu_detach_device()
      drm/tegra: Add back arm_iommu_detach_device()
      mfd: tps65910: Set PWR_OFF bit during driver probe
      drm/tegra: submit: Add missing pm_runtime_mark_last_busy()

Dmitry Torokhov (1):
      HID: vivaldi: fix handling devices not using numbered reports

Dominik Brodowski (1):
      pcmcia: fix setting of kthread task states

Dongliang Mu (1):
      media: em28xx: fix memory leak in em28xx_init_dev

Edwin Peer (3):
      bnxt_en: Refactor coredump functions
      bnxt_en: move coredump functions into dedicated file
      bnxt_en: use firmware provided max timeout for messages

Eli Cohen (2):
      vdpa/mlx5: Fix wrong configuration of virtio_version_1_0
      vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()

Eric Dumazet (7):
      xfrm: fix a small bug in xfrm_sa_len()
      ppp: ensure minimum packet size in ppp_write()
      ipv4: update fib_info_cnt under spinlock protection
      ipv4: avoid quadratic behavior in netns dismantle
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
      netns: add schedule point in ops_exit_list()

Eric W. Biederman (1):
      taskstats: Cleanup the use of task->exit_code

Eugen Hristev (1):
      media: i2c: imx274: fix s_frame_interval runtime resume not requested

Fabio Estevam (3):
      media: imx-pxp: Initialize the spinlock prior to using it
      ath10k: Fix the MTU size on QCA9377 SDIO
      regmap: Call regmap_debugfs_exit() prior to _init()

Felix Fietkau (1):
      mt76: mt7615: improve wmm index allocation

Felix Kuehling (1):
      drm/amdkfd: Fix error handling in svm_range_add

Fengnan Chang (1):
      f2fs: fix remove page failed in invalidate compress pages

Filipe Manana (2):
      btrfs: fix deadlock between quota enable and other quota operations
      btrfs: respect the max size in the header when activating swap file

Florian Fainelli (1):
      net: mdio: Demote probed message to debug print

Florian Westphal (2):
      netfilter: bridge: add support for pppoe filtering
      netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone

Frank Rowand (1):
      of: unittest: 64 bit dma address test requires arch support

Frederic Weisbecker (1):
      rcu/exp: Mark current CPU as exp-QS in IPI loop second pass

Fugang Duan (1):
      tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()

Gang Li (1):
      shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Gaurav Jain (1):
      crypto: caam - save caam memory to support crypto engine retry mechanism.

Geert Uytterhoeven (1):
      riscv: dts: microchip: mpfs: Drop empty chosen node

Geliang Tang (1):
      mptcp: fix a DSS option writing error

George G. Davis (1):
      mtd: hyperbus: rpc-if: fix bug in rpcif_hb_remove

German Gomez (1):
      perf evsel: Override attr->sample_period for non-libpfm4 events

Ghalem Boudour (1):
      xfrm: fix policy lookup for ipv6 gre packets

Giovanni Cabiddu (1):
      crypto: qat - fix undetected PFVF timeout in ACK loop

Greg Kroah-Hartman (1):
      Linux 5.15.17

Guillaume Nault (4):
      mlx5: Don't accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
      gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
      libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

Haimin Zhang (1):
      USB: ehci_brcm_hub_control: Improve port index sanitizing

Hans Verkuil (3):
      media: cec: fix a deadlock situation
      media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE
      media: cec-pin: fix interrupt en/disable handling

Hans de Goede (10):
      media: i2c: ov8865: Fix lockdep error
      ACPI: scan: Create platform device for BCM4752 and LNV4752 ACPI nodes
      media: atomisp-ov2680: Fix ov2680_set_fmt() clobbering the exposure
      drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
      gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
      ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table
      ACPI: Change acpi_device_always_present() into acpi_device_override_status()
      ACPI / x86: Allow specifying acpi_device_override_status() quirks by path
      ACPI / x86: Add not-present quirk for the PCI0.SDHB.BRC1 device on the GPD win
      PCI: pciehp: Use down_read/write_nested(reset_lock) to fix lockdep errors

Hari Bathini (2):
      powerpc: handle kdump appropriately with crash_kexec_post_notifiers option
      powerpc/fadump: Fix inaccurate CPU state info in vmcore generated with panic

Hari Prasath (1):
      ARM: dts: at91: update alternate function of signal PD20

Harshad Shirwadkar (1):
      ext4: initialize err_blk before calling __ext4_get_inode_loc

Hector Martin (3):
      spi: Fix incorrect cs_setup delay handling
      iommu/io-pgtable-arm: Fix table descriptor paddr formatting
      mmc: sdhci-pci-gli: GL9755: Support for CD/WP inversion on OF platforms

Heiko Carstens (1):
      selftests/ftrace: make kprobe profile testcase description unique

Heiner Kallweit (2):
      i2c: i801: Don't silently correct invalid transfer size
      crypto: omap-aes - Fix broken pm_runtime_and_get() usage

Herbert Xu (1):
      crypto: stm32 - Revert broken pm_runtime_resume_and_get changes

Horatiu Vultur (1):
      net: ocelot: Fix the call to switchdev_bridge_port_offload

Hou Tao (1):
      bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)

Huang Rui (1):
      x86, sched: Fix undefined reference to init_freq_invariance_cppc() build error

Hyeong-Jun Kim (1):
      f2fs: compress: fix potential deadlock of compress file

Håkon Bugge (1):
      RDMA/cma: Remove open coding of overflow checking for private_data_len

Igor Pylypiv (1):
      scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()

Ilan Peer (2):
      iwlwifi: mvm: Fix calculation of frame length
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Ilia Mirkin (1):
      drm/nouveau/kms/nv04: use vzalloc for nv04_display

Ingo Molnar (1):
      x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs

Iwona Winiarska (2):
      gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock
      gpio: aspeed-sgpio: Convert aspeed_sgpio.lock to raw_spinlock

Jack Wang (1):
      RDMA/rtrs-clt: Fix the initial value of min_latency

Jackie Liu (1):
      drm/msm/dp: displayPort driver need algorithm rational

Jaegeuk Kim (1):
      f2fs: avoid EINVAL by SBI_NEED_FSCK when pinning a file

Jakub Kicinski (2):
      crypto: x86/aesni - don't require alignment of data
      selftests: harness: avoid false negatives if test has no ASSERTs

James Hilliard (1):
      media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

James Smart (3):
      scsi: lpfc: Fix leaked lpfc_dmabuf mbox allocations with NPIV
      scsi: lpfc: Trigger SLI4 firmware dump before doing driver cleanup
      scsi: lpfc: Fix lpfc_force_rscn ndlp kref imbalance

Jammy Huang (2):
      media: aspeed: fix mode-detect always time out at 2nd run
      media: aspeed: Update signal status immediately to ensure sane hw state

Jan Kara (5):
      bfq: Do not let waker requests skip proper accounting
      ext4: avoid trim error on fs with small groups
      udf: Fix error handling in udf_new_inode()
      ext4: make sure to reset inode lockdep class when quota enabling fails
      ext4: make sure quota gets properly shutdown on error

Jan Kiszka (1):
      soc: ti: pruss: fix referenced node in error message

Jann Horn (1):
      HID: uhid: Fix worker destroying device without any protection

Jason A. Donenfeld (1):
      random: do not throw away excess input to crng_fast_load

Jason Gerecke (3):
      HID: wacom: Reset expected and received contact counts at the same time
      HID: wacom: Ignore the confidence flag when a touch is removed
      HID: wacom: Avoid using stale array indicies to read contact count

Jens Axboe (1):
      block: fix async_depth sysfs interface for mq-deadline

Jens Wiklander (1):
      tee: fix put order in teedev_close_context()

Jernej Skrabec (1):
      media: hantro: Fix probe func error path

Jesper Dangaard Brouer (1):
      igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS

Jiasheng Jiang (9):
      media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes
      power: reset: mt6397: Check for null res pointer
      staging: greybus: audio: Check null pointer
      fsl/fman: Check for null pointer after calling devm_ioremap
      Bluetooth: hci_bcm: Check for error irq
      can: xilinx_can: xcan_probe(): check for error irq
      ASoC: rt5663: Handle device_property_read_u32_array error codes
      ASoC: mediatek: Check for error clk pointer
      ASoC: samsung: idma: Check of ioremap return value

Jie Wang (1):
      net: bonding: fix bond_xmit_broadcast return value error bug

Jim Quinlan (1):
      of: unittest: fix warning on PowerPC frame size warning

Jingwen Chen (2):
      drm/amd/amdgpu: fix psp tmr bo pin count leak in SRIOV
      drm/amd/amdgpu: fix gmc bo pin count leak in SRIOV

Jiri Olsa (1):
      bpf/selftests: Fix namespace mount setup in tc_redirect

Jiri Slaby (1):
      mxser: keep only !tty test in ISR

Jisheng Zhang (1):
      riscv: mm: fix wrong phys_ram_base value for RV64

Joakim Tjernlund (1):
      i2c: mpc: Correct I2C reset procedure

Joe Thornber (2):
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joerg Roedel (1):
      x86/mm: Flush global TLB when switching to trampoline page-table

Johan Hovold (9):
      media: flexcop-usb: fix control-message timeouts
      media: mceusb: fix control-message timeouts
      media: em28xx: fix control-message timeouts
      media: cpia2: fix control-message timeouts
      media: s2255: fix control-message timeouts
      media: redrat3: fix control-message timeouts
      media: pvrusb2: fix control-message timeouts
      media: stk1160: fix control-message timeouts
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (12):
      iwlwifi: mvm: fix 32-bit build in FTM
      um: fix ndelay/udelay defines
      um: rename set_signals() to um_set_signals()
      um: virt-pci: Fix 32-bit compile
      lib/logic_iomem: Fix 32-bit build
      lib/logic_iomem: Fix operation on 32-bit
      um: virtio_uml: Fix time-travel external time propagation
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: remove module loading failure message
      um: gitignore: Add kernel/capflags.c
      iwlwifi: fix Bz NMI behaviour

John David Anglin (2):
      parisc: Avoid calling faulthandler_disabled() twice
      parisc: Fix lpa and lpa_user defines

John Fastabend (2):
      bpf, sockmap: Fix return codes from tcp_bpf_recvmsg_parser()
      bpf, sockmap: Fix double bpf_prog_put on error case in map_link

John Keeping (2):
      usb: dwc2: gadget: initialize max_speed from params
      pinctrl/rockchip: fix gpio device creation

Jonathan Cameron (2):
      iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs
      iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046

Josef Bacik (3):
      btrfs: remove BUG_ON() in find_parent_nodes()
      btrfs: remove BUG_ON(!eie) in find_parent_nodes
      btrfs: check the root node for uptodate before returning it

Joseph Hwang (1):
      Bluetooth: refactor set_exp_feature with a feature table

José Expósito (6):
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_get_str_desc
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
      HID: magicmouse: Report battery level over USB
      HID: apple: Do not reset quirks when the Fn key is not found

José Roberto de Souza (1):
      drm/i915/display/ehl: Update voltage swing table

Julia Lawall (4):
      powerpc/6xx: add missing of_node_put
      powerpc/powernv: add missing of_node_put
      powerpc/cell: add missing of_node_put
      powerpc/btext: add missing of_node_put

Kai-Heng Feng (2):
      rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
      usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Kajol Jain (1):
      bpf: Remove config check to enable bpf support for branch records

Kamal Heib (3):
      RDMA/hns: Validate the pkey index
      RDMA/qedr: Fix reporting max_{send/recv}_wr attrs
      RDMA/cxgb4: Set queue pair state when being queried

Karl Kurbjun (1):
      HID: Ignore battery for Elan touchscreen on HP Envy X360 15t-dr100

Karthikeyan Kathirvel (2):
      ath11k: clear the keys properly via DISABLE_KEY
      ath11k: reset RSN/WPA present state for open BSS

Kees Cook (2):
      x86/uaccess: Move variable into switch case statement
      char/mwave: Adjust io port register size

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Kieran Bingham (1):
      arm64: dts: renesas: Fix thermal bindings

Kirill A. Shutemov (1):
      ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Kishon Vijay Abraham I (2):
      arm64: dts: ti: j7200-main: Fix 'dtbs_check' serdes_ln_ctrl node
      arm64: dts: ti: j721e-main: Fix 'dtbs_check' in serdes_ln_ctrl node

Konrad Dybcio (2):
      arm64: dts: qcom: sm8350: Shorten camera-thermal-bottom name
      regulator: qcom_smd: Align probe function with rpmh-regulator

Kris Van Hees (1):
      bpf: Fix verifier support for validation of async callbacks

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Kunihiko Hayashi (2):
      spi: uniphier: Fix a bug that doesn't point to private data correctly
      dmaengine: uniphier-xdmac: Fix type of address variables

Kuniyuki Iwashima (1):
      bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().

Kurt Kanzenbach (4):
      net: dsa: hellcreek: Fix insertion of static FDB entries
      net: dsa: hellcreek: Add STP forwarding rule
      net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
      net: dsa: hellcreek: Add missing PTP via UDP rules

Kyeong Yoo (1):
      jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Lad Prabhakar (6):
      mtd: hyperbus: rpc-if: Check return value of rpcif_sw_init()
      memory: renesas-rpc-if: Return error in case devm_ioremap_resource() fails
      serial: 8250_bcm7271: Propagate error codes from brcmuart_probe()
      can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device
      clk: renesas: rzg2l: Check return value of pm_genpd_init()
      clk: renesas: rzg2l: propagate return value of_genpd_add_provider_simple()

Lakshmi Sowjanya D (1):
      i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Laurence de Bruxelles (1):
      rtc: pxa: fix null pointer dereference

Laurent Pinchart (1):
      drm: rcar-du: Fix CRTC timings when CMM is used

Leon Romanovsky (1):
      devlink: Remove misleading internal_flags from health reporter dump

Li Hua (1):
      sched/rt: Try to restart rt period timer when rt runtime exceeded

Lino Sanfilippo (2):
      serial: amba-pl011: do not request memory region twice
      tpm: fix potential NULL pointer access in tpm_del_char_device

Linus Lüssing (1):
      batman-adv: allow netlink usage in unprivileged containers

Lizhi Hou (1):
      tty: serial: uartlite: allow 64 bit address

Loic Poulain (2):
      bus: mhi: pci_generic: Graceful shutdown on freeze
      wcn36xx: Fix max channels retrieval

Lu Baolu (1):
      iommu: Extend mutex lock scope in iommu_probe_device()

Luca Coelho (1):
      iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ

Lucas De Marchi (1):
      x86/gpu: Reserve stolen memory for first integrated Intel GPU

Lucas Stach (2):
      drm/etnaviv: consider completed fence seqno in hang check
      drm/etnaviv: limit submit sizes

Luiz Augusto von Dentz (5):
      Bluetooth: L2CAP: Fix not initializing sk_peer_pid
      Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag
      Bluetooth: L2CAP: Fix using wrong mode
      Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
      Bluetooth: hci_sync: Fix not setting adv set duration

Lukas Bulwahn (6):
      ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA
      ASoC: codecs: wcd938x: add SND_SOC_WCD938_SDW to codec list instead
      mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support
      mips: fix Kconfig reference to PHYS_ADDR_T_64BIT
      ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
      Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Lukas Wunner (4):
      serial: pl010: Drop CR register reset on set_termios
      serial: pl011: Drop CR register reset on set_termios
      serial: core: Keep mctrl register state and cached copy in sync
      serial: Fix incorrect rs485 polarity on uart open

Lukasz Luba (1):
      cpufreq: qcom-cpufreq-hw: Update offline CPUs per-cpu thermal pressure

Luís Henriques (1):
      ext4: set csum seed in tmp inode while migrating to extents

Lv Yunlong (1):
      wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma

Lyude Paul (1):
      drm/dp: Don't read back backlight mode in drm_edp_backlight_enable()

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to FW max capability

Manivannan Sadhasivam (1):
      bus: mhi: core: Fix race while handling SYS_ERR at power up

Mansur Alisha Shaik (2):
      media: venus: correct low power frequency calculation for encoder
      media: venus: avoid calling core_clk_setrate() concurrently during concurrent video sessions

Maor Dickman (4):
      net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
      net/mlx5e: Don't block routes with nexthop objects in SW
      net/mlx5e: Sync VXLAN udp ports during uplink representor profile change
      net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager

Marc Kleine-Budde (5):
      can: mcp251xfd: add missing newline to printed strings
      can: softing: softing_startstop(): fix set but not used variable warning
      can: flexcan: rename RX modes
      can: flexcan: add more quirks to describe RX path capabilities
      can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message

Marc Zyngier (1):
      irqchip/gic-v4: Disable redistributors' view of the VPE table at boot time

Marcelo Tosatti (1):
      KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock

Marco Chiappero (2):
      crypto: qat - remove unnecessary collision prevention step in PFVF
      crypto: qat - make pfvf send message direction agnostic

Marek Behún (1):
      ARM: dts: armada-38x: Add generic compatible to UART nodes

Marek Vasut (2):
      soc: imx: gpcv2: Synchronously suspend MIX domains
      crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Marijn Suijten (7):
      backlight: qcom-wled: Validate enabled string indices in DT
      backlight: qcom-wled: Pass number of elements to read to read_u32_array
      backlight: qcom-wled: Fix off-by-one maximum with default num_strings
      backlight: qcom-wled: Override default length with qcom,enabled-strings
      backlight: qcom-wled: Use cpu_to_le16 macro to perform conversion
      backlight: qcom-wled: Respect enabled-strings in set_brightness
      regulator: qcom-labibb: OCP interrupts are not a failure while disabled

Marina Nikolic (1):
      amdgpu/pm: Make sysfs pm attributes as read-only for VFs

Mario Limonciello (1):
      ACPI: CPPC: Check present CPUs for determining _CPC is valid

Mark Chen (2):
      Bluetooth: btusb: Handle download_firmware failure cases
      Bluetooth: btusb: Return error code when getting patch status failed

Mark Langsdorf (1):
      ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Mark Rutland (1):
      powerpc: Avoid discarding flags in system_call_exception()

Markus Reichl (1):
      net: usb: Correct reset handling of smsc95xx

Martin Blumenstingl (1):
      clk: meson: gxbb: Fix the SDM_EN bit for MPLL0 on GXBB

Martin Leung (1):
      drm/amd/display: add else to avoid double destroy clk_mgr

Martyn Welch (1):
      drm/bridge: megachips: Ensure both bridges are probed before registration

Mateusz Jończyk (1):
      rtc: cmos: take rtc_lock while reading from CMOS

Matthias Schiffer (1):
      scripts/dtc: dtx_diff: remove broken example from help text

Matthieu Baerts (1):
      mptcp: fix opt size when sending DSS + MP_FAIL

Mauro Carvalho Chehab (8):
      media: atomisp: fix enum formats logic
      media: atomisp: fix try_fmt logic
      media: atomisp: set per-device's default mode
      media: atomisp: check before deference asd variable
      media: atomisp: handle errors at sh_css_create_isp_params()
      media: m920x: don't use stack on USB reads
      scripts: sphinx-pre-install: add required ctex dependency
      scripts: sphinx-pre-install: Fix ctex support on Debian

Maxim Levitsky (5):
      iommu/amd: Restore GA log/tail pointer on host resume
      iommu/amd: X2apic mode: re-enable after resume
      iommu/amd: X2apic mode: setup the INTX registers on mask/unmask
      iommu/amd: X2apic mode: mask/unmask interrupts on suspend/resume
      iommu/amd: Remove useless irq affinity notifier

Maxim Mikityanskiy (2):
      bpf: Fix the test_task_vma selftest to support output shorter than 1 kB
      sch_api: Don't skip qdisc attach on ingress

Maxime Ripard (13):
      clk: bcm-2835: Pick the closest clock rate
      clk: bcm-2835: Remove rounding up the dividers
      drm/vc4: hdmi: Set a default HSM rate
      drm/vc4: hdmi: Move the HSM clock enable to runtime_pm
      drm/vc4: hdmi: Make sure the controller is powered in detect
      drm/vc4: hdmi: Make sure the controller is powered up during bind
      drm/vc4: hdmi: Rework the pre_crtc_configure error handling
      drm/vc4: crtc: Make sure the HDMI controller is powered when disabling
      drm/vc4: hdmi: Enable the scrambler on reconnection
      drm/vc4: hdmi: Make sure the device is powered with CEC
      drm/vc4: crtc: Drop feed_txp from state
      drm/vc4: Fix non-blocking commit getting stuck forever
      drm/vc4: crtc: Copy assigned channel to the CRTC

Meng Li (1):
      crypto: caam - replace this_cpu_ptr with raw_cpu_ptr

Merlijn Wajer (1):
      leds: lp55xx: initialise output direction from dts

Miaoqian Lin (10):
      Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe
      usb: dwc3: qcom: Fix NULL vs IS_ERR checking in dwc3_qcom_probe
      drivers/firmware: Add missing platform_device_put() in sysfb_create_simplefb
      spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
      phy: mediatek: Fix missing check in mtk_mipi_tx_probe
      scsi: ufs: ufs-mediatek: Fix error checking in ufs_mtk_init_va09_pwr_ctrl()
      parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
      gpio: mpc8xxx: Fix IRQ check in mpc8xxx_probe
      gpio: idt3243x: Fix IRQ check in idt_gpio_probe
      lib82596: Fix IRQ check in sni_82596_probe

Michael Ellerman (4):
      powerpc/64s: Mask NIP before checking against SRR0
      powerpc/64s: Use EMIT_WARN_ENTRY for SRR debug warnings
      powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
      selftests/powerpc: Add a test of sigreturning to the kernel

Michael Kuron (1):
      media: dib0700: fix undefined behavior in tuner shutdown

Michael S. Tsirkin (1):
      virtio_ring: mark ring unused on error

Michael Walle (1):
      mtd: core: provide unique name for nvmem device

Michal Suchanek (1):
      debugfs: lockdown: Allow reading debugfs files that are not world readable

Mika Westerberg (1):
      thunderbolt: Runtime PM activate both ends of the device link

Mike Leach (1):
      Documentation: coresight: Fix documentation issue

Mikhail Rudenko (1):
      media: rockchip: rkisp1: use device name for debugfs subdir name

Miroslav Lichvar (2):
      net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets
      net: fix sock_timestamping_bind_phc() to release device

Mohammad Athari Bin Ismail (1):
      net: phy: marvell: add Marvell specific PHY loopback

Moshe Shemesh (2):
      net/mlx5: Set command entry semaphore up once got index free
      Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Moshe Tal (1):
      bonding: Fix extraction of ports from the packet headers

Namjae Jeon (5):
      ksmbd: fix guest connection failure with nautilus
      ksmbd: add support for smb2 max credit parameter
      ksmbd: move credit charge deduction under processing request
      ksmbd: limits exceeding the maximum allowable outstanding requests
      ksmbd: add reserved room in ipc request/response

Nathan Chancellor (3):
      x86/boot/compressed: Move CLANG_FLAGS to beginning of KBUILD_CFLAGS
      iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
      MIPS: Loongson64: Use three arguments for slti

Nathan Errera (1):
      iwlwifi: mvm: test roc running status bits before removing the sta

Neal Liu (1):
      usb: uhci: add aspeed ast2600 uhci support

Neil Armstrong (1):
      drm/bridge: dw-hdmi: handle ELD when DRM_BRIDGE_ATTACH_NO_CONNECTOR

Nicholas Kazlauskas (1):
      drm/amd/display: Fix out of bounds access on DNC31 stream encoder regs

Nicholas Piggin (2):
      powerpc/watchdog: Fix missed watchdog reset due to memory ordering race
      powerpc/64s/radix: Fix huge vmap false positive

Nick Kossifidis (3):
      riscv: try to allocate crashkern region from 32bit addressible memory
      riscv: Don't use va_pa_offset on kdump
      riscv: use hart id instead of cpu id on machine_kexec

Nicolas Dichtel (1):
      xfrm: fix dflt policy check when there is no policy configured

Nicolas Toromanoff (6):
      crypto: stm32/cryp - fix CTR counter carry
      crypto: stm32/cryp - fix xts and race condition in crypto_engine requests
      crypto: stm32/cryp - check early input data
      crypto: stm32/cryp - fix double pm exit
      crypto: stm32/cryp - fix lrw chaining mode
      crypto: stm32/cryp - fix bugs and crash in tests

Nikita Yushchenko (1):
      tracing/osnoise: Properly unhook events if start_per_cpu_kthreads() fails

Niklas Söderlund (2):
      dt-bindings: thermal: Fix definition of cooling-maps contribution property
      media: rcar-vin: Update format alignment constraints

Nishanth Menon (4):
      arm64: dts: ti: k3-am642: Fix the L2 cache sets
      arm64: dts: ti: k3-j7200: Fix the L2 cache sets
      arm64: dts: ti: k3-j721e: Fix the L2 cache sets
      arm64: dts: ti: k3-j7200: Correct the d-cache-sets info

Ohad Sharabi (1):
      habanalabs: skip read fw errors if dynamic descriptor invalid

Oleksandr Andrushchenko (1):
      xen/gntdev: fix unmap notification order

Oleksij Rempel (1):
      thermal/drivers/imx: Implement runtime PM support

Pablo Neira Ayuso (1):
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Pali Rohár (5):
      PCI: pci-bridge-emul: Make expansion ROM Base Address register read-only
      PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space
      PCI: pci-bridge-emul: Fix definitions of reserved bits
      PCI: pci-bridge-emul: Correctly set PCIe capabilities
      PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device

Panicker Harish (1):
      Bluetooth: hci_qca: Stop IBS timer during BT OFF

Paolo Abeni (2):
      mptcp: fix per socket endpoint accounting
      bpf: Do not WARN in bpf_warn_invalid_xdp_action()

Patrick Williams (1):
      tpm: fix NPE on probe for missing device

Paul Blakey (4):
      net/mlx5e: Fix matching on modified inner ip_ecn bits
      net/sched: flow_dissector: Fix matching on zone id for invalid conns
      net: openvswitch: Fix matching zone id for invalid conns arriving from tc
      net: openvswitch: Fix ct_state nat flags for conns arriving from tc

Paul Cercueil (7):
      mtd: rawnand: davinci: Don't calculate ECC when reading page
      mtd: rawnand: davinci: Avoid duplicated page read
      mtd: rawnand: davinci: Rewrite function description
      mtd: rawnand: Export nand_read_page_hwecc_oob_first()
      mtd: rawnand: ingenic: JZ4740 needs 'oob_first' read page function
      MIPS: boot/compressed/: add __ashldi3 to target for ZSTD compression
      MIPS: compressed: Fix build with ZSTD compression

Paul Chaignon (1):
      bpftool: Enable line buffering for stdout

Paul Gerber (1):
      thermal/drivers/imx8mm: Enable ADC when enabling monitor

Paul Moore (1):
      audit: ensure userspace is penalized the same as the kernel when under pressure

Pavankumar Kondeti (1):
      usb: gadget: f_fs: Use stream_open() for endpoint files

Pavel Begunkov (1):
      io_uring: remove double poll on poll update

Pavel Hofman (1):
      usb: gadget: u_audio: Subdevice 0 for capture ctls

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peiwei Hu (1):
      powerpc/prom_init: Fix improper check of prom_getprop()

Peng Fan (1):
      arm64: dts: ti: k3-j721e: correct cache-sets info

Peng Hao (1):
      virtio/virtio_mem: handle a possible NULL as a memcpy parameter

Peter Chiu (1):
      mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()

Peter Gonda (1):
      crypto: ccp - Move SEV_INIT retry for corrupted data

Petr Cvachoucek (1):
      ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Philipp Zabel (1):
      media: coda: fix CODA960 JPEG encoder buffer overflow

Pierre-Louis Bossart (1):
      ASoC: Intel: sof_sdw: fix jack detection on HP Spectre x360 convertible

Ping-Ke Shih (2):
      rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC
      mac80211: allow non-standard VHT MCS-10/11

Pingfan Liu (1):
      efi: apply memblock cap after memblock_add()

Po-Hao Huang (1):
      rtw88: 8822c: update rx settings to prevent potential hw deadlock

Prasad Malisetty (1):
      arm64: dts: qcom: sc7280: Fix incorrect clock name

Qiang Yu (1):
      drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y

Quentin Monnet (4):
      bpftool: Fix memory leak in prog_dump()
      samples/bpf: Install libbpf headers when building
      bpftool: Remove inclusion of utilities.mak from Makefiles
      bpftool: Fix indent in option lists in the documentation

Raed Salem (1):
      net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path

Rafael J. Wysocki (5):
      ACPI: EC: Rework flushing of EC work while suspended to idle
      PM: runtime: Add safety net to supplier device release
      cpufreq: Fix initialization of min and max frequency QoS requests
      ACPICA: Utilities: Avoid deleting the same object twice in a row
      ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Rameshkumar Sundaram (2):
      ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware
      ath11k: Fix deleting uninitialized kernel timer during fragment cache flush

Randy Dunlap (5):
      mips: lantiq: add support for clk_set_parent()
      mips: bcm63xx: add support for clk_set_parent()
      um: registers: Rename function names to avoid conflicts and build problems
      media: correct MEDIA_TEST_SUPPORT help text
      Documentation: fix firewire.rst ABI file path error

Reiji Watanabe (2):
      arm64: clear_page() shouldn't use DC ZVA when DCZID_EL0.DZP == 1
      arm64: mte: DC {GVA,GZVA} shouldn't be used when DCZID_EL0.DZP == 1

Rob Clark (2):
      drm/msm/gpu: Don't allow zero fence_id
      iommu/arm-smmu-qcom: Fix TTBR0 read

Rob Herring (1):
      PCI: xgene: Fix IB window setup

Robert Hancock (10):
      clk: si5341: Fix clock HW provider cleanup
      net: axienet: increase reset timeout
      net: axienet: Wait for PhyRstCmplt after core reset
      net: axienet: reset core on initialization prior to MDIO access
      net: axienet: add missing memory barriers
      net: axienet: limit minimum TX ring size
      net: axienet: Fix TX ring slot available check
      net: axienet: fix number of TX ring slots for available check
      net: axienet: fix for TX busy handling
      net: axienet: increase default TX ring size to 128

Robert Marko (2):
      arm64: dts: marvell: cn9130: add GPIO and SPI aliases
      arm64: dts: marvell: cn9130: enable CP0 GPIO controllers

Robert Schlabbach (1):
      media: si2157: Fix "warm" tuner state detection

Robin Murphy (2):
      perf/arm-cmn: Fix CPU hotplug unregistration
      drm/tegra: vic: Fix DMA API misuse

Russell King (Oracle) (4):
      net: phy: prefer 1000baseT over 1000baseKX
      net: phy: marvell: configure RGMII delays for 88E1118
      net: gemini: allow any RGMII interface mode
      net: sfp: fix high power modules without diagnostic monitoring

Ryuta NAKANISHI (1):
      phy: uniphier-usb3ss: fix unintended writing zeros to PHY register

Sakari Ailus (3):
      media: ov8865: Disable only enabled regulators on error path
      device property: Fix fwnode_graph_devcon_match() fwnode leak
      Documentation: ACPI: Fix data node reference documentation

Sam Protsenko (1):
      dt-bindings: watchdog: Require samsung,syscon-phandle for Exynos7

Sameer Pujar (1):
      arm64: tegra: Remove non existent Tegra194 reset

Sean Christopherson (1):
      RISC-V: Use common riscv_cpuid_to_hartid_mask() for both SMP=y and SMP=n

Sean Wang (2):
      Bluetooth: btmtksdio: fix resume failure
      mt76: mt7921: drop offload_flags overwritten

Sean Young (1):
      media: igorplugusb: receiver overflow should be reported

Sebastian Andrzej Siewior (1):
      ext4: destroy ext4_fc_dentry_cachep kmemcache on module removal

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

Sergey Shtylyov (3):
      mmc: meson-mx-sdhc: add IRQ check
      mmc: meson-mx-sdio: add IRQ check
      bcmgenet: add WOL IRQ check

Shaul Triebitz (1):
      iwlwifi: mvm: avoid clearing a just saved session protection id

Shay Drory (1):
      net/mlx5: Fix access to sf_dev_table on allocation failure

Shengjiu Wang (4):
      ASoC: imx-card: Need special setting for ak4497 on i.MX8MQ
      ASoC: imx-card: Fix mclk calculation issue for akcodec
      ASoC: imx-card: improve the sound quality for low rate
      ASoC: fsl_asrc: refine the check of available clock divider

Sicelo A. Mhlongo (1):
      ARM: dts: omap3-n900: Fix lp5523 for multi color

Slark Xiao (1):
      net: wwan: Fix MRU mismatch issue which may lead to data connection lost

Soenke Huster (1):
      Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()

Sreekanth Reddy (1):
      scsi: mpi3mr: Fixes around reply request queues

Srinivas Kandagatla (2):
      arm64: dts: qcom: c630: Fix soundcard setup
      nvmem: core: set size for sysfs bin file

Sriram R (1):
      ath11k: Avoid NULL ptr access during mgmt tx cleanup

Stafford Horne (1):
      openrisc: Add clone3 ABI wrapper

Stefan Riedmueller (1):
      mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6

Stephan Gerhold (1):
      interconnect: qcom: rpm: Prevent integer overflow in rate

Stephan Müller (1):
      crypto: jitter - consider 32 LSB for APT

Stephen Boyd (3):
      drm/bridge: ti-sn65dsi86: Set max register for regmap
      of/fdt: Don't worry about non-memory region overlap for no-map
      clk: Emit a stern warning with writable debugfs enabled

Steven Rostedt (1):
      tracing: Have syscall trace events use trace_event_buffer_lock_reserve()

Subbaraya Sundeep (1):
      octeontx2-af: Increment ptp refcount before use

Sudeep Holla (1):
      ACPICA: Fix wrong interpretation of PCC address

Suresh Kumar (1):
      net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Suresh Udipi (2):
      media: rcar-csi2: Correct the selection of hsfreqrange
      media: rcar-csi2: Optimize the selection PHTW register

Sven Eckelmann (1):
      ath11k: Fix ETSI regd with weather radar overlap

Swapnil Jakhade (1):
      phy: cadence: Sierra: Fix to get correct parent for mux clocks

Takashi Iwai (7):
      ALSA: core: Fix SSID quirk lookup for subvendor=0
      ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
      ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
      ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
      ALSA: hda: Fix potential deadlock at codec unbinding
      ALSA: usb-audio: Drop superfluous '0' in Presonus Studio 1810c's ID
      ALSA: seq: Set upper limit of processed events

Taniya Das (1):
      clk: qcom: gcc-sc7280: Mark gcc_cfg_noc_lpass_clk always enabled

Tasos Sahanidis (1):
      floppy: Fix hang in watchdog when disk is ejected

Tedd Ho-Jeong An (1):
      Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader

Tetsuo Handa (3):
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()
      block: check minor range in device_add_disk()

Thadeu Lima de Souza Cascardo (1):
      selftests/powerpc/spectre_v2: Return skip code when miss_percent is high

Theodore Ts'o (1):
      ext4: don't use the orphan list when migrating an inode

Thierry Reding (2):
      drm/tegra: gr2d: Explicitly control module reset
      arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Thomas Gleixner (2):
      ALSA: hda: Make proper use of timecounter
      PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()

Thomas Hellström (1):
      dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()

Thomas Weißschuh (1):
      ACPI: battery: Add the ThinkPad "Not Charging" quirk

Tianjia Zhang (1):
      MIPS: Octeon: Fix build errors using clang

Tobias Waldekranz (3):
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Add workaround for erratum A-009885
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Todd Kjos (2):
      binder: fix handling of error during copy
      binder: avoid potential data leakage when copying txn

Toke Høiland-Jørgensen (1):
      xdp: check prog type before updating BPF link

Tom Rix (2):
      net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
      net: mscc: ocelot: fix using match before it is set

Trevor Wu (2):
      ASoC: mediatek: mt8195: correct default value
      ASoC: mediatek: mt8195: correct pcmif BE dai control flow

Tsuchiya Yuto (8):
      media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()
      media: atomisp: fix punit_ddr_dvfs_enable() argument for mrfld_power up case
      media: atomisp: fix inverted logic in buffers_needed()
      media: atomisp: do not use err var when checking port validity for ISP2400
      media: atomisp: fix inverted error check for ia_css_mipi_is_source_port_valid()
      media: atomisp: fix ifdefs in sh_css.c
      media: atomisp: add NULL check for asd obtained from atomisp_video_pipe
      media: atomisp: fix "variable dereferenced before check 'asd'"

Tudor Ambarus (9):
      crypto: atmel-aes - Reestablish the correct tfm context at dequeue
      tty: serial: atmel: Check return code of dmaengine_submit()
      tty: serial: atmel: Call dma_async_issue_pending()
      dmaengine: at_xdmac: Don't start transactions at tx_submit level
      dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending
      dmaengine: at_xdmac: Print debug message after realeasing the lock
      dmaengine: at_xdmac: Fix concurrency over xfers_list
      dmaengine: at_xdmac: Fix lld view setting
      dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tzung-Bi Shih (3):
      ASoC: mediatek: mt8192-mt6359: fix device_node leak
      ASoC: mediatek: mt8173: fix device_node leak
      ASoC: mediatek: mt8183: fix device_node leak

Ulf Hansson (1):
      mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Uwe Kleine-König (1):
      perf tools: Drop requirement for libstdc++.so for libopencsd check

Valentin Caron (1):
      serial: stm32: move tx dma terminate DMA to shutdown

Vincent Donnefort (2):
      sched/fair: Fix detection of per-CPU kthreads waking a task
      sched/fair: Fix per-CPU kthread and wakee stacking for asym CPU capacity

Vladimir Oltean (3):
      net: dsa: fix incorrect function pointer check for MRP ring roles
      net: mscc: ocelot: fix incorrect balancing with down LAG ports
      net: mscc: ocelot: don't let phylink re-enable TX PAUSE on the NPI port

Vladimir Zapolskiy (1):
      cpufreq: qcom-hw: Fix probable nested interrupt handling

Waiman Long (1):
      clocksource: Avoid accidental unstable marking of clocksources

Wan Jiabing (1):
      ARM: shmobile: rcar-gen2: Add missing of_node_put()

Wander Lairson Costa (1):
      rcutorture: Avoid soft lockup during cpu stall

Wang Hai (4):
      drm: fix null-ptr-deref in drm_dev_init_release()
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
      media: dmxdev: fix UAF when dvb_register_device() fails
      media: msi001: fix possible null-ptr-deref in msi001_probe()

Wayne Lin (1):
      drm/amd/display: Fix bug in debugfs crc_win_update entry

Wei Yongjun (4):
      usb: ftdi-elan: fix memory leak on device disconnect
      misc: lattice-ecp3-config: Fix task hung when firmware load failed
      Bluetooth: Fix debugfs entry leak in hci_register_dev()
      Bluetooth: Fix memory leak of hci device

Weili Qian (2):
      crypto: hisilicon/qm - fix incorrect return value of hisi_qm_resume()
      crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()

Wen Gong (2):
      ath11k: add string type to search board data in board-2.bin for WCN6855
      ath11k: avoid deadlock by change ieee80211_queue_work for regd_update_work

Wen Gu (2):
      net/smc: Reset conn->lgr when link group registration fails
      net/smc: Fix hung_task when removing SMC-R devices

William Kucharski (1):
      cgroup: Trace event cgroup id fields should be u64

Willy Tarreau (2):
      tools/nolibc: i386: fix initial stack alignment
      tools/nolibc: fix incorrect truncation of exit code

Xiangyang Zhang (1):
      tracing/kprobes: 'nmissed' not showed correctly for kretprobe

Xiao Ni (1):
      md: Move alloc/free acct bioset in to personality

Xie Yongji (1):
      fuse: Pass correct lend value to filemap_write_and_wait_range()

Xin Xiong (1):
      netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Xin Yin (3):
      ext4: fix fast commit may miss tracking range for FALLOC_FL_ZERO_RANGE
      ext4: use ext4_ext_remove_space() for fast commit replay delete range
      ext4: fast commit may miss tracking unwritten range during ftruncate

Xing Song (1):
      mt76: do not pass the received frame with decryption error

Xiongfeng Wang (1):
      iommu/iova: Fix race between FQ timeout and teardown

Xiongwei Song (1):
      floppy: Add max size check for user space request

Yafang Shao (1):
      bpf: Fix mount source show for bpffs

Yang Li (2):
      ethernet: renesas: Use div64_ul instead of do_div
      drm/amd/display: check top_pipe_to_program pointer

Yang Yingliang (3):
      media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()
      staging: rtl8192e: return error code from rtllib_softmac_init()
      staging: rtl8192e: rtllib_module: fix error handle case in alloc_rtllib()

Ye Bin (3):
      ext4: Fix BUG_ON in ext4_bread when write quota data
      ext4: fix null-ptr-deref in '__ext4_journal_ensure_credits'
      block: Fix fsync always failed if once failed

Ye Guojin (2):
      ASoC: imx-hdmi: add put_device() after of_find_device_by_node()
      MIPS: OCTEON: add put_device() after of_find_device_by_node()

Yifeng Li (1):
      PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Yixing Liu (1):
      RDMA/hns: Modify the mapping attribute of doorbell to device

Yizhuo Zhai (1):
      drm/amd/display: Fix the uninitialized variable in enable_stream_features()

Yunfei Wang (1):
      iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure

Yury Norov (1):
      bitops: protect find_first_{,zero}_bit properly

Zack Rusin (6):
      drm/vmwgfx: Remove the deprecated lower mem limit
      drm/vmwgfx: Fail to initialize on broken configs
      drm/vmwgfx: Release ttm memory if probe fails
      drm/vmwgfx: Introduce a new placement for MOB page tables
      drm/vmwgfx: Remove explicit transparent hugepages support
      drm/vmwgfx: Remove unused compile options

Zechuan Chen (1):
      perf probe: Fix ppc64 'perf probe add events failed' case

Zekun Shen (5):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      rsi: Fix use-after-free in rsi_rx_done_handler()
      rsi: Fix out-of-bounds read in rsi_read_pkt()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zhang Yi (1):
      ext4: fix an use-after-free issue about data=journal writeback mode

Zhang Zixun (1):
      x86/mce/inject: Avoid out-of-bounds write when setting flags

Zhen Lei (1):
      of: fdt: Aggregate the processing of "linux,usable-memory-range"

Zheyu Ma (1):
      media: b2c2: Add missing check in flexcop_pci_isr:

Zhou Qingyang (9):
      drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
      drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()
      media: dib8000: Fix a memleak in dib8000_init()
      media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
      ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
      media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
      media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Zhu Lingshan (1):
      ifcvf/vDPA: fix misuse virtio-net device config size for blk dev

Zizhuang Deng (1):
      lib/mpi: Add the return value check of kcalloc()

Zongmin Zhou (1):
      drm/amdgpu: fixup bad vram size on gmc v8

jason-jh.lin (1):
      mailbox: fix gce_num of mt8192 driver data

oujiefeng (1):
      spi: hisi-kunpeng: Fix the debugfs directory name incorrect

xinhui pan (1):
      drm/ttm: Put BO in its memory manager's lru list

