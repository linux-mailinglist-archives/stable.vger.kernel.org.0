Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F97E6B5D7D
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCKPvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCKPvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:51:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D299E2C5C;
        Sat, 11 Mar 2023 07:49:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A1060D30;
        Sat, 11 Mar 2023 15:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77487C433D2;
        Sat, 11 Mar 2023 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549798;
        bh=vaHhiL8dOecn/tApJatDI6ojmC6Qy5ntOKziVIpvbag=;
        h=From:To:Cc:Subject:Date:From;
        b=SaCcq8j2dGRbdgI50Uwf21sPicX4kRfA+lKnxOateKDtm3DjZUhXv9vzSpZkN+eZl
         uaQf3D/Av70mywLLPP45RrYc7INIm2uwc2wJt3ZkywbM4M97JfbWgKTwyieSJbhvt3
         KPeBC6G/hhXWaDtJmJUx39crw5flPPXctumRGuFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.235
Date:   Sat, 11 Mar 2023 16:49:43 +0100
Message-Id: <1678549784248239@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.235 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/cgroup-v1/memory.rst                      |   13 
 Documentation/admin-guide/hw-vuln/spectre.rst                       |   21 
 Documentation/dev-tools/gdb-kernel-debugging.rst                    |    4 
 Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml  |    1 
 Documentation/virt/kvm/api.txt                                      |   18 
 Documentation/virt/kvm/devices/vm.txt                               |    4 
 Makefile                                                            |   13 
 arch/alpha/kernel/traps.c                                           |   30 
 arch/arm/boot/dts/exynos3250-rinato.dts                             |    2 
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi                          |    2 
 arch/arm/boot/dts/exynos4.dtsi                                      |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts                           |    1 
 arch/arm/boot/dts/exynos5420.dtsi                                   |    2 
 arch/arm/boot/dts/imx7s.dtsi                                        |    2 
 arch/arm/boot/dts/spear320-hmi.dts                                  |    2 
 arch/arm/mach-imx/mmdc.c                                            |   24 
 arch/arm/mach-omap1/timer.c                                         |    2 
 arch/arm/mach-omap2/timer.c                                         |    1 
 arch/arm/mach-zynq/slcr.c                                           |    1 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                          |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                   |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi                         |   20 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                           |    6 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                          |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                            |    1 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                                |   12 
 arch/m68k/68000/entry.S                                             |    2 
 arch/m68k/Kconfig.devices                                           |    1 
 arch/m68k/coldfire/entry.S                                          |    2 
 arch/m68k/kernel/entry.S                                            |    3 
 arch/mips/include/asm/syscall.h                                     |    2 
 arch/mips/include/asm/vpe.h                                         |    1 
 arch/mips/kernel/smp-cps.c                                          |    8 
 arch/mips/kernel/vpe-mt.c                                           |    7 
 arch/mips/lantiq/prom.c                                             |    6 
 arch/powerpc/Makefile                                               |    2 
 arch/powerpc/kernel/eeh_driver.c                                    |   71 
 arch/powerpc/kernel/rtas.c                                          |   24 
 arch/powerpc/platforms/powernv/pci-ioda.c                           |    3 
 arch/powerpc/platforms/pseries/lpar.c                               |   20 
 arch/powerpc/platforms/pseries/lparcfg.c                            |   20 
 arch/riscv/kernel/time.c                                            |    3 
 arch/s390/kernel/kprobes.c                                          |    4 
 arch/s390/kernel/vmlinux.lds.S                                      |    1 
 arch/s390/kvm/kvm-s390.c                                            |   16 
 arch/sparc/Kconfig                                                  |    2 
 arch/um/drivers/vector_kern.c                                       |    1 
 arch/x86/crypto/ghash-clmulni-intel_glue.c                          |    6 
 arch/x86/include/asm/microcode.h                                    |    4 
 arch/x86/include/asm/microcode_amd.h                                |    4 
 arch/x86/include/asm/msr-index.h                                    |    4 
 arch/x86/include/asm/reboot.h                                       |    2 
 arch/x86/include/asm/resctrl_sched.h                                |   19 
 arch/x86/include/asm/virtext.h                                      |   16 
 arch/x86/kernel/cpu/bugs.c                                          |   35 
 arch/x86/kernel/cpu/microcode/amd.c                                 |   53 
 arch/x86/kernel/cpu/microcode/core.c                                |    6 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                              |   14 
 arch/x86/kernel/crash.c                                             |   17 
 arch/x86/kernel/kprobes/opt.c                                       |    6 
 arch/x86/kernel/process_32.c                                        |    2 
 arch/x86/kernel/process_64.c                                        |    2 
 arch/x86/kernel/reboot.c                                            |   88 -
 arch/x86/kernel/smp.c                                               |    6 
 arch/x86/kernel/sysfb_efi.c                                         |    8 
 arch/x86/um/vdso/um_vdso.c                                          |   12 
 block/bio-integrity.c                                               |    1 
 block/blk-iocost.c                                                  |   11 
 block/blk-mq-sched.c                                                |   71 
 block/blk-mq.c                                                      |    6 
 crypto/essiv.c                                                      |   10 
 crypto/rsa-pkcs1pad.c                                               |   34 
 crypto/seqiv.c                                                      |    2 
 drivers/acpi/acpica/Makefile                                        |    2 
 drivers/acpi/acpica/hwvalid.c                                       |    7 
 drivers/acpi/acpica/nsrepair.c                                      |   12 
 drivers/acpi/battery.c                                              |    2 
 drivers/acpi/video_detect.c                                         |    2 
 drivers/block/rbd.c                                                 |   20 
 drivers/char/ipmi/ipmi_ssif.c                                       |   46 
 drivers/clk/clk.c                                                   |   11 
 drivers/clk/qcom/gcc-qcs404.c                                       |   24 
 drivers/clk/qcom/gpucc-sdm845.c                                     |    7 
 drivers/clk/renesas/r7s9210-cpg-mssr.c                              |    2 
 drivers/clk/renesas/renesas-cpg-mssr.c                              |   29 
 drivers/clk/renesas/renesas-cpg-mssr.h                              |   12 
 drivers/crypto/amcc/crypto4xx_core.c                                |   10 
 drivers/crypto/ccp/ccp-dmaengine.c                                  |   21 
 drivers/firmware/google/framebuffer-coreboot.c                      |    4 
 drivers/gpio/gpio-vf610.c                                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |    6 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c            |    6 
 drivers/gpu/drm/drm_atomic_helper.c                                 |   29 
 drivers/gpu/drm/drm_bridge.c                                        |  125 -
 drivers/gpu/drm/drm_encoder.c                                       |    2 
 drivers/gpu/drm/drm_fourcc.c                                        |    4 
 drivers/gpu/drm/drm_mipi_dsi.c                                      |   52 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                      |    6 
 drivers/gpu/drm/drm_probe_helper.c                                  |    2 
 drivers/gpu/drm/drm_vblank.c                                        |   28 
 drivers/gpu/drm/exynos/exynos_dp.c                                  |    1 
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                             |    8 
 drivers/gpu/drm/i915/display/intel_quirks.c                         |    2 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                              |    1 
 drivers/gpu/drm/mediatek/mtk_drm_gem.c                              |    8 
 drivers/gpu/drm/mediatek/mtk_hdmi.c                                 |    8 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                            |    7 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                           |    5 
 drivers/gpu/drm/msm/dsi/dsi_host.c                                  |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                     |    4 
 drivers/gpu/drm/msm/msm_fence.c                                     |    2 
 drivers/gpu/drm/mxsfb/Kconfig                                       |    1 
 drivers/gpu/drm/omapdrm/dss/dsi.c                                   |   26 
 drivers/gpu/drm/omapdrm/omap_drv.c                                  |    4 
 drivers/gpu/drm/omapdrm/omap_encoder.c                              |    3 
 drivers/gpu/drm/radeon/atombios_encoders.c                          |    5 
 drivers/gpu/drm/radeon/radeon_device.c                              |    1 
 drivers/gpu/drm/vc4/vc4_dpi.c                                       |   66 
 drivers/gpu/drm/vc4/vc4_dsi.c                                       |    8 
 drivers/gpu/host1x/hw/syncpt_hw.c                                   |    3 
 drivers/gpu/ipu-v3/ipu-common.c                                     |    1 
 drivers/hid/hid-asus.c                                              |  136 +
 drivers/hid/hid-bigbenff.c                                          |   75 -
 drivers/hid/hid-debug.c                                             |    1 
 drivers/hid/hid-ids.h                                               |    1 
 drivers/hid/hid-input.c                                             |    8 
 drivers/hwmon/coretemp.c                                            |  128 -
 drivers/hwmon/ltc2945.c                                             |    2 
 drivers/hwmon/mlxreg-fan.c                                          |    6 
 drivers/iio/accel/mma9551_core.c                                    |   10 
 drivers/input/keyboard/omap-keypad.c                                |    2 
 drivers/input/serio/hil_mlc.c                                       |    2 
 drivers/input/touchscreen/ads7846.c                                 |   13 
 drivers/irqchip/irq-alpine-msi.c                                    |    1 
 drivers/irqchip/irq-bcm7120-l2.c                                    |    3 
 drivers/irqchip/irq-brcmstb-l2.c                                    |    6 
 drivers/irqchip/irq-mvebu-gicp.c                                    |    1 
 drivers/irqchip/irq-ti-sci-intr.c                                   |    1 
 drivers/md/dm-cache-target.c                                        |    4 
 drivers/md/dm-flakey.c                                              |   30 
 drivers/md/dm-thin.c                                                |    2 
 drivers/md/dm.c                                                     |    1 
 drivers/media/i2c/ov5675.c                                          |    4 
 drivers/media/i2c/ov7670.c                                          |    2 
 drivers/media/i2c/ov772x.c                                          |    3 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                            |    3 
 drivers/media/platform/omap3isp/isp.c                               |    9 
 drivers/media/rc/ene_ir.c                                           |    3 
 drivers/media/usb/siano/smsusb.c                                    |    1 
 drivers/media/usb/uvc/uvc_ctrl.c                                    |   30 
 drivers/media/usb/uvc/uvc_driver.c                                  |   66 
 drivers/media/usb/uvc/uvc_entity.c                                  |    2 
 drivers/media/usb/uvc/uvc_status.c                                  |   40 
 drivers/media/usb/uvc/uvc_video.c                                   |   15 
 drivers/media/usb/uvc/uvcvideo.h                                    |    6 
 drivers/mfd/arizona-core.c                                          |    2 
 drivers/mfd/pcf50633-adc.c                                          |    7 
 drivers/misc/mei/bus-fixup.c                                        |    8 
 drivers/mtd/nand/raw/sunxi_nand.c                                   |    2 
 drivers/mtd/ubi/build.c                                             |    7 
 drivers/mtd/ubi/vmt.c                                               |   18 
 drivers/mtd/ubi/wl.c                                                |   25 
 drivers/net/can/usb/esd_usb2.c                                      |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |    8 
 drivers/net/ethernet/intel/ice/ice_main.c                           |   17 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c                |    1 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                 |    3 
 drivers/net/tap.c                                                   |    2 
 drivers/net/tun.c                                                   |    2 
 drivers/net/wan/farsync.c                                           |    4 
 drivers/net/wireless/ath/ath10k/wmi.c                               |    4 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   60 
 drivers/net/wireless/ath/ath9k/htc.h                                |   32 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                       |   10 
 drivers/net/wireless/ath/ath9k/htc_hst.c                            |    4 
 drivers/net/wireless/ath/ath9k/wmi.c                                |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c           |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c             |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c           |    5 
 drivers/net/wireless/intel/ipw2x00/ipw2100.c                        |  121 -
 drivers/net/wireless/intel/ipw2x00/ipw2200.c                        |   67 
 drivers/net/wireless/intel/iwlegacy/3945-mac.c                      |   24 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c                      |   12 
 drivers/net/wireless/intel/iwlegacy/common.c                        |    8 
 drivers/net/wireless/intersil/orinoco/hw.c                          |    2 
 drivers/net/wireless/marvell/libertas/cmdresp.c                     |    2 
 drivers/net/wireless/marvell/libertas/if_usb.c                      |    2 
 drivers/net/wireless/marvell/libertas/main.c                        |    3 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                   |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                          |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                            |   13 
 drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c                 |    5 
 drivers/net/wireless/mediatek/mt7601u/dma.c                         |    3 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c              |    5 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   11 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c                |   91 -
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c              |    4 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h              |    4 
 drivers/net/wireless/rsi/rsi_91x_coex.c                             |    1 
 drivers/net/wireless/st/cw1200/scan.c                               |    3 
 drivers/net/wireless/wl3501_cs.c                                    |    2 
 drivers/nfc/st-nci/se.c                                             |    6 
 drivers/nfc/st21nfca/se.c                                           |    6 
 drivers/opp/debugfs.c                                               |    2 
 drivers/pci/pci.c                                                   |    2 
 drivers/pci/pci.h                                                   |   43 
 drivers/pci/quirks.c                                                |   23 
 drivers/phy/rockchip/phy-rockchip-typec.c                           |    3 
 drivers/pinctrl/pinctrl-at91-pio4.c                                 |    4 
 drivers/pinctrl/pinctrl-at91.c                                      |    2 
 drivers/pinctrl/stm32/pinctrl-stm32.c                               |    1 
 drivers/powercap/powercap_sys.c                                     |   14 
 drivers/pwm/pwm-sifive.c                                            |   16 
 drivers/pwm/pwm-stm32-lp.c                                          |    2 
 drivers/regulator/max77802-regulator.c                              |   34 
 drivers/regulator/s5m8767.c                                         |    6 
 drivers/remoteproc/qcom_q6v5_mss.c                                  |   59 
 drivers/rpmsg/qcom_glink_native.c                                   |    1 
 drivers/rtc/rtc-pm8xxx.c                                            |   24 
 drivers/rtc/rtc-sun6i.c                                             |   32 
 drivers/s390/block/dasd.c                                           |    4 
 drivers/s390/block/dasd_eckd.c                                      |   82 -
 drivers/s390/block/dasd_int.h                                       |    1 
 drivers/s390/crypto/ap_bus.c                                        |    2 
 drivers/scsi/aic94xx/aic94xx_task.c                                 |    3 
 drivers/scsi/ipr.c                                                  |   41 
 drivers/scsi/qla2xxx/qla_nvme.c                                     |   19 
 drivers/scsi/qla2xxx/qla_os.c                                       |    9 
 drivers/scsi/scsi_lib.c                                             |    7 
 drivers/scsi/ses.c                                                  |   64 
 drivers/spi/spi-bcm63xx-hsspi.c                                     |   20 
 drivers/spi/spi-synquacer.c                                         |    7 
 drivers/staging/emxx_udc/emxx_udc.c                                 |    7 
 drivers/staging/most/dim2/dim2.c                                    |    2 
 drivers/staging/octeon/ethernet-tx.c                                |    2 
 drivers/staging/wilc1000/wilc_netdev.c                              |    7 
 drivers/thermal/hisi_thermal.c                                      |    4 
 drivers/thermal/intel/Kconfig                                       |    3 
 drivers/thermal/intel/intel_powerclamp.c                            |   20 
 drivers/thermal/intel/intel_quark_dts_thermal.c                     |   12 
 drivers/thermal/intel/intel_soc_dts_iosf.c                          |    2 
 drivers/tty/serial/fsl_lpuart.c                                     |   24 
 drivers/tty/tty_io.c                                                |    8 
 drivers/tty/vt/keyboard.c                                           |    2 
 drivers/tty/vt/vc_screen.c                                          |    4 
 drivers/usb/gadget/udc/snps_udc_core.c                              |    6 
 drivers/usb/host/fhci-sched.c                                       |    2 
 drivers/usb/host/xhci-mvebu.c                                       |    2 
 drivers/usb/storage/ene_ub6250.c                                    |    2 
 drivers/watchdog/at91sam9_wdt.c                                     |    7 
 drivers/watchdog/pcwd_usb.c                                         |    6 
 drivers/watchdog/watchdog_dev.c                                     |    2 
 fs/cifs/smbdirect.c                                                 |    4 
 fs/coda/upcall.c                                                    |    2 
 fs/ext4/xattr.c                                                     |   35 
 fs/f2fs/data.c                                                      |    6 
 fs/f2fs/inline.c                                                    |   28 
 fs/f2fs/super.c                                                     |   11 
 fs/f2fs/verity.c                                                    |   12 
 fs/gfs2/aops.c                                                      |    3 
 fs/hfs/bnode.c                                                      |    1 
 fs/hfsplus/super.c                                                  |    4 
 fs/jfs/jfs_dmap.c                                                   |    3 
 fs/nfsd/nfs4layouts.c                                               |    4 
 fs/nfsd/nfs4proc.c                                                  |    2 
 fs/ocfs2/move_extents.c                                             |   34 
 fs/ubifs/budget.c                                                   |    9 
 fs/ubifs/dir.c                                                      |    9 
 fs/ubifs/file.c                                                     |   12 
 fs/ubifs/super.c                                                    |   17 
 fs/ubifs/tnc.c                                                      |   24 
 fs/ubifs/ubifs.h                                                    |    5 
 fs/udf/file.c                                                       |   26 
 fs/udf/inode.c                                                      |   74 -
 fs/udf/super.c                                                      |    1 
 fs/udf/udf_i.h                                                      |    3 
 fs/udf/udf_sb.h                                                     |    2 
 include/drm/drm_bridge.h                                            |   77 -
 include/drm/drm_crtc.h                                              |   34 
 include/drm/drm_mipi_dsi.h                                          |    4 
 include/drm/drm_simple_kms_helper.h                                 |    7 
 include/drm/drm_vblank.h                                            |    1 
 include/linux/ima.h                                                 |    6 
 include/linux/interrupt.h                                           |   15 
 include/linux/kernel_stat.h                                         |    2 
 include/linux/kprobes.h                                             |    2 
 include/linux/pci_ids.h                                             |    2 
 include/linux/uaccess.h                                             |    4 
 include/net/sctp/structs.h                                          |    1 
 include/net/sock.h                                                  |    9 
 include/sound/soc-dapm.h                                            |    3 
 include/uapi/linux/usb/video.h                                      |   30 
 include/uapi/linux/uvcvideo.h                                       |    2 
 kernel/backtracetest.c                                              |    2 
 kernel/debug/debug_core.c                                           |    2 
 kernel/fail_function.c                                              |    5 
 kernel/irq/irqdomain.c                                              |   31 
 kernel/irq/resend.c                                                 |    2 
 kernel/kprobes.c                                                    |    6 
 kernel/rcu/tree_exp.h                                               |    2 
 kernel/sched/deadline.c                                             |    5 
 kernel/sched/rt.c                                                   |   10 
 kernel/time/hrtimer.c                                               |    2 
 kernel/time/posix-stubs.c                                           |    2 
 kernel/time/posix-timers.c                                          |    2 
 kernel/trace/ring_buffer.c                                          |    7 
 lib/mpi/mpicoder.c                                                  |    3 
 mm/huge_memory.c                                                    |    3 
 mm/memcontrol.c                                                     |    4 
 net/9p/trans_rdma.c                                                 |   15 
 net/9p/trans_xen.c                                                  |   48 
 net/atm/pppoatm.c                                                   |    2 
 net/bluetooth/hci_sock.c                                            |   11 
 net/bluetooth/l2cap_core.c                                          |   24 
 net/bluetooth/l2cap_sock.c                                          |    8 
 net/core/dev.c                                                      |    4 
 net/core/sock.c                                                     |   22 
 net/ipv4/inet_connection_sock.c                                     |    1 
 net/ipv4/inet_hashtables.c                                          |   12 
 net/ipv4/tcp_minisocks.c                                            |    7 
 net/ipv6/route.c                                                    |   11 
 net/iucv/iucv.c                                                     |    2 
 net/mac80211/sta_info.c                                             |    2 
 net/netfilter/nf_conntrack_netlink.c                                |    5 
 net/nfc/netlink.c                                                   |    4 
 net/rds/message.c                                                   |    2 
 net/sched/Kconfig                                                   |   11 
 net/sched/Makefile                                                  |    1 
 net/sched/act_sample.c                                              |   11 
 net/sched/cls_tcindex.c                                             |  730 ----------
 net/sctp/stream_sched_prio.c                                        |   52 
 net/tls/tls_sw.c                                                    |   26 
 net/wireless/sme.c                                                  |   31 
 security/integrity/ima/ima_main.c                                   |    7 
 security/security.c                                                 |    7 
 sound/drivers/pcsp/pcsp_lib.c                                       |    2 
 sound/pci/hda/patch_ca0132.c                                        |    2 
 sound/pci/hda/patch_realtek.c                                       |    1 
 sound/pci/ice1712/aureon.c                                          |    2 
 sound/soc/fsl/fsl_sai.c                                             |    1 
 sound/soc/kirkwood/kirkwood-dma.c                                   |    2 
 sound/soc/soc-compress.c                                            |    2 
 tools/iio/iio_utils.c                                               |   23 
 tools/lib/bpf/nlattr.c                                              |    2 
 tools/perf/perf-completion.sh                                       |   11 
 tools/perf/util/llvm-utils.c                                        |   25 
 tools/testing/ktest/ktest.pl                                        |   26 
 tools/testing/ktest/sample.conf                                     |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |    2 
 tools/testing/selftests/net/fib_tests.sh                            |    2 
 tools/testing/selftests/net/udpgso_bench_rx.c                       |    6 
 virt/kvm/coalesced_mmio.c                                           |    8 
 354 files changed, 2762 insertions(+), 2413 deletions(-)

