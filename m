Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C3203196
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgFVIJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgFVIJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 04:09:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45816207C3;
        Mon, 22 Jun 2020 08:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813339;
        bh=kfXSaUJJYWTeyJnKekxxR+TXItXcdi6CZkk9mndOPUY=;
        h=From:To:Cc:Subject:Date:From;
        b=XTAmP/vNfqFUTEARHSnQD+fOA0D2xf+UDe0ZhZ0But8mxET5tR48QMxDDJESk3QmU
         vRoEZrfyEOKZ5AP/CkVEa66QE8KBOvnf0meSrurj1vk2ZnPXpu+raCZlx3NuhgXr5K
         K3GjgqFwP9RtP47f9zKaqaJ4MTHmymAZILj7hp3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.5
Date:   Mon, 22 Jun 2020 10:08:40 +0200
Message-Id: <159281332020554@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.5 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt  |    6 
 Documentation/virt/kvm/api.rst                                       |    2 
 Makefile                                                             |   15 
 arch/alpha/include/asm/io.h                                          |   74 ++
 arch/alpha/kernel/io.c                                               |   60 ++
 arch/arm/boot/compressed/.gitignore                                  |    9 
 arch/arm/boot/compressed/Makefile                                    |   38 -
 arch/arm/boot/compressed/atags_to_fdt.c                              |    1 
 arch/arm/boot/compressed/fdt.c                                       |    2 
 arch/arm/boot/compressed/fdt_ro.c                                    |    2 
 arch/arm/boot/compressed/fdt_rw.c                                    |    2 
 arch/arm/boot/compressed/fdt_wip.c                                   |    2 
 arch/arm/boot/compressed/libfdt_env.h                                |   24 
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                            |    2 
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi                          |    2 
 arch/arm/boot/dts/s5pv210-aries.dtsi                                 |    1 
 arch/arm/mach-tegra/tegra.c                                          |    4 
 arch/arm/mm/proc-macros.S                                            |    3 
 arch/arm64/include/asm/cacheflush.h                                  |    6 
 arch/arm64/include/asm/pgtable.h                                     |    1 
 arch/arm64/kernel/head.S                                             |   12 
 arch/arm64/kernel/insn.c                                             |   14 
 arch/arm64/kernel/machine_kexec_file.c                               |    6 
 arch/arm64/kernel/vmlinux.lds.S                                      |    1 
 arch/m68k/include/asm/mac_via.h                                      |    1 
 arch/m68k/mac/config.c                                               |   21 
 arch/m68k/mac/via.c                                                  |    6 
 arch/mips/Makefile                                                   |   13 
 arch/mips/boot/compressed/Makefile                                   |    2 
 arch/mips/configs/loongson3_defconfig                                |    2 
 arch/mips/include/asm/cpu-features.h                                 |    6 
 arch/mips/include/asm/mipsregs.h                                     |    2 
 arch/mips/kernel/genex.S                                             |    6 
 arch/mips/kernel/mips-cm.c                                           |    6 
 arch/mips/kernel/setup.c                                             |   10 
 arch/mips/kernel/time.c                                              |   70 ++
 arch/mips/kernel/vmlinux.lds.S                                       |    2 
 arch/mips/loongson2ef/common/init.c                                  |    4 
 arch/mips/loongson64/init.c                                          |    4 
 arch/mips/mm/dma-noncoherent.c                                       |    1 
 arch/mips/mti-malta/malta-init.c                                     |    8 
 arch/mips/pistachio/init.c                                           |    8 
 arch/mips/tools/elf-entry.c                                          |    9 
 arch/powerpc/Kconfig                                                 |    4 
 arch/powerpc/include/asm/book3s/32/kup.h                             |    3 
 arch/powerpc/include/asm/fadump-internal.h                           |    4 
 arch/powerpc/include/asm/kasan.h                                     |    6 
 arch/powerpc/kernel/dt_cpu_ftrs.c                                    |    8 
 arch/powerpc/kernel/fadump.c                                         |  155 ++++--
 arch/powerpc/kernel/prom.c                                           |   19 
 arch/powerpc/mm/init_32.c                                            |    2 
 arch/powerpc/mm/kasan/kasan_init_32.c                                |    4 
 arch/powerpc/mm/pgtable_32.c                                         |    4 
 arch/powerpc/platforms/cell/spufs/file.c                             |  113 +++-
 arch/powerpc/platforms/powernv/smp.c                                 |    1 
 arch/riscv/mm/init.c                                                 |   11 
 arch/riscv/net/bpf_jit_comp32.c                                      |    5 
 arch/s390/net/bpf_jit_comp.c                                         |   19 
 arch/sparc/kernel/ptrace_32.c                                        |  228 +++------
 arch/sparc/kernel/ptrace_64.c                                        |   17 
 arch/x86/boot/compressed/head_32.S                                   |    5 
 arch/x86/boot/compressed/head_64.S                                   |    1 
 arch/x86/include/asm/smap.h                                          |   11 
 arch/x86/kernel/amd_nb.c                                             |    5 
 arch/x86/kernel/irq_64.c                                             |    2 
 arch/x86/mm/init.c                                                   |    2 
 block/blk-iocost.c                                                   |   28 -
 block/blk-mq.c                                                       |   26 -
 block/blk.h                                                          |    2 
 crypto/blake2b_generic.c                                             |    4 
 drivers/acpi/acpica/dsfield.c                                        |   17 
 drivers/acpi/arm64/iort.c                                            |    5 
 drivers/acpi/evged.c                                                 |    2 
 drivers/acpi/video_detect.c                                          |   10 
 drivers/base/swnode.c                                                |   27 -
 drivers/bluetooth/btbcm.c                                            |    2 
 drivers/bluetooth/btmtkuart.c                                        |   14 
 drivers/bluetooth/btusb.c                                            |    1 
 drivers/bluetooth/hci_bcm.c                                          |    8 
 drivers/bluetooth/hci_qca.c                                          |   10 
 drivers/clk/mediatek/clk-mux.c                                       |    2 
 drivers/clocksource/Kconfig                                          |    1 
 drivers/clocksource/dw_apb_timer.c                                   |    5 
 drivers/clocksource/dw_apb_timer_of.c                                |    6 
 drivers/clocksource/timer-versatile.c                                |    3 
 drivers/cpufreq/qcom-cpufreq-nvmem.c                                 |    2 
 drivers/cpuidle/cpuidle-psci.c                                       |    8 
 drivers/cpuidle/sysfs.c                                              |    6 
 drivers/crypto/ccp/Kconfig                                           |    3 
 drivers/crypto/chelsio/chcr_algo.c                                   |   45 +
 drivers/crypto/chelsio/chcr_crypto.h                                 |    1 
 drivers/crypto/stm32/stm32-crc32.c                                   |  144 +++--
 drivers/edac/amd64_edac.c                                            |   14 
 drivers/edac/amd64_edac.h                                            |    3 
 drivers/firmware/efi/libstub/Makefile                                |    1 
 drivers/firmware/efi/libstub/randomalloc.c                           |    4 
 drivers/gnss/sirf.c                                                  |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                              |   43 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                               |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                               |   11 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c                   |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c                    |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                   |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                |    9 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c                |    6 
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h                     |    2 
 drivers/gpu/drm/ast/ast_mode.c                                       |   13 
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c                       |   12 
 drivers/gpu/drm/bridge/panel.c                                       |    6 
 drivers/gpu/drm/bridge/tc358768.c                                    |    4 
 drivers/gpu/drm/drm_dp_helper.c                                      |    1 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c                       |    9 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c                      |    4 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_ttm.c                          |    2 
 drivers/gpu/drm/mcde/mcde_dsi.c                                      |    7 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                   |   31 +
 drivers/gpu/drm/rcar-du/rcar_du_plane.c                              |   16 
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c                                |   14 
 drivers/hv/connection.c                                              |   20 
 drivers/hv/hv.c                                                      |    7 
 drivers/hv/hyperv_vmbus.h                                            |   11 
 drivers/hv/vmbus_drv.c                                               |   20 
 drivers/hwmon/k10temp.c                                              |    1 
 drivers/iommu/intel-iommu.c                                          |   28 -
 drivers/irqchip/irq-sifive-plic.c                                    |   17 
 drivers/macintosh/windfarm_pm112.c                                   |   21 
 drivers/md/bcache/request.c                                          |    1 
 drivers/md/bcache/super.c                                            |    7 
 drivers/md/dm-crypt.c                                                |    2 
 drivers/md/md.c                                                      |    3 
 drivers/md/raid5.c                                                   |   15 
 drivers/media/cec/cec-adap.c                                         |    8 
 drivers/media/dvb-frontends/m88ds3103.c                              |    2 
 drivers/media/i2c/imx219.c                                           |    2 
 drivers/media/i2c/ov5640.c                                           |    4 
 drivers/media/platform/qcom/venus/core.c                             |   12 
 drivers/media/platform/rcar-fcp.c                                    |    5 
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c                     |    6 
 drivers/media/platform/vicodec/vicodec-core.c                        |   15 
 drivers/media/tuners/si2157.c                                        |   15 
 drivers/media/usb/dvb-usb/dibusb-mb.c                                |    2 
 drivers/media/v4l2-core/v4l2-ctrls.c                                 |   18 
 drivers/memory/samsung/exynos5422-dmc.c                              |    2 
 drivers/mmc/host/meson-mx-sdio.c                                     |    3 
 drivers/mmc/host/mmci.c                                              |   30 -
 drivers/mmc/host/mmci_stm32_sdmmc.c                                  |    1 
 drivers/mmc/host/owl-mmc.c                                           |    8 
 drivers/mmc/host/sdhci-esdhc-imx.c                                   |    2 
 drivers/mmc/host/sdhci-msm.c                                         |    4 
 drivers/mmc/host/sdhci.c                                             |   10 
 drivers/mmc/host/sdhci.h                                             |    3 
 drivers/mmc/host/via-sdmmc.c                                         |    7 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                             |   11 
 drivers/mtd/nand/raw/diskonchip.c                                    |    7 
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c                      |    2 
 drivers/mtd/nand/raw/mtk_nand.c                                      |    2 
 drivers/mtd/nand/raw/nand_base.c                                     |   10 
 drivers/mtd/nand/raw/nand_onfi.c                                     |    2 
 drivers/mtd/nand/raw/orion_nand.c                                    |    2 
 drivers/mtd/nand/raw/oxnas_nand.c                                    |    8 
 drivers/mtd/nand/raw/pasemi_nand.c                                   |    4 
 drivers/mtd/nand/raw/plat_nand.c                                     |    2 
 drivers/mtd/nand/raw/sharpsl.c                                       |    2 
 drivers/mtd/nand/raw/socrates_nand.c                                 |    2 
 drivers/mtd/nand/raw/sunxi_nand.c                                    |    2 
 drivers/mtd/nand/raw/tmio_nand.c                                     |    2 
 drivers/mtd/nand/raw/xway_nand.c                                     |    2 
 drivers/net/dsa/sja1105/sja1105_ethtool.c                            |  144 ++---
 drivers/net/ethernet/allwinner/sun4i-emac.c                          |    4 
 drivers/net/ethernet/amazon/ena/ena_com.c                            |    6 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                      |    6 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                       |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                       |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c                   |   39 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                     |    4 
 drivers/net/ethernet/intel/e1000/e1000_main.c                        |    4 
 drivers/net/ethernet/intel/e1000e/e1000.h                            |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                           |   16 
 drivers/net/ethernet/intel/ice/ice.h                                 |    2 
 drivers/net/ethernet/intel/ice/ice_common.c                          |    8 
 drivers/net/ethernet/intel/ice/ice_controlq.c                        |   49 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c                         |    4 
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c                       |    8 
 drivers/net/ethernet/intel/ice/ice_main.c                            |    8 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                     |   65 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h                     |    2 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                         |    3 
 drivers/net/ethernet/intel/igc/igc_main.c                            |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                      |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                        |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c                 |    8 
 drivers/net/ethernet/mellanox/mlx4/crdump.c                          |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                      |   15 
 drivers/net/ethernet/mscc/ocelot_ace.c                               |  103 ++++
 drivers/net/ethernet/mscc/ocelot_ace.h                               |    5 
 drivers/net/ethernet/mscc/ocelot_flower.c                            |    2 
 drivers/net/ethernet/nxp/lpc_eth.c                                   |    3 
 drivers/net/ethernet/qlogic/qede/qede.h                              |    2 
 drivers/net/ethernet/qlogic/qede/qede_main.c                         |   11 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                    |   20 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                     |    5 
 drivers/net/ethernet/ti/davinci_mdio.c                               |    2 
 drivers/net/ethernet/ti/k3-cppi-desc-pool.c                          |    4 
 drivers/net/ipa/gsi.c                                                |   11 
 drivers/net/macvlan.c                                                |    4 
 drivers/net/veth.c                                                   |    8 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                                |    2 
 drivers/net/wireless/ath/ath10k/bmi.c                                |    1 
 drivers/net/wireless/ath/ath10k/htt.h                                |    7 
 drivers/net/wireless/ath/ath10k/htt_tx.c                             |    8 
 drivers/net/wireless/ath/ath10k/mac.c                                |    5 
 drivers/net/wireless/ath/ath10k/pci.c                                |    1 
 drivers/net/wireless/ath/ath10k/qmi.c                                |   13 
 drivers/net/wireless/ath/ath10k/qmi.h                                |    6 
 drivers/net/wireless/ath/ath10k/txrx.c                               |    2 
 drivers/net/wireless/ath/ath10k/wmi-ops.h                            |   10 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                            |   15 
 drivers/net/wireless/ath/ath11k/dp.c                                 |    4 
 drivers/net/wireless/ath/ath11k/dp_rx.c                              |   20 
 drivers/net/wireless/ath/ath11k/thermal.c                            |    6 
 drivers/net/wireless/ath/ath11k/wmi.c                                |    7 
 drivers/net/wireless/ath/carl9170/fw.c                               |    4 
 drivers/net/wireless/ath/carl9170/main.c                             |   21 
 drivers/net/wireless/ath/wcn36xx/main.c                              |    6 
 drivers/net/wireless/broadcom/b43/main.c                             |    2 
 drivers/net/wireless/broadcom/b43legacy/main.c                       |    1 
 drivers/net/wireless/broadcom/b43legacy/xmit.c                       |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c          |   12 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c           |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                     |   11 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                    |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                       |   15 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                         |   18 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h                         |    6 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                    |    6 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                      |   14 
 drivers/net/wireless/mediatek/mt76/agg-rx.c                          |    8 
 drivers/net/wireless/mediatek/mt76/mt76.h                            |    6 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                      |   34 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h                      |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                     |   21 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                      |   16 
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h                     |    2 
 drivers/net/wireless/realtek/rtlwifi/usb.c                           |    8 
 drivers/net/wireless/realtek/rtw88/pci.c                             |    1 
 drivers/nvme/host/core.c                                             |   16 
 drivers/nvme/host/fc.c                                               |    2 
 drivers/nvme/host/pci.c                                              |   79 ++-
 drivers/nvme/host/tcp.c                                              |    4 
 drivers/nvme/target/core.c                                           |   15 
 drivers/pci/probe.c                                                  |   24 
 drivers/pci/quirks.c                                                 |   48 +
 drivers/perf/arm_smmuv3_pmu.c                                        |    5 
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c                         |    2 
 drivers/pinctrl/samsung/pinctrl-exynos.c                             |   82 ++-
 drivers/platform/x86/asus-wmi.c                                      |    2 
 drivers/platform/x86/dell-laptop.c                                   |   11 
 drivers/platform/x86/hp-wmi.c                                        |   10 
 drivers/platform/x86/intel-hid.c                                     |    7 
 drivers/platform/x86/intel-vbtn.c                                    |   75 ++-
 drivers/power/reset/vexpress-poweroff.c                              |    1 
 drivers/power/supply/power_supply_hwmon.c                            |    4 
 drivers/pwm/pwm-jz4740.c                                             |    6 
 drivers/pwm/pwm-lpss.c                                               |   15 
 drivers/regulator/qcom-rpmh-regulator.c                              |    8 
 drivers/soc/fsl/dpio/qbman-portal.c                                  |    1 
 drivers/soc/tegra/Kconfig                                            |    1 
 drivers/spi/spi-dw-mid.c                                             |   16 
 drivers/spi/spi-dw.c                                                 |    8 
 drivers/spi/spi-fsl-dspi.c                                           |   24 
 drivers/spi/spi-mem.c                                                |   10 
 drivers/spi/spi-mux.c                                                |    8 
 drivers/spi/spi-pxa2xx.c                                             |    1 
 drivers/spi/spi.c                                                    |    1 
 drivers/staging/android/ion/ion_heap.c                               |    4 
 drivers/staging/greybus/sdio.c                                       |   10 
 drivers/staging/media/imx/imx-media-utils.c                          |  201 ++------
 drivers/staging/media/imx/imx7-mipi-csis.c                           |   82 +--
 drivers/staging/media/ipu3/ipu3-mmu.c                                |   10 
 drivers/staging/media/ipu3/ipu3-v4l2.c                               |   10 
 drivers/staging/media/ipu3/ipu3.c                                    |    5 
 drivers/staging/media/ipu3/ipu3.h                                    |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c                      |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_video.c                    |    3 
 drivers/tty/serial/8250/8250_core.c                                  |   14 
 drivers/tty/serial/8250/8250_pci.c                                   |    6 
 drivers/tty/serial/kgdboc.c                                          |  126 ++++-
 drivers/usb/musb/mediatek.c                                          |    6 
 drivers/virtio/virtio_balloon.c                                      |    9 
 drivers/w1/masters/omap_hdq.c                                        |   74 +-
 fs/btrfs/block-group.c                                               |    2 
 fs/btrfs/block-rsv.c                                                 |    3 
 fs/btrfs/ctree.h                                                     |    4 
 fs/btrfs/disk-io.c                                                   |    5 
 fs/btrfs/extent-io-tree.h                                            |    1 
 fs/btrfs/file-item.c                                                 |    6 
 fs/btrfs/inode.c                                                     |   81 ++-
 fs/btrfs/qgroup.c                                                    |   14 
 fs/btrfs/relocation.c                                                |   12 
 fs/btrfs/scrub.c                                                     |   38 +
 fs/btrfs/send.c                                                      |   67 ++
 fs/btrfs/space-info.c                                                |   43 +
 fs/btrfs/space-info.h                                                |    1 
 fs/btrfs/transaction.c                                               |   60 --
 fs/btrfs/transaction.h                                               |    3 
 fs/btrfs/tree-log.c                                                  |   22 
 fs/btrfs/volumes.c                                                   |   14 
 fs/ext4/ext4_extents.h                                               |    9 
 fs/ext4/fsync.c                                                      |   28 -
 fs/ext4/ialloc.c                                                     |    1 
 fs/ext4/xattr.c                                                      |    7 
 fs/f2fs/f2fs.h                                                       |    1 
 fs/f2fs/inline.c                                                     |    6 
 fs/f2fs/super.c                                                      |   25 -
 fs/io_uring.c                                                        |  250 ++++++----
 fs/jbd2/transaction.c                                                |   14 
 fs/xfs/kmem.h                                                        |    6 
 fs/xfs/libxfs/xfs_attr_leaf.c                                        |   17 
 fs/xfs/xfs_bmap_util.c                                               |    2 
 fs/xfs/xfs_buf.c                                                     |    8 
 fs/xfs/xfs_dquot.c                                                   |    9 
 include/linux/intel-iommu.h                                          |    1 
 include/linux/kgdb.h                                                 |    2 
 include/linux/mmzone.h                                               |    2 
 include/linux/pci_ids.h                                              |    7 
 include/linux/property.h                                             |    1 
 include/linux/sched/mm.h                                             |    2 
 include/linux/skbuff.h                                               |    8 
 include/linux/skmsg.h                                                |    8 
 include/linux/string.h                                               |   60 +-
 include/linux/sunrpc/gss_api.h                                       |    1 
 include/linux/sunrpc/svcauth_gss.h                                   |    3 
 include/net/bluetooth/hci.h                                          |    9 
 include/net/tls.h                                                    |    9 
 include/trace/events/btrfs.h                                         |    1 
 include/uapi/linux/bpf.h                                             |    8 
 include/uapi/linux/kvm.h                                             |    2 
 kernel/audit.c                                                       |   52 +-
 kernel/audit.h                                                       |    2 
 kernel/auditfilter.c                                                 |   16 
 kernel/bpf/syscall.c                                                 |    3 
 kernel/cpu.c                                                         |   18 
 kernel/cpu_pm.c                                                      |    4 
 kernel/debug/debug_core.c                                            |    5 
 kernel/exit.c                                                        |   25 -
 kernel/sched/core.c                                                  |   13 
 kernel/sched/fair.c                                                  |    4 
 kernel/sched/rt.c                                                    |   12 
 kernel/sched/sched.h                                                 |    2 
 kernel/time/clocksource.c                                            |    2 
 lib/Kconfig.ubsan                                                    |    2 
 lib/mpi/longlong.h                                                   |    2 
 lib/test_kasan.c                                                     |   29 -
 lib/test_printf.c                                                    |    4 
 mm/huge_memory.c                                                     |   31 +
 mm/page_alloc.c                                                      |   27 -
 net/batman-adv/bat_v_elp.c                                           |   15 
 net/bluetooth/hci_event.c                                            |    1 
 net/core/filter.c                                                    |    8 
 net/core/skmsg.c                                                     |   98 ++-
 net/netfilter/nft_nat.c                                              |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c                                |   12 
 net/sunrpc/auth_gss/svcauth_gss.c                                    |   18 
 net/tls/tls_sw.c                                                     |   20 
 scripts/sphinx-pre-install                                           |    7 
 security/integrity/evm/evm_crypto.c                                  |    2 
 security/integrity/ima/ima.h                                         |   10 
 security/integrity/ima/ima_crypto.c                                  |   53 +-
 security/integrity/ima/ima_init.c                                    |   24 
 security/integrity/ima/ima_main.c                                    |    3 
 security/integrity/ima/ima_policy.c                                  |   12 
 security/integrity/ima/ima_template_lib.c                            |   18 
 security/lockdown/lockdown.c                                         |    2 
 security/selinux/ss/policydb.c                                       |    1 
 tools/cgroup/iocost_monitor.py                                       |   42 -
 tools/include/uapi/linux/bpf.h                                       |    8 
 tools/lib/api/fs/fs.c                                                |   17 
 tools/lib/api/fs/fs.h                                                |   12 
 tools/lib/bpf/hashmap.c                                              |    7 
 tools/lib/bpf/libbpf.c                                               |  236 +++++----
 tools/lib/perf/evlist.c                                              |    1 
 tools/objtool/check.c                                                |    6 
 tools/perf/builtin-probe.c                                           |    3 
 tools/perf/util/dso.c                                                |   16 
 tools/perf/util/dso.h                                                |    1 
 tools/perf/util/probe-event.c                                        |   46 +
 tools/perf/util/probe-finder.c                                       |    1 
 tools/perf/util/symbol.c                                             |    4 
 tools/power/x86/intel-speed-select/isst-config.c                     |    1 
 tools/testing/selftests/bpf/.gitignore                               |    2 
 tools/testing/selftests/bpf/Makefile                                 |    6 
 tools/testing/selftests/bpf/config                                   |    2 
 tools/testing/selftests/bpf/prog_tests/core_reloc.c                  |    2 
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c              |    1 
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c         |    5 
 tools/testing/selftests/bpf/test_align.c                             |   41 -
 tools/testing/selftests/bpf/test_progs.c                             |   21 
 399 files changed, 3999 insertions(+), 2004 deletions(-)

