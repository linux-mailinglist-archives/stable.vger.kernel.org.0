Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FCDCCFEB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfJFJU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 05:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfJFJU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 05:20:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A52206C2;
        Sun,  6 Oct 2019 09:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570353657;
        bh=/UmNmqWYQwt62jLRrQpWDOQODh/S45q955zHogG8BA8=;
        h=Date:From:To:Cc:Subject:From;
        b=QPnCORIuu+99/JDPzGGsdGtxiVb2/Y2Trm+WN1htOIKYSWPQTeeKMFtfm35j/2oP7
         cIK38DX/J/kTOsU/RIEF1ls00te1UOPReH8spbhtxsHK/wFSPXRFuB4myJsSSmHCKt
         cEcChjWDwQdwPGM0NazIIxLkBTGmNtxPjaeYDdKc=
Date:   Sun, 6 Oct 2019 11:20:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.195
Message-ID: <20191006092054.GA2760731@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.195 kernel.

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

 Makefile                                         |    2=20
 arch/arm/boot/dts/exynos5420-peach-pit.dts       |    1=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts        |    1=20
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts          |    4=20
 arch/arm/mach-zynq/platsmp.c                     |    2=20
 arch/arm64/mm/proc.S                             |    9 +
 arch/ia64/kernel/module.c                        |    8 +
 arch/s390/crypto/aes_s390.c                      |    6 +
 arch/x86/kernel/apic/apic.c                      |    8 +
 arch/x86/kernel/smp.c                            |   46 +++++----
 arch/x86/kvm/emulate.c                           |    2=20
 arch/x86/kvm/x86.c                               |   21 +++-
 drivers/acpi/cppc_acpi.c                         |    6 -
 drivers/acpi/custom_method.c                     |    5 -
 drivers/acpi/pci_irq.c                           |    4=20
 drivers/base/soc.c                               |    2=20
 drivers/bluetooth/btusb.c                        |    3=20
 drivers/char/hw_random/core.c                    |    2=20
 drivers/char/mem.c                               |   21 ++++
 drivers/crypto/talitos.c                         |    1=20
 drivers/devfreq/exynos-bus.c                     |   31 +++---
 drivers/devfreq/governor_passive.c               |    7 -
 drivers/dma/bcm2835-dma.c                        |    4=20
 drivers/dma/edma.c                               |    9 +
 drivers/dma/iop-adma.c                           |   18 +--
 drivers/edac/altera_edac.c                       |    4=20
 drivers/firmware/efi/cper.c                      |   15 +++
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |    5 +
 drivers/gpu/drm/drm_probe_helper.c               |    9 +
 drivers/hid/hid-lg.c                             |   10 +-
 drivers/hid/hid-lg4ff.c                          |    1=20
 drivers/hid/hid-prodikeys.c                      |   12 ++
 drivers/hid/hidraw.c                             |    2=20
 drivers/hwmon/acpi_power_meter.c                 |    4=20
 drivers/i2c/busses/i2c-riic.c                    |    1=20
 drivers/infiniband/core/cq.c                     |    8 +
 drivers/infiniband/core/device.c                 |   15 ++-
 drivers/infiniband/core/mad.c                    |    2=20
 drivers/infiniband/hw/hfi1/mad.c                 |   45 +++------
 drivers/iommu/amd_iommu.c                        |    4=20
 drivers/irqchip/irq-gic-v3-its.c                 |    9 -
 drivers/isdn/mISDN/socket.c                      |    2=20
 drivers/leds/leds-lp5562.c                       |    6 +
 drivers/md/md.c                                  |   14 ++
 drivers/md/raid1.c                               |   13 ++
 drivers/md/raid5.c                               |    4=20
 drivers/media/dvb-core/dvbdev.c                  |    4=20
 drivers/media/i2c/ov9650.c                       |    5 +
 drivers/media/i2c/tvp5150.c                      |    2=20
 drivers/media/pci/saa7134/saa7134-i2c.c          |   12 +-
 drivers/media/pci/saa7146/hexium_gemini.c        |    3=20
 drivers/media/platform/exynos4-is/fimc-is.c      |    1=20
 drivers/media/platform/exynos4-is/media-dev.c    |    2=20
 drivers/media/platform/omap3isp/isp.c            |    8 +
 drivers/media/platform/omap3isp/ispccdc.c        |    1=20
 drivers/media/platform/omap3isp/ispccp2.c        |    1=20
 drivers/media/platform/omap3isp/ispcsi2.c        |    1=20
 drivers/media/platform/omap3isp/isppreview.c     |    1=20
 drivers/media/platform/omap3isp/ispresizer.c     |    1=20
 drivers/media/platform/omap3isp/ispstat.c        |    2=20
 drivers/media/radio/si470x/radio-si470x-usb.c    |    5 -
 drivers/media/rc/iguanair.c                      |   15 +--
 drivers/media/usb/cpia2/cpia2_usb.c              |    4=20
 drivers/media/usb/dvb-usb/dib0700_devices.c      |    8 +
 drivers/media/usb/gspca/konica.c                 |    5 +
 drivers/media/usb/gspca/nw80x.c                  |    5 +
 drivers/media/usb/gspca/ov519.c                  |   10 ++
 drivers/media/usb/gspca/ov534.c                  |    5 +
 drivers/media/usb/gspca/ov534_9.c                |    1=20
 drivers/media/usb/gspca/se401.c                  |    5 +
 drivers/media/usb/gspca/sn9c20x.c                |   12 ++
 drivers/media/usb/gspca/sonixb.c                 |    5 +
 drivers/media/usb/gspca/sonixj.c                 |    5 +
 drivers/media/usb/gspca/spca1528.c               |    5 +
 drivers/media/usb/gspca/sq930x.c                 |    5 +
 drivers/media/usb/gspca/sunplus.c                |    5 +
 drivers/media/usb/gspca/vc032x.c                 |    5 +
 drivers/media/usb/gspca/w996Xcf.c                |    5 +
 drivers/media/usb/hdpvr/hdpvr-core.c             |   13 ++
 drivers/media/usb/ttusb-dec/ttusb_dec.c          |    2=20
 drivers/mmc/host/sdhci.c                         |    4=20
 drivers/mtd/chips/cfi_cmdset_0002.c              |   18 ++-
 drivers/net/arcnet/arcnet.c                      |   31 +++---
 drivers/net/ethernet/intel/e1000e/ich8lan.c      |   10 ++
 drivers/net/ethernet/intel/e1000e/ich8lan.h      |    2=20
 drivers/net/ethernet/marvell/skge.c              |    2=20
 drivers/net/ethernet/nxp/lpc_eth.c               |   13 +-
 drivers/net/macsec.c                             |    1=20
 drivers/net/phy/national.c                       |    9 +
 drivers/net/ppp/ppp_generic.c                    |    2=20
 drivers/net/usb/cdc_ncm.c                        |    6 +
 drivers/net/usb/usbnet.c                         |    8 +
 drivers/net/wireless/marvell/libertas/if_usb.c   |    3=20
 drivers/nvme/target/admin-cmd.c                  |   14 +-
 drivers/parisc/dino.c                            |   24 ++++
 drivers/power/supply/power_supply_sysfs.c        |    3=20
 drivers/regulator/core.c                         |   42 ++++++--
 drivers/regulator/lm363x-regulator.c             |    2=20
 fs/btrfs/ctree.c                                 |    5 -
 fs/btrfs/extent-tree.c                           |    8 +
 fs/btrfs/qgroup.c                                |   43 ++++----
 fs/cifs/smb2ops.c                                |    5 +
 fs/cifs/xattr.c                                  |    2=20
 fs/ext4/extents.c                                |    4=20
 fs/ext4/inode.c                                  |    9 +
 fs/f2fs/segment.c                                |   44 ++++++++-
 fs/f2fs/super.c                                  |    4=20
 fs/fuse/file.c                                   |    1=20
 fs/overlayfs/inode.c                             |    3=20
 fs/xfs/libxfs/xfs_bmap.c                         |   29 ++++--
 include/linux/bug.h                              |    5 +
 include/linux/quotaops.h                         |    2=20
 include/rdma/ib_verbs.h                          |    9 +
 kernel/kprobes.c                                 |    3=20
 kernel/locking/lockdep.c                         |    3=20
 kernel/printk/printk.c                           |  111 +++++-------------=
