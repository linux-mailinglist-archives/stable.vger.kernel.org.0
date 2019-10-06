Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2BCCFE7
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfJFJUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 05:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfJFJUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 05:20:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045B7206C2;
        Sun,  6 Oct 2019 09:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570353630;
        bh=ijziIydNgnB7aghCTsKIdKtFmYmef4SSs49k7MOydko=;
        h=Date:From:To:Cc:Subject:From;
        b=BxWFI8h5nniALeBxAF9T3VyoHdSJpcCfQG6AAUO5/pAHDuYyDsH3Ng669xbJpmmUE
         KTaP/BSJnS8zjT2TaGqbk3tXEDQZOYRts3aZruYArnkn78uZ7kws8pUUxkNlXaW2Nw
         tZu6xucDpPzLYXNOJmCAloRYCWkMNKHPWRRvhJ0k=
Date:   Sun, 6 Oct 2019 11:20:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.195
Message-ID: <20191006092028.GA2758222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.195 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 arch/arm/mach-zynq/platsmp.c                  |    2 -
 arch/ia64/kernel/module.c                     |    8 +++-
 arch/x86/kernel/apic/apic.c                   |    8 ++++
 arch/x86/kernel/smp.c                         |   46 +++++++++++++++-----------
 arch/x86/kvm/emulate.c                        |    2 +
 arch/x86/kvm/x86.c                            |   21 +++++++++--
 drivers/acpi/cppc_acpi.c                      |    6 ++-
 drivers/acpi/custom_method.c                  |    5 ++
 drivers/base/soc.c                            |    2 +
 drivers/bluetooth/btusb.c                     |    3 +
 drivers/char/hw_random/core.c                 |    2 -
 drivers/char/mem.c                            |   21 +++++++++++
 drivers/crypto/talitos.c                      |    1 
 drivers/dma/bcm2835-dma.c                     |    4 +-
 drivers/dma/edma.c                            |    9 +++--
 drivers/dma/iop-adma.c                        |   18 +++++-----
 drivers/firmware/efi/cper.c                   |   15 ++++++++
 drivers/gpu/drm/drm_probe_helper.c            |    9 ++++-
 drivers/hid/hid-lg.c                          |   22 ++++++++----
 drivers/hid/hid-lg4ff.c                       |    1 
 drivers/hid/hid-prodikeys.c                   |   12 +++++-
 drivers/hid/hidraw.c                          |    2 -
 drivers/hwmon/acpi_power_meter.c              |    4 +-
 drivers/i2c/busses/i2c-riic.c                 |    1 
 drivers/irqchip/irq-gic-v3-its.c              |    9 ++---
 drivers/isdn/mISDN/socket.c                   |    2 +
 drivers/leds/leds-lp5562.c                    |    6 ++-
 drivers/md/md.c                               |   14 ++++++-
 drivers/md/raid1.c                            |   13 ++++++-
 drivers/md/raid5.c                            |    4 +-
 drivers/media/i2c/ov9650.c                    |    5 ++
 drivers/media/pci/saa7134/saa7134-i2c.c       |   12 ++++--
 drivers/media/pci/saa7146/hexium_gemini.c     |    3 +
 drivers/media/platform/omap3isp/isp.c         |    8 ++++
 drivers/media/platform/omap3isp/ispccdc.c     |    1 
 drivers/media/platform/omap3isp/ispccp2.c     |    1 
 drivers/media/platform/omap3isp/ispcsi2.c     |    1 
 drivers/media/platform/omap3isp/isppreview.c  |    1 
 drivers/media/platform/omap3isp/ispresizer.c  |    1 
 drivers/media/platform/omap3isp/ispstat.c     |    2 +
 drivers/media/radio/si470x/radio-si470x-usb.c |    5 ++
 drivers/media/rc/iguanair.c                   |   15 +++-----
 drivers/media/usb/cpia2/cpia2_usb.c           |    4 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c   |    8 ++++
 drivers/media/usb/gspca/konica.c              |    5 ++
 drivers/media/usb/gspca/nw80x.c               |    5 ++
 drivers/media/usb/gspca/ov519.c               |   10 +++++
 drivers/media/usb/gspca/ov534.c               |    5 ++
 drivers/media/usb/gspca/ov534_9.c             |    1 
 drivers/media/usb/gspca/se401.c               |    5 ++
 drivers/media/usb/gspca/sn9c20x.c             |   12 ++++++
 drivers/media/usb/gspca/sonixb.c              |    5 ++
 drivers/media/usb/gspca/sonixj.c              |    5 ++
 drivers/media/usb/gspca/spca1528.c            |    5 ++
 drivers/media/usb/gspca/sq930x.c              |    5 ++
 drivers/media/usb/gspca/sunplus.c             |    5 ++
 drivers/media/usb/gspca/vc032x.c              |    5 ++
 drivers/media/usb/gspca/w996Xcf.c             |    5 ++
 drivers/media/usb/hdpvr/hdpvr-core.c          |   13 ++++++-
 drivers/media/usb/ttusb-dec/ttusb_dec.c       |    2 -
 drivers/mmc/host/sdhci.c                      |    4 +-
 drivers/mtd/chips/cfi_cmdset_0002.c           |   18 ++++++----
 drivers/net/arcnet/arcnet.c                   |   31 +++++++++--------
 drivers/net/ethernet/marvell/skge.c           |    2 -
 drivers/net/ethernet/nxp/lpc_eth.c            |   13 +++----
 drivers/net/phy/national.c                    |    9 +++--
 drivers/net/usb/cdc_ncm.c                     |    6 ++-
 drivers/net/usb/usbnet.c                      |    8 ++++
 drivers/net/wireless/libertas/if_usb.c        |    3 +
 drivers/parisc/dino.c                         |   24 +++++++++++++
 fs/btrfs/ctree.c                              |    5 ++
 fs/btrfs/extent-tree.c                        |    8 ++++
 fs/btrfs/qgroup.c                             |   33 ++++++++++--------
 fs/cifs/smb2ops.c                             |    5 ++
 fs/ext4/inode.c                               |    9 +++++
 fs/f2fs/segment.c                             |   44 ++++++++++++++++++++++--
 fs/f2fs/super.c                               |    4 +-
 fs/fuse/file.c                                |    1 
 fs/overlayfs/inode.c                          |    3 +
 include/linux/bug.h                           |    5 ++
 include/linux/quotaops.h                      |    2 -
 kernel/kprobes.c                              |    3 +
 kernel/locking/lockdep.c                      |    3 +
 kernel/printk/printk.c                        |    2 -
 kernel/sched/core.c                           |    4 --
 kernel/sched/fair.c                           |    5 +-
 kernel/time/alarmtimer.c                      |    4 +-
 net/appletalk/ddp.c                           |    5 ++
 net/ax25/af_ax25.c                            |    2 +
 net/bluetooth/hci_event.c                     |    5 --
 net/bluetooth/l2cap_core.c                    |    9 -----
 net/ieee802154/socket.c                       |    3 +
 net/mac80211/ieee80211_i.h                    |    3 +
 net/mac80211/mlme.c                           |   17 +++++++--
 net/mac80211/tdls.c                           |   23 +++++++++++++
 net/nfc/llcp_sock.c                           |    7 ++-
 net/openvswitch/datapath.c                    |    2 -
 net/rds/tcp.c                                 |    8 ++--
 net/sched/sch_netem.c                         |    2 -
 net/wireless/util.c                           |    1 
 sound/firewire/tascam/tascam-pcm.c            |    3 +
 sound/firewire/tascam/tascam-stream.c         |   42 +++++++++++++++--------
 sound/hda/hdac_controller.c                   |    2 +
 sound/i2c/other/ak4xxx-adda.c                 |    7 ++-
 sound/pci/hda/hda_controller.c                |    5 ++
 sound/pci/hda/hda_intel.c                     |    2 -
 sound/pci/hda/patch_analog.c                  |    1 
 sound/pci/hda/patch_realtek.c                 |    3 +
 sound/soc/codecs/sgtl5000.c                   |   15 +++++---
 sound/soc/fsl/fsl_ssi.c                       |    5 ++
 sound/soc/intel/common/sst-ipc.c              |    2 +
 sound/soc/soc-generic-dmaengine-pcm.c         |    6 +++
 sound/usb/pcm.c                               |    1 
 tools/lib/traceevent/Makefile                 |    6 +--
 tools/lib/traceevent/event-plugin.c           |    2 -
 116 files changed, 678 insertions(+), 203 deletions(-)

