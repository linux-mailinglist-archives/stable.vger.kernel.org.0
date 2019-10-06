Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F77CCFF3
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfJFJVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 05:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfJFJVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 05:21:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B624206C2;
        Sun,  6 Oct 2019 09:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570353682;
        bh=as3IKLocEziYnfnEkZnviESEoTqKvqLD9P8zESdnLyQ=;
        h=Date:From:To:Cc:Subject:From;
        b=d6RpON8w9jvG6i8Z+XXJEy0PRVu8CG68BEPG3RjhkQNTpwYMeDUb4hsHtRqL1h01G
         bAbFAOkOqTzFKauTmtPROeehth1q9G2xeHaJRN6pTFkjHOmQlooOhp/rnNe5YWde+w
         rYnUSDqqKWsMI2QDUzaxuucMt7prajKthTb/eDeA=
Date:   Sun, 6 Oct 2019 11:21:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.147
Message-ID: <20191006092119.GA2763303@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.147 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    6 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts        |    1=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts         |    1=20
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts           |    4 -
 arch/arm/mach-zynq/platsmp.c                      |    2=20
 arch/arm/plat-samsung/watchdog-reset.c            |    1=20
 arch/arm64/boot/dts/rockchip/rk3328.dtsi          |    3 +
 arch/arm64/kernel/cpufeature.c                    |    5 ++
 arch/arm64/mm/proc.S                              |    9 ++++
 arch/ia64/kernel/module.c                         |    8 ++-
 arch/powerpc/include/asm/opal.h                   |    2=20
 arch/powerpc/platforms/powernv/opal-wrappers.S    |    2=20
 arch/powerpc/sysdev/xive/native.c                 |   11 ++++
 arch/s390/crypto/aes_s390.c                       |    6 ++
 arch/x86/Makefile                                 |    2=20
 arch/x86/kernel/apic/apic.c                       |    8 +++
 arch/x86/kernel/smp.c                             |   46 ++++++++++++-----=
---
 arch/x86/kvm/emulate.c                            |    2=20
 arch/x86/kvm/x86.c                                |   21 +++++++--
 block/blk-mq.c                                    |    2=20
 block/blk-sysfs.c                                 |    3 +
 drivers/acpi/acpi_processor.c                     |   10 +++-
 drivers/acpi/acpi_video.c                         |   37 ++++++++++++++++
 drivers/acpi/cppc_acpi.c                          |    6 +-
 drivers/acpi/custom_method.c                      |    5 +-
 drivers/acpi/pci_irq.c                            |    4 +
 drivers/base/soc.c                                |    2=20
 drivers/block/nbd.c                               |    4 +
 drivers/bluetooth/btusb.c                         |    3 +
 drivers/char/hw_random/core.c                     |    2=20
 drivers/char/mem.c                                |   21 +++++++++
 drivers/crypto/talitos.c                          |    1=20
 drivers/devfreq/exynos-bus.c                      |   31 +++++++------
 drivers/devfreq/governor_passive.c                |    7 +--
 drivers/dma/bcm2835-dma.c                         |    4 +
 drivers/dma/edma.c                                |    9 ++--
 drivers/dma/iop-adma.c                            |   18 ++++----
 drivers/edac/altera_edac.c                        |    4 +
 drivers/edac/amd64_edac.c                         |   28 ++++++++----
 drivers/edac/edac_mc.c                            |    8 ++-
 drivers/edac/pnd2_edac.c                          |    7 ++-
 drivers/firmware/efi/cper.c                       |   15 ++++++
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |    5 ++
 drivers/gpu/drm/drm_probe_helper.c                |    9 +++-
 drivers/hid/hid-lg.c                              |   10 ++--
 drivers/hid/hid-lg4ff.c                           |    1=20
 drivers/hid/hid-prodikeys.c                       |   12 ++++-
 drivers/hid/hid-sony.c                            |    2=20
 drivers/hid/hidraw.c                              |    2=20
 drivers/hwmon/acpi_power_meter.c                  |    4 -
 drivers/i2c/busses/i2c-riic.c                     |    1=20
 drivers/infiniband/core/cq.c                      |    8 ++-
 drivers/infiniband/core/device.c                  |   15 ++++++
 drivers/infiniband/core/mad.c                     |    2=20
 drivers/infiniband/hw/hfi1/mad.c                  |   45 ++++++++---------=
