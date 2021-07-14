Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4393C87A2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbhGNPfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239574AbhGNPfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79487613C9;
        Wed, 14 Jul 2021 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626276732;
        bh=Wy3Ykk0+hR+y7BC0KIzD7cfTnMQ81F+ZDVJZmAP2aSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=iJsfBpsz/FycSTK+mHMUJxaf4p9m5K1OByKYizwA8ClzdDrBE36kIwzmW0pXXZ5/b
         bAHPHnp83BBzOJNFK9AhTgGwvspjsP/CkwaTjiacKOT6w1PTsdb+f6/D2Ol6BP8cxW
         sr4SzAqBpspPZt0JomEogtKW3HszRiW4l1utq9Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.132
Date:   Wed, 14 Jul 2021 17:32:08 +0200
Message-Id: <162627672826157@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.132 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/evm                                  |   26 ++
 Documentation/admin-guide/kernel-parameters.txt                |    6 
 Documentation/hwmon/max31790.rst                               |    5 
 Makefile                                                       |    4 
 arch/arm/boot/dts/sama5d4.dtsi                                 |    2 
 arch/arm/kernel/perf_event_v7.c                                |    4 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                   |    2 
 arch/arm64/include/asm/asm-uaccess.h                           |    4 
 arch/arm64/include/asm/kernel-pgtable.h                        |    6 
 arch/arm64/include/asm/mmu_context.h                           |    8 
 arch/arm64/include/asm/pgtable.h                               |    1 
 arch/arm64/include/asm/uaccess.h                               |    4 
 arch/arm64/kernel/entry.S                                      |    6 
 arch/arm64/kernel/setup.c                                      |    2 
 arch/arm64/kernel/vmlinux.lds.S                                |    8 
 arch/arm64/mm/proc.S                                           |    2 
 arch/ia64/kernel/mca_drv.c                                     |    2 
 arch/m68k/Kconfig.machine                                      |    3 
 arch/mips/include/asm/highmem.h                                |    2 
 arch/powerpc/include/asm/cputhreads.h                          |   30 ++
 arch/powerpc/kernel/smp.c                                      |   11 
 arch/powerpc/kernel/stacktrace.c                               |   27 +-
 arch/powerpc/kvm/book3s_hv.c                                   |   13 -
 arch/powerpc/kvm/book3s_hv_builtin.c                           |    2 
 arch/powerpc/kvm/book3s_hv_nested.c                            |    3 
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                            |    2 
 arch/s390/Kconfig                                              |    2 
 arch/s390/kvm/kvm-s390.c                                       |   18 -
 arch/x86/kvm/vmx/nested.c                                      |    2 
 block/blk-merge.c                                              |    8 
 block/blk-rq-qos.h                                             |   24 ++
 block/blk-wbt.c                                                |   11 
 block/blk-wbt.h                                                |    1 
 crypto/shash.c                                                 |   18 +
 drivers/acpi/Makefile                                          |    5 
 drivers/acpi/acpi_pad.c                                        |   24 --
 drivers/acpi/acpi_tad.c                                        |   14 -
 drivers/acpi/acpica/nsrepair2.c                                |    7 
 drivers/acpi/bgrt.c                                            |   57 +---
 drivers/acpi/bus.c                                             |    1 
 drivers/acpi/device_sysfs.c                                    |   46 +--
 drivers/acpi/dock.c                                            |   26 +-
 drivers/acpi/ec.c                                              |   16 +
 drivers/acpi/power.c                                           |    9 
 drivers/acpi/processor_idle.c                                  |   40 +++
 drivers/acpi/resource.c                                        |    9 
 drivers/ata/pata_ep93xx.c                                      |    2 
 drivers/ata/pata_octeon_cf.c                                   |    5 
 drivers/ata/pata_rb532_cf.c                                    |    6 
 drivers/ata/sata_highbank.c                                    |    6 
 drivers/char/hw_random/exynos-trng.c                           |    4 
 drivers/char/pcmcia/cm4000_cs.c                                |    4 
 drivers/clk/actions/owl-s500.c                                 |   62 +++--
 drivers/clk/clk-si5341.c                                       |   19 +
 drivers/clk/meson/g12a.c                                       |    2 
 drivers/cpufreq/cpufreq.c                                      |   11 
 drivers/crypto/cavium/nitrox/nitrox_isr.c                      |    4 
 drivers/crypto/ccp/sp-pci.c                                    |    6 
 drivers/crypto/ixp4xx_crypto.c                                 |    2 
 drivers/crypto/nx/nx-842-pseries.c                             |    9 
 drivers/crypto/omap-sham.c                                     |    4 
 drivers/crypto/qat/qat_common/qat_hal.c                        |    6 
 drivers/crypto/qat/qat_common/qat_uclo.c                       |    1 
 drivers/crypto/ux500/hash/hash_core.c                          |    1 
 drivers/edac/i10nm_base.c                                      |    3 
 drivers/edac/pnd2_edac.c                                       |    3 
 drivers/edac/sb_edac.c                                         |    3 
 drivers/edac/skx_base.c                                        |    3 
 drivers/edac/ti_edac.c                                         |    1 
 drivers/extcon/extcon-max8997.c                                |    3 
 drivers/extcon/extcon-sm5502.c                                 |    1 
 drivers/firmware/stratix10-svc.c                               |   22 +
 drivers/fsi/fsi-core.c                                         |    4 
 drivers/fsi/fsi-occ.c                                          |    1 
 drivers/fsi/fsi-sbefifo.c                                      |   10 
 drivers/fsi/fsi-scom.c                                         |   16 -
 drivers/gpu/drm/qxl/qxl_dumb.c                                 |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    1 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                |   36 ++-
 drivers/hid/hid-core.c                                         |   10 
 drivers/hid/wacom_wac.h                                        |    2 
 drivers/hv/hv_util.c                                           |    4 
 drivers/hwmon/max31722.c                                       |    9 
 drivers/hwmon/max31790.c                                       |   49 ++--
 drivers/iio/accel/bma180.c                                     |   10 
 drivers/iio/accel/bma220_spi.c                                 |   10 
 drivers/iio/accel/hid-sensor-accel-3d.c                        |   13 -
 drivers/iio/accel/kxcjk-1013.c                                 |   24 +-
 drivers/iio/accel/mxc4005.c                                    |   12 -
 drivers/iio/accel/stk8312.c                                    |   12 -
 drivers/iio/accel/stk8ba50.c                                   |   17 -
 drivers/iio/adc/at91-sama5d2_adc.c                             |   33 +-
 drivers/iio/adc/hx711.c                                        |    4 
 drivers/iio/adc/mxs-lradc-adc.c                                |    3 
 drivers/iio/adc/ti-ads1015.c                                   |   12 -
 drivers/iio/adc/ti-ads8688.c                                   |    3 
 drivers/iio/adc/vf610_adc.c                                    |   10 
 drivers/iio/gyro/bmg160_core.c                                 |   10 
 drivers/iio/humidity/am2315.c                                  |   16 -
 drivers/iio/imu/adis16400.c                                    |    3 
 drivers/iio/imu/adis_buffer.c                                  |    3 
 drivers/iio/light/isl29125.c                                   |   10 
 drivers/iio/light/ltr501.c                                     |   15 -
 drivers/iio/light/tcs3414.c                                    |   10 
 drivers/iio/light/tcs3472.c                                    |   16 -
 drivers/iio/light/vcnl4035.c                                   |    3 
 drivers/iio/magnetometer/bmc150_magn.c                         |   11 
 drivers/iio/magnetometer/hmc5843.h                             |    8 
 drivers/iio/magnetometer/hmc5843_core.c                        |    4 
 drivers/iio/magnetometer/rm3100-core.c                         |    3 
 drivers/iio/potentiostat/lmp91000.c                            |    4 
 drivers/iio/proximity/as3935.c                                 |   10 
 drivers/iio/proximity/isl29501.c                               |    2 
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c              |   10 
 drivers/iio/proximity/srf08.c                                  |   14 -
 drivers/infiniband/core/uverbs_cmd.c                           |   21 +
 drivers/infiniband/hw/mlx4/qp.c                                |    9 
 drivers/infiniband/hw/mlx5/main.c                              |    4 
 drivers/infiniband/hw/mlx5/qp.c                                |    6 
 drivers/infiniband/sw/rxe/rxe_net.c                            |   10 
 drivers/infiniband/sw/rxe/rxe_qp.c                             |    1 
 drivers/infiniband/sw/rxe/rxe_resp.c                           |    2 
 drivers/input/joydev.c                                         |    2 
 drivers/input/keyboard/Kconfig                                 |    3 
 drivers/input/keyboard/hil_kbd.c                               |    1 
 drivers/input/touchscreen/usbtouchscreen.c                     |    8 
 drivers/iommu/dma-iommu.c                                      |    6 
 drivers/leds/Kconfig                                           |    1 
 drivers/leds/leds-as3645a.c                                    |    1 
 drivers/leds/leds-ktd2692.c                                    |   27 +-
 drivers/leds/leds-lm36274.c                                    |   82 +++---
 drivers/leds/leds-lm3692x.c                                    |    8 
 drivers/media/common/siano/smscoreapi.c                        |   22 -
 drivers/media/common/siano/smscoreapi.h                        |    4 
 drivers/media/common/siano/smsdvb-main.c                       |    4 
 drivers/media/dvb-core/dvb_net.c                               |   25 +-
 drivers/media/i2c/ir-kbd-i2c.c                                 |    4 
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                       |    6 
 drivers/media/i2c/s5c73m3/s5c73m3.h                            |    2 
 drivers/media/i2c/s5k4ecgx.c                                   |   10 
 drivers/media/i2c/s5k5baf.c                                    |    6 
 drivers/media/i2c/s5k6aa.c                                     |   10 
 drivers/media/i2c/tc358743.c                                   |    1 
 drivers/media/mc/Makefile                                      |    2 
 drivers/media/pci/bt8xx/bt878.c                                |    3 
 drivers/media/pci/cobalt/cobalt-driver.c                       |    1 
 drivers/media/pci/cobalt/cobalt-driver.h                       |    7 
 drivers/media/platform/exynos-gsc/gsc-m2m.c                    |    4 
 drivers/media/platform/exynos4-is/fimc-isp-video.c             |    7 
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                   |    6 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c         |    4 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c          |    8 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h          |    2 
 drivers/media/platform/s5p-cec/s5p_cec.c                       |    7 
 drivers/media/platform/s5p-g2d/g2d.c                           |    3 
 drivers/media/platform/s5p-jpeg/jpeg-core.c                    |    5 
 drivers/media/platform/sh_vou.c                                |    6 
 drivers/media/platform/sti/bdisp/Makefile                      |    2 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                  |    7 
 drivers/media/platform/sti/delta/Makefile                      |    2 
 drivers/media/platform/sti/hva/Makefile                        |    2 
 drivers/media/platform/sti/hva/hva-hw.c                        |    3 
 drivers/media/usb/au0828/au0828-core.c                         |    4 
 drivers/media/usb/cpia2/cpia2.h                                |    1 
 drivers/media/usb/cpia2/cpia2_core.c                           |   12 +
 drivers/media/usb/cpia2/cpia2_usb.c                            |   13 -
 drivers/media/usb/dvb-usb/cinergyT2-core.c                     |    2 
 drivers/media/usb/dvb-usb/cxusb.c                              |    2 
 drivers/media/usb/em28xx/em28xx-input.c                        |    8 
 drivers/media/usb/gspca/gl860/gl860.c                          |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                        |    4 
 drivers/media/v4l2-core/v4l2-fh.c                              |    1 
 drivers/memstick/host/rtsx_usb_ms.c                            |   10 
 drivers/misc/eeprom/idt_89hpesx.c                              |    8 
 drivers/mmc/core/block.c                                       |    8 
 drivers/mmc/host/sdhci-sprd.c                                  |    1 
 drivers/mmc/host/usdhi6rol0.c                                  |    1 
 drivers/mmc/host/via-sdmmc.c                                   |    3 
 drivers/mmc/host/vub300.c                                      |    2 
 drivers/mtd/nand/raw/marvell_nand.c                            |    4 
 drivers/mtd/parsers/redboot.c                                  |    7 
 drivers/net/can/peak_canfd/peak_canfd.c                        |    4 
 drivers/net/can/usb/ems_usb.c                                  |    3 
 drivers/net/ethernet/aeroflex/greth.c                          |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |    1 
 drivers/net/ethernet/emulex/benet/be_cmds.c                    |    6 
 drivers/net/ethernet/emulex/benet/be_main.c                    |    2 
 drivers/net/ethernet/ezchip/nps_enet.c                         |    4 
 drivers/net/ethernet/faraday/ftgmac100.c                       |    6 
 drivers/net/ethernet/google/gve/gve_main.c                     |    4 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                      |    9 
 drivers/net/ethernet/ibm/ibmvnic.c                             |   10 
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   24 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                |    2 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c           |   10 
 drivers/net/ieee802154/mac802154_hwsim.c                       |   11 
 drivers/net/vrf.c                                              |   14 -
 drivers/net/vxlan.c                                            |    2 
 drivers/net/wireless/ath/ath10k/mac.c                          |    1 
 drivers/net/wireless/ath/ath10k/pci.c                          |   14 -
 drivers/net/wireless/ath/ath9k/main.c                          |    5 
 drivers/net/wireless/ath/carl9170/Kconfig                      |    8 
 drivers/net/wireless/ath/wcn36xx/main.c                        |   21 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    |   37 +--
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                    |    3 
 drivers/net/wireless/marvell/mwifiex/pcie.c                    |   10 
 drivers/net/wireless/rsi/rsi_91x_hal.c                         |    6 
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                    |    3 
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                        |    3 
 drivers/net/wireless/rsi/rsi_main.h                            |    1 
 drivers/nvme/target/fc.c                                       |   10 
 drivers/of/fdt.c                                               |    8 
 drivers/of/of_reserved_mem.c                                   |    8 
 drivers/pci/controller/pci-hyperv.c                            |    3 
 drivers/perf/arm_smmuv3_pmu.c                                  |   18 -
 drivers/perf/fsl_imx8_ddr_perf.c                               |    6 
 drivers/phy/socionext/phy-uniphier-pcie.c                      |   11 
 drivers/phy/ti/phy-dm816x-usb.c                                |   17 +
 drivers/pinctrl/sh-pfc/pfc-r8a7796.c                           |    3 
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c                          |    8 
 drivers/platform/x86/toshiba_acpi.c                            |    1 
 drivers/regulator/da9052-regulator.c                           |    3 
 drivers/regulator/hi655x-regulator.c                           |   16 -
 drivers/regulator/mt6358-regulator.c                           |    2 
 drivers/regulator/uniphier-regulator.c                         |    1 
 drivers/rtc/rtc-stm32.c                                        |    6 
 drivers/s390/cio/chp.c                                         |    3 
 drivers/s390/cio/chsc.c                                        |    2 
 drivers/scsi/FlashPoint.c                                      |   32 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                           |    4 
 drivers/scsi/scsi_lib.c                                        |    1 
 drivers/soundwire/stream.c                                     |   13 -
 drivers/spi/spi-loopback-test.c                                |    2 
 drivers/spi/spi-omap-100k.c                                    |    2 
 drivers/spi/spi-sun6i.c                                        |    6 
 drivers/spi/spi-topcliff-pch.c                                 |    4 
 drivers/spi/spi.c                                              |    1 
 drivers/ssb/scan.c                                             |    1 
 drivers/ssb/sdio.c                                             |    1 
 drivers/staging/fbtft/fb_agm1264k-fl.c                         |   20 -
 drivers/staging/fbtft/fb_bd663474.c                            |    4 
 drivers/staging/fbtft/fb_ili9163.c                             |    4 
 drivers/staging/fbtft/fb_ili9320.c                             |    1 
 drivers/staging/fbtft/fb_ili9325.c                             |    4 
 drivers/staging/fbtft/fb_ili9340.c                             |    1 
 drivers/staging/fbtft/fb_s6d1121.c                             |    4 
 drivers/staging/fbtft/fb_sh1106.c                              |    1 
 drivers/staging/fbtft/fb_ssd1289.c                             |    4 
 drivers/staging/fbtft/fb_ssd1325.c                             |    2 
 drivers/staging/fbtft/fb_ssd1331.c                             |    6 
 drivers/staging/fbtft/fb_ssd1351.c                             |    1 
 drivers/staging/fbtft/fb_upd161704.c                           |    4 
 drivers/staging/fbtft/fb_watterott.c                           |    1 
 drivers/staging/fbtft/fbtft-bus.c                              |    3 
 drivers/staging/fbtft/fbtft-core.c                             |   13 -
 drivers/staging/fbtft/fbtft-io.c                               |   12 -
 drivers/staging/gdm724x/gdm_lte.c                              |   20 +
 drivers/staging/media/imx/imx-media-csi.c                      |   14 +
 drivers/staging/media/imx/imx7-mipi-csis.c                     |    6 
 drivers/staging/mt7621-dts/mt7621.dtsi                         |    2 
 drivers/staging/rtl8712/hal_init.c                             |    3 
 drivers/staging/rtl8712/usb_intf.c                             |   10 
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c                       |   19 -
 drivers/target/iscsi/cxgbit/cxgbit_target.c                    |   21 +
 drivers/tty/nozomi.c                                           |    9 
 drivers/tty/serial/8250/8250_port.c                            |   19 +
 drivers/tty/serial/8250/serial_cs.c                            |    2 
 drivers/tty/serial/mvebu-uart.c                                |   18 -
 drivers/tty/serial/sh-sci.c                                    |    8 
 drivers/usb/class/cdc-acm.c                                    |    5 
 drivers/usb/dwc2/core.c                                        |   30 +-
 drivers/usb/dwc3/core.c                                        |    3 
 drivers/usb/gadget/function/f_eem.c                            |   43 +++
 drivers/usb/gadget/function/f_fs.c                             |   65 ++---
 drivers/usb/host/xhci-mem.c                                    |    1 
 drivers/usb/typec/class.c                                      |    4 
 drivers/vfio/pci/vfio_pci.c                                    |   29 +-
 drivers/video/backlight/lm3630a_bl.c                           |    4 
 drivers/video/fbdev/imxfb.c                                    |    2 
 drivers/visorbus/visorchipset.c                                |    6 
 fs/btrfs/Kconfig                                               |    2 
 fs/btrfs/delayed-inode.c                                       |   18 +
 fs/btrfs/send.c                                                |   11 
 fs/btrfs/transaction.c                                         |    6 
 fs/btrfs/tree-log.c                                            |    1 
 fs/cifs/cifsglob.h                                             |    3 
 fs/cifs/connect.c                                              |    5 
 fs/configfs/file.c                                             |   10 
 fs/dax.c                                                       |    3 
 fs/dlm/config.c                                                |    9 
 fs/dlm/lowcomms.c                                              |    2 
 fs/ext4/extents.c                                              |    3 
 fs/ext4/extents_status.c                                       |    4 
 fs/ext4/ialloc.c                                               |   11 
 fs/ext4/mballoc.c                                              |    9 
 fs/ext4/super.c                                                |   10 
 fs/fs-writeback.c                                              |   39 ---
 fs/fuse/dev.c                                                  |   12 -
 fs/ntfs/inode.c                                                |    2 
 fs/ocfs2/filecheck.c                                           |    6 
 fs/ocfs2/stackglue.c                                           |    8 
 include/crypto/internal/hash.h                                 |    8 
 include/linux/bio.h                                            |   12 -
 include/linux/iio/common/cros_ec_sensors_core.h                |    2 
 include/linux/prandom.h                                        |    2 
 include/linux/tracepoint.h                                     |   10 
 include/media/media-dev-allocator.h                            |    2 
 include/net/ip.h                                               |   12 -
 include/net/ip6_route.h                                        |   16 +
 include/net/sch_generic.h                                      |   12 +
 include/net/tc_act/tc_vlan.h                                   |    1 
 include/net/xfrm.h                                             |    1 
 kernel/kthread.c                                               |   19 +
 kernel/locking/lockdep.c                                       |  120 +++++++++-
 kernel/rcu/tree.c                                              |    2 
 kernel/sched/core.c                                            |   43 ++-
 kernel/sched/deadline.c                                        |    2 
 kernel/sched/fair.c                                            |    8 
 kernel/sched/rt.c                                              |   17 +
 kernel/time/clocksource.c                                      |   53 +++-
 kernel/trace/bpf_trace.c                                       |    3 
 kernel/trace/trace_events_hist.c                               |    7 
 kernel/tracepoint.c                                            |   33 ++
 lib/iov_iter.c                                                 |    9 
 lib/kstrtox.c                                                  |   13 -
 lib/kstrtox.h                                                  |    2 
 lib/seq_buf.c                                                  |    4 
 lib/vsprintf.c                                                 |   82 ++++--
 mm/huge_memory.c                                               |    2 
 mm/z3fold.c                                                    |    1 
 net/bluetooth/hci_event.c                                      |   13 +
 net/bluetooth/mgmt.c                                           |    3 
 net/bpfilter/main.c                                            |    2 
 net/can/bcm.c                                                  |    7 
 net/can/gw.c                                                   |    3 
 net/can/j1939/main.c                                           |    4 
 net/can/j1939/socket.c                                         |    3 
 net/core/filter.c                                              |    4 
 net/ipv4/esp4.c                                                |    2 
 net/ipv4/fib_frontend.c                                        |    2 
 net/ipv4/route.c                                               |    3 
 net/ipv6/esp6.c                                                |    2 
 net/ipv6/exthdrs.c                                             |   31 +-
 net/mac80211/mlme.c                                            |    9 
 net/mac80211/sta_info.c                                        |    5 
 net/netfilter/nft_exthdr.c                                     |    3 
 net/netfilter/nft_osf.c                                        |    5 
 net/netfilter/nft_tproxy.c                                     |    9 
 net/netlabel/netlabel_mgmt.c                                   |   19 -
 net/sched/act_vlan.c                                           |    7 
 net/sched/cls_tcindex.c                                        |    2 
 net/sched/sch_qfq.c                                            |    8 
 net/sunrpc/sched.c                                             |   12 -
 net/tls/tls_sw.c                                               |    2 
 net/xfrm/xfrm_state.c                                          |   14 +
 samples/bpf/xdp_redirect_user.c                                |    2 
 scripts/Makefile.build                                         |    9 
 scripts/tools-support-relr.sh                                  |    3 
 security/integrity/evm/evm_main.c                              |    5 
 security/integrity/evm/evm_secfs.c                             |   13 -
 sound/pci/hda/patch_realtek.c                                  |   43 +++
 sound/pci/intel8x0.c                                           |    2 
 sound/soc/atmel/atmel-i2s.c                                    |   34 ++
 sound/soc/codecs/cs42l42.h                                     |    2 
 sound/soc/codecs/rk3328_codec.c                                |   28 +-
 sound/soc/hisilicon/hi6210-i2s.c                               |   14 -
 sound/soc/mediatek/common/mtk-btcvsd.c                         |   24 +-
 sound/soc/sh/rcar/adg.c                                        |    4 
 sound/usb/format.c                                             |    2 
 sound/usb/mixer.c                                              |    8 
 sound/usb/mixer.h                                              |    1 
 sound/usb/mixer_scarlett_gen2.c                                |    7 
 tools/bpf/bpftool/main.c                                       |    4 
 tools/perf/util/llvm-utils.c                                   |    2 
 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py   |    2 
 tools/testing/selftests/x86/protection_keys.c                  |    3 
 379 files changed, 2313 insertions(+), 1243 deletions(-)