Al Cooper (1):
      mmc: sdhci: Fix incorrect switch to HS mode

Al Stone (1):
      ACPI / CPPC: do not require the _PSD method

Alan Stern (3):
      HID: prodikeys: Fix general protection fault during probe
      HID: logitech: Fix general protection fault caused by Logitech driver
      HID: hidraw: Fix invalid read in hidraw_ioctl

Amadeusz Sławiński (1):
      ASoC: Intel: Fix use of potentially uninitialized variable

Ard van Breemen (1):
      ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Arkadiusz Miskiewicz (1):
      mac80211: Print text for disassociation reason

Arnd Bergmann (3):
      media: dib0700: fix link error for dibx000_i2c_set_speed
      dmaengine: iop-adma: use correct printk format strings
      net: lpc-enet: fix printk format strings

Benjamin Tissoires (1):
      HID: lg: make transfer buffers DMA capable

Bjørn Mork (2):
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

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Eric Dumazet (1):
      sch_netem: fix a divide by zero in tabledist()

Filipe Manana (2):
      Btrfs: fix use-after-free when using the tree modification log
      Btrfs: fix race setting up and completing qgroup rescan workers

Greg Kroah-Hartman (1):
      Linux 4.4.195

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails

Guoqing Jiang (2):
      md: don't call spare_active in md_reap_sync_thread if all member devices can't work
      md: don't set In_sync if array is frozen

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans Verkuil (3):
      media: gspca: zero usb_buf on error
      media: radio/si470x: kill urb on error
      media: hdpvr: add terminating 0 at end of string

