Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBDD544620
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 10:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242055AbiFIIjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 04:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbiFIIj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 04:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FAE6412;
        Thu,  9 Jun 2022 01:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FAF2B82C88;
        Thu,  9 Jun 2022 08:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FF8C34114;
        Thu,  9 Jun 2022 08:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654763943;
        bh=GLEsxJoqRr1Mkhj8ta7aWak1YLwADpIF82ObMtnyzGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=mj0NRQfIyFsuL/MD43AixCrelssNpHd/ksZLmAIrb1vazIJv7v8sP6zubpImSPnFt
         NK4AAAWg1shksG0mDQxZwhoPrTt83UzdHYqbeacMkn5Z3qsaGVE5D1hN8lIsdZPM1c
         SC9agWqFdyhU1Q/zRb3UFgj4eV0gxXu7ZPUVvK6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.121
Date:   Thu,  9 Jun 2022 10:38:59 +0200
Message-Id: <165476393977169@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.121 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/conf.py                                           |    2 
 Documentation/devicetree/bindings/display/sitronix,st7735r.yaml |    1 
 Documentation/devicetree/bindings/gpio/gpio-altera.txt          |    5 
 Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml   |    1 
 Makefile                                                        |    2 
 arch/arm/boot/dts/bcm2835-rpi-b.dts                             |   13 
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                        |   22 
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts                      |    2 
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts                       |    4 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                       |    4 
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts                   |    6 
 arch/arm/boot/dts/imx6qdl-colibri.dtsi                          |    6 
 arch/arm/boot/dts/ox820.dtsi                                    |    2 
 arch/arm/boot/dts/s5pv210-aries.dtsi                            |    3 
 arch/arm/boot/dts/s5pv210.dtsi                                  |   12 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi              |    1 
 arch/arm/boot/dts/suniv-f1c100s.dtsi                            |    4 
 arch/arm/mach-hisi/platsmp.c                                    |    4 
 arch/arm/mach-mediatek/Kconfig                                  |    1 
 arch/arm/mach-omap1/clock.c                                     |    2 
 arch/arm/mach-pxa/cm-x300.c                                     |    8 
 arch/arm/mach-pxa/magician.c                                    |    2 
 arch/arm/mach-pxa/tosa.c                                        |    4 
 arch/arm/mach-vexpress/dcscb.c                                  |    1 
 arch/arm64/Kconfig.platforms                                    |    1 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                           |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                        |    2 
 arch/arm64/kernel/sys_compat.c                                  |    2 
 arch/arm64/mm/copypage.c                                        |    4 
 arch/csky/kernel/probes/kprobes.c                               |    2 
 arch/m68k/Kconfig.cpu                                           |    2 
 arch/m68k/include/asm/raw_io.h                                  |    6 
 arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h         |    1 
 arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h         |    1 
 arch/openrisc/include/asm/timex.h                               |    1 
 arch/openrisc/kernel/head.S                                     |    9 
 arch/parisc/include/asm/fb.h                                    |    4 
 arch/powerpc/include/asm/page.h                                 |    7 
 arch/powerpc/include/asm/vas.h                                  |    2 
 arch/powerpc/kernel/fadump.c                                    |    8 
 arch/powerpc/kernel/idle.c                                      |    2 
 arch/powerpc/perf/isa207-common.c                               |    3 
 arch/powerpc/platforms/4xx/cpm.c                                |    2 
 arch/powerpc/platforms/8xx/cpm1.c                               |    1 
 arch/powerpc/platforms/powernv/opal-fadump.c                    |   94 ++--
 arch/powerpc/platforms/powernv/opal-fadump.h                    |   10 
 arch/powerpc/platforms/powernv/ultravisor.c                     |    1 
 arch/powerpc/platforms/powernv/vas-fault.c                      |    2 
 arch/powerpc/platforms/powernv/vas-window.c                     |    4 
 arch/powerpc/platforms/powernv/vas.h                            |    2 
 arch/powerpc/sysdev/dart_iommu.c                                |    6 
 arch/powerpc/sysdev/fsl_rio.c                                   |    2 
 arch/powerpc/sysdev/xics/icp-opal.c                             |    1 
 arch/riscv/include/asm/irq_work.h                               |    2 
 arch/riscv/kernel/head.S                                        |    1 
 arch/s390/include/asm/kexec.h                                   |   10 
 arch/s390/include/asm/preempt.h                                 |   15 
 arch/s390/kernel/perf_event.c                                   |    2 
 arch/um/drivers/chan_user.c                                     |    9 
 arch/um/include/asm/thread_info.h                               |    2 
 arch/um/kernel/exec.c                                           |    2 
 arch/um/kernel/process.c                                        |    2 
 arch/um/kernel/ptrace.c                                         |    8 
 arch/um/kernel/signal.c                                         |    4 
 arch/x86/Kconfig                                                |    4 
 arch/x86/entry/entry_64.S                                       |    1 
 arch/x86/entry/vdso/vma.c                                       |    2 
 arch/x86/events/amd/ibs.c                                       |   55 ++
 arch/x86/events/intel/core.c                                    |    2 
 arch/x86/include/asm/acenv.h                                    |   14 
 arch/x86/include/asm/kexec.h                                    |    8 
 arch/x86/include/asm/suspend_32.h                               |    2 
 arch/x86/include/asm/suspend_64.h                               |   12 
 arch/x86/kernel/apic/apic.c                                     |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c                              |    8 
 arch/x86/kernel/cpu/intel.c                                     |    2 
 arch/x86/kernel/cpu/mce/amd.c                                   |   32 -
 arch/x86/kernel/step.c                                          |    3 
 arch/x86/kernel/sys_x86_64.c                                    |    7 
 arch/x86/kvm/vmx/nested.c                                       |   45 +-
 arch/x86/kvm/vmx/vmcs.h                                         |    5 
 arch/x86/lib/delay.c                                            |    4 
 arch/x86/mm/pat/memtype.c                                       |    2 
 arch/x86/um/ldt.c                                               |    6 
 arch/xtensa/kernel/ptrace.c                                     |    4 
 arch/xtensa/kernel/signal.c                                     |    4 
 arch/xtensa/platforms/iss/simdisk.c                             |   18 
 block/bfq-cgroup.c                                              |  111 +++--
 block/bfq-iosched.c                                             |   46 +-
 block/bfq-iosched.h                                             |    6 
 block/blk-cgroup.c                                              |    8 
 block/blk-iolatency.c                                           |  122 ++---
 crypto/cryptd.c                                                 |   23 -
 drivers/acpi/property.c                                         |   18 
 drivers/acpi/sleep.c                                            |   12 
 drivers/base/memory.c                                           |    5 
 drivers/base/node.c                                             |    1 
 drivers/block/drbd/drbd_main.c                                  |   11 
 drivers/block/nbd.c                                             |   13 
 drivers/block/virtio_blk.c                                      |    7 
 drivers/char/hw_random/omap3-rom-rng.c                          |    2 
 drivers/char/ipmi/ipmi_msghandler.c                             |    4 
 drivers/char/ipmi/ipmi_ssif.c                                   |   23 +
 drivers/char/random.c                                           |   12 
 drivers/cpufreq/mediatek-cpufreq.c                              |   19 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c             |  115 +++--
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c               |   30 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c               |   10 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h                    |   14 
 drivers/crypto/ccree/cc_buffer_mgr.c                            |   27 -
 drivers/crypto/marvell/cesa/cipher.c                            |    1 
 drivers/crypto/nx/nx-common-powernv.c                           |    2 
 drivers/devfreq/rk3399_dmc.c                                    |    2 
 drivers/dma/idxd/cdev.c                                         |    8 
 drivers/dma/stm32-mdma.c                                        |   87 +--
 drivers/edac/dmc520_edac.c                                      |    2 
 drivers/firmware/arm_scmi/base.c                                |    2 
 drivers/gpio/gpiolib-of.c                                       |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c                       |    3 
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c                       |   14 
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c                       |    8 
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c               |   10 
 drivers/gpu/drm/arm/malidp_crtc.c                               |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                    |    1 
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c              |   31 +
 drivers/gpu/drm/drm_edid.c                                      |    6 
 drivers/gpu/drm/drm_plane.c                                     |   14 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                           |    6 
 drivers/gpu/drm/gma500/psb_intel_display.c                      |    7 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                    |   33 -
 drivers/gpu/drm/i915/i915_perf.c                                |    4 
 drivers/gpu/drm/i915/i915_perf_types.h                          |    2 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                       |   61 ++
 drivers/gpu/drm/mediatek/mtk_cec.c                              |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                           |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c                     |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                         |    8 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                       |   14 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                        |    6 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c                      |   15 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h                      |    4 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                       |   15 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h                       |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                      |   20 
 drivers/gpu/drm/msm/dp/dp_display.c                             |   55 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                              |   21 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                 |   10 
 drivers/gpu/drm/msm/msm_drv.c                                   |    1 
 drivers/gpu/drm/msm/msm_gem_prime.c                             |    2 
 drivers/gpu/drm/nouveau/dispnv50/atom.h                         |    6 
 drivers/gpu/drm/nouveau/dispnv50/crc.c                          |   27 -
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c                  |    6 
 drivers/gpu/drm/panel/panel-simple.c                            |    3 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                     |    2 
 drivers/gpu/drm/stm/ltdc.c                                      |   16 
 drivers/gpu/drm/tilcdc/tilcdc_external.c                        |    8 
 drivers/gpu/drm/vc4/vc4_hvs.c                                   |   26 -
 drivers/gpu/drm/vc4/vc4_txp.c                                   |    8 
 drivers/gpu/drm/virtio/virtgpu_display.c                        |    2 
 drivers/hid/hid-bigbenff.c                                      |    6 
 drivers/hid/hid-elan.c                                          |    2 
 drivers/hid/hid-led.c                                           |    2 
 drivers/hwtracing/coresight/coresight-core.c                    |   33 -
 drivers/i2c/busses/i2c-at91-master.c                            |   11 
 drivers/i2c/busses/i2c-npcm7xx.c                                |  103 +++-
 drivers/i2c/busses/i2c-rcar.c                                   |   15 
 drivers/infiniband/hw/hfi1/file_ops.c                           |    2 
 drivers/infiniband/hw/hfi1/init.c                               |    2 
 drivers/infiniband/hw/hfi1/sdma.c                               |   12 
 drivers/infiniband/sw/rdmavt/qp.c                               |    6 
 drivers/infiniband/sw/rxe/rxe_req.c                             |    2 
 drivers/input/misc/sparcspkr.c                                  |    1 
 drivers/input/touchscreen/stmfts.c                              |   16 
 drivers/iommu/amd/init.c                                        |    2 
 drivers/iommu/intel/iommu.c                                     |    2 
 drivers/iommu/msm_iommu.c                                       |   11 
 drivers/iommu/mtk_iommu.c                                       |    3 
 drivers/irqchip/irq-armada-370-xp.c                             |   11 
 drivers/irqchip/irq-aspeed-i2c-ic.c                             |    4 
 drivers/irqchip/irq-aspeed-scu-ic.c                             |    4 
 drivers/irqchip/irq-sni-exiu.c                                  |   25 -
 drivers/irqchip/irq-xtensa-mx.c                                 |   18 
 drivers/macintosh/Kconfig                                       |    6 
 drivers/macintosh/Makefile                                      |    3 
 drivers/macintosh/via-pmu.c                                     |    2 
 drivers/mailbox/mailbox.c                                       |   19 
 drivers/md/bcache/btree.c                                       |   58 +-
 drivers/md/bcache/btree.h                                       |    2 
 drivers/md/bcache/journal.c                                     |   31 +
 drivers/md/bcache/journal.h                                     |    2 
 drivers/md/bcache/request.c                                     |    6 
 drivers/md/bcache/super.c                                       |    1 
 drivers/md/bcache/writeback.c                                   |  101 +---
 drivers/md/bcache/writeback.h                                   |    2 
 drivers/md/md-bitmap.c                                          |   44 +
 drivers/md/md.c                                                 |   18 
 drivers/media/cec/core/cec-adap.c                               |    6 
 drivers/media/i2c/ov7670.c                                      |    1 
 drivers/media/pci/cx23885/cx23885-core.c                        |    6 
 drivers/media/pci/cx25821/cx25821-core.c                        |    2 
 drivers/media/platform/aspeed-video.c                           |    4 
 drivers/media/platform/coda/coda-common.c                       |   35 +
 drivers/media/platform/exynos4-is/fimc-is.c                     |    6 
 drivers/media/platform/exynos4-is/fimc-isp-video.h              |    2 
 drivers/media/platform/qcom/venus/hfi.c                         |    3 
 drivers/media/platform/rockchip/rga/rga.c                       |    6 
 drivers/media/platform/sti/delta/delta-v4l2.c                   |    6 
 drivers/media/platform/vsp1/vsp1_rpf.c                          |    6 
 drivers/media/rc/imon.c                                         |   99 ++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                         |    7 
 drivers/media/usb/uvc/uvc_v4l2.c                                |   20 
 drivers/memory/samsung/exynos5422-dmc.c                         |    5 
 drivers/mfd/davinci_voicecodec.c                                |    6 
 drivers/mfd/ipaq-micro.c                                        |    2 
 drivers/misc/ocxl/file.c                                        |    2 
 drivers/mmc/host/jz4740_mmc.c                                   |   20 
 drivers/mmc/host/sdhci_am654.c                                  |   23 -
 drivers/mtd/chips/cfi_cmdset_0002.c                             |  103 ++--
 drivers/mtd/nand/raw/cadence-nand-controller.c                  |    5 
 drivers/mtd/nand/raw/denali_pci.c                               |   15 
 drivers/mtd/spi-nor/core.c                                      |    9 
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h                       |    2 
 drivers/net/can/xilinx_can.c                                    |    4 
 drivers/net/dsa/mt7530.c                                        |   14 
 drivers/net/ethernet/broadcom/Makefile                          |    5 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c     |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c            |    5 
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c               |   10 
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c                |    5 
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c                |    9 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c               |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c                 |   23 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c                  |   10 
 drivers/net/ethernet/huawei/hinic/hinic_tx.c                    |    9 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c               |   10 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c              |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c              |   13 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c             |    2 
 drivers/net/ethernet/sfc/ef10.c                                 |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c          |   15 
 drivers/net/hyperv/netvsc_drv.c                                 |    5 
 drivers/net/ipa/ipa_endpoint.c                                  |    4 
 drivers/net/phy/micrel.c                                        |   11 
 drivers/net/wireguard/socket.c                                  |    4 
 drivers/net/wireless/ath/ath10k/mac.c                           |   20 
 drivers/net/wireless/ath/ath11k/mac.c                           |   16 
 drivers/net/wireless/ath/ath11k/spectral.c                      |   17 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                  |    2 
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                     |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                   |    8 
 drivers/net/wireless/ath/carl9170/tx.c                          |    3 
 drivers/net/wireless/broadcom/b43/phy_n.c                       |    2 
 drivers/net/wireless/broadcom/b43legacy/phy.c                   |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c                  |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/power.c                  |    3 
 drivers/net/wireless/marvell/mwifiex/11h.c                      |    2 
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c              |    8 
 drivers/net/wireless/realtek/rtlwifi/usb.c                      |    2 
 drivers/nfc/st21nfca/se.c                                       |   17 
 drivers/nfc/st21nfca/st21nfca.h                                 |    1 
 drivers/nvdimm/core.c                                           |    9 
 drivers/nvdimm/security.c                                       |    5 
 drivers/nvme/host/core.c                                        |    2 
 drivers/nvme/host/pci.c                                         |    1 
 drivers/of/overlay.c                                            |    4 
 drivers/opp/of.c                                                |    2 
 drivers/pci/controller/cadence/pcie-cadence-ep.c                |    3 
 drivers/pci/controller/dwc/pci-imx6.c                           |   23 -
 drivers/pci/controller/dwc/pcie-designware-host.c               |    3 
 drivers/pci/controller/dwc/pcie-qcom.c                          |    9 
 drivers/pci/controller/pcie-rockchip-ep.c                       |    3 
 drivers/pci/pci.c                                               |   12 
 drivers/pci/pcie/aer.c                                          |    7 
 drivers/phy/qualcomm/phy-qcom-qmp.c                             |   11 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                           |   18 
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                     |    2 
 drivers/pinctrl/renesas/core.c                                  |    7 
 drivers/pinctrl/renesas/pinctrl-rzn1.c                          |   10 
 drivers/platform/chrome/cros_ec.c                               |   16 
 drivers/platform/chrome/cros_ec_chardev.c                       |    2 
 drivers/platform/chrome/cros_ec_proto.c                         |   50 +-
 drivers/platform/mips/cpu_hwmon.c                               |  127 +----
 drivers/regulator/core.c                                        |    7 
 drivers/regulator/pfuze100-regulator.c                          |    2 
 drivers/regulator/qcom_smd-regulator.c                          |   35 -
 drivers/scsi/dc395x.c                                           |   15 
 drivers/scsi/fcoe/fcoe_ctlr.c                                   |    2 
 drivers/scsi/lpfc/lpfc_sli.c                                    |    6 
 drivers/scsi/megaraid.c                                         |    2 
 drivers/scsi/ufs/ti-j721e-ufs.c                                 |    6 
 drivers/scsi/ufs/ufs-qcom.c                                     |   14 
 drivers/scsi/ufs/ufshcd.c                                       |    7 
 drivers/soc/qcom/llcc-qcom.c                                    |    1 
 drivers/soc/qcom/smp2p.c                                        |    1 
 drivers/soc/qcom/smsm.c                                         |    1 
 drivers/soc/ti/ti_sci_pm_domains.c                              |    2 
 drivers/spi/spi-fsl-qspi.c                                      |    4 
 drivers/spi/spi-img-spfi.c                                      |    2 
 drivers/spi/spi-rspi.c                                          |   15 
 drivers/spi/spi-stm32-qspi.c                                    |    3 
 drivers/spi/spi-ti-qspi.c                                       |    5 
 drivers/staging/media/hantro/hantro_v4l2.c                      |    8 
 drivers/staging/media/rkvdec/rkvdec-h264.c                      |   37 +
 drivers/staging/media/rkvdec/rkvdec.c                           |    4 
 drivers/target/target_core_device.c                             |    1 
 drivers/thermal/broadcom/bcm2711_thermal.c                      |    5 
 drivers/thermal/broadcom/sr-thermal.c                           |    3 
 drivers/thermal/imx_sc_thermal.c                                |    6 
 drivers/thermal/thermal_core.c                                  |   42 +
 drivers/tty/serial/pch_uart.c                                   |   27 -
 drivers/tty/tty_buffer.c                                        |    3 
 drivers/usb/core/hcd.c                                          |   29 +
 drivers/usb/core/quirks.c                                       |    3 
 drivers/usb/dwc3/gadget.c                                       |    6 
 drivers/usb/host/xhci-pci.c                                     |    2 
 drivers/usb/serial/option.c                                     |    2 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                |    5 
 drivers/video/console/sticon.c                                  |    5 
 drivers/video/console/sticore.c                                 |   32 +
 drivers/video/fbdev/amba-clcd.c                                 |    5 
 drivers/video/fbdev/core/fbcon.c                                |    5 
 drivers/video/fbdev/sticore.h                                   |    3 
 drivers/video/fbdev/stifb.c                                     |    4 
 fs/afs/rxrpc.c                                                  |    8 
 fs/binfmt_flat.c                                                |   27 +
 fs/btrfs/disk-io.c                                              |    4 
 fs/btrfs/volumes.c                                              |    8 
 fs/cifs/smb2inode.c                                             |    2 
 fs/cifs/smb2ops.c                                               |    2 
 fs/dax.c                                                        |    3 
 fs/dlm/lock.c                                                   |   11 
 fs/dlm/plock.c                                                  |   12 
 fs/ext4/ext4.h                                                  |    6 
 fs/ext4/extents.c                                               |   10 
 fs/ext4/inline.c                                                |   12 
 fs/ext4/inode.c                                                 |    4 
 fs/ext4/namei.c                                                 |   84 +++
 fs/ext4/super.c                                                 |   24 -
 fs/f2fs/f2fs.h                                                  |   19 
 fs/f2fs/file.c                                                  |   20 
 fs/f2fs/inline.c                                                |   29 +
 fs/f2fs/inode.c                                                 |   19 
 fs/f2fs/segment.c                                               |   42 +
 fs/f2fs/segment.h                                               |   33 -
 fs/f2fs/super.c                                                 |    6 
 fs/fat/fatent.c                                                 |    7 
 fs/fs-writeback.c                                               |   13 
 fs/gfs2/quota.c                                                 |   32 -
 fs/iomap/buffered-io.c                                          |    3 
 fs/jfs/jfs_dmap.c                                               |    3 
 fs/nfs/file.c                                                   |   16 
 fs/nfs/pnfs.c                                                   |    2 
 fs/nfs/write.c                                                  |   11 
 fs/notify/fdinfo.c                                              |   11 
 fs/notify/inotify/inotify.h                                     |   12 
 fs/notify/inotify/inotify_user.c                                |    2 
 fs/notify/mark.c                                                |    6 
 fs/ocfs2/dlmfs/userdlm.c                                        |   16 
 fs/proc/generic.c                                               |    3 
 fs/proc/proc_net.c                                              |    3 
 fs/xfs/libxfs/xfs_btree.c                                       |   35 -
 fs/xfs/xfs_dquot.c                                              |   39 +
 fs/xfs/xfs_iomap.c                                              |    3 
 fs/xfs/xfs_log.c                                                |   28 -
 fs/xfs/xfs_log.h                                                |    1 
 fs/xfs/xfs_mount.c                                              |   93 ++--
 fs/xfs/xfs_qm.c                                                 |   92 +---
 fs/xfs/xfs_symlink.c                                            |    1 
 include/drm/drm_edid.h                                          |    6 
 include/linux/bpf.h                                             |    2 
 include/linux/efi.h                                             |    2 
 include/linux/font.h                                            |    2 
 include/linux/gpio/driver.h                                     |   12 
 include/linux/kexec.h                                           |   46 +-
 include/linux/lsm_hook_defs.h                                   |    4 
 include/linux/lsm_hooks.h                                       |    2 
 include/linux/mailbox_controller.h                              |    1 
 include/linux/mtd/cfi.h                                         |    1 
 include/linux/nodemask.h                                        |   13 
 include/linux/platform_data/cros_ec_proto.h                     |    3 
 include/linux/ptrace.h                                          |    7 
 include/linux/security.h                                        |   23 -
 include/linux/thermal.h                                         |    2 
 include/linux/usb/hcd.h                                         |    2 
 include/net/bluetooth/hci.h                                     |   16 
 include/net/bluetooth/hci_core.h                                |   18 
 include/net/flow.h                                              |   10 
 include/net/if_inet6.h                                          |    8 
 include/net/route.h                                             |    6 
 include/scsi/libfcoe.h                                          |    3 
 include/sound/jack.h                                            |    1 
 include/trace/events/rxrpc.h                                    |    2 
 include/trace/events/vmscan.h                                   |    4 
 init/Kconfig                                                    |    5 
 ipc/mqueue.c                                                    |   14 
 kernel/bpf/stackmap.c                                           |    1 
 kernel/dma/debug.c                                              |    2 
 kernel/kexec_file.c                                             |   34 -
 kernel/ptrace.c                                                 |    5 
 kernel/rcu/Kconfig                                              |    1 
 kernel/rcu/tasks.h                                              |    3 
 kernel/scftorture.c                                             |    5 
 kernel/sched/fair.c                                             |    8 
 kernel/sched/pelt.h                                             |    4 
 kernel/sched/sched.h                                            |    4 
 kernel/trace/ftrace.c                                           |    5 
 kernel/trace/trace_events_hist.c                                |    3 
 mm/compaction.c                                                 |    2 
 mm/hugetlb.c                                                    |    9 
 net/bluetooth/hci_conn.c                                        |    8 
 net/bluetooth/hci_core.c                                        |   27 -
 net/bluetooth/hci_debugfs.c                                     |    8 
 net/bluetooth/hci_event.c                                       |   91 ++--
 net/bluetooth/hci_request.c                                     |  221 +++++++---
 net/bluetooth/hci_sock.c                                        |   12 
 net/bluetooth/l2cap_core.c                                      |   10 
 net/bluetooth/mgmt.c                                            |   14 
 net/bluetooth/mgmt_config.c                                     |   10 
 net/bluetooth/sco.c                                             |   21 
 net/bluetooth/smp.c                                             |    6 
 net/core/dev.c                                                  |    8 
 net/dccp/ipv4.c                                                 |    2 
 net/dccp/ipv6.c                                                 |    6 
 net/ipv4/icmp.c                                                 |    4 
 net/ipv4/inet_connection_sock.c                                 |    4 
 net/ipv4/ip_output.c                                            |    2 
 net/ipv4/ping.c                                                 |    2 
 net/ipv4/raw.c                                                  |    2 
 net/ipv4/syncookies.c                                           |    2 
 net/ipv4/udp.c                                                  |    2 
 net/ipv6/addrconf.c                                             |   33 +
 net/ipv6/af_inet6.c                                             |    2 
 net/ipv6/datagram.c                                             |    2 
 net/ipv6/icmp.c                                                 |    6 
 net/ipv6/inet6_connection_sock.c                                |    4 
 net/ipv6/netfilter/nf_reject_ipv6.c                             |    2 
 net/ipv6/ping.c                                                 |    2 
 net/ipv6/raw.c                                                  |    2 
 net/ipv6/syncookies.c                                           |    2 
 net/ipv6/tcp_ipv6.c                                             |    4 
 net/ipv6/udp.c                                                  |    2 
 net/l2tp/l2tp_ip6.c                                             |    2 
 net/mac80211/chan.c                                             |    7 
 net/mac80211/ieee80211_i.h                                      |    5 
 net/mac80211/scan.c                                             |   20 
 net/netfilter/nf_synproxy_core.c                                |    2 
 net/nfc/core.c                                                  |    1 
 net/rxrpc/ar-internal.h                                         |   13 
 net/rxrpc/call_event.c                                          |    7 
 net/rxrpc/conn_object.c                                         |    2 
 net/rxrpc/input.c                                               |   31 -
 net/rxrpc/output.c                                              |   20 
 net/rxrpc/recvmsg.c                                             |    8 
 net/rxrpc/sendmsg.c                                             |    6 
 net/rxrpc/sysctl.c                                              |    4 
 net/sctp/input.c                                                |    4 
 net/smc/af_smc.c                                                |    2 
 net/wireless/nl80211.c                                          |    1 
 net/wireless/reg.c                                              |    4 
 net/xfrm/xfrm_state.c                                           |    6 
 scripts/faddr2line                                              |  150 ++++--
 security/integrity/ima/Kconfig                                  |   14 
 security/integrity/platform_certs/keyring_handler.h             |    8 
 security/integrity/platform_certs/load_uefi.c                   |   33 +
 security/security.c                                             |   17 
 security/selinux/hooks.c                                        |    4 
 security/selinux/include/xfrm.h                                 |    2 
 security/selinux/xfrm.c                                         |   13 
 sound/core/jack.c                                               |   34 +
 sound/core/pcm_memory.c                                         |    3 
 sound/pci/hda/patch_realtek.c                                   |   11 
 sound/soc/atmel/atmel-classd.c                                  |    1 
 sound/soc/atmel/atmel-pdmic.c                                   |    1 
 sound/soc/codecs/Kconfig                                        |    2 
 sound/soc/codecs/max98090.c                                     |    6 
 sound/soc/codecs/rk3328_codec.c                                 |    2 
 sound/soc/codecs/rt5514.c                                       |    2 
 sound/soc/codecs/rt5645.c                                       |    7 
 sound/soc/codecs/tscs454.c                                      |   12 
 sound/soc/codecs/wm2000.c                                       |    6 
 sound/soc/fsl/imx-sgtl5000.c                                    |   14 
 sound/soc/intel/boards/bytcr_rt5640.c                           |   12 
 sound/soc/mediatek/mt2701/mt2701-wm8960.c                       |    9 
 sound/soc/mediatek/mt8173/mt8173-max98090.c                     |    5 
 sound/soc/mxs/mxs-saif.c                                        |    1 
 sound/soc/samsung/aries_wm8994.c                                |   17 
 sound/soc/samsung/arndale.c                                     |    5 
 sound/soc/samsung/littlemill.c                                  |    5 
 sound/soc/samsung/lowland.c                                     |    5 
 sound/soc/samsung/odroid.c                                      |    4 
 sound/soc/samsung/smdk_wm8994.c                                 |    4 
 sound/soc/samsung/smdk_wm8994pcm.c                              |    4 
 sound/soc/samsung/snow.c                                        |    9 
 sound/soc/samsung/speyside.c                                    |    5 
 sound/soc/samsung/tm2_wm5110.c                                  |    3 
 sound/soc/samsung/tobermory.c                                   |    5 
 sound/soc/soc-dapm.c                                            |    2 
 sound/soc/ti/j721e-evm.c                                        |   44 +
 sound/usb/midi.c                                                |    3 
 tools/lib/bpf/libbpf.c                                          |   20 
 tools/perf/Makefile.config                                      |   39 +
 tools/perf/builtin-c2c.c                                        |    6 
 tools/perf/pmu-events/jevents.c                                 |    2 
 tools/perf/util/data.h                                          |    1 
 tools/power/x86/turbostat/turbostat.c                           |    1 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c   |    2 
 tools/testing/selftests/cgroup/test_stress.sh                   |    2 
 tools/testing/selftests/resctrl/fill_buf.c                      |    4 
 510 files changed, 3860 insertions(+), 2277 deletions(-)

