Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9348337A7CF
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhEKNhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231659AbhEKNh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 09:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7411B6191C;
        Tue, 11 May 2021 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620740179;
        bh=U1mRXSBG6nMDIC2gaLwRlpc9BSQVfWkGReOKPu2MjZA=;
        h=From:To:Cc:Subject:Date:From;
        b=qgFGqArBORlvHBiSFqATyIQ8bpTSRlShTFgkAQy4Fmw6xUmultpjS5wR2MpYzXQOV
         Og3aGcYnWWywFu0dz/rgDJUyLNhyQBVrDGj6JGDXtaapN6VgIN35oDcz7Q/myVlrDp
         c0iDOf8jv9JULwjOWxCz1pYbgJU3hMtHHbKO0G7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.36
Date:   Tue, 11 May 2021 15:36:10 +0200
Message-Id: <162074017023196@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.36 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |   10 
 arch/arm/boot/compressed/Makefile                                   |    4 
 arch/arm/boot/dts/at91-sam9x60ek.dts                                |    3 
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts                         |    3 
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts                       |    3 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                              |    3 
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                           |    3 
 arch/arm/boot/dts/at91-sama5d2_xplained.dts                         |    3 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts                         |    3 
 arch/arm/boot/dts/at91sam9260ek.dts                                 |    3 
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi                         |    3 
 arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts                         |    4 
 arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts                         |    4 
 arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts                   |    4 
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts                         |    4 
 arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts                      |    4 
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts                       |    4 
 arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts                         |    4 
 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts                  |    4 
 arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts                   |    4 
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts                         |    4 
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts                   |    4 
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts                        |    4 
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts                         |    4 
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts                         |    4 
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts                       |    4 
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts                     |    4 
 arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts                       |    4 
 arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts                       |    4 
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts                       |    4 
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts                       |    4 
 arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts                    |    4 
 arch/arm/boot/dts/bcm47094-netgear-r8500.dts                        |    4 
 arch/arm/boot/dts/bcm47094-phicomm-k3.dts                           |    4 
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi                       |   73 ++--
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts                     |    2 
 arch/arm/crypto/curve25519-core.S                                   |    2 
 arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts                 |    4 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                        |    3 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                            |    2 
 arch/arm64/kernel/vdso/vdso.lds.S                                   |    8 
 arch/powerpc/include/asm/reg.h                                      |    1 
 arch/powerpc/include/uapi/asm/errno.h                               |    1 
 arch/powerpc/kernel/eeh.c                                           |   11 
 arch/powerpc/kernel/setup_64.c                                      |   19 -
 arch/powerpc/kexec/file_load_64.c                                   |   92 +++++
 arch/powerpc/lib/Makefile                                           |    3 
 arch/s390/crypto/arch_random.c                                      |    4 
 arch/s390/kernel/dis.c                                              |    2 
 arch/x86/Kconfig                                                    |    2 
 arch/x86/Makefile                                                   |    1 
 arch/x86/boot/compressed/Makefile                                   |    1 
 arch/x86/boot/compressed/mem_encrypt.S                              |    6 
 arch/x86/kernel/cpu/common.c                                        |    2 
 arch/x86/kernel/sev-es-shared.c                                     |    6 
 arch/x86/mm/mem_encrypt_identity.c                                  |   35 +-
 crypto/api.c                                                        |    2 
 crypto/rng.c                                                        |   10 
 drivers/acpi/arm64/gtdt.c                                           |   10 
 drivers/acpi/custom_method.c                                        |    4 
 drivers/ata/ahci.c                                                  |    5 
 drivers/ata/ahci.h                                                  |    1 
 drivers/ata/libahci.c                                               |    5 
 drivers/block/rnbd/rnbd-clt-sysfs.c                                 |   10 
 drivers/bus/mhi/core/init.c                                         |   16 
 drivers/bus/mhi/core/main.c                                         |  110 +++++-
 drivers/bus/mhi/core/pm.c                                           |    5 
 drivers/bus/ti-sysc.c                                               |   49 ++
 drivers/char/random.c                                               |    4 
 drivers/char/tpm/eventlog/acpi.c                                    |   33 +
 drivers/char/tpm/eventlog/common.c                                  |    3 
 drivers/char/tpm/eventlog/efi.c                                     |   29 +
 drivers/clk/socfpga/clk-gate-a10.c                                  |    1 
 drivers/cpuidle/cpuidle-tegra.c                                     |   12 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c                   |    2 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                 |    2 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c                   |    2 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                          |    2 
 drivers/crypto/omap-aes.c                                           |    6 
 drivers/crypto/qat/qat_common/qat_algs.c                            |   11 
 drivers/crypto/sa2ul.c                                              |    2 
 drivers/crypto/stm32/stm32-cryp.c                                   |    4 
 drivers/crypto/stm32/stm32-hash.c                                   |    8 
 drivers/extcon/extcon-arizona.c                                     |   57 +--
 drivers/firmware/efi/libstub/Makefile                               |    3 
 drivers/fpga/dfl-pci.c                                              |   18 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                           |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                             |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                            |    9 
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c                            |    7 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c               |   17 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   17 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h                   |   14 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c           |   15 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c               |  115 ++++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c        |    4 
 drivers/gpu/drm/amd/display/dc/core/dc.c                            |    3 
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h                        |    1 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c               |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c      |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c    |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c   |   28 +
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c |   28 +
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c   |   28 +
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c   |   28 +
 drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c       |   28 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c               |    2 
 drivers/gpu/drm/arm/display/include/malidp_utils.h                  |    3 
 drivers/gpu/drm/arm/display/komeda/komeda_pipeline.c                |   16 
 drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c          |   19 -
 drivers/gpu/drm/ast/ast_drv.c                                       |    2 
 drivers/gpu/drm/ast/ast_mode.c                                      |    2 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                      |   14 
 drivers/gpu/drm/i915/intel_pm.c                                     |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c                    |   18 -
 drivers/gpu/drm/msm/dp/dp_hpd.c                                     |    4 
 drivers/gpu/drm/qxl/qxl_display.c                                   |    4 
 drivers/gpu/drm/qxl/qxl_drv.c                                       |    2 
 drivers/gpu/drm/radeon/radeon_ttm.c                                 |    5 
 drivers/gpu/drm/vkms/vkms_crtc.c                                    |    3 
 drivers/hwtracing/intel_th/gth.c                                    |    4 
 drivers/hwtracing/intel_th/pci.c                                    |   10 
 drivers/input/touchscreen/ili210x.c                                 |    2 
 drivers/irqchip/irq-gic-v3.c                                        |    8 
 drivers/md/dm-integrity.c                                           |    1 
 drivers/md/dm-raid.c                                                |   34 +
 drivers/md/dm-rq.c                                                  |    2 
 drivers/md/persistent-data/dm-btree-internal.h                      |    4 
 drivers/md/persistent-data/dm-space-map-common.c                    |    2 
 drivers/md/persistent-data/dm-space-map-common.h                    |    8 
 drivers/md/raid1.c                                                  |    2 
 drivers/media/dvb-core/dvbdev.c                                     |    1 
 drivers/media/i2c/adv7511-v4l2.c                                    |    2 
 drivers/media/i2c/adv7604.c                                         |    2 
 drivers/media/i2c/adv7842.c                                         |    2 
 drivers/media/i2c/tc358743.c                                        |    2 
 drivers/media/i2c/tda1997x.c                                        |    2 
 drivers/media/pci/saa7164/saa7164-encoder.c                         |   20 -
 drivers/media/pci/sta2x11/Kconfig                                   |    1 
 drivers/media/platform/qcom/venus/hfi_parser.c                      |    6 
 drivers/media/platform/sti/bdisp/bdisp-debug.c                      |    2 
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c                    |    2 
 drivers/media/rc/ite-cir.c                                          |    8 
 drivers/media/test-drivers/vivid/vivid-core.c                       |    6 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                            |   90 +++--
 drivers/media/usb/dvb-usb/dvb-usb.h                                 |    2 
 drivers/media/usb/em28xx/em28xx-dvb.c                               |    1 
 drivers/media/usb/gspca/gspca.c                                     |    2 
 drivers/media/usb/gspca/gspca.h                                     |    1 
 drivers/media/usb/gspca/sq905.c                                     |    2 
 drivers/media/usb/gspca/stv06xx/stv06xx.c                           |    9 
 drivers/media/v4l2-core/v4l2-ctrls.c                                |  137 +++----
 drivers/mfd/arizona-irq.c                                           |    2 
 drivers/mfd/da9063-i2c.c                                            |   10 
 drivers/mmc/core/block.c                                            |   16 
 drivers/mmc/core/core.c                                             |   76 ----
 drivers/mmc/core/core.h                                             |   17 
 drivers/mmc/core/host.c                                             |   40 ++
 drivers/mmc/core/mmc.c                                              |    7 
 drivers/mmc/core/mmc_ops.c                                          |    4 
 drivers/mmc/core/sd.c                                               |    6 
 drivers/mmc/core/sdio.c                                             |   28 +
 drivers/mmc/host/sdhci-brcmstb.c                                    |    1 
 drivers/mmc/host/sdhci-esdhc-imx.c                                  |    2 
 drivers/mmc/host/sdhci-pci-core.c                                   |   29 +
 drivers/mmc/host/sdhci-pci.h                                        |    2 
 drivers/mmc/host/sdhci-tegra.c                                      |   32 +
 drivers/mmc/host/sdhci.c                                            |   60 +--
 drivers/mmc/host/uniphier-sd.c                                      |    5 
 drivers/mtd/maps/physmap-bt1-rom.c                                  |    2 
 drivers/mtd/nand/raw/atmel/nand-controller.c                        |    6 
 drivers/mtd/nand/spi/core.c                                         |    2 
 drivers/mtd/spi-nor/core.c                                          |   33 +
 drivers/mtd/spi-nor/macronix.c                                      |    3 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c                   |   30 -
 drivers/net/ethernet/sfc/farch.c                                    |   16 
 drivers/net/wimax/i2400m/op-rfkill.c                                |    2 
 drivers/net/wireless/rsi/rsi_91x_sdio.c                             |    2 
 drivers/nvme/target/discovery.c                                     |    6 
 drivers/pci/pci.c                                                   |   16 
 drivers/perf/arm_pmu_platform.c                                     |    9 
 drivers/phy/ti/phy-twl4030-usb.c                                    |    2 
 drivers/platform/x86/intel_pmc_core.c                               |   19 -
 drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c       |   33 +
 drivers/power/supply/bq27xxx_battery.c                              |   51 +-
 drivers/power/supply/cpcap-battery.c                                |    2 
 drivers/power/supply/cpcap-charger.c                                |    3 
 drivers/power/supply/generic-adc-battery.c                          |    2 
 drivers/power/supply/lp8788-charger.c                               |    2 
 drivers/power/supply/pm2301_charger.c                               |    2 
 drivers/power/supply/s3c_adc_battery.c                              |    2 
 drivers/power/supply/tps65090-charger.c                             |    2 
 drivers/power/supply/tps65217_charger.c                             |    2 
 drivers/s390/crypto/zcrypt_card.c                                   |    1 
 drivers/s390/crypto/zcrypt_queue.c                                  |    1 
 drivers/scsi/device_handler/scsi_dh_alua.c                          |    5 
 drivers/scsi/libfc/fc_lport.c                                       |    2 
 drivers/scsi/lpfc/lpfc_attr.c                                       |   75 ++--
 drivers/scsi/lpfc/lpfc_crtn.h                                       |    3 
 drivers/scsi/lpfc/lpfc_hw4.h                                        |  174 ----------
 drivers/scsi/lpfc/lpfc_init.c                                       |  112 ------
 drivers/scsi/lpfc/lpfc_mbox.c                                       |   36 --
 drivers/scsi/lpfc/lpfc_nportdisc.c                                  |   11 
 drivers/scsi/lpfc/lpfc_nvmet.c                                      |    1 
 drivers/scsi/lpfc/lpfc_sli.c                                        |   43 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                                 |    4 
 drivers/scsi/qla2xxx/qla_attr.c                                     |    8 
 drivers/scsi/qla2xxx/qla_bsg.c                                      |    3 
 drivers/scsi/qla2xxx/qla_os.c                                       |    7 
 drivers/scsi/smartpqi/smartpqi_init.c                               |  161 +++++++++
 drivers/soc/tegra/pmc.c                                             |   70 +++-
 drivers/soundwire/cadence_master.c                                  |   10 
 drivers/spi/spi-ath79.c                                             |    3 
 drivers/spi/spi-dln2.c                                              |    2 
 drivers/spi/spi-omap-100k.c                                         |    6 
 drivers/spi/spi-qup.c                                               |    2 
 drivers/spi/spi-stm32-qspi.c                                        |   18 -
 drivers/spi/spi-ti-qspi.c                                           |   20 -
 drivers/spi/spi.c                                                   |   16 
 drivers/staging/media/atomisp/pci/atomisp_fops.c                    |    3 
 drivers/staging/media/imx/imx-media-capture.c                       |    2 
 drivers/staging/media/ipu3/ipu3-v4l2.c                              |   36 +-
 drivers/target/target_core_pscsi.c                                  |    3 
 drivers/tee/optee/core.c                                            |   10 
 drivers/thermal/cpufreq_cooling.c                                   |    2 
 drivers/thermal/gov_fair_share.c                                    |    4 
 drivers/tty/n_gsm.c                                                 |   14 
 drivers/tty/vt/vt.c                                                 |    1 
 drivers/usb/core/hub.c                                              |    2 
 drivers/usb/dwc2/core_intr.c                                        |    8 
 drivers/usb/dwc3/core.c                                             |   29 +
 drivers/usb/dwc3/core.h                                             |    9 
 drivers/usb/dwc3/gadget.c                                           |   41 +-
 drivers/usb/gadget/config.c                                         |    4 
 drivers/usb/gadget/function/f_fs.c                                  |    3 
 drivers/usb/gadget/function/f_uac1.c                                |   43 ++
 drivers/usb/gadget/function/f_uac2.c                                |   39 ++
 drivers/usb/gadget/function/f_uvc.c                                 |    8 
 drivers/usb/gadget/legacy/webcam.c                                  |    1 
 drivers/usb/gadget/udc/dummy_hcd.c                                  |   23 -
 drivers/usb/gadget/udc/tegra-xudc.c                                 |    2 
 drivers/usb/host/xhci-mem.c                                         |   12 
 drivers/usb/host/xhci-mtk.c                                         |    3 
 drivers/usb/host/xhci-mtk.h                                         |    1 
 drivers/usb/host/xhci.c                                             |   14 
 drivers/usb/musb/musb_core.c                                        |    2 
 drivers/vhost/vdpa.c                                                |    1 
 drivers/video/backlight/qcom-wled.c                                 |   29 +
 drivers/video/fbdev/core/fbcmap.c                                   |    8 
 drivers/virt/nitro_enclaves/ne_misc_dev.c                           |   43 --
 fs/btrfs/compression.c                                              |   11 
 fs/btrfs/ctree.c                                                    |   20 +
 fs/btrfs/ioctl.c                                                    |   18 -
 fs/btrfs/relocation.c                                               |   46 +-
 fs/btrfs/transaction.c                                              |   12 
 fs/cifs/connect.c                                                   |    1 
 fs/cifs/sess.c                                                      |    6 
 fs/cifs/smb2ops.c                                                   |   18 -
 fs/cifs/smb2pdu.c                                                   |    5 
 fs/ecryptfs/main.c                                                  |    6 
 fs/erofs/erofs_fs.h                                                 |    3 
 fs/erofs/inode.c                                                    |    7 
 fs/eventpoll.c                                                      |    6 
 fs/exfat/balloc.c                                                   |   11 
 fs/ext4/fast_commit.c                                               |    4 
 fs/ext4/file.c                                                      |   25 +
 fs/ext4/ialloc.c                                                    |   51 +-
 fs/ext4/ioctl.c                                                     |    6 
 fs/ext4/mmp.c                                                       |    2 
 fs/ext4/super.c                                                     |    9 
 fs/f2fs/node.c                                                      |    3 
 fs/f2fs/verity.c                                                    |   75 +++-
 fs/fuse/file.c                                                      |   41 +-
 fs/fuse/fuse_i.h                                                    |    1 
 fs/fuse/virtio_fs.c                                                 |    1 
 fs/jbd2/transaction.c                                               |   15 
 fs/jffs2/compr_rtime.c                                              |    3 
 fs/jffs2/file.c                                                     |    1 
 fs/jffs2/scan.c                                                     |    2 
 fs/nfs/fs_context.c                                                 |   12 
 fs/nfs/pnfs.c                                                       |    7 
 fs/stat.c                                                           |    8 
 fs/ubifs/replay.c                                                   |    3 
 include/crypto/acompress.h                                          |    2 
 include/crypto/aead.h                                               |    2 
 include/crypto/akcipher.h                                           |    2 
 include/crypto/chacha.h                                             |    9 
 include/crypto/hash.h                                               |    4 
 include/crypto/kpp.h                                                |    2 
 include/crypto/rng.h                                                |    2 
 include/crypto/skcipher.h                                           |    2 
 include/linux/mfd/da9063/registers.h                                |    3 
 include/linux/mfd/intel-m10-bmc.h                                   |    2 
 include/linux/mmc/host.h                                            |    3 
 include/linux/perf_event.h                                          |    1 
 include/linux/power/bq27xxx_battery.h                               |    1 
 include/media/v4l2-ctrls.h                                          |   12 
 include/scsi/libfcoe.h                                              |    2 
 include/uapi/linux/usb/video.h                                      |    3 
 kernel/.gitignore                                                   |    1 
 kernel/Makefile                                                     |    9 
 kernel/events/core.c                                                |  142 ++++----
 kernel/futex.c                                                      |    7 
 kernel/irq/matrix.c                                                 |    4 
 kernel/kcsan/core.c                                                 |    2 
 kernel/kcsan/debugfs.c                                              |    4 
 kernel/kcsan/kcsan.h                                                |    5 
 kernel/rcu/tree.c                                                   |    2 
 kernel/sched/fair.c                                                 |   31 +
 kernel/sched/features.h                                             |    3 
 kernel/sched/psi.c                                                  |    5 
 kernel/time/posix-timers.c                                          |    4 
 kernel/trace/ftrace.c                                               |    5 
 kernel/trace/trace.c                                                |   41 --
 kernel/trace/trace_clock.c                                          |   44 +-
 lib/dynamic_debug.c                                                 |    2 
 lib/vsprintf.c                                                      |    2 
 net/bluetooth/ecdh_helper.h                                         |    2 
 net/openvswitch/actions.c                                           |    8 
 security/commoncap.c                                                |    2 
 sound/isa/sb/emu8000.c                                              |    4 
 sound/isa/sb/sb16_csp.c                                             |    8 
 sound/pci/hda/patch_conexant.c                                      |   14 
 sound/pci/hda/patch_realtek.c                                       |   52 ++
 sound/usb/clock.c                                                   |   18 -
 sound/usb/mixer_maps.c                                              |   12 
 tools/power/x86/intel-speed-select/isst-display.c                   |   12 
 tools/power/x86/turbostat/turbostat.c                               |   19 -
 tools/testing/selftests/arm64/mte/Makefile                          |    2 
 tools/testing/selftests/arm64/mte/mte_common_util.c                 |   13 
 tools/testing/selftests/resctrl/Makefile                            |    2 
 tools/testing/selftests/resctrl/cache.c                             |    8 
 tools/testing/selftests/resctrl/cat_test.c                          |   12 
 tools/testing/selftests/resctrl/cqm_test.c                          |   14 
 tools/testing/selftests/resctrl/fill_buf.c                          |    4 
 tools/testing/selftests/resctrl/mba_test.c                          |    2 
 tools/testing/selftests/resctrl/mbm_test.c                          |    2 
 tools/testing/selftests/resctrl/resctrl.h                           |   21 -
 tools/testing/selftests/resctrl/resctrl_tests.c                     |   14 
 tools/testing/selftests/resctrl/resctrl_val.c                       |   85 +++-
 tools/testing/selftests/resctrl/resctrlfs.c                         |   79 +++-
 344 files changed, 3030 insertions(+), 1639 deletions(-)

