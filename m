Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF32B3CFD09
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 17:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbhGTO1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 10:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239344AbhGTOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF0C6101E;
        Tue, 20 Jul 2021 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626792113;
        bh=f3yKOUHRuv4T6u2uBUNKwhvbek6CNII6tfHPno7FyjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DDTEEPy3AxZE/238dIGErvaXnJTih3DA3Tk0NuoYw+FTIC/J/pnBYDo1gFR7AHjPI
         el4NfzUEt/wlAHVl3qq9akiWZjdsMO3cjsPU+48xDao+ejCWW7Os8ZTvv5ShV5AnL1
         DCUyi52VfoiID+4JokOudyFsQMlcOqXGbeNdGAqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.240
Date:   Tue, 20 Jul 2021 16:41:46 +0200
Message-Id: <1626792107180179@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.240 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/am335x-cm-t335.dts                           |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                                |   18 +-
 arch/arm/boot/dts/exynos5422-odroidxu4.dts                     |    2 
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi                |    4 
 arch/arm/boot/dts/r8a7779-marzen.dts                           |    2 
 arch/arm/boot/dts/r8a7779.dtsi                                 |    1 
 arch/arm/boot/dts/sama5d4.dtsi                                 |    2 
 arch/arm/probes/kprobes/test-thumb.c                           |   10 -
 arch/hexagon/kernel/vmlinux.lds.S                              |    7 
 arch/ia64/kernel/mca_drv.c                                     |    2 
 arch/mips/boot/compressed/Makefile                             |    4 
 arch/mips/boot/compressed/decompress.c                         |    2 
 arch/mips/include/asm/hugetlb.h                                |    8 
 arch/mips/include/asm/pgalloc.h                                |   10 -
 arch/mips/vdso/vdso.h                                          |    2 
 arch/powerpc/boot/devtree.c                                    |   59 ++++---
 arch/powerpc/boot/ns16550.c                                    |    9 -
 arch/powerpc/include/asm/barrier.h                             |    2 
 arch/powerpc/include/asm/ps3.h                                 |    2 
 arch/powerpc/platforms/ps3/mm.c                                |   12 +
 arch/s390/Kconfig                                              |    2 
 arch/s390/kernel/setup.c                                       |    2 
 arch/um/drivers/chan_user.c                                    |    3 
 arch/um/drivers/slip_user.c                                    |    3 
 arch/x86/include/asm/fpu/internal.h                            |   19 +-
 arch/x86/kernel/fpu/regset.c                                   |    2 
 arch/x86/kvm/cpuid.c                                           |    8 
 arch/x86/kvm/x86.c                                             |    2 
 crypto/shash.c                                                 |   18 +-
 drivers/acpi/Makefile                                          |    5 
 drivers/acpi/acpi_amba.c                                       |    1 
 drivers/acpi/acpi_video.c                                      |    9 +
 drivers/acpi/acpica/nsrepair2.c                                |    7 
 drivers/acpi/bus.c                                             |    1 
 drivers/acpi/device_sysfs.c                                    |    2 
 drivers/acpi/ec.c                                              |   16 +
 drivers/acpi/processor_idle.c                                  |   40 ++++
 drivers/ata/ahci_sunxi.c                                       |    2 
 drivers/ata/pata_ep93xx.c                                      |    2 
 drivers/ata/pata_octeon_cf.c                                   |    5 
 drivers/ata/pata_rb532_cf.c                                    |    6 
 drivers/ata/sata_highbank.c                                    |    6 
 drivers/atm/iphase.c                                           |    2 
 drivers/atm/nicstar.c                                          |   26 +--
 drivers/block/virtio_blk.c                                     |    2 
 drivers/bluetooth/btusb.c                                      |    5 
 drivers/char/ipmi/ipmi_watchdog.c                              |   22 +-
 drivers/char/pcmcia/cm4000_cs.c                                |    4 
 drivers/char/virtio_console.c                                  |    4 
 drivers/clk/renesas/r8a77995-cpg-mssr.c                        |    1 
 drivers/clk/tegra/clk-pll.c                                    |    6 
 drivers/crypto/ccp/sp-pci.c                                    |    6 
 drivers/crypto/ixp4xx_crypto.c                                 |    2 
 drivers/crypto/nx/nx-842-pseries.c                             |    9 -
 drivers/crypto/qat/qat_common/qat_hal.c                        |    6 
 drivers/crypto/qat/qat_common/qat_uclo.c                       |    1 
 drivers/crypto/ux500/hash/hash_core.c                          |    1 
 drivers/extcon/extcon-max8997.c                                |    1 
 drivers/extcon/extcon-sm5502.c                                 |    1 
 drivers/firmware/qemu_fw_cfg.c                                 |    8 
 drivers/gpio/gpio-zynq.c                                       |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |    2 
 drivers/gpu/drm/mxsfb/Kconfig                                  |    1 
 drivers/gpu/drm/qxl/qxl_dumb.c                                 |    2 
 drivers/gpu/drm/radeon/radeon_display.c                        |    1 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    1 
 drivers/gpu/drm/virtio/virtgpu_kms.c                           |    1 
 drivers/gpu/drm/zte/Kconfig                                    |    1 
 drivers/hid/hid-core.c                                         |   10 -
 drivers/hid/wacom_wac.h                                        |    2 
 drivers/hv/hv_util.c                                           |    4 
 drivers/hwmon/max31722.c                                       |    9 -
 drivers/hwmon/max31790.c                                       |    2 
 drivers/hwtracing/intel_th/core.c                              |   17 ++
 drivers/hwtracing/intel_th/gth.c                               |   16 +
 drivers/hwtracing/intel_th/intel_th.h                          |    3 
 drivers/i2c/i2c-core-base.c                                    |    3 
 drivers/iio/accel/bma180.c                                     |   10 -
 drivers/iio/accel/bma220_spi.c                                 |   10 -
 drivers/iio/accel/hid-sensor-accel-3d.c                        |   13 -
 drivers/iio/accel/kxcjk-1013.c                                 |   24 +-
 drivers/iio/accel/stk8312.c                                    |   12 -
 drivers/iio/accel/stk8ba50.c                                   |   17 --
 drivers/iio/adc/mxs-lradc-adc.c                                |    3 
 drivers/iio/adc/ti-ads1015.c                                   |   12 -
 drivers/iio/adc/vf610_adc.c                                    |   10 -
 drivers/iio/gyro/bmg160_core.c                                 |   10 -
 drivers/iio/humidity/am2315.c                                  |   16 +
 drivers/iio/imu/adis_buffer.c                                  |    3 
 drivers/iio/light/isl29125.c                                   |   10 -
 drivers/iio/light/ltr501.c                                     |   15 +
 drivers/iio/light/tcs3414.c                                    |   10 -
 drivers/iio/potentiostat/lmp91000.c                            |    4 
 drivers/iio/proximity/as3935.c                                 |   10 -
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c              |   10 -
 drivers/iio/proximity/srf08.c                                  |   14 -
 drivers/infiniband/core/cma.c                                  |    3 
 drivers/infiniband/hw/cxgb4/qp.c                               |    1 
 drivers/infiniband/sw/rxe/rxe_mr.c                             |    2 
 drivers/infiniband/sw/rxe/rxe_net.c                            |   10 -
 drivers/input/joydev.c                                         |    2 
 drivers/input/keyboard/hil_kbd.c                               |    1 
 drivers/input/touchscreen/usbtouchscreen.c                     |    8 
 drivers/ipack/carriers/tpci200.c                               |    5 
 drivers/isdn/hardware/mISDN/hfcpci.c                           |    2 
 drivers/leds/leds-as3645a.c                                    |    1 
 drivers/leds/leds-ktd2692.c                                    |   27 ++-
 drivers/md/persistent-data/dm-btree-remove.c                   |    3 
 drivers/md/persistent-data/dm-space-map-disk.c                 |    9 -
 drivers/md/persistent-data/dm-space-map-metadata.c             |    9 -
 drivers/media/common/siano/smscoreapi.c                        |   22 +-
 drivers/media/common/siano/smscoreapi.h                        |    4 
 drivers/media/common/siano/smsdvb-main.c                       |    4 
 drivers/media/dvb-core/dvb_net.c                               |   25 ++-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                       |    6 
 drivers/media/i2c/s5c73m3/s5c73m3.h                            |    2 
 drivers/media/i2c/s5k4ecgx.c                                   |   10 -
 drivers/media/i2c/s5k5baf.c                                    |    6 
 drivers/media/i2c/s5k6aa.c                                     |   10 -
 drivers/media/i2c/tc358743.c                                   |    1 
 drivers/media/pci/bt8xx/bt878.c                                |    3 
 drivers/media/pci/cobalt/cobalt-driver.c                       |    1 
 drivers/media/pci/cobalt/cobalt-driver.h                       |    7 
 drivers/media/platform/exynos4-is/fimc-isp-video.c             |    7 
 drivers/media/platform/s5p-cec/s5p_cec.c                       |    2 
 drivers/media/platform/s5p-g2d/g2d.c                           |    3 
 drivers/media/platform/sti/hva/hva-hw.c                        |    3 
 drivers/media/usb/cpia2/cpia2.h                                |    1 
 drivers/media/usb/cpia2/cpia2_core.c                           |   12 +
 drivers/media/usb/cpia2/cpia2_usb.c                            |   13 -
 drivers/media/usb/dvb-usb/cinergyT2-core.c                     |    2 
 drivers/media/usb/dvb-usb/cxusb.c                              |    2 
 drivers/media/usb/dvb-usb/dtv5100.c                            |    7 
 drivers/media/usb/em28xx/em28xx-input.c                        |    8 
 drivers/media/usb/gspca/sq905.c                                |    2 
 drivers/media/usb/gspca/sunplus.c                              |    8 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                        |    4 
 drivers/media/usb/uvc/uvc_video.c                              |   27 +++
 drivers/media/usb/zr364xx/zr364xx.c                            |    1 
 drivers/media/v4l2-core/v4l2-fh.c                              |    1 
 drivers/memory/atmel-ebi.c                                     |    4 
 drivers/memory/fsl_ifc.c                                       |    8 
 drivers/mfd/da9052-i2c.c                                       |    1 
 drivers/mfd/stmpe-i2c.c                                        |    2 
 drivers/misc/eeprom/idt_89hpesx.c                              |    1 
 drivers/misc/ibmasm/module.c                                   |    5 
 drivers/mmc/core/core.c                                        |    7 
 drivers/mmc/core/sd.c                                          |   10 -
 drivers/mmc/host/sdhci.c                                       |    4 
 drivers/mmc/host/sdhci.h                                       |    1 
 drivers/mmc/host/usdhi6rol0.c                                  |    1 
 drivers/mmc/host/via-sdmmc.c                                   |    3 
 drivers/mmc/host/vub300.c                                      |    2 
 drivers/net/can/peak_canfd/peak_canfd.c                        |    4 
 drivers/net/can/usb/ems_usb.c                                  |    3 
 drivers/net/ethernet/aeroflex/greth.c                          |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |    1 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                   |    4 
 drivers/net/ethernet/ezchip/nps_enet.c                         |    4 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                      |    9 -
 drivers/net/ethernet/ibm/ibmvnic.c                             |    5 
 drivers/net/ethernet/intel/e100.c                              |   12 -
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    2 
 drivers/net/ethernet/micrel/ks8842.c                           |    4 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c           |   29 +--
 drivers/net/ethernet/sfc/ef10_sriov.c                          |   25 +--
 drivers/net/fjes/fjes_main.c                                   |    4 
 drivers/net/virtio_net.c                                       |    7 
 drivers/net/vxlan.c                                            |    2 
 drivers/net/wireless/ath/ath10k/mac.c                          |    1 
 drivers/net/wireless/ath/ath9k/main.c                          |    5 
 drivers/net/wireless/ath/carl9170/Kconfig                      |    8 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |   24 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c                    |   10 -
 drivers/net/wireless/rsi/rsi_91x_hal.c                         |    4 
 drivers/net/wireless/st/cw1200/cw1200_sdio.c                   |    1 
 drivers/net/wireless/ti/wl1251/cmd.c                           |    9 -
 drivers/net/wireless/ti/wl12xx/main.c                          |    7 
 drivers/of/fdt.c                                               |    8 
 drivers/of/of_reserved_mem.c                                   |    8 
 drivers/pci/host/pci-aardvark.c                                |   59 +++++--
 drivers/pci/pci-label.c                                        |    2 
 drivers/phy/ti/phy-dm816x-usb.c                                |   17 +-
 drivers/pinctrl/pinctrl-amd.c                                  |    1 
 drivers/platform/x86/toshiba_acpi.c                            |    1 
 drivers/power/reset/gpio-poweroff.c                            |    1 
 drivers/power/supply/Kconfig                                   |    3 
 drivers/power/supply/ab8500_btemp.c                            |    1 
 drivers/power/supply/ab8500_charger.c                          |   19 ++
 drivers/power/supply/ab8500_fg.c                               |    1 
 drivers/power/supply/charger-manager.c                         |    1 
 drivers/power/supply/max17042_battery.c                        |    2 
 drivers/power/supply/rt5033_battery.c                          |    7 
 drivers/pwm/pwm-spear.c                                        |    4 
 drivers/pwm/pwm-tegra.c                                        |   13 -
 drivers/regulator/da9052-regulator.c                           |    3 
 drivers/reset/core.c                                           |    5 
 drivers/reset/reset-a10sr.c                                    |    1 
 drivers/rtc/rtc-proc.c                                         |    4 
 drivers/rtc/rtc-stm32.c                                        |    6 
 drivers/s390/char/sclp_vt220.c                                 |    4 
 drivers/s390/cio/chp.c                                         |    3 
 drivers/s390/cio/chsc.c                                        |    2 
 drivers/scsi/FlashPoint.c                                      |   32 +--
 drivers/scsi/be2iscsi/be_main.c                                |    5 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                               |    2 
 drivers/scsi/cxgbi/libcxgbi.c                                  |    4 
 drivers/scsi/hosts.c                                           |    4 
 drivers/scsi/libiscsi.c                                        |    7 
 drivers/scsi/lpfc/lpfc_els.c                                   |    9 +
 drivers/scsi/lpfc/lpfc_sli.c                                   |    5 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                           |    4 
 drivers/scsi/qedi/qedi_fw.c                                    |    2 
 drivers/scsi/qedi/qedi_main.c                                  |    2 
 drivers/scsi/scsi_lib.c                                        |    1 
 drivers/scsi/scsi_transport_iscsi.c                            |   12 +
 drivers/spi/spi-loopback-test.c                                |    2 
 drivers/spi/spi-omap-100k.c                                    |    2 
 drivers/spi/spi-sun6i.c                                        |    6 
 drivers/spi/spi-topcliff-pch.c                                 |    4 
 drivers/spi/spi.c                                              |    1 
 drivers/ssb/sdio.c                                             |    1 
 drivers/staging/gdm724x/gdm_lte.c                              |   20 +-
 drivers/staging/rtl8723bs/hal/odm.h                            |    5 
 drivers/tty/nozomi.c                                           |    9 -
 drivers/tty/serial/8250/serial_cs.c                            |   13 +
 drivers/tty/serial/fsl_lpuart.c                                |    3 
 drivers/tty/serial/sh-sci.c                                    |    8 
 drivers/usb/class/cdc-acm.c                                    |    5 
 drivers/usb/gadget/function/f_eem.c                            |   43 ++++-
 drivers/usb/gadget/function/f_fs.c                             |   67 +++-----
 drivers/usb/gadget/function/f_hid.c                            |    2 
 drivers/usb/gadget/legacy/hid.c                                |    4 
 drivers/video/backlight/lm3630a_bl.c                           |   12 -
 drivers/w1/slaves/w1_ds2438.c                                  |    4 
 drivers/watchdog/aspeed_wdt.c                                  |    2 
 drivers/watchdog/iTCO_wdt.c                                    |   12 +
 drivers/watchdog/lpc18xx_wdt.c                                 |    2 
 drivers/watchdog/sbc60xxwdt.c                                  |    2 
 drivers/watchdog/sc520_wdt.c                                   |    2 
 drivers/watchdog/w83877f_wdt.c                                 |    2 
 fs/btrfs/Kconfig                                               |    2 
 fs/btrfs/delayed-inode.c                                       |   18 +-
 fs/btrfs/send.c                                                |   11 +
 fs/btrfs/transaction.c                                         |    6 
 fs/btrfs/tree-log.c                                            |    1 
 fs/ceph/addr.c                                                 |   10 -
 fs/configfs/file.c                                             |   10 -
 fs/crypto/fname.c                                              |    9 -
 fs/dlm/config.c                                                |    9 +
 fs/dlm/lowcomms.c                                              |    2 
 fs/ext4/extents.c                                              |    3 
 fs/ext4/extents_status.c                                       |    4 
 fs/ext4/ialloc.c                                               |   11 -
 fs/ext4/mballoc.c                                              |    9 -
 fs/ext4/super.c                                                |    9 -
 fs/f2fs/super.c                                                |    1 
 fs/fs-writeback.c                                              |   34 ----
 fs/fuse/dev.c                                                  |   11 +
 fs/jfs/inode.c                                                 |    3 
 fs/jfs/jfs_logmgr.c                                            |    1 
 fs/nfs/inode.c                                                 |    4 
 fs/nfs/nfs3proc.c                                              |    4 
 fs/nfs/pnfs_nfs.c                                              |   52 +++---
 fs/ntfs/inode.c                                                |    2 
 fs/ocfs2/filecheck.c                                           |    6 
 fs/ocfs2/stackglue.c                                           |    8 
 fs/orangefs/super.c                                            |    2 
 fs/reiserfs/journal.c                                          |   14 +
 fs/seq_file.c                                                  |    3 
 fs/ubifs/dir.c                                                 |    7 
 fs/udf/namei.c                                                 |    4 
 include/crypto/internal/hash.h                                 |    8 
 include/linux/mfd/abx500/ux500_chargalg.h                      |    2 
 include/linux/nfs_fs.h                                         |    1 
 include/linux/prandom.h                                        |    2 
 include/net/sctp/structs.h                                     |    2 
 include/scsi/scsi_transport_iscsi.h                            |    2 
 kernel/cpu.c                                                   |   49 +++++
 kernel/trace/trace.c                                           |   38 +---
 kernel/trace/trace_events_hist.c                               |    6 
 lib/decompress_unlz4.c                                         |    8 
 lib/iov_iter.c                                                 |    2 
 lib/kstrtox.c                                                  |   13 +
 lib/kstrtox.h                                                  |    2 
 lib/seq_buf.c                                                  |    8 
 lib/vsprintf.c                                                 |   82 +++++-----
 mm/backing-dev.c                                               |    4 
 mm/huge_memory.c                                               |    2 
 net/bluetooth/hci_core.c                                       |   16 -
 net/bluetooth/mgmt.c                                           |    6 
 net/bridge/br_multicast.c                                      |    2 
 net/can/bcm.c                                                  |    7 
 net/can/gw.c                                                   |    3 
 net/core/dev.c                                                 |   11 +
 net/ipv6/output_core.c                                         |   28 ---
 net/mac80211/rx.c                                              |    2 
 net/netfilter/nft_exthdr.c                                     |    3 
 net/netlabel/netlabel_mgmt.c                                   |   19 +-
 net/sched/cls_tcindex.c                                        |    2 
 net/sched/sch_qfq.c                                            |    8 
 net/sctp/bind_addr.c                                           |   19 +-
 net/sctp/input.c                                               |    8 
 net/sctp/ipv6.c                                                |    7 
 net/sctp/protocol.c                                            |    7 
 net/sctp/sm_make_chunk.c                                       |   29 +--
 net/sunrpc/sched.c                                             |   12 +
 net/vmw_vsock/af_vsock.c                                       |    2 
 net/wireless/wext-spy.c                                        |   14 -
 net/xfrm/xfrm_user.c                                           |   28 +--
 samples/bpf/xdp_redirect_user.c                                |    2 
 security/selinux/avc.c                                         |   13 -
 security/smack/smackfs.c                                       |    2 
 sound/firewire/Kconfig                                         |    5 
 sound/firewire/bebob/bebob.c                                   |    5 
 sound/firewire/oxfw/oxfw.c                                     |    2 
 sound/isa/cmi8330.c                                            |    2 
 sound/isa/sb/sb16_csp.c                                        |    8 
 sound/pci/hda/hda_tegra.c                                      |    3 
 sound/ppc/powermac.c                                           |    6 
 sound/soc/codecs/cs42l42.h                                     |    2 
 sound/soc/hisilicon/hi6210-i2s.c                               |   14 -
 sound/soc/soc-core.c                                           |    2 
 sound/soc/tegra/tegra_alc5632.c                                |    1 
 sound/soc/tegra/tegra_max98090.c                               |    1 
 sound/soc/tegra/tegra_rt5640.c                                 |    1 
 sound/soc/tegra/tegra_rt5677.c                                 |    1 
 sound/soc/tegra/tegra_sgtl5000.c                               |    1 
 sound/soc/tegra/tegra_wm8753.c                                 |    1 
 sound/soc/tegra/tegra_wm8903.c                                 |    1 
 sound/soc/tegra/tegra_wm9712.c                                 |    1 
 sound/soc/tegra/trimslice.c                                    |    1 
 sound/usb/format.c                                             |    2 
 tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c      |    2 
 tools/testing/selftests/x86/protection_keys.c                  |    3 
 337 files changed, 1684 insertions(+), 884 deletions(-)