Adrian Hunter (2):
      perf symbols: Fix debuginfo search for Ubuntu
      perf symbols: Fix kernel maps for kcore and eBPF

Ahmed S. Darwish (1):
      block: nr_sects_write(): Disable preemption on seqcount write

Al Viro (2):
      sparc32: fix register window handling in genregs32_[gs]et()
      sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Alain Michaud (1):
      Bluetooth: Adding driver and quirk defs for multi-role LE

Alan Maguire (2):
      selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
      selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh

Alex Elder (1):
      net: ipa: do not clear interrupt in gsi_channel_start()

Alexander Duyck (1):
      virtio-balloon: Disable free page reporting if page poison reporting is not enabled

Alexander Monakov (3):
      x86/amd_nb: Add AMD family 17h model 60h PCI IDs
      hwmon: (k10temp) Add AMD family 17h model 60h PCI match
      EDAC/amd64: Add AMD family 17h model 60h PCI IDs

Alexander Sverdlin (1):
      macvlan: Skip loopback packets in RX handler

Alvin Lee (1):
      drm/amd/display: Revert to old formula in set_vtg_params

Anand Jain (2):
      btrfs: free alien device after device add
      btrfs: include non-missing as a qualifier for the latest_bdev

Anders Roxell (1):
      power: vexpress: add suppress_bind_attrs to true

