Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A044F965C
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiDHNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 09:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiDHNGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 09:06:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6B73441A2;
        Fri,  8 Apr 2022 06:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8328CB82AD2;
        Fri,  8 Apr 2022 13:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDD2C385A3;
        Fri,  8 Apr 2022 13:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649423066;
        bh=I6FKEg1F2WdCerintIwYbgK9XbahqeCnD3xLWtQkzIs=;
        h=From:To:Cc:Subject:Date:From;
        b=P50QNHzLZ0gGNOnhUYcJ1K7vhMTXgatxu4HYy2xGRC06bACfWK/JRjyfv7/cdIWeH
         T8THwP2bJhFkGu0z12Uy8gFytQlTXtIBlOb8QMj1AUAwOFc5DcxbNdnp2cLtxiupKk
         7GNWBFTUfHrg9vM9ddKDcTjc4DpipvhbFrvks8ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.19
Date:   Fri,  8 Apr 2022 15:04:05 +0200
Message-Id: <16494230466218@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.19 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-fs-f2fs                                       |    1 
 Documentation/admin-guide/kernel-parameters.txt                               |    3 
 Documentation/admin-guide/sysctl/kernel.rst                                   |    1 
 Documentation/devicetree/bindings/media/i2c/hynix,hi846.yaml                  |    6 
 Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml |   28 
 Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml   |   16 
 Documentation/devicetree/bindings/mtd/nand-controller.yaml                    |    4 
 Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml         |    2 
 Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml               |    2 
 Documentation/devicetree/bindings/spi/spi-mxic.txt                            |    4 
 Documentation/devicetree/bindings/usb/usb-hcd.yaml                            |    2 
 Documentation/process/stable-kernel-rules.rst                                 |   11 
 Documentation/security/SCTP.rst                                               |   26 
 Documentation/sound/hd-audio/models.rst                                       |    4 
 Documentation/sphinx/requirements.txt                                         |    2 
 MAINTAINERS                                                                   |    3 
 Makefile                                                                      |    2 
 arch/Kconfig                                                                  |    1 
 arch/arc/kernel/process.c                                                     |    2 
 arch/arm/boot/dts/bcm2711.dtsi                                                |   50 
 arch/arm/boot/dts/bcm2837.dtsi                                                |   49 
 arch/arm/boot/dts/dra7-l4.dtsi                                                |    5 
 arch/arm/boot/dts/dra7.dtsi                                                   |    8 
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi                                     |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                                     |    3 
 arch/arm/boot/dts/exynos5420-smdk5420.dts                                     |    3 
 arch/arm/boot/dts/imx53-m53menlo.dts                                          |   29 
 arch/arm/boot/dts/imx7-colibri.dtsi                                           |    4 
 arch/arm/boot/dts/imx7-mba7.dtsi                                              |    2 
 arch/arm/boot/dts/imx7d-nitrogen7.dts                                         |    2 
 arch/arm/boot/dts/imx7d-pico-hobbit.dts                                       |    4 
 arch/arm/boot/dts/imx7d-pico-pi.dts                                           |    4 
 arch/arm/boot/dts/imx7d-sdb.dts                                               |    4 
 arch/arm/boot/dts/imx7s-warp.dts                                              |    4 
 arch/arm/boot/dts/openbmc-flash-layout-64.dtsi                                |    2 
 arch/arm/boot/dts/openbmc-flash-layout.dtsi                                   |    2 
 arch/arm/boot/dts/qcom-ipq4019.dtsi                                           |    3 
 arch/arm/boot/dts/qcom-msm8960.dtsi                                           |    8 
 arch/arm/boot/dts/sama5d2.dtsi                                                |    2 
 arch/arm/boot/dts/sama7g5.dtsi                                                |    6 
 arch/arm/boot/dts/spear1340.dtsi                                              |    6 
 arch/arm/boot/dts/spear13xx.dtsi                                              |    6 
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi                                      |    2 
 arch/arm/boot/dts/sun8i-v3s.dtsi                                              |   22 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                                       |    6 
 arch/arm/configs/multi_v5_defconfig                                           |    2 
 arch/arm/crypto/Kconfig                                                       |    2 
 arch/arm/kernel/entry-ftrace.S                                                |   51 
 arch/arm/kernel/swp_emulate.c                                                 |    2 
 arch/arm/kernel/traps.c                                                       |    2 
 arch/arm/mach-iop32x/include/mach/entry-macro.S                               |    2 
 arch/arm/mach-iop32x/include/mach/irqs.h                                      |    2 
 arch/arm/mach-iop32x/irq.c                                                    |    6 
 arch/arm/mach-iop32x/irqs.h                                                   |   60 
 arch/arm/mach-mmp/sram.c                                                      |   22 
 arch/arm/mach-mstar/Kconfig                                                   |    1 
 arch/arm/mach-s3c/mach-jive.c                                                 |    6 
 arch/arm64/Kconfig                                                            |    1 
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi                             |    8 
 arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts                           |    8 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi                              |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi                                |    6 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi                                |    6 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                                         |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                                         |    3 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                          |    2 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                          |    8 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                          |    6 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                          |   16 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                          |    2 
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts                               |    4 
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi                                      |    5 
 arch/arm64/boot/dts/ti/k3-am64.dtsi                                           |    1 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                                      |    5 
 arch/arm64/boot/dts/ti/k3-am65.dtsi                                           |    1 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                                     |    5 
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                                          |    1 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                                     |    5 
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                                          |    1 
 arch/arm64/configs/defconfig                                                  |    2 
 arch/arm64/include/asm/module.lds.h                                           |    6 
 arch/arm64/include/asm/spectre.h                                              |    3 
 arch/arm64/kernel/proton-pack.c                                               |    9 
 arch/arm64/kernel/signal.c                                                    |   10 
 arch/arm64/mm/init.c                                                          |   36 
 arch/arm64/mm/mmu.c                                                           |   41 
 arch/arm64/net/bpf_jit_comp.c                                                 |   18 
 arch/csky/kernel/perf_callchain.c                                             |    2 
 arch/csky/kernel/signal.c                                                     |    2 
 arch/m68k/coldfire/device.c                                                   |    6 
 arch/microblaze/include/asm/uaccess.h                                         |   18 
 arch/mips/crypto/crc32-mips.c                                                 |   46 
 arch/mips/dec/int-handler.S                                                   |    6 
 arch/mips/dec/prom/Makefile                                                   |    2 
 arch/mips/dec/setup.c                                                         |    3 
 arch/mips/include/asm/dec/prom.h                                              |   15 
 arch/mips/include/asm/pgalloc.h                                               |    6 
 arch/mips/mm/tlbex.c                                                          |   23 
 arch/mips/rb532/devices.c                                                     |    6 
 arch/nios2/include/asm/uaccess.h                                              |   26 
 arch/nios2/kernel/signal.c                                                    |   20 
 arch/parisc/include/asm/traps.h                                               |    1 
 arch/parisc/kernel/cache.c                                                    |   28 
 arch/parisc/kernel/traps.c                                                    |    2 
 arch/parisc/mm/fault.c                                                        |   89 
 arch/powerpc/Makefile                                                         |    2 
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts                                  |   30 
 arch/powerpc/boot/dts/fsl/t1040rdb.dts                                        |    8 
 arch/powerpc/include/asm/io.h                                                 |   40 
 arch/powerpc/include/asm/set_memory.h                                         |   12 
 arch/powerpc/include/asm/uaccess.h                                            |    3 
 arch/powerpc/kvm/book3s_hv.c                                                  |    5 
 arch/powerpc/kvm/powerpc.c                                                    |    4 
 arch/powerpc/lib/sstep.c                                                      |   12 
 arch/powerpc/mm/fault.c                                                       |   14 
 arch/powerpc/mm/kasan/kasan_init_32.c                                         |    3 
 arch/powerpc/mm/numa.c                                                        |    4 
 arch/powerpc/mm/pageattr.c                                                    |   39 
 arch/powerpc/mm/pgtable_32.c                                                  |   24 
 arch/powerpc/perf/imc-pmu.c                                                   |    6 
 arch/powerpc/platforms/8xx/pic.c                                              |    1 
 arch/powerpc/platforms/powernv/rng.c                                          |    6 
 arch/powerpc/platforms/pseries/pci_dlpar.c                                    |    4 
 arch/powerpc/sysdev/fsl_gtm.c                                                 |    4 
 arch/riscv/boot/dts/canaan/sipeed_maix_bit.dts                                |    2 
 arch/riscv/boot/dts/canaan/sipeed_maix_dock.dts                               |    2 
 arch/riscv/boot/dts/canaan/sipeed_maix_go.dts                                 |    2 
 arch/riscv/boot/dts/canaan/sipeed_maixduino.dts                               |    2 
 arch/riscv/include/asm/module.lds.h                                           |    6 
 arch/riscv/include/asm/thread_info.h                                          |   10 
 arch/riscv/kernel/perf_callchain.c                                            |    6 
 arch/sparc/kernel/signal_32.c                                                 |    2 
 arch/um/drivers/mconsole_kern.c                                               |    3 
 arch/x86/events/intel/pt.c                                                    |    2 
 arch/x86/kernel/kvm.c                                                         |    2 
 arch/x86/kvm/emulate.c                                                        |   14 
 arch/x86/kvm/hyperv.c                                                         |   96 
 arch/x86/kvm/lapic.c                                                          |    9 
 arch/x86/kvm/mmu.h                                                            |    1 
 arch/x86/kvm/mmu/paging_tmpl.h                                                |   77 
 arch/x86/kvm/mmu/tdp_mmu.c                                                    |   61 
 arch/x86/kvm/mmu/tdp_mmu.h                                                    |    3 
 arch/x86/kvm/svm/avic.c                                                       |   10 
 arch/x86/kvm/svm/sev.c                                                        |   36 
 arch/x86/kvm/x86.c                                                            |    3 
 arch/x86/xen/pmu.c                                                            |   10 
 arch/x86/xen/pmu.h                                                            |    3 
 arch/x86/xen/smp_pv.c                                                         |    2 
 arch/xtensa/include/asm/pgtable.h                                             |    4 
 arch/xtensa/include/asm/processor.h                                           |    4 
 arch/xtensa/kernel/jump_label.c                                               |    2 
 arch/xtensa/kernel/mxhead.S                                                   |    2 
 arch/xtensa/mm/tlb.c                                                          |    6 
 block/bfq-cgroup.c                                                            |    6 
 block/bfq-iosched.c                                                           |   31 
 block/bfq-wf2q.c                                                              |    2 
 block/bio.c                                                                   |    3 
 block/blk-cgroup.c                                                            |   10 
 block/blk-iolatency.c                                                         |    2 
 block/blk-merge.c                                                             |   36 
 block/blk-mq-sched.c                                                          |    9 
 block/blk-mq.c                                                                |   60 
 block/blk-rq-qos.h                                                            |   20 
 block/blk-sysfs.c                                                             |    8 
 block/blk-throttle.c                                                          |   10 
 block/blk-throttle.h                                                          |    2 
 block/genhd.c                                                                 |    2 
 crypto/asymmetric_keys/pkcs7_verify.c                                         |    6 
 crypto/asymmetric_keys/public_key.c                                           |  126 
 crypto/asymmetric_keys/x509_public_key.c                                      |    6 
 crypto/authenc.c                                                              |    2 
 crypto/rsa-pkcs1pad.c                                                         |   11 
 crypto/xts.c                                                                  |    1 
 drivers/acpi/acpica/nswalk.c                                                  |    3 
 drivers/acpi/apei/bert.c                                                      |   10 
 drivers/acpi/apei/erst.c                                                      |    2 
 drivers/acpi/apei/hest.c                                                      |    2 
 drivers/acpi/bus.c                                                            |   27 
 drivers/acpi/cppc_acpi.c                                                      |    5 
 drivers/acpi/property.c                                                       |    2 
 drivers/base/dd.c                                                             |    2 
 drivers/base/memory.c                                                         |    8 
 drivers/base/power/domain.c                                                   |    2 
 drivers/base/power/main.c                                                     |    6 
 drivers/block/drbd/drbd_req.c                                                 |    3 
 drivers/block/loop.c                                                          |   11 
 drivers/block/n64cart.c                                                       |    2 
 drivers/bluetooth/btintel.c                                                   |   11 
 drivers/bluetooth/btintel.h                                                   |    1 
 drivers/bluetooth/btmtksdio.c                                                 |    4 
 drivers/bluetooth/btusb.c                                                     |    6 
 drivers/bluetooth/hci_h5.c                                                    |    8 
 drivers/bluetooth/hci_serdev.c                                                |    3 
 drivers/bus/mhi/core/debugfs.c                                                |   26 
 drivers/bus/mhi/core/init.c                                                   |   36 
 drivers/bus/mhi/core/internal.h                                               |  119 
 drivers/bus/mhi/core/main.c                                                   |   22 
 drivers/bus/mhi/core/pm.c                                                     |    4 
 drivers/bus/mhi/pci_generic.c                                                 |    1 
 drivers/bus/mips_cdmm.c                                                       |    1 
 drivers/char/hw_random/Kconfig                                                |    2 
 drivers/char/hw_random/atmel-rng.c                                            |    1 
 drivers/char/hw_random/cavium-rng-vf.c                                        |  194 
 drivers/char/hw_random/cavium-rng.c                                           |   11 
 drivers/char/hw_random/nomadik-rng.c                                          |    4 
 drivers/char/tpm/tpm-chip.c                                                   |   46 
 drivers/char/tpm/tpm.h                                                        |    2 
 drivers/char/tpm/tpm2-space.c                                                 |   65 
 drivers/char/virtio_console.c                                                 |    7 
 drivers/clk/actions/owl-s700.c                                                |    1 
 drivers/clk/actions/owl-s900.c                                                |    2 
 drivers/clk/at91/sama7g5.c                                                    |    8 
 drivers/clk/clk-clps711x.c                                                    |    2 
 drivers/clk/clk.c                                                             |   16 
 drivers/clk/hisilicon/clk-hi3559a.c                                           |    4 
 drivers/clk/imx/clk-imx7d.c                                                   |    1 
 drivers/clk/imx/clk-imx8qxp-lpcg.c                                            |    2 
 drivers/clk/loongson1/clk-loongson1c.c                                        |    1 
 drivers/clk/qcom/clk-rcg2.c                                                   |   14 
 drivers/clk/qcom/gcc-ipq8074.c                                                |   21 
 drivers/clk/qcom/gcc-msm8994.c                                                |    1 
 drivers/clk/renesas/r9a07g044-cpg.c                                           |    4 
 drivers/clk/rockchip/clk.c                                                    |    3 
 drivers/clk/tegra/clk-tegra124-emc.c                                          |    1 
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c                                |    1 
 drivers/clocksource/acpi_pm.c                                                 |    6 
 drivers/clocksource/exynos_mct.c                                              |   60 
 drivers/clocksource/timer-microchip-pit64b.c                                  |    2 
 drivers/clocksource/timer-of.c                                                |    6 
 drivers/clocksource/timer-ti-dm-systimer.c                                    |    4 
 drivers/cpufreq/qcom-cpufreq-nvmem.c                                          |    2 
 drivers/cpuidle/cpuidle-qcom-spm.c                                            |   20 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c                           |    3 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c                             |    3 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                           |    3 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c                             |    2 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c                             |    3 
 drivers/crypto/amlogic/amlogic-gxl-cipher.c                                   |    2 
 drivers/crypto/ccp/ccp-dmaengine.c                                            |   16 
 drivers/crypto/ccp/sev-dev.c                                                  |    2 
 drivers/crypto/ccree/cc_buffer_mgr.c                                          |    7 
 drivers/crypto/ccree/cc_cipher.c                                              |    2 
 drivers/crypto/gemini/sl3516-ce-cipher.c                                      |    2 
 drivers/crypto/hisilicon/qm.c                                                 |    2 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                                    |   16 
 drivers/crypto/hisilicon/sec2/sec_main.c                                      |    8 
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c                            |   17 
 drivers/crypto/mxs-dcp.c                                                      |    2 
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c                              |    1 
 drivers/crypto/vmx/Kconfig                                                    |    4 
 drivers/cxl/core/bus.c                                                        |    4 
 drivers/cxl/core/regs.c                                                       |    6 
 drivers/dax/super.c                                                           |    1 
 drivers/dma-buf/udmabuf.c                                                     |    4 
 drivers/dma/hisi_dma.c                                                        |    2 
 drivers/dma/idxd/device.c                                                     |   34 
 drivers/dma/idxd/idxd.h                                                       |   12 
 drivers/dma/idxd/init.c                                                       |    6 
 drivers/dma/idxd/registers.h                                                  |   14 
 drivers/dma/idxd/sysfs.c                                                      |   42 
 drivers/firmware/efi/efi-pstore.c                                             |    2 
 drivers/firmware/google/Kconfig                                               |    2 
 drivers/firmware/qcom_scm.c                                                   |    6 
 drivers/firmware/stratix10-svc.c                                              |    2 
 drivers/firmware/sysfb_simplefb.c                                             |   23 
 drivers/fsi/fsi-master-aspeed.c                                               |   17 
 drivers/fsi/fsi-scom.c                                                        |   45 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                                |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                                    |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                                       |   11 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                             |   10 
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c                  |   14 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                                            |    4 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                                     |    2 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                                      |    1 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                                  |   29 
 drivers/gpu/drm/bridge/analogix/anx7625.c                                     |    3 
 drivers/gpu/drm/bridge/cdns-dsi.c                                             |    1 
 drivers/gpu/drm/bridge/nwl-dsi.c                                              |    1 
 drivers/gpu/drm/bridge/sil-sii8620.c                                          |    2 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                                     |    5 
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c                                 |    1 
 drivers/gpu/drm/drm_edid.c                                                    |   18 
 drivers/gpu/drm/drm_fb_helper.c                                               |    9 
 drivers/gpu/drm/drm_syncobj.c                                                 |   61 
 drivers/gpu/drm/i915/display/intel_bw.c                                       |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                                       |    2 
 drivers/gpu/drm/i915/display/intel_hdmi.c                                     |   13 
 drivers/gpu/drm/i915/display/intel_opregion.c                                 |   15 
 drivers/gpu/drm/i915/display/intel_pps.c                                      |    6 
 drivers/gpu/drm/i915/display/intel_pps.h                                      |    2 
 drivers/gpu/drm/i915/display/intel_psr.c                                      |    4 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                                      |    2 
 drivers/gpu/drm/i915/intel_pm.c                                               |   10 
 drivers/gpu/drm/meson/Makefile                                                |    1 
 drivers/gpu/drm/meson/meson_drv.c                                             |   28 
 drivers/gpu/drm/meson/meson_dw_hdmi.c                                         |  341 -
 drivers/gpu/drm/meson/meson_encoder_hdmi.c                                    |  370 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.h                                    |   12 
 drivers/gpu/drm/meson/meson_osd_afbcd.c                                       |   41 
 drivers/gpu/drm/meson/meson_osd_afbcd.h                                       |    1 
 drivers/gpu/drm/mgag200/mgag200_mode.c                                        |    5 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                                         |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                                   |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c                                        |    8 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                                              |    3 
 drivers/gpu/drm/msm/dp/dp_display.c                                           |    5 
 drivers/gpu/drm/msm/dp/dp_panel.c                                             |    5 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c                                    |    4 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c                                    |    4 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c                                    |    4 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c                               |    4 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c                                     |   26 
 drivers/gpu/drm/nouveau/nouveau_backlight.c                                   |    6 
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c                                |    9 
 drivers/gpu/drm/panfrost/panfrost_gpu.c                                       |    5 
 drivers/gpu/drm/radeon/radeon_connectors.c                                    |    2 
 drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c                            |    4 
 drivers/gpu/drm/tegra/dsi.c                                                   |    4 
 drivers/gpu/drm/tiny/simpledrm.c                                              |    3 
 drivers/gpu/drm/v3d/v3d_drv.c                                                 |    8 
 drivers/gpu/host1x/dev.c                                                      |    1 
 drivers/greybus/svc.c                                                         |    8 
 drivers/hid/hid-logitech-dj.c                                                 |    1 
 drivers/hid/hid-thrustmaster.c                                                |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                                            |   32 
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c                                   |   29 
 drivers/hv/hv_balloon.c                                                       |    2 
 drivers/hwmon/pmbus/pmbus.h                                                   |    1 
 drivers/hwmon/pmbus/pmbus_core.c                                              |   18 
 drivers/hwmon/sch56xx-common.c                                                |    2 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c                           |    8 
 drivers/hwtracing/coresight/coresight-syscfg.c                                |    2 
 drivers/i2c/busses/i2c-bcm2835.c                                              |   26 
 drivers/i2c/busses/i2c-meson.c                                                |   12 
 drivers/i2c/busses/i2c-pasemi-core.c                                          |    1 
 drivers/i2c/busses/i2c-pasemi-pci.c                                           |    1 
 drivers/i2c/busses/i2c-xiic.c                                                 |    3 
 drivers/i2c/muxes/i2c-demux-pinctrl.c                                         |    5 
 drivers/iio/accel/mma8452.c                                                   |   29 
 drivers/iio/adc/aspeed_adc.c                                                  |    4 
 drivers/iio/adc/twl6030-gpadc.c                                               |    2 
 drivers/iio/afe/iio-rescale.c                                                 |    8 
 drivers/iio/inkern.c                                                          |   40 
 drivers/infiniband/core/cma.c                                                 |    2 
 drivers/infiniband/core/nldev.c                                               |    3 
 drivers/infiniband/core/verbs.c                                               |    1 
 drivers/infiniband/hw/hfi1/verbs.c                                            |    3 
 drivers/infiniband/hw/irdma/ctrl.c                                            |   10 
 drivers/infiniband/hw/irdma/hw.c                                              |    2 
 drivers/infiniband/hw/irdma/i40iw_if.c                                        |    1 
 drivers/infiniband/hw/irdma/main.c                                            |    1 
 drivers/infiniband/hw/irdma/main.h                                            |    1 
 drivers/infiniband/hw/irdma/utils.c                                           |   48 
 drivers/infiniband/hw/irdma/verbs.c                                           |    4 
 drivers/infiniband/hw/mlx5/devx.c                                             |    4 
 drivers/infiniband/hw/mlx5/mr.c                                               |    2 
 drivers/infiniband/sw/rxe/rxe_av.c                                            |   19 
 drivers/infiniband/sw/rxe/rxe_loc.h                                           |    5 
 drivers/infiniband/sw/rxe/rxe_net.c                                           |   17 
 drivers/infiniband/sw/rxe/rxe_req.c                                           |   63 
 drivers/infiniband/sw/rxe/rxe_resp.c                                          |   12 
 drivers/input/input.c                                                         |    6 
 drivers/input/touchscreen/zinitix.c                                           |   44 
 drivers/iommu/iova.c                                                          |    5 
 drivers/iommu/ipmmu-vmsa.c                                                    |    4 
 drivers/iommu/mtk_iommu.c                                                     |   32 
 drivers/iommu/mtk_iommu_v1.c                                                  |   40 
 drivers/irqchip/irq-nvic.c                                                    |    2 
 drivers/irqchip/qcom-pdc.c                                                    |    5 
 drivers/mailbox/imx-mailbox.c                                                 |   11 
 drivers/mailbox/tegra-hsp.c                                                   |    5 
 drivers/md/bcache/btree.c                                                     |    6 
 drivers/md/bcache/writeback.c                                                 |    6 
 drivers/md/dm-core.h                                                          |    2 
 drivers/md/dm-crypt.c                                                         |    2 
 drivers/md/dm-integrity.c                                                     |    6 
 drivers/md/dm-stats.c                                                         |   34 
 drivers/md/dm-stats.h                                                         |   11 
 drivers/md/dm.c                                                               |   86 
 drivers/media/i2c/adv7511-v4l2.c                                              |    2 
 drivers/media/i2c/adv7604.c                                                   |    2 
 drivers/media/i2c/adv7842.c                                                   |    2 
 drivers/media/i2c/ov5640.c                                                    |   14 
 drivers/media/i2c/ov5648.c                                                    |   12 
 drivers/media/i2c/ov6650.c                                                    |  115 
 drivers/media/pci/bt8xx/bttv-driver.c                                         |    4 
 drivers/media/pci/cx88/cx88-mpeg.c                                            |    3 
 drivers/media/pci/ivtv/ivtv-driver.h                                          |    1 
 drivers/media/pci/ivtv/ivtv-ioctl.c                                           |   10 
 drivers/media/pci/ivtv/ivtv-streams.c                                         |   11 
 drivers/media/pci/saa7134/saa7134-alsa.c                                      |    4 
 drivers/media/platform/aspeed-video.c                                         |    9 
 drivers/media/platform/atmel/atmel-isc-base.c                                 |   22 
 drivers/media/platform/atmel/atmel-sama7g5-isc.c                              |    6 
 drivers/media/platform/coda/coda-common.c                                     |    1 
 drivers/media/platform/davinci/vpif.c                                         |  109 
 drivers/media/platform/imx-jpeg/mxc-jpeg.c                                    |    7 
 drivers/media/platform/meson/ge2d/ge2d.c                                      |   24 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c                         |    2 
 drivers/media/platform/omap3isp/ispstat.c                                     |    5 
 drivers/media/platform/qcom/camss/camss-csid-170.c                            |   19 
 drivers/media/platform/qcom/camss/camss-vfe-170.c                             |   12 
 drivers/media/platform/qcom/venus/helpers.c                                   |    2 
 drivers/media/platform/qcom/venus/hfi_cmds.c                                  |    2 
 drivers/media/platform/qcom/venus/venc.c                                      |    4 
 drivers/media/platform/qcom/venus/venc_ctrls.c                                |    6 
 drivers/media/platform/ti-vpe/cal-video.c                                     |    3 
 drivers/media/rc/gpio-ir-tx.c                                                 |   28 
 drivers/media/rc/ir_toy.c                                                     |    2 
 drivers/media/test-drivers/vidtv/vidtv_s302m.c                                |   17 
 drivers/media/usb/em28xx/em28xx-cards.c                                       |   13 
 drivers/media/usb/go7007/s2250-board.c                                        |   10 
 drivers/media/usb/hdpvr/hdpvr-video.c                                         |    4 
 drivers/media/usb/stk1160/stk1160-core.c                                      |    2 
 drivers/media/usb/stk1160/stk1160-v4l.c                                       |   10 
 drivers/media/usb/stk1160/stk1160.h                                           |    2 
 drivers/media/v4l2-core/v4l2-ctrls-core.c                                     |   10 
 drivers/media/v4l2-core/v4l2-ioctl.c                                          |   12 
 drivers/media/v4l2-core/v4l2-mem2mem.c                                        |   53 
 drivers/memory/emif.c                                                         |    8 
 drivers/memory/tegra/tegra20-emc.c                                            |    2 
 drivers/memstick/core/mspro_block.c                                           |   10 
 drivers/mfd/asic3.c                                                           |   10 
 drivers/mfd/mc13xxx-core.c                                                    |    4 
 drivers/misc/cardreader/alcor_pci.c                                           |    9 
 drivers/misc/habanalabs/common/debugfs.c                                      |    2 
 drivers/misc/kgdbts.c                                                         |    4 
 drivers/misc/mei/hw-me-regs.h                                                 |    2 
 drivers/misc/mei/hw-me.c                                                      |   23 
 drivers/misc/mei/interrupt.c                                                  |   35 
 drivers/misc/mei/pci-me.c                                                     |    1 
 drivers/mmc/core/bus.c                                                        |    9 
 drivers/mmc/core/bus.h                                                        |    3 
 drivers/mmc/core/host.c                                                       |   15 
 drivers/mmc/core/mmc.c                                                        |   16 
 drivers/mmc/core/sd.c                                                         |   25 
 drivers/mmc/core/sdio.c                                                       |    5 
 drivers/mmc/core/sdio_bus.c                                                   |    7 
 drivers/mmc/host/davinci_mmc.c                                                |    6 
 drivers/mmc/host/rtsx_pci_sdmmc.c                                             |   20 
 drivers/mmc/host/sdhci_am654.c                                                |   24 
 drivers/mtd/devices/mchp23k256.c                                              |   14 
 drivers/mtd/devices/mchp48l640.c                                              |   10 
 drivers/mtd/nand/onenand/generic.c                                            |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c                                  |   14 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                                    |    3 
 drivers/mtd/nand/raw/nand_base.c                                              |   44 
 drivers/mtd/nand/raw/pl35x-nand-controller.c                                  |    2 
 drivers/mtd/ubi/build.c                                                       |    9 
 drivers/mtd/ubi/fastmap.c                                                     |   28 
 drivers/mtd/ubi/vmt.c                                                         |    8 
 drivers/net/bareudp.c                                                         |   19 
 drivers/net/can/m_can/m_can.c                                                 |    5 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                                |    2 
 drivers/net/can/usb/ems_usb.c                                                 |    1 
 drivers/net/can/usb/mcba_usb.c                                                |   27 
 drivers/net/can/usb/usb_8dev.c                                                |   30 
 drivers/net/can/vxcan.c                                                       |    2 
 drivers/net/dsa/Kconfig                                                       |   12 
 drivers/net/dsa/Makefile                                                      |    3 
 drivers/net/dsa/bcm_sf2_cfp.c                                                 |    6 
 drivers/net/dsa/microchip/ksz8795_spi.c                                       |   11 
 drivers/net/dsa/microchip/ksz9477_spi.c                                       |   12 
 drivers/net/dsa/mv88e6xxx/chip.c                                              |    1 
 drivers/net/dsa/realtek-smi-core.c                                            |  523 --
 drivers/net/dsa/realtek-smi-core.h                                            |  145 
 drivers/net/dsa/realtek/Kconfig                                               |   20 
 drivers/net/dsa/realtek/Makefile                                              |    3 
 drivers/net/dsa/realtek/realtek-smi-core.c                                    |  523 ++
 drivers/net/dsa/realtek/realtek-smi-core.h                                    |  145 
 drivers/net/dsa/realtek/rtl8365mb.c                                           | 1986 ++++++++++
 drivers/net/dsa/realtek/rtl8366.c                                             |  448 ++
 drivers/net/dsa/realtek/rtl8366rb.c                                           | 1815 +++++++++
 drivers/net/dsa/rtl8365mb.c                                                   | 1986 ----------
 drivers/net/dsa/rtl8366.c                                                     |  448 --
 drivers/net/dsa/rtl8366rb.c                                                   | 1813 ---------
 drivers/net/ethernet/8390/mcf8390.c                                           |   10 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c                                 |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h                                 |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                                |    4 
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c                          |    5 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c                              |  128 
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                                   |   18 
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c                            |   15 
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h                            |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                               |   47 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c                       |  234 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h                       |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c                     |   12 
 drivers/net/ethernet/ibm/ibmvnic.c                                            |   63 
 drivers/net/ethernet/ibm/ibmvnic.h                                            |    7 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                                    |   19 
 drivers/net/ethernet/intel/ice/ice.h                                          |    4 
 drivers/net/ethernet/intel/ice/ice_idc.c                                      |    3 
 drivers/net/ethernet/intel/ice/ice_main.c                                     |   25 
 drivers/net/ethernet/intel/ice/ice_xsk.c                                      |   16 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                                  |    4 
 drivers/net/ethernet/intel/igb/igb_main.c                                     |   19 
 drivers/net/ethernet/intel/igc/igc_main.c                                     |   16 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                                  |   27 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c                           |   15 
 drivers/net/ethernet/microchip/sparx5/Kconfig                                 |    2 
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c                           |    2 
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c                           |    4 
 drivers/net/ethernet/pensando/ionic/ionic_dev.c                               |   20 
 drivers/net/ethernet/pensando/ionic/ionic_dev.h                               |    1 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                              |   34 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                                   |   29 
 drivers/net/ethernet/qlogic/qed/qed_sriov.h                                   |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                               |   10 
 drivers/net/ethernet/sun/sunhme.c                                             |    6 
 drivers/net/ethernet/ti/cpsw_ethtool.c                                        |    6 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                             |   72 
 drivers/net/phy/at803x.c                                                      |   40 
 drivers/net/phy/broadcom.c                                                    |   21 
 drivers/net/phy/micrel.c                                                      |   32 
 drivers/net/usb/asix.h                                                        |    4 
 drivers/net/usb/asix_common.c                                                 |   19 
 drivers/net/usb/asix_devices.c                                                |   21 
 drivers/net/wireguard/queueing.c                                              |    3 
 drivers/net/wireguard/socket.c                                                |    5 
 drivers/net/wireless/ath/ath10k/snoc.c                                        |    2 
 drivers/net/wireless/ath/ath10k/wow.c                                         |    7 
 drivers/net/wireless/ath/ath11k/dp_rx.c                                       |   72 
 drivers/net/wireless/ath/ath11k/mac.c                                         |    3 
 drivers/net/wireless/ath/ath9k/htc_hst.c                                      |    5 
 drivers/net/wireless/ath/carl9170/main.c                                      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c                   |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c                       |   73 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c                       |    1 
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c                             |    2 
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                                   |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c                              |   13 
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h                                 |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                                   |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                                   |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                                  |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                                   |    5 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                               |    2 
 drivers/net/wireless/mediatek/mt76/mt7603/main.c                              |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                               |    8 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                              |    3 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c                          |    2 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h                          |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                               |    1 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                               |   67 
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c                           |   16 
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c                               |  119 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                               |   21 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h                               |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c                               |   49 
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h                            |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c                               |  124 
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c                           |   18 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h                              |   11 
 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c                          |   38 
 drivers/net/wireless/mediatek/mt76/sdio.h                                     |    2 
 drivers/net/wireless/ray_cs.c                                                 |    6 
 drivers/nvdimm/region_devs.c                                                  |    3 
 drivers/nvme/host/core.c                                                      |   48 
 drivers/nvme/host/multipath.c                                                 |    7 
 drivers/nvme/host/nvme.h                                                      |   19 
 drivers/nvme/host/tcp.c                                                       |   40 
 drivers/pci/access.c                                                          |    9 
 drivers/pci/controller/dwc/pci-imx6.c                                         |   10 
 drivers/pci/controller/dwc/pcie-fu740.c                                       |   51 
 drivers/pci/controller/pci-aardvark.c                                         |   13 
 drivers/pci/controller/pci-xgene.c                                            |   35 
 drivers/pci/hotplug/pciehp_hpc.c                                              |    2 
 drivers/pci/quirks.c                                                          |   12 
 drivers/phy/broadcom/phy-brcm-usb-init.c                                      |   36 
 drivers/phy/broadcom/phy-brcm-usb-init.h                                      |    1 
 drivers/phy/broadcom/phy-brcm-usb.c                                           |   11 
 drivers/phy/phy-core-mipi-dphy.c                                              |    4 
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c                                 |    2 
 drivers/pinctrl/mediatek/pinctrl-paris.c                                      |   32 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                                     |    4 
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c                                     |  185 
 drivers/pinctrl/pinconf-generic.c                                             |    6 
 drivers/pinctrl/pinctrl-ingenic.c                                             |   46 
 drivers/pinctrl/pinctrl-microchip-sgpio.c                                     |   15 
 drivers/pinctrl/pinctrl-rockchip.c                                            |    2 
 drivers/pinctrl/renesas/core.c                                                |    5 
 drivers/pinctrl/renesas/pfc-r8a77470.c                                        |    4 
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c                                |    2 
 drivers/pinctrl/samsung/pinctrl-samsung.c                                     |   30 
 drivers/platform/chrome/Makefile                                              |    3 
 drivers/platform/chrome/cros_ec_sensorhub_ring.c                              |    3 
 drivers/platform/chrome/cros_ec_sensorhub_trace.h                             |  123 
 drivers/platform/chrome/cros_ec_trace.h                                       |   95 
 drivers/platform/chrome/cros_ec_typec.c                                       |    6 
 drivers/platform/x86/huawei-wmi.c                                             |   13 
 drivers/power/reset/gemini-poweroff.c                                         |    4 
 drivers/power/supply/ab8500_chargalg.c                                        |    4 
 drivers/power/supply/ab8500_fg.c                                              |    4 
 drivers/power/supply/bq24190_charger.c                                        |    7 
 drivers/power/supply/sbs-charger.c                                            |   18 
 drivers/power/supply/wm8350_power.c                                           |   97 
 drivers/powercap/dtpm_cpu.c                                                   |    7 
 drivers/pps/clients/pps-gpio.c                                                |    2 
 drivers/ptp/ptp_clock.c                                                       |   11 
 drivers/pwm/pwm-lpc18xx-sct.c                                                 |   20 
 drivers/regulator/qcom_smd-regulator.c                                        |    4 
 drivers/regulator/rpi-panel-attiny-regulator.c                                |   56 
 drivers/remoteproc/qcom_q6v5_adsp.c                                           |    1 
 drivers/remoteproc/qcom_q6v5_mss.c                                            |   11 
 drivers/remoteproc/qcom_wcnss.c                                               |    1 
 drivers/remoteproc/remoteproc_debugfs.c                                       |    2 
 drivers/rtc/interface.c                                                       |    7 
 drivers/rtc/rtc-mc146818-lib.c                                                |    6 
 drivers/rtc/rtc-pl031.c                                                       |    6 
 drivers/scsi/fnic/fnic_scsi.c                                                 |   15 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                                        |    2 
 drivers/scsi/libsas/sas_ata.c                                                 |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                           |   25 
 drivers/scsi/pm8001/pm8001_hwi.c                                              |   23 
 drivers/scsi/pm8001/pm80xx_hwi.c                                              |  209 -
 drivers/scsi/qla2xxx/qla_attr.c                                               |    7 
 drivers/scsi/qla2xxx/qla_bsg.c                                                |    6 
 drivers/scsi/qla2xxx/qla_def.h                                                |   22 
 drivers/scsi/qla2xxx/qla_edif.c                                               |   25 
 drivers/scsi/qla2xxx/qla_gbl.h                                                |    4 
 drivers/scsi/qla2xxx/qla_gs.c                                                 |  160 
 drivers/scsi/qla2xxx/qla_init.c                                               |  233 -
 drivers/scsi/qla2xxx/qla_inline.h                                             |    2 
 drivers/scsi/qla2xxx/qla_iocb.c                                               |   93 
 drivers/scsi/qla2xxx/qla_isr.c                                                |    1 
 drivers/scsi/qla2xxx/qla_mbx.c                                                |   29 
 drivers/scsi/qla2xxx/qla_mid.c                                                |    9 
 drivers/scsi/qla2xxx/qla_mr.c                                                 |   11 
 drivers/scsi/qla2xxx/qla_nvme.c                                               |   22 
 drivers/scsi/qla2xxx/qla_os.c                                                 |   54 
 drivers/scsi/qla2xxx/qla_sup.c                                                |    4 
 drivers/scsi/qla2xxx/qla_target.c                                             |   14 
 drivers/scsi/qla2xxx/qla_tmpl.c                                               |    9 
 drivers/scsi/scsi_error.c                                                     |    9 
 drivers/scsi/scsi_transport_fc.c                                              |   39 
 drivers/scsi/sd.c                                                             |    6 
 drivers/scsi/ufs/ufshcd.c                                                     |   21 
 drivers/soc/mediatek/mtk-pm-domains.c                                         |    3 
 drivers/soc/qcom/ocmem.c                                                      |    1 
 drivers/soc/qcom/qcom_aoss.c                                                  |    8 
 drivers/soc/qcom/rpmpd.c                                                      |    3 
 drivers/soc/ti/wkup_m3_ipc.c                                                  |    4 
 drivers/soundwire/dmi-quirks.c                                                |    2 
 drivers/soundwire/intel.c                                                     |    4 
 drivers/spi/spi-fsi.c                                                         |   10 
 drivers/spi/spi-mt65xx.c                                                      |   15 
 drivers/spi/spi-mxic.c                                                        |   28 
 drivers/spi/spi-pxa2xx-pci.c                                                  |   17 
 drivers/spi/spi-tegra114.c                                                    |    4 
 drivers/spi/spi-tegra20-slink.c                                               |    8 
 drivers/spi/spi-tegra210-quad.c                                               |    2 
 drivers/spi/spi-zynqmp-gqspi.c                                                |    5 
 drivers/spi/spi.c                                                             |    4 
 drivers/staging/iio/adc/ad7280a.c                                             |    4 
 drivers/staging/media/atomisp/pci/atomisp_acc.c                               |   28 
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c                     |   18 
 drivers/staging/media/atomisp/pci/hmm/hmm.c                                   |    7 
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c                             |    2 
 drivers/staging/media/hantro/hantro_h1_regs.h                                 |    2 
 drivers/staging/media/imx/imx7-mipi-csis.c                                    |    6 
 drivers/staging/media/imx/imx8mq-mipi-csi2.c                                  |   74 
 drivers/staging/media/meson/vdec/esparser.c                                   |    7 
 drivers/staging/media/meson/vdec/vdec_helpers.c                               |    8 
 drivers/staging/media/meson/vdec/vdec_helpers.h                               |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c                              |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c                              |    2 
 drivers/staging/media/zoran/zoran.h                                           |    2 
 drivers/staging/media/zoran/zoran_card.c                                      |   86 
 drivers/staging/media/zoran/zoran_device.c                                    |    7 
 drivers/staging/media/zoran/zoran_driver.c                                    |   18 
 drivers/staging/mt7621-dts/gbpc1.dts                                          |   40 
 drivers/staging/mt7621-dts/gbpc2.dts                                          |  116 
 drivers/staging/mt7621-dts/mt7621.dtsi                                        |   26 
 drivers/staging/qlge/qlge_main.c                                              |   11 
 drivers/staging/r8188eu/core/rtw_recv.c                                       |    3 
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c                               |    4 
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c                       |    7 
 drivers/tty/hvc/hvc_iucv.c                                                    |    4 
 drivers/tty/mxser.c                                                           |   15 
 drivers/tty/serial/8250/8250_aspeed_vuart.c                                   |    2 
 drivers/tty/serial/8250/8250_dma.c                                            |   11 
 drivers/tty/serial/8250/8250_lpss.c                                           |   28 
 drivers/tty/serial/8250/8250_mid.c                                            |   19 
 drivers/tty/serial/8250/8250_port.c                                           |   24 
 drivers/tty/serial/kgdboc.c                                                   |    6 
 drivers/tty/serial/serial_core.c                                              |   14 
 drivers/usb/host/xhci-hub.c                                                   |    5 
 drivers/usb/host/xhci-mem.c                                                   |    2 
 drivers/usb/host/xhci.c                                                       |   20 
 drivers/usb/host/xhci.h                                                       |   14 
 drivers/usb/serial/Kconfig                                                    |    1 
 drivers/usb/serial/pl2303.c                                                   |    2 
 drivers/usb/serial/pl2303.h                                                   |    3 
 drivers/usb/serial/usb-serial-simple.c                                        |    7 
 drivers/usb/storage/ene_ub6250.c                                              |  155 
 drivers/usb/storage/realtek_cr.c                                              |    2 
 drivers/usb/typec/tipd/core.c                                                 |    5 
 drivers/usb/typec/tipd/tps6598x.h                                             |    1 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                             |   25 
 drivers/vfio/pci/vfio_pci_core.c                                              |   61 
 drivers/vhost/iotlb.c                                                         |    6 
 drivers/video/fbdev/atafb.c                                                   |   12 
 drivers/video/fbdev/atmel_lcdfb.c                                             |   11 
 drivers/video/fbdev/cirrusfb.c                                                |   16 
 drivers/video/fbdev/controlfb.c                                               |    2 
 drivers/video/fbdev/core/fbcvt.c                                              |   53 
 drivers/video/fbdev/core/fbmem.c                                              |   29 
 drivers/video/fbdev/matrox/matroxfb_base.c                                    |    2 
 drivers/video/fbdev/nvidia/nv_i2c.c                                           |    2 
 drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c                     |    1 
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c                      |    8 
 drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c              |    2 
 drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c              |    4 
 drivers/video/fbdev/sm712fb.c                                                 |   46 
 drivers/video/fbdev/smscufx.c                                                 |    3 
 drivers/video/fbdev/udlfb.c                                                   |    8 
 drivers/video/fbdev/w100fb.c                                                  |   15 
 drivers/virt/acrn/hsm.c                                                       |   20 
 drivers/virt/acrn/mm.c                                                        |   24 
 drivers/virtio/virtio.c                                                       |    5 
 drivers/virtio/virtio_pci_common.c                                            |   48 
 drivers/virtio/virtio_pci_common.h                                            |    7 
 drivers/virtio/virtio_pci_legacy.c                                            |    5 
 drivers/virtio/virtio_pci_modern.c                                            |    6 
 drivers/watchdog/rti_wdt.c                                                    |    1 
 fs/binfmt_elf.c                                                               |   90 
 fs/binfmt_elf_fdpic.c                                                         |   18 
 fs/btrfs/block-group.c                                                        |    8 
 fs/btrfs/compression.c                                                        |   20 
 fs/btrfs/disk-io.c                                                            |   26 
 fs/btrfs/extent_io.c                                                          |   22 
 fs/btrfs/file-item.c                                                          |   38 
 fs/btrfs/inode.c                                                              |    8 
 fs/btrfs/reflink.c                                                            |    7 
 fs/btrfs/space-info.c                                                         |    3 
 fs/btrfs/volumes.c                                                            |   48 
 fs/buffer.c                                                                   |    8 
 fs/cifs/cifsfs.c                                                              |   14 
 fs/cifs/connect.c                                                             |   14 
 fs/cifs/file.c                                                                |   10 
 fs/cifs/smb2ops.c                                                             |  130 
 fs/coredump.c                                                                 |   86 
 fs/exec.c                                                                     |   26 
 fs/ext2/super.c                                                               |    6 
 fs/ext4/inline.c                                                              |    9 
 fs/ext4/inode.c                                                               |   25 
 fs/ext4/mballoc.c                                                             |  128 
 fs/ext4/namei.c                                                               |   10 
 fs/f2fs/checkpoint.c                                                          |    8 
 fs/f2fs/compress.c                                                            |    5 
 fs/f2fs/data.c                                                                |    8 
 fs/f2fs/debug.c                                                               |   18 
 fs/f2fs/f2fs.h                                                                |    1 
 fs/f2fs/file.c                                                                |    5 
 fs/f2fs/gc.c                                                                  |    4 
 fs/f2fs/inode.c                                                               |    7 
 fs/f2fs/node.c                                                                |    6 
 fs/f2fs/segment.c                                                             |    7 
 fs/f2fs/super.c                                                               |   10 
 fs/f2fs/sysfs.c                                                               |    2 
 fs/file.c                                                                     |   31 
 fs/gfs2/bmap.c                                                                |    2 
 fs/gfs2/file.c                                                                |    3 
 fs/gfs2/inode.c                                                               |    2 
 fs/gfs2/rgrp.c                                                                |   10 
 fs/gfs2/rgrp.h                                                                |    2 
 fs/gfs2/super.c                                                               |    2 
 fs/io_uring.c                                                                 |   18 
 fs/jffs2/build.c                                                              |    4 
 fs/jffs2/fs.c                                                                 |    2 
 fs/jffs2/scan.c                                                               |    6 
 fs/jfs/jfs_dmap.c                                                             |    7 
 fs/nfs/callback_proc.c                                                        |   27 
 fs/nfs/callback_xdr.c                                                         |    4 
 fs/nfs/nfs2xdr.c                                                              |    2 
 fs/nfs/nfs3xdr.c                                                              |   22 
 fs/nfs/nfs4proc.c                                                             |    1 
 fs/nfs/pagelist.c                                                             |    1 
 fs/nfs/pnfs.c                                                                 |   11 
 fs/nfs/pnfs.h                                                                 |    2 
 fs/nfs/proc.c                                                                 |    1 
 fs/nfs/write.c                                                                |    7 
 fs/nfsd/filecache.c                                                           |    6 
 fs/nfsd/nfs4state.c                                                           |   12 
 fs/nfsd/nfsproc.c                                                             |    2 
 fs/nfsd/xdr.h                                                                 |    2 
 fs/ntfs/inode.c                                                               |    4 
 fs/ocfs2/quota_global.c                                                       |   23 
 fs/ocfs2/quota_local.c                                                        |    2 
 fs/proc/bootconfig.c                                                          |    2 
 fs/pstore/platform.c                                                          |   38 
 fs/ubifs/dir.c                                                                |  238 -
 fs/ubifs/file.c                                                               |   14 
 fs/ubifs/io.c                                                                 |   34 
 fs/ubifs/ioctl.c                                                              |    2 
 fs/ubifs/journal.c                                                            |   52 
 include/drm/drm_connector.h                                                   |   12 
 include/drm/drm_dp_helper.h                                                   |    2 
 include/drm/drm_modeset_lock.h                                                |    1 
 include/linux/atomic/atomic-arch-fallback.h                                   |   38 
 include/linux/binfmts.h                                                       |    3 
 include/linux/blk-cgroup.h                                                    |   17 
 include/linux/blk_types.h                                                     |    3 
 include/linux/coredump.h                                                      |    5 
 include/linux/fb.h                                                            |    1 
 include/linux/lsm_hook_defs.h                                                 |    2 
 include/linux/lsm_hooks.h                                                     |    5 
 include/linux/mm.h                                                            |   14 
 include/linux/mtd/rawnand.h                                                   |    2 
 include/linux/netfilter_netdev.h                                              |    2 
 include/linux/nvme.h                                                          |    1 
 include/linux/pci.h                                                           |    1 
 include/linux/pstore.h                                                        |    6 
 include/linux/randomize_kstack.h                                              |   16 
 include/linux/sched.h                                                         |    8 
 include/linux/security.h                                                      |    8 
 include/linux/serial_core.h                                                   |    2 
 include/linux/skbuff.h                                                        |   28 
 include/linux/skmsg.h                                                         |   13 
 include/linux/soc/ti/ti_sci_protocol.h                                        |    2 
 include/linux/sunrpc/xdr.h                                                    |    2 
 include/linux/sunrpc/xprt.h                                                   |    3 
 include/linux/sunrpc/xprtsock.h                                               |    2 
 include/net/netfilter/nf_conntrack_helper.h                                   |    1 
 include/net/netfilter/nf_flow_table.h                                         |   18 
 include/scsi/scsi_device.h                                                    |    1 
 include/sound/pcm.h                                                           |    1 
 include/trace/events/ext4.h                                                   |   78 
 include/trace/events/rxrpc.h                                                  |    8 
 include/uapi/linux/bpf.h                                                      |   12 
 include/uapi/linux/loop.h                                                     |    4 
 include/uapi/linux/omap3isp.h                                                 |   21 
 include/uapi/linux/rfkill.h                                                   |   14 
 include/uapi/linux/rseq.h                                                     |   20 
 include/uapi/linux/serial_core.h                                              |    3 
 kernel/audit.h                                                                |    4 
 kernel/auditsc.c                                                              |   87 
 kernel/bpf/btf.c                                                              |   55 
 kernel/bpf/stackmap.c                                                         |   56 
 kernel/debug/kdb/kdb_support.c                                                |    2 
 kernel/dma/debug.c                                                            |    4 
 kernel/dma/swiotlb.c                                                          |   11 
 kernel/events/core.c                                                          |    3 
 kernel/livepatch/core.c                                                       |    4 
 kernel/locking/lockdep.c                                                      |   38 
 kernel/locking/lockdep_internals.h                                            |    6 
 kernel/locking/lockdep_proc.c                                                 |   51 
 kernel/power/hibernate.c                                                      |    2 
 kernel/power/suspend_test.c                                                   |    8 
 kernel/printk/printk.c                                                        |    6 
 kernel/ptrace.c                                                               |   47 
 kernel/rcu/rcu_segcblist.h                                                    |    4 
 kernel/rcu/tree.c                                                             |   71 
 kernel/rcu/tree.h                                                             |    4 
 kernel/resource.c                                                             |   41 
 kernel/rseq.c                                                                 |    8 
 kernel/sched/core.c                                                           |    1 
 kernel/sched/cpuacct.c                                                        |    3 
 kernel/sched/cpufreq_schedutil.c                                              |    1 
 kernel/sched/deadline.c                                                       |   12 
 kernel/sched/debug.c                                                          |   10 
 kernel/sched/fair.c                                                           |   18 
 kernel/sched/rt.c                                                             |   32 
 kernel/trace/trace.c                                                          |    9 
 kernel/trace/trace_events.c                                                   |   88 
 kernel/watch_queue.c                                                          |    4 
 lib/kunit/try-catch.c                                                         |    2 
 lib/raid6/test/Makefile                                                       |    4 
 lib/raid6/test/test.c                                                         |    1 
 lib/test_kmod.c                                                               |    1 
 lib/test_lockup.c                                                             |   11 
 lib/test_xarray.c                                                             |   22 
 lib/vsprintf.c                                                                |   48 
 lib/xarray.c                                                                  |    4 
 mm/kmemleak.c                                                                 |    9 
 mm/madvise.c                                                                  |    3 
 mm/memcontrol.c                                                               |    2 
 mm/memory.c                                                                   |   65 
 mm/mempolicy.c                                                                |    8 
 mm/mlock.c                                                                    |    7 
 mm/mmap.c                                                                     |    2 
 mm/page_alloc.c                                                               |    9 
 mm/slab.c                                                                     |    1 
 mm/usercopy.c                                                                 |    5 
 net/bluetooth/hci_conn.c                                                      |    2 
 net/can/isotp.c                                                               |   69 
 net/core/skbuff.c                                                             |   51 
 net/core/skmsg.c                                                              |   17 
 net/dsa/dsa2.c                                                                |    5 
 net/ipv4/route.c                                                              |   18 
 net/ipv4/tcp_bpf.c                                                            |   14 
 net/ipv4/tcp_output.c                                                         |    5 
 net/ipv6/xfrm6_output.c                                                       |   16 
 net/key/af_key.c                                                              |    2 
 net/mac80211/ieee80211_i.h                                                    |    2 
 net/mac80211/main.c                                                           |   13 
 net/mac80211/mesh.c                                                           |    2 
 net/mac80211/mlme.c                                                           |   15 
 net/mac80211/util.c                                                           |   27 
 net/mptcp/protocol.c                                                          |    1 
 net/netfilter/nf_conntrack_core.c                                             |    4 
 net/netfilter/nf_conntrack_helper.c                                           |    6 
 net/netfilter/nf_conntrack_proto_tcp.c                                        |   17 
 net/netfilter/nf_flow_table_inet.c                                            |   17 
 net/netfilter/nf_flow_table_ip.c                                              |   18 
 net/netfilter/nft_ct.c                                                        |    3 
 net/netlink/af_netlink.c                                                      |    2 
 net/openvswitch/conntrack.c                                                   |  132 
 net/openvswitch/flow_netlink.c                                                |    4 
 net/rfkill/core.c                                                             |   48 
 net/rxrpc/ar-internal.h                                                       |   15 
 net/rxrpc/call_event.c                                                        |    2 
 net/rxrpc/call_object.c                                                       |   40 
 net/rxrpc/server_key.c                                                        |    7 
 net/sched/act_ct.c                                                            |   19 
 net/sctp/sm_statefuns.c                                                       |    8 
 net/sunrpc/clnt.c                                                             |    6 
 net/sunrpc/sched.c                                                            |   22 
 net/sunrpc/sysfs.c                                                            |   55 
 net/sunrpc/xprt.c                                                             |   10 
 net/sunrpc/xprtrdma/transport.c                                               |    8 
 net/sunrpc/xprtsock.c                                                         |   56 
 net/tipc/socket.c                                                             |    3 
 net/unix/af_unix.c                                                            |   16 
 net/vmw_vsock/virtio_transport.c                                              |   11 
 net/x25/af_x25.c                                                              |   11 
 net/xdp/xsk.c                                                                 |   69 
 net/xdp/xsk_buff_pool.c                                                       |    8 
 net/xfrm/xfrm_interface.c                                                     |    5 
 samples/bpf/xdpsock_user.c                                                    |    5 
 samples/landlock/sandboxer.c                                                  |    1 
 scripts/atomic/fallbacks/read_acquire                                         |   11 
 scripts/atomic/fallbacks/set_release                                          |    7 
 scripts/dtc/Makefile                                                          |    2 
 scripts/gcc-plugins/stackleak_plugin.c                                        |   25 
 scripts/mod/modpost.c                                                         |    2 
 security/integrity/evm/evm_main.c                                             |    2 
 security/keys/keyctl_pkey.c                                                   |   14 
 security/keys/trusted-keys/trusted_core.c                                     |    6 
 security/landlock/syscalls.c                                                  |    2 
 security/security.c                                                           |   24 
 security/selinux/hooks.c                                                      |  180 
 security/selinux/include/policycap.h                                          |    1 
 security/selinux/include/policycap_names.h                                    |    3 
 security/selinux/include/security.h                                           |    7 
 security/selinux/selinuxfs.c                                                  |    2 
 security/selinux/xfrm.c                                                       |    2 
 security/smack/smack_lsm.c                                                    |    2 
 security/tomoyo/load_policy.c                                                 |    4 
 sound/core/pcm.c                                                              |    1 
 sound/core/pcm_lib.c                                                          |    9 
 sound/core/pcm_native.c                                                       |   39 
 sound/firewire/fcp.c                                                          |    4 
 sound/isa/cs423x/cs4236.c                                                     |    8 
 sound/pci/hda/hda_intel.c                                                     |   10 
 sound/pci/hda/patch_hdmi.c                                                    |    8 
 sound/pci/hda/patch_realtek.c                                                 |   15 
 sound/soc/amd/acp/acp-mach-common.c                                           |    2 
 sound/soc/amd/vangogh/acp5x-mach.c                                            |    1 
 sound/soc/amd/vangogh/acp5x-pcm-dma.c                                         |   68 
 sound/soc/atmel/atmel_ssc_dai.c                                               |    5 
 sound/soc/atmel/mikroe-proto.c                                                |   20 
 sound/soc/atmel/sam9g20_wm8731.c                                              |    1 
 sound/soc/atmel/sam9x5_wm8731.c                                               |   13 
 sound/soc/codecs/Kconfig                                                      |    5 
 sound/soc/codecs/cs35l41.c                                                    |    6 
 sound/soc/codecs/cs42l42.c                                                    |   14 
 sound/soc/codecs/lpass-rx-macro.c                                             |   14 
 sound/soc/codecs/lpass-tx-macro.c                                             |    2 
 sound/soc/codecs/lpass-va-macro.c                                             |    4 
 sound/soc/codecs/lpass-wsa-macro.c                                            |    2 
 sound/soc/codecs/max98927.c                                                   |    1 
 sound/soc/codecs/msm8916-wcd-analog.c                                         |   22 
 sound/soc/codecs/msm8916-wcd-digital.c                                        |    5 
 sound/soc/codecs/mt6358.c                                                     |    4 
 sound/soc/codecs/rk817_codec.c                                                |    6 
 sound/soc/codecs/rt5663.c                                                     |    2 
 sound/soc/codecs/rt5682s.c                                                    |   26 
 sound/soc/codecs/rt5682s.h                                                    |    1 
 sound/soc/codecs/wcd934x.c                                                    |   12 
 sound/soc/codecs/wcd938x.c                                                    |   10 
 sound/soc/codecs/wm8350.c                                                     |   28 
 sound/soc/dwc/dwc-i2s.c                                                       |   17 
 sound/soc/fsl/fsl_spdif.c                                                     |    2 
 sound/soc/fsl/imx-es8328.c                                                    |    1 
 sound/soc/generic/simple-card-utils.c                                         |   15 
 sound/soc/intel/boards/sof_es8336.c                                           |    7 
 sound/soc/intel/boards/sof_sdw.c                                              |    2 
 sound/soc/intel/common/soc-acpi-intel-bxt-match.c                             |    7 
 sound/soc/intel/common/soc-acpi-intel-cml-match.c                             |    7 
 sound/soc/intel/common/soc-acpi-intel-glk-match.c                             |    7 
 sound/soc/intel/common/soc-acpi-intel-jsl-match.c                             |    7 
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c                             |    7 
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c                            |    7 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c                    |    7 
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c                       |   23 
 sound/soc/mxs/mxs-saif.c                                                      |    5 
 sound/soc/mxs/mxs-sgtl5000.c                                                  |    3 
 sound/soc/rockchip/rockchip_i2s.c                                             |   15 
 sound/soc/rockchip/rockchip_i2s_tdm.c                                         |   12 
 sound/soc/sh/fsi.c                                                            |   19 
 sound/soc/sh/rz-ssi.c                                                         |   73 
 sound/soc/soc-compress.c                                                      |    5 
 sound/soc/soc-core.c                                                          |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                                         |    6 
 sound/soc/soc-topology.c                                                      |    3 
 sound/soc/sof/imx/imx8m.c                                                     |    1 
 sound/soc/sof/intel/Kconfig                                                   |    1 
 sound/soc/sof/intel/hda-loader.c                                              |   11 
 sound/soc/sof/intel/hda-pcm.c                                                 |    1 
 sound/soc/sof/intel/hda.c                                                     |   15 
 sound/soc/ti/davinci-i2s.c                                                    |    5 
 sound/soc/xilinx/xlnx_formatter_pcm.c                                         |   25 
 sound/spi/at73c213.c                                                          |   27 
 tools/bpf/bpftool/btf.c                                                       |    2 
 tools/bpf/bpftool/gen.c                                                       |    2 
 tools/bpf/bpftool/link.c                                                      |    3 
 tools/bpf/bpftool/map.c                                                       |   15 
 tools/bpf/bpftool/pids.c                                                      |    3 
 tools/bpf/bpftool/prog.c                                                      |    2 
 tools/include/uapi/linux/bpf.h                                                |    4 
 tools/lib/bpf/btf.h                                                           |   22 
 tools/lib/bpf/btf_dump.c                                                      |   11 
 tools/lib/bpf/libbpf.c                                                        |    3 
 tools/lib/bpf/netlink.c                                                       |   63 
 tools/lib/bpf/xsk.c                                                           |   11 
 tools/perf/builtin-stat.c                                                     |    2 
 tools/perf/pmu-events/arch/x86/skylakex/cache.json                            |  111 
 tools/perf/pmu-events/arch/x86/skylakex/floating-point.json                   |   24 
 tools/perf/pmu-events/arch/x86/skylakex/frontend.json                         |   18 
 tools/perf/pmu-events/arch/x86/skylakex/memory.json                           |   96 
 tools/perf/pmu-events/arch/x86/skylakex/pipeline.json                         |   11 
 tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json                      |  461 ++
 tools/perf/pmu-events/arch/x86/skylakex/uncore-other.json                     |   23 
 tools/testing/cxl/test/cxl.c                                                  |    2 
 tools/testing/selftests/bpf/prog_tests/bind_perm.c                            |   20 
 tools/testing/selftests/bpf/progs/bpf_misc.h                                  |   19 
 tools/testing/selftests/bpf/progs/test_probe_user.c                           |   15 
 tools/testing/selftests/bpf/progs/test_sock_fields.c                          |    2 
 tools/testing/selftests/bpf/test_lirc_mode2.sh                                |    5 
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh                              |   10 
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh                        |   60 
 tools/testing/selftests/bpf/xdpxceiver.c                                      |    5 
 tools/testing/selftests/lkdtm/config                                          |    1 
 tools/testing/selftests/net/af_unix/test_unix_oob.c                           |    6 
 tools/testing/selftests/net/mptcp/mptcp_connect.sh                            |   19 
 tools/testing/selftests/net/test_vxlan_under_vrf.sh                           |    8 
 tools/testing/selftests/net/timestamping.c                                    |    4 
 tools/testing/selftests/net/tls.c                                             |    6 
 tools/testing/selftests/rcutorture/bin/torture.sh                             |    4 
 tools/testing/selftests/sgx/Makefile                                          |    2 
 tools/testing/selftests/vm/Makefile                                           |   12 
 tools/testing/selftests/x86/Makefile                                          |    6 
 tools/testing/selftests/x86/check_cc.sh                                       |    2 
 tools/virtio/virtio_test.c                                                    |    1 
 virt/kvm/kvm_main.c                                                           |   13 
 1059 files changed, 16202 insertions(+), 10810 deletions(-)