Al Cooper (1):
      mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Al Viro (1):
      iov_iter_fault_in_readable() should do nothing in xarray case

Alexander Aring (2):
      fs: dlm: cancel work sync othercon
      fs: dlm: fix memory leak when fenced

Alexander Larkin (1):
      Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl

Alexander Shishkin (1):
      intel_th: Wait until port is in reset before programming it

Andrew Gabbasov (1):
      usb: gadget: f_fs: Fix setting of device and driver data cross-references

Andy Shevchenko (3):
      net: pch_gbe: Propagate error from devm_gpio_request_one()
      eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
      net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Anirudh Rayabharam (2):
      ext4: fix kernel infoleak via ext4_extent_header
      media: pvrusb2: fix warning in pvr2_i2c_core_done

Ard Biesheuvel (1):
      crypto: shash - avoid comparing pointers to exported functions under CFI

Arnd Bergmann (3):
      ia64: mca_drv: fix incorrect array size calculation
      mwifiex: re-fix for unaligned accesses
      mips: always link byteswap helpers into decompressor

Arturo Giusti (1):
      udf: Fix NULL pointer dereference in udf_symlink function

Aswath Govindraju (1):
      ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema

Athira Rajeev (1):
      selftests/powerpc: Fix "no_handler" EBB selftest

