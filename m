Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337EC38D4D4
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhEVJjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 05:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230309AbhEVJi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 05:38:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BD426128A;
        Sat, 22 May 2021 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621676252;
        bh=+kxjNACTtl5gj/yEFGLdj6cVCsN8SG54n5nl73QS480=;
        h=From:To:Cc:Subject:Date:From;
        b=E/OvFWgsiXtrIX9RjGNqDYulq+dB4A0gznXMa15iIW8CjLEKgTAkvgDEDOnMsselH
         Lq3waPOPBf27qCVtvhykJo3hr7mrWPVpb0+4MchWIiMDcwlN47KLuuGG51TgHjnBGm
         zmGdeTLpZFx/tyF07ik6j9ZjHfBjU6gnih0K6Uro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.191
Date:   Sat, 22 May 2021 11:37:26 +0200
Message-Id: <16216762462624@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.191 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sphinx/parse-headers.pl                          |    2 
 Documentation/target/tcm_mod_builder.py                        |    2 
 Documentation/trace/postprocess/decode_msr.py                  |    2 
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |    2 
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    |    2 
 Makefile                                                       |    2 
 arch/arc/kernel/entry.S                                        |    4 
 arch/arm/boot/compressed/Makefile                              |    4 
 arch/arm/boot/dts/exynos4412-midas.dtsi                        |    6 
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi                |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                      |    2 
 arch/arm/boot/dts/exynos5250-snow-common.dtsi                  |    2 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                           |    2 
 arch/arm/include/asm/kvm_host.h                                |    1 
 arch/arm/kernel/asm-offsets.c                                  |    3 
 arch/arm/kernel/hw_breakpoint.c                                |    2 
 arch/arm/kernel/smccc-call.S                                   |   11 
 arch/arm/kernel/suspend.c                                      |   19 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                   |    3 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                       |    2 
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi               |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi               |    4 
 arch/arm64/include/asm/kvm_host.h                              |    1 
 arch/arm64/kernel/vdso/gettimeofday.S                          |    6 
 arch/arm64/kernel/vdso/vdso.lds.S                              |    8 
 arch/arm64/kvm/debug.c                                         |   88 +
 arch/ia64/include/asm/module.h                                 |    6 
 arch/ia64/kernel/module.c                                      |   29 
 arch/ia64/scripts/unwcheck.py                                  |    2 
 arch/mips/include/asm/div64.h                                  |   55 -
 arch/mips/pci/pci-legacy.c                                     |    9 
 arch/mips/pci/pci-mt7620.c                                     |    5 
 arch/mips/pci/pci-rt2880.c                                     |   37 
 arch/powerpc/Kconfig                                           |    2 
 arch/powerpc/Kconfig.debug                                     |    1 
 arch/powerpc/include/asm/book3s/64/radix.h                     |    6 
 arch/powerpc/include/uapi/asm/errno.h                          |    1 
 arch/powerpc/kernel/eeh.c                                      |   11 
 arch/powerpc/kernel/iommu.c                                    |    4 
 arch/powerpc/kernel/prom.c                                     |    2 
 arch/powerpc/kernel/smp.c                                      |    6 
 arch/powerpc/lib/feature-fixups.c                              |   35 
 arch/powerpc/mm/pgtable-radix.c                                |    4 
 arch/powerpc/perf/isa207-common.c                              |    4 
 arch/powerpc/platforms/52xx/lite5200_sleep.S                   |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c                   |    3 
 arch/powerpc/platforms/pseries/pci_dlpar.c                     |    4 
 arch/riscv/include/asm/ftrace.h                                |   14 
 arch/riscv/kernel/mcount.S                                     |   10 
 arch/s390/crypto/arch_random.c                                 |    4 
 arch/s390/kernel/dis.c                                         |    2 
 arch/s390/kvm/gaccess.h                                        |   54 -
 arch/s390/kvm/kvm-s390.c                                       |    4 
 arch/um/kernel/dyn.lds.S                                       |    6 
 arch/um/kernel/uml.lds.S                                       |    6 
 arch/x86/Kconfig                                               |    1 
 arch/x86/Makefile                                              |    1 
 arch/x86/entry/vdso/vma.c                                      |    2 
 arch/x86/events/amd/iommu.c                                    |    6 
 arch/x86/kernel/cpu/microcode/core.c                           |    8 
 arch/x86/kernel/kprobes/core.c                                 |   17 
 arch/x86/kvm/x86.c                                             |    1 
 arch/x86/lib/msr-smp.c                                         |    4 
 block/blk-mq.c                                                 |    6 
 crypto/api.c                                                   |    2 
 drivers/acpi/arm64/gtdt.c                                      |   10 
 drivers/acpi/cppc_acpi.c                                       |   14 
 drivers/acpi/custom_method.c                                   |    4 
 drivers/acpi/scan.c                                            |    1 
 drivers/ata/libahci_platform.c                                 |    4 
 drivers/ata/pata_arasan_cf.c                                   |   15 
 drivers/ata/pata_ixp4xx_cf.c                                   |    6 
 drivers/ata/sata_mv.c                                          |    4 
 drivers/base/regmap/regmap-debugfs.c                           |    1 
 drivers/block/null_blk_zoned.c                                 |    1 
 drivers/bus/qcom-ebi2.c                                        |    4 
 drivers/char/tpm/eventlog/common.c                             |    3 
 drivers/char/tpm/tpm2-cmd.c                                    |    1 
 drivers/char/ttyprintk.c                                       |   11 
 drivers/clk/mvebu/armada-37xx-periph.c                         |   83 -
 drivers/clk/qcom/a53-pll.c                                     |    1 
 drivers/clk/samsung/clk-exynos7.c                              |    7 
 drivers/clk/socfpga/clk-gate-a10.c                             |    1 
 drivers/clk/uniphier/clk-uniphier-mux.c                        |    4 
 drivers/cpufreq/armada-37xx-cpufreq.c                          |   76 +
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c                       |    4 
 drivers/crypto/qat/qat_c62xvf/adf_drv.c                        |    4 
 drivers/crypto/qat/qat_common/adf_isr.c                        |   29 
 drivers/crypto/qat/qat_common/adf_transport.c                  |    1 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                     |   17 
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c                    |    4 
 drivers/extcon/extcon-arizona.c                                |   17 
 drivers/firmware/Kconfig                                       |    1 
 drivers/gpio/gpiolib-acpi.c                                    |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c                        |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c                         |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h                         |    9 
 drivers/gpu/drm/i915/gvt/gvt.c                                 |    8 
 drivers/gpu/drm/i915/intel_pm.c                                |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c               |   10 
 drivers/gpu/drm/radeon/radeon.h                                |    1 
 drivers/gpu/drm/radeon/radeon_atombios.c                       |   26 
 drivers/gpu/drm/radeon/radeon_kms.c                            |    1 
 drivers/gpu/drm/radeon/radeon_pm.c                             |    8 
 drivers/gpu/drm/radeon/si_dpm.c                                |    3 
 drivers/hid/hid-ids.h                                          |    1 
 drivers/hid/hid-plantronics.c                                  |   60 +
 drivers/hsi/hsi_core.c                                         |    3 
 drivers/hv/channel_mgmt.c                                      |   30 
 drivers/hwtracing/intel_th/gth.c                               |    4 
 drivers/hwtracing/intel_th/pci.c                               |   10 
 drivers/i2c/busses/i2c-cadence.c                               |    5 
 drivers/i2c/busses/i2c-emev2.c                                 |    5 
 drivers/i2c/busses/i2c-jz4780.c                                |    5 
 drivers/i2c/busses/i2c-sh7760.c                                |    5 
 drivers/i2c/i2c-dev.c                                          |    9 
 drivers/iio/accel/adis16201.c                                  |    2 
 drivers/iio/gyro/mpu3050-core.c                                |   13 
 drivers/iio/light/tsl2583.c                                    |    8 
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c              |    1 
 drivers/infiniband/hw/bnxt_re/qplib_res.c                      |    1 
 drivers/infiniband/hw/hfi1/firmware.c                          |    1 
 drivers/infiniband/hw/i40iw/i40iw_pble.c                       |    6 
 drivers/infiniband/ulp/srpt/ib_srpt.c                          |    1 
 drivers/input/touchscreen/elants_i2c.c                         |   44 
 drivers/input/touchscreen/silead.c                             |   44 
 drivers/irqchip/irq-gic-v3-mbi.c                               |    2 
 drivers/isdn/capi/kcapi.c                                      |    4 
 drivers/md/dm-raid.c                                           |   34 
 drivers/md/dm-rq.c                                             |    2 
 drivers/md/md-bitmap.c                                         |    2 
 drivers/md/md.c                                                |   73 -
 drivers/md/persistent-data/dm-btree-internal.h                 |    4 
 drivers/md/persistent-data/dm-space-map-common.c               |    2 
 drivers/md/persistent-data/dm-space-map-common.h               |    8 
 drivers/md/raid1.c                                             |    2 
 drivers/media/dvb-core/dvbdev.c                                |    1 
 drivers/media/i2c/adv7511-v4l2.c                               |    2 
 drivers/media/i2c/adv7604.c                                    |    2 
 drivers/media/i2c/adv7842.c                                    |    2 
 drivers/media/i2c/tc358743.c                                   |    2 
 drivers/media/pci/saa7164/saa7164-encoder.c                    |   20 
 drivers/media/pci/sta2x11/Kconfig                              |    1 
 drivers/media/platform/vivid/vivid-core.c                      |    6 
 drivers/media/platform/vivid/vivid-vid-out.c                   |    2 
 drivers/media/rc/ite-cir.c                                     |    8 
 drivers/media/tuners/m88rs6000t.c                              |    6 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                       |   20 
 drivers/media/usb/dvb-usb/dvb-usb.h                            |    2 
 drivers/media/usb/em28xx/em28xx-dvb.c                          |    1 
 drivers/media/usb/gspca/gspca.c                                |    2 
 drivers/media/usb/gspca/gspca.h                                |    1 
 drivers/media/usb/gspca/sq905.c                                |    2 
 drivers/media/usb/gspca/stv06xx/stv06xx.c                      |    9 
 drivers/memory/omap-gpmc.c                                     |    7 
 drivers/mfd/stm32-timers.c                                     |    7 
 drivers/misc/aspeed-lpc-snoop.c                                |    4 
 drivers/misc/kgdbts.c                                          |   26 
 drivers/misc/lis3lv02d/lis3lv02d.c                             |   21 
 drivers/misc/vmw_vmci/vmci_doorbell.c                          |    2 
 drivers/misc/vmw_vmci/vmci_guest.c                             |    2 
 drivers/mmc/core/block.c                                       |   16 
 drivers/mmc/core/core.c                                        |    2 
 drivers/mmc/core/core.h                                        |    9 
 drivers/mmc/core/mmc.c                                         |    7 
 drivers/mmc/core/mmc_ops.c                                     |    4 
 drivers/mmc/core/sd.c                                          |    6 
 drivers/mmc/host/sdhci-pci-core.c                              |   27 
 drivers/mtd/mtdchar.c                                          |    8 
 drivers/mtd/mtdcore.c                                          |    3 
 drivers/mtd/nand/raw/atmel/nand-controller.c                   |    6 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                       |    6 
 drivers/mtd/nand/raw/fsmc_nand.c                               |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                     |    2 
 drivers/mtd/nand/raw/qcom_nandc.c                              |    7 
 drivers/mtd/nand/spi/core.c                                    |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |    4 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h          |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c             |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    2 
 drivers/net/ethernet/cisco/enic/enic_main.c                    |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c        |    2 
 drivers/net/ethernet/intel/i40e/i40e_client.c                  |    1 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                    |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                    |    1 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c              |   30 
 drivers/net/ethernet/qualcomm/emac/emac-mac.c                  |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c            |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c               |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |   14 
 drivers/net/ethernet/ti/davinci_emac.c                         |    4 
 drivers/net/fddi/Kconfig                                       |   15 
 drivers/net/fddi/defxx.c                                       |   47 
 drivers/net/geneve.c                                           |    4 
 drivers/net/wan/lapbether.c                                    |   32 
 drivers/net/wimax/i2400m/op-rfkill.c                           |    2 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                      |    3 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  |    2 
 drivers/net/wireless/ath/ath9k/hw.c                            |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c                 |    6 
 drivers/net/wireless/marvell/mwl8k.c                           |    1 
 drivers/net/wireless/mediatek/mt7601u/eeprom.c                 |    2 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c         |  500 +++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c                        |    2 
 drivers/net/wireless/wl3501.h                                  |   47 
 drivers/net/wireless/wl3501_cs.c                               |   54 -
 drivers/nfc/pn533/pn533.c                                      |    3 
 drivers/nvme/host/core.c                                       |    3 
 drivers/nvme/host/multipath.c                                  |    4 
 drivers/of/fdt.c                                               |   12 
 drivers/pci/controller/pci-thunder-ecam.c                      |    2 
 drivers/pci/controller/pci-thunder-pem.c                       |   13 
 drivers/pci/controller/pcie-iproc-msi.c                        |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c                  |    3 
 drivers/pci/hotplug/acpiphp_glue.c                             |    1 
 drivers/pci/pci.c                                              |   16 
 drivers/pci/pci.h                                              |    6 
 drivers/pci/probe.c                                            |    1 
 drivers/perf/arm_pmu_platform.c                                |    2 
 drivers/phy/marvell/Kconfig                                    |    4 
 drivers/phy/ti/phy-twl4030-usb.c                               |    2 
 drivers/pinctrl/pinctrl-ingenic.c                              |    3 
 drivers/pinctrl/samsung/pinctrl-exynos.c                       |   10 
 drivers/platform/x86/pmc_atom.c                                |   28 
 drivers/power/supply/bq27xxx_battery.c                         |   51 -
 drivers/power/supply/generic-adc-battery.c                     |    2 
 drivers/power/supply/lp8788-charger.c                          |    2 
 drivers/power/supply/pm2301_charger.c                          |    2 
 drivers/power/supply/s3c_adc_battery.c                         |    2 
 drivers/power/supply/tps65090-charger.c                        |    2 
 drivers/power/supply/tps65217_charger.c                        |    2 
 drivers/rpmsg/qcom_glink_native.c                              |    1 
 drivers/rtc/rtc-ds1307.c                                       |   12 
 drivers/scsi/device_handler/scsi_dh_alua.c                     |    5 
 drivers/scsi/ibmvscsi/ibmvfc.c                                 |   57 -
 drivers/scsi/jazz_esp.c                                        |    4 
 drivers/scsi/libfc/fc_lport.c                                  |    2 
 drivers/scsi/lpfc/lpfc_crtn.h                                  |    3 
 drivers/scsi/lpfc/lpfc_hw4.h                                   |  174 ---
 drivers/scsi/lpfc/lpfc_init.c                                  |  103 --
 drivers/scsi/lpfc/lpfc_mbox.c                                  |   36 
 drivers/scsi/lpfc/lpfc_nportdisc.c                             |   11 
 drivers/scsi/lpfc/lpfc_nvmet.c                                 |    1 
 drivers/scsi/lpfc/lpfc_sli.c                                   |    1 
 drivers/scsi/qla2xxx/qla_attr.c                                |    8 
 drivers/scsi/qla2xxx/qla_bsg.c                                 |    3 
 drivers/scsi/qla2xxx/qla_os.c                                  |    7 
 drivers/scsi/sni_53c710.c                                      |    5 
 drivers/scsi/sun3x_esp.c                                       |    4 
 drivers/soc/qcom/mdt_loader.c                                  |   17 
 drivers/soundwire/bus.c                                        |    3 
 drivers/soundwire/stream.c                                     |   10 
 drivers/spi/spi-dln2.c                                         |    2 
 drivers/spi/spi-omap-100k.c                                    |    6 
 drivers/spi/spi-ti-qspi.c                                      |   20 
 drivers/spi/spi.c                                              |    9 
 drivers/staging/erofs/erofs_fs.h                               |    3 
 drivers/staging/erofs/inode.c                                  |    6 
 drivers/staging/greybus/uart.c                                 |    2 
 drivers/staging/media/omap4iss/iss.c                           |    4 
 drivers/staging/rtl8192u/r8192U_core.c                         |    2 
 drivers/target/target_core_pscsi.c                             |    3 
 drivers/target/target_core_user.c                              |    4 
 drivers/tee/optee/core.c                                       |   10 
 drivers/thermal/fair_share.c                                   |    4 
 drivers/tty/serial/stm32-usart.c                               |   17 
 drivers/tty/serial/stm32-usart.h                               |    3 
 drivers/tty/tty_io.c                                           |    8 
 drivers/tty/vt/vt.c                                            |    1 
 drivers/usb/class/cdc-acm.c                                    |    2 
 drivers/usb/class/cdc-wdm.c                                    |   30 
 drivers/usb/core/hub.c                                         |    6 
 drivers/usb/dwc2/core.h                                        |    2 
 drivers/usb/dwc2/core_intr.c                                   |  162 +--
 drivers/usb/dwc2/gadget.c                                      |    3 
 drivers/usb/dwc2/hcd.c                                         |   10 
 drivers/usb/dwc3/dwc3-omap.c                                   |    5 
 drivers/usb/dwc3/dwc3-pci.c                                    |    1 
 drivers/usb/dwc3/gadget.c                                      |   26 
 drivers/usb/gadget/config.c                                    |    4 
 drivers/usb/gadget/function/f_fs.c                             |    3 
 drivers/usb/gadget/function/f_uac1.c                           |   43 
 drivers/usb/gadget/function/f_uvc.c                            |    7 
 drivers/usb/gadget/udc/aspeed-vhub/core.c                      |    3 
 drivers/usb/gadget/udc/aspeed-vhub/epn.c                       |    2 
 drivers/usb/gadget/udc/dummy_hcd.c                             |   23 
 drivers/usb/gadget/udc/fotg210-udc.c                           |   26 
 drivers/usb/gadget/udc/pch_udc.c                               |   49 
 drivers/usb/gadget/udc/r8a66597-udc.c                          |    2 
 drivers/usb/gadget/udc/snps_udc_plat.c                         |    4 
 drivers/usb/host/fotg210-hcd.c                                 |    4 
 drivers/usb/host/sl811-hcd.c                                   |    9 
 drivers/usb/host/xhci-ext-caps.h                               |    5 
 drivers/usb/host/xhci-mem.c                                    |    9 
 drivers/usb/host/xhci-mtk.c                                    |    3 
 drivers/usb/host/xhci-mtk.h                                    |    1 
 drivers/usb/host/xhci-pci.c                                    |    4 
 drivers/usb/host/xhci.c                                        |   20 
 drivers/usb/typec/tcpci.c                                      |   21 
 drivers/usb/usbip/vudc_sysfs.c                                 |    2 
 drivers/vfio/mdev/mdev_sysfs.c                                 |    2 
 drivers/video/fbdev/core/fbcmap.c                              |    8 
 fs/block_dev.c                                                 |   20 
 fs/btrfs/ctree.c                                               |   20 
 fs/btrfs/ioctl.c                                               |   18 
 fs/btrfs/relocation.c                                          |    6 
 fs/ceph/caps.c                                                 |    1 
 fs/ceph/inode.c                                                |    1 
 fs/cifs/smb2ops.c                                              |    2 
 fs/dlm/debug_fs.c                                              |    1 
 fs/ecryptfs/main.c                                             |    6 
 fs/ext4/ialloc.c                                               |   48 
 fs/ext4/super.c                                                |    9 
 fs/f2fs/inline.c                                               |    3 
 fs/f2fs/node.c                                                 |    3 
 fs/fuse/cuse.c                                                 |    2 
 fs/hfsplus/extents.c                                           |    7 
 fs/iomap.c                                                     |   34 
 fs/jffs2/compr_rtime.c                                         |    3 
 fs/jffs2/scan.c                                                |    2 
 fs/nfs/flexfilelayout/flexfilelayout.c                         |    2 
 fs/nfs/inode.c                                                 |    8 
 fs/nfs/nfs42proc.c                                             |   21 
 fs/nfs/pnfs.c                                                  |    7 
 fs/overlayfs/copy_up.c                                         |    3 
 fs/squashfs/file.c                                             |    6 
 fs/ubifs/replay.c                                              |    3 
 include/crypto/acompress.h                                     |    2 
 include/crypto/aead.h                                          |    2 
 include/crypto/akcipher.h                                      |    2 
 include/crypto/hash.h                                          |    4 
 include/crypto/kpp.h                                           |    2 
 include/crypto/rng.h                                           |    2 
 include/crypto/skcipher.h                                      |    2 
 include/linux/hid.h                                            |    2 
 include/linux/i2c.h                                            |    2 
 include/linux/iomap.h                                          |    1 
 include/linux/module.h                                         |   26 
 include/linux/power/bq27xxx_battery.h                          |    1 
 include/linux/smp.h                                            |    2 
 include/linux/spi/spi.h                                        |    3 
 include/linux/tty_driver.h                                     |    2 
 include/net/bluetooth/hci_core.h                               |    1 
 include/scsi/libfcoe.h                                         |    2 
 include/uapi/linux/netfilter/xt_SECMARK.h                      |    6 
 include/uapi/linux/tty_flags.h                                 |    4 
 kernel/futex.c                                                 |    3 
 kernel/irq/matrix.c                                            |    4 
 kernel/kexec_file.c                                            |    4 
 kernel/module.c                                                |   61 -
 kernel/sched/debug.c                                           |   42 
 kernel/sched/fair.c                                            |   12 
 kernel/smp.c                                                   |   10 
 kernel/time/posix-timers.c                                     |    4 
 kernel/trace/ftrace.c                                          |    5 
 kernel/trace/trace.c                                           |   41 
 kernel/trace/trace_clock.c                                     |   44 
 kernel/up.c                                                    |    2 
 lib/bug.c                                                      |   33 
 lib/kobject_uevent.c                                           |    9 
 lib/nlattr.c                                                   |    2 
 lib/stackdepot.c                                               |    6 
 mm/hugetlb.c                                                   |   11 
 mm/khugepaged.c                                                |   18 
 mm/ksm.c                                                       |    1 
 mm/memory-failure.c                                            |    2 
 mm/shmem.c                                                     |   12 
 mm/sparse.c                                                    |    1 
 net/bluetooth/ecdh_helper.h                                    |    2 
 net/bluetooth/hci_event.c                                      |    3 
 net/bluetooth/hci_request.c                                    |   12 
 net/bluetooth/l2cap_core.c                                     |    4 
 net/bluetooth/l2cap_sock.c                                     |    8 
 net/bridge/br_arp_nd_proxy.c                                   |    4 
 net/core/ethtool.c                                             |    2 
 net/hsr/hsr_framereg.c                                         |    3 
 net/ipv4/tcp_cong.c                                            |    4 
 net/ipv6/ip6_gre.c                                             |    7 
 net/ipv6/ip6_tunnel.c                                          |    3 
 net/ipv6/ip6_vti.c                                             |    3 
 net/ipv6/sit.c                                                 |    5 
 net/mac80211/main.c                                            |    7 
 net/mac80211/mlme.c                                            |    5 
 net/netfilter/nf_conntrack_standalone.c                        |    5 
 net/netfilter/nfnetlink_osf.c                                  |    2 
 net/netfilter/nft_set_hash.c                                   |   10 
 net/netfilter/xt_SECMARK.c                                     |   88 +
 net/nfc/digital_dep.c                                          |    2 
 net/nfc/llcp_sock.c                                            |    4 
 net/openvswitch/actions.c                                      |    8 
 net/sctp/sm_make_chunk.c                                       |    2 
 net/sctp/sm_statefuns.c                                        |   28 
 net/sctp/socket.c                                              |   38 
 net/smc/af_smc.c                                               |    4 
 net/tipc/netlink_compat.c                                      |    2 
 net/vmw_vsock/vmci_transport.c                                 |    3 
 net/wireless/scan.c                                            |    2 
 net/xdp/xsk_queue.h                                            |    7 
 samples/bpf/tracex1_kern.c                                     |    4 
 samples/kfifo/bytestream-example.c                             |    8 
 samples/kfifo/inttype-example.c                                |    8 
 samples/kfifo/record-example.c                                 |    8 
 scripts/bloat-o-meter                                          |    2 
 scripts/config                                                 |    2 
 scripts/diffconfig                                             |    2 
 scripts/kconfig/nconf.c                                        |    2 
 scripts/recordmcount.pl                                        |    2 
 scripts/split-man.pl                                           |    2 
 security/commoncap.c                                           |    2 
 sound/core/init.c                                              |    2 
 sound/isa/sb/emu8000.c                                         |    4 
 sound/isa/sb/sb16_csp.c                                        |    8 
 sound/pci/hda/hda_generic.c                                    |   16 
 sound/pci/hda/patch_conexant.c                                 |   14 
 sound/pci/hda/patch_realtek.c                                  |   89 -
 sound/pci/rme9652/hdsp.c                                       |    3 
 sound/pci/rme9652/hdspm.c                                      |    3 
 sound/pci/rme9652/rme9652.c                                    |    3 
 sound/soc/codecs/ak5558.c                                      |    4 
 sound/soc/codecs/rt286.c                                       |   23 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   20 
 sound/soc/samsung/tm2_wm5110.c                                 |    2 
 sound/usb/card.c                                               |   14 
 sound/usb/clock.c                                              |   18 
 sound/usb/midi.c                                               |    2 
 sound/usb/mixer.c                                              |   60 -
 sound/usb/mixer_maps.c                                         |   68 -
 sound/usb/mixer_quirks.c                                       |    6 
 sound/usb/mixer_scarlett.c                                     |   14 
 sound/usb/proc.c                                               |    2 
 sound/usb/quirks.c                                             |   16 
 sound/usb/stream.c                                             |    4 
 sound/usb/usbaudio.h                                           |    2 
 sound/usb/validate.c                                           |    4 
 tools/perf/python/tracepoint.py                                |    2 
 tools/perf/util/symbol_fprintf.c                               |    2 
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 
 tools/testing/selftests/bpf/test_offload.py                    |    2 
 tools/testing/selftests/lib.mk                                 |    4 
 tools/testing/selftests/tc-testing/tdc_batch.py                |    2 
 virt/kvm/arm/arm.c                                             |    2 
 444 files changed, 3239 insertions(+), 1822 deletions(-)