Al Viro (1):
      alpha: fix FEN fault handling

Alexander Potapenko (1):
      fs: f2fs: initialize fsdata in pagecache_write()

Alexander Usyskin (1):
      mei: bus-fixup:upon error print return values of send and receive

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexey Khoroshilov (1):
      clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alexey V. Vissarionov (1):
      ALSA: hda/ca0132: minor fix for allocation size

Alper Nebi Yasak (1):
      firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Ammar Faizi (1):
      x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Andreas Gruenbacher (1):
      gfs2: jdata writepage fix

AngeloGioacchino Del Regno (1):
      arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Angus Chen (1):
      ARM: imx: Call ida_simple_remove() for ida_simple_get

Armin Wolf (1):
      ACPI: battery: Fix missing NUL-termination with large strings

Arnd Bergmann (3):
      rtlwifi: fix -Wpointer-sign warning
      wifi: ath9k: use proper statements in conditionals
      scsi: ipr: Work around fortify-string warning

Arun Easi (1):
      scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests

Benjamin Coddington (1):
      nfsd: fix race to check ls_layouts

Bitterblue Smith (1):
      wifi: rtl8xxxu: Use a longer retry limit of 48

Bjorn Andersson (1):
      rpmsg: glink: Avoid infinite loop on intent for missing channel