Abhinav Kumar (1):
      drm/msm/dpu: handle pm_runtime_get_sync() errors in bind path

Abhishek Kumar (1):
      ath10k: skip ath10k_halt during suspend for driver state RESTARTING

Aditya Garg (1):
      efi: Do not import certificates from UEFI Secure Boot for T2 Macs

Aidan MacDonald (1):
      mmc: jz4740: Apply DMA engine limits to maximum segment size

Akira Yokosawa (1):
      docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0

Albert Wang (1):
      usb: dwc3: gadget: Move null pinter check to proper place

Alex Elder (2):
      net: ipa: fix page free in ipa_endpoint_trans_release()
      net: ipa: fix page free in ipa_endpoint_replenish_one()

Alexander Aring (2):
      dlm: fix plock invalid read
      dlm: fix missing lkb refcount handling

Alexander Wetzel (1):
      rtl818x: Prevent using not initialized queues

Alexandre Ghiti (1):
      riscv: Initialize thread pointer before calling C functions

Alexandru Elisei (1):
      arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall

Alexey Dobriyan (1):
      proc: fix dentry/inode overinstantiating under /proc/${pid}/net

Alexey Khoroshilov (1):
      ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()

Alice Wong (1):
      drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo

Amadeusz Sławiński (1):
      ALSA: jack: Access input_dev under mutex