Axel Lin (1):
      regulator: da9052: Ensure enough delay time for .set_voltage_time_sel

Benjamin Drung (1):
      media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Benjamin Herrenschmidt (1):
      powerpc/boot: Fixup device-tree on little endian

Bibo Mao (1):
      hugetlb: clear huge pte during flush function on mips platform

Bixuan Cui (2):
      crypto: nx - add missing MODULE_DEVICE_TABLE
      power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Chao Yu (1):
      f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs

Charles Keepax (1):
      spi: Make of_register_spi_device also set the fwnode

Chris Chiu (1):
      ACPI: EC: Make more Asus laptops use ECDT _GPE

Christian Löhle (1):
      mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Christophe JAILLET (8):
      crypto: ccp - Fix a resource leak in an error handling path
      brcmsmac: mac80211_if: Fix a resource leak in an error handling path
      tty: nozomi: Fix a resource leak in an error handling function
      tty: nozomi: Fix the error handling path of 'nozomi_card_init()'
      phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()
      leds: ktd2692: Fix an error handling path
      tty: serial: 8250: serial_cs: Fix a memory leak in error handling path
      scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Christophe Leroy (1):
      btrfs: disable build on platforms having page size 256K

Chung-Chiang Cheng (1):
      configfs: fix memleak in configfs_release_bin_file