---
 drivers/iommu/amd_iommu.c                         |    4 +
 drivers/iommu/iova.c                              |    4 +
 drivers/irqchip/irq-gic-v3-its.c                  |    9 +---
 drivers/isdn/mISDN/socket.c                       |    2=20
 drivers/leds/leds-lp5562.c                        |    6 ++
 drivers/md/dm-zoned-target.c                      |    2=20
 drivers/md/md.c                                   |   28 ++++++++----
 drivers/md/md.h                                   |    3 +
 drivers/md/raid0.c                                |   33 ++++++++++++++
 drivers/md/raid0.h                                |   14 ++++++
 drivers/md/raid1.c                                |   39 +++++++++++------
 drivers/md/raid5.c                                |   10 +++-
 drivers/media/cec/cec-notifier.c                  |    2=20
 drivers/media/dvb-core/dvbdev.c                   |    4 +
 drivers/media/i2c/ov5640.c                        |    5 ++
 drivers/media/i2c/ov5645.c                        |   26 ++++++++---
 drivers/media/i2c/ov9650.c                        |    5 ++
 drivers/media/i2c/tvp5150.c                       |    2=20
 drivers/media/pci/saa7134/saa7134-i2c.c           |   12 +++--
 drivers/media/pci/saa7146/hexium_gemini.c         |    3 +
 drivers/media/platform/exynos4-is/fimc-is.c       |    1=20
 drivers/media/platform/exynos4-is/media-dev.c     |    2=20
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c     |    4 +
 drivers/media/platform/omap3isp/isp.c             |    8 +++
 drivers/media/platform/omap3isp/ispccdc.c         |    1=20
 drivers/media/platform/omap3isp/ispccp2.c         |    1=20
 drivers/media/platform/omap3isp/ispcsi2.c         |    1=20
 drivers/media/platform/omap3isp/isppreview.c      |    1=20
 drivers/media/platform/omap3isp/ispresizer.c      |    1=20
 drivers/media/platform/omap3isp/ispstat.c         |    2=20
 drivers/media/platform/rcar_fdp1.c                |    2=20
 drivers/media/radio/si470x/radio-si470x-usb.c     |    5 +-
 drivers/media/rc/iguanair.c                       |   15 +++---
 drivers/media/rc/imon.c                           |    7 ++-
 drivers/media/rc/mtk-cir.c                        |    8 +++
 drivers/media/usb/cpia2/cpia2_usb.c               |    4 +
 drivers/media/usb/dvb-usb/dib0700_devices.c       |    8 +++
 drivers/media/usb/gspca/konica.c                  |    5 ++
 drivers/media/usb/gspca/nw80x.c                   |    5 ++
 drivers/media/usb/gspca/ov519.c                   |   10 ++++
 drivers/media/usb/gspca/ov534.c                   |    5 ++
 drivers/media/usb/gspca/ov534_9.c                 |    1=20
 drivers/media/usb/gspca/se401.c                   |    5 ++
 drivers/media/usb/gspca/sn9c20x.c                 |   12 +++++
 drivers/media/usb/gspca/sonixb.c                  |    5 ++
 drivers/media/usb/gspca/sonixj.c                  |    5 ++
 drivers/media/usb/gspca/spca1528.c                |    5 ++
 drivers/media/usb/gspca/sq930x.c                  |    5 ++
 drivers/media/usb/gspca/sunplus.c                 |    5 ++
 drivers/media/usb/gspca/vc032x.c                  |    5 ++
 drivers/media/usb/gspca/w996Xcf.c                 |    5 ++
 drivers/media/usb/hdpvr/hdpvr-core.c              |   13 +++++
 drivers/media/usb/ttusb-dec/ttusb_dec.c           |    2=20
 drivers/mmc/core/sdio_irq.c                       |    9 ++--
 drivers/mmc/host/sdhci.c                          |    4 +
 drivers/mtd/chips/cfi_cmdset_0002.c               |   18 +++++---
 drivers/net/arcnet/arcnet.c                       |   31 +++++++------
 drivers/net/ethernet/intel/e1000e/ich8lan.c       |   10 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h       |    2=20
 drivers/net/ethernet/marvell/skge.c               |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |    1=20
 drivers/net/ethernet/nxp/lpc_eth.c                |   13 +++--
 drivers/net/macsec.c                              |    1=20
 drivers/net/phy/national.c                        |    9 ++--
 drivers/net/ppp/ppp_generic.c                     |    2=20
 drivers/net/usb/cdc_ncm.c                         |    6 ++
 drivers/net/usb/usbnet.c                          |    8 +++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |    2=20
 drivers/net/wireless/marvell/libertas/if_usb.c    |    3 -
 drivers/nvme/target/admin-cmd.c                   |   14 +++---
 drivers/parisc/dino.c                             |   24 ++++++++++
 drivers/pci/host/pci-hyperv.c                     |    2=20
 drivers/pinctrl/sprd/pinctrl-sprd.c               |    6 --
 drivers/power/supply/power_supply_sysfs.c         |    3 -
 drivers/regulator/core.c                          |   42 +++++++++++++-----
 drivers/regulator/lm363x-regulator.c              |    2=20
 drivers/scsi/device_handler/scsi_dh_rdac.c        |    2=20
 drivers/staging/media/imx/imx6-mipi-csi2.c        |   12 +----
 fs/binfmt_elf.c                                   |    3 -
 fs/btrfs/ctree.c                                  |    5 +-
 fs/btrfs/extent-tree.c                            |    8 +++
 fs/btrfs/qgroup.c                                 |   45 +++++++++++------=