Abhinav Kumar (1):
      drm/msm/dp: Fix incorrect NULL check kbot warnings in DP driver

Adrian Hunter (2):
      mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers
      mmc: sdhci-pci: Add PCI IDs for Intel LKF

Al Cooper (1):
      mmc: sdhci-brcmstb: Remove CQE quirk

Alexander Lobakin (1):
      mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Alexander Shishkin (2):
      intel_th: pci: Add Rocket Lake CPU support
      intel_th: pci: Add Alder Lake-M support

Andre Przywara (2):
      kselftest/arm64: mte: Fix compilation with native compiler
      kselftest/arm64: mte: Fix MTE feature detection

Aniruddha Tvs Rao (1):
      mmc: sdhci-tegra: Add required callbacks to set/clear CQE_EN bit

Anirudh Rayabharam (1):
      usb: gadget: dummy_hcd: fix gpf in gadget_setup

Anson Jacob (3):
      drm/amdkfd: Fix UBSAN shift-out-of-bounds warning
      drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'
      drm/amd/display: Fix UBSAN: shift-out-of-bounds warning

Ard Biesheuvel (2):
      ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld
      crypto: api - check for ERR pointers in crypto_destroy_tfm()

Aric Cyr (2):
      drm/amd/display: Don't optimize bandwidth before disabling planes
      drm/amd/display: DCHUB underflow counter increasing in some scenarios