Hans de Goede (1):
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Jan Dakinevich (2):
      KVM: x86: always stop emulation on page fault
      KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jia-Ju Bai (1):
      ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()

Jian-Hong Pan (1):
      Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Juri Lelli (1):
      sched/core: Fix CPU controller for !RT_GROUP_SCHED

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Luke Nowakowski-Krijger (1):
      media: hdpvr: Add device num check and handling

Maciej S. Szmigiero (1):
      media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()

Mao Wenan (1):
      net: rds: Fix NULL ptr use in rds_tcp_kill_sock

Marc Zyngier (1):
      irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Marcel Holtmann (1):
      Revert "Bluetooth: validate BLE connection interval updates"

Mark Salyzyn (1):
      ovl: filter of trusted xattr results in audit

Masami Hiramatsu (1):
      kprobes: Prohibit probing on BUG() and WARN() address

Mauro Carvalho Chehab (1):
      media: ov9650: add a sanity check

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
      ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set

Qu Wenruo (1):
      btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type

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
      ALSA: firewire-tascam: handle error code when getting current source of clock
      ALSA: firewire-tascam: check intermediate state of clock status and retry

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

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Tzvetomir Stoyanov (1):
      libtraceevent: Change users plugin directory

Uwe Kleine-König (1):
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
      hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'

Wenwen Wang (3):
      media: saa7146: add cleanup in hexium_attach()
      media: cpia2_usb: fix memory leaks
      ACPI: custom_method: fix memory leaks

Xiao Ni (1):
      md/raid6: Set R5_ReadError when there is read failure on parity disk

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

Yufen Yu (1):
      md/raid1: fail run raid1 array when active disk less than one

chenzefeng (1):
      ia64:unwind: fix double free for mod->arch.init_unw_table