Aaron Conole (1):
      openvswitch: always update flow key after nat

Aashish Sharma (1):
      dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Abel Vesa (2):
      clk: imx7d: Remove audio_mclk_root_clk
      ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk

Abhishek Sahu (2):
      vfio/pci: fix memory leak during D3hot to D0 transition
      vfio/pci: wake-up devices around reset functions

Adrian Hunter (4):
      scsi: core: sd: Add silence_suspend flag to suppress some PM messages
      scsi: ufs: Fix runtime PM messages never-ending cycle
      perf/core: Fix address filter parser for multiple filters
      perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Aharon Landau (1):
      RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR

Aidan MacDonald (1):
      pinctrl: ingenic: Fix regmap on X series SoCs

Akira Kawata (1):
      fs/binfmt_elf: Fix AT_PHDR for unusual ELF files

Akira Yokosawa (1):
      docs: sphinx/requirements: Limit jinja2<3.1

Alan Stern (1):
      USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Alex Deucher (2):
      drm/amdgpu: move PX checking into amdgpu_device_ip_early_init
      drm/amdgpu: only check for _PR3 on dGPUs

Alexander Lobakin (11):
      i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      i40e: respect metadata on XSK Rx to skb
      ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ice: respect metadata on XSK Rx to skb
      igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
      ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ixgbe: respect metadata on XSK Rx to skb
      i40e: remove dead stores on XSK hotpath
      ice: fix 'scheduling while atomic' on aux critical err interrupt
      ice: don't allow to run ice_send_event_to_aux() in atomic ctx