Colin Ian King (1):
      drm: qxl: ensure surf.data is ininitialized

Corentin Labbe (1):
      crypto: ixp4xx - dma_unmap the correct address

Daehwan Jung (1):
      ALSA: usb-audio: fix rate on Ozone Z90 USB headset

Dan Carpenter (4):
      ocfs2: fix snprintf() checking
      staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
      staging: gdm724x: check for overflow in gdm_lte_netif_rx()
      rtc: fix snprintf() checking in is_rtc_hctosys()

Dany Madden (1):
      Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Dave Hansen (1):
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random

David Sterba (2):
      btrfs: clear defrag status of a root if starting transaction fails
      btrfs: clear log tree recovering status if starting transaction fails

Davis Mosenkovs (1):
      mac80211: fix memory corruption in EAPOL handling

Desmond Cheong Zhi Xi (1):
      ntfs: fix validity check for file name attribute

Dillon Min (1):
      media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx

Dimitri John Ledkov (1):
      lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Dinghao Liu (1):
      i40e: Fix error handling in i40e_vsi_open

Dmitry Osipenko (2):
      clk: tegra: Ensure that PLLU configuration is applied properly
      ASoC: tegra: Set driver_name=tegra for all machine drivers

Dmitry Torokhov (2):
      HID: do not use down_interruptible() when unbinding devices
      i2c: core: Disable client irq on reboot/shutdown