Al Viro (2):
      copy_page_to_iter(): fix ITER_DISCARD case
      iov_iter_fault_in_readable() should do nothing in xarray case

Alex Williamson (1):
      vfio/pci: Handle concurrent vma faults

Alexander Aring (2):
      fs: dlm: cancel work sync othercon
      fs: dlm: fix memory leak when fenced

Alexander Larkin (1):
      Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl

Alexandru Ardelean (1):
      iio: at91-sama5d2_adc: remove usage of iio_priv_to_dev() helper

Alvin Šipraga (2):
      brcmfmac: fix setting of station info chains bitmask
      brcmfmac: correctly report average RSSI in station info

Andrew Gabbasov (1):
      usb: gadget: f_fs: Fix setting of device and driver data cross-references

Andy Shevchenko (8):
      net: mvpp2: Put fwnode in error case during ->probe()
      net: pch_gbe: Propagate error from devm_gpio_request_one()
      staging: fbtft: Rectify GPIO handling
      backlight: lm3630a_bl: Put fwnode in error case during ->probe()
      leds: lm3532: select regmap I2C API
      leds: lm3692x: Put fwnode in any case during ->probe()
      eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
      eeprom: idt_89hpesx: Restore printing the unsupported fwnode name

Anirudh Rayabharam (2):
      ext4: fix kernel infoleak via ext4_extent_header
      media: pvrusb2: fix warning in pvr2_i2c_core_done