Arnd Bergmann (2):
      amdgpu: avoid incorrect %hu format string
      security: commoncap: fix -Wstringop-overread warning

Artur Petrosyan (1):
      usb: dwc2: Fix session request interrupt handler

Arun Easi (1):
      scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()

Aurelien Aptel (1):
      smb2: fix use-after-free in smb2_ioctl_query_info()

Avri Altman (2):
      mmc: block: Update ext_csd.cache_ctrl if it was written
      mmc: block: Issue a cache flush only when it's enabled

Bart Van Assche (2):
      scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      scsi: libfc: Fix a format specifier

Bas Nieuwenhuizen (1):
      tools/power/turbostat: Fix turbostat for AMD Zen CPUs

Benjamin Block (1):
      dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Bhaumik Bhatt (3):
      bus: mhi: core: Clear configuration from channel context during reset
      bus: mhi: core: Destroy SBL devices when moving to mission mode
      bus: mhi: core: Clear context for stopped channels from remove()

Bill Wendling (1):
      arm64/vdso: Discard .note.gnu.property sections in vDSO

Bixuan Cui (2):
      usb: musb: fix PM reference leak in musb_irq_work()
      usb: core: hub: Fix PM reference leak in usb_port_resume()

Calvin Walton (1):
      tools/power turbostat: Fix offset overflow issue in index converting