Boris Brezillon (3):
      drm/exynos: Don't reset bridge->next
      drm/bridge: Rename bridge helpers targeting a bridge chain
      drm/bridge: Introduce drm_bridge_get_next_bridge()

Borislav Petkov (AMD) (3):
      x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter
      x86/microcode/AMD: Add a @cpu parameter to the reloading functions
      x86/microcode/AMD: Fix mixed steppings support

Breno Leitao (1):
      x86/bugs: Reset speculation control settings on init

Chen Hui (1):
      ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Chen Jun (1):
      watchdog: Fix kmemleak in watchdog_cdev_register

Chen Wandun (1):
      crypto: essiv - remove redundant null pointer check before kfree

Chen-Yu Tsai (1):
      clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()

Christian Hewitt (1):
      arm64: dts: meson: remove CPU opps below 1GHz for G12A boards

Christophe JAILLET (2):
      ipw2x00: switch from 'pci_' to 'dma_' API
      spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()

Claudiu Beznea (1):
      pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Conor Dooley (1):
      RISC-V: time: initialize hrtimer based broadcast clock event device

Corey Minyard (1):
      ipmi_ssif: Rename idle state and check

Damien Le Moal (1):
      PCI: Avoid FLR for AMD FCH AHCI adapters

Dan Carpenter (2):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      thermal: intel: quark_dts: fix error pointer dereference

