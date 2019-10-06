Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6910ECD000
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 11:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfJFJWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 05:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfJFJWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 05:22:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B64206C2;
        Sun,  6 Oct 2019 09:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570353742;
        bh=vLLG1lctCh4S8fNEJCsd8gVP/lGkv+C7w73scbQ/iWk=;
        h=Date:From:To:Cc:Subject:From;
        b=XV/VY5aGCN82qzFlgaeMUmCiPD94SsUg2iNuoNagGXrCXvITWzXBRX6UR9K6mIn+a
         2fF09jsLXQOrXqCorONYaMWPiKT3325UJFkdhaVdgLXec0Wv9voX3HU6gKkyDqsAcY
         yzbta35D4eFbPoBy7+rUyWBIlo3W65RkxpU3eU/o=
Date:   Sun, 6 Oct 2019 11:22:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.19
Message-ID: <20191006092220.GA2768181@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.19 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/sound/hd-audio/models.rst                 |    3=20
 Makefile                                                |    2=20
 arch/arm/boot/dts/am3517-evm.dts                        |   23 -
 arch/arm/boot/dts/exynos5420-peach-pit.dts              |    1=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts               |    1=20
 arch/arm/boot/dts/imx7-colibri.dtsi                     |    1=20
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts                 |    4=20
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi        |   37 -
 arch/arm/configs/omap2plus_defconfig                    |    1=20
 arch/arm/mach-at91/.gitignore                           |    1=20
 arch/arm/mach-at91/Makefile                             |    5=20
 arch/arm/mach-at91/pm_suspend.S                         |    2=20
 arch/arm/mach-ep93xx/edb93xx.c                          |    2=20
 arch/arm/mach-ep93xx/simone.c                           |    2=20
 arch/arm/mach-ep93xx/ts72xx.c                           |    4=20
 arch/arm/mach-ep93xx/vision_ep9307.c                    |    2=20
 arch/arm/mach-omap2/.gitignore                          |    1=20
 arch/arm/mach-omap2/Makefile                            |    5=20
 arch/arm/mach-omap2/sleep33xx.S                         |    2=20
 arch/arm/mach-omap2/sleep43xx.S                         |    2=20
 arch/arm/mach-zynq/platsmp.c                            |    2=20
 arch/arm/mm/copypage-xscale.c                           |    6=20
 arch/arm/plat-samsung/watchdog-reset.c                  |    1=20
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                |    3=20
 arch/arm64/include/asm/cputype.h                        |   21 -
 arch/arm64/include/asm/exception.h                      |    2=20
 arch/arm64/include/asm/tlbflush.h                       |    1=20
 arch/arm64/kernel/cpufeature.c                          |    2=20
 arch/arm64/kernel/entry.S                               |   36 -
 arch/arm64/kernel/image-vars.h                          |   51 ++
 arch/arm64/kernel/image.h                               |   42 --
 arch/arm64/kernel/traps.c                               |    9=20
 arch/arm64/kernel/vmlinux.lds.S                         |    2=20
 arch/arm64/mm/init.c                                    |    6=20
 arch/arm64/mm/proc.S                                    |    9=20
 arch/ia64/kernel/module.c                               |    8=20
 arch/m68k/include/asm/atarihw.h                         |    9=20
 arch/m68k/include/asm/io_mm.h                           |    6=20
 arch/m68k/include/asm/macintosh.h                       |    1=20
 arch/powerpc/Makefile                                   |    2=20
 arch/powerpc/platforms/powernv/opal-imc.c               |   12=20
 arch/s390/crypto/aes_s390.c                             |    6=20
 arch/s390/include/asm/string.h                          |    9=20
 arch/x86/include/asm/intel-family.h                     |    3=20
 arch/x86/include/asm/kvm_host.h                         |    7=20
 arch/x86/kernel/amd_nb.c                                |    3=20
 arch/x86/kernel/apic/apic.c                             |  115 +++--
 arch/x86/kernel/apic/vector.c                           |   11=20
 arch/x86/kernel/smp.c                                   |   46 +-
 arch/x86/kvm/emulate.c                                  |    2=20
 arch/x86/kvm/mmu.c                                      |   47 +-
 arch/x86/kvm/svm.c                                      |    4=20
 arch/x86/kvm/vmx/vmx.c                                  |    6=20
 arch/x86/kvm/x86.c                                      |   21 -
 arch/x86/mm/numa.c                                      |    4=20
 arch/x86/mm/pti.c                                       |    8=20
 arch/x86/platform/intel/iosf_mbi.c                      |  100 ++--
 block/blk-flush.c                                       |   10=20
 block/blk-mq.c                                          |   25 -
 block/blk-throttle.c                                    |    3=20
 block/blk.h                                             |    7=20
 block/mq-deadline.c                                     |   19=20
 drivers/acpi/acpi_lpss.c                                |    8=20
 drivers/acpi/acpi_processor.c                           |   10=20
 drivers/acpi/apei/ghes.c                                |   17=20
 drivers/acpi/cppc_acpi.c                                |    6=20
 drivers/acpi/custom_method.c                            |    5=20
 drivers/acpi/pci_irq.c                                  |    4=20
 drivers/ata/ahci.c                                      |  116 +++--
 drivers/ata/ahci.h                                      |    2=20
 drivers/base/soc.c                                      |    2=20
 drivers/block/loop.c                                    |    1=20
 drivers/block/nbd.c                                     |    4=20
 drivers/char/hw_random/core.c                           |    2=20
 drivers/char/ipmi/ipmi_msghandler.c                     |  114 ++---
 drivers/char/mem.c                                      |   21 +
 drivers/char/tpm/tpm-interface.c                        |   23 -
 drivers/char/tpm/tpm_tis_core.c                         |    3=20
 drivers/cpufreq/armada-8k-cpufreq.c                     |    2=20
 drivers/cpuidle/governors/teo.c                         |   32 -
 drivers/devfreq/devfreq.c                               |    2=20
 drivers/devfreq/exynos-bus.c                            |   31 -
 drivers/devfreq/governor_passive.c                      |    7=20
 drivers/dma/bcm2835-dma.c                               |    4=20
 drivers/dma/iop-adma.c                                  |   18=20
 drivers/dma/ti/edma.c                                   |    9=20
 drivers/edac/altera_edac.c                              |    4=20
 drivers/edac/amd64_edac.c                               |  151 ++++---
 drivers/edac/amd64_edac.h                               |    5=20
 drivers/edac/edac_mc.c                                  |    8=20
 drivers/edac/pnd2_edac.c                                |    7=20
 drivers/firmware/arm_scmi/driver.c                      |    8=20
 drivers/firmware/efi/cper.c                             |   15=20
 drivers/firmware/qcom_scm.c                             |    7=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |    1=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c        |    5=20
 drivers/gpu/drm/drm_kms_helper_common.c                 |    2=20
 drivers/hwmon/acpi_power_meter.c                        |    4=20
 drivers/hwmon/k10temp.c                                 |    1=20
 drivers/i2c/busses/i2c-riic.c                           |    1=20
 drivers/infiniband/core/addr.c                          |    2=20
 drivers/infiniband/core/uverbs_cmd.c                    |    3=20
 drivers/infiniband/hw/hfi1/mad.c                        |   45 --
 drivers/infiniband/hw/hfi1/verbs.c                      |   17=20
 drivers/infiniband/hw/mlx5/main.c                       |    1=20
 drivers/iommu/Makefile                                  |    2=20
 drivers/iommu/amd_iommu.c                               |    4=20
 drivers/iommu/amd_iommu.h                               |   14=20
 drivers/iommu/amd_iommu_init.c                          |    5=20
 drivers/iommu/amd_iommu_quirks.c                        |   92 ++++
 drivers/iommu/arm-smmu-v3.c                             |    2=20
 drivers/iommu/intel_irq_remapping.c                     |    6=20
 drivers/iommu/iova.c                                    |    4=20
 drivers/irqchip/irq-gic-v3-its.c                        |    9=20
 drivers/irqchip/irq-sifive-plic.c                       |   12=20
 drivers/isdn/mISDN/socket.c                             |    2=20
 drivers/leds/led-triggers.c                             |    1=20
 drivers/leds/leds-lm3532.c                              |   17=20
 drivers/leds/leds-lp5562.c                              |    6=20
 drivers/md/bcache/closure.c                             |   10=20
 drivers/md/dm-rq.c                                      |    1=20
 drivers/md/md.c                                         |   28 -
 drivers/md/md.h                                         |    3=20
 drivers/md/raid0.c                                      |   33 +
 drivers/md/raid0.h                                      |   14=20
 drivers/md/raid1.c                                      |   39 +
 drivers/md/raid5.c                                      |   10=20
 drivers/media/cec/cec-notifier.c                        |    2=20
 drivers/media/common/videobuf2/videobuf2-v4l2.c         |    8=20
 drivers/media/dvb-core/dvb_frontend.c                   |    4=20
 drivers/media/dvb-core/dvbdev.c                         |    4=20
 drivers/media/dvb-frontends/dvb-pll.c                   |   40 +
 drivers/media/i2c/ov5640.c                              |    5=20
 drivers/media/i2c/ov5645.c                              |   26 -
 drivers/media/i2c/ov9650.c                              |    5=20
 drivers/media/i2c/tda1997x.c                            |    9=20
 drivers/media/pci/saa7134/saa7134-i2c.c                 |   12=20
 drivers/media/pci/saa7146/hexium_gemini.c               |    3=20
 drivers/media/platform/aspeed-video.c                   |    5=20
 drivers/media/platform/exynos4-is/fimc-is.c             |    1=20
 drivers/media/platform/exynos4-is/media-dev.c           |    2=20
 drivers/media/platform/fsl-viu.c                        |    2=20
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c           |    4=20
 drivers/media/platform/omap3isp/isp.c                   |    8=20
 drivers/media/platform/omap3isp/ispccdc.c               |    1=20
 drivers/media/platform/omap3isp/ispccp2.c               |    1=20
 drivers/media/platform/omap3isp/ispcsi2.c               |    1=20
 drivers/media/platform/omap3isp/isppreview.c            |    1=20
 drivers/media/platform/omap3isp/ispresizer.c            |    1=20
 drivers/media/platform/omap3isp/ispstat.c               |    2=20
 drivers/media/platform/rcar_fdp1.c                      |    2=20
 drivers/media/platform/vivid/vivid-kthread-cap.c        |    9=20
 drivers/media/platform/vsp1/vsp1_dl.c                   |    4=20
 drivers/media/radio/si470x/radio-si470x-usb.c           |    5=20
 drivers/media/rc/iguanair.c                             |   15=20
 drivers/media/rc/imon.c                                 |    7=20
 drivers/media/rc/mceusb.c                               |  334 +++++++++--=
