Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D40108CCB
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 12:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfKYLSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 06:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfKYLSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 06:18:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3C62082F;
        Mon, 25 Nov 2019 11:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574680720;
        bh=otBTlL+KDLlBYr2jEPolblC0ydLcHsATOxUxeDX0xEw=;
        h=Date:From:To:Cc:Subject:From;
        b=IpkHHlXFwCEpXTjIKekF4vWix2u1QZL2dQ5B+l+X3C7xHg3URIdSLvhrLEX8M2vh5
         aSHJCBuojJo261vKpXTA1It3qAzUeUVx5wq3KVfjQ93MPKa20otWagnDb8kpFZGVcv
         Ywd1eAN4ccE+EFVrNgM/DLUCx7ScpmCDXdwfPPcM=
Date:   Mon, 25 Nov 2019 12:18:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.203
Message-ID: <20191125111837.GA2574399@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.203 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm/boot/compressed/libfdt_env.h                  |    2=20
 arch/arm/boot/dts/am335x-evm.dts                       |   12 -
 arch/arm/boot/dts/arm-realview-eb.dtsi                 |    2=20
 arch/arm/boot/dts/arm-realview-pb1176.dts              |    2=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts              |    2=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                |    2=20
 arch/arm/boot/dts/at91sam9g45.dtsi                     |    2=20
 arch/arm/boot/dts/dove-cubox.dts                       |    2=20
 arch/arm/boot/dts/dove.dtsi                            |    6=20
 arch/arm/boot/dts/exynos5250-arndale.dts               |    9 +
 arch/arm/boot/dts/exynos5250-snow-rev5.dts             |   11 +
 arch/arm/boot/dts/exynos5420-peach-pit.dts             |    3=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts              |    3=20
 arch/arm/boot/dts/lpc32xx.dtsi                         |    4=20
 arch/arm/boot/dts/omap3-gta04.dtsi                     |   49 +++++--
 arch/arm/boot/dts/omap5-board-common.dtsi              |    5=20
 arch/arm/boot/dts/orion5x-linkstation.dtsi             |    2=20
 arch/arm/boot/dts/pxa27x.dtsi                          |    2=20
 arch/arm/boot/dts/qcom-ipq4019.dtsi                    |    2=20
 arch/arm/boot/dts/rk3036.dtsi                          |    2=20
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts      |    2=20
 arch/arm/boot/dts/ste-dbx5x0.dtsi                      |    6=20
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi         |    8 -
 arch/arm/boot/dts/ste-hrefprev60.dtsi                  |    2=20
 arch/arm/boot/dts/ste-snowball.dts                     |    2=20
 arch/arm/boot/dts/ste-u300.dts                         |    2=20
 arch/arm/boot/dts/tegra20-paz00.dts                    |    6=20
 arch/arm/boot/dts/tegra30-apalis.dtsi                  |    6=20
 arch/arm/boot/dts/tegra30.dtsi                         |    6=20
 arch/arm/boot/dts/versatile-ab.dts                     |    2=20
 arch/arm/kernel/entry-common.S                         |    9 -
 arch/arm/kvm/mmu.c                                     |    3=20
 arch/arm/mach-imx/pm-imx6.c                            |   25 +++
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi           |    4=20
 arch/arm64/boot/dts/lg/lg1312.dtsi                     |    4=20
 arch/arm64/boot/dts/lg/lg1313.dtsi                     |    4=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi         |    1=20
 arch/arm64/lib/clear_user.S                            |    2=20
 arch/arm64/lib/copy_from_user.S                        |    2=20
 arch/arm64/lib/copy_in_user.S                          |    2=20
 arch/arm64/lib/copy_to_user.S                          |    2=20
 arch/arm64/mm/numa.c                                   |    2=20
 arch/mips/bcm47xx/workarounds.c                        |    8 -
 arch/mips/include/asm/kexec.h                          |    6=20
 arch/mips/txx9/generic/setup.c                         |    5=20
 arch/powerpc/boot/libfdt_env.h                         |    2=20
 arch/powerpc/kernel/iommu.c                            |    2=20
 arch/powerpc/kernel/rtas.c                             |    2=20
 arch/powerpc/kernel/vdso32/datapage.S                  |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S              |    1=20
 arch/powerpc/kernel/vdso64/datapage.S                  |    1=20
 arch/powerpc/kernel/vdso64/gettimeofday.S              |    1=20
 arch/powerpc/kvm/book3s.c                              |    3=20
 arch/powerpc/mm/slb.c                                  |    2=20
 arch/powerpc/platforms/pseries/dtl.c                   |    4=20
 arch/s390/kernel/vdso32/Makefile                       |    3=20
 arch/s390/kernel/vdso64/Makefile                       |    3=20
 arch/x86/Kconfig                                       |    3=20
 arch/x86/include/asm/atomic.h                          |    8 -
 arch/x86/include/asm/atomic64_64.h                     |    8 -
 arch/x86/include/asm/barrier.h                         |    4=20
 arch/x86/include/asm/insn.h                            |   18 ++
 arch/x86/include/asm/kexec.h                           |    2=20
 arch/x86/kernel/cpu/cyrix.c                            |    2=20
 arch/x86/kernel/kprobes/core.c                         |    4=20
 arch/x86/kernel/uprobes.c                              |    6=20
 crypto/rsa-pkcs1pad.c                                  |    9 -
 drivers/acpi/acpica/acevents.h                         |    2=20
 drivers/acpi/acpica/aclocal.h                          |    2=20
 drivers/acpi/acpica/evregion.c                         |   17 ++
 drivers/acpi/acpica/evrgnini.c                         |    6=20
 drivers/acpi/acpica/evxfregn.c                         |    1=20
 drivers/acpi/osl.c                                     |    1=20
 drivers/acpi/pci_root.c                                |    5=20
 drivers/acpi/sbshc.c                                   |    2=20
 drivers/ata/Kconfig                                    |    3=20
 drivers/ata/libata-scsi.c                              |   21 +++
 drivers/ata/pata_ep93xx.c                              |    8 -
 drivers/base/component.c                               |    6=20
 drivers/clk/samsung/clk-cpu.c                          |    6=20
 drivers/clk/samsung/clk-cpu.h                          |    2=20
 drivers/crypto/mxs-dcp.c                               |   80 ++++++++++--
 drivers/crypto/s5p-sss.c                               |    4=20
 drivers/dma/Kconfig                                    |    2=20
 drivers/dma/dma-jz4780.c                               |    2=20
 drivers/dma/ioat/init.c                                |    7 -
 drivers/dma/timb_dma.c                                 |    2=20
 drivers/gpio/gpio-syscon.c                             |    2=20
 drivers/hwmon/ina3221.c                                |    6=20
 drivers/hwmon/pwm-fan.c                                |    8 -
 drivers/hwtracing/coresight/coresight-etm4x.c          |   40 +++---
 drivers/hwtracing/coresight/coresight-tmc-etf.c        |    4=20
 drivers/hwtracing/coresight/coresight.c                |   22 ++-
 drivers/i2c/busses/Kconfig                             |    7 -
 drivers/iio/dac/mcp4922.c                              |   11 +
 drivers/infiniband/hw/hfi1/pcie.c                      |    4=20
 drivers/infiniband/hw/i40iw/i40iw_cm.c                 |    2=20
 drivers/infiniband/hw/mthca/mthca_main.c               |    3=20
 drivers/infiniband/sw/rxe/rxe_comp.c                   |   21 ++-
 drivers/infiniband/sw/rxe/rxe_req.c                    |   15 +-
 drivers/infiniband/ulp/iser/iser_initiator.c           |   18 ++
 drivers/input/ff-memless.c                             |    9 +
 drivers/input/rmi4/rmi_f54.c                           |    5=20
 drivers/input/touchscreen/silead.c                     |   13 ++
 drivers/input/touchscreen/st1232.c                     |    1=20
 drivers/md/bcache/super.c                              |    1=20
 drivers/media/pci/ivtv/ivtv-yuv.c                      |    2=20
 drivers/media/pci/meye/meye.c                          |    2=20
 drivers/media/platform/davinci/isif.c                  |    3=20
 drivers/media/platform/davinci/vpbe_display.c          |    2=20
 drivers/media/platform/pxa_camera.c                    |    2=20
 drivers/media/usb/au0828/au0828-core.c                 |    4=20
 drivers/media/usb/cx231xx/cx231xx-video.c              |    2=20
 drivers/mfd/ti_am335x_tscadc.c                         |   13 ++
 drivers/misc/cxl/guest.c                               |    2=20
 drivers/misc/genwqe/card_utils.c                       |   13 +-
 drivers/misc/kgdbts.c                                  |   16 --
 drivers/mmc/host/sdhci-of-at91.c                       |    2=20
 drivers/mtd/maps/physmap_of.c                          |   27 ----
 drivers/mtd/nand/sh_flctl.c                            |    4=20
 drivers/net/can/slcan.c                                |    1=20
 drivers/net/ethernet/amd/am79c961a.c                   |    2=20
 drivers/net/ethernet/amd/atarilance.c                  |    6=20
 drivers/net/ethernet/amd/declance.c                    |    2=20
 drivers/net/ethernet/amd/sun3lance.c                   |    6=20
 drivers/net/ethernet/amd/sunlance.c                    |    2=20
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c               |    4=20
 drivers/net/ethernet/broadcom/bcm63xx_enet.c           |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c       |   10 +
 drivers/net/ethernet/broadcom/sb1250-mac.c             |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c         |    4=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h         |    2=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c             |    2=20
 drivers/net/ethernet/intel/i40e/i40e_main.c            |    8 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c             |    3=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c     |   10 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c          |   10 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         |    7 +
 drivers/net/ethernet/micrel/ks8695net.c                |    2=20
 drivers/net/ethernet/micrel/ks8851_mll.c               |    4=20
 drivers/net/ethernet/smsc/smc911x.c                    |    3=20
 drivers/net/ethernet/smsc/smc91x.c                     |    3=20
 drivers/net/ethernet/smsc/smsc911x.c                   |    3=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.c           |    4=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.h           |    2=20
 drivers/net/ethernet/toshiba/spider_net.c              |    4=20
 drivers/net/ethernet/toshiba/tc35815.c                 |    6=20
 drivers/net/ethernet/xilinx/ll_temac_main.c            |    3=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c      |    3=20
 drivers/net/ethernet/xilinx/xilinx_emaclite.c          |    9 -
 drivers/net/slip/slip.c                                |    1=20
 drivers/net/usb/ax88172a.c                             |    2=20
 drivers/net/usb/cdc_ncm.c                              |    2=20
 drivers/net/usb/lan78xx.c                              |    5=20
 drivers/net/wireless/ath/ath10k/ahb.c                  |    4=20
 drivers/net/wireless/ath/ath10k/core.h                 |    1=20
 drivers/net/wireless/ath/ath10k/mac.c                  |    2=20
 drivers/net/wireless/ath/ath10k/pci.c                  |    2=20
 drivers/net/wireless/ath/ath10k/wmi.c                  |   22 ++-
 drivers/net/wireless/ath/ath10k/wmi.h                  |    8 +
 drivers/net/wireless/ath/ath9k/common-spectral.c       |    2=20
 drivers/net/wireless/ath/ath9k/main.c                  |    1=20
 drivers/net/wireless/ath/ath9k/tx99.c                  |   10 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   26 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c            |    4=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            |    8 +
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c    |    2=20
 drivers/net/xen-netback/interface.c                    |    3=20
 drivers/nvmem/core.c                                   |    2=20
 drivers/of/base.c                                      |    2=20
 drivers/phy/phy-twl4030-usb.c                          |   29 ++++
 drivers/pinctrl/pinctrl-at91-pio4.c                    |    8 -
 drivers/pinctrl/pinctrl-at91.c                         |   28 ++--
 drivers/power/reset/at91-sama5d2_shdwc.c               |    3=20
 drivers/power/supply/ab8500_fg.c                       |   31 +---
 drivers/power/supply/max8998_charger.c                 |    2=20
 drivers/power/supply/twl4030_charger.c                 |   30 ++++
 drivers/reset/core.c                                   |   15 +-
 drivers/s390/net/qeth_l2_main.c                        |    3=20
 drivers/s390/net/qeth_l3_main.c                        |    3=20
 drivers/scsi/NCR5380.c                                 |   42 ++++--
 drivers/scsi/libsas/sas_expander.c                     |   13 --
 drivers/scsi/pm8001/pm8001_hwi.c                       |    6=20
 drivers/scsi/pm8001/pm8001_sas.c                       |    9 +
 drivers/scsi/pm8001/pm8001_sas.h                       |    1=20
 drivers/scsi/pm8001/pm80xx_hwi.c                       |   80 +++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h                       |    3=20
 drivers/scsi/sym53c8xx_2/sym_hipd.c                    |   15 +-
 drivers/spi/spi-pic32.c                                |    4=20
 drivers/spi/spi-rockchip.c                             |    3=20
 drivers/spi/spidev.c                                   |    8 -
 drivers/tty/serial/mxs-auart.c                         |    3=20
 drivers/usb/chipidea/otg.c                             |    9 -
 drivers/usb/chipidea/usbmisc_imx.c                     |    2=20
 drivers/usb/gadget/function/uvc_configfs.c             |    7 +
 drivers/usb/gadget/function/uvc_video.c                |   32 +++-
 drivers/usb/gadget/udc/fotg210-udc.c                   |    2=20
 drivers/usb/host/xhci-mtk-sch.c                        |    4=20
 drivers/usb/serial/cypress_m8.c                        |    2=20
 drivers/vfio/pci/vfio_pci.c                            |    8 -
 drivers/vfio/pci/vfio_pci_config.c                     |   31 ++++
 drivers/video/backlight/lm3639_bl.c                    |    6=20
 drivers/video/fbdev/core/fbmon.c                       |   95 ------------=
