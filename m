Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22B7109282
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfKYREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbfKYREB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:04:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D614E20674;
        Mon, 25 Nov 2019 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574701439;
        bh=ABulx9I4OcG6XNZAE5j7I1whSdZ1vtAw8aCBCa5Iyig=;
        h=Date:From:To:Cc:Subject:From;
        b=Ihd6Tso5gc6siq77mn41vym+t2d1/AZ/mXGAj/V3jQe6OI3a9YJG+osFmxiixAMQb
         rXSEDp5db/dUlhlVaj4Kw8Rfv8FViggk7zqUIQd1+qWyT4Ipc7I12szroFOQbaPSev
         swwjv1UtEJSzZ+IMbjoZC0OV6IA41detiB7dNfWE=
Date:   Mon, 25 Nov 2019 18:03:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.203
Message-ID: <20191125170357.GA2721973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.203 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/misc-devices/mei/mei-amt-version.c    |    2 
 Makefile                                            |    2 
 arch/arm/boot/compressed/libfdt_env.h               |    2 
 arch/arm/boot/dts/am335x-evm.dts                    |   12 
 arch/arm/boot/dts/at91sam9g45.dtsi                  |    2 
 arch/arm/boot/dts/exynos5250-snow-rev5.dts          |   11 
 arch/arm/boot/dts/omap3-gta04.dtsi                  |   21 
 arch/arm/boot/dts/pxa27x.dtsi                       |    2 
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts   |    2 
 arch/arm/boot/dts/ste-dbx5x0.dtsi                   |    6 
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi      |    8 
 arch/arm/boot/dts/ste-hrefprev60.dtsi               |    2 
 arch/arm/boot/dts/ste-snowball.dts                  |    2 
 arch/arm/boot/dts/ste-u300.dts                      |    2 
 arch/arm/boot/dts/tegra30-apalis.dtsi               |    6 
 arch/arm/boot/dts/tegra30.dtsi                      |    6 
 arch/arm/kernel/entry-common.S                      |    9 
 arch/arm/mach-imx/pm-imx6.c                         |   25 
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi        |    4 
 arch/arm64/lib/clear_user.S                         |    2 
 arch/arm64/lib/copy_from_user.S                     |    2 
 arch/arm64/lib/copy_in_user.S                       |    2 
 arch/arm64/lib/copy_to_user.S                       |    2 
 arch/mips/bcm47xx/workarounds.c                     |    8 
 arch/mips/include/asm/kexec.h                       |    6 
 arch/mips/txx9/generic/setup.c                      |    5 
 arch/powerpc/boot/libfdt_env.h                      |    2 
 arch/powerpc/kernel/iommu.c                         |    2 
 arch/powerpc/kernel/rtas.c                          |    2 
 arch/powerpc/kernel/vdso32/datapage.S               |    1 
 arch/powerpc/kernel/vdso32/gettimeofday.S           |    1 
 arch/powerpc/kernel/vdso64/datapage.S               |    1 
 arch/powerpc/kernel/vdso64/gettimeofday.S           |    1 
 arch/powerpc/kvm/book3s.c                           |    3 
 arch/powerpc/mm/slb.c                               |    2 
 arch/powerpc/platforms/pseries/dtl.c                |    4 
 arch/x86/Kconfig                                    |    3 
 arch/x86/include/asm/atomic.h                       |    8 
 arch/x86/include/asm/atomic64_64.h                  |    8 
 arch/x86/include/asm/barrier.h                      |    4 
 arch/x86/include/asm/insn.h                         |   18 
 arch/x86/include/asm/kexec.h                        |    2 
 arch/x86/kernel/cpu/cyrix.c                         |    2 
 arch/x86/kernel/kprobes/core.c                      |    4 
 arch/x86/kernel/uprobes.c                           |    6 
 drivers/acpi/osl.c                                  |    1 
 drivers/acpi/pci_root.c                             |    5 
 drivers/acpi/sbshc.c                                |    2 
 drivers/ata/libata-scsi.c                           |   21 
 drivers/ata/pata_ep93xx.c                           |    8 
 drivers/bluetooth/hci_ldisc.c                       |   10 
 drivers/bluetooth/hci_uart.h                        |    1 
 drivers/crypto/mxs-dcp.c                            |   80 -
 drivers/dma/dma-jz4780.c                            |    2 
 drivers/dma/ioat/init.c                             |    7 
 drivers/dma/timb_dma.c                              |    2 
 drivers/gpio/gpio-syscon.c                          |    2 
 drivers/hwmon/pwm-fan.c                             |    8 
 drivers/iio/dac/mcp4922.c                           |   11 
 drivers/infiniband/hw/mthca/mthca_main.c            |    3 
 drivers/input/ff-memless.c                          |    9 
 drivers/input/touchscreen/st1232.c                  |    1 
 drivers/md/bcache/super.c                           |    1 
 drivers/media/pci/ivtv/ivtv-yuv.c                   |    2 
 drivers/media/pci/meye/meye.c                       |    2 
 drivers/media/platform/davinci/isif.c               |    3 
 drivers/media/platform/davinci/vpbe_display.c       |    2 
 drivers/media/usb/cx231xx/cx231xx-video.c           |    2 
 drivers/misc/genwqe/card_utils.c                    |   13 
 drivers/misc/kgdbts.c                               |   16 
 drivers/mmc/host/sdhci-of-at91.c                    |    2 
 drivers/mtd/maps/physmap_of.c                       |   27 
 drivers/mtd/nand/sh_flctl.c                         |    4 
 drivers/net/can/slcan.c                             |    1 
 drivers/net/ethernet/amd/am79c961a.c                |    2 
 drivers/net/ethernet/amd/atarilance.c               |    6 
 drivers/net/ethernet/amd/declance.c                 |    2 
 drivers/net/ethernet/amd/sun3lance.c                |    6 
 drivers/net/ethernet/amd/sunlance.c                 |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c            |    4 
 drivers/net/ethernet/broadcom/bcm63xx_enet.c        |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |   10 
 drivers/net/ethernet/broadcom/sb1250-mac.c          |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c      |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h      |    2 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c          |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c         |    8 
 drivers/net/ethernet/intel/i40e/i40e_ptp.c          |    3 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c  |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       |   10 
 drivers/net/ethernet/micrel/ks8695net.c             |    2 
 drivers/net/ethernet/micrel/ks8851_mll.c            |    4 
 drivers/net/ethernet/smsc/smc911x.c                 |    3 
 drivers/net/ethernet/smsc/smc91x.c                  |    3 
 drivers/net/ethernet/smsc/smsc911x.c                |    3 
 drivers/net/ethernet/toshiba/ps3_gelic_net.c        |    4 
 drivers/net/ethernet/toshiba/ps3_gelic_net.h        |    2 
 drivers/net/ethernet/toshiba/spider_net.c           |    4 
 drivers/net/ethernet/toshiba/tc35815.c              |    6 
 drivers/net/ethernet/xilinx/ll_temac_main.c         |    3 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |    3 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c       |    9 
 drivers/net/slip/slip.c                             |    1 
 drivers/net/usb/ax88172a.c                          |    2 
 drivers/net/usb/cdc_ncm.c                           |    2 
 drivers/net/usb/lan78xx.c                           |    5 
 drivers/net/wireless/ath/ath10k/core.h              |    1 
 drivers/net/wireless/ath/ath10k/mac.c               |    2 
 drivers/net/wireless/ath/ath10k/wmi.c               |   22 
 drivers/net/wireless/ath/ath10k/wmi.h               |    8 
 drivers/net/wireless/ath/ath9k/common-spectral.c    |    2 
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c       |   17 
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h       |    2 
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c |    2 
 drivers/nvmem/core.c                                |    2 
 drivers/of/base.c                                   |    2 
 drivers/pinctrl/pinctrl-at91-pio4.c                 |    8 
 drivers/pinctrl/pinctrl-at91.c                      |   28 
 drivers/power/ab8500_fg.c                           |   31 
 drivers/power/max8998_charger.c                     |    2 
 drivers/power/twl4030_charger.c                     |   30 
 drivers/s390/net/qeth_l2_main.c                     |    3 
 drivers/s390/net/qeth_l3_main.c                     |    3 
 drivers/scsi/libsas/sas_expander.c                  |   13 
 drivers/scsi/pm8001/pm8001_hwi.c                    |    6 
 drivers/scsi/pm8001/pm8001_sas.c                    |    9 
 drivers/scsi/pm8001/pm8001_sas.h                    |    1 
 drivers/scsi/pm8001/pm80xx_hwi.c                    |   80 -
 drivers/scsi/pm8001/pm80xx_hwi.h                    |    3 
 drivers/scsi/sym53c8xx_2/sym_hipd.c                 |   15 
 drivers/spi/spi-rockchip.c                          |    3 
 drivers/spi/spidev.c                                |    8 
 drivers/tty/serial/mxs-auart.c                      |    3 
 drivers/usb/chipidea/otg.c                          |    9 
 drivers/usb/gadget/function/uvc_configfs.c          |    7 
 drivers/usb/gadget/function/uvc_video.c             |   32 
 drivers/usb/gadget/udc/fotg210-udc.c                |    2 
 drivers/usb/serial/cypress_m8.c                     |    2 
 drivers/vfio/pci/vfio_pci_config.c                  |    4 
 drivers/video/backlight/lm3639_bl.c                 |    6 
 drivers/video/fbdev/Kconfig                         |   10 
 drivers/video/fbdev/Makefile                        |    1 
 drivers/video/fbdev/core/fbmon.c                    |   95 -
 drivers/video/fbdev/core/modedb.c                   |   57 
 drivers/video/fbdev/sbuslib.c                       |   28 
 drivers/video/fbdev/sh_mobile_hdmi.c                | 1489 --------------------
 fs/ecryptfs/inode.c                                 |   19 
 fs/f2fs/gc.c                                        |    2 
 fs/fuse/control.c                                   |    4 
 fs/gfs2/rgrp.c                                      |    2 
 fs/gfs2/super.c                                     |    2 
 fs/kernfs/symlink.c                                 |    5 
 fs/nfs/delegation.c                                 |    6 
 fs/proc/vmcore.c                                    |   10 
 include/linux/blkdev.h                              |   16 
 include/linux/cpufeature.h                          |    2 
 include/linux/edac.h                                |    3 
 include/linux/fb.h                                  |    3 
 include/linux/intel-iommu.h                         |    6 
 include/linux/libfdt_env.h                          |    1 
 include/linux/platform_data/dma-ep93xx.h            |    2 
 include/linux/sunrpc/sched.h                        |    2 
 include/net/llc.h                                   |    1 
 include/video/sh_mobile_hdmi.h                      |   49 
 kernel/events/uprobes.c                             |    4 
 kernel/kprobes.c                                    |    8 
 kernel/printk/printk.c                              |   18 
 kernel/signal.c                                     |    4 
 mm/hugetlb_cgroup.c                                 |    2 
 mm/memcontrol.c                                     |    2 
 mm/shmem.c                                          |    2 
 net/bluetooth/l2cap_core.c                          |   10 
 net/llc/llc_core.c                                  |    4 
 net/mac80211/rc80211_minstrel_ht.c                  |    2 
 net/openvswitch/vport-internal_dev.c                |    5 
 net/sunrpc/sched.c                                  |  109 -
 net/wireless/nl80211.c                              |    2 
 security/apparmor/apparmorfs.c                      |    2 
 security/apparmor/audit.c                           |    3 
 security/apparmor/file.c                            |    3 
 security/apparmor/include/policy.h                  |    2 
 security/apparmor/lsm.c                             |   22 
 security/apparmor/policy.c                          |   18 
 sound/core/oss/pcm_plugin.c                         |    4 
 sound/core/seq/seq_system.c                         |   18 
 sound/pci/hda/patch_sigmatel.c                      |   20 
 sound/pci/intel8x0m.c                               |   20 
 sound/soc/codecs/sgtl5000.c                         |    2 
 sound/soc/soc-pcm.c                                 |    2 
 sound/usb/endpoint.c                                |    3 
 sound/usb/mixer.c                                   |    4 
 191 files changed, 949 insertions(+), 2140 deletions(-)