-----
 drivers/media/rc/mtk-cir.c                              |    8=20
 drivers/media/usb/cpia2/cpia2_usb.c                     |    4=20
 drivers/media/usb/dvb-usb/dib0700_devices.c             |    8=20
 drivers/media/usb/dvb-usb/pctv452e.c                    |    8=20
 drivers/media/usb/em28xx/em28xx-cards.c                 |    1=20
 drivers/media/usb/gspca/konica.c                        |    5=20
 drivers/media/usb/gspca/nw80x.c                         |    5=20
 drivers/media/usb/gspca/ov519.c                         |   10=20
 drivers/media/usb/gspca/ov534.c                         |    5=20
 drivers/media/usb/gspca/ov534_9.c                       |    1=20
 drivers/media/usb/gspca/se401.c                         |    5=20
 drivers/media/usb/gspca/sn9c20x.c                       |   12=20
 drivers/media/usb/gspca/sonixb.c                        |    5=20
 drivers/media/usb/gspca/sonixj.c                        |    5=20
 drivers/media/usb/gspca/spca1528.c                      |    5=20
 drivers/media/usb/gspca/sq930x.c                        |    5=20
 drivers/media/usb/gspca/sunplus.c                       |    5=20
 drivers/media/usb/gspca/vc032x.c                        |    5=20
 drivers/media/usb/gspca/w996Xcf.c                       |    5=20
 drivers/media/usb/hdpvr/hdpvr-core.c                    |   13=20
 drivers/media/usb/ttusb-dec/ttusb_dec.c                 |    2=20
 drivers/media/v4l2-core/videobuf-core.c                 |    5=20
 drivers/mmc/core/sdio_irq.c                             |    9=20
 drivers/mmc/host/dw_mmc.c                               |    4=20
 drivers/mmc/host/mtk-sd.c                               |    3=20
 drivers/mmc/host/sdhci.c                                |    4=20
 drivers/mtd/nand/raw/stm32_fmc2_nand.c                  |   90 +---
 drivers/net/arcnet/arcnet.c                             |   31 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c             |   10=20
 drivers/net/ethernet/intel/e1000e/ich8lan.h             |    2=20
 drivers/net/ethernet/intel/i40e/i40e_main.c             |    5=20
 drivers/net/ethernet/marvell/skge.c                     |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c          |    1=20
 drivers/net/ethernet/netronome/nfp/flower/main.c        |    7=20
 drivers/net/ethernet/nxp/lpc_eth.c                      |   13=20
 drivers/net/macsec.c                                    |    1=20
 drivers/net/phy/micrel.c                                |    3=20
 drivers/net/phy/national.c                              |    9=20
 drivers/net/ppp/ppp_generic.c                           |    2=20
 drivers/net/usb/cdc_ncm.c                               |    6=20
 drivers/net/usb/usbnet.c                                |    8=20
 drivers/net/vrf.c                                       |    3=20
 drivers/net/wireless/ath/ath10k/wmi-tlv.c               |    2=20
 drivers/net/wireless/ath/ath10k/wmi-tlv.h               |   16=20
 drivers/net/wireless/ath/ath10k/wmi.h                   |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c             |    8=20
 drivers/net/wireless/marvell/libertas/if_usb.c          |    3=20
 drivers/net/wireless/mediatek/mt76/mmio.c               |    2=20
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c         |   15=20
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h      |    6=20
 drivers/net/wireless/mediatek/mt76/usb.c                |    2=20
 drivers/net/wireless/realtek/rtw88/pci.c                |   71 ++-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c            |    1=20
 drivers/nvme/host/multipath.c                           |    8=20
 drivers/nvme/target/admin-cmd.c                         |   14=20
 drivers/parisc/dino.c                                   |   24 +
 drivers/platform/chrome/cros_ec_rpmsg.c                 |   32 +
 drivers/platform/x86/intel_int0002_vgpio.c              |    1=20
 drivers/platform/x86/intel_pmc_core.c                   |    8=20
 drivers/ras/Makefile                                    |    3=20
 drivers/regulator/core.c                                |   42 +-
 drivers/regulator/lm363x-regulator.c                    |    2=20
 drivers/scsi/device_handler/scsi_dh_rdac.c              |    2=20
 drivers/scsi/qla2xxx/qla_init.c                         |   25 -
 drivers/scsi/qla2xxx/qla_os.c                           |    1=20
 drivers/scsi/qla2xxx/qla_target.c                       |    1=20
 drivers/scsi/scsi_lib.c                                 |   13=20
 drivers/soc/amlogic/meson-clk-measure.c                 |   12=20
 drivers/soc/renesas/Kconfig                             |    5=20
 drivers/soc/renesas/rmobile-sysc.c                      |   31 -
 drivers/spi/spi-dw-mmio.c                               |    6=20
 drivers/spi/spi-fsl-dspi.c                              |    4=20
 drivers/staging/media/imx/imx6-mipi-csi2.c              |   12=20
 drivers/video/fbdev/efifb.c                             |   27 -
 fs/binfmt_elf.c                                         |    3=20
 fs/btrfs/ctree.c                                        |    5=20
 fs/btrfs/ctree.h                                        |    1=20
 fs/btrfs/delayed-inode.c                                |   13=20
 fs/btrfs/disk-io.c                                      |   10=20
 fs/btrfs/extent-tree.c                                  |    8=20
 fs/btrfs/extent_io.c                                    |    9=20
 fs/btrfs/free-space-cache.c                             |   20=20
 fs/btrfs/inode.c                                        |    8=20
 fs/btrfs/qgroup.c                                       |   38 +
 fs/btrfs/tree-checker.c                                 |   98 ++++
 fs/cifs/cifsfs.c                                        |    2=20
 fs/cifs/cifsglob.h                                      |    2=20
 fs/cifs/connect.c                                       |    9=20
 fs/cifs/smb2ops.c                                       |   10=20
 fs/cifs/smb2pdu.c                                       |    3=20
 fs/cifs/xattr.c                                         |    2=20
 fs/ext4/extents.c                                       |    4=20
 fs/ext4/inode.c                                         |    9=20
 fs/fuse/dev.c                                           |   93 ++--
 fs/fuse/file.c                                          |    1=20
 fs/fuse/fuse_i.h                                        |    3=20
 fs/fuse/inode.c                                         |    1=20
 fs/fuse/readdir.c                                       |    4=20
 fs/gfs2/bmap.c                                          |    1=20
 fs/io_uring.c                                           |    4=20
 fs/overlayfs/export.c                                   |    3=20
 fs/overlayfs/inode.c                                    |    3=20
 fs/xfs/xfs_file.c                                       |   26 +
 include/linux/blk-mq.h                                  |   13=20
 include/linux/blkdev.h                                  |   15=20
 include/linux/bug.h                                     |    5=20
 include/linux/fs.h                                      |    2=20
 include/linux/mmc/host.h                                |    9=20
 include/linux/pci_ids.h                                 |    1=20
 include/linux/quotaops.h                                |    2=20
 include/linux/sunrpc/xprt.h                             |    1=20
 include/net/route.h                                     |    3=20
 kernel/kprobes.c                                        |    3=20
 kernel/printk/printk.c                                  |    2=20
 kernel/rcu/tree.c                                       |    6=20
 kernel/sched/core.c                                     |   61 ++
 kernel/sched/cpufreq_schedutil.c                        |    7=20
 kernel/sched/deadline.c                                 |   33 +
 kernel/sched/fair.c                                     |   11=20
 kernel/sched/idle.c                                     |    5=20
 kernel/sched/psi.c                                      |    2=20
 kernel/time/alarmtimer.c                                |    4=20
 kernel/time/posix-cpu-timers.c                          |   20=20
 lib/lzo/lzo1x_compress.c                                |   14=20
 mm/compaction.c                                         |   35 -
 mm/fadvise.c                                            |    4=20
 mm/madvise.c                                            |   22 -
 mm/memcontrol.c                                         |   10=20
 mm/oom_kill.c                                           |    5=20
 mm/z3fold.c                                             |   64 ++-
 net/appletalk/ddp.c                                     |    5=20
 net/ax25/af_ax25.c                                      |    2=20
 net/ieee802154/socket.c                                 |    3=20
 net/ipv4/inet_connection_sock.c                         |    4=20
 net/ipv4/ip_forward.c                                   |    2=20
 net/ipv4/ip_output.c                                    |    2=20
 net/ipv4/route.c                                        |   34 -
 net/ipv4/tcp_bbr.c                                      |    8=20
 net/ipv4/tcp_timer.c                                    |    5=20
 net/ipv4/xfrm4_policy.c                                 |    1=20
 net/ipv6/fib6_rules.c                                   |    3=20
 net/nfc/llcp_sock.c                                     |    7=20
 net/openvswitch/datapath.c                              |    2=20
 net/qrtr/qrtr.c                                         |    1=20
 net/sched/act_api.c                                     |   34 -
 net/sched/act_sample.c                                  |    1=20
 net/sched/cls_api.c                                     |    6=20
 net/sched/sch_api.c                                     |    3=20
 net/sched/sch_cbs.c                                     |   30 -
 net/sched/sch_netem.c                                   |    2=20
 net/sunrpc/clnt.c                                       |    6=20
 net/sunrpc/xdr.c                                        |   27 -
 net/sunrpc/xprt.c                                       |   54 +-
 net/wireless/util.c                                     |    1=20
 scripts/Makefile.kasan                                  |   11=20
 scripts/gcc-plugins/randomize_layout_plugin.c           |   10=20
 security/keys/trusted.c                                 |    5=20
 sound/firewire/motu/motu.c                              |   12=20
 sound/firewire/tascam/tascam-pcm.c                      |    3=20
 sound/firewire/tascam/tascam-stream.c                   |   42 +-
 sound/hda/hdac_controller.c                             |    2=20
 sound/i2c/other/ak4xxx-adda.c                           |    7=20
 sound/pci/hda/hda_codec.c                               |    8=20
 sound/pci/hda/hda_controller.c                          |    5=20
 sound/pci/hda/hda_intel.c                               |    2=20
 sound/pci/hda/patch_hdmi.c                              |    9=20
 sound/pci/hda/patch_realtek.c                           |   90 ++++
 sound/soc/atmel/mchp-i2s-mcc.c                          |   41 +
 sound/soc/codecs/es8316.c                               |    7=20
 sound/soc/codecs/hdac_hda.c                             |    4=20
 sound/soc/codecs/sgtl5000.c                             |   21 -
 sound/soc/codecs/tlv320aic31xx.c                        |    7=20
 sound/soc/fsl/fsl_ssi.c                                 |   18=20
 sound/soc/intel/common/sst-acpi.c                       |    3=20
 sound/soc/intel/common/sst-ipc.c                        |    2=20
 sound/soc/intel/skylake/skl-debug.c                     |    2=20
 sound/soc/intel/skylake/skl-nhlt.c                      |    2=20
 sound/soc/sh/rcar/adg.c                                 |   21 -
 sound/soc/soc-generic-dmaengine-pcm.c                   |    6=20
 sound/soc/sof/intel/hda-codec.c                         |    6=20
 sound/soc/sof/sof-pci-dev.c                             |    3=20
 sound/soc/sunxi/sun4i-i2s.c                             |    9=20
 sound/soc/uniphier/aio-cpu.c                            |   31 +
 sound/soc/uniphier/aio.h                                |    1=20
 sound/usb/pcm.c                                         |    1=20
 tools/include/uapi/asm/bitsperlong.h                    |   18=20
 tools/lib/traceevent/Makefile                           |    6=20
 tools/lib/traceevent/event-plugin.c                     |    2=20
 tools/perf/arch/x86/util/kvm-stat.c                     |    4=20
 tools/perf/arch/x86/util/tsc.c                          |    6=20
 tools/perf/perf.c                                       |    3=20
 tools/perf/tests/shell/trace+probe_vfs_getname.sh       |    4=20
 tools/perf/trace/beauty/ioctl.c                         |    2=20
 tools/perf/ui/browsers/scripts.c                        |    6=20
 tools/perf/ui/helpline.c                                |    4=20
 tools/perf/ui/util.c                                    |    2=20
 tools/perf/util/evlist.c                                |    9=20
 tools/perf/util/header.c                                |    4=20
 tools/perf/util/hist.c                                  |    5=20
 tools/perf/util/map.c                                   |    3=20
 tools/perf/util/map_groups.h                            |    4=20
 tools/perf/util/thread.c                                |    7=20
 tools/perf/util/thread.h                                |    4=20
 tools/perf/util/unwind-libunwind-local.c                |   18=20
 tools/perf/util/unwind-libunwind.c                      |   34 -
 tools/perf/util/unwind.h                                |   25 -
 tools/perf/util/xyarray.h                               |    3=20
 tools/testing/selftests/net/fib_tests.sh                |   21 -
 366 files changed, 3148 insertions(+), 1538 deletions(-)