Amelie Delaunay (3):
      dmaengine: stm32-mdma: remove GISR1 register
      dmaengine: stm32-mdma: rework interrupt handler
      dmaengine: stm32-mdma: fix chan initialization in stm32_mdma_irq_handler()

Amir Goldstein (2):
      inotify: show inotify mask flags in proc fdinfo
      fsnotify: fix wrong lockdep annotations

Ammar Faizi (2):
      x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails
      x86/delay: Fix the wrong asm constraint in delay_loop()

Andre Przywara (1):
      ARM: dts: suniv: F1C100: fix watchdog compatible

Andreas Gruenbacher (1):
      iomap: iomap_write_failed fix

Andrii Nakryiko (2):
      libbpf: Don't error out on CO-RE relos for overriden weak subprogs
      libbpf: Fix logic for finding matching program for CO-RE relocation

Archie Pusaka (2):
      Bluetooth: use inclusive language in HCI role comments
      Bluetooth: use inclusive language when filtering devices

Arnd Bergmann (2):
      drbd: fix duplicate array initializer
      ARM: pxa: maybe fix gpio lookup tables

Baochen Qiang (1):
      ath11k: Don't check arvif->is_started before sending management frames

Baokun Li (1):
      ext4: fix bug_on in __es_tree_search

Bart Van Assche (1):
      scsi: ufs: qcom: Fix ufs_qcom_resume()