---
 fs/cifs/smb2ops.c                                 |    5 ++
 fs/cifs/xattr.c                                   |    2=20
 fs/ext4/extents.c                                 |    4 -
 fs/ext4/inode.c                                   |    9 ++++
 fs/f2fs/checkpoint.c                              |    8 ++-
 fs/f2fs/data.c                                    |    8 +--
 fs/f2fs/f2fs.h                                    |    4 +
 fs/f2fs/inline.c                                  |    4 -
 fs/f2fs/inode.c                                   |    4 -
 fs/f2fs/node.c                                    |    4 -
 fs/f2fs/recovery.c                                |    2=20
 fs/f2fs/segment.c                                 |   49 +++++++++++++++++=
+----
 fs/f2fs/segment.h                                 |    4 -
 fs/f2fs/super.c                                   |    6 +-
 fs/fuse/file.c                                    |    1=20
 fs/gfs2/bmap.c                                    |    1=20
 fs/overlayfs/inode.c                              |    3 -
 fs/xfs/libxfs/xfs_bmap.c                          |   29 +++++++++----
 include/linux/bug.h                               |    5 ++
 include/linux/quotaops.h                          |    2=20
 include/rdma/ib_verbs.h                           |    9 ++--
 kernel/kprobes.c                                  |    3 -
 kernel/locking/lockdep.c                          |    3 +
 kernel/printk/printk.c                            |    2=20
 kernel/sched/core.c                               |    4 -
 kernel/sched/fair.c                               |   11 ++--
 kernel/time/alarmtimer.c                          |    4 -
 mm/compaction.c                                   |   35 +++++----------
 mm/memcontrol.c                                   |   10 ++++
 mm/oom_kill.c                                     |    5 +-
 net/appletalk/ddp.c                               |    5 ++
 net/ax25/af_ax25.c                                |    2=20
 net/bluetooth/hci_event.c                         |    5 --
 net/bluetooth/l2cap_core.c                        |    9 ----
 net/ieee802154/socket.c                           |    3 +
 net/ipv4/raw_diag.c                               |    3 -
 net/nfc/llcp_sock.c                               |    7 ++-
 net/openvswitch/datapath.c                        |    2=20
 net/qrtr/qrtr.c                                   |    1=20
 net/sched/act_sample.c                            |    1=20
 net/sched/sch_api.c                               |    3 -
 net/sched/sch_netem.c                             |    2=20
 net/wireless/util.c                               |    1=20
 scripts/gcc-plugins/randomize_layout_plugin.c     |   10 ++--
 sound/firewire/tascam/tascam-pcm.c                |    3 +
 sound/firewire/tascam/tascam-stream.c             |   42 ++++++++++++------
 sound/hda/hdac_controller.c                       |    2=20
 sound/i2c/other/ak4xxx-adda.c                     |    7 +--
 sound/pci/hda/hda_controller.c                    |    5 +-
 sound/pci/hda/hda_intel.c                         |    5 --
 sound/pci/hda/patch_analog.c                      |    1=20
 sound/pci/hda/patch_hdmi.c                        |    9 +++-
 sound/pci/hda/patch_realtek.c                     |   22 +++++++++
 sound/soc/codecs/es8316.c                         |    7 ++-
 sound/soc/codecs/sgtl5000.c                       |   15 ++++--
 sound/soc/fsl/fsl_ssi.c                           |    5 +-
 sound/soc/intel/common/sst-ipc.c                  |    2=20
 sound/soc/intel/skylake/skl-debug.c               |    2=20
 sound/soc/intel/skylake/skl-nhlt.c                |    2=20
 sound/soc/sh/rcar/adg.c                           |   21 ++++++---
 sound/soc/soc-generic-dmaengine-pcm.c             |    6 ++
 sound/usb/pcm.c                                   |    1=20
 tools/lib/traceevent/Makefile                     |    6 +-
 tools/lib/traceevent/event-plugin.c               |    2=20
 tools/objtool/Makefile                            |    7 ++-
 tools/perf/tests/shell/trace+probe_vfs_getname.sh |    4 +
 tools/perf/trace/beauty/ioctl.c                   |    2=20
 tools/perf/util/header.c                          |    4 +
 tools/perf/util/xyarray.h                         |    3 -
 206 files changed, 1196 insertions(+), 436 deletions(-)