A Sun (1):
      media: mceusb: fix (eliminate) TX IR signal length limit

Adam Ford (3):
      ARM: dts: logicpd-torpedo-baseboard: Fix missing video
      ARM: omap2plus_defconfig: Fix missing video
      ARM: dts: am3517-evm: Fix missing video

Ahzo (1):
      drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)

Al Cooper (1):
      mmc: sdhci: Fix incorrect switch to HS mode

Al Stone (1):
      ACPI / CPPC: do not require the _PSD method

Alessio Balsini (1):
      loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Alexander Graf (1):
      KVM: x86: Disable posted interrupts for non-standard IRQs delivery mo=
des

Alexander Sverdlin (1):
      spi: ep93xx: Repair SPI CS lookup tables

Amadeusz S=C5=82awi=C5=84ski (3):
      ASoC: Intel: NHLT: Fix debug print format
      ASoC: Intel: Skylake: Use correct function to access iomem space
      ASoC: Intel: Fix use of potentially uninitialized variable

Andi Kleen (1):
      perf report: Fix --ns time sort key output

Andr=C3=A9 Draszik (1):
      ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Andy Shevchenko (1):
      spi: dw-mmio: Clock should be shut when error occurs

Anton Eidelman (1):
      nvme-multipath: fix ana log nsid lookup when nsid is not found