Alexander Usyskin (3):
      mei: me: disable driver on the ign firmware
      mei: me: add Alder Lake N device id.
      mei: avoid iterator usage outside of list_for_each_entry

Alexey Khoroshilov (1):
      NFS: remove unneeded check in decode_devicenotify_args()

Ali Pouladi (1):
      rtc: pl031: fix rtc features null pointer dereference

Alistair Delva (1):
      remoteproc: Fix count check in rproc_coredump_write()

Alistair Popple (1):
      mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Amadeusz Sławiński (1):
      ASoC: topology: Allow TLV control to be either read or write

Ameer Hamza (1):
      media: venus: vdec: fixed possible memory leak issue

Amir Goldstein (1):
      nfsd: more robust allocation failure handling in nfsd_file_cache_init

Amit Kumar Mahapatra (1):
      mtd: rawnand: pl353: Set the nand chip node as the flash node

Ammar Faizi (1):
      ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM

Anand Jain (1):
      btrfs: harden identification of a stale device

Anders Roxell (3):
      powerpc/lib/sstep: Fix 'sthcx' instruction
      powerpc/lib/sstep: Fix build errors with newer binutils
      powerpc: Fix build errors with newer binutils

Andre Przywara (2):
      ARM: configs: multi_v5_defconfig: re-enable CONFIG_V4L_PLATFORM_DRIVERS
      ARM: configs: multi_v5_defconfig: re-enable DRM_PANEL and FB_xxx