Ahzo (1):
      drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)

Al Cooper (1):
      mmc: sdhci: Fix incorrect switch to HS mode

Al Stone (1):
      ACPI / CPPC: do not require the _PSD method

Alan Stern (3):
      HID: prodikeys: Fix general protection fault during probe
      HID: logitech: Fix general protection fault caused by Logitech driver
      HID: hidraw: Fix invalid read in hidraw_ioctl

Amadeusz S=C5=82awi=C5=84ski (3):
      ASoC: Intel: NHLT: Fix debug print format
      ASoC: Intel: Skylake: Use correct function to access iomem space
      ASoC: Intel: Fix use of potentially uninitialized variable

Andr=C3=A9 Draszik (1):
      ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Ard van Breemen (1):
      ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Arnaldo Carvalho de Melo (1):
      perf test vfs_getname: Disable ~/.perfconfig to get default output

Arnd Bergmann (3):
      media: dib0700: fix link error for dibx000_i2c_set_speed
      dmaengine: iop-adma: use correct printk format strings
      net: lpc-enet: fix printk format strings

Axel Lin (1):
      regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_=
vneg

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

Chao Yu (4):
      Revert "f2fs: avoid out-of-range memory access"
      f2fs: fix to do sanity check on segment bitmap of LFS curseg
      f2fs: use generic EFSBADCRC/EFSCORRUPTED
      quota: fix wrong condition in is_quota_modification()

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr

Chris Wilson (2):
      drm: Flush output polling on shutdown
      ALSA: hda: Flush interrupts on disabling

Cong Wang (1):
      net_sched: add max len check for TCA_KIND

Dan Carpenter (1):
      EDAC/altera: Use the proper type for the IRQ status bits

Darius Rad (1):
      media: rc: imon: Allow iMON RC protocol for ffdc 7e device