Adrian Hunter (1):
      mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers

Alexander Aring (1):
      fs: dlm: fix debugfs dump

Alexander Lobakin (1):
      mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Alexander Shishkin (2):
      intel_th: pci: Add Rocket Lake CPU support
      intel_th: pci: Add Alder Lake-M support

Alexandru Elisei (1):
      KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Alexey Kardashevskiy (1):
      powerpc/iommu: Annotate nested lock for lockdep

Andrew Scull (1):
      bug: Remove redundant condition check in report_bug

Andy Shevchenko (5):
      usb: gadget: pch_udc: Revert d3cb25a12138 completely
      usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
      usb: gadget: pch_udc: Check if driver is present before calling ->setup()
      usb: gadget: pch_udc: Check for DMA mapping error
      scripts: switch explicitly to Python 3

Anirudh Rayabharam (1):
      usb: gadget: dummy_hcd: fix gpf in gadget_setup

Archie Pusaka (3):
      Bluetooth: verify AMP hci_chan before amp_destroy
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
      Bluetooth: check for zapped sk before connecting

Ard Biesheuvel (2):
      ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld
      crypto: api - check for ERR pointers in crypto_destroy_tfm()

Arnaldo Carvalho de Melo (1):
      perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Arnd Bergmann (9):
      amdgpu: avoid incorrect %hu format string
      security: commoncap: fix -Wstringop-overread warning
      irqchip/gic-v3: Fix OF_BAD_ADDR error handling
      smp: Fix smp_call_function_single_async prototype
      x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
      kgdb: fix gcc-11 warning on indentation
      usb: sl811-hcd: improve misleading indentation
      isdn: capi: fix mismatched prototypes
      PCI: thunder: Fix compile testing