Anshuman Khandual (1):
      arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan

Antoine Tenart (1):
      vrf: do not push non-ND strict packets with a source LLA through packet taps again

Ard Biesheuvel (1):
      crypto: shash - avoid comparing pointers to exported functions under CFI

Arnaldo Carvalho de Melo (1):
      perf llvm: Return -ENOMEM when asprintf() fails

Arnd Bergmann (2):
      ia64: mca_drv: fix incorrect array size calculation
      mwifiex: re-fix for unaligned accesses

Axel Lin (2):
      regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
      regulator: hi655x: Fix pass wrong pointer to config.driver_data

Bailey Forrest (1):
      gve: Fix swapped vars when fetching max queues

Bean Huo (1):
      mmc: block: Disable CMDQ on the ioctl path

Bixuan Cui (2):
      crypto: nx - add missing MODULE_DEVICE_TABLE
      EDAC/ti: Add missing MODULE_DEVICE_TABLE

Bob Pearson (1):
      RDMA/rxe: Fix qp reference counting for atomic ops

Boqun Feng (2):
      locking/lockdep: Fix the dep path printing for backwards BFS
      lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()

Boris Sukholitko (1):
      net/sched: act_vlan: Fix modify to allow 0

Bryan O'Donoghue (1):
      wcn36xx: Move hal_buf allocation to devm_kmalloc in probe