Al Viro (2):
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either

Alan Modra (1):
      powerpc/vdso: Correct call frame information

Andreas Kemnade (2):
      power: supply: twl4030_charger: fix charging current out-of-bounds
      power: supply: twl4030_charger: disable eoc interrupt on linear charge

Andrew Zaborowski (1):
      nl80211: Fix a GET_KEY reply attribute

Anton Vasilyev (1):
      serial: mxs-auart: Fix potential infinite loop

Ben Greear (1):
      ath10k: fix vdev-start timeout on error

Bernd Edlinger (1):
      kernfs: Fix range checks in kernfs_get_target_path

Bjorn Helgaas (1):
      x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Bob Peterson (1):
      gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Borislav Petkov (2):
      x86/olpc: Fix build error with CONFIG_MFD_CS5535=m
      proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypted()

Breno Leitao (1):
      powerpc/iommu: Avoid derefence before pointer check

Cameron Kaiser (1):
      KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC and LR

Charles Keepax (1):
      ASoC: dpcm: Properly initialise hw->rate_max

Christoph Hellwig (1):
      block: introduce blk_rq_is_passthrough

Chung-Hsien Hsu (1):
      brcmfmac: fix full timeout waiting for action frame on-channel tx

Colin Ian King (2):
      ASoC: sgtl5000: avoid division by zero if lo_vag is zero
      media: cx231xx: fix potential sign-extension overflow on large shift