Artur Petrosyan (3):
      usb: dwc2: Fix session request interrupt handler
      usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.
      usb: dwc2: Fix hibernation between host and device modes.

Arun Easi (1):
      scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()

Athira Rajeev (1):
      powerpc/perf: Fix PMU constraint check for EBB events

Avri Altman (2):
      mmc: block: Update ext_csd.cache_ctrl if it was written
      mmc: block: Issue a cache flush only when it's enabled

Axel Rasmussen (1):
      userfaultfd: release page in error path to avoid BUG_ON

Badhri Jagan Sridharan (1):
      usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Bart Van Assche (3):
      scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      scsi: libfc: Fix a format specifier
      blk-mq: Swap two calls in blk_mq_exit_queue()

Bence Csókás (1):
      i2c: Add I2C_AQ_NO_REP_START adapter quirk

Benjamin Block (1):
      dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Bill Wendling (1):
      arm64/vdso: Discard .note.gnu.property sections in vDSO

Bjorn Andersson (2):
      soc: qcom: mdt_loader: Validate that p_filesz < p_memsz
      soc: qcom: mdt_loader: Detect truncated read of segments

Bodo Stroesser (1):
      scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Brian King (1):
      scsi: ibmvfc: Fix invalid state machine BUG_ON()

Chaitanya Kulkarni (1):
      scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Chao Yu (1):
      f2fs: fix to avoid out-of-bounds memory access

