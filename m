Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB850297F
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 14:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbiDOMZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 08:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244449AbiDOMZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 08:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE51A7C146;
        Fri, 15 Apr 2022 05:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A7561748;
        Fri, 15 Apr 2022 12:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03176C385A6;
        Fri, 15 Apr 2022 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650025375;
        bh=ctPRKetxX2SffREjwioIBWrKP39ODaagYxEMrfp/JFs=;
        h=From:To:Cc:Subject:Date:From;
        b=Jt+aHHpeqzKnsKcnz9SHQ3Fxr3mGEdgfYiivkkhueWX5jT31tC/JiIf/CBJkI85dC
         h0UE0RtxZNUWDoJwjQvpgpHBg1OTMhJCFu14FQLEsa7m8+2xhdJlRbuF1f0vjEBlMW
         +DGhRIfRT4EXsCj206gNAe2tSi3AhKWQWz1v8PU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.238
Date:   Fri, 15 Apr 2022 14:22:46 +0200
Message-Id: <165002536687118@kroah.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.238 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/stable-kernel-rules.rst                    |   11 
 Makefile                                                         |    2 
 arch/arm/boot/dts/bcm2837.dtsi                                   |   49 ++
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi                        |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                        |    3 
 arch/arm/boot/dts/exynos5420-smdk5420.dts                        |    3 
 arch/arm/boot/dts/qcom-ipq4019.dtsi                              |    3 
 arch/arm/boot/dts/qcom-msm8960.dtsi                              |    8 
 arch/arm/boot/dts/sama5d2.dtsi                                   |    2 
 arch/arm/boot/dts/spear1340.dtsi                                 |    6 
 arch/arm/boot/dts/spear13xx.dtsi                                 |    6 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                          |    6 
 arch/arm/mach-mmp/sram.c                                         |   22 -
 arch/arm/mach-s3c24xx/mach-jive.c                                |    6 
 arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts              |    8 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi                 |    2 
 arch/arm64/include/asm/kvm_mmu.h                                 |    3 
 arch/arm64/kernel/insn.c                                         |    4 
 arch/arm64/kernel/module.lds                                     |    6 
 arch/mips/dec/prom/Makefile                                      |    2 
 arch/mips/include/asm/dec/prom.h                                 |   15 
 arch/mips/include/asm/setup.h                                    |    2 
 arch/mips/kernel/traps.c                                         |   22 -
 arch/mips/rb532/devices.c                                        |    6 
 arch/powerpc/Makefile                                            |    2 
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi                          |    4 
 arch/powerpc/include/asm/io.h                                    |   40 +-
 arch/powerpc/include/asm/uaccess.h                               |    3 
 arch/powerpc/kernel/kvm.c                                        |    2 
 arch/powerpc/kernel/machine_kexec.c                              |   15 
 arch/powerpc/kernel/rtas.c                                       |    6 
 arch/powerpc/kvm/powerpc.c                                       |    4 
 arch/powerpc/lib/sstep.c                                         |    8 
 arch/powerpc/platforms/powernv/rng.c                             |    6 
 arch/powerpc/sysdev/fsl_gtm.c                                    |    4 
 arch/riscv/kernel/module.lds                                     |    6 
 arch/um/drivers/mconsole_kern.c                                  |    3 
 arch/x86/events/intel/pt.c                                       |    2 
 arch/x86/kernel/kvm.c                                            |    2 
 arch/x86/kvm/emulate.c                                           |   14 
 arch/x86/kvm/hyperv.c                                            |   17 -
 arch/x86/kvm/lapic.c                                             |    5 
 arch/x86/kvm/pmu_amd.c                                           |    8 
 arch/x86/power/cpu.c                                             |   21 +
 arch/x86/xen/pmu.c                                               |   10 
 arch/x86/xen/pmu.h                                               |    3 
 arch/x86/xen/smp_hvm.c                                           |    6 
 arch/x86/xen/smp_pv.c                                            |    2 
 arch/x86/xen/time.c                                              |   24 +
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi                      |    8 
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi                       |    8 
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi                        |    4 
 block/bfq-iosched.c                                              |   31 +
 block/blk-merge.c                                                |   12 
 block/blk-sysfs.c                                                |    8 
 crypto/authenc.c                                                 |    2 
 drivers/acpi/acpica/nswalk.c                                     |    3 
 drivers/acpi/apei/bert.c                                         |   10 
 drivers/acpi/apei/erst.c                                         |    2 
 drivers/acpi/apei/hest.c                                         |    2 
 drivers/acpi/cppc_acpi.c                                         |    5 
 drivers/acpi/property.c                                          |    2 
 drivers/ata/sata_dwc_460ex.c                                     |    6 
 drivers/base/power/main.c                                        |    6 
 drivers/block/drbd/drbd_int.h                                    |    8 
 drivers/block/drbd/drbd_nl.c                                     |   41 +-
 drivers/block/drbd/drbd_req.c                                    |    3 
 drivers/block/drbd/drbd_state.c                                  |   18 -
 drivers/block/drbd/drbd_state_change.h                           |    8 
 drivers/block/loop.c                                             |   10 
 drivers/block/virtio_blk.c                                       |   12 
 drivers/bluetooth/hci_serdev.c                                   |    3 
 drivers/char/hw_random/atmel-rng.c                               |    1 
 drivers/char/tpm/tpm-chip.c                                      |   46 --
 drivers/char/tpm/tpm.h                                           |    2 
 drivers/char/tpm/tpm2-space.c                                    |   65 +++
 drivers/char/virtio_console.c                                    |   15 
 drivers/clk/actions/owl-s700.c                                   |    1 
 drivers/clk/actions/owl-s900.c                                   |    2 
 drivers/clk/clk-clps711x.c                                       |    2 
 drivers/clk/clk.c                                                |   24 +
 drivers/clk/loongson1/clk-loongson1c.c                           |    1 
 drivers/clk/qcom/clk-rcg2.c                                      |    1 
 drivers/clk/qcom/gcc-ipq8074.c                                   |    2 
 drivers/clk/qcom/gcc-msm8994.c                                   |    1 
 drivers/clk/tegra/clk-emc.c                                      |    1 
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c                   |    1 
 drivers/clocksource/acpi_pm.c                                    |    6 
 drivers/clocksource/timer-of.c                                   |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                               |   16 
 drivers/crypto/mxs-dcp.c                                         |    2 
 drivers/crypto/vmx/Kconfig                                       |    4 
 drivers/dma/sh/shdma-base.c                                      |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                 |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                           |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                          |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c                        |   10 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                            |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |    3 
 drivers/gpu/drm/bridge/cdns-dsi.c                                |    1 
 drivers/gpu/drm/bridge/sil-sii8620.c                             |    2 
 drivers/gpu/drm/drm_edid.c                                       |   11 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                   |    6 
 drivers/gpu/drm/imx/parallel-display.c                           |    4 
 drivers/gpu/drm/tegra/dsi.c                                      |    4 
 drivers/hid/i2c-hid/i2c-hid-core.c                               |   32 +
 drivers/hv/hv_balloon.c                                          |    2 
 drivers/hv/vmbus_drv.c                                           |    9 
 drivers/hwmon/pmbus/pmbus.h                                      |    1 
 drivers/hwmon/pmbus/pmbus_core.c                                 |   18 -
 drivers/hwmon/sch56xx-common.c                                   |    2 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c              |    8 
 drivers/i2c/busses/i2c-xiic.c                                    |    3 
 drivers/i2c/muxes/i2c-demux-pinctrl.c                            |    5 
 drivers/iio/adc/twl6030-gpadc.c                                  |    2 
 drivers/iio/afe/iio-rescale.c                                    |    8 
 drivers/iio/inkern.c                                             |   40 +-
 drivers/input/input.c                                            |    6 
 drivers/iommu/arm-smmu-v3.c                                      |    1 
 drivers/irqchip/irq-gic-v3.c                                     |    8 
 drivers/irqchip/irq-nvic.c                                       |    2 
 drivers/irqchip/qcom-pdc.c                                       |    5 
 drivers/md/dm-crypt.c                                            |    2 
 drivers/md/dm-ioctl.c                                            |    2 
 drivers/media/pci/cx88/cx88-mpeg.c                               |    3 
 drivers/media/platform/coda/coda-common.c                        |    1 
 drivers/media/platform/davinci/vpif.c                            |    1 
 drivers/media/usb/em28xx/em28xx-cards.c                          |   13 
 drivers/media/usb/go7007/s2250-board.c                           |   10 
 drivers/media/usb/hdpvr/hdpvr-video.c                            |    4 
 drivers/media/usb/stk1160/stk1160-core.c                         |    2 
 drivers/media/usb/stk1160/stk1160-v4l.c                          |   10 
 drivers/media/usb/stk1160/stk1160.h                              |    2 
 drivers/memory/emif.c                                            |    8 
 drivers/mfd/asic3.c                                              |   10 
 drivers/mfd/mc13xxx-core.c                                       |    4 
 drivers/misc/kgdbts.c                                            |    4 
 drivers/mmc/core/host.c                                          |   15 
 drivers/mmc/host/davinci_mmc.c                                   |    6 
 drivers/mmc/host/renesas_sdhi_core.c                             |    4 
 drivers/mmc/host/sdhci-xenon.c                                   |   10 
 drivers/mtd/nand/onenand/generic.c                               |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c                     |   14 
 drivers/mtd/ubi/build.c                                          |    9 
 drivers/mtd/ubi/fastmap.c                                        |   28 +
 drivers/mtd/ubi/vmt.c                                            |    8 
 drivers/net/can/usb/ems_usb.c                                    |    1 
 drivers/net/can/usb/mcba_usb.c                                   |   27 -
 drivers/net/can/vxcan.c                                          |    2 
 drivers/net/ethernet/8390/mcf8390.c                              |   10 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                      |   29 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.h                      |    1 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                       |    3 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                  |   10 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c            |    3 
 drivers/net/ethernet/sun/sunhme.c                                |    6 
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/macvtap.c                                            |    6 
 drivers/net/phy/broadcom.c                                       |   21 +
 drivers/net/wireless/ath/ath10k/wow.c                            |    7 
 drivers/net/wireless/ath/ath5k/eeprom.c                          |    3 
 drivers/net/wireless/ath/ath9k/htc_hst.c                         |    5 
 drivers/net/wireless/ath/carl9170/main.c                         |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c          |   48 --
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c                |    2 
 drivers/net/wireless/ray_cs.c                                    |    6 
 drivers/parisc/dino.c                                            |   41 +-
 drivers/parisc/gsc.c                                             |   31 +
 drivers/parisc/gsc.h                                             |    1 
 drivers/parisc/lasi.c                                            |    7 
 drivers/parisc/wax.c                                             |    7 
 drivers/pci/access.c                                             |    9 
 drivers/pci/controller/pci-aardvark.c                            |   16 
 drivers/pci/hotplug/pciehp_hpc.c                                 |    4 
 drivers/perf/qcom_l2_pmu.c                                       |    6 
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c                    |    2 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                        |    4 
 drivers/pinctrl/pinconf-generic.c                                |    6 
 drivers/pinctrl/pinctrl-rockchip.c                               |    2 
 drivers/pinctrl/samsung/pinctrl-samsung.c                        |   30 +
 drivers/power/reset/gemini-poweroff.c                            |    4 
 drivers/power/supply/ab8500_fg.c                                 |    4 
 drivers/power/supply/axp20x_battery.c                            |   13 
 drivers/power/supply/bq24190_charger.c                           |    7 
 drivers/power/supply/wm8350_power.c                              |   97 ++++-
 drivers/ptp/ptp_sysfs.c                                          |    4 
 drivers/pwm/pwm-lpc18xx-sct.c                                    |   20 -
 drivers/regulator/qcom_smd-regulator.c                           |    4 
 drivers/remoteproc/qcom_wcnss.c                                  |    1 
 drivers/rtc/rtc-wm8350.c                                         |   11 
 drivers/scsi/aha152x.c                                           |    6 
 drivers/scsi/bfa/bfad_attr.c                                     |   26 -
 drivers/scsi/libfc/fc_exch.c                                     |    1 
 drivers/scsi/libsas/sas_ata.c                                    |    2 
 drivers/scsi/mvsas/mv_init.c                                     |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                                 |   13 
 drivers/scsi/pm8001/pm80xx_hwi.c                                 |   11 
 drivers/scsi/qla2xxx/qla_def.h                                   |    4 
 drivers/scsi/qla2xxx/qla_gs.c                                    |    5 
 drivers/scsi/qla2xxx/qla_init.c                                  |   40 +-
 drivers/scsi/qla2xxx/qla_isr.c                                   |    1 
 drivers/scsi/qla2xxx/qla_target.c                                |    1 
 drivers/scsi/zorro7xx.c                                          |    2 
 drivers/soc/ti/wkup_m3_ipc.c                                     |    4 
 drivers/spi/spi-bcm-qspi.c                                       |    4 
 drivers/spi/spi-pxa2xx-pci.c                                     |   17 -
 drivers/spi/spi-tegra114.c                                       |    4 
 drivers/spi/spi-tegra20-slink.c                                  |    8 
 drivers/spi/spi.c                                                |    4 
 drivers/staging/iio/adc/ad7280a.c                                |    4 
 drivers/thermal/int340x_thermal/int3400_thermal.c                |    2 
 drivers/tty/hvc/hvc_iucv.c                                       |    4 
 drivers/tty/mxser.c                                              |   15 
 drivers/tty/serial/8250/8250_mid.c                               |   19 -
 drivers/tty/serial/8250/8250_port.c                              |   12 
 drivers/tty/serial/kgdboc.c                                      |    6 
 drivers/tty/serial/samsung.c                                     |    5 
 drivers/usb/dwc3/dwc3-omap.c                                     |    2 
 drivers/usb/host/ehci-pci.c                                      |    9 
 drivers/usb/host/xhci-hub.c                                      |    2 
 drivers/usb/host/xhci-mem.c                                      |    2 
 drivers/usb/host/xhci.c                                          |   20 -
 drivers/usb/host/xhci.h                                          |    7 
 drivers/usb/serial/Kconfig                                       |    1 
 drivers/usb/serial/pl2303.c                                      |    1 
 drivers/usb/serial/pl2303.h                                      |    3 
 drivers/usb/serial/usb-serial-simple.c                           |    7 
 drivers/usb/storage/ene_ub6250.c                                 |  155 ++++-----
 drivers/usb/storage/realtek_cr.c                                 |    2 
 drivers/video/fbdev/atafb.c                                      |   12 
 drivers/video/fbdev/cirrusfb.c                                   |   16 
 drivers/video/fbdev/core/fbcvt.c                                 |   53 +--
 drivers/video/fbdev/nvidia/nv_i2c.c                              |    2 
 drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c        |    1 
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c         |    8 
 drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c |    2 
 drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c |    4 
 drivers/video/fbdev/sm712fb.c                                    |   46 --
 drivers/video/fbdev/smscufx.c                                    |    3 
 drivers/video/fbdev/udlfb.c                                      |    8 
 drivers/video/fbdev/w100fb.c                                     |   15 
 drivers/w1/slaves/w1_therm.c                                     |    8 
 fs/btrfs/extent_io.h                                             |    2 
 fs/ext2/super.c                                                  |    6 
 fs/ext4/inode.c                                                  |   25 +
 fs/f2fs/gc.c                                                     |    4 
 fs/fuse/dev.c                                                    |   12 
 fs/fuse/file.c                                                   |    1 
 fs/fuse/fuse_i.h                                                 |    2 
 fs/gfs2/rgrp.c                                                   |    3 
 fs/jffs2/build.c                                                 |    4 
 fs/jffs2/fs.c                                                    |    2 
 fs/jffs2/scan.c                                                  |    6 
 fs/jfs/inode.c                                                   |    3 
 fs/jfs/jfs_dmap.c                                                |    7 
 fs/minix/inode.c                                                 |    3 
 fs/nfs/callback_proc.c                                           |   27 -
 fs/nfs/callback_xdr.c                                            |    4 
 fs/nfs/direct.c                                                  |   48 +-
 fs/nfs/file.c                                                    |    4 
 fs/nfs/nfs4state.c                                               |   12 
 fs/nfs/pnfs.c                                                    |   11 
 fs/nfs/pnfs.h                                                    |    2 
 fs/nfsd/nfsproc.c                                                |    2 
 fs/nfsd/xdr.h                                                    |    2 
 fs/ntfs/inode.c                                                  |    4 
 fs/ubifs/dir.c                                                   |   44 +-
 fs/ubifs/io.c                                                    |   34 +-
 fs/ubifs/ioctl.c                                                 |    2 
 include/linux/blk-cgroup.h                                       |   17 +
 include/linux/blkdev.h                                           |    8 
 include/linux/mmzone.h                                           |   11 
 include/linux/netdevice.h                                        |    6 
 include/linux/nfs_fs.h                                           |    8 
 include/linux/pci.h                                              |    1 
 include/linux/sunrpc/xdr.h                                       |    2 
 include/net/arp.h                                                |    1 
 include/net/sock.h                                               |   25 +
 include/net/xfrm.h                                               |   11 
 include/uapi/linux/bpf.h                                         |    4 
 init/main.c                                                      |    6 
 kernel/cgroup/cgroup-internal.h                                  |   19 +
 kernel/cgroup/cgroup-v1.c                                        |   33 +
 kernel/cgroup/cgroup.c                                           |   81 +++-
 kernel/dma/debug.c                                               |    4 
 kernel/events/core.c                                             |    3 
 kernel/power/hibernate.c                                         |    2 
 kernel/power/suspend_test.c                                      |    8 
 kernel/printk/printk.c                                           |    6 
 kernel/ptrace.c                                                  |   47 +-
 kernel/sched/debug.c                                             |   10 
 lib/raid6/test/Makefile                                          |    4 
 lib/raid6/test/test.c                                            |    1 
 lib/test_kmod.c                                                  |    1 
 mm/memcontrol.c                                                  |    2 
 mm/memory.c                                                      |   42 +-
 mm/mempolicy.c                                                   |    9 
 mm/mmap.c                                                        |    2 
 mm/mremap.c                                                      |    3 
 mm/page_alloc.c                                                  |    9 
 mm/rmap.c                                                        |   25 +
 mm/usercopy.c                                                    |    5 
 net/bluetooth/hci_event.c                                        |    3 
 net/can/raw.c                                                    |    2 
 net/ipv4/arp.c                                                   |    9 
 net/ipv4/fib_frontend.c                                          |    5 
 net/ipv4/raw.c                                                   |    2 
 net/ipv4/tcp_output.c                                            |    5 
 net/ipv6/raw.c                                                   |    2 
 net/ipv6/xfrm6_output.c                                          |   16 
 net/key/af_key.c                                                 |    6 
 net/netfilter/nf_conntrack_proto_tcp.c                           |   17 -
 net/netlink/af_netlink.c                                         |    2 
 net/openvswitch/actions.c                                        |    2 
 net/openvswitch/flow_netlink.c                                   |    8 
 net/packet/af_packet.c                                           |    6 
 net/rxrpc/net_ns.c                                               |    2 
 net/smc/smc_core.c                                               |    2 
 net/sunrpc/sched.c                                               |    4 
 net/sunrpc/xprt.c                                                |    7 
 net/sunrpc/xprtrdma/transport.c                                  |    4 
 net/x25/af_x25.c                                                 |   11 
 net/xfrm/xfrm_interface.c                                        |    5 
 net/xfrm/xfrm_policy.c                                           |   32 -
 net/xfrm/xfrm_user.c                                             |   18 -
 security/selinux/xfrm.c                                          |    2 
 security/smack/smack_lsm.c                                       |    2 
 security/tomoyo/load_policy.c                                    |    4 
 sound/firewire/fcp.c                                             |    4 
 sound/isa/cs423x/cs4236.c                                        |    8 
 sound/pci/hda/patch_realtek.c                                    |    4 
 sound/soc/atmel/atmel_ssc_dai.c                                  |    5 
 sound/soc/atmel/sam9g20_wm8731.c                                 |    1 
 sound/soc/codecs/msm8916-wcd-digital.c                           |    5 
 sound/soc/codecs/rt5663.c                                        |    2 
 sound/soc/codecs/wm8350.c                                        |   28 +
 sound/soc/davinci/davinci-i2s.c                                  |    5 
 sound/soc/fsl/imx-es8328.c                                       |    1 
 sound/soc/mxs/mxs-saif.c                                         |    5 
 sound/soc/mxs/mxs-sgtl5000.c                                     |    3 
 sound/soc/sh/fsi.c                                               |   19 -
 sound/soc/soc-core.c                                             |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                            |    6 
 sound/soc/soc-topology.c                                         |    3 
 sound/spi/at73c213.c                                             |   27 +
 tools/build/feature/Makefile                                     |    9 
 tools/include/uapi/linux/bpf.h                                   |    4 
 tools/perf/Makefile.config                                       |    3 
 tools/testing/selftests/bpf/test_lirc_mode2.sh                   |    5 
 tools/testing/selftests/cgroup/cgroup_util.c                     |    2 
 tools/testing/selftests/cgroup/test_core.c                       |  167 ++++++++++
 tools/testing/selftests/x86/check_cc.sh                          |    2 
 virt/kvm/kvm_main.c                                              |   13 
 357 files changed, 2468 insertions(+), 1115 deletions(-)