Carl Philipp Klemm (1):
      power: supply: cpcap-charger: Add usleep to cpcap charger to avoid usb plug bounce

Carsten Haitzler (1):
      drm/komeda: Fix bit check to import to value of proper type

Chaitanya Kulkarni (1):
      scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Chao Yu (1):
      f2fs: fix to avoid out-of-bounds memory access

Charan Teja Reddy (1):
      sched,psi: Handle potential task count underflow bugs more gracefully

Chen Jun (1):
      posix-timers: Preserve return value in clock_adjtime32()

Christophe JAILLET (2):
      mmc: uniphier-sd: Fix an error handling path in uniphier_sd_probe()
      mmc: uniphier-sd: Fix a resource leak in the remove function

Christophe Kerello (1):
      spi: stm32-qspi: fix pm_runtime usage_count counter

Christophe Leroy (1):
      powerpc/32: Fix boot failure with CONFIG_STACKPROTECTOR

Chunfeng Yun (2):
      arm64: dts: mt8173: fix property typo of 'phys' in dsi node
      usb: xhci-mtk: support quirk to disable usb2 lpm

Colin Ian King (1):
      clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return

Daniel Gomez (2):
      drm/amdgpu/ttm: Fix memory leak userptr pages
      drm/radeon/ttm: Fix memory leak userptr pages