Chen Huang (1):
      powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Chen Hui (1):
      clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE

Chen Jun (1):
      posix-timers: Preserve return value in clock_adjtime32()

Christoph Hellwig (12):
      modules: mark ref_module static
      modules: mark find_symbol static
      modules: mark each_symbol_section static
      modules: unexport __module_text_address
      modules: unexport __module_address
      modules: rename the licence field in struct symsearch to license
      modules: return licensing information from find_symbol
      modules: inherit TAINT_PROPRIETARY_MODULE
      md: split mddev_find
      md: factor out a mddev_find_locked helper from mddev_find
      nvme: do not try to reconfigure APST when the controller is not live
      iomap: fix sub-page uptodate handling

Christophe JAILLET (3):
      usb: fotg210-hcd: Fix an error message
      ACPI: scan: Fix a memory leak in an error handling path
      xhci: Do not use GFP_KERNEL in (potentially) atomic context

Christophe Leroy (1):
      powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Chunfeng Yun (3):
      arm64: dts: mt8173: fix property typo of 'phys' in dsi node
      usb: xhci-mtk: support quirk to disable usb2 lpm
      usb: core: hub: fix race condition about TRSMRCY of resume

Claudio Imbrenda (2):
      KVM: s390: split kvm_s390_logical_to_effective
      KVM: s390: split kvm_s390_real_to_abs