--
 drivers/video/fbdev/core/modedb.c                      |   57 --------
 drivers/video/fbdev/sbuslib.c                          |   28 ++--
 fs/compat_ioctl.c                                      |   10 -
 fs/ecryptfs/inode.c                                    |   19 ++
 fs/f2fs/gc.c                                           |    2=20
 fs/f2fs/recovery.c                                     |    2=20
 fs/f2fs/super.c                                        |    6=20
 fs/fuse/control.c                                      |    4=20
 fs/gfs2/rgrp.c                                         |    2=20
 fs/gfs2/super.c                                        |    2=20
 fs/kernfs/symlink.c                                    |    5=20
 fs/nfs/delegation.c                                    |    6=20
 fs/orangefs/orangefs-sysfs.c                           |    2=20
 fs/proc/vmcore.c                                       |   10 +
 include/linux/blkdev.h                                 |    9 +
 include/linux/cpufeature.h                             |    2=20
 include/linux/edac.h                                   |    3=20
 include/linux/fb.h                                     |    3=20
 include/linux/intel-iommu.h                            |    6=20
 include/linux/libfdt_env.h                             |    1=20
 include/linux/platform_data/dma-ep93xx.h               |    2=20
 include/linux/sunrpc/sched.h                           |    2=20
 include/net/llc.h                                      |    1=20
 include/rdma/ib_verbs.h                                |    2=20
 kernel/cpu.c                                           |    1=20
 kernel/events/uprobes.c                                |    4=20
 kernel/kprobes.c                                       |    8 +
 kernel/printk/printk.c                                 |   18 +-
 kernel/signal.c                                        |    4=20
 mm/hugetlb_cgroup.c                                    |    2=20
 mm/memcontrol.c                                        |    2=20
 mm/shmem.c                                             |    2=20
 net/bluetooth/l2cap_core.c                             |   10 +
 net/ipv4/gre_demux.c                                   |    7 -
 net/ipv4/ip_gre.c                                      |    9 -
 net/llc/llc_core.c                                     |    4=20
 net/mac80211/rc80211_minstrel_ht.c                     |    2=20
 net/openvswitch/vport-internal_dev.c                   |    5=20
 net/sunrpc/sched.c                                     |  109 ++++++++----=