Bhaskar Chowdhury (1):
      Bluetooth: L2CAP: Rudimentary typo fixes

Biju Das (1):
      spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction

Bjorn Andersson (1):
      soc: qcom: llcc: Add MODULE_DEVICE_TABLE()

Bjorn Helgaas (1):
      PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299

Björn Ardö (1):
      mailbox: forward the hrtimer if not queued and under a lock

Bob Peterson (1):
      gfs2: use i_lock spin_lock for inode qadata

Borislav Petkov (1):
      x86/microcode: Add explicit CPU vendor dependency

Brian Foster (3):
      xfs: sync lazy sb accounting on quiesce of read-only mounts
      xfs: restore shutdown check in mapped write fault path
      xfs: consider shutdown in bmapbt cursor delete assert

Brian Norris (2):
      PM / devfreq: rk3399_dmc: Disable edev on remove()
      drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX

Cai Huoqing (1):
      media: staging: media: rkvdec: Make use of the helper function devm_platform_ioremap_resource()

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 modem

Chao Yu (7):
      f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()
      f2fs: fix to do sanity check on block address in f2fs_do_zero_range()
      f2fs: fix to clear dirty inode in f2fs_evict_inode()
      f2fs: fix deadloop in foreground GC
      f2fs: fix to do sanity check on total_data_blocks
      f2fs: fix fallocate to use file_modified to update permissions consistently
      f2fs: fix to do sanity check for inline inode