Andre Guedes (1):
      igc: Fix default MAC address filter override

Andrea Arcangeli (1):
      mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Always handle the VMBus messages on CPU0

Andrii Nakryiko (9):
      libbpf: Fix memory leak and possible double-free in hashmap__clear
      libbpf: Refactor map creation logic and fix cleanup leak
      selftests/bpf: Ensure test flavors use correct skeletons
      selftests/bpf: Fix memory leak in test selector
      selftests/bpf: Fix memory leak in extract_build_id()
      selftests/bpf: Fix invalid memory reads in core_relo selftest
      libbpf: Fix huge memory leak in libbpf_find_vmlinux_btf_id()
      selftests/bpf: Fix bpf_link leak in ns_current_pid_tgid selftest
      selftests/bpf: Add runqslower binary to .gitignore

Andy Shevchenko (4):
      spi: dw: Zero DMA Tx and Rx configurations on stack
      spi: Respect DataBitLength field of SpiSerialBusV2() ACPI resource
      stmmac: intel: Fix clock handling on error and remove paths
      platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()

Angelo Dureghello (2):
      mmc: sdhci: add quirks for be to le byte swapping
      spi: spi-fsl-dspi: fix native data copy

Ansuel Smith (1):
      cpufreq: qcom: fix wrong compatible binding