-----
 net/wireless/nl80211.c                                 |    2=20
 net/wireless/reg.c                                     |   46 +++++++
 samples/mei/mei-amt-version.c                          |    2=20
 sound/core/oss/pcm_plugin.c                            |    4=20
 sound/core/seq/seq_system.c                            |   18 ++
 sound/pci/hda/patch_sigmatel.c                         |   20 +++
 sound/pci/intel8x0m.c                                  |   20 +--
 sound/soc/codecs/hdac_hdmi.c                           |    6=20
 sound/soc/codecs/sgtl5000.c                            |    2=20
 sound/soc/soc-pcm.c                                    |    2=20
 sound/usb/endpoint.c                                   |    3=20
 sound/usb/mixer.c                                      |    4=20
 256 files changed, 1340 insertions(+), 745 deletions(-)

Aapo Vienamo (1):
      arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Al Viro (2):
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable eit=
her

Alan Modra (1):
      powerpc/vdso: Correct call frame information

Alex Williamson (1):
      vfio/pci: Mask buggy SR-IOV VF INTx support

Andreas Kemnade (3):
      power: supply: twl4030_charger: fix charging current out-of-bounds
      power: supply: twl4030_charger: disable eoc interrupt on linear charge
      phy: phy-twl4030-usb: fix denied runtime access

