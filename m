Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5249060761E
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJUL3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 07:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJUL3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 07:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7213A264E4A;
        Fri, 21 Oct 2022 04:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20CBB82B1D;
        Fri, 21 Oct 2022 11:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BAEC433C1;
        Fri, 21 Oct 2022 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666351734;
        bh=z7bJT2LrjscRjxYyYiHsH7veZirpUfTvZeI1sPNz9iU=;
        h=From:To:Cc:Subject:Date:From;
        b=WsErnWojC7FGz6Zfu4ZzyKTzmtqD8Q9d4ZAABkKkkJNapmt3po8/kHW4BuqN3FZ+J
         X/f8OFLTZ+E/hlwfaab1DzgEoJ5A/YCfGGRlyKUxlsrWgqPJl+xPXZpOAT3gUdvre/
         srUM32IM/f+zLx5iWjBD6BQmy5bFdhLETsNeRp7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.3
Date:   Fri, 21 Oct 2022 13:28:49 +0200
Message-Id: <1666351729239175@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.3 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                            |    2 
 Documentation/admin-guide/kernel-parameters.txt                    |    4 
 Documentation/arm64/silicon-errata.rst                             |    2 
 Documentation/filesystems/vfs.rst                                  |    3 
 Documentation/trace/coresight/coresight-cpu-debug.rst              |    3 
 Makefile                                                           |    2 
 arch/arm/Kconfig                                                   |    1 
 arch/arm/boot/compressed/misc.c                                    |    2 
 arch/arm/boot/compressed/vmlinux.lds.S                             |    2 
 arch/arm/boot/dts/armada-385-turris-omnia.dts                      |    4 
 arch/arm/boot/dts/exynos4412-midas.dtsi                            |    2 
 arch/arm/boot/dts/exynos4412-origen.dts                            |    2 
 arch/arm/boot/dts/imx6dl-riotboard.dts                             |    1 
 arch/arm/boot/dts/imx6dl.dtsi                                      |    3 
 arch/arm/boot/dts/imx6q-arm2.dts                                   |    1 
 arch/arm/boot/dts/imx6q-evi.dts                                    |    1 
 arch/arm/boot/dts/imx6q-mccmon6.dts                                |    1 
 arch/arm/boot/dts/imx6q.dtsi                                       |    3 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi                      |    6 
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi                           |    1 
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi                       |    1 
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi                      |    1 
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi                          |    1 
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi                           |    1 
 arch/arm/boot/dts/imx6qdl-tqma6a.dtsi                              |    1 
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi                              |    1 
 arch/arm/boot/dts/imx6qp.dtsi                                      |    6 
 arch/arm/boot/dts/imx6sl.dtsi                                      |   23 
 arch/arm/boot/dts/imx6sll.dtsi                                     |    3 
 arch/arm/boot/dts/imx6sx-udoo-neo.dtsi                             |   14 
 arch/arm/boot/dts/imx6sx.dtsi                                      |    6 
 arch/arm/boot/dts/imx7d-sdb.dts                                    |    7 
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                               |   16 
 arch/arm/include/asm/stacktrace.h                                  |    6 
 arch/arm/kernel/return_address.c                                   |    1 
 arch/arm/kernel/stacktrace.c                                       |   84 +-
 arch/arm/lib/call_with_stack.S                                     |    2 
 arch/arm/mm/dma-mapping.c                                          |   12 
 arch/arm/mm/dump.c                                                 |    2 
 arch/arm/mm/kasan_init.c                                           |    9 
 arch/arm/mm/mmu.c                                                  |    4 
 arch/arm/plat-orion/Makefile                                       |    2 
 arch/arm64/Kconfig                                                 |   17 
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi              |    2 
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts           |    3 
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi        |    2 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                          |    4 
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi                  |    1 
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi                      |    8 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                              |    4 
 arch/arm64/boot/dts/qcom/pm8350c.dtsi                              |    3 
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts                           |   11 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts              |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi                 |    2 
 arch/arm64/boot/dts/qcom/sc7280-idp.dts                            |    2 
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                               |    9 
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts                          |    9 
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts         |   10 
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi                       |    3 
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts                            |   12 
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts                 |    2 
 arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi            |    2 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                               |    2 
 arch/arm64/boot/dts/renesas/r9a07g043.dtsi                         |    8 
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi                         |    8 
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi                         |    8 
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts              |   10 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                          |   11 
 arch/arm64/include/asm/mte.h                                       |    5 
 arch/arm64/kernel/cpu_errata.c                                     |    5 
 arch/arm64/kernel/cpufeature.c                                     |    3 
 arch/arm64/kernel/ftrace.c                                         |   17 
 arch/arm64/kernel/mte.c                                            |   60 +
 arch/arm64/kernel/suspend.c                                        |    2 
 arch/arm64/kernel/topology.c                                       |   40 -
 arch/arm64/mm/mteswap.c                                            |    7 
 arch/arm64/mm/proc.S                                               |   46 -
 arch/ia64/mm/numa.c                                                |    1 
 arch/m68k/kernel/setup_mm.c                                        |    5 
 arch/mips/bcm47xx/prom.c                                           |    4 
 arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts                 |    6 
 arch/mips/sgi-ip27/ip27-xtalk.c                                    |   70 +-
 arch/mips/sgi-ip30/ip30-xtalk.c                                    |   70 +-
 arch/parisc/include/asm/pgtable.h                                  |    7 
 arch/parisc/kernel/entry.S                                         |    8 
 arch/powerpc/Kconfig                                               |    2 
 arch/powerpc/Makefile                                              |    2 
 arch/powerpc/boot/Makefile                                         |    1 
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi                    |   51 +
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts                           |    2 
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts                           |    2 
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts                           |    2 
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts                           |    2 
 arch/powerpc/boot/dts/turris1x.dts                                 |   14 
 arch/powerpc/configs/pseries_defconfig                             |    1 
 arch/powerpc/include/asm/interrupt.h                               |    3 
 arch/powerpc/include/asm/syscalls.h                                |   12 
 arch/powerpc/kernel/interrupt.c                                    |   10 
 arch/powerpc/kernel/interrupt_64.S                                 |   45 +
 arch/powerpc/kernel/kprobes.c                                      |    8 
 arch/powerpc/kernel/pci_dn.c                                       |    1 
 arch/powerpc/kernel/setup_64.c                                     |    4 
 arch/powerpc/kernel/sys_ppc32.c                                    |   14 
 arch/powerpc/kernel/syscalls.c                                     |    4 
 arch/powerpc/math-emu/math_efp.c                                   |    1 
 arch/powerpc/platforms/powernv/opal.c                              |    1 
 arch/powerpc/platforms/pseries/vas.c                               |    2 
 arch/powerpc/sysdev/fsl_msi.c                                      |    2 
 arch/riscv/Kconfig                                                 |    2 
 arch/riscv/Makefile                                                |    2 
 arch/riscv/include/asm/io.h                                        |   16 
 arch/riscv/include/asm/mmu.h                                       |    1 
 arch/riscv/kernel/setup.c                                          |    4 
 arch/riscv/kernel/smpboot.c                                        |    3 
 arch/riscv/kernel/sys_riscv.c                                      |    3 
 arch/riscv/kernel/vdso.c                                           |   13 
 arch/riscv/mm/fault.c                                              |    3 
 arch/sh/include/asm/sections.h                                     |    2 
 arch/sh/kernel/machvec.c                                           |   10 
 arch/um/kernel/um_arch.c                                           |    2 
 arch/x86/Kconfig                                                   |    7 
 arch/x86/include/asm/cpu.h                                         |    2 
 arch/x86/include/asm/hyperv-tlfs.h                                 |    4 
 arch/x86/include/asm/microcode.h                                   |    1 
 arch/x86/include/asm/msr-index.h                                   |   13 
 arch/x86/include/asm/paravirt_types.h                              |   11 
 arch/x86/kernel/apic/apic.c                                        |   44 +
 arch/x86/kernel/cpu/feat_ctl.c                                     |    2 
 arch/x86/kernel/cpu/mce/apei.c                                     |   13 
 arch/x86/kernel/cpu/microcode/amd.c                                |    3 
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                          |   12 
 arch/x86/kvm/emulate.c                                             |    2 
 arch/x86/kvm/vmx/nested.c                                          |   37 -
 arch/x86/kvm/vmx/vmx.c                                             |   12 
 arch/x86/kvm/x86.c                                                 |   27 
 arch/x86/net/bpf_jit_comp.c                                        |   16 
 arch/x86/xen/enlighten_pv.c                                        |    3 
 block/bio.c                                                        |    2 
 block/blk-mq.c                                                     |    6 
 block/blk-throttle.c                                               |   28 
 block/blk-throttle.h                                               |    2 
 block/blk-wbt.c                                                    |   10 
 block/blk.h                                                        |    3 
 block/elevator.c                                                   |    4 
 crypto/akcipher.c                                                  |    8 
 drivers/acpi/acpi_fpdt.c                                           |   22 
 drivers/acpi/acpi_pcc.c                                            |   28 
 drivers/acpi/acpi_video.c                                          |   16 
 drivers/acpi/apei/ghes.c                                           |    2 
 drivers/acpi/x86/utils.c                                           |   19 
 drivers/ata/libahci_platform.c                                     |   14 
 drivers/base/arch_topology.c                                       |   19 
 drivers/block/nbd.c                                                |    6 
 drivers/bluetooth/btintel.c                                        |   17 
 drivers/bluetooth/btusb.c                                          |   14 
 drivers/bluetooth/hci_ldisc.c                                      |    7 
 drivers/bluetooth/hci_serdev.c                                     |   10 
 drivers/char/hw_random/arm_smccc_trng.c                            |    4 
 drivers/char/hw_random/core.c                                      |   19 
 drivers/char/hw_random/imx-rngc.c                                  |   37 -
 drivers/char/random.c                                              |    4 
 drivers/clk/baikal-t1/ccu-div.c                                    |   65 +
 drivers/clk/baikal-t1/ccu-div.h                                    |   10 
 drivers/clk/baikal-t1/clk-ccu-div.c                                |   26 
 drivers/clk/bcm/clk-bcm2835.c                                      |   43 +
 drivers/clk/berlin/bg2.c                                           |    5 
 drivers/clk/berlin/bg2q.c                                          |    6 
 drivers/clk/clk-ast2600.c                                          |    2 
 drivers/clk/clk-oxnas.c                                            |    6 
 drivers/clk/clk-qoriq.c                                            |   10 
 drivers/clk/clk-versaclock5.c                                      |    2 
 drivers/clk/imx/clk-imx8mp.c                                       |    2 
 drivers/clk/imx/clk-scu.c                                          |    6 
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c                           |    6 
 drivers/clk/mediatek/clk-mt8195-infra_ao.c                         |   13 
 drivers/clk/mediatek/clk-mt8195-mfg.c                              |    6 
 drivers/clk/mediatek/clk-mt8195-vdo0.c                             |    7 
 drivers/clk/mediatek/clk-mt8195-vdo1.c                             |    6 
 drivers/clk/mediatek/clk-mtk.c                                     |   12 
 drivers/clk/meson/meson-aoclk.c                                    |    5 
 drivers/clk/meson/meson-eeclk.c                                    |    5 
 drivers/clk/meson/meson8b.c                                        |    5 
 drivers/clk/qcom/Kconfig                                           |    1 
 drivers/clk/qcom/apss-ipq6018.c                                    |    2 
 drivers/clk/qcom/gcc-sdm660.c                                      |    2 
 drivers/clk/qcom/gcc-sm6115.c                                      |   46 -
 drivers/clk/samsung/clk-exynosautov9.c                             |   20 
 drivers/clk/sprd/common.c                                          |    9 
 drivers/clk/st/clkgen-fsyn.c                                       |    5 
 drivers/clk/st/clkgen-mux.c                                        |    5 
 drivers/clk/tegra/clk-tegra114.c                                   |    1 
 drivers/clk/tegra/clk-tegra20.c                                    |    1 
 drivers/clk/tegra/clk-tegra210.c                                   |    1 
 drivers/clk/ti/clk-dra7-atl.c                                      |    9 
 drivers/clk/ti/clk.c                                               |    5 
 drivers/clk/zynqmp/clkc.c                                          |    7 
 drivers/clk/zynqmp/pll.c                                           |   31 
 drivers/clocksource/arm_arch_timer.c                               |    6 
 drivers/clocksource/timer-gxp.c                                    |    7 
 drivers/cpufreq/amd-pstate.c                                       |   16 
 drivers/cpufreq/intel_pstate.c                                     |    1 
 drivers/cpufreq/qcom-cpufreq-hw.c                                  |   10 
 drivers/cpuidle/cpuidle-riscv-sbi.c                                |    7 
 drivers/crypto/cavium/cpt/cptpf_main.c                             |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                                 |    6 
 drivers/crypto/ccp/sev-dev.c                                       |   26 
 drivers/crypto/hisilicon/qm.c                                      |    6 
 drivers/crypto/hisilicon/zip/zip_crypto.c                          |    4 
 drivers/crypto/inside-secure/safexcel_hash.c                       |    8 
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c                  |   18 
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h                   |    2 
 drivers/crypto/qat/qat_common/qat_algs.c                           |   18 
 drivers/crypto/sahara.c                                            |   18 
 drivers/dma-buf/udmabuf.c                                          |    9 
 drivers/dma/dw-edma/dw-edma-core.c                                 |   12 
 drivers/dma/hisi_dma.c                                             |   28 
 drivers/dma/idxd/irq.c                                             |    2 
 drivers/dma/ioat/dma.c                                             |    6 
 drivers/dma/mxs-dma.c                                              |   11 
 drivers/dma/qcom/qcom_adm.c                                        |   22 
 drivers/dma/ti/k3-udma.c                                           |   25 
 drivers/firmware/efi/libstub/fdt.c                                 |    8 
 drivers/firmware/google/gsmi.c                                     |    9 
 drivers/fpga/dfl-pci.c                                             |   18 
 drivers/fpga/dfl.c                                                 |    2 
 drivers/fsi/fsi-core.c                                             |    3 
 drivers/fsi/fsi-master-ast-cf.c                                    |    2 
 drivers/fsi/fsi-occ.c                                              |   18 
 drivers/gpio/gpio-rockchip.c                                       |    7 
 drivers/gpu/drm/Kconfig                                            |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                     |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                        |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                            |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c                        |    9 
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c                            |   10 
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                 |    5 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c              |   45 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c                   |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                  |   83 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c              |    8 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c         |   11 
 drivers/gpu/drm/amd/display/dc/core/dc.c                           |   16 
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c                       |    6 
 drivers/gpu/drm/amd/display/dc/dc_stream.h                         |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c          |   35 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h          |    3 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c |    6 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c            |    4 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hubp.c                  |    1 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c                 |    4 
 drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c                |    6 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c               |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c     |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c             |    1 
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h                  |    8 
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c                   |    4 
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c                    |   21 
 drivers/gpu/drm/arm/display/komeda/komeda_kms.h                    |    2 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                           |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c                       |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                       |    5 
 drivers/gpu/drm/bridge/analogix/anx7625.c                          |    1 
 drivers/gpu/drm/bridge/ite-it6505.c                                |    5 
 drivers/gpu/drm/bridge/lontium-lt9611.c                            |    3 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c           |    4 
 drivers/gpu/drm/bridge/parade-ps8640.c                             |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                          |   13 
 drivers/gpu/drm/bridge/tc358767.c                                  |    5 
 drivers/gpu/drm/display/drm_dp_helper.c                            |    9 
 drivers/gpu/drm/display/drm_dp_mst_topology.c                      |    6 
 drivers/gpu/drm/drm_bridge.c                                       |    4 
 drivers/gpu/drm/drm_ioctl.c                                        |    8 
 drivers/gpu/drm/drm_mipi_dsi.c                                     |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                     |   18 
 drivers/gpu/drm/i915/display/intel_cdclk.c                         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_context.c                        |    8 
 drivers/gpu/drm/i915/gt/gen6_ppgtt.c                               |   16 
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c                               |   58 -
 drivers/gpu/drm/i915/gt/intel_context.c                            |    5 
 drivers/gpu/drm/i915/gt/intel_context.h                            |    3 
 drivers/gpu/drm/i915/gt/intel_ggtt.c                               |    8 
 drivers/gpu/drm/i915/gt/intel_gtt.c                                |    3 
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c                  |   26 
 drivers/gpu/drm/i915/intel_pm.c                                    |   16 
 drivers/gpu/drm/meson/meson_drv.c                                  |   14 
 drivers/gpu/drm/meson/meson_drv.h                                  |    7 
 drivers/gpu/drm/meson/meson_encoder_cvbs.c                         |   13 
 drivers/gpu/drm/meson/meson_encoder_cvbs.h                         |    1 
 drivers/gpu/drm/meson/meson_encoder_hdmi.c                         |   13 
 drivers/gpu/drm/meson/meson_encoder_hdmi.h                         |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                            |   19 
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c                           |   29 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                           |    9 
 drivers/gpu/drm/msm/dp/dp_catalog.c                                |    2 
 drivers/gpu/drm/msm/msm_drv.c                                      |   13 
 drivers/gpu/drm/msm/msm_drv.h                                      |    2 
 drivers/gpu/drm/msm/msm_io_utils.c                                 |   22 
 drivers/gpu/drm/nouveau/nouveau_bo.c                               |    4 
 drivers/gpu/drm/nouveau/nouveau_connector.c                        |    3 
 drivers/gpu/drm/nouveau/nouveau_prime.c                            |    1 
 drivers/gpu/drm/omapdrm/dss/dss.c                                  |    3 
 drivers/gpu/drm/panel/Kconfig                                      |    4 
 drivers/gpu/drm/pl111/pl111_versatile.c                            |    1 
 drivers/gpu/drm/tests/drm_format_helper_test.c                     |   23 
 drivers/gpu/drm/tiny/bochs.c                                       |    2 
 drivers/gpu/drm/udl/udl_modeset.c                                  |    3 
 drivers/gpu/drm/vc4/vc4_drv.c                                      |   14 
 drivers/gpu/drm/vc4/vc4_drv.h                                      |    1 
 drivers/gpu/drm/vc4/vc4_vec.c                                      |    4 
 drivers/gpu/drm/virtio/virtgpu_display.c                           |    2 
 drivers/gpu/drm/virtio/virtgpu_gem.c                               |    4 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                             |    4 
 drivers/gpu/drm/virtio/virtgpu_object.c                            |    3 
 drivers/gpu/drm/virtio/virtgpu_plane.c                             |    6 
 drivers/gpu/drm/virtio/virtgpu_vq.c                                |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                                |    1 
 drivers/hid/Kconfig                                                |    6 
 drivers/hid/Makefile                                               |    1 
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c                      |    2 
 drivers/hid/hid-ids.h                                              |    3 
 drivers/hid/hid-multitouch.c                                       |    8 
 drivers/hid/hid-nintendo.c                                         |   55 -
 drivers/hid/hid-roccat.c                                           |    4 
 drivers/hid/hid-topre.c                                            |   49 +
 drivers/hid/hid-uclogic-core.c                                     |    1 
 drivers/hid/hid-uclogic-rdesc.c                                    |    2 
 drivers/hsi/clients/ssi_protocol.c                                 |    1 
 drivers/hsi/controllers/omap_ssi_core.c                            |    1 
 drivers/hsi/controllers/omap_ssi_port.c                            |    8 
 drivers/hwmon/gsc-hwmon.c                                          |    1 
 drivers/hwmon/occ/p9_sbe.c                                         |   17 
 drivers/hwmon/pmbus/mp2888.c                                       |   13 
 drivers/hwmon/sht4x.c                                              |    2 
 drivers/i2c/busses/i2c-designware-core.h                           |    7 
 drivers/i2c/busses/i2c-designware-master.c                         |   13 
 drivers/i2c/busses/i2c-designware-pcidrv.c                         |   30 
 drivers/i2c/busses/i2c-mlxbf.c                                     |   44 +
 drivers/iio/adc/ad7923.c                                           |    4 
 drivers/iio/adc/at91-sama5d2_adc.c                                 |   28 
 drivers/iio/adc/ltc2497.c                                          |   13 
 drivers/iio/dac/ad5593r.c                                          |   46 -
 drivers/iio/industrialio-core.c                                    |    5 
 drivers/iio/inkern.c                                               |    8 
 drivers/iio/magnetometer/yamaha-yas530.c                           |    2 
 drivers/iio/pressure/dps310.c                                      |  262 ++++---
 drivers/infiniband/core/cm.c                                       |   14 
 drivers/infiniband/core/uverbs_cmd.c                               |    5 
 drivers/infiniband/core/verbs.c                                    |    2 
 drivers/infiniband/hw/hns/hns_roce_mr.c                            |    1 
 drivers/infiniband/hw/irdma/defs.h                                 |    1 
 drivers/infiniband/hw/irdma/hw.c                                   |   51 -
 drivers/infiniband/hw/irdma/type.h                                 |    1 
 drivers/infiniband/hw/irdma/user.h                                 |    1 
 drivers/infiniband/hw/irdma/utils.c                                |    3 
 drivers/infiniband/hw/irdma/verbs.c                                |   69 +-
 drivers/infiniband/hw/mlx4/mr.c                                    |    1 
 drivers/infiniband/hw/mlx5/main.c                                  |    3 
 drivers/infiniband/hw/mlx5/odp.c                                   |    3 
 drivers/infiniband/sw/rxe/rxe_loc.h                                |    6 
 drivers/infiniband/sw/rxe/rxe_mr.c                                 |   11 
 drivers/infiniband/sw/rxe/rxe_qp.c                                 |   10 
 drivers/infiniband/sw/rxe/rxe_queue.c                              |   12 
 drivers/infiniband/sw/rxe/rxe_resp.c                               |   10 
 drivers/infiniband/sw/rxe/rxe_verbs.c                              |   12 
 drivers/infiniband/sw/siw/siw.h                                    |    1 
 drivers/infiniband/sw/siw/siw_qp.c                                 |    2 
 drivers/infiniband/sw/siw/siw_qp_rx.c                              |   27 
 drivers/infiniband/sw/siw/siw_verbs.c                              |    3 
 drivers/infiniband/ulp/srp/ib_srp.c                                |    4 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                        |   21 
 drivers/iommu/omap-iommu-debug.c                                   |    6 
 drivers/isdn/mISDN/l1oip.h                                         |    1 
 drivers/isdn/mISDN/l1oip_core.c                                    |   13 
 drivers/leds/flash/leds-lm3601x.c                                  |    2 
 drivers/mailbox/bcm-flexrm-mailbox.c                               |    8 
 drivers/mailbox/imx-mailbox.c                                      |   10 
 drivers/mailbox/mailbox-mpfs.c                                     |   25 
 drivers/md/bcache/writeback.c                                      |   73 +-
 drivers/md/dm-verity-loadpin.c                                     |    8 
 drivers/md/dm-verity-target.c                                      |   16 
 drivers/md/dm-verity.h                                             |    1 
 drivers/md/md.c                                                    |    1 
 drivers/md/raid0.c                                                 |    2 
 drivers/md/raid5.c                                                 |   15 
 drivers/media/pci/cx88/cx88-vbi.c                                  |    9 
 drivers/media/pci/cx88/cx88-video.c                                |   43 -
 drivers/media/platform/amlogic/meson-ge2d/ge2d.c                   |    1 
 drivers/media/platform/amphion/vdec.c                              |   16 
 drivers/media/platform/amphion/venc.c                              |    2 
 drivers/media/platform/amphion/vpu.h                               |    1 
 drivers/media/platform/amphion/vpu_core.c                          |   84 +-
 drivers/media/platform/amphion/vpu_core.h                          |    1 
 drivers/media/platform/amphion/vpu_dbg.c                           |    9 
 drivers/media/platform/amphion/vpu_malone.c                        |    2 
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c               |    1 
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c            |    3 
 drivers/media/platform/samsung/exynos4-is/fimc-is.c                |    1 
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c                   |    3 
 drivers/media/platform/xilinx/xilinx-vipp.c                        |    9 
 drivers/media/usb/airspy/airspy.c                                  |    4 
 drivers/media/usb/uvc/uvc_ctrl.c                                   |   83 +-
 drivers/media/usb/uvc/uvc_driver.c                                 |    8 
 drivers/memory/of_memory.c                                         |    2 
 drivers/memory/pl353-smc.c                                         |    1 
 drivers/mfd/da9062-core.c                                          |    1 
 drivers/mfd/fsl-imx25-tsadc.c                                      |   34 
 drivers/mfd/intel_soc_pmic_core.c                                  |    1 
 drivers/mfd/lp8788-irq.c                                           |    3 
 drivers/mfd/lp8788.c                                               |   12 
 drivers/mfd/sm501.c                                                |    7 
 drivers/misc/ocxl/file.c                                           |    2 
 drivers/mmc/core/block.c                                           |    6 
 drivers/mmc/core/card.h                                            |    6 
 drivers/mmc/core/quirks.h                                          |    6 
 drivers/mmc/host/au1xmmc.c                                         |    3 
 drivers/mmc/host/renesas_sdhi_core.c                               |   21 
 drivers/mmc/host/sdhci-msm.c                                       |    1 
 drivers/mmc/host/sdhci-sprd.c                                      |    2 
 drivers/mmc/host/sdhci-tegra.c                                     |    2 
 drivers/mmc/host/wmt-sdmmc.c                                       |    5 
 drivers/mtd/devices/docg3.c                                        |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c                       |    1 
 drivers/mtd/nand/raw/fsl_elbc_nand.c                               |   28 
 drivers/mtd/nand/raw/intel-nand-controller.c                       |   12 
 drivers/mtd/nand/raw/meson_nand.c                                  |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                        |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                   |    3 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                  |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                   |   79 ++
 drivers/net/ethernet/atheros/alx/main.c                            |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                    |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c                      |   10 
 drivers/net/ethernet/engleder/tsnep_hw.h                           |    3 
 drivers/net/ethernet/faraday/ftmac100.h                            |   12 
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c                   |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |  177 ++++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c                       |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                         |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c                 |   10 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                    |   13 
 drivers/net/ethernet/marvell/prestera/prestera_acl.c               |    8 
 drivers/net/ethernet/marvell/prestera/prestera_acl.h               |    4 
 drivers/net/ethernet/marvell/prestera/prestera_flower.c            |    6 
 drivers/net/ethernet/marvell/prestera/prestera_main.c              |   36 -
 drivers/net/ethernet/micrel/ks8851_spi.c                           |    5 
 drivers/net/ethernet/microchip/lan743x_ptp.c                       |    7 
 drivers/net/ethernet/sunplus/spl2sw_driver.c                       |    2 
 drivers/net/ethernet/ti/Kconfig                                    |    1 
 drivers/net/ethernet/ti/davinci_mdio.c                             |  242 ++++++-
 drivers/net/ethernet/xilinx/xilinx_axienet.h                       |   12 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                  |   37 -
 drivers/net/hyperv/hyperv_net.h                                    |    3 
 drivers/net/hyperv/netvsc.c                                        |    4 
 drivers/net/hyperv/netvsc_drv.c                                    |   19 
 drivers/net/thunderbolt.c                                          |   28 
 drivers/net/usb/r8152.c                                            |    4 
 drivers/net/wireless/ath/ath10k/core.c                             |   16 
 drivers/net/wireless/ath/ath10k/htc.c                              |   11 
 drivers/net/wireless/ath/ath10k/hw.h                               |    2 
 drivers/net/wireless/ath/ath10k/mac.c                              |   54 -
 drivers/net/wireless/ath/ath11k/ahb.c                              |   58 +
 drivers/net/wireless/ath/ath11k/core.c                             |    2 
 drivers/net/wireless/ath/ath11k/dp_rx.c                            |    3 
 drivers/net/wireless/ath/ath11k/mac.c                              |   25 
 drivers/net/wireless/ath/ath11k/mhi.c                              |   17 
 drivers/net/wireless/ath/ath11k/peer.c                             |   30 
 drivers/net/wireless/ath/ath11k/qmi.c                              |   38 +
 drivers/net/wireless/ath/ath11k/qmi.h                              |   10 
 drivers/net/wireless/ath/ath11k/wmi.c                              |    9 
 drivers/net/wireless/ath/ath11k/wmi.h                              |    2 
 drivers/net/wireless/ath/ath9k/htc_hst.c                           |   43 -
 drivers/net/wireless/ath/ath9k/rng.c                               |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c             |   12 
 drivers/net/wireless/mac80211_hwsim.c                              |    7 
 drivers/net/wireless/marvell/mwifiex/init.c                        |    9 
 drivers/net/wireless/marvell/mwifiex/main.h                        |    3 
 drivers/net/wireless/marvell/mwifiex/sta_event.c                   |    6 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                   |    4 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c               |   10 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c                |    6 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                    |   12 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                    |   10 
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c               |    5 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                    |    7 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c                   |   26 
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c                    |   15 
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c                   |   13 
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c                    |   28 
 drivers/net/wireless/mediatek/mt76/sdio.c                          |    8 
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c                     |   34 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                   |    6 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c              |   96 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c               |    9 
 drivers/net/wireless/realtek/rtw88/main.c                          |    8 
 drivers/net/wireless/realtek/rtw89/core.c                          |    1 
 drivers/net/wireless/realtek/rtw89/fw.c                            |   12 
 drivers/net/wireless/realtek/rtw89/pci.c                           |    5 
 drivers/net/wireless/realtek/rtw89/ser.c                           |    3 
 drivers/net/wireless/silabs/wfx/main.c                             |    2 
 drivers/net/wireless/st/cw1200/queue.c                             |   18 
 drivers/net/wwan/iosm/iosm_ipc_wwan.c                              |    5 
 drivers/nvme/host/core.c                                           |   20 
 drivers/nvme/host/ioctl.c                                          |    9 
 drivers/nvme/host/multipath.c                                      |    1 
 drivers/nvme/host/nvme.h                                           |    4 
 drivers/nvme/target/core.c                                         |    1 
 drivers/nvme/target/fabrics-cmd-auth.c                             |   13 
 drivers/nvme/target/fabrics-cmd.c                                  |    6 
 drivers/nvme/target/nvmet.h                                        |    7 
 drivers/nvme/target/passthru.c                                     |    7 
 drivers/nvme/target/tcp.c                                          |   11 
 drivers/nvmem/core.c                                               |   15 
 drivers/pci/setup-res.c                                            |   11 
 drivers/perf/riscv_pmu_sbi.c                                       |    7 
 drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c               |    6 
 drivers/phy/mediatek/phy-mtk-tphy.c                                |    7 
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c                            |    7 
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c                           |    6 
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c                      |   10 
 drivers/pinctrl/pinctrl-rockchip.c                                 |   13 
 drivers/platform/chrome/chromeos_laptop.c                          |   24 
 drivers/platform/chrome/cros_ec.c                                  |    8 
 drivers/platform/chrome/cros_ec_chardev.c                          |    3 
 drivers/platform/chrome/cros_ec_proto.c                            |   32 
 drivers/platform/chrome/cros_ec_typec.c                            |    5 
 drivers/platform/x86/hp-wmi.c                                      |   11 
 drivers/platform/x86/msi-laptop.c                                  |   14 
 drivers/platform/x86/pmc_atom.c                                    |    2 
 drivers/power/supply/adp5061.c                                     |    6 
 drivers/powercap/intel_rapl_common.c                               |    4 
 drivers/regulator/core.c                                           |    2 
 drivers/regulator/qcom_rpm-regulator.c                             |   24 
 drivers/remoteproc/remoteproc_core.c                               |    5 
 drivers/rpmsg/rpmsg_char.c                                         |    4 
 drivers/scsi/3w-9xxx.c                                             |    2 
 drivers/scsi/iscsi_tcp.c                                           |   73 +-
 drivers/scsi/iscsi_tcp.h                                           |    3 
 drivers/scsi/libsas/sas_expander.c                                 |    2 
 drivers/scsi/lpfc/lpfc.h                                           |   14 
 drivers/scsi/lpfc/lpfc_crtn.h                                      |    8 
 drivers/scsi/lpfc/lpfc_ct.c                                        |    7 
 drivers/scsi/lpfc/lpfc_debugfs.c                                   |   61 -
 drivers/scsi/lpfc/lpfc_debugfs.h                                   |    2 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                   |    4 
 drivers/scsi/lpfc/lpfc_init.c                                      |  332 ++++-----
 drivers/scsi/lpfc/lpfc_mem.c                                       |    9 
 drivers/scsi/lpfc/lpfc_sli.c                                       |  193 +++++
 drivers/scsi/lpfc/lpfc_sli4.h                                      |    4 
 drivers/scsi/lpfc/lpfc_vmid.c                                      |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                                   |    4 
 drivers/scsi/qedf/qedf_main.c                                      |   21 
 drivers/slimbus/qcom-ngd-ctrl.c                                    |   22 
 drivers/soc/qcom/smem_state.c                                      |    3 
 drivers/soc/qcom/smsm.c                                            |   20 
 drivers/soc/tegra/Kconfig                                          |    1 
 drivers/soc/tegra/fuse/fuse-tegra.c                                |    1 
 drivers/soundwire/cadence_master.c                                 |    9 
 drivers/soundwire/intel.c                                          |    1 
 drivers/spi/spi-cadence-quadspi.c                                  |    3 
 drivers/spi/spi-dw-bt1.c                                           |    4 
 drivers/spi/spi-meson-spicc.c                                      |    6 
 drivers/spi/spi-mt7621.c                                           |    8 
 drivers/spi/spi-omap-100k.c                                        |    1 
 drivers/spi/spi-qup.c                                              |   21 
 drivers/spi/spi-s3c64xx.c                                          |    9 
 drivers/spi/spi.c                                                  |    2 
 drivers/spmi/spmi-pmic-arb.c                                       |   13 
 drivers/staging/greybus/audio_helper.c                             |   11 
 drivers/staging/media/meson/vdec/vdec_hevc.c                       |    6 
 drivers/staging/media/sunxi/cedrus/cedrus.c                        |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c                    |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c                   |    5 
 drivers/staging/rtl8723bs/core/rtw_cmd.c                           |   16 
 drivers/staging/rtl8723bs/os_dep/os_intfs.c                        |   60 -
 drivers/staging/vt6655/device_main.c                               |    8 
 drivers/thermal/cpufreq_cooling.c                                  |   10 
 drivers/thermal/intel/intel_powerclamp.c                           |    6 
 drivers/thermal/qcom/tsens-v0_1.c                                  |    2 
 drivers/thunderbolt/nhi.c                                          |   49 +
 drivers/thunderbolt/switch.c                                       |   24 
 drivers/thunderbolt/tb.h                                           |    1 
 drivers/thunderbolt/tb_regs.h                                      |    1 
 drivers/thunderbolt/usb4.c                                         |   20 
 drivers/tty/serial/8250/8250_core.c                                |   16 
 drivers/tty/serial/8250/8250_omap.c                                |    3 
 drivers/tty/serial/8250/8250_pci.c                                 |   14 
 drivers/tty/serial/8250/8250_port.c                                |   30 
 drivers/tty/serial/ar933x_uart.c                                   |    7 
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                        |   22 
 drivers/tty/serial/fsl_lpuart.c                                    |   12 
 drivers/tty/serial/imx.c                                           |    8 
 drivers/tty/serial/jsm/jsm_driver.c                                |    3 
 drivers/tty/serial/serial_core.c                                   |   36 -
 drivers/tty/serial/stm32-usart.c                                   |  100 +-
 drivers/tty/serial/xilinx_uartps.c                                 |   14 
 drivers/usb/common/debug.c                                         |   96 +-
 drivers/usb/common/usb-conn-gpio.c                                 |    6 
 drivers/usb/core/quirks.c                                          |    4 
 drivers/usb/dwc3/core.c                                            |   83 +-
 drivers/usb/dwc3/core.h                                            |    6 
 drivers/usb/gadget/function/f_fs.c                                 |    4 
 drivers/usb/gadget/function/f_printer.c                            |   12 
 drivers/usb/gadget/function/f_uvc.c                                |    6 
 drivers/usb/gadget/function/uvc.h                                  |    1 
 drivers/usb/gadget/function/uvc_v4l2.c                             |    2 
 drivers/usb/gadget/function/uvc_video.c                            |    9 
 drivers/usb/host/xhci-dbgcap.c                                     |    2 
 drivers/usb/host/xhci-mem.c                                        |    7 
 drivers/usb/host/xhci-plat.c                                       |   18 
 drivers/usb/host/xhci.c                                            |    3 
 drivers/usb/host/xhci.h                                            |    1 
 drivers/usb/misc/idmouse.c                                         |    8 
 drivers/usb/mtu3/mtu3_core.c                                       |    2 
 drivers/usb/mtu3/mtu3_plat.c                                       |    2 
 drivers/usb/musb/musb_gadget.c                                     |    3 
 drivers/usb/storage/unusual_devs.h                                 |    6 
 drivers/usb/typec/anx7411.c                                        |    4 
 drivers/usb/typec/ucsi/ucsi.c                                      |    8 
 drivers/vhost/vsock.c                                              |    2 
 drivers/video/aperture.c                                           |   14 
 drivers/video/fbdev/core/fbmem.c                                   |   12 
 drivers/video/fbdev/smscufx.c                                      |   14 
 drivers/video/fbdev/stifb.c                                        |    2 
 drivers/xen/gntdev-common.h                                        |    3 
 drivers/xen/gntdev.c                                               |   80 +-
 fs/btrfs/block-group.c                                             |   11 
 fs/btrfs/extent-tree.c                                             |    3 
 fs/btrfs/file.c                                                    |   59 +
 fs/btrfs/free-space-cache.c                                        |   59 +
 fs/btrfs/qgroup.c                                                  |   15 
 fs/btrfs/scrub.c                                                   |   69 +-
 fs/btrfs/super.c                                                   |   20 
 fs/cifs/cifsproto.h                                                |    2 
 fs/cifs/connect.c                                                  |    2 
 fs/cifs/file.c                                                     |    9 
 fs/cifs/smb2ops.c                                                  |   23 
 fs/cifs/smb2pdu.c                                                  |    7 
 fs/cifs/smb2transport.c                                            |   10 
 fs/dlm/ast.c                                                       |    6 
 fs/dlm/lock.c                                                      |   20 
 fs/dlm/lowcomms.c                                                  |    4 
 fs/erofs/inode.c                                                   |    2 
 fs/erofs/super.c                                                   |    2 
 fs/eventfd.c                                                       |   10 
 fs/ext2/super.c                                                    |   22 
 fs/ext4/fast_commit.c                                              |   40 -
 fs/ext4/file.c                                                     |    6 
 fs/ext4/inode.c                                                    |   17 
 fs/ext4/ioctl.c                                                    |    4 
 fs/ext4/namei.c                                                    |   17 
 fs/ext4/resize.c                                                   |    2 
 fs/ext4/super.c                                                    |   47 -
 fs/ext4/xattr.c                                                    |    1 
 fs/f2fs/checkpoint.c                                               |   47 +
 fs/f2fs/data.c                                                     |    4 
 fs/f2fs/extent_cache.c                                             |    3 
 fs/f2fs/f2fs.h                                                     |   16 
 fs/f2fs/gc.c                                                       |   22 
 fs/f2fs/recovery.c                                                 |   23 
 fs/f2fs/segment.c                                                  |    2 
 fs/f2fs/super.c                                                    |   15 
 fs/file_table.c                                                    |    7 
 fs/fs-writeback.c                                                  |   37 -
 fs/internal.h                                                      |   10 
 fs/iomap/buffered-io.c                                             |    2 
 fs/jbd2/commit.c                                                   |    2 
 fs/jbd2/journal.c                                                  |   10 
 fs/jbd2/recovery.c                                                 |    1 
 fs/jbd2/transaction.c                                              |    6 
 fs/ksmbd/server.c                                                  |    4 
 fs/ksmbd/smb2pdu.c                                                 |   27 
 fs/ksmbd/smb_common.c                                              |    6 
 fs/mbcache.c                                                       |   17 
 fs/nfsd/nfs3proc.c                                                 |   11 
 fs/nfsd/nfs4proc.c                                                 |   19 
 fs/nfsd/nfs4recover.c                                              |    4 
 fs/nfsd/nfs4state.c                                                |    5 
 fs/nfsd/nfs4xdr.c                                                  |   14 
 fs/nfsd/nfsproc.c                                                  |    6 
 fs/nfsd/xdr4.h                                                     |    3 
 fs/ntfs3/inode.c                                                   |    2 
 fs/ntfs3/xattr.c                                                   |  102 --
 fs/open.c                                                          |   11 
 fs/posix_acl.c                                                     |   25 
 fs/quota/quota_tree.c                                              |   38 +
 fs/userfaultfd.c                                                   |    4 
 fs/xfs/xfs_super.c                                                 |   10 
 include/dt-bindings/clock/samsung,exynosautov9.h                   |   56 -
 include/linux/ata.h                                                |   39 -
 include/linux/bio.h                                                |    2 
 include/linux/blk-mq.h                                             |   11 
 include/linux/blk_types.h                                          |    2 
 include/linux/bpf.h                                                |    3 
 include/linux/bpf_verifier.h                                       |   11 
 include/linux/dynamic_debug.h                                      |   11 
 include/linux/eventfd.h                                            |    2 
 include/linux/export-internal.h                                    |    6 
 include/linux/filter.h                                             |    5 
 include/linux/fortify-string.h                                     |    3 
 include/linux/fs.h                                                 |    9 
 include/linux/hugetlb.h                                            |    8 
 include/linux/hw_random.h                                          |    3 
 include/linux/iio/iio-opaque.h                                     |    2 
 include/linux/iova.h                                               |    2 
 include/linux/mmc/card.h                                           |    1 
 include/linux/once.h                                               |   28 
 include/linux/ring_buffer.h                                        |    2 
 include/linux/sched.h                                              |    2 
 include/linux/serial_8250.h                                        |    1 
 include/linux/serial_core.h                                        |    4 
 include/linux/skbuff.h                                             |    2 
 include/linux/sunrpc/svc.h                                         |   19 
 include/linux/tcp.h                                                |    2 
 include/linux/trace.h                                              |   36 -
 include/linux/trace_events.h                                       |    1 
 include/net/ieee802154_netdev.h                                    |   12 
 include/net/tcp.h                                                  |    5 
 include/uapi/linux/bpf.h                                           |    7 
 include/uapi/rdma/mlx5-abi.h                                       |    1 
 io_uring/fdinfo.c                                                  |   32 
 io_uring/io_uring.c                                                |   29 
 io_uring/io_uring.h                                                |   12 
 io_uring/net.c                                                     |  107 ++-
 io_uring/net.h                                                     |    9 
 io_uring/opdef.c                                                   |   17 
 io_uring/opdef.h                                                   |    1 
 io_uring/rsrc.c                                                    |    1 
 io_uring/rw.c                                                      |   47 +
 io_uring/rw.h                                                      |    1 
 ipc/mqueue.c                                                       |    1 
 kernel/auditsc.c                                                   |    4 
 kernel/bpf/bpf_local_storage.c                                     |    4 
 kernel/bpf/bpf_lsm.c                                               |    6 
 kernel/bpf/bpf_task_storage.c                                      |    8 
 kernel/bpf/btf.c                                                   |    2 
 kernel/bpf/cgroup.c                                                |   28 
 kernel/bpf/core.c                                                  |    9 
 kernel/bpf/dispatcher.c                                            |   27 
 kernel/bpf/hashtab.c                                               |   30 
 kernel/bpf/helpers.c                                               |    2 
 kernel/bpf/syscall.c                                               |    2 
 kernel/bpf/trampoline.c                                            |    8 
 kernel/bpf/verifier.c                                              |  146 ++--
 kernel/cgroup/cgroup.c                                             |    6 
 kernel/cgroup/cpuset.c                                             |   18 
 kernel/livepatch/transition.c                                      |   18 
 kernel/module/tracking.c                                           |    3 
 kernel/rcu/tasks.h                                                 |    5 
 kernel/rcu/tree.c                                                  |   17 
 kernel/rcu/tree_plugin.h                                           |    3 
 kernel/trace/bpf_trace.c                                           |   20 
 kernel/trace/ftrace.c                                              |   34 
 kernel/trace/kprobe_event_gen_test.c                               |   49 +
 kernel/trace/ring_buffer.c                                         |   87 ++
 kernel/trace/trace.c                                               |   76 ++
 kernel/trace/trace_eprobe.c                                        |   63 -
 kernel/trace/trace_events_synth.c                                  |   23 
 kernel/trace/trace_kprobe.c                                        |   60 -
 kernel/trace/trace_osnoise.c                                       |    3 
 kernel/trace/trace_probe_kernel.h                                  |  115 +++
 lib/Kconfig.debug                                                  |   10 
 lib/dynamic_debug.c                                                |   45 -
 lib/once.c                                                         |   30 
 mm/damon/vaddr.c                                                   |   10 
 mm/gup.c                                                           |   14 
 mm/hugetlb.c                                                       |   68 -
 mm/memory.c                                                        |    2 
 mm/mmap.c                                                          |    5 
 mm/mprotect.c                                                      |    2 
 net/bluetooth/hci_core.c                                           |   38 -
 net/bluetooth/hci_event.c                                          |   14 
 net/bluetooth/hci_sock.c                                           |    3 
 net/bluetooth/hci_sync.c                                           |    1 
 net/bluetooth/hci_sysfs.c                                          |    3 
 net/bluetooth/l2cap_core.c                                         |   17 
 net/bluetooth/mgmt.c                                               |    4 
 net/bluetooth/rfcomm/sock.c                                        |    3 
 net/can/bcm.c                                                      |    7 
 net/core/flow_dissector.c                                          |    4 
 net/core/skmsg.c                                                   |   12 
 net/core/stream.c                                                  |    3 
 net/ieee802154/socket.c                                            |    4 
 net/ipv4/datagram.c                                                |    2 
 net/ipv4/esp4_offload.c                                            |    5 
 net/ipv4/inet_hashtables.c                                         |    4 
 net/ipv4/netfilter/nft_fib_ipv4.c                                  |    3 
 net/ipv4/tcp.c                                                     |   16 
 net/ipv4/tcp_output.c                                              |   19 
 net/ipv6/esp6_offload.c                                            |    5 
 net/ipv6/netfilter/nft_fib_ipv6.c                                  |    6 
 net/mac80211/cfg.c                                                 |   17 
 net/mac80211/mlme.c                                                |   20 
 net/mac80211/sta_info.c                                            |    4 
 net/netfilter/nf_conntrack_core.c                                  |   18 
 net/openvswitch/datapath.c                                         |   18 
 net/rds/tcp.c                                                      |    2 
 net/sched/cls_u32.c                                                |    6 
 net/sctp/auth.c                                                    |   18 
 net/unix/af_unix.c                                                 |   13 
 net/unix/garbage.c                                                 |   20 
 net/vmw_vsock/virtio_transport_common.c                            |    2 
 net/wireless/reg.c                                                 |    4 
 net/xdp/xsk.c                                                      |   22 
 net/xdp/xsk_queue.h                                                |   22 
 net/xfrm/xfrm_input.c                                              |   18 
 net/xfrm/xfrm_ipcomp.c                                             |    1 
 scripts/Kbuild.include                                             |   23 
 scripts/package/mkspec                                             |    4 
 scripts/selinux/install_policy.sh                                  |    2 
 security/integrity/ima/ima_appraise.c                              |   12 
 security/loadpin/Kconfig                                           |    2 
 sound/core/pcm_dmaengine.c                                         |    8 
 sound/core/rawmidi.c                                               |    2 
 sound/core/sound_oss.c                                             |   13 
 sound/hda/intel-dsp-config.c                                       |    5 
 sound/pci/hda/hda_beep.c                                           |   15 
 sound/pci/hda/hda_beep.h                                           |    1 
 sound/pci/hda/hda_codec.c                                          |   41 -
 sound/pci/hda/patch_hdmi.c                                         |   36 -
 sound/pci/hda/patch_realtek.c                                      |   11 
 sound/pci/hda/patch_sigmatel.c                                     |   25 
 sound/soc/amd/acp/acp-pci.c                                        |    1 
 sound/soc/amd/yc/acp6x-mach.c                                      |   14 
 sound/soc/codecs/da7219.c                                          |    5 
 sound/soc/codecs/lpass-tx-macro.c                                  |   13 
 sound/soc/codecs/mt6359-accdet.c                                   |    6 
 sound/soc/codecs/mt6660.c                                          |    8 
 sound/soc/codecs/tas2764.c                                         |   78 --
 sound/soc/codecs/wcd-mbhc-v2.c                                     |   10 
 sound/soc/codecs/wcd9335.c                                         |    2 
 sound/soc/codecs/wcd934x.c                                         |    2 
 sound/soc/codecs/wm5102.c                                          |    6 
 sound/soc/codecs/wm5110.c                                          |    6 
 sound/soc/codecs/wm8997.c                                          |    6 
 sound/soc/codecs/wm_adsp.c                                         |    4 
 sound/soc/fsl/eukrea-tlv320.c                                      |    8 
 sound/soc/mediatek/mt8195/mt8195-mt6359.c                          |    6 
 sound/soc/rockchip/rockchip_i2s.c                                  |   41 -
 sound/soc/sh/rcar/ctu.c                                            |    6 
 sound/soc/sh/rcar/dvc.c                                            |    6 
 sound/soc/sh/rcar/mix.c                                            |    6 
 sound/soc/sh/rcar/src.c                                            |    5 
 sound/soc/sh/rcar/ssi.c                                            |    4 
 sound/soc/soc-pcm.c                                                |    2 
 sound/soc/sof/intel/hda.c                                          |   11 
 sound/soc/sof/ipc3-topology.c                                      |    7 
 sound/soc/sof/ipc4-topology.c                                      |    9 
 sound/soc/sof/mediatek/mt8195/mt8195.c                             |    1 
 sound/soc/sof/sof-pci-dev.c                                        |    2 
 sound/soc/sof/sof-priv.h                                           |    4 
 sound/soc/stm/stm32_adfsdm.c                                       |    8 
 sound/soc/stm/stm32_i2s.c                                          |    4 
 sound/soc/stm/stm32_spdifrx.c                                      |    4 
 sound/soc/sunxi/sun4i-codec.c                                      |    3 
 sound/usb/card.c                                                   |   32 
 sound/usb/endpoint.c                                               |   17 
 sound/usb/quirks-table.h                                           |   76 ++
 sound/usb/quirks.c                                                 |  344 ++++++++--
 sound/usb/quirks.h                                                 |    2 
 sound/usb/usbaudio.h                                               |    1 
 tools/bpf/bpftool/btf_dumper.c                                     |    2 
 tools/bpf/bpftool/cgroup.c                                         |   54 +
 tools/bpf/bpftool/main.c                                           |   10 
 tools/include/uapi/linux/bpf.h                                     |    7 
 tools/lib/bpf/bpf_tracing.h                                        |   14 
 tools/lib/bpf/btf.h                                                |   25 
 tools/lib/bpf/btf_dump.c                                           |    2 
 tools/lib/bpf/libbpf.c                                             |   21 
 tools/lib/bpf/libbpf.h                                             |    4 
 tools/lib/bpf/libbpf_probes.c                                      |    2 
 tools/lib/bpf/nlattr.c                                             |    2 
 tools/lib/bpf/usdt.bpf.h                                           |    4 
 tools/objtool/elf.c                                                |    7 
 tools/perf/arch/x86/util/intel-pt.c                                |    2 
 tools/perf/util/intel-pt.c                                         |    9 
 tools/perf/util/parse-events.c                                     |    3 
 tools/perf/util/pmu.c                                              |   17 
 tools/perf/util/pmu.h                                              |    2 
 tools/perf/util/pmu.l                                              |    2 
 tools/perf/util/pmu.y                                              |   15 
 tools/power/x86/turbostat/turbostat.c                              |    1 
 tools/testing/selftests/arm64/signal/testcases/testcases.c         |    2 
 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c        |    2 
 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c         |    2 
 tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c     |    2 
 tools/testing/selftests/bpf/prog_tests/cgroup_link.c               |   11 
 tools/testing/selftests/bpf/progs/kprobe_multi.c                   |    4 
 tools/testing/selftests/bpf/test_maps.c                            |   24 
 tools/testing/selftests/bpf/xsk.c                                  |    6 
 tools/testing/selftests/bpf/xskxceiver.c                           |    4 
 tools/testing/selftests/cpu-hotplug/config                         |    1 
 tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh             |  138 +---
 tools/testing/selftests/net/fcnal-test.sh                          |   30 
 tools/testing/selftests/net/nettest.c                              |   16 
 tools/testing/selftests/tpm2/tpm2.py                               |    4 
 898 files changed, 8533 insertions(+), 4009 deletions(-)