Ard van Breemen (1):
      ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Arnaldo Carvalho de Melo (4):
      perf config: Honour $PERF_CONFIG env var to specify alternate .perfco=
nfig
      perf test vfs_getname: Disable ~/.perfconfig to get default output
      tools headers: Fixup bitsperlong per arch includes
      perf evlist: Use unshare(CLONE_FS) in sb threads to let setns(CLONE_N=
EWNS) work

Arnd Bergmann (6):
      media: dib0700: fix link error for dibx000_i2c_set_speed
      media: vivid: work around high stack usage with clang
      dmaengine: iop-adma: use correct printk format strings
      ARM: xscale: fix multi-cpu compilation
      net: lpc-enet: fix printk format strings
      media: don't drop front-end reference count for ->detach

Axel Lin (1):
      regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_=
vneg

Benjamin Coddington (1):
      SUNRPC: Fix buffer handling of GSS MIC without slack

Benjamin Peterson (1):
      perf trace beauty ioctl: Fix off-by-one error in cmd->string table

Bjorn Andersson (1):
      net: qrtr: Stop rx_worker before freeing node

Bj=C3=B8rn Mork (2):
      cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
      usbnet: ignore endpoints with invalid wMaxPacketSize

Bob Peterson (1):
      gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps

Bodong Wang (1):
      net/mlx5: Add device ID of upcoming BlueField-2