Andrew Zaborowski (1):
      nl80211: Fix a GET_KEY reply attribute

Anshuman Khandual (1):
      arm64/numa: Report correct memblock range for the dummy node

Anton Vasilyev (1):
      serial: mxs-auart: Fix potential infinite loop

Arnd Bergmann (1):
      media: dvb: fix compat ioctl translation

Banajit Goswami (1):
      component: fix loop condition to call unbind() if bind() fails

Ben Greear (1):
      ath10k: fix vdev-start timeout on error

Bernd Edlinger (1):
      kernfs: Fix range checks in kernfs_get_target_path

Bjorn Helgaas (1):
      x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Bob Moore (1):
      ACPICA: Never run _REG on system_memory and system_IO

Bob Peterson (1):
      gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Borislav Petkov (3):
      cpu/SMT: State SMT is disabled even with nosmt and without "=3Dforce"
      x86/olpc: Fix build error with CONFIG_MFD_CS5535=3Dm
      proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypt=
ed()

Brad Love (1):
      media: au0828: Fix incorrect error messages

Breno Leitao (1):
      powerpc/iommu: Avoid derefence before pointer check

Cameron Kaiser (1):
      KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC a=
nd LR

Chao Yu (2):
      f2fs: fix memory leak of percpu counter in fill_super()
      f2fs: fix to recover inode's uid/gid during POR