Aaron Tomlin (1):
      module: tracking: Keep a record of tainted unloaded modules only

Abhishek Pandit-Subedi (1):
      Bluetooth: Prevent double register of suspend

Adam Skladowski (1):
      clk: qcom: gcc-sm6115: Override default Alpha PLL regs

Adrian Hunter (2):
      perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc
      perf intel-pt: Fix system_wide dummy event for hybrid

Adrián Larumbe (3):
      drm/meson: reorder driver deinit sequence to fix use-after-free bug
      drm/meson: explicitly remove aggregate driver at module unload time
      drm/meson: remove drm bridges at aggregate driver unbind time

Aharon Landau (1):
      RDMA/mlx5: Don't compare mkey tags in DEVX indirect mkey

Albert Briscoe (1):
      usb: gadget: function: fix dangling pnp_string in f_printer.c

Alex Sverdlin (1):
      ARM: 9242/1: kasan: Only map modules if CONFIG_KASAN_VMALLOC=n

Alexander Aring (6):
      fs: dlm: fix race between test_bit() and queue_work()
      fs: dlm: handle -EBUSY first in lock arg validation
      fs: dlm: fix invalid derefence of sb_lvbptr
      fs: dlm: fix race in lowcomms
      net: ieee802154: return -EINVAL for unknown addr type
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Stein (9):
      ARM: dts: imx6: delete interrupts property if interrupts-extended is set
      ARM: dts: imx6q: add missing properties for sram
      ARM: dts: imx6dl: add missing properties for sram
      ARM: dts: imx6qp: add missing properties for sram
      ARM: dts: imx6sl: add missing properties for sram
      ARM: dts: imx6sll: add missing properties for sram
      ARM: dts: imx6sx: add missing properties for sram
      usb: dwc3: core: add gfladj_refclk_lpm_sel quirk
      arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes

Alexander Zhu (1):
      btrfs: fix alignment of VMA for memory mapped files on THP

Alvin Lee (1):
      drm/amd/display: Fix watermark calculation

Alvin Šipraga (2):
      drm: bridge: adv7511: fix CEC power down control register offset
      drm: bridge: adv7511: unregister cec i2c device after cec adapter

Amir Goldstein (1):
      locks: fix TOCTOU race when granting write lease

Andreas Pape (1):
      ALSA: dmaengine: increment buffer pointer atomically

Andrew Bresticker (2):
      riscv: Allow PROT_WRITE-only mmap()
      riscv: Make VM_WRITE imply VM_READ

Andrew Gaul (1):
      r8152: Rate limit overflow messages

Andrew Perepechko (1):
      jbd2: wake up journal waiters in FIFO order, not LIFO

Andri Yngvason (1):
      HID: multitouch: Add memory barriers

Andrii Nakryiko (3):
      libbpf: Fix crash if SEC("freplace") programs don't have attach_prog_fd set
      libbpf: restore memory layout of bpf_object_open_opts
      libbpf: Don't require full struct enum64 in UAPI headers

Andy Shevchenko (2):
      i2c: designware-pci: Group AMD NAVI quirk parts together
      platform/x86: pmc_atom: Improve quirk message to be less cryptic

