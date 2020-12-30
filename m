Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D232E781F
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL3Ler (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 06:34:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgL3Ler (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 06:34:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EC7B2220B;
        Wed, 30 Dec 2020 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609328044;
        bh=C03N4ujz1u9a3lKM/aP2S3k+xh3ZLqWtsx5upNj2Cg0=;
        h=From:To:Cc:Subject:Date:From;
        b=NkjCh+/OK5gXlK3G1CcXpecF/zilKf7frmakUgVPvqvHbCwaEMJDYRFGR3VGgVEg7
         ZiVRUtYNKIW/Wo3vj32p017YZwx8f3kFrSieDm7Q2vMj45ULlbOez3a+QQad7OHESj
         TXRc1DACSGE+bsZtGUBLwVtiD/TYTebmJUoxROFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.86
Date:   Wed, 30 Dec 2020 12:35:25 +0100
Message-Id: <160932812517565@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.86 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/x86/topology.rst                            |    9 +
 Makefile                                                  |    2 
 arch/Kconfig                                              |   16 +
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi                 |    5 
 arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts       |    5 
 arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts            |    4 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts               |    7 
 arch/arm/boot/dts/at91-sama5d4_xplained.dts               |    7 
 arch/arm/boot/dts/at91sam9rl.dtsi                         |   19 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts                 |    6 
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi                 |   28 +++
 arch/arm/boot/dts/exynos5410.dtsi                         |    4 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi             |    2 
 arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi            |    1 
 arch/arm/boot/dts/meson8b-odroidc1.dts                    |    2 
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts                 |    2 
 arch/arm/boot/dts/omap4-panda-es.dts                      |    2 
 arch/arm/boot/dts/sama5d2.dtsi                            |    7 
 arch/arm/boot/dts/sun7i-a20-bananapi.dts                  |    2 
 arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts             |    4 
 arch/arm/boot/dts/sun8i-v3s.dtsi                          |    2 
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts         |   12 -
 arch/arm/crypto/aes-ce-core.S                             |   32 ++-
 arch/arm/kernel/head.S                                    |    6 
 arch/arm/mach-sunxi/sunxi.c                               |    1 
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts        |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts      |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts       |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi      |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi         |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts      |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts     |    4 
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts       |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts            |    2 
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts        |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi                |    2 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                   |   12 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi            |    2 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts    |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                  |    4 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   31 ++-
 arch/arm64/boot/dts/renesas/cat875.dtsi                   |    1 
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi           |    1 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts            |    1 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                  |   16 -
 arch/arm64/include/asm/kvm_host.h                         |    1 
 arch/arm64/kernel/syscall.c                               |    2 
 arch/arm64/kvm/sys_regs.c                                 |    1 
 arch/mips/bcm47xx/Kconfig                                 |    1 
 arch/mips/kernel/setup.c                                  |    4 
 arch/powerpc/include/asm/book3s/32/pgtable.h              |    4 
 arch/powerpc/include/asm/cpm1.h                           |    1 
 arch/powerpc/include/asm/cputable.h                       |    7 
 arch/powerpc/include/asm/nohash/pgtable.h                 |    4 
 arch/powerpc/kernel/Makefile                              |    3 
 arch/powerpc/kernel/head_64.S                             |   10 -
 arch/powerpc/kernel/paca.c                                |    4 
 arch/powerpc/kernel/rtas.c                                |    2 
 arch/powerpc/kernel/setup-common.c                        |    4 
 arch/powerpc/kernel/setup.h                               |    6 
 arch/powerpc/kernel/setup_64.c                            |    2 
 arch/powerpc/mm/fault.c                                   |    8 
 arch/powerpc/mm/mem.c                                     |    2 
 arch/powerpc/perf/core-book3s.c                           |   13 +
 arch/powerpc/platforms/8xx/micropatch.c                   |   11 +
 arch/powerpc/platforms/powernv/memtrace.c                 |   44 ++++
 arch/powerpc/platforms/powernv/npu-dma.c                  |   16 +
 arch/powerpc/platforms/pseries/suspend.c                  |    4 
 arch/powerpc/xmon/nonstdio.c                              |    2 
 arch/s390/kernel/smp.c                                    |   18 --
 arch/s390/purgatory/head.S                                |    9 -
 arch/sparc/mm/init_64.c                                   |    2 
 arch/um/drivers/chan_user.c                               |    4 
 arch/um/drivers/xterm.c                                   |    5 
 arch/um/os-Linux/irq.c                                    |    2 
 arch/um/os-Linux/umid.c                                   |   17 -
 arch/x86/events/intel/core.c                              |    5 
 arch/x86/events/intel/ds.c                                |    2 
 arch/x86/include/asm/apic.h                               |    1 
 arch/x86/include/asm/cacheinfo.h                          |    4 
 arch/x86/kernel/apic/apic.c                               |   14 -
 arch/x86/kernel/apic/x2apic_phys.c                        |    9 +
 arch/x86/kernel/cpu/amd.c                                 |   11 -
 arch/x86/kernel/cpu/cacheinfo.c                           |    6 
 arch/x86/kernel/cpu/hygon.c                               |   11 -
 arch/x86/kernel/kprobes/core.c                            |    5 
 arch/x86/mm/ident_map.c                                   |   12 +
 block/blk-mq.c                                            |   37 ++--
 block/blk-zoned.c                                         |   40 +---
 crypto/af_alg.c                                           |   10 -
 crypto/ecdh.c                                             |    9 -
 drivers/acpi/acpi_pnp.c                                   |    3 
 drivers/acpi/device_pm.c                                  |   41 +---
 drivers/acpi/resource.c                                   |    2 
 drivers/android/binder.c                                  |    1 
 drivers/android/binder_alloc.c                            |   48 +++++
 drivers/android/binder_alloc.h                            |    4 
 drivers/block/xen-blkback/xenbus.c                        |    4 
 drivers/bluetooth/btmtksdio.c                             |    2 
 drivers/bluetooth/btusb.c                                 |    2 
 drivers/bluetooth/hci_h5.c                                |    3 
 drivers/bus/fsl-mc/fsl-mc-allocator.c                     |    4 
 drivers/bus/mips_cdmm.c                                   |    4 
 drivers/clk/at91/sam9x60.c                                |    6 
 drivers/clk/clk-s2mps11.c                                 |    1 
 drivers/clk/ingenic/cgu.c                                 |   14 +
 drivers/clk/meson/Kconfig                                 |    1 
 drivers/clk/mvebu/armada-37xx-xtal.c                      |    4 
 drivers/clk/renesas/r9a06g032-clocks.c                    |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                     |    1 
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                       |    1 
 drivers/clk/tegra/clk-dfll.c                              |    4 
 drivers/clk/tegra/clk-id.h                                |    1 
 drivers/clk/tegra/clk-tegra-periph.c                      |    2 
 drivers/clk/ti/fapll.c                                    |   11 +
 drivers/clocksource/arm_arch_timer.c                      |   27 ++-
 drivers/clocksource/timer-cadence-ttc.c                   |   18 +-
 drivers/clocksource/timer-orion.c                         |   11 -
 drivers/cpufreq/armada-8k-cpufreq.c                       |    6 
 drivers/cpufreq/highbank-cpufreq.c                        |    7 
 drivers/cpufreq/loongson1-cpufreq.c                       |    1 
 drivers/cpufreq/mediatek-cpufreq.c                        |    1 
 drivers/cpufreq/qcom-cpufreq-nvmem.c                      |    1 
 drivers/cpufreq/scpi-cpufreq.c                            |    1 
 drivers/cpufreq/sti-cpufreq.c                             |    7 
 drivers/cpufreq/sun50i-cpufreq-nvmem.c                    |    1 
 drivers/crypto/Kconfig                                    |    1 
 drivers/crypto/amcc/crypto4xx_core.c                      |    2 
 drivers/crypto/inside-secure/safexcel.c                   |    2 
 drivers/crypto/omap-aes.c                                 |    3 
 drivers/crypto/qat/qat_common/qat_hal.c                   |    2 
 drivers/crypto/talitos.c                                  |   10 -
 drivers/dax/super.c                                       |    1 
 drivers/dma-buf/dma-resv.c                                |    2 
 drivers/dma/mv_xor_v2.c                                   |    4 
 drivers/edac/amd64_edac.c                                 |   26 +-
 drivers/edac/i10nm_base.c                                 |   11 -
 drivers/edac/mce_amd.c                                    |    2 
 drivers/extcon/extcon-max77693.c                          |    2 
 drivers/gpio/gpio-eic-sprd.c                              |    9 -
 drivers/gpio/gpio-mvebu.c                                 |   16 +
 drivers/gpio/gpio-zynq.c                                  |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                  |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |    3 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c |   13 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c             |    8 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c          |    4 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c   |    2 
 drivers/gpu/drm/aspeed/Kconfig                            |    1 
 drivers/gpu/drm/drm_dp_aux_dev.c                          |    2 
 drivers/gpu/drm/gma500/cdv_intel_dp.c                     |    2 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c            |    2 
 drivers/gpu/drm/mcde/mcde_drv.c                           |    4 
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.c                   |    5 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c                |    8 
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c                  |    1 
 drivers/gpu/drm/tegra/drm.c                               |    2 
 drivers/gpu/drm/tegra/sor.c                               |   10 -
 drivers/gpu/drm/tve200/tve200_drv.c                       |    4 
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                  |    8 
 drivers/hsi/controllers/omap_ssi_core.c                   |    2 
 drivers/hwmon/ina3221.c                                   |    2 
 drivers/hwtracing/coresight/coresight-etb10.c             |    4 
 drivers/hwtracing/coresight/coresight-priv.h              |    2 
 drivers/hwtracing/coresight/coresight-tmc-etf.c           |    4 
 drivers/hwtracing/coresight/coresight-tmc-etr.c           |    4 
 drivers/i2c/busses/i2c-qcom-geni.c                        |    6 
 drivers/iio/adc/rockchip_saradc.c                         |    2 
 drivers/iio/adc/ti-ads124s08.c                            |   13 +
 drivers/iio/imu/bmi160/bmi160_core.c                      |    4 
 drivers/iio/industrialio-buffer.c                         |    6 
 drivers/iio/light/rpr0521.c                               |   17 +
 drivers/iio/light/st_uvis25.h                             |    5 
 drivers/iio/light/st_uvis25_core.c                        |    8 
 drivers/iio/magnetometer/mag3110.c                        |   13 +
 drivers/iio/pressure/mpl3115.c                            |    9 -
 drivers/iio/trigger/iio-trig-hrtimer.c                    |    4 
 drivers/infiniband/core/cm.c                              |    2 
 drivers/infiniband/core/cma.c                             |    7 
 drivers/infiniband/core/device.c                          |    7 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                  |    1 
 drivers/infiniband/hw/cxgb4/cq.c                          |    3 
 drivers/infiniband/hw/mthca/mthca_cq.c                    |    2 
 drivers/infiniband/hw/mthca/mthca_dev.h                   |    1 
 drivers/infiniband/sw/rxe/rxe_req.c                       |    3 
 drivers/input/keyboard/cros_ec_keyb.c                     |    1 
 drivers/input/keyboard/omap4-keypad.c                     |   89 +++++----
 drivers/input/mouse/cyapa_gen6.c                          |    2 
 drivers/input/touchscreen/ads7846.c                       |   52 +++--
 drivers/input/touchscreen/goodix.c                        |   12 +
 drivers/irqchip/irq-alpine-msi.c                          |    3 
 drivers/md/dm-ioctl.c                                     |    1 
 drivers/md/dm-table.c                                     |    6 
 drivers/md/md-cluster.c                                   |   67 ++++---
 drivers/md/md.c                                           |   21 +-
 drivers/media/common/siano/smsdvb-main.c                  |    5 
 drivers/media/i2c/imx214.c                                |    2 
 drivers/media/i2c/max2175.c                               |    2 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                  |   62 +++---
 drivers/media/pci/intel/ipu3/ipu3-cio2.h                  |    1 
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c         |    5 
 drivers/media/pci/saa7146/mxb.c                           |   19 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c                |    2 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c     |   19 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c     |   26 ++
 drivers/media/rc/sunxi-cir.c                              |    2 
 drivers/media/usb/gspca/gspca.c                           |    1 
 drivers/media/usb/msi2500/msi2500.c                       |    2 
 drivers/media/usb/tm6000/tm6000-video.c                   |    5 
 drivers/media/v4l2-core/v4l2-fwnode.c                     |    6 
 drivers/memstick/core/memstick.c                          |    1 
 drivers/memstick/host/r592.c                              |   12 -
 drivers/misc/habanalabs/device.c                          |   16 -
 drivers/mmc/host/pxamci.c                                 |    1 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                |   38 +++-
 drivers/mtd/nand/raw/meson_nand.c                         |    7 
 drivers/mtd/nand/raw/qcom_nandc.c                         |    2 
 drivers/mtd/nand/spi/core.c                               |    4 
 drivers/mtd/parsers/cmdlinepart.c                         |   14 +
 drivers/net/can/m_can/m_can.c                             |    4 
 drivers/net/can/softing/softing_main.c                    |    9 -
 drivers/net/ethernet/allwinner/sun4i-emac.c               |    7 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c            |    4 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c               |   46 +++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                |   18 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             |   24 +-
 drivers/net/ethernet/korina.c                             |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c           |   29 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c            |    6 
 drivers/net/ethernet/microchip/lan743x_main.c             |   43 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c          |    1 
 drivers/net/virtio_net.c                                  |    1 
 drivers/net/vxlan.c                                       |    3 
 drivers/net/wireless/ath/ath10k/usb.c                     |    7 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                 |    4 
 drivers/net/wireless/ath/ath10k/wmi.c                     |    9 -
 drivers/net/wireless/ath/ath10k/wmi.h                     |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |    1 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |    6 
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             |    1 
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c       |   14 -
 drivers/net/wireless/marvell/mwifiex/main.c               |    2 
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c        |    6 
 drivers/net/wireless/rsi/rsi_91x_usb.c                    |   30 +--
 drivers/net/wireless/st/cw1200/main.c                     |    2 
 drivers/net/xen-netback/xenbus.c                          |    6 
 drivers/nfc/s3fwrn5/firmware.c                            |    4 
 drivers/nvdimm/label.c                                    |   13 +
 drivers/pci/controller/pcie-iproc.c                       |   10 -
 drivers/pci/pci-acpi.c                                    |    4 
 drivers/pci/pci.c                                         |   14 -
 drivers/pci/slot.c                                        |    6 
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                  |    6 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                   |   74 +++++++-
 drivers/pinctrl/aspeed/pinmux-aspeed.h                    |    7 
 drivers/pinctrl/intel/pinctrl-baytrail.c                  |    8 
 drivers/pinctrl/intel/pinctrl-merrifield.c                |    8 
 drivers/pinctrl/pinctrl-falcon.c                          |   14 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                     |    6 
 drivers/platform/chrome/cros_ec_spi.c                     |    1 
 drivers/platform/x86/dell-smbios-base.c                   |    1 
 drivers/platform/x86/intel-vbtn.c                         |    6 
 drivers/platform/x86/mlx-platform.c                       |   27 ---
 drivers/power/supply/axp288_charger.c                     |   28 +--
 drivers/power/supply/bq24190_charger.c                    |   20 +-
 drivers/ps3/ps3stor_lib.c                                 |    2 
 drivers/pwm/pwm-lp3943.c                                  |    1 
 drivers/pwm/pwm-zx.c                                      |    1 
 drivers/regulator/axp20x-regulator.c                      |    2 
 drivers/remoteproc/qcom_q6v5_adsp.c                       |   13 -
 drivers/remoteproc/qcom_q6v5_mss.c                        |    5 
 drivers/rtc/rtc-ep93xx.c                                  |    6 
 drivers/rtc/rtc-pcf2127.c                                 |   12 -
 drivers/s390/block/dasd_alias.c                           |   22 ++
 drivers/s390/cio/device.c                                 |    4 
 drivers/scsi/bnx2i/Kconfig                                |    1 
 drivers/scsi/fnic/fnic_main.c                             |    1 
 drivers/scsi/lpfc/lpfc_mem.c                              |    6 
 drivers/scsi/lpfc/lpfc_sli.c                              |   10 -
 drivers/scsi/megaraid/megaraid_sas_base.c                 |   16 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                       |    2 
 drivers/scsi/pm8001/pm8001_init.c                         |    3 
 drivers/scsi/qedi/qedi_main.c                             |    4 
 drivers/scsi/qla2xxx/qla_tmpl.c                           |    9 -
 drivers/scsi/qla2xxx/qla_tmpl.h                           |    2 
 drivers/scsi/scsi_lib.c                                   |  126 +++++++++-----
 drivers/slimbus/qcom-ngd-ctrl.c                           |    6 
 drivers/soc/amlogic/meson-canvas.c                        |    4 
 drivers/soc/mediatek/mtk-scpsys.c                         |    5 
 drivers/soc/qcom/qcom-geni-se.c                           |   17 +
 drivers/soc/qcom/smp2p.c                                  |    5 
 drivers/soc/renesas/rmobile-sysc.c                        |    1 
 drivers/soc/tegra/fuse/speedo-tegra210.c                  |    2 
 drivers/soc/ti/knav_dma.c                                 |   13 +
 drivers/soc/ti/knav_qmss_queue.c                          |    4 
 drivers/spi/atmel-quadspi.c                               |   27 +--
 drivers/spi/spi-bcm63xx-hsspi.c                           |    4 
 drivers/spi/spi-davinci.c                                 |    2 
 drivers/spi/spi-fsl-spi.c                                 |   11 -
 drivers/spi/spi-gpio.c                                    |   15 -
 drivers/spi/spi-img-spfi.c                                |    4 
 drivers/spi/spi-mem.c                                     |    1 
 drivers/spi/spi-mt7621.c                                  |   11 +
 drivers/spi/spi-mxic.c                                    |   10 -
 drivers/spi/spi-mxs.c                                     |    1 
 drivers/spi/spi-pic32.c                                   |    1 
 drivers/spi/spi-pxa2xx.c                                  |    5 
 drivers/spi/spi-rb4xx.c                                   |    2 
 drivers/spi/spi-sc18is602.c                               |   13 -
 drivers/spi/spi-sh.c                                      |   13 -
 drivers/spi/spi-sprd.c                                    |    1 
 drivers/spi/spi-st-ssc4.c                                 |    5 
 drivers/spi/spi-stm32.c                                   |    1 
 drivers/spi/spi-synquacer.c                               |   15 -
 drivers/spi/spi-tegra114.c                                |    2 
 drivers/spi/spi-tegra20-sflash.c                          |    1 
 drivers/spi/spi-tegra20-slink.c                           |    2 
 drivers/spi/spi-ti-qspi.c                                 |    1 
 drivers/spi/spi.c                                         |   19 +-
 drivers/staging/comedi/drivers/mf6x4.c                    |    3 
 drivers/staging/gasket/gasket_interrupt.c                 |   15 +
 drivers/staging/greybus/audio_codec.c                     |    2 
 drivers/staging/speakup/speakup_dectlk.c                  |    2 
 drivers/tty/serial/serial_core.c                          |    4 
 drivers/usb/chipidea/ci_hdrc_imx.c                        |    3 
 drivers/usb/gadget/function/f_acm.c                       |    2 
 drivers/usb/gadget/function/f_fs.c                        |    5 
 drivers/usb/gadget/function/f_midi.c                      |    6 
 drivers/usb/gadget/function/f_rndis.c                     |    4 
 drivers/usb/host/ehci-omap.c                              |    1 
 drivers/usb/host/max3421-hcd.c                            |    3 
 drivers/usb/host/oxu210hp-hcd.c                           |    4 
 drivers/usb/mtu3/mtu3_debugfs.c                           |    2 
 drivers/usb/serial/digi_acceleport.c                      |   45 +----
 drivers/usb/serial/keyspan_pda.c                          |   63 +++----
 drivers/usb/serial/mos7720.c                              |    2 
 drivers/usb/serial/option.c                               |   23 ++
 drivers/vfio/pci/vfio_pci.c                               |    4 
 drivers/vfio/pci/vfio_pci_nvlink2.c                       |    7 
 drivers/video/fbdev/atmel_lcdfb.c                         |    2 
 drivers/virtio/virtio_ring.c                              |    8 
 drivers/watchdog/Kconfig                                  |    4 
 drivers/watchdog/qcom-wdt.c                               |    2 
 drivers/watchdog/sprd_wdt.c                               |   34 +--
 drivers/watchdog/watchdog_core.c                          |   22 +-
 drivers/xen/xen-pciback/xenbus.c                          |    2 
 drivers/xen/xenbus/xenbus.h                               |    2 
 drivers/xen/xenbus/xenbus_client.c                        |    8 
 drivers/xen/xenbus/xenbus_probe.c                         |    1 
 drivers/xen/xenbus/xenbus_probe_backend.c                 |    7 
 drivers/xen/xenbus/xenbus_xs.c                            |   34 ++-
 fs/afs/super.c                                            |    3 
 fs/btrfs/extent-tree.c                                    |   22 ++
 fs/btrfs/extent_io.h                                      |    2 
 fs/btrfs/volumes.c                                        |    4 
 fs/ceph/caps.c                                            |   11 +
 fs/cifs/smb2ops.c                                         |    3 
 fs/erofs/data.c                                           |   26 --
 fs/ext4/inode.c                                           |   19 +-
 fs/ext4/mballoc.c                                         |    1 
 fs/f2fs/node.c                                            |    2 
 fs/jffs2/readinode.c                                      |   16 +
 fs/jffs2/super.c                                          |   17 +
 fs/jfs/jfs_dmap.h                                         |    2 
 fs/lockd/host.c                                           |   20 +-
 fs/nfs/inode.c                                            |    2 
 fs/nfs/nfs4proc.c                                         |   10 -
 fs/nfs/nfs4xdr.c                                          |   10 -
 fs/nfs_common/grace.c                                     |    6 
 fs/nfsd/nfssvc.c                                          |    3 
 fs/quota/quota_v2.c                                       |   19 ++
 fs/ubifs/auth.c                                           |    4 
 fs/ubifs/io.c                                             |   13 +
 include/acpi/acpi_bus.h                                   |    5 
 include/linux/netfilter/x_tables.h                        |    5 
 include/linux/pm_runtime.h                                |   21 ++
 include/linux/prefetch.h                                  |    8 
 include/linux/security.h                                  |    2 
 include/linux/seq_buf.h                                   |    2 
 include/linux/sunrpc/xprt.h                               |    1 
 include/linux/trace_seq.h                                 |    4 
 include/media/v4l2-mediabus.h                             |    2 
 include/net/netfilter/nf_tables.h                         |    6 
 include/uapi/linux/android/binder.h                       |    1 
 include/uapi/linux/if_alg.h                               |   16 +
 include/xen/xenbus.h                                      |   15 +
 init/initramfs.c                                          |    2 
 kernel/cgroup/cpuset.c                                    |   33 +++
 kernel/cpu.c                                              |    6 
 kernel/irq/irqdomain.c                                    |   11 +
 kernel/sched/core.c                                       |    6 
 kernel/sched/deadline.c                                   |    5 
 kernel/sched/sched.h                                      |   42 ++--
 kernel/trace/bpf_trace.c                                  |    8 
 kernel/trace/ring_buffer.c                                |   17 +
 mm/page_alloc.c                                           |   13 -
 net/bluetooth/hci_event.c                                 |   17 +
 net/core/lwt_bpf.c                                        |    8 
 net/ipv4/netfilter/arp_tables.c                           |   14 -
 net/ipv4/netfilter/ip_tables.c                            |   14 -
 net/ipv6/netfilter/ip6_tables.c                           |   14 -
 net/mac80211/vht.c                                        |   14 +
 net/netfilter/nf_tables_api.c                             |   14 +
 net/netfilter/nft_compat.c                                |   36 +++-
 net/netfilter/nft_ct.c                                    |    2 
 net/netfilter/nft_dynset.c                                |    8 
 net/netfilter/x_tables.c                                  |   49 +----
 net/sunrpc/debugfs.c                                      |    4 
 net/sunrpc/sched.c                                        |   65 +++----
 net/sunrpc/xprt.c                                         |   65 +++++--
 net/sunrpc/xprtrdma/module.c                              |    1 
 net/sunrpc/xprtrdma/rpc_rdma.c                            |   40 +++-
 net/sunrpc/xprtrdma/transport.c                           |    1 
 net/sunrpc/xprtsock.c                                     |    7 
 net/wireless/nl80211.c                                    |    2 
 net/xdp/xsk.c                                             |   10 -
 samples/bpf/lwt_len_hist.sh                               |    2 
 scripts/Makefile.build                                    |   12 -
 scripts/checkpatch.pl                                     |    2 
 scripts/kconfig/preprocess.c                              |    2 
 security/integrity/ima/ima_crypto.c                       |   20 --
 security/selinux/hooks.c                                  |   16 +
 sound/core/memalloc.c                                     |    3 
 sound/core/oss/pcm_oss.c                                  |   22 +-
 sound/pci/hda/hda_codec.c                                 |    2 
 sound/pci/hda/hda_sysfs.c                                 |    2 
 sound/pci/hda/patch_ca0132.c                              |    4 
 sound/pci/hda/patch_realtek.c                             |   18 ++
 sound/soc/amd/acp-da7219-max98357a.c                      |    9 -
 sound/soc/codecs/cx2072x.c                                |    4 
 sound/soc/codecs/wm8997.c                                 |    2 
 sound/soc/codecs/wm8998.c                                 |    4 
 sound/soc/codecs/wm_adsp.c                                |    5 
 sound/soc/jz4740/jz4740-i2s.c                             |    4 
 sound/soc/meson/Kconfig                                   |    2 
 sound/soc/soc-pcm.c                                       |    2 
 sound/soc/sunxi/sun4i-i2s.c                               |    4 
 sound/usb/clock.c                                         |    6 
 sound/usb/quirks.c                                        |    1 
 tools/perf/util/parse-regs-options.c                      |    2 
 tools/perf/util/probe-file.c                              |   13 +
 tools/testing/selftests/bpf/Makefile                      |    3 
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c      |   42 ----
 tools/testing/selftests/bpf/test_offload.py               |    1 
 tools/testing/selftests/bpf/test_tunnel.sh                |   43 ++++
 tools/testing/selftests/net/udpgso_bench_rx.c             |    3 
 tools/testing/selftests/seccomp/config                    |    1 
 448 files changed, 2693 insertions(+), 1475 deletions(-)

Adam Sampson (1):
      ARM: dts: sun7i: pcduino3-nano: enable RGMII RX/TX delay on PHY

Alan Stern (1):
      media: gspca: Fix memory leak in probe

Alexander Sverdlin (1):
      MIPS: Don't round up kernel sections size for memblock_add()

Alexandre Belloni (2):
      ARM: dts: at91: at91sam9rl: fix ADC triggers
      clk: at91: sam9x60: remove atmel,osc-bypass support

Alexey Kardashevskiy (3):
      serial_core: Check for port state when tty is in error state
      vfio/pci/nvlink2: Do not attempt NPU2 setup on POWER8NVL NPU
      powerpc/powernv/npu: Do not attempt NPU2 setup on POWER8NVL NPU

Amadej Kastelic (1):
      ALSA: usb-audio: Add VID to support native DSD reproduction on FiiO devices

Anant Thazhemadam (1):
      Bluetooth: hci_h5: fix memory leak in h5_close

Andrew Jeffery (1):
      pinctrl: aspeed: Fix GPIO requests on pass-through banks

Andrii Nakryiko (1):
      bpf: Fix bpf_put_raw_tracepoint()'s use of __module_address()

Andy Shevchenko (2):
      pinctrl: merrifield: Set default bias in case no particular value given
      pinctrl: baytrail: Avoid clearing debounce value when turning it off

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Anton Ivanov (4):
      um: Monitor error events in IRQ controller
      um: tty: Fix handling of close in tty lines
      um: chan_xterm: Fix fd leak
      um: Remove use of asprinf in umid.c

Antti Palosaari (1):
      media: msi2500: assign SPI bus number dynamically

Ard Biesheuvel (4):
      ARM: p2v: fix handling of LPAE translation in BE mode
      powerpc: Avoid broken GCC __attribute__((optimize))
      crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
      crypto: arm/aes-ce - work around Cortex-A57/A72 silion errata

Arnaldo Carvalho de Melo (1):
      perf probe: Fix memory leak when synthesizing SDT probes

Arnd Bergmann (10):
      scsi: megaraid_sas: Check user-provided offsets
      drm/amdgpu: fix incorrect enum type
      drm/amdgpu: fix build_coefficients() argument
      RDMa/mthca: Work around -Wenum-conversion warning
      seq_buf: Avoid type mismatch for seq_buf_init
      crypto: atmel-i2c - select CONFIG_BITREVERSE
      watchdog: coh901327: add COMMON_CLK dependency
      initramfs: fix clang build failure
      Input: cyapa_gen6 - fix out-of-bounds stack access
      platform/x86: mlx-platform: remove an unused variable

Artem Lapkin (1):
      arm64: dts: meson: fix spi-max-frequency on Khadas VIM2

Arun Easi (1):
      scsi: qla2xxx: Fix crash during driver load on big endian machines

Arvind Sankar (1):
      x86/mm/ident_map: Check for errors from ident_pud_init()

Athira Rajeev (2):
      powerpc/perf: Fix crash with is_sier_available when pmu is not set
      powerpc/perf: Exclude kernel samples while counting events in user space.

Baolin Wang (1):
      Revert "gpio: eic-sprd: Use devm_platform_ioremap_resource()"

Baruch Siach (1):
      gpio: mvebu: fix potential user-after-free on probe

Bernd Bauer (1):
      ARM: dts: imx6qdl-kontron-samx6i: fix I2C_PM scl pin

Bharat Gooty (1):
      PCI: iproc: Fix out-of-bound array accesses

Biju Das (2):
      arm64: dts: renesas: hihope-rzg2-ex: Drop rxc-skew-ps from ethernet-phy node
      arm64: dts: renesas: cat875: Remove rxc-skew-ps from ethernet-phy node

Bjorn Andersson (2):
      slimbus: qcom-ngd-ctrl: Avoid sending power requests without QMI
      arm64: dts: qcom: c630: Polish i2c-hid devices

Bjorn Helgaas (1):
      PCI: Bounds-check command-line resource alignment requests

Björn Töpel (4):
      i40e: Refactor rx_bi accesses
      i40e: avoid premature Rx buffer reuse
      ixgbe: avoid premature Rx buffer reuse
      selftests/bpf: Fix broken riscv build

Bob Pearson (1):
      RDMA/rxe: Compute PSN windows correctly

Bongsu Jeon (1):
      nfc: s3fwrn5: Release the nfc firmware

Borislav Petkov (1):
      EDAC/amd64: Fix PCI component registration

Brandon Syu (1):
      drm/amd/display: Init clock value by current vbios CLKs

Brett Mastbergen (1):
      netfilter: nft_ct: Remove confirmation check for NFT_CT_ID

Calum Mackay (1):
      lockd: don't use interval-based rebinding over TCP

Carlos Garnacho (1):
      platform/x86: intel-vbtn: Allow switch events on Acer Switch Alpha 12

Cezary Rojewski (1):
      ASoC: pcm: DRAIN support reactivation

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
      arm64: dts: rockchip: Fix UART pull-ups on rk3328

Cheng Lin (1):
      nfs_common: need lock during iterate through the list

Chris Chiu (4):
      ALSA: hda/realtek - Enable headset mic of ASUS X430UN with ALC256
      ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255
      ALSA/hda: apply jack fixup for the Acer Veriton N4640G/N6640G/N2510G
      ALSA: hda/realtek: Apply jack fixup for Quanta NL3

Chris Packham (1):
      ARM: dts: Remove non-existent i2c1 from 98dx3236

Chris Park (1):
      drm/amd/display: Prevent bandwidth overflow

Chris Wilson (1):
      drm/i915: Fix mismatch between misplaced vma check and vma insert

Christophe JAILLET (5):
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
      clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Christophe Leroy (8):
      crypto: talitos - Endianess in current_desc_hdr()
      crypto: talitos - Fix return type of current_desc_hdr()
      powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
      powerpc/mm: sanity_check_fault() should work for all, not only BOOK3S
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

Chunyan Zhang (1):
      gpio: eic-sprd: break loop when getting NULL device resource

Claudiu Beznea (1):
      ARM: dts: at91: sama5d2: map securam as device

Clément Péron (1):
      ASoC: sun4i-i2s: Fix lrck_period computation for I2S justified mode

Colin Ian King (4):
      crypto: inside-secure - Fix sizeof() mismatch
      media: tm6000: Fix sizeof() mismatches
      PCI: Fix overflow in command-line resource alignment requests
      drm/mediatek: avoid dereferencing a null hdmi_phy on an error message

Connor McAdams (2):
      ALSA: hda/ca0132 - Change Input Source enum strings.
      ALSA: hda/ca0132 - Fix AE-5 rear headphone pincfg.

Cristian Birsan (2):
      ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
      ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Dae R. Jeong (1):
      md: fix a warning caused by a race between concurrent md_ioctl()s

Damien Le Moal (1):
      block: Simplify REQ_OP_ZONE_RESET_ALL handling

Dan Aloni (1):
      sunrpc: fix xs_read_xdr_buf for partial pages receive

Dan Carpenter (11):
      usb: mtu3: fix memory corruption in mtu3_debugfs_regset()
      soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
      rtc: pcf2127: fix pcf2127_nvmem_read/write() returns
      media: max2175: fix max2175_set_csm_mode() error code
      media: saa7146: fix array overflow in vidioc_s_audio()
      mtd: rawnand: meson: Fix a resource leak in init
      ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
      qlcnic: Fix error code in probe
      virtio_ring: Cut and paste bugs in vring_create_virtqueue_packed()
      virtio_net: Fix error code in probe()
      virtio_ring: Fix two use after free bugs

Dan Williams (1):
      libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels

Daniel Gomez (1):
      media: imx214: Fix stop streaming

Daniel Jordan (1):
      cpuset: fix race between hotplug work and later CPU offline

Daniel Scally (1):
      Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Daniel T. Lee (1):
      samples: bpf: Fix lwt_len_hist reusing previous BPF map

Dave Kleikamp (1):
      jfs: Fix array index bounds check in dbAdjTree

David Hildenbrand (2):
      powerpc/powernv/memtrace: Don't leak kernel memory to user space
      powerpc/powernv/memtrace: Fix crashing the kernel when enabling concurrently

David Howells (1):
      afs: Fix memory leak when mounting with multiple source parameters

David Jander (1):
      Input: ads7846 - fix race that causes missing releases

David Woodhouse (1):
      x86/apic: Fix x2apic enablement without interrupt remapping

Deepak R Varma (1):
      drm/tegra: replace idr_init() by idr_init_base()

DingHua Ma (1):
      regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x

Dmitry Baryshkov (1):
      drm/msm/dsi_pll_10nm: restore VCO rate during restore_state

Dmitry Osipenko (1):
      clk: tegra: Fix duplicated SE clock entry

Dmitry Torokhov (2):
      Input: ads7846 - fix unaligned access on 7845
      Input: cros_ec_keyb - send 'scancodes' in addition to key events

Dongdong Wang (1):
      lwt: Disable BH too in run_lwt_bpf()

Dongjin Kim (1):
      arm64: dts: meson-sm1: fix typo in opp table

Douglas Anderson (3):
      blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
      soc: qcom: geni: More properly switch to DMA mode
      Revert "i2c: i2c-qcom-geni: Fix DMA transfer race"

Dwaipayan Ray (1):
      checkpatch: fix unescaped left brace

Eric Biggers (1):
      crypto: af_alg - avoid undefined behavior accessing salg_name

Evan Green (1):
      soc: qcom: smp2p: Safely acquire spinlock without IRQs

Fabio Estevam (2):
      ARM: dts: imx6qdl-wandboard-revd1: Remove PAD_GPIO_6 from enetgrp
      usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Fedor Tokarev (1):
      net: sunrpc: Fix 'snprintf' return value check in 'do_xprt_debugfs'

Felix Kuehling (1):
      drm/amdkfd: Fix leak in dmabuf import

Florian Westphal (1):
      netfilter: nft_compat: make sure xtables destructors have run

Geert Uytterhoeven (1):
      clk: renesas: r9a06g032: Drop __packed for portability

Greg Kroah-Hartman (1):
      Linux 5.4.86

Guenter Roeck (2):
      watchdog: armada_37xx: Add missing dependency on HAS_IOMEM
      watchdog: sirfsoc: Add missing dependency on HAS_IOMEM

H. Nikolaus Schaller (1):
      ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES

Han Xu (1):
      mtd: rawnand: gpmi: Fix the random DMA timeout issue

Hangbin Liu (1):
      selftest/bpf: Add missed ip6ip6 test back

Hans de Goede (1):
      power: supply: axp288_charger: Fix HP Pavilion x2 10 DMI matching

Huang Jianan (1):
      erofs: avoid using generic_block_bmap

Hui Wang (2):
      ACPI: PNP: compare the string length in the matching_id()
      ALSA: hda/realtek: make bass spk volume adjustable on a yoga laptop

Ian Abbott (1):
      staging: comedi: mf6x4: Fix AI end-of-conversion detection

Icenowy Zheng (1):
      ARM: dts: sun8i: v3s: fix GIC node memory range

Jack Morgenstein (1):
      RDMA/core: Do not indicate device ready when device enablement fails

Jack Pham (1):
      usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Jack Xu (1):
      crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()

Jaegeuk Kim (1):
      f2fs: call f2fs_get_meta_page_retry for nat page

James Smart (2):
      scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()
      scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()

Jan Kara (2):
      quota: Sanity-check quota file headers on load
      ext4: fix deadlock with fs freezing and EA inodes

Jason Gunthorpe (1):
      vfio-pci: Use io_remap_pfn_range() for PCI IO memory

Jernej Skrabec (1):
      clk: sunxi-ng: Make sure divider tables have sentinel

Jerome Brunet (1):
      ASoC: meson: fix COMPILE_TEST error

Jing Xiangfeng (5):
      staging: gasket: interrupt: fix the missed eventfd_ctx_put() in gasket_interrupt.c
      HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()
      memstick: r592: Fix error return in r592_probe()
      Bluetooth: btusb: Add the missed release_firmware() in btusb_mtk_setup_firmware()
      Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_firmware()

Joel Stanley (1):
      ARM: dts: aspeed: s2600wf: Fix VGA memory region location

Johan Hovold (9):
      USB: serial: option: add interface-number sanity check to flag handling
      USB: serial: mos7720: fix parallel-port state restore
      USB: serial: digi_acceleport: fix write-wakeup deadlocks
      USB: serial: keyspan_pda: fix dropped unthrottle interrupts
      USB: serial: keyspan_pda: fix write deadlock
      USB: serial: keyspan_pda: fix stalled writes
      USB: serial: keyspan_pda: fix write-wakeup use-after-free
      USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
      USB: serial: keyspan_pda: fix write unthrottling

Johannes Berg (2):
      iwlwifi: mvm: hook up missing RX handlers
      mac80211: don't set set TDLS STA bandwidth wider than possible

Johannes Thumshirn (1):
      block: factor out requeue handling from dispatch code

Johannes Weiner (1):
      mm: don't wake kswapd prematurely when watermark boosting is disabled

Jonathan Cameron (7):
      iio:light:rpr0521: Fix timestamp alignment and prevent data leak.
      iio:light:st_uvis25: Fix timestamp alignment and prevent data leak.
      iio:magnetometer:mag3110: Fix alignment and data leak issues.
      iio:pressure:mpl3115: Force alignment of buffer
      iio:imu:bmi160: Fix too large a buffer.
      iio:adc:ti-ads124s08: Fix buffer being too long.
      iio:adc:ti-ads124s08: Fix alignment and data leak issues.

Jordan Niethe (2):
      powerpc/64: Set up a kernel stack for secondaries before cpu_restore()
      powerpc/64: Fix an EMIT_BUG_ENTRY in head_64.S

Josef Bacik (1):
      btrfs: do not shorten unpin len for caching block groups

Jubin Zhong (1):
      PCI: Fix pci_slot_release() NULL pointer dereference

Julian Sax (1):
      HID: i2c-hid: add Vero K147 to descriptor override

Kailang Yang (1):
      ALSA: hda/realtek - Add supported for more Lenovo ALC285 Headset Button

Kamal Heib (2):
      RDMA/bnxt_re: Set queue pair state when being queried
      RDMA/cxgb4: Validate the number of CQEs

Kan Liang (2):
      perf/x86/intel: Add event constraint for CYCLE_ACTIVITY.STALLS_MEM_ANY
      perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake

Keita Suzuki (1):
      media: siano: fix memory leak of debugfs members in smsdvb_hotplug

Keqian Zhu (2):
      clocksource/drivers/arm_arch_timer: Use stable count reader in erratum sne
      clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Kevin Hilman (1):
      clk: meson: Kconfig: fix dependency for G12A

Krzysztof Kozlowski (5):
      ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
      ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410
      ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU
      drm/mcde: Fix handling of platform_get_irq() error
      drm/tve200: Fix handling of platform_get_irq() error

Lad Prabhakar (1):
      media: v4l2-fwnode: Return -EINVAL for invalid bus-type

Lars-Peter Clausen (1):
      iio: hrtimer-trigger: Mark hrtimer to expire in hard interrupt context

Leon Romanovsky (3):
      RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait
      net/mlx5: Properly convey driver version to firmware
      RDMA/cma: Don't overwrite sgid_attr after device is released

Li RongQing (1):
      i40e: optimise prefetch page refcount

Lingling Xu (2):
      watchdog: sprd: remove watchdog disable from resume fail path
      watchdog: sprd: check busy bit before new loading rather than after that

Lokesh Vutla (1):
      pwm: lp3943: Dynamically allocate PWM chip base

Luc Van Oostenryck (1):
      xsk: Fix xsk_poll()'s return type

Luca Coelho (1):
      iwlwifi: pcie: add one missing entry for AX210

Luis Henriques (1):
      ceph: fix race in concurrent __ceph_remove_cap invocations

Lukas Wunner (15):
      media: netup_unidvb: Don't leak SPI master in probe error path
      spi: pxa2xx: Fix use-after-free on unbind
      spi: spi-sh: Fix use-after-free on unbind
      spi: atmel-quadspi: Fix use-after-free on unbind
      spi: davinci: Fix use-after-free on unbind
      spi: gpio: Don't leak SPI master in probe error path
      spi: mxic: Don't leak SPI master in probe error path
      spi: pic32: Don't leak DMA channels in probe error path
      spi: rb4xx: Don't leak SPI master in probe error path
      spi: sc18is602: Don't leak SPI master in probe error path
      spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path
      spi: synquacer: Disable clock in probe error path
      spi: mt7621: Disable clock in probe error path
      spi: mt7621: Don't leak SPI master in probe error path
      spi: atmel-quadspi: Disable clock in probe error path

Maarten Lankhorst (1):
      dma-buf/dma-resv: Respect num_fences when initializing the shared fence list.

Manivannan Sadhasivam (1):
      watchdog: qcom: Avoid context switch in restart handler

Mao Jinlong (1):
      coresight: tmc-etr: Check if page is valid before dma_map_page()

Marc Zyngier (3):
      genirq/irqdomain: Don't try to free an interrupt that has no mapping
      irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
      KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Marek Behún (1):
      arm64: dts: armada-3720-turris-mox: update ethernet-phy handle name

Marek Szyprowski (1):
      extcon: max77693: Fix modalias string

Mark Rutland (1):
      arm64: syscall: exit userspace before unmasking exceptions

Martin Wilck (1):
      scsi: core: Fix VPD LUN ID designator priorities

Masahiro Yamada (2):
      kbuild: avoid split lines in .mod files
      kconfig: fix return value of do_error_if()

Masami Hiramatsu (1):
      x86/kprobes: Restore BTF if the single-stepping is cancelled

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Matthew Wilcox (Oracle) (1):
      sparc: fix handling of page table constructor failure

Michael Walle (1):
      arm64: dts: ls1028a: fix ENETC PTP clock input

Mickaël Salaün (1):
      selftests/seccomp: Update kernel config

Miquel Raynal (1):
      mtd: spinand: Fix OOB read

Nathan Chancellor (1):
      crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd

Nathan Lynch (2):
      powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops
      powerpc/pseries/hibernation: remove redundant cacheinfo update

Necip Fazil Yildiran (1):
      MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

NeilBrown (1):
      NFS: switch nfsiod to be an UNBOUND workqueue.

Nicholas Piggin (1):
      kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling

Nicolas Boichat (1):
      soc: mediatek: Check if power domains can be powered on at boot time

Nicolas Ferre (1):
      ARM: dts: at91: sama5d2: fix CAN message ram offset and size

Nicolin Chen (2):
      soc/tegra: fuse: Fix index bug in get_process_id
      clk: tegra: Do not return 0 on failure

Nikita Shubin (1):
      rtc: ep93xx: Fix NULL pointer dereference in ep93xx_rtc_read_time

Nuno Sá (1):
      iio: buffer: Fix demux update

Ofir Bitton (1):
      habanalabs: put devices before driver removal

Oleksij Rempel (1):
      Input: ads7846 - fix integer overflow on Rt calculation

Olga Kornievskaia (1):
      NFSv4.2: condition READDIR's mask for security label based on LSM state

Pablo Greco (3):
      ARM: dts: sun7i: bananapi: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun8i: r40: bananapi-m2-berry: Fix dcdc1 regulator
      ARM: dts: sun8i: v40: bananapi-m2-berry: Fix ethernet node

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: fix timeouts later than 23 days

Pali Rohár (8):
      cpufreq: ap806: Add missing MODULE_DEVICE_TABLE
      cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
      cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE
      cpufreq: qcom: Add missing MODULE_DEVICE_TABLE
      cpufreq: st: Add missing MODULE_DEVICE_TABLE
      cpufreq: sun50i: Add missing MODULE_DEVICE_TABLE
      cpufreq: loongson1: Add missing MODULE_ALIAS
      cpufreq: scpi: Add missing MODULE_ALIAS

Paolo Abeni (1):
      selftests: fix poll error in udpgro.sh

Paul Cercueil (1):
      clk: ingenic: Fix divider calculation with div tables

Paul Kocialkowski (1):
      ARM: sunxi: Add machine match for the Allwinner V3 SoC

Paul Moore (1):
      selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Pawel Wieczorkiewicz (1):
      xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Paweł Chmiel (2):
      arm64: dts: exynos: Include common syscon restart/poweroff for Exynos7
      arm64: dts: exynos: Correct psci compatible used on Exynos7

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Peng Liu (1):
      sched/deadline: Fix sched_dl_global_validate()

Philipp Rudo (1):
      s390/kexec_file: fix diag308 subcode when loading crash kernel

Praveenkumar I (1):
      mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read

Qinglang Miao (13):
      gpio: zynq: fix reference leak in zynq_gpio functions
      drm/tegra: sor: Disable clocks on error in tegra_sor_init()
      spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
      spi: bcm63xx-hsspi: fix missing clk_disable_unprepare() on error in bcm63xx_hsspi_resume
      media: solo6x10: fix missing snd_card_free in error handling case
      memstick: fix a double-free bug in memstick_check
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
      mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
      platform/x86: dell-smbios-base: Fix error return code in dell_smbios_init
      dm ioctl: fix error return code in target_message
      scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
      s390/cio: fix use-after-free in ccw_device_destroy_console
      iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Qiuxu Zhuo (1):
      EDAC/i10nm: Use readl() to access MMIO registers

Qu Wenruo (1):
      btrfs: trim: fix underflow in trim length to prevent access beyond device boundary

Rafael J. Wysocki (1):
      PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()

Rakesh Pillai (1):
      ath10k: Fix the parsing error in service available event

Randy Dunlap (2):
      scsi: bnx2i: Requires MMU
      drm/aspeed: Fix Kconfig warning & subsequent build errors

Rasmus Villemoes (1):
      spi: fsl: fix use of spisel_boot signal on MPC8309

Richard Weinberger (1):
      ubifs: wbuf: Don't leak kernel memory to flash

Roberto Sassu (1):
      ima: Don't modify file descriptor mode on the fly

Robin Gong (1):
      ALSA: core: memalloc: add page alignment for iram

Russell King (1):
      net: mvpp2: add mvpp2_phylink_to_port() helper

Sai Prakash Ranjan (2):
      coresight: tmc-etf: Fix NULL ptr dereference in tmc_enable_etf_sink_perf()
      coresight: etb10: Fix possible NULL ptr dereference in etb_enable_perf()

Sakari Ailus (5):
      media: ipu3-cio2: Remove traces of returned buffers
      media: ipu3-cio2: Return actual subdev format
      media: ipu3-cio2: Serialise access to pad format
      media: ipu3-cio2: Validate mbus format in setting subdev format
      media: ipu3-cio2: Make the field on subdev format V4L2_FIELD_NONE

Sara Sharon (1):
      cfg80211: initialize rekey_data

Sean Nyekjaer (1):
      can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit

Sean Young (1):
      media: sunxi-cir: ensure IR is handled when it is continuous

Sebastian Andrzej Siewior (1):
      orinoco: Move context allocation after processing the skb

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Serge Hallyn (1):
      fix namespaced fscaps when !CONFIG_SECURITY

Sergei Antonov (1):
      mtd: rawnand: meson: fix meson_nfc_dma_buffer_release() arguments

Seung-Woo Kim (1):
      brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}

Simon Beginn (1):
      Input: goodix - add upside-down quirk for Teclast X98 Pro tablet

Sreekanth Reddy (1):
      scsi: mpt3sas: Increase IOCInit request timeout to 30s

Stefan Agner (3):
      arm64: dts: meson: fix PHY deassert timing requirements
      ARM: dts: meson: fix PHY deassert timing requirements
      arm64: dts: meson: g12a: x96-max: fix PHY deassert timing requirements

Stefan Haberland (4):
      s390/dasd: fix hanging device offline processing
      s390/dasd: prevent inconsistent LCU device data
      s390/dasd: fix list corruption of pavgroup group list
      s390/dasd: fix list corruption of lcu list

Stephane Eranian (1):
      perf/x86/intel: Check PEBS status correctly

Stephen Boyd (1):
      platform/chrome: cros_ec_spi: Don't overwrite spi::mode

Steve French (1):
      SMB3: avoid confusing warning message on mount to Azure

Steven Rostedt (VMware) (1):
      Revert: "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"

Stylon Wang (1):
      drm/amd/display: Fix memory leaks in S3 resume

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Switch synchronization to RCU

Suzuki K Poulose (1):
      coresight: tmc-etr: Fix barrier packet insertion for perf buffer

Sven Eckelmann (3):
      vxlan: Add needed_headroom for lower device
      vxlan: Copy needed_tailroom from lowerdev
      mtd: parser: cmdline: Fix parsing of part-names with colons

Sven Schnelle (1):
      s390/smp: perform initial CPU reset also for SMT siblings

Sven Van Asbroeck (1):
      lan743x: fix rx_napi_poll/interrupt ping-pong

Takashi Iwai (5):
      ALSA: hda: Fix regressions on clear and reconfig sysfs
      ALSA: pcm: oss: Fix a few more UBSAN fixes
      ALSA: hda/realtek: Add quirk for MSI-GP73
      ALSA: usb-audio: Disable sample read check if firmware doesn't give back
      ASoC: cx2072x: Fix doubly definitions of Playback and Capture streams

Terry Zhou (1):
      clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Thomas Gleixner (2):
      dm table: Remove BUG_ON(in_interrupt())
      sched: Reenable interrupts in do_sched_yield()

Tianyue Ren (1):
      selinux: fix error initialization in inode_doinit_with_dentry()

Todd Kjos (1):
      binder: add flag to clear buffer on txn complete

Toke Høiland-Jørgensen (1):
      selftests/bpf/test_offload.py: Reset ethtool features after failed setting

Tom Rix (1):
      drm/gma500: fix double free of gma_connector

Trond Myklebust (3):
      SUNRPC: rpc_wake_up() should wake up tasks in the correct order
      SUNRPC: xprt_load_transport() needs to support the netid "rdma6"
      NFSv4: Fix the alignment of page data in the getdeviceinfo reply

Tsuchiya Yuto (1):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure

Tudor Ambarus (1):
      spi: atmel-quadspi: Fix AHB memory accesses

Tyrel Datwyler (1):
      powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter

Uwe Kleine-König (2):
      spi: fix resource leak for drivers without .remove callback
      pwm: zx: Add missing cleanup in error path

Vadim Pasternak (3):
      platform/x86: mlx-platform: Remove PSU EEPROM from default platform configuration
      platform/x86: mlx-platform: Remove PSU EEPROM from MSN274x platform configuration
      platform/x86: mlx-platform: Fix item counter assignment for MSN2700, MSN24xx systems

Vidya Sagar (1):
      arm64: tegra: Fix DT binding for IO High Voltage entry

Vijay Khemka (1):
      ARM: dts: aspeed: tiogapass: Remove vuart

Vincent Stehlé (2):
      powerpc/ps3: use dma_mapping_error()
      net: korina: fix return value

Wang Hai (2):
      qtnfmac: fix error return code in qtnf_pcie_probe()
      device-dax/core: Fix memory leak when rmmod dax.ko

Wang Li (1):
      phy: renesas: rcar-gen3-usb2: disable runtime pm in case of failure

Wang ShaoBo (1):
      ubifs: Fix error return code in ubifs_init_authentication()

Wang Wensheng (1):
      watchdog: Fix potential dereferencing of null pointer

Will McVicker (2):
      USB: gadget: f_midi: setup SuperSpeed Plus descriptors
      USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Xuan Zhuo (1):
      xsk: Replace datagram_poll by sock_poll_wait

Yang Yingliang (5):
      video: fbdev: atmel_lcdfb: fix return error code in atmel_lcdfb_of_init()
      drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
      usb/max3421: fix return error code in max3421_probe()
      clocksource/drivers/orion: Add missing clk_disable_unprepare() on error path
      speakup: fix uninitialized flush_lock

Yangtao Li (1):
      pinctrl: sunxi: Always call chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler

Yazen Ghannam (2):
      EDAC/mce_amd: Use struct cpuinfo_x86.cpu_die_id for AMD NodeId
      x86/CPU/AMD: Save AMD NodeId as cpu_die_id

Yu Kuai (6):
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_dec_pm()
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_enc_pm()
      soc: amlogic: canvas: add missing put_device() call in meson_canvas_get()
      clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()
      pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Zhang Changzhong (4):
      rsi: fix error return code in rsi_reset_card()
      scsi: fnic: Fix error return code in fnic_probe()
      bus: fsl-mc: fix error return code in fsl_mc_object_allocate()
      remoteproc: qcom: Fix potential NULL dereference in adsp_init_mmio()

Zhang Qilong (28):
      PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
      can: softing: softing_netdev_open(): fix error handling
      spi: img-spfi: fix reference leak in img_spfi_resume
      spi: spi-mem: fix reference leak in spi_mem_access_start
      spi: stm32: fix reference leak in stm32_spi_resume
      spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
      spi: tegra20-slink: fix reference leak in slink ops of tegra20
      spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
      spi: tegra114: fix reference leak in tegra spi ops
      ASoC: wm8998: Fix PM disable depth imbalance on error
      spi: sprd: fix reference leak in sprd_spi_remove
      ASoC: arizona: Fix a wrong free in wm8997_probe
      staging: greybus: codecs: Fix reference counter leak in error handling
      spi: mxs: fix reference leak in mxs_spi_probe
      crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
      soc: ti: knav_qmss: fix reference leak in knav_queue_probe
      soc: ti: Fix reference imbalance in knav_dma_probe
      Input: omap4-keypad - fix runtime PM error handling
      power: supply: bq24190_charger: fix reference leak
      hwmon: (ina3221) Fix PM usage counter unbalance in ina3221_write_enable
      scsi: pm80xx: Fix error return in pm8001_pci_probe()
      usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
      usb: oxu210hp-hcd: Fix memory leak in oxu_create
      remoteproc: q6v5-mss: fix error handling in q6v5_pds_enable
      remoteproc: qcom: fix reference leak in adsp_start
      mtd: rawnand: gpmi: fix reference count leak in gpmi ops
      libnvdimm/label: Return -ENXIO for no slot in __blk_label_update
      clk: ti: Fix memleak in ti_fapll_synth_setup

Zhao Heming (2):
      md/cluster: block reshape with remote resync job
      md/cluster: fix deadlock when node is doing resync job

Zhe Li (1):
      jffs2: Fix GC exit abnormally

Zheng Zengkai (1):
      perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhihao Cheng (3):
      drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe
      mmc: pxamci: Fix error return code in pxamci_probe
      dmaengine: mv_xor_v2: Fix error return code in mv_xor_v2_probe()

Zwane Mwaikambo (1):
      drm/dp_aux_dev: check aux_dev before use in drm_dp_aux_dev_get_by_minor()

kazuo ito (1):
      nfsd: Fix message level for normal termination

lizhe (1):
      jffs2: Fix ignoring mounting options problem during remounting

taehyun.cho (1):
      USB: gadget: f_acm: add support for SuperSpeed Plus