-----
 kernel/sched/core.c                              |    4=20
 kernel/sched/fair.c                              |    5 -
 kernel/time/alarmtimer.c                         |    4=20
 mm/memcontrol.c                                  |   10 ++
 net/appletalk/ddp.c                              |    5 +
 net/ax25/af_ax25.c                               |    2=20
 net/bluetooth/hci_event.c                        |    5 -
 net/bluetooth/l2cap_core.c                       |    9 -
 net/ieee802154/socket.c                          |    3=20
 net/mac80211/ieee80211_i.h                       |    3=20
 net/mac80211/mlme.c                              |   17 ++-
 net/mac80211/tdls.c                              |   23 ++++
 net/nfc/llcp_sock.c                              |    7 +
 net/openvswitch/datapath.c                       |    2=20
 net/qrtr/qrtr.c                                  |    1=20
 net/sched/sch_netem.c                            |    2=20
 net/wireless/util.c                              |    1=20
 sound/firewire/tascam/tascam-pcm.c               |    3=20
 sound/firewire/tascam/tascam-stream.c            |   42 +++++---
 sound/hda/hdac_controller.c                      |    2=20
 sound/i2c/other/ak4xxx-adda.c                    |    7 -
 sound/pci/hda/hda_controller.c                   |    5 -
 sound/pci/hda/hda_intel.c                        |    2=20
 sound/pci/hda/patch_analog.c                     |    1=20
 sound/pci/hda/patch_realtek.c                    |    3=20
 sound/soc/codecs/sgtl5000.c                      |   15 ++-
 sound/soc/fsl/fsl_ssi.c                          |    5 -
 sound/soc/intel/common/sst-ipc.c                 |    2=20
 sound/soc/intel/skylake/skl-nhlt.c               |    2=20
 sound/soc/soc-generic-dmaengine-pcm.c            |    6 +
 sound/usb/pcm.c                                  |    1=20
 tools/lib/traceevent/Makefile                    |    6 -
 tools/lib/traceevent/event-plugin.c              |    2=20
 tools/objtool/Makefile                           |    2=20
 150 files changed, 892 insertions(+), 378 deletions(-)

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