Daniel Axtens (1):
      powerpc/eeh: Small refactor of eeh_handle_normal_event()

Daniel Mentz (1):
      drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Daniel Scally (1):
      usb: uvc: Enumerate valid values for color matching

Daniil Tatianin (1):
      ACPICA: nsrepair: handle cases without a return value correctly

Darrell Kavanagh (2):
      drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5
      firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Dave Stevenson (2):
      drm/vc4: dpi: Add option for inverting pixel clock and output enable
      drm/vc4: dpi: Fix format mapping for RGB565

Dietmar Eggemann (1):
      sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()

Dmitry Baryshkov (5):
      arm64: dts: qcom: qcs404: use symbol names for PCIe resets
      drm/msm: use strscpy instead of strncpy
      clk: qcom: gcc-qcs404: disable gpll[04]_out_aux parents
      clk: qcom: gcc-qcs404: fix names of the DSI clocks used as parents
      clk: qcom: gpucc-sdm845: fix clk_dis_wait being programmed for CX GDSC

Dmitry Fomin (1):
      ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Dmitry Goncharov (1):
      kbuild: Port silent mode detection to future gnu make.

Dongliang Mu (1):
      fs: hfsplus: fix UAF issue in hfsplus_put_super

Douglas Anderson (1):
      Revert "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"