Charles Keepax (1):
      ASoC: dpcm: Properly initialise hw->rate_max

Christian Lamparter (1):
      ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Christoph Hellwig (1):
      block: introduce blk_rq_is_passthrough

Christoph Manszewski (1):
      crypto: s5p-sss: Fix Fix argument list alignment

Chuhong Yuan (1):
      Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Chunfeng Yun (1):
      usb: xhci-mtk: fix ISOC error when interval is zero

Chung-Hsien Hsu (2):
      brcmfmac: reduce timeout for action frame scan
      brcmfmac: fix full timeout waiting for action frame on-channel tx

Claudiu Beznea (1):
      power: reset: at91-poweroff: do not procede if at91_shdwc is allocated

Colin Ian King (3):
      ASoC: sgtl5000: avoid division by zero if lo_vag is zero
      media: cx231xx: fix potential sign-extension overflow on large shift
      orangefs: rate limit the client not running info message

Cong Wang (1):
      llc: avoid blocking in llc_sap_close()

Dan Aloni (1):
      crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Dan Carpenter (8):
      ALSA: pcm: signedness bug in snd_pcm_plug_alloc()
      pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_=
map()
      power: supply: ab8500_fg: silence uninitialized variable warnings
      ath9k: Fix a locking bug in ath9k_add_interface()
      net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
      mei: samples: fix a signedness bug in amt_host_if_call()
      fbdev: sbuslib: use checked version of put_user()
      fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Daniel Silsby (1):
      dmaengine: dma-jz4780: Further residue status fix

Daniel Vetter (1):
      fbdev: Ditch fb_edid_add_monspecs

Deepak Ukey (2):
      scsi: pm80xx: Corrected dma_unmap_sg() parameter
      scsi: pm80xx: Fixed system hang issue during kexec boot

Dengcheng Zhu (1):
      MIPS: kexec: Relax memory restriction

Ding Xiang (1):
      mips: txx9: fix iounmap related issue

Dinh Nguyen (1):
      ARM: dts: socfpga: Fix I2C bus unit-address error

Eric Auger (1):
      iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Eric W. Biederman (3):
      signal: Always ignore SIGKILL and SIGSTOP sent to the global init
      signal: Properly deliver SIGILL from uprobes
      signal: Properly deliver SIGSEGV from x86 uprobes

Erik Stromdahl (1):
      ath10k: wmi: disable softirq's while calling ieee80211_rx

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix quirk2 overwrite

Felix Fietkau (3):
      ath9k: fix tx99 with monitor mode interface
      ath9k: add back support for using active monitor interfaces for tx99
      mac80211: minstrel: fix CCK rate group streams value