Darrick J. Wong (1):
      xfs: don't crash on null attr fork xfs_bmapi_read

David Lechner (1):
      power: supply: sysfs: ratelimit property read error message

Davide Caratti (1):
      net/sched: act_sample: don't push mac header on ip6gre ingress

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Dexuan Cui (1):
      PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

Emmanuel Grumbach (1):
      iwlwifi: mvm: send BCAST management frames to the right station

Eric Dumazet (2):
      sch_netem: fix a divide by zero in tabledist()
      iommu/iova: Avoid false sharing on fq_timer_on

Ezequiel Garcia (2):
      media: i2c: ov5645: Fix power sequence
      media: imx: mipi csi-2: Don't fail if initial state times-out

Fabio Estevam (1):
      media: i2c: ov5640: Check for devm_gpiod_get_optional() error

Filipe Manana (2):
      Btrfs: fix use-after-free when using the tree modification log
      Btrfs: fix race setting up and completing qgroup rescan workers

Geert Uytterhoeven (1):
      media: fdp1: Reduce FCP not found message level to debug

Gerald BAEZA (1):
      libperf: Fix alignment trap with xyarray contents in 'perf stat'

Greg Kroah-Hartman (1):
      Linux 4.14.147

Greg Kurz (1):
      powerpc/xive: Fix bogus error code returned by OPAL

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector I=
PI fails

Guoqing Jiang (3):
      md: don't call spare_active in md_reap_sync_thread if all member devi=
ces can't work
      md: don't set In_sync if array is frozen
      raid5: don't set STRIPE_HANDLE to stripe which is in batch list

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans Verkuil (4):
      media: gspca: zero usb_buf on error
      media: radio/si470x: kill urb on error
      media: hdpvr: add terminating 0 at end of string
      media: cec-notifier: clear cec_adap in cec_notifier_unregister

Hans de Goede (2):
      ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easyno=
te MZ35
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Harald Freudenberger (1):
      s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Ira Weiny (1):
      IB/hfi1: Define variables as unsigned long to fix KASAN warning

Jack Morgenstein (1):
      IB/core: Add an unbound WQ type to the new CQ API

Jan Dakinevich (2):
      KVM: x86: always stop emulation on page fault
      KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jia-Ju Bai (1):
      ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in bu=
ild_adc_controls()

Jian-Hong Pan (1):
      Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Jiri Slaby (1):
      ACPI / processor: don't print errors for processorIDs =3D=3D 0xff

Joonwon Kang (1):
      randstruct: Check member structs in is_pure_ops_struct()

Josh Poimboeuf (1):
      objtool: Clobber user CFLAGS variable

Juri Lelli (1):
      sched/core: Fix CPU controller for !RT_GROUP_SCHED

Kai-Heng Feng (1):
      e1000e: add workaround for possible stalled packet

Kamil Konieczny (1):
      PM / devfreq: exynos-bus: Correct clock enable sequence

Katsuhiro Suzuki (1):
      ASoC: es8316: fix headphone mixer volume table

Kees Cook (1):
      binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Kuninori Morimoto (1):
      ASoC: rsnd: don't call clk_get_rate() under atomic context

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Leonard Crestez (1):
      PM / devfreq: passive: Use non-devm notifiers

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Lihua Yao (1):
      ARM: samsung: Fix system restart on S3C6410

Lu Fengqi (1):
      btrfs: qgroup: Drop quota_root and fs_info parameters from update_qgr=
oup_status_item

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Luke Nowakowski-Krijger (1):
      media: hdpvr: Add device num check and handling

Maciej S. Szmigiero (1):
      media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate=
()

Marc Zyngier (1):
      irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Marcel Holtmann (1):
      Revert "Bluetooth: validate BLE connection interval updates"

Marco Felsch (1):
      media: tvp5150: fix switch exit in set control handler

Marek Szyprowski (1):
      ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks

Mark Brown (1):
      regulator: Defer init completion for a while after late_initcall