Dongliang Mu (1):
      media: dvd_usb: memory leak in cinergyt2_fe_attach

Eric Biggers (1):
      fscrypt: don't ignore minor_hash when hash is 0

Eric Dumazet (2):
      pkt_sched: sch_qfq: fix qfq_change_class() error path
      vxlan: add missing rcu_read_lock() in neigh_reduce()

Eric Sandeen (1):
      seq_file: disallow extremely large seq buffer allocations

Erik Kaneda (1):
      ACPICA: Fix memory leak caused by _CID repair function

Evgeny Novikov (1):
      media: st-hva: Fix potential NULL pointer dereferences

Fabio Aiuto (1):
      staging: rtl8723bs: fix macro value for 2.4Ghz only device

Filipe Manana (1):
      btrfs: send: fix invalid path for unlink operations after parent orphanization

Gao Xiang (1):
      nfs: fix acl memory leak of posix_acl_create()

Geert Uytterhoeven (2):
      of: Fix truncation of memory sizes on 32-bit platforms
      ARM: dts: r8a7779, marzen: Fix DU clock names

Geoff Levand (1):
      powerpc/ps3: Add dma_mask to ps3_dma_region

Gerd Rausch (1):
      RDMA/cma: Fix rdma_resolve_route() memory leak

Greg Kroah-Hartman (1):
      Linux 4.14.240