Charles Keepax (1):
      spi: Make of_register_spi_device also set the fwnode

Chris Chiu (1):
      ACPI: EC: Make more Asus laptops use ECDT _GPE

Christophe JAILLET (10):
      crypto: ccp - Fix a resource leak in an error handling path
      media: rc: i2c: Fix an error message
      video: fbdev: imxfb: Fix an error message
      brcmsmac: mac80211_if: Fix a resource leak in an error handling path
      tty: nozomi: Fix a resource leak in an error handling function
      firmware: stratix10-svc: Fix a resource leak in an error handling path
      tty: nozomi: Fix the error handling path of 'nozomi_card_init()'
      ASoC: mediatek: mtk-btcvsd: Fix an error handling path in 'mtk_btcvsd_snd_probe()'
      phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()
      leds: ktd2692: Fix an error handling path

Christophe Leroy (1):
      btrfs: disable build on platforms having page size 256K

Chung-Chiang Cheng (1):
      configfs: fix memleak in configfs_release_bin_file

Clément Lassieur (1):
      usb: dwc2: Don't reset the core after setting turnaround time

Codrin Ciubotariu (1):
      ASoC: atmel-i2s: Fix usage of capture and playback at the same time

Colin Ian King (2):
      drm: qxl: ensure surf.data is ininitialized
      fsi: core: Fix return of error values on failures