Duoming Zhou (2):
      media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
      media: usb: siano: Fix use after free bugs caused by do_submit_urb

Elvira Khabirova (1):
      mips: fix syscall_get_nr

Emil Renner Berthing (1):
      pwm: sifive: Always let the first pwm_apply_state succeed

Eric Biggers (4):
      crypto: x86/ghash - fix unaligned access in ghash_setkey()
      f2fs: fix information leak in f2fs_move_inline_dirents()
      f2fs: fix cgroup writeback accounting with fs-layer encryption
      f2fs: use memcpy_{to,from}_page() where possible

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fabrice Gasnier (1):
      pwm: stm32-lp: fix the check on arr and cmp registers update

Fedor Pchelkin (3):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Fainelli (3):
      irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
      irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
      net: bcmgenet: Add a check for oversized packets

Frank Jungclaus (1):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Frederic Barrat (1):
      powerpc/powernv/ioda: Skip unallocated resources when mapping to PE

Ganesh Goudar (1):
      powerpc/eeh: Set channel state after notifying the drivers

Geert Uytterhoeven (3):
      drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats
      drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
      clk: renesas: cpg-mssr: Remove superfluous check in resume code

Geliang Tang (1):
      mptcp: add sk_stop_timer_sync helper

George Kennedy (2):
      ubi: ensure that VID header offset + VID header size <= alloc, size
      vc_screen: modify vcs_size() handling in vcs_read()