Charles Keepax (3):
      ASoC: tscs454: Add endianness flag in snd_soc_component_driver
      ASoC: atmel-pdmic: Remove endianness flag on pdmic component
      ASoC: atmel-classd: Remove endianness flag on class d component

Chen-Tsung Hsieh (1):
      mtd: spi-nor: core: Check written SR value in spi_nor_write_16bit_sr_and_check()

Chen-Yu Tsai (1):
      media: hantro: Empty encoder capture buffers by default

Chengming Zhou (1):
      sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq

Christoph Hellwig (2):
      target: remove an incorrect unmap zeroes data deduction
      virtio_blk: fix the discard_granularity and discard_alignment queue limits

Christophe JAILLET (5):
      media: aspeed: Fix an error handling path in aspeed_video_probe()
      hinic: Avoid some over memory allocation
      memory: samsung: exynos5422-dmc: Avoid some over memory allocation
      drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()
      dmaengine: idxd: Fix the error handling path in idxd_cdev_register()

Christophe de Dinechin (1):
      nodemask.h: fix compilation error with GCC12

Chuanhong Guo (1):
      arm: mediatek: select arch timer for mt7629

Colin Ian King (2):
      ALSA: pcm: Check for null pointer of pointer substream before dereferencing it
      selftests/resctrl: Fix null pointer dereference on open failed

Coly Li (4):
      bcache: improve multithreaded bch_btree_check()
      bcache: improve multithreaded bch_sectors_dirty_init()
      bcache: remove incremental dirty sector counting for bch_sectors_dirty_init()
      bcache: avoid journal no-space deadlock by reserving 1 journal bucket

Corentin Labbe (3):
      crypto: marvell/cesa - ECB does not IV
      crypto: sun8i-ss - rework handling of IV
      crypto: sun8i-ss - handle zero sized sg

Corey Minyard (2):
      ipmi:ssif: Check for NULL msg when handling events and messages
      ipmi: Fix pr_fmt to avoid compilation issues

Cristian Marussi (1):
      firmware: arm_scmi: Fix list protocols enumeration in the base protocol

Dan Carpenter (5):
      ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix
      drm/msm: return an error pointer in msm_gem_prime_get_sg_table()
      PCI: cadence: Fix find_first_zero_bit() limit
      PCI: rockchip: Fix find_first_zero_bit() limit
      OPP: call of_node_put() on error path in _bandwidth_supported()

Dan Williams (2):
      nvdimm: Fix firmware activation deadlock scenarios
      nvdimm: Allow overwrite in the presence of disabled dimms

Daniel Lezcano (2):
      thermal/drivers/core: Use a char pointer for the cooling device name
      thermal/core: Fix memory leak in the error path

Daniel Thompson (1):
      irqchip/exiu: Fix acknowledgment of edge triggered interrupts

Daniel Vetter (1):
      fbcon: Consistently protect deferred_takeover with console_lock()

Darrick J. Wong (3):
      xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
      xfs: fix incorrect root dquot corruption error when switching group/project quota types
      xfs: force log and push AIL to clear pinned inodes when aborting mount

Dave Airlie (1):
      drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.

Dave Chinner (1):
      xfs: assert in xfs_btree_del_cursor should take into account error

David Howells (7):
      rxrpc: Return an error to sendmsg if call failed
      rxrpc, afs: Fix selection of abort codes
      rxrpc: Fix listen() setting the bar too high for the prealloc rings
      rxrpc: Don't try to resend the request if we're receiving the reply
      rxrpc: Fix overlapping ACK accounting
      rxrpc: Don't let ack.previousPacket regress
      rxrpc: Fix decision on when to generate an IDLE ACK

Dennis Dalessandro (1):
      RDMA/hfi1: Fix potential integer multiplication overflow errors

Dimitri John Ledkov (1):
      cfg80211: declare MODULE_FIRMWARE for regulatory.db

Dinh Nguyen (1):
      dt-bindings: gpio: altera: correct interrupt-cells

Dmitry Baryshkov (2):
      drm/msm/dsi: fix error checks and return values for DSI xmit functions
      drm/msm: add missing include to msm_drv.c

Dmitry Torokhov (1):
      Input: stmfts - do not leave device disabled in stmfts_input_open

Dongliang Mu (3):
      HID: bigben: fix slab-out-of-bounds Write in bigben_probe
      rtlwifi: Use pr_warn instead of WARN_ONCE
      media: ov7670: remove ov7670_power_off from ov7670_remove

Douglas Miller (2):
      RDMA/hfi1: Prevent panic when SDMA is disabled
      RDMA/hfi1: Prevent use of lock before it is initialized

Duoming Zhou (1):
      NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix assert 1F04 upon reconfig

Eric Biggers (2):
      ext4: reject the 'commit' option on ext2 filesystems
      ext4: only allow test_dummy_encryption when supported

Eric Dumazet (2):
      net: remove two BUG() from skb_checksum_help()
      sctp: read sk->sk_bound_dev_if once in sctp_rcv()