Mark Rutland (1):
      arm64: kpti: ensure patched kernel text is fetched from PoU

Mark Salyzyn (1):
      ovl: filter of trusted xattr results in audit

Martin Wilck (1):
      scsi: scsi_dh_rdac: zero cdb in send_mode_select()

Masami Hiramatsu (1):
      kprobes: Prohibit probing on BUG() and WARN() address

Matthias Brugger (1):
      media: mtk-mdp: fix reference count on old device tree

Mauro Carvalho Chehab (1):
      media: ov9650: add a sanity check

Michal Hocko (1):
      memcg, kmem: do not fail __GFP_NOFAIL charges

Mike Christie (1):
      nbd: add missing config put

Mikulas Patocka (1):
      dm zoned: fix invalid memory access

Murphy Zhou (1):
      CIFS: fix max ea value size

MyungJoo Ham (1):
      PM / devfreq: passive: fix compiler warning

Nathan Chancellor (2):
      pinctrl: sprd: Use define directive for sprd_pinconf_params values
      x86/retpolines: Fix up backport of a9d57ef15cbe

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

Oleksandr Suvorov (1):
      ASoC: sgtl5000: Fix charge pump source assignment

Oliver Neukum (2):
      usbnet: sanity checking of packet sizes and device mtu
      media: iguanair: add sanity checks

Ori Nimron (5):
      mISDN: enforce CAP_NET_RAW for raw sockets
      appletalk: enforce CAP_NET_RAW for raw sockets
      ax25: enforce CAP_NET_RAW for raw sockets
      ieee802154: enforce CAP_NET_RAW for raw sockets
      nfc: enforce CAP_NET_RAW for raw sockets

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function

Peter Ujfalusi (2):
      dmaengine: ti: edma: Do not reset reserved paRAM slots
      ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is n=
ot set

Phil Auld (1):
      sched/fair: Use rq_lock/unlock in online_fair_sched_group

Qian Cai (1):
      iommu/amd: Silence warnings under memory pressure

Qu Wenruo (2):
      btrfs: extent-tree: Make sure we only allocate extents from block gro=
ups with the same type
      btrfs: qgroup: Fix the wrong target io_tree when freeing reserved dat=
a space

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio

Robert Richter (1):
      EDAC/mc: Fix grain_bits calculation

Roderick Colenbrander (1):
      HID: sony: Fix memory corruption issue on cleanup.

Rolf Eike Beer (1):
      objtool: Query pkg-config for libelf location

Sakari Ailus (2):
      media: omap3isp: Don't set streaming state on random subdevs
      media: omap3isp: Set device on omap3isp subdevs

Sean Christopherson (1):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS

Sean Young (1):
      media: mtk-cir: lower de-glitch counter for rc-mm protocol

Shawn Lin (1):
      arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Stefan Wahren (1):
      dmaengine: bcm2835: Print error in case setting DMA mask fails

Stephen Douthit (1):
      EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()

Stephen Hemminger (2):
      net: don't warn in inet diag when IPV6 is disabled
      skge: fix checksum byte order

Surbhi Palande (1):
      f2fs: check all the data segments against all node ones

Takashi Iwai (5):
      ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
      ALSA: hda - Apply AMD controller workaround for Raven platform
      ALSA: hda - Show the fatal CORB/RIRB error more clearly
      ALSA: hda - Drop unsol event handler for Intel HDMI codecs
      ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Takashi Sakamoto (2):
      ALSA: firewire-tascam: handle error code when getting current source =
of clock
      ALSA: firewire-tascam: check intermediate state of clock status and r=
etry

Takeshi Misawa (1):
      ppp: Fix memory leak in ppp_write

Tan Xiaojun (1):
      perf record: Support aarch64 random socket_id assignment

Tetsuo Handa (2):
      memcg, oom: don't require __GFP_FS when invoking memcg OOM killer
      /dev/mem: Bail out upon SIGKILL.

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Theodore Ts'o (1):
      ext4: fix punch hole for inline_data file systems