Greg Kroah-Hartman (2):
      kernel/fail_function: fix memory leak with using debugfs_lookup()
      Linux 5.4.235

Guenter Roeck (1):
      media: uvcvideo: Handle errors from calls to usb_string

Haibo Chen (1):
      gpio: vf610: connect GPIO label to dev name

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Hans Verkuil (1):
      media: i2c: ov7670: 0 instead of -EINVAL was returned

Hans de Goede (5):
      HID: asus: Only set EV_REP if we are adding a mapping
      HID: asus: Add report_size to struct asus_touchpad_info
      HID: asus: Add support for multi-touch touchpad on Medion Akoya E1239T
      HID: asus: Fix mute and touchpad-toggle keys on Medion Akoya E1239T
      ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Harshit Mogalapalli (2):
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Heming Zhao via Ocfs2-devel (2):
      ocfs2: fix defrag path triggering jbd2 ASSERT
      ocfs2: fix non-auto defrag path not working issue

Herbert Xu (5):
      lib/mpi: Fix buffer overrun when SG is too long
      crypto: essiv - Handle EBUSY correctly
      crypto: seqiv - Handle EBUSY correctly
      crypto: rsa-pkcs1pad - Use akcipher_request_complete
      crypto: crypto4xx - Call dma_unmap_page when done

Ian Rogers (1):
      perf llvm: Fix inadvertent file creation

Ilya Dryomov (1):
      rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Ilya Leoshkevich (2):
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
      s390: discard .interp section

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Jakob Koschel (1):
      docs/scripts/gdb: add necessary make scripts_gdb step

Jakub Kicinski (1):
      net: tls: avoid hanging tasks on the tx_lock

Jakub Sitnicki (1):
      selftests/net: Interpret UDP_GRO cmsg data as an int value

Jamal Hadi Salim (1):
      net/sched: Retire tcindex classifier

James Bottomley (1):
      scsi: ses: Don't attach if enclosure has no components

Jan Höppner (1):
      s390/dasd: Prepare for additional path event handling

Jan Kara (7):
      udf: Define EFSCORRUPTED error code
      udf: Truncate added extents on failed expansion
      udf: Do not bother merging very long extents
      udf: Do not update file length for failed writes to inline files
      udf: Preserve link count of system files
      udf: Detect system inodes linked into directory hierarchy
      udf: Fix file corruption when appending just after end of preallocated extent

Jann Horn (1):
      timers: Prevent union confusion from unexpected restart_syscall()

Jeff Layton (1):
      nfsd: zero out pointers after putting nfsd_files on COPY setup error

Jernej Skrabec (1):
      rtc: sun6i: Make external 32k oscillator optional

Jesse Brandeburg (1):
      ice: add missing checks for PF vsi type

Jia-Ju Bai (1):
      tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Jiapeng Chong (1):
      phy: rockchip-typec: Fix unsigned comparison with less than zero

Jiasheng Jiang (9):
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()
      drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
      drm/msm/dpu: Add check for cstate
      drm/msm/dpu: Add check for pstates
      drm/msm/mdp5: Add check for kzalloc
      scsi: aic94xx: Add missing check for dma_map_single()
      media: platform: ti: Add missing check for devm_regulator_get
      drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Jingyuan Liang (1):
      HID: Add Mapping for System Microphone Mute

Jisoo Jang (3):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds
      wifi: mt7601u: fix an integer underflow

Johan Hovold (4):
      rtc: pm8xxx: fix set-alarm race
      irqdomain: Fix association race
      irqdomain: Fix disassociation race
      irqdomain: Drop bogus fwspec-mapping error handling

Johannes Weiner (1):
      mm: memcontrol: deprecate charge moving

Jonathan Cormier (1):
      hwmon: (ltc2945) Handle error case in ltc2945_value_store

Juergen Gross (2):
      9p/xen: fix version parsing
      9p/xen: fix connection sequence

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Jun Nie (2):
      ext4: optimize ea_inode block expansion
      ext4: refuse to create ea block when umounted

KP Singh (2):
      x86/speculation: Allow enabling STIBP with legacy IBRS
      Documentation/hw-vuln: Document the interaction between IBRS and STIBP

Kees Cook (10):
      usb: gadget: udc: Avoid tasklet passing a global
      treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()
      coda: Avoid partial allocation of sig_inputArgs
      uaccess: Add minimum bounds check on kernel buffer size
      ASoC: kirkwood: Iterate over array indexes instead of using pointer math
      regulator: max77802: Bounds check regulator id against opmode
      regulator: s5m8767: Bounds check id indexing into arrays
      media: uvcvideo: Silence memcpy() run-time false positive warnings
      usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
      USB: ene_usb6250: Allocate enough memory for full object