Cezary Rojewski (1):
      ASoC: Intel: Haswell: Adjust machine device private context

Chao Yu (1):
      quota: fix wrong condition in is_quota_modification()

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr

Chris Wilson (1):
      ALSA: hda: Flush interrupts on disabling

Christoph Hellwig (1):
      irqchip/sifive-plic: set max threshold for ignored handlers

Christophe Kerello (1):
      mtd: rawnand: stm32_fmc2: avoid warnings when building with W=3D1 opt=
ion

Christophe Leroy (1):
      btrfs: fix allocation of free space cache v1 bitmap pages

Codrin Ciubotariu (2):
      ASoC: mchp-i2s-mcc: Wait for RX/TX RDY only if controller is running
      ASoC: mchp-i2s-mcc: Fix unprepare of GCLK

Colin Ian King (1):
      media: vsp1: fix memory leak of dl on error return path

Cong Wang (2):
      net_sched: add max len check for TCA_KIND
      net_sched: add policy validation for action attributes

Damien Le Moal (1):
      block: mq-deadline: Fix queue restart handling

Dan Carpenter (1):
      EDAC/altera: Use the proper type for the IRQ status bits

Dan Murphy (1):
      leds: lm3532: Fixes for the driver for stability

Dan Williams (1):
      libata/ahci: Drop PCS quirk for Denverton and beyond

Danit Goldberg (1):
      IB/mlx5: Free mpi in mp_slave mode

Darius Rad (1):
      media: rc: imon: Allow iMON RC protocol for ffdc 7e device

Dave Rodgman (1):
      lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle

David Ahern (3):
      selftests: Update fib_tests to handle missing ping6
      ipv4: Revert removal of rt_uses_gateway
      vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled

Davide Caratti (1):
      net/sched: act_sample: don't push mac header on ip6gre ingress

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Dennis Zhou (1):
      btrfs: adjust dirty_metadata_bytes after writeback failure of extent =
buffer

Ding Xiang (1):
      ovl: Fix dereferencing possible ERR_PTR()

Douglas RAILLARD (1):
      sched/cpufreq: Align trace event behavior of fast switching

Eric Biggers (1):
      fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock

Eric Dumazet (4):
      sch_netem: fix a divide by zero in tabledist()
      net: sched: fix possible crash in tcf_action_destroy()
      tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
      iommu/iova: Avoid false sharing on fq_timer_on

Ezequiel Garcia (3):
      media: i2c: ov5645: Fix power sequence
      media: imx: mipi csi-2: Don't fail if initial state times-out
      PM / devfreq: Fix kernel oops on governor module load

Fabio Estevam (1):
      media: i2c: ov5640: Check for devm_gpiod_get_optional() error

Felix Fietkau (1):
      mt76: round up length on mt76_wr_copy

Filipe Manana (2):
      Btrfs: fix use-after-free when using the tree modification log
      Btrfs: fix race setting up and completing qgroup rescan workers

Finn Thain (1):
      m68k: Prevent some compiler warnings in Coldfire builds

Gayatri Kammela (1):
      x86/cpu: Add Tiger Lake to Intel family

Geert Uytterhoeven (3):
      media: fdp1: Reduce FCP not found message level to debug
      soc: renesas: rmobile-sysc: Set GENPD_FLAG_ALWAYS_ON for always-on do=
main
      soc: renesas: Enable ARM_ERRATA_754322 for affected Cortex-A9

Gerald BAEZA (1):
      libperf: Fix alignment trap with xyarray contents in 'perf stat'

Greg Kroah-Hartman (1):
      Linux 5.2.19

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector I=
PI fails

Guoqing Jiang (3):
      md: don't call spare_active in md_reap_sync_thread if all member devi=
ces can't work
      md: don't set In_sync if array is frozen
      raid5: don't set STRIPE_HANDLE to stripe which is in batch list

Gustavo A. R. Silva (1):
      perf script: Fix memory leaks in list_scripts()

Hans Andersson (1):
      net: phy: micrel: add Asym Pause workaround for KSZ9021

Hans Verkuil (5):
      media: gspca: zero usb_buf on error
      media: radio/si470x: kill urb on error
      media: hdpvr: add terminating 0 at end of string
      media: cec-notifier: clear cec_adap in cec_notifier_unregister
      media: videobuf-core.c: poll_wait needs a non-NULL buf pointer