Andreas Gruenbacher (2):
      gfs2: gfs2_setattr_size error path fix
      gfs2: Fix gfs2_file_buffered_write endless loop workaround

Andreas Rammhold (1):
      KEYS: trusted: Fix trusted key backends when building as module

Andrew Price (1):
      gfs2: Make sure FITRIM minlen is rounded up to fs block size

Andrii Nakryiko (2):
      libbpf: Fix compilation warning due to mismatched printf format
      libbpf: Fix memleak in libbpf_netlink_recv()

Andy Shevchenko (4):
      spi: pxa2xx-pci: Balance reference count for PCI DMA device
      vsprintf: Fix potential unaligned access
      serial: 8250_mid: Balance reference count for PCI DMA device
      serial: 8250_lpss: Balance reference count for PCI DMA device

Ang Tien Sung (1):
      firmware: stratix10-svc: add missing callback parameter on RSU

Anirudh Rayabharam (1):
      vhost: handle error while adding split ranges to iotlb

Anssi Hannula (3):
      xhci: fix garbage USBSTS being logged in some cases
      xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()
      hv_balloon: rate-limit "Unhandled message" warning

Anthony I Gilea (1):
      ASoC: Intel: sof_sdw: fix quirks for 2022 HP Spectre x360 13"

Anton Ivanov (1):
      um: Fix uml_mconsole stop/go