Corentin Labbe (2):
      crypto: ixp4xx - dma_unmap the correct address
      mtd: partitions: redboot: seek fis-index-block in the right node

Cristian Ciocaltea (3):
      clk: actions: Fix UART clock dividers on Owl S500 SoC
      clk: actions: Fix SD clocks factor table on Owl S500 SoC
      clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC

Daehwan Jung (1):
      ALSA: usb-audio: fix rate on Ozone Z90 USB headset

Dan Carpenter (4):
      media: au0828: fix a NULL vs IS_ERR() check
      ocfs2: fix snprintf() checking
      staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
      staging: gdm724x: check for overflow in gdm_lte_netif_rx()

Dany Madden (1):
      Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Dave Hansen (1):
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random

David Sterba (2):
      btrfs: clear defrag status of a root if starting transaction fails
      btrfs: clear log tree recovering status if starting transaction fails

Desmond Cheong Zhi Xi (1):
      ntfs: fix validity check for file name attribute

Dillon Min (1):
      media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx

Dinghao Liu (1):
      i40e: Fix error handling in i40e_vsi_open

Dmitry Torokhov (1):
      HID: do not use down_interruptible() when unbinding devices

Dongliang Mu (3):
      media: dvd_usb: memory leak in cinergyt2_fe_attach
      ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
      ieee802154: hwsim: Fix memory leak in hwsim_add_one