Guenter Roeck (2):
      hwmon: (max31722) Remove non-standard ACPI device IDs
      hwmon: (max31790) Fix fan speed reporting for fan7..12

Gustavo A. R. Silva (2):
      media: siano: Fix out-of-bounds warnings in smscore_load_firmware_family2()
      wireless: wext-spy: Fix out-of-bounds warning

Hanjun Guo (1):
      ACPI: bus: Call kobject_put() in acpi_init() error path

Hannu Hartikainen (1):
      USB: cdc-acm: blacklist Heimann USB Appset device

Hans Verkuil (1):
      media: cobalt: fix race condition in setting HPD

Hans de Goede (1):
      ACPI: video: Add quirk for the Dell Vostro 3350

Herbert Xu (1):
      crypto: nx - Fix RCU warning in nx842_OF_upd_status

Hou Tao (1):
      dm btree remove: assign new_root only when removal succeeds

Huang Pei (1):
      MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Igor Matheus Andrade Torrente (1):
      media: em28xx: Fix possible memory leak of em28xx struct

Jack Xu (2):
      crypto: qat - check return code of qat_hal_rd_rel_reg()
      crypto: qat - remove unused macro in FW loader

Jack Zhang (1):
      drm/amd/amdgpu/sriov disable all ip hw status by default

James Smart (2):
      scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
      scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

Jan Kiszka (1):
      watchdog: iTCO_wdt: Account for rebooting on second timeout

Jason Gerecke (1):
      HID: wacom: Correct base usage for capacitive ExpressKey status bits

Jay Fang (2):
      spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
      spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()

Jeff Layton (1):
      ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Jesse Brandeburg (1):
      e100: handle eeprom as little endian

Jiajun Cao (1):
      ALSA: hda: Add IRQ check for platform_get_irq()

Jian-Hong Pan (1):
      net: bcmgenet: Fix attaching to PYH failed on RPi 4B

Jiapeng Chong (3):
      platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()
      RDMA/cxgb4: Fix missing error code in create_qp()
      fs/jfs: Fix missing error code in lmLogInit()

Jing Xiangfeng (1):
      drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Joe Thornber (1):
      dm space maps: don't reset space map allocation cursor when committing

Johan Hovold (5):
      Input: usbtouchscreen - fix control-request directions
      mmc: vub3000: fix control-request direction
      media: dtv5100: fix control-request directions
      media: gspca/sq905: fix control-request direction
      media: gspca/sunplus: fix zero-length control requests

Johannes Berg (1):
      iwlwifi: mvm: don't change band on bound PHY contexts

John Garry (1):
      scsi: core: Cap scsi_host cmd_per_lun at can_queue

Jonathan Cameron (17):
      iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Josef Bacik (2):
      btrfs: fix error handling in __btrfs_update_delayed_inode
      btrfs: abort transaction if we fail to update the delayed inode

Kai-Heng Feng (1):
      Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Kamal Heib (1):
      RDMA/rxe: Fix failure during driver load

Krzysztof Kozlowski (7):
      power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
      reset: a10sr: add missing of_match_table reference
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4
      memory: atmel-ebi: add missing of_node_put for loop iteration
      memory: fsl_ifc: fix leak of IO mapping on probe failure
      memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Wilczyński (2):
      ACPI: sysfs: Fix a buffer overrun problem with description_show()
      PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Kuninori Morimoto (1):
      clk: renesas: r8a77995: Add ZA2 clock

Lai Jiangshan (1):
      KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Lee Gibson (1):
      wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Liguang Zhang (1):
      ACPI: AMBA: Fix resource name in /proc/iomem

Linus Walleij (2):
      power: supply: ab8500: Fix an old bug
      power: supply: ab8500: Avoid NULL pointers

Linyu Yuan (1):
      usb: gadget: eem: fix echo command packet response issue

Liu Shixin (1):
      netlabel: Fix memory leak in netlbl_mgmt_add_common

Longpeng(Mike) (1):
      vsock: notify server to shutdown when client has pending signal

Ludovic Desroches (1):
      ARM: dts: at91: sama5d4: fix pinctrl muxing

Luiz Augusto von Dentz (1):
      Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid

Luiz Sampaio (1):
      w1: ds2438: fixing bug that would always get page0

Lv Yunlong (4):
      media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
      media: exynos4-is: Fix a use after free in isp_video_release
      ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe
      misc/libmasm/module: Fix two use after free in ibmasm_init_one