Amadeusz S=C5=82awi=C5=84ski (2):
      ASoC: Intel: NHLT: Fix debug print format
      ASoC: Intel: Fix use of potentially uninitialized variable

Andr=C3=A9 Draszik (1):
      ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Ard van Breemen (1):
      ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Arkadiusz Miskiewicz (1):
      mac80211: Print text for disassociation reason

Arnd Bergmann (3):
      media: dib0700: fix link error for dibx000_i2c_set_speed
      dmaengine: iop-adma: use correct printk format strings
      net: lpc-enet: fix printk format strings

Axel Lin (1):
      regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_=
vneg

Bjorn Andersson (1):
      net: qrtr: Stop rx_worker before freeing node

Bj=C3=B8rn Mork (2):
      cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
      usbnet: ignore endpoints with invalid wMaxPacketSize

Chao Yu (3):
      Revert "f2fs: avoid out-of-range memory access"
      f2fs: fix to do sanity check on segment bitmap of LFS curseg
      quota: fix wrong condition in is_quota_modification()

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr

Chris Wilson (2):
      drm: Flush output polling on shutdown
      ALSA: hda: Flush interrupts on disabling

Dan Carpenter (1):
      EDAC/altera: Use the proper type for the IRQ status bits

Darrick J. Wong (1):
      xfs: don't crash on null attr fork xfs_bmapi_read

David Lechner (1):
      power: supply: sysfs: ratelimit property read error message

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Eric Dumazet (1):
      sch_netem: fix a divide by zero in tabledist()

Filipe Manana (2):
      Btrfs: fix use-after-free when using the tree modification log
      Btrfs: fix race setting up and completing qgroup rescan workers

Greg Kroah-Hartman (1):
      Linux 4.9.195

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector I=
PI fails

Guoqing Jiang (2):
      md: don't call spare_active in md_reap_sync_thread if all member devi=
ces can't work
      md: don't set In_sync if array is frozen

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans Verkuil (3):
      media: gspca: zero usb_buf on error
      media: radio/si470x: kill urb on error
      media: hdpvr: add terminating 0 at end of string

Hans de Goede (1):
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

Josh Poimboeuf (1):
      objtool: Clobber user CFLAGS variable

Juri Lelli (1):
      sched/core: Fix CPU controller for !RT_GROUP_SCHED

Kai-Heng Feng (1):
      e1000e: add workaround for possible stalled packet