Colin Ian King (15):
      clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
      drm/radeon: fix copy of uninitialized variable back to userspace
      memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
      staging: rtl8192u: Fix potential infinite loop
      usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
      media: vivid: fix assignment of dev->fbuf_out_flags
      media: m88rs6000t: avoid potential out-of-bounds reads on arrays
      clk: uniphier: Fix potential infinite loop
      liquidio: Fix unintented sign extension of a left shift of a u16
      mt7601u: fix always true expression
      net: thunderx: Fix unintentional sign extension issue
      ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails
      net: davinci_emac: Fix incorrect masking of tx and rx error channel
      f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
      iio: tsl2583: Fix division by a zero lux_val

Cong Wang (1):
      smc: disallow TCP_ULP in smc_setsockopt()

Dan Carpenter (9):
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      ovl: fix missing revert_creds() on error path
      mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()
      soc: aspeed: fix a ternary sign expansion bug
      HSI: core: fix resource leaks in hsi_add_client_from_dt()
      nfc: pn533: prevent potential memory corruption
      drm/i915/gvt: Fix error code in intel_gvt_init_device()
      bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
      kfifo: fix ternary sign extension bugs

Daniel Niv (1):
      media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

David Ward (2):
      ASoC: rt286: Generalize support for ALC3263 codec
      ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Davide Caratti (1):
      openvswitch: fix stack OOB read while fragmenting IPv4 packets