Daniel Niv (1):
      media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

David Bauer (3):
      spi: ath79: always call chipselect function
      spi: ath79: remove spi-master setup and cleanup assignment
      spi: sync up initial chipselect state

David E. Box (1):
      platform/x86: intel_pmc_core: Don't use global pmcdev in quirks

Davide Caratti (1):
      openvswitch: fix stack OOB read while fragmenting IPv4 packets

Davidlohr Bueso (1):
      fs/epoll: restore waking from ep_done_scan()

Dean Anderson (1):
      usb: gadget/function/f_fs string table fix for multiple languages

Dinghao Liu (3):
      media: platform: sti: Fix runtime PM imbalance in regs_show
      media: sun8i-di: Fix runtime PM imbalance in deinterlace_start_streaming
      mfd: arizona: Fix rumtime PM imbalance on error

Dmitry Osipenko (3):
      cpuidle: tegra: Fix C7 idling state on Tegra114
      ARM: tegra: acer-a500: Rename avdd to vdda of touchscreen node
      soc/tegra: pmc: Fix completion of power-gate toggling

Dmitry Vyukov (1):
      drm/vkms: fix misuse of WARN_ON

Dmytro Laktyushkin (1):
      drm/amd/display: fix dml prefetch validation

Don Brace (1):
      scsi: smartpqi: Use host-wide tag space

DooHyun Hwang (1):
      mmc: core: Do a power cycle when the CMD11 fails

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Edward Cree (2):
      sfc: farch: fix TX queue lookup in TX flush done handling
      sfc: farch: fix TX queue lookup in TX event handling

Emily Deng (1):
      drm/amdgpu: Fix some unload driver issues

Eric Biggers (3):
      random: initialize ChaCha20 constants with correct endianness
      f2fs: fix error handling in f2fs_end_enable_verity()
      crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS

Eryk Brol (1):
      drm/amd/display: Check for DSC support instead of ASIC revision

Eugene Korenevsky (1):
      cifs: fix out-of-bound memory access when calling smb3_notify() at mount point

Ewan D. Milne (1):
      scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Fangzhi Zuo (1):
      drm/amd/display: Fix debugfs link_settings entry

