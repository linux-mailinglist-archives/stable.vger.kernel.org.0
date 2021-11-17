Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457AF4544EC
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhKQK3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 05:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhKQK3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 05:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D24D261BFB;
        Wed, 17 Nov 2021 10:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637144771;
        bh=0tklUfcFAsZW7x36tq6nUQmVTlMu+ynirDtN4vC5Fro=;
        h=From:To:Cc:Subject:Date:From;
        b=XXH3cUjE7hBaVukmvxW4ZlS/nj2E31mPAQHS5X5V94a+kTQEHy/6ArgrMJSmstI9g
         iirlxMegTf4k+QzDB7xrRtvyarf25h9WOw5gYhHDZspDmg3/5vCrF4q3NOD70U1Zjg
         DyuJLYXPsllqmxHsmKbnJRyZ0DjWg3m7Z3mjkfy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.19
Date:   Wed, 17 Nov 2021 11:26:07 +0100
Message-Id: <163714476814814@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.19 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                 |    7 
 Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml       |    2 
 Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt |   23 
 Documentation/filesystems/fscrypt.rst                           |   10 
 Makefile                                                        |    2 
 arch/Kconfig                                                    |    3 
 arch/alpha/include/asm/processor.h                              |    2 
 arch/alpha/kernel/process.c                                     |    5 
 arch/arc/include/asm/processor.h                                |    2 
 arch/arc/kernel/stacktrace.c                                    |    4 
 arch/arm/Makefile                                               |   22 
 arch/arm/boot/dts/at91-tse850-3.dts                             |    2 
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts                     |    2 
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts                     |    2 
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts               |    2 
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts                    |    2 
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts                     |    2 
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts                     |    2 
 arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts               |    2 
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts                   |    2 
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts                      |    2 
 arch/arm/boot/dts/bcm94708.dts                                  |    2 
 arch/arm/boot/dts/bcm94709.dts                                  |    2 
 arch/arm/boot/dts/omap3-gta04.dtsi                              |    2 
 arch/arm/boot/dts/qcom-msm8974.dtsi                             |    4 
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi                        |    8 
 arch/arm/boot/dts/stm32mp151.dtsi                               |   16 
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi                    |    2 
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi                          |    2 
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts                 |    2 
 arch/arm/include/asm/processor.h                                |    2 
 arch/arm/kernel/process.c                                       |    4 
 arch/arm/kernel/stacktrace.c                                    |    3 
 arch/arm/mach-s3c/irq-s3c24xx.c                                 |   22 
 arch/arm/mm/Kconfig                                             |    2 
 arch/arm/mm/kasan_init.c                                        |    2 
 arch/arm/mm/mmu.c                                               |    4 
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts                 |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts              |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi         |    4 
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi           |    4 
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi                |    4 
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts           |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi               |    6 
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts                |    2 
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi               |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                           |    8 
 arch/arm64/boot/dts/qcom/pm8916.dtsi                            |    1 
 arch/arm64/boot/dts/qcom/pmi8994.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi             |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi             |    8 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                            |   52 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi                            |    6 
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi             |    1 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                        |    2 
 arch/arm64/boot/dts/rockchip/rk3568.dtsi                        |    2 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                       |    6 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                       |   16 
 arch/arm64/include/asm/esr.h                                    |    1 
 arch/arm64/include/asm/pgtable.h                                |   12 
 arch/arm64/include/asm/processor.h                              |    2 
 arch/arm64/kernel/cpufeature.c                                  |   10 
 arch/arm64/kernel/process.c                                     |    4 
 arch/arm64/kernel/vdso32/Makefile                               |    3 
 arch/arm64/kvm/hyp/hyp-entry.S                                  |    2 
 arch/arm64/kvm/hyp/nvhe/host.S                                  |    2 
 arch/arm64/kvm/hyp/nvhe/page_alloc.c                            |    1 
 arch/arm64/mm/mmu.c                                             |    5 
 arch/arm64/net/bpf_jit_comp.c                                   |    5 
 arch/csky/include/asm/processor.h                               |    2 
 arch/csky/kernel/stacktrace.c                                   |    5 
 arch/h8300/include/asm/processor.h                              |    2 
 arch/h8300/kernel/process.c                                     |    5 
 arch/hexagon/include/asm/processor.h                            |    2 
 arch/hexagon/kernel/process.c                                   |    4 
 arch/ia64/Kconfig.debug                                         |    2 
 arch/ia64/include/asm/processor.h                               |    2 
 arch/ia64/kernel/kprobes.c                                      |    9 
 arch/ia64/kernel/process.c                                      |    5 
 arch/m68k/Kconfig.machine                                       |    1 
 arch/m68k/include/asm/processor.h                               |    2 
 arch/m68k/kernel/process.c                                      |    4 
 arch/microblaze/include/asm/processor.h                         |    2 
 arch/microblaze/kernel/process.c                                |    2 
 arch/mips/Kconfig                                               |    1 
 arch/mips/Makefile                                              |    2 
 arch/mips/include/asm/cmpxchg.h                                 |    5 
 arch/mips/include/asm/mips-cm.h                                 |   12 
 arch/mips/include/asm/processor.h                               |    2 
 arch/mips/kernel/mips-cm.c                                      |   21 
 arch/mips/kernel/process.c                                      |    8 
 arch/mips/kernel/r2300_fpu.S                                    |    4 
 arch/mips/kernel/syscall.c                                      |    9 
 arch/mips/lantiq/xway/dma.c                                     |   23 
 arch/nds32/include/asm/processor.h                              |    2 
 arch/nds32/kernel/process.c                                     |    7 
 arch/nios2/include/asm/processor.h                              |    2 
 arch/nios2/kernel/process.c                                     |    5 
 arch/openrisc/include/asm/processor.h                           |    2 
 arch/openrisc/kernel/dma.c                                      |    4 
 arch/openrisc/kernel/process.c                                  |    2 
 arch/openrisc/kernel/smp.c                                      |    6 
 arch/parisc/include/asm/pgtable.h                               |   10 
 arch/parisc/include/asm/processor.h                             |    2 
 arch/parisc/kernel/cache.c                                      |    4 
 arch/parisc/kernel/entry.S                                      |    2 
 arch/parisc/kernel/process.c                                    |    5 
 arch/parisc/kernel/smp.c                                        |   19 
 arch/parisc/kernel/unwind.c                                     |   21 
 arch/parisc/kernel/vmlinux.lds.S                                |    3 
 arch/parisc/mm/fixmap.c                                         |    5 
 arch/parisc/mm/init.c                                           |    4 
 arch/powerpc/Kconfig                                            |    6 
 arch/powerpc/include/asm/nohash/32/pgtable.h                    |   19 
 arch/powerpc/include/asm/nohash/32/pte-8xx.h                    |   22 
 arch/powerpc/include/asm/nohash/64/pgtable.h                    |    5 
 arch/powerpc/include/asm/nohash/pte-book3e.h                    |   18 
 arch/powerpc/include/asm/paravirt.h                             |   18 
 arch/powerpc/include/asm/processor.h                            |    2 
 arch/powerpc/kernel/firmware.c                                  |    7 
 arch/powerpc/kernel/head_booke.h                                |   15 
 arch/powerpc/kernel/interrupt.c                                 |    2 
 arch/powerpc/kernel/process.c                                   |    9 
 arch/powerpc/kvm/book3s_hv.c                                    |   30 +
 arch/powerpc/kvm/booke.c                                        |   16 
 arch/powerpc/lib/feature-fixups.c                               |   11 
 arch/powerpc/mm/mem.c                                           |    2 
 arch/powerpc/mm/nohash/tlb_low_64e.S                            |    8 
 arch/powerpc/mm/pgtable_32.c                                    |    2 
 arch/powerpc/net/bpf_jit_comp.c                                 |    2 
 arch/powerpc/perf/power10-events-list.h                         |    8 
 arch/powerpc/perf/power10-pmu.c                                 |   44 +
 arch/powerpc/platforms/44x/fsp2.c                               |    2 
 arch/powerpc/platforms/85xx/Makefile                            |    4 
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c                    |    7 
 arch/powerpc/platforms/85xx/smp.c                               |   12 
 arch/powerpc/platforms/book3s/vas-api.c                         |    4 
 arch/powerpc/platforms/powernv/opal-prd.c                       |   12 
 arch/powerpc/platforms/pseries/mobility.c                       |   34 +
 arch/powerpc/xmon/xmon.c                                        |    3 
 arch/riscv/include/asm/processor.h                              |    2 
 arch/riscv/kernel/stacktrace.c                                  |   12 
 arch/riscv/net/bpf_jit_core.c                                   |    5 
 arch/s390/include/asm/processor.h                               |    2 
 arch/s390/kernel/perf_cpum_cf.c                                 |    4 
 arch/s390/kernel/process.c                                      |    4 
 arch/s390/kernel/uv.c                                           |    2 
 arch/s390/kvm/priv.c                                            |    2 
 arch/s390/kvm/pv.c                                              |   21 
 arch/s390/mm/gmap.c                                             |   11 
 arch/s390/mm/pgtable.c                                          |   70 ++
 arch/sh/include/asm/processor_32.h                              |    2 
 arch/sh/kernel/cpu/fpu.c                                        |   10 
 arch/sh/kernel/process_32.c                                     |    5 
 arch/sparc/include/asm/processor_32.h                           |    2 
 arch/sparc/include/asm/processor_64.h                           |    2 
 arch/sparc/kernel/process_32.c                                  |    5 
 arch/sparc/kernel/process_64.c                                  |    5 
 arch/um/include/asm/processor-generic.h                         |    2 
 arch/um/kernel/process.c                                        |    5 
 arch/x86/Kconfig                                                |    1 
 arch/x86/crypto/aesni-intel_glue.c                              |    2 
 arch/x86/events/intel/core.c                                    |    5 
 arch/x86/events/intel/ds.c                                      |    5 
 arch/x86/events/intel/uncore_discovery.h                        |    2 
 arch/x86/events/intel/uncore_snbep.c                            |    6 
 arch/x86/hyperv/hv_init.c                                       |    5 
 arch/x86/include/asm/cpu_entry_area.h                           |    8 
 arch/x86/include/asm/insn-eval.h                                |    1 
 arch/x86/include/asm/irq_stack.h                                |   37 -
 arch/x86/include/asm/kvm_host.h                                 |    2 
 arch/x86/include/asm/mem_encrypt.h                              |    1 
 arch/x86/include/asm/page_64_types.h                            |    2 
 arch/x86/include/asm/processor.h                                |    3 
 arch/x86/include/asm/stacktrace.h                               |   10 
 arch/x86/include/asm/traps.h                                    |    6 
 arch/x86/kernel/Makefile                                        |    6 
 arch/x86/kernel/cc_platform.c                                   |   69 ++
 arch/x86/kernel/cpu/amd.c                                       |    2 
 arch/x86/kernel/cpu/common.c                                    |   44 +
 arch/x86/kernel/cpu/cpu.h                                       |    1 
 arch/x86/kernel/cpu/hygon.c                                     |    2 
 arch/x86/kernel/cpu/mce/intel.c                                 |    5 
 arch/x86/kernel/dumpstack_64.c                                  |    6 
 arch/x86/kernel/irq.c                                           |    4 
 arch/x86/kernel/process.c                                       |   66 --
 arch/x86/kernel/sev.c                                           |   32 -
 arch/x86/kernel/traps.c                                         |   60 +-
 arch/x86/kvm/cpuid.c                                            |   47 -
 arch/x86/kvm/vmx/nested.c                                       |  103 +---
 arch/x86/kvm/vmx/vmx.c                                          |   68 --
 arch/x86/kvm/vmx/vmx.h                                          |   63 ++
 arch/x86/kvm/x86.c                                              |  108 +++-
 arch/x86/lib/insn-eval.c                                        |    2 
 arch/x86/lib/insn.c                                             |    5 
 arch/x86/mm/cpu_entry_area.c                                    |    7 
 arch/x86/mm/fault.c                                             |   20 
 arch/x86/mm/mem_encrypt.c                                       |    1 
 arch/x86/mm/mem_encrypt_identity.c                              |    9 
 arch/xtensa/include/asm/processor.h                             |    2 
 arch/xtensa/kernel/process.c                                    |    5 
 block/blk-cgroup.c                                              |   10 
 block/blk-mq.c                                                  |   18 
 block/blk.h                                                     |    6 
 crypto/Kconfig                                                  |    2 
 crypto/pcrypt.c                                                 |   12 
 crypto/tcrypt.c                                                 |    5 
 drivers/acpi/ac.c                                               |   19 
 drivers/acpi/acpica/acglobal.h                                  |    2 
 drivers/acpi/acpica/hwesleep.c                                  |    8 
 drivers/acpi/acpica/hwsleep.c                                   |   11 
 drivers/acpi/acpica/hwxfsleep.c                                 |    7 
 drivers/acpi/battery.c                                          |    2 
 drivers/acpi/glue.c                                             |   25 
 drivers/acpi/internal.h                                         |    1 
 drivers/acpi/pmic/intel_pmic.c                                  |   51 +-
 drivers/acpi/power.c                                            |   86 +--
 drivers/acpi/resource.c                                         |   56 ++
 drivers/acpi/scan.c                                             |    6 
 drivers/ata/libata-core.c                                       |    2 
 drivers/ata/libata-eh.c                                         |    8 
 drivers/auxdisplay/ht16k33.c                                    |   66 +-
 drivers/auxdisplay/img-ascii-lcd.c                              |   10 
 drivers/base/component.c                                        |    5 
 drivers/base/core.c                                             |    4 
 drivers/base/power/main.c                                       |   93 ++-
 drivers/block/ataflop.c                                         |  141 +++--
 drivers/block/floppy.c                                          |    9 
 drivers/block/nbd.c                                             |   24 
 drivers/block/zram/zram_drv.c                                   |    2 
 drivers/bluetooth/btmtkuart.c                                   |   13 
 drivers/bus/ti-sysc.c                                           |   65 ++
 drivers/char/hw_random/mtk-rng.c                                |    9 
 drivers/char/ipmi/ipmi_msghandler.c                             |   10 
 drivers/char/ipmi/ipmi_watchdog.c                               |   25 
 drivers/char/ipmi/kcs_bmc_serio.c                               |    4 
 drivers/char/tpm/tpm2-space.c                                   |    3 
 drivers/char/tpm/tpm_tis_core.c                                 |   26 -
 drivers/char/tpm/tpm_tis_core.h                                 |    4 
 drivers/char/tpm/tpm_tis_spi_main.c                             |    1 
 drivers/char/xillybus/xillyusb.c                                |    1 
 drivers/clk/at91/clk-master.c                                   |    6 
 drivers/clk/at91/clk-sam9x60-pll.c                              |    4 
 drivers/clk/at91/pmc.c                                          |    5 
 drivers/clk/mvebu/ap-cpu-clk.c                                  |   14 
 drivers/clocksource/Kconfig                                     |    1 
 drivers/cpufreq/cpufreq.c                                       |    7 
 drivers/cpufreq/intel_pstate.c                                  |   37 +
 drivers/cpuidle/sysfs.c                                         |    5 
 drivers/crypto/caam/caampkc.c                                   |   19 
 drivers/crypto/caam/regs.h                                      |    3 
 drivers/crypto/ccree/cc_driver.c                                |    3 
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c              |    1 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c                   |   13 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                      |    6 
 drivers/crypto/s5p-sss.c                                        |    2 
 drivers/cxl/pci.c                                               |    2 
 drivers/dma-buf/dma-buf.c                                       |    1 
 drivers/dma/at_xdmac.c                                          |   53 +-
 drivers/dma/bestcomm/ata.c                                      |    2 
 drivers/dma/bestcomm/bestcomm.c                                 |   22 
 drivers/dma/bestcomm/fec.c                                      |    4 
 drivers/dma/bestcomm/gen_bd.c                                   |    4 
 drivers/dma/dmaengine.h                                         |    2 
 drivers/dma/stm32-dma.c                                         |   23 
 drivers/dma/ti/k3-udma.c                                        |   32 +
 drivers/edac/amd64_edac.c                                       |   22 
 drivers/edac/sb_edac.c                                          |    2 
 drivers/firmware/psci/psci_checker.c                            |    2 
 drivers/firmware/qcom_scm.c                                     |    2 
 drivers/gpio/gpio-mlxbf2.c                                      |    5 
 drivers/gpio/gpio-realtek-otto.c                                |    2 
 drivers/gpu/drm/Kconfig                                         |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c                     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h                     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                      |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c                           |    4 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c                           |    8 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c                           |   17 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                         |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                            |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c               |    9 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c       |    2 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c           |   16 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c              |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c                |   89 +--
 drivers/gpu/drm/bridge/analogix/anx7625.c                       |   12 
 drivers/gpu/drm/bridge/ite-it66121.c                            |   21 
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c                      |    9 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                  |   47 +
 drivers/gpu/drm/drm_plane_helper.c                              |    1 
 drivers/gpu/drm/i915/display/intel_fb.c                         |    5 
 drivers/gpu/drm/imx/imx-drm-core.c                              |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                           |    6 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c                     |    8 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                         |    4 
 drivers/gpu/drm/msm/msm_gem.c                                   |    5 
 drivers/gpu/drm/msm/msm_gpu.c                                   |    2 
 drivers/gpu/drm/nouveau/nouveau_gem.c                           |    2 
 drivers/gpu/drm/nouveau/nouveau_svm.c                           |    4 
 drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c                  |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c               |    3 
 drivers/gpu/drm/radeon/radeon_gem.c                             |    2 
 drivers/gpu/drm/sun4i/sun8i_csc.h                               |    4 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                                 |   99 ---
 drivers/gpu/drm/v3d/v3d_gem.c                                   |    4 
 drivers/gpu/drm/virtio/virtgpu_vq.c                             |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                             |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c                      |   72 --
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c                        |    3 
 drivers/hid/hid-u2fzero.c                                       |   10 
 drivers/hid/surface-hid/surface_hid.c                           |    4 
 drivers/hv/hyperv_vmbus.h                                       |    1 
 drivers/hwmon/hwmon.c                                           |    6 
 drivers/hwmon/pmbus/lm25066.c                                   |   25 
 drivers/hwtracing/coresight/coresight-cti-core.c                |    2 
 drivers/hwtracing/coresight/coresight-trbe.c                    |   10 
 drivers/i2c/busses/i2c-mt65xx.c                                 |    2 
 drivers/i2c/busses/i2c-xlr.c                                    |    6 
 drivers/iio/accel/st_accel_i2c.c                                |    4 
 drivers/iio/accel/st_accel_spi.c                                |    4 
 drivers/iio/adc/ti-tsc2046.c                                    |    2 
 drivers/iio/dac/ad5446.c                                        |    9 
 drivers/iio/dac/ad5766.c                                        |    6 
 drivers/iio/dac/ad5770r.c                                       |    2 
 drivers/iio/gyro/st_gyro_i2c.c                                  |    4 
 drivers/iio/gyro/st_gyro_spi.c                                  |    4 
 drivers/iio/imu/adis.c                                          |    4 
 drivers/iio/industrialio-buffer.c                               |   28 -
 drivers/iio/industrialio-core.c                                 |    9 
 drivers/iio/magnetometer/st_magn_i2c.c                          |    4 
 drivers/iio/magnetometer/st_magn_spi.c                          |    4 
 drivers/iio/pressure/st_pressure_i2c.c                          |    4 
 drivers/iio/pressure/st_pressure_spi.c                          |    8 
 drivers/infiniband/core/uverbs_cmd.c                            |    3 
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                        |    3 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                      |    6 
 drivers/infiniband/hw/mlx4/qp.c                                 |    4 
 drivers/infiniband/hw/qedr/verbs.c                              |   15 
 drivers/infiniband/sw/rxe/rxe_param.h                           |    2 
 drivers/input/joystick/iforce/iforce-usb.c                      |    2 
 drivers/input/misc/ariel-pwrbutton.c                            |    7 
 drivers/input/mouse/elantech.c                                  |   13 
 drivers/input/serio/i8042-x86ia64io.h                           |   14 
 drivers/input/touchscreen/st1232.c                              |    2 
 drivers/iommu/dma-iommu.c                                       |   16 
 drivers/iommu/mtk_iommu.c                                       |    4 
 drivers/irqchip/irq-bcm6345-l1.c                                |    2 
 drivers/irqchip/irq-sifive-plic.c                               |    8 
 drivers/isdn/hardware/mISDN/hfcpci.c                            |    8 
 drivers/mailbox/mtk-cmdq-mailbox.c                              |    1 
 drivers/md/md.c                                                 |   11 
 drivers/md/raid1.c                                              |    2 
 drivers/media/common/videobuf2/videobuf2-core.c                 |   42 -
 drivers/media/common/videobuf2/videobuf2-dma-contig.c           |   39 -
 drivers/media/common/videobuf2/videobuf2-dma-sg.c               |   35 -
 drivers/media/common/videobuf2/videobuf2-vmalloc.c              |   30 -
 drivers/media/dvb-frontends/mn88443x.c                          |   18 
 drivers/media/i2c/Kconfig                                       |    1 
 drivers/media/i2c/imx258.c                                      |   12 
 drivers/media/i2c/ir-kbd-i2c.c                                  |    1 
 drivers/media/i2c/mt9p031.c                                     |   28 +
 drivers/media/i2c/tda1997x.c                                    |    8 
 drivers/media/pci/cx23885/cx23885-alsa.c                        |    3 
 drivers/media/pci/ivtv/ivtvfb.c                                 |    4 
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c              |   27 -
 drivers/media/platform/allegro-dvt/allegro-core.c               |    9 
 drivers/media/platform/atmel/atmel-isc-base.c                   |   25 
 drivers/media/platform/atmel/atmel-isc.h                        |    2 
 drivers/media/platform/atmel/atmel-sama5d2-isc.c                |   39 -
 drivers/media/platform/atmel/atmel-sama7g5-isc.c                |   22 
 drivers/media/platform/imx-jpeg/mxc-jpeg.c                      |    6 
 drivers/media/platform/meson/ge2d/ge2d.c                        |    6 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c              |    8 
 drivers/media/platform/mtk-vpu/mtk_vpu.c                        |    5 
 drivers/media/platform/qcom/venus/pm_helpers.c                  |    8 
 drivers/media/platform/rcar-vin/rcar-csi2.c                     |    2 
 drivers/media/platform/rcar-vin/rcar-dma.c                      |    3 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                        |    6 
 drivers/media/platform/stm32/stm32-dcmi.c                       |   19 
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c            |    6 
 drivers/media/radio/radio-wl1273.c                              |    2 
 drivers/media/radio/si470x/radio-si470x-i2c.c                   |    2 
 drivers/media/radio/si470x/radio-si470x-usb.c                   |    2 
 drivers/media/rc/ir_toy.c                                       |    2 
 drivers/media/rc/ite-cir.c                                      |    2 
 drivers/media/rc/mceusb.c                                       |    1 
 drivers/media/spi/cxd2880-spi.c                                 |    2 
 drivers/media/test-drivers/vidtv/vidtv_bridge.c                 |    4 
 drivers/media/usb/dvb-usb/az6027.c                              |    1 
 drivers/media/usb/dvb-usb/dibusb-common.c                       |    2 
 drivers/media/usb/em28xx/em28xx-cards.c                         |    5 
 drivers/media/usb/em28xx/em28xx-core.c                          |    5 
 drivers/media/usb/tm6000/tm6000-video.c                         |    3 
 drivers/media/usb/ttusb-dec/ttusb_dec.c                         |   10 
 drivers/media/usb/uvc/uvc_driver.c                              |    7 
 drivers/media/usb/uvc/uvc_v4l2.c                                |    7 
 drivers/media/usb/uvc/uvc_video.c                               |    5 
 drivers/media/v4l2-core/v4l2-ioctl.c                            |   67 +-
 drivers/memory/fsl_ifc.c                                        |   13 
 drivers/memory/renesas-rpc-if.c                                 |  113 +++-
 drivers/memstick/core/ms_block.c                                |    2 
 drivers/memstick/host/jmb38x_ms.c                               |    2 
 drivers/memstick/host/r592.c                                    |    8 
 drivers/mfd/altera-sysmgr.c                                     |    2 
 drivers/mfd/dln2.c                                              |   18 
 drivers/mfd/mfd-core.c                                          |    2 
 drivers/mfd/motorola-cpcap.c                                    |    8 
 drivers/mfd/sprd-sc27xx-spi.c                                   |    7 
 drivers/mmc/host/Kconfig                                        |    2 
 drivers/mmc/host/dw_mmc.c                                       |    3 
 drivers/mmc/host/moxart-mmc.c                                   |   29 -
 drivers/mmc/host/mtk-sd.c                                       |    5 
 drivers/mmc/host/mxs-mmc.c                                      |   10 
 drivers/mmc/host/sdhci-omap.c                                   |   18 
 drivers/most/most_usb.c                                         |    5 
 drivers/mtd/mtdcore.c                                           |    4 
 drivers/mtd/nand/raw/ams-delta.c                                |   12 
 drivers/mtd/nand/raw/arasan-nand-controller.c                   |   15 
 drivers/mtd/nand/raw/au1550nd.c                                 |   12 
 drivers/mtd/nand/raw/fsmc_nand.c                                |    4 
 drivers/mtd/nand/raw/gpio.c                                     |   12 
 drivers/mtd/nand/raw/intel-nand-controller.c                    |    5 
 drivers/mtd/nand/raw/mpc5121_nfc.c                              |   12 
 drivers/mtd/nand/raw/orion_nand.c                               |   12 
 drivers/mtd/nand/raw/pasemi_nand.c                              |   12 
 drivers/mtd/nand/raw/plat_nand.c                                |   12 
 drivers/mtd/nand/raw/socrates_nand.c                            |   12 
 drivers/mtd/nand/raw/xway_nand.c                                |   12 
 drivers/mtd/spi-nor/controllers/hisi-sfc.c                      |    1 
 drivers/net/Kconfig                                             |    2 
 drivers/net/bonding/bond_sysfs_slave.c                          |   36 -
 drivers/net/can/dev/bittiming.c                                 |    2 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                  |    2 
 drivers/net/can/usb/etas_es58x/es58x_core.c                     |    6 
 drivers/net/dsa/mv88e6xxx/chip.c                                |    5 
 drivers/net/dsa/ocelot/felix.c                                  |    9 
 drivers/net/dsa/rtl8366.c                                       |    2 
 drivers/net/dsa/rtl8366rb.c                                     |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                     |    8 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                     |   20 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                       |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c               |   13 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h               |   13 
 drivers/net/ethernet/cavium/thunder/nic_main.c                  |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c                |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c              |    7 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                      |    2 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c     |    2 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h     |    2 
 drivers/net/ethernet/dec/tulip/winbond-840.c                    |    2 
 drivers/net/ethernet/fealnx.c                                   |    2 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c                |   18 
 drivers/net/ethernet/google/gve/gve.h                           |   17 
 drivers/net/ethernet/google/gve/gve_adminq.h                    |    1 
 drivers/net/ethernet/google/gve/gve_main.c                      |   48 +
 drivers/net/ethernet/google/gve/gve_rx.c                        |    7 
 drivers/net/ethernet/google/gve/gve_tx.c                        |   23 
 drivers/net/ethernet/google/gve/gve_tx_dqo.c                    |   84 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c          |   20 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c         |   45 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h         |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c           |   77 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h           |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c       |   15 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h       |    5 
 drivers/net/ethernet/ibm/ibmvnic.c                              |   21 
 drivers/net/ethernet/intel/ice/ice.h                            |    7 
 drivers/net/ethernet/intel/ice/ice_base.c                       |    2 
 drivers/net/ethernet/intel/ice/ice_devlink.c                    |  109 +++-
 drivers/net/ethernet/intel/ice/ice_devlink.h                    |    6 
 drivers/net/ethernet/intel/ice/ice_lib.c                        |    3 
 drivers/net/ethernet/intel/ice/ice_main.c                       |    4 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                |   22 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h                |    9 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                 |   38 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c            |   78 +--
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c             |    1 
 drivers/net/ethernet/mscc/ocelot.c                              |   17 
 drivers/net/ethernet/mscc/ocelot_net.c                          |    1 
 drivers/net/ethernet/mscc/ocelot_vsc7514.c                      |    1 
 drivers/net/ethernet/netronome/nfp/bpf/main.c                   |   16 
 drivers/net/ethernet/netronome/nfp/bpf/main.h                   |    2 
 drivers/net/ethernet/netronome/nfp/bpf/offload.c                |   17 
 drivers/net/ethernet/qlogic/qede/qede_main.c                    |   12 
 drivers/net/ethernet/realtek/r8169_main.c                       |    1 
 drivers/net/ethernet/sfc/mcdi_port_common.c                     |   37 +
 drivers/net/ethernet/sfc/ptp.c                                  |    4 
 drivers/net/ethernet/sfc/siena_sriov.c                          |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c                 |    2 
 drivers/net/ethernet/ti/cpsw_ale.c                              |    6 
 drivers/net/ethernet/ti/davinci_emac.c                          |   16 
 drivers/net/ifb.c                                               |    2 
 drivers/net/phy/micrel.c                                        |    9 
 drivers/net/phy/phy.c                                           |    7 
 drivers/net/phy/phylink.c                                       |    7 
 drivers/net/vmxnet3/vmxnet3_drv.c                               |    1 
 drivers/net/vrf.c                                               |   28 -
 drivers/net/wireless/ath/ath10k/core.c                          |   11 
 drivers/net/wireless/ath/ath10k/coredump.c                      |   11 
 drivers/net/wireless/ath/ath10k/coredump.h                      |    7 
 drivers/net/wireless/ath/ath10k/mac.c                           |   45 +
 drivers/net/wireless/ath/ath10k/qmi.c                           |    3 
 drivers/net/wireless/ath/ath10k/sdio.c                          |    5 
 drivers/net/wireless/ath/ath10k/snoc.c                          |   77 +++
 drivers/net/wireless/ath/ath10k/snoc.h                          |    5 
 drivers/net/wireless/ath/ath10k/usb.c                           |    7 
 drivers/net/wireless/ath/ath10k/wmi.c                           |    4 
 drivers/net/wireless/ath/ath10k/wmi.h                           |    3 
 drivers/net/wireless/ath/ath11k/dbring.c                        |   16 
 drivers/net/wireless/ath/ath11k/dp_rx.c                         |   13 
 drivers/net/wireless/ath/ath11k/mac.c                           |    2 
 drivers/net/wireless/ath/ath11k/qmi.c                           |    4 
 drivers/net/wireless/ath/ath11k/reg.c                           |   11 
 drivers/net/wireless/ath/ath11k/reg.h                           |    2 
 drivers/net/wireless/ath/ath11k/wmi.c                           |   40 +
 drivers/net/wireless/ath/ath11k/wmi.h                           |    3 
 drivers/net/wireless/ath/ath6kl/usb.c                           |    7 
 drivers/net/wireless/ath/ath9k/main.c                           |    4 
 drivers/net/wireless/ath/dfs_pattern_detector.c                 |   10 
 drivers/net/wireless/ath/wcn36xx/dxe.c                          |   49 +
 drivers/net/wireless/ath/wcn36xx/hal.h                          |   32 +
 drivers/net/wireless/ath/wcn36xx/main.c                         |   21 
 drivers/net/wireless/ath/wcn36xx/smd.c                          |  126 ++++-
 drivers/net/wireless/ath/wcn36xx/smd.h                          |    1 
 drivers/net/wireless/ath/wcn36xx/txrx.c                         |   64 +-
 drivers/net/wireless/ath/wcn36xx/txrx.h                         |    3 
 drivers/net/wireless/broadcom/b43/phy_g.c                       |    2 
 drivers/net/wireless/broadcom/b43legacy/radio.c                 |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c          |   10 
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c                    |   13 
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                     |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                  |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                   |    6 
 drivers/net/wireless/marvell/libertas/if_usb.c                  |    2 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c               |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                      |    5 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                 |   32 -
 drivers/net/wireless/marvell/mwifiex/pcie.c                     |   36 +
 drivers/net/wireless/marvell/mwifiex/usb.c                      |   16 
 drivers/net/wireless/marvell/mwl8k.c                            |    2 
 drivers/net/wireless/mediatek/mt76/debugfs.c                    |   10 
 drivers/net/wireless/mediatek/mt76/mt76.h                       |    8 
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c             |   29 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c                |    6 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                 |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                |    4 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                 |   18 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c            |   30 -
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h            |    8 
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                |   13 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c                |   10 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                 |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h                 |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                 |   22 
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c             |   36 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c                |   13 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                 |   68 ++
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h                 |    8 
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c                 |   22 
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h                 |   10 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h                |    8 
 drivers/net/wireless/microchip/wilc1000/cfg80211.c              |    3 
 drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c          |   14 
 drivers/net/wireless/realtek/rtw88/fw.c                         |    7 
 drivers/net/wireless/realtek/rtw88/reg.h                        |    1 
 drivers/net/wireless/rsi/rsi_91x_core.c                         |    2 
 drivers/net/wireless/rsi/rsi_91x_hal.c                          |   10 
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                     |   74 --
 drivers/net/wireless/rsi/rsi_91x_main.c                         |   17 
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                         |   24 
 drivers/net/wireless/rsi/rsi_91x_sdio.c                         |    5 
 drivers/net/wireless/rsi/rsi_91x_usb.c                          |    5 
 drivers/net/wireless/rsi/rsi_hal.h                              |   11 
 drivers/net/wireless/rsi/rsi_main.h                             |   15 
 drivers/net/xen-netfront.c                                      |    8 
 drivers/nfc/pn533/pn533.c                                       |    6 
 drivers/nvdimm/btt.c                                            |    1 
 drivers/nvme/host/multipath.c                                   |    9 
 drivers/nvme/host/rdma.c                                        |    2 
 drivers/nvme/target/configfs.c                                  |    2 
 drivers/nvme/target/rdma.c                                      |   24 
 drivers/nvme/target/tcp.c                                       |   21 
 drivers/of/unittest.c                                           |   16 
 drivers/opp/of.c                                                |    2 
 drivers/pci/controller/cadence/pci-j721e.c                      |    2 
 drivers/pci/controller/cadence/pcie-cadence-plat.c              |    2 
 drivers/pci/controller/dwc/pcie-uniphier.c                      |   26 -
 drivers/pci/controller/pci-aardvark.c                           |  251 ++++++++--
 drivers/pci/pci-bridge-emul.c                                   |   13 
 drivers/pci/pci.c                                               |    8 
 drivers/pci/quirks.c                                            |    1 
 drivers/phy/microchip/sparx5_serdes.c                           |    4 
 drivers/phy/qualcomm/phy-qcom-qusb2.c                           |   16 
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c                   |    2 
 drivers/phy/ti/phy-gmii-sel.c                                   |    2 
 drivers/pinctrl/core.c                                          |    2 
 drivers/pinctrl/pinctrl-amd.c                                   |   19 
 drivers/pinctrl/pinctrl-amd.h                                   |    1 
 drivers/pinctrl/pinctrl-equilibrium.c                           |    7 
 drivers/pinctrl/renesas/core.c                                  |    2 
 drivers/platform/surface/surface_aggregator_registry.c          |   54 ++
 drivers/platform/x86/thinkpad_acpi.c                            |    2 
 drivers/platform/x86/wmi.c                                      |    9 
 drivers/power/reset/at91-reset.c                                |    4 
 drivers/power/supply/bq27xxx_battery_i2c.c                      |    3 
 drivers/power/supply/max17040_battery.c                         |    2 
 drivers/power/supply/max17042_battery.c                         |   12 
 drivers/power/supply/rt5033_battery.c                           |    2 
 drivers/ptp/ptp_kvm_x86.c                                       |    4 
 drivers/regulator/s5m8767.c                                     |   21 
 drivers/remoteproc/imx_rproc.c                                  |   41 -
 drivers/remoteproc/remoteproc_core.c                            |    8 
 drivers/remoteproc/remoteproc_coredump.c                        |    2 
 drivers/remoteproc/remoteproc_elf_loader.c                      |    4 
 drivers/reset/reset-socfpga.c                                   |   26 +
 drivers/rtc/rtc-ds1302.c                                        |    7 
 drivers/rtc/rtc-ds1390.c                                        |    7 
 drivers/rtc/rtc-mcp795.c                                        |    7 
 drivers/rtc/rtc-pcf2123.c                                       |    9 
 drivers/rtc/rtc-rv3032.c                                        |    4 
 drivers/s390/char/tape_std.c                                    |    3 
 drivers/s390/cio/css.c                                          |    4 
 drivers/s390/cio/device_ops.c                                   |   12 
 drivers/s390/crypto/ap_queue.c                                  |    2 
 drivers/scsi/csiostor/csio_lnode.c                              |    2 
 drivers/scsi/dc395x.c                                           |    1 
 drivers/scsi/hosts.c                                            |    1 
 drivers/scsi/lpfc/lpfc_els.c                                    |   11 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                |   10 
 drivers/scsi/lpfc/lpfc_nvme.c                                   |    5 
 drivers/scsi/lpfc/lpfc_scsi.c                                   |    7 
 drivers/scsi/lpfc/lpfc_sli.c                                    |  101 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c                     |   11 
 drivers/scsi/pm8001/pm8001_hwi.c                                |    2 
 drivers/scsi/pm8001/pm8001_sas.h                                |    3 
 drivers/scsi/pm8001/pm80xx_hwi.c                                |   53 +-
 drivers/scsi/qedf/qedf_main.c                                   |    2 
 drivers/scsi/qla2xxx/qla_attr.c                                 |   24 
 drivers/scsi/qla2xxx/qla_gbl.h                                  |    2 
 drivers/scsi/qla2xxx/qla_init.c                                 |    4 
 drivers/scsi/qla2xxx/qla_mr.c                                   |   23 
 drivers/scsi/qla2xxx/qla_os.c                                   |   37 -
 drivers/scsi/qla2xxx/qla_target.c                               |   14 
 drivers/scsi/scsi_error.c                                       |   25 
 drivers/scsi/scsi_lib.c                                         |    3 
 drivers/scsi/ufs/ufshcd-pltfrm.c                                |    4 
 drivers/soc/fsl/dpaa2-console.c                                 |    1 
 drivers/soc/fsl/dpio/dpio-service.c                             |    2 
 drivers/soc/fsl/dpio/qbman-portal.c                             |    9 
 drivers/soc/qcom/apr.c                                          |    2 
 drivers/soc/qcom/llcc-qcom.c                                    |    2 
 drivers/soc/qcom/rpmhpd.c                                       |   20 
 drivers/soc/qcom/socinfo.c                                      |    4 
 drivers/soc/samsung/Kconfig                                     |    1 
 drivers/soc/tegra/pmc.c                                         |    2 
 drivers/soundwire/bus.c                                         |    2 
 drivers/soundwire/debugfs.c                                     |    2 
 drivers/spi/atmel-quadspi.c                                     |    2 
 drivers/spi/spi-altera-dfl.c                                    |    2 
 drivers/spi/spi-altera-platform.c                               |    2 
 drivers/spi/spi-bcm-qspi.c                                      |    8 
 drivers/spi/spi-mtk-nor.c                                       |    2 
 drivers/spi/spi-pl022.c                                         |    5 
 drivers/spi/spi-rpc-if.c                                        |    4 
 drivers/spi/spi-stm32-qspi.c                                    |    2 
 drivers/spi/spi.c                                               |   41 +
 drivers/staging/ks7010/Kconfig                                  |    3 
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c              |   37 -
 drivers/staging/media/imx/imx-media-dev-common.c                |    2 
 drivers/staging/media/ipu3/ipu3-v4l2.c                          |    7 
 drivers/staging/media/rkvdec/rkvdec-h264.c                      |    5 
 drivers/staging/media/rkvdec/rkvdec.c                           |   40 -
 drivers/staging/most/dim2/Makefile                              |    2 
 drivers/staging/most/dim2/dim2.c                                |   24 
 drivers/staging/most/dim2/sysfs.c                               |   49 -
 drivers/staging/most/dim2/sysfs.h                               |   11 
 drivers/target/target_core_tmr.c                                |   17 
 drivers/target/target_core_transport.c                          |   30 -
 drivers/thermal/qcom/tsens.c                                    |   29 -
 drivers/thermal/thermal_core.c                                  |   16 
 drivers/tty/serial/8250/8250_dw.c                               |    2 
 drivers/tty/serial/8250/8250_port.c                             |   21 
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                     |    2 
 drivers/tty/serial/imx.c                                        |    4 
 drivers/tty/serial/serial_core.c                                |   16 
 drivers/tty/serial/xilinx_uartps.c                              |    3 
 drivers/usb/chipidea/core.c                                     |   23 
 drivers/usb/dwc2/drd.c                                          |   24 
 drivers/usb/gadget/legacy/hid.c                                 |    4 
 drivers/usb/host/xhci-hub.c                                     |    3 
 drivers/usb/host/xhci-pci.c                                     |   16 
 drivers/usb/misc/iowarrior.c                                    |    8 
 drivers/usb/musb/Kconfig                                        |    2 
 drivers/usb/serial/keyspan.c                                    |   15 
 drivers/usb/typec/Kconfig                                       |    4 
 drivers/video/backlight/backlight.c                             |    6 
 drivers/video/fbdev/chipsfb.c                                   |    2 
 drivers/video/fbdev/efifb.c                                     |   21 
 drivers/virtio/virtio_ring.c                                    |   14 
 drivers/watchdog/Kconfig                                        |    2 
 drivers/watchdog/f71808e_wdt.c                                  |    4 
 drivers/watchdog/omap_wdt.c                                     |    6 
 drivers/xen/balloon.c                                           |   86 ++-
 drivers/xen/xen-pciback/conf_space_capability.c                 |    2 
 fs/btrfs/disk-io.c                                              |    3 
 fs/btrfs/reflink.c                                              |    2 
 fs/btrfs/tree-log.c                                             |    4 
 fs/btrfs/volumes.c                                              |   14 
 fs/cifs/cifsglob.h                                              |    3 
 fs/cifs/connect.c                                               |   21 
 fs/cifs/file.c                                                  |   35 +
 fs/cifs/fs_context.c                                            |   10 
 fs/cifs/fs_context.h                                            |    1 
 fs/crypto/fscrypt_private.h                                     |    5 
 fs/crypto/hkdf.c                                                |   11 
 fs/crypto/keysetup.c                                            |   57 +-
 fs/erofs/decompressor.c                                         |    1 
 fs/erofs/zdata.c                                                |   13 
 fs/erofs/zpvec.h                                                |   13 
 fs/exfat/inode.c                                                |    2 
 fs/ext4/extents.c                                               |   63 +-
 fs/ext4/super.c                                                 |    9 
 fs/f2fs/compress.c                                              |    1 
 fs/f2fs/inode.c                                                 |    2 
 fs/f2fs/namei.c                                                 |    2 
 fs/f2fs/super.c                                                 |    2 
 fs/fuse/dev.c                                                   |   14 
 fs/gfs2/glock.c                                                 |   24 
 fs/io-wq.c                                                      |   38 -
 fs/jfs/jfs_mount.c                                              |   51 --
 fs/nfs/dir.c                                                    |    9 
 fs/nfs/direct.c                                                 |    2 
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                       |    4 
 fs/nfs/inode.c                                                  |   13 
 fs/nfs/nfs3xdr.c                                                |    2 
 fs/nfs/nfs4idmap.c                                              |    2 
 fs/nfs/nfs4proc.c                                               |   15 
 fs/nfs/pnfs.h                                                   |    2 
 fs/nfs/pnfs_nfs.c                                               |    6 
 fs/nfs/proc.c                                                   |    2 
 fs/nfs/write.c                                                  |   26 -
 fs/ocfs2/file.c                                                 |    8 
 fs/orangefs/dcache.c                                            |    4 
 fs/overlayfs/file.c                                             |   16 
 fs/proc/stat.c                                                  |    4 
 fs/proc/uptime.c                                                |   14 
 fs/quota/quota_tree.c                                           |   15 
 fs/tracefs/inode.c                                              |    3 
 include/drm/ttm/ttm_bo_api.h                                    |    3 
 include/linux/blkdev.h                                          |    2 
 include/linux/cc_platform.h                                     |   88 +++
 include/linux/cgroup-defs.h                                     |  107 +---
 include/linux/cgroup.h                                          |   22 
 include/linux/console.h                                         |    2 
 include/linux/dsa/ocelot.h                                      |   38 +
 include/linux/ethtool_netlink.h                                 |    3 
 include/linux/filter.h                                          |    1 
 include/linux/fortify-string.h                                  |    5 
 include/linux/kernel_stat.h                                     |    1 
 include/linux/libata.h                                          |    2 
 include/linux/nfs_fs.h                                          |    1 
 include/linux/posix-timers.h                                    |    2 
 include/linux/rpmsg.h                                           |    2 
 include/linux/sched.h                                           |    1 
 include/linux/sched/task.h                                      |    3 
 include/linux/sched/task_stack.h                                |    4 
 include/linux/seq_file.h                                        |    2 
 include/linux/skmsg.h                                           |   18 
 include/linux/surface_aggregator/controller.h                   |    4 
 include/linux/tpm.h                                             |    1 
 include/media/videobuf2-core.h                                  |   37 -
 include/memory/renesas-rpc-if.h                                 |    1 
 include/net/inet_connection_sock.h                              |    2 
 include/net/llc.h                                               |    4 
 include/net/neighbour.h                                         |   12 
 include/net/sch_generic.h                                       |    4 
 include/net/sctp/sctp.h                                         |    7 
 include/net/sock.h                                              |    2 
 include/net/strparser.h                                         |   20 
 include/net/tcp.h                                               |   17 
 include/net/udp.h                                               |    5 
 include/scsi/scsi_cmnd.h                                        |    2 
 include/scsi/scsi_host.h                                        |    1 
 include/soc/mscc/ocelot.h                                       |   24 
 include/sound/soc-topology.h                                    |    3 
 include/uapi/linux/ethtool_netlink.h                            |    4 
 include/uapi/linux/pci_regs.h                                   |    6 
 kernel/bpf/core.c                                               |    4 
 kernel/bpf/trampoline.c                                         |    6 
 kernel/bpf/verifier.c                                           |    4 
 kernel/cgroup/cgroup.c                                          |   94 +--
 kernel/cgroup/rstat.c                                           |    2 
 kernel/fork.c                                                   |    3 
 kernel/kprobes.c                                                |    3 
 kernel/locking/lockdep.c                                        |    4 
 kernel/locking/rwsem.c                                          |   53 +-
 kernel/power/energy_model.c                                     |   23 
 kernel/power/swap.c                                             |    7 
 kernel/rcu/rcutorture.c                                         |   48 +
 kernel/rcu/tasks.h                                              |    3 
 kernel/rcu/tree_exp.h                                           |    2 
 kernel/rcu/tree_plugin.h                                        |    8 
 kernel/sched/core.c                                             |   62 +-
 kernel/scs.c                                                    |    1 
 kernel/signal.c                                                 |   18 
 kernel/time/posix-cpu-timers.c                                  |   19 
 kernel/trace/ftrace.c                                           |   23 
 kernel/trace/ring_buffer.c                                      |    5 
 kernel/trace/trace.c                                            |   73 +-
 kernel/trace/trace.h                                            |    3 
 kernel/trace/trace_dynevent.c                                   |    2 
 kernel/trace/trace_event_perf.c                                 |    6 
 kernel/trace/trace_events.c                                     |   42 -
 kernel/trace/trace_events_synth.c                               |    4 
 kernel/trace/trace_functions_graph.c                            |    2 
 kernel/trace/trace_hwlat.c                                      |    6 
 kernel/trace/trace_kprobe.c                                     |    8 
 kernel/trace/trace_osnoise.c                                    |   14 
 kernel/trace/trace_printk.c                                     |    2 
 kernel/trace/trace_recursion_record.c                           |    4 
 kernel/trace/trace_stack.c                                      |    6 
 kernel/trace/trace_stat.c                                       |    6 
 kernel/trace/trace_uprobe.c                                     |    4 
 kernel/trace/tracing_map.c                                      |   40 -
 kernel/workqueue.c                                              |   15 
 lib/decompress_unxz.c                                           |    2 
 lib/dynamic_debug.c                                             |   12 
 lib/iov_iter.c                                                  |    5 
 lib/xz/xz_dec_lzma2.c                                           |   21 
 lib/xz/xz_dec_stream.c                                          |    6 
 mm/filemap.c                                                    |    1 
 mm/memcontrol.c                                                 |   27 -
 mm/oom_kill.c                                                   |   23 
 mm/zsmalloc.c                                                   |    7 
 net/8021q/vlan.c                                                |    3 
 net/8021q/vlan_dev.c                                            |    3 
 net/9p/client.c                                                 |    2 
 net/bluetooth/l2cap_sock.c                                      |   10 
 net/bluetooth/sco.c                                             |   33 -
 net/bridge/br_private.h                                         |    2 
 net/can/j1939/main.c                                            |    7 
 net/can/j1939/transport.c                                       |    6 
 net/core/dev.c                                                  |    5 
 net/core/filter.c                                               |   58 ++
 net/core/neighbour.c                                            |   48 +
 net/core/net-sysfs.c                                            |   55 ++
 net/core/net_namespace.c                                        |    4 
 net/core/netclassid_cgroup.c                                    |    7 
 net/core/netprio_cgroup.c                                       |   10 
 net/core/skmsg.c                                                |   43 +
 net/core/stream.c                                               |    3 
 net/core/sysctl_net_core.c                                      |    2 
 net/dccp/dccp.h                                                 |    2 
 net/dccp/proto.c                                                |   14 
 net/dsa/Kconfig                                                 |    2 
 net/dsa/switch.c                                                |    4 
 net/dsa/tag_ocelot.c                                            |    4 
 net/dsa/tag_ocelot_8021q.c                                      |    1 
 net/ethtool/pause.c                                             |    3 
 net/ipv4/inet_connection_sock.c                                 |    4 
 net/ipv4/inet_hashtables.c                                      |    2 
 net/ipv4/proc.c                                                 |    2 
 net/ipv4/tcp.c                                                  |   40 +
 net/ipv4/tcp_bpf.c                                              |   48 +
 net/ipv6/addrconf.c                                             |    3 
 net/ipv6/udp.c                                                  |    2 
 net/netfilter/nf_conntrack_proto_udp.c                          |    7 
 net/netfilter/nfnetlink_queue.c                                 |    2 
 net/netfilter/nft_dynset.c                                      |   11 
 net/rxrpc/rtt.c                                                 |    2 
 net/sched/sch_generic.c                                         |    9 
 net/sched/sch_mq.c                                              |   24 
 net/sched/sch_mqprio.c                                          |   23 
 net/sched/sch_taprio.c                                          |   27 -
 net/sctp/output.c                                               |   13 
 net/sctp/transport.c                                            |   11 
 net/smc/af_smc.c                                                |   20 
 net/smc/smc_llc.c                                               |    2 
 net/strparser/strparser.c                                       |   10 
 net/sunrpc/addr.c                                               |   40 -
 net/sunrpc/xprt.c                                               |   28 -
 net/vmw_vsock/af_vsock.c                                        |    2 
 net/wireless/core.c                                             |   10 
 samples/kprobes/kretprobe_example.c                             |    2 
 scripts/leaking_addresses.pl                                    |    3 
 security/apparmor/label.c                                       |    4 
 security/integrity/evm/evm_main.c                               |    2 
 security/integrity/ima/ima.h                                    |    2 
 security/integrity/ima/ima_appraise.c                           |   52 +-
 security/selinux/ss/services.c                                  |  162 +++---
 security/smack/smackfs.c                                        |   11 
 sound/core/memalloc.c                                           |    7 
 sound/core/oss/mixer_oss.c                                      |   44 +
 sound/core/timer.c                                              |   17 
 sound/firewire/oxfw/oxfw-stream.c                               |    7 
 sound/firewire/oxfw/oxfw.c                                      |    8 
 sound/firewire/oxfw/oxfw.h                                      |    5 
 sound/pci/hda/hda_intel.c                                       |   52 --
 sound/pci/hda/patch_realtek.c                                   |   82 +++
 sound/soc/codecs/cs42l42.c                                      |   43 -
 sound/soc/codecs/wcd9335.c                                      |    2 
 sound/soc/sh/rcar/core.c                                        |    1 
 sound/soc/soc-core.c                                            |    1 
 sound/soc/sof/topology.c                                        |    9 
 sound/soc/tegra/tegra_asoc_machine.c                            |   60 +-
 sound/soc/tegra/tegra_asoc_machine.h                            |    1 
 sound/synth/emux/emux.c                                         |    2 
 sound/usb/6fire/comm.c                                          |    2 
 sound/usb/6fire/firmware.c                                      |    6 
 sound/usb/format.c                                              |    1 
 sound/usb/line6/driver.c                                        |   14 
 sound/usb/line6/driver.h                                        |    2 
 sound/usb/line6/podhd.c                                         |    6 
 sound/usb/line6/toneport.c                                      |    2 
 sound/usb/misc/ua101.c                                          |    4 
 sound/usb/quirks.c                                              |    1 
 tools/arch/x86/lib/insn.c                                       |    5 
 tools/bpf/bpftool/prog.c                                        |   16 
 tools/include/asm-generic/unaligned.h                           |   23 
 tools/lib/bpf/bpf.c                                             |    4 
 tools/lib/bpf/bpf_core_read.h                                   |    2 
 tools/lib/bpf/btf.c                                             |   22 
 tools/lib/bpf/libbpf.c                                          |    6 
 tools/lib/bpf/skel_internal.h                                   |    6 
 tools/objtool/arch/x86/decode.c                                 |   20 
 tools/objtool/check.c                                           |  159 +++---
 tools/objtool/include/objtool/arch.h                            |    1 
 tools/perf/util/bpf-event.c                                     |    4 
 tools/perf/util/intel-pt-decoder/Build                          |    2 
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c            |    4 
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c              |    4 
 tools/testing/selftests/bpf/prog_tests/test_ima.c               |    3 
 tools/testing/selftests/bpf/progs/strobemeta.h                  |    4 
 tools/testing/selftests/bpf/test_progs.c                        |    4 
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh          |   62 +-
 tools/testing/selftests/bpf/verifier/array_access.c             |    2 
 tools/testing/selftests/bpf/xdp_redirect_multi.c                |    4 
 tools/testing/selftests/core/close_range_test.c                 |    2 
 tools/testing/selftests/kvm/lib/x86_64/svm.c                    |   14 
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c          |    2 
 tools/testing/selftests/net/Makefile                            |    2 
 tools/testing/selftests/net/fcnal-test.sh                       |    3 
 tools/testing/selftests/net/fib_nexthops.sh                     |    1 
 tools/testing/selftests/net/forwarding/bridge_igmp.sh           |   12 
 tools/testing/selftests/net/forwarding/bridge_mld.sh            |   12 
 tools/testing/selftests/net/udpgso_bench_rx.c                   |   11 
 tools/testing/selftests/sched/cs_prctl_test.c                   |   28 -
 tools/testing/selftests/vm/split_huge_page_test.c               |    2 
 tools/testing/selftests/x86/iopl.c                              |   78 ++-
 tools/tracing/latency/latency-collector.c                       |    2 
 956 files changed, 7996 insertions(+), 4407 deletions(-)