Dean Anderson (1):
      usb: gadget/function/f_fs string table fix for multiple languages

Dinghao Liu (1):
      iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Dmitry Baryshkov (1):
      PCI: Release OF node in pci_scan_device()'s error path

Dmitry Osipenko (1):
      iio: gyro: mpu3050: Fix reported temperature value

DooHyun Hwang (1):
      mmc: core: Do a power cycle when the CMD11 fails

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Emmanuel Grumbach (1):
      mac80211: clear the beacon's CRC after channel switch

Eric Dumazet (6):
      ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
      netfilter: nftables: avoid overflows in nft_hash_buckets()
      ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
      sit: proper dev_{hold|put} in ndo_[un]init methods
      ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
      ipv6: remove extra dev_hold() for fallback tunnels

Erwan Le Ray (2):
      serial: stm32: fix incorrect characters on console
      serial: stm32: fix tx_empty condition

Ewan D. Milne (1):
      scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Fabian Vogt (6):
      fotg210-udc: Fix DMA on EP0 for length > max packet size
      fotg210-udc: Fix EP0 IN requests bigger than two packets
      fotg210-udc: Remove a dubious condition leading to fotg210_done
      fotg210-udc: Mask GRP2 interrupts we don't handle
      fotg210-udc: Don't DMA more than the buffer can take
      fotg210-udc: Complete OUT requests on short packets

Fabrice Gasnier (1):
      mfd: stm32-timers: Avoid clearing auto reload register

Feilong Lin (1):
      ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: fix RX VLAN offload

Felix Kuehling (1):
      drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Fengnan Chang (1):
      ext4: fix error code in ext4_commit_super

Ferry Toth (1):
      usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

Filipe Manana (2):
      btrfs: fix metadata extent leak after failure to create subvolume
      btrfs: fix race when picking most recent mod log operation for an old root

Finn Behrens (1):
      tweewide: Fix most Shebang lines

Gao Xiang (1):
      erofs: add unsupported inode i_format check

Geert Uytterhoeven (1):
      phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Giovanni Cabiddu (1):
      crypto: qat - fix error path in adf_isr_resource_alloc()

Greg Kroah-Hartman (2):
      kobject_uevent: remove warning in init_uevent_argv()
      Linux 4.19.191

Guchun Chen (1):
      drm/amdgpu: fix NULL pointer dereference

Guochun Mao (1):
      ubifs: Only check replay with inode type to judge if inode linked

Gustavo A. R. Silva (4):
      sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
      ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Hannes Reinecke (1):
      nvme: retrigger ANA log update if group descriptor isn't found

Hans Verkuil (3):
      media: gspca/sq905.c: fix uninitialized variable
      media: vivid: update EDID
      media: gscpa/stv06xx: fix memory leak

Hans de Goede (7):
      extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
      misc: lis3lv02d: Fix false-positive WARN on various HP models
      ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
      ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet
      Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices
      Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state
      gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Harald Freudenberger (1):
      s390/archrandom: add parameter check for s390_arch_random_generate

He Ying (1):
      firmware: qcom-scm: Fix QCOM_SCM configuration

Heiko Carstens (1):
      KVM: s390: fix guarded storage control register handling

Heinz Mauelshagen (1):
      dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Hemant Kumar (1):
      usb: gadget: Fix double free of device descriptor pointers

Heming Zhao (1):
      md-cluster: fix use-after-free issue when removing rdev

Hoang Le (1):
      tipc: convert dest node's address to network order

Hui Wang (1):
      ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Ido Schimmel (1):
      mlxsw: spectrum_mr: Update egress RIF list before route's action

Ilya Lipnitskiy (3):
      MIPS: pci-mt7620: fix PLL lock check
      MIPS: pci-rt2880: fix slot 0 configuration
      MIPS: pci-legacy: stop using of_pci_range_to_resource

Ingo Molnar (1):
      x86/platform/uv: Fix !KEXEC build failure

James Smart (4):
      scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
      scsi: lpfc: Fix pt2pt connection does not recover after LOGO
      scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
      scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

Jan Glauber (1):
      md: Fix missing unused status line of /proc/mdstat

Jane Chu (1):
      mm/memory-failure: unnecessary amount of unmapping

Jason Gunthorpe (1):
      vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Jeff Layton (1):
      ceph: fix fscache invalidation

Jeffrey Mitchell (1):
      ecryptfs: fix kernel panic with null dev_name

Jerome Forissier (1):
      tee: optee: do not check memref size on return from Secure World

Jia Zhou (1):
      ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Jia-Ju Bai (2):
      rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()
      kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Jian Cai (1):
      arm64: vdso: remove commas between macro name and arguments

Joe Thornber (2):
      dm persistent data: packed struct should have an aligned() attribute too
      dm space map common: fix division bug in sm_ll_find_free_block()

Johan Hovold (4):
      staging: greybus: uart: fix unprivileged TIOCCSERIAL
      USB: cdc-acm: fix unprivileged TIOCCSERIAL
      tty: actually undefine superseded ASYNC flags
      tty: fix return value for unsupported ioctls

Johannes Berg (3):
      cfg80211: scan: drop entry from hidden_list on overflow
      mac80211: bail out if cipher schemes are invalid
      um: Mark all kernel symbols as local

John Millikin (1):
      x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Jonathan Cameron (1):
      iio:accel:adis16201: Fix wrong axis assignment that prevents loading

Jonathan McDowell (1):
      net: stmmac: Set FIFO sizes for ipq806x

Jonathon Reinhart (2):
      net: Only allow init netns to set default tcp cong to a restricted algo
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Jordan Niethe (1):
      powerpc/64s: Fix pte update for kernel memory on radix

Josef Bacik (1):
      btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Josh Poimboeuf (1):
      pinctrl: ingenic: Improve unreachable code generation

Jouni Roivas (1):
      hfsplus: prevent corruption in shrinking truncate

Julian Braha (1):
      media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Kai Stuhlemmer (ebee Engineering) (1):
      mtd: rawnand: atmel: Update ecc_stats.corrected counter

Kai-Heng Feng (1):
      drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

Kaixu Xia (1):
      cxgb4: Fix the -Wmisleading-indentation warning

Kees Cook (2):
      drm/radeon: Fix off-by-one power_state index heap overwrite
      drm/radeon: Avoid power table parsing memory leaks

Krzysztof Kozlowski (7):
      ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family
      ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family
      ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
      ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
      ARM: dts: exynos: correct PMIC interrupt trigger level on Snow
      pinctrl: samsung: use 'int' for register masks in Exynos

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
      arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Lin Ma (1):
      bluetooth: eliminate the potential race condition when removing the HCI controller