AngeloGioacchino Del Regno (6):
      ASoC: mediatek: mt8195-mt6359: Properly register sound card for SOF
      ASoC: SOF: mediatek: mt8195: Import namespace SND_SOC_SOF_MTK_COMMON
      clk: mediatek: clk-mt8195-vdo0: Set rate on vdo0_dp_intf0_dp_intf's parent
      clk: mediatek: clk-mt8195-vdo1: Reparent and set rate on vdo1_dpintf's parent
      clk: mediatek: mt8195-infra_ao: Set pwrmcu clocks as critical
      clk: mediatek: clk-mt8195-mfg: Reparent mfg_bg3d and propagate rate changes

Anna Schumaker (1):
      NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data

Anssi Hannula (4):
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart

Antoine Tenart (2):
      netfilter: conntrack: fix the gc rescheduling delay
      netfilter: conntrack: revisit the gc initial rescheduling bias

Anup Patel (1):
      cpuidle: riscv-sbi: Fix CPU_PM_CPU_IDLE_ENTER_xyz() macro usage

Ard Biesheuvel (1):
      efi: libstub: drop pointless get_memory_map() call

Aric Cyr (2):
      drm/amd/display: Remove interface for periodic interrupt 1
      Revert "drm/amd/display: correct hostvm flag"