Marc Kleine-Budde (1):
      iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too

Marcelo Ricardo Leitner (2):
      sctp: validate from_addr_param return
      sctp: add size validation when walking chunks

Marek Szyprowski (1):
      extcon: max8997: Add missing modalias string

Marek Vasut (1):
      rsi: Assign beacon rate settings to the correct rate_info descriptor field

Mario Limonciello (1):
      ACPI: processor idle: Fix up C-state latency if not ordered

Martin Fuzzey (1):
      rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path

Martin Fäcknitz (1):
      MIPS: vdso: Invalid GIC access through VDSO

Mauro Carvalho Chehab (3):
      media: dvb_net: avoid speculation from net slot
      media: siano: fix device register error path
      media: s5p_cec: decrement usage count if disabled

Maximilian Luz (1):
      pinctrl/amd: Add device HID for new AMD GPIO controller

Miaohe Lin (1):
      mm/huge_memory.c: don't discard hugepage if other processes are mapping it

Michael Buesch (1):
      ssb: sdio: Don't overwrite const buffer if block_write fails

Mika Westerberg (1):
      bdi: Do not use freezable workqueue

Mike Christie (3):
      scsi: iscsi: Add iscsi_cls_conn refcount helpers
      scsi: iscsi: Fix shost->max_id use
      scsi: qedi: Fix null ref during abort handling

Mike Marshall (1):
      orangefs: fix orangefs df output.

Miklos Szeredi (2):
      fuse: check connected before queueing on fpq->io
      fuse: reject internal errno

Minchan Kim (1):
      selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Mirko Vogt (1):
      spi: spi-sun6i: Fix chipselect/clock bug

Muchun Song (1):
      writeback: fix obtain a reference to a freeing memcg css

Nathan Chancellor (3):
      powerpc/barrier: Avoid collision with clang's __lwsync macro
      qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute
      hexagon: use common DISCARDS macro

Nick Desaulniers (1):
      ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Nikolay Aleksandrov (1):
      net: bridge: multicast: fix PIM hello router port marking race

Nuno Sa (1):
      iio: adis_buffer: do not return ints in irq handlers

Oliver Hartkopp (1):
      can: gw: synchronize rcu operations before removing gw job entry

Oliver Lang (2):
      iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
      iio: ltr501: ltr501_read_ps(): add missing endianness conversion

Ondrej Zary (2):
      serial_cs: Add Option International GSM-Ready 56K/ISDN modem
      serial_cs: remove wrong GLOBETROTTER.cis entry

Pablo Neira Ayuso (1):
      netfilter: nft_exthdr: check for IPv6 packet before further processing

Pali Rohár (2):
      ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
      PCI: aardvark: Fix kernel panic during PIO transfer

Pan Dong (1):
      ext4: fix avefreec in find_group_orlov

Paul Burton (1):
      tracing: Simplify & fix saved_tgids logic

Pavel Skripkin (10):
      media: dvb-usb: fix wrong definition
      net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
      media: cpia2: fix memory leak in cpia2_usb_probe
      net: ethernet: aeroflex: fix UAF in greth_of_remove
      net: ethernet: ezchip: fix UAF in nps_enet_remove
      net: ethernet: ezchip: fix error handling
      net: sched: fix warning in tcindex_alloc_perfect_hash
      reiserfs: add check for invalid 1st journal block
      media: zr364xx: fix memory leak in zr364xx_start_readpipe
      jfs: fix GPF in diFree

Petr Pavlu (1):
      ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Philipp Zabel (1):
      reset: bail if try_module_get() fails

Quat Le (1):
      scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Rafał Miłecki (1):
      ARM: dts: BCM5301X: Fixup SPI binding

Randy Dunlap (5):
      media: I2C: change 'RST' to "RSET" to fix multiple build errors
      wireless: carl9170: fix LEDS build errors & warnings
      scsi: FlashPoint: Rename si_flags field
      s390: appldata depends on PROC_SYSCTL
      mips: disable branch profiling in boot/decompress.o

Remi Pommarel (1):
      PCI: aardvark: Don't rely on jiffies while holding spinlock

Richard Fitzgerald (4):
      lib: vsprintf: Fix handling of number field widths in vsscanf
      random32: Fix implicit truncation warning in prandom_seed_state()
      ACPI: tables: Add custom DSDT file as makefile prerequisite
      ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK

Ruslan Bilovol (1):
      usb: gadget: f_hid: fix endianness issue with descriptors

Sean Christopherson (1):
      KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled

Sebastian Andrzej Siewior (1):
      net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT

Sergey Shtylyov (4):
      sata_highbank: fix deferred probing
      pata_rb532_cf: fix deferred probing
      pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
      pata_ep93xx: fix deferred probing

Sherry Sun (1):
      tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Srinivas Neeli (1):
      gpio: zynq: Check return value of pm_runtime_get_sync

Steffen Klassert (1):
      xfrm: Fix error reporting in xfrm_state_construct.

Stephan Gerhold (2):
      extcon: sm5502: Drop invalid register write in sm5502_reg_data
      power: supply: rt5033_battery: Fix device tree enumeration

Stephane Grosjean (1):
      can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Stephen Brennan (1):
      ext4: use ext4_grp_locked_error in mb_find_extent