Hans de Goede (4):
      x86/platform/intel/iosf_mbi Rewrite locking
      platform/x86: intel_int0002_vgpio: Fix wakeups not working on Cherry =
Trail
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
      efifb: BGRT: Improve efifb_bgrt_sanity_check

Harald Freudenberger (1):
      s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding

Hariprasad Kelam (1):
      cpufreq: ap806: Add NULL check after kcalloc

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Hou Tao (1):
      block: make rq sector size accessible for block stats

Ira Weiny (1):
      IB/hfi1: Define variables as unsigned long to fix KASAN warning

Jack Morgenstein (1):
      RDMA: Fix double-free in srq creation error flow

Jackie Liu (1):
      io_uring: fix wrong sequence setting logic

James Morse (1):
      arm64: entry: Move ct_user_exit before any other exception

Jan Dakinevich (2):
      KVM: x86: always stop emulation on page fault
      KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jan Kara (3):
      fs: Export generic_fadvise()
      mm: Handle MADV_WILLNEED through vfs_fadvise()
      xfs: Fix stale data exposure when readahead races with hole punch

Jan-Marek Glogowski (1):
      ALSA: hda/realtek - PCI quirk for Medion E4254

Jani Nikula (1):
      drm: fix module name in edid_firmware log message

Jarkko Nikula (1):
      ACPI / LPSS: Save/restore LPSS private registers also on Lynxpoint

Jarkko Sakkinen (1):
      tpm: Wrap the buffer from the caller to tpm_buf in tpm_send()

Jason A. Donenfeld (1):
      ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule

Jia-Ju Bai (1):
      ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in bu=
ild_adc_controls()

Jian-Hong Pan (2):
      rtw88: pci: Rearrange the memory usage for skb in RX ISR
      rtw88: pci: Use DMA sync instead of remapping in RX ISR

Jiri Slaby (1):
      ACPI / processor: don't print errors for processorIDs =3D=3D 0xff

Ji=C5=99=C3=AD Pale=C4=8Dek (1):
      kvm: Nested KVM MMUs need PAE root too

John Keeping (1):
      perf unwind: Fix libunwind when tid !=3D pid

Joonwon Kang (1):
      randstruct: Check member structs in is_pure_ops_struct()

Junhua Huang (1):
      arm64: mm: free the initrd reserved memblock in a aligned manner

Juri Lelli (3):
      sched/core: Fix CPU controller for !RT_GROUP_SCHED
      sched/deadline: Fix bandwidth accounting at all levels after offline =
migration
      rcu/tree: Call setschedule() gp ktread to SCHED_FIFO outside of atomi=
c region

Kai-Heng Feng (3):
      e1000e: add workaround for possible stalled packet
      iommu/amd: Override wrong IVRS IOAPIC on Raven Ridge systems
      drm/amd/display: Restore backlight brightness after system resume

Kaike Wan (1):
      IB/hfi1: Do not update hcrc for a KDETH packet during fault injection

Kamil Konieczny (1):
      PM / devfreq: exynos-bus: Correct clock enable sequence

Katsuhiro Suzuki (1):
      ASoC: es8316: fix headphone mixer volume table

Kees Cook (2):
      arm64/efi: Move variable assignments after SECTIONS
      binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Kent Overstreet (1):
      closures: fix a race on wakeup from closure_sync

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Kevin(Yudong) Yang (1):
      tcp_bbr: fix quantization code to not raise cwnd if not probing bandw=
idth

Keyon Jie (1):
      ASoC: hdac_hda: fix page fault issue by removing race

Kunihiko Hayashi (1):
      ASoC: uniphier: Fix double reset assersion when transitioning to susp=
end state

Kuninori Morimoto (1):
      ASoC: rsnd: don't call clk_get_rate() under atomic context

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Leonard Crestez (1):
      PM / devfreq: passive: Use non-devm notifiers

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Liguang Zhang (1):
      ACPI / APEI: Release resources if gen_pool_add() fails

Lihua Yao (1):
      ARM: samsung: Fix system restart on S3C6410

Lorenzo Bianconi (2):
      mt76: mt7615: always release sem in mt7615_load_patch
      mt76: mt7615: fix mt7615 firmware path definitions

Luca Coelho (1):
      iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36

Lucas Stach (1):
      ASoC: tlv320aic31xx: suppress error message for EPROBE_DEFER

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Luke Mujica (1):
      perf tools: Fix paths in include statements

Luke Nowakowski-Krijger (1):
      media: hdpvr: Add device num check and handling

M. Vefa Bicakci (1):
      platform/x86: intel_pmc_core: Do not ioremap RAM

Maciej S. Szmigiero (1):
      media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate=
()

Madhavan Srinivasan (1):
      powerpc/imc: Dont create debugfs files for cpu-less nodes

Marc Zyngier (1):
      irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Marcel Bocu (2):
      x86/amd_nb: Add PCI device IDs for family 17h, model 70h
      hwmon: (k10temp) Add support for AMD family 17h, model 70h CPUs

Marek Szyprowski (1):
      ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks

Mark Brown (1):
      regulator: Defer init completion for a while after late_initcall

Mark Rutland (2):
      kasan/arm64: fix CONFIG_KASAN_SW_TAGS && KASAN_INLINE
      arm64: kpti: ensure patched kernel text is fetched from PoU

Mark Salyzyn (1):
      ovl: filter of trusted xattr results in audit

Martin Wilck (1):
      scsi: scsi_dh_rdac: zero cdb in send_mode_select()

Masahiro Yamada (2):
      ARM: at91: move platform-specific asm-offset.h to arch/arm/mach-at91
      ARM: OMAP2+: move platform-specific asm-offset.h to arch/arm/mach-oma=
p2

Masami Hiramatsu (1):
      kprobes: Prohibit probing on BUG() and WARN() address

Matthias Brugger (1):
      media: mtk-mdp: fix reference count on old device tree

Mauro Carvalho Chehab (2):
      media: aspeed-video: address a protential usage of an unitialized var
      media: ov9650: add a sanity check