Dwaipayan Ray (1):
      ACPI: Use DEVICE_ATTR_<RW|RO|WO> macros

Eddie James (2):
      fsi: scom: Reset the FSI2PIB engine for any error
      fsi: occ: Don't accept response from un-initialized OCC

Elia Devito (1):
      ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx

Eric Dumazet (5):
      pkt_sched: sch_qfq: fix qfq_change_class() error path
      vxlan: add missing rcu_read_lock() in neigh_reduce()
      ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
      ipv6: exthdrs: do not blindly use init_net
      ipv6: fix out-of-bound access in ip6_parse_tlv()

Erik Kaneda (1):
      ACPICA: Fix memory leak caused by _CID repair function

Evgeny Novikov (1):
      media: st-hva: Fix potential NULL pointer dereferences

Felix Fietkau (1):
      mac80211: remove iwlwifi specific workaround that broke sta NDP tx

Filipe Manana (1):
      btrfs: send: fix invalid path for unlink operations after parent orphanization

Gary Lin (1):
      bpfilter: Specify the log level for the kmsg message

Geert Uytterhoeven (3):
      pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
      pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
      of: Fix truncation of memory sizes on 32-bit platforms

Greg Kroah-Hartman (1):
      Linux 5.4.132

Guenter Roeck (4):
      hwmon: (max31790) Report correct current pwm duty cycles
      hwmon: (max31790) Fix pwmX_enable attributes
      hwmon: (max31722) Remove non-standard ACPI device IDs
      hwmon: (max31790) Fix fan speed reporting for fan7..12

Gustavo A. R. Silva (1):
      media: siano: Fix out-of-bounds warnings in smscore_load_firmware_family2()

Haiyang Zhang (1):
      PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()

Hanjun Guo (1):
      ACPI: bus: Call kobject_put() in acpi_init() error path

Hannes Reinecke (1):
      nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_rqst()

Hannu Hartikainen (1):
      USB: cdc-acm: blacklist Heimann USB Appset device

Hans Verkuil (1):
      media: cobalt: fix race condition in setting HPD

Heiko Carstens (1):
      KVM: s390: get rid of register asm usage

Herbert Xu (1):
      crypto: nx - Fix RCU warning in nx842_OF_upd_status

Hsin-Hsiung Wang (1):
      regulator: mt6358: Fix vdram2 .vsel_mask

Hui Wang (1):
      ACPI: resources: Add checks for ACPI IRQ override

Igor Matheus Andrade Torrente (1):
      media: em28xx: Fix possible memory leak of em28xx struct

Jack Xu (2):
      crypto: qat - check return code of qat_hal_rd_rel_reg()
      crypto: qat - remove unused macro in FW loader

Jakub Kicinski (1):
      tls: prevent oversized sendfile() hangs by ignoring MSG_MORE

Jan Kara (1):
      dax: fix ENOMEM handling in grab_mapping_entry()

Jason Gerecke (1):
      HID: wacom: Correct base usage for capacitive ExpressKey status bits

Jay Fang (2):
      spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
      spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()

Jerome Brunet (1):
      clk: meson: g12a: fix gp0 and hifi ranges

Jian-Hong Pan (1):
      net: bcmgenet: Fix attaching to PYH failed on RPi 4B

Jiapeng Chong (1):
      platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()

Jing Xiangfeng (2):
      usb: typec: Add the missed altmode_id_remove() in typec_register_altmode()
      drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()

Joachim Fenkes (2):
      fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE
      fsi/sbefifo: Fix reset timeout

Joerg Roedel (1):
      iommu/dma: Fix compile warning in 32-bit builds

Johan Hovold (3):
      Input: usbtouchscreen - fix control-request directions
      media: gspca/gl860: fix zero-length control requests
      mmc: vub3000: fix control-request direction

Jonathan Cameron (29):
      iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio:accel:mxc4005: Drop unnecessary explicit casts in regmap_bulk_read calls
      iio: accel: mxc4005: Fix overread of data and alignment issue.
      iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: adc: at91-sama5d2: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: isl29501: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Josef Bacik (2):
      btrfs: fix error handling in __btrfs_update_delayed_inode
      btrfs: abort transaction if we fail to update the delayed inode

Josh Poimboeuf (1):
      kbuild: Fix objtool dependency for 'OBJECT_FILES_NON_STANDARD_<obj> := n'

Kamal Heib (1):
      RDMA/rxe: Fix failure during driver load

Krzysztof Kozlowski (1):
      mmc: sdhci-sprd: use sdhci_sprd_writew

Krzysztof Wilczyński (1):
      ACPI: sysfs: Fix a buffer overrun problem with description_show()

Kunihiko Hayashi (1):
      phy: uniphier-pcie: Fix updating phy parameters

Kuninori Morimoto (1):
      ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()

Laurent Pinchart (1):
      media: imx: imx7_mipi_csis: Fix logging of only error event counters

Leon Romanovsky (3):
      RDMA/core: Sanitize WQ state received from the userspace
      RDMA/mlx5: Don't add slave port to unaffiliated list
      RDMA/mlx5: Don't access NULL-cleared mpi pointer

Linyu Yuan (1):
      usb: gadget: eem: fix echo command packet response issue

Liu Shixin (1):
      netlabel: Fix memory leak in netlbl_mgmt_add_common

Long Li (1):
      block: return the correct bvec when checking for gaps

Luc Van Oostenryck (1):
      kbuild: run the checker after the compiler

Ludovic Desroches (1):
      ARM: dts: at91: sama5d4: fix pinctrl muxing

Luiz Augusto von Dentz (2):
      Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
      Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event

Lv Yunlong (2):
      media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
      media: exynos4-is: Fix a use after free in isp_video_release

Maciej W. Rozycki (1):
      serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates

Maciej Żenczykowski (1):
      bpf: Do not change gso_size during bpf_skb_change_proto()

Marc Kleine-Budde (1):
      iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too

Marcelo Ricardo Leitner (1):
      tc-testing: fix list handling