Finn Thain (5):
      scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data
      scsi: NCR5380: Check for invalid reselection target
      scsi: NCR5380: Don't clear busy flag when abort fails
      scsi: NCR5380: Don't call dsprintk() following reselection interrupt
      scsi: NCR5380: Handle BUS FREE during reselection

Florian Fainelli (2):
      ata: ahci_brcm: Allow using driver or DSL SoCs
      i2c: brcmstb: Allow enabling the driver on DSL SoCs

Ganesh Goudar (1):
      cxgb4: Fix endianness issue in t4_fwcache()

Geert Uytterhoeven (2):
      ARM: dts: ux500: Correct SCU unit address
      reset: Fix potential use-after-free in __of_reset_control_get()

George Kennedy (1):
      scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Greg Kroah-Hartman (1):
      Linux 4.9.203

Grygorii Strashko (1):
      ARM: dts: am335x-evm: fix number of cpsw

H. Nikolaus Schaller (7):
      ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overw=
rite in other DTS files
      ARM: dts: omap3-gta04: fixes for tvout / venc
      ARM: dts: omap3-gta04: tvout: enable as display1 alias
      ARM: dts: omap3-gta04: fix touchscreen tsc2007
      ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-=
Boot
      ARM: dts: omap3-gta04: keep vpll2 always on
      ARM: dts: omap5: enable OTG role for DWC3 controller

Haishuang Yan (1):
      ip_gre: fix parsing gre header in ipgre_err

Hannes Reinecke (1):
      scsi: NCR5380: Clear all unissued commands on host reset

He Zhe (1):
      printk: Give error on attempt to set log buffer length to over 2G

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

Huibin Hong (1):
      spi: rockchip: initialize dma_slave_config properly

H=C3=A5kon Bugge (1):
      RDMA/i40iw: Fix incorrect iterator type

Israel Rukshin (1):
      IB/iser: Fix possible NULL deref at iser_inv_desc()

Jaegeuk Kim (1):
      f2fs: return correct errno in f2fs_gc

James Erwin (1):
      IB/hfi1: Ensure full Gen3 speed in a Gen4 system

Jason Yan (1):
      scsi: libsas: always unregister the old device if going to discover n=
ew

Jay Foster (1):
      ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Jens Axboe (1):
      libata: have ata_scsi_rw_xlat() fail invalid passthrough requests

Jia-Ju Bai (2):
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
      usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in f=
otg210_get_status()

Joel Pepper (1):
      usb: gadget: uvc: configfs: Prevent format changes after linking head=
er

Johan Hovold (1):
      USB: serial: cypress_m8: fix interrupt-out transfer length

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Julian Sax (1):
      Input: silead - try firmware reload after unsuccessful resume

Julian Wiedmann (1):
      s390/qeth: invoke softirqs after napi_schedule()

Justin Ernst (1):
      EDAC: Raise the maximum number of memory controllers

Kirill Tkhai (1):
      fuse: use READ_ONCE on congestion_threshold and max_background

Lao Wei (1):
      media: fix: media: pci: meye: validate offset to avoid arbitrary acce=
ss

Larry Finger (1):
      rtl8187: Fix warning generated when strncpy() destination length matc=
hes the sixe argument

Laura Abbott (1):
      misc: kgdbts: Fix restrict error

Laurent Pinchart (3):
      usb: gadget: uvc: configfs: Drop leaked references to config items
      usb: gadget: uvc: Factor out video USB request queueing
      usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Leo Yan (1):
      coresight: tmc: Fix byte-address alignment for RRP

Li Qiang (1):
      vfio/pci: Fix potential memory leak in vfio_msi_cap_len

Linus Walleij (1):
      ARM: dts: ux500: Fix LCDA clock line muxing

Loic Poulain (1):
      usb: chipidea: Fix otg event handler

Lucas Stach (2):
      Input: synaptics-rmi4 - fix video buffer size
      Input: synaptics-rmi4 - clear IRQ enables for F54

Ludovic Desroches (1):
      pinctrl: at91: don't use the same irqchip with multiple gpiochips

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS

Marc Dietrich (1):
      ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler (3):
      ARM: dts: pxa: fix power i2c base address
      ARM: dts: tegra30: fix xcvr-setup-use-fuses
      ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcus Folkesson (1):
      iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Marek Szyprowski (4):
      ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook
      ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chrome=
books
      ARM: dts: exynos: Disable pull control for S5M8767 PMIC
      clk: samsung: Use clk_hw API for calling clk framework from clk notif=
iers

Marek Vasut (1):
      gpio: syscon: Fix possible NULL ptr usage

Martin Kepplinger (1):
      Input: st1232 - set INPUT_PROP_DIRECT property

Masami Hiramatsu (3):
      kprobes: Don't call BUG_ON() if there is a kprobe in use on free list
      kprobes/x86: Prohibit probing on exception masking instructions
      uprobes/x86: Prohibit probing on MOV SS instruction

Matthew Whitehead (1):
      x86/CPU: Use correct macros for Cyrix calls

Michael Pobega (1):
      ALSA: hda/sigmatel - Disable automute for Elo VuPoint

Mitch Williams (1):
      i40e: use correct length for strncpy

Nathan Chancellor (11):
      spi: pic32: Use proper enum in dmaengine_prep_slave_rg
      media: davinci: Fix implicit enum conversion warning
      dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction
      dmaengine: timb_dma: Use proper enum in td_prep_slave_sg
      cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update
      cxgb4: Use proper enum in IEEE_FAUX_SYNC
      mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer
      IB/mlx4: Avoid implicit enumerated type conversion
      ata: ep93xx: Use proper enums for directions
      media: pxa_camera: Fix check for pdev->dev.of_node
      backlight: lm3639: Unconditionally call led_classdev_unregister

Nathan Fontenot (1):
      powerpc/pseries: Disable CPU hotplug across migrations

Naveen N. Rao (2):
      powerpc/pseries: Fix DTL buffer registration
      powerpc/pseries: Fix how we iterate over the DTL entries

Nicholas Piggin (1):
      powerpc/64s/hash: Fix stab_rr off by one initialization

Nicolas Adell (1):
      usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is a=
lready started

Nicolin Chen (1):
      hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Oleksij Rempel (1):
      ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" =
is set

Olga Kornievskaia (1):
      NFSv4.x: fix lock recovery during delegation recall

Oliver Neukum (2):
      ax88172a: fix information leak on short answers
      Input: ff-memless - kill timer in destroy()

Patryk Ma=C5=82ek (2):
      i40e: hold the rtnl lock on clearing interrupt scheme
      i40e: Prevent deleting MAC address from VF when set by PF

Paul Cercueil (1):
      dmaengine: dma-jz4780: Don't depend on MACH_JZ4780

Pavel Tatashin (1):
      arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

Peter Zijlstra (1):
      x86/atomic: Fix smp_mb__{before,after}_atomic()

Petr Machata (1):
      mlxsw: spectrum: Init shaper for TCs 8..15

Radoslaw Tyl (1):
      ixgbe: Fix crash with VFs and flow director on interface flap

Radu Solea (2):
      crypto: mxs-dcp - Fix SHA null hashes and output length
      crypto: mxs-dcp - Fix AES issues

Rajeev Kumar Sirasanagandla (1):
      cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Rami Rosen (1):
      dmaengine: ioat: fix prototype of ioat_enumerate_channels

Ricardo Ribalda Delgado (1):
      mtd: physmap_of: Release resources on error

Rob Herring (9):
      of: make PowerMac cache node search conditional on CONFIG_PPC_PMAC
      ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036
      libfdt: Ensure INT_MAX is defined in libfdt_env.h
      ARM: dts: ste: Fix SPI controller node names
      ARM: dts: marvell: Fix SPI and I2C bus warnings
      ARM: dts: realview: Fix SPI controller node names
      arm64: dts: amd: Fix SPI bus warnings
      arm64: dts: lg: Fix SPI controller node names
      ARM: dts: lpc32xx: Fix SPI controller node names

Roger Quadros (1):
      ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Ronald Tschal=C3=A4r (1):
      ACPI / SBS: Fix rare oops when removing modules

Sara Sharon (2):
      iwlwifi: mvm: avoid sending too many BARs
      iwlwifi: mvm: don't send keys when entering D3

Shahed Shaikh (1):
      bnx2x: Ignore bandwidth attention in single function mode

Shenghui Wang (1):
      bcache: recal cached_dev_sectors on detach

Simon Wunderlich (1):
      ath9k: fix reporting calculated new FFT upper max