Cong Wang (1):
      llc: avoid blocking in llc_sap_close()

Dan Carpenter (7):
      ALSA: pcm: signedness bug in snd_pcm_plug_alloc()
      pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_map()
      power: supply: ab8500_fg: silence uninitialized variable warnings
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

Felix Fietkau (1):
      mac80211: minstrel: fix CCK rate group streams value

Ganesh Goudar (1):
      cxgb4: Fix endianness issue in t4_fwcache()

Geert Uytterhoeven (2):
      ARM: dts: ux500: Correct SCU unit address
      fbdev: Remove unused SH-Mobile HDMI driver

George Kennedy (1):
      scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Greg Kroah-Hartman (1):
      Linux 4.4.203

Grygorii Strashko (1):
      ARM: dts: am335x-evm: fix number of cpsw

H. Nikolaus Schaller (4):
      ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overwrite in other DTS files
      ARM: dts: omap3-gta04: tvout: enable as display1 alias
      ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-Boot
      ARM: dts: omap3-gta04: keep vpll2 always on

He Zhe (1):
      printk: Give error on attempt to set log buffer length to over 2G

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

Huibin Hong (1):
      spi: rockchip: initialize dma_slave_config properly

Jaegeuk Kim (1):
      f2fs: return correct errno in f2fs_gc