Marek Behún (1):
      leds: lm36274: cosmetic: rename lm36274_data to chip

Marek Szyprowski (1):
      extcon: max8997: Add missing modalias string

Marek Vasut (1):
      rsi: Assign beacon rate settings to the correct rate_info descriptor field

Mario Limonciello (1):
      ACPI: processor idle: Fix up C-state latency if not ordered

Mark Rutland (1):
      arm64: consistently use reserved_pg_dir

Martin Fuzzey (2):
      rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path
      rsi: fix AP mode with WPA failure due to encrypted EAPOL

Mateusz Palczewski (1):
      i40e: Fix autoneg disabling for non-10GBaseT links

Matti Vaittinen (1):
      extcon: extcon-max8997: Fix IRQ freeing at error path

Mauro Carvalho Chehab (11):
      media: mdk-mdp: fix pm_runtime_get_sync() usage count
      media: s5p: fix pm_runtime_get_sync() usage count
      media: sh_vou: fix pm_runtime_get_sync() usage count
      media: mtk-vcodec: fix PM runtime get logic
      media: s5p-jpeg: fix pm_runtime_get_sync() usage count
      media: sti/bdisp: fix pm_runtime_get_sync() usage count
      media: exynos-gsc: fix pm_runtime_get_sync() usage count
      media: sti: fix obj-$(config) targets
      media: dvb_net: avoid speculation from net slot
      media: siano: fix device register error path
      media: s5p_cec: decrement usage count if disabled

Miao Wang (1):
      net/ipv4: swap flow ports when validating source

Miaohe Lin (2):
      mm/huge_memory.c: don't discard hugepage if other processes are mapping it
      mm/z3fold: fix potential memory leak in z3fold_destroy_pool()

Michael Buesch (1):
      ssb: sdio: Don't overwrite const buffer if block_write fails

Michael Ellerman (1):
      powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()

Miklos Szeredi (3):
      fuse: ignore PG_workingset after stealing
      fuse: check connected before queueing on fpq->io
      fuse: reject internal errno

Mimi Zohar (1):
      evm: fix writing <securityfs>/evm overflow

Minas Harutyunyan (1):
      usb: dwc3: Fix debugfs creation flow

Ming Lei (2):
      block: fix race between adding/removing rq qos and normal IO
      block: fix discard request merge

Mirko Vogt (1):
      spi: spi-sun6i: Fix chipselect/clock bug

Muchun Song (1):
      writeback: fix obtain a reference to a freeing memcg css

Nathan Chancellor (2):
      KVM: PPC: Book3S HV: Workaround high stack usage with clang
      ACPI: bgrt: Fix CFI violation

Nicholas Piggin (1):
      powerpc: Offline CPU in stop_this_cpu()

Nick Desaulniers (1):
      Makefile: fix GDB warning with CONFIG_RELR

Nuno Sa (2):
      iio: adis_buffer: do not return ints in irq handlers
      iio: adis16400: do not return ints in irq handlers

Odin Ugedal (1):
      sched/fair: Fix ascii art by relpacing tabs

Oleksij Rempel (1):
      can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done

Oliver Hartkopp (1):
      can: gw: synchronize rcu operations before removing gw job entry

Oliver Lang (2):
      iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
      iio: ltr501: ltr501_read_ps(): add missing endianness conversion

Ondrej Zary (2):
      serial_cs: Add Option International GSM-Ready 56K/ISDN modem
      serial_cs: remove wrong GLOBETROTTER.cis entry

Pablo Neira Ayuso (3):
      netfilter: nft_exthdr: check for IPv6 packet before further processing
      netfilter: nft_osf: check for TCP packet before further processing
      netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols

Pali Rohár (5):
      serial: mvebu-uart: fix calculation of clock divisor
      ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
      serial: mvebu-uart: do not allow changing baudrate when uartclk is not available
      serial: mvebu-uart: correctly calculate minimal possible baudrate
      arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART

Pan Dong (1):
      ext4: fix avefreec in find_group_orlov

Paul E. McKenney (2):
      clocksource: Retry clock read if long delays detected
      rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()

Pavel Skripkin (9):
      media: dvb-usb: fix wrong definition
      net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
      media: cpia2: fix memory leak in cpia2_usb_probe
      net: ethernet: aeroflex: fix UAF in greth_of_remove
      net: ethernet: ezchip: fix UAF in nps_enet_remove
      net: ethernet: ezchip: fix error handling
      net: sched: fix warning in tcindex_alloc_perfect_hash
      staging: rtl8712: remove redundant check in r871xu_drv_init
      staging: rtl8712: fix memory leak in rtl871x_load_fw_cb

Petr Mladek (1):
      kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Petr Oros (1):
      Revert "be2net: disable bh with spin_lock in be_process_mcc"

Ping-Ke Shih (1):
      mac80211: remove iwlwifi specific workaround NDPs of null_response

Qais Yousef (3):
      sched/uclamp: Fix wrong implementation of cpu.uclamp.min
      sched/uclamp: Fix locking around cpu_util_update_eff()
      sched/uclamp: Fix uclamp_tg_restrict()

Quat Le (1):
      scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Rafael J. Wysocki (1):
      cpufreq: Make cpufreq_online() call driver->offline() on errors

Randy Dunlap (5):
      media: I2C: change 'RST' to "RSET" to fix multiple build errors
      m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning
      wireless: carl9170: fix LEDS build errors & warnings
      scsi: FlashPoint: Rename si_flags field
      s390: appldata depends on PROC_SYSCTL

Richard Fitzgerald (5):
      lib: vsprintf: Fix handling of number field widths in vsscanf
      random32: Fix implicit truncation warning in prandom_seed_state()
      ACPI: tables: Add custom DSDT file as makefile prerequisite
      ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
      soundwire: stream: Fix test for DP prepare complete

Robert Hancock (2):
      clk: si5341: Avoid divide errors due to bogus register contents
      clk: si5341: Update initialization magic