Abinaya Kalaiselvan (1):
      ath10k: fix module load regression with iram-recovery feature

Aharon Landau (1):
      RDMA/core: Require the driver to set the IOVA correctly during rereg_mr

Ahmad Fatoum (1):
      watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Ajay Singh (1):
      wilc1000: fix possible memory leak in cfg_scan_result()

Ajish Koshy (1):
      scsi: pm80xx: Fix lockup in outbound queue management

Alagu Sankar (1):
      ath10k: high latency fixes for beacon buffer

Aleksander Jan Bajkowski (3):
      MIPS: lantiq: dma: add small delay after reset
      MIPS: lantiq: dma: reset correct number of channel
      MIPS: lantiq: dma: fix burst length for DEU

Alex Bee (2):
      drm: bridge: it66121: Fix return value it66121_probe
      arm64: dts: rockchip: Fix GPU register width for RK3328

Alex Deucher (2):
      drm/amdgpu/pm: properly handle sclk for profiling modes on vangogh
      drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits

Alex Sierra (1):
      drm/amdkfd: rm BO resv on validation to avoid deadlock

Alex Xu (Hello71) (1):
      drm/plane-helper: fix uninitialized variable reference

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 400

Alexandru Ardelean (1):
      iio: st_sensors: disable regulators after device unregistration

Alexei Starovoitov (2):
      bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
      bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.

Alexey Gladkov (1):
      Fix user namespace leak

Alok Prasad (1):
      RDMA/qedr: Fix NULL deref for query_qp on the GSI QP

Amelie Delaunay (5):
      usb: dwc2: drd: fix dwc2_force_mode call in dwc2_ovr_init
      usb: dwc2: drd: fix dwc2_drd_role_sw_set when clock could be disabled
      usb: dwc2: drd: reset current session before setting the new one
      dmaengine: stm32-dma: fix stm32_dma_get_max_width
      dmaengine: stm32-dma: fix burst in case of unaligned memory address

Amit Engel (1):
      nvmet-tcp: fix header digest verification

Anand Jain (1):
      btrfs: call btrfs_check_rw_degradable only if there is a missing device

Anand Moon (3):
      arm64: dts: meson-g12a: Fix the pwm regulator supply properties
      arm64: dts: meson-g12b: Fix the pwm regulator supply properties
      arm64: dts: meson-sm1: Fix the pwm regulator supply properties

Anant Thazhemadam (1):
      media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Anatolij Gustschin (1):
      dmaengine: bestcomm: fix system boot lockups

Anders Roxell (1):
      PM: hibernate: fix sparse warnings

Andrea Righi (1):
      selftests/bpf: Fix fclose/pclose mismatch in test_progs