Anton Protopopov (1):
      bpf: Fix map permissions check

Anup Patel (3):
      irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()
      irqchip/sifive-plic: Setup cpuhp once after boot CPU handler is present
      RISC-V: Don't mark init section as non-executable

Ard Biesheuvel (3):
      ACPI: GED: use correct trigger type field in _Exx / _Lxx handling
      efi/libstub/x86: Work around LLVM ELF quirk build regression
      efi/libstub/random: Align allocate size to EFI_ALLOC_ALIGN

Arnd Bergmann (5):
      crypto: ccp -- don't "select" CONFIG_DMADEVICES
      drm/bridge: fix stack usage warning on old gcc
      dsa: sja1105: dynamically allocate stats structure
      nvme-fc: avoid gcc-10 zero-length-bounds warning
      crypto: blake2b - Fix clang optimization for ARMv7-M

Arthur Kiyanovski (1):
      net: ena: fix error returning in ena_com_get_hash_function()

Arvind Sankar (2):
      x86/boot: Correct relocation destination on old linkers
      x86/mm: Stop printing BRK addresses

Ashok Raj (2):
      PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints
      PCI: Program MPS for RCiEP devices

Ayush Sawal (1):
      Crypto/chcr: Fixes a coccinile check error

Ben Hutchings (1):
      MIPS: Fix exception handler memcpy()