Roberto Sassu (2):
      evm: Execute evm_inode_init_security() only when an HMAC key is loaded
      evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded

Robin Murphy (1):
      perf/smmuv3: Don't trample existing events with global filter

Roman Gushchin (1):
      writeback, cgroup: increment isw_nr_in_flight before grabbing an inode

Sabrina Dubroca (1):
      xfrm: xfrm_state_mtu should return at least 1280 for ipv6

Sasha Neftin (1):
      e1000e: Check the PCIm state

Sean Christopherson (1):
      KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap

Sergey Shtylyov (4):
      sata_highbank: fix deferred probing
      pata_rb532_cf: fix deferred probing
      pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
      pata_ep93xx: fix deferred probing

Sergio Paracuellos (1):
      staging: mt7621-dts: fix pci address for PCI memory range

Shuah Khan (1):
      media: Fix Media Controller API config checks

Srinath Mannam (1):
      iommu/dma: Fix IOVA reserve dma ranges

Stephan Gerhold (1):
      extcon: sm5502: Drop invalid register write in sm5502_reg_data

Stephane Grosjean (1):
      can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Stephen Brennan (1):
      ext4: use ext4_grp_locked_error in mb_find_extent

Steve French (1):
      cifs: fix missing spinlock around update to ses->status

Steve Longerbeam (1):
      media: imx-csi: Skip first few frames from a BT.656 source

Steven Rostedt (VMware) (2):
      tracing/histograms: Fix parsing of "sym-offset" modifier
      tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing

Sukadev Bhattiprolu (1):
      ibmvnic: free tx_pool if tso_pool alloc fails

Suraj Jitindar Singh (1):
      KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors

Takashi Iwai (6):
      ALSA: usb-audio: Fix OOB access at proc output
      ALSA: usb-audio: scarlett2: Fix wrong resume call
      ALSA: intel8x0: Fix breakage at ac97 clock measurement
      ALSA: hda/realtek: Add another ALC236 variant support
      ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
      ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too

Thadeu Lima de Souza Cascardo (1):
      can: bcm: delay release of struct bcm_op after synchronize_rcu()

Thomas Hebb (1):
      drm/rockchip: dsi: move all lane config except LCDC mux to bind()

Tian Tao (1):
      spi: omap-100k: Fix the length judgment problem

Tong Tiangen (1):
      crypto: nitrox - fix unchecked variable in nitrox_register_interrupts

Tong Zhang (1):
      memstick: rtsx_usb_ms: fix UAF

Tony Luck (1):
      EDAC/Intel: Do not load EDAC driver when running as a guest

Vadim Fedorenko (1):
      net: lwtunnel: handle MTU calculation in forwading

Varun Prakash (1):
      scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cmd()

Vincent Donnefort (2):
      sched/rt: Fix RT utilization tracking during policy change
      sched/rt: Fix Deadline utilization tracking during policy change

Vineeth Vijayan (1):
      s390/cio: dont call css_wait_for_slow_path() inside a lock

Wang Hai (1):
      samples/bpf: Fix the error return code of xdp_redirect's main()

Wei Li (1):
      MIPS: Fix PKMAP with 32-bit MIPS huge page support

Yang Jihong (1):
      arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode

Yang Li (1):
      ath10k: Fix an error code in ath10k_add_interface()

Yang Yingliang (8):
      ext4: return error code when ext4_fill_flex_info() fails
      net: ftgmac100: add missing error return code in ftgmac100_probe()
      drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()
      ath10k: go to path err_unsupported when chip id is not supported
      ath10k: add missing error return code in ath10k_pci_probe()
      ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_platform_probe()
      ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()
      mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()

Yoshihiro Shimoda (1):
      serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()

Yu Kuai (1):
      char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_protocol()

YueHaibing (1):
      hv_utils: Fix passing zero to 'PTR_ERR' warning

Yun Zhou (1):
      seq_buf: Make trace_seq_putmem_hex() support data longer than 8

Yunsheng Lin (1):
      net: sched: add barrier to ensure correct ordering for lockless qdisc

Zhang Qilong (1):
      crypto: omap-sham - Fix PM reference leak in omap sham ops

Zhang Xiaoxu (2):
      SUNRPC: Fix the batch tasks count wraparound.
      SUNRPC: Should wake up the privileged task firstly.

Zhang Yi (5):
      ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle
      ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
      ext4: remove check for zero nr_to_scan in ext4_es_scan()
      blk-wbt: introduce a new disable state to prevent false positive by rwb_enabled()
      blk-wbt: make sure throttle is enabled properly

Zhangjiantao (Kirin, nanjing) (1):
      xhci: solve a double free problem while doing s4

Zhen Lei (9):
      crypto: ux500 - Fix error return code in hash_hw_final()
      media: tc358743: Fix error return code in tc358743_probe_of()
      mmc: usdhi6rol0: fix error return code in usdhi6_probe()
      ehea: fix error return code in ehea_restart_qps()
      ssb: Fix error return code in ssb_bus_scan()
      Input: hil_kbd - fix error return code in hil_dev_connect()
      visorbus: fix error return code in visorchipset_init()
      scsi: mpt3sas: Fix error return value in _scsih_expander_add()
      leds: as3645a: Fix error return code in as3645a_parse_node()

Zheyu Ma (2):
      media: bt8xx: Fix a missing check bug in bt878_probe
      mmc: via-sdmmc: add a check against NULL pointer dereference

Zhihao Cheng (1):
      tools/bpftool: Fix error return code in do_batch()

Zou Wei (1):
      regulator: uniphier: Add missing MODULE_DEVICE_TABLE

frank zago (1):
      iio: light: tcs3472: do not free unallocated IRQ

zhangyi (F) (1):
      block_dump: remove block_dump feature in mark_inode_dirty()

Łukasz Stelmach (1):
      hwrng: exynos - Fix runtime PM imbalance on error