Arnd Bergmann (1):
      ARM: orion: fix include path

Arun Easi (1):
      scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled

Arvid Norlander (1):
      ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Arınç ÜNAL (1):
      mips: dts: ralink: mt7621: fix external phy on GB-PC2

Asmaa Mnebhi (1):
      i2c: mlxbf: support lock mechanism

Aurabindo Pillai (1):
      drm/amd/display: Add HUBP surface flip interrupt handler

Avri Altman (1):
      mmc: core: Add SD card quirk for broken discard

Baochen Qiang (1):
      wifi: ath11k: Include STA_KEEPALIVE_ARP_RESPONSE TLV header by default

Baokun Li (1):
      ext4: fix null-ptr-deref in ext4_write_info

Baolin Wang (2):
      mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
      mm/damon: validate if the pmd entry is present before accessing

Bart Van Assche (3):
      ARM: 9243/1: riscpc: Unbreak the build
      RDMA/srp: Fix srp_abort()
      block: Fix the enum blk_eh_timer_return documentation

Basavaraj Natikar (1):
      HID: amd_sfh: Handle condition of "no sensors" for SFH1.1

Bernard Metzler (2):
      RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.
      RDMA/siw: Fix QP destroy to wait for all references dropped.

Bernard Zhao (1):
      drm/amd: fix potential memory leak

Bhupesh Sharma (1):
      arm64: dts: qcom: sc8280xp-pmics: Remove reg entry & use correct node name for pmc8280c_lpg node

Biju Das (4):
      mmc: renesas_sdhi: Fix rounding errors
      arm64: dts: renesas: r9a07g044: Fix SCI{Rx,Tx} interrupt types
      arm64: dts: renesas: r9a07g054: Fix SCI{Rx,Tx} interrupt types
      arm64: dts: renesas: r9a07g043: Fix SCI{Rx,Tx} interrupt types

Bill Wendling (1):
      x86/paravirt: add extra clobbers with ZERO_CALL_USED_REGS enabled

Bitterblue Smith (5):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
      wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
      wifi: rtl8xxxu: gen2: Enable 40 MHz channel width
      wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM

Bob Pearson (2):
      RDMA/rxe: Set pd early in mr alloc routines
      RDMA/rxe: Fix resize_finish() in rxe_queue.c

Bryan O'Donoghue (1):
      arm64: dts: qcom: pm8350c: Drop PWM reg declaration

Callum Osmotherly (1):
      ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Carlos Llamas (1):
      mm/mmap: undo ->mmap() when arch_validate_flags() fails

Catalin Marinas (1):
      arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored

Cezary Rojewski (1):
      ALSA: hda: Fix page fault in snd_hda_codec_shutdown()

Chanho Park (2):
      dt-bindings: clock: exynosautov9: correct clock numbering of peric0/c1
      clk: samsung: exynosautov9: correct register offsets of peric0/c1

Chao Qin (1):
      powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Chao Yu (3):
      f2fs: fix to do sanity check on destination blkaddr during recovery
      f2fs: fix to do sanity check on summary info
      f2fs: fix to account FS_CP_DATA_IO correctly

Chen-Yu Tsai (4):
      drm/bridge: parade-ps8640: Fix regulator supply order
      clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent
      clk: mediatek: fix unregister function in mtk_clk_register_dividers cleanup
      clk: mediatek: Migrate remaining clk_unregister_*() to clk_hw_unregister_*()

Chia-I Wu (1):
      drm/virtio: set fb_modifiers_not_supported

Chris Packham (1):
      arm64: dts: marvell: 98dx25xx: use correct property for i2c gpios

Chris Wilson (1):
      drm/i915/gt: Use i915_vm_put on ppgtt_create error paths

Christian Brauner (2):
      ntfs3: rework xattr handlers and switch to POSIX ACL VFS helpers
      acl: return EOPNOTSUPP in posix_acl_fix_xattr_common()

Christian Marangi (3):
      dmaengine: qcom-adm: fix wrong sizeof config in slave_config
      dmaengine: qcom-adm: fix wrong calling convention for prep_slave_sg
      wifi: ath11k: fix peer addition/deletion error on sta band migration

Christoph Hellwig (2):
      nvmet-auth: don't try to cancel a non-initialized work_struct
      ARM/dma-mapping: don't override ->dma_coherent when set from a bus notifier

Christophe JAILLET (11):
      nfsd: Fix a memory leak in an error handling path
      spi: mt7621: Fix an error message in mt7621_spi_probe()
      mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
      ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()
      mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()
      usb: common: usb-conn-gpio: Simplify some error message
      coresight: docs: Fix a broken reference
      mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
      mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
      mfd: lp8788: Fix an error handling path in lp8788_probe()
      mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Christophe Leroy (2):
      serial: cpm_uart: Don't request IRQ too early for console port
      powerpc/Kconfig: Fix non existing CONFIG_PPC_FSL_BOOKE

Chuck Lever (7):
      NFSD: Protect against send buffer overflow in NFSv3 READDIR
      NFSD: Protect against send buffer overflow in NFSv2 READ
      NFSD: Protect against send buffer overflow in NFSv3 READ
      SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
      SUNRPC: Fix svcxdr_init_encode's buflen calculation
      NFSD: Protect against send buffer overflow in NFSv2 READDIR
      NFSD: Fix handling of oversized NFSv4 COMPOUND requests

Chunfeng Yun (2):
      phy: phy-mtk-tphy: fix the phy type setting issue
      usb: mtu3: fix failed runtime suspend in host only mode

Claudiu Beznea (4):
      iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
      iio: adc: at91-sama5d2_adc: check return status for pressure and touch
      iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq
      iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume

Coly Li (1):
      bcache: fix set_at_max_writeback_rate() for multiple attached devices

Conner Knox (1):
      ALSA: usb-audio: Add quirk to enable Avid Mbox 3 support

Conor Dooley (4):
      arm64: topology: move store_cpu_topology() to shared code
      riscv: topology: fix default topology reporting
      mailbox: mpfs: fix handling of the reg property
      mailbox: mpfs: account for mbox offsets while sending

Cristian Ciocaltea (1):
      ASoC: wm_adsp: Handle optional legacy support

Dai Ngo (1):
      NFSD: fix use-after-free on source server when doing inter-server copy

Daisuke Matsuda (2):
      IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers
      RDMA/rxe: Delete error messages triggered by incoming Read requests

Damian Muszynski (1):
      crypto: qat - fix DMA transfer direction

Dan Carpenter (18):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      wifi: wfx: prevent underflow in wfx_send_pds()
      wifi: mt76: mt7915: fix an uninitialized variable bug
      wifi: mt76: mt7921: fix use after free in mt7921_acpi_read()
      drm/bridge: Avoid uninitialized variable warning
      ASoC: mt6359: fix tests for platform_get_irq() failure
      platform/chrome: fix memory corruption in ioctl
      virtio-gpu: fix shift wrapping bug in virtio_gpu_fence_event_create()
      fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
      usb: gadget: f_fs: stricter integer overflow checks
      remoteproc: Harden rproc_handle_vdev() against integer overflow
      mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()
      usb: dwc3: core: fix some leaks in probe
      drivers: serial: jsm: fix some leaks in probe
      mfd: fsl-imx25: Fix check for platform_get_irq() errors
      iommu/omap: Fix buffer overflow in debugfs
      crypto: marvell/octeontx - prevent integer overflows
      crypto: cavium - prevent integer overflow loading firmware

Dang Huynh (1):
      clk: qcom: sm6115: Select QCOM_GDSC

Daniel Golle (5):
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620

Daniel Sneddon (1):
      x86/apic: Don't disable x2APIC if locked

Dario Binacchi (1):
      dmaengine: mxs: use platform_driver_register

Darrick J. Wong (1):
      iomap: iomap: fix memory corruption when recording errors during writeback

Dave Jiang (1):
      dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

Dave Marchevsky (1):
      bpf: Cleanup check_refcount_ok

David Collins (1):
      spmi: pmic-arb: correct duplicate APID to PPID mapping logic

David Gow (1):
      drm/amd/display: fix overflow on MIN_I64 definition

David Sloan (1):
      md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()

Deren Wu (1):
      wifi: mt76: mt7921e: fix rmmod crash in driver reload test

Dmitry Baryshkov (2):
      drm/msm: lookup the ICC paths in both mdp5/dpu and mdss devices
      drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Dmitry Osipenko (8):
      drm/virtio: Check whether transferred 2D BO is shmem
      drm/virtio: Unlock reservations on virtio_gpu_object_shmem_init() error
      drm/virtio: Unlock reservations on dma_resv_reserve_fences() error
      drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()
      media: cedrus: Set the platform driver data earlier
      media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
      drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling
      soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA

Dmitry Torokhov (3):
      ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
      arm64: dts: exynos: fix polarity of "enable" line of NFC chip in TM2
      ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Dongliang Mu (3):
      media: airspy: fix memory leak in airspy probe
      phy: qualcomm: call clk_disable_unprepare in the error handling
      usb: idmouse: fix an uninit-value in idmouse_open

Doug Smythies (1):
      cpufreq: intel_pstate: Add Tigerlake support in no-HWP mode

Duoming Zhou (3):
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
      mISDN: fix use-after-free bugs in l1oip timer handlers
      scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Dylan Yudaken (1):
      eventfd: guard wake_up in eventfd fs calls as well

Eddie James (4):
      iio: pressure: dps310: Refactor startup procedure
      iio: pressure: dps310: Reset chip after timeout
      hwmon (occ): Retry for checksum failure
      fsi: occ: Prevent use after free

Enzo Matsumiya (1):
      cifs: return correct error in ->calc_signature()

Eric Dumazet (2):
      once: add DO_ONCE_SLOW() for sleepable contexts
      tcp: annotate data-race around tcp_md5sig_pool_populated

Fangrui Song (1):
      riscv: Pass -mno-relax only on lld < 15.0.0

Fangzhi Zuo (1):
      drm/amd/display: Validate DSC After Enable All New CRTCs

Felix Kuehling (1):
      drm/amdkfd: Fix UBSAN shift-out-of-bounds warning

Filipe Manana (2):
      btrfs: fix race between quota enable and quota rescan ioctl
      btrfs: fix missed extent on fsync after dropping extent maps

Florian Fainelli (1):
      libbpf: Initialize err in probe_map_create

Frieder Schrempf (1):
      arm64: dts: imx8mm-kontron: Use the VSELECT signal to switch SD card IO voltage

Gao Xiang (1):
      erofs: fix order >= MAX_ORDER warning due to crafted negative i_size

Gaosheng Cui (1):
      nvmem: core: Fix memleak in nvmem_register()

Gaurav Kohli (1):
      hv_netvsc: Fix race between VF offering and VF association message from host

Geert Uytterhoeven (2):
      arm64: dts: qcom: sdm845-xiaomi-polaris: Fix sde_dsi_active pinctrl
      ARM: Drop CMDLINE_* dependency on ATAGS

George Shen (1):
      drm/amd/display: Fix urgent latency override for DCN32/DCN321

Gerd Hoffmann (1):
      drm/bochs: fix blanking

Gerhard Engleder (1):
      tsnep: Fix TSNEP_INFO_TX_TIME register define

Greg Kroah-Hartman (3):
      staging: greybus: audio_helper: remove unused and wrong debugfs usage
      selinux: use "grep -E" instead of "egrep"
      Linux 6.0.3

Guilherme G. Piccoli (1):
      firmware: google: Test spinlock on panic path to avoid lockups

Haibo Chen (1):
      ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Hamza Mahfooz (1):
      Revert "drm/amdgpu: use dirty framebuffer helper"

Hangyu Hua (3):
      misc: ocxl: fix possible refcount leak in afu_ioctl()
      ipc: mqueue: fix possible memory leak in init_mqueue_fs()
      media: platform: fix some double free in meson-ge2d and mtk-jpeg and s5p-mfc

Hans de Goede (4):
      platform/x86: msi-laptop: Fix old-ec check for backlight registering
      platform/x86: msi-laptop: Fix resource cleanup
      ACPI: tables: FPDT: Don't call acpi_os_map_memory() on invalid phys address
      platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Haren Myneni (1):
      powerpc/pseries/vas: Pass hw_cpu_id to node associativity HCALL

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Harry Stern (1):
      hid: topre: Add driver fixing report descriptor