Ard Biesheuvel (1):
      ARM: ftrace: avoid redundant loads or clobbering IP

Armin Wolf (1):
      hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Arnd Bergmann (4):
      uaccess: fix nios2 and microblaze get_user_8()
      uaccess: fix type mismatch warnings from access_ok()
      lib/test_lockup: fix kernel pointer check for separate address spaces
      ARM: iop32x: offset IRQ numbers by 1

Arun Easi (3):
      scsi: qla2xxx: Fix device reconnect in loop topology
      scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests
      scsi: qla2xxx: Fix crash during module load unload test

Arınç ÜNAL (5):
      staging: mt7621-dts: fix LEDs and pinctrl on GB-PC1 devicetree
      staging: mt7621-dts: fix formatting
      staging: mt7621-dts: fix pinctrl properties for ethernet
      staging: mt7621-dts: fix GB-PC2 devicetree
      staging: mt7621-dts: fix pinctrl-0 items to be size-1 items on ethernet

Aswath Govindraju (1):
      mmc: sdhci_am654: Fix the driver data of AM64 SoC

Athira Rajeev (1):
      powerpc/perf: Don't use perf_hw_context for trace IMC PMU

Bagas Sanjaya (2):
      Documentation: add link to stable release candidate tree
      Documentation: update stable tree link

Baokun Li (5):
      jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
      jffs2: fix memory leak in jffs2_do_mount_fs
      jffs2: fix memory leak in jffs2_scan_medium
      ubifs: rename_whiteout: correct old_dir size computing
      ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl

Bard Liao (1):
      ASoC: SOF: Intel: match sdw version on link_slaves_found

Bart Van Assche (1):
      scsi: fnic: Fix a tracing statement

Bartosz Golaszewski (1):
      Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"

Baruch Siach (1):
      arm64: dts: qcom: ipq6018: fix usb reference period

Ben Dooks (1):
      PCI: fu740: Force 2.5GT/s for initial device probe

Bharata B Rao (1):
      sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Biju Das (2):
      spi: Fix invalid sgs value
      spi: Fix erroneous sgs value with min_t()

Bikash Hazarika (1):
      scsi: qla2xxx: Fix wrong FDMI data for 64G adapter

Billy Tsai (1):
      iio: adc: aspeed: Add divider flag to fix incorrect voltage reading.

Bjorn Helgaas (1):
      PCI: Avoid broken MSI on SB600 USB devices

Bob Pearson (1):
      RDMA/rxe: Fix ref error in rxe_av.c

Brandon Wyman (1):
      hwmon: (pmbus) Add Vin unit off handling

Brett Creeley (2):
      ionic: Don't send reset commands if FW isn't running
      ionic: Correctly print AQ errors if completions aren't received

Carlos Llamas (1):
      loop: fix ioctl calls using compat_loop_info

Casey Schaufler (2):
      LSM: general protection fault in legacy_parse_param
      Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni (1):
      loop: use sysfs_emit() in the sysfs xxx show()

Chao Yu (6):
      f2fs: fix to unlock page correctly in error path of is_alive()
      f2fs: fix to do sanity check on .cp_pack_total_block_count
      f2fs: fix to enable ATGC correctly via gc_idle sysfs interface
      f2fs: fix to avoid potential deadlock
      f2fs: fix to do sanity check on curseg->alloc_type
      f2fs: compress: fix to print raw data size in error path of lz4 decompression

Charan Teja Kalla (3):
      mm: madvise: skip unmapped vma holes passed to process_madvise
      mm: madvise: return correct bytes advised with process_madvise
      Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"

Charles Keepax (1):
      ASoC: madera: Add dependencies on MFD

Chen Jingwen (1):
      powerpc/kasan: Fix early region not updated correctly

Chen-Yu Tsai (7):
      media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
      media: hantro: Fix overfill bottom register field name
      pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback
      pinctrl: mediatek: paris: Fix "argument" argument type for mtk_pinconf_get()
      pinctrl: mediatek: paris: Fix pingroup pin config state readback
      pinctrl: mediatek: paris: Skip custom extra pin config dump for virtual GPIOs
      pinctrl: pinconf-generic: Print arguments for bias-pull-*

Chengguang Xu (1):
      RDMA/rxe: Change variable and function argument to proper type

Chengming Zhou (2):
      blk-cgroup: set blkg iostat after percpu stat aggregation
      sched/cpuacct: Fix charge percpu cpuusage

Chris Leech (1):
      nvme-tcp: lockdep: annotate in-kernel sockets

Christian Brauner (1):
      landlock: Use square brackets around "landlock-ruleset"

Christian Göttsche (2):
      selinux: check return value of sel_make_avc_files
      selinux: use correct type for context length

Christian König (1):
      drm/syncobj: flatten dma_fence_chains on transfer

Christoph Hellwig (3):
      nvme: cleanup __nvme_check_ids
      nvme: fix the check for duplicate unique identifiers
      memstick/mspro_block: fix handling of read-only devices

Christophe JAILLET (7):
      firmware: ti_sci: Fix compilation failure when CONFIG_TI_SCI_PROTOCOL is not defined
      i2c: bcm2835: Fix the error handling in 'bcm2835_i2c_probe()'
      power: supply: sbs-charger: Don't cancel work that is not initialized
      gpu: host1x: Fix a memory leak in 'host1x_remove()'
      fsi: Aspeed: Fix a potential double free
      misc: alcor_pci: Fix an error handling path
      block: Fix the maximum minor value is blk_alloc_ext_minor()

Christophe Leroy (3):
      vsprintf: Fix %pK with kptr_restrict == 0
      livepatch: Fix build failure on 32 bits processors
      powerpc: Add set_memory_{p/np}() and remove set_memory_attr()

Chuck Lever (1):
      NFSD: Fix nfsd_breaker_owns_lease() return values

Chun-Jie Chen (1):
      soc: mediatek: pm-domains: Add wakeup capacity support in power domain

Claudiu Beznea (3):
      net: dsa: microchip: add spi_device_id tables
      hwrng: atmel - disable trng on failure path
      clocksource/drivers/timer-microchip-pit64b: Use notrace

Codrin Ciubotariu (2):
      ASoC: dmaengine: do not use a NULL prepare_slave_config() callback
      clk: at91: sama7g5: fix parents of PDMCs' GCLK

Colin Ian King (2):
      carl9170: fix missing bit-wise or operator for tx_params
      iwlwifi: Fix -EIO error code that is never returned

Cooper Chiou (1):
      drm/edid: check basic audio support on CEA extension block

Corentin Labbe (9):
      crypto: sun8i-ss - really disable hash on A80
      crypto: rockchip - ECB does not need IV
      crypto: sun8i-ss - call finalize with bh disabled
      crypto: sun8i-ce - call finalize with bh disabled
      crypto: amlogic - call finalize with bh disabled
      crypto: gemini - call finalize with bh disabled
      media: staging: media: zoran: fix usage of vb2_dma_contig_set_max_seg_size
      media: staging: media: zoran: move videodev alloc
      media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com

Corinna Vinschen (2):
      igc: avoid kernel warning when changing RX ring parameters
      igb: refactor XDP registration

Dafna Hirschfeld (1):
      media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED

Damien Le Moal (12):
      net: bnxt_ptp: fix compilation error
      scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
      scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
      scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
      scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
      scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
      scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
      scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
      scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
      scsi: pm8001: Fix NCQ NON DATA command task initialization
      scsi: pm8001: Fix NCQ NON DATA command completion handling
      scsi: pm8001: Fix abort all task initialization

Dan Carpenter (13):
      greybus: svc: fix an error handling bug in gb_svc_hello()
      NFSD: prevent underflow in nfssvc_decode_writeargs()
      NFSD: prevent integer overflow on 32 bit systems
      video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()
      video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
      media: usb: go7007: s2250-board: fix leak in probe()
      libbpf: Fix signedness bug in btf_dump_array_data()
      iwlwifi: mvm: Fix an error code in iwl_mvm_up()
      RDMA/irdma: Prevent some integer underflows
      USB: storage: ums-realtek: fix error code in rts51x_read_mem()
      RDMA/nldev: Prevent underflow in nldev_stat_set_counter_dynamic_doit()
      clk: imx: off by one in imx_lpcg_parse_clks_from_dt()
      lib/test: use after free in register_test_dev_kmod()

Dan Williams (4):
      cxl/core: Fix cxl_probe_component_regs() error message
      tools/testing/cxl: Fix root port to host bridge assignment
      cxl/port: Hold port reference until decoder release
      nvdimm/region: Fix default alignment for small regions

Daniel González Cabanelas (1):
      media: cx88-mpeg: clear interrupt status register before streaming video

Daniel Henrique Barboza (1):
      powerpc/mm/numa: skip NUMA_NO_NODE onlining in parse_numa_properties()

Daniel Lezcano (1):
      powercap/dtpm_cpu: Reset per_cpu variable in the release function

Daniel Palmer (1):
      ARM: mstar: Select HAVE_ARM_ARCH_TIMER

Daniel Thompson (2):
      soc: qcom: aoss: remove spurious IRQF_ONESHOT flags
      kdb: Fix the putarea helper function

Daniel Wagner (1):
      scsi: qla2xxx: Refactor asynchronous command initialization

Dario Binacchi (1):
      mtd: rawnand: gpmi: fix controller timings setting

Darren Hart (1):
      ACPI/APEI: Limit printable size of BERT table data

Dave Jiang (2):
      dmaengine: idxd: change bandwidth token to read buffers
      dmaengine: idxd: restore traffic class defaults after wq reset

Dave Kleikamp (1):
      KEYS: trusted: Avoid calling null function trusted_key_exit

Dave Stevenson (1):
      regulator: rpi-panel: Handle I2C errors/timing to the Atmel

David Engraf (1):
      arm64: signal: nofpsimd: Do not allocate fp/simd context when not available

David Gow (1):
      firmware: google: Properly state IOMEM dependency

David Heidelberg (2):
      arm64: dts: qcom: sdm845: fix microphone bias properties and values
      ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960

David Hildenbrand (1):
      drivers/base/memory: add memory block to memory group after registration succeeded

David Howells (3):
      watch_queue: Fix NULL dereference in error cleanup
      watch_queue: Actually free the watch
      rxrpc: Fix call timer start racing with call destruction

David Jeffery (1):
      scsi: fnic: Finish scsi_cmnd before dropping the spinlock

David Matlack (1):
      KVM: Prevent module exit until all VMs are freed

David Rhodes (1):
      ASoC: cs35l41: Fix GPIO2 configuration

David Woodhouse (1):
      rcu: Kill rnp->ofl_seq and use only rcu_state.ofl_lock for exclusion

Derek Fang (1):
      ASoC: rt5682s: Fix the wrong jack type detected

Deren Wu (1):
      mt76: mt7921s: fix missing fc type/sub-type for 802.11 pkts

Dirk Buchwalder (1):
      clk: qcom: ipq8074: Use floor ops for SDCC1 clock

Dirk Müller (1):
      lib/raid6/test: fix multiple definition linking error

Divya Koppera (1):
      net: phy: micrel: Fix concurrent register access

Dmitry Baryshkov (5):
      arm64: dts: qcom: sm8250: fix PCIe bindings to follow schema
      drm/msm/dsi/phy: fix 7nm v4.0 settings for C-PHY mode
      drm/msm/dpu: add DSPP blocks teardown
      drm/msm/dpu: fix dp audio condition
      PM: core: keep irq flags in device_pm_check_callbacks()

Dmitry Osipenko (1):
      memory: tegra20-emc: Correct memory device mask

Dmitry Torokhov (1):
      HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Dmitry Vyukov (1):
      riscv: Increase stack size under KASAN

Dongliang Mu (3):
      media: em28xx: initialize refcount before kref_get
      ntfs: add sanity check on allocation size
      media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Douglas Anderson (1):
      arm64: dts: qcom: sc7280: Fix gmu unit address

Drew Fustini (1):
      clocksource/drivers/timer-ti-dm: Fix regression from errata i940 fix

Duoming Zhou (1):
      net/x25: Fix null-ptr-deref caused by x25_disconnect

Dāvis Mosāns (1):
      crypto: ccp - ccp_dmaengine_unregister release dma channels

Eddie James (2):
      USB: serial: pl2303: add IBM device IDs
      spi: fsi: Implement a timeout for polling status

Eli Cohen (1):
      vdpa/mlx5: Avoid processing works if workqueue was destroyed

Eric Biggers (8):
      KEYS: fix length validation in keyctl_pkey_params_get_2()
      KEYS: asymmetric: enforce that sig algo matches key algo
      KEYS: asymmetric: properly validate hash_algo and encoding
      crypto: rsa-pkcs1pad - only allow with rsa
      crypto: rsa-pkcs1pad - correctly get hash from source scatterlist
      crypto: rsa-pkcs1pad - restore signature length check
      crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
      block: don't delete queue kobject before its children

Eric Dumazet (3):
      watch_queue: Free the page array when watch_queue is dismantled
      net: add skb_set_end_offset() helper
      net: preserve skb_end_offset() in skb_unclone_keeptruesize()

Eric W. Biederman (4):
      coredump: Snapshot the vmas in do_coredump
      coredump: Remove the WARN_ON in dump_vma_snapshot
      coredump/elf: Pass coredump_params into fill_note_info
      coredump: Use the vma snapshot in fill_files_note

Eugen Hristev (2):
      media: atmel: atmel-sama7g5-isc: fix ispck leftover
      media: atmel: atmel-isc-base: report frame sizes as full supported range

Evgeny Novikov (1):
      video: fbdev: w100fb: Reset global state

Fabiano Rosas (2):
      KVM: PPC: Fix vmx/vsx mixup in mmio emulation
      KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init

Fabio Estevam (1):
      PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails

Fangrui Song (2):
      arm64: module: remove (NOLOAD) from linker script
      riscv module: remove (NOLOAD)

Felix Maurer (2):
      selftests: bpf: Fix bind on used port
      selftests/bpf: Make test_lwt_ip_encap more stable and faster

Fengnan Chang (1):
      f2fs: fix compressed file start atomic write may cause data corruption

Filipe Manana (1):
      btrfs: fix unexpected error path when reflinking an inline extent

Florian Fainelli (1):
      net: phy: broadcom: Fix brcm_fet_config_init()

Florian Westphal (1):
      net: prefer nf_ct_put instead of nf_conntrack_put

Frank Wunderlich (1):
      arm64: dts: broadcom: Fix sata nodename

GONG, Ruiqi (1):
      selinux: access superblock_security_struct in LSM blob way

Geert Uytterhoeven (3):
      hwrng: cavium - HW_RANDOM_CAVIUM should depend on ARCH_THUNDER
      pinctrl: renesas: r8a77470: Reduce size for narrow VIN1 channel
      pinctrl: renesas: checker: Fix miscalculation of number of states

Geliang Tang (1):
      selftests: mptcp: add csum mib check for mptcp_connect

George Kennedy (1):
      video: fbdev: cirrusfb: check pixclock to avoid divide by zero

Gerhard Engleder (1):
      selftests/net: timestamping: Fix bind_phc check

Gilad Ben-Yossef (1):
      crypto: ccree - don't attempt 0 len DMA mappings

Greg Kroah-Hartman (1):
      Linux 5.16.19

Guangbin Huang (1):
      net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware

Guilherme G. Piccoli (1):
      docs: sysctl/kernel: add missing bit to panic_print

Guillaume Nault (1):
      ipv4: Fix route lookups when handling ICMP redirects and PMTU updates

Guillaume Ranquet (1):
      clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()

Guillaume Tucker (1):
      selftests, x86: fix how check_cc.sh is being invoked

Guodong Liu (1):
      pinctrl: canonical rsel resistance selection property

Gwendal Grignou (2):
      HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
      platform: chrome: Split trace include file