Bernard Zhao (1):
      memory: samsung: exynos5422-dmc: Fix tFAW timings alignment

Bhupesh Sharma (1):
      net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Bingbu Cao (2):
      media: staging: imgu: do not hold spinlock during freeing mmu page table
      media: staging/intel-ipu3: Implement lock for stream on/off operations

Bjorn Andersson (1):
      regulator: qcom-rpmh: Fix typos in pm8150 and pm8150l

Bogdan Togorean (1):
      drm: bridge: adv7511: Extend list of audio sample rates

Boris Brezillon (1):
      mtd: rawnand: Fix nand_gpio_waitrdy()

Brad Love (1):
      media: si2157: Better check for running tuner in init

Brett Creeley (1):
      ice: Fix Tx timeout when link is toggled on a VF's interface

Brian Foster (3):
      xfs: reset buffer write failure state on successful completion
      xfs: fix duplicate verification from xfs_qm_dqflush()
      xfs: don't fail verifier on empty attr3 leaf block

Chris Chiu (1):
      platform/x86: asus_wmi: Reserve more space for struct bias_args

Christian König (1):
      drm/amdgpu: fix and cleanup amdgpu_gem_object_close v4

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christoph Hellwig (4):
      x86: fix vmap arguments in map_irq_stack
      staging: android: ion: use vmap instead of vm_map_ram
      bcache: remove a duplicate ->make_request_fn assignment
      nvme: refine the Qemu Identify CNS quirk

Christophe JAILLET (3):
      ath11k: Fix some resource leaks in error path in 'ath11k_thermal_register()'
      media: sun8i: Fix an error handling path in 'deinterlace_runtime_resume()'
      wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Christophe Leroy (5):
      powerpc/mm: Fix conditions to perform MMU specific management by blocks on PPC32.
      powerpc/32s: Fix another build failure with CONFIG_PPC_KUAP_DEBUG
      powerpc/kasan: Fix issues by lowering KASAN_SHADOW_END
      powerpc/kasan: Fix shadow pages allocation failure
      powerpc/32: Disable KASAN with pages bigger than 16k

Chuhong Yuan (1):
      Bluetooth: btmtkuart: Improve exception handling in btmtuart_probe()

Chung-Hsien Hsu (1):
      brcmfmac: fix WPA/WPA2-PSK 4-way handshake offload and SAE offload failures

Colin Ian King (3):
      ath11k: fix error message to correctly report the command that failed
      media: dvb: return -EREMOTEIO on i2c transfer failure.
      libertas_tf: avoid a null dereference in pointer priv

Coly Li (2):
      raid5: remove gfp flags from scribble_alloc()
      bcache: fix refcount underflow in bcache_device_free()

Corentin Labbe (1):
      soc/tegra: pmc: Select GENERIC_PINCONF

Dafna Hirschfeld (1):
      media: i2c: imx219: Fix a bug in imx219_enum_frame_size

Dale Zhao (1):
      drm/amd/display: Correct updating logic of dcn21's pipe VM flags

Dan Carpenter (3):
      media: vicodec: Fix error codes in probe function
      media: cec: silence shift wrapping warning in __cec_s_log_addrs()
      rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Daniel Axtens (2):
      kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE
      string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Daniel Borkmann (1):
      bpf: Fix up bpf_skb_adjust_room helper's skb csum setting

Daniel Jordan (1):
      mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init

Daniel Thompson (2):
      arm64: cacheflush: Fix KGDB trap detection
      kgdb: Fix spurious true from in_dbg_master()

Darrick J. Wong (2):
      xfs: more lockdep whackamole with kmem_alloc*
      xfs: clean up the error handling in xfs_swap_extents

Dejin Zheng (1):
      rtw88: fix an issue about leak system resources

Devulapally Shiva Krishna (2):
      Crypto/chcr: fix ctr, cbc, xts and rfc3686-ctr failed tests
      Crypto/chcr: fix for ccm(aes) failed test

Dmitry Osipenko (1):
      ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Dmytro Laktyushkin (1):
      drm/amd/display: fix virtual signal dsc setup

Doug Berger (2):
      net: bcmgenet: set Rx mode before starting netif
      net: bcmgenet: Fix WoL with password after deep sleep