Kemeng Shi (3):
      blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
      blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait
      blk-mq: correct stale comment of .get_budget

Koba Ko (1):
      crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Krzysztof Kozlowski (5):
      ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
      ARM: dts: exynos: correct HDMI phy compatible in Exynos4
      ARM: dts: exynos: correct TMU phandle in Exynos4
      ARM: dts: exynos: correct TMU phandle in Odroid XU
      ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Kuninori Morimoto (1):
      ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Kuniyuki Iwashima (1):
      tcp: Fix listen() regression in 5.4.229.

Li Hua (2):
      ubifs: Fix build errors as symbol undefined
      watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Li Nan (1):
      blk-iocost: fix divide by 0 error in calc_lcoefs()

Li Zetao (4):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
      ubi: Fix use-after-free when volume resizing failed
      ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()
      ubifs: Fix memory leak in alloc_wbufs()

Liang He (2):
      gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
      mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak

Linus Torvalds (1):
      x86/resctl: fix scheduler confusion with 'current'

Liu Shixin (1):
      hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Liu Shixin via Jfs-discussion (1):
      fs/jfs: fix shift exponent db_agl2size negative

Liwei Song (1):
      drm/radeon: free iio for atombios when driver shutdown

Lorenzo Bianconi (1):
      wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup

Lu Wei (1):
      ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

Luc Van Oostenryck (1):
      wilc1000: let wilc_mac_xmit() return NETDEV_TX_OK

Luca Ellero (2):
      Input: ads7846 - don't report pressure for ads7845
      Input: ads7846 - don't check penirq immediately for 7845

Lucas Tanure (1):
      ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix potential user-after-free

Lukas Wunner (2):
      PCI/PM: Observe reset delay irrespective of bridge_d3
      PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Luke D. Jones (1):
      HID: asus: Remove check for same LED brightness on set

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Mario Limonciello (1):
      ACPICA: Drop port I/O validation for some regions

Mark Hawrylak (1):
      drm/radeon: Fix eDP for single-display iMac11,2

Mark Rutland (1):
      ACPI: Don't build ACPICA with '-Os'

Markus Elfring (1):
      net/wireless: Delete unnecessary checks before the macro call “dev_kfree_skb”

Markuss Broks (1):
      ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Martin Blumenstingl (3):
      arm64: dts: meson-gx: Fix Ethernet MAC address unit name
      arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
      arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin K. Petersen (1):
      block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Masami Hiramatsu (Google) (1):
      selftests/ftrace: Fix bash specific "==" operator

Mavroudis Chatzilaridis (1):
      drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Maxime Ripard (1):
      dt-bindings: rtc: sun6i-a31-rtc: Loosen the requirements on the clocks

Mengyuan Lou (1):
      PCI: Add ACS quirk for Wangxun NICs

Miaoqian Lin (4):
      irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
      irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
      irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe
      pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain

Michael Schmitz (1):
      m68k: Check syscall_trace_enter() return code

Mike Snitzer (3):
      dm: remove flush_scheduled_work() during local_exit()
      dm thin: add cond_resched() to various workqueue loops
      dm cache: add cond_resched() to various workqueue loops

Mikko Perttunen (1):
      gpu: host1x: Don't skip assigning syncpoints to channels

Mikulas Patocka (2):
      dm flakey: fix logic when corrupting a bio
      dm flakey: don't corrupt the zero page

Miles Chen (1):
      drm/mediatek: Use NULL instead of 0 for NULL pointer

Minsuk Kang (1):
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Nathan Chancellor (1):
      powerpc: Remove linker flag from KBUILD_AFLAGS

Nathan Lynch (4):
      powerpc/pseries/lpar: add missing RTAS retry status handling
      powerpc/pseries/lparcfg: add missing RTAS retry status handling
      powerpc/rtas: make all exports GPL
      powerpc/rtas: ensure 4KB alignment for rtas_data_buf

Neil Armstrong (6):
      arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
      arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
      arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name
      arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

Nico Boehr (1):
      KVM: s390: disable migration mode when dirty tracking is disabled

Nícolas F. R. A. Prado (1):
      drm/mediatek: Clean dangling pointer on bind error path

Paul E. McKenney (1):
      rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Pavel Skripkin (1):
      ath9k: htc: clean up statistics macros

Pedro Tammela (1):
      net/sched: act_sample: fix action bind logic

Peng Fan (1):
      ARM: dts: imx7s: correct iomuxc gpr mux controller cells

Pietro Borrello (12):
      HID: asus: use spinlock to protect concurrent accesses
      HID: asus: use spinlock to safely schedule workers
      sched/rt: pick_next_rt_entity(): check list_entry
      net: add sock_init_data_uid()
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid
      rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
      HID: bigben: use spinlock to protect concurrent accesses
      HID: bigben_worker() remove unneeded check on report_field
      HID: bigben: use spinlock to safely schedule workers
      hid: bigben_probe(): validate report count
      inet: fix fast path in __inet_hash_connect()

Qi Zheng (1):
      OPP: fix error checking in opp_migrate_dentry()

Qiheng Lin (3):
      ARM: zynq: Fix refcount leak in zynq_early_slcr_init
      s390/dasd: Fix potential memleak in dasd_eckd_init()
      mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Quinn Tran (2):
      scsi: qla2xxx: Fix link failure in NPIV environment
      scsi: qla2xxx: Fix erroneous link down