Andreas Gruenbacher (3):
      iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value
      gfs2: Cancel remote delete work asynchronously
      gfs2: Fix glock_hash_walk bugs

Andreas Kemnade (1):
      arm: dts: omap3-gta04a4: accelerometer irq fix

Andrej Shadura (2):
      HID: u2fzero: clarify error check and length calculations
      HID: u2fzero: properly handle timeouts in usb_submit_urb

Andrew Halaney (1):
      dyndbg: make dyndbg a known cli param

Andrey Grodzovsky (1):
      drm/amdgpu: Fix MMIO access page fault

Andrii Nakryiko (4):
      selftests/bpf: Fix strobemeta selftest regression
      libbpf: Fix overflow in BTF sanity checks
      libbpf: Fix BTF header parsing checks
      selftests/bpf: Fix also no-alu32 strobemeta selftest

André Almeida (1):
      ACPI: battery: Accept charges over the design capacity as full

Andy Shevchenko (1):
      serial: 8250_dw: Drop wrong use of ACPI_PTR()

Anel Orazgaliyeva (1):
      cpuidle: Fix kobject memory leaks in error paths

Anson Jacob (1):
      drm/amd/display: dcn20_resource_construct reduce scope of FPU enabled

Anssi Hannula (1):
      serial: xilinx_uartps: Fix race condition causing stuck TX