Kamil Konieczny (1):
      PM / devfreq: exynos-bus: Correct clock enable sequence

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Leonard Crestez (1):
      PM / devfreq: passive: Use non-devm notifiers

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Linus Torvalds (1):
      printk: remove games with previous record flags

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

Masami Hiramatsu (1):
      kprobes: Prohibit probing on BUG() and WARN() address

Mauro Carvalho Chehab (1):
      media: ov9650: add a sanity check

Michal Hocko (1):
      memcg, kmem: do not fail __GFP_NOFAIL charges

Murphy Zhou (1):
      CIFS: fix max ea value size

MyungJoo Ham (1):
      PM / devfreq: passive: fix compiler warning

Nick Stoughton (1):
      leds: leds-lp5562 allow firmware files up to the maximum length

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

Qian Cai (1):
      iommu/amd: Silence warnings under memory pressure

Qu Wenruo (1):
      btrfs: extent-tree: Make sure we only allocate extents from block gro=
ups with the same type

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio

Sakari Ailus (2):
      media: omap3isp: Don't set streaming state on random subdevs
      media: omap3isp: Set device on omap3isp subdevs

Sean Christopherson (1):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Stefan Wahren (1):
      dmaengine: bcm2835: Print error in case setting DMA mask fails

Stephen Hemminger (1):
      skge: fix checksum byte order

Surbhi Palande (1):
      f2fs: check all the data segments against all node ones

Takashi Iwai (3):
      ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
      ALSA: hda - Show the fatal CORB/RIRB error more clearly
      ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Takashi Sakamoto (2):
      ALSA: firewire-tascam: handle error code when getting current source =
of clock
      ALSA: firewire-tascam: check intermediate state of clock status and r=
etry

Takeshi Misawa (1):
      ppp: Fix memory leak in ppp_write

Tetsuo Handa (1):
      /dev/mem: Bail out upon SIGKILL.

Thadeu Lima de Souza Cascardo (1):
      alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Theodore Ts'o (1):
      ext4: fix punch hole for inline_data file systems

Thomas Gleixner (1):
      x86/apic: Soft disable APIC before initializing it

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Tom Wu (1):
      nvmet: fix data units read and written counters in SMART log

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Tzvetomir Stoyanov (1):
      libtraceevent: Change users plugin directory

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

Xiao Ni (1):
      md/raid6: Set R5_ReadError when there is read failure on parity disk

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

Xin Long (1):
      macsec: drop skb sk before calling gro_cells_receive

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

Yufen Yu (1):
      md/raid1: fail run raid1 array when active disk less than one

chenzefeng (1):
      ia64:unwind: fix double free for mod->arch.init_unw_table


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2ZsfMACgkQONu9yGCS
aT6oew/6Awz7eT3SPiL8ofKDbWif+aE/nplPzLPPN6kWsqs1i6ELJWkym0rbnrWw
+kmaYe0fYb3vsi/H5AjC/tFrVmHYfr6o7Mh1U6xX8HdEsKtfdQP7o3S566FXcWeV
vyQS700hmVQwa3sk5fImAo7d2y0SpT5oKxvZRArRwzGlPD3sFPtLgBuFYQeVI8wF
TPS1XNaLlcvm3BLZVaeH+MUBbtfrYmqQp+KIzOOmWmFtCJbsHV41+MvgBDdBgs4o
mWgFe22dRY3UD4/92zH04zRqKuPNoX1Idht0G6GieRhhVtNdXwwA+znPaNd7WDdo
jnjKvSi2qEFVWSCqkv7whwoMMYg88vOc9kLK7Di3REse9vrVIjVPtbT+a3vrqvpK
uoeHoJt/FHpuOYxO1w+JzNgXgGCZO0eem6DAIwoNcHVZrUN0n2Hdxg+Vj87yx9/Y
+VyOmhL4kQ8NHys4T9zZa5e+xXM1P4WIQWUeFmmaL576zOx3zowfrzJCO8klV+iy
HvDMUKJMf5QLHsiG6oPe1YXsW3aDAq6zO1AKS6WrOatErDutXLk0t4IG3aCkawUm
f0E00ydQ+CElIHKVvJCmvPX+DRNpO8RKOFffO+WmPi+/14xb1AJlpYcAulaOrM3W
MfRjMtsuCCMlcRiWLjobSq1ZCgsqFZ1Se2J01X9FW55NzVVHLRk=
=TQ9h
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