Linus Torvalds (1):
      Fix misc new gcc warnings

Lukasz Luba (1):
      thermal/core/fair share: Lock the thermal zone while looping over instances

Lv Yunlong (10):
      ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer
      ALSA: sb: Fix two use after free in snd_sb_qsound_build
      mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
      crypto: qat - Fix a double free in adf_create_ring
      drivers/block/null_blk/main: Fix a double free in null_init.
      mwl8k: Fix a double Free in mwl8k_probe_hw
      net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
      RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res
      net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
      ethernet:enic: Fix a use after free bug in enic_hard_start_xmit

Maciej W. Rozycki (5):
      FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR
      FDDI: defxx: Make MMIO the configuration default except for EISA
      MIPS: Reinstate platform `__div64_32' handler
      MIPS: Avoid DIVU in `__div64_32' is result would be zero
      MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej Żenczykowski (1):
      net: fix nla_strcmp to handle more then one trailing null character

Magnus Karlsson (1):
      xsk: Simplify detection of empty and full rings

Mahesh Salgaonkar (1):
      powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

Manivannan Sadhasivam (3):
      mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
      mtd: rawnand: qcom: Return actual error code instead of -ENODEV
      ARM: 9075/1: kernel: Fix interrupted SMC calls

Marc Zyngier (1):
      ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Marcel Hamer (1):
      usb: dwc3: omap: improve extcon initialization

Marek Behún (3):
      arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node
      cpufreq: armada-37xx: Fix setting TBG parent for load levels
      clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Marek Vasut (1):
      rsi: Use resume_noirq for SDIO

Marijn Suijten (1):
      drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal

Mark Langsdorf (2):
      ACPI: custom_method: fix potential use-after-free issue
      ACPI: custom_method: fix a possible memory leak

Masami Hiramatsu (1):
      x86/kprobes: Fix to check non boostable prefixes correctly

Mathias Nyman (2):
      xhci: check control context is valid before dereferencing it.
      xhci: fix potential array out of bounds with several interrupters

Matthias Schiffer (1):
      power: supply: bq27xxx: fix power_avg for newer ICs

Maxim Mikityanskiy (1):
      HID: plantronics: Workaround for double volume key presses

Maximilian Luz (1):
      usb: xhci: Increase timeout for HC halt

Meng Li (1):
      regmap: set debugfs_name to NULL after it is freed

Miaohe Lin (3):
      khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
      mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
      ksm: fix potential missing rmap_item for stable_node

Michael Ellerman (3):
      powerpc/pseries: Stop calling printk in rtas_stop_self()
      powerpc/64s: Fix crashes when toggling stf barrier
      powerpc/64s: Fix crashes when toggling entry flush barrier

Michael Kelley (1):
      Drivers: hv: vmbus: Increase wait time for VMbus unload

Michael Walle (1):
      mtd: require write permissions for locking and badblock ioctls

Mihai Moldovan (1):
      kconfig: nconf: stop endless search loops

Miklos Szeredi (1):
      cuse: prevent clone

Muhammad Usama Anjum (1):
      media: em28xx: fix memory leak

Nathan Chancellor (5):
      ACPI: CPPC: Replace cppc_attr with kobj_attribute
      x86/events/amd/iommu: Fix sysfs type mismatch
      powerpc/prom: Mark identical_pvr_fixup as __init
      scripts/recordmcount.pl: Fix RISC-V regex for clang
      riscv: Workaround mcount name prior to clang-13

Nikola Livic (1):
      pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Nikolay Aleksandrov (1):
      net: bridge: when suppression is enabled exclude RARP packets

Nobuhiro Iwamatsu (1):
      rtc: ds1307: Fix wday settings for rx8130

Odin Ugedal (1):
      sched/fair: Fix unfairness caused by missing load decay

Olga Kornievskaia (1):
      NFSv4.2 fix handling of sr_eof in SEEK's reply

Oliver Neukum (1):
      cdc-wdm: untangle a circular dependency between callback and softint

Or Cohen (1):
      net/nfc: fix use-after-free llcp_sock_bind/connect

Otavio Pontes (1):
      x86/microcode: Check for offline CPUs before requesting new microcode

Pablo Neira Ayuso (2):
      netfilter: xt_SECMARK: add new revision to fix structure layout
      netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check

Pali Rohár (6):
      cpufreq: armada-37xx: Fix the AVS value for load L1
      clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz
      clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0
      cpufreq: armada-37xx: Fix driver cleanup when registration failed
      cpufreq: armada-37xx: Fix determining base CPU frequency
      PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()

Pan Bian (1):
      bus: qcom: Put child node before return

Paul Aurich (1):
      cifs: Return correct error code from smb2_get_enc_key

Paul Clements (1):
      md/raid1: properly indicate failure when ending a failed write request

Pavel Machek (1):
      intel_th: Consistency and off-by-one fix

Pavel Skripkin (2):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init
      tty: fix memory leak in vc_deallocate

Pawel Laszczak (1):
      usb: gadget: uvc: add bInterval checking for HS mode

Paweł Chmiel (1):
      clk: exynos7: Mark aclk_fsys1_200 as critical

Peilin Ye (1):
      media: dvbdev: Fix memory leak in dvb_media_device_free()

Phil Elwell (1):
      usb: dwc2: Fix gadget DMA unmap direction

Phillip Lougher (1):
      squashfs: fix divide error in calculate_skip()

Phillip Potter (2):
      fbdev: zero-fill colormap in fbcmap.c
      net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Pierre-Louis Bossart (1):
      ASoC: samsung: tm2_wm5110: check of of_parse return value

Ping-Ke Shih (1):
      rtlwifi: 8821ae: upgrade PHY and RF parameters

Quentin Perret (2):
      Revert "of/fdt: Make sure no-map does not remove already reserved regions"
      Revert "fdt: Properly handle "no-map" field in the memory region"

Quinn Tran (1):
      scsi: qla2xxx: Fix use after free in bsg

Rafael J. Wysocki (1):
      PCI: PM: Do not read power state in pci_enable_device_flags()

Rander Wang (1):
      soundwire: stream: fix memory leak in stream config error path

Randy Dunlap (1):
      powerpc: iommu: fix build when neither PCI or IBMVIO is set

Robin Murphy (1):
      perf/arm_pmu_platform: Fix error handling

Ruslan Bilovol (1):
      usb: gadget: f_uac1: validate input parameters