Fenghua Yu (8):
      selftests/resctrl: Enable gcc checks to detect buffer overflows
      selftests/resctrl: Fix compilation issues for global variables
      selftests/resctrl: Fix compilation issues for other global variables
      selftests/resctrl: Clean up resctrl features check
      selftests/resctrl: Fix missing options "-n" and "-p"
      selftests/resctrl: Use resctrl/info for feature detection
      selftests/resctrl: Fix incorrect parsing of iMC counters
      selftests/resctrl: Fix checking for < 0 for unsigned values

Fengnan Chang (1):
      ext4: fix error code in ext4_commit_super

Filipe Manana (3):
      btrfs: fix metadata extent leak after failure to create subvolume
      btrfs: fix race between transaction aborts and fsyncs leading to use-after-free
      btrfs: fix race when picking most recent mod log operation for an old root

Gao Xiang (1):
      erofs: add unsupported inode i_format check

Gerd Hoffmann (1):
      drm/qxl: release shadow on shutdown

Gioh Kim (1):
      block/rnbd-clt: Fix missing a memory free when unloading the module

Greg Kroah-Hartman (1):
      Linux 5.10.36

Guangqing Zhu (1):
      power: supply: cpcap-battery: fix invalid usage of list cursor

Guchun Chen (1):
      drm/amdgpu: fix NULL pointer dereference

Guochun Mao (1):
      ubifs: Only check replay with inode type to judge if inode linked

Gustavo A. R. Silva (1):
      mtd: physmap: physmap-bt1-rom: Fix unintentional stack access

Hans Verkuil (4):
      media: gspca/sq905.c: fix uninitialized variable
      media: vivid: update EDID
      media: gscpa/stv06xx: fix memory leak
      media: v4l2-ctrls: fix reference to freed memory

Hans de Goede (2):
      extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
      extcon: arizona: Fix various races on driver unbind

Hansem Ro (1):
      Input: ili210x - add missing negation for touch indication on ili210x

Harald Freudenberger (2):
      s390/zcrypt: fix zcard and zqueue hot-unplug memleak
      s390/archrandom: add parameter check for s390_arch_random_generate

He Ying (1):
      irqchip/gic-v3: Do not enable irqs when handling spurious interrups

Heinz Mauelshagen (1):
      dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Hemant Kumar (1):
      usb: gadget: Fix double free of device descriptor pointers

Hillf Danton (1):
      tty: n_gsm: check error while registering tty devices

Hou Pu (1):
      nvmet: return proper error code from discovery ctrl

Hubert Streidl (1):
      mfd: da9063: Support SMBus and I2C mode

Hui Tang (1):
      crypto: qat - fix unmap invalid dma address

Hyeongseok Kim (1):
      exfat: fix erroneous discard when clear cluster bit

Ido Schimmel (1):
      mlxsw: spectrum_mr: Update egress RIF list before route's action

James Smart (5):
      scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
      scsi: lpfc: Fix pt2pt connection does not recover after LOGO
      scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
      scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
      scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

Jan Kara (3):
      ext4: annotate data race in start_this_handle()
      ext4: annotate data race in jbd2_journal_dirty_metadata()
      ext4: Fix occasional generic/418 failure

Jared Baldridge (1):
      drm: Added orientation quirk for OneGX1 Pro

Jason Wang (1):
      vhost-vdpa: fix vm_flags for virtqueue doorbell mapping

Jeffrey Hugo (2):
      bus: mhi: core: Fix check for syserr at power_up
      bus: mhi: core: Sanity check values from remote device before use

Jeffrey Mitchell (1):
      ecryptfs: fix kernel panic with null dev_name

Jerome Forissier (1):
      tee: optee: do not check memref size on return from Secure World

Joe Thornber (2):
      dm persistent data: packed struct should have an aligned() attribute too
      dm space map common: fix division bug in sm_ll_find_free_block()

Joel Stanley (1):
      jffs2: Hook up splice_write callback

Joerg Roedel (1):
      x86/sev: Do not require Hypervisor CPUID bit for SEV guests