Steven Rostedt (VMware) (1):
      tracing: Do not reference char * as a string in histograms

Takashi Iwai (1):
      ALSA: sb: Fix potential double-free of CSP mixer elements

Takashi Sakamoto (2):
      Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"
      ALSA: bebob: add support for ToneWeal FW66

Tao Ren (1):
      watchdog: aspeed: fix hardware timeout calculation

Tetsuo Handa (1):
      smackfs: restrict bytes count in smk_set_cipso()

Thadeu Lima de Souza Cascardo (1):
      can: bcm: delay release of struct bcm_op after synchronize_rcu()

Thomas Gleixner (3):
      cpu/hotplug: Cure the cpusets trainwreck
      x86/fpu: Return proper error codes from user access functions
      x86/fpu: Limit xstate copy size in xstateregs_set()

Thomas Zimmermann (2):
      drm/mxsfb: Don't select DRM_KMS_FB_HELPER
      drm/zte: Don't select DRM_KMS_FB_HELPER

Tian Tao (1):
      spi: omap-100k: Fix the length judgment problem

Tim Jiang (1):
      Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Timo Sigurdsson (1):
      ata: ahci_sunxi: Disable DIPM

Tony Lindgren (1):
      wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Trond Myklebust (2):
      NFS: nfs_find_open_context() may only select open files
      NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Tyrel Datwyler (1):
      scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Uwe Kleine-König (3):
      backlight: lm3630a: Fix return code of .update_status() callback
      pwm: spear: Don't modify HW state in .remove callback
      pwm: tegra: Don't modify HW state in .remove callback

Valentin Vidic (1):
      s390/sclp_vt220: fix console name to match device

Vineeth Vijayan (1):
      s390/cio: dont call css_wait_for_slow_path() inside a lock

Wang Hai (1):
      samples/bpf: Fix the error return code of xdp_redirect's main()

Willy Tarreau (1):
      ipv6: use prandom_u32() for ID generation

Wolfram Sang (1):
      mmc: core: clear flags before allowing to retune

Xianting Tian (1):
      virtio_net: Remove BUG() to avoid machine dead

Xiao Yang (1):
      RDMA/rxe: Don't overwrite errno from ib_umem_get()

Xie Yongji (4):
      drm/virtio: Fix double free on probe failure
      virtio-blk: Fix memory leak among suspend/resume procedure
      virtio_net: Fix error handling in virtnet_restore()
      virtio_console: Assure used length from device is limited

Yang Li (1):
      ath10k: Fix an error code in ath10k_add_interface()

Yang Yingliang (7):
      drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()
      ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()
      net: bcmgenet: check return value after calling platform_get_resource()
      net: micrel: check return value after calling platform_get_resource()
      fjes: check return value after calling platform_get_resource()
      ALSA: ppc: fix error return code in snd_pmac_probe()
      usb: gadget: hid: fix error return code in hid_bind()

Yoshihiro Shimoda (1):
      serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()

Yu Kuai (1):
      char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_protocol()

Yu Liu (1):
      Bluetooth: Fix the HCI to MGMT status conversion table

YueHaibing (1):
      hv_utils: Fix passing zero to 'PTR_ERR' warning

Yun Zhou (2):
      seq_buf: Make trace_seq_putmem_hex() support data longer than 8
      seq_buf: Fix overflow in seq_buf_putmem_hex()

Zhang Xiaoxu (2):
      SUNRPC: Fix the batch tasks count wraparound.
      SUNRPC: Should wake up the privileged task firstly.

Zhang Yi (3):
      ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle
      ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
      ext4: remove check for zero nr_to_scan in ext4_es_scan()

Zhen Lei (11):
      crypto: ux500 - Fix error return code in hash_hw_final()
      media: tc358743: Fix error return code in tc358743_probe_of()
      mmc: usdhi6rol0: fix error return code in usdhi6_probe()
      ehea: fix error return code in ehea_restart_qps()
      Input: hil_kbd - fix error return code in hil_dev_connect()
      scsi: mpt3sas: Fix error return value in _scsih_expander_add()
      leds: as3645a: Fix error return code in as3645a_parse_node()
      ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
      um: fix error return code in slip_open()
      um: fix error return code in winch_tramp()
      ALSA: isa: Fix error return code in snd_cmi8330_probe()

Zheyu Ma (4):
      media: bt8xx: Fix a missing check bug in bt878_probe
      mmc: via-sdmmc: add a check against NULL pointer dereference
      atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
      atm: nicstar: register the interrupt handler in the right place

Zhihao Cheng (1):
      ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Zou Wei (10):
      atm: iphase: fix possible use-after-free in ia_module_exit()
      mISDN: fix possible use-after-free in HFC_cleanup()
      atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
      cw1200: add missing MODULE_DEVICE_TABLE
      mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
      watchdog: Fix possible use-after-free in wdt_startup()
      watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
      watchdog: Fix possible use-after-free by calling del_timer_sync()
      power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
      power: supply: ab8500: add missing MODULE_DEVICE_TABLE

zhangyi (F) (1):
      block_dump: remove block_dump feature in mark_inode_dirty()

Íñigo Huguet (2):
      sfc: avoid double pci_remove of VFs
      sfc: error code if SRIOV cannot be disabled