Eric W. Biederman (3):
      ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP
      ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP
      ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Eugenio Pérez (1):
      vdpasim: allow to enable a vq repeatedly

Evan Quan (1):
      drm/amd/pm: fix the compile warning

Fabio Estevam (1):
      net: phy: micrel: Allow probing without .driver_data

Felix Fietkau (1):
      mac80211: upgrade passive scan to active scan on DFS channels after beacon rx

Finn Thain (1):
      macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled

Francesco Dolcini (1):
      PCI: imx6: Fix PERST# start-up sequence

GUO Zihua (1):
      ima: remove the IMA_TEMPLATE Kconfig option

Geert Uytterhoeven (2):
      m68k: atari: Make Atari ROM port I/O write macros return void
      m68k: math-emu: Fix dependencies of math emulation support

Gilad Ben-Yossef (1):
      crypto: ccree - use fine grained DMA mapping dir

Greg Kroah-Hartman (1):
      Linux 5.10.121

Guenter Roeck (2):
      platform/chrome: Re-introduce cros_ec_cmd_xfer and use it for ioctls
      MIPS: Loongson: Use hwmon_device_register_with_groups() to register hwmon

Guo Ren (1):
      csky: patch_text: Fixup last cpu should be master

Gustavo A. R. Silva (3):
      net: stmmac: selftests: Use kcalloc() instead of kzalloc()
      net: huawei: hinic: Use devm_kcalloc() instead of devm_kzalloc()
      scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Hangyu Hua (3):
      media: rga: fix possible memory leak in rga_probe
      drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()
      misc: ocxl: fix possible double free in ocxl_file_register_afu

Hans Verkuil (1):
      media: cec-adap.c: fix is_configuring state

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for the HP Pro Tablet 408

Haowen Bai (4):
      b43legacy: Fix assigning negative value to unsigned variable
      b43: Fix assigning negative value to unsigned variable
      ipw2x00: Fix potential NULL dereference in libipw_xmit()
      sfc: ef10: Fix assigning negative value to unsigned variable

Haren Myneni (1):
      powerpc/powernv/vas: Assign real address to rx_fifo in vas_rx_win_attr

Hari Bathini (2):
      powerpc/fadump: Fix fadump to work with a different endian capture kernel
      powerpc/fadump: fix PT_LOAD segment for boot memory area

Hari Chandrakanthan (1):
      ath11k: disable spectral scan during spectral deinit

Heiko Carstens (1):
      s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES

Helge Deller (2):
      parisc/stifb: Implement fb_is_primary_device()
      parisc/stifb: Keep track of hardware path of graphics card

Heming Zhao (1):
      md/bitmap: don't set sb values if can't pass sanity check

Howard Chung (1):
      Bluetooth: Interleave with allowlist scan

Jaegeuk Kim (1):
      f2fs: don't need inode lock for system hidden quota

Jagan Teki (1):
      drm/panel: panel-simple: Fix proper bpc for AM-1280800N3TZQW-T00H

Jakob Koschel (1):
      f2fs: fix dereference of stale list iterator after loop body

Jakub Kicinski (2):
      eth: tg3: silence the GCC 12 array-bounds warning
      net: stmmac: fix out-of-bounds access in a selftest

James Clark (1):
      perf tools: Use Python devtools for version autodetection rather than runtime

James Smart (1):
      scsi: lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()

Jan Kara (11):
      bfq: Split shared queues on move between cgroups
      bfq: Update cgroup information before merging bio
      bfq: Track whether bfq_group is still online
      ext4: verify dir block before splitting it
      ext4: avoid cycles in directory h-tree
      bfq: Avoid merging queues with different parents
      bfq: Drop pointless unlock-lock pair
      bfq: Remove pointless bfq_init_rq() calls
      bfq: Get rid of __bio_blkcg() usage
      bfq: Make sure bfqg for which we are queueing requests is online
      block: fix bio_clone_blkg_association() to associate with proper blkcg_gq

Jan Kiszka (1):
      efi: Add missing prototype for efi_capsule_setup_info

Jani Nikula (2):
      drm/edid: fix invalid EDID extension block filtering
      drm/i915/dsi: fix VBT send packet port selection for ICL+

Janusz Krzysztofik (1):
      ARM: OMAP1: clock: Fix UART rate reporting algorithm

Jason A. Donenfeld (2):
      openrisc: start CPU timer early in boot
      Revert "random: use static branch for crng_ready()"

Jeffrey Mitchell (1):
      xfs: set inode size after creating symlink

Jessica Zhang (2):
      drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected
      drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected

Jia-Ju Bai (1):
      md: bcache: check the return value of kzalloc() in detached_dev_do_request()

Jia-Wei Chang (1):
      cpufreq: mediatek: Use module_init and add module_exit

Jiantao Zhang (1):
      PCI: dwc: Fix setting error return on MSI DMA mapping failure

Jiasheng Jiang (1):
      drm: mali-dp: potential dereference of null pointer

Jiri Slaby (1):
      serial: pch: don't overwrite xmit->buf[0] by x_char

Joerg Roedel (1):
      iommu/amd: Increase timeout waiting for GA log enablement

Johan Hovold (4):
      PCI: qcom: Fix runtime PM imbalance on probe errors
      PCI: qcom: Fix unbalanced PHY init on probe errors
      phy: qcom-qmp: fix struct clk leak on probe errors
      phy: qcom-qmp: fix reset-controller leak on probe errors

Johannes Berg (3):
      nl80211: show SSID for P2P_GO interfaces
      wifi: mac80211: fix use-after-free in chanctx code
      um: chan_user: Fix winch_tramp() return value

Jonas Karlman (1):
      media: rkvdec: h264: Fix bit depth wrap in pps packet

Jonathan Bakker (1):
      ARM: dts: s5pv210: Remove spi-cs-high on panel in Aries

Jonathan Teh (1):
      HID: hid-led: fix maximum brightness for Dream Cheeky

Josh Poimboeuf (2):
      x86/speculation: Add missing prototype for unpriv_ebpf_notify()
      scripts/faddr2line: Fix overlapping text section failures

Junxiao Bi via Ocfs2-devel (1):
      ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

Kajol Jain (1):
      powerpc/perf: Fix the threshold compare group constraint for power9

Kan Liang (1):
      perf/x86/intel: Fix event constraints for ICL

Kathiravan T (1):
      arm64: dts: qcom: ipq8074: fix the sleep clock frequency

Keita Suzuki (2):
      drm/amd/pm: fix double free in si_parse_power_table()
      tracing: Fix potential double free in create_var_ref()

Keith Busch (1):
      nvme: set dma alignment to dword

Kirill A. Shutemov (1):
      ACPICA: Avoid cache flush inside virtual machines

Kishon Vijay Abraham I (1):
      usb: core: hcd: Add support for deferring roothub registration

Kiwoong Kim (1):
      scsi: ufs: core: Exclude UECxx from SFR dump list

Konrad Dybcio (2):
      arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count
      regulator: qcom_smd: Fix up PM8950 regulator configuration

Krzysztof Kozlowski (6):
      ARM: dts: ox820: align interrupt controller node name with dtschema
      ARM: dts: s5pv210: align DMA channels with dtschema
      ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM
      irqchip/aspeed-i2c-ic: Fix irq_of_parse_and_map() return value
      irqchip/aspeed-scu-ic: Fix irq_of_parse_and_map() return value
      pinctrl: mvebu: Fix irq_of_parse_and_map() return value

Kuldeep Singh (1):
      spi: qcom-qspi: Add minItems to interconnect-names

Kuninori Morimoto (2):
      ASoC: samsung: Use dev_err_probe() helper
      i2c: rcar: fix PM ref counts in probe error paths

Kuogee Hsieh (3):
      drm/msm/dpu: adjust display_v_end for eDP and DP
      drm/msm/dp: stop event kernel thread when DP unbind
      drm/msm/dp: fix event thread stuck in wait_event after kthread_stop()