Salil Mehta (1):
      net: hns3: Limiting the scope of vector_ring_chain variable

Sandeep Singh (1):
      xhci: Add reset resume quirk for AMD xhci controller.

Sean Christopherson (1):
      x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Sean Young (1):
      media: ite-cir: check for receive overflow

Sergei Trofimovich (1):
      ia64: module: fix symbolizer crash on fdescr

Sergey Shtylyov (12):
      pata_arasan_cf: fix IRQ check
      pata_ipx4xx_cf: fix IRQ check
      sata_mv: add IRQ checks
      ata: libahci_platform: fix IRQ check
      scsi: jazz_esp: Add IRQ check
      scsi: sun3x_esp: Add IRQ check
      scsi: sni_53c710: Add IRQ check
      i2c: cadence: add IRQ check
      i2c: emev2: add IRQ check
      i2c: jz4780: add IRQ check
      i2c: sh7760: add IRQ check
      i2c: sh7760: fix IRQ error path

Seunghui Lee (1):
      mmc: core: Set read only for SD cards with permanent write protect bit

Shengjiu Wang (1):
      ASoC: ak5558: correct reset polarity

Shuah Khan (1):
      ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Sindhu Devale (1):
      RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Srikar Dronamraju (1):
      powerpc/smp: Set numa node before updating mask

Srinivas Kandagatla (1):
      soundwire: bus: Fix device found flag correctly

Stefan Berger (1):
      tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Stefano Garzarella (1):
      vsock/vmci: log once the failed queue pair allocation

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Steven Rostedt (VMware) (3):
      ftrace: Handle commands when closing set_ftrace_filter file
      tracing: Map all PIDs to command lines
      tracing: Restructure trace_clock_global() to never block

Sudhakar Panneerselvam (1):
      md/bitmap: wait for external bitmap writes to complete during tear down

Taehee Yoo (1):
      hsr: use netdev_err() instead of WARN_ONCE()

Takashi Iwai (12):
      ALSA: hda/conexant: Re-order CX5066 quirk table entries
      ALSA: usb-audio: Explicitly set up the clock selector
      ALSA: usb-audio: More constifications
      ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries
      ALSA: hda/realtek: Re-order ALC269 HP quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries
      ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries
      ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices
      ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Tao Ren (1):
      usb: gadget: aspeed: fix dma map failure

Tetsuo Handa (4):
      misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct
      misc: vmw_vmci: explicitly initialize vmci_datagram payload
      ttyprintk: Add TTY hangup callback.
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Thinh Nguyen (2):
      usb: xhci: Fix port minor revision
      usb: dwc3: gadget: Fix START_TRANSFER link state check

Thomas Gleixner (2):
      Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
      KVM: x86: Cancel pvclock_gtod_work on module removal

Timo Gurr (1):
      ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Toke Høiland-Jørgensen (1):
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Tong Zhang (5):
      crypto: qat - don't release uninitialized resources
      crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init
      ALSA: hdsp: don't disable if not enabled
      ALSA: hdspm: don't disable if not enabled
      ALSA: rme9652: don't disable if not enabled

Tony Ambardar (1):
      powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Trond Myklebust (4):
      NFS: Don't discard pNFS layout segments that are marked for return
      NFSv4: Don't discard segments marked for return in _pnfs_return_layout()
      NFSv4.2: Always flush out writes in nfs42_proc_fallocate()
      NFS: Deal correctly with attribute generation counter overflow

Tudor Ambarus (1):
      spi: spi-ti-qspi: Free DMA resources

Tyrel Datwyler (1):
      powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Vasily Gorbik (1):
      s390/disassembler: increase ebpf disasm buffer size

Vineet Gupta (1):
      ARC: entry: fix off-by-one error in syscall number validation

Vitaly Kuznetsov (1):
      genirq/matrix: Prevent allocation counter corruption

Waiman Long (1):
      sched/debug: Fix cgroup_path[] serialization

Wang Wensheng (3):
      IB/hfi1: Fix error return code in parse_platform_config()
      RDMA/srpt: Fix error return code in srpt_cm_req_recv()
      mm/sparse: add the missing sparse_buffer_fini() in error branch

Wei Yongjun (2):
      spi: dln2: Fix reference leak to master
      spi: omap-100k: Fix reference leak to master

Wesley Cheng (2):
      usb: dwc3: gadget: Ignore EP queue requests during bus reset
      usb: dwc3: gadget: Return success always for kick transfer in ep queue

William A. Kennington III (1):
      spi: Fix use-after-free with devm_spi_alloc_*

Wolfram Sang (1):
      i2c: bail out early when RDWR parameters are wrong

Xie He (1):
      net: lapbether: Prevent racing when checking whether the netif is running

Xin Long (4):
      Revert "net/sctp: fix race condition in sctp_destroy_sock"
      sctp: delay auto_asconf init until binding the first addr
      sctp: do asoc update earlier in sctp_sf_do_dupcook_a
      sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Yang Yang (1):
      jffs2: check the validity of dstlen in jffs2_zlib_compress()

Yang Yingliang (10):
      phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
      power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
      power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
      media: tc358743: fix possible use-after-free in tc358743_remove()
      media: adv7604: fix possible use-after-free in adv76xx_remove()
      media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
      media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
      USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
      media: omap4iss: return error code when omap4iss_get() failed
      PCI: endpoint: Fix missing destroy_workqueue()

Yannick Vignon (1):
      net: stmmac: Do not enable RX FIFO overflow interrupts

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Ye Bin (1):
      usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

Yonghong Song (1):
      selftests: Set CC to clang in lib.mk if LLVM is set

Yufeng Mo (1):
      net: hns3: disable phy loopback setting in hclge_mac_start_phy

Yunjian Wang (1):
      i40e: Fix use-after-free in i40e_client_subtask()

Zhang Yi (2):
      ext4: fix check to prevent false positive report of incorrect used inodes
      ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

Zhao Heming (1):
      md: md_open returns -EBUSY when entering racing area

Zhen Lei (2):
      tpm: fix error return code in tpm2_get_cc_attrs_tbl()
      ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook

Zqiang (1):
      lib: stackdepot: turn depot_lock spinlock to raw_spinlock

dongjian (1):
      power: supply: Use IRQF_ONESHOT

karthik alapati (1):
      staging: wimax/i2400m: fix byte-order issue

lizhe (1):
      jffs2: Fix kasan slab-out-of-bounds problem

louis.wang (1):
      ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

shaoyunl (1):
      drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

yangerkun (1):
      block: reexpand iov_iter after read/write

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC

