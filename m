Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDD65A428
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 13:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiLaMqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 07:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiLaMqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 07:46:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F852BCC;
        Sat, 31 Dec 2022 04:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5E8EB8070E;
        Sat, 31 Dec 2022 12:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F4C433EF;
        Sat, 31 Dec 2022 12:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672490792;
        bh=q7cnqElp9mkWMFmImw05cn2tSnfy67vFI0TH3A//jeU=;
        h=From:To:Cc:Subject:Date:From;
        b=E8q6zxe1ntBqpVQqQ1R1nIgkJlQUhI5D8EtikYE/I9hTu972A/Bgb/ZFuhZhlJshq
         /NGFGKedTQM0Q5WkbkRgS8Jev+ckWPjYPqApzj/mPCC9l+ci1+2Dv8fW259EO5J61p
         XdyFKlN49Q17BUhu6dInnwBU06g+Gn9sR45r3jK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.2
Date:   Sat, 31 Dec 2022 13:46:28 +0100
Message-Id: <167249078835102@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.2 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/stable/sysfs-driver-dma-idxd                           |   12 
 Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor                  |    3 
 Documentation/admin-guide/sysctl/kernel.rst                              |   23 
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml              |   25 
 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml                |    8 
 Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml                |   46 
 Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml         |    7 
 Documentation/devicetree/bindings/pinctrl/mediatek,mt7986-pinctrl.yaml   |   46 
 Documentation/devicetree/bindings/pwm/microchip,corepwm.yaml             |    4 
 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt                 |    2 
 Documentation/devicetree/bindings/sound/rt5682.txt                       |    2 
 Documentation/driver-api/spi.rst                                         |    4 
 Documentation/fault-injection/fault-injection.rst                        |   10 
 Makefile                                                                 |    2 
 arch/Kconfig                                                             |    2 
 arch/alpha/include/asm/thread_info.h                                     |    2 
 arch/alpha/kernel/entry.S                                                |    4 
 arch/arm/boot/dts/armada-370.dtsi                                        |    2 
 arch/arm/boot/dts/armada-375.dtsi                                        |    2 
 arch/arm/boot/dts/armada-380.dtsi                                        |    4 
 arch/arm/boot/dts/armada-385-turris-omnia.dts                            |   18 
 arch/arm/boot/dts/armada-385.dtsi                                        |    6 
 arch/arm/boot/dts/armada-39x.dtsi                                        |    6 
 arch/arm/boot/dts/armada-xp-mv78230.dtsi                                 |    8 
 arch/arm/boot/dts/armada-xp-mv78260.dtsi                                 |   16 
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts                             |   17 
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts                             |   16 
 arch/arm/boot/dts/dove.dtsi                                              |    2 
 arch/arm/boot/dts/nuvoton-npcm730-gbs.dts                                |    2 
 arch/arm/boot/dts/nuvoton-npcm730-gsj.dts                                |    2 
 arch/arm/boot/dts/nuvoton-npcm730-kudo.dts                               |    6 
 arch/arm/boot/dts/nuvoton-npcm750-evb.dts                                |    4 
 arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts                     |    6 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                      |    2 
 arch/arm/boot/dts/spear600.dtsi                                          |    2 
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts                        |    1 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi                       |    2 
 arch/arm/mach-mmp/time.c                                                 |   11 
 arch/arm64/boot/dts/apple/t8103.dtsi                                     |    6 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts                   |    3 
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts                              |   12 
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi                                |   22 
 arch/arm64/boot/dts/mediatek/mt6779.dtsi                                 |    8 
 arch/arm64/boot/dts/mediatek/mt6797.dtsi                                 |    2 
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi                                |   16 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                                 |    2 
 arch/arm64/boot/dts/mediatek/mt8195.dtsi                                 |    8 
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi                         |    6 
 arch/arm64/boot/dts/nvidia/tegra234.dtsi                                 |    8 
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts                             |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                    |    2 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                    |  114 +
 arch/arm64/boot/dts/qcom/msm8996pro.dtsi                                 |  266 ++++
 arch/arm64/boot/dts/qcom/pm6350.dtsi                                     |    1 
 arch/arm64/boot/dts/qcom/pm660.dtsi                                      |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi                    |    6 
 arch/arm64/boot/dts/qcom/sc7280-idp.dts                                  |    1 
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi                                 |    3 
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                                     |    2 
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi                               |    4 
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts                       |    2 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                                     |    2 
 arch/arm64/boot/dts/qcom/sm6350.dtsi                                     |   10 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                     |   10 
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts                                  |    2 
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi                     |    2 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                     |   20 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                     |   10 
 arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts            |    2 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                                     |   13 
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi                                |   16 
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi                                |    2 
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi                               |    6 
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi                               |   34 
 arch/arm64/boot/dts/tesla/fsd-pinctrl.h                                  |    6 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                                 |    1 
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi                          |    1 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                                |    1 
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi                               |    2 
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi                         |    2 
 arch/arm64/crypto/Kconfig                                                |   11 
 arch/arm64/crypto/Makefile                                               |    3 
 arch/arm64/crypto/sm3-neon-core.S                                        |  601 +++++++++
 arch/arm64/crypto/sm3-neon-glue.c                                        |  103 +
 arch/arm64/include/asm/processor.h                                       |    4 
 arch/arm64/mm/fault.c                                                    |    8 
 arch/mips/bcm63xx/clk.c                                                  |    2 
 arch/mips/boot/dts/ingenic/ci20.dts                                      |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c                    |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper.c                          |    2 
 arch/mips/kernel/vpe-cmp.c                                               |    4 
 arch/mips/kernel/vpe-mt.c                                                |    4 
 arch/mips/ralink/of.c                                                    |    4 
 arch/powerpc/boot/dts/turris1x.dts                                       |   14 
 arch/powerpc/include/asm/hvcall.h                                        |    3 
 arch/powerpc/perf/callchain.c                                            |    1 
 arch/powerpc/perf/hv-gpci-requests.h                                     |    4 
 arch/powerpc/perf/hv-gpci.c                                              |   35 
 arch/powerpc/perf/hv-gpci.h                                              |    1 
 arch/powerpc/perf/req-gen/perf.h                                         |   20 
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c                            |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c                                |    2 
 arch/powerpc/platforms/pseries/eeh_pseries.c                             |   11 
 arch/powerpc/platforms/pseries/plpks.c                                   |   32 
 arch/powerpc/platforms/pseries/plpks.h                                   |    2 
 arch/powerpc/sysdev/xive/spapr.c                                         |    1 
 arch/powerpc/xmon/xmon.c                                                 |    7 
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit-fabric.dtsi                |    2 
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts                        |    2 
 arch/riscv/boot/dts/microchip/mpfs-sev-kit-fabric.dtsi                   |   29 
 arch/riscv/include/asm/hugetlb.h                                         |    6 
 arch/riscv/include/asm/io.h                                              |    5 
 arch/riscv/include/asm/pgtable-64.h                                      |    6 
 arch/riscv/kernel/entry.S                                                |   18 
 arch/riscv/kernel/signal.c                                               |   34 
 arch/riscv/kernel/traps.c                                                |    2 
 arch/riscv/kvm/vcpu.c                                                    |   11 
 arch/riscv/mm/physaddr.c                                                 |    2 
 arch/riscv/net/bpf_jit_comp64.c                                          |   29 
 arch/x86/Kconfig                                                         |    4 
 arch/x86/crypto/aegis128-aesni-asm.S                                     |    9 
 arch/x86/crypto/aria-aesni-avx-asm_64.S                                  |   13 
 arch/x86/crypto/sha1_ni_asm.S                                            |    3 
 arch/x86/crypto/sha1_ssse3_asm.S                                         |    3 
 arch/x86/crypto/sha256-avx-asm.S                                         |    3 
 arch/x86/crypto/sha256-avx2-asm.S                                        |    3 
 arch/x86/crypto/sha256-ssse3-asm.S                                       |    3 
 arch/x86/crypto/sha256_ni_asm.S                                          |    3 
 arch/x86/crypto/sha512-avx-asm.S                                         |    3 
 arch/x86/crypto/sha512-avx2-asm.S                                        |    3 
 arch/x86/crypto/sha512-ssse3-asm.S                                       |    3 
 arch/x86/crypto/sm3-avx-asm_64.S                                         |    3 
 arch/x86/crypto/sm4-aesni-avx-asm_64.S                                   |    7 
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S                                  |    7 
 arch/x86/events/intel/uncore_snb.c                                       |    3 
 arch/x86/events/intel/uncore_snbep.c                                     |    5 
 arch/x86/hyperv/hv_init.c                                                |    2 
 arch/x86/include/asm/apic.h                                              |    3 
 arch/x86/include/asm/realmode.h                                          |    1 
 arch/x86/include/asm/x86_init.h                                          |    4 
 arch/x86/kernel/apic/apic.c                                              |   13 
 arch/x86/kernel/cpu/intel.c                                              |   63 -
 arch/x86/kernel/cpu/sgx/encl.c                                           |   23 
 arch/x86/kernel/setup.c                                                  |    2 
 arch/x86/kernel/uprobes.c                                                |    4 
 arch/x86/kernel/x86_init.c                                               |    3 
 arch/x86/realmode/init.c                                                 |    8 
 arch/x86/xen/enlighten_pv.c                                              |    2 
 arch/x86/xen/smp.c                                                       |   24 
 arch/x86/xen/smp_pv.c                                                    |   12 
 arch/x86/xen/spinlock.c                                                  |    6 
 block/bfq-iosched.c                                                      |   16 
 block/blk-cgroup.c                                                       |    2 
 block/blk-mq-sysfs.c                                                     |   11 
 block/blk-mq.c                                                           |   56 
 block/genhd.c                                                            |    2 
 crypto/cryptd.c                                                          |   36 
 crypto/tcrypt.c                                                          |  265 ++--
 drivers/acpi/acpica/dsmethod.c                                           |   10 
 drivers/acpi/acpica/utcopy.c                                             |    7 
 drivers/acpi/ec.c                                                        |   10 
 drivers/acpi/irq.c                                                       |    5 
 drivers/acpi/pfr_telemetry.c                                             |    6 
 drivers/acpi/pfr_update.c                                                |    6 
 drivers/acpi/processor_idle.c                                            |    3 
 drivers/acpi/video_detect.c                                              |   54 
 drivers/acpi/x86/utils.c                                                 |   24 
 drivers/ata/libata-sata.c                                                |   11 
 drivers/base/class.c                                                     |    5 
 drivers/base/power/runtime.c                                             |   12 
 drivers/base/regmap/regmap-irq.c                                         |   15 
 drivers/block/drbd/drbd_main.c                                           |    9 
 drivers/block/drbd/drbd_nl.c                                             |   10 
 drivers/block/floppy.c                                                   |    4 
 drivers/block/loop.c                                                     |   28 
 drivers/bluetooth/btintel.c                                              |    5 
 drivers/bluetooth/btusb.c                                                |    6 
 drivers/bluetooth/hci_bcm.c                                              |   13 
 drivers/bluetooth/hci_bcsp.c                                             |    2 
 drivers/bluetooth/hci_h5.c                                               |    2 
 drivers/bluetooth/hci_ll.c                                               |    2 
 drivers/bluetooth/hci_qca.c                                              |    2 
 drivers/char/hw_random/amd-rng.c                                         |   18 
 drivers/char/hw_random/geode-rng.c                                       |   36 
 drivers/char/ipmi/ipmi_msghandler.c                                      |    8 
 drivers/char/ipmi/kcs_bmc_aspeed.c                                       |   24 
 drivers/char/tpm/tpm_crb.c                                               |    2 
 drivers/char/tpm/tpm_ftpm_tee.c                                          |    8 
 drivers/char/tpm/tpm_tis_core.c                                          |   20 
 drivers/char/tpm/tpm_tis_core.h                                          |    1 
 drivers/char/tpm/tpm_tis_i2c.c                                           |    3 
 drivers/clk/imx/clk-imx8mn.c                                             |  116 -
 drivers/clk/imx/clk-imx8mp.c                                             |    4 
 drivers/clk/imx/clk-imx93.c                                              |   19 
 drivers/clk/imx/clk-imxrt1050.c                                          |    2 
 drivers/clk/mediatek/clk-mt7986-infracfg.c                               |    2 
 drivers/clk/microchip/clk-mpfs-ccc.c                                     |    6 
 drivers/clk/qcom/clk-krait.c                                             |    2 
 drivers/clk/qcom/dispcc-sm6350.c                                         |    4 
 drivers/clk/qcom/gcc-ipq806x.c                                           |    4 
 drivers/clk/qcom/gcc-sm8250.c                                            |    4 
 drivers/clk/qcom/lpassaudiocc-sc7280.c                                   |   55 
 drivers/clk/qcom/lpasscorecc-sc7180.c                                    |   24 
 drivers/clk/renesas/r8a779a0-cpg-mssr.c                                  |    2 
 drivers/clk/renesas/r8a779f0-cpg-mssr.c                                  |   18 
 drivers/clk/renesas/r9a06g032-clocks.c                                   |    3 
 drivers/clk/rockchip/clk-pll.c                                           |    1 
 drivers/clk/samsung/clk-pll.c                                            |    1 
 drivers/clk/socfpga/clk-gate.c                                           |    5 
 drivers/clk/st/clkgen-fsyn.c                                             |    5 
 drivers/clk/visconti/pll.c                                               |    1 
 drivers/clocksource/sh_cmt.c                                             |   88 -
 drivers/clocksource/timer-ti-dm-systimer.c                               |    4 
 drivers/clocksource/timer-ti-dm.c                                        |    2 
 drivers/counter/stm32-lptimer-cnt.c                                      |    2 
 drivers/cpufreq/amd_freq_sensitivity.c                                   |    2 
 drivers/cpufreq/qcom-cpufreq-hw.c                                        |   43 
 drivers/cpuidle/dt_idle_states.c                                         |    2 
 drivers/crypto/Kconfig                                                   |    5 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                      |    2 
 drivers/crypto/amlogic/amlogic-gxl-core.c                                |    1 
 drivers/crypto/amlogic/amlogic-gxl.h                                     |    2 
 drivers/crypto/cavium/nitrox/nitrox_mbx.c                                |    1 
 drivers/crypto/ccree/cc_debugfs.c                                        |    2 
 drivers/crypto/ccree/cc_driver.c                                         |   10 
 drivers/crypto/hisilicon/hpre/hpre_main.c                                |   10 
 drivers/crypto/hisilicon/qm.c                                            |   11 
 drivers/crypto/img-hash.c                                                |    8 
 drivers/crypto/omap-sham.c                                               |    2 
 drivers/crypto/qat/qat_4xxx/adf_drv.c                                    |    1 
 drivers/crypto/rockchip/rk3288_crypto.c                                  |  193 ---
 drivers/crypto/rockchip/rk3288_crypto.h                                  |   53 
 drivers/crypto/rockchip/rk3288_crypto_ahash.c                            |  197 +--
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c                         |  413 +++---
 drivers/dio/dio.c                                                        |    8 
 drivers/dma/apple-admac.c                                                |  102 +
 drivers/dma/idxd/sysfs.c                                                 |   68 +
 drivers/edac/i10nm_base.c                                                |    3 
 drivers/extcon/extcon-usbc-tusb320.c                                     |   17 
 drivers/firmware/raspberrypi.c                                           |    1 
 drivers/firmware/ti_sci.c                                                |    5 
 drivers/gpio/gpiolib-cdev.c                                              |  204 ++-
 drivers/gpio/gpiolib.c                                                   |    4 
 drivers/gpio/gpiolib.h                                                   |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                                 |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                               |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                                 |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                                 |    2 
 drivers/gpu/drm/amd/amdgpu/nv.c                                          |   28 
 drivers/gpu/drm/amd/amdgpu/soc15.c                                       |   24 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c                |   35 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c                       |   16 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c             |    2 
 drivers/gpu/drm/amd/display/dc/core/dc.c                                 |   65 -
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c                    |    3 
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c                    |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c                |   30 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                       |   35 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c                        |    6 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c                    |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c                     |    7 
 drivers/gpu/drm/amd/include/kgd_pp_interface.h                           |    3 
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c                         |    3 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c                          |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c                  |   25 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c                    |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                           |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c                     |   21 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                                 |    3 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                             |   18 
 drivers/gpu/drm/bridge/adv7511/adv7533.c                                 |   25 
 drivers/gpu/drm/bridge/ite-it6505.c                                      |    8 
 drivers/gpu/drm/drm_atomic_helper.c                                      |   10 
 drivers/gpu/drm/drm_edid.c                                               |   12 
 drivers/gpu/drm/drm_fourcc.c                                             |    8 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                                    |   11 
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c                                |    5 
 drivers/gpu/drm/i915/display/intel_bios.c                                |    2 
 drivers/gpu/drm/i915/display/intel_dp.c                                  |   59 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                                 |   21 
 drivers/gpu/drm/i915/gem/i915_gem_pm.c                                   |    2 
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c                                  |   63 -
 drivers/gpu/drm/i915/gem/i915_gem_ttm.h                                  |   18 
 drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c                             |    2 
 drivers/gpu/drm/i915/gt/intel_engine.h                                   |    6 
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                                |   91 +
 drivers/gpu/drm/i915/gt/intel_gt.c                                       |    3 
 drivers/gpu/drm/i915/gt/intel_gt_types.h                                 |   17 
 drivers/gpu/drm/i915/gt/sysfs_engines.c                                  |   25 
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c                           |  109 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h                              |   21 
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c                               |    6 
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c                        |    8 
 drivers/gpu/drm/i915/i915_driver.c                                       |    3 
 drivers/gpu/drm/i915/i915_gem.c                                          |   45 
 drivers/gpu/drm/i915/intel_runtime_pm.c                                  |    5 
 drivers/gpu/drm/i915/intel_runtime_pm.h                                  |   22 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                       |   12 
 drivers/gpu/drm/mediatek/mtk_hdmi.c                                      |    7 
 drivers/gpu/drm/meson/meson_encoder_cvbs.c                               |    7 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                                    |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c                               |   11 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                                 |   27 
 drivers/gpu/drm/msm/dp/dp_display.c                                      |    2 
 drivers/gpu/drm/msm/dsi/dsi_host.c                                       |  121 -
 drivers/gpu/drm/msm/hdmi/hdmi.c                                          |    2 
 drivers/gpu/drm/mxsfb/lcdif_kms.c                                        |   48 
 drivers/gpu/drm/mxsfb/lcdif_regs.h                                       |    5 
 drivers/gpu/drm/panel/panel-sitronix-st7701.c                            |   12 
 drivers/gpu/drm/radeon/radeon_bios.c                                     |   19 
 drivers/gpu/drm/rcar-du/Kconfig                                          |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                                   |    2 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                          |    2 
 drivers/gpu/drm/rockchip/inno_hdmi.c                                     |    2 
 drivers/gpu/drm/rockchip/rk3066_hdmi.c                                   |    2 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                              |    4 
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c                             |    2 
 drivers/gpu/drm/rockchip/rockchip_lvds.c                                 |   10 
 drivers/gpu/drm/sti/sti_dvo.c                                            |    7 
 drivers/gpu/drm/sti/sti_hda.c                                            |    7 
 drivers/gpu/drm/sti/sti_hdmi.c                                           |    7 
 drivers/gpu/drm/tegra/dc.c                                               |    4 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                                 |    4 
 drivers/hid/hid-apple.c                                                  |  118 -
 drivers/hid/hid-input.c                                                  |    6 
 drivers/hid/hid-logitech-hidpp.c                                         |   11 
 drivers/hid/hid-mcp2221.c                                                |   12 
 drivers/hid/hid-rmi.c                                                    |    2 
 drivers/hid/hid-sensor-custom.c                                          |    2 
 drivers/hid/hid-uclogic-params.c                                         |   73 +
 drivers/hid/hid-uclogic-rdesc.c                                          |   34 
 drivers/hid/hid-uclogic-rdesc.h                                          |    7 
 drivers/hid/i2c-hid/i2c-hid-core.c                                       |    3 
 drivers/hid/wacom_sys.c                                                  |    8 
 drivers/hid/wacom_wac.c                                                  |    4 
 drivers/hid/wacom_wac.h                                                  |    1 
 drivers/hsi/controllers/omap_ssi_core.c                                  |   14 
 drivers/hv/ring_buffer.c                                                 |   13 
 drivers/hwmon/Kconfig                                                    |    1 
 drivers/hwmon/emc2305.c                                                  |   44 
 drivers/hwmon/jc42.c                                                     |  243 ++--
 drivers/hwmon/nct6775-platform.c                                         |    7 
 drivers/hwtracing/coresight/coresight-cti-core.c                         |    2 
 drivers/hwtracing/coresight/coresight-trbe.c                             |    1 
 drivers/i2c/busses/i2c-ismt.c                                            |    3 
 drivers/i2c/busses/i2c-pxa-pci.c                                         |   10 
 drivers/i2c/muxes/i2c-mux-reg.c                                          |    5 
 drivers/iio/adc/ad_sigma_delta.c                                         |    8 
 drivers/iio/adc/ti-adc128s052.c                                          |   14 
 drivers/iio/addac/ad74413r.c                                             |    2 
 drivers/iio/imu/adis.c                                                   |   28 
 drivers/iio/industrialio-event.c                                         |    4 
 drivers/iio/temperature/ltc2983.c                                        |   10 
 drivers/infiniband/Kconfig                                               |    2 
 drivers/infiniband/core/device.c                                         |    2 
 drivers/infiniband/core/mad.c                                            |    5 
 drivers/infiniband/core/nldev.c                                          |    6 
 drivers/infiniband/core/restrack.c                                       |    2 
 drivers/infiniband/core/sysfs.c                                          |   17 
 drivers/infiniband/hw/hfi1/affinity.c                                    |    2 
 drivers/infiniband/hw/hfi1/firmware.c                                    |    6 
 drivers/infiniband/hw/hns/hns_roce_device.h                              |    3 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                               |  217 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                               |   13 
 drivers/infiniband/hw/hns/hns_roce_main.c                                |   18 
 drivers/infiniband/hw/hns/hns_roce_mr.c                                  |    4 
 drivers/infiniband/hw/hns/hns_roce_qp.c                                  |  107 +
 drivers/infiniband/hw/irdma/uk.c                                         |  170 +-
 drivers/infiniband/hw/irdma/user.h                                       |   20 
 drivers/infiniband/hw/irdma/utils.c                                      |    2 
 drivers/infiniband/hw/irdma/verbs.c                                      |  145 --
 drivers/infiniband/hw/irdma/verbs.h                                      |   53 
 drivers/infiniband/sw/rxe/rxe_mr.c                                       |    9 
 drivers/infiniband/sw/rxe/rxe_qp.c                                       |    6 
 drivers/infiniband/sw/siw/siw_cq.c                                       |   24 
 drivers/infiniband/sw/siw/siw_qp_tx.c                                    |    2 
 drivers/infiniband/sw/siw/siw_verbs.c                                    |   40 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                             |    7 
 drivers/infiniband/ulp/srp/ib_srp.c                                      |   96 +
 drivers/input/joystick/Kconfig                                           |    1 
 drivers/input/misc/Kconfig                                               |    2 
 drivers/input/misc/iqs7222.c                                             |  504 ++++----
 drivers/input/touchscreen/elants_i2c.c                                   |    9 
 drivers/interconnect/qcom/sc7180.c                                       |    2 
 drivers/iommu/amd/iommu_v2.c                                             |    1 
 drivers/iommu/fsl_pamu.c                                                 |    2 
 drivers/iommu/iommu.c                                                    |   28 
 drivers/iommu/mtk_iommu.c                                                |   53 
 drivers/iommu/rockchip-iommu.c                                           |   10 
 drivers/iommu/s390-iommu.c                                               |  106 -
 drivers/iommu/sun50i-iommu.c                                             |   89 +
 drivers/irqchip/irq-gic-pm.c                                             |    2 
 drivers/irqchip/irq-loongson-liointc.c                                   |    5 
 drivers/irqchip/irq-loongson-pch-pic.c                                   |    3 
 drivers/irqchip/irq-wpcm450-aic.c                                        |    1 
 drivers/isdn/hardware/mISDN/hfcmulti.c                                   |   19 
 drivers/isdn/hardware/mISDN/hfcpci.c                                     |   13 
 drivers/isdn/hardware/mISDN/hfcsusb.c                                    |   12 
 drivers/leds/leds-is31fl319x.c                                           |    3 
 drivers/leds/rgb/leds-qcom-lpg.c                                         |   18 
 drivers/macintosh/macio-adb.c                                            |    4 
 drivers/macintosh/macio_asic.c                                           |    2 
 drivers/mailbox/arm_mhuv2.c                                              |    4 
 drivers/mailbox/mailbox-mpfs.c                                           |   31 
 drivers/mailbox/pcc.c                                                    |    1 
 drivers/mailbox/zynqmp-ipi-mailbox.c                                     |    4 
 drivers/mcb/mcb-core.c                                                   |    4 
 drivers/mcb/mcb-parse.c                                                  |    2 
 drivers/md/dm.c                                                          |  123 +-
 drivers/md/md-bitmap.c                                                   |   27 
 drivers/md/raid0.c                                                       |    1 
 drivers/md/raid1.c                                                       |    1 
 drivers/md/raid10.c                                                      |    2 
 drivers/media/dvb-core/dvb_ca_en50221.c                                  |    2 
 drivers/media/dvb-core/dvb_frontend.c                                    |   10 
 drivers/media/dvb-core/dvbdev.c                                          |   32 
 drivers/media/dvb-frontends/bcm3510.c                                    |    1 
 drivers/media/i2c/ad5820.c                                               |   10 
 drivers/media/i2c/adv748x/adv748x-afe.c                                  |    4 
 drivers/media/i2c/dw9768.c                                               |   33 
 drivers/media/i2c/hi846.c                                                |   14 
 drivers/media/i2c/mt9p031.c                                              |    1 
 drivers/media/i2c/ov5640.c                                               |    3 
 drivers/media/i2c/ov5648.c                                               |    1 
 drivers/media/pci/saa7164/saa7164-core.c                                 |    4 
 drivers/media/pci/solo6x10/solo6x10-core.c                               |    1 
 drivers/media/platform/amphion/vdec.c                                    |   15 
 drivers/media/platform/amphion/vpu.h                                     |    1 
 drivers/media/platform/amphion/vpu_cmds.c                                |   39 
 drivers/media/platform/amphion/vpu_drv.c                                 |    6 
 drivers/media/platform/amphion/vpu_malone.c                              |    1 
 drivers/media/platform/amphion/vpu_msgs.c                                |    2 
 drivers/media/platform/amphion/vpu_v4l2.c                                |   30 
 drivers/media/platform/amphion/vpu_windsor.c                             |    1 
 drivers/media/platform/chips-media/coda-bit.c                            |   14 
 drivers/media/platform/chips-media/coda-jpeg.c                           |   10 
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c                     |   51 
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c                     |   24 
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c                     |   15 
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c        |   13 
 drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c     |   60 
 drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c        |   15 
 drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c                  |    2 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c                        |    4 
 drivers/media/platform/qcom/camss/camss-video.c                          |    3 
 drivers/media/platform/qcom/camss/camss.c                                |   11 
 drivers/media/platform/qcom/venus/pm_helpers.c                           |    4 
 drivers/media/platform/samsung/exynos4-is/fimc-core.c                    |    2 
 drivers/media/platform/samsung/exynos4-is/media-dev.c                    |   12 
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c                         |   17 
 drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c                 |    1 
 drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c           |   23 
 drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c |   23 
 drivers/media/radio/si470x/radio-si470x-usb.c                            |    4 
 drivers/media/rc/imon.c                                                  |    6 
 drivers/media/test-drivers/vidtv/vidtv_bridge.c                          |   22 
 drivers/media/test-drivers/vimc/vimc-core.c                              |    2 
 drivers/media/test-drivers/vivid/vivid-vid-cap.c                         |    1 
 drivers/media/usb/dvb-usb/az6027.c                                       |    4 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                                 |    4 
 drivers/media/v4l2-core/v4l2-ctrls-api.c                                 |    1 
 drivers/media/v4l2-core/v4l2-ctrls-core.c                                |    2 
 drivers/media/v4l2-core/v4l2-ioctl.c                                     |   34 
 drivers/media/v4l2-core/videobuf-dma-contig.c                            |   22 
 drivers/memory/renesas-rpc-if.c                                          |    3 
 drivers/memstick/core/ms_block.c                                         |    9 
 drivers/mfd/Kconfig                                                      |    1 
 drivers/mfd/axp20x.c                                                     |    2 
 drivers/mfd/qcom-pm8008.c                                                |    4 
 drivers/mfd/qcom_rpm.c                                                   |   16 
 drivers/misc/cxl/guest.c                                                 |   24 
 drivers/misc/cxl/pci.c                                                   |   21 
 drivers/misc/habanalabs/common/firmware_if.c                             |    2 
 drivers/misc/lkdtm/cfi.c                                                 |    6 
 drivers/misc/ocxl/config.c                                               |   20 
 drivers/misc/ocxl/file.c                                                 |    7 
 drivers/misc/sgi-gru/grufault.c                                          |   13 
 drivers/misc/sgi-gru/grumain.c                                           |   22 
 drivers/misc/sgi-gru/grutables.h                                         |    2 
 drivers/misc/tifm_7xx1.c                                                 |    2 
 drivers/mmc/core/sd.c                                                    |   11 
 drivers/mmc/host/alcor.c                                                 |    5 
 drivers/mmc/host/atmel-mci.c                                             |    9 
 drivers/mmc/host/litex_mmc.c                                             |    1 
 drivers/mmc/host/meson-gx-mmc.c                                          |    4 
 drivers/mmc/host/mmci.c                                                  |    4 
 drivers/mmc/host/moxart-mmc.c                                            |    4 
 drivers/mmc/host/mxcmmc.c                                                |    4 
 drivers/mmc/host/omap_hsmmc.c                                            |    4 
 drivers/mmc/host/pxamci.c                                                |    7 
 drivers/mmc/host/renesas_sdhi.h                                          |    1 
 drivers/mmc/host/renesas_sdhi_core.c                                     |   14 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                            |    4 
 drivers/mmc/host/rtsx_pci_sdmmc.c                                        |    9 
 drivers/mmc/host/rtsx_usb_sdmmc.c                                        |   11 
 drivers/mmc/host/sdhci-tegra.c                                           |    3 
 drivers/mmc/host/sdhci.c                                                 |    5 
 drivers/mmc/host/sdhci.h                                                 |    2 
 drivers/mmc/host/sdhci_f_sdh30.c                                         |    3 
 drivers/mmc/host/toshsd.c                                                |    6 
 drivers/mmc/host/via-sdmmc.c                                             |    4 
 drivers/mmc/host/vub300.c                                                |   11 
 drivers/mmc/host/wbsd.c                                                  |   12 
 drivers/mmc/host/wmt-sdmmc.c                                             |    6 
 drivers/mtd/lpddr/lpddr2_nvm.c                                           |    2 
 drivers/mtd/maps/pxa2xx-flash.c                                          |    2 
 drivers/mtd/mtdcore.c                                                    |    9 
 drivers/mtd/spi-nor/core.c                                               |    3 
 drivers/mtd/spi-nor/sysfs.c                                              |   14 
 drivers/net/bonding/bond_main.c                                          |   37 
 drivers/net/can/m_can/m_can.c                                            |   32 
 drivers/net/can/m_can/m_can_platform.c                                   |    4 
 drivers/net/can/m_can/tcan4x5x-core.c                                    |   18 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                              |   30 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                         |  115 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                        |  160 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                         |  437 ++++++-
 drivers/net/dsa/lan9303-core.c                                           |    4 
 drivers/net/dsa/microchip/ksz_common.c                                   |    3 
 drivers/net/dsa/mv88e6xxx/chip.c                                         |    9 
 drivers/net/ethernet/adi/adin1110.c                                      |   37 
 drivers/net/ethernet/amd/atarilance.c                                    |    2 
 drivers/net/ethernet/amd/lance.c                                         |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                              |   23 
 drivers/net/ethernet/apple/bmac.c                                        |    2 
 drivers/net/ethernet/apple/mace.c                                        |    2 
 drivers/net/ethernet/broadcom/bnx2.c                                     |    5 
 drivers/net/ethernet/dnet.c                                              |    4 
 drivers/net/ethernet/freescale/enetc/enetc.c                             |   35 
 drivers/net/ethernet/freescale/fec_main.c                                |    8 
 drivers/net/ethernet/intel/i40e/i40e_main.c                              |   36 
 drivers/net/ethernet/intel/ice/ice_ptp.c                                 |   10 
 drivers/net/ethernet/intel/igb/igb_main.c                                |    8 
 drivers/net/ethernet/intel/igc/igc.h                                     |    3 
 drivers/net/ethernet/intel/igc/igc_defines.h                             |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                                |  210 ++-
 drivers/net/ethernet/intel/igc/igc_tsn.c                                 |   13 
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c                          |    6 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                              |   71 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                              |   11 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                         |    1 
 drivers/net/ethernet/neterion/s2io.c                                     |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                              |    3 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c                 |    2 
 drivers/net/ethernet/rdc/r6040.c                                         |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c                    |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                        |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h                         |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c                   |    8 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                                 |   10 
 drivers/net/ethernet/ti/netcp_core.c                                     |    2 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                            |    2 
 drivers/net/fddi/defxx.c                                                 |   22 
 drivers/net/hamradio/baycom_epp.c                                        |    2 
 drivers/net/hamradio/scc.c                                               |    6 
 drivers/net/macsec.c                                                     |   34 
 drivers/net/mctp/mctp-serial.c                                           |    6 
 drivers/net/ntb_netdev.c                                                 |    4 
 drivers/net/ppp/ppp_generic.c                                            |    2 
 drivers/net/wan/farsync.c                                                |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                                 |    6 
 drivers/net/wireless/ath/ath10k/core.c                                   |   16 
 drivers/net/wireless/ath/ath10k/htc.c                                    |    9 
 drivers/net/wireless/ath/ath10k/hw.h                                     |    2 
 drivers/net/wireless/ath/ath10k/pci.c                                    |   20 
 drivers/net/wireless/ath/ath11k/core.h                                   |    2 
 drivers/net/wireless/ath/ath11k/mac.c                                    |  122 +-
 drivers/net/wireless/ath/ath11k/qmi.c                                    |    3 
 drivers/net/wireless/ath/ath9k/hif_usb.c                                 |   46 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c                |    8 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c              |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c                  |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c                  |    1 
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h                         |    7 
 drivers/net/wireless/intel/iwlwifi/mei/main.c                            |  172 +-
 drivers/net/wireless/intel/iwlwifi/mei/net.c                             |   10 
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                              |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                             |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                             |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                              |   20 
 drivers/net/wireless/mediatek/mt76/mt76.h                                |    3 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c                     |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c                       |   58 
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h                       |    5 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                          |   23 
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c                          |   13 
 drivers/net/wireless/mediatek/mt76/mt7921/init.c                         |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                          |   34 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c                         |    6 
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h                       |    4 
 drivers/net/wireless/mediatek/mt76/usb.c                                 |   11 
 drivers/net/wireless/purelifi/plfxlc/usb.c                               |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                         |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c                    |   28 
 drivers/net/wireless/realtek/rtw89/core.c                                |    2 
 drivers/net/wireless/realtek/rtw89/mac.c                                 |    6 
 drivers/net/wireless/realtek/rtw89/phy.c                                 |    2 
 drivers/net/wireless/rsi/rsi_91x_core.c                                  |    4 
 drivers/net/wireless/rsi/rsi_91x_hal.c                                   |    6 
 drivers/nfc/pn533/pn533.c                                                |    4 
 drivers/nvme/host/core.c                                                 |   19 
 drivers/nvme/host/fc.c                                                   |    2 
 drivers/nvme/host/nvme.h                                                 |    2 
 drivers/nvme/host/rdma.c                                                 |    4 
 drivers/nvme/host/tcp.c                                                  |    1 
 drivers/nvme/target/core.c                                               |   22 
 drivers/nvme/target/io-cmd-file.c                                        |   16 
 drivers/nvme/target/loop.c                                               |    2 
 drivers/nvme/target/nvmet.h                                              |    3 
 drivers/of/overlay.c                                                     |    4 
 drivers/pci/controller/dwc/pci-imx6.c                                    |   13 
 drivers/pci/controller/dwc/pcie-designware.c                             |    2 
 drivers/pci/controller/vmd.c                                             |   27 
 drivers/pci/endpoint/functions/pci-epf-test.c                            |    2 
 drivers/pci/endpoint/functions/pci-epf-vntb.c                            |    2 
 drivers/pci/irq.c                                                        |    2 
 drivers/pci/probe.c                                                      |    3 
 drivers/perf/arm_dmc620_pmu.c                                            |    8 
 drivers/perf/arm_dsu_pmu.c                                               |    6 
 drivers/perf/arm_smmuv3_pmu.c                                            |    8 
 drivers/perf/hisilicon/hisi_pcie_pmu.c                                   |    8 
 drivers/perf/marvell_cn10k_tad_pmu.c                                     |    6 
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c                        |    9 
 drivers/phy/broadcom/phy-brcm-usb-init.h                                 |    1 
 drivers/phy/broadcom/phy-brcm-usb.c                                      |   14 
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c                             |    3 
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c                                 |  607 +++++-----
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h                       |    2 
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h                            |   14 
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c                                  |  142 --
 drivers/phy/qualcomm/phy-qcom-qmp.h                                      |    1 
 drivers/pinctrl/mediatek/pinctrl-mt7986.c                                |   24 
 drivers/pinctrl/pinconf-generic.c                                        |    4 
 drivers/pinctrl/pinctrl-k210.c                                           |    4 
 drivers/pinctrl/pinctrl-ocelot.c                                         |   20 
 drivers/pinctrl/pinctrl-thunderbay.c                                     |    8 
 drivers/platform/chrome/cros_ec_typec.c                                  |    3 
 drivers/platform/chrome/cros_usbpd_notify.c                              |    6 
 drivers/platform/mellanox/mlxbf-pmc.c                                    |    2 
 drivers/platform/x86/huawei-wmi.c                                        |   20 
 drivers/platform/x86/intel/int3472/clk_and_regulator.c                   |    3 
 drivers/platform/x86/intel_scu_ipc.c                                     |    2 
 drivers/platform/x86/mxm-wmi.c                                           |    8 
 drivers/pnp/core.c                                                       |    4 
 drivers/power/supply/ab8500_charger.c                                    |    9 
 drivers/power/supply/bq25890_charger.c                                   |   71 -
 drivers/power/supply/cw2015_battery.c                                    |    3 
 drivers/power/supply/power_supply_core.c                                 |    7 
 drivers/power/supply/rk817_charger.c                                     |    4 
 drivers/power/supply/z2_battery.c                                        |    6 
 drivers/pwm/pwm-mediatek.c                                               |    2 
 drivers/pwm/pwm-mtk-disp.c                                               |    5 
 drivers/pwm/pwm-sifive.c                                                 |    5 
 drivers/pwm/pwm-tegra.c                                                  |   15 
 drivers/rapidio/devices/rio_mport_cdev.c                                 |   15 
 drivers/rapidio/rio-scan.c                                               |    8 
 drivers/rapidio/rio.c                                                    |    9 
 drivers/regulator/core.c                                                 |   25 
 drivers/regulator/devres.c                                               |    2 
 drivers/regulator/of_regulator.c                                         |    2 
 drivers/regulator/qcom-labibb-regulator.c                                |    1 
 drivers/regulator/qcom-rpmh-regulator.c                                  |    2 
 drivers/regulator/stm32-vrefbuf.c                                        |    2 
 drivers/remoteproc/qcom_q6v5_pas.c                                       |    4 
 drivers/remoteproc/qcom_q6v5_wcss.c                                      |    6 
 drivers/remoteproc/qcom_sysmon.c                                         |    5 
 drivers/remoteproc/remoteproc_core.c                                     |    8 
 drivers/rtc/class.c                                                      |    4 
 drivers/rtc/rtc-cmos.c                                                   |  378 +++---
 drivers/rtc/rtc-mxc_v2.c                                                 |    4 
 drivers/rtc/rtc-pcf2127.c                                                |   22 
 drivers/rtc/rtc-pcf85063.c                                               |   10 
 drivers/rtc/rtc-pic32.c                                                  |    8 
 drivers/rtc/rtc-rzn1.c                                                   |    4 
 drivers/rtc/rtc-snvs.c                                                   |   16 
 drivers/rtc/rtc-st-lpc.c                                                 |    1 
 drivers/s390/net/ctcm_main.c                                             |   11 
 drivers/s390/net/lcs.c                                                   |    8 
 drivers/s390/net/netiucv.c                                               |    9 
 drivers/scsi/elx/efct/efct_driver.c                                      |    1 
 drivers/scsi/elx/libefc/efclib.h                                         |    6 
 drivers/scsi/fcoe/fcoe.c                                                 |    1 
 drivers/scsi/fcoe/fcoe_sysfs.c                                           |   19 
 drivers/scsi/hpsa.c                                                      |    9 
 drivers/scsi/ipr.c                                                       |   10 
 drivers/scsi/lpfc/lpfc_sli.c                                             |    6 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                                 |    2 
 drivers/scsi/qla2xxx/qla_def.h                                           |   22 
 drivers/scsi/qla2xxx/qla_init.c                                          |   20 
 drivers/scsi/qla2xxx/qla_inline.h                                        |    4 
 drivers/scsi/qla2xxx/qla_os.c                                            |    4 
 drivers/scsi/scsi_debug.c                                                |   11 
 drivers/scsi/scsi_error.c                                                |   14 
 drivers/scsi/smartpqi/smartpqi.h                                         |    2 
 drivers/scsi/smartpqi/smartpqi_init.c                                    |   77 +
 drivers/scsi/snic/snic_disc.c                                            |    3 
 drivers/soc/apple/rtkit.c                                                |    7 
 drivers/soc/apple/sart.c                                                 |    7 
 drivers/soc/mediatek/mtk-pm-domains.c                                    |    2 
 drivers/soc/qcom/apr.c                                                   |   15 
 drivers/soc/qcom/llcc-qcom.c                                             |    2 
 drivers/soc/sifive/sifive_ccache.c                                       |   33 
 drivers/soc/tegra/cbb/tegra194-cbb.c                                     |   14 
 drivers/soc/tegra/cbb/tegra234-cbb.c                                     |  170 ++
 drivers/soc/ti/knav_qmss_queue.c                                         |    3 
 drivers/soc/ti/smartreflex.c                                             |    1 
 drivers/spi/spi-fsl-spi.c                                                |   19 
 drivers/spi/spi-gpio.c                                                   |   16 
 drivers/spi/spidev.c                                                     |   21 
 drivers/staging/media/deprecated/stkwebcam/Kconfig                       |    2 
 drivers/staging/media/imx/imx7-media-csi.c                               |    6 
 drivers/staging/media/rkvdec/rkvdec-vp9.c                                |    3 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c                         |   25 
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h                         |    2 
 drivers/staging/r8188eu/core/rtw_pwrctrl.c                               |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                                     |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                        |    4 
 drivers/staging/vme_user/vme_fake.c                                      |    2 
 drivers/staging/vme_user/vme_tsi148.c                                    |    1 
 drivers/target/iscsi/iscsi_target_nego.c                                 |   12 
 drivers/thermal/imx8mm_thermal.c                                         |    8 
 drivers/thermal/k3_j72xx_bandgap.c                                       |    2 
 drivers/thermal/qcom/lmh.c                                               |    2 
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c                              |    3 
 drivers/thermal/thermal_core.c                                           |   18 
 drivers/thermal/thermal_helpers.c                                        |    7 
 drivers/thermal/thermal_of.c                                             |    8 
 drivers/tty/serial/8250/8250_bcm7271.c                                   |   10 
 drivers/tty/serial/altera_uart.c                                         |    5 
 drivers/tty/serial/amba-pl011.c                                          |   14 
 drivers/tty/serial/pch_uart.c                                            |    4 
 drivers/tty/serial/serial-tegra.c                                        |    6 
 drivers/tty/serial/stm32-usart.c                                         |   47 
 drivers/tty/serial/sunsab.c                                              |    8 
 drivers/ufs/core/ufshcd.c                                                |   37 
 drivers/uio/uio_dmem_genirq.c                                            |   13 
 drivers/usb/cdns3/cdnsp-ring.c                                           |   42 
 drivers/usb/core/hcd.c                                                   |    6 
 drivers/usb/dwc3/core.c                                                  |   23 
 drivers/usb/dwc3/dwc3-qcom.c                                             |   13 
 drivers/usb/gadget/function/f_hid.c                                      |   53 
 drivers/usb/gadget/udc/core.c                                            |   12 
 drivers/usb/gadget/udc/fotg210-udc.c                                     |   12 
 drivers/usb/host/xhci-mtk.c                                              |    1 
 drivers/usb/host/xhci-ring.c                                             |   14 
 drivers/usb/host/xhci.h                                                  |    2 
 drivers/usb/musb/musb_gadget.c                                           |    2 
 drivers/usb/musb/omap2430.c                                              |   54 
 drivers/usb/roles/class.c                                                |    5 
 drivers/usb/storage/alauda.c                                             |    2 
 drivers/usb/typec/bus.c                                                  |    2 
 drivers/usb/typec/tcpm/tcpci.c                                           |    5 
 drivers/usb/typec/tipd/core.c                                            |   11 
 drivers/usb/typec/wusb3801.c                                             |    2 
 drivers/vfio/iova_bitmap.c                                               |   32 
 drivers/vfio/platform/vfio_platform_common.c                             |    3 
 drivers/video/fbdev/Kconfig                                              |    2 
 drivers/video/fbdev/core/fbcon.c                                         |    3 
 drivers/video/fbdev/ep93xx-fb.c                                          |    4 
 drivers/video/fbdev/geode/Kconfig                                        |    1 
 drivers/video/fbdev/hyperv_fb.c                                          |    8 
 drivers/video/fbdev/pm2fb.c                                              |    9 
 drivers/video/fbdev/uvesafb.c                                            |    1 
 drivers/video/fbdev/vermilion/vermilion.c                                |    4 
 drivers/video/fbdev/via/via-core.c                                       |    9 
 drivers/virt/coco/sev-guest/sev-guest.c                                  |    1 
 drivers/watchdog/iTCO_wdt.c                                              |   21 
 drivers/xen/privcmd.c                                                    |    2 
 fs/afs/fs_probe.c                                                        |    5 
 fs/binfmt_misc.c                                                         |    8 
 fs/btrfs/extent-io-tree.c                                                |   22 
 fs/btrfs/file.c                                                          |   10 
 fs/char_dev.c                                                            |    2 
 fs/cifs/smb2file.c                                                       |    4 
 fs/configfs/dir.c                                                        |    2 
 fs/debugfs/file.c                                                        |   28 
 fs/erofs/fscache.c                                                       |   47 
 fs/erofs/internal.h                                                      |   10 
 fs/erofs/super.c                                                         |    2 
 fs/erofs/zdata.c                                                         |    3 
 fs/erofs/zmap.c                                                          |   11 
 fs/f2fs/compress.c                                                       |    2 
 fs/f2fs/f2fs.h                                                           |    2 
 fs/f2fs/file.c                                                           |    4 
 fs/f2fs/gc.c                                                             |   29 
 fs/f2fs/namei.c                                                          |  329 ++---
 fs/f2fs/segment.c                                                        |    8 
 fs/f2fs/super.c                                                          |    8 
 fs/gfs2/glock.c                                                          |    2 
 fs/hfs/inode.c                                                           |    2 
 fs/hfs/trans.c                                                           |    2 
 fs/hugetlbfs/inode.c                                                     |    6 
 fs/jfs/jfs_dmap.c                                                        |   27 
 fs/jfs/namei.c                                                           |    2 
 fs/ksmbd/mgmt/user_session.c                                             |    8 
 fs/libfs.c                                                               |   22 
 fs/lockd/svcsubs.c                                                       |   17 
 fs/nfs/fs_context.c                                                      |    6 
 fs/nfs/internal.h                                                        |    6 
 fs/nfs/namespace.c                                                       |    2 
 fs/nfs/nfs42xdr.c                                                        |    2 
 fs/nfs/nfs4proc.c                                                        |   38 
 fs/nfs/nfs4state.c                                                       |    2 
 fs/nfs/nfs4xdr.c                                                         |   22 
 fs/nfsd/nfs2acl.c                                                        |   10 
 fs/nfsd/nfs3acl.c                                                        |   30 
 fs/nfsd/nfs4callback.c                                                   |    4 
 fs/nfsd/nfs4proc.c                                                       |    7 
 fs/nfsd/nfs4state.c                                                      |   51 
 fs/nilfs2/the_nilfs.c                                                    |   73 +
 fs/ntfs3/bitmap.c                                                        |    2 
 fs/ntfs3/super.c                                                         |    2 
 fs/ntfs3/xattr.c                                                         |    2 
 fs/ocfs2/journal.c                                                       |    2 
 fs/ocfs2/journal.h                                                       |    1 
 fs/ocfs2/stackglue.c                                                     |    8 
 fs/ocfs2/super.c                                                         |    5 
 fs/orangefs/orangefs-debugfs.c                                           |   29 
 fs/orangefs/orangefs-mod.c                                               |    8 
 fs/orangefs/orangefs-sysfs.c                                             |   71 +
 fs/overlayfs/file.c                                                      |   28 
 fs/overlayfs/super.c                                                     |    7 
 fs/pstore/Kconfig                                                        |    1 
 fs/pstore/pmsg.c                                                         |    7 
 fs/pstore/ram.c                                                          |    2 
 fs/pstore/ram_core.c                                                     |    6 
 fs/reiserfs/namei.c                                                      |    4 
 fs/reiserfs/xattr_security.c                                             |    2 
 fs/sysv/itree.c                                                          |    2 
 fs/udf/namei.c                                                           |    8 
 fs/xattr.c                                                               |    2 
 include/drm/drm_connector.h                                              |    6 
 include/drm/ttm/ttm_tt.h                                                 |    2 
 include/dt-bindings/clock/imx8mn-clock.h                                 |   24 
 include/dt-bindings/clock/imx8mp-clock.h                                 |    3 
 include/linux/btf_ids.h                                                  |    2 
 include/linux/debugfs.h                                                  |   19 
 include/linux/eventfd.h                                                  |    2 
 include/linux/fortify-string.h                                           |    2 
 include/linux/fs.h                                                       |   12 
 include/linux/hisi_acc_qm.h                                              |    6 
 include/linux/hyperv.h                                                   |    2 
 include/linux/ieee80211.h                                                |    2 
 include/linux/iio/imu/adis.h                                             |   13 
 include/linux/netdevice.h                                                |   58 
 include/linux/proc_fs.h                                                  |    2 
 include/linux/regulator/driver.h                                         |    3 
 include/linux/skmsg.h                                                    |    1 
 include/linux/timerqueue.h                                               |    2 
 include/media/dvbdev.h                                                   |   32 
 include/net/bluetooth/hci.h                                              |   20 
 include/net/bluetooth/hci_core.h                                         |    7 
 include/net/dst.h                                                        |    5 
 include/net/ip_vs.h                                                      |   10 
 include/net/mrp.h                                                        |    1 
 include/net/sock_reuseport.h                                             |    2 
 include/net/tcp.h                                                        |    4 
 include/sound/hda_codec.h                                                |    1 
 include/sound/pcm.h                                                      |   36 
 include/trace/events/f2fs.h                                              |   34 
 include/trace/events/ib_mad.h                                            |   13 
 include/uapi/linux/idxd.h                                                |    2 
 include/uapi/linux/io_uring.h                                            |   18 
 include/uapi/linux/swab.h                                                |    2 
 include/uapi/rdma/hns-abi.h                                              |   15 
 include/uapi/sound/asequencer.h                                          |    8 
 io_uring/io_uring.c                                                      |    2 
 io_uring/msg_ring.c                                                      |    6 
 io_uring/net.c                                                           |    9 
 io_uring/notif.c                                                         |   12 
 io_uring/notif.h                                                         |    3 
 io_uring/opdef.c                                                         |    7 
 io_uring/opdef.h                                                         |    2 
 io_uring/timeout.c                                                       |    4 
 ipc/mqueue.c                                                             |    6 
 kernel/Makefile                                                          |    3 
 kernel/acct.c                                                            |    2 
 kernel/bpf/btf.c                                                         |    5 
 kernel/bpf/cgroup_iter.c                                                 |   14 
 kernel/bpf/syscall.c                                                     |    6 
 kernel/bpf/verifier.c                                                    |  120 +
 kernel/cpu.c                                                             |   60 
 kernel/events/core.c                                                     |    8 
 kernel/fork.c                                                            |   17 
 kernel/futex/core.c                                                      |   26 
 kernel/gcov/gcc_4_7.c                                                    |    5 
 kernel/irq/internals.h                                                   |    2 
 kernel/irq/irqdesc.c                                                     |   15 
 kernel/kprobes.c                                                         |   16 
 kernel/module/decompress.c                                               |    8 
 kernel/padata.c                                                          |   15 
 kernel/power/snapshot.c                                                  |    4 
 kernel/rcu/tree.c                                                        |    2 
 kernel/relay.c                                                           |    4 
 kernel/sched/core.c                                                      |   10 
 kernel/sched/fair.c                                                      |  223 +++
 kernel/sched/psi.c                                                       |    8 
 kernel/sched/sched.h                                                     |   51 
 kernel/trace/blktrace.c                                                  |    3 
 kernel/trace/trace_events_hist.c                                         |    2 
 kernel/trace/trace_events_user.c                                         |    1 
 lib/debugobjects.c                                                       |   10 
 lib/fonts/fonts.c                                                        |    4 
 lib/maple_tree.c                                                         |    4 
 lib/notifier-error-inject.c                                              |    2 
 lib/test_firmware.c                                                      |    1 
 lib/test_maple_tree.c                                                    |   23 
 mm/gup.c                                                                 |    3 
 net/802/mrp.c                                                            |   18 
 net/9p/client.c                                                          |    5 
 net/bluetooth/hci_conn.c                                                 |    2 
 net/bluetooth/hci_core.c                                                 |    4 
 net/bluetooth/hci_sync.c                                                 |    2 
 net/bluetooth/lib.c                                                      |    4 
 net/bluetooth/mgmt.c                                                     |    2 
 net/bluetooth/rfcomm/core.c                                              |    2 
 net/bpf/test_run.c                                                       |    3 
 net/core/dev.c                                                           |   14 
 net/core/devlink.c                                                       |    5 
 net/core/filter.c                                                        |   25 
 net/core/skbuff.c                                                        |    3 
 net/core/skmsg.c                                                         |    9 
 net/core/sock.c                                                          |    2 
 net/core/sock_map.c                                                      |    2 
 net/core/sock_reuseport.c                                                |   94 +
 net/core/stream.c                                                        |    6 
 net/dsa/tag_8021q.c                                                      |   11 
 net/ethtool/ioctl.c                                                      |    3 
 net/hsr/hsr_debugfs.c                                                    |   40 
 net/hsr/hsr_device.c                                                     |   32 
 net/hsr/hsr_forward.c                                                    |   14 
 net/hsr/hsr_framereg.c                                                   |  222 +--
 net/hsr/hsr_framereg.h                                                   |   17 
 net/hsr/hsr_main.h                                                       |    9 
 net/hsr/hsr_netlink.c                                                    |    4 
 net/ipv4/af_inet.c                                                       |    4 
 net/ipv4/inet_connection_sock.c                                          |    7 
 net/ipv4/ping.c                                                          |    2 
 net/ipv4/tcp_bpf.c                                                       |   19 
 net/ipv4/udp.c                                                           |   39 
 net/ipv4/udp_tunnel_core.c                                               |    1 
 net/ipv6/af_inet6.c                                                      |    4 
 net/ipv6/datagram.c                                                      |   15 
 net/ipv6/sit.c                                                           |   22 
 net/ipv6/udp.c                                                           |   12 
 net/mac80211/cfg.c                                                       |    2 
 net/mac80211/ieee80211_i.h                                               |    1 
 net/mac80211/iface.c                                                     |    1 
 net/mac80211/mlme.c                                                      |   15 
 net/mac80211/tx.c                                                        |    2 
 net/mctp/device.c                                                        |   14 
 net/netfilter/ipvs/ip_vs_core.c                                          |   30 
 net/netfilter/ipvs/ip_vs_ctl.c                                           |   10 
 net/netfilter/ipvs/ip_vs_est.c                                           |   20 
 net/netfilter/nf_conntrack_proto_icmpv6.c                                |   53 
 net/netfilter/nf_flow_table_offload.c                                    |    6 
 net/openvswitch/datapath.c                                               |   25 
 net/openvswitch/flow_netlink.c                                           |    2 
 net/rxrpc/output.c                                                       |    2 
 net/rxrpc/sendmsg.c                                                      |    2 
 net/sched/ematch.c                                                       |    2 
 net/sctp/sysctl.c                                                        |   73 -
 net/sunrpc/clnt.c                                                        |    2 
 net/sunrpc/xprtrdma/verbs.c                                              |    2 
 net/tls/tls_sw.c                                                         |    6 
 net/unix/af_unix.c                                                       |   12 
 net/vmw_vsock/vmci_transport.c                                           |    6 
 net/wireless/nl80211.c                                                   |    3 
 net/wireless/reg.c                                                       |    4 
 samples/bpf/xdp1_user.c                                                  |    2 
 samples/bpf/xdp2_kern.c                                                  |    4 
 samples/vfio-mdev/mdpy-fb.c                                              |    8 
 security/Kconfig.hardening                                               |    3 
 security/apparmor/apparmorfs.c                                           |    4 
 security/apparmor/label.c                                                |   12 
 security/apparmor/lsm.c                                                  |    4 
 security/apparmor/policy.c                                               |    2 
 security/apparmor/policy_ns.c                                            |    2 
 security/apparmor/policy_unpack.c                                        |    2 
 security/integrity/digsig.c                                              |    6 
 security/integrity/ima/ima_policy.c                                      |   51 
 security/integrity/ima/ima_template.c                                    |    4 
 security/loadpin/loadpin.c                                               |   30 
 sound/core/memalloc.c                                                    |   44 
 sound/core/pcm_native.c                                                  |    4 
 sound/drivers/mts64.c                                                    |    3 
 sound/pci/asihpi/hpioctl.c                                               |    2 
 sound/pci/hda/hda_codec.c                                                |    3 
 sound/pci/hda/patch_hdmi.c                                               |  120 +
 sound/pci/hda/patch_realtek.c                                            |   27 
 sound/soc/amd/acp/acp-platform.c                                         |    8 
 sound/soc/amd/yc/acp6x-mach.c                                            |    7 
 sound/soc/codecs/pcm512x.c                                               |    8 
 sound/soc/codecs/rt298.c                                                 |    7 
 sound/soc/codecs/rt5670.c                                                |    2 
 sound/soc/codecs/wm8994.c                                                |    5 
 sound/soc/codecs/wsa883x.c                                               |    6 
 sound/soc/generic/audio-graph-card.c                                     |    4 
 sound/soc/intel/Kconfig                                                  |    2 
 sound/soc/intel/avs/boards/rt298.c                                       |   24 
 sound/soc/intel/avs/core.c                                               |    2 
 sound/soc/intel/avs/ipc.c                                                |    6 
 sound/soc/intel/boards/sof_es8336.c                                      |    2 
 sound/soc/intel/skylake/skl.c                                            |    5 
 sound/soc/mediatek/common/mtk-btcvsd.c                                   |    6 
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c                               |   20 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                         |    7 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c               |   14 
 sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c                |    2 
 sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c                 |    2 
 sound/soc/pxa/mmp-pcm.c                                                  |    2 
 sound/soc/qcom/Kconfig                                                   |   16 
 sound/soc/qcom/common.c                                                  |    2 
 sound/soc/qcom/common.h                                                  |   23 
 sound/soc/qcom/lpass-sc7180.c                                            |    3 
 sound/soc/rockchip/rockchip_pdm.c                                        |    1 
 sound/soc/rockchip/rockchip_spdif.c                                      |    1 
 sound/usb/endpoint.c                                                     |    7 
 sound/usb/pcm.c                                                          |   13 
 sound/usb/quirks-table.h                                                 |    2 
 sound/usb/quirks.c                                                       |    2 
 sound/usb/usbaudio.h                                                     |    4 
 tools/bpf/bpftool/common.c                                               |    1 
 tools/lib/bpf/bpf.h                                                      |    7 
 tools/lib/bpf/btf.c                                                      |    8 
 tools/lib/bpf/btf_dump.c                                                 |   29 
 tools/lib/bpf/libbpf.c                                                   |   22 
 tools/lib/bpf/usdt.c                                                     |   11 
 tools/objtool/check.c                                                    |   10 
 tools/perf/Documentation/perf-annotate.txt                               |    2 
 tools/perf/Documentation/perf-diff.txt                                   |    2 
 tools/perf/Documentation/perf-lock.txt                                   |    2 
 tools/perf/Documentation/perf-probe.txt                                  |    2 
 tools/perf/Documentation/perf-record.txt                                 |    2 
 tools/perf/Documentation/perf-report.txt                                 |    2 
 tools/perf/Documentation/perf-stat.txt                                   |    4 
 tools/perf/bench/numa.c                                                  |    9 
 tools/perf/builtin-annotate.c                                            |    2 
 tools/perf/builtin-diff.c                                                |    2 
 tools/perf/builtin-lock.c                                                |    2 
 tools/perf/builtin-probe.c                                               |   22 
 tools/perf/builtin-record.c                                              |    2 
 tools/perf/builtin-report.c                                              |    2 
 tools/perf/builtin-stat.c                                                |   41 
 tools/perf/builtin-trace.c                                               |   32 
 tools/perf/tests/shell/stat_all_pmu.sh                                   |   13 
 tools/perf/ui/util.c                                                     |    5 
 tools/perf/util/bpf_off_cpu.c                                            |    2 
 tools/perf/util/branch.h                                                 |    3 
 tools/perf/util/debug.c                                                  |    4 
 tools/perf/util/stat-display.c                                           |   33 
 tools/perf/util/stat.h                                                   |    1 
 tools/perf/util/symbol-elf.c                                             |    2 
 tools/testing/selftests/bpf/config                                       |    1 
 tools/testing/selftests/bpf/network_helpers.c                            |    4 
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c                        |   11 
 tools/testing/selftests/bpf/prog_tests/empty_skb.c                       |  146 ++
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c               |   26 
 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c                      |   17 
 tools/testing/selftests/bpf/prog_tests/map_kptr.c                        |    3 
 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c                 |    4 
 tools/testing/selftests/bpf/prog_tests/tracing_struct.c                  |    3 
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c                 |    7 
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c                 |    2 
 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c                    |    2 
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c                        |    6 
 tools/testing/selftests/bpf/progs/empty_skb.c                            |   37 
 tools/testing/selftests/bpf/progs/lsm_cgroup.c                           |    8 
 tools/testing/selftests/bpf/test_bpftool_metadata.sh                     |    7 
 tools/testing/selftests/bpf/test_flow_dissector.sh                       |    6 
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh                         |   17 
 tools/testing/selftests/bpf/test_lwt_seg6local.sh                        |    9 
 tools/testing/selftests/bpf/test_tc_edt.sh                               |    3 
 tools/testing/selftests/bpf/test_tc_tunnel.sh                            |    5 
 tools/testing/selftests/bpf/test_tunnel.sh                               |    5 
 tools/testing/selftests/bpf/test_xdp_meta.sh                             |    9 
 tools/testing/selftests/bpf/test_xdp_vlan.sh                             |    8 
 tools/testing/selftests/bpf/xdp_synproxy.c                               |    5 
 tools/testing/selftests/cgroup/cgroup_util.c                             |    5 
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh                 |    4 
 tools/testing/selftests/efivarfs/efivarfs.sh                             |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc      |   15 
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh              |   36 
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c                   |    5 
 tools/testing/selftests/proc/proc-uptime-002.c                           |    3 
 1088 files changed, 12888 insertions(+), 6320 deletions(-)

Aakarsh Jain (1):
      media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Abdun Nihaal (1):
      fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs

Abhinav Kumar (1):
      drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

Aditya Kumar Singh (1):
      wifi: ath11k: fix firmware assert during bandwidth change for peer sta

Adriana Kobylak (1):
      ARM: dts: aspeed: rainier,everest: Move reserved memory regions

Ajay Kaher (1):
      perf symbol: correction while adjusting symbol

Akinobu Mita (3):
      libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
      lib/notifier-error-inject: fix error when writing -errno to debugfs file
      debugfs: fix error when writing negative value to atomic_t debugfs file

Al Cooper (1):
      phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Al Viro (2):
      alpha: fix TIF_NOTIFY_SIGNAL handling
      alpha: fix syscall entry in !AUDUT_SYSCALL case

Alan Maguire (1):
      libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Alan Previn (2):
      drm/i915/guc: Add error-capture init warnings when needed
      drm/i915/guc: Fix GuC error capture sizing estimation and reporting

Alexander Stein (1):
      rtc: pcf85063: Fix reading alarm

Alexander Sverdlin (1):
      spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE

Alexandre Belloni (1):
      rtc: pcf85063: fix pcf85063_clkout_control

Alexandre Ghiti (1):
      riscv: Fix P4D_SHIFT definition for 3-level page table mode

Alexandru Tachici (1):
      net: ethernet: adi: adin1110: Fix SPI transfers

Alexey Dobriyan (1):
      proc: fixup uptime selftest

Alexey Izbyshev (1):
      futex: Resend potentially swallowed owner death notification

Allen-KH Cheng (1):
      mtd: spi-nor: Fix the number of bytes for the dummy cycles

Alvin Lee (2):
      drm/amd/display: Use min transition for SubVP into MPO
      drm/amd/display: Fix DTBCLK disable requests and SRC_SEL programming

Amadeusz Sławiński (2):
      ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
      ASoC: Intel: avs: Add quirk for KBL-R RVP platform

Amir Goldstein (2):
      ovl: remove privs in ovl_copyfile()
      ovl: remove privs in ovl_fallocate()

Anastasia Belova (1):
      MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Andreas Gruenbacher (1):
      gfs2: Partially revert gfs2_inode_lookup change

Andrew Bresticker (1):
      RISC-V: Fix unannoted hardirqs-on in return to userspace slow-path

Andrew Jeffery (1):
      ipmi: kcs: Poll OBF briefly to reduce OBE latency

Andrii Nakryiko (3):
      bpf: propagate precision in ALU/ALU64 operations
      bpf: propagate precision across all frames, not just the last one
      libbpf: Avoid enum forward-declarations in public API in C++ mode

Andrzej Pietrasiewicz (1):
      media: rkvdec: Add required padding

Andy Shevchenko (1):
      fbdev: ssd1307fb: Drop optional dependency

AngeloGioacchino Del Regno (9):
      arm64: dts: mediatek: mt8195: Fix CPUs capacity-dmips-mhz
      arm64: dts: mt7896a: Fix unit_address_vs_reg warning for oscillator
      arm64: dts: mt6779: Fix devicetree build warnings
      arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators
      arm64: dts: mt2712e: Fix unit address for pinctrl node
      arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
      arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
      arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
      arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name

Anna Schumaker (2):
      NFSv4.2: Set the correct size scratch buffer for decoding READ_PLUS
      NFS: Allow very small rsize & wsize again

Anshuman Gupta (2):
      drm/i915: Encapsulate lmem rpm stuff in intel_runtime_pm
      drm/i915/dgfx: Grab wakeref at i915_ttm_unmap_virtual

Anssi Hannula (4):
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Fix bogus restart events

Anup Patel (2):
      RISC-V: Fix MEMREMAP_WB for systems with Svpbmt
      RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()

Ard Biesheuvel (1):
      ftrace: Allow WITH_ARGS flavour of graph tracer with shadow call stack

Arnd Bergmann (2):
      RDMA/siw: Fix pointer cast warning
      drm/amd/pm: avoid large variable on kernel stack

Artem Chernyshev (1):
      net: vmw_vsock: vmci: Check memcpy_from_msg()

Artem Lukyanov (1):
      ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table

Arun Easi (1):
      scsi: qla2xxx: Fix crash when I/O abort times out

Arun Ramadoss (1):
      net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq

Asher Song (1):
      drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"

Aurabindo Pillai (1):
      drm/amd/display: fix array index out of bound error in bios parser

Avraham Stern (2):
      wifi: iwlwifi: mei: make sure ownership confirmed message is sent
      wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock

Baisong Zhong (3):
      ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
      ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
      media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Barnabás Pőcze (2):
      platform/x86: huawei-wmi: fix return value calculation
      timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Bart Van Assche (4):
      scsi: core: Fix a race between scsi_done() and scsi_timeout()
      scsi: qla2xxx: Fix set-but-not-used variable warnings
      scsi: ufs: core: Fix the polling implementation
      scsi: ufs: Reduce the START STOP UNIT timeout

Bartosz Golaszewski (2):
      gpiolib: cdev: fix NULL-pointer dereferences
      gpiolib: protect the GPIO device against being dropped while in use by user-space

Bartosz Staszewski (1):
      i40e: Fix the inability to attach XDP program on downed interface

Bastien Nocera (1):
      HID: logitech-hidpp: Guard FF init code against non-USB devices

Beau Belgrave (1):
      tracing/user_events: Fix call print_fmt leak

Ben Greear (1):
      wifi: iwlwifi: mvm: fix double free on tx path.

Bernard Metzler (2):
      RDMA/siw: Fix immediate work request flush to completion queue
      RDMA/siw: Set defined status for work completion with undefined status

Bitterblue Smith (4):
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
      wifi: rtl8xxxu: Fix the channel width reporting

Bjorn Andersson (1):
      thermal/drivers/qcom/lmh: Fix irq handler return value

Bjorn Helgaas (1):
      Revert "PCI: Clear PCI_STATUS when setting up device"

Björn Töpel (1):
      bpf: Do not zero-extend kfunc return values

Brian Foster (1):
      NFSD: pass range end to vfs_fsync_range() instead of count

Brian Starkey (1):
      drm/fourcc: Fix vsub/hsub for Q410 and Q401

Bryan O'Donoghue (1):
      dt-bindings: mfd: qcom,spmi-pmic: Drop PWM reg dependency

Cai Xinchen (1):
      rapidio: devices: fix missing put_device in mport_cdev_open

Cezary Rojewski (4):
      ASoC: Intel: avs: Fix DMA mask assignment
      ASoC: Intel: avs: Fix potential RX buffer overflow
      ASoC: Intel: avs: Lock substream before snd_pcm_stop()
      ASoC: Intel: Skylake: Fix driver hang during shutdown

Chao Yu (3):
      f2fs: fix to invalidate dcc->f2fs_issue_discard in error path
      f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()
      f2fs: fix to avoid accessing uninitialized spinlock

Chen Hui (1):
      cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Chen Jiahao (1):
      drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Chen Zhongjin (12):
      perf: Fix possible memleak in pmu_dev_alloc()
      erofs: Fix pcluster memleak when its block address is zero
      fs: sysv: Fix sysv_nblocks() returns wrong value
      media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
      media: vimc: Fix wrong function called when vimc_init() fails
      media: dvb-core: Fix ignored return value in dvb_register_frontend()
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
      configfs: fix possible memory leak in configfs_create_dir()
      scsi: efct: Fix possible memleak in efct_device_init()
      scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
      vme: Fix error not catched in fake_init()
      ovl: fix use inode directly in rcu-walk mode

Chen-Yu Tsai (1):
      arm64: dts: mt8183: Fix Mali GPU clock

Chengchang Tang (5):
      RDMA/hns: Fix AH attr queried by query_qp
      RDMA/hns: Fix PBL page MTR find
      RDMA/hns: Fix page size cap from firmware
      RDMA/hns: Fix error code of CMD
      RDMA/hns: Fix XRC caps on HIP08

ChiYuan Huang (2):
      regulator: core: Use different devices for resource allocation and DT lookup
      regulator: core: Fix resolve supply lookup issue

Christian Marangi (2):
      clk: qcom: clk-krait: fix wrong div2 functions
      phy: qcom-qmp-pcie: split pcs_misc init cfg for ipq8074 pcs table

Christoph Böhmwalder (1):
      drbd: use blk_queue_max_discard_sectors helper

Christoph Hellwig (7):
      nvmet: only allocate a single slab for bvecs
      block: clear ->slave_dir when dropping the main slave_dir reference
      dm: cleanup open_table_device
      dm: cleanup close_table_device
      dm: track per-add_disk holder relations in DM
      media: videobuf-dma-contig: use dma_mmap_coherent
      nvme: pass nr_maps explicitly to nvme_alloc_io_tag_set

Christophe JAILLET (9):
      wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
      Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
      octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions
      crypto: amlogic - Remove kcalloc without check
      fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
      powerpc/52xx: Fix a resource leak in an error handling path
      mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()
      myri10ge: Fix an error handling path in myri10ge_probe()
      mfd: qcom_rpm: Use devm_of_platform_populate() to simplify code

Christophe Leroy (1):
      spi: fsl_spi: Don't change speed while chipselect is active

Chuck Lever (2):
      NFSD: Finish converting the NFSv2 GETACL result encoder
      NFSD: Finish converting the NFSv3 GETACL result encoder

Chun-Jie Chen (1):
      soc: mediatek: pm-domains: Fix the power glitch issue

Chunfeng Yun (1):
      usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

Cole Robinson (1):
      virt/sev-guest: Add a MODULE_ALIAS

Cong Dang (1):
      memory: renesas-rpc-if: Clear HS bit during hardware initialization

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Conor Dooley (5):
      riscv: dts: microchip: fix memory node unit address for icicle
      dt-bindings: pwm: fix microchip corePWM's pwm-cells
      riscv: dts: microchip: fix the icicle's #pwm-cells
      riscv: dts: microchip: remove pcie node from the sev kit
      mailbox: mpfs: read the system controller's status

Corentin Labbe (8):
      crypto: sun8i-ss - use dma_addr instead u32
      crypto: rockchip - do not do custom power management
      crypto: rockchip - do not store mode globally
      crypto: rockchip - add fallback for cipher
      crypto: rockchip - add fallback for ahash
      crypto: rockchip - better handle cipher key
      crypto: rockchip - remove non-aligned handling
      crypto: rockchip - rework by using crypto_engine

Cosmin Tanislav (1):
      iio: temperature: ltc2983: make bulk write buffer DMA-safe

Dan Aloni (1):
      nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter (5):
      amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
      bonding: uninitialized variable in bond_miimon_inspect()
      staging: rtl8192u: Fix use after free in ieee80211_rx()
      fs/ntfs3: Harden against integer overflows
      iommu/mediatek: Fix forever loop in error handling

Daniel Golle (2):
      clk: mediatek: fix dependency of MT7986 ADC clocks
      pwm: mediatek: always use bus clock for PWM on MT7622

Daniel Jordan (2):
      padata: Always leave BHs disabled when running ->parallel()
      padata: Fix list iterator in padata_do_serial()

Dario Binacchi (5):
      clk: imx8mn: rename vpu_pll to m7_alt_pll
      clk: imx: replace osc_hdmi with dummy
      clk: imx: rename video_pll1 to video_pll
      clk: imx8mn: fix imx8mn_sai2_sels clocks list
      clk: imx8mn: fix imx8mn_enet_phy_sels clocks list

David Hildenbrand (1):
      mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings

David Howells (4):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      afs: Fix lost servers_outstanding count

David Jeffery (1):
      blk-mq: avoid double ->queue_rq() because of early timeout

Denis Pauk (1):
      hwmon: (nct6775) add ASUS CROSSHAIR VIII/TUF/ProArt B550M

Deren Wu (3):
      wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
      wifi: mt76: mt7921: Add missing __packed annotation of struct mt7921_clc
      wifi: mt76: do not send firmware FW_FEATURE_NON_DL region

Dmitry Baryshkov (11):
      arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables
      arm64: dts: qcom: msm8996: fix GPU OPP table
      drm/msm/mdp5: stop overriding drvdata
      drm/msm/hdmi: use devres helper for runtime PM management
      clk: qcom: gcc-ipq806x: use parent_data for the last remaining entry
      drm/msm/mdp5: fix reading hw revision on db410c platform
      led: qcom-lpg: Fix sleeping in atomic
      phy: qcom-qmp-usb: correct registers layout for IPQ8074 USB3 PHY
      phy: qcom-qmp-pcie: split register tables into common and extra parts
      phy: qcom-qmp-pcie: support separate tables for EP mode
      phy: qcom-qmp-pcie: Support SM8450 PCIe1 PHY in EP mode

Dmitry Torokhov (7):
      MIPS: DTS: CI20: fix reset line polarity of the ethernet controller
      arm64: dts: qcom: msm8996: fix sound card reset line polarity
      arm64: dts: qcom: sm8250-mtp: fix reset line polarity
      arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 3.0/3.1
      arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 1.0/2.0
      HID: i2c: let RMI devices decide what constitutes wakeup event
      ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Dongdong Zhang (1):
      f2fs: fix normal discard process

Dongliang Mu (1):
      fs: jfs: fix shift-out-of-bounds in dbAllocAG

Doug Brown (2):
      ARM: mmp: fix timer_read delay
      drm/etnaviv: add missing quirks for GC300

Douglas Anderson (3):
      Input: elants_i2c - properly handle the reset GPIO when power is off
      clk: qcom: lpass-sc7280: Fix pm_runtime usage
      clk: qcom: lpass-sc7180: Fix pm_runtime usage

Dr. David Alan Gilbert (1):
      jfs: Fix fortify moan in symlink

Dragos Tatulea (1):
      IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Duoming Zhou (1):
      drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_timeout_handler

Eddie James (2):
      tpm: tis_i2c: Fix sanity check interrupt enable mask
      tpm: Add flag to use default cancellation policy

Edward Pacman (1):
      ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Emeel Hakim (1):
      net: macsec: fix net device access prior to holding a lock

Emmanuel Grumbach (2):
      wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled
      wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API

Enrik Berkhan (1):
      HID: mcp2221: don't connect hidraw

Eric Biggers (8):
      crypto: x86/aegis128 - fix possible crash with CFI enabled
      crypto: x86/aria - fix crash with CFI enabled
      crypto: x86/sha1 - fix possible crash with CFI enabled
      crypto: x86/sha256 - fix possible crash with CFI enabled
      crypto: x86/sha512 - fix possible crash with CFI enabled
      crypto: x86/sm3 - fix possible crash with CFI enabled
      crypto: x86/sm4 - fix crash with CFI enabled
      crypto: arm64/sm3 - fix possible crash with CFI enabled

Eric Dumazet (4):
      bpf, sockmap: fix race in sock_map_free()
      net: stream: purge sk_error_queue in sk_stream_kill_queues()
      net: add atomic_long_t to net_device_stats fields
      ipv6/sit: use DEV_STATS_INC() to avoid data-races

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Fabrice Gasnier (1):
      counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Fabrizio Castro (2):
      arm64: dts: renesas: r9a09g011: Fix unit address format error
      arm64: dts: renesas: r9a09g011: Fix I2C SoC specific strings

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full

Fenghua Yu (1):
      dmaengine: idxd: Fix crc_val field for completion record

Ferry Toth (1):
      usb: dwc3: core: defer probe on ulpi_read_id timeout

Filipe Manana (1):
      btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range

Firo Yang (1):
      sctp: sysctl: make extra pointers netns aware

Florian Westphal (1):
      netfilter: conntrack: set icmpv6 redirects as RELATED

Francisco Munoz (1):
      PCI: vmd: Fix secondary bus reset for Intel bridges

Frank Li (1):
      PCI: endpoint: pci-epf-vntb: Fix call pci_epc_mem_free_addr() in error path

Frank Wunderlich (3):
      arm64: dts: mt7986: fix trng node name
      arm64: dts: mt7986: move wed_pcie node
      dt-bindings: pinctrl: update uart/mmc bindings for MT7986 SoC

GUO Zihua (4):
      ima: Handle -ESTALE returned by ima_filter_rule_match()
      integrity: Fix memory leakage in keyring allocation error path
      rtc: mxc_v2: Add missing clk_disable_unprepare()
      ima: Simplify ima_lsm_copy_rule

Gabriel Somlo (2):
      mmc: litex_mmc: ensure `host->irq == 0` if polling
      serial: altera_uart: fix locking in polling mode

Gao Xiang (2):
      erofs: fix missing unmap if z_erofs_get_extent_compressedlen() fails
      erofs: validate the extent length for uncompressed pclusters

Gaosheng Cui (17):
      lib/fonts: fix undefined behavior in bit shift for get_default_font
      drm/ttm: fix undefined behavior in bit shift for TTM_TT_FLAG_PRIV_POPULATED
      mtd: core: fix possible resource leak in init_mtd()
      ASoC: amd: acp: Fix possible UAF in acp_dma_open
      ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
      pinctrl: thunderbay: fix possible memory leak in thunderbay_build_functions()
      net: stmmac: fix possible memory leak in stmmac_dvr_probe()
      apparmor: fix a memleak in multi_transaction_new()
      crypto: ccree - Remove debugfs when platform_driver_register failed
      scsi: snic: Fix possible UAF in snic_tgt_create()
      crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
      staging: vme_user: Fix possible UAF in tsi148_dma_list_add
      fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()
      remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
      rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
      rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
      net: stmmac: fix errno when create_singlethread_workqueue() fails

Gaurav Kohli (1):
      x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Gautam Menghani (1):
      media: imon: fix a race condition in send_packet()

Gavrilov Ilia (1):
      relay: fix type mismatch when allocating memory in relay_create_buf()

Geert Uytterhoeven (3):
      arm64: dts: renesas: r8a779g0: Fix HSCIF0 "brg_int" clock
      clk: renesas: r8a779f0: Fix SD0H clock name
      media: staging: stkwebcam: Restore MEDIA_{USB,CAMERA}_SUPPORT dependencies

George Shen (1):
      drm/amd/display: Workaround to increase phantom pipe vactive in pipesplit

Georgi Vlaev (1):
      firmware: ti_sci: Fix polled mode during system suspend

Gerhard Engleder (2):
      samples/bpf: Fix map iteration in xdp1_user
      samples/bpf: Fix MAC address swapping in xdp2_kern

Giulio Benetti (1):
      clk: imx: imxrt1050: fix IMXRT1050_CLK_LCDIF_APB offsets

Greg Kroah-Hartman (1):
      Linux 6.1.2

Guchun Chen (1):
      drm/amd/pm/smu11: BACO is supported when it's in BACO state

Guenter Roeck (2):
      iommu/mediatek: Validate number of phandles associated with "mediatek,larbs"
      thermal/core: Ensure that thermal device is registered in thermal_zone_get_temp

Guilherme G. Piccoli (2):
      x86/split_lock: Add sysctl to control the misery mode
      video: hyperv_fb: Avoid taking busy spinlock on panic path

Guoniu.zhou (1):
      media: ov5640: set correct default link frequency

Gustavo A. R. Silva (1):
      powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Haibo Chen (1):
      clk: imx93: correct the flexspi1 clock setting

Haiyi Zhou (1):
      drm/amd/display: wait for vblank during pipe programming

Hamza Mahfooz (2):
      drm/edid: add a quirk for two LG monitors to get them to work on 10bpc
      Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"

Hangbin Liu (3):
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock
      bonding: add missed __rcu annotation for curr_active_slave
      bonding: do failover when high prio link up

Hanjun Guo (1):
      drm/radeon: Add the missed acpi_put_table() to fix memory leak

Hans Verkuil (1):
      media: v4l2-ctrls-api.c: add back dropped ctrl->is_new = 1

Hans de Goede (8):
      power: supply: bq25890: Ensure pump_express_work is cancelled on remove
      ACPI: video: Change GIGABYTE GB-BXBT-2807 quirk to force_none
      ACPI: video: Change Sony Vaio VPCEH3U1E quirk to force_native
      ACPI: video: Add force_vendor quirk for Sony Vaio PCG-FRV35
      ACPI: video: Add force_native quirk for Sony Vaio VPCY11S1E
      ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X90F)
      ACPI: x86: Add skip i2c clients quirk for Medion Lifetab S10346
      ASoC: rt5670: Remove unbalanced pm_runtime_put()

Hao Lee (1):
      sched/psi: Fix possible missing or delayed pending event

Harshit Mogalapalli (4):
      xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
      scsi: scsi_debug: Fix a warning in resp_write_scat()
      scsi: scsi_debug: Fix a warning in resp_verify()
      scsi: scsi_debug: Fix a warning in resp_report_zones()

Hawkins Jiawei (2):
      nfs: fix possible null-ptr-deref when parsing param
      hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()

Herbert Xu (1):
      crypto: cryptd - Use request context instead of stack for sub-request

Hoi Pok Wu (1):
      fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Hou Tao (2):
      erofs: check the uniqueness of fsid in shared domain in advance
      bpf: Pin the start cgroup in cgroup_iter_seq_init()

Hui Tang (3):
      mtd: lpddr2_nvm: Fix possible null-ptr-deref
      clk: microchip: check for null return of devm_kzalloc()
      i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Huisong Li (1):
      mailbox: pcc: Reset pcc_chan_count to zero in case of PCC probe failure

Ido Schimmel (1):
      thermal/of: Fix memory leak on thermal_of_zone_register() failure

Ilya Bakoulin (1):
      drm/amd/display: Fix display corruption w/ VSR enable

Inga Stotland (1):
      Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Isaac J. Manjarres (1):
      loop: Fix the max_loop commandline argument treatment when it is set to 0

Ivaylo Dimitrov (1):
      usb: musb: remove extra check in musb_gadget_vbus_draw

Jacob Keller (1):
      ice: synchronize the misc IRQ when tearing down Tx tracker

Jaegeuk Kim (1):
      f2fs: allow to set compression for inlined file

Jakub Kicinski (3):
      devlink: hold region lock when flushing snapshots
      selftests: devlink: fix the fd redirect in dummy_reporter_test
      devlink: protect devlink dump by the instance lock

James Clark (3):
      perf tools: Fix "kernel lock contention analysis" test by not printing warnings in quiet mode
      perf branch: Fix interpretation of branch records
      perf tools: Make quiet mode consistent between tools

James Hilliard (1):
      selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym

James Hurley (1):
      platform/mellanox: mlxbf-pmc: Fix event typo

Jani Nikula (1):
      drm/i915/guc: make default_lists const data

Janne Grunau (1):
      arch: arm64: apple: t8103: Use standard "iommu" node name

Jason Gerecke (1):
      HID: wacom: Ensure bootloader PID is usable in hidraw mode

Jason Gunthorpe (1):
      iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Jayesh Choudhary (3):
      arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
      arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node
      arm64: dts: ti: k3-j7200-mcu-wakeup: Drop dma-coherent in crypto node

Jeff LaBundy (7):
      Input: iqs7222 - protect against undefined slider size
      Input: iqs7222 - drop unused device node references
      Input: iqs7222 - report malformed properties
      Input: iqs7222 - add support for IQS7222A v1.13+
      dt-bindings: input: iqs7222: Reduce 'linux,code' to optional
      dt-bindings: input: iqs7222: Correct minimum slider size
      dt-bindings: input: iqs7222: Add support for IQS7222A v1.13+

Jeff Layton (2):
      nfsd: don't call nfsd_file_put from client states seqfile display
      nfsd: return error if nfs4_setacl fails

Jens Axboe (1):
      io_uring/net: ensure compat import handlers clear free_iov

Jeremy Kerr (1):
      mctp: serial: Fix starting value for frame check sequence

Jernej Skrabec (7):
      media: v4l2-ioctl.c: Unify YCbCr/YUV terms in format descriptions
      media: cedrus: hevc: Fix offset adjustments
      iommu/sun50i: Fix reset release
      iommu/sun50i: Consider all fault sources for reset
      iommu/sun50i: Fix R/W permission check
      iommu/sun50i: Fix flush size
      iommu/sun50i: Implement .iotlb_sync_map

Jerry Ray (1):
      net: lan9303: Fix read error execution path

Jiamei Xie (1):
      serial: amba-pl011: avoid SBSA UART accessing DMACR register

Jiang Li (1):
      md/raid1: stop mdx_raid1 thread when raid1 array run failed

Jianmin Lv (1):
      irqchip/loongson-pch-pic: Fix translate callback for DT path

Jiantao Zhang (1):
      USB: gadget: Fix use-after-free during usb config switch

Jiao Zhou (1):
      ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Jiasheng Jiang (8):
      soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index
      media: coda: jpeg: Add check for kmalloc
      ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd
      memstick/ms_block: Add check for alloc_ordered_workqueue
      media: coda: Add check for dcoda_iram_alloc
      media: coda: Add check for kmalloc
      usb: storage: Add check for kcalloc
      HID: amd_sfh: Add missing check for dma_alloc_coherent

Jiaxin Yu (1):
      ASoC: mediatek: mt8186: Correct I2S shared clocks

Jimmy Assarsson (5):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jiri Olsa (1):
      selftests/bpf: Add missing bpf_iter_vma_offset__destroy call

Jiri Slaby (SUSE) (1):
      qed (gcc13): use u16 for fid to be big enough

Jisoo Jang (1):
      wifi: brcmfmac: Fix potential NULL pointer dereference in 'brcmf_c_preinit_dcmds()'

Joao Martins (2):
      vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
      vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries

Joel Granados (1):
      nvme: return err on nvme_init_non_mdts_limits fail

Johan Hovold (21):
      arm64: dts: qcom: sm8150: fix UFS PHY registers
      arm64: dts: qcom: sm8250: fix UFS PHY registers
      arm64: dts: qcom: sm8350: fix UFS PHY registers
      arm64: dts: qcom: sm8450: fix UFS PHY registers
      arm64: dts: qcom: sm8250: drop bogus DP PHY clock
      arm64: dts: qcom: sm6350: drop bogus DP PHY clock
      phy: qcom-qmp-pcie: drop bogus register update
      phy: qcom-qmp-pcie: drop power-down delay config
      phy: qcom-qmp-pcie: replace power-down delay
      phy: qcom-qmp-pcie: fix sc8180x initialisation
      phy: qcom-qmp-pcie: fix ipq8074-gen3 initialisation
      phy: qcom-qmp-pcie: fix ipq6018 initialisation
      phy: qcom-qmp-usb: clean up power-down handling
      phy: qcom-qmp-usb: drop sc8280xp power-down delay
      phy: qcom-qmp-usb: drop power-down delay config
      phy: qcom-qmp-usb: clean up status polling
      phy: qcom-qmp-usb: drop start and pwrdn-ctrl abstraction
      phy: qcom-qmp-usb: fix sc8280xp PCS_USB offset
      arm64: dts: qcom: sm6350: fix USB-DP PHY registers
      arm64: dts: qcom: sm8250: fix USB-DP PHY registers
      regulator: core: fix deadlock on regulator enable

Johannes Berg (5):
      wifi: fix multi-link element subelement iteration
      wifi: mac80211: mlme: fix null-ptr deref on failed assoc
      wifi: mac80211: check link ID in auth/assoc continuation
      wifi: mac80211: fix ifdef symbol name
      wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone

John Harrison (2):
      drm/i915/guc: Limit scheduling properties to avoid overflow
      drm/i915: Fix compute pre-emption w/a to apply to compute engines

John Johansen (3):
      apparmor: fix lockdep warning when removing a namespace
      apparmor: Fix abi check to include v8 abi
      apparmor: Fix regression in stacking due to label flags

John Keeping (3):
      usb: gadget: f_hid: fix f_hidg lifetime vs cdev
      usb: gadget: f_hid: fix refcount leak on error path
      ALSA: usb-audio: Add quirk for Tascam Model 12

John Stultz (2):
      pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
      pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

Jon Hunter (2):
      pwm: tegra: Improve required rate calculation
      pwm: tegra: Ensure the clock rate is not less than needed

Jonathan Neuschäfer (2):
      ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nodes
      spi: Update reference to struct spi_controller

Jonathan Toppins (1):
      bonding: fix link recovery in mode 2 when updelay is nonzero

Josef Bacik (1):
      btrfs: do not panic if we can't allocate a prealloc extent state

José Expósito (2):
      HID: input: do not query XP-PEN Deco LW battery
      HID: uclogic: Add support for XP-PEN Deco LW

Juergen Gross (1):
      x86/boot: Skip realmode init code when running as Xen PV guest

Julian Anastasov (1):
      ipvs: use u64_stats_t for the per-cpu counters

Justin Chen (2):
      phy: usb: Use slow clock for wake enabled suspend
      phy: usb: Fix clock imbalance for suspend/resume

Justin Tee (1):
      scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs

Kai Vehmanen (3):
      ALSA: hda/hdmi: fix i915 silent stream programming flow
      ALSA: hda/hdmi: set default audio parameters for KAE silent-stream
      ALSA: hda/hdmi: fix stream-id config keep-alive for rt suspend

Kai Ye (1):
      crypto: hisilicon/qm - increase the memory of local variables

Kajol Jain (1):
      powerpc/hv-gpci: Fix hv_gpci event list

Kartik (1):
      serial: tegra: Read DMA status before terminating

Keerthy (2):
      arm64: dts: ti: k3-j721s2: Fix the interrupt ranges property for main & wkup gpio intr
      thermal/drivers/k3_j72xx_bandgap: Fix the debug print message

Kees Cook (6):
      fortify: Do not cast to "unsigned char"
      openvswitch: Use kmalloc_size_roundup() to match ksize() usage
      bnx2: Use kmalloc_size_roundup() to match ksize() usage
      igb: Do not free q_vector unless new one was allocated
      bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage
      LoadPin: Ignore the "contents" argument of the LSM hooks

Kerem Karabay (2):
      HID: apple: fix key translations where multiple quirks attempt to translate the same key
      HID: apple: enable APPLE_ISO_TILDE_QUIRK for the keyboards of Macs with the T2 chip

Khaled Almahallawy (1):
      drm/i915/display: Don't disable DDI/Transcoder when setting phy test pattern

Khazhismel Kumykov (1):
      bfq: fix waker_bfqq inconsistency crash

Kirill Tkhai (1):
      unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

Konrad Dybcio (2):
      clk: qcom: dispcc-sm6350: Add CLK_OPS_PARENT_ENABLE to pixel&byte src
      regulator: qcom-rpmh: Fix PMR735a S3 regulator spec

Konstantin Meskhidze (1):
      drm/amdkfd: Fix memory leakage

Kory Maincent (1):
      arm: dts: spear600: Fix clcd interrupt

Kris Bahnsen (1):
      spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Kristina Martsenko (1):
      lkdtm: cfi: Make PAC test work with GCC 7 and 8

Krzysztof Kozlowski (11):
      arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins
      arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable
      arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name
      arm64: dts: qcom: sdm630: fix UART1 pin bias
      arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
      arm64: dts: qcom: sm8250: correct LPASS pin pull down
      arm64: dts: qcom: sc7180-trogdor-homestar: fully configure secondary I2S pins
      arm64: dts: qcom: sm6125: fix SDHCI CQE reg names
      ASoC: codecs: wsa883x: Use proper shutdown GPIO polarity
      interconnect: qcom: sc7180: fix dropped const of qcom_icc_bcm
      arm64: dts: qcom: sm8450: disable SDHCI SDR104/SDR50 on all boards

Kumar Kartikeya Dwivedi (2):
      bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
      bpf: Fix slot type check in check_stack_write_var_off

Kumar Meiyappan (1):
      scsi: smartpqi: Correct device removal for multi-actuator devices

Kunihiko Hayashi (2):
      PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled
      mmc: f-sdh30: Add quirks for broken timeout clock capability

Kuniyuki Iwashima (4):
      seccomp: Move copy_seccomp() to no failure path.
      soreuseport: Fix socket selection for SO_INCOMING_CPU.
      udp: Clean up some functions.
      net: Return errno in sk->sk_prot->get_port().

Ladislav Michl (1):
      MIPS: OCTEON: warn only once if deprecated link status is being used

Laurent Pinchart (4):
      drm: lcdif: Switch to limited range for RGB to YUV conversion
      media: v4l2-ctrls: Fix off-by-one error in integer menu control check
      drm: rcar-du: Drop leftovers dependencies from Kconfig
      media: imx: imx7-media-csi: Clear BIT_MIPI_DOUBLE_CMPNT for <16b formats

Leo Yan (3):
      perf trace: Return error if a system call doesn't exist
      perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
      perf trace: Handle failure when trace point folder is missed

Leon Romanovsky (1):
      RDMA/core: Fix order of nldev_exit call

Leonid Ravich (1):
      IB/mad: Don't call to function that might sleep while in atomic context

Li Huafei (1):
      kprobes: Fix check for probe enabled in kill_kprobe()

Li Jun (2):
      dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
      clk: imx: imx8mp: add shared clk gate for usb suspend clk

Li Zetao (4):
      ocfs2: fix memory leak in ocfs2_mount_volume()
      ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()
      net: farsync: Fix kmemleak when rmmods farsync
      r6040: Fix kmemleak in probe and remove

Li Zhijian (1):
      RDMA/rxe: Fix mr->map double free

Li Zhong (2):
      ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
      drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Liam Howlett (2):
      test_maple_tree: add test for mas_spanning_rebalance() on insufficient data
      maple_tree: fix mas_spanning_rebalance() on insufficient data

Liang He (2):
      media: c8sectpfe: Add of_node_put() when breaking out of loop
      drm/amdgpu: Fix potential double free and null pointer dereference

Lili Li (1):
      ASoC: Intel: Skylake: Fix Kconfig dependency

Lin Ma (3):
      media: dvbdev: adopts refcnt to avoid UAF
      media: dvbdev: fix build warning due to comments
      media: dvbdev: fix refcnt bug

Linus Walleij (1):
      usb: fotg210-udc: Fix ages old endianness issues

Liu Peibao (1):
      irqchip/loongson-liointc: Fix improper error handling in liointc_init()

Liu Shixin (4):
      media: vivid: fix compose size exceed boundary
      ALSA: asihpi: fix missing pci_disable_device()
      media: saa7164: fix missing pci_disable_device()
      binfmt_misc: fix shift-out-of-bounds in check_special_flags

Lorenzo Bianconi (5):
      net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine
      net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
      wifi: mt76: mt7915: fix reporting of TX AGGR histogram
      wifi: mt76: mt7921: fix reporting of TX AGGR histogram
      wifi: mt76: do not run mt76u_status_worker if the device is not running

Luca Weiss (6):
      ARM: dts: qcom: apq8064: fix coresight compatible
      soc: qcom: llcc: make irq truly optional
      thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2
      leds: is31fl319x: Fix setting current limit for is31fl319{0,1,3}
      remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
      remoteproc: qcom_q6v5_pas: detach power domains on remove

Luiz Augusto von Dentz (1):
      Bluetooth: hci_conn: Fix crash on hci_create_cis_sync

Luoyouming (2):
      RDMA/hns: Fix ext_sge num error when post send
      RDMA/hns: Fix incorrect sge nums calculation

Manivannan Sadhasivam (4):
      cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()
      clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs
      phy: qcom-qmp-pcie: Fix high latency with 4x2 PHY when ASPM is enabled
      phy: qcom-qmp-pcie: Fix sm8450_qmp_gen4x2_pcie_pcs_tbl[] register names

Marco Elver (1):
      objtool, kcsan: Add volatile read/write instrumentation to whitelist

Marco Felsch (1):
      drm: lcdif: change burst size to 256B

Marcus Folkesson (2):
      HID: hid-sensor-custom: set fixed size for custom attributes
      thermal/drivers/imx8mm_thermal: Validate temperature range

Marek Szyprowski (2):
      media: exynos4-is: don't rely on the v4l2_async_subdev internals
      ASoC: wm8994: Fix potential deadlock

Marek Vasut (11):
      ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
      ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
      clk: renesas: r9a06g032: Repair grave increment error
      drm/panel/panel-sitronix-st7701: Fix RTNI calculation
      drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
      drm: lcdif: Set and enable FIFO Panic threshold
      media: mt9p031: Drop bogus v4l2_subdev_get_try_crop() call from mt9p031_init_cfg()
      extcon: usbc-tusb320: Update state on probe even if no IRQ pending
      power: supply: bq25890: Factor out regulator registration code
      Bluetooth: hci_bcm: Add CYW4373A0 support

Marijn Suijten (13):
      arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name
      arm64: dts: qcom: pm6350: Include header for KEY_POWER
      drm/msm/dpu1: Account for DSC's bits_per_pixel having 4 fractional bits
      drm/msm/dsi: Remove useless math in DSC calculations
      drm/msm/dsi: Remove repeated calculation of slice_per_intf
      drm/msm/dsi: Use DIV_ROUND_UP instead of conditional increment on modulo
      drm/msm/dsi: Reuse earlier computed dsc->slice_chunk_size
      drm/msm/dsi: Appropriately set dsc->mux_word_size based on bpc
      drm/msm/dsi: Migrate to drm_dsc_compute_rc_parameters()
      drm/msm/dsi: Account for DSC's bits_per_pixel having 4 fractional bits
      drm/msm/dsi: Disallow 8 BPC DSC configuration for alternative BPC values
      drm/msm/dsi: Prevent signed BPG offsets from bleeding into adjacent bits
      arm64: dts: qcom: sm6350: Add apps_smmu with streamID to SDHCI 1/2 nodes

Mark Rutland (2):
      arm64: mm: kfence: only handle translation faults
      arm64: make is_ttbrX_addr() noinstr-safe

Mark Zhang (4):
      RDMA/restrack: Release MR restrack when delete
      RDMA/core: Make sure "ib_port" is valid when access sysfs node
      RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port
      RDMA/nldev: Fix failure to send large messages

Markus Schneider-Pargmann (2):
      can: tcan4x5x: Remove invalid write in clear_interrupts
      can: tcan4x5x: Fix use of register error status mask

Martin Blumenstingl (2):
      hwmon: (jc42) Convert register access and caching to regmap/regcache
      hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin KaFai Lau (1):
      selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test

Martin Leung (1):
      drm/amd/display: revert Disable DRR actions during state commit

Martin Povišer (1):
      dmaengine: apple-admac: Allocate cache SRAM to channels

Mateusz Jończyk (1):
      x86/apic: Handle no CONFIG_X86_X2APIC on systems with x2APIC enabled by BIOS

Mathias Nyman (1):
      xhci: Prevent infinite loop in transaction errors recovery for streams

Matt Johnston (1):
      mctp: Remove device type check at unregister

Matt Redfearn (1):
      include/uapi/linux/swab: Fix potentially missing __always_inline

Matti Vaittinen (1):
      mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix a race condition between login_work and the login thread

Maxim Korotkov (1):
      ethtool: avoiding integer overflow in ethtool_phys_id()

Mazin Al Haddad (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Mia Kanashi (1):
      ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur

Miaoqian Lin (5):
      module: Fix NULL vs IS_ERR checking for module_get_next_page
      bpftool: Fix memory leak in do_build_table_cb
      cxl: Fix refcount leak in cxl_calc_capp_routing
      selftests/powerpc: Fix resource leaks
      usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init

Michael Kelley (1):
      tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Michael Petlan (1):
      perf test: Fix "all PMU test" to skip parametrized events

Michael Riesch (1):
      iommu/rockchip: fix permission bits in page table entries v2

Michael Walle (1):
      mtd: spi-nor: hide jedec_id sysfs attribute if not present

Mika Westerberg (1):
      watchdog: iTCO_wdt: Set NO_REBOOT if the watchdog is not already running

Mike Leach (1):
      coresight: cti: Fix null pointer error on CTI init before ETM

Mike McGowen (1):
      scsi: smartpqi: Add new controller PCI IDs

Milan Landaverde (1):
      bpf: prevent leak of lsm program after failed attach

Ming Qian (7):
      media: amphion: reset instance if it's aborted before codec header parsed
      media: amphion: add lock around vdec_g_fmt
      media: amphion: apply vb2_queue_error instead of setting manually
      media: amphion: try to wakeup vpu core to avoid failure
      media: amphion: cancel vpu before release instance
      media: amphion: lock and check m2m_ctx in event handler
      media: imx-jpeg: Disable useless interrupt to avoid kernel panic

Minsuk Kang (2):
      nfc: pn533: Clear nfc_target before being used
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Moudy Ho (3):
      media: platform: mtk-mdp3: fix error handling in mdp_cmdq_send()
      media: platform: mtk-mdp3: fix error handling about components clock_on
      media: platform: mtk-mdp3: fix error handling in mdp_probe()

Muhammad Husaini Zulkifli (1):
      igc: Add checking for basetime less than zero

Mukesh Ojha (1):
      f2fs: fix the assign logic of iocb

Mustafa Ismail (4):
      RDMA/irdma: Fix inline for multiple SGE's
      RDMA/irdma: Fix RQ completion opcode
      RDMA/irdma: Do not request 2-level PBLEs for CQ alloc
      RDMA/irdma: Initialize net_type before checking it

Namhyung Kim (4):
      perf stat: Use evsel__is_hybrid() more
      perf stat: Move common code in print_metric_headers()
      perf off_cpu: Fix a typo in BTF tracepoint name, it should be 'btf_trace_sched_switch'
      perf stat: Do not delay the workload with --delay

Natalia Petrova (1):
      crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Nathan Chancellor (13):
      drm/meson: Fix return type of meson_encoder_cvbs_mode_valid()
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      drm/amdgpu: Fix type of second parameter in trans_msg() callback
      drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()
      drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()
      scsi: elx: libefc: Fix second parameter type in state callbacks
      drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
      security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6

Nathan Lynch (1):
      powerpc/pseries/eeh: use correct API for error log size

Nayna Jain (4):
      powerpc/pseries: fix the object owners enum value in plpks driver
      powerpc/pseries: Fix the H_CALL error code in PLPKS driver
      powerpc/pseries: Return -EIO instead of -EINTR for H_ABORTED error
      powerpc/pseries: fix plpks_read_var() code for different consumers

Nicholas Piggin (1):
      powerpc/perf: callchain validate kernel stack pointer bounds

Nicolas Cavallari (1):
      wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC

Niklas Cassel (1):
      ata: libata: fix NCQ autosense logic

Niklas Schnelle (1):
      iommu/s390: Fix duplicate domain attachments

Niklas Söderlund (1):
      media: adv748x: afe: Select input port when initializing AFE

Nirmal Patel (1):
      PCI: vmd: Disable MSI remapping after suspend

Nirmoy Das (1):
      drm/i915: Refactor ttm ghost obj detection

Nuno Sá (1):
      iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Nícolas F. R. A. Prado (1):
      ASoC: dt-bindings: rt5682: Set sound-dai-cells to 1

Oleg Nesterov (1):
      uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Ondrej Mosnacek (1):
      fs: don't audit the capability check in simple_xattr_list()

Padmanabhan Rajanbabu (2):
      arm64: dts: fsd: fix drive strength macros as per FSD HW UM
      arm64: dts: fsd: fix drive strength values as per FSD HW UM

Pali Rohár (11):
      ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: turris-omnia: Add ethernet aliases
      ARM: dts: turris-omnia: Add switch port 6 node
      arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC
      phy: marvell: phy-mvebu-a3700-comphy: Reset COMPHY registers before USB 3.0 power on
      powerpc: dts: turris1x.dts: Add channel labels for temperature sensor

Palmer Dabbelt (1):
      RISC-V: Align the shadow stack

Paul Kocialkowski (4):
      media: sun6i-mipi-csi2: Require both pads to be connected for streaming
      media: sun8i-a83t-mipi-csi2: Require both pads to be connected for streaming
      media: sun6i-mipi-csi2: Register async subdev with no sensor attached
      media: sun8i-a83t-mipi-csi2: Register async subdev with no sensor attached

Paulo Alcantara (1):
      cifs: don't leak -ENOMEM in smb2_open_file()

Pavel Begunkov (6):
      io_uring: add completion locking for iopoll
      io_uring: dont remove file from msg_ring reqs
      io_uring: improve io_double_lock_ctx fail handling
      io_uring/net: fix cleanup after recycle
      io_uring: protect cq_timeouts with timeout_lock
      io_uring: remove iopoll spinlock

Pawel Laszczak (1):
      usb: cdnsp: fix lack of ZLP for ep0

Peng Fan (2):
      clk: imx93: unmap anatop base in error handling path
      clk: imx93: correct enet clock

Pengcheng Yang (3):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Phil Auld (1):
      cpu/hotplug: Make target_store() a nop when target == state

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Pin-yen Lin (1):
      drm/bridge: it6505: Initialize AUX channel in it6505_i2c_probe

Ping-Ke Shih (1):
      wifi: rtw89: use u32_encode_bits() to fill MAC quota value

Prathamesh Shete (1):
      mmc: sdhci-tegra: Issue CMD and DAT resets together

Pu Lehui (1):
      riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Qais Yousef (7):
      sched/uclamp: Fix relationship between uclamp and migration margin
      sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
      sched/uclamp: Fix fits_capacity() check in feec()
      sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
      sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
      sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
      sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition

Qiheng Lin (1):
      power: supply: Fix refcount leak in rk817_charger_probe

Qingfang DENG (1):
      netfilter: flowtable: really fix NAT IPv6 offload

Rafael J. Wysocki (7):
      PM: runtime: Do not call __rpm_callback() from rpm_idle()
      rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()
      rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()
      rtc: cmos: Eliminate forward declarations of some functions
      rtc: cmos: Rename ACPI-related functions
      rtc: cmos: Disable ACPI RTC event on removal
      ACPICA: Fix error code path in acpi_ds_call_control_method()

Rafael Mendonca (6):
      drm/amdgpu/powerplay/psm: Fix memory leak in power state init
      media: i2c: hi846: Fix memory leak in hi846_parse_dt()
      media: i2c: ov5648: Free V4L2 fwnode data on unbind
      vfio: platform: Do not pass return buffer to ACPI _RST method
      uio: uio_dmem_genirq: Fix missing unlock in irq configuration
      uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rahul Bhattacharjee (1):
      wifi: ath11k: Fix qmi_msg_handler data structure initialization

Ramona Bolboaca (1):
      iio: adis: add '__adis_enable_irq()' implementation

Randy Dunlap (6):
      Input: joystick - fix Kconfig warning for JOYSTICK_ADC
      ASoC: codecs: wsa883x: use correct header file
      Input: wistron_btns - disable on UML
      RDMA: Disable IB HW for UML
      fbdev: geode: don't build on UML
      fbdev: uvesafb: don't build on UML

Rasmus Villemoes (2):
      iio: adc128s052: add proper .data members in adc128_of_match table
      iio: addac: ad74413r: fix integer promotion bug in ad74413_get_input_current_offset()

Reinette Chatre (1):
      x86/sgx: Reduce delay and interference of enclave release

Ricardo Ribalda (2):
      media: i2c: ad5820: Fix error path
      ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

Richard Gobert (1):
      net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets

Rickard x Andersson (1):
      gcov: add support for checksum field

Rob Clark (1):
      drm/msm/a6xx: Fix speed-bin detection vs probe-defer

Robert Elliott (1):
      crypto: tcrypt - fix return value for multiple subtests

Roberto Sassu (1):
      reiserfs: Add missing calls to reiserfs_security_free()

Robin Murphy (1):
      iommu: Avoid races around device probe

Roger Quadros (1):
      net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()

Rui Zhang (1):
      regulator: core: fix use_count leakage when handling boot-on

Ryder Lee (1):
      wifi: mt76: mt7915: fix mt7915_mac_set_timing()

Ryusuke Konishi (2):
      nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
      nilfs2: fix shift-out-of-bounds due to too large exponent of block size

Sagi Grimberg (1):
      nvme-auth: don't override ctrl keys before validation

Sakari Ailus (1):
      dw9768: Enable low-power probe on ACPI

Sam Shih (1):
      pinctrl: mediatek: fix the pinconf register offset of some pins

Sami Tolvanen (1):
      cfi: Fix CFI failure with KASAN

Samuel Holland (2):
      riscv: Fix crash during early errata patching
      mfd: axp20x: Do not sleep in the power off handler

Sascha Hauer (1):
      PCI: imx6: Initialize PHY before deasserting core reset

Schspa Shi (2):
      mrp: introduce active flags to prevent UAF when applicant uninit
      9p: set req refcount to zero to avoid uninitialized usage

Sean Wang (1):
      wifi: mt76: mt7921: fix antenna signal are way off in monitor mode

Sebastian Andrzej Siewior (6):
      Revert "net: hsr: use hlist_head instead of list_head for mac addresses"
      hsr: Add a rcu-read lock to hsr_forward_skb().
      hsr: Avoid double remove of a node.
      hsr: Disable netpoll.
      hsr: Synchronize sending frames to have always incremented outgoing seq nr.
      hsr: Synchronize sequence number updates.

Serge Semin (2):
      dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq
      dt-bindings: visconti-pcie: Fix interrupts array max constraints

Sergio Paracuellos (1):
      MIPS: ralink: mt7621: avoid to init common ralink reset controller

Shang XiaoJing (13):
      perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()
      perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
      ocfs2: fix memory leak in ocfs2_stack_glue_init()
      irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
      mtd: core: Fix refcount error in del_mtd_device()
      scsi: ipr: Fix WARNING in ipr_init()
      crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
      samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
      fbdev: via: Fix error in via_core_init()
      power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()
      rtc: class: Fix potential memleak in devm_rtc_allocate_device()
      remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_mmio()
      remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()

Shayne Chen (1):
      wifi: mt76: mt7915: rework eeprom tx paths and streams init

Sheng Yong (2):
      f2fs: set zstd compress level correctly
      f2fs: fix to enable compress for newly created file if extension matches

Shengjiu Wang (1):
      remoteproc: core: Auto select rproc-virtio device id

Shigeru Yoshida (4):
      fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()
      udf: Avoid double brelse() in udf_rename()
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
      media: si470x: Fix use-after-free in si470x_int_in_callback()

Shiraz Saleem (1):
      RDMA/irdma: Report the correct link speed

Shung-Hsi Yu (3):
      libbpf: Use elf_getshdrnum() instead of e_shnum
      libbpf: Deal with section with no data gracefully
      libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Sibi Sankar (1):
      arm64: dts: qcom: sc7280: Mark all Qualcomm reference boards as LTE

Song Liu (1):
      selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION

Srinivas Kandagatla (1):
      ASoC: qcom: cleanup and fix dependency of QCOM_COMMON

Stanislav Fomichev (6):
      bpf: Move skb->len == 0 checks into __bpf_redirect
      selftests/bpf: Make sure zero-len skbs aren't redirectable
      selftests/bpf: Mount debugfs in setns_by_fd
      bpf: make sure skb->len != 0 when redirecting to a tunneling device
      ppp: associate skb with a device at tx
      bpf: Prevent decl_tag from being referenced in func_proto arg

Stefan Eichenberger (1):
      rtc: snvs: Allow a time difference on clock register read

Stefan Metzmacher (1):
      io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Stephen Boyd (1):
      pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Steven Price (1):
      pwm: tegra: Fix 32 bit build

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Sumit Gupta (4):
      soc/tegra: cbb: Use correct master_id mask for CBB NOC in Tegra194
      soc/tegra: cbb: Update slave maps for Tegra234
      soc/tegra: cbb: Add checks for potential out of bound errors
      soc/tegra: cbb: Check firewall before enabling error reporting

Sven Peter (9):
      soc: apple: sart: Stop casting function pointer signatures
      soc: apple: rtkit: Stop casting function pointer signatures
      usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
      usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
      usb: typec: tipd: Fix spurious fwnode_handle_put in error path
      usb: typec: tipd: Fix typec_unregister_port error paths
      Bluetooth: Add quirk to disable extended scanning
      Bluetooth: Add quirk to disable MWS Transport Configuration
      usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Takashi Iwai (3):
      ALSA: memalloc: Allocate more contiguous pages for fallback case
      ALSA: pcm: Set missing stop_operating flag at undoing trigger start
      ALSA: usb-audio: Workaround for XRUN at prepare

Tan Tee Min (3):
      igc: allow BaseTime 0 enrollment for Qbv
      igc: recalculate Qbv end_time by considering cycle time
      igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Tang Bin (1):
      venus: pm_helpers: Fix error check in vcodec_domains_get()

Tejun Heo (1):
      blk-iolatency: Fix memory leak on add_disk() failures

Tetsuo Handa (1):
      fbdev: fbcon: release buffer when fbcon_do_set_font() failed

Thomas Zimmermann (1):
      drm/atomic-helper: Don't allocate new plane state in CRTC check

Tianjia Zhang (1):
      crypto: arm64/sm3 - add NEON assembly implementation

Toke Høiland-Jørgensen (1):
      bpf: Add dummy type reference to nf_conn___init to fix type deduplication

Tom Lendacky (2):
      net: amd-xgbe: Fix logic around active and passive cables
      net: amd-xgbe: Check only the minimum speed for active/passive cables

Tong Tiangen (1):
      riscv/mm: add arch hook arch_clear_hugepage_flags

Tony Lindgren (2):
      clocksource/drivers/timer-ti-dm: Fix warning for omap_timer_match
      usb: musb: omap2430: Fix probe regression for missing resources

Trond Myklebust (9):
      lockd: set other missing fields when unlocking files
      NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
      NFSv4.2: Always decode the security label
      NFSv4.2: Fix a memory stomp in decode_attr_security_label
      NFSv4.2: Fix initialisation of struct nfs4_label
      NFSv4: Fix a credential leak in _nfs4_discover_trunking()
      NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
      NFS: Fix an Oops in nfs_d_automount()
      NFSv4.x: Fail client initialisation if state manager thread can't run

Tvrtko Ursulin (1):
      drm/i915: Handle all GTs on driver (un)load paths

Ulf Hansson (1):
      cpuidle: dt: Return the correct numbers of parsed idle states

Uwe Kleine-König (4):
      crypto: ccree - Make cc_debugfs_global_fini() available for module init function
      power: supply: bq25890: Convert to i2c's .probe_new()
      rtc: pcf2127: Convert to .probe_new()
      pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Valentin Caron (1):
      serial: stm32: move dma_request_chan() before clk_prepare_enable()

Veerabadhran Gopalakrishnan (1):
      amdgpu/nv.c: Corrected typo in the video capabilities resolution

Victor Ding (1):
      platform/chrome: cros_ec_typec: zero out stale pointers

Vidya Sagar (3):
      arm64: tegra: Fix Prefetchable aperture ranges of Tegra234 PCIe controllers
      arm64: tegra: Fix non-prefetchable aperture of PCIe C3 controller
      PCI: dwc: Fix n_fts[] array overrun

Ville Syrjälä (3):
      drm/msm: Use drm_mode_copy()
      drm/rockchip: Use drm_mode_copy()
      drm/sti: Use drm_mode_copy()

Vincent Donnefort (1):
      cpu/hotplug: Do not bail-out in DYING/STARTING sections

Vinicius Costa Gomes (2):
      igc: Enhance Qbv scheduling by using first flag bit
      igc: Use strict cycles for Qbv scheduling

Vivek Yadav (1):
      can: m_can: Call the RAM init directly from m_can_chip_config

Vladimir Oltean (3):
      net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
      net: enetc: avoid buffer leaks on xdp_do_redirect() failure
      net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()

Vladimir Zapolskiy (2):
      media: camss: Clean up received buffers on failed start of streaming
      media: camss: Do not attach an already attached power domain on MSM8916 platform

Wang Jingjin (2):
      ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
      ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Wang ShaoBo (7):
      ACPI: pfr_telemetry: use ACPI_FREE() to free acpi_object
      ACPI: pfr_update: use ACPI_FREE() to free acpi_object
      regulator: core: use kfree_const() to free space conditionally
      drbd: remove call to memset before free device/resource/connection
      drbd: destroy workqueue when drbd device was freed
      SUNRPC: Fix missing release socket in rpc_sockname()
      Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Wang Weiyang (1):
      rapidio: fix possible UAF when kfifo_alloc() fails

Wang Yufen (10):
      pstore/ram: Fix error return code in ramoops_probe()
      selftests/bpf: fix missing BPF object files
      selftests/bpf: fix memory leak of lsm_cgroup
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
      crypto: qat - fix error return code in adf_probe
      RDMA/hfi1: Fix error return code in parse_platform_config()
      RDMA/srp: Fix error return code in srp_parse_options()
      ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()
      ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
      ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max98357_dev_probe()

Wei Fang (1):
      net: fec: check the return value of build_skb()

Wei Yongjun (1):
      irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()

Weili Qian (3):
      crypto: hisilicon/qm - fix incorrect parameters usage
      crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF
      crypto: hisilicon/qm - fix 'QM_XEQ_DEPTH_CAP' mask value

Wesley Chalmers (2):
      drm/amd/display: Disable DRR actions during state commit
      drm/amd/display: Use the largest vready_offset in pipe group

Wolfram Sang (9):
      arm64: dts: renesas: r8a779f0: Fix HSCIF "brg_int" clock
      arm64: dts: renesas: r8a779f0: Fix SCIF "brg_int" clock
      clocksource/drivers/sh_cmt: Access registers according to spec
      clk: renesas: r8a779a0: Fix SD0H clock name
      clk: renesas: r8a779f0: Fix HSCIF parent clocks
      clk: renesas: r8a779f0: Fix SCIF parent clocks
      mmc: renesas_sdhi: alway populate SCC pointer
      mmc: renesas_sdhi: add quirk for broken register layout
      mmc: renesas_sdhi: better reset from HS400 mode

Wright Feng (1):
      brcmfmac: return error when getting invalid max_flowrings from dongle

Xia Fukun (1):
      drm/i915/bios: fix a memory leak in generate_lfp_data_ptrs

Xiao Ni (1):
      md/raid0, raid10: Don't set discard sectors for request queue

Xiaochen Shen (2):
      dmaengine: idxd: Make max batch size attributes in sysfs invisible for Intel IAA
      dmaengine: idxd: Make read buffer sysfs attributes invisible for Intel IAA

Xie Shaowen (1):
      macintosh/macio-adb: check the return value of ioremap()

Xingjiang Qiao (2):
      hwmon: (emc2305) fix unable to probe emc2301/2/3
      hwmon: (emc2305) fix pwm never being able to set lower

Xinlei Lee (1):
      drm/mediatek: Modify dpi power on/off sequence.

Xiongfeng Wang (15):
      ACPI: irq: Fix some kernel-doc issues
      perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()
      perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
      perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()
      perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()
      cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
      drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
      drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
      mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()
      crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
      RDMA/hfi: Decrease PCI device reference count in error path
      hwrng: amd - Fix PCI device refcount leak
      hwrng: geode - Fix PCI device refcount leak
      serial: pch: Fix PCI device refcount leak in pch_request_dma()
      fbdev: vermilion: decrease reference count in error path

Xiu Jianfeng (12):
      x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
      x86/xen: Fix memory leak in xen_init_lock_cpu()
      ima: Fix misuse of dereference of pointer in template_desc_init_fields()
      wifi: ath10k: Fix return value in ath10k_pci_init()
      clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
      clk: visconti: Fix memory leak in visconti_register_pll()
      clk: samsung: Fix memory leak in _samsung_clk_register_pll()
      clk: socfpga: Fix memory leak in socfpga_gate_init()
      apparmor: Use pointer to struct aa_label for lbs_cred
      apparmor: Fix memleak in alloc_ns()
      ksmbd: Fix resource leak in ksmbd_session_rpc_open()
      clk: st: Fix memory leak in st_of_quadfs_setup()

Xu Kuohai (6):
      libbpf: Fix use-after-free in btf_dump_name_dups
      libbpf: Fix memory leak in parse_usdt_arg()
      selftests/bpf: Fix memory leak caused by not destroying skeleton
      selftest/bpf: Fix memory leak in kprobe_multi_test
      selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
      selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c

YN Chen (1):
      wifi: mt76: mt7921: fix wrong power after multiple SAR set

Yan Lei (1):
      media: dvb-frontends: fix leak of memory fw

Yang Jihong (4):
      selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
      blktrace: Fix output non-blktrace event when blk_classic option enabled
      perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()
      perf probe: Check -v and -q options in the right place

Yang Shen (1):
      coresight: trbe: remove cpuhp instance node before remove cpuhp state

Yang Yingliang (87):
      soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()
      soc: sifive: ccache: fix missing free_irq() in error path in sifive_ccache_init()
      soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()
      MIPS: vpe-mt: fix possible memory leak while module exiting
      MIPS: vpe-cmp: fix possible memory leak while module exiting
      PNP: fix name memory leak in pnp_alloc_dev()
      thermal: core: fix some possible name leaks in error paths
      EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
      genirq/irqdesc: Don't try to remove non-existing sysfs files
      rapidio: fix possible name leaks when rio_add_device() fails
      rapidio: rio: fix possible name leak in rio_register_mport()
      clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()
      platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()
      pinctrl: ocelot: add missing destroy_workqueue() in error path in ocelot_pinctrl_probe()
      media: platform: exynos4-is: fix return value check in fimc_md_probe()
      regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
      media: solo6x10: fix possible memory leak in solo_sysfs_init()
      drm/amdgpu: fix pci device refcount leak
      regulator: core: fix module refcount leak in set_supply()
      regulator: core: fix resource leak in regulator_register()
      mmc: alcor: fix return value check of mmc_add_host()
      mmc: moxart: fix return value check of mmc_add_host()
      mmc: mxcmmc: fix return value check of mmc_add_host()
      mmc: pxamci: fix return value check of mmc_add_host()
      mmc: rtsx_pci: fix return value check of mmc_add_host()
      mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
      mmc: toshsd: fix return value check of mmc_add_host()
      mmc: vub300: fix return value check of mmc_add_host()
      mmc: wmt-sdmmc: fix return value check of mmc_add_host()
      mmc: atmel-mci: fix return value check of mmc_add_host()
      mmc: omap_hsmmc: fix return value check of mmc_add_host()
      mmc: meson-gx: fix return value check of mmc_add_host()
      mmc: via-sdmmc: fix return value check of mmc_add_host()
      mmc: wbsd: fix return value check of mmc_add_host()
      mmc: mmci: fix return value check of mmc_add_host()
      ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()
      hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
      af_unix: call proto_unregister() in the error path in af_unix_init()
      Bluetooth: hci_core: fix error handling in hci_register_dev()
      Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()
      scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()
      scsi: hpsa: Fix error handling in hpsa_add_sas_host()
      scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
      scsi: fcoe: Fix possible name leak when device_register() fails
      scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()
      drivers: dio: fix possible memory leak in dio_init()
      class: fix possible memory leak in __class_register()
      usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
      habanalabs: fix return value check in hl_fw_get_sec_attest_data()
      misc: ocxl: fix possible name leak in ocxl_file_register_afu()
      ocxl: fix pci device refcount leak when calling get_function_0()
      firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()
      cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
      cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
      usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
      usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()
      mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
      chardev: fix error handling in cdev_device_add()
      i2c: mux: reg: check return value after calling platform_get_resource()
      usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()
      fbdev: pm2fb: fix missing pci_disable_device()
      HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
      HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
      iommu/mediatek: Check return value after calling platform_get_resource()
      iommu/amd: Fix pci device refcount leak in ppr_notifier()
      macintosh: fix possible memory leak in macio_add_one_device()
      powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
      powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()
      mfd: pm8008: Fix return value check in pm8008_probe()
      mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()
      mailbox: zynq-ipi: fix error handling while device_register() fails
      hwmon: (jc42) Fix missing unlock on error in jc42_write()
      ASoC: sof_es8336: fix possible use-after-free in sof_es8336_remove()

Yangtao Li (2):
      f2fs: fix gc mode when gc_urgent_high_remaining is 1
      f2fs: fix iostat parameter for discard

Yassine Oudjana (2):
      arm64: dts: qcom: msm8996: Add MSM8996 Pro support
      regmap-irq: Use the new num_config_regs property in regmap_add_irq_chip_fwnode

Ye Bin (1):
      blk-mq: fix possible memleak when register 'hctx' failed

Yicong Yang (1):
      drivers/perf: hisi: Fix some event id for hisi-pcie-pmu

Yipeng Zou (1):
      selftests/ftrace: event_triggers: wait longer for test_event_enable

Yixing Liu (1):
      RDMA/hns: Fix the gid problem caused by free mr

Yong Wu (3):
      iommu/mediatek: Add platform_device_put for recovering the device refcnt
      iommu/mediatek: Use component_match_add
      iommu/mediatek: Add error path for loop of mm_dts_parse

Yonggil Song (1):
      f2fs: avoid victim selection from previous victim section

Yonghong Song (1):
      bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set

Yongqiang Liu (1):
      net: defxx: Fix missing err handling in dfx_init()

Youghandhar Chintala (1):
      wifi: ath10k: Delay the unmapping of the buffer

Yu Kuai (2):
      dm: make sure create and remove dm device won't race with open and close table
      block, bfq: fix possible uaf for 'bfqq->bic'

Yu Liao (1):
      platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Yuan Can (20):
      perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
      drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init()
      tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
      platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()
      media: platform: exynos4-is: Fix error handling in fimc_md_init()
      media: amphion: Fix error handling in vpu_driver_init()
      ASoC: qcom: Add checks for devm_kcalloc
      wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
      regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
      scsi: hpsa: Fix possible memory leak in hpsa_init_one()
      RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
      serial: 8250_bcm7271: Fix error handling in brcmuart_init()
      serial: sunsab: Fix error handling in sunsab_init()
      HSI: omap_ssi_core: Fix error handling in ssi_init()
      power: supply: ab8500: Fix error handling in ab8500_charger_init()
      iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
      remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
      drm/rockchip: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      floppy: Fix memory leak in do_floppy_init()

YueHaibing (2):
      selftests: cgroup: fix unsigned comparison with less than zero
      staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Yunfei Dong (6):
      media: mediatek: vcodec: fix h264 cavlc bitstream fail
      media: mediatek: vcodec: Fix getting NULL pointer for dst buffer
      media: mediatek: vcodec: Fix h264 set lat buffer error
      media: mediatek: vcodec: Setting lat buf to lat_list when lat decode error
      media: mediatek: vcodec: Core thread depends on core_list
      media: mediatek: vcodec: Can't set dst buffer to done when lat decode error

Yushan Zhou (1):
      rtc: rzn1: Check return value in rzn1_rtc_probe

Zeng Heng (4):
      ASoC: pxa: fix null-pointer dereference in filter()
      PCI: Check for alloc failure in pci_request_irq()
      power: supply: fix residue sysfs file in error handle route of __power_supply_register()
      iio: fix memory leak in iio_device_register_eventset()

Zhang Changzhong (1):
      net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Zhang Qilong (7):
      soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe
      soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
      eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
      drm/rockchip: lvds: fix PM usage counter unbalance in poweron
      ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
      f2fs: Fix the race condition of resize flag between resizefs
      power: supply: z2_battery: Fix possible memleak in z2_batt_probe()

Zhang Xiaoxu (7):
      mtd: Fix device name leak when register device failed in add_mtd_device()
      xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
      RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed
      orangefs: Fix sysfs not cleanup when dev init failed
      orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
      orangefs: Fix kmemleak in orangefs_sysfs_init()
      orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Yiqun (1):
      crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Zhang Yuchen (1):
      ipmi: fix memleak when unload ipmi driver

Zhang Zekun (1):
      drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

ZhangPeng (4):
      hfs: Fix OOB Write in hfs_asc2mac
      pinctrl: k210: call of_node_put()
      pinctrl: pinconf-generic: add missing of_node_put()
      hfs: fix OOB Read in __hfs_brec_find

Zhao Gongyi (1):
      selftests/efivarfs: Add checking of the test return value

Zhen Lei (1):
      mmc: core: Normalize the error handling branch in sd_read_ext_regs()

Zheng Wang (1):
      misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

Zheng Yejian (2):
      tracing/hist: Fix issue of losting command info in error_log
      acct: fix potential integer overflow in encode_comp_t()

Zheng Yongjun (1):
      mtd: maps: pxa2xx-flash: fix memory leak in probe

Zhengchao Shao (5):
      ipc: fix memory leak in init_mqueue_fs()
      wifi: mac80211: fix memory leak in ieee80211_if_add()
      RDMA/hns: fix memory leak in hns_roce_alloc_mr()
      test_firmware: fix memory leak in test_firmware_init()
      drivers: mcb: fix resource leak in mcb_probe()

Zheyu Ma (1):
      i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Zhiqi Song (1):
      crypto: hisilicon/hpre - fix resource leak in remove process

Ziyang Xuan (1):
      wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()

Zong-Zhe Yang (1):
      wifi: rtw89: fix physts IE page check

Zqiang (1):
      rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

delisun (1):
      serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

gehao (1):
      drm/amd/display: prevent memory leak

ruanjinjie (3):
      of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
      misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
      power: supply: fix null pointer dereferencing in power_supply_get_battery_info

wangdicheng (1):
      ALSA: usb-audio: add the quirk for KT0206 device

wuchi (1):
      lib/debugobjects: fix stat count and optimize debug_objects_mem_init

xinlei lee (1):
      pwm: mtk-disp: Fix the parameters calculated by the enabled flag of disp_pwm

xiongxin (1):
      PM: hibernate: Fix mistake in kerneldoc comment

zhikzhai (1):
      drm/amd/display: skip commit minimal transition state

Íñigo Huguet (1):
      wifi: mac80211: fix maybe-unused warning