Kuppuswamy Sathyanarayanan (1):
      PCI/AER: Clear MULTI_ERR_COR/UNCOR_RCV bits

Kwanghoon Son (1):
      media: exynos4-is: Fix compile warning

Lai Jiangshan (1):
      x86/sev: Annotate stack change in the #VC handler

Len Brown (1):
      tools/power turbostat: fix ICX DRAM power numbers

Leo Yan (1):
      perf c2c: Use stdio interface if slang is not supported

Lin Ma (2):
      ASoC: rt5645: Fix errorenous cleanup order
      NFC: NULL out the dev->rfkill to prevent UAF

Linus Torvalds (1):
      drm: fix EDID struct for old ARM OABI format

Liu Zixian (1):
      drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes

Liviu Dudau (1):
      drm/komeda: return early if drm_universal_plane_init() fails.

Luca Weiss (1):
      media: venus: hfi: avoid null dereference in deinit

Lucas Stach (2):
      drm/bridge: adv7511: clean up CEC adapter when probe fails
      drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem

Lv Ruyi (7):
      scsi: megaraid: Fix error check return value of register_chrdev()
      drm: msm: fix error check return value of irq_of_parse_and_map()
      powerpc/xics: fix refcount leak in icp_opal_init()
      powerpc/powernv: fix missing of_node_put in uv_init()
      drm/msm/dp: fix error check return value of irq_of_parse_and_map()
      drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()
      mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Maciej W. Rozycki (2):
      MIPS: IP27: Remove incorrect `cpu_has_fpu' override
      MIPS: IP30: Remove incorrect `cpu_has_fpu' override

Manivannan Sadhasivam (1):
      scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled

Mao Jinlong (1):
      coresight: core: Fix coresight device probe failure issue

Marc Kleine-Budde (1):
      can: xilinx_can: mark bit timing constants as const

Marek Vasut (2):
      drm/panel: simple: Add missing bus flags for Innolux G070Y2-L01
      ARM: dts: stm32: Fix PHY post-reset delay on Avenger96

Mario Limonciello (1):
      ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default

Marios Levogiannis (1):
      ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS

Mark Bloch (1):
      net/mlx5: fs, delete the FTE when there are no rules attached to it

Mark Brown (2):
      ASoC: dapm: Don't fold register value changes into notifications
      ASoC: rt5514: Fix event generation for "DSP Voice Wake Up" control

Mathias Nyman (1):
      xhci: Allow host runtime PM as default for Intel Alder Lake N xHCI

Matthieu Baerts (1):
      x86/pm: Fix false positive kmemleak report in msr_build_context()

Max Filippov (1):
      irqchip: irq-xtensa-mx: fix initial IRQ affinity

Max Krummenacher (1):
      ARM: dts: imx6dl-colibri: Fix I2C pinmuxing

Maxime Ripard (3):
      drm/vc4: hvs: Reset muxes at probe time
      drm/vc4: txp: Don't set TXP_VSTART_AT_EOF
      drm/vc4: txp: Force alpha to be 0xff if it's disabled

Miaohe Lin (1):
      drivers/base/node.c: fix compaction sysfs file leak

Miaoqian Lin (20):
      ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe
      ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe
      spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout
      HID: elan: Fix potential double free in elan_input_configured
      drm/bridge: Fix error handling in analogix_dp_probe
      ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe
      ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe
      regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt
      ASoC: samsung: Fix refcount leak in aries_audio_probe
      media: exynos4-is: Fix PM disable depth imbalance in fimc_is_probe
      media: st-delta: Fix PM disable depth imbalance in delta_probe
      media: exynos4-is: Change clk_disable to clk_disable_unprepare
      ASoC: ti: j721e-evm: Fix refcount leak in j721e_soc_probe_*
      drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init
      thermal/drivers/imx_sc_thermal: Fix refcount leak in imx_sc_thermal_probe
      soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc
      soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc
      Input: sparcspkr - fix refcount leak in bbc_beep_probe
      powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup
      video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup

Michael Ellerman (1):
      powerpc/64: Only WARN if __pa()/__va() called with bad addresses

Michael Rodin (1):
      media: vsp1: Fix offset calculation for plane cropping

Michael Walle (1):
      i2c: at91: use dma safe buffers

Mike Kravetz (1):
      hugetlb: fix huge_pmd_unshare address update

Mike Travis (1):
      x86/platform/uv: Update TSC sync state for UV5

Mikulas Patocka (1):
      dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Miles Chen (1):
      drm/mediatek: Fix mtk_cec_mask()

Minghao Chi (1):
      scsi: ufs: Use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

Monish Kumar R (1):
      USB: new quirk for Dell Gen 2 devices

Muchun Song (1):
      dax: fix cache flush on PMD-mapped pages

Nathan Chancellor (2):
      drm/i915: Fix CFI violation with show_dynamic_id()
      i2c: at91: Initialize dma_buf in at91_twi_xfer()

Naveen N. Rao (1):
      kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Nico Boehr (1):
      s390/perf: obtain sie_block from the right address

Nicolas Dufresne (3):
      media: rkvdec: h264: Fix dpb_valid implementation
      media: coda: Fix reported H264 profile
      media: coda: Add more H264 levels for CODA960

Nicolas Frattaroli (1):
      ASoC: rk3328: fix disabling mclk on pclk probe failure

Niels Dossche (5):
      mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
      ipv6: fix locking issues with loops over idev->addr_list
      IB/rdmavt: add missing locks in rvt_ruc_loopback
      ath11k: acquire ab->base_lock in unassign when finding the peer by addr
      Bluetooth: use hdev lock for accept_list and reject_list in conn req

Niklas Cassel (1):
      binfmt_flat: do not stop relocating GOT entries prematurely on riscv

Noralf Trønnes (1):
      dt-bindings: display: sitronix, st7735r: Fix backlight in example

Nuno Sá (1):
      of: overlay: do not break notify on NOTIFY_{OK|STOP}

OGAWA Hirofumi (1):
      fat: add ratelimit to fat*_ent_bread()

Padmanabha Srinivasaiah (1):
      rcu-tasks: Fix race in schedule and flush work

Pali Rohár (1):
      irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x

Patrice Chotard (1):
      spi: stm32-qspi: Fix wait_cmd timeout in APM mode

Paul Cercueil (1):
      drm/ingenic: Reset pixclock rate when parent clock rate changes

Paul E. McKenney (2):
      rcu: Make TASKS_RUDE_RCU select IRQ_WORK
      scftorture: Fix distribution of short handler delays

Paul Moore (1):
      lsm,selinux: pass flowi_common instead of flowi to the LSM hooks

Pavel Skripkin (1):
      media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Peilin Ye (1):
      Fonts: Make font size unsigned in font_desc

Peng Wu (3):
      ARM: versatile: Add missing of_node_put in dcscb_init
      ARM: hisi: Add missing of_node_put after of_find_compatible_node
      powerpc/iommu: Add missing of_node_put in iommu_init_early_dart

Petr Machata (2):
      mlxsw: spectrum_dcb: Do not warn about priority changes
      mlxsw: Treat LLDP packets as control

Phil Auld (1):
      kselftest/cgroup: fix test_stress.sh to use OUTPUT dir

Phil Elwell (3):
      ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT
      ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C
      ARM: dts: bcm2837-rpi-3-b-plus: Fix GPIO line name of power LED

Philipp Zabel (1):
      media: coda: limit frame interval enumeration to supported encoder frame sizes

Pierre-Louis Bossart (2):
      ASoC: max98357a: remove dependency on GPIOLIB
      ASoC: rt1015p: remove dependency on GPIOLIB

Qi Zheng (1):
      tty: fix deadlock caused by calling printk() under tty_port->lock

Qinglang Miao (1):
      cpufreq: mediatek: add missing platform_driver_unregister() on error in mtk_cpufreq_driver_init