Sinan Kaya (1):
      PCI/ACPI: Correct error message for ASPM disabling

Srinivas Kandagatla (1):
      nvmem: core: return error code instead of NULL from nvmem_device_get

Stefan Agner (1):
      cpufeature: avoid warning when compiling with clang

Stefan Wahren (1):
      net: lan78xx: Bail out if lan78xx_get_endpoints fails

Suzuki K Poulose (2):
      coresight: Fix handling of sinks
      kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table

Takashi Iwai (3):
      ALSA: usb-audio: Fix missing error check at mixer resolution test
      ALSA: seq: Do error checks at creating system ports
      ALSA: intel8x0m: Register irq handler after register initializations

Tamizh chelvam (1):
      ath10k: fix kernel panic by moving pci flush after napi_disable

Thierry Reding (1):
      hwmon: (pwm-fan) Silence error on probe deferral

Tim Smith (1):
      GFS2: Flush the GFS2 delete workqueue before stopping the kernel thre=
ads

Timothy E Baldwin (1):
      ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Tomasz Figa (1):
      power: supply: max8998-charger: Fix platform data retrieval

Tomasz Nowicki (1):
      coresight: etm4x: Configure EL2 exception level when kernel is runnin=
g in HYP

Trent Piepho (1):
      spi: spidev: Fix OF tree warning logic

Trond Myklebust (1):
      SUNRPC: Fix priority queue fairness

Tuomas Tynkkynen (1):
      MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Vasily Gorbik (1):
      s390/kasan: avoid vdso instrumentation

Vignesh R (1):
      mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capab=
le

Vijay Immanuel (1):
      IB/rxe: fixes for rdma read retry

Wei Yongjun (1):
      IB/mthca: Fix error return code in __mthca_init_one()

Wenwen Wang (1):
      media: isif: fix a NULL pointer dereference bug

Yong Zhi (1):
      ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation

YueHaibing (8):
      net: toshiba: fix return type of ndo_start_xmit function
      net: xilinx: fix return type of ndo_start_xmit function
      net: broadcom: fix return type of ndo_start_xmit function
      net: amd: fix return type of ndo_start_xmit function
      net: micrel: fix return type of ndo_start_xmit function
      net: smsc: fix return type of ndo_start_xmit function
      net: ovs: fix return type of ndo_start_xmit function
      net: xen-netback: fix return type of ndo_start_xmit function

zhong jiang (3):
      misc: genwqe: should return proper error value.
      memfd: Use radix_tree_deref_slot_protected to avoid the warning.
      misc: cxl: Fix possible null pointer dereference


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3buI0ACgkQONu9yGCS
aT4GGxAAj2LvkmcwKgzmkXtONcwTK+k+KkbrCGDT6RT1LF1kRH0v5Y/6HXU4EhRx
tjRAI4+eId2AnPUhXTOc9q+pkpAbNurGrui/xHwSapJXKG4GLW7p+c8MxQSTaDHg
smimXFM2sR7ZYq1XIrqc4Pn61H3Zf65HJofVpl3B1sQ09Lc9MVxkopRp8tue5EKc
aPEYAPydZGskohqJYM0cmGNomAsg5RhvoPLZyDbIL+wI8oYoaiJlfEsWRqw/bRcT
j7eec5HTKHO2q5+XxChl5DzRcJM+wEcwnwaDHm5NscEG6uFZSS0MNx+CkF4ReVnL
6ciOFrbXAW7U6RrOWhaFm8no/2eHBQ2qvpy22QGCTrb7AQgbdflNFTtl0mROuxml
vv+F5YOmi3j4kieTI33w+z9/4erQypb4n4h1zwhmh/sAE/wbFOL8Qo7tS6Ax6849
pLo0Bv0YHIrsm1qL61D70JZveADUD+fsZ7FX2cwQmdo/I6UsHj2/5FYRAY0M1viJ
O5cJTwHygUxIuQoL6giEjXi4Fxq4htyAPh2s0FhuwTDmoNeozfGE8tMOaOO6jpoB
Sv6YuRmdum801I48BMJKMaKFZfnWz0vTqaAAaR2fjI2aR72qapJzhtVev+zPGEyh
FAzVtB/oTmmxp71BGuPi2tSjthhNVGVhsVgSx459GUTxw5RCtEQ=
=jnzA
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