Jason Yan (1):
      scsi: libsas: always unregister the old device if going to discover new

Jay Foster (1):
      ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Jens Axboe (1):
      libata: have ata_scsi_rw_xlat() fail invalid passthrough requests

Jia-Ju Bai (2):
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
      usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in fotg210_get_status()

Joel Pepper (1):
      usb: gadget: uvc: configfs: Prevent format changes after linking header

Johan Hovold (1):
      USB: serial: cypress_m8: fix interrupt-out transfer length

John Johansen (3):
      apparmor: fix uninitialized lsm_audit member
      apparmor: fix update the mtime of the profile file on replacement
      apparmor: fix module parameters can be changed after policy is locked

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Julian Wiedmann (1):
      s390/qeth: invoke softirqs after napi_schedule()

Justin Ernst (1):
      EDAC: Raise the maximum number of memory controllers

Kefeng Wang (1):
      Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_uart_set_proto()

Kirill Tkhai (1):
      fuse: use READ_ONCE on congestion_threshold and max_background

Lao Wei (1):
      media: fix: media: pci: meye: validate offset to avoid arbitrary access

Larry Finger (1):
      rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

Laura Abbott (1):
      misc: kgdbts: Fix restrict error

Laurent Pinchart (3):
      usb: gadget: uvc: configfs: Drop leaked references to config items
      usb: gadget: uvc: Factor out video USB request queueing
      usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Li Qiang (1):
      vfio/pci: Fix potential memory leak in vfio_msi_cap_len

Linus Walleij (1):
      ARM: dts: ux500: Fix LCDA clock line muxing