Aashish Sharma (1):
      dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Adrian Hunter (2):
      perf/core: Fix address filter parser for multiple filters
      perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Alan Stern (1):
      USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Alex Deucher (1):
      drm/amdkfd: make CRAT table missing message informational only

Alexander Lobakin (1):
      MIPS: fix fortify panic when copying asm exception handlers

Alexey Khoroshilov (1):
      NFS: remove unneeded check in decode_devicenotify_args()

Alistair Popple (1):
      mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Amadeusz Sławiński (1):
      ASoC: topology: Allow TLV control to be either read or write

Anders Roxell (3):
      powerpc/lib/sstep: Fix 'sthcx' instruction
      powerpc/lib/sstep: Fix build errors with newer binutils
      powerpc: Fix build errors with newer binutils

Andreas Gruenbacher (1):
      powerpc/kvm: Fix kvm_use_magic_page

Andrew Price (1):
      gfs2: Make sure FITRIM minlen is rounded up to fs block size

Andy Shevchenko (2):
      spi: pxa2xx-pci: Balance reference count for PCI DMA device
      serial: 8250_mid: Balance reference count for PCI DMA device

Anisse Astier (1):
      drm: Add orientation quirk for GPD Win Max

Anssi Hannula (1):
      hv_balloon: rate-limit "Unhandled message" warning