Haimin Zhang (1):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Hangbin Liu (3):
      selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
      bareudp: use ipv6_mod_enabled to check if IPv6 enabled
      selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Hangyu Hua (5):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
      powerpc: 8xx: fix a return value error in mpc8xx_pic_init
      staging: qlge: add unregister_netdev in qlge_probe
      can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Hans Verkuil (2):
      ivtv: fix incorrect device_caps for ivtvfb
      media: staging: media: zoran: fix various V4L2 compliance errors

Hans de Goede (5):
      drm/simpledrm: Add "panel orientation" property on non-upright mounted LCD panels
      power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return
      iio: mma8452: Fix probe failing when an i2c_device_id is used
      media: atomisp_gmin_platform: Add DMI quirk to not turn AXP ELDO2 regulator off on some boards
      media: i2c: ov5648: Fix lockdep error

Hector Martin (5):
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
      brcmfmac: pcie: Declare missing firmware files in pcie.c
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
      brcmfmac: pcie: Fix crashes due to early IRQs

Helge Deller (1):
      video: fbdev: sm712fb: Fix crash in smtcfb_read()

Hengqi Chen (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

Henry Lin (1):
      xhci: fix runtime PM imbalance in USB2 resume

Herbert Xu (3):
      crypto: authenc - Fix sleep in atomic context in decrypt_tail
      crypto: xts - Add softdep on ecb
      crypto: arm/aes-neonbs-cbc - Select generic cbc and aes

Hoang Le (1):
      tipc: fix the timer expires after interval 100ms

Horatiu Vultur (1):
      dt-bindings: pinctrl: pinctrl-microchip-sgpio: Fix example

Hou Tao (2):
      bpf, arm64: Call build_prologue() first in first JIT pass
      bpf, arm64: Feed byte-offset into bpf line info

Hou Wenlong (1):
      KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Hugh Dickins (1):
      mempolicy: mbind_range() set_policy() after vma_merge()

Håkon Bugge (1):
      IB/cma: Allow XRC INI QPs to set their local ACK timeout

Ian Rogers (1):
      perf vendor events: Update metrics for SkyLake Server

Ido Schimmel (1):
      selftests: test_vxlan_under_vrf: Fix broken test case

Ilan Peer (1):
      mac80211: Remove a couple of obsolete TODO

Ilpo Järvinen (1):
      serial: 8250: fix XOFF/XON sending when DMA is used

Jackie Liu (1):
      n64cart: convert bi_disk to bi_bdev->bd_disk fix build

Jaegeuk Kim (3):
      f2fs: fix missing free nid in f2fs_handle_failed_inode
      f2fs: don't get FREEZE lock in f2fs_evict_inode in frozen fs
      f2fs: use spin_lock to avoid hang

Jagan Teki (1):
      drm: bridge: adv7511: Fix ADV7535 HPD enablement

Jakob Koschel (2):
      media: saa7134: fix incorrect use to determine if list is empty
      powerpc/sysdev: fix incorrect use to determine if list is empty

Jakub Kicinski (2):
      tcp: ensure PMTU updates are processed during fastopen
      selftests: tls: skip cmsg_to_pipe tests with TLS=n

Jakub Sitnicki (1):
      selftests/bpf: Fix error reporting from sock_fields programs

James Clark (1):
      coresight: Fix TRCCONFIGR.QE sysfs interface

James Smart (1):
      scsi: scsi_transport_fc: Fix FPIN Link Integrity statistics counters

Jammy Huang (1):
      media: aspeed: Correct value for h-total-pixels

Jani Nikula (2):
      drm/i915/opregion: check port number bounds for SWSCI display power state
      drm/locking: fix drm_modeset_acquire_ctx kernel-doc

Jann Horn (3):
      ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE
      coredump: Also dump first pages of non-executable ELF libraries
      pstore: Don't use semaphores in always-atomic-context code

Janusz Krzysztofik (3):
      media: ov6650: Fix set format try processing path
      media: ov6650: Add try support to selection API operations
      media: ov6650: Fix crop rectangle affected by set format

Jason A. Donenfeld (2):
      wireguard: queueing: use CFI-safe ptr_ring cleanup function
      wireguard: socket: ignore v6 endpoints when ipv6 is disabled

Jason Wang (2):
      Revert "virtio-pci: harden INTX interrupts"
      Revert "virtio_pci: harden MSI-X interrupts"

Jens Axboe (6):
      block: ensure plug merging checks the correct queue at least once
      block: flush plug based on hardware and software queue order
      io_uring: ensure that fsnotify is always called
      io_uring: don't check unrelated req->open.how in accept request
      io_uring: terminate manual loop iterator loop correctly for non-vecs
      Revert "nbd: fix possible overflow on 'first_minor' in nbd_dev_add()"

Jeremy Linton (1):
      net: bcmgenet: Use stronger register read/writes to assure ordering

Jernej Skrabec (2):
      media: cedrus: H265: Fix neighbour info buffer size
      media: cedrus: h264: Fix neighbour info buffer size

Jia-Ju Bai (4):
      ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()
      ASoC: acp: check the return value of devm_kzalloc() in acp_legacy_dai_links_create()
      memory: emif: check the pointer temp in get_device_details()
      platform/x86: huawei-wmi: check the return value of device_create_file()

Jian Shen (4):
      net: hns3: fix bug when PF set the duplicate MAC address for VFs
      net: hns3: fix port base vlan add fail when concurrent with reset
      net: hns3: add vlan list lock to protect vlan list
      net: hns3: refine the process when PF set VF VLAN

Jianglei Nie (1):
      crypto: ccree - Fix use after free in cc_cipher_exit()

Jianyong Wu (1):
      arm64/mm: avoid fixmap race condition when create pud mapping

Jiasheng Jiang (28):
      thermal: int340x: Check for NULL after calling kmemdup()
      spi: spi-zynqmp-gqspi: Handle error for dma_set_mask
      media: mtk-vcodec: potential dereference of null pointer
      ASoC: codecs: Check for error pointer after calling devm_regmap_init_mmio
      media: meson: vdec: potential dereference of null pointer
      soc: qcom: rpmpd: Check for null return of devm_kcalloc
      ASoC: ti: davinci-i2s: Add check for clk_enable()
      ALSA: spi: Add check for clk_enable()
      ASoC: mxs-saif: Handle errors for clk_enable
      ASoC: atmel_ssc_dai: Handle errors for clk_enable
      ASoC: dwc-i2s: Handle errors for clk_enable
      ASoC: soc-compress: prevent the potentially use of null pointer
      memory: emif: Add check for setup_interrupts
      media: vidtv: Check for null return of vzalloc
      ASoC: wm8350: Handle error for wm8350_register_irq
      ASoC: fsi: Add check for clk_enable
      mmc: davinci_mmc: Handle error for clk_enable
      drm/v3d/v3d_drv: Check for error num after setting mask
      drm/panfrost: Check for error num after setting mask
      mtd: onenand: Check for error irq
      ray_cs: Check ioremap return value
      iommu/ipmmu-vmsa: Check for error num after setting mask
      power: supply: wm8350-power: Handle error for wm8350_register_irq
      power: supply: wm8350-power: Add missing free in free_charger_irq
      mfd: mc13xxx: Add check for mc13xxx_irq_request
      iio: adc: Add check for devm_request_threaded_irq
      habanalabs: Add check for pci_enable_device
      ASoC: soc-compress: Change the check for codec_dai

Jiaxin Yu (1):
      ASoC: mediatek: mt6358: add missing EXPORT_SYMBOLs

Jie Hai (1):
      dmaengine: hisi_dma: fix MSI allocate fail when reload hisi_dma

Jing Yao (3):
      video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
      video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()
      video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit

Jiri Slaby (1):
      mxser: fix xmit_buf leak in activate when LSR == 0xff

Jocelyn Falempe (1):
      mgag200 fix memmapsl configuration in GCTL6 register

Joe Carnuccio (3):
      scsi: qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
      scsi: qla2xxx: Add devids and conditionals for 28xx
      scsi: qla2xxx: Check for firmware dump already collected

Joel Stanley (2):
      fsi: scom: Fix error handling
      fsi: scom: Remove retries in indirect scoms

Johan Hovold (6):
      USB: serial: pl2303: fix GS type detection
      USB: serial: simple: add Nokia phone driver
      firmware: sysfb: fix platform-device leak in error path
      media: davinci: vpif: fix unbalanced runtime PM get
      media: davinci: vpif: fix unbalanced runtime PM enable
      media: davinci: vpif: fix use-after-free on driver unbind

Johannes Berg (4):
      rfkill: make new event layout opt-in
      mac80211: limit bandwidth in HE capabilities
      iwlwifi: mvm: align locking in D3 test debugfs
      iwlwifi: pcie: fix SW error MSI-X mapping

John David Anglin (2):
      parisc: Fix non-access data TLB cache flush faults
      parisc: Fix handling off probe non-access faults

Jon Hunter (1):
      spi: Fix Tegra QSPI example

Jonathan Cameron (2):
      cxl/regs: Fix size of CXL Capability Header Register
      staging:iio:adc:ad7280a: Fix handing of device address bit reversing.

Jonathan Marek (4):
      media: camss: csid-170: fix non-10bit formats
      media: camss: csid-170: don't enable unused irqs
      media: camss: csid-170: set the right HALT_CMD when disabled
      media: camss: vfe-170: fix "VFE halt timeout" error

Jonathan Neuschäfer (6):
      clk: actions: Terminate clk_div_table with sentinel element
      clk: loongson1: Terminate clk_div_table with sentinel element
      clk: hisilicon: Terminate clk_div_table with sentinel element
      clk: clps711x: Terminate clk_div_table with sentinel element
      pinctrl: nuvoton: npcm7xx: Rename DS() macro to DSTR()
      pinctrl: nuvoton: npcm7xx: Use %zu printk format for ARRAY_SIZE()

Josef Bacik (4):
      btrfs: make search_csum_tree return 0 if we get -EFBIG
      btrfs: handle csum lookup errors properly on reads
      btrfs: do not double complete bio on errors during compressed reads
      btrfs: do not clean up repair bio if submit fails

Joseph Qi (1):
      ocfs2: fix crash when mount with quota enabled

José Expósito (2):
      Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
      drm/selftests/test-drm_dp_mst_helper: Fix memory leak in sideband_msg_req_encode_decode

José Roberto de Souza (2):
      drm/i915/display: Fix HPD short pulse handling for eDP
      drm/i915/display: Do not re-enable PSR after it was marked as not reliable

Juergen Gross (1):
      xen: fix is_xen_pmu()

Juhyung Park (1):
      f2fs: quota: fix loop condition at f2fs_quota_sync()

Kai Vehmanen (1):
      ASoC: SOF: Intel: enable DMI L1 for playback streams

Kai Ye (3):
      crypto: hisilicon/sec - fix the aead software fallback for engine
      crypto: hisilicon/qm - cleanup warning in qm_vf_read_qos
      crypto: hisilicon/sec - not need to enable sm4 extra mode at HW V3

Kai-Heng Feng (3):
      ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020
      mmc: rtsx: Use pm_runtime_{get,put}() to handle runtime PM
      mmc: rtsx: Let MMC core handle runtime PM

Kees Cook (4):
      exec: Force single empty string when argv is empty
      media: omap3isp: Use struct_group() for memcpy() region
      gcc-plugins/stackleak: Exactly match strings instead of prefixes
      drm/dp: Fix off-by-one in register cache size

Kenta Tada (1):
      selftests/bpf: Extract syscall wrapper

Kirill Tkhai (1):
      dm: fix use-after-free in dm_cleanup_zoned_dev()

Konrad Dybcio (1):
      clk: qcom: gcc-msm8994: Fix gpll4 width

Krzysztof Kozlowski (6):
      dt-bindings: usb: hcd: correct usb-device path
      pinctrl: samsung: drop pin banks references on error paths
      ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5420
      clocksource/drivers/exynos_mct: Handle DTS with higher number of interrupts

Kuan-Ying Lee (1):
      mm/kmemleak: reset tag when compare object pointer

Kuldeep Singh (5):
      arm64: dts: ns2: Fix spi-cpol and spi-cpha property
      ARM: dts: spear1340: Update serial node properties
      ARM: dts: spear13xx: Update SPI dma properties
      arm64: dts: ls1043a: Update i2c dma properties
      arm64: dts: ls1046a: Update i2c node dma properties

Kumar Kartikeya Dwivedi (1):
      bpf: Fix UAF due to race between btf_try_get_module and load_module

Kunihiko Hayashi (1):
      clk: uniphier: Fix fixed-rate initialization

Kuniyuki Iwashima (2):
      af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
      af_unix: Support POLLPRI for OOB.

Kuogee Hsieh (3):
      drm/msm/dp: populate connector of struct dp_panel
      drm/msm/dp: stop link training after link training 2 failed
      drm/msm/dp: always add fail-safe mode into connector mode list

Lad Prabhakar (4):
      ASoC: sh: rz-ssi: Drop calling rz_ssi_pio_recv() recursively
      i2c: bcm2835: Use platform_get_irq() to get the interrupt
      clk: renesas: r9a07g044: Update multiplier and divider values for PLL2/3
      ASoC: sh: rz-ssi: Make the data structures available before registering the handlers

Lars Ellenberg (1):
      drbd: fix potential silent data corruption

Laurent Pinchart (1):
      media: staging: media: imx: imx7-mipi-csis: Make subdev name unique

Leilk Liu (1):
      spi: mediatek: support tick_delay without enhance_timing

Leon Romanovsky (1):
      Revert "RDMA/core: Fix ib_qp_usecnt_dec() called when error"

Leon Yen (1):
      mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl

Li RongQing (1):
      KVM: x86: fix sending PV IPI

Liam Beguin (4):
      iio: afe: rescale: use s64 for temporary scale calculations
      iio: inkern: apply consumer scale on IIO_VAL_INT cases
      iio: inkern: apply consumer scale when no channel scale is available
      iio: inkern: make a best effort on offset calculation

Libin Yang (1):
      soundwire: intel: fix wrong register name in intel_shim_wake

Liguang Zhang (1):
      PCI: pciehp: Clear cmd_busy bit in polling mode

Lina Wang (1):
      xfrm: fix tunnel model fragmentation behavior

Lino Sanfilippo (1):
      tpm: fix reference counting for struct tpm_chip

Linus Torvalds (4):
      Revert "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
      fs: fd tables have to be multiples of BITS_PER_LONG
      fs: fix fd table size alignment properly
      Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Linus Walleij (2):
      Input: zinitix - do not report shadow fingers
      power: ab8500_chargalg: Use CLOCK_MONOTONIC

Liu Ying (1):
      phy: dphy: Correct lpx parameter and its derivatives(ta_{get,go,sure})

Lorenzo Bianconi (10):
      mt76: connac: fix sta_rec_wtbl tag len
      mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
      mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
      mt76: mt7921: do not always disable fw runtime-pm
      mt76: mt7921: fix a leftover race in runtime-pm
      mt76: mt7615: fix a leftover race in runtime-pm
      mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update
      mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_sta
      mt76: mt7921: fix mt7921_queues_acq implementation

Luca Coelho (1):
      iwlwifi: mvm: don't iterate unadded vifs when handling FW SMPS req

Luca Weiss (1):
      cpufreq: qcom-cpufreq-nvmem: fix reading of PVS Valid fuse

Lucas Tanure (2):
      ASoC: cs35l41: Fix max number of TX channels
      i2c: meson: Fix wrong speed use from probe

Lucas Zampieri (1):
      HID: logitech-dj: add new lightspeed receiver id

Luiz Angelo Daros de Luca (2):
      net: dsa: realtek-smi: fix kdoc warnings
      net: dsa: realtek-smi: move to subdirectory

Lv Ruyi (1):
      proc: bootconfig: Add null pointer check

Lyude Paul (2):
      drm/nouveau/backlight: Fix LVDS backlight detection on some laptops
      drm/nouveau/backlight: Just set all backlight types as RAW

Maciej Fijalkowski (1):
      ice: xsk: Fix indexing in ice_tx_xsk_pool()

Maciej W. Rozycki (2):
      DEC: Limit PMAX memory probing to R3k systems
      MIPS: Sanitise Cavium switch cases in TLB handler synthesizers

Magnus Karlsson (3):
      selftests, xsk: Fix rx_full stats test
      xsk: Fix race at socket teardown
      xsk: Do not write NULL in SW ring at allocation failure

Manish Chopra (2):
      qed: display VF trust config
      qed: validate and restrict untrusted VFs vlan promisc mode

Manish Rangankar (1):
      scsi: qla2xxx: Use correct feature type field during RFF_ID processing

Manivannan Sadhasivam (1):
      arm64: dts: qcom: sm8250: Fix MSI IRQ for PCIe1 and PCIe2

Maor Gottlieb (1):
      RDMA/core: Set MR type in ib_reg_user_mr

Marc Kleine-Budde (1):
      can: m_can: m_can_tx_handler(): fix use after free of skb

Marc Zyngier (4):
      PCI: xgene: Revert "PCI: xgene: Fix IB window setup"
      pinctrl: npcm: Fix broken references to chip->parent_device
      irqchip/qcom-pdc: Fix broken locking
      PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"

Marcel Ziswiler (1):
      arm64: defconfig: build imx-sdma as a module

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: fix ref leak when switching zones

Marcelo Roberto Jimenez (1):
      gpio: Revert regression in sysfs-gpio (gpiolib.c)

Marco Elver (1):
      stack: Constrain and fix stack offset randomization with Clang builds

Marek Szyprowski (1):
      clocksource/drivers/exynos_mct: Refactor resources allocation

Marek Vasut (1):
      ARM: dts: imx: Add missing LVDS decoder on M53Menlo

Marijn Suijten (2):
      firmware: qcom: scm: Remove reassignment to desc following initializer
      drm/msm/dsi: Use "ref" fw clock instead of global name for VCO parent

Mark Brown (3):
      mtd: mchp23k256: Add SPI ID table
      mtd: mchp48l640: Add SPI ID table
      KVM: arm64: Enable Cortex-A510 erratum 2077057 by default

Mark Rutland (2):
      arm64: prevent instrumentation of bp hardening callbacks
      atomics: Fix atomic64_{read_acquire,set_release} fallbacks

Mark Tomlinson (1):
      PCI: Reduce warnings on possible RW1C corruption

Martin Blumenstingl (2):
      drm/meson: osd_afbcd: Add an exit callback to struct meson_afbcd_ops
      drm/meson: Fix error handling when afbcd.ops->init fails

Martin Kaiser (1):
      staging: r8188eu: fix endless loop in recv_func

Martin Kepplinger (4):
      media: imx: imx8mq-mipi-csi2: remove wrong irq config write operation
      media: imx: imx8mq-mipi_csi2: fix system resume
      media: dt-binding: media: hynix,hi846: use $defs/port-base port description
      media: dt-bindings: media: hynix,hi846: add link-frequencies description

Martin Povišer (1):
      i2c: pasemi: Drop I2C classes from platform driver variant

Martin Varghese (1):
      openvswitch: Fixed nd target mask field in the flow dump.

Masahiro Yamada (1):
      modpost: restore the warning message for missing symbol versions

Mastan Katragadda (1):
      drm/i915/gem: add missing boundary check in vm_access

Mateusz Jończyk (1):
      rtc: mc146818-lib: fix locking in mc146818_set_time

Mathias Nyman (1):
      xhci: make xhci_handshake timeout for xhci_reset() adjustable

Mathieu Desnoyers (1):
      rseq: Remove broken uapi field layout on 32-bit little endian

Matt Kramer (1):
      ALSA: hda/realtek: Add alc256-samsung-headphone fixup

Matthew Wilcox (Oracle) (2):
      XArray: Fix xas_create_range() when multi-order entry present
      XArray: Update the LRU list in xas_split()

Maulik Shah (2):
      arm64: dts: qcom: sm8150: Correct TCS configuration for apps rsc
      arm64: dts: qcom: sm8350: Correct TCS configuration for apps rsc

Mauricio Vásquez (1):
      bpftool: Fix error check when calling hashmap__new()

Mauro Carvalho Chehab (2):
      ASoC: Intel: sof_es8336: add quirk for Huawei D15 2021
      media: atomisp: fix bad usage at error handling logic

Max Filippov (4):
      xtensa: define update_mmu_tlb function
      xtensa: fix stop_machine_cpuslocked call in patch_text
      xtensa: fix xtensa_wsr always writing 0
      xtensa: add missing XCHAL_HAVE_WINDOWED check

Maxim Kiselev (1):
      powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch

Maxime Ripard (5):
      drm/edid: Don't clear formats if using deep color
      drm/edid: Split deep color modes between RGB and YUV444
      clk: Fix clk_hw_get_clk() when dev is NULL
      clk: Initialize orphan req_rate
      drm/connector: Fix typo in documentation

Maíra Canal (1):
      drm/amd/display: Remove vupdate_int_entry definition

MeiChia Chiu (2):
      mt76: mt7915: fix the nss setting in bitrates
      mt76: mt7915: fix the muru tlv issue

Mel Gorman (1):
      sched/fair: Improve consistency of allowed NUMA balance calculations

Meng Tang (2):
      ASoC: amd: Fix reference to PCM buffer address
      ASoC: rockchip: i2s_tdm: Fixup config for SND_SOC_DAIFMT_DSP_A/B

Miaohe Lin (2):
      mm/mlock: fix two bugs in user_shm_lock()
      kernel/resource: fix kfree() of bootmem memory again

Miaoqian Lin (37):
      coresight: syscfg: Fix memleak on registration failure in cscfg_create_device
      spi: tegra114: Add missing IRQ check in tegra_spi_probe
      spi: tegra210-quad: Fix missin IRQ check in tegra_qspi_probe
      hwrng: nomadik - Change clk_disable to clk_disable_unprepare
      media: coda: Fix missing put_device() call in coda_get_vdoa_data
      soc: qcom: ocmem: Fix missing put_device() call in of_get_ocmem
      soc: qcom: aoss: Fix missing put_device call in qmp_get
      soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe
      ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe
      video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
      ASoC: atmel: Fix error handling in snd_proto_probe
      ASoC: rockchip: i2s: Fix missing clk_disable_unprepare() in rockchip_i2s_probe
      ASoC: SOF: Add missing of_node_put() in imx8m_probe
      ASoC: mediatek: mt8192-mt6359: Fix error handling in mt8192_mt6359_dev_probe
      ASoC: rk817: Fix missing clk_disable_unprepare() in rk817_platform_probe
      ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
      ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe
      ASoC: atmel: Fix error handling in sam9x5_wm8731_driver_probe
      ASoC: msm8916-wcd-analog: Fix error handling in pm8916_wcd_analog_spmi_probe
      ASoC: codecs: wcd934x: Add missing of_node_put() in wcd934x_codec_parse_data
      drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev
      drm/bridge: Add missing pm_runtime_disable() in __dw_mipi_dsi_probe
      drm/bridge: nwl-dsi: Fix PM disable depth imbalance in nwl_dsi_probe
      power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe
      power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
      drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
      ath10k: Fix error handling in ath10k_setup_msa_resources
      mips: cdmm: Fix refcount leak in mips_cdmm_phys_base
      mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
      remoteproc: qcom: Fix missing of_node_put in adsp_alloc_memory_region
      remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
      remoteproc: qcom_q6v5_mss: Fix some leaks in q6v5_alloc_memory_region
      clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver
      pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init
      pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe
      pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe
      watchdog: rti-wdt: Add missing pm_runtime_disable() in probe function

Michael Ellerman (3):
      powerpc/Makefile: Don't pass -mcpu=powerpc64 when building 32-bit
      powerpc/64s: Don't use DSISR for SLB faults
      powerpc/pseries: Fix use after free in remove_phb_dynamic()

Michael Hübner (1):
      HID: Add support for open wheel and no attachment to T300

Michael S. Tsirkin (1):
      virtio_console: break out of buf poll on remove

Michael Schmitz (1):
      video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Michael Straube (1):
      staging: r8188eu: release_firmware is not called if allocation fails

Michael Walle (1):
      pinctrl: microchip-sgpio: lock RMW access

Mike Marciniszyn (1):
      IB/hfi1: Allow larger MTU without AIP

Mike Snitzer (3):
      dm stats: fix too short end duration_ns when using precise_timestamps
      dm: interlock pending dm_io and dm_wait_for_bios_completion
      dm: fix double accounting of flush with data

Mikulas Patocka (1):
      dm integrity: set journal entry unused when shrinking device

Minchan Kim (1):
      mm: fs: fix lru_cache_disabled race in bh_lru

Ming Lei (1):
      block: throttle split bio in case of iops limit

Ming Qian (1):
      media: imx-jpeg: fix a bug of accessing array out of bounds

Minghao Chi (1):
      spi: tegra20: Use of_device_get_match_data()

Minghao Chi (CGEL ZTE) (1):
      net:mcf8390: Use platform_get_irq() to get the interrupt

Mingzhe Zou (1):
      bcache: fixup multiple threads crash

Miquel Raynal (4):
      spi: mxic: Fix the transmit path
      dt-bindings: mtd: nand-controller: Fix the reg property description
      dt-bindings: mtd: nand-controller: Fix a comment in the examples
      dt-bindings: spi: mxic: The interrupt property is not mandatory

Mirela Rabulea (2):
      media: ov5640: Fix set format, v4l2_mbus_pixelcode not updated
      media: imx-jpeg: Prevent decoding NV12M jpegs into single-planar buffers

Miroslav Lichvar (1):
      ptp: unregister virtual clocks when unregistering physical clock.

Mohan Kumar (1):
      ALSA: hda: Avoid unsol event during RPM suspending

Muchun Song (1):
      mm: kfence: fix missing objcg housekeeping for SLAB

Muhammad Usama Anjum (3):
      selftests/x86: Add validity check and allow field splitting
      selftests/sgx: Treat CC as one argument
      selftests/lkdtm: Add UBSAN config

Mukesh Sisodiya (1):
      iwlwifi: yoyo: Avoid using dram data if allocation failed

Mustafa Ismail (3):
      RDMA/irdma: Fix netdev notifications for vlan's
      RDMA/irdma: Fix Passthrough mode in VM
      RDMA/irdma: Remove incorrect masking of PD

Namhyung Kim (1):
      bpf: Adjust BPF stack helper functions to accommodate skip > 0

Naohiro Aota (1):
      btrfs: zoned: mark relocation as writing

Naveen N. Rao (1):
      selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper

Neil Armstrong (3):
      media: mexon-ge2d: fixup frames size in registers
      drm/meson: split out encoder from meson_dw_hdmi
      drm/bridge: dw-hdmi: use safe format when first in bridge chain

NeilBrown (3):
      SUNRPC: avoid race between mod_timer() and del_timer_sync()
      SUNRPC/call_alloc: async tasks mustn't block waiting for memory
      SUNRPC: improve 'swap' handling: scheduling and PF_MEMALLOC

Nicolas Dufresne (1):
      media: v4l2-core: Initialize h264 scaling matrix

Niels Dossche (2):
      btrfs: extend locking to all space_info members accesses
      Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed

Nikita Shubin (1):
      riscv: Fix fill_callchain return value

Niklas Cassel (1):
      riscv: dts: canaan: Fix SPI3 bus width

Niklas Söderlund (1):
      samples/bpf, xdpsock: Fix race when running for fix duration of time

Nikolay Borisov (1):
      btrfs: zoned: put block group after final usage

Nilesh Javali (1):
      scsi: qla2xxx: Fix warning for missing error code

Nishanth Menon (5):
      arm64: dts: ti: k3-am65: Fix gic-v3 compatible regs
      arm64: dts: ti: k3-j721e: Fix gic-v3 compatible regs
      arm64: dts: ti: k3-j7200: Fix gic-v3 compatible regs
      arm64: dts: ti: k3-am64: Fix gic-v3 compatible regs
      drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt

Ojaswin Mujoo (1):
      ext4: make mb_optimize_scan performance mount option work with extents

Olga Kornievskaia (2):
      SUNRPC don't resend a task on an offlined transport
      NFSv4.1: don't retry BIND_CONN_TO_SESSION on session error

Oliver Hartkopp (5):
      can: isotp: sanitize CAN ID checks in isotp_bind()
      vxcan: enable local echo for sent CAN frames
      can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
      can: isotp: support MSG_TRUNC flag when reading from socket
      can: isotp: restore accidentally removed MSG_PEEK feature

Olivier Moysan (1):
      ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15

Ondrej Mosnacek (2):
      security: add sctp_assoc_established hook
      security: implement sctp_assoc_established hook in selinux

Ondrej Zary (1):
      media: bttv: fix WARNING regression on tunerless devices

P Praneesh (1):
      ath11k: avoid active pdev check for each msdu

Pablo Neira Ayuso (2):
      netfilter: flowtable: Fix QinQ and pppoe support for inet table
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Pali Rohár (2):
      PCI: aardvark: Fix reading MSI interrupt number
      PCI: aardvark: Fix reading PCI_EXP_RTSTA_PME bit on emulated bridge

Pankaj Raghav (1):
      nvme: fix the read-only state for zoned namespaces with unsupposed features

Paolo Bonzini (2):
      KVM: x86: Reinitialize context if host userspace toggles EFER.LME
      KVM: x86/mmu: do compare-and-exchange of gPTE via the user address

Paolo Valente (1):
      Revert "Revert "block, bfq: honor already-setup queue merges""

Patrick Rudolph (1):
      hwmon: (pmbus) Add mutex to regulator ops

Paul Cercueil (1):
      MIPS: crypto: Fix CRC32 code

Paul Davey (1):
      bus: mhi: Fix MHI DMA structure endianness

Paul E. McKenney (2):
      rcu: Mark writes to the rcu_segcblist structure's ->flags field
      torture: Make torture.sh help message match reality

Paul Kocialkowski (1):
      ARM: dts: sun8i: v3s: Move the csi1 block to follow address order

Paul Menzel (1):
      lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3

Paulo Alcantara (3):
      cifs: do not skip link targets when an I/O fails
      cifs: prevent bad output lengths in smb2_ioctl_query_info()
      cifs: fix NULL ptr dereference in smb2_ioctl_query_info()

Pavel Begunkov (1):
      io_uring: fix memory leak of uid in files registration

Pavel Kubelun (1):
      ARM: dts: qcom: ipq4019: fix sleep clock

Pavel Skripkin (8):
      udmabuf: validate ubuf->pagecount
      Bluetooth: hci_serdev: call init_rwsem() before p->open()
      ath9k_htc: fix uninit value bugs
      net: asix: add proper error handling of usb read errors
      Bluetooth: hci_uart: add missing NULL check in h5_enqueue
      jfs: fix divide error in dbNextAG
      media: Revert "media: em28xx: add missing em28xx_close_extension"
      can: mcba_usb: properly check endpoint type

Peiwei Hu (1):
      media: ir_toy: free before error exiting

Pekka Pessi (1):
      mailbox: tegra-hsp: Flush whole channel

Peng Li (1):
      net: hns3: clean residual vf config after disable sriov

Peng Liu (1):
      kunit: make kunit_test_timeout compatible with comment

Peter Chiu (3):
      mt76: mt7915: fix ht mcs in mt7915_mac_add_txs_skb()
      mt76: mt7921: fix ht mcs in mt7921_mac_add_txs_skb()
      mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()

Peter Gonda (1):
      crypto: ccp - Ensure psp_ret is always init'd in __sev_platform_init_locked()

Peter Rosin (1):
      i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Peter Xu (1):
      mm: don't skip swap entry even if zap_details specified

Petr Machata (1):
      af_netlink: Fix shift out of bounds in group mask calculation

Petr Vorel (2):
      crypto: vmx - add missing dependencies
      arm64: dts: qcom: msm8994: Provide missing "xo_board" and "sleep_clk" to GCC

Phil Sutter (2):
      netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()
      netfilter: egress: Report interface as outgoing

Phillip Potter (1):
      staging: r8188eu: convert DBG_88E_LEVEL call in hal/rtl8188e_hal_init.c

Pierre-Louis Bossart (3):
      ASoC: Intel: soc-acpi: add more ACPI HIDs for ES83x6 devices
      ASoC: Intel: Revert "ASoC: Intel: sof_es8336: add quirk for Huawei D15 2021"
      ASoC: Intel: sof_es8336: log all quirks

Pin-Yen Lin (1):
      drm/bridge: anx7625: Fix overflow issue on reading EDID

Po Liu (1):
      net:enetc: allocate CBD ring data memory using DMA coherent methods

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Check for EC device

Qais Yousef (2):
      sched/core: Export pelt_thermal_tp
      sched/uclamp: Fix iowait boost escaping uclamp restriction

Qu Wenruo (1):
      btrfs: verify the tranisd of the to-be-written dirty extent buffer

Quentin Schulz (1):
      clk: rockchip: re-add rational best approximation algorithm to the fractional divider

Quinn Tran (12):
      scsi: qla2xxx: Fix stuck session in gpdb
      scsi: qla2xxx: Fix warning message due to adisc being flushed
      scsi: qla2xxx: Fix scheduling while atomic
      scsi: qla2xxx: Fix premature hw access after PCI error
      scsi: qla2xxx: edif: Fix clang warning
      scsi: qla2xxx: Fix disk failure to rediscover
      scsi: qla2xxx: Fix incorrect reporting of task management failure
      scsi: qla2xxx: Fix hang due to session stuck
      scsi: qla2xxx: Fix laggy FC remote port session recovery
      scsi: qla2xxx: Fix N2N inconsistent PLOGI
      scsi: qla2xxx: Fix stuck session of PRLI reject
      scsi: qla2xxx: Reduce false trigger to login

Rafael J. Wysocki (3):
      Revert "ACPI: Pass the same capabilities to the _OSC regardless of the query flag"
      ACPICA: Avoid walking the ACPI Namespace if it is not there
      ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Rafał Miłecki (2):
      arm64: dts: broadcom: bcm4908: use proper TWD binding
      phy: phy-brcm-usb: fixup BCM4908 support

Rameshkumar Sundaram (1):
      ath11k: Invalidate cached reo ring entry before accessing it

Randy Dunlap (22):
      EVM: fix the evm= __setup handler return value
      PM: hibernate: fix __setup handler error handling
      PM: suspend: fix return value of __setup handler
      ACPI: APEI: fix return value of __setup handlers
      clocksource: acpi_pm: fix return value of __setup handler
      ASoC: max98927: add missing header file
      printk: fix return value of printk.devkmsg __setup handler
      m68k: coldfire/device.c: only build for MCF_EDMA when h/w macros are defined
      TOMOYO: fix __setup handlers return values
      mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
      MIPS: RB532: fix return value of __setup handler
      dma-debug: fix return value of __setup handlers
      tty: hvc: fix return value of __setup handler
      kgdboc: fix return value of __setup handler
      kgdbts: fix return value of __setup handler
      driver core: dd: fix return value of __setup handler
      net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
      net: sparx5: uses, depends on BRIDGE or !BRIDGE
      mm/mmap: return 1 from stack_guard_gap __setup() handler
      ARM: 9187/1: JIVE: fix return value of __setup handler
      mm/memcontrol: return 1 from cgroup.memory __setup() handler
      mm/usercopy: return 1 from hardened_usercopy __setup() handler

Richard Fitzgerald (1):
      ASoC: cs42l42: Report full jack status when plug is detected

Richard Guy Briggs (1):
      audit: log AUDIT_TIME_* records only from rules

Richard Haines (1):
      selinux: allow FIOCLEX and FIONCLEX with policy capability

Richard Leitner (1):
      ARM: tegra: tamonten: Fix I2C3 pad setting

Richard Schleich (2):
      ARM: dts: bcm2837: Add the missing L1/L2 cache information
      ARM: dts: bcm2711: Add the missing L1/L2 cache information

Rik van Riel (2):
      mm: invalidate hwpoison page cache page in fault path
      mm,hwpoison: unmap poisoned page before invalidation

Ritesh Harjani (3):
      ext4: fix ext4_fc_stats trace point
      ext4: correct cluster len and clusters changed accounting in ext4_mb_mark_bb
      ext4: fix ext4_mb_mark_bb() with flex_bg with fast_commit

Rob Clark (1):
      drm/msm/a6xx: Fix missing ARRAY_SIZE() check

Rob Herring (1):
      arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly

Robert Hancock (6):
      ASoC: xilinx: xlnx_formatter_pcm: Handle sysclk setting
      ASoC: simple-card-utils: Set sysclk on all components
      net: phy: at803x: move page selection fix to config_init
      i2c: xiic: Make bus names unique
      net: axienet: fix RX ring refill allocation failure handling
      pps: clients: gpio: Propagate return value from pps_gpio_probe

Robert Marko (1):
      clk: qcom: ipq8074: fix PCI-E clock oops

Robin Gong (2):
      mailbox: imx: fix crash in resume on i.mx8ulp
      mailbox: imx: fix wakeup failure from freeze mode

Robin Murphy (1):
      iommu/iova: Improve 32-bit free space estimate

Rohith Surabattula (1):
      Adjust cifssb maximum read size

Roman Li (1):
      drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug

Ronnie Sahlberg (2):
      cifs: fix handlecache and multiuser
      cifs: we do not need a spinlock around the tree access during umount

Rotem Saado (1):
      iwlwifi: yoyo: remove DBGI_SRAM address reset writing

Sakari Ailus (3):
      ACPI: properties: Consistently return -ENOENT if there are no more references
      media: v4l: Avoid unaligned access warnings when printing 4cc modifiers
      media: ov5648: Don't pack controls struct

Sam Protsenko (1):
      pinctrl: samsung: Remove EINT handler for Exynos850 ALIVE and CMGP gpios

Saurav Kashyap (3):
      scsi: qla2xxx: Implement ref count for SRB
      scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()
      scsi: qla2xxx: Add qla2x00_async_done() for async routines

Scott Mayhew (1):
      selinux: Fix selinux_sb_mnt_opts_compat()

Sean Christopherson (5):
      KVM: SVM: Exit to userspace on ENOMEM/EFAULT GHCB errors
      KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap hook
      KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
      KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
      KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU

Sean Nyekjaer (1):
      mtd: rawnand: protect access to rawnand devices while in suspend

Sean Wang (3):
      mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
      mt76: mt7921: set EDCA parameters with the MCU CE command
      mt76: mt7921e: fix possible probe failure after reboot

Sean Young (1):
      media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC

Sergey Shtylyov (1):
      mmc: core: use sysfs_emit() instead of sprintf()

Shannon Nelson (3):
      ionic: fix type complaint in ionic_dev_cmd_clean()
      ionic: start watchdog after all is setup
      ionic: fix up printing of timeout error

Shawn Guo (1):
      PM: domains: Fix sleep-in-atomic bug caused by genpd_debug_remove()

Shengjiu Wang (2):
      ASoC: fsl_spdif: Disable TX clock when stop
      ASoC: soc-core: skip zero num_dai component in searching dai name

Shijith Thotton (1):
      crypto: octeontx2 - remove CONFIG_DM_CRYPT check

Shin'ichiro Kawasaki (1):
      block: limit request dispatch loop duration

Si-Wei Liu (1):
      vdpa/mlx5: should verify CTRL_VQ feature exists for MQ

Sondhauß, Jan (1):
      drivers: ethernet: cpsw: fix panic when interrupt coaleceing is set via ethtool

Souptick Joarder (HPE) (1):
      irqchip/nvic: Release nvic_base upon failure

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix incorrect 4GB boundary check

Srinivas Kandagatla (7):
      ASoC: codecs: rx-macro: fix accessing compander for aux
      ASoC: codecs: rx-macro: fix accessing array out of bounds for enum type
      ASoC: codecs: va-macro: fix accessing array out of bounds for enum type
      ASoC: codecs: wc938x: fix accessing array out of bounds for enum type
      ASoC: codecs: wcd938x: fix kcontrol max values
      ASoC: codecs: wcd934x: fix kcontrol max values
      ASoC: codecs: wcd934x: fix return value of wcd934x_rx_hph_mode_put

Srinivas Pandruvada (1):
      thermal: int340x: Increase bitmap size

Stanimir Varbanov (2):
      media: venus: hfi_cmds: List HDR10 property as unsupported for v1 and v3
      media: venus: venc: Fix h264 8x8 transform control

Stefano Garzarella (5):
      tools/virtio: fix virtio_test execution
      vsock/virtio: initialize vdev->priv before using VQs
      vsock/virtio: read the negotiated features before using VQs
      vsock/virtio: enable VQs early on probe
      virtio: use virtio_device_ready() in virtio_device_restore()

Stephan Gerhold (1):
      cpuidle: qcom-spm: Check if any CPU is managed by SPM

Steven Rostedt (Google) (3):
      tracing: Have trace event string test handle zero length strings
      tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
      tracing: Have type enum modifications copy the strings

Sukadev Bhattiprolu (1):
      ibmvnic: fix race between xmit and reset

Sungup Moon (1):
      nvme: allow duplicate NSIDs for private namespaces

Sunil Goutham (1):
      hwrng: cavium - Check health status while reading random data

Sven Peter (1):
      usb: typec: tipd: Forward plug orientation to typec subsystem

Takashi Iwai (3):
      ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
      iwlwifi: mvm: Don't call iwl_mvm_sta_from_mac80211() with NULL sta
      ALSA: hda: Fix driver index handling at re-binding

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Taniya Das (2):
      clk: qcom: clk-rcg2: Update logic to calculate D value for RCG
      clk: qcom: clk-rcg2: Update the frac table for pixel clock

Tedd Ho-Jeong An (1):
      Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products

Tejun Heo (2):
      block: fix rq-qos breakage from skipping rq_qos_done_bio()
      block: don't merge across cgroup boundaries if blkcg is enabled

Theodore Ts'o (1):
      ext4: don't BUG if someone dirty pages without asking ext4 first

Thomas Bracht Laumann Jespersen (1):
      scripts/dtc: Call pkg-config POSIXly correct

Thomas Richter (1):
      perf stat: Fix forked applications enablement of counters

Thomas Zimmermann (2):
      fbdev: Hot-unplug firmware fb devices on forced removal
      drm/fb-helper: Mark screen buffers in system memory with FBINFO_VIRTFB

Tim Gardner (1):
      video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Enable port policy support on 6097

Toke Høiland-Jørgensen (2):
      libbpf: Use dynamically allocated buffer when receiving netlink messages
      libbpf: Define BTF_KIND_* constants in btf.h to avoid compilation errors

Tom Rix (7):
      samples/landlock: Fix path_list memory leak
      media: video/hdmi: handle short reads of hdmi info frame.
      drm/amd/pm: return -ENOTSUPP if there is no get_dpm_ultimate_freq function
      qlcnic: dcb: default to returning -EOPNOTSUPP
      octeontx2-af: initialize action variable
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
      rtc: check if __rtc_read_time was successful

Tomas Paukrt (1):
      crypto: mxs-dcp - Fix scatterlist processing

Tong Zhang (1):
      dax: make sure inodes are flushed before destroy cache

Trond Myklebust (7):
      SUNRPC: Do not dereference non-socket transports in sysfs
      NFS: NFSv2/v3 clients should never be setting NFS_CAP_XATTR
      NFS: Use of mapping_set_error() results in spurious errors
      NFS: Return valid errors from nfs2/3_decode_dirent()
      SUNRPC: Don't call connect() more than once on a TCP socket
      NFS: Don't loop forever in nfs_do_recoalesce()
      NFSv4/pNFS: Fix another issue with a list iterator pointing to the head

Tsuchiya Yuto (1):
      media: atomisp: fix dummy_ptr check to avoid duplicate active_bo

Tudor Ambarus (2):
      ARM: dts: at91: sama7g5: Remove unused properties in i2c nodes
      ARM: dts: at91: sama5d2: Fix PMERRLOC resource size

Tzung-Bi Shih (1):
      ASoC: mediatek: use of_device_get_match_data()

Ulf Hansson (2):
      mmc: host: Return an error when ->enable_sdio_irq() ops is missing
      mmc: rtsx: Fix build errors/warnings for unused variable

Uwe Kleine-König (3):
      pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()
      serial: 8250: Fix race condition in RTS-after-send handling
      ARM: mmp: Fix failure to remove sram device

Valentin Schneider (2):
      sched/rt: Plug rt_mutex_setprio() vs push_rt_task() race
      sched/tracing: Report TASK_RTLOCK_WAIT tasks as TASK_UNINTERRUPTIBLE

Vijay Balakrishna (1):
      arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones

Vijendar Mukunda (2):
      ASoC: amd: vg: fix for pm resume callback sequence
      ASoC: amd: vangogh: fix uninitialized symbol warning in machine driver

Ville Syrjälä (3):
      drm/i915: Treat SAGV block time 0 as SAGV disabled
      drm/i915: Fix PSF GV point mask when SAGV is not possible
      drm/i915: Reject unsupported TMDS rates on ICL+

Vitaly Kuznetsov (7):
      KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_send_ipi()
      KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_flush_tlb()
      KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls
      KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Vladimir Oltean (2):
      net: dsa: fix panic on shutdown if multi-chip tree failed to probe
      net: enetc: report software timestamping via SO_TIMESTAMPING

Waiman Long (2):
      locking/lockdep: Avoid potential access of invalid memory in lock_class
      locking/lockdep: Iterate lock_classes directly when reading lockdep files

Wan Jiabing (1):
      docs: fix 'make htmldocs' warning in SCTP.rst

Wang Hai (2):
      video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()
      wireguard: socket: free skb in send6 when ipv6 is disabled

Wang Wensheng (1):
      ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Wang Yufen (4):
      bpf, sockmap: Fix memleak in sk_psock_queue_msg
      bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
      bpf, sockmap: Fix more uncharged while msg has more_data
      bpf, sockmap: Fix double uncharge the mem of sk_msg

Wei Fu (1):
      bpftool: Only set obj->skeleton on complete success

Wen Gong (2):
      ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern
      ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz

Will Deacon (1):
      arm64: mm: Drop 'const' from conditional arm64_dma_phys_limit definition

Xiang Chen (1):
      scsi: hisi_sas: Change permission of parameter prot_mask

Xiao Yang (1):
      RDMA/rxe: Check the last packet by RXE_END_MASK

Xiaolong Huang (2):
      virt: acrn: fix a memory leak in acrn_dev_ioctl()
      rxrpc: fix some null-ptr-deref bugs in server_key.c

Xiaomeng Tong (2):
      ALSA: cs4236: fix an incorrect NULL check on list iterator
      net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

Xin Xiong (1):
      mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init

Xu Kuohai (1):
      libbpf: Skip forward declaration when counting duplicated type names

Yafang Shao (2):
      libbpf: Fix possible NULL pointer dereference when destroying skeleton
      bpftool: Fix print error when show bpf map

Yahu Gao (1):
      block/bfq_wf2q: correct weight to ioprio

Yajun Deng (1):
      RDMA/core: Fix ib_qp_usecnt_dec() called when error

Yake Yang (1):
      Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt

Yaliang Wang (1):
      MIPS: pgalloc: fix memory leak caused by pgd_free()

Yang Guang (1):
      video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit

Ye Bin (1):
      ext4: fix fs corruption when tring to remove a non-empty directory with IO error

Yi Wang (1):
      KVM: SVM: fix panic on out-of-bounds guest IRQ

Yinjun Zhang (1):
      bpftool: Fix the error when lookup in no-btf maps

Yiqing Yao (1):
      drm/amd/pm: enable pm sysfs write for one VF mode

Yong Wu (6):
      media: iommu/mediatek-v1: Free the existed fwspec if the master dev already has
      media: iommu/mediatek: Return ENODEV if the device is NULL
      media: iommu/mediatek: Add device_link between the consumer and the larb devices
      dt-bindings: memory: mtk-smi: Rename clock to clocks
      dt-bindings: memory: mtk-smi: No need mediatek,larb-id for mt8167
      dt-bindings: memory: mtk-smi: Correct minItems to 2 for the gals clocks

Yonghong Song (1):
      bpf: Fix a btf decl_tag bug when tagging a function

Yonghua Huang (1):
      virt: acrn: obtain pa from VMA with PFNMAP flag

Yonglin Tan (1):
      bus: mhi: pci_generic: Add mru_default for Quectel EM1xx series

Yonglong Li (1):
      mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb

Yongzhi Liu (1):
      RDMA/mlx5: Fix memory leak in error flow for subscribe event routine

Yosry Ahmed (1):
      selftests: vm: fix clang build error multiple output files

Yu Kuai (1):
      block, bfq: don't move oom_bfqq

YueHaibing (1):
      video: fbdev: controlfb: Fix COMPILE_TEST build

Yufeng Mo (2):
      net: hns3: format the output of the MAC address
      net: hns3: fix the concurrency between functions reading debugfs

Z. Liu (1):
      video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen

Zev Weiss (2):
      ARM: dts: Fix OpenBMC flash layout label addresses
      serial: 8250_aspeed_vuart: add PORT_ASPEED_VUART port type

Zhang Wensheng (2):
      bfq: fix use-after-free in bfq_dispatch_request
      nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Zhang Yi (1):
      ext2: correct max file size computing

Zheng Bin (1):
      ASoC: SOF: Intel: Fix build error without SND_SOC_SOF_PCI_DEV

Zheng Yongjun (1):
      net: sparx5: switchdev: fix possible NULL pointer dereference

Zhenzhong Duan (1):
      KVM: x86: Fix emulation in writing cr8

Zheyu Ma (2):
      ethernet: sun: Free the coherent when failing in probing
      video: fbdev: sm712fb: Fix crash in smtcfb_write()

Zhihao Cheng (10):
      ubifs: rename_whiteout: Fix double free for whiteout_ui->data
      ubifs: Fix deadlock in concurrent rename whiteout and inode writeback
      ubifs: Add missing iput if do_tmpfile() failed in rename whiteout
      ubifs: Rename whiteout atomically
      ubifs: Fix 'ui->dirty' race between do_tmpfile() and writeback work
      ubifs: Rectify space amount budget for mkdir/tmpfile operations
      ubifs: setflags: Make dirtied_ino_d 8 bytes aligned
      ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()
      ubifs: Fix to add refcount once page is set private
      ubi: fastmap: Return error code if memory allocation fails in add_aeb()

Zhou Qingyang (3):
      media: ti-vpe: cal: Fix a NULL pointer dereference in cal_ctx_v4l2_init_formats()
      drm/nouveau/acr: Fix undefined behavior in nvkm_acr_hsfw_load_bl()
      drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()

kernel test robot (1):
      regulator: qcom_smd: fix for_each_child.cocci warnings

lic121 (1):
      libbpf: Unmap rings when umem deleted

zhangqilong (1):
      ASoC: rockchip: Fix PM usage reference of rockchip_i2s_tdm_resume