Maxime Ripard (1):
      ASoC: sun4i-i2s: Don't use the oversample to calculate BCLK

Michael Ellerman (1):
      powerpc/Makefile: Always pass --synthetic to nm if supported

Michael Tretter (1):
      media: vb2: reorder checks in vb2_poll()

Michal Hocko (1):
      memcg, kmem: do not fail __GFP_NOFAIL charges

Mike Christie (1):
      nbd: add missing config put

Miles Chen (1):
      sched/psi: Correct overly pessimistic size calculation

Ming Lei (2):
      blk-mq: add callback of .cleanup_rq
      scsi: implement .cleanup_rq callback

Murphy Zhou (1):
      CIFS: fix max ea value size

MyungJoo Ham (1):
      PM / devfreq: passive: fix compiler warning

Nadav Amit (1):
      iommu/vt-d: Fix wrong analysis whether devices share the same bus

Navid Emamdoost (2):
      nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
      nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs

Neil Armstrong (1):
      soc: amlogic: meson-clk-measure: protect measure with a mutex

Neil Horman (1):
      x86/apic/vector: Warn when vector space exhaustion breaks affinity

NeilBrown (3):
      md: don't report active array_state until after revalidate_disk() com=
pletes.
      md: only call set_in_sync() when it is expected to succeed.
      md/raid0: avoid RAID0 data corruption due to layout confusion.

Nick Stoughton (1):
      leds: leds-lp5562 allow firmware files up to the maximum length

Nigel Croxon (1):
      raid5: don't increment read_errors on EILSEQ return

Nikolay Borisov (1):
      btrfs: Relinquish CPUs in btrfs_compare_trees

Oleksandr Suvorov (2):
      ASoC: sgtl5000: Fix of unmute outputs on probe
      ASoC: sgtl5000: Fix charge pump source assignment

Oliver Neukum (3):
      usbnet: sanity checking of packet sizes and device mtu
      media: iguanair: add sanity checks
      zd1211rw: remove false assertion from zd_mac_clear()

Ori Nimron (5):
      mISDN: enforce CAP_NET_RAW for raw sockets
      appletalk: enforce CAP_NET_RAW for raw sockets
      ax25: enforce CAP_NET_RAW for raw sockets
      ieee802154: enforce CAP_NET_RAW for raw sockets
      nfc: enforce CAP_NET_RAW for raw sockets

Pan Xiuli (1):
      ASoC: SOF: pci: mark last_busy value at runtime PM init

Paul E. McKenney (1):
      time/tick-broadcast: Fix tick_broadcast_offline() lockdep complaint

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function

Peter Ujfalusi (2):
      dmaengine: ti: edma: Do not reset reserved paRAM slots
      ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is n=
ot set

Peter Zijlstra (3):
      idle: Prevent late-arriving interrupts from disrupting offline
      x86/mm: Fix cpumask_of_node() error condition
      rcu/tree: Fix SCHED_FIFO params

Phil Auld (1):
      sched/fair: Use rq_lock/unlock in online_fair_sched_group

Pi-Hsun Shih (1):
      platform/chrome: cros_ec_rpmsg: Fix race with host command when probe=
 failed

Qian Cai (2):
      arm64/prefetch: fix a -Wtype-limits warning
      iommu/amd: Silence warnings under memory pressure

Qu Wenruo (6):
      btrfs: delayed-inode: Kill the BUG_ON() in btrfs_delete_delayed_dir_i=
ndex()
      btrfs: extent-tree: Make sure we only allocate extents from block gro=
ups with the same type
      btrfs: tree-checker: Add ROOT_ITEM check
      btrfs: Detect unbalanced tree with empty leaf before crashing btree o=
perations
      btrfs: qgroup: Fix the wrong target io_tree when freeing reserved dat=
a space
      btrfs: qgroup: Fix reserved data space leak if we have multiple reser=
ve calls

Quinn Tran (1):
      scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag

Rafael J. Wysocki (1):
      cpuidle: teo: Allow tick to be stopped if PM QoS is used

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio

Rakesh Pillai (1):
      ath10k: fix channel info parsing for non tlv target

Randy Dunlap (1):
      media: media/platform: fsl-viu.c: fix build for MICROBLAZE

Ranjani Sridharan (1):
      ASoC: SOF: Intel: hda: Make hdac_device device-managed

Robert Richter (1):
      EDAC/mc: Fix grain_bits calculation

Roberto Sassu (1):
      KEYS: trusted: correctly initialize digests and fix locking issue

Saeed Mahameed (1):
      net/mlx5e: Fix traffic duplication in ethtool steering

Sakari Ailus (2):
      media: omap3isp: Don't set streaming state on random subdevs
      media: omap3isp: Set device on omap3isp subdevs

Sean Christopherson (2):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS
      KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes

Sean Young (3):
      media: mtk-cir: lower de-glitch counter for rc-mm protocol
      media: em28xx: modules workqueue not inited for 2nd device
      media: dvb-frontends: use ida for pll number

Shawn Lin (1):
      arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix clock control issue in master mode

Song Liu (1):
      x86/mm/pti: Handle unaligned address gracefully in pti_clone_pagetabl=
e()

Stefan Agner (1):
      ARM: dts: imx7-colibri: disable HS400

Stefan Assmann (1):
      i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask

Stefan Berger (2):
      tpm_tis_core: Turn on the TPM before probing IRQ's
      tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts

Stefan Wahren (1):
      dmaengine: bcm2835: Print error in case setting DMA mask fails

Stephen Boyd (1):
      firmware: qcom_scm: Use proper types for dma mappings

Stephen Douthit (1):
      EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()

Stephen Hemminger (1):
      skge: fix checksum byte order

Steve French (2):
      smb3: allow disabling requesting leases
      smb3: fix leak in "open on server" perf counter

Sudeep Holla (1):
      firmware: arm_scmi: Check if platform has released shmem before using

Takashi Iwai (3):
      ALSA: hda - Show the fatal CORB/RIRB error more clearly
      ALSA: hda - Drop unsol event handler for Intel HDMI codecs
      ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Takashi Sakamoto (3):
      ALSA: firewire-motu: add support for MOTU 4pre
      ALSA: firewire-tascam: handle error code when getting current source =