Thomas Gleixner (1):
      x86/apic: Soft disable APIC before initializing it

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Tom Briden (1):
      ALSA: hda/realtek - Fixup mute led on HP Spectre x360

Tom Wu (1):
      nvmet: fix data units read and written counters in SMART log

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Tzvetomir Stoyanov (1):
      libtraceevent: Change users plugin directory

Ulf Hansson (1):
      mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHRE=
AD

Uwe Kleine-K=C3=B6nig (1):
      arcnet: provide a buffer big enough to actually receive packets

Vasily Averin (1):
      fuse: fix missing unlock_page in fuse_writepage()

Vincent Guittot (1):
      sched/fair: Fix imbalance due to CPU affinity

Vincent Whitchurch (1):
      printk: Do not lose last line in kmsg buffer dump

Vinod Koul (1):
      base: soc: Export soc_device_register/unregister APIs

Waiman Long (1):
      locking/lockdep: Add debug_locks check in __lock_downgrade()

Wang Shenran (1):
      hwmon: (acpi_power_meter) Change log level for 'unsafe software power=
 cap'

Wen Yang (1):
      media: exynos4-is: fix leaked of_node references

Wenwen Wang (5):
      media: dvb-core: fix a memory leak bug
      media: saa7146: add cleanup in hexium_attach()
      media: cpia2_usb: fix memory leaks
      ACPI: custom_method: fix memory leaks
      ACPI / PCI: fix acpi_pci_irq_enable() memory leak

Will Deacon (1):
      arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 fi=
eld

Xiao Ni (1):
      md/raid6: Set R5_ReadError when there is read failure on parity disk

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

Xin Long (1):
      macsec: drop skb sk before calling gro_cells_receive

Yafang Shao (1):
      mm/compaction.c: clear total_{migrate,free}_scanned before scanning a=
 new zone

Yazen Ghannam (2):
      EDAC/amd64: Recognize DRAM device type ECC capability
      EDAC/amd64: Decode syndrome before translating address

Yufen Yu (2):
      md/raid1: end bio when the device faulty
      md/raid1: fail run raid1 array when active disk less than one

chenzefeng (1):
      ia64:unwind: fix double free for mod->arch.init_unw_table

zhengbin (1):
      blk-mq: move cancel of requeue_work to the front of blk_exit_queue


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2Zsg8ACgkQONu9yGCS
aT4aig/9EW6PsheMFl7oyqVHM3x1AlkXrdqN2cOZS/cA+Jacp4Gz3JvIAUUX1MmT
rOFjLnvg06TOIvMedv8peN7flmPH7lRmuCg3ORP8dy5tIM4cWBePjvJsCAlQ6v+z
3ZYA3AA7IXvy330QJ+dL6d7bLa6o8JynDmmEOx6PKDEWGflYvwp/uH1xBy7kX3JO
mUsl2qNAPMS2VyDjJxH7SthVoyjVHZWyFS+IXhq+sE4Ha/Xl562hH7HFmpH5Qyxu
66qdZdFP+Xptfo9yNq8ZwzSHlDymgoQiaAE/HY245f3m1g6kSVmhpB4itru2typ7
BsKTVhuQdU/2kswLoNNp4vpEFhJwrekcxLUYyWBHh6PpNseyjAPkK5a8uvJDrayj
K5KsNSqk58WKDypwCqvYOnuhN7Kp9IN5qW+yEEW8GFxZLVxjzqNw8VPL1u6hrr9x
3dbCHMZRYK9wIN2wBVwfGZI8DJUoXz3+L3RxdykCfWKbnP6hYSkFLHeLaZ3NlfK3
atwyuyqFL6lPVS+gPphH+WDkk0fXrZK4ZXH70l9fWEDYvcwEczVEVDxLfBI+kZV3
eU/xCWJZGTUOPlr1MjcQpy9B1ii34FwJP4Gucc7aobCBULEQV83r2dGR2+fpiTop
4HTaKcc1SQvQSjFoSC/lEg5OPr7WIpskSjoLt6eDF8uQ9cGfZ2M=
=5aBr
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