Douglas Anderson (4):
      kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb
      kgdb: Prevent infinite recursive entries to the debugger
      kgdboc: Use a platform device to handle tty drivers showing up late
      kernel/cpu_pm: Fix uninitted local in cpu_pm

Eelco Chaudron (1):
      libbpf: Fix perf_buffer__free() API for sparse allocs

Enric Balletbo i Serra (1):
      drm/bridge: panel: Return always an error pointer in drm_panel_bridge_add()

Erez Shitrit (1):
      net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Eric Biggers (3):
      ext4: fix race between ext4_sync_parent() and rename()
      dm crypt: avoid truncating the logical block size
      f2fs: don't leak filename in f2fs_try_convert_inline_dir()

Eric Joyner (1):
      ice: Fix resource leak on early exit from function

Erik Kaneda (1):
      ACPICA: Dispatcher: add status checks

Evan Green (1):
      spi: pxa2xx: Apply CS clk quirk to BXT

Felix Kuehling (1):
      drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode

Filipe Manana (6):
      btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
      btrfs: fix a race between scrub and block group removal/allocation
      btrfs: fix corrupt log due to concurrent fsync of inodes with shared extents
      btrfs: fix wrong file range cleanup after an error filling dealloc range
      btrfs: fix space_info bytes_may_use underflow after nocow buffered write
      btrfs: fix space_info bytes_may_use underflow during space cache writeout

Finn Thain (1):
      m68k: mac: Don't call via_flush_cache() on Mac IIfx

Gavin Shan (1):
      arm64/kernel: Fix range on invalidating dcache for boot page tables

Geert Uytterhoeven (1):
      spi: spi-mem: Fix Dual/Quad modes on Octal-capable devices

Greg Kroah-Hartman (2):
      software node: implement software_node_unregister()
      Linux 5.7.5

Guoqing Jiang (1):
      md: don't flush workqueue unconditionally in md_open

H. Nikolaus Schaller (3):
      w1: omap-hdq: cleanup to add missing newline for some dev_dbg
      w1: omap-hdq: fix return value to be -1 if there is a timeout
      w1: omap-hdq: fix interrupt handling which did show spurious timeouts

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Hans Verkuil (1):
      media: v4l2-ctrls: v4l2_ctrl_g/s_ctrl*(): don't continue when WARN_ON

Hans de Goede (7):
      Bluetooth: btbcm: Add 2 missing models to subver tables
      platform/x86: intel-vbtn: Use acpi_evaluate_integer()
      platform/x86: intel-vbtn: Split keymap into buttons and switches parts
      platform/x86: intel-vbtn: Do not advertise switches to userspace if they are not there
      platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types
      platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type
      pwm: lpss: Fix get_state runtime-pm reference handling

Hari Bathini (3):
      powerpc/fadump: use static allocation for reserved memory ranges
      powerpc/fadump: consider reserved ranges while reserving memory
      powerpc/fadump: Account for memory_limit while reserving memory

Harshad Shirwadkar (1):
      ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Huaixin Chang (2):
      sched/fair: Refill bandwidth before scaling
      sched: Defend cfs and rt bandwidth quota against overflow

Ian Rogers (1):
      libperf evlist: Fix a refcount leak

Ilya Leoshkevich (1):
      s390/bpf: Maintain 8-byte stack alignment

Ioana Ciornei (1):
      soc: fsl: dpio: properly compute the consumer index

Jacob Keller (1):
      ice: fix potential double free in probe unrolling

Jaegeuk Kim (1):
      f2fs: fix checkpoint=disable:%u%%

Jaehoon Chung (1):
      brcmfmac: fix wrong location to get firmware feature

Jakub Sitnicki (1):
      selftests/bpf, flow_dissector: Close TAP device FD after the test

Jan Kara (1):
      jbd2: avoid leaking transaction credits when unreserving handle

Jann Horn (1):
      exit: Move preemption fixup up, move blocking operations down

Jean-Philippe Brucker (1):
      pmu/smmuv3: Clear IRQ affinity hint on device removal

Jeffle Xu (1):
      ext4: fix error pointer dereference

Jens Axboe (2):
      io_uring: cleanup io_poll_remove_one() logic
      io_uring: allow POLL_ADD with double poll_wait() users

Jeremy Cline (1):
      lockdown: Allow unprivileged users to see lockdown status

Jeremy Kerr (1):
      powerpc/spufs: fix copy_to_user while atomic

Jesper Dangaard Brouer (3):
      ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
      dpaa2-eth: fix return codes used in ndo_setup_tc
      veth: Adjust hard_start offset on redirect XDP frames

Jesse Brandeburg (2):
      ice: cleanup vf_id signedness
      ice: Fix inability to set channels when down

Jia-Ju Bai (1):
      net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jiaxun Yang (2):
      MIPS: Truncate link address into 32bit for 32bit kernel
      PCI: Don't disable decoding when mmio_always_on is set

Jitao Shi (2):
      dt-bindings: display: mediatek: control dpi pins mode to avoid leakage
      drm/mediatek: set dpi pin mode to gpio low to avoid leakage current

John Fastabend (2):
      bpf: Refactor sockmap redirect code so its easy to reuse
      bpf: Fix running sk_skb program types with ktls

Jon Derrick (2):
      iommu/vt-d: Only clear real DMA device's context entries
      iommu/vt-d: Allocate domain info for real DMA sub-devices

Jon Doron (1):
      x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Jonathan Bakker (3):
      pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210
      pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs
      ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries

Josef Bacik (3):
      btrfs: account for trans_block_rsv in may_commit_transaction
      btrfs: improve global reserve stealing logic
      btrfs: force chunk allocation if our global rsv is larger than metadata

Joshua Aberback (1):
      drm/amd/display: Force watermark value propagation

Julien Thierry (1):
      objtool: Ignore empty alternatives

Kai-Heng Feng (4):
      PCI: Avoid Pericom USB controller OHCI/EHCI PME# defect
      serial: 8250_pci: Move Pericom IDs to pci_ids.h
      e1000e: Disable TSO for buffer overrun workaround
      igb: Report speed and duplex as unknown when device is runtime suspended

Kaige Li (1):
      MIPS: tools: Fix resource leak in elf-entry.c

Kees Cook (2):
      ubsan: entirely disable alignment checks under UBSAN_TRAP
      e1000: Distribute switch variables for initialization