John Millikin (1):
      x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Jonas Witschel (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G7

Jonathan Kim (1):
      drm/amdgpu: mask the xgmi number of hops reported from psp to kfd

Josef Bacik (3):
      btrfs: do proper error handling in create_reloc_root
      btrfs: do proper error handling in btrfs_update_reloc_root
      btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Julian Braha (1):
      media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Kai Stuhlemmer (ebee Engineering) (1):
      mtd: rawnand: atmel: Update ecc_stats.corrected counter

Kailang Yang (1):
      ALSA: hda/realtek - Headset Mic issue on HP platform

Kenneth Feng (1):
      drm/amd/pm: fix workload mismatch on vega10

Kevin Barnett (1):
      scsi: smartpqi: Add new PCI IDs

Kiran Gunda (1):
      backlight: qcom-wled: Fix FSC update issue for WLED5

Laurent Pinchart (1):
      media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()

Lee Jones (1):
      drm/amd/display/dc/dce/dce_aux: Remove duplicate line causing 'field overwritten' issue

Lingutla Chandrasekhar (1):
      sched/fair: Ignore percpu threads for imbalance pulls

Linus Torvalds (1):
      Fix misc new gcc warnings

Linus Walleij (1):
      ARM: dts: ux500: Fix up TVK R3 sensors

Longfang Liu (1):
      crypto: hisilicon/sec - fixes a printing error

Ludovic Desroches (1):
      ARM: dts: at91: change the key code of the gpio key

Luis Henriques (1):
      virtiofs: fix memory leak in virtio_fs_probe()

Lukasz Luba (1):
      thermal/core/fair share: Lock the thermal zone while looping over instances

Luke D Jones (1):
      ALSA: hda/realtek: GA503 use same quirks as GA401

Lv Yunlong (2):
      ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer
      ALSA: sb: Fix two use after free in snd_sb_qsound_build

Maciej W. Rozycki (1):
      x86/build: Disable HIGHMEM64G selection for M486SX

Mahesh Salgaonkar (1):
      powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

Marc Zyngier (1):
      ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Marco Elver (1):
      kcsan, debugfs: Move debugfs file creation out of early init

Marek Behún (1):
      arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node

Marek Vasut (1):
      rsi: Use resume_noirq for SDIO

Marijn Suijten (2):
      drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal
      drm/msm/mdp5: Do not multiply vclk line count by 100

Mark Langsdorf (2):
      ACPI: custom_method: fix potential use-after-free issue
      ACPI: custom_method: fix a possible memory leak

Martin Leung (1):
      drm/amd/display: changing sr exit latency

Masahiro Yamada (1):
      kbuild: update config_data.gz only when the content of .config is changed

Mathias Krause (1):
      nitro_enclaves: Fix stale file descriptors on failed usercopy

Mathias Nyman (3):
      xhci: check port array allocation was successful before dereferencing it
      xhci: check control context is valid before dereferencing it.
      xhci: fix potential array out of bounds with several interrupters

Matthias Schiffer (1):
      power: supply: bq27xxx: fix power_avg for newer ICs

Mauro Carvalho Chehab (1):
      atomisp: don't let it go past pipes array

Muhammad Usama Anjum (1):
      media: em28xx: fix memory leak

Murthy Bhat (1):
      scsi: smartpqi: Correct request leakage during reset operations

Nathan Chancellor (4):
      x86/boot: Add $(CLANG_FLAGS) to compressed KBUILD_CFLAGS
      efi/libstub: Add $(CLANG_FLAGS) to x86 flags
      Makefile: Move -Wno-unused-but-set-variable out of GCC only block
      crypto: arm/curve25519 - Move '.fpu' after '.arch'

Nicholas Piggin (1):
      powerpc/powernv: Enable HAIL (HV AIL) for ISA v3.1 processors

Obeida Shamoun (1):
      backlight: qcom-wled: Use sink_addr for sync toggle

Paul Aurich (1):
      cifs: Return correct error code from smb2_get_enc_key

Paul Clements (1):
      md/raid1: properly indicate failure when ending a failed write request

Pavel Machek (1):
      intel_th: Consistency and off-by-one fix

Pavel Skripkin (2):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init
      tty: fix memory leak in vc_deallocate

Pawel Laszczak (2):
      usb: gadget: uvc: add bInterval checking for HS mode
      usb: webcam: Invalid size of Processing Unit Descriptor

Peilin Ye (1):
      media: dvbdev: Fix memory leak in dvb_media_device_free()

Peng Fan (1):
      mmc: sdhci-esdhc-imx: validate pinctrl before use it

Peter Zijlstra (2):
      perf: Rework perf_event_exit_event()
      sched,fair: Alternative sched_slice()

Phil Calvin (1):
      ALSA: hda/realtek: fix mic boost on Intel NUC 8

Phillip Potter (1):
      fbdev: zero-fill colormap in fbcmap.c

Pierre-Louis Bossart (1):
      soundwire: cadence: only prepare attached devices on clock stop

Pradeep P V K (1):
      mmc: sdhci: Check for reset prior to DMA address unmap

Qu Huang (1):
      drm/amdkfd: Fix cat debugfs hang_hws file causes system crash bug

Qu Wenruo (1):
      btrfs: handle remount to no compress during compression

Quinn Tran (1):
      scsi: qla2xxx: Fix use after free in bsg

Rafael J. Wysocki (1):
      PCI: PM: Do not read power state in pci_enable_device_flags()

Rafał Miłecki (1):
      ARM: dts: BCM5301X: fix "reg" formatting in /memory node

Randy Dunlap (1):
      NFS: fs_context: validate UDP retrans to prevent shift out-of-bounds

Rasmus Villemoes (1):
      lib/vsprintf.c: remove leftover 'f' and 'F' cases from bstr_printf()

Ricardo Ribalda (3):
      media: staging/intel-ipu3: Fix memory leak in imu_fmt
      media: staging/intel-ipu3: Fix set_fmt error handling
      media: staging/intel-ipu3: Fix race condition during set_fmt

Robin Murphy (2):
      perf/arm_pmu_platform: Use dev_err_probe() for IRQ errors
      perf/arm_pmu_platform: Fix error handling

Ruslan Bilovol (2):
      usb: gadget: f_uac2: validate input parameters
      usb: gadget: f_uac1: validate input parameters

Russ Weight (1):
      fpga: dfl: pci: add DID for D5005 PAC cards

Sami Loone (1):
      ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops

Sean Christopherson (1):
      x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Sean Young (1):
      media: ite-cir: check for receive overflow

Sebastian Krzyszkowiak (1):
      arm64: dts: imx8mq-librem5-r3: Mark buck3 as always on

Seunghui Lee (1):
      mmc: core: Set read only for SD cards with permanent write protect bit

Shixin Liu (6):
      crypto: sun8i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
      crypto: sun8i-ce - Fix PM reference leak in sun8i_ce_probe()
      crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
      crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c
      crypto: sa2ul - Fix PM reference leak in sa_ul_probe()
      crypto: omap-aes - Fix PM reference leak on omap-aes.c

Shuo Chen (1):
      dyndbg: fix parsing file query without a line-range suffix

Shyam Prasad N (1):
      cifs: detect dead connections only when echoes are enabled.

Sourabh Jain (1):
      powerpc/kexec_file: Use current CPU info while setting up FDT

Sreekanth Reddy (1):
      scsi: mpt3sas: Block PCI config access from userspace during reset

Srinivas Pandruvada (2):
      tools/power/x86/intel-speed-select: Increase string size
      platform/x86: ISST: Account for increased timeout in some cases

Stanimir Varbanov (1):
      media: venus: hfi_parser: Don't initialize parser on v1

Stefan Berger (3):
      tpm: acpi: Check eventlog signature before using it
      tpm: efi: Use local variable for calculating final log size
      tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Steve French (2):
      smb3: when mounting with multichannel include it in requested capabilities
      smb3: do not attempt multichannel to server which does not support it

Steven Rostedt (VMware) (3):
      ftrace: Handle commands when closing set_ftrace_filter file
      tracing: Map all PIDs to command lines
      tracing: Restructure trace_clock_global() to never block

Takashi Iwai (4):
      ALSA: hda/conexant: Re-order CX5066 quirk table entries
      ALSA: usb-audio: Explicitly set up the clock selector
      media: dvb-usb: Fix use-after-free access
      media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()

Theodore Ts'o (2):
      fs: fix reporting supported extra file attributes for statx()
      ext4: allow the dax flag to be set and cleared on inline directories

Thinh Nguyen (4):
      usb: xhci: Fix port minor revision
      usb: dwc3: gadget: Check for disabled LPM quirk
      usb: dwc3: gadget: Remove FS bInterval_m1 limitation
      usb: dwc3: gadget: Fix START_TRANSFER link state check

Thomas Gleixner (2):
      Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
      futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI

Thomas Zimmermann (1):
      drm/ast: Fix invalid usage of AST_MAX_HWC_WIDTH in cursor atomic_check

Tian Tao (1):
      dm integrity: fix missing goto in bitmap_flush_interval error handling

Timo Gurr (1):
      ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Tong Zhang (2):
      drm/qxl: do not run release if qxl failed to init
      drm/ast: fix memory leak when unload the driver

Tony Ambardar (1):
      powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Tony Lindgren (1):
      bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first

Trond Myklebust (2):
      NFS: Don't discard pNFS layout segments that are marked for return
      NFSv4: Don't discard segments marked for return in _pnfs_return_layout()

Tudor Ambarus (2):
      Revert "mtd: spi-nor: macronix: Add support for mx25l51245g"
      spi: spi-ti-qspi: Free DMA resources

Uladzislau Rezki (Sony) (1):
      kvfree_rcu: Use same set of GFP flags as does single-argument

Ulf Hansson (1):
      mmc: core: Fix hanging on I/O during system suspend for removable cards

Vasily Gorbik (1):
      s390/disassembler: increase ebpf disasm buffer size

Vincent Donnefort (1):
      sched/pelt: Fix task util_est update filtering

Vitaly Kuznetsov (1):
      genirq/matrix: Prevent allocation counter corruption

Vivek Goyal (1):
      fuse: fix write deadlock

Wang Li (1):
      spi: qup: fix PM reference leak in spi_qup_remove()

Wei Yongjun (2):
      spi: dln2: Fix reference leak to master
      spi: omap-100k: Fix reference leak to master

Werner Sembach (1):
      drm/amd/display: Try YCbCr420 color when YCbCr444 fails

Wesley Cheng (1):
      usb: dwc3: gadget: Ignore EP queue requests during bus reset

Xiang Chen (1):
      mtd: spi-nor: core: Fix an issue of releasing resources during read/write

Xiaogang Chen (1):
      drm/amdgpu/display: buffer INTERRUPT_LOW_IRQ_CONTEXT interrupt work

Xingui Yang (1):
      ata: ahci: Disable SXS for Hisilicon Kunpeng920

Xu Yihang (1):
      ext4: fix error return code in ext4_fc_perform_commit()

Xu Yilun (1):
      mfd: intel-m10-bmc: Fix the register access range

Yang Yang (1):
      jffs2: check the validity of dstlen in jffs2_zlib_compress()

Yang Yingliang (9):
      usb: gadget: tegra-xudc: Fix possible use-after-free in tegra_xudc_remove()
      phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
      power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
      power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
      media: tc358743: fix possible use-after-free in tc358743_remove()
      media: adv7604: fix possible use-after-free in adv76xx_remove()
      media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
      media: i2c: tda1997: Fix possible use-after-free in tda1997x_remove()
      media: i2c: adv7842: fix possible use-after-free in adv7842_remove()

Ye Bin (1):
      ext4: fix ext4_error_err save negative errno into superblock

Yu Chen (1):
      usb: dwc3: core: Do core softreset when switch mode

Zhang Yi (2):
      ext4: fix check to prevent false positive report of incorrect used inodes
      ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

brian-sy yang (1):
      thermal/drivers/cpufreq_cooling: Fix slab OOB issue

dongjian (1):
      power: supply: Use IRQF_ONESHOT

karthik alapati (1):
      staging: wimax/i2400m: fix byte-order issue

lizhe (1):
      jffs2: Fix kasan slab-out-of-bounds problem

shaoyunl (1):
      drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