Randy Dunlap (5):
      m68k: /proc/hardware should depend on PROC_FS
      sparc: allow PM configs for sparc32 COMPILE_TEST
      MIPS: SMP-CPS: fix build error when HOTPLUG_CPU not set
      MIPS: vpe-mt: drop physical_memsize
      thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Ricardo Ribalda (4):
      media: uvcvideo: Handle cameras with invalid descriptors
      media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910
      media: uvcvideo: Provide sync and async uvc_ctrl_status_event
      media: uvcvideo: Fix race condition with usb_kill_urb

Rob Clark (1):
      drm/mediatek: Drop unbalanced obj unref

Roberto Sassu (1):
      ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Robin Murphy (1):
      hwmon: (coretemp) Simplify platform device handling

Roman Li (1):
      drm/amd/display: Fix potential null-deref in dm_resume

Roxana Nicolescu (1):
      selftest: fib_tests: Always cleanup before exit

Sakari Ailus (1):
      media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Salman Qazi (1):
      block: Limit number of items taken from the I/O scheduler in one go

Samuel Holland (2):
      mtd: rawnand: sunxi: Fix the size of the last OOB region
      rtc: sun6i: Always export the internal oscillator

Sean Christopherson (5):
      KVM: Destroy target device if coalesced MMIO unregistration fails
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Shang XiaoJing (1):
      media: ov5675: Fix memleak in ov5675_init_controls()

Shay Drory (1):
      net/mlx5: fw_tracer: Fix debug print

Shayne Chen (1):
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Shengjiu Wang (1):
      ASoC: fsl_sai: initialize is_dsp_mode flag

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable the CTS when send break signal

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Srinivas Pandruvada (1):
      thermal: intel: powerclamp: Fix cur_state for multi package system

Steven Rostedt (3):
      ktest.pl: Give back console on Ctrt^C on monitor
      ktest.pl: Fix missing "end_monitor" when machine check fails
      ktest.pl: Add RUN_TIMEOUT option with default unlimited

Sven Schnelle (1):
      tty: fix out-of-bounds access in tty_driver_lookup_tty()

Thomas Zimmermann (1):
      drm: Initialize struct drm_crtc_state.no_vblank from device settings

Tomas Henzl (4):
      scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
      scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
      scsi: ses: Fix possible desc_ptr out-of-bounds accesses
      scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Tomi Valkeinen (1):
      drm/omap: dsi: Fix excessive stack usage

Tzung-Bi Shih (1):
      ASoC: dapm: declare missing structure prototypes

Uwe Kleine-König (1):
      pwm: sifive: Reduce time the controller lock is held

Vadim Pasternak (1):
      hwmon: (mlxreg-fan) Return zero speed for broken fan

Valentin Schneider (1):
      x86/resctrl: Apply READ_ONCE/WRITE_ONCE to task_struct.{rmid,closid}

Vasily Gorbik (2):
      s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
      s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Wambui Karuga (1):
      drm/mediatek: remove cast to pointers passed to kfree

Wan Jiabing (1):
      ath9k: hif_usb: simplify if-if to if-else

William Zhang (1):
      spi: bcm63xx-hsspi: Fix multi-bit mode setting

Xiang Yang (1):
      um: vector: Fix memory leak in vector_config

Xin Long (1):
      sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Yang Jihong (2):
      x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
      x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Li (1):
      thermal: intel: Fix unsigned comparison with less than zero

Yang Yingliang (11):
      ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
      wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      powercap: fix possible name leak in powercap_register_zone()
      ubi: Fix possible null-ptr-deref in ubi_free_volume()

Yicong Yang (1):
      perf tools: Fix auto-complete on aarch64

Yin Fengwei (1):
      mm/thp: check and bail out if page in deferred queue already

Yongqin Liu (1):
      thermal/drivers/hisi: Drop second sensor hi3660

Yoshihiro Shimoda (1):
      clk: renesas: cpg-mssr: Use enum clk_reg_layout instead of a boolean flag

Yuan Can (4):
      wifi: rsi: Fix memory leak in rsi_coex_attach()
      drm/bridge: megachips: Fix error handling in i2c_register_driver()
      media: i2c: ov772x: Fix memleak in ov772x_probe()
      staging: emxx_udc: Add checks for dma_alloc_coherent()

Yulong Zhang (1):
      tools/iio/iio_utils:fix memory leak

Zhang Changzhong (2):
      wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhang Xiaoxu (2):
      cifs: Fix lost destroy smbd connection when MR allocate failed
      cifs: Fix warning and UAF when destroy the MR list

Zhen Lei (1):
      genirq: Fix the return type of kstat_cpu_irqs_sum()

Zhengchao Shao (4):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
      9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Zhihao Cheng (10):
      ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
      ubifs: Rectify space budget for ubifs_xrename()
      ubifs: Fix wrong dirty space budget for dirty inode
      ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1
      ubifs: Reserve one leb for each journal head while doing budget
      ubifs: Re-statistic cleaned znode count if commit failed
      ubifs: dirty_cow_znode: Fix memleak in error handling path
      ubifs: ubifs_writepage: Mark page dirty after writing inode failed
      ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
      ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

ruanjinjie (1):
      watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

Álvaro Fernández Rojas (1):
      spi: bcm63xx-hsspi: fix pm_runtime

Łukasz Stelmach (1):
      ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