Ansuel Smith (1):
      thermal/drivers/tsens: Add timeout to get_temp_tsens_valid

Antoine Tenart (1):
      net-sysfs: try not to restart the syscall if it will fail eventually

Arnaud Pouliquen (1):
      rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined

Arnd Bergmann (16):
      hyperv/vmbus: include linux/bitops.h
      ifb: fix building without CONFIG_NET_CLS_ACT
      ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
      gve: DQO: avoid unused variable warnings
      drm/amdgpu: fix warning for overflow check
      crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
      drm: fb_helper: fix CONFIG_FB dependency
      crypto: ccree - avoid out-of-range warnings from clang
      memstick: avoid out-of-range warning
      ARM: 9142/1: kasan: work around LPAE build warning
      iommu/mediatek: Fix out-of-range warning with clang
      drm: fb_helper: improve CONFIG_FB dependency
      arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
      dmaengine: stm32-dma: avoid 64-bit division in stm32_dma_get_max_width
      ARM: 9156/1: drop cc-option fallbacks for architecture selection
      ath10k: fix invalid dma_addr_t token assignment

Arun Easi (1):
      scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file

Asmaa Mnebhi (1):
      gpio: mlxbf2.c: Add check for bgpio_init failure

Athira Rajeev (1):
      powerpc/perf: Fix cycles/instructions as PM_CYC/PM_INST_CMPL in power10

Aurabindo Pillai (1):
      drm/amd/display: fix null pointer deref when plugging in display

Austin Kim (2):
      ALSA: synth: missing check for possible NULL after the call to kstrdup
      evm: mark evm_fixmode as __ro_after_init

Baochen Qiang (2):
      ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets
      ath11k: Fix memory leak in ath11k_qmi_driver_event_work

Baptiste Lepers (1):
      pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds

Barnabás Pőcze (1):
      platform/x86: wmi: do not fail if disabling fails

Basavaraj Natikar (2):
      pinctrl: amd: Add irq field data
      pinctrl: amd: Handle wake-up interrupt

Bastien Roucariès (1):
      ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode

Ben Greear (1):
      mt76: mt7915: fix hwmon temp sensor mem use-after-free

Ben Skeggs (1):
      ce/gf100: fix incorrect CE0 address calculation on some GPUs

Benjamin Li (2):
      wcn36xx: handle connection loss indication
      wcn36xx: add proper DMA memory barriers in rx path

Bhupesh Sharma (1):
      arm64: dts: qcom: sdm845: Use RPMH_CE_CLK macro directly

Bixuan Cui (1):
      powerpc/44x/fsp2: add missing of_node_put

Bjorn Andersson (1):
      soc: qcom: rpmhpd: Make power_on actually enable the domain

Borislav Petkov (3):
      x86/insn: Use get_unaligned() instead of memcpy()
      selftests/x86/iopl: Adjust to the faked iopl CLI/STI usage
      x86/sev: Make the #VC exception stacks part of the default stacks storage

Brett Creeley (1):
      ice: Fix not stopping Tx queues for VFs

Bryan O'Donoghue (2):
      Revert "wcn36xx: Enable firmware link monitoring"
      wcn36xx: Fix Antenna Diversity Switching

Bryant Mairs (1):
      drm: panel-orientation-quirks: Add quirk for Aya Neo 2021

Catherine Sullivan (1):
      gve: Track RX buffer allocation failures

Charan Teja Reddy (1):
      dma-buf: WARN on dmabuf release with pending attachments

Chen-Yu Tsai (2):
      media: rkvdec: Do not override sizeimage for output format
      media: rkvdec: Support dynamic resolution changes

Chengfeng Ye (1):
      nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Chenyuan Mi (1):
      drm/nouveau/svm: Fix refcount leak bug and missing check against null bug

Christian Löhle (1):
      mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Christophe JAILLET (12):
      media: meson-ge2d: Fix rotation parameter changes detection in 'ge2d_s_ctrl()'
      media: mtk-vpu: Fix a resource leak in the error handling path of 'mtk_vpu_probe()'
      media: imx-jpeg: Fix the error handling path of 'mxc_jpeg_probe()'
      mmc: mxs-mmc: disable regulator on error and in the remove function
      ipmi: kcs_bmc: Fix a memory leak in the error handling path of 'kcs_bmc_serio_add_device()'
      clk: mvebu: ap-cpu-clk: Fix a memory leak in error handling paths
      soc/tegra: Fix an error handling path in tegra_powergate_power_up()
      ASoC: rsnd: Fix an error handling path in 'rsnd_node_count()'
      remoteproc: Fix a memory leak in an error handling path in 'rproc_handle_vdev()'
      i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_probe()'
      PCI: j721e: Fix j721e_pcie_probe() error path
      net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory

Christophe Leroy (6):
      powerpc/mem: Fix arch/powerpc/mm/mem.c:53:12: error: no previous prototype for 'create_section_mapping'
      video: fbdev: chipsfb: use memset_io() instead of memset()
      powerpc/booke: Disable STRICT_KERNEL_RWX, DEBUG_PAGEALLOC and KFENCE
      powerpc/nohash: Fix __ptep_set_access_flags() and ptep_set_wrprotect()
      powerpc/book3e: Fix set_memory_x() and set_memory_nx()
      powerpc: Don't provide __kernel_map_pages() without ARCH_SUPPORTS_DEBUG_PAGEALLOC

Claudio Imbrenda (2):
      KVM: s390: pv: avoid double free of sida page
      KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm

Claudiu Beznea (6):
      power: reset: at91-reset: check properly the return value of devm_of_iomap
      clk: at91: sam9x60-pll: use DIV_ROUND_CLOSEST_ULL
      clk: at91: clk-master: check if div or pres is zero
      clk: at91: clk-master: fix prescaler logic
      dmaengine: at_xdmac: call at_xdmac_axi_config() on resume path
      dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Clément Léger (1):
      clk: at91: check pmc node status before registering syscore ops

Colin Ian King (4):
      media: cxd2880-spi: Fix a null pointer dereference on error handling path
      media: cx23885: Fix snd_card_free call on null card pointer
      media: em28xx: Don't use ops->suspend if it is NULL
      mmc: moxart: Fix null pointer dereference on pointer host

Corey Minyard (2):
      ipmi:watchdog: Set panic count to proper value on a panic
      ipmi: Disable some operations during a panic

Cyril Strejc (1):
      net: multicast: calculate csum of looped-back and forwarded packets

Daeho Jeong (1):
      f2fs: include non-compressed blocks in compr_written_block

Dafna Hirschfeld (1):
      media: mtk-vcodec: venc: fix return value when start_streaming fails

Damien Le Moal (1):
      libata: fix read log timeout value

Dan Carpenter (16):
      tpm: Check for integer overflow in tpm2_map_response_body()
      ath11k: fix some sleeping in atomic bugs
      b43legacy: fix a lower bounds test
      b43: fix a lower bounds test
      memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
      drm/msm: Fix potential Oops in a6xx_gmu_rpmh_init()
      drm/msm: potential error pointer dereference in init()
      drm/msm: fix potential NULL dereference in cleanup
      drm/msm: uninitialized variable in msm_gem_import()
      mt76: mt7915: fix info leak in mt7915_mcu_set_pre_cal()
      usb: gadget: hid: fix error code in do_config()
      scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
      phy: ti: gmii-sel: check of_get_address() for failure
      rtc: rv3032: fix error handling in rv3032_clkout_set_rate()
      zram: off by one in read_block_state()
      gve: Fix off by one in gve_tx_timeout()

Dan Schatzberg (1):
      cgroup: Fix rootcg cpu.stat guest double counting

Dan Williams (1):
      cxl/pci: Fix NULL vs ERR_PTR confusion

Daniel Borkmann (4):
      net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
      net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE
      bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
      bpf, cgroup: Assign cgroup in cgroup_sk_alloc when called from interrupt

Daniel Jordan (1):
      crypto: pcrypt - Delay write to padata->info

Dave Jones (1):
      x86/mce: Add errata workaround for Skylake SKX37

David Hildenbrand (5):
      s390/gmap: validate VMA in __gmap_zap()
      s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()
      s390/mm: validate VMA in PGSTE manipulation functions
      s390/mm: fix VMA and page table handling code in storage key handling functions
      s390/uv: fully validate the VMA before calling follow_page()

David Stevens (1):
      iommu/dma: Fix arch_sync_dma for map

David Virag (1):
      soc: samsung: exynos-pmu: Fix compilation when nothing selects CONFIG_MFD_CORE

David Woodhouse (1):
      KVM: x86: Fix recording of guest steal time / preempted status

David Yang (1):
      tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer

Davide Baldo (1):
      ALSA: hda/realtek: Fixes HP Spectre x360 15-eb1xxx speakers

Denis Kirjanov (1):
      powerpc/xmon: fix task state output

Deren Wu (2):
      mt76: mt7921: Fix out of order process by invalid event pkt
      mt76: mt7921: fix dma hang in rmmod

Derong Liu (1):
      mmc: mtk-sd: Add wait dma stop done flow

Desmond Cheong Zhi Xi (1):
      Bluetooth: fix init and cleanup of sco_conn.timeout_work

Dinghao Liu (1):
      Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Dirk Bender (1):
      media: mt9p031: Fix corrupted frame after restarting stream

Dmitriy Ulitin (1):
      media: stm32: Potential NULL pointer dereference in dcmi_irq_thread()

Dmitry Baryshkov (3):
      soc: qcom: socinfo: add two missing PMIC IDs
      soc: qcom: rpmhpd: fix sm8350_mxc's peer domain
      drm/bridge/lontium-lt9611uxc: fix provided connector suport

Dmitry Bogdanov (2):
      scsi: qla2xxx: Fix unmap of already freed sgl
      scsi: target: core: Remove from tmr_list during LUN unlink

Dmitry Osipenko (2):
      ASoC: tegra: Set default card name for Trimslice
      ASoC: tegra: Restore AC97 support

Dominique Martinet (1):
      9p/net: fix missing error check in p9_check_errors

Dong Aisheng (4):
      remoteproc: imx_rproc: Fix TCM io memory type
      remoteproc: Fix the wrong default value of is_iomem
      remoteproc: imx_rproc: Fix ignoring mapping vdev regions
      remoteproc: imx_rproc: Fix rsc-table name

Dongjin Kim (1):
      arm64: dts: meson: sm1: add Ethernet PHY reset line for ODROID-C4/HC4

Dongli Zhang (2):
      xen/netfront: stop tx queues during live migration
      vmxnet3: do not stop tx queues after netif_device_detach()

Dongliang Mu (3):
      JFS: fix memleak in jfs_mount
      memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe
      f2fs: fix UAF in f2fs_available_free_memory

Douglas Anderson (1):
      arm64: dts: qcom: sc7180: Base dynamic CPU power coefficients in reality

Dust Li (1):
      net/smc: fix sk_refcnt underflow on linkdown and fallback

Eiichi Tsukata (1):
      vsock: prevent unnecessary refcnt inc for nonblocking connect

Eric Badger (1):
      EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Eric Biggers (1):
      fscrypt: allow 256-bit master keys with AES-256-XTS

Eric Dumazet (5):
      net: annotate data-race in neigh_output()
      tcp: switch orphan_count to bare per-cpu counters
      bpf: Fixes possible race in update_prog_stats() for 32bit arches
      llc: fix out-of-bound array index in llc_sk_dev_hash()
      net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any

Eric W. Biederman (3):
      signal: Remove the bogus sigkill_pending in ptrace_stop
      signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT
      signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)

Erik Ekman (2):
      sfc: Export fibre-specific supported link modes
      sfc: Don't use netif_info before net_device setup

Eugen Hristev (1):
      media: atmel: fix the ispck initialization

Evgeny Novikov (6):
      media: atomisp: Fix error handling in probe
      media: vidtv: Fix memory leak in remove
      media: ttusb-dec: avoid release of non-acquired mutex
      media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()
      mtd: rawnand: intel: Fix potential buffer overflow in probe
      mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()

Ewan D. Milne (1):
      scsi: core: Avoid leaving shost->last_reset with stale value if EH does not run

Fabio Estevam (2):
      ath10k: sdio: Add missing BH locking around napi_schdule()
      Revert "drm/imx: Annotate dma-fence critical section in commit path"

Fabrice Gasnier (1):
      ARM: dts: stm32: fix STUSB1600 Type-C irq level on stm32mp15xx-dkx

Felix Fietkau (1):
      mt76: mt7615: fix skb use-after-free on mac reset

Filipe Manana (1):
      btrfs: fix lost error handling when replaying directory deletes

Florian Westphal (3):
      fcnal-test: kill hanging ping/nettest binaries on cleanup
      vrf: run conntrack only in context of lower/physdev for locally generated packets
      netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Frank Rowand (1):
      of: unittest: fix EXPECT text for gpio hog errors

Gao Xiang (2):
      erofs: don't trigger WARN() when decompression fails
      erofs: fix unsafe pagevec reuse of hooked pclusters