QintaoShen (1):
      soc: ti: ti_sci_pm_domains: Check for null return of devm_kcalloc

Qu Wenruo (2):
      btrfs: add "0x" prefix for unsupported optional features
      btrfs: repair super block num_devices automatically

Randy Dunlap (6):
      x86: Fix return value of __setup handlers
      x86/mm: Cleanup the control_va_addr_alignment() __setup handler
      powerpc/8xx: export 'cpm_setbrg' for modules
      powerpc/idle: Fix return value of __setup() handler
      powerpc/4xx/cpm: Fix return value of __setup() handler
      macintosh: via-pmu and via-cuda need RTC_LIB

Ravi Bangoria (2):
      perf/amd/ibs: Cascade pmu init functions' return value
      perf/amd/ibs: Use interrupt regs ip for stack unwinding

Rei Yamamoto (1):
      mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Rex-BC Chen (1):
      cpufreq: mediatek: Unregister platform device on exit

Rik van der Kemp (1):
      ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop

Ronnie Sahlberg (1):
      cifs: when extending a file with falloc we should make files not-sparse

Russell King (Oracle) (1):
      net: dsa: mt7530: 1G can also support 1000BASE-X link mode

Sakari Ailus (1):
      ACPI: property: Release subnode properties with data nodes

Samuel Holland (1):
      riscv: Fix irq_work when SMP is disabled

Sathish Narasimman (1):
      Bluetooth: LL privacy allow RPA

Schspa Shi (1):
      cpufreq: Fix possible race in cpufreq online error path

Sean Christopherson (3):
      KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry
      KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault
      Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug

Sebastian Andrzej Siewior (1):
      crypto: cryptd - Protect per-CPU resource by disabling BH.

Shawn Lin (1):
      arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399

Smith, Kyle Miller (Nimble Kernel) (1):
      nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Song Liu (1):
      ftrace: Clean up hash direct_functions on register failures

Stefan Wahren (4):
      thermal/drivers/bcm2711: Don't clamp temperature at zero
      ARM: dts: bcm2835-rpi-b: Fix GPIO line names
      gpiolib: of: Introduce hook for missing gpio-ranges
      pinctrl: bcm2835: implement hook for missing gpio-ranges

Steve French (1):
      SMB3: EBADF/EIO errors in rename/open caused by race condition in smb2_compound_op

Steven Price (1):
      drm/plane: Move range check for format_count earlier

Takashi Iwai (1):
      ALSA: usb-audio: Cancel pending work at closing a MIDI substream

Tali Perry (2):
      i2c: npcm: Fix timeout calculation
      i2c: npcm: Handle spurious interrupts

Tejas Upadhyay (1):
      iommu/vt-d: Add RPLS to quirk list to skip TE disabling

Tejun Heo (1):
      blk-iolatency: Fix inflight count imbalances and IO hangs on offline

Tetsuo Handa (1):
      media: imon: reorganize serialization

Theodore Ts'o (1):
      ext4: filter out EXT4_FC_REPLAY from on-disk superblock field s_state

Thibaut VARÈNE (1):
      ath9k: fix QCA9561 PA bias level

Thorsten Scherer (1):
      ARM: dts: ci4x10: Adapt to changes in imx6qdl.dtsi regarding fec clocks

Tokunori Ikegami (2):
      mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
      mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

Tong Tiangen (1):
      arm64: fix types in copy_highpage()

Trond Myklebust (5):
      NFS: Do not report EINTR/ERESTARTSYS as mapping errors
      NFS: fsync() should report filesystem errors over EINTR/ERESTARTSYS
      NFS: Do not report flush errors in nfs_write_end()
      NFS: Don't report errors from nfs_pageio_complete() more than once
      NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout

Tyler Hicks (1):
      EDAC/dmc520: Don't print an error for each unconfigured interrupt line

Tyrone Ting (1):
      i2c: npcm: Correct register access width

Tzung-Bi Shih (1):
      platform/chrome: cros_ec: fix error handling in cros_ec_register()

Vasily Averin (1):
      tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate

Vignesh Raghavendra (1):
      drivers: mmc: sdhci_am654: Add the quirk to set TESTCD bit

Vincent Mailhol (1):
      can: mcp251xfd: silence clang's -Wunaligned-access warning

Vincent Whitchurch (1):
      um: Fix out-of-bounds read in LDT setup

Vinod Polimera (1):
      drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume

Viresh Kumar (1):
      Revert "cpufreq: Fix possible race in cpufreq online error path"

Waiman Long (2):
      ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()
      kseltest/cgroup: Make test_stress.sh work if run interactively

Wenli Looi (1):
      ath9k: fix ar9003_get_eepmisc

Xiao Yang (1):
      RDMA/rxe: Generate a completion for unsupported/invalid opcode

Xiaomeng Tong (11):
      media: uvcvideo: Fix missing check to determine if element is found in list
      scsi: dc395x: Fix a missing check on list iterator
      drm/nouveau/clk: Fix an incorrect NULL check on list iterator
      drm/nouveau/kms/nv50-: atom: fix an incorrect NULL check on list iterator
      md: fix an incorrect NULL check in does_sb_need_changing
      md: fix an incorrect NULL check in md_reload_sb
      iommu/msm: Fix an incorrect NULL check on list iterator
      carl9170: tx: fix an incorrect use of list iterator
      stm: ltdc: fix two incorrect NULL checks on list iterator
      tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator
      gma500: fix an incorrect NULL check on list iterator

Xie Yongji (1):
      nbd: Fix hung on disconnect request if socket is closed before

Yang Jihong (1):
      perf tools: Add missing headers needed by util/data.h

Yang Yingliang (10):
      pinctrl: renesas: rzn1: Fix possible null-ptr-deref in sh_pfc_map_resources()
      mtd: rawnand: cadence: fix possible null-ptr-deref in cadence_nand_dt_probe()
      drm/msm/hdmi: check return value after calling platform_get_resource_byname()
      drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()
      spi: spi-fsl-qspi: check return value after calling platform_get_resource_byname()
      thermal/core: Fix memory leak in __thermal_cooling_device_register()
      ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()
      pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()
      hwrng: omap3-rom - fix using wrong clk_disable() in omap_rom_rng_runtime_resume()
      mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()

Ye Bin (3):
      ext4: fix use-after-free in ext4_rename_dir_prepare
      ext4: fix warning in ext4_handle_inode_extension
      ext4: fix bug_on in ext4_writepages

Yi Yang (1):
      xtensa/simdisk: fix proc_read_simdisk()

Yicong Yang (1):
      PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()

Ying Hsu (1):
      Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Yong Wu (1):
      iommu/mediatek: Add list_del in mtk_iommu_remove

Yonghong Song (1):
      selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Yongzhi Liu (1):
      hv_netvsc: Fix potential dereference of NULL pointer

Yuntao Wang (1):
      bpf: Fix excessive memory allocation in stack_map_alloc()

Zev Weiss (1):
      regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET

Zheng Bin (1):
      net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init

Zheng Yongjun (2):
      spi: img-spfi: Fix pm_runtime_get_sync() error checking
      thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe

Zhengjun Xing (1):
      perf jevents: Fix event syntax error caused by ExtSel

Zheyu Ma (3):
      media: pci: cx23885: Fix the error handling in cx23885_initdev()
      media: cx25821: Fix the warning when removing the module
      mtd: rawnand: denali: Use managed device resources

Zhihao Cheng (1):
      fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages

Zhou Qingyang (1):
      drm/komeda: Fix an undefined behavior bug in komeda_plane_add()

Zixuan Fu (1):
      fs: jfs: fix possible NULL pointer dereference in dbFree()

Ziyang Xuan (1):
      thermal/core: fix a UAF bug in __thermal_cooling_device_register()

jianghaoran (1):
      ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

liuyacan (1):
      net/smc: postpone sk_refcnt increment in connect()