Helge Deller (2):
      parisc: fbdev/stifb: Align graphics memory size to 4MB
      parisc: Fix userspace graphics card breakage due to pgtable special bit

Hengqi Chen (1):
      libbpf: Do not require executable permission for shared libraries

Hirokazu Honda (1):
      media: mediatek: vcodec: Skip non CBR bitrate mode

Hou Tao (6):
      bpf: Disable preemption when increasing per-cpu map_locked
      bpf: Propagate error from htab_lock_bucket() to userspace
      bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy
      bpf: Use this_cpu_{inc_return|dec} for prog->active
      bpf: Only add BTF IDs for socket security hooks when CONFIG_SECURITY_NETWORK is on
      selftests/bpf: Free the allocated resources after test case succeeds

Howard Hsu (2):
      wifi: mt76: mt7915: fix mcs value in ht mode
      wifi: mt76: mt7915: do not check state before configuring implicit beamform

Huacai Chen (1):
      UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Huisong Li (2):
      ACPI: PCC: replace wait_for_completion()
      ACPI: PCC: Fix Tx acknowledge in the PCC address space handler

Hyunwoo Kim (2):
      fbdev: smscufx: Fix use-after-free in ufx_ops_open()
      HID: roccat: Fix use-after-free in roccat_read()

Ian Nam (1):
      clk: zynqmp: Fix stack-out-of-bounds in strncpy`

Ian Rogers (1):
      selftests/xsk: Avoid use-after-free on ctx

Ignat Korchagin (1):
      crypto: akcipher - default implementation for setting a private key

Ilpo Järvinen (1):
      serial: 8250: Toggle IER bits on only after irq has been set up

Ivan T. Ivanov (1):
      clk: bcm2835: Round UART input clock up

Jack Wang (2):
      HSI: omap_ssi_port: Fix dma_map_sg error check
      mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Jacky Li (1):
      crypto: ccp - Fail the PSP initialization when writing psp data file failed

Jacob Keller (1):
      ice: set tx_tstamps when creating new Tx rings via ethtool

Jaegeuk Kim (5):
      f2fs: fix wrong continue condition in GC
      f2fs: complete checkpoints during remount
      f2fs: flush pending checkpoints when freezing super
      f2fs: increase the limit for reserve_root
      f2fs: allow direct read for zoned device

Jairaj Arava (1):
      ASoC: SOF: pci: Change DMI match info to support all Chrome platforms

Jakob Hauser (1):
      iio: magnetometer: yas530: Change data type of hard_offsets to signed

Jakub Kicinski (1):
      eth: alx: take rtnl_lock on resume

James Cowgill (1):
      hwrng: arm-smccc-trng - fix NO_ENTROPY handling

James Hilliard (1):
      libbpf: Ensure functions with always_inline attribute are inline

James Morse (1):
      arm64: errata: Add Cortex-A55 to the repeat tlbi list

James Smart (3):
      scsi: lpfc: Rework MIB Rx Monitor debug info logic
      scsi: lpfc: Fix various issues reported by tools
      scsi: lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID

Jameson Thies (1):
      platform/chrome: cros_ec: Notify the PM of wake events during resume

Jan Kara (5):
      mbcache: Avoid nesting of cache->c_list_lock under bit locks
      ext2: Add sanity checks for group and filesystem size
      ext4: avoid crash when inline data creation follows DIO write
      ext4: fix check for block being out of directory size
      ext2: Use kvmalloc() for group descriptor array

Jane Chu (1):
      x86/mce: Retrieve poison range from hardware

Janis Schoetterl-Glausch (1):
      kbuild: rpm-pkg: fix breakage when V=1 is used

Jarkko Nikula (1):
      i2c: designware: Fix handling of real but unexpected device interrupts

Jaroslav Kysela (2):
      ALSA: hda/hdmi: change type for the 'assigned' variable
      ALSA: hda/hdmi: Fix the converter allocation for the silent stream

Jason A. Donenfeld (4):
      hwrng: core - let sleep be interrupted when unregistering hwrng
      m68k: Process bootinfo records before saving them
      random: schedule jitter credit for next jiffy, not in two jiffies
      hwmon: (sht4x) do not overflow clamping operation on 32-bit platforms

Javier Martinez Canillas (3):
      drm/msm: Make .remove and .shutdown HW shutdown consistent
      drm: Use size_t type for len variable in drm_copy_field()
      drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jeff Layton (2):
      ext4: unconditionally enable the i_version counter
      ext4: fix i_version handling in ext4

Jens Axboe (4):
      io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT
      io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128
      io_uring/rw: defer fsnotify calls to task context
      io_uring/rw: ensure kiocb_end_write() is always called

Jens Hillenstedt (1):
      mfd: da9061: Fix Failed to set Two-Wire Bus Mode.

Jerry Lee 李修賢 (1):
      ext4: continue to expand file system when the target size doesn't reach

Jerry Ray (1):
      micrel: ksz8851: fixes struct pointer issue

Jerry Snitselaar (1):
      dmaengine: idxd: avoid deadlock in process_misc_interrupts()

Jesus Fernandez Manzano (1):
      wifi: ath11k: fix number of VHT beamformee spatial streams

Jia Zhu (1):
      erofs: use kill_anon_super() to kill super in fscache mode

Jianglei Nie (6):
      drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()
      bnx2x: fix potential memory leak in bnx2x_tpa_stop()
      wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
      drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()
      HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()
      usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Jiasheng Jiang (4):
      net: prestera: acl: Add check for kmemdup
      ASoC: rsnd: Add check for rsnd_mod_power_on
      fsi: core: Check error number after calling ida_simple_get
      mfd: sm501: Add check for platform_driver_register()

Jie Hai (3):
      dmaengine: hisilicon: Disable channels when unregister hisi_dma
      dmaengine: hisilicon: Fix CQ head update
      dmaengine: hisilicon: Add multi-thread support for a DMA channel

Jim Cromie (4):
      dyndbg: fix static_branch manipulation
      dyndbg: fix module.dyndbg handling
      dyndbg: let query-modname override actual module name
      dyndbg: drop EXPORTed dynamic_debug_exec_queries

Jinke Han (1):
      ext4: place buffer head allocation before handle start

Jiri Olsa (1):
      bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT

Jisheng Zhang (1):
      riscv: vdso: fix NULL deference in vdso_join_timens() when vfork

Joanne Koong (1):
      bpf: Fix ref_obj_id for dynptr data slices in verifier

Joel Stanley (1):
      clk: ast2600: BCLK comes from EPLL

Johan Hovold (6):
      arm64: dts: qcom: sc8280xp-crd: disallow regulator mode switches
      arm64: dts: qcom: sc8280xp-lenovo-thinkpad-x13s: disallow regulator mode switches
      arm64: dts: qcom: sa8295p-adp: disallow regulator mode switches
      arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size
      arm64: dts: qcom: sm8450: fix UFS PHY serdes size
      phy: qcom-qmp-usb: disable runtime PM on unbind

Johannes Berg (4):
      wifi: mac80211: fix use-after-free
      wifi: mac80211_hwsim: fix link change handling
      wifi: mac80211: mlme: assign link address correctly
      wifi: mac80211: accept STA changes without link changes

John Garry (1):
      scsi: pm8001: Fix running_req for internal abort commands

Johnothan King (1):
      HID: nintendo: check analog user calibration for plausibility

Jonathan Cameron (1):
      iio: ABI: Fix wrong format of differential capacitance channel ABI.

Jorge Lopez (1):
      platform/x86: hp-wmi: Setting thermal profile fails with 0x06

Josef Bacik (1):
      btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure

Josh Triplett (1):
      ext4: don't run ext4lazyinit for read-only filesystems

José Expósito (4):
      drm/format-helper: Fix test on big endian architectures
      HID: uclogic: Add missing suffix for digitalizers
      HID: uclogic: Fix warning in uclogic_rdesc_template_apply
      media: uvcvideo: Fix memory leak in uvc_gpio_parse

Judy Hsiao (2):
      ASoC: rockchip: i2s: use regmap_read_poll_timeout to poll I2S_CLR
      ASoC: rockchip: i2s: use regmap_read_poll_timeout_atomic to poll I2S_CLR

Junichi Uekawa (1):
      vhost/vsock: Use kvmalloc/kvfree for larger packets.

Justin Chen (2):
      usb: host: xhci-plat: suspend and resume clocks
      usb: host: xhci-plat: suspend/resume clks for brcm

Kees Cook (7):
      sh: machvec: Use char[] for section boundaries
      x86/microcode/AMD: Track patch allocation size explicitly
      fortify: Fix __compiletime_strlen() under UBSAN_BOUNDS_LOCAL
      MIPS: BCM47XX: Cast memcmp() of function to (void *)
      ARM: decompressor: Include .data.rel.ro.local
      x86/entry: Work around Clang __bdos() bug
      net: sched: cls_u32: Avoid memcpy() false-positive warning

Keith Busch (3):
      nvme: handle effects after freeing the request
      nvme: copy firmware_rev on each init
      blk-mq: use quiesced elevator switch when reinitializing queues

Khaled Almahallawy (1):
      drm/dp: Don't rewrite link config when setting phy test pattern

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Kiran K (1):
      Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk

Koba Ko (1):
      crypto: ccp - Release dma channels before dmaengine unrgister

Kohei Tarumizu (1):
      x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Krzysztof Kozlowski (8):
      arm64: dts: qcom: sdm845-mtp: correct ADC settle time
      ASoC: wcd9335: fix order of Slimbus unprepare/disable
      ASoC: wcd934x: fix order of Slimbus unprepare/disable
      slimbus: qcom-ngd: use correct error in message of pdr_add_lookup() failure
      slimbus: qcom-ngd: cleanup in probe error path
      ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()"
      arm64: dts: qcom: sm8350-sagami: correct TS pin property
      arm64: dts: qcom: sc7280-idp: correct ADC channel node name and unit address

Kshitiz Varshney (1):
      hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()

Kumar Kartikeya Dwivedi (1):
      bpf: Fix reference state management for synchronous callbacks

Kuninori Morimoto (1):
      ASoC: soc-pcm.c: call __soc_pcm_close() in soc_pcm_close()

Kuniyuki Iwashima (1):
      af_unix: Fix memory leaks of the whole sk due to OOB skb.

Kunkun Jiang (1):
      clocksource/drivers/arm_arch_timer: Fix handling of ARM erratum 858921

Kuogee Hsieh (1):
      drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()

Lalith Rajendran (1):
      ext4: make ext4_lazyinit_thread freezable

Lam Thai (1):
      bpftool: Fix a wrong type cast in btf_dumper_int

Lee Jones (1):
      bpf: Ensure correct locking around vulnerable function find_vpid()

Letu Ren (1):
      scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Li Huafei (3):
      powerpc/kprobes: Fix null pointer reference in arch_prepare_kprobe()
      ARM: 9233/1: stacktrace: Skip frame pointer boundary check for call_with_stack()
      ARM: 9234/1: stacktrace: Avoid duplicate saving of exception PC value

Liang He (24):
      hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API
      drm/bridge: anx7625: Fix refcount bug in anx7625_parse_dt()
      drm/bridge: tc358767: Add of_node_put() when breaking out of loop
      drm:pl111: Add of_node_put() when breaking out of for_each_available_child_of_node()
      drm/omap: dss: Fix refcount leak bugs
      ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
      memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
      memory: of: Fix refcount leak bug in of_get_ddr_timings()
      memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()
      soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
      soc: qcom: smem_state: Add refcounting for the 'state->of_node'
      soc/tegra: fuse: Add missing of_node_put() in tegra_init_fuse()
      clk: meson: Hold reference returned by of_get_parent()
      clk: st: Hold reference returned by of_get_parent()
      clk: oxnas: Hold reference returned by of_get_parent()
      clk: qoriq: Hold reference returned by of_get_parent()
      clk: berlin: Add of_node_put() for of_get_parent()
      clk: sprd: Hold reference returned by of_get_parent()
      media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
      phy: amlogic: phy-meson-axg-mipi-pcie-analog: Hold reference returned by of_get_parent()
      usb: typec: anx7411: Use of_get_child_by_name() instead of of_find_node_by_name()
      clk: ti: Balance of_node_get() calls for of_find_node_by_name()
      powerpc/sysdev/fsl_msi: Add missing of_node_put()
      powerpc/pci_dn: Add missing of_node_put()

Lin Yujun (5):
      MIPS: SGI-IP30: Fix platform-device leak in bridge_platform_create()
      MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()
      slimbus: qcom-ngd: Add error handling in of_qcom_slim_ngd_register
      clk: imx: scu: fix memleak on platform_device_add() fails
      clocksource/drivers/timer-gxp: Add missing error handling in gxp_timer_probe

Linus Walleij (1):
      regulator: qcom_rpm: Fix circular deferral regression

Liu Jian (3):
      skmsg: Schedule psock work if the cached skb exists on the psock
      xfrm: Reinject transport-mode packets through workqueue
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Liu Shixin (1):
      mm: hugetlb: fix UAF in hugetlb_handle_userfault

Liviu Dudau (1):
      drm/komeda: Fix handling of atomic commits in the atomic_commit_tail hook

Logan Gunthorpe (3):
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md: Remove extra mddev_get() in md_seq_start()
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Lorenzo Bianconi (4):
      wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload
      wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup
      wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv
      wifi: mt76: fix uninitialized pointer in mt7921_mac_fill_rx

Lucas Segarra Fernandez (1):
      crypto: qat - fix default value of WDT timer

Lucas Stach (2):
      ARM: dts: imx6qdl-kontron-samx6i: hook up DDC i2c bus
      drm: bridge: dw_hdmi: only trigger hotplug event on link change

Luciano Leão (1):
      x86/cpu: Include the header of init_ia32_feat_ctl()'s prototype

Luiz Augusto von Dentz (6):
      Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
      Bluetooth: hci_core: Fix not handling link timeouts propertly
      Bluetooth: hci_sync: Fix not indicating power state
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: hci_event: Make sure ISO events don't affect non-ISO connections
      Bluetooth: L2CAP: Fix user-after-free

Lukas Czerner (2):
      fs: record I_DIRTY_TIME even if inode already has I_DIRTY_INODE
      ext4: don't increase iversion counter for ea_inodes

Lukas Wunner (3):
      serial: stm32: Deassert Transmit Enable on ->rs485_config()
      serial: Deassert Transmit Enable on probe in driver-specific way
      serial: ar933x: Deassert Transmit Enable on ->rs485_config()

Luke D. Jones (2):
      ALSA: hda/realtek: Correct pin configs for ASUS G533Z
      ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Lv Ruyi (1):
      fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe

Lyude Paul (1):
      drm/nouveau/kms/nv140-: Disable interlacing

M. Vefa Bicakci (2):
      xen/gntdev: Prevent leaking grants
      xen/gntdev: Accommodate VMA splitting

Maciej Fijalkowski (2):
      xsk: Fix backpressure mechanism on Tx
      selftests/xsk: Add missing close() on netns fd

Maciej S. Szmigiero (1):
      btrfs: don't print information about space cache or tree every remount

Maciej W. Rozycki (4):
      RISC-V: Make port I/O string accessors actually work
      PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge
      serial: 8250: Let drivers request full 16550A feature probing
      serial: 8250: Request full 16550A feature probing for OxSemi PCIe devices

Maksym Glubokiy (1):
      net: prestera: cache port state for non-phylink ports too

Manikanta Pubbisetty (2):
      wifi: ath11k: Fix incorrect QMI message ID mappings
      wifi: ath11k: Register shutdown handler for WCN6750

Manivannan Sadhasivam (1):
      dmaengine: dw-edma: Remove runtime PM support

Marcel Ziswiler (2):
      ARM: dts: imx6sl: use tabs for code indent
      ARM: dts: imx6sx-udoo-neo: don't use multiple blank lines

Marek Behún (1):
      ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Marek Szyprowski (1):
      spi: Ensure that sg_table won't be used after being freed

Marijn Suijten (1):
      clk: qcom: gcc-sdm660: Use floor ops for SDCC1 clock

Mario Limonciello (4):
      thunderbolt: Explicitly enable lane adapter hotplug events at startup
      xhci: Don't show warning for reinit on known broken suspend
      ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable
      ASoC: amd: yc: Add Lenovo Yoga Slim 7 Pro X to quirks table

Mark Brown (1):
      kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT

Mark Rutland (1):
      arm64: ftrace: fix module PLTs with mcount

Mark Zhang (1):
      RDMA/cm: Use SLID in the work completion as the DLID in responder side

Martin Blumenstingl (2):
      mtd: rawnand: intel: Read the chip-select line from the correct OF node
      mtd: rawnand: intel: Remove undocumented compatible string

Martin Kaiser (1):
      hwrng: imx-rngc - use devm_clk_get_enabled

Martin Leung (1):
      drm/amd/display: zeromem mypipe heap struct before using it

Martin Povišer (3):
      ASoC: tas2764: Allow mono streams
      ASoC: tas2764: Drop conflicting set_bias_level power setting
      ASoC: tas2764: Fix mute/unmute

Masahiro Yamada (4):
      kbuild: remove the target in signal traps when interrupted
      linux/export: use inline assembler to populate symbol CRCs
      Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5
      Kconfig.debug: add toolchain checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT

Mateusz Kwiatkowski (1):
      drm/vc4: vec: Fix timings for VEC modes

Matt Ranostay (1):
      arm64: dts: ti: k3-j7200: fix main pinmux range

Matthew Gerlach (1):
      fpga: dfl-pci: Add IDs for Intel N6000, N6001 and C6100 cards

Matthias Kaehlcke (2):
      dm: verity-loadpin: Only trust verity targets with enforcement
      LoadPin: Fix Kconfig doc about format of file with verity digests

Maxim Mikityanskiy (1):
      net: wwan: iosm: Call mutex_init before locking it

Maxime Ripard (3):
      drm/mipi-dsi: Detach devices when removing the host
      drm/vc4: drv: Call component_unbind_all()
      clk: bcm2835: Make peripheral PLLC critical

Maya Matuszczyk (2):
      drm: panel-orientation-quirks: Add quirk for Anbernic Win600
      drm: panel-orientation-quirks: Add quirk for Aya Neo Air

Miaoqian Lin (6):
      clk: tegra: Fix refcount leak in tegra210_clock_init
      clk: tegra: Fix refcount leak in tegra114_clock_init
      clk: tegra20: Fix refcount leak in tegra20_clock_init
      HSI: omap_ssi: Fix refcount leak in ssi_probe
      media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
      clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Michael Ellerman (1):
      powerpc/configs: Properly enable PAPR_SCM in pseries_defconfig

Michael Grzeschik (1):
      usb: gadget: uvc: increase worker prio to WQ_HIGHPRI

Michael Hennerich (1):
      iio: dac: ad5593r: Fix i2c read protocol requirements

Michael Walle (2):
      ARM: dts: kirkwood: lsxl: fix serial line
      ARM: dts: kirkwood: lsxl: remove first ethernet port

Michal Hocko (1):
      rcu: Back off upon fill_page_cache_func() allocation failure

Michal Jaron (1):
      iavf: Fix race between iavf_close and iavf_reset_task

Michal Koutný (1):
      cgroup: Honor caller's cgroup NS when resolving path

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mickaël Salaün (1):
      ksmbd: Fix user namespace mapping

Mika Westerberg (2):
      net: thunderbolt: Enable DMA paths only after rings are enabled
      thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround

Mike Christie (1):
      scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Mikhail Rudenko (1):
      ASoC: sunxi: sun4i-codec: set debugfs_prefix for CPU DAI component

Mimi Zohar (1):
      ima: fix blocking of security.ima xattrs of unsupported algorithms

Ming Qian (4):
      media: amphion: insert picture startcode after seek for vc1g format
      media: amphion: adjust the encoder's value range of gop size
      media: amphion: don't change the colorspace reported by decoder.
      media: amphion: fix a bug that vpu core may not resume after suspend

Mordechay Goodstein (1):
      wifi: mac80211: mlme: don't add empty EML capabilities

Muralidhar Reddy (1):
      ALSA: intel-dspconfig: add ES8336 support for AlderLake-PS

Nam Cao (2):
      staging: vt6655: fix some erroneous memory clean-up loops
      staging: vt6655: fix potential memory leak

Namjae Jeon (2):
      ksmbd: fix incorrect handling of iterate_dir
      ksmbd: fix endless loop when encryption for response fails

Nathan Chancellor (4):
      usb: gadget: uvc: Fix argument to sizeof() in uvc_register_video()
      powerpc/math_emu/efp: Include module.h
      drm/amd/display: Fix build breakage with CONFIG_DEBUG_FS=n
      lib/Kconfig.debug: Add check for non-constant .{s,u}leb128 support to DWARF5

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Neil Armstrong (1):
      spi: meson-spicc: do not rely on busy flag in pow2 clk ops

Nicholas Kazlauskas (1):
      drm/amd/display: Update PMFW z-state interface for DCN314

Nicholas Piggin (5):
      powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5
      powerpc/64/interrupt: Fix false warning in context tracking due to idle state
      powerpc/64: mark irqs hard disabled in boot paca
      powerpc/64/interrupt: Fix return to masked context after hard-mask irq becomes pending
      powerpc/64s/interrupt: Fix lost interrupts when returning to soft-masked context

Nico Pache (1):
      tracing/osnoise: Fix possible recursive locking in stop_per_cpu_kthreads

Nicolas Dufresne (1):
      media: cedrus: Fix watchdog race condition

Niklas Cassel (4):
      ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
      ata: fix ata_id_has_devslp()
      ata: fix ata_id_has_ncq_autosense()
      ata: fix ata_id_has_dipm()

Nuno Sá (3):
      iio: adc: ad7923: fix channel readings for some variants
      iio: inkern: only release the device node when done with it
      iio: inkern: fix return value in devm_of_iio_channel_get_by_name()

Oleksandr Shamray (1):
      hwmon: (pmbus/mp2888) Fix sensors readouts for MPS Multi-phase mp2888 controller

Ondrej Mosnacek (1):
      userfaultfd: open userfaultfds with O_RDONLY

Pali Rohár (6):
      powerpc/boot: Explicitly disable usage of SPE instructions
      mtd: rawnand: fsl_elbc: Fix none ECC mode
      serial: 8250: Fix restoring termios speed after suspend
      powerpc: dts: turris1x.dts: Fix NOR partitions labels
      powerpc: dts: turris1x.dts: Fix labels in DSA cpu port nodes
      powerpc: Fix SPE Power ISA properties for e500v1 platforms

Palmer Dabbelt (1):
      RISC-V: Re-enable counter access from userspace

Patrick Rudolph (1):
      regulator: core: Prevent integer underflow

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure

Paul E. McKenney (1):
      rcu-tasks: Ensure RCU Tasks Trace loops have quiescent states

Pavel Begunkov (17):
      io_uring: add custom opcode hooks on fail
      io_uring/rw: don't lose partial IO result on fail
      io_uring/net: don't lose partial send/recv on fail
      io_uring/rw: fix unexpected link breakage
      io_uring/rw: don't lose short results on io_setup_async_rw()
      io_uring/net: don't update msg_name if not provided
      io_uring: limit registration w/ SINGLE_ISSUER
      io_uring/af_unix: defer registered files gc to io_uring release
      io_uring: correct pinned_vm accounting
      io_uring: fix CQE reordering
      io_uring/net: refactor io_sr_msg types
      io_uring/net: use io_sr_msg for sendzc
      io_uring/net: don't lose partial send_zc on fail
      io_uring/net: rename io_sendzc()
      io_uring/net: don't skip notifs for failed requests
      io_uring/net: fix notif cqe reordering
      io_uring: fix fdinfo sqe offsets calculation

Peng Fan (2):
      clk: imx8mp: tune the order of enet_qos_root_clk
      mailbox: imx: fix RST channel support

Perry Yuan (2):
      cpufreq: amd-pstate: Fix initial highest_perf value
      cpufreq: amd_pstate: fix wrong lowest perf fetch

Peter Collingbourne (1):
      arm64: mte: move register initialization to C

Peter Geis (1):
      phy: rockchip-inno-usb2: Return zero after otg sync

Peter Harliman Liem (1):
      crypto: inside-secure - Change swab to swab32

Peter Ujfalusi (1):
      ASoC: SOF: ipc4-topology: Free the ida when IPC fails in sof_ipc4_widget_setup()

Peter Xu (1):
      mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in

Phil Sutter (1):
      netfilter: nft_fib: Fix for rpath check with VRF devices

Philip Yang (1):
      drm/amdgpu: SDMA update use unlocked iterator

Pierre-Louis Bossart (2):
      ASoC: SOF: add quirk to override topology mclk_id
      soundwire: intel: fix error handling on dai registration issues

Pin-Yen Lin (1):
      drm/bridge: it6505: Power on downstream device in .atomic_enable

Pin-yen Lin (1):
      drm/bridge: it6505: Fix the order of DP_SET_POWER commands

Ping-Ke Shih (3):
      wifi: rtlwifi: 8192de: correct checking of IQK reload
      wifi: rtw89: pci: fix interrupt stuck after leaving low power mode
      wifi: rtw89: pci: correct TX resource checking in low power mode

Piyush Mehta (1):
      usb: dwc3: core: Enable GUCTL1 bit 10 for fixing termination error after resume bug

Po-Hao Huang (2):
      wifi: rtw89: free unused skb to prevent memory leak
      wifi: rtw89: fix rx filter after scan

Prashant Malani (2):
      platform/chrome: cros_ec_typec: Add bit offset for DP VDO
      platform/chrome: cros_ec_typec: Correct alt mode index

Prathamesh Shete (1):
      mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

Pu Lehui (3):
      bpf, cgroup: Reject prog_attach_flags array when effective query
      bpftool: Fix wrong cgroup attach flags being assigned to effective progs
      selftests/bpf: Adapt cgroup effective query uapi change

Qingqing Yang (1):
      flow_dissector: Do not count vlan tags inside tunnel payload

Qu Wenruo (4):
      btrfs: enhance unsupported compat RO flags handling
      btrfs: dump extra info if one free space cache has more bitmaps than it should
      btrfs: scrub: properly report super block errors in system log
      btrfs: scrub: try to fix super block errors

Quanyang Wang (1):
      clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Quentin Monnet (1):
      bpftool: Clear errno after libcap's checks

Quentin Schulz (2):
      gpio: rockchip: request GPIO mux to pinctrl when setting direction
      pinctrl: rockchip: add pinmux_ops.gpio_set_direction callback

Rafael Mendonca (4):
      xhci: dbc: Fix memory leak in xhci_alloc_dbc()
      ACPI: PCC: Release resources on address space setup failure path
      drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()
      drm/vmwgfx: Fix memory leak in vmw_mksstat_add_ioctl()

Raju Lakkaraju (1):
      eth: lan743x: reject extts for non-pci11x1x devices

Randy Dunlap (4):
      drm/panel: use 'select' for Ili9341 panel driver helpers
      drm: fix drm_mipi_dbi build errors
      ia64: export memory_add_physaddr_to_nid to fix cxl build error
      net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses

Ravi Gunasekaran (1):
      net: ethernet: ti: davinci_mdio: Add workaround for errata i2329

Richard Acayan (1):
      mmc: sdhci-msm: add compatible string check for sdm670

Richard Fitzgerald (1):
      soundwire: cadence: Don't overwrite msg->buf during write commands

Richard Gobert (1):
      net-next: Fix IP_UNICAST_IF option behavior for connected sockets

Richard Guy Briggs (2):
      audit: explicitly check audit_context->context enum value
      audit: free audit_proctitle only on task exit

Rik van Riel (1):
      livepatch: fix race between fork and KLP transition

Rob Clark (1):
      drm/virtio: Fix same-context optimization

Rob Herring (1):
      perf: Skip and warn on unknown format 'configN' attrs

Robert Hancock (1):
      net: axienet: Switch to 64-bit RX/TX statistics

Robert Marko (1):
      clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical

Roberto Sassu (1):
      btf: Export bpf_dynptr definition

Robin Guo (1):
      usb: musb: Fix musb_gadget.c rxstate overflow bug

Robin Murphy (1):
      iommu/iova: Fix module config properly

Rodrigo Siqueira (1):
      drm/amd/display: Enable 2 to 1 ODM policy if supported

Rohan McLure (1):
      powerpc: Fix fallocate and fadvise64_64 compat parameter combination

Roman Li (1):
      drm/amd/display: Enable dpia support for dcn314

Ronnie Sahlberg (1):
      cifs: destage dirty pages before re-reading them for cache=none

Ruili Ji (1):
      drm/amdgpu: Enable F32_WPTR_POLL_ENABLE in mqd

Russell King (Oracle) (1):
      net: mvpp2: fix mvpp2 debugfs leak

Rustam Subkhankulov (1):
      platform/chrome: fix double-free in chromeos_laptop_prepare()

Sabrina Dubroca (1):
      esp: choose the correct inner protocol for GSO on inter address family tunnels

Sagi Grimberg (1):
      nvme-multipath: fix possible hang in live ns resize with ANA access

Sami Tolvanen (1):
      objtool: Preserve special st_shndx indexes in elf_update_symbol

Saranya Gopal (1):
      ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Satya Priya (2):
      arm64: dts: qcom: sc7280: Cleanup the lpasscc node
      arm64: dts: qcom: sc7280: Update lpasscore node

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Saurav Kashyap (1):
      scsi: qedf: Populate sysfs attributes for vport

Sean Christopherson (4):
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02
      KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Sean Wang (10):
      Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
      wifi: mt76: mt7921e: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921s: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921u: fix race issue between reset and suspend/resume
      wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work
      wifi: mt76: sdio: poll sta stat when device transmits data
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_[start, stop]_ap
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_sta_set_decap_offload
      wifi: mt76: mt7921: fix the firmware version report
      wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value

Sebastian Krzyszkowiak (1):
      arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply

Serge Semin (5):
      clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD
      clk: baikal-t1: Fix invalid xGMAC PTP clock divider
      clk: baikal-t1: Add shared xGMAC ref/ptp clocks internal parent
      clk: baikal-t1: Add SATA internal ref clock buffer
      ata: libahci_platform: Sanity check the DT child nodes number

Sergei Antonov (1):
      net: ftmac100: fix endianness-related issues from 'sparse'

Shaul Triebitz (2):
      wifi: mac80211: properly set old_links when removing a link
      wifi: cfg80211: get correct AP link chandef

Shengjiu Wang (1):
      rpmsg: char: Avoid double destroy of default endpoint

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Sherry Wang (1):
      drm/amd/display: correct hostvm flag

Shigeru Yoshida (1):
      nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Shiraz Saleem (1):
      RDMA/irdma: Validate udata inlen and outlen

Shirish S (1):
      drm/amd/display: explicitly disable psr_feature_enable appropriately

Shuai Xue (1):
      ACPI: APEI: do not add task_work to kernel thread to avoid memory leak

Shubhrajyoti Datta (2):
      tty: xilinx_uartps: Check clk_enable return value
      tty: xilinx_uartps: Fix the ignore_status

Simon Ser (1):
      drm/dp_mst: fix drm_dp_dpcd_read return value checks

Sindhu-Devale (1):
      RDMA/irdma: Align AE id codes to correct flush code and event

Song Liu (2):
      ftrace: Fix recursive locking direct_mutex in ftrace_modify_direct_caller
      bpf: use bpf_prog_pack for bpf_dispatcher

Sonny Jiang (1):
      drm/amdgpu: Enable VCN PG on GC11_0_1

Srinivas Kandagatla (1):
      ASoC: codecs: tx-macro: fix kcontrol put

Srinivas Pandruvada (1):
      thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Stanislav Lisovskiy (1):
      drm/i915/dg2: Bump up CDCLK for DG2

Stefan Berger (1):
      selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle

Stefan Metzmacher (1):
      io_uring/net: fix fast_iov assignment in io_setup_async_msg()

Stefan Wahren (1):
      clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Stephen Boyd (1):
      arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc enabled for TZ

Steve French (2):
      smb3: do not log confusing message when server returns no network interfaces
      smb3: must initialize two ACL struct fields to zero

Steven Rostedt (Google) (13):
      ftrace: Still disable enabled records marked as disabled
      ring-buffer: Allow splice to read previous partially read pages
      ring-buffer: Have the shortest_full queue be the shortest not longest
      ring-buffer: Check pending waiters when doing wake ups as well
      ring-buffer: Add ring_buffer_wake_waiters()
      ring-buffer: Fix race between reset page and reading page
      tracing: Wake up ring buffer waiters on closing of the file
      tracing: Wake up waiters when tracing is disabled
      tracing: Add ioctl() to force ring buffer waiters to wake up
      tracing: Do not free snapshot if tracer is on cmdline
      tracing: Move duplicate code of trace_kprobe/eprobe.c into header
      tracing: Add "(fault)" name injection to kernel probes
      tracing: Fix reading strings from synthetic events

Takashi Iwai (10):
      ALSA: oss: Fix potential deadlock at unregistration
      ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
      ALSA: usb-audio: Fix potential memory leaks
      ALSA: usb-audio: Fix NULL dererence at error path
      drm/udl: Restore display mode on resume
      ALSA: hda: beep: Simplify keep-power-at-enable behavior
      ALSA: usb-audio: Properly refcounting clock rate
      ALSA: hda/hdmi: Don't skip notification handling during PM operation
      ALSA: usb-audio: Register card at the last interface
      ALSA: usb-audio: Fix last interface check for registration

Tao Chen (1):
      tracing/eprobe: Fix alloc event dir failed when event name no set

Tetsuo Handa (8):
      btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer
      Bluetooth: avoid hci_dev_test_and_set_flag() in mgmt_init_hdev()
      Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      net/ieee802154: reject zero-sized raw_sendmsg()
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Thinh Nguyen (1):
      usb: common: debug: Check non-standard control requests

Thomas Hellström (1):
      drm/i915: Fix display problems after resume

Thomas Zimmermann (1):
      video/aperture: Disable and unregister sysfb devices via aperture helpers

Tudor Ambarus (1):
      mtd: rawnand: atmel: Unmap streaming DMA mappings

Tvrtko Ursulin (1):
      drm/i915/guc: Fix revocation of non-persistent contexts

Uwe Kleine-König (2):
      iio: ltc2497: Fix reading conversion results
      leds: lm3601x: Don't use mutex after it was destroyed

Vadim Fedorenko (1):
      bnxt_en: replace reset with config timestamps

Vaishnav Achath (1):
      dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow

Varun Prakash (1):
      nvmet-tcp: add bounds check on Transfer Tag

Ville Syrjälä (5):
      drm/i915: Fix watermark calculations for gen12+ RC CCS modifier
      drm/i915: Fix watermark calculations for gen12+ MC CCS modifier
      drm/i915: Fix watermark calculations for gen12+ CCS+CC modifier
      drm/i915: Fix watermark calculations for DG2 CCS modifiers
      drm/i915: Fix watermark calculations for DG2 CCS+CC modifier

Vincent Knecht (1):
      thermal/drivers/qcom/tsens-v0_1: Fix MSM8939 fourth sensor hw_id

Vincent Whitchurch (2):
      spi: s3c64xx: Fix large transfers with DMA
      iio: Use per-device lockdep class for mlock

Viresh Kumar (1):
      cpufreq: qcom-cpufreq-hw: Fix uninitialized throttled_freq warning

Vitaly Kuznetsov (1):
      x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition

Vivek Kasireddy (1):
      udmabuf: Set ubuf->sg = NULL if the creation of sg table fails

Waiman Long (2):
      tracing: Disable interrupt or preemption before acquiring arch_spinlock_t
      cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset

Wang Kefeng (2):
      ARM: 9244/1: dump: Fix wrong pg_level in walk_pmd()
      ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE

Wayne Chang (1):
      usb: typec: ucsi: Don't warn on probe deferral

Wei Yongjun (1):
      power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()

Weili Qian (1):
      crypto: hisilicon/qm - fix missing put dfx access

Wen Gong (2):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()
      wifi: ath11k: fix failed to find the peer with peer_id 0 when disconnected

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix minimum clock limit

Wenjing Liu (1):
      drm/amd/display: polling vid stream status in hpo dp blank

Wenting Zhang (1):
      riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb

William Dean (1):
      mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Wright Feng (1):
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xiaoke Wang (2):
      staging: rtl8723bs: fix potential memory leak in rtw_init_drv_sw()
      staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

Xiaomeng Tong (1):
      cw1200: fix incorrect check to determine if no element is found in list

Xiaoyan Li (1):
      ASoC: amd: yc: Add ASUS UM5302TA into DMI table

Xin Liu (2):
      libbpf: Fix NULL pointer exception in API btf_dump__dump_type_data
      libbpf: Fix overrun in netlink attribute iteration

Xin Long (1):
      sctp: handle the error returned from sctp_auth_asoc_init_active_key

Xu Qiang (3):
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()
      media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()

Xuewen Yan (1):
      thermal: cpufreq_cooling: Check the policy first in cpufreq_cooling_register()

YN Chen (1):
      wifi: mt76: sdio: fix transmitting packet hangs

Yang Guo (1):
      clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO and CNTVCT_LO value

Yang Yingliang (3):
      wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
      ASoC: amd: acp: add missing platform_device_unregister() in acp_pci_probe()
      drm/amdgpu: add missing pci_disable_device() in amdgpu_pmops_runtime_resume()

Ye Bin (7):
      jbd2: fix potential buffer head reference count leak
      jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
      jbd2: add miss release buffer head in fc_do_one_pass()
      ext4: fix miss release buffer head in ext4_fc_write_inode
      ext4: fix potential memory leak in ext4_fc_record_modified_inode()
      ext4: fix potential memory leak in ext4_fc_record_regions()
      ext4: update 'state->fc_regions_size' after successful memory allocation

Ye Weihua (1):
      crypto: hisilicon/zip - fix mismatch in get/set sgl_sge_nr

Yicong Yang (1):
      iommu/arm-smmu-v3: Make default domain type of HiSilicon PTT device to identity

Yifan Zha (2):
      drm/amdgpu: Skip the program of MMMC_VM_AGP_* in SRIOV on MMHUB v3_0_0
      drm/admgpu: Skip CG/PG on SOC21 under SRIOV VF

Yipeng Zou (2):
      tracing: kprobe: Fix kprobe event gen test module on exit
      tracing: kprobe: Make gen test module work in arm and riscv

Youghandhar Chintala (1):
      wifi: ath10k: Set tx credit to one for WCN3990 snoc based devices

Yu Kuai (4):
      blk-throttle: fix that io throttle can only work for single bio
      blk-wbt: call rq_qos_add() after wb_normal is initialized
      blk-throttle: prevent overflow while calculating wait time
      blk-wbt: fix that 'rwb->wc' is always set to 1 in wbt_init()

Yunke Cao (1):
      media: uvcvideo: Use entity get_cur in uvc_ctrl_set

Yunxiang Li (1):
      drm/amd/display: Fix vblank refcount in vrr transition

Zeng Jingxiang (1):
      gpu: lontium-lt9611: Fix NULL pointer dereference in lt9611_connector_init()

Zhang Qilong (11):
      spi: cadence-quadspi: Fix PM disable depth imbalance in cqspi_probe
      spi: dw: Fix PM disable depth imbalance in dw_spi_bt1_probe
      spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
      ASoC: stm32: dfsdm: Fix PM disable depth imbalance in stm32_adfsdm_probe
      ASoC: stm32: spdifrx: Fix PM disable depth imbalance in stm32_spdifrx_probe
      ASoC: stm: Fix PM disable depth imbalance in stm32_i2s_probe
      ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe
      ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe
      ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe
      ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe
      f2fs: fix race condition on setting FI_NO_EXTENT flag

Zhang Rui (2):
      powercap: intel_rapl: Use standard Energy Unit for SPR Dram RAPL domain
      tools/power turbostat: Use standard Energy Unit for SPR Dram RAPL domain

Zhang Xiaoxu (2):
      cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
      ksmbd: Fix wrong return value and message length check in smb2_ioctl()

Zhang Yi (1):
      ext4: ext4_read_bh_lock() should submit IO if the buffer isn't uptodate

Zhao Gongyi (3):
      selftests/cpu-hotplug: Use return instead of exit
      selftests/cpu-hotplug: Delete fault injection related code
      selftests/cpu-hotplug: Reserve one cpu online at least

Zheng Wang (1):
      eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address

Zheng Yejian (1):
      ftrace: Properly unset FTRACE_HASH_FL_MOD

Zheng Yongjun (2):
      net: fs_enet: Fix wrong check in do_pd_setup
      powerpc/powernv: add missing of_node_put() in opal_export_attrs()

Zhengchao Shao (1):
      crypto: sahara - don't sleep when in softirq

Zheyu Ma (2):
      drm/bridge: megachips: Fix a null pointer dereference bug
      media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Zhihao Cheng (2):
      quota: Check next/prev free block number after reading from quota file
      ext4: fix dir corruption when ext4_dx_add_entry() fails

Zhu Yanjun (2):
      RDMA/rxe: Fix "kernel NULL pointer dereference" error
      RDMA/rxe: Fix the error caused by qp->sk

Ziyang Xuan (1):
      can: bcm: check the result of can_send() in bcm_can_tx()

Zong-Zhe Yang (1):
      rtw89: ser: leave lps with mutex

Zqiang (2):
      rcu: Avoid triggering strict-GP irq-work when RCU is idle
      rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()

hongao (1):
      drm/amdgpu: fix initial connector audio value

sunghwan jung (1):
      Revert "usb: storage: Add quirk for Samsung Fit flash"

sunliming (1):
      drm/amd/display: Fix variable dereferenced before check