Geert Uytterhoeven (7):
      arm64: dts: renesas: beacon: Fix Ethernet PHY mode
      pinctrl: renesas: checker: Fix off-by-one bug in drive register check
      serial: cpm_uart: Protect udbg definitions by CONFIG_SERIAL_CPM_CONSOLE
      mips: cm: Convert to bitfield API to fix out-of-bounds access
      auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string
      auxdisplay: ht16k33: Connect backlight to fbdev
      auxdisplay: ht16k33: Fix frame buffer device blanking

Giovanni Cabiddu (2):
      crypto: qat - detect PFVF collision after ACK
      crypto: qat - disregard spurious PFVF interrupts

Greg Kroah-Hartman (1):
      Linux 5.14.19

Guangbin Huang (2):
      net: hns3: ignore reset event before initialization process is done
      net: hns3: allow configure ETS bandwidth of all TCs

Guchun Chen (1):
      drm/amdgpu: move amdgpu_virt_release_full_gpu to fini_early stage

Guo Ren (1):
      irqchip/sifive-plic: Fixup EOI failed when masked

Guoqing Jiang (1):
      md/raid1: only allocate write behind bio for WriteMostly device

Guru Das Srinagesh (1):
      firmware: qcom_scm: Fix error retval in __qcom_scm_is_call_available()

Gustavo A. R. Silva (1):
      powerpc/vas: Fix potential NULL pointer dereference

Halil Pasic (1):
      s390/cio: make ccw_device_dma_* more robust

Hangbin Liu (5):
      kselftests/net: add missed icmp.sh test to Makefile
      selftests/bpf/xdp_redirect_multi: Put the logs to tmp folder
      selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number
      selftests/bpf/xdp_redirect_multi: Give tcpdump a chance to terminate cleanly
      selftests/bpf/xdp_redirect_multi: Limit the tests in netns

Hannes Reinecke (1):
      nvme: drop scan_lock and always kick requeue list when removing namespaces

Hans Verkuil (1):
      media: vidtv: move kfree(dvb) to vidtv_bridge_dev_release()

Hans de Goede (7):
      drm: panel-orientation-quirks: Update the Lenovo Ideapad D330 quirk (v2)
      drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
      drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6
      brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet
      power: supply: bq27xxx: Fix kernel crash on IRQ handler register error
      ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses
      media: videobuf2-dma-sg: Fix buf->vb NULL pointer dereference

Hao Wu (1):
      tpm: fix Atmel TPM crash caused by too frequent queries

Haoyue Xu (1):
      RDMA/hns: Fix initial arm_st of CQ

Harald Freudenberger (1):
      s390/ap: Fix hanging ioctl caused by orphaned replies

Hari Bathini (1):
      powerpc/bpf: Fix write protecting JIT code

Heiner Kallweit (1):
      net: phy: fix duplex out of sync problem while changing settings

Helge Deller (4):
      parisc: Fix set_fixmap() on PA1.x CPUs
      parisc: Fix ptrace check on syscall return
      task_stack: Fix end_of_stack() for architectures with upwards-growing stack
      parisc: Fix backtrace to always include init funtion names

Henrik Grimler (1):
      power: supply: max17042_battery: use VFSOC for capacity when no rsns

Horia Geantă (1):
      crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks

Huang Guobin (1):
      bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Hui Wang (2):
      ACPI: resources: Add DMI-based legacy IRQ override quirk
      ACPI: resources: Add one more Medion model in IRQ override quirk

Iago Toral Quiroga (1):
      drm/v3d: fix wait for TMU write combiner flush

Ian Rogers (1):
      perf bpf: Add missing free to bpf_event__print_bpf_prog_info()

Igor Pylypiv (1):
      scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()

Ilya Leoshkevich (1):
      libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()

Imre Deak (2):
      fbdev/efifb: Release PCI device's runtime PM ref during FB destroy
      drm/i915/fb: Fix rounding error in subsampled plane size calculation

Ingmar Klein (1):
      PCI: Mark Atheros QCA6174 to avoid bus reset

Israel Rukshin (3):
      nvmet: fix use-after-free when a port is removed
      nvmet-rdma: fix use-after-free when a port is removed
      nvmet-tcp: fix use-after-free when a port is removed

Ivan Vecera (1):
      net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled

J. Bruce Fields (1):
      nfsd: don't alloc under spinlock in rpc_parse_scope_id

Jack Andersen (1):
      mfd: dln2: Add cell for initializing DLN2 ADC

Jackie Liu (3):
      ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()
      MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT
      ar7: fix kernel builds for compiler test

Jaegeuk Kim (1):
      f2fs: should use GFP_NOFS for directory inodes

Jakob Hauser (1):
      power: supply: rt5033_battery: Change voltage values to µV

Jakub Kicinski (4):
      net: sched: update default qdisc visibility after Tx queue cnt changes
      net: stream: don't purge sk_error_queue in sk_stream_kill_queues()
      udp6: allow SO_MARK ctrl msg to affect routing
      ethtool: fix ethtool msg len calculation for pause stats

James Smart (3):
      scsi: lpfc: Don't release final kref on Fport node while ABTS outstanding
      scsi: lpfc: Fix FCP I/O flush functionality for TMF routines
      scsi: lpfc: Wait for successful restart of SLI3 adapter during host sg_reset

Jan Kara (1):
      ocfs2: fix data corruption on truncate

Jane Malalane (1):
      x86/cpu: Fix migration safety with X86_BUG_NULL_SEL

Janghyub Seo (1):
      r8169: Add device 10ec:8162 to driver r8169

Janis Schoetterl-Glausch (1):
      KVM: s390: Fix handle_sske page fault handling

Jaroslav Kysela (1):
      ALSA: hda/realtek: Add a quirk for Acer Spin SP513-54N

Jason Gunthorpe (1):
      drm/ttm: remove ttm_bo_vm_insert_huge()

Jason Ormes (1):
      ALSA: usb-audio: Line6 HX-Stomp XL USB_ID for 48k-fixed quirk

Jens Axboe (5):
      block: bump max plugged deferred size from 16 to 32
      block: remove inaccurate requeue check
      io-wq: ensure that hash wait lock is IRQ disabling
      io-wq: fix queue stalling race
      io-wq: serialize hash clear with wakeup

Jeremy Soller (1):
      ALSA: hda/realtek: Headset fixup for Clevo NH77HJQ

Jernej Skrabec (1):
      drm/sun4i: Fix macros in sun8i_csc.h

Jessica Zhang (1):
      drm/msm: Fix potential NULL dereference in DPU SSPP

Jia-Ju Bai (1):
      fs: orangefs: fix error return code of orangefs_revalidate_lookup()

Jiasheng Jiang (1):
      rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()

Jie Wang (2):
      net: hns3: fix ROCE base interrupt vector initialization bug
      net: hns3: fix pfc packet number incorrect after querying pfc parameters

Jim Mattson (1):
      KVM: selftests: Fix nested SVM tests when built with clang

Jimmy Kizito (1):
      drm/amd/display: Fix null pointer dereference for encoders

Jiri Olsa (1):
      selftests/bpf: Fix perf_buffer test on system with offline cpus

Joerg Roedel (1):
      x86/sev: Fix stack type check in vc_switch_off_ist()

Johan Hovold (14):
      Input: iforce - fix control-message timeout
      ALSA: ua101: fix division by zero at probe
      ALSA: 6fire: fix control and bulk message timeouts
      ALSA: line6: fix control and interrupt message timeouts
      mwifiex: fix division by zero in fw download path
      ath6kl: fix division by zero in send path
      ath6kl: fix control-message timeout
      ath10k: fix control-message timeout
      ath10k: fix division by zero in send path
      rtl8187: fix control-message timeouts
      serial: 8250: fix racy uartclk update
      most: fix control-message timeouts
      USB: iowarrior: fix control-message timeouts
      USB: chipidea: fix interrupt deadlock

Johannes Berg (5):
      iwlwifi: mvm: disable RX-diversity in powersave
      cfg80211: always free wiphy specific regdomain
      iwlwifi: mvm: reset PM state on unsuccessful resume
      iwlwifi: pnvm: don't kmemdup() more than we have
      iwlwifi: pnvm: read EFI data only if long enough

John David Anglin (1):
      parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page

John Fastabend (3):
      bpf, sockmap: Remove unhash handler for BPF sockmap usage
      bpf, sockmap: Fix race in ingress receive verdict with redirect to self
      bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

John Fraker (1):
      gve: Recover from queue stall due to missed IRQ

John Keeping (1):
      Input: st1232 - increase "wait ready" timeout

Johnathon Clark (1):
      ALSA: hda/realtek: Fix mic mute LED for the HP Spectre x360 14

Jon Maxwell (1):
      tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()

Jonas Dreßler (5):
      mwifiex: Read a PCI register after writing the TX ring write pointer
      mwifiex: Try waking the firmware until we get an interrupt
      mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
      mwifiex: Properly initialize private structure on interface type changes
      mwifiex: Send DELBA requests according to spec

Josef Bacik (1):
      btrfs: do not take the uuid_mutex in btrfs_rm_device

Josh Don (1):
      fs/proc/uptime.c: Fix idle time reporting in /proc/uptime

Juergen Gross (1):
      xen/balloon: add late_initcall_sync() for initial ballooning done

Junji Wei (1):
      RDMA/rxe: Fix wrong port_cap_flags

Jussi Maki (1):
      bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg

Kai Song (1):
      mfd: altera-sysmgr: Fix a mistake caused by resource_size conversion

Kai Vehmanen (1):
      component: do not leave master devres group open after bind

Kai-Heng Feng (1):
      ALSA: hda/realtek: Add quirk for HP EliteBook 840 G7 mute LED

Kalesh Singh (1):
      tracing/cfi: Fix cmp_entries_* functions signature mismatch

Kan Liang (3):
      perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server
      perf/x86/intel/uncore: Fix invalid unit check
      perf/x86/intel/uncore: Fix Intel ICX IIO event constraints

Kees Cook (7):
      leaking_addresses: Always print a trailing newline
      fortify: Fix dropped strcpy() compile-time write overflow check
      media: radio-wl1273: Avoid card name truncation
      media: si470x: Avoid card name truncation
      media: tm6000: Avoid card name truncation
      clocksource/drivers/timer-ti-dm: Select TIMER_OF
      sched: Add wrapper for get_wchan() to keep task blocked

Kele Huang (1):
      ptp: fix error print of ptp_kvm on X86_64 platform

Kewei Xu (1):
      i2c: mediatek: fixing the incorrect register offset

Kishon Vijay Abraham I (6):
      arm64: dts: ti: k3-j721e-main: Fix "max-virtual-functions" in PCIe EP nodes
      arm64: dts: ti: k3-j721e-main: Fix "bus-range" upto 256 bus number for PCIe
      arm64: dts: ti: j7200-main: Fix "vendor-id"/"device-id" properties of pcie node
      arm64: dts: ti: j7200-main: Fix "bus-range" upto 256 bus number for PCIe
      dmaengine: ti: k3-udma: Set bchan to NULL if a channel request fail
      dmaengine: ti: k3-udma: Set r/tchan or rflow to NULL if request fail

Krzysztof Kozlowski (3):
      regulator: s5m8767: do not use reset value as DVS voltage if GPIO DVS is disabled
      regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property
      mfd: core: Add missing of_node_put for loop iteration

Kumar Kartikeya Dwivedi (3):
      libbpf: Fix skel_internal.h to set errno on loader retval < 0
      selftests/bpf: Fix fd cleanup in sk_lookup test
      selftests/bpf: Fix memory leak in test_ima

Kunihiko Hayashi (1):
      PCI: uniphier: Serialize INTx masking/unmasking and fix the bit operation

Lad Prabhakar (1):
      spi: spi-rpc-if: Check return value of rpcif_sw_init()

Lang Yu (2):
      drm/amdkfd: Fix an inappropriate error handling in allloc memory of gpu
      drm/amdgpu: fix a potential memory leak in amdgpu_device_fini_sw()