of clock
      ALSA: firewire-tascam: check intermediate state of clock status and r=
etry

Takeshi Misawa (1):
      ppp: Fix memory leak in ppp_write

Tan Xiaojun (1):
      perf record: Support aarch64 random socket_id assignment

Tejun Heo (1):
      fuse: fix beyond-end-of-page access in fuse_parse_cache()

Tetsuo Handa (2):
      memcg, oom: don't require __GFP_FS when invoking memcg OOM killer
      /dev/mem: Bail out upon SIGKILL.

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Theodore Ts'o (1):
      ext4: fix punch hole for inline_data file systems

Thomas Gleixner (4):
      x86/apic: Make apic_pending_intr_clear() more robust
      x86/apic: Soft disable APIC before initializing it
      posix-cpu-timers: Sanitize bogus WARNONS
      x86/mm/pti: Do not invoke PTI functions when PTI is disabled

Tom Wu (1):
      nvmet: fix data units read and written counters in SMART log

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Tomas Espeleta (1):
      ALSA: hda - Add a quirk model for fixing Huawei Matebook X right spea=
ker

Tony Camuso (1):
      ipmi: move message error checking to avoid deadlock

Trond Myklebust (1):
      SUNRPC: Dequeue the request from the receive queue while we're re-enc=
oding

Tzvetomir Stoyanov (1):
      libtraceevent: Change users plugin directory

Ulf Hansson (4):
      mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHRE=
AD
      mmc: core: Add helper function to indicate if SDIO IRQs is enabled
      mmc: dw_mmc: Re-store SDIO IRQs mask at system resume
      mmc: mtk-sd: Re-store SDIO IRQs mask at system resume

Uwe Kleine-K=C3=B6nig (1):
      arcnet: provide a buffer big enough to actually receive packets

Valdis Kletnieks (1):
      RAS: Build debugfs.o only when enabled in Kconfig

Vandana BN (1):
      media: vivid:add sanity check to avoid divide error and set value to =
1 if 0.

Vasily Averin (1):
      fuse: fix missing unlock_page in fuse_writepage()

Vasily Gorbik (1):
      s390/kasan: provide uninstrumented __strlen

Vincent Guittot (1):
      sched/fair: Fix imbalance due to CPU affinity

Vincent Whitchurch (1):
      printk: Do not lose last line in kmsg buffer dump

Vinicius Costa Gomes (1):
      net/sched: cbs: Fix not adding cbs instance to list

Vinod Koul (1):
      base: soc: Export soc_device_register/unregister APIs

Vitaly Wool (2):
      z3fold: fix retry mechanism in page reclaim
      z3fold: fix memory leak in kmem cache

Vladimir Oltean (1):
      spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours

Wang Shenran (1):
      hwmon: (acpi_power_meter) Change log level for 'unsafe software power=
 cap'

Wen Yang (1):
      media: exynos4-is: fix leaked of_node references

Wenwen Wang (6):
      led: triggers: Fix a memory leak bug
      media: dvb-core: fix a memory leak bug
      media: saa7146: add cleanup in hexium_attach()
      media: cpia2_usb: fix memory leaks
      ACPI: custom_method: fix memory leaks
      ACPI / PCI: fix acpi_pci_irq_enable() memory leak

Will Deacon (2):
      arm64: tlb: Ensure we execute an ISB following walk cache invalidation
      iommu/arm-smmu-v3: Disable detection of ATS and PRI

Wolfram Sang (1):
      media: i2c: tda1997x: prevent potential NULL pointer access

Xiao Ni (1):
      md/raid6: Set R5_ReadError when there is read failure on parity disk

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

Xin Long (1):
      macsec: drop skb sk before calling gro_cells_receive

Yafang Shao (1):
      mm/compaction.c: clear total_{migrate,free}_scanned before scanning a=
 new zone

Yazen Ghannam (3):
      EDAC/amd64: Support more than two controllers for chip selects handli=
ng
      EDAC/amd64: Recognize DRAM device type ECC capability
      EDAC/amd64: Decode syndrome before translating address

Yufen Yu (3):
      md/raid1: end bio when the device faulty
      md/raid1: fail run raid1 array when active disk less than one
      block: fix null pointer dereference in blk_mq_rq_timed_out()

chenzefeng (1):
      ia64:unwind: fix double free for mod->arch.init_unw_table

zhengbin (1):
      blk-mq: Fix memory leak in blk_mq_init_allocated_queue error handling


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2ZsksACgkQONu9yGCS
aT4cahAAxKScaedxGlIHvMavjGUM4MSwliM4zOxSwdDXkGdNiCkY6vp7HwTRxWRS
gUdSCcizYu3Tss80//ZrXP6X4wVS8aycs5mlhUhLQiriQLnynUSb5F5Hj0719rR5
7230ArXimgr0o94J4kxaPjJRoVq0Cl0FodOFv6yyBJi/nrOFArruG2/G8EzkDEhC
CgcluxWh0UXCGeGNgDKm+7i3yV4i4azpPEnriUjokmiaB6W9rP57q5avZTfZGIQB
nINvsZ5zBwzXfhUOiacWQWqcW6rY6nprrhrUXbGSingEL+/KSqwkOP7ILomqmTsG
7TYeSXyPSwv/DOBqtGXtjUDZqB+cA8uZT1hUtpWsxZI5v7S/a4lkUaAvv+w8ATl3
GQj2T7jf9EHoEtkFEn6VqEgwlojvt9k5Mp6U+GdLuba1oYVQFMsiWdsjeKymyOFA
iC99nHb6XP7I5rFYmFLskWheubF90dC7iWDwlzrcPPBInR5Pmi3BeiU+rr5S99GC
n7MbSnTWCuiOVemwaa8J4vQB8JHQzYIiUTLQ/YaPsiR5yQxfbfM+vmihLrYtrrW6
ihGk1s0bfXniZMC+WRljCRBw3J06v2Eal4hsl5XhZXPW4Knl0wbg2WXIhMBwpCXD
caLf5bPwJ500O2esiygDxLP2OQSUh3e1ICaFoE35ZDxTy413+LE=
=yvCb
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