Kevin Buettner (1):
      PCI: Avoid FLR for AMD Starship USB 3.0

Kieran Bingham (1):
      media: platform: fcp: Set appropriate DMA parameters

Koba Ko (1):
      platform/x86: dell-laptop: don't register micmute LED if there is no token

Krzysztof Struczynski (3):
      ima: Fix ima digest hash table key calculation
      ima: Remove redundant policy rule set in add_rules()
      ima: Set again build_ima_appraise variable

Larry Finger (3):
      b43legacy: Fix case where channel status is corrupted
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Laurent Pinchart (1):
      media: imx: imx7-mipi-csis: Cleanup and fix subdev pad format handling

Lichao Liu (1):
      MIPS: CPU_LOONGSON2EF need software to maintain cache consistency

Linus Walleij (1):
      ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Lorenzo Bianconi (7):
      mt76: mt7615: fix aid configuration in mt7615_mcu_wtbl_generic_tlv
      mt76: mt7663: fix mt7615_mac_cca_stats_reset routine
      mt76: mt7615: do not always reset the dfs state setting the channel
      mt76: mt7622: fix DMA unmap length
      mt76: mt7663: fix DMA unmap length
      mt76: mt7615: fix mt7615_firmware_own for mt7663e
      mt76: mt7615: fix mt7615_driver_own routine

Ludovic Barre (1):
      mmc: mmci_sdmmc: fix power on issue due to pwr_reg initialization

Ludovic Desroches (1):
      ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin

Lukas Wunner (1):
      serial: 8250: Avoid error message on reprobe

Luke Nelson (2):
      arm64: insn: Fix two bugs in encoding 32-bit logical immediates
      bpf, riscv: Fix tail call count off by one in RV32 BPF JIT

Macpaul Lin (1):
      usb: musb: mediatek: add reset FADDR to zero in reset interrupt handle

Maharaja Kennadyrajan (1):
      ath10k: Fix the race condition in firmware dump work queue

Mansur Alisha Shaik (1):
      media: venus: core: remove CNOC voting while device suspend

Marcos Paulo de Souza (1):
      btrfs: send: emit file capabilities after chown

Marcos Scriven (1):
      PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0

Marek Szyprowski (1):
      ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensor's bus

Marek Vasut (1):
      mmc: mmci: Switch to mmc_regulator_set_vqmmc()

Mark Pearson (1):
      drm/dp: Lenovo X13 Yoga OLED panel brightness fix

Mark Starovoytov (1):
      net: atlantic: make hw_get_regs optional

Marta Plantykow (1):
      ice: Change number of XDP TxQ to 0 when destroying rings

Martin Blumenstingl (1):
      mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error

Masahiro Yamada (2):
      ARM: 8969/1: decompressor: simplify libfdt builds
      kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Masami Hiramatsu (3):
      perf probe: Do not show the skipped events
      perf probe: Fix to check blacklist address correctly
      perf probe: Check address correctness by map instead of _etext

Mauro Carvalho Chehab (1):
      scripts: sphinx-pre-install: address some issues with Gentoo

Michael Ellerman (4):
      clocksource/drivers/timer-microchip-pit64b: Select CONFIG_TIMER_OF
      drivers/macintosh: Fix memleak in windfarm_pm112 driver
      powerpc/64s: Don't let DT CPU features set FSCR_DSCR
      powerpc/64s: Save FSCR to init_task.thread.fscr after feature init

Michał Mirosław (3):
      Bluetooth: hci_bcm: respect IRQ polarity from DT
      Bluetooth: hci_bcm: fix freeing not-requested IRQ
      power: supply: core: fix HWMON temperature labels

Mikulas Patocka (1):
      alpha: fix memory barriers so that they conform to the specification

Ming Lei (1):
      block: alloc map and request for new hardware queue

Miquel Raynal (13):
      mtd: rawnand: onfi: Fix redundancy detection check
      mtd: rawnand: diskonchip: Fix the probe error path
      mtd: rawnand: sharpsl: Fix the probe error path
      mtd: rawnand: ingenic: Fix the probe error path
      mtd: rawnand: xway: Fix the probe error path
      mtd: rawnand: orion: Fix the probe error path
      mtd: rawnand: socrates: Fix the probe error path
      mtd: rawnand: oxnas: Fix the probe error path
      mtd: rawnand: sunxi: Fix the probe error path
      mtd: rawnand: plat_nand: Fix the probe error path
      mtd: rawnand: pasemi: Fix the probe error path
      mtd: rawnand: mtk: Fix the probe error path
      mtd: rawnand: tmio: Fix the probe error path

Mordechay Goodstein (1):
      iwlwifi: avoid debug max amsdu config overwriting itself

Nathan Chancellor (1):
      lib/mpi: Fix 64-bit MIPS build with Clang

NeilBrown (2):
      sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.
      sunrpc: clean up properly in gss_mech_unregister()

Nickolai Kozachenko (1):
      platform/x86: intel-hid: Add a quirk to support HP Spectre X2 (2015)

Nicolas Toromanoff (3):
      crypto: stm32/crc32 - fix ext4 chksum BUG_ON()
      crypto: stm32/crc32 - fix run-time self test issue.
      crypto: stm32/crc32 - fix multi-instance

Omar Sandoval (1):
      btrfs: fix error handling when submitting direct I/O bio

Pablo Neira Ayuso (1):
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Pali Rohár (1):
      mwifiex: Fix memory corruption in dump_station

Paul Cercueil (1):
      pwm: jz4740: Enhance precision in calculation of duty cycle

Paul Hsieh (1):
      drm/amd/display: dmcu wait loop calculation is incorrect in RV

Paul M Stillwell Jr (1):
      ice: fix PCI device serial number to be lowercase values

Paul Menzel (1):
      ACPI: video: Use native backlight on Acer TravelMate 5735Z

Paul Moore (2):
      audit: fix a net reference leak in audit_send_reply()
      audit: fix a net reference leak in audit_list_rules_send()

Pavel Begunkov (1):
      io_uring: fix overflowed reqs cancellation

Pavel Tatashin (2):
      mm: initialize deferred pages with interrupts enabled
      mm: call cond_resched() from deferred_init_memmap()

Peter Rosin (1):
      spi: mux: repair mux usage

Peter Zijlstra (2):
      x86,smap: Fix smap_{save,restore}() alternatives
      sched/core: Fix illegal RCU from offline CPUs

Philipp Zabel (2):
      media: imx: utils: fix and simplify pixel format enumeration
      media: imx: utils: fix media bus format enumeration