Loic Poulain (2):
      usb: chipidea: Fix otg event handler
      Bluetooth: hci_ldisc: Fix null pointer derefence in case of early data

Ludovic Desroches (1):
      pinctrl: at91: don't use the same irqchip with multiple gpiochips

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS

Marcel Ziswiler (3):
      ARM: dts: pxa: fix power i2c base address
      ARM: dts: tegra30: fix xcvr-setup-use-fuses
      ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcus Folkesson (1):
      iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Marek Szyprowski (1):
      ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook

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

Nathan Chancellor (8):
      media: davinci: Fix implicit enum conversion warning
      dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction
      dmaengine: timb_dma: Use proper enum in td_prep_slave_sg
      cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update
      cxgb4: Use proper enum in IEEE_FAUX_SYNC
      mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer
      ata: ep93xx: Use proper enums for directions
      backlight: lm3639: Unconditionally call led_classdev_unregister

Nathan Fontenot (1):
      powerpc/pseries: Disable CPU hotplug across migrations

Naveen N. Rao (2):
      powerpc/pseries: Fix DTL buffer registration
      powerpc/pseries: Fix how we iterate over the DTL entries

Nicholas Piggin (1):
      powerpc/64s/hash: Fix stab_rr off by one initialization

Oleksij Rempel (1):
      ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" is set

Olga Kornievskaia (1):
      NFSv4.x: fix lock recovery during delegation recall

Oliver Neukum (2):
      ax88172a: fix information leak on short answers
      Input: ff-memless - kill timer in destroy()

Patryk Małek (2):
      i40e: hold the rtnl lock on clearing interrupt scheme
      i40e: Prevent deleting MAC address from VF when set by PF

Pavel Tatashin (1):
      arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

Peter Zijlstra (1):
      x86/atomic: Fix smp_mb__{before,after}_atomic()

Radoslaw Tyl (1):
      ixgbe: Fix crash with VFs and flow director on interface flap

Radu Solea (2):
      crypto: mxs-dcp - Fix SHA null hashes and output length
      crypto: mxs-dcp - Fix AES issues

Rami Rosen (1):
      dmaengine: ioat: fix prototype of ioat_enumerate_channels

Ricardo Ribalda Delgado (1):
      mtd: physmap_of: Release resources on error

Rob Herring (4):
      of: make PowerMac cache node search conditional on CONFIG_PPC_PMAC
      libfdt: Ensure INT_MAX is defined in libfdt_env.h
      ARM: dts: ste: Fix SPI controller node names
      arm64: dts: amd: Fix SPI bus warnings

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Ronald Tschalär (1):
      ACPI / SBS: Fix rare oops when removing modules

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

Takashi Iwai (3):
      ALSA: usb-audio: Fix missing error check at mixer resolution test
      ALSA: seq: Do error checks at creating system ports
      ALSA: intel8x0m: Register irq handler after register initializations

Thierry Reding (1):
      hwmon: (pwm-fan) Silence error on probe deferral

Tim Smith (1):
      GFS2: Flush the GFS2 delete workqueue before stopping the kernel threads

Timothy E Baldwin (1):
      ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Tomasz Figa (1):
      power: supply: max8998-charger: Fix platform data retrieval

Trent Piepho (1):
      spi: spidev: Fix OF tree warning logic

Trond Myklebust (1):
      SUNRPC: Fix priority queue fairness

Tuomas Tynkkynen (1):
      MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Wei Yongjun (1):
      IB/mthca: Fix error return code in __mthca_init_one()

Wenwen Wang (1):
      media: isif: fix a NULL pointer dereference bug

YueHaibing (7):
      net: toshiba: fix return type of ndo_start_xmit function
      net: xilinx: fix return type of ndo_start_xmit function
      net: broadcom: fix return type of ndo_start_xmit function
      net: amd: fix return type of ndo_start_xmit function
      net: micrel: fix return type of ndo_start_xmit function
      net: smsc: fix return type of ndo_start_xmit function
      net: ovs: fix return type of ndo_start_xmit function

zhong jiang (2):
      misc: genwqe: should return proper error value.
      memfd: Use radix_tree_deref_slot_protected to avoid the warning.