Anton Ivanov (1):
      um: Fix uml_mconsole stop/go

Armin Wolf (1):
      hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Arnaldo Carvalho de Melo (2):
      tools build: Filter out options and warnings not supported by clang
      tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Bagas Sanjaya (2):
      Documentation: add link to stable release candidate tree
      Documentation: update stable tree link

Baokun Li (5):
      jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
      jffs2: fix memory leak in jffs2_do_mount_fs
      jffs2: fix memory leak in jffs2_scan_medium
      ubifs: rename_whiteout: correct old_dir size computing
      ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl

Bas Nieuwenhuizen (1):
      drm/amdgpu: Check if fd really is an amdgpu fd.

Bharata B Rao (1):
      sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Biju Das (2):
      spi: Fix invalid sgs value
      spi: Fix erroneous sgs value with min_t()

Brandon Wyman (1):
      hwmon: (pmbus) Add Vin unit off handling

Casey Schaufler (1):
      Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni (1):
      loop: use sysfs_emit() in the sysfs xxx show()

Chao Yu (1):
      f2fs: fix to unlock page correctly in error path of is_alive()

Chen-Yu Tsai (2):
      pinctrl: pinconf-generic: Print arguments for bias-pull-*
      net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

Christian Göttsche (1):
      selinux: use correct type for context length