Prarit Bhargava (1):
      tools/power/x86/intel-speed-select: Fix CLX-N package information output

Punit Agrawal (1):
      e1000e: Relax condition to trigger reset for ME workaround

Qiushi Wu (2):
      cpuidle: Fix three reference count leaks
      power: supply: core: fix memory leak in HWMON error path

Qu Wenruo (2):
      btrfs: qgroup: mark qgroup inconsistent if we're inherting snapshot to a new qgroup
      btrfs: reloc: fix reloc root leak and NULL pointer dereference

Rakesh Pillai (2):
      ath10k: Skip handling del_server during driver exit
      ath10k: Remove msdu from idr when management pkt send fails

Roberto Sassu (6):
      ima: Switch to ima_hash_algo for boot aggregate
      ima: Evaluate error in init_ima()
      ima: Directly assign the ima_default_policy pointer to ima_rules
      ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()
      ima: Remove __init annotation from ima_pcrread()
      evm: Fix possible memory leak in evm_calc_hmac_or_hash()

Roi Dayan (1):
      net/mlx5e: CT: Avoid false warning about rule may be used uninitialized

Ryder Lee (1):
      mt76: avoid rx reorder buffer overflow

Sagi Grimberg (2):
      nvme-tcp: use bh_lock in data_ready
      nvmet: fix memory leak when removing namespaces and controllers concurrently

Samuel Holland (1):
      media: cedrus: Program output format during each run

Saravana Kannan (1):
      clocksource/drivers/timer-versatile: Clear OF_POPULATED flag

Sean Young (1):
      media: m88ds3103: error in set_frontend is swallowed and not reported

Serge Semin (9):
      mips: Fix cpu_has_mips64r1/2 activation for MIPS32 CPUs
      spi: dw: Enable interrupts in accordance with DMA xfer mode
      clocksource: dw_apb_timer: Make CPU-affiliation being optional
      clocksource: dw_apb_timer_of: Fix missing clockevent timers
      spi: dw: Fix Rx-only DMA transfers
      mips: cm: Fix an invalid error code of INTVN_*_ERR
      mips: MAAR: Use more precise address mask
      mips: Add udelay lpj numbers adjustment
      spi: dw: Return any value retrieved from the dma_transfer callback

Shaokun Zhang (1):
      drivers/perf: hisi: Fix typo in events attribute array

Sharon (1):
      iwlwifi: mvm: fix aux station leak

Sriram R (1):
      ath11k: Avoid mgmt tx count underflow

Stanislav Fomichev (1):
      selftests/bpf: Fix test_align verifier log patterns

Stephane Eranian (1):
      tools api fs: Make xxx__mountpoint() more scalable

Sung Lee (1):
      drm/amd/display: Do not disable pipe split if mode is not supported

Surabhi Boob (2):
      ice: Fix memory leak
      ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS

Sven Eckelmann (1):
      batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Tamizh Chelvam (1):
      ath11k: fix kernel panic by freeing the msdu received with invalid length

Tejun Heo (2):
      iocost_monitor: drop string wrap around numbers when outputting json
      iocost: don't let vrate run wild while there's no saturation signal

Thomas Gleixner (1):
      clocksource: Remove obsolete ifdef

Thomas Zimmermann (1):
      drm/ast: Allocate initial CRTC state of the correct size

Tian Tao (1):
      drm/hisilicon: Enforce 128-byte stride alignment to fix the hardware limitation

Tiezhu Yang (2):
      MIPS: Loongson: Build ATI Radeon GPU driver as module
      MIPS: Make sparse_init() using top-down allocation

Tomasz Figa (1):
      media: staging: ipu3: Fix stale list entries on parameter queue failure

Tomi Valkeinen (1):
      media: ov5640: fix use of destroyed mutex

Tomohito Esaki (1):
      drm: rcar-du: Set primary plane zpos immutably at initializing

Tuan Phan (1):
      ACPI/IORT: Fix PMCG node single ID mapping handling

Ulf Hansson (4):
      cpuidle: psci: Fixup execution order when entering a domain idle state
      staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core
      mmc: owl-mmc: Respect the cmd->busy_timeout from the mmc core
      mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

Venkateswara Naralasetty (1):
      ath10k: fix kernel null pointer dereference

Veronika Kabatova (1):
      selftests/bpf: Copy runqslower to OUTPUT directory

Vladimir Oltean (1):
      net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules

Wei Yongjun (11):
      net: ethernet: ti: fix return value check in k3_cppi_desc_pool_create_name()
      ath11k: use GFP_ATOMIC under spin lock
      octeontx2-pf: Fix error return code in otx2_probe()
      ice: Fix error return code in ice_add_prof()
      net: lpc-enet: fix error return code in lpc_mii_init()
      selinux: fix error return code in policydb_read()
      drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()
      ath10k: fix possible memory leak in ath10k_bmi_lz_data_large()
      ath11k: fix error return code in ath11k_dp_alloc()
      drm/mcde: dsi: Fix return value check in mcde_dsi_bind()
      gnss: sirf: fix error return code in sirf_probe()

Weiping Zhang (3):
      block: reset mapping if failed to update hardware queue count
      nvme-pci: align io queue count with allocted nvme_queue in nvme_probe
      nvme-pci: make sure write/poll_queues less or equal then cpu count

Weiyi Lu (1):
      clk: mediatek: assign the initial value to clk_init_data of mtk_mux

Wen Gong (2):
      ath10k: remove the max_sched_scan_reqs value
      ath10k: add flush tx packets for SDIO chip

Xie XiuQi (1):
      ixgbe: fix signed-integer-overflow warning

Xiyu Yang (1):
      ext4: fix buffer_head refcnt leak when ext4_iget() fails

Yauheni Kaliuta (1):
      selftests/bpf: Install generated test progs

YuanJunQing (1):
      MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Yunjian Wang (1):
      net: allwinner: Fix use correct return type for ndo_start_xmit()

Zijun Hu (1):
      Bluetooth: hci_qca: Fix suspend/resume functionality failure

Zou Wei (1):
      net/mlx4_core: Add missing iounmap() in error path

chen gong (1):
      drm/amd/powerpay: Disable gfxoff when setting manual mode on picasso and raven

limingyu (1):
      drm/amdgpu: Init data to avoid oops while reading pp_num_states.

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix hamming oob layout

Łukasz Stelmach (1):
      arm64: kexec_file: print appropriate variable