Lars-Peter Clausen (1):
      dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`

Lasse Collin (2):
      lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression
      lib/xz: Validate the value before assigning it to an enum variable

Laurent Vivier (1):
      KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling

Leon Romanovsky (3):
      bnxt_en: Check devlink allocation and registration status
      qed: Don't ignore devlink allocation failures
      RDMA/mlx4: Return missed an error if device doesn't support steering

Leon Yen (2):
      mt76: connac: fix mt76_connac_gtk_rekey_tlv usage
      mt76: connac: fix GTK rekey offload failure on WPA mixed mode

Li Chen (1):
      PCI: cadence: Add cdns_plat_pcie_probe() missing return

Li Zhang (1):
      btrfs: clear MISSING device status bit in btrfs_close_one_device

Li Zhijian (1):
      kselftests/sched: cleanup the child processes

Linus Lüssing (1):
      ath9k: Fix potential interrupt storm on queue reset

Linus Walleij (2):
      net: dsa: rtl8366rb: Fix off-by-one bug
      net: dsa: rtl8366: Fix a bug in deleting VLANs

Liu Jian (1):
      skmsg: Lose offset info in sk_psock_skb_ingress

Loic Poulain (8):
      wcn36xx: Fix HT40 capability for 2Ghz band
      wcn36xx: Fix tx_status mechanism
      wcn36xx: Fix (QoS) null data frame bitrate/modulation
      wcn36xx: Correct band/freq reporting on RX
      wcn36xx: Fix packet drop on resume
      ath10k: Fix missing frame timestamp for beacon/probe-resp
      wcn36xx: Fix discarded frames due to wrong sequence number
      wcn36xx: Channel list update before hardware scan

Lorenz Bauer (3):
      bpf: Define bpf_jit_alloc_exec_limit for riscv JIT
      bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
      bpf: Prevent increasing bpf_jit_limit above max

Lorenzo Bianconi (10):
      mt76: mt7921: fix endianness in mt7921_mcu_tx_done_event
      mt76: mt7915: fix endianness warning in mt7915_mac_add_txs_skb
      mt76: mt7921: fix endianness warning in mt7921_update_txs
      mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi
      mt76: mt7921: fix survey-dump reporting
      mt76: mt76x02: fix endianness warnings in mt76x02_mac.c
      mt76: overwrite default reg_ops if necessary
      mt76: mt7921: always wake device if necessary in debugfs
      mt76: mt7915: fix possible infinite loop release semaphore
      mt76: connac: fix possible NULL pointer dereference in mt76_connac_get_phy_mode_v2

Luis Chamberlain (5):
      floppy: fix calling platform_device_unregister() on invalid drives
      nvdimm/btt: do not call del_gendisk() if not needed
      block/ataflop: use the blk_cleanup_disk() helper
      block/ataflop: add registration bool before calling del_gendisk()
      block/ataflop: provide a helper for cleanup up an atari disk

Lukas Wunner (1):
      ifb: Depend on netfilter alternatively to tc

Maciej W. Rozycki (1):
      MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_LEVEL

Mansur Alisha Shaik (1):
      media: venus: fix vpp frequency calculation for decoder

Marc Kleine-Budde (2):
      can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int
      can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()

Marek Behún (6):
      PCI: pci-bridge-emul: Fix emulation of W1C bits
      PCI: aardvark: Fix return value of MSI domain .alloc() method
      PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG
      PCI: aardvark: Don't spam about PIO Response Status
      net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on ports other than 10
      net: marvell: mvpp2: Fix wrong SerDes reconfiguration order

Marek Vasut (3):
      rsi: Fix module dev_oper_mode parameter description
      ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz
      video: backlight: Drop maximum brightness override for brightness zero

Marijn Suijten (2):
      ARM: dts: qcom: msm8974: Add xo_board reference clock to DSI0 PHY
      arm64: dts: qcom: pmi8994: Fix "eternal"->"external" typo in WLED node

Mario (1):
      drm: panel-orientation-quirks: Add quirk for GPD Win3

Mario Limonciello (1):
      drm/amd/display: Look at firmware version to determine using dmub on dcn21

Mark Brown (11):
      spi: Check we have a spi_device_id for each DT compatible
      tpm_tis_spi: Add missing SPI ID
      iio: st_pressure_spi: Add missing entries SPI to device ID table
      ASoC: topology: Fix stub for snd_soc_tplg_component_remove()
      rtc: ds1302: Add SPI ID table
      rtc: ds1390: Add SPI ID table
      rtc: pcf2123: Add SPI ID table
      rtc: mcp795: Add SPI ID table
      Input: ariel-pwrbutton - add SPI device ID table
      mfd: cpcap: Add SPI device ID table
      mfd: sprd: Add SPI device ID table

Mark Rutland (2):
      KVM: arm64: Extract ESR_ELx.EC only
      irq: mips: avoid nested irq_enter()

Markus Schneider-Pargmann (1):
      hwrng: mtk - Force runtime pm ops for sleep ops

Martin Fuzzey (3):
      rsi: fix occasional initialisation failure with BT coex
      rsi: fix key enabled check causing unwanted encryption for vap_id > 0
      rsi: fix rate mask set leading to P2P failure

Martin Kepplinger (1):
      media: imx: set a media_device bus_info string

Masahiro Yamada (1):
      MIPS: fix duplicated slashes for Platform file path

Masami Hiramatsu (2):
      ia64: kprobes: Fix to pass correct trampoline address to the handler
      ARM: clang: Do not rely on lr register for stacktrace

Mathias Nyman (1):
      xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay

Matthew Auld (1):
      drm/ttm: stop calling tt_swapin in vm_access

Matthew Wilcox (Oracle) (1):
      mm/filemap.c: remove bogus VM_BUG_ON

Matthias Schiffer (1):
      net: phy: micrel: make *-skew-ps check more lenient

Mauricio Vásquez (1):
      libbpf: Fix memory leak in btf__dedup()

Maurizio Lombardi (1):
      nvmet-tcp: fix a memory leak when releasing a queue

Max Gurtovoy (1):
      nvme-rdma: fix error code in nvme_rdma_setup_ctrl

Maxim Kiselev (1):
      net: davinci_emac: Fix interrupt pacing disable

Maximilian Luz (3):
      platform/surface: aggregator_registry: Add support for Surface Laptop Studio
      HID: surface-hid: Use correct event registry for managing HID events
      HID: surface-hid: Allow driver matching for target ID 1 devices

Mehrdad Arshad Rad (1):
      libbpf: Fix lookup_and_delete_elem_flags error reporting

Meng Li (2):
      soc: fsl: dpio: replace smp_processor_id with raw_smp_processor_id
      soc: fsl: dpio: use the combined functions to protect critical zone

Menglong Dong (1):
      workqueue: make sysfs of unbound kworker cpumask more clever

Miaohe Lin (1):
      mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Michael Pratt (1):
      posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()

Michael Schmitz (2):
      block: ataflop: fix breakage introduced at blk-mq refactoring
      block: ataflop: more blk-mq refactoring fixes

Michael Tretter (1):
      media: allegro: ignore interrupt if mailbox is not initialized

Michael Walle (1):
      crypto: caam - disable pkc for non-E SoCs

Michal Hocko (1):
      mm, oom: do not trigger out_of_memory from the #PF

Michał Mirosław (1):
      ARM: 9155/1: fix early early_iounmap()

Mihail Chindris (2):
      drivers: iio: dac: ad5766: Fix dt property name
      Documentation:devicetree:bindings:iio:dac: Fix val

Miklos Szeredi (1):
      fuse: fix page stealing

Miquel Raynal (11):
      mtd: rawnand: socrates: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: arasan: Prevent an unsupported configuration
      mtd: rawnand: fsmc: Fix use of SM ORDER
      mtd: rawnand: ams-delta: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: xway: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: mpc5121: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: gpio: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: pasemi: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: orion: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: plat_nand: Keep the driver compatible with on-die ECC engines
      mtd: rawnand: au1550nd: Keep the driver compatible with on-die ECC engines

Mirela Rabulea (1):
      media: imx-jpeg: Fix possible null pointer dereference

Muchun Song (1):
      seq_file: fix passing wrong private data

Nadezda Lutovinova (2):
      media: s5p-mfc: Add checking to s5p_mfc_probe().
      media: rcar-csi2: Add checking to rcsi2_start_receiver()

Naina Mehta (1):
      soc: qcom: llcc: Disable MMUHWT retention

Naohiro Aota (1):
      block: schedule queue restart after BLK_STS_ZONE_RESOURCE

Nathan Chancellor (1):
      platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Nathan Lynch (3):
      powerpc: fix unbalanced node refcount in check_kvm_guest()
      powerpc/paravirt: correct preempt debug splat in vcpu_is_preempted()
      powerpc/pseries/mobility: ignore ibm, platform-facilities updates

Neeraj Upadhyay (1):
      rcu: Fix existing exp request check in sync_sched_exp_online_cleanup()

Nehal Bakulchandra Shah (1):
      usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

Nicholas Piggin (2):
      powerpc/32e: Ignore ESR in instruction storage interrupt handler
      powerpc/64s/interrupt: Fix check_return_regs_valid() false positive

Nick Desaulniers (1):
      arm64: vdso32: suppress error message for 'make mrproper'

Nick Hainke (1):
      mt76: mt7615: mt7622: fix ibss and meshpoint

Nikita Yushchenko (1):
      staging: most: dim2: do not double-register the same device

Niklas Söderlund (1):
      media: rcar-vin: Use user provided buffers when starting

Nikolay Aleksandrov (1):
      selftests: net: bridge: update IGMP/MLD membership interval value

Nuno Sá (2):
      iio: ad5770r: make devicetree property reading consistent
      iio: adis: do not disabe IRQs in 'adis_init()'

Oleksij Rempel (1):
      iio: adc: tsc2046: fix scan interval warning

Olivier Moysan (2):
      ARM: dts: stm32: fix SAI sub nodes register range
      ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15

Ondrej Jirman (1):
      media: sun6i-csi: Allow the video device to be open multiple times

Ondrej Mosnacek (1):
      selinux: fix race condition when computing ocontext SIDs

Ovidiu Panait (1):
      crypto: octeontx2 - set assoclen in aead_do_fallback()

Pablo Neira Ayuso (2):
      netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
      netfilter: nft_dynset: relax superfluous check on set updates

Pali Rohár (13):
      serial: core: Fix initializing and restoring termios speed
      PCI: aardvark: Do not clear status bits of masked interrupts
      PCI: aardvark: Fix checking for link up via LTSSM state
      PCI: aardvark: Do not unmask unused interrupts
      PCI: aardvark: Fix reporting Data Link Layer Link Active
      PCI: aardvark: Fix configuring Reference clock
      PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge
      PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
      PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
      PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge
      PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated bridge
      PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros
      PCI: aardvark: Fix PCIe Max Payload Size setting

Paolo Bonzini (1):
      KVM: x86: move guest_pv_has out of user_access section

Paul Cercueil (2):
      drm/bridge: it66121: Initialize {device,vendor}_ids
      drm/bridge: it66121: Wait for next bridge to be probed

Paul E. McKenney (1):
      rcu-tasks: Move RTGS_WAIT_CBS to beginning of rcu_tasks_kthread() loop

Paulo Alcantara (2):
      cifs: set a minimum of 120s for next dns resolution
      cifs: fix memory leak of smb3_fs_context_dup::server_hostname

Pavel Skripkin (3):
      ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
      media: em28xx: add missing em28xx_close_extension
      media: dvb-usb: fix ununit-value in az6027_rc_query

Pawan Gupta (1):
      smackfs: Fix use-after-free in netlbl_catmap_walk()

Paweł Anikiel (1):
      reset: socfpga: add empty driver allowing consumers to probe

Pekka Korpinen (1):
      iio: dac: ad5446: Fix ad5622_write() return value

Peng Fan (1):
      remoteproc: elf_loader: Fix loading segment when is_iomem true

Peter Geis (1):
      arm64: dts: rockchip: fix rk3568 mbi-alias

Peter Rosin (1):
      ARM: dts: at91: tse850: the emac<->phy interface is rmii

Peter Zijlstra (8):
      x86/iopl: Fake iopl(3) CLI/STI usage
      locking/lockdep: Avoid RCU-induced noinstr fail
      x86/mm/64: Improve stack overflow warnings
      x86: Increase exception stack sizes
      x86/xen: Mark cpu_bringup_and_idle() as dead_end_function
      objtool: Handle __sanitize_cov*() tail calls
      rcu: Always inline rcu_dynticks_task*_{enter,exit}()
      x86: Fix __get_wchan() for !STACKTRACE

Petr Machata (1):
      selftests: net: fib_nexthops: Wait before checking reported idle time

Phoenix Huang (1):
      Input: elantench - fix misreporting trackpoint coordinates

Pradeep Kumar Chitrapu (1):
      ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status

Punit Agrawal (1):
      kprobes: Do not use local variable when creating debugfs file

Qi Zheng (1):
      x86: Fix get_wchan() to support the ORC unwinder

Quentin Monnet (1):
      bpftool: Avoid leaking the JSON writer prepared for program metadata

Quentin Perret (1):
      KVM: arm64: Report corrupted refcount at EL2

Quinn Tran (3):
      scsi: qla2xxx: Fix use after free in eh_abort path
      scsi: qla2xxx: Fix gnl list corruption
      scsi: qla2xxx: Turn off target reset during issue_lip

Rafael J. Wysocki (8):
      PM: sleep: Do not let "syscore" devices runtime-suspend during system transitions
      ACPICA: Avoid evaluating methods too early during system resume
      ACPI: scan: Release PM resources blocked by unused objects
      ACPI: PM: Turn off unused wakeup power resources
      ACPI: PM: Fix sharing of wakeup power resources
      cpufreq: intel_pstate: Clear HWP desired on suspend/shutdown and offline
      ACPI: PM: Fix device wakeup power reference counting error
      PM: sleep: Avoid calling put_device() under dpm_list_mtx

Rafał Miłecki (2):
      ARM: dts: BCM5301X: Fix memory nodes names
      arm64: dts: broadcom: bcm4908: Fix UART clock name

Rahul Lakkireddy (1):
      cxgb4: fix eeprom len when diagnostics not implemented

Rahul Tanwar (1):
      pinctrl: equilibrium: Fix function addition in multiple groups

Rajat Asthana (1):
      media: mceusb: return without resubmitting URB in case of -EPROTO error.

Rakesh Babu (1):
      octeontx2-pf: Enable promisc/allmulti match MCAM entries.

Randy Dunlap (9):
      mmc: winbond: don't build on M68K
      ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
      media: i2c: ths8200 needs V4L2_ASYNC
      net: fealnx: fix build for UML
      net: tulip: winbond-840: fix build for UML
      media: ivtv: fix build for UML
      usb: musb: select GENERIC_PHY instead of depending on it
      usb: typec: STUSB160X should select REGMAP_I2C
      m68k: set a default value for MEMORY_RESERVE

Ranjani Sridharan (1):
      ASoC: SOF: topology: do not power down primary core during topology removal

Reiji Watanabe (1):
      arm64: arm64_ftr_reg->name may not be a human-readable string

Reimar Döffinger (1):
      libata: fix checking of DMA state

Ricardo Ribalda (7):
      media: v4l2-ioctl: Fix check_ext_ctrls
      media: uvcvideo: Set capability in s_param
      media: uvcvideo: Return -EIO for control errors
      media: uvcvideo: Set unique vdev name based in type
      media: ipu3-imgu: imgu_fmt: Handle properly try
      media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info
      media: v4l2-ioctl: S_CTRL output the right value

Richard Fitzgerald (4):
      ASoC: cs42l42: Always configure both ASP TX channels
      ASoC: cs42l42: Correct some register default values
      ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER
      ASoC: cs42l42: Correct configuring of switch inversion from ts-inv

Robert Foss (1):
      drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()

Robert-Ionut Alexa (1):
      soc: fsl: dpaa2-console: free buffer before returning from dpaa2_console_read

Russ Weight (1):
      spi: altera: Change to dynamic allocation of spi id

Russell Currey (1):
      powerpc/security: Use a mutex for interrupt exit code patching

Russell King (Oracle) (2):
      net: phylink: don't call netif_carrier_off() with NULL netdev
      net: phylink: avoid mvneta warning when setting pause parameters

Ryder Lee (3):
      mt76: mt7915: fix an off-by-one bound check
      mt76: mt7615: fix hwmon temp sensor mem use-after-free
      mt76: mt7615: fix monitor mode tear down crash

Sakari Ailus (1):
      media: imx258: Fix getting clock frequency

Sandeep Maheswaram (1):
      phy: qcom-snps: Correct the FSEL_MASK

Sander Vanheule (1):
      gpio: realtek-otto: fix GPIO line IRQ offset

Scott Wood (1):
      rcutorture: Avoid problematic critical section nesting on PREEMPT_RT

Sean Christopherson (5):
      x86/irq: Ensure PI wakeup handler is unregistered before module unload
      KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup
      KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows
      KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use
      KVM: nVMX: Handle dynamic MSR intercept toggling

Sean Wang (5):
      mt76: fix build error implicit enumeration conversion
      mt76: mt7921: report HE MU radiotap
      mt76: mt7921: fix firmware usage of RA info using legacy rates
      mt76: mt7921: fix kernel warning from cfg80211_calculate_bitrate
      mt76: mt7921: fix retrying release semaphore without end

Sean Young (3):
      media: ite-cir: IR receiver stop working after receive overflow
      media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers
      media: ir_toy: assignment to be16 should be of correct type

Sebastian Andrzej Siewior (1):
      lockdep: Let lock_is_held_type() detect recursive read as read

Sebastian Krzyszkowiak (2):
      power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
      power: supply: max17042_battery: Clear status bits in interrupt handler

Seevalamuthu Mariappan (1):
      ath11k: Align bss_chan_info structure with firmware

Selvin Xavier (2):
      RDMA/bnxt_re: Fix query SRQ failure
      PCI: Do not enable AtomicOps on VFs

Sergey Senozhatsky (2):
      media: videobuf2: rework vb2_mem_ops API
      media: videobuf2: always set buffer vb2 pointer

Shaoying Xu (1):
      ext4: fix lazy initialization next schedule time computation in more granular unit

Shayne Chen (4):
      mt76: mt7915: fix potential overflow of eeprom page index
      mt76: mt7915: fix bit fields for HT rate idx
      mt76: mt7915: fix sta_rec_wtbl tag len
      mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()

Shreyansh Chouhan (1):
      crypto: aesni - check walk.nbytes instead of err

Shuah Khan (2):
      selftests: kvm: fix mismatched fclose() after popen()
      selftests/core: fix conflicting types compile error for close_range()

Shyam Prasad N (1):
      cifs: To match file servers, make sure the server hostname matches

Shyam Sundar S K (1):
      net: amd-xgbe: Toggle PLL settings during rate change

Sidong Yang (1):
      btrfs: reflink: initialize return value to 0 in btrfs_extent_same()

Simon Ser (1):
      drm/panel-orientation-quirks: add Valve Steam Deck

Srinivas Kandagatla (3):
      soundwire: debugfs: use controller id and link_id for debugfs
      soundwire: bus: stop dereferencing invalid slave pointer
      scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer

Sriram R (2):
      ath11k: Avoid reg rules update during firmware recovery
      ath11k: Avoid race during regd updates

Stafford Horne (1):
      openrisc: fix SMP tlb flush NULL pointer dereference

Stefan Agner (2):
      phy: micrel: ksz8041nl: do not use power down mode
      serial: imx: fix detach/attach of serial console

Stefan Binding (1):
      ASoC: cs42l42: Ensure 0dB full scale volume is used for headsets

Stefan Schaeckeler (1):
      ACPI: AC: Quirk GK45 to skip reading _PSR

Stephan Gerhold (2):
      arm64: dts: qcom: msm8916: Fix Secondary MI2S bit clock
      arm64: dts: qcom: pm8916: Remove wrong reg-names for rtc@6000

Stephane Eranian (1):
      perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings

Stephen Boyd (1):
      ath10k: Don't always treat modem stop events as crashes

Stephen Suryaputra (1):
      gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Steve French (1):
      smb3: do not error on fsync when readonly

Steven Rostedt (VMware) (3):
      ring-buffer: Protect ring_buffer_reset() from reentrancy
      tracefs: Have tracefs directories not set OTH permission bits by default
      tracing: Disable "other" permission bits in the tracefs files

Sudarshan Rajagopalan (1):
      arm64: mm: update max_pfn after memory hotplug

Sukadev Bhattiprolu (3):
      ibmvnic: don't stop queue in xmit
      ibmvnic: Process crqs after enabling interrupts
      ibmvnic: delay complete()

Sumit Saxena (1):
      scsi: megaraid_sas: Fix concurrent access to ISR between IRQ polling and real interrupt

Sungjong Seo (1):
      exfat: fix incorrect loading of i_blocks for large files

Suzuki K Poulose (2):
      coresight: trbe: Fix incorrect access of the sink specific data
      coresight: trbe: Defer the probe on offline CPUs

Sven Eckelmann (1):
      ath10k: fix max antenna gain unit

Sven Schnelle (4):
      parisc: fix warning in flush_tlb_all
      parisc/unwind: fix unwinder when CONFIG_64BIT is enabled
      parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
      s390/tape: fix timer initialization in tape_std_assign()

Sylwester Dziedziuch (1):
      ice: Fix replacing VF hardware MAC to existing MAC filter

THOBY Simon (2):
      IMA: block writes of the security.ima xattr with unsupported algorithms
      IMA: reject unknown hash algorithms in ima_get_hash_algo

Tadeusz Struk (1):
      scsi: core: Remove command size deduction from scsi_setup_scsi_cmnd()

Takashi Iwai (11):
      Input: i8042 - Add quirk for Fujitsu Lifebook T725
      ALSA: hda/realtek: Add a quirk for HP OMEN 15 mute LED
      ALSA: hda/realtek: Add quirk for ASUS UX550VE
      ALSA: mixer: oss: Fix racy access to slots
      ALSA: hda: Free card instance properly at probe errors
      ALSA: PCM: Fix NULL dereference at mmap checks
      ALSA: timer: Unconditionally unlink slave instances, too
      Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
      ALSA: hda: Reduce udelay() at SKL+ position reporting
      ALSA: hda: Use position buffer for SKL+ again
      ALSA: memalloc: Catch call with NULL snd_dma_buffer pointer

Takashi Sakamoto (1):
      ALSA: oxfw: fix functional regression for Mackie Onyx 1640i in v5.14 or later

Tang Bin (1):
      crypto: s5p-sss - Add error handling in s5p_aes_probe()

Tao Zhang (1):
      coresight: cti: Correct the parameter for pm_runtime_put

Tetsuo Handa (3):
      smackfs: use __GFP_NOFAIL for smk_cipso_doi()
      smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi
      ataflop: remove ataflop_probe_lock mutex

Thomas Perrot (1):
      spi: spl022: fix Microwire full duplex mode

Thomas Richter (1):
      s390/cpumf: cpum_cf PMU displays invalid value after hotplug remove

Tiezhu Yang (1):
      samples/kretprobes: Fix return value if register_kretprobe() failed

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PC70HS

Tim Gardner (2):
      drm/msm: prevent NULL dereference in msm_gpu_crashstate_capture()
      net: enetc: unmap DMA in enetc_send_cmd()

Toke Høiland-Jørgensen (1):
      libbpf: Don't crash on object files with no symbol tables

Tom Lendacky (3):
      x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c
      arch/cc: Introduce a function to check for confidential computing features
      x86/sev: Add an x86 version of cc_platform_has()

Tom Rix (2):
      media: TDA1997x: handle short reads of hdmi info frame.
      apparmor: fix error check

Tong Zhang (1):
      scsi: dc395: Fix error case unwinding

Tony Lindgren (3):
      mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured
      mmc: sdhci-omap: Fix context restore
      bus: ti-sysc: Fix timekeeping_suspended warning on resume

Tony Lu (1):
      net/smc: Fix smc_link->llc_testlink_time overflow

Trond Myklebust (9):
      NFS: Default change_attr_type to NFS4_CHANGE_TYPE_IS_UNDEFINED
      NFS: Don't set NFS_INO_DATA_INVAL_DEFER and NFS_INO_INVALID_DATA
      NFS: Ignore the directory size when marking for revalidation
      NFS: Fix dentry verifier races
      NFS: Fix deadlocks in nfs_scan_commit_list()
      NFS: Fix up commit deadlocks
      NFS: Fix an Oops in pnfs_mark_request_commit()
      NFSv4: Fix a regression in nfs_set_open_stateid_locked()
      SUNRPC: Partial revert of commit 6f9f17287e78

Tuo Li (2):
      media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
      ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Vasant Hegde (1):
      powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module unload

Vasily Averin (2):
      memcg: prohibit unconditional exceeding the limit of dying tasks
      mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Vegard Nossum (1):
      staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC

Viktor Rosendahl (1):
      tools/latency-collector: Use correct size when writing queue_full_warning

Vincent Donnefort (2):
      cpufreq: Make policy min/max hard requirements
      PM: EM: Fix inefficient states detection

Vincent Mailhol (1):
      can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path

Vineeth Vijayan (1):
      s390/cio: check the subchannel validity for dev_busid

Vitaly Kuznetsov (1):
      x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted

Vladimir Oltean (4):
      net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
      net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
      net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge
      net: stmmac: allow a tc-taprio base-time of zero

Vladimir Zapolskiy (2):
      arm64: dts: qcom: sdm845: Fix Qualcomm crypto engine bus clock
      phy: qcom-qusb2: Fix a memory leak on probe

Waiman Long (1):
      cgroup: Make rebind_subsystems() disable v2 controllers all at once

Walter Stoll (1):
      watchdog: Fix OMAP watchdog early handling

Wan Jiabing (3):
      net: sparx5: Add of_node_put() before goto
      net: mscc: ocelot: Add of_node_put() before goto
      soc: qcom: apr: Add of_node_put() before return

Wang Hai (3):
      USB: serial: keyspan: fix memleak on probe errors
      libertas_tf: Fix possible memory leak in probe and disconnect
      libertas: Fix possible memory leak in probe and disconnect

Wang ShaoBo (1):
      Bluetooth: fix use-after-free error in lock_sock_nested()

Wang Wensheng (1):
      ALSA: timer: Fix use-after-free problem

Wen Gong (1):
      ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED

Wen Gu (1):
      net/smc: Correct spelling mistake to TCPF_SYN_RECV

Willem de Bruijn (1):
      selftests/net: udpgso_bench_rx: fix port argument

Wojciech Drewek (1):
      ice: Move devlink port to PF/VF struct

Wolfram Sang (1):
      memory: renesas-rpc-if: Correct QSPI data transfer in Manual mode

Xiao Ni (1):
      md: update superblock after changing rdev flags in state_store

Xiaoming Ni (2):
      powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found
      powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n

Xin Long (4):
      sctp: allow IP fragmentation when PLPMTUD enters Error state
      sctp: reset probe_timer in sctp_transport_pl_update
      sctp: subtract sctphdr len in sctp_transport_pl_hlen
      sctp: return true only for pathmtu update in sctp_transport_pl_toobig

Xin Xiong (1):
      mmc: moxart: Fix reference count leaks in moxart_probe

Xuan Zhuo (1):
      virtio_ring: check desc == NULL when using indirect with packed

Yaara Baruch (1):
      iwlwifi: change all JnP to NO-160 configuration

Yajun Deng (1):
      net: net_namespace: Fix undefined member in key_remove_domain()

Yanfei Xu (1):
      locking/rwsem: Disable preemption for spinning region

Yang Yingliang (14):
      ASoC: soc-core: fix null-ptr-deref in snd_soc_del_component_unlocked()
      iio: core: fix double free in iio_device_unregister_sysfs()
      iio: core: check return value when calling dev_set_name()
      pinctrl: core: fix possible memory leak in pinctrl_enable()
      iio: buffer: check return value of kstrdup_const()
      iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()
      iio: buffer: Fix memory leak in __iio_buffer_alloc_sysfs_and_mask()
      iio: buffer: Fix memory leak in iio_buffer_register_legacy_sysfs_groups()
      spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
      hwmon: Fix possible memleak in __hwmon_device_register()
      driver core: Fix possible memory leak in device_link_add()
      power: supply: max17040: fix null-ptr-deref in max17040_probe()
      iio: buffer: Fix double-free in iio_buffers_alloc_sysfs_and_mask()
      phy: Sparx5 Eth SerDes: Fix return value check in sparx5_serdes_probe()

Yassine Oudjana (1):
      ASoC: wcd9335: Use correct version to initialize Class H

Yazen Ghannam (1):
      EDAC/amd64: Handle three rank interleaving mode

Ye Bin (2):
      PM: hibernate: Get block device exclusively in swsusp_check()
      nbd: Fix use-after-free in pid_show

Yee Lee (1):
      scs: Release kasan vmalloc poison in scs_free process

Yifan Zhang (1):
      drm/amdkfd: fix resume error when iommu disabled in Picasso

Yixing Liu (1):
      RDMA/hns: Modify the value of MAX_LP_MSG_LEN to meet hardware compatibility

Yoshitaka Ikeda (1):
      spi: Fixed division by zero warning

Yu Kuai (3):
      blk-cgroup: synchronize blkg creation against policy deactivation
      nbd: fix max value for 'first_minor'
      nbd: fix possible overflow for 'first_minor' in nbd_dev_add()

Yu Xiao (1):
      nfp: bpf: relax prog rejection for mtu check through max_pkt_offset

Yuanzheng Song (1):
      thermal/core: Fix null pointer dereference in thermal_release()

YueHaibing (2):
      opp: Fix return in _opp_add_static_v2()
      xen-pciback: Fix return in pm_ctrl_init()

Yufeng Mo (2):
      net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode
      net: hns3: fix kernel crash when unload VF while it is being reset

Zev Weiss (3):
      hwmon: (pmbus/lm25066) Add offset coefficients
      hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff
      mtd: core: don't remove debugfs directory if device is in use

Zhang Changzhong (2):
      can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
      can: j1939: j1939_can_recv(): ignore messages with invalid source address

Zhang Qiao (1):
      kernel/sched: Fix sched_fork() access an invalid sched_task_group

Zhang Rui (1):
      cpufreq: intel_pstate: Fix cpu->pstate.turbo_freq initialization

Zhang Yi (2):
      quota: check block number when reading the block in quota file
      quota: correct error number in free_dqentry()

Zheyu Ma (7):
      cavium: Return negative value when pci_alloc_irq_vectors() fails
      scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
      mISDN: Fix return values of the probe function
      cavium: Fix return values of the probe function
      media: netup_unidvb: handle interrupt properly according to the firmware
      memstick: r592: Fix a UAF bug when removing the driver
      mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ziyang Xuan (4):
      char: xillybus: fix msg_ep UAF in xillyusb_probe()
      thermal/core: fix a UAF bug in __thermal_cooling_device_register()
      rsi: stop thread firstly in rsi_91x_init() error handling
      net: vlan: fix a UAF in vlan_dev_real_dev()

Zong-Zhe Yang (1):
      rtw88: fix RX clock gate setting while fifo dump

jason-jh.lin (1):
      mailbox: Remove WARN_ON for async_cb.cb in cmdq_exec_done

jing yangyang (1):
      firmware/psci: fix application of sizeof to pointer

liuyuntao (1):
      virtio-gpu: fix possible memory allocation failure

yangerkun (3):
      ext4: ensure enough credits in ext4_ext_shift_path_extents
      ext4: refresh the ext4_ext_path struct after dropping i_data_sem.
      ovl: fix use after free in struct ovl_aio_req

王贇 (1):
      ftrace: do CPU checking after preemption disabled