Christian Lamparter (1):
      ata: sata_dwc_460ex: Fix crash due to OOB write

Christophe JAILLET (1):
      scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

Claudiu Beznea (1):
      hwrng: atmel - disable trng on failure path

Codrin Ciubotariu (1):
      ASoC: dmaengine: do not use a NULL prepare_slave_config() callback

Colin Ian King (2):
      carl9170: fix missing bit-wise or operator for tx_params
      iwlwifi: Fix -EIO error code that is never returned

Cooper Chiou (1):
      drm/edid: check basic audio support on CEA extension block

Dafna Hirschfeld (1):
      media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED

Damien Le Moal (6):
      scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
      scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
      scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
      scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
      scsi: pm8001: Fix abort all task initialization
      scsi: pm8001: Fix pm8001_mpi_task_abort_resp()

Dan Carpenter (7):
      NFSD: prevent underflow in nfssvc_decode_writeargs()
      NFSD: prevent integer overflow on 32 bit systems
      video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
      media: usb: go7007: s2250-board: fix leak in probe()
      USB: storage: ums-realtek: fix error code in rts51x_read_mem()
      lib/test: use after free in register_test_dev_kmod()
      drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

Daniel González Cabanelas (1):
      media: cx88-mpeg: clear interrupt status register before streaming video

Darren Hart (1):
      ACPI/APEI: Limit printable size of BERT table data

David Heidelberg (1):
      ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960

David Matlack (1):
      KVM: Prevent module exit until all VMs are freed

Dirk Buchwalder (1):
      clk: qcom: ipq8074: Use floor ops for SDCC1 clock

Dirk Müller (1):
      lib/raid6/test: fix multiple definition linking error

Dmitry Baryshkov (1):
      PM: core: keep irq flags in device_pm_check_callbacks()

Dmitry Torokhov (1):
      HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Dongli Zhang (1):
      xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Dongliang Mu (3):
      media: em28xx: initialize refcount before kref_get
      ntfs: add sanity check on allocation size
      media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Duoming Zhou (2):
      drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
      net/x25: Fix null-ptr-deref caused by x25_disconnect

Dust Li (1):
      net/smc: correct settings of RMB window update limit

Dāvis Mosāns (1):
      crypto: ccp - ccp_dmaengine_unregister release dma channels

Eddie James (1):
      USB: serial: pl2303: add IBM device IDs

Eric Biggers (1):
      block: don't delete queue kobject before its children

Eric Dumazet (1):
      rxrpc: fix a race in rxrpc_exit_net()

Ethan Lien (1):
      btrfs: fix qgroup reserve overflow the qgroup limit

Evgeny Boger (1):
      power: supply: axp20x_battery: properly report current when discharging

Evgeny Novikov (1):
      video: fbdev: w100fb: Reset global state

Fabiano Rosas (1):
      KVM: PPC: Fix vmx/vsx mixup in mmio emulation

Fangrui Song (2):
      riscv module: remove (NOLOAD)
      arm64: module: remove (NOLOAD) from linker script

Felix Kuehling (1):
      drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

Florian Fainelli (1):
      net: phy: broadcom: Fix brcm_fet_config_init()

Frank Wunderlich (1):
      arm64: dts: broadcom: Fix sata nodename

George Kennedy (1):
      video: fbdev: cirrusfb: check pixclock to avoid divide by zero

Greg Kroah-Hartman (1):
      Linux 4.19.238

Guilherme G. Piccoli (1):
      Drivers: hv: vmbus: Fix potential crash on module unload

Guillaume Ranquet (1):
      clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()

Guo Ren (1):
      arm64: patch_text: Fixup last cpu should be master

H. Nikolaus Schaller (1):
      usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Haimin Zhang (2):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
      jfs: prevent NULL deref in diFree

Hangbin Liu (1):
      selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Hangyu Hua (2):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
      can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Hans de Goede (1):
      power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return

Hector Martin (2):
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio

Helge Deller (2):
      video: fbdev: sm712fb: Fix crash in smtcfb_read()
      parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Hengqi Chen (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

Herbert Xu (1):
      crypto: authenc - Fix sleep in atomic context in decrypt_tail

Hou Wenlong (1):
      KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Hugh Dickins (1):
      mempolicy: mbind_range() set_policy() after vma_merge()

Ido Schimmel (1):
      ipv4: Invalidate neighbour for broadcast address upon address addition

Ilya Maximets (1):
      net: openvswitch: don't send internal clone attribute to the userspace.

Jakob Koschel (1):
      powerpc/sysdev: fix incorrect use to determine if list is empty

Jakub Kicinski (1):
      tcp: ensure PMTU updates are processed during fastopen

James Clark (1):
      coresight: Fix TRCCONFIGR.QE sysfs interface

James Morse (1):
      KVM: arm64: Check arm64_get_bp_hardening_data() didn't return NULL

Jamie Bainbridge (1):
      qede: confirm skb is allocated before using

Jann Horn (1):
      ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE

Jia-Ju Bai (2):
      ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()
      memory: emif: check the pointer temp in get_device_details()

Jianglei Nie (1):
      scsi: libfc: Fix use after free in fc_exch_abts_resp()

Jiasheng Jiang (15):
      ASoC: ti: davinci-i2s: Add check for clk_enable()
      ALSA: spi: Add check for clk_enable()
      ASoC: mxs-saif: Handle errors for clk_enable
      ASoC: atmel_ssc_dai: Handle errors for clk_enable
      memory: emif: Add check for setup_interrupts
      ASoC: wm8350: Handle error for wm8350_register_irq
      ASoC: fsi: Add check for clk_enable
      mmc: davinci_mmc: Handle error for clk_enable
      mtd: onenand: Check for error irq
      ray_cs: Check ioremap return value
      power: supply: wm8350-power: Handle error for wm8350_register_irq
      power: supply: wm8350-power: Add missing free in free_charger_irq
      mfd: mc13xxx: Add check for mc13xxx_irq_request
      iio: adc: Add check for devm_request_threaded_irq
      rtc: wm8350: Handle error for wm8350_register_irq

Jim Mattson (1):
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Jing Yao (3):
      video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
      video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()
      video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit

Jiri Slaby (2):
      mxser: fix xmit_buf leak in activate when LSR == 0xff
      serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

Joe Carnuccio (1):
      scsi: qla2xxx: Check for firmware dump already collected

Johan Hovold (2):
      USB: serial: simple: add Nokia phone driver
      media: davinci: vpif: fix unbalanced runtime PM get

Jonathan Cameron (1):
      staging:iio:adc:ad7280a: Fix handing of device address bit reversing.

Jonathan Neuschäfer (3):
      clk: actions: Terminate clk_div_table with sentinel element
      clk: loongson1: Terminate clk_div_table with sentinel element
      clk: clps711x: Terminate clk_div_table with sentinel element

Jordy Zomer (1):
      dm ioctl: prevent potential spectre v1 gadget

José Expósito (2):
      Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
      drm/imx: Fix memory leak in imx_pd_connector_get_modes

Juergen Gross (1):
      xen: fix is_xen_pmu()

Kai-Heng Feng (1):
      ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020

Kamal Dasu (1):
      spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Konrad Dybcio (1):
      clk: qcom: gcc-msm8994: Fix gpll4 width

Krzysztof Kozlowski (4):
      pinctrl: samsung: drop pin banks references on error paths
      ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5420

Kuldeep Singh (3):
      arm64: dts: ns2: Fix spi-cpol and spi-cpha property
      ARM: dts: spear1340: Update serial node properties
      ARM: dts: spear13xx: Update SPI dma properties

Kunihiko Hayashi (1):
      clk: uniphier: Fix fixed-rate initialization

Lars Ellenberg (1):
      drbd: fix potential silent data corruption

Li RongQing (1):
      KVM: x86: fix sending PV IPI

Liam Beguin (4):
      iio: afe: rescale: use s64 for temporary scale calculations
      iio: inkern: apply consumer scale on IIO_VAL_INT cases
      iio: inkern: apply consumer scale when no channel scale is available
      iio: inkern: make a best effort on offset calculation

Liguang Zhang (1):
      PCI: pciehp: Clear cmd_busy bit in polling mode

Lina Wang (1):
      xfrm: fix tunnel model fragmentation behavior

Lino Sanfilippo (1):
      tpm: fix reference counting for struct tpm_chip

Lucas Denefle (1):
      w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Luiz Augusto von Dentz (1):
      Bluetooth: Fix use after free in hci_send_acl

Lv Yunlong (1):
      drbd: Fix five use after free bugs in get_initial_state

Maciej W. Rozycki (1):
      DEC: Limit PMAX memory probing to R3k systems

Manish Chopra (2):
      qed: display VF trust config
      qed: validate and restrict untrusted VFs vlan promisc mode

Manish Rangankar (1):
      scsi: qla2xxx: Use correct feature type field during RFF_ID processing

Manivannan Sadhasivam (1):
      PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Marc Zyngier (2):
      irqchip/qcom-pdc: Fix broken locking
      irqchip/gic-v3: Fix GICR_CTLR.RWP polling

Mark Tomlinson (1):
      PCI: Reduce warnings on possible RW1C corruption

Martin Varghese (1):
      openvswitch: Fixed nd target mask field in the flow dump.

Mathias Nyman (1):
      xhci: make xhci_handshake timeout for xhci_reset() adjustable

Mauricio Faria de Oliveira (1):
      mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Max Filippov (1):
      xtensa: fix DTC warning unit_address_format

Maxim Kiselev (1):
      powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Maxime Ripard (2):
      drm/edid: Don't clear formats if using deep color
      clk: Enforce that disjoints limits are invalid

Miaohe Lin (1):
      mm/mempolicy: fix mpol_new leak in shared_policy_replace

Miaoqian Lin (17):
      spi: tegra114: Add missing IRQ check in tegra_spi_probe
      media: coda: Fix missing put_device() call in coda_get_vdoa_data
      soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe
      ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe
      video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
      ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
      ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe
      drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev
      power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe
      power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
      drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
      mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
      remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
      clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver
      pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init
      pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe
      pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe

Michael Chan (1):
      bnxt_en: Eliminate unintended link toggle during FW reset

Michael Ellerman (1):
      powerpc/Makefile: Don't pass -mcpu=powerpc64 when building 32-bit

Michael S. Tsirkin (1):
      virtio_console: break out of buf poll on remove

Michael Schmitz (1):
      video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Miklos Szeredi (1):
      fuse: fix pipe buffer lifetime for direct_io

Minghao Chi (1):
      spi: tegra20: Use of_device_get_match_data()

Minghao Chi (CGEL ZTE) (1):
      net:mcf8390: Use platform_get_irq() to get the interrupt

Muhammad Usama Anjum (1):
      selftests/x86: Add validity check and allow field splitting

Neal Liu (1):
      usb: ehci: add pci device support for Aspeed platforms

NeilBrown (4):
      SUNRPC: avoid race between mod_timer() and del_timer_sync()
      SUNRPC/call_alloc: async tasks mustn't block waiting for memory
      NFS: swap IO handling is slightly different for O_DIRECT IO
      NFS: swap-out must always use STABLE writes.

Nilesh Javali (1):
      scsi: qla2xxx: Fix warning for missing error code

Nishanth Menon (1):
      drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt

Oliver Hartkopp (1):
      vxcan: enable local echo for sent CAN frames

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Pali Rohár (2):
      PCI: aardvark: Fix support for MSI interrupts
      Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Paolo Bonzini (1):
      mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Paolo Valente (1):
      Revert "Revert "block, bfq: honor already-setup queue merges""

Patrick Rudolph (1):
      hwmon: (pmbus) Add mutex to regulator ops

Paul Menzel (1):
      lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3

Pavel Kubelun (1):
      ARM: dts: qcom: ipq4019: fix sleep clock

Pavel Skripkin (5):
      Bluetooth: hci_serdev: call init_rwsem() before p->open()
      ath9k_htc: fix uninit value bugs
      jfs: fix divide error in dbNextAG
      media: Revert "media: em28xx: add missing em28xx_close_extension"
      can: mcba_usb: properly check endpoint type

Pawan Gupta (2):
      x86/pm: Save the MSR validity status at context setup
      x86/speculation: Restore speculation related MSRs during S3 resume

Peter Rosin (1):
      i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Peter Xu (1):
      mm: don't skip swap entry even if zap_details specified

Petr Machata (1):
      af_netlink: Fix shift out of bounds in group mask calculation

Petr Vorel (1):
      crypto: vmx - add missing dependencies

Qinghua Jin (1):
      minix: fix bug when opening a file with O_DIRECT

Quinn Tran (4):
      scsi: qla2xxx: Fix stuck session in gpdb
      scsi: qla2xxx: Fix incorrect reporting of task management failure
      scsi: qla2xxx: Fix hang due to session stuck
      scsi: qla2xxx: Reduce false trigger to login

Rafael J. Wysocki (2):
      ACPICA: Avoid walking the ACPI Namespace if it is not there
      ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Randy Dunlap (18):
      PM: hibernate: fix __setup handler error handling
      PM: suspend: fix return value of __setup handler
      ACPI: APEI: fix return value of __setup handlers
      clocksource: acpi_pm: fix return value of __setup handler
      printk: fix return value of printk.devkmsg __setup handler
      TOMOYO: fix __setup handlers return values
      MIPS: RB532: fix return value of __setup handler
      dma-debug: fix return value of __setup handlers
      tty: hvc: fix return value of __setup handler
      kgdboc: fix return value of __setup handler
      kgdbts: fix return value of __setup handler
      mm/mmap: return 1 from stack_guard_gap __setup() handler
      mm/memcontrol: return 1 from cgroup.memory __setup() handler
      mm/usercopy: return 1 from hardened_usercopy __setup() handler
      ARM: 9187/1: JIVE: fix return value of __setup handler
      scsi: aha152x: Fix aha152x_setup() __setup handler return value
      init/main.c: return 1 from handled __setup() functions
      virtio_console: eliminate anonymous module_init & module_exit

Richard Leitner (1):
      ARM: tegra: tamonten: Fix I2C3 pad setting

Richard Schleich (1):
      ARM: dts: bcm2837: Add the missing L1/L2 cache information

Rik van Riel (2):
      mm: invalidate hwpoison page cache page in fault path
      mm,hwpoison: unmap poisoned page before invalidation

Robert Hancock (1):
      i2c: xiic: Make bus names unique

Sakari Ailus (1):
      ACPI: properties: Consistently return -ENOENT if there are no more references

Saurav Kashyap (1):
      scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Shengjiu Wang (1):
      ASoC: soc-core: skip zero num_dai component in searching dai name

Souptick Joarder (HPE) (1):
      irqchip/nvic: Release nvic_base upon failure

Sourabh Jain (1):
      powerpc: Set crashkernel offset to mid of RMA region

Srinivas Pandruvada (1):
      thermal: int340x: Increase bitmap size

Sven Eckelmann (1):
      macvtap: advertise link netns via netlink

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Taniya Das (1):
      clk: qcom: clk-rcg2: Update the frac table for pixel clock

Tejun Heo (7):
      block: don't merge across cgroup boundaries if blkcg is enabled
      cgroup: Use open-time credentials for process migraton perm checks
      cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
      cgroup: Use open-time cgroup namespace for process migration perm checks
      selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
      selftests: cgroup: Test open-time credential usage for migration checks
      selftests: cgroup: Test open-time cgroup namespace usage for migration checks

Theodore Ts'o (1):
      ext4: don't BUG if someone dirty pages without asking ext4 first

Tim Gardner (1):
      video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow

Tom Rix (1):
      qlcnic: dcb: default to returning -EOPNOTSUPP

Tomas Paukrt (1):
      crypto: mxs-dcp - Fix scatterlist processing

Trond Myklebust (2):
      NFSv4/pNFS: Fix another issue with a list iterator pointing to the head
      NFSv4: Protect the state recovery thread against direct reclaim

Tudor Ambarus (1):
      ARM: dts: at91: sama5d2: Fix PMERRLOC resource size

Ulf Hansson (1):
      mmc: host: Return an error when ->enable_sdio_irq() ops is missing

Uwe Kleine-König (3):
      pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()
      serial: 8250: Fix race condition in RTS-after-send handling
      ARM: mmp: Fix failure to remove sram device

Vinod Koul (1):
      dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Vitaly Kuznetsov (1):
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Waiman Long (1):
      mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Wang Hai (1):
      video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()

Wang Wensheng (1):
      ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Wen Gong (1):
      ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern

Willem de Bruijn (1):
      net: add missing SOF_TIMESTAMPING_OPT_ID support

Wolfram Sang (1):
      mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Xiaomeng Tong (2):
      ALSA: cs4236: fix an incorrect NULL check on list iterator
      perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Xie Yongji (2):
      block: Add a helper to validate the block size
      virtio-blk: Use blk_validate_block_size() to validate block size

Xin Long (1):
      xfrm: policy: match with both mark and mask on user interfaces

Xin Xiong (2):
      mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init
      drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj

Yajun Deng (1):
      netdevice: add the case if dev is NULL

Yang Guang (4):
      video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
      ptp: replace snprintf with sysfs_emit
      scsi: mvsas: Replace snprintf() with sysfs_emit()
      scsi: bfa: Replace snprintf() with sysfs_emit()

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zhang Wensheng (1):
      bfq: fix use-after-free in bfq_dispatch_request

Zhang Yi (1):
      ext2: correct max file size computing

Zhenzhong Duan (1):
      KVM: x86: Fix emulation in writing cr8

Zheyu Ma (2):
      ethernet: sun: Free the coherent when failing in probing
      video: fbdev: sm712fb: Fix crash in smtcfb_write()

Zhihao Cheng (7):
      ubifs: rename_whiteout: Fix double free for whiteout_ui->data
      ubifs: Fix deadlock in concurrent rename whiteout and inode writeback
      ubifs: Add missing iput if do_tmpfile() failed in rename whiteout
      ubifs: setflags: Make dirtied_ino_d 8 bytes aligned
      ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()
      ubi: fastmap: Return error code if memory allocation fails in add_aeb()
      ubifs: Rectify space amount budget for mkdir/tmpfile operations

Zhou Guanghui (1):
      iommu/arm-smmu-v3: fix event handling soft lockup

Zhou Qingyang (1):
      drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()

kernel test robot (1):
      regulator: qcom_smd: fix for_each_child.cocci warnings

