Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6334F1BCC28
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgD1TR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 15:17:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50400 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728392AbgD1TRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 15:17:25 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jTVjM-0005fM-Is; Tue, 28 Apr 2020 20:17:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jTVjL-000KXm-PN; Tue, 28 Apr 2020 20:17:20 +0100
Date:   Tue, 28 Apr 2020 20:17:19 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.83
Message-ID: <lsq.1588101375.310409089@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.83 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.16.82 is attached to this message.

Ben.

------------

 Documentation/sysctl/fs.txt                       |  36 ++
 Makefile                                          |   2 +-
 arch/powerpc/kernel/irq.c                         |   4 +-
 arch/x86/boot/compressed/head_64.S                |   5 +
 arch/x86/include/asm/kaiser.h                     |  10 +
 arch/x86/kernel/cpu/microcode/amd.c               |   4 +
 arch/x86/kvm/cpuid.c                              |   3 +-
 arch/x86/kvm/vmx.c                                |   2 +-
 arch/x86/realmode/init.c                          |   4 +-
 arch/x86/realmode/rm/trampoline_64.S              |   3 +-
 block/blk-settings.c                              |   2 +-
 drivers/acpi/device_pm.c                          |  12 +-
 drivers/block/floppy.c                            |   7 +-
 drivers/gpio/gpiolib.c                            |  13 +-
 drivers/hid/hid-core.c                            |   6 +
 drivers/hid/hid-input.c                           |  16 +-
 drivers/hid/hidraw.c                              |   7 +-
 drivers/hid/uhid.c                                |   5 +-
 drivers/hwmon/adt7475.c                           |   5 +-
 drivers/iio/industrialio-buffer.c                 |   6 +-
 drivers/infiniband/hw/mlx4/main.c                 |  16 +-
 drivers/input/input.c                             |  26 +-
 drivers/input/misc/keyspan_remote.c               |   9 +-
 drivers/input/tablet/aiptek.c                     |   6 +-
 drivers/input/tablet/gtco.c                       |  10 +-
 drivers/input/touchscreen/sur40.c                 |   2 +-
 drivers/isdn/gigaset/usb-gigaset.c                |  23 +-
 drivers/md/dm-crypt.c                             |   4 +-
 drivers/md/dm-delay.c                             |  16 +-
 drivers/md/dm-flakey.c                            |  40 +-
 drivers/md/dm-linear.c                            |   7 +-
 drivers/md/dm-raid1.c                             |   8 +-
 drivers/md/dm-snap-persistent.c                   |   2 +-
 drivers/md/dm-stripe.c                            |   8 +-
 drivers/md/dm-thin-metadata.c                     |  29 +
 drivers/md/dm-thin-metadata.h                     |   7 +
 drivers/md/persistent-data/dm-btree-remove.c      |   8 +-
 drivers/md/raid0.c                                |   2 +-
 drivers/media/media-device.c                      |  43 +-
 drivers/media/media-devnode.c                     | 171 +++---
 drivers/media/usb/gspca/ov519.c                   |  10 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c         |  19 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c  |   4 +
 drivers/media/usb/gspca/xirlink_cit.c             |  18 +-
 drivers/media/usb/uvc/uvc_driver.c                |   2 +-
 drivers/misc/enclosure.c                          |   3 +-
 drivers/mmc/host/sdhci.c                          |  10 +-
 drivers/net/bonding/bond_main.c                   |  40 +-
 drivers/net/can/mscan/mscan.c                     |  21 +-
 drivers/net/can/slcan.c                           |  16 +-
 drivers/net/can/usb/gs_usb.c                      |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   5 -
 drivers/net/ethernet/natsemi/sonic.c              | 113 +++-
 drivers/net/ethernet/natsemi/sonic.h              |  25 +-
 drivers/net/ethernet/stmicro/stmmac/common.h      |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 drivers/net/hamradio/6pack.c                      |   4 +-
 drivers/net/hamradio/mkiss.c                      |   4 +-
 drivers/net/macvlan.c                             |   3 +-
 drivers/net/slip/slip.c                           |  12 +-
 drivers/net/usb/r8152.c                           |   3 +
 drivers/net/vxlan.c                               |   5 +-
 drivers/net/wireless/libertas/cfg.c               |  18 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c          |   1 +
 drivers/net/wireless/mwifiex/tdls.c               |  74 ++-
 drivers/pinctrl/pinctrl-baytrail.c                | 212 ++++---
 drivers/platform/x86/asus-wmi.c                   |   8 +-
 drivers/platform/x86/hp-wmi.c                     |   2 +-
 drivers/ptp/ptp_clock.c                           |  42 +-
 drivers/ptp/ptp_private.h                         |   9 +-
 drivers/ptp/ptp_sysfs.c                           | 162 +++---
 drivers/scsi/fnic/vnic_dev.c                      |  20 +-
 drivers/scsi/qla4xxx/ql4_os.c                     |   1 -
 drivers/scsi/sd.c                                 |   4 +-
 drivers/staging/android/ashmem.c                  |  28 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |   3 +-
 drivers/staging/rtl8712/usb_intf.c                |   2 +-
 drivers/staging/usbip/vhci_rx.c                   |  13 +-
 drivers/tty/serial/msm_serial.c                   |  13 +-
 drivers/tty/serial/serial_core.c                  |   1 +
 drivers/tty/vt/selection.c                        |  34 +-
 drivers/tty/vt/vt.c                               |   2 -
 drivers/usb/atm/ueagle-atm.c                      |  18 +-
 drivers/usb/core/config.c                         |  77 ++-
 drivers/usb/core/hub.c                            |   1 +
 drivers/usb/core/quirks.c                         |  37 ++
 drivers/usb/core/urb.c                            |   1 +
 drivers/usb/core/usb.h                            |   3 +
 drivers/usb/dwc3/dwc3-pci.c                       |  30 +
 drivers/usb/host/ehci-q.c                         |  13 +-
 drivers/usb/host/xhci-hub.c                       |   8 +-
 drivers/usb/host/xhci-ring.c                      |   3 +-
 drivers/usb/misc/adutux.c                         |   2 +-
 drivers/usb/misc/idmouse.c                        |   2 +-
 drivers/usb/mon/mon_bin.c                         |  32 +-
 drivers/usb/musb/musbhsdma.c                      |   2 +-
 drivers/usb/serial/ch341.c                        |   6 +-
 drivers/usb/serial/io_edgeport.c                  |  26 +-
 drivers/usb/serial/keyspan.c                      |   4 +
 drivers/usb/serial/opticon.c                      |   2 +-
 drivers/usb/serial/quatech2.c                     |   6 +
 drivers/usb/serial/usb-serial-simple.c            |   2 +
 drivers/usb/serial/usb-serial.c                   |   3 +
 drivers/vhost/net.c                               |  13 +-
 drivers/video/console/vgacon.c                    |   3 +
 drivers/virtio/virtio_balloon.c                   |  10 +
 firmware/Makefile                                 |   2 +-
 fs/btrfs/Makefile                                 |   2 +-
 fs/btrfs/ctree.c                                  |  19 +-
 fs/btrfs/ctree.h                                  | 157 +++---
 fs/btrfs/dev-replace.c                            |   2 +-
 fs/btrfs/disk-io.c                                |  80 +--
 fs/btrfs/extent-tree.c                            | 110 +++-
 fs/btrfs/extent_io.c                              |  98 ++--
 fs/btrfs/extent_io.h                              |  25 +-
 fs/btrfs/extent_map.c                             |   2 +-
 fs/btrfs/extent_map.h                             |  10 +-
 fs/btrfs/inode.c                                  |   8 +-
 fs/btrfs/ioctl.c                                  |  10 +-
 fs/btrfs/relocation.c                             |   1 +
 fs/btrfs/root-tree.c                              |  10 +-
 fs/btrfs/scrub.c                                  |   2 +-
 fs/btrfs/struct-funcs.c                           |   9 +-
 fs/btrfs/tree-checker.c                           | 649 ++++++++++++++++++=
++++
 fs/btrfs/tree-checker.h                           |  38 ++
 fs/btrfs/tree-log.c                               |  24 +-
 fs/btrfs/uuid-tree.c                              |   2 +
 fs/btrfs/volumes.c                                | 206 +++++--
 fs/btrfs/volumes.h                                |   2 +
 fs/char_dev.c                                     |  88 ++-
 fs/ext4/dir.c                                     |   5 +
 fs/ext4/ext4.h                                    |  13 +
 fs/ext4/extents.c                                 |  89 +--
 fs/ext4/file.c                                    |   2 +-
 fs/ext4/inode.c                                   | 117 +++-
 fs/ext4/super.c                                   |   1 +
 fs/ext4/truncate.h                                |   2 +
 fs/inode.c                                        |   1 +
 fs/locks.c                                        |   2 +-
 fs/namei.c                                        |  56 +-
 include/linux/blkdev.h                            |  10 +-
 include/linux/blktrace_api.h                      |   6 +-
 include/linux/cdev.h                              |   5 +
 include/linux/fs.h                                |   3 +
 include/linux/futex.h                             |  17 +-
 include/linux/if_ether.h                          |   8 +
 include/linux/kobject.h                           |   2 +
 include/linux/mod_devicetable.h                   |   4 +-
 include/linux/netfilter_arp/arp_tables.h          |   2 +-
 include/linux/posix-clock.h                       |  19 +-
 include/linux/quotaops.h                          |   2 +-
 include/linux/usb/quirks.h                        |   3 +
 include/media/media-device.h                      |   5 +-
 include/media/media-devnode.h                     |  32 +-
 include/net/addrconf.h                            |   5 +-
 include/net/cfg80211.h                            |  11 +
 include/net/neighbour.h                           |   1 -
 kernel/futex.c                                    |  93 ++--
 kernel/sysctl.c                                   |  18 +
 kernel/taskstats.c                                |  30 +-
 kernel/time/posix-clock.c                         |  31 +-
 kernel/trace/blktrace.c                           | 129 +++--
 kernel/trace/ftrace.c                             |   6 +-
 kernel/trace/trace_sched_wakeup.c                 |   4 +-
 kernel/trace/trace_stack.c                        |   5 +
 lib/kobject.c                                     |   5 +-
 mm/mempolicy.c                                    |   6 +-
 net/8021q/vlan_netlink.c                          |  10 +-
 net/batman-adv/distributed-arp-table.c            |   4 +-
 net/bridge/br_netfilter.c                         |   3 +
 net/bridge/netfilter/ebtables.c                   |  58 +-
 net/core/neighbour.c                              |   3 -
 net/ipv4/netfilter/arp_tables.c                   |  42 +-
 net/ipv4/netfilter/arptable_filter.c              |   2 +-
 net/ipv4/tcp_input.c                              |   5 +-
 net/ipv4/tcp_output.c                             |   8 +
 net/ipv6/af_inet6.c                               |   2 +-
 net/mac80211/cfg.c                                |  55 +-
 net/mac80211/sta_info.c                           |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h           |   2 +-
 net/netfilter/ipset/ip_set_core.c                 |   3 +-
 net/netfilter/nf_conntrack_netlink.c              |   3 +
 net/netfilter/nft_bitwise.c                       |  19 +-
 net/netfilter/nft_cmp.c                           |  18 +-
 net/packet/af_packet.c                            |   3 +-
 net/sched/ematch.c                                |   2 +-
 net/sched/sch_fq.c                                |  10 +-
 net/sctp/sm_sideeffect.c                          |  28 +-
 net/wireless/util.c                               |  45 ++
 scripts/recordmcount.c                            |  17 +
 sound/core/pcm_native.c                           |   4 +
 sound/core/seq/seq_timer.c                        |  14 +-
 sound/pci/hda/patch_ca0132.c                      |   5 +-
 sound/pci/ice1712/ice1724.c                       |   9 +-
 sound/soc/codecs/wm8962.c                         |   4 +-
 sound/usb/pcm.c                                   |  44 +-
 197 files changed, 3377 insertions(+), 1229 deletions(-)

Al Viro (2):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late
      vfs: fix do_last() regression

Alan Cox (1):
      usb: dwc3: pci: Add PCI ID for Intel Braswell

Alan Stern (1):
      HID: Fix slab-out-of-bounds read in hid_field_extract

Alberto Aguirre (2):
      ALSA: usb-audio: add implicit fb quirk for Axe-Fx II
      ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (2):
      btrfs: tree-checker: use %zu format string for size_t
      scsi: fnic: fix invalid stack access

Avinash Patil (1):
      mwifiex: fix probable memory corruption while processing TDLS frame

Ben Hutchings (1):
      Linux 3.16.83

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Cengiz Can (1):
      blktrace: fix dereference after null check

Chao Yu (1):
      quota: fix wrong condition in is_quota_modification()

Chen-Yu Tsai (1):
      net: stmmac: dwmac-sunxi: Allow all RGMII modes

Christian Brauner (1):
      taskstats: fix data-race

Christophe Leroy (1):
      powerpc/irq: fix stack overflow verification

Cong Wang (2):
      netfilter: fix a use-after-free in mtype_destroy()
      net_sched: fix datalen for ematch

Dan Carpenter (1):
      scsi: iscsi: qla4xxx: fix double free in probe

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between =
zones

David Sterba (6):
      btrfs: new define for the inline extent data start
      btrfs: kill extent_buffer_page helper
      btrfs: cleanup, rename a few variables in btrfs_read_sys_array
      btrfs: add more checks to btrfs_read_sys_array
      btrfs: handle invalid num_stripes in sys_array
      btrfs: tree-check: reduce stack consumption in check_dir_item

Davidlohr Bueso (1):
      blktrace: re-write setting q->blk_trace

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Dmitry Torokhov (5):
      HID: hid-input: clear unmapped usages
      Input: add safety guards to input_set_keycode()
      ptp: do not explicitly set drvdata in ptp_clock_register()
      ptp: use is_visible method to hide unused attributes
      ptp: create "pins" together with the rest of attributes

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Eric Dumazet (9):
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
      neighbour: remove neigh_cleanup() method
      bonding: fix bond_neigh_init()
      6pack,mkiss: fix possible deadlock
      tcp: do not send empty skb from tcp_write_xmit()
      vlan: vlan_changelink() should propagate errors
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      macvlan: do not assume mac_header is set in macvlan_broadcast()
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()

Erkka Talvitie (1):
      USB: EHCI: Do not return -EPIPE when hub is disconnected

Eryu Guan (1):
      ext4: update c/mtime on truncate up

Eugenio P=C3=A9rez (1):
      vhost: Check docket sk_family instead of call getname

Fabian Henneke (1):
      hidraw: Return EPOLLOUT from hidraw_poll

Felipe Balbi (3):
      usb: dwc3: pci: add support for Comet Lake PCH ID
      usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices
      usb: dwc3: pci: add support for TigerLake Devices

Filipe Manana (3):
      Btrfs: fix emptiness check for dirtied extent buffers at check_leaf()
      Btrfs: fix removal logic of the tree mod log that leads to use-after-=
free issues
      Btrfs: fix infinite loop during nocow writeback due to race

Finn Thain (4):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Use MMIO accessors
      net/sonic: Fix receive buffer handling
      net/sonic: Quiesce SONIC before re-initializing descriptor memory

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from p=
olling to irq mode

Florian Westphal (6):
      netfilter: ctnetlink: netns exit must wait for callbacks
      netfilter: ebtables: convert BUG_ONs to WARN_ONs
      netfilter: ebtables: compat: reject all padding in matches/watchers
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Geert Uytterhoeven (1):
      gpio: Fix error message on out-of-range GPIO in lookup table

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()

Gu Jinxiang (1):
      btrfs: validate type when reading a chunk

Hangbin Liu (1):
      vxlan: fix tos value before xmit

Hans de Goede (2):
      pinctrl: baytrail: Really serialize all register accesses
      platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes

Heikki Krogerus (8):
      usb: dwc3: pci: add support for Intel Sunrise Point PCH
      usb: dwc3: pci: add support for Intel Broxton SOC
      usb: dwc3: pci: add ID for one more Intel Broxton platform
      usb: dwc3: pci: add Intel Kabylake PCI ID
      usb: dwc3: pci: add Intel Gemini Lake PCI ID
      usb: dwc3: pci: add Intel Cannonlake PCI IDs
      usb: dwc3: pci: add support for Intel IceLake
      usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug

Jan Kara (7):
      ext4: fix races between page faults and hole punching
      ext4: move unlocked dio protection from ext4_alloc_file_blocks()
      ext4: fix races between buffered IO and collapse / insert range
      ext4: fix races of writeback with punch hole and zero range
      ext4: check for directory entries too close to block end
      kobject: Export kobject_get_unless_zero()
      blktrace: Protect q->blk_trace with RCU

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jeff Mahoney (2):
      btrfs: cleanup, stop casting for extent_map->lookup everywhere
      btrfs: struct-funcs, constify readers

Jer=C3=B3nimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT

Jiri Slaby (4):
      vt: selection, handle pending signals in paste_selection
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

Johan Hovold (29):
      staging: gigaset: fix general protection fault on probe
      staging: gigaset: fix illegal free on probe errors
      staging: gigaset: add endpoint-type sanity check
      USB: serial: io_edgeport: fix epic endpoint lookup
      USB: idmouse: fix interface sanity checks
      USB: adutux: fix interface sanity check
      USB: atm: ueagle-atm: add missing endpoint check
      staging: rtl8188eu: fix interface sanity check
      staging: rtl8712: fix interface sanity check
      USB: core: fix check for duplicate endpoints
      USB: core: add endpoint-blacklist quirk
      USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting
      Input: aiptek - fix endpoint sanity check
      Input: gtco - fix endpoint sanity check
      Input: sur40 - fix interface sanity checks
      ALSA: usb-audio: fix sync-ep altsetting sanity check
      USB: serial: opticon: fix control-message timeouts
      r8152: add missing endpoint sanity check
      Input: keyspan-remote - fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: handle unbound ports on URB completion
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: keyspan: handle unbound ports
      USB: serial: quatech2: handle unbound ports
      media: ov519: add missing endpoint sanity checks
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Johannes Thumshirn (1):
      btrfs: ensure that a DUP or RAID1 block group has exactly two stripes

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size

Josef Bacik (9):
      ext4: only call ext4_truncate when size <=3D isize
      Btrfs: fix em leak in find_first_block_group
      btrfs: do not call synchronize_srcu() in inode_tree_del
      btrfs: abort transaction after failed inode updates in create_subvol
      btrfs: handle ENOENT in btrfs_uuid_tree_iterate
      btrfs: skip log replay on orphaned roots
      btrfs: do not leak reloc root if we fail to read the fs root
      btrfs: do not delete mismatched root refs
      btrfs: check rw_devices, not num_devices for balance

Jouni Malinen (1):
      mac80211: Do not send Layer 2 Update frame before authorization

Kaitao Cheng (1):
      kernel/trace: Fix do not unregister tracepoints when register sched_m=
igrate_task fail

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Kenneth Klette Jonassen (1):
      pkt_sched: fq: avoid hang when quantum 0

Lars M=C3=B6llendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest elem=
ent

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Liu Bo (9):
      Btrfs: add validadtion checks for chunk loading
      Btrfs: check inconsistence between chunk and block group
      Btrfs: detect corruption when non-root leaf has zero item
      Btrfs: check btree node's nritems
      Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
      Btrfs: memset to avoid stale content in btree node block
      Btrfs: improve check_node to avoid reading corrupted nodes
      Btrfs: kill BUG_ON in run_delayed_tree_ref
      Btrfs: memset to avoid stale content in btree leaf

Logan Gunthorpe (1):
      chardev: add helper function to register char devs with a struct devi=
ce

Lu Fengqi (1):
      btrfs: Remove redundant btrfs_release_path from btrfs_unlink_subvol

Lukas Czerner (1):
      ext4: wait for existing dio workers in ext4_alloc_file_blocks()

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Mao Wenan (2):
      af_packet: set defaule value for tmo
      net: sonic: return NETDEV_TX_OK if failed to map buffer

Marcel Holtmann (2):
      HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Mathias Nyman (2):
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behavi=
our.
      xhci: make sure interrupts are restored to correct state

Mauro Carvalho Chehab (3):
      media-devnode: just return 0 instead of using a var
      media-devnode: fix namespace mess
      media-device: dynamically allocate struct media_devnode

Max Kellermann (2):
      drivers/media/media-devnode: clear private_data before put_device()
      media-devnode: add missing mutex lock in error handler

Michael Straube (1):
      staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci: fix minimum clock rate for v3 controller

Mika Westerberg (4):
      pinctrl: baytrail: Relax GPIO request rules
      pinctrl: baytrail: Clear interrupt triggering from pins that are in G=
PIO mode
      pinctrl: baytrail: Rework interrupt handling
      pinctrl: baytrail: Serialize all register access

Mike Snitzer (1):
      dm flakey: fix reads to be issued if drop_writes configured

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Moni Shoua (1):
      IB/mlx4: Avoid executing gid task when device is being removed

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
      libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow

Nikos Tsironis (1):
      dm thin metadata: Add support for a pre-commit callback

Pablo Neira Ayuso (2):
      netfilter: nf_tables: missing sanitization in data from userspace
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()

Paolo Bonzini (1):
      KVM: nVMX: Don't emulate instructions in guest mode

Parav Pandit (1):
      IB/mlx4: Follow mirror sequence of device add during device removal

Paul Cercueil (1):
      usb: musb: dma: Correct parameter passed to IRQ handler

Pavel Tatashin (1):
      x86/pti/efi: broken conversion from efi to kernel page table

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Peter Hurley (1):
      tty: vt: Fix !TASK_RUNNING diagnostic warning from paste_selection()

Peter Zijlstra (1):
      futex: Fix inode life-time issue

Qu Wenruo (14):
      btrfs: Enhance chunk validation check
      btrfs: Refactor check_leaf function for later expansion
      btrfs: Check if item pointer overlaps with the item itself
      btrfs: Add sanity check for EXTENT_DATA when reading out leaf
      btrfs: Add checker for EXTENT_CSUM
      btrfs: Move leaf and node validation checker to tree-checker.c
      btrfs: tree-checker: Enhance btrfs_check_node output
      btrfs: tree-checker: Fix false panic for sanity test
      btrfs: tree-checker: Add checker for dir item
      btrfs: tree-checker: Verify block_group_item
      btrfs: tree-checker: Detect invalid and empty essential trees
      btrfs: Check that each block group has corresponding chunk at mount t=
ime
      btrfs: Verify that every chunk has corresponding block group at mount=
 time
      btrfs: tree-checker: Check level for leaves and nodes

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Richard Palethorpe (2):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU
      slcan: Don't transmit uninitialized stack data in padding

Russell King (2):
      gpiolib: fix up emulated open drain outputs
      mod_devicetable: fix PHY module format

Sabrina Dubroca (1):
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Salvatore Mesoraca (1):
      namei: allow restricted O_CREAT of FIFOs and regular files

Shaokun Zhang (1):
      btrfs: tree-checker: Fix misleading group system information

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Shuah Khan (3):
      media: Fix media_open() to clear filp->private_data in error leg
      media: fix use-after-free in cdev_put() when app exits after driver u=
nbind
      media: fix media devnode ioctl/syscall and unregister race

Steven Rostedt (VMware) (1):
      tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defin=
ed

Sudip Mukherjee (2):
      tty: link tty and port before configuring it as console
      tty: always relink the port

Suren Baghdasaryan (1):
      staging: android: ashmem: Disallow ashmem memory from being remapped

Suwan Kim (1):
      usbip: Fix error path of vhci_recv_ret_submit()

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Takashi Iwai (4):
      ALSA: pcm: Avoid possible info leaks from PCM stream buffers
      ALSA: hda/ca0132 - Avoid endless loop
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
      ALSA: seq: Fix racy access for queue timer in proc read

Thomas Gleixner (1):
      futex: Unbreak futex hashing

Tom Lendacky (1):
      x86/microcode/AMD: Add support for fam17h microcode loading

Vivek Goyal (1):
      dm: do not override error code returned from dm_get_device()

Vladis Dronov (2):
      ptp: fix the race between the release of ptp_clock and cdev
      ptp: free ptp device pin descriptors properly

Wang Shilong (1):
      Btrfs: fix wrong max inline data size limit

Wei Yongjun (1):
      dm flakey: return -EINVAL on interval bounds error in flakey_ctr()

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      ftrace: Avoid potential division by zero in function profiler

Will Deacon (1):
      chardev: Avoid potential use-after-free in 'chrdev_open()'

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without =
PI

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

YueHaibing (1):
      ptp: Fix pass zero to ERR_PTR() in ptp_clock_register

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()


--M9NhX3UHpAaciwkO
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.83.patch"
Content-Disposition: attachment; filename="linux-3.16.83.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 35e17f748ca7..af5859b2d0f9 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -34,7 +34,9 @@ before actually making adjustments.
 - overflowgid
 - pipe-user-pages-hard
 - pipe-user-pages-soft
+- protected_fifos
 - protected_hardlinks
+- protected_regular
 - protected_symlinks
 - suid_dumpable
 - super-max
@@ -182,6 +184,24 @@ applied.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+protected_fifos:
+
+The intent of this protection is to avoid unintentional writes to
+an attacker-controlled FIFO, where a program expected to create a regular
+file.
+
+When set to "0", writing to FIFOs is unrestricted.
+
+When set to "1" don't allow O_CREAT open on FIFOs that we don't own
+in world writable sticky directories, unless they are owned by the
+owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+This protection is based on the restrictions in Openwall.
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
 protected_hardlinks:
=20
 A long-standing class of security issues is the hardlink-based
@@ -202,6 +222,22 @@ This protection is based on the restrictions in Openwa=
ll and grsecurity.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+protected_regular:
+
+This protection is similar to protected_fifos, but it
+avoids writes to an attacker-controlled regular file, where a program
+expected to create one.
+
+When set to "0", writing to regular files is unrestricted.
+
+When set to "1" don't allow O_CREAT open on regular files that we
+don't own in world writable sticky directories, unless they are
+owned by the owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
 protected_symlinks:
=20
 A long-standing class of security issues is the symlink-based
diff --git a/Makefile b/Makefile
index 64e7647e6a9d..99500d145fab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 82
+SUBLEVEL =3D 83
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 856a6cac5c3e..c755e672d96e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -471,8 +471,6 @@ void __do_irq(struct pt_regs *regs)
=20
 	trace_irq_entry(regs);
=20
-	check_stack_overflow();
-
 	/*
 	 * Query the platform PIC for the interrupt & ack it.
 	 *
@@ -504,6 +502,8 @@ void do_IRQ(struct pt_regs *regs)
 	irqtp =3D hardirq_ctx[raw_smp_processor_id()];
 	sirqtp =3D softirq_ctx[raw_smp_processor_id()];
=20
+	check_stack_overflow();
+
 	/* Already there ? */
 	if (unlikely(curtp =3D=3D irqtp || curtp =3D=3D sirqtp)) {
 		__do_irq(regs);
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/=
head_64.S
index 6b1766c6c082..2fcd71219b92 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -216,6 +216,11 @@ ENTRY(efi32_stub_entry)
 	leal	efi32_config(%ebp), %eax
 	movl	%eax, efi_config(%ebp)
=20
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
 	jmp	startup_32
 ENDPROC(efi32_stub_entry)
 #endif
diff --git a/arch/x86/include/asm/kaiser.h b/arch/x86/include/asm/kaiser.h
index 802bbbdfe143..48c791a411ab 100644
--- a/arch/x86/include/asm/kaiser.h
+++ b/arch/x86/include/asm/kaiser.h
@@ -19,6 +19,16 @@
=20
 #define KAISER_SHADOW_PGD_OFFSET 0x1000
=20
+#ifdef CONFIG_PAGE_TABLE_ISOLATION
+/*
+ *  A page table address must have this alignment to stay the same when
+ *  KAISER_SHADOW_PGD_OFFSET mask is applied
+ */
+#define KAISER_KERNEL_PGD_ALIGNMENT (KAISER_SHADOW_PGD_OFFSET << 1)
+#else
+#define KAISER_KERNEL_PGD_ALIGNMENT PAGE_SIZE
+#endif
+
 #ifdef __ASSEMBLY__
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
=20
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/micr=
ocode/amd.c
index ff16949e7f3d..6068c25e7c48 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -154,6 +154,7 @@ static unsigned int verify_patch_size(u8 family, u32 pa=
tch_size,
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
 #define F16H_MPB_MAX_SIZE 3458
+#define F17H_MPB_MAX_SIZE 3200
=20
 	switch (family) {
 	case 0x14:
@@ -165,6 +166,9 @@ static unsigned int verify_patch_size(u8 family, u32 pa=
tch_size,
 	case 0x16:
 		max_size =3D F16H_MPB_MAX_SIZE;
 		break;
+	case 0x17:
+		max_size =3D F17H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size =3D F1XH_MPB_MAX_SIZE;
 		break;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 66062325d4b7..22958dcfccd9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -400,7 +400,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry=
2 *entry, u32 function,
 				entry->edx |=3D F(SPEC_CTRL);
 			if (boot_cpu_has(X86_FEATURE_STIBP))
 				entry->edx |=3D F(INTEL_STIBP);
-			if (boot_cpu_has(X86_FEATURE_SSBD))
+			if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+			    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 				entry->edx |=3D F(SPEC_CTRL_SSBD);
 			/*
 			 * We emulate ARCH_CAPABILITIES in software even
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a1dbb20b768b..1faaa78505f4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8938,7 +8938,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage)
 {
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
=20
 static struct kvm_x86_ops vmx_x86_ops =3D {
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index bad628a620c4..66f20e7756cc 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -4,6 +4,7 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/realmode.h>
+#include <asm/kaiser.h>
=20
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -15,7 +16,8 @@ void __init reserve_real_mode(void)
 	size_t size =3D PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
=20
 	/* Has to be under 1M so we can execute real-mode AP code. */
-	mem =3D memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	mem =3D memblock_find_in_range(0, 1 << 20, size,
+				     KAISER_KERNEL_PGD_ALIGNMENT);
 	if (!mem)
 		panic("Cannot allocate trampoline\n");
=20
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/tr=
ampoline_64.S
index dac7b20d2f9d..781cca63f795 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -30,6 +30,7 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
+#include <asm/kaiser.h>
 #include "realmode.h"
=20
 	.text
@@ -139,7 +140,7 @@ ENTRY(startup_64)
 tr_gdt_end:
=20
 	.bss
-	.balign	PAGE_SIZE
+	.balign	KAISER_KERNEL_PGD_ALIGNMENT
 GLOBAL(trampoline_pgd)		.space	PAGE_SIZE
=20
 	.balign	8
diff --git a/block/blk-settings.c b/block/blk-settings.c
index aa02247d227e..f1bd4ca22c6b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -373,7 +373,7 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);
  *   storage device can address.  The default of 512 covers most
  *   hardware.
  **/
-void blk_queue_logical_block_size(struct request_queue *q, unsigned short =
size)
+void blk_queue_logical_block_size(struct request_queue *q, unsigned int si=
ze)
 {
 	q->limits.logical_block_size =3D size;
=20
diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index e9f44a210712..4a41ec7414db 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1041,9 +1041,19 @@ static struct dev_pm_domain acpi_general_pm_domain =
=3D {
  */
 int acpi_dev_pm_attach(struct device *dev, bool power_on)
 {
+	/*
+	 * Skip devices whose ACPI companions match the device IDs below,
+	 * because they require special power management handling incompatible
+	 * with the generic ACPI PM domain.
+	 */
+	static const struct acpi_device_id special_pm_ids[] =3D {
+		{"PNP0C0B", }, /* Generic ACPI fan */
+		{"INT3404", }, /* Fan */
+		{}
+	};
 	struct acpi_device *adev =3D ACPI_COMPANION(dev);
=20
-	if (!adev)
+	if (!adev || !acpi_match_device_ids(adev, special_pm_ids))
 		return -ENODEV;
=20
 	if (dev->pm_domain)
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3999b8c6a09d..85c8bcb8157b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -847,14 +847,17 @@ static void reset_fdc_info(int mode)
 /* selects the fdc and drive, and enables the fdc's input/dma. */
 static void set_fdc(int drive)
 {
+	unsigned int new_fdc =3D fdc;
+
 	if (drive >=3D 0 && drive < N_DRIVE) {
-		fdc =3D FDC(drive);
+		new_fdc =3D FDC(drive);
 		current_drive =3D drive;
 	}
-	if (fdc !=3D 1 && fdc !=3D 0) {
+	if (new_fdc >=3D N_FDC) {
 		pr_info("bad fdc value\n");
 		return;
 	}
+	fdc =3D new_fdc;
 	set_dor(fdc, ~0, 8);
 #if N_FDC > 1
 	set_dor(1 - fdc, ~8, 0);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c6eaa7a4539c..770eabbc554b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -273,6 +273,14 @@ int gpiod_get_direction(const struct gpio_desc *desc)
 	chip =3D gpiod_to_chip(desc);
 	offset =3D gpio_chip_hwgpio(desc);
=20
+	/*
+	 * Open drain emulation using input mode may incorrectly report
+	 * input here, fix that up.
+	 */
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags) &&
+	    test_bit(FLAG_IS_OUT, &desc->flags))
+		return 0;
+
 	if (!chip->get_direction)
 		return status;
=20
@@ -2743,8 +2751,9 @@ static struct gpio_desc *gpiod_find(struct device *de=
v, const char *con_id,
=20
 		if (chip->ngpio <=3D p->chip_hwnum) {
 			dev_err(dev,
-				"requested GPIO %d is out of range [0..%d] for chip %s\n",
-				idx, chip->ngpio, chip->label);
+				"requested GPIO %u (%u) is out of range [0..%u] for chip %s\n",
+				idx, p->chip_hwnum, chip->ngpio - 1,
+				chip->label);
 			return ERR_PTR(-EINVAL);
 		}
=20
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 38b1cad80322..c8f21de0fc19 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -248,6 +248,12 @@ static int hid_add_field(struct hid_parser *parser, un=
signed report_type, unsign
 	offset =3D report->size;
 	report->size +=3D parser->global.report_size * parser->global.report_coun=
t;
=20
+	/* Total size check: Allow for possible report index byte */
+	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+		hid_err(parser->device, "report is too long\n");
+		return -1;
+	}
+
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
=20
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 39b4193a37f4..b65eb2a723ac 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -947,9 +947,15 @@ static void hidinput_configure_usage(struct hid_input =
*hidinput, struct hid_fiel
 	}
=20
 mapped:
-	if (device->driver->input_mapped && device->driver->input_mapped(device,
-				hidinput, field, usage, &bit, &max) < 0)
-		goto ignore;
+	if (device->driver->input_mapped &&
+	    device->driver->input_mapped(device, hidinput, field, usage,
+					 &bit, &max) < 0) {
+		/*
+		 * The driver indicated that no further generic handling
+		 * of the usage is desired.
+		 */
+		return;
+	}
=20
 	set_bit(usage->type, input->evbit);
=20
@@ -1008,9 +1014,11 @@ static void hidinput_configure_usage(struct hid_inpu=
t *hidinput, struct hid_fiel
 		set_bit(MSC_SCAN, input->mscbit);
 	}
=20
-ignore:
 	return;
=20
+ignore:
+	usage->type =3D 0;
+	usage->code =3D 0;
 }
=20
 void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, s=
truct hid_usage *usage, __s32 value)
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 627a24d3ea7c..ef9e196b54a5 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -262,13 +262,14 @@ static ssize_t hidraw_get_report(struct file *file, c=
har __user *buffer, size_t
 static unsigned int hidraw_poll(struct file *file, poll_table *wait)
 {
 	struct hidraw_list *list =3D file->private_data;
+	unsigned int mask =3D POLLOUT | POLLWRNORM; /* hidraw is always writable =
*/
=20
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head !=3D list->tail)
-		return POLLIN | POLLRDNORM;
+		mask |=3D POLLIN | POLLRDNORM;
 	if (!list->hidraw->exist)
-		return POLLERR | POLLHUP;
-	return 0;
+		mask |=3D POLLERR | POLLHUP;
+	return mask;
 }
=20
 static int hidraw_open(struct inode *inode, struct file *file)
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 035c7c2863dc..f4063d788469 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -720,13 +720,14 @@ static ssize_t uhid_char_write(struct file *file, con=
st char __user *buffer,
 static unsigned int uhid_char_poll(struct file *file, poll_table *wait)
 {
 	struct uhid_device *uhid =3D file->private_data;
+	unsigned int mask =3D POLLOUT | POLLWRNORM; /* uhid is always writable */
=20
 	poll_wait(file, &uhid->waitq, wait);
=20
 	if (uhid->head !=3D uhid->tail)
-		return POLLIN | POLLRDNORM;
+		mask |=3D POLLIN | POLLRDNORM;
=20
-	return 0;
+	return mask;
 }
=20
 static const struct file_operations uhid_fops =3D {
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 3cefd1aeb24f..1b9f6adcbd85 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -268,9 +268,10 @@ static inline u16 volt2reg(int channel, long volt, u8 =
bypass_attn)
 	long reg;
=20
 	if (bypass_attn & (1 << channel))
-		reg =3D (volt * 1024) / 2250;
+		reg =3D DIV_ROUND_CLOSEST(volt * 1024, 2250);
 	else
-		reg =3D (volt * r[1] * 1024) / ((r[0] + r[1]) * 2250);
+		reg =3D DIV_ROUND_CLOSEST(volt * r[1] * 1024,
+					(r[0] + r[1]) * 2250);
 	return clamp_val(reg, 0, 1023) & (0xff << 2);
 }
=20
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-b=
uffer.c
index 77b19ca8b763..6479e3ec2110 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -478,7 +478,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio=
_dev,
 {
 	const struct iio_chan_spec *ch;
 	unsigned bytes =3D 0;
-	int length, i;
+	int length, i, largest =3D 0;
=20
 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -491,6 +491,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio=
_dev,
 			length =3D ch->scan_type.storagebits / 8;
 		bytes =3D ALIGN(bytes, length);
 		bytes +=3D length;
+		largest =3D max(largest, length);
 	}
 	if (timestamp) {
 		ch =3D iio_find_channel_from_si(indio_dev,
@@ -502,7 +503,10 @@ static int iio_compute_scan_bytes(struct iio_dev *indi=
o_dev,
 			length =3D ch->scan_type.storagebits / 8;
 		bytes =3D ALIGN(bytes, length);
 		bytes +=3D length;
+		largest =3D max(largest, length);
 	}
+
+	bytes =3D ALIGN(bytes, largest);
 	return bytes;
 }
=20
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4=
/main.c
index 79a8accc0801..401f556d954c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1395,6 +1395,9 @@ static void update_gids_task(struct work_struct *work)
 	int err;
 	struct mlx4_dev	*dev =3D gw->dev->dev;
=20
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox =3D mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
@@ -1425,6 +1428,9 @@ static void reset_gids_task(struct work_struct *work)
 	int err;
 	struct mlx4_dev	*dev =3D gw->dev->dev;
=20
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox =3D mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("reset gid table failed\n");
@@ -2363,15 +2369,19 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, vo=
id *ibdev_ptr)
 	struct mlx4_ib_dev *ibdev =3D ibdev_ptr;
 	int p;
=20
-	mlx4_ib_close_sriov(ibdev);
-	mlx4_ib_mad_cleanup(ibdev);
-	ib_unregister_device(&ibdev->ib_dev);
+	ibdev->ib_active =3D false;
+	flush_workqueue(wq);
+
 	if (ibdev->iboe.nb.notifier_call) {
 		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
 			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call =3D NULL;
 	}
=20
+	mlx4_ib_close_sriov(ibdev);
+	mlx4_ib_mad_cleanup(ibdev);
+	ib_unregister_device(&ibdev->ib_dev);
+
 	mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
 			      ibdev->steer_qpn_count);
 	kfree(ibdev->ib_uc_qpns_bitmap);
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 29ca0bb4f561..0a9e49e425a1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -841,16 +841,18 @@ static int input_default_setkeycode(struct input_dev =
*dev,
 		}
 	}
=20
-	__clear_bit(*old_keycode, dev->keybit);
-	__set_bit(ke->keycode, dev->keybit);
-
-	for (i =3D 0; i < dev->keycodemax; i++) {
-		if (input_fetch_keycode(dev, i) =3D=3D *old_keycode) {
-			__set_bit(*old_keycode, dev->keybit);
-			break; /* Setting the bit twice is useless, so break */
+	if (*old_keycode <=3D KEY_MAX) {
+		__clear_bit(*old_keycode, dev->keybit);
+		for (i =3D 0; i < dev->keycodemax; i++) {
+			if (input_fetch_keycode(dev, i) =3D=3D *old_keycode) {
+				__set_bit(*old_keycode, dev->keybit);
+				/* Setting the bit twice is useless, so break */
+				break;
+			}
 		}
 	}
=20
+	__set_bit(ke->keycode, dev->keybit);
 	return 0;
 }
=20
@@ -906,9 +908,13 @@ int input_set_keycode(struct input_dev *dev,
 	 * Simulate keyup event if keycode is not present
 	 * in the keymap anymore
 	 */
-	if (test_bit(EV_KEY, dev->evbit) &&
-	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
-	    __test_and_clear_bit(old_keycode, dev->key)) {
+	if (old_keycode > KEY_MAX) {
+		dev_warn(dev->dev.parent ?: &dev->dev,
+			 "%s: got too big old keycode %#x\n",
+			 __func__, old_keycode);
+	} else if (test_bit(EV_KEY, dev->evbit) &&
+		   !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
+		   __test_and_clear_bit(old_keycode, dev->key)) {
 		struct input_value vals[] =3D  {
 			{ EV_KEY, old_keycode, 0 },
 			input_value_sync
diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keysp=
an_remote.c
index 01f3b5b300f3..7ed630da6b19 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -344,7 +344,8 @@ static int keyspan_setup(struct usb_device* dev)
 	int retval =3D 0;
=20
 	retval =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x11, 0x40, 0x5601, 0x0, NULL, 0, 0);
+				 0x11, 0x40, 0x5601, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set bit rate due to error: %d\n",
 			__func__, retval);
@@ -352,7 +353,8 @@ static int keyspan_setup(struct usb_device* dev)
 	}
=20
 	retval =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x44, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x44, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set resume sensitivity due to error: =
%d\n",
 			__func__, retval);
@@ -360,7 +362,8 @@ static int keyspan_setup(struct usb_device* dev)
 	}
=20
 	retval =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-				 0x22, 0x40, 0x0, 0x0, NULL, 0, 0);
+				 0x22, 0x40, 0x0, 0x0, NULL, 0,
+				 USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to turn receive on due to error: %d\n",
 			__func__, retval);
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 78ca44840d60..40a166773c1b 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1820,14 +1820,14 @@ aiptek_probe(struct usb_interface *intf, const stru=
ct usb_device_id *id)
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_=
MAX - 1, 0, 0);
=20
 	/* Verify that a device really has an endpoint */
-	if (intf->altsetting[0].desc.bNumEndpoints < 1) {
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&intf->dev,
 			"interface has %d endpoints, but must have minimum 1\n",
-			intf->altsetting[0].desc.bNumEndpoints);
+			intf->cur_altsetting->desc.bNumEndpoints);
 		err =3D -EINVAL;
 		goto fail3;
 	}
-	endpoint =3D &intf->altsetting[0].endpoint[0].desc;
+	endpoint =3D &intf->cur_altsetting->endpoint[0].desc;
=20
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index cf3af3a3297a..a0f69a015e0e 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -886,18 +886,14 @@ static int gtco_probe(struct usb_interface *usbinterf=
ace,
 	}
=20
 	/* Sanity check that a device has an endpoint */
-	if (usbinterface->altsetting[0].desc.bNumEndpoints < 1) {
+	if (usbinterface->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&usbinterface->dev,
 			"Invalid number of endpoints\n");
 		error =3D -EINVAL;
 		goto err_free_urb;
 	}
=20
-	/*
-	 * The endpoint is always altsetting 0, we know this since we know
-	 * this device only has one interrupt endpoint
-	 */
-	endpoint =3D &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint =3D &usbinterface->cur_altsetting->endpoint[0].desc;
=20
 	/* Some debug */
 	dev_dbg(&usbinterface->dev, "gtco # interfaces: %d\n", usbinterface->num_=
altsetting);
@@ -984,7 +980,7 @@ static int gtco_probe(struct usb_interface *usbinterfac=
e,
 	input_dev->dev.parent =3D &usbinterface->dev;
=20
 	/* Setup the URB, it will be posted later on open of input device */
-	endpoint =3D &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint =3D &usbinterface->cur_altsetting->endpoint[0].desc;
=20
 	usb_fill_int_urb(gtco->urbinfo,
 			 gtco->usbdev,
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/=
sur40.c
index af96ffcbcffd..c218ac6c2745 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -357,7 +357,7 @@ static int sur40_probe(struct usb_interface *interface,
 	int error;
=20
 	/* Check if we really have the right interface. */
-	iface_desc =3D &interface->altsetting[0];
+	iface_desc =3D interface->cur_altsetting;
 	if (iface_desc->desc.bInterfaceClass !=3D 0xFF)
 		return -ENODEV;
=20
diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-=
gigaset.c
index d0a41cb0cf62..3a6c6bc4a7ae 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -578,8 +578,7 @@ static int gigaset_initcshw(struct cardstate *cs)
 {
 	struct usb_cardstate *ucs;
=20
-	cs->hw.usb =3D ucs =3D
-		kmalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
+	cs->hw.usb =3D ucs =3D kzalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
 	if (!ucs) {
 		pr_err("out of memory\n");
 		return -ENOMEM;
@@ -591,9 +590,6 @@ static int gigaset_initcshw(struct cardstate *cs)
 	ucs->bchars[3] =3D 0;
 	ucs->bchars[4] =3D 0x11;
 	ucs->bchars[5] =3D 0x13;
-	ucs->bulk_out_buffer =3D NULL;
-	ucs->bulk_out_urb =3D NULL;
-	ucs->read_urb =3D NULL;
 	tasklet_init(&cs->write_tasklet,
 		     gigaset_modem_fill, (unsigned long) cs);
=20
@@ -693,6 +689,11 @@ static int gigaset_probe(struct usb_interface *interfa=
ce,
 		return -ENODEV;
 	}
=20
+	if (hostif->desc.bNumEndpoints < 2) {
+		dev_err(&interface->dev, "missing endpoints\n");
+		return -ENODEV;
+	}
+
 	dev_info(&udev->dev, "%s: Device matched ... !\n", __func__);
=20
 	/* allocate memory for our device state and initialize it */
@@ -712,6 +713,12 @@ static int gigaset_probe(struct usb_interface *interfa=
ce,
=20
 	endpoint =3D &hostif->endpoint[0].desc;
=20
+	if (!usb_endpoint_is_bulk_out(endpoint)) {
+		dev_err(&interface->dev, "missing bulk-out endpoint\n");
+		retval =3D -ENODEV;
+		goto error;
+	}
+
 	buffer_size =3D le16_to_cpu(endpoint->wMaxPacketSize);
 	ucs->bulk_out_size =3D buffer_size;
 	ucs->bulk_out_endpointAddr =3D endpoint->bEndpointAddress;
@@ -731,6 +738,12 @@ static int gigaset_probe(struct usb_interface *interfa=
ce,
=20
 	endpoint =3D &hostif->endpoint[1].desc;
=20
+	if (!usb_endpoint_is_int_in(endpoint)) {
+		dev_err(&interface->dev, "missing int-in endpoint\n");
+		retval =3D -ENODEV;
+		goto error;
+	}
+
 	ucs->busy =3D 0;
=20
 	ucs->read_urb =3D usb_alloc_urb(0, GFP_KERNEL);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dfab51ff09ea..284871a103f8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1762,11 +1762,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
 	}
 	cc->iv_offset =3D tmpll;
=20
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev)) {
+	ret =3D dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev=
);
+	if (ret) {
 		ti->error =3D "Device lookup failed";
 		goto bad;
 	}
=20
+	ret =3D -EINVAL;
 	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) !=3D 1) {
 		ti->error =3D "Invalid device sector";
 		goto bad;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 42c3a27a14cc..7e194aa14634 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -129,6 +129,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)
 	struct delay_c *dc;
 	unsigned long long tmpll;
 	char dummy;
+	int ret;
=20
 	if (argc !=3D 3 && argc !=3D 6) {
 		ti->error =3D "requires exactly 3 or 6 arguments";
@@ -143,6 +144,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)
=20
 	dc->reads =3D dc->writes =3D 0;
=20
+	ret =3D -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) !=3D 1) {
 		ti->error =3D "Invalid device sector";
 		goto bad;
@@ -154,12 +156,14 @@ static int delay_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
 		goto bad;
 	}
=20
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &dc->dev_read)) {
+	ret =3D dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &dc->dev_read);
+	if (ret) {
 		ti->error =3D "Device lookup failed";
 		goto bad;
 	}
=20
+	ret =3D -EINVAL;
 	dc->dev_write =3D NULL;
 	if (argc =3D=3D 3)
 		goto out;
@@ -175,13 +179,15 @@ static int delay_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
 		goto bad_dev_read;
 	}
=20
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
-			  &dc->dev_write)) {
+	ret =3D dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &dc->dev_write);
+	if (ret) {
 		ti->error =3D "Write device lookup failed";
 		goto bad_dev_read;
 	}
=20
 out:
+	ret =3D -EINVAL;
 	dc->kdelayd_wq =3D alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!dc->kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
@@ -208,7 +214,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)
 	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
-	return -EINVAL;
+	return ret;
 }
=20
 static void delay_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 0f5e1820c92d..8809c5e6f6ac 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -69,6 +69,11 @@ static int parse_features(struct dm_arg_set *as, struct =
flakey_c *fc,
 		arg_name =3D dm_shift_arg(as);
 		argc--;
=20
+		if (!arg_name) {
+			ti->error =3D "Insufficient feature arguments";
+			return -EINVAL;
+		}
+
 		/*
 		 * drop_writes
 		 */
@@ -183,6 +188,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)
=20
 	devname =3D dm_shift_arg(&as);
=20
+	r =3D -EINVAL;
 	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) !=3D 1) {
 		ti->error =3D "Invalid device sector";
 		goto bad;
@@ -199,11 +205,13 @@ static int flakey_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
=20
 	if (!(fc->up_interval + fc->down_interval)) {
 		ti->error =3D "Total (up + down) interval is zero";
+		r =3D -EINVAL;
 		goto bad;
 	}
=20
 	if (fc->up_interval + fc->down_interval < fc->up_interval) {
 		ti->error =3D "Interval overflow";
+		r =3D -EINVAL;
 		goto bad;
 	}
=20
@@ -211,7 +219,8 @@ static int flakey_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)
 	if (r)
 		goto bad;
=20
-	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev)) {
+	r =3D dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev);
+	if (r) {
 		ti->error =3D "Device lookup failed";
 		goto bad;
 	}
@@ -224,7 +233,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)
=20
 bad:
 	kfree(fc);
-	return -EINVAL;
+	return r;
 }
=20
 static void flakey_dtr(struct dm_target *ti)
@@ -287,15 +296,13 @@ static int flakey_map(struct dm_target *ti, struct bi=
o *bio)
 		pb->bio_submitted =3D true;
=20
 		/*
-		 * Map reads as normal only if corrupt_bio_byte set.
+		 * Error reads if neither corrupt_bio_byte or drop_writes are set.
+		 * Otherwise, flakey_end_io() will decide if the reads should be modifie=
d.
 		 */
 		if (bio_data_dir(bio) =3D=3D READ) {
-			/* If flags were specified, only corrupt those that match. */
-			if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw =3D=3D READ) &&
-			    all_corrupt_bio_flags_match(bio, fc))
-				goto map_bio;
-			else
+			if (!fc->corrupt_bio_byte && !test_bit(DROP_WRITES, &fc->flags))
 				return -EIO;
+			goto map_bio;
 		}
=20
 		/*
@@ -332,14 +339,21 @@ static int flakey_end_io(struct dm_target *ti, struct=
 bio *bio, int error)
 	struct flakey_c *fc =3D ti->private;
 	struct per_bio_data *pb =3D dm_per_bio_data(bio, sizeof(struct per_bio_da=
ta));
=20
-	/*
-	 * Corrupt successful READs while in down state.
-	 */
 	if (!error && pb->bio_submitted && (bio_data_dir(bio) =3D=3D READ)) {
-		if (fc->corrupt_bio_byte)
+		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw =3D=3D READ) &&
+		    all_corrupt_bio_flags_match(bio, fc)) {
+			/*
+			 * Corrupt successful matching READs while in down state.
+			 */
 			corrupt_bio_data(bio, fc);
-		else
+
+		} else if (!test_bit(DROP_WRITES, &fc->flags)) {
+			/*
+			 * Error read during the down_interval if drop_writes
+			 * wasn't configured.
+			 */
 			return -EIO;
+		}
 	}
=20
 	return error;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 53e848c10939..62c26e4ad6ac 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -30,6 +30,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int =
argc, char **argv)
 	struct linear_c *lc;
 	unsigned long long tmp;
 	char dummy;
+	int ret;
=20
 	if (argc !=3D 2) {
 		ti->error =3D "Invalid argument count";
@@ -42,13 +43,15 @@ static int linear_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)
 		return -ENOMEM;
 	}
=20
+	ret =3D -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) !=3D 1) {
 		ti->error =3D "dm-linear: Invalid device sector";
 		goto bad;
 	}
 	lc->start =3D tmp;
=20
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev)) {
+	ret =3D dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev=
);
+	if (ret) {
 		ti->error =3D "dm-linear: Device lookup failed";
 		goto bad;
 	}
@@ -61,7 +64,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int =
argc, char **argv)
=20
       bad:
 	kfree(lc);
-	return -EINVAL;
+	return ret;
 }
=20
 static void linear_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 089d62751f7f..3a477f97952a 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -923,16 +923,18 @@ static int get_mirror(struct mirror_set *ms, struct d=
m_target *ti,
 {
 	unsigned long long offset;
 	char dummy;
+	int ret;
=20
 	if (sscanf(argv[1], "%llu%c", &offset, &dummy) !=3D 1) {
 		ti->error =3D "Invalid offset";
 		return -EINVAL;
 	}
=20
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+	ret =3D dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &ms->mirror[mirror].dev);
+	if (ret) {
 		ti->error =3D "Device lookup failure";
-		return -ENXIO;
+		return ret;
 	}
=20
 	ms->mirror[mirror].ms =3D ms;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persisten=
t.c
index d3272acc0f0e..2d6a12bd3b28 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -16,7 +16,7 @@
 #include "dm-bufio.h"
=20
 #define DM_MSG_PREFIX "persistent snapshot"
-#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
+#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32U	/* 16KB */
=20
 #define DM_PREFETCH_CHUNKS		12
=20
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index d1600d2aa2e2..e7b07b1282d8 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -75,13 +75,15 @@ static int get_stripe(struct dm_target *ti, struct stri=
pe_c *sc,
 {
 	unsigned long long start;
 	char dummy;
+	int ret;
=20
 	if (sscanf(argv[1], "%llu%c", &start, &dummy) !=3D 1)
 		return -EINVAL;
=20
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &sc->stripe[stripe].dev))
-		return -ENXIO;
+	ret =3D dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &sc->stripe[stripe].dev);
+	if (ret)
+		return ret;
=20
 	sc->stripe[stripe].physical_start =3D start;
=20
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index e6f64c472d5e..da54c8172df0 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -197,6 +197,15 @@ struct dm_pool_metadata {
 	 */
 	bool fail_io:1;
=20
+	/*
+	 * Pre-commit callback.
+	 *
+	 * This allows the thin provisioning target to run a callback before
+	 * the metadata are committed.
+	 */
+	dm_pool_pre_commit_fn pre_commit_fn;
+	void *pre_commit_context;
+
 	/*
 	 * Reading the space map roots can fail, so we read it into these
 	 * buffers before the superblock is locked and updated.
@@ -784,6 +793,14 @@ static int __commit_transaction(struct dm_pool_metadat=
a *pmd)
 	 */
 	BUILD_BUG_ON(sizeof(struct thin_disk_superblock) > 512);
=20
+	if (pmd->pre_commit_fn) {
+		r =3D pmd->pre_commit_fn(pmd->pre_commit_context);
+		if (r < 0) {
+			DMERR("pre-commit callback failed");
+			return r;
+		}
+	}
+
 	r =3D __write_changed_details(pmd);
 	if (r < 0)
 		return r;
@@ -844,6 +861,8 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct b=
lock_device *bdev,
 	pmd->fail_io =3D false;
 	pmd->bdev =3D bdev;
 	pmd->data_block_size =3D data_block_size;
+	pmd->pre_commit_fn =3D NULL;
+	pmd->pre_commit_context =3D NULL;
=20
 	r =3D __create_persistent_data_objects(pmd, format_device);
 	if (r) {
@@ -1789,6 +1808,16 @@ int dm_pool_register_metadata_threshold(struct dm_po=
ol_metadata *pmd,
 	return r;
 }
=20
+void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
+					  dm_pool_pre_commit_fn fn,
+					  void *context)
+{
+	down_write(&pmd->root_lock);
+	pmd->pre_commit_fn =3D fn;
+	pmd->pre_commit_context =3D context;
+	up_write(&pmd->root_lock);
+}
+
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
 {
 	int r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index e3c857db195a..9859dd9fb921 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -213,6 +213,13 @@ int dm_pool_register_metadata_threshold(struct dm_pool=
_metadata *pmd,
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd);
 bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd);
=20
+/* Pre-commit callback */
+typedef int (*dm_pool_pre_commit_fn)(void *context);
+
+void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
+					  dm_pool_pre_commit_fn fn,
+					  void *context);
+
 /*----------------------------------------------------------------*/
=20
 #endif
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/pers=
istent-data/dm-btree-remove.c
index 92cd09f3c69b..d9fb3490da5d 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -203,7 +203,13 @@ static void __rebalance2(struct dm_btree_info *info, s=
truct btree_node *parent,
 	struct btree_node *right =3D r->n;
 	uint32_t nr_left =3D le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right =3D le32_to_cpu(right->header.nr_entries);
-	unsigned threshold =3D 2 * merge_threshold(left) + 1;
+	/*
+	 * Ensure the number of entries in each child will be greater
+	 * than or equal to (max_entries / 3 + 1), so no matter which
+	 * child is used for removal, the number will still be not
+	 * less than (max_entries / 3).
+	 */
+	unsigned int threshold =3D 2 * (merge_threshold(left) + 1);
=20
 	if (nr_left + nr_right < threshold) {
 		/*
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8f7dfc58f965..61165e528a5e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -88,7 +88,7 @@ static int create_strip_zones(struct mddev *mddev, struct=
 r0conf **private_conf)
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned short blksize =3D 512;
+	unsigned blksize =3D 512;
=20
 	if (!conf)
 		return -ENOMEM;
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 73a432934bd8..2a489e6debc0 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/slab.h>
 #include <linux/types.h>
=20
 #include <media/media-device.h>
@@ -236,7 +237,7 @@ static long media_device_ioctl(struct file *filp, unsig=
ned int cmd,
 			       unsigned long arg)
 {
 	struct media_devnode *devnode =3D media_devnode_data(filp);
-	struct media_device *dev =3D to_media_device(devnode);
+	struct media_device *dev =3D devnode->media_dev;
 	long ret;
=20
 	switch (cmd) {
@@ -305,7 +306,7 @@ static long media_device_compat_ioctl(struct file *filp=
, unsigned int cmd,
 				      unsigned long arg)
 {
 	struct media_devnode *devnode =3D media_devnode_data(filp);
-	struct media_device *dev =3D to_media_device(devnode);
+	struct media_device *dev =3D devnode->media_dev;
 	long ret;
=20
 	switch (cmd) {
@@ -346,7 +347,8 @@ static const struct media_file_operations media_device_=
fops =3D {
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_device *mdev =3D to_media_device(to_media_devnode(cd));
+	struct media_devnode *devnode =3D to_media_devnode(cd);
+	struct media_device *mdev =3D devnode->media_dev;
=20
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -374,6 +376,7 @@ static void media_device_release(struct media_devnode *=
mdev)
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
+	struct media_devnode *devnode;
 	int ret;
=20
 	if (WARN_ON(mdev->dev =3D=3D NULL || mdev->model[0] =3D=3D 0))
@@ -384,17 +387,28 @@ int __must_check __media_device_register(struct media=
_device *mdev,
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
=20
+	devnode =3D kzalloc(sizeof(*devnode), GFP_KERNEL);
+	if (!devnode)
+		return -ENOMEM;
+
 	/* Register the device node. */
-	mdev->devnode.fops =3D &media_device_fops;
-	mdev->devnode.parent =3D mdev->dev;
-	mdev->devnode.release =3D media_device_release;
-	ret =3D media_devnode_register(&mdev->devnode, owner);
-	if (ret < 0)
+	mdev->devnode =3D devnode;
+	devnode->fops =3D &media_device_fops;
+	devnode->parent =3D mdev->dev;
+	devnode->release =3D media_device_release;
+	ret =3D media_devnode_register(mdev, devnode, owner);
+	if (ret < 0) {
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode =3D NULL;
 		return ret;
+	}
=20
-	ret =3D device_create_file(&mdev->devnode.dev, &dev_attr_model);
+	ret =3D device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
-		media_devnode_unregister(&mdev->devnode);
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode =3D NULL;
+		media_devnode_unregister_prepare(devnode);
+		media_devnode_unregister(devnode);
 		return ret;
 	}
=20
@@ -412,11 +426,16 @@ void media_device_unregister(struct media_device *mde=
v)
 	struct media_entity *entity;
 	struct media_entity *next;
=20
+	/* Clear the devnode register bit to avoid races with media dev open */
+	media_devnode_unregister_prepare(mdev->devnode);
+
 	list_for_each_entry_safe(entity, next, &mdev->entities, list)
 		media_device_unregister_entity(entity);
=20
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	media_devnode_unregister(&mdev->devnode);
+	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+	media_devnode_unregister(mdev->devnode);
+	/* devnode free is handled in media_devnode_*() */
+	mdev->devnode =3D NULL;
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
=20
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7acd19c881de..e887120d19aa 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
=20
 #include <media/media-devnode.h>
+#include <media/media-device.h>
=20
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -59,21 +60,19 @@ static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEV=
ICES);
 /* Called when the last user of the media device exits. */
 static void media_devnode_release(struct device *cd)
 {
-	struct media_devnode *mdev =3D to_media_devnode(cd);
+	struct media_devnode *devnode =3D to_media_devnode(cd);
=20
 	mutex_lock(&media_devnode_lock);
-
-	/* Delete the cdev on this minor as well */
-	cdev_del(&mdev->cdev);
-
 	/* Mark device node number as free */
-	clear_bit(mdev->minor, media_devnode_nums);
-
+	clear_bit(devnode->minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
=20
 	/* Release media_devnode and perform other cleanups as needed. */
-	if (mdev->release)
-		mdev->release(mdev);
+	if (devnode->release)
+		devnode->release(devnode);
+
+	kfree(devnode);
+	pr_debug("%s: Media Devnode Deallocated\n", __func__);
 }
=20
 static struct bus_type media_bus_type =3D {
@@ -83,37 +82,37 @@ static struct bus_type media_bus_type =3D {
 static ssize_t media_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
-	if (!mdev->fops->read)
+	if (!devnode->fops->read)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->read(filp, buf, sz, off);
+	return devnode->fops->read(filp, buf, sz, off);
 }
=20
 static ssize_t media_write(struct file *filp, const char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
-	if (!mdev->fops->write)
+	if (!devnode->fops->write)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->write(filp, buf, sz, off);
+	return devnode->fops->write(filp, buf, sz, off);
 }
=20
 static unsigned int media_poll(struct file *filp,
 			       struct poll_table_struct *poll)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return POLLERR | POLLHUP;
-	if (!mdev->fops->poll)
+	if (!devnode->fops->poll)
 		return DEFAULT_POLLMASK;
-	return mdev->fops->poll(filp, poll);
+	return devnode->fops->poll(filp, poll);
 }
=20
 static long
@@ -121,12 +120,12 @@ __media_ioctl(struct file *filp, unsigned int cmd, un=
signed long arg,
 	      long (*ioctl_func)(struct file *filp, unsigned int cmd,
 				 unsigned long arg))
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
 	if (!ioctl_func)
 		return -ENOTTY;
=20
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
=20
 	return ioctl_func(filp, cmd, arg);
@@ -134,9 +133,9 @@ __media_ioctl(struct file *filp, unsigned int cmd, unsi=
gned long arg,
=20
 static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long=
 arg)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
-	return __media_ioctl(filp, cmd, arg, mdev->fops->ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->ioctl);
 }
=20
 #ifdef CONFIG_COMPAT
@@ -144,9 +143,9 @@ static long media_ioctl(struct file *filp, unsigned int=
 cmd, unsigned long arg)
 static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
+	struct media_devnode *devnode =3D media_devnode_data(filp);
=20
-	return __media_ioctl(filp, cmd, arg, mdev->fops->compat_ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->compat_ioctl);
 }
=20
 #endif /* CONFIG_COMPAT */
@@ -154,7 +153,7 @@ static long media_compat_ioctl(struct file *filp, unsig=
ned int cmd,
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev;
+	struct media_devnode *devnode;
 	int ret;
=20
 	/* Check if the media device is available. This needs to be done with
@@ -164,23 +163,24 @@ static int media_open(struct inode *inode, struct fil=
e *filp)
 	 * a crash.
 	 */
 	mutex_lock(&media_devnode_lock);
-	mdev =3D container_of(inode->i_cdev, struct media_devnode, cdev);
+	devnode =3D container_of(inode->i_cdev, struct media_devnode, cdev);
 	/* return ENXIO if the media device has been removed
 	   already or if it is not registered anymore. */
-	if (!media_devnode_is_registered(mdev)) {
+	if (!media_devnode_is_registered(devnode)) {
 		mutex_unlock(&media_devnode_lock);
 		return -ENXIO;
 	}
 	/* and increase the device refcount */
-	get_device(&mdev->dev);
+	get_device(&devnode->dev);
 	mutex_unlock(&media_devnode_lock);
=20
-	filp->private_data =3D mdev;
+	filp->private_data =3D devnode;
=20
-	if (mdev->fops->open) {
-		ret =3D mdev->fops->open(filp);
+	if (devnode->fops->open) {
+		ret =3D devnode->fops->open(filp);
 		if (ret) {
-			put_device(&mdev->dev);
+			put_device(&devnode->dev);
+			filp->private_data =3D NULL;
 			return ret;
 		}
 	}
@@ -191,17 +191,19 @@ static int media_open(struct inode *inode, struct fil=
e *filp)
 /* Override for the release function */
 static int media_release(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev =3D media_devnode_data(filp);
-	int ret =3D 0;
+	struct media_devnode *devnode =3D media_devnode_data(filp);
+
+	if (devnode->fops->release)
+		devnode->fops->release(filp);
=20
-	if (mdev->fops->release)
-		mdev->fops->release(filp);
+	filp->private_data =3D NULL;
=20
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
-	put_device(&mdev->dev);
-	filp->private_data =3D NULL;
-	return ret;
+	put_device(&devnode->dev);
+
+	pr_debug("%s: Media Release\n", __func__);
+	return 0;
 }
=20
 static const struct file_operations media_devnode_fops =3D {
@@ -220,7 +222,8 @@ static const struct file_operations media_devnode_fops =
=3D {
=20
 /**
  * media_devnode_register - register a media device node
- * @mdev: media device node structure we want to register
+ * @media_dev: struct media_device we want to register a device node
+ * @devnode: media device node structure we want to register
  *
  * The registration code assigns minor numbers and registers the new devic=
e node
  * with the kernel. An error is returned if no free minor number can be fo=
und,
@@ -232,7 +235,8 @@ static const struct file_operations media_devnode_fops =
=3D {
  * the media_devnode structure is *not* called, so the caller is responsib=
le for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -244,68 +248,89 @@ int __must_check media_devnode_register(struct media_=
devnode *mdev,
 	if (minor =3D=3D MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
+		kfree(devnode);
 		return -ENFILE;
 	}
=20
 	set_bit(minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
=20
-	mdev->minor =3D minor;
+	devnode->minor =3D minor;
+	devnode->media_dev =3D mdev;
+
+	/* Part 1: Initialize dev now to use dev.kobj for cdev.kobj.parent */
+	devnode->dev.bus =3D &media_bus_type;
+	devnode->dev.devt =3D MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release =3D media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent =3D devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	device_initialize(&devnode->dev);
=20
 	/* Part 2: Initialize and register the character device */
-	cdev_init(&mdev->cdev, &media_devnode_fops);
-	mdev->cdev.owner =3D owner;
+	cdev_init(&devnode->cdev, &media_devnode_fops);
+	devnode->cdev.owner =3D owner;
+	devnode->cdev.kobj.parent =3D &devnode->dev.kobj;
=20
-	ret =3D cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
+	ret =3D cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor=
), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
-		goto error;
+		goto cdev_add_error;
 	}
=20
-	/* Part 3: Register the media device */
-	mdev->dev.bus =3D &media_bus_type;
-	mdev->dev.devt =3D MKDEV(MAJOR(media_dev_t), mdev->minor);
-	mdev->dev.release =3D media_devnode_release;
-	if (mdev->parent)
-		mdev->dev.parent =3D mdev->parent;
-	dev_set_name(&mdev->dev, "media%d", mdev->minor);
-	ret =3D device_register(&mdev->dev);
+	/* Part 3: Add the media device */
+	ret =3D device_add(&devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: device_register failed\n", __func__);
-		goto error;
+		pr_err("%s: device_add failed\n", __func__);
+		goto device_add_error;
 	}
=20
 	/* Part 4: Activate this minor. The char device can now be used. */
-	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
=20
 	return 0;
=20
-error:
-	cdev_del(&mdev->cdev);
-	clear_bit(mdev->minor, media_devnode_nums);
+device_add_error:
+	cdev_del(&devnode->cdev);
+cdev_add_error:
+	mutex_lock(&media_devnode_lock);
+	clear_bit(devnode->minor, media_devnode_nums);
+	devnode->media_dev =3D NULL;
+	mutex_unlock(&media_devnode_lock);
+
+	put_device(&devnode->dev);
 	return ret;
 }
=20
+void media_devnode_unregister_prepare(struct media_devnode *devnode)
+{
+	/* Check if devnode was ever registered at all */
+	if (!media_devnode_is_registered(devnode))
+		return;
+
+	mutex_lock(&media_devnode_lock);
+	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
+	mutex_unlock(&media_devnode_lock);
+}
+
 /**
  * media_devnode_unregister - unregister a media device node
- * @mdev: the device node to unregister
+ * @devnode: the device node to unregister
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
  *
- * This function can safely be called if the device node has never been
- * registered or has already been unregistered.
+ * Should be called after media_devnode_unregister_prepare()
  */
-void media_devnode_unregister(struct media_devnode *mdev)
+void media_devnode_unregister(struct media_devnode *devnode)
 {
-	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(mdev))
-		return;
-
 	mutex_lock(&media_devnode_lock);
-	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	/* Delete the cdev on this minor as well */
+	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
-	device_unregister(&mdev->dev);
+	device_del(&devnode->dev);
+	devnode->media_dev =3D NULL;
+	put_device(&devnode->dev);
 }
=20
 /*
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov51=
9.c
index c95f32a0c02b..6acb2132aedc 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -3497,6 +3497,11 @@ static void ov511_mode_init_regs(struct sd *sd)
 		return;
 	}
=20
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err =3D -ENODEV;
+		return;
+	}
+
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	reg_w(sd, R51x_FIFO_PSIZE, packet_size >> 5);
=20
@@ -3622,6 +3627,11 @@ static void ov518_mode_init_regs(struct sd *sd)
 		return;
 	}
=20
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err =3D -ENODEV;
+		return;
+	}
+
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	ov518_reg_w32(sd, R51x_FIFO_PSIZE, packet_size & ~7, 2);
=20
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/=
gspca/stv06xx/stv06xx.c
index 49d209bbf9ee..66a007203b78 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -293,6 +293,9 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
=20
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	err =3D stv06xx_write_bridge(sd, STV_ISO_SIZE_L, packet_size);
 	if (err < 0)
@@ -317,11 +320,21 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
=20
 static int stv06xx_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	struct sd *sd =3D (struct sd *) gspca_dev;
=20
+	intfc =3D gspca_dev->dev->actconfig->intf_cache[0];
+
+	if (intfc->num_altsetting < 2)
+		return -ENODEV;
+
+	alt =3D &intfc->altsetting[1];
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	/* Start isoc bandwidth "negotiation" at max isoc bandwidth */
-	alt =3D &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	alt->endpoint[0].desc.wMaxPacketSize =3D
 		cpu_to_le16(sd->sensor->max_packet_size[gspca_dev->curr_mode]);
=20
@@ -334,6 +347,10 @@ static int stv06xx_isoc_nego(struct gspca_dev *gspca_d=
ev)
 	struct usb_host_interface *alt;
 	struct sd *sd =3D (struct sd *) gspca_dev;
=20
+	/*
+	 * Existence of altsetting and endpoint was verified in
+	 * stv06xx_isoc_init()
+	 */
 	alt =3D &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	min_packet_size =3D sd->sensor->min_packet_size[gspca_dev->curr_mode];
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c b/drivers/med=
ia/usb/gspca/stv06xx/stv06xx_pb0100.c
index 8d785edcccf2..cc88c059b8d7 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
@@ -198,6 +198,10 @@ static int pb0100_start(struct sd *sd)
 	alt =3D usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt)
 		return -ENODEV;
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
=20
 	/* If we don't have enough bandwidth use a lower framerate */
diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspc=
a/xirlink_cit.c
index a41aa7817c54..b05c27e847e4 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1455,6 +1455,9 @@ static int cit_get_packet_size(struct gspca_dev *gspc=
a_dev)
 		return -EIO;
 	}
=20
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	return le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 }
=20
@@ -2632,6 +2635,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
=20
 static int sd_isoc_init(struct gspca_dev *gspca_dev)
 {
+	struct usb_interface_cache *intfc;
 	struct usb_host_interface *alt;
 	int max_packet_size;
=20
@@ -2647,8 +2651,17 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
 		break;
 	}
=20
+	intfc =3D gspca_dev->dev->actconfig->intf_cache[0];
+
+	if (intfc->num_altsetting < 2)
+		return -ENODEV;
+
+	alt =3D &intfc->altsetting[1];
+
+	if (alt->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	/* Start isoc bandwidth "negotiation" at max isoc bandwidth */
-	alt =3D &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	alt->endpoint[0].desc.wMaxPacketSize =3D cpu_to_le16(max_packet_size);
=20
 	return 0;
@@ -2671,6 +2684,9 @@ static int sd_isoc_nego(struct gspca_dev *gspca_dev)
 		break;
 	}
=20
+	/*
+	 * Existence of altsetting and endpoint was verified in sd_isoc_init()
+	 */
 	alt =3D &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
 	packet_size =3D le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	if (packet_size <=3D min_packet_size)
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc=
_driver.c
index 3b5f73ffe17a..9da63b6ff167 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1640,7 +1640,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
+	if (media_devnode_is_registered(dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
 #endif
=20
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 6cab9411b158..56c52497d56c 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -364,10 +364,9 @@ int enclosure_remove_device(struct enclosure_device *e=
dev, struct device *dev)
 		cdev =3D &edev->component[i];
 		if (cdev->dev =3D=3D dev) {
 			enclosure_remove_links(cdev);
-			device_del(&cdev->cdev);
 			put_device(dev);
 			cdev->dev =3D NULL;
-			return device_add(&cdev->cdev);
+			return 0;
 		}
 	}
 	return -ENODEV;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 393444edc78e..be03d058528c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2945,11 +2945,13 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->ops->get_min_clock)
 		mmc->f_min =3D host->ops->get_min_clock(host);
 	else if (host->version >=3D SDHCI_SPEC_300) {
-		if (host->clk_mul) {
-			mmc->f_min =3D (host->max_clk * host->clk_mul) / 1024;
+		if (host->clk_mul)
 			mmc->f_max =3D host->max_clk * host->clk_mul;
-		} else
-			mmc->f_min =3D host->max_clk / SDHCI_MAX_DIV_SPEC_300;
+		/*
+		 * Divided Clock Mode minimum clock rate is always less than
+		 * Programmable Clock Mode minimum clock rate.
+		 */
+		mmc->f_min =3D host->max_clk / SDHCI_MAX_DIV_SPEC_300;
 	} else
 		mmc->f_min =3D host->max_clk / SDHCI_MAX_DIV_SPEC_200;
=20
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 98f9fd6e37b6..3fb81bddf05b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3421,33 +3421,35 @@ static int bond_neigh_init(struct neighbour *n)
 	const struct net_device_ops *slave_ops;
 	struct neigh_parms parms;
 	struct slave *slave;
-	int ret;
+	int ret =3D 0;
=20
-	slave =3D bond_first_slave(bond);
+	rcu_read_lock();
+	slave =3D bond_first_slave_rcu(bond);
 	if (!slave)
-		return 0;
+		goto out;
 	slave_ops =3D slave->dev->netdev_ops;
 	if (!slave_ops->ndo_neigh_setup)
-		return 0;
-
-	parms.neigh_setup =3D NULL;
-	parms.neigh_cleanup =3D NULL;
-	ret =3D slave_ops->ndo_neigh_setup(slave->dev, &parms);
-	if (ret)
-		return ret;
+		goto out;
=20
-	/*
-	 * Assign slave's neigh_cleanup to neighbour in case cleanup is called
-	 * after the last slave has been detached.  Assumes that all slaves
-	 * utilize the same neigh_cleanup (true at this writing as only user
-	 * is ipoib).
+	/* TODO: find another way [1] to implement this.
+	 * Passing a zeroed structure is fragile,
+	 * but at least we do not pass garbage.
+	 *
+	 * [1] One way would be that ndo_neigh_setup() never touch
+	 *     struct neigh_parms, but propagate the new neigh_setup()
+	 *     back to ___neigh_create() / neigh_parms_alloc()
 	 */
-	n->parms->neigh_cleanup =3D parms.neigh_cleanup;
+	memset(&parms, 0, sizeof(parms));
+	ret =3D slave_ops->ndo_neigh_setup(slave->dev, &parms);
=20
-	if (!parms.neigh_setup)
-		return 0;
+	if (ret)
+		goto out;
=20
-	return parms.neigh_setup(n);
+	if (parms.neigh_setup)
+		ret =3D parms.neigh_setup(n);
+out:
+	rcu_read_unlock();
+	return ret;
 }
=20
 /*
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index e0c9be5e2ab7..9aa851f865f4 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -412,13 +412,12 @@ static int mscan_rx_poll(struct napi_struct *napi, in=
t quota)
 	struct net_device *dev =3D napi->dev;
 	struct mscan_regs __iomem *regs =3D priv->reg_base;
 	struct net_device_stats *stats =3D &dev->stats;
-	int npackets =3D 0;
-	int ret =3D 1;
+	int work_done =3D 0;
 	struct sk_buff *skb;
 	struct can_frame *frame;
 	u8 canrflg;
=20
-	while (npackets < quota) {
+	while (work_done < quota) {
 		canrflg =3D in_8(&regs->canrflg);
 		if (!(canrflg & (MSCAN_RXF | MSCAN_ERR_IF)))
 			break;
@@ -439,18 +438,18 @@ static int mscan_rx_poll(struct napi_struct *napi, in=
t quota)
=20
 		stats->rx_packets++;
 		stats->rx_bytes +=3D frame->can_dlc;
-		npackets++;
+		work_done++;
 		netif_receive_skb(skb);
 	}
=20
-	if (!(in_8(&regs->canrflg) & (MSCAN_RXF | MSCAN_ERR_IF))) {
-		napi_complete(&priv->napi);
-		clear_bit(F_RX_PROGRESS, &priv->flags);
-		if (priv->can.state < CAN_STATE_BUS_OFF)
-			out_8(&regs->canrier, priv->shadow_canrier);
-		ret =3D 0;
+	if (work_done < quota) {
+		if (likely(napi_complete_done(&priv->napi, work_done))) {
+			clear_bit(F_RX_PROGRESS, &priv->flags);
+			if (priv->can.state < CAN_STATE_BUS_OFF)
+				out_8(&regs->canrier, priv->shadow_canrier);
+		}
 	}
-	return ret;
+	return work_done;
 }
=20
 static irqreturn_t mscan_isr(int irq, void *dev_id)
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index ea4d4f1a6411..f0769ce11c4b 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -150,7 +150,7 @@ static void slc_bump(struct slcan *sl)
 	u32 tmpid;
 	char *cmd =3D sl->rbuff;
=20
-	cf.can_id =3D 0;
+	memset(&cf, 0, sizeof(cf));
=20
 	switch (*cmd) {
 	case 'r':
@@ -189,8 +189,6 @@ static void slc_bump(struct slcan *sl)
 	else
 		return;
=20
-	*(u64 *) (&cf.data) =3D 0; /* clear payload */
-
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf.can_id & CAN_RTR_FLAG)) {
 		for (i =3D 0; i < cf.can_dlc; i++) {
@@ -346,9 +344,16 @@ static void slcan_transmit(struct work_struct *work)
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
 {
-	struct slcan *sl =3D tty->disc_data;
+	struct slcan *sl;
+
+	rcu_read_lock();
+	sl =3D rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;
=20
 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }
=20
 /* Send a can_frame to a TTY queue. */
@@ -640,10 +645,11 @@ static void slcan_close(struct tty_struct *tty)
 		return;
=20
 	spin_lock_bh(&sl->lock);
-	tty->disc_data =3D NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty =3D NULL;
 	spin_unlock_bh(&sl->lock);
=20
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
=20
 	/* Flush network side */
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3da1be6b508b..b58d25aedb72 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -846,7 +846,7 @@ static int gs_usb_probe(struct usb_interface *intf, con=
st struct usb_device_id *
 			     GS_USB_BREQ_HOST_FORMAT,
 			     USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 			     1,
-			     intf->altsetting[0].desc.bInterfaceNumber,
+			     intf->cur_altsetting->desc.bInterfaceNumber,
 			     hconf,
 			     sizeof(*hconf),
 			     1000);
@@ -869,7 +869,7 @@ static int gs_usb_probe(struct usb_interface *intf, con=
st struct usb_device_id *
 			     GS_USB_BREQ_DEVICE_CONFIG,
 			     USB_DIR_IN|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 			     1,
-			     intf->altsetting[0].desc.bInterfaceNumber,
+			     intf->cur_altsetting->desc.bInterfaceNumber,
 			     dconf,
 			     sizeof(*dconf),
 			     1000);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index c932436c6a47..35ab6f85a0df 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1465,11 +1465,6 @@ static int ixgbevf_write_uc_addr_list(struct net_dev=
ice *netdev)
 	struct ixgbe_hw *hw =3D &adapter->hw;
 	int count =3D 0;
=20
-	if ((netdev_uc_count(netdev)) > 10) {
-		pr_err("Too many unicast filters - No Space\n");
-		return -ENOSPC;
-	}
-
 	if (!netdev_uc_empty(netdev)) {
 		struct netdev_hw_addr *ha;
 		netdev_for_each_uc_addr(ha, netdev) {
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/na=
tsemi/sonic.c
index 1bd419dbda6d..cf3aaffc445f 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -50,6 +50,8 @@ static int sonic_open(struct net_device *dev)
 	if (sonic_debug > 2)
 		printk("sonic_open: initializing sonic driver.\n");
=20
+	spin_lock_init(&lp->lock);
+
 	for (i =3D 0; i < SONIC_NUM_RRS; i++) {
 		struct sk_buff *skb =3D netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 		if (skb =3D=3D NULL) {
@@ -101,6 +103,24 @@ static int sonic_open(struct net_device *dev)
 	return 0;
 }
=20
+/* Wait for the SONIC to become idle. */
+static void sonic_quiesce(struct net_device *dev, u16 mask)
+{
+	struct sonic_local * __maybe_unused lp =3D netdev_priv(dev);
+	int i;
+	u16 bits;
+
+	for (i =3D 0; i < 1000; ++i) {
+		bits =3D SONIC_READ(SONIC_CMD) & mask;
+		if (!bits)
+			return;
+		if (irqs_disabled() || in_interrupt())
+			udelay(20);
+		else
+			usleep_range(100, 200);
+	}
+	WARN_ONCE(1, "command deadline expired! 0x%04x\n", bits);
+}
=20
 /*
  * Close the SONIC device
@@ -118,6 +138,9 @@ static int sonic_close(struct net_device *dev)
 	/*
 	 * stop the SONIC, disable interrupts
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -157,6 +180,9 @@ static void sonic_tx_timeout(struct net_device *dev)
 	 * put the Sonic into software-reset mode and
 	 * disable all interrupts before releasing DMA buffers
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -194,8 +220,6 @@ static void sonic_tx_timeout(struct net_device *dev)
  *   wake the tx queue
  * Concurrently with all of this, the SONIC is potentially writing to
  * the status flags of the TDs.
- * Until some mutual exclusion is added, this code will not work with SMP.=
 However,
- * MIPS Jazz machines and m68k Macs were all uni-processor machines.
  */
=20
 static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
@@ -203,7 +227,8 @@ static int sonic_send_packet(struct sk_buff *skb, struc=
t net_device *dev)
 	struct sonic_local *lp =3D netdev_priv(dev);
 	dma_addr_t laddr;
 	int length;
-	int entry =3D lp->next_tx;
+	int entry;
+	unsigned long flags;
=20
 	if (sonic_debug > 2)
 		printk("sonic_send_packet: skb=3D%p, dev=3D%p\n", skb, dev);
@@ -221,11 +246,15 @@ static int sonic_send_packet(struct sk_buff *skb, str=
uct net_device *dev)
=20
 	laddr =3D dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
 	if (!laddr) {
-		printk(KERN_ERR "%s: failed to map tx DMA buffer.\n", dev->name);
+		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb(skb);
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
=20
+	spin_lock_irqsave(&lp->lock, flags);
+
+	entry =3D lp->next_tx;
+
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
 	sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
 	sonic_tda_put(dev, entry, SONIC_TD_PKTSIZE, length); /* length of packet =
*/
@@ -235,10 +264,6 @@ static int sonic_send_packet(struct sk_buff *skb, stru=
ct net_device *dev)
 	sonic_tda_put(dev, entry, SONIC_TD_LINK,
 		sonic_tda_get(dev, entry, SONIC_TD_LINK) | SONIC_EOL);
=20
-	/*
-	 * Must set tx_skb[entry] only after clearing status, and
-	 * before clearing EOL and before stopping queue
-	 */
 	wmb();
 	lp->tx_len[entry] =3D length;
 	lp->tx_laddr[entry] =3D laddr;
@@ -263,6 +288,8 @@ static int sonic_send_packet(struct sk_buff *skb, struc=
t net_device *dev)
=20
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
=20
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return NETDEV_TX_OK;
 }
=20
@@ -275,9 +302,21 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_=
id)
 	struct net_device *dev =3D dev_id;
 	struct sonic_local *lp =3D netdev_priv(dev);
 	int status;
+	unsigned long flags;
+
+	/* The lock has two purposes. Firstly, it synchronizes sonic_interrupt()
+	 * with sonic_send_packet() so that the two functions can share state.
+	 * Secondly, it makes sonic_interrupt() re-entrant, as that is required
+	 * by macsonic which must use two IRQs with different priority levels.
+	 */
+	spin_lock_irqsave(&lp->lock, flags);
+
+	status =3D SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
+	if (!status) {
+		spin_unlock_irqrestore(&lp->lock, flags);
=20
-	if (!(status =3D SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT))
 		return IRQ_NONE;
+	}
=20
 	do {
 		if (status & SONIC_INT_PKTRX) {
@@ -292,11 +331,12 @@ static irqreturn_t sonic_interrupt(int irq, void *dev=
_id)
 			int td_status;
 			int freed_some =3D 0;
=20
-			/* At this point, cur_tx is the index of a TD that is one of:
-			 *   unallocated/freed                          (status set   & tx_skb[=
entry] clear)
-			 *   allocated and sent                         (status set   & tx_skb[=
entry] set  )
-			 *   allocated and not yet sent                 (status clear & tx_skb[=
entry] set  )
-			 *   still being allocated by sonic_send_packet (status clear & tx_skb[=
entry] clear)
+			/* The state of a Transmit Descriptor may be inferred
+			 * from { tx_skb[entry], td_status } as follows.
+			 * { clear, clear } =3D> the TD has never been used
+			 * { set,   clear } =3D> the TD was handed to SONIC
+			 * { set,   set   } =3D> the TD was handed back
+			 * { clear, set   } =3D> the TD is available for re-use
 			 */
=20
 			if (sonic_debug > 2)
@@ -398,10 +438,30 @@ static irqreturn_t sonic_interrupt(int irq, void *dev=
_id)
 		/* load CAM done */
 		if (status & SONIC_INT_LCD)
 			SONIC_WRITE(SONIC_ISR, SONIC_INT_LCD); /* clear the interrupt */
-	} while((status =3D SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT));
+
+		status =3D SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
+	} while (status);
+
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return IRQ_HANDLED;
 }
=20
+/* Return the array index corresponding to a given Receive Buffer pointer.=
 */
+static int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
+			   unsigned int last)
+{
+	unsigned int i =3D last;
+
+	do {
+		i =3D (i + 1) & SONIC_RRS_MASK;
+		if (addr =3D=3D lp->rx_laddr[i])
+			return i;
+	} while (i !=3D last);
+
+	return -ENOENT;
+}
+
 /*
  * We have a good packet(s), pass it/them up the network stack.
  */
@@ -421,6 +481,16 @@ static void sonic_rx(struct net_device *dev)
=20
 		status =3D sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 		if (status & SONIC_RCR_PRX) {
+			u32 addr =3D (sonic_rda_get(dev, entry,
+						  SONIC_RD_PKTPTR_H) << 16) |
+				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
+			int i =3D index_from_addr(lp, addr, entry);
+
+			if (i < 0) {
+				WARN_ONCE(1, "failed to find buffer!\n");
+				break;
+			}
+
 			/* Malloc up new buffer. */
 			new_skb =3D netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 			if (new_skb =3D=3D NULL) {
@@ -442,7 +512,7 @@ static void sonic_rx(struct net_device *dev)
=20
 			/* now we have a new skb to replace it, pass the used one up the stack =
*/
 			dma_unmap_single(lp->device, lp->rx_laddr[entry], SONIC_RBSIZE, DMA_FRO=
M_DEVICE);
-			used_skb =3D lp->rx_skb[entry];
+			used_skb =3D lp->rx_skb[i];
 			pkt_len =3D sonic_rda_get(dev, entry, SONIC_RD_PKTLEN);
 			skb_trim(used_skb, pkt_len);
 			used_skb->protocol =3D eth_type_trans(used_skb, dev);
@@ -451,13 +521,13 @@ static void sonic_rx(struct net_device *dev)
 			lp->stats.rx_bytes +=3D pkt_len;
=20
 			/* and insert the new skb */
-			lp->rx_laddr[entry] =3D new_laddr;
-			lp->rx_skb[entry] =3D new_skb;
+			lp->rx_laddr[i] =3D new_laddr;
+			lp->rx_skb[i] =3D new_skb;
=20
 			bufadr_l =3D (unsigned long)new_laddr & 0xffff;
 			bufadr_h =3D (unsigned long)new_laddr >> 16;
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_L, bufadr_l);
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, bufadr_h);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
 		} else {
 			/* This should only happen, if we enable accepting broken packets. */
 			lp->stats.rx_errors++;
@@ -592,6 +662,7 @@ static int sonic_init(struct net_device *dev)
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
=20
 	/*
 	 * initialize the receive resource area
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/na=
tsemi/sonic.h
index 07091dd27e5d..7dcf913d7395 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -109,6 +109,9 @@
 #define SONIC_CR_TXP            0x0002
 #define SONIC_CR_HTX            0x0001
=20
+#define SONIC_CR_ALL (SONIC_CR_LCAM | SONIC_CR_RRRA | \
+		      SONIC_CR_RXEN | SONIC_CR_TXP)
+
 /*
  * SONIC data configuration bits
  */
@@ -273,8 +276,9 @@
 #define SONIC_NUM_RDS   SONIC_NUM_RRS /* number of receive descriptors */
 #define SONIC_NUM_TDS   16            /* number of transmit descriptors */
=20
-#define SONIC_RDS_MASK  (SONIC_NUM_RDS-1)
-#define SONIC_TDS_MASK  (SONIC_NUM_TDS-1)
+#define SONIC_RRS_MASK  (SONIC_NUM_RRS - 1)
+#define SONIC_RDS_MASK  (SONIC_NUM_RDS - 1)
+#define SONIC_TDS_MASK  (SONIC_NUM_TDS - 1)
=20
 #define SONIC_RBSIZE	1520          /* size of one resource buffer */
=20
@@ -320,6 +324,7 @@ struct sonic_local {
 	unsigned int next_tx;          /* next free TD */
 	struct device *device;         /* generic device */
 	struct net_device_stats stats;
+	spinlock_t lock;
 };
=20
 #define TX_TIMEOUT (3 * HZ)
@@ -341,30 +346,30 @@ static void sonic_tx_timeout(struct net_device *dev);
    as far as we can tell. */
 /* OpenBSD calls this "SWO".  I'd like to think that sonic_buf_put()
    is a much better name. */
-static inline void sonic_buf_put(void* base, int bitmode,
+static inline void sonic_buf_put(u16 *base, int bitmode,
 				 int offset, __u16 val)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		((__u16 *) base + (offset*2))[1] =3D val;
+		__raw_writew(val, base + (offset * 2) + 1);
 #else
-		((__u16 *) base + (offset*2))[0] =3D val;
+		__raw_writew(val, base + (offset * 2) + 0);
 #endif
 	else
-	 	((__u16 *) base)[offset] =3D val;
+		__raw_writew(val, base + (offset * 1) + 0);
 }
=20
-static inline __u16 sonic_buf_get(void* base, int bitmode,
+static inline __u16 sonic_buf_get(u16 *base, int bitmode,
 				  int offset)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		return ((volatile __u16 *) base + (offset*2))[1];
+		return __raw_readw(base + (offset * 2) + 1);
 #else
-		return ((volatile __u16 *) base + (offset*2))[0];
+		return __raw_readw(base + (offset * 2) + 0);
 #endif
 	else
-		return ((volatile __u16 *) base)[offset];
+		return __raw_readw(base + (offset * 1) + 0);
 }
=20
 /* Inlines that you should actually use for reading/writing DMA buffers */
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/eth=
ernet/stmicro/stmmac/common.h
index 4561b16a9ebb..4747facb3edc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -270,9 +270,8 @@ struct dma_features {
 	unsigned int enh_desc;
 };
=20
-/* GMAC TX FIFO is 8K, Rx FIFO is 16K */
-#define BUF_SIZE_16KiB 16384
-/* RX Buffer size must be < 8191 and multiple of 4/8/16 bytes */
+/* RX Buffer size must be multiple of 4/8/16 bytes */
+#define BUF_SIZE_16KiB 16368
 #define BUF_SIZE_8KiB 8188
 #define BUF_SIZE_4KiB 4096
 #define BUF_SIZE_2KiB 2048
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/ne=
t/ethernet/stmicro/stmmac/dwmac-sunxi.c
index 771cd15fca18..0f7a4d70d919 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -78,7 +78,7 @@ static int sun7i_gmac_init(struct platform_device *pdev, =
void *priv)
 	 * rate, which then uses the auto-reparenting feature of the
 	 * clock driver, and enabling/disabling the clock.
 	 */
-	if (gmac->interface =3D=3D PHY_INTERFACE_MODE_RGMII) {
+	if (phy_interface_mode_is_rgmii(gmac->interface)) {
 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_GMII_RGMII_RATE);
 		clk_prepare_enable(gmac->tx_clk);
 		gmac->clk_enabled =3D 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index 5fe95ef7954b..ad9f1f022457 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -904,7 +904,9 @@ static int stmmac_set_bfsize(int mtu, int bufsize)
 {
 	int ret =3D bufsize;
=20
-	if (mtu >=3D BUF_SIZE_4KiB)
+	if (mtu >=3D BUF_SIZE_8KiB)
+		ret =3D BUF_SIZE_16KiB;
+	else if (mtu >=3D BUF_SIZE_4KiB)
 		ret =3D BUF_SIZE_8KiB;
 	else if (mtu >=3D BUF_SIZE_2KiB)
 		ret =3D BUF_SIZE_4KiB;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 5e8aff812f20..bd109f981d8b 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -685,10 +685,10 @@ static void sixpack_close(struct tty_struct *tty)
 {
 	struct sixpack *sp;
=20
-	write_lock_bh(&disc_data_lock);
+	write_lock_irq(&disc_data_lock);
 	sp =3D tty->disc_data;
 	tty->disc_data =3D NULL;
-	write_unlock_bh(&disc_data_lock);
+	write_unlock_irq(&disc_data_lock);
 	if (!sp)
 		return;
=20
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 8a6c720a4cc9..dba143836753 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -811,10 +811,10 @@ static void mkiss_close(struct tty_struct *tty)
 {
 	struct mkiss *ax;
=20
-	write_lock_bh(&disc_data_lock);
+	write_lock_irq(&disc_data_lock);
 	ax =3D tty->disc_data;
 	tty->disc_data =3D NULL;
-	write_unlock_bh(&disc_data_lock);
+	write_unlock_irq(&disc_data_lock);
=20
 	if (!ax)
 		return;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9493690885cf..02efd2775dcf 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -345,10 +345,11 @@ static int macvlan_queue_xmit(struct sk_buff *skb, st=
ruct net_device *dev)
 	const struct macvlan_dev *dest;
=20
 	if (vlan->mode =3D=3D MACVLAN_MODE_BRIDGE) {
-		const struct ethhdr *eth =3D (void *)skb->data;
+		const struct ethhdr *eth =3D skb_eth_hdr(skb);
=20
 		/* send to other bridge ports directly */
 		if (is_multicast_ether_addr(eth->h_dest)) {
+			skb_reset_mac_header(skb);
 			macvlan_broadcast(skb, port, dev, MACVLAN_MODE_BRIDGE);
 			goto xmit_world;
 		}
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 3780c4672bfa..65df455c056e 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -452,9 +452,16 @@ static void slip_transmit(struct work_struct *work)
  */
 static void slip_write_wakeup(struct tty_struct *tty)
 {
-	struct slip *sl =3D tty->disc_data;
+	struct slip *sl;
+
+	rcu_read_lock();
+	sl =3D rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;
=20
 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }
=20
 static void sl_tx_timeout(struct net_device *dev)
@@ -885,10 +892,11 @@ static void slip_close(struct tty_struct *tty)
 		return;
=20
 	spin_lock_bh(&sl->lock);
-	tty->disc_data =3D NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty =3D NULL;
 	spin_unlock_bh(&sl->lock);
=20
+	synchronize_rcu();
 	flush_work(&sl->tx_work);
=20
 	/* VSV =3D very important to remove timers */
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6fa1d2c9c556..714beecd16ef 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3425,6 +3425,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
=20
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3)
+		return -ENODEV;
+
 	usb_reset_device(udev);
 	netdev =3D alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 73874090cf42..78f3e8612bab 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1904,7 +1904,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struc=
t net_device *dev,
 			return;
 		}
=20
-		tos =3D ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos =3D ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl =3D ttl ? : ip4_dst_hoplimit(&rt->dst);
=20
 		err =3D vxlan_xmit_skb(vxlan->vn_sock, rt, skb,
@@ -1929,7 +1929,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struc=
t net_device *dev,
 		fl6.saddr =3D vxlan->saddr.sin6.sin6_addr;
 		fl6.flowi6_proto =3D IPPROTO_UDP;
=20
-		if (ipv6_stub->ipv6_dst_lookup(sk, &ndst, &fl6)) {
+		ndst =3D ipv6_stub->ipv6_dst_lookup_flow(sk, &fl6, NULL);
+		if (unlikely(IS_ERR(ndst))) {
 			netdev_dbg(dev, "no route to %pI6\n",
 				   &dst->sin6.sin6_addr);
 			dev->stats.tx_carrier_errors++;
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/lib=
ertas/cfg.c
index 47a998d8f99e..390541173138 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -272,6 +272,10 @@ add_ie_rates(u8 *tlv, const u8 *ie, int *nrates)
 	int hw, ap, ap_max =3D ie[1];
 	u8 hw_rate;
=20
+	if (ap_max > MAX_RATES) {
+		lbs_deb_assoc("invalid rates\n");
+		return tlv;
+	}
 	/* Advance past IE header */
 	ie +=3D 2;
=20
@@ -1785,6 +1789,9 @@ static int lbs_ibss_join_existing(struct lbs_private =
*priv,
 	struct cmd_ds_802_11_ad_hoc_join cmd;
 	u8 preamble =3D RADIO_PREAMBLE_SHORT;
 	int ret =3D 0;
+	int hw, i;
+	u8 rates_max;
+	u8 *rates;
=20
 	lbs_deb_enter(LBS_DEB_CFG80211);
=20
@@ -1845,9 +1852,14 @@ static int lbs_ibss_join_existing(struct lbs_private=
 *priv,
 	if (!rates_eid) {
 		lbs_add_rates(cmd.bss.rates);
 	} else {
-		int hw, i;
-		u8 rates_max =3D rates_eid[1];
-		u8 *rates =3D cmd.bss.rates;
+		rates_max =3D rates_eid[1];
+		if (rates_max > MAX_RATES) {
+			lbs_deb_join("invalid rates");
+			rcu_read_unlock();
+			ret =3D -EINVAL;
+			goto out;
+		}
+		rates =3D cmd.bss.rates;
 		for (hw =3D 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
 			u8 hw_rate =3D lbs_rates[hw].bitrate / 5;
 			for (i =3D 0; i < rates_max; i++) {
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireles=
s/mwifiex/sta_ioctl.c
index 5326a0095601..501505f2e3c7 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -226,6 +226,7 @@ static int mwifiex_process_country_ie(struct mwifiex_pr=
ivate *priv,
=20
 	if (country_ie_len >
 	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		rcu_read_unlock();
 		wiphy_dbg(priv->wdev->wiphy,
 			  "11D: country_ie_len overflow!, deauth AP\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwi=
fiex/tdls.c
index 0e88364e0c67..bc374d8825b7 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -847,57 +847,117 @@ void mwifiex_process_tdls_action_frame(struct mwifie=
x_private *priv,
=20
 		switch (*pos) {
 		case WLAN_EID_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			sta_ptr->tdls_cap.rates_len =3D pos[1];
 			for (i =3D 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[i] =3D pos[i + 2];
 			break;
=20
 		case WLAN_EID_EXT_SUPP_RATES:
+			if (pos[1] > 32)
+				return;
 			basic =3D sta_ptr->tdls_cap.rates_len;
+			if (pos[1] > 32 - basic)
+				return;
 			for (i =3D 0; i < pos[1]; i++)
 				sta_ptr->tdls_cap.rates[basic + i] =3D pos[i + 2];
 			sta_ptr->tdls_cap.rates_len +=3D pos[1];
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,
+			if (pos > end - sizeof(struct ieee80211_ht_cap) - 2)
+				return;
+			if (pos[1] !=3D sizeof(struct ieee80211_ht_cap))
+				return;
+			/* copy the ie's value into ht_capb*/
+			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos + 2,
 			       sizeof(struct ieee80211_ht_cap));
 			sta_ptr->is_11n_enabled =3D 1;
 			break;
 		case WLAN_EID_HT_OPERATION:
-			memcpy(&sta_ptr->tdls_cap.ht_oper, pos,
+			if (pos > end -
+			    sizeof(struct ieee80211_ht_operation) - 2)
+				return;
+			if (pos[1] !=3D sizeof(struct ieee80211_ht_operation))
+				return;
+			/* copy the ie's value into ht_oper*/
+			memcpy(&sta_ptr->tdls_cap.ht_oper, pos + 2,
 			       sizeof(struct ieee80211_ht_operation));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
+			if (pos > end - 3)
+				return;
+			if (pos[1] !=3D 1)
+				return;
 			sta_ptr->tdls_cap.coex_2040 =3D pos[2];
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
+			if (pos > end - sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] < sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] > 8)
+				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
 			       sizeof(struct ieee_types_header) +
 			       min_t(u8, pos[1], 8));
 			break;
 		case WLAN_EID_RSN:
+			if (pos > end - sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] < sizeof(struct ieee_types_header))
+				return;
+			if (pos[1] > IEEE_MAX_IE_SIZE -
+			    sizeof(struct ieee_types_header))
+				return;
 			memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
-			       sizeof(struct ieee_types_header) + pos[1]);
+			       sizeof(struct ieee_types_header) +
+			       min_t(u8, pos[1], IEEE_MAX_IE_SIZE -
+				     sizeof(struct ieee_types_header)));
 			break;
 		case WLAN_EID_QOS_CAPA:
+			if (pos > end - 3)
+				return;
+			if (pos[1] !=3D 1)
+				return;
 			sta_ptr->tdls_cap.qos_info =3D pos[2];
 			break;
 		case WLAN_EID_VHT_OPERATION:
-			if (priv->adapter->is_hw_11ac_capable)
-				memcpy(&sta_ptr->tdls_cap.vhtoper, pos,
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end -
+				    sizeof(struct ieee80211_vht_operation) - 2)
+					return;
+				if (pos[1] !=3D
+				    sizeof(struct ieee80211_vht_operation))
+					return;
+				/* copy the ie's value into vhtoper*/
+				memcpy(&sta_ptr->tdls_cap.vhtoper, pos + 2,
 				       sizeof(struct ieee80211_vht_operation));
+			}
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
 			if (priv->adapter->is_hw_11ac_capable) {
-				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos,
+				if (pos > end -
+				    sizeof(struct ieee80211_vht_cap) - 2)
+					return;
+				if (pos[1] !=3D sizeof(struct ieee80211_vht_cap))
+					return;
+				/* copy the ie's value into vhtcap*/
+				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos + 2,
 				       sizeof(struct ieee80211_vht_cap));
 				sta_ptr->is_11ac_enabled =3D 1;
 			}
 			break;
 		case WLAN_EID_AID:
-			if (priv->adapter->is_hw_11ac_capable)
+			if (priv->adapter->is_hw_11ac_capable) {
+				if (pos > end - 4)
+					return;
+				if (pos[1] !=3D 2)
+					return;
 				sta_ptr->tdls_cap.aid =3D
 					      le16_to_cpu(*(__le16 *)(pos + 2));
+			}
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-b=
aytrail.c
index ecbfec9e54d9..bc9312adecf6 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -44,6 +44,7 @@
=20
 /* BYT_CONF0_REG register bits */
 #define BYT_IODEN		BIT(31)
+#define BYT_DIRECT_IRQ_EN	BIT(27)
 #define BYT_TRIG_NEG		BIT(26)
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
@@ -139,13 +140,14 @@ struct byt_gpio {
 	struct gpio_chip		chip;
 	struct irq_domain		*domain;
 	struct platform_device		*pdev;
-	spinlock_t			lock;
 	void __iomem			*reg_base;
 	struct pinctrl_gpio_range	*range;
 };
=20
 #define to_byt_gpio(c)	container_of(c, struct byt_gpio, chip)
=20
+static DEFINE_RAW_SPINLOCK(byt_lock);
+
 static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
 				 int reg)
 {
@@ -160,42 +162,65 @@ static void __iomem *byt_gpio_reg(struct gpio_chip *c=
hip, unsigned offset,
 	return vg->reg_base + reg_offset + reg;
 }
=20
-static bool is_special_pin(struct byt_gpio *vg, unsigned offset)
+static void byt_gpio_clear_triggering(struct byt_gpio *vg, unsigned offset)
+{
+	void __iomem *reg =3D byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
+	unsigned long flags;
+	u32 value;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
+	value =3D readl(reg);
+	value &=3D ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+	writel(value, reg);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
+}
+
+static u32 byt_get_gpio_mux(struct byt_gpio *vg, unsigned offset)
 {
 	/* SCORE pin 92-93 */
 	if (!strcmp(vg->range->name, BYT_SCORE_ACPI_UID) &&
 		offset >=3D 92 && offset <=3D 93)
-		return true;
+		return 1;
=20
 	/* SUS pin 11-21 */
 	if (!strcmp(vg->range->name, BYT_SUS_ACPI_UID) &&
 		offset >=3D 11 && offset <=3D 21)
-		return true;
+		return 1;
=20
-	return false;
+	return 0;
 }
=20
 static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct byt_gpio *vg =3D to_byt_gpio(chip);
 	void __iomem *reg =3D byt_gpio_reg(chip, offset, BYT_CONF0_REG);
-	u32 value;
-	bool special;
+	u32 value, gpio_mux;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
=20
 	/*
 	 * In most cases, func pin mux 000 means GPIO function.
 	 * But, some pins may have func pin mux 001 represents
-	 * GPIO function. Only allow user to export pin with
-	 * func pin mux preset as GPIO function by BIOS/FW.
+	 * GPIO function.
+	 *
+	 * Because there are devices out there where some pins were not
+	 * configured correctly we allow changing the mux value from
+	 * request (but print out warning about that).
 	 */
 	value =3D readl(reg) & BYT_PIN_MUX;
-	special =3D is_special_pin(vg, offset);
-	if ((special && value !=3D 1) || (!special && value)) {
-		dev_err(&vg->pdev->dev,
-			"pin %u cannot be used as GPIO.\n", offset);
-		return -EINVAL;
+	gpio_mux =3D byt_get_gpio_mux(vg, offset);
+	if (WARN_ON(gpio_mux !=3D value)) {
+		value =3D readl(reg) & ~BYT_PIN_MUX;
+		value |=3D gpio_mux;
+		writel(value, reg);
+
+		dev_warn(&vg->pdev->dev,
+			 "pin %u forcibly re-configured as GPIO\n", offset);
 	}
=20
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
+
 	pm_runtime_get(&vg->pdev->dev);
=20
 	return 0;
@@ -204,14 +229,8 @@ static int byt_gpio_request(struct gpio_chip *chip, un=
signed offset)
 static void byt_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	struct byt_gpio *vg =3D to_byt_gpio(chip);
-	void __iomem *reg =3D byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
-	u32 value;
-
-	/* clear interrupt triggering */
-	value =3D readl(reg);
-	value &=3D ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
-	writel(value, reg);
=20
+	byt_gpio_clear_triggering(vg, offset);
 	pm_runtime_put(&vg->pdev->dev);
 }
=20
@@ -226,7 +245,7 @@ static int byt_irq_type(struct irq_data *d, unsigned ty=
pe)
 	if (offset >=3D vg->chip.ngpio)
 		return -EINVAL;
=20
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value =3D readl(reg);
=20
 	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
@@ -234,24 +253,14 @@ static int byt_irq_type(struct irq_data *d, unsigned =
type)
 	 */
 	value &=3D ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
=20
-	switch (type) {
-	case IRQ_TYPE_LEVEL_HIGH:
-		value |=3D BYT_TRIG_LVL;
-	case IRQ_TYPE_EDGE_RISING:
-		value |=3D BYT_TRIG_POS;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		value |=3D BYT_TRIG_LVL;
-	case IRQ_TYPE_EDGE_FALLING:
-		value |=3D BYT_TRIG_NEG;
-		break;
-	case IRQ_TYPE_EDGE_BOTH:
-		value |=3D (BYT_TRIG_NEG | BYT_TRIG_POS);
-		break;
-	}
 	writel(value, reg);
=20
-	spin_unlock_irqrestore(&vg->lock, flags);
+	if (type & IRQ_TYPE_EDGE_BOTH)
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+	else if (type & IRQ_TYPE_LEVEL_MASK)
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 	return 0;
 }
@@ -259,17 +268,23 @@ static int byt_irq_type(struct irq_data *d, unsigned =
type)
 static int byt_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	void __iomem *reg =3D byt_gpio_reg(chip, offset, BYT_VAL_REG);
-	return readl(reg) & BYT_LEVEL;
+	unsigned long flags;
+	u32 val;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
+	val =3D readl(reg);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
+
+	return val & BYT_LEVEL;
 }
=20
 static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int valu=
e)
 {
-	struct byt_gpio *vg =3D to_byt_gpio(chip);
 	void __iomem *reg =3D byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 old_val;
=20
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
=20
 	old_val =3D readl(reg);
=20
@@ -278,23 +293,22 @@ static void byt_gpio_set(struct gpio_chip *chip, unsi=
gned offset, int value)
 	else
 		writel(old_val & ~BYT_LEVEL, reg);
=20
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offse=
t)
 {
-	struct byt_gpio *vg =3D to_byt_gpio(chip);
 	void __iomem *reg =3D byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 value;
=20
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
=20
 	value =3D readl(reg) | BYT_DIR_MASK;
 	value &=3D ~BYT_INPUT_EN;		/* active low */
 	writel(value, reg);
=20
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 	return 0;
 }
@@ -302,12 +316,11 @@ static int byt_gpio_direction_input(struct gpio_chip =
*chip, unsigned offset)
 static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned gpio, int value)
 {
-	struct byt_gpio *vg =3D to_byt_gpio(chip);
 	void __iomem *reg =3D byt_gpio_reg(chip, gpio, BYT_VAL_REG);
 	unsigned long flags;
 	u32 reg_val;
=20
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
=20
 	reg_val =3D readl(reg) | BYT_DIR_MASK;
 	reg_val &=3D ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
@@ -317,7 +330,7 @@ static int byt_gpio_direction_output(struct gpio_chip *=
chip,
 	else
 		writel(reg_val & ~BYT_LEVEL, reg);
=20
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
=20
 	return 0;
 }
@@ -329,7 +342,7 @@ static void byt_gpio_dbg_show(struct seq_file *s, struc=
t gpio_chip *chip)
 	unsigned long flags;
 	u32 conf0, val, offs;
=20
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
=20
 	for (i =3D 0; i < vg->chip.ngpio; i++) {
 		const char *pull_str =3D NULL;
@@ -390,7 +403,7 @@ static void byt_gpio_dbg_show(struct seq_file *s, struc=
t gpio_chip *chip)
=20
 		seq_puts(s, "\n");
 	}
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static int byt_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -404,54 +417,77 @@ static void byt_gpio_irq_handler(unsigned irq, struct=
 irq_desc *desc)
 	struct irq_data *data =3D irq_desc_get_irq_data(desc);
 	struct byt_gpio *vg =3D irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip =3D irq_data_get_irq_chip(data);
-	u32 base, pin, mask;
+	u32 base, pin;
 	void __iomem *reg;
-	u32 pending;
+	unsigned long pending;
 	unsigned virq;
-	int looplimit =3D 0;
=20
 	/* check from GPIO controller which pin triggered the interrupt */
 	for (base =3D 0; base < vg->chip.ngpio; base +=3D 32) {
-
 		reg =3D byt_gpio_reg(&vg->chip, base, BYT_INT_STAT_REG);
-
-		while ((pending =3D readl(reg))) {
-			pin =3D __ffs(pending);
-			mask =3D BIT(pin);
-			/* Clear before handling so we can't lose an edge */
-			writel(mask, reg);
-
+		pending =3D readl(reg);
+		for_each_set_bit(pin, &pending, 32) {
 			virq =3D irq_find_mapping(vg->domain, base + pin);
 			generic_handle_irq(virq);
-
-			/* In case bios or user sets triggering incorretly a pin
-			 * might remain in "interrupt triggered" state.
-			 */
-			if (looplimit++ > 32) {
-				dev_err(&vg->pdev->dev,
-					"Gpio %d interrupt flood, disabling\n",
-					base + pin);
-
-				reg =3D byt_gpio_reg(&vg->chip, base + pin,
-						   BYT_CONF0_REG);
-				mask =3D readl(reg);
-				mask &=3D ~(BYT_TRIG_NEG | BYT_TRIG_POS |
-					  BYT_TRIG_LVL);
-				writel(mask, reg);
-				mask =3D readl(reg); /* flush */
-				break;
-			}
 		}
 	}
 	chip->irq_eoi(data);
 }
=20
+static void byt_irq_ack(struct irq_data *d)
+{
+	struct gpio_chip *gc =3D irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg =3D to_byt_gpio(gc);
+	unsigned offset =3D irqd_to_hwirq(d);
+	void __iomem *reg;
+
+	raw_spin_lock(&byt_lock);
+	reg =3D byt_gpio_reg(&vg->chip, offset, BYT_INT_STAT_REG);
+	writel(BIT(offset % 32), reg);
+	raw_spin_unlock(&byt_lock);
+}
+
 static void byt_irq_unmask(struct irq_data *d)
 {
+	struct gpio_chip *gc =3D irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg =3D to_byt_gpio(gc);
+	unsigned offset =3D irqd_to_hwirq(d);
+	unsigned long flags;
+	void __iomem *reg;
+	u32 value;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
+	reg =3D byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
+	value =3D readl(reg);
+
+	switch (irqd_get_trigger_type(d)) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		value |=3D BYT_TRIG_LVL;
+	case IRQ_TYPE_EDGE_RISING:
+		value |=3D BYT_TRIG_POS;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		value |=3D BYT_TRIG_LVL;
+	case IRQ_TYPE_EDGE_FALLING:
+		value |=3D BYT_TRIG_NEG;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		value |=3D (BYT_TRIG_NEG | BYT_TRIG_POS);
+		break;
+	}
+
+	writel(value, reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
=20
 static void byt_irq_mask(struct irq_data *d)
 {
+	struct gpio_chip *gc =3D irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg =3D to_byt_gpio(gc);
+
+	byt_gpio_clear_triggering(vg, irqd_to_hwirq(d));
 }
=20
 static int byt_irq_reqres(struct irq_data *d)
@@ -476,6 +512,7 @@ static void byt_irq_relres(struct irq_data *d)
=20
 static struct irq_chip byt_irqchip =3D {
 	.name =3D "BYT-GPIO",
+	.irq_ack =3D byt_irq_ack,
 	.irq_mask =3D byt_irq_mask,
 	.irq_unmask =3D byt_irq_unmask,
 	.irq_set_type =3D byt_irq_type,
@@ -487,6 +524,21 @@ static void byt_gpio_irq_init_hw(struct byt_gpio *vg)
 {
 	void __iomem *reg;
 	u32 base, value;
+	int i;
+
+	/*
+	 * Clear interrupt triggers for all pins that are GPIOs and
+	 * do not use direct IRQ mode. This will prevent spurious
+	 * interrupts from misconfigured pins.
+	 */
+	for (i =3D 0; i < vg->chip.ngpio; i++) {
+		value =3D readl(byt_gpio_reg(&vg->chip, i, BYT_CONF0_REG));
+		if ((value & BYT_PIN_MUX) =3D=3D byt_get_gpio_mux(vg, i) &&
+		    !(value & BYT_DIRECT_IRQ_EN)) {
+			byt_gpio_clear_triggering(vg, i);
+			dev_dbg(&vg->pdev->dev, "disabling GPIO %d\n", i);
+		}
+	}
=20
 	/* clear interrupt status trigger registers */
 	for (base =3D 0; base < vg->chip.ngpio; base +=3D 32) {
@@ -558,8 +610,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(vg->reg_base))
 		return PTR_ERR(vg->reg_base);
=20
-	spin_lock_init(&vg->lock);
-
 	gc =3D &vg->chip;
 	gc->label =3D dev_name(&pdev->dev);
 	gc->owner =3D THIS_MODULE;
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wm=
i.c
index 3c6ccedc82b6..53329896837f 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -386,13 +386,7 @@ static void kbd_led_update(struct work_struct *work)
=20
 	asus =3D container_of(work, struct asus_wmi, kbd_led_work);
=20
-	/*
-	 * bits 0-2: level
-	 * bit 7: light on/off
-	 */
-	if (asus->kbd_led_wk > 0)
-		ctrl_param =3D 0x80 | (asus->kbd_led_wk & 0x7F);
-
+	ctrl_param =3D 0x80 | (asus->kbd_led_wk & 0x7F);
 	asus_wmi_set_devstate(ASUS_WMI_DEVID_KBD_BACKLIGHT, ctrl_param, NULL);
 }
=20
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index d5f86dbf6dd6..7129e40e2788 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -309,7 +309,7 @@ static int __init hp_wmi_bios_2008_later(void)
=20
 static int __init hp_wmi_bios_2009_later(void)
 {
-	int state =3D 0;
+	u8 state[128];
 	int ret =3D hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, 0, &state,
 				       sizeof(state), sizeof(state));
 	if (!ret)
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 296b0ec8744d..c72ee5966733 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -167,10 +167,11 @@ static struct posix_clock_operations ptp_clock_ops =
=3D {
 	.read		=3D ptp_read,
 };
=20
-static void delete_ptp_clock(struct posix_clock *pc)
+static void ptp_clock_release(struct device *dev)
 {
-	struct ptp_clock *ptp =3D container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp =3D container_of(dev, struct ptp_clock, dev);
=20
+	ptp_cleanup_pin_groups(ptp);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	ida_simple_remove(&ptp_clocks_map, ptp->index);
@@ -201,7 +202,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_i=
nfo *info,
 	}
=20
 	ptp->clock.ops =3D ptp_clock_ops;
-	ptp->clock.release =3D delete_ptp_clock;
 	ptp->info =3D info;
 	ptp->devid =3D MKDEV(major, index);
 	ptp->index =3D index;
@@ -210,17 +210,9 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_=
info *info,
 	mutex_init(&ptp->pincfg_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
=20
-	/* Create a new device in our class. */
-	ptp->dev =3D device_create(ptp_class, parent, ptp->devid, ptp,
-				 "ptp%d", ptp->index);
-	if (IS_ERR(ptp->dev))
-		goto no_device;
-
-	dev_set_drvdata(ptp->dev, ptp);
-
-	err =3D ptp_populate_sysfs(ptp);
+	err =3D ptp_populate_pin_groups(ptp);
 	if (err)
-		goto no_sysfs;
+		goto no_pin_groups;
=20
 	/* Register a new PPS source. */
 	if (info->pps) {
@@ -231,13 +223,24 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock=
_info *info,
 		pps.owner =3D info->owner;
 		ptp->pps_source =3D pps_register_source(&pps, PTP_PPS_DEFAULTS);
 		if (!ptp->pps_source) {
+			err =3D -EINVAL;
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}
 	}
=20
-	/* Create a posix clock. */
-	err =3D posix_clock_register(&ptp->clock, ptp->devid);
+	/* Initialize a new device of our class in our clock structure. */
+	device_initialize(&ptp->dev);
+	ptp->dev.devt =3D ptp->devid;
+	ptp->dev.class =3D ptp_class;
+	ptp->dev.parent =3D parent;
+	ptp->dev.groups =3D ptp->pin_attr_groups;
+	ptp->dev.release =3D ptp_clock_release;
+	dev_set_drvdata(&ptp->dev, ptp);
+	dev_set_name(&ptp->dev, "ptp%d", ptp->index);
+
+	/* Create a posix clock and link it to the device. */
+	err =3D posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
 		pr_err("failed to create posix clock\n");
 		goto no_clock;
@@ -249,10 +252,8 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_=
info *info,
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 no_pps:
-	ptp_cleanup_sysfs(ptp);
-no_sysfs:
-	device_destroy(ptp_class, ptp->devid);
-no_device:
+	ptp_cleanup_pin_groups(ptp);
+no_pin_groups:
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 no_slot:
@@ -270,10 +271,9 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	/* Release the clock's resources. */
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
-	ptp_cleanup_sysfs(ptp);
-	device_destroy(ptp_class, ptp->devid);
=20
 	posix_clock_unregister(&ptp->clock);
+
 	return 0;
 }
 EXPORT_SYMBOL(ptp_clock_unregister);
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 9c5d41421b65..15346e840caa 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -40,7 +40,7 @@ struct timestamp_event_queue {
=20
 struct ptp_clock {
 	struct posix_clock clock;
-	struct device *dev;
+	struct device dev;
 	struct ptp_clock_info *info;
 	dev_t devid;
 	int index; /* index into clocks.map */
@@ -54,6 +54,8 @@ struct ptp_clock {
 	struct device_attribute *pin_dev_attr;
 	struct attribute **pin_attr;
 	struct attribute_group pin_attr_group;
+	/* 1st entry is a pointer to the real group, 2nd is NULL terminator */
+	const struct attribute_group *pin_attr_groups[2];
 };
=20
 /*
@@ -94,8 +96,7 @@ uint ptp_poll(struct posix_clock *pc,
=20
 extern const struct attribute_group *ptp_groups[];
=20
-int ptp_cleanup_sysfs(struct ptp_clock *ptp);
-
-int ptp_populate_sysfs(struct ptp_clock *ptp);
+int ptp_populate_pin_groups(struct ptp_clock *ptp);
+void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
=20
 #endif
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 302e626fe6b0..731d0423c8aa 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -46,27 +46,6 @@ PTP_SHOW_INT(n_periodic_outputs, n_per_out);
 PTP_SHOW_INT(n_programmable_pins, n_pins);
 PTP_SHOW_INT(pps_available, pps);
=20
-static struct attribute *ptp_attrs[] =3D {
-	&dev_attr_clock_name.attr,
-	&dev_attr_max_adjustment.attr,
-	&dev_attr_n_alarms.attr,
-	&dev_attr_n_external_timestamps.attr,
-	&dev_attr_n_periodic_outputs.attr,
-	&dev_attr_n_programmable_pins.attr,
-	&dev_attr_pps_available.attr,
-	NULL,
-};
-
-static const struct attribute_group ptp_group =3D {
-	.attrs =3D ptp_attrs,
-};
-
-const struct attribute_group *ptp_groups[] =3D {
-	&ptp_group,
-	NULL,
-};
-
-
 static ssize_t extts_enable_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
@@ -91,6 +70,7 @@ static ssize_t extts_enable_store(struct device *dev,
 out:
 	return err;
 }
+static DEVICE_ATTR(extts_enable, 0220, NULL, extts_enable_store);
=20
 static ssize_t extts_fifo_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
@@ -124,6 +104,7 @@ static ssize_t extts_fifo_show(struct device *dev,
 	mutex_unlock(&ptp->tsevq_mux);
 	return cnt;
 }
+static DEVICE_ATTR(fifo, 0444, extts_fifo_show, NULL);
=20
 static ssize_t period_store(struct device *dev,
 			    struct device_attribute *attr,
@@ -151,6 +132,7 @@ static ssize_t period_store(struct device *dev,
 out:
 	return err;
 }
+static DEVICE_ATTR(period, 0220, NULL, period_store);
=20
 static ssize_t pps_enable_store(struct device *dev,
 				struct device_attribute *attr,
@@ -177,6 +159,57 @@ static ssize_t pps_enable_store(struct device *dev,
 out:
 	return err;
 }
+static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
+
+static struct attribute *ptp_attrs[] =3D {
+	&dev_attr_clock_name.attr,
+
+	&dev_attr_max_adjustment.attr,
+	&dev_attr_n_alarms.attr,
+	&dev_attr_n_external_timestamps.attr,
+	&dev_attr_n_periodic_outputs.attr,
+	&dev_attr_n_programmable_pins.attr,
+	&dev_attr_pps_available.attr,
+
+	&dev_attr_extts_enable.attr,
+	&dev_attr_fifo.attr,
+	&dev_attr_period.attr,
+	&dev_attr_pps_enable.attr,
+	NULL
+};
+
+static umode_t ptp_is_attribute_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	struct device *dev =3D kobj_to_dev(kobj);
+	struct ptp_clock *ptp =3D dev_get_drvdata(dev);
+	struct ptp_clock_info *info =3D ptp->info;
+	umode_t mode =3D attr->mode;
+
+	if (attr =3D=3D &dev_attr_extts_enable.attr ||
+	    attr =3D=3D &dev_attr_fifo.attr) {
+		if (!info->n_ext_ts)
+			mode =3D 0;
+	} else if (attr =3D=3D &dev_attr_period.attr) {
+		if (!info->n_per_out)
+			mode =3D 0;
+	} else if (attr =3D=3D &dev_attr_pps_enable.attr) {
+		if (!info->pps)
+			mode =3D 0;
+	}
+
+	return mode;
+}
+
+static const struct attribute_group ptp_group =3D {
+	.is_visible	=3D ptp_is_attribute_visible,
+	.attrs		=3D ptp_attrs,
+};
+
+const struct attribute_group *ptp_groups[] =3D {
+	&ptp_group,
+	NULL
+};
=20
 static int ptp_pin_name2index(struct ptp_clock *ptp, const char *name)
 {
@@ -235,40 +268,14 @@ static ssize_t ptp_pin_store(struct device *dev, stru=
ct device_attribute *attr,
 	return count;
 }
=20
-static DEVICE_ATTR(extts_enable, 0220, NULL, extts_enable_store);
-static DEVICE_ATTR(fifo,         0444, extts_fifo_show, NULL);
-static DEVICE_ATTR(period,       0220, NULL, period_store);
-static DEVICE_ATTR(pps_enable,   0220, NULL, pps_enable_store);
-
-int ptp_cleanup_sysfs(struct ptp_clock *ptp)
+int ptp_populate_pin_groups(struct ptp_clock *ptp)
 {
-	struct device *dev =3D ptp->dev;
-	struct ptp_clock_info *info =3D ptp->info;
-
-	if (info->n_ext_ts) {
-		device_remove_file(dev, &dev_attr_extts_enable);
-		device_remove_file(dev, &dev_attr_fifo);
-	}
-	if (info->n_per_out)
-		device_remove_file(dev, &dev_attr_period);
-
-	if (info->pps)
-		device_remove_file(dev, &dev_attr_pps_enable);
-
-	if (info->n_pins) {
-		sysfs_remove_group(&dev->kobj, &ptp->pin_attr_group);
-		kfree(ptp->pin_attr);
-		kfree(ptp->pin_dev_attr);
-	}
-	return 0;
-}
-
-static int ptp_populate_pins(struct ptp_clock *ptp)
-{
-	struct device *dev =3D ptp->dev;
 	struct ptp_clock_info *info =3D ptp->info;
 	int err =3D -ENOMEM, i, n_pins =3D info->n_pins;
=20
+	if (!n_pins)
+		return 0;
+
 	ptp->pin_dev_attr =3D kzalloc(n_pins * sizeof(*ptp->pin_dev_attr),
 				    GFP_KERNEL);
 	if (!ptp->pin_dev_attr)
@@ -292,61 +299,18 @@ static int ptp_populate_pins(struct ptp_clock *ptp)
 	ptp->pin_attr_group.name =3D "pins";
 	ptp->pin_attr_group.attrs =3D ptp->pin_attr;
=20
-	err =3D sysfs_create_group(&dev->kobj, &ptp->pin_attr_group);
-	if (err)
-		goto no_group;
+	ptp->pin_attr_groups[0] =3D &ptp->pin_attr_group;
+
 	return 0;
=20
-no_group:
-	kfree(ptp->pin_attr);
 no_pin_attr:
 	kfree(ptp->pin_dev_attr);
 no_dev_attr:
 	return err;
 }
=20
-int ptp_populate_sysfs(struct ptp_clock *ptp)
+void ptp_cleanup_pin_groups(struct ptp_clock *ptp)
 {
-	struct device *dev =3D ptp->dev;
-	struct ptp_clock_info *info =3D ptp->info;
-	int err;
-
-	if (info->n_ext_ts) {
-		err =3D device_create_file(dev, &dev_attr_extts_enable);
-		if (err)
-			goto out1;
-		err =3D device_create_file(dev, &dev_attr_fifo);
-		if (err)
-			goto out2;
-	}
-	if (info->n_per_out) {
-		err =3D device_create_file(dev, &dev_attr_period);
-		if (err)
-			goto out3;
-	}
-	if (info->pps) {
-		err =3D device_create_file(dev, &dev_attr_pps_enable);
-		if (err)
-			goto out4;
-	}
-	if (info->n_pins) {
-		err =3D ptp_populate_pins(ptp);
-		if (err)
-			goto out5;
-	}
-	return 0;
-out5:
-	if (info->pps)
-		device_remove_file(dev, &dev_attr_pps_enable);
-out4:
-	if (info->n_per_out)
-		device_remove_file(dev, &dev_attr_period);
-out3:
-	if (info->n_ext_ts)
-		device_remove_file(dev, &dev_attr_fifo);
-out2:
-	if (info->n_ext_ts)
-		device_remove_file(dev, &dev_attr_extts_enable);
-out1:
-	return err;
+	kfree(ptp->pin_attr);
+	kfree(ptp->pin_dev_attr);
 }
diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 9795d6f3e197..4532ef9b46de 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -445,26 +445,26 @@ int vnic_dev_soft_reset_done(struct vnic_dev *vdev, i=
nt *done)
=20
 int vnic_dev_hang_notify(struct vnic_dev *vdev)
 {
-	u64 a0, a1;
+	u64 a0 =3D 0, a1 =3D 0;
 	int wait =3D 1000;
 	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
 }
=20
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a0, a1;
+	u64 a[2] =3D {};
 	int wait =3D 1000;
 	int err, i;
=20
 	for (i =3D 0; i < ETH_ALEN; i++)
 		mac_addr[i] =3D 0;
=20
-	err =3D vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
+	err =3D vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a[0], &a[1], wait);
 	if (err)
 		return err;
=20
 	for (i =3D 0; i < ETH_ALEN; i++)
-		mac_addr[i] =3D ((u8 *)&a0)[i];
+		mac_addr[i] =3D ((u8 *)&a)[i];
=20
 	return 0;
 }
@@ -489,15 +489,15 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, in=
t directed, int multicast,
=20
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 =3D 0, a1 =3D 0;
+	u64 a[2] =3D {};
 	int wait =3D 1000;
 	int err;
 	int i;
=20
 	for (i =3D 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] =3D addr[i];
+		((u8 *)&a)[i] =3D addr[i];
=20
-	err =3D vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
+	err =3D vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a[0], &a[1], wait);
 	if (err)
 		printk(KERN_ERR
 			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
@@ -507,15 +507,15 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *add=
r)
=20
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 =3D 0, a1 =3D 0;
+	u64 a[2] =3D {};
 	int wait =3D 1000;
 	int err;
 	int i;
=20
 	for (i =3D 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] =3D addr[i];
+		((u8 *)&a)[i] =3D addr[i];
=20
-	err =3D vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
+	err =3D vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a[0], &a[1], wait);
 	if (err)
 		printk(KERN_ERR
 			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 91bceca76aa9..dc7c7c17b272 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4269,7 +4269,6 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 	return QLA_SUCCESS;
=20
 mem_alloc_error_exit:
-	qla4xxx_mem_free(ha);
 	return QLA_ERROR;
 }
=20
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2fcda75ef688..34bfd7ebc664 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1910,8 +1910,10 @@ static int sd_read_protection_type(struct scsi_disk =
*sdkp, unsigned char *buffer
 	u8 type;
 	int ret =3D 0;
=20
-	if (scsi_device_protection(sdp) =3D=3D 0 || (buffer[12] & 1) =3D=3D 0)
+	if (scsi_device_protection(sdp) =3D=3D 0 || (buffer[12] & 1) =3D=3D 0) {
+		sdkp->protection_type =3D 0;
 		return ret;
+	}
=20
 	type =3D ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 =3D Type 1 */
=20
diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ash=
mem.c
index 5dbc68da8727..610981e49b51 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -351,8 +351,23 @@ static inline vm_flags_t calc_vm_may_flags(unsigned lo=
ng prot)
 	       _calc_vm_trans(prot, PROT_EXEC,  VM_MAYEXEC);
 }
=20
+static int ashmem_vmfile_mmap(struct file *file, struct vm_area_struct *vm=
a)
+{
+	/* do not allow to mmap ashmem backing shmem file directly */
+	return -EPERM;
+}
+
+static unsigned long
+ashmem_vmfile_get_unmapped_area(struct file *file, unsigned long addr,
+				unsigned long len, unsigned long pgoff,
+				unsigned long flags)
+{
+	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
 static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	static struct file_operations vmfile_fops;
 	struct ashmem_area *asma =3D file->private_data;
 	int ret =3D 0;
=20
@@ -386,6 +401,19 @@ static int ashmem_mmap(struct file *file, struct vm_ar=
ea_struct *vma)
 			goto out;
 		}
 		asma->file =3D vmfile;
+		/*
+		 * override mmap operation of the vmfile so that it can't be
+		 * remapped which would lead to creation of a new vma with no
+		 * asma permission checks. Have to override get_unmapped_area
+		 * as well to prevent VM_BUG_ON check for f_ops modification.
+		 */
+		if (!vmfile_fops.mmap) {
+			vmfile_fops =3D *vmfile->f_op;
+			vmfile_fops.mmap =3D ashmem_vmfile_mmap;
+			vmfile_fops.get_unmapped_area =3D
+					ashmem_vmfile_get_unmapped_area;
+		}
+		vmfile->f_op =3D &vmfile_fops;
 	}
 	get_file(asma->file);
=20
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/=
rtl8188eu/os_dep/usb_intf.c
index 1000e87faa73..df88448d1eaa 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -61,6 +61,7 @@ static struct usb_device_id rtw_usb_id_tbl[] =3D {
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
 	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
+	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */
@@ -141,7 +142,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_int=
erface *usb_intf)
 	phost_conf =3D pusbd->actconfig;
 	pconf_desc =3D &phost_conf->desc;
=20
-	phost_iface =3D &usb_intf->altsetting[0];
+	phost_iface =3D usb_intf->cur_altsetting;
 	piface_desc =3D &phost_iface->desc;
=20
 	pdvobjpriv->NumInterfaces =3D pconf_desc->bNumInterfaces;
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/u=
sb_intf.c
index 22a28becf275..af79582dbc28 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -269,7 +269,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padap=
ter)
 	pdev_desc =3D &pusbd->descriptor;
 	phost_conf =3D pusbd->actconfig;
 	pconf_desc =3D &phost_conf->desc;
-	phost_iface =3D &pintf->altsetting[0];
+	phost_iface =3D pintf->cur_altsetting;
 	piface_desc =3D &phost_iface->desc;
 	pdvobjpriv->nr_endpoint =3D piface_desc->bNumEndpoints;
 	if (pusbd->speed =3D=3D USB_SPEED_HIGH) {
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_r=
x.c
index d573917f998c..d9e0c76ead6e 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -88,16 +88,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vd=
ev,
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
=20
 	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
+	if (usbip_recv_xbuff(ud, urb) < 0) {
+		urb->status =3D -EPROTO;
+		goto error;
+	}
=20
 	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
+	if (usbip_recv_iso(ud, urb) < 0) {
+		urb->status =3D -EPROTO;
+		goto error;
+	}
=20
 	/* restore the padding in iso packets */
 	usbip_pad_iso(ud, urb);
=20
+error:
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
=20
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_seria=
l.c
index 1c438396c630..15bf626abd8b 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -857,6 +857,7 @@ static void msm_console_write(struct console *co, const=
 char *s,
 	struct msm_port *msm_port;
 	int num_newlines =3D 0;
 	bool replaced =3D false;
+	int locked =3D 1;
=20
 	BUG_ON(co->index < 0 || co->index >=3D UART_NR);
=20
@@ -869,7 +870,13 @@ static void msm_console_write(struct console *co, cons=
t char *s,
 			num_newlines++;
 	count +=3D num_newlines;
=20
-	spin_lock(&port->lock);
+	if (port->sysrq)
+		locked =3D 0;
+	else if (oops_in_progress)
+		locked =3D spin_trylock(&port->lock);
+	else
+		spin_lock(&port->lock);
+
 	if (msm_port->is_uartdm)
 		reset_dm_count(port, count);
=20
@@ -906,7 +913,9 @@ static void msm_console_write(struct console *co, const=
 char *s,
 		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
 		i +=3D num_chars;
 	}
-	spin_unlock(&port->lock);
+
+	if (locked)
+		spin_unlock(&port->lock);
 }
=20
 static int __init msm_console_setup(struct console *co, char *options)
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index 6b71032b8123..1726bab49e40 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2639,6 +2639,7 @@ int uart_add_one_port(struct uart_driver *drv, struct=
 uart_port *uport)
 		lockdep_set_class(&uport->lock, &port_lock_key);
 	}
=20
+	tty_port_link_device(port, drv->tty_driver, uport->line);
 	uart_configure_port(drv, state, uport);
=20
 	/*
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index ea27804d87af..4e0c3d95884b 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -13,6 +13,7 @@
 #include <linux/tty.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
=20
@@ -40,6 +41,7 @@ static volatile int sel_start =3D -1; 	/* cleared by clea=
r_selection */
 static int sel_end;
 static int sel_buffer_lth;
 static char *sel_buffer;
+static DEFINE_MUTEX(sel_lock);
=20
 /* clear_selection, highlight and highlight_pointer can be called
    from interrupt (via scrollback/front) */
@@ -156,14 +158,14 @@ static int store_utf8(u16 c, char *p)
  *	The entire selection process is managed under the console_lock. It's
  *	 a lot under the lock but its hardly a performance path
  */
-int set_selection(const struct tiocl_selection __user *sel, struct tty_str=
uct *tty)
+static int __set_selection(const struct tiocl_selection __user *sel, struc=
t tty_struct *tty)
 {
 	struct vc_data *vc =3D vc_cons[fg_console].d;
 	int sel_mode, new_sel_start, new_sel_end, spc;
 	char *bp, *obp;
 	int i, ps, pe, multiplier;
 	u16 c;
-	int mode;
+	int mode, ret =3D 0;
=20
 	poke_blanked_console();
=20
@@ -324,7 +326,21 @@ int set_selection(const struct tiocl_selection __user =
*sel, struct tty_struct *t
 		}
 	}
 	sel_buffer_lth =3D bp - sel_buffer;
-	return 0;
+
+	return ret;
+}
+
+int set_selection(const struct tiocl_selection __user *v, struct tty_struc=
t *tty)
+{
+	int ret;
+
+	mutex_lock(&sel_lock);
+	console_lock();
+	ret =3D __set_selection(v, tty);
+	console_unlock();
+	mutex_unlock(&sel_lock);
+
+	return ret;
 }
=20
 /* Insert the contents of the selection buffer into the
@@ -341,6 +357,7 @@ int paste_selection(struct tty_struct *tty)
 	unsigned int count;
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
+	int ret =3D 0;
=20
 	console_lock();
 	poke_blanked_console();
@@ -350,21 +367,30 @@ int paste_selection(struct tty_struct *tty)
 	tty_buffer_lock_exclusive(&vc->port);
=20
 	add_wait_queue(&vc->paste_wait, &wait);
+	mutex_lock(&sel_lock);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (signal_pending(current)) {
+			ret =3D -EINTR;
+			break;
+		}
 		if (test_bit(TTY_THROTTLED, &tty->flags)) {
+			mutex_unlock(&sel_lock);
 			schedule();
+			mutex_lock(&sel_lock);
 			continue;
 		}
+		__set_current_state(TASK_RUNNING);
 		count =3D sel_buffer_lth - pasted;
 		count =3D tty_ldisc_receive_buf(ld, sel_buffer + pasted, NULL,
 					      count);
 		pasted +=3D count;
 	}
+	mutex_unlock(&sel_lock);
 	remove_wait_queue(&vc->paste_wait, &wait);
 	__set_current_state(TASK_RUNNING);
=20
 	tty_buffer_unlock_exclusive(&vc->port);
 	tty_ldisc_deref(ld);
-	return 0;
+	return ret;
 }
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 6f5d249d454d..b9d4075ddc17 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2670,9 +2670,7 @@ int tioclinux(struct tty_struct *tty, unsigned long a=
rg)
 	switch (type)
 	{
 		case TIOCL_SETSEL:
-			console_lock();
 			ret =3D set_selection((struct tiocl_selection __user *)(p+1), tty);
-			console_unlock();
 			break;
 		case TIOCL_PASTESEL:
 			ret =3D paste_selection(tty);
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 5a459377574b..6038314056cd 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2167,10 +2167,11 @@ static void uea_intr(struct urb *urb)
 /*
  * Start the modem : init the data and start kernel thread
  */
-static int uea_boot(struct uea_softc *sc)
+static int uea_boot(struct uea_softc *sc, struct usb_interface *intf)
 {
-	int ret, size;
 	struct intr_pkt *intr;
+	int ret =3D -ENOMEM;
+	int size;
=20
 	uea_enters(INS_TO_USBDEV(sc));
=20
@@ -2195,6 +2196,11 @@ static int uea_boot(struct uea_softc *sc)
 	if (UEA_CHIP_VERSION(sc) =3D=3D ADI930)
 		load_XILINX_firmware(sc);
=20
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
+		ret =3D -ENODEV;
+		goto err0;
+	}
+
 	intr =3D kmalloc(size, GFP_KERNEL);
 	if (!intr) {
 		uea_err(INS_TO_USBDEV(sc),
@@ -2211,8 +2217,7 @@ static int uea_boot(struct uea_softc *sc)
 	usb_fill_int_urb(sc->urb_int, sc->usb_dev,
 			 usb_rcvintpipe(sc->usb_dev, UEA_INTR_PIPE),
 			 intr, size, uea_intr, sc,
-			 sc->usb_dev->actconfig->interface[0]->altsetting[0].
-			 endpoint[0].desc.bInterval);
+			 intf->cur_altsetting->endpoint[0].desc.bInterval);
=20
 	ret =3D usb_submit_urb(sc->urb_int, GFP_KERNEL);
 	if (ret < 0) {
@@ -2227,6 +2232,7 @@ static int uea_boot(struct uea_softc *sc)
 	sc->kthread =3D kthread_create(uea_kthread, sc, "ueagle-atm");
 	if (IS_ERR(sc->kthread)) {
 		uea_err(INS_TO_USBDEV(sc), "failed to create thread\n");
+		ret =3D PTR_ERR(sc->kthread);
 		goto err2;
 	}
=20
@@ -2241,7 +2247,7 @@ static int uea_boot(struct uea_softc *sc)
 	kfree(intr);
 err0:
 	uea_leaves(INS_TO_USBDEV(sc));
-	return -ENOMEM;
+	return ret;
 }
=20
 /*
@@ -2604,7 +2610,7 @@ static int uea_bind(struct usbatm_data *usbatm, struc=
t usb_interface *intf,
 	if (ret < 0)
 		goto error;
=20
-	ret =3D uea_boot(sc);
+	ret =3D uea_boot(sc, intf);
 	if (ret < 0)
 		goto error_rm_grp;
=20
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 872669da443e..4722b6a93a89 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -169,10 +169,60 @@ static const unsigned short super_speed_maxpacket_max=
es[4] =3D {
 	[USB_ENDPOINT_XFER_INT] =3D 1024,
 };
=20
-static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
-    int asnum, struct usb_host_interface *ifp, int num_ep,
-    unsigned char *buffer, int size)
+static bool endpoint_is_duplicate(struct usb_endpoint_descriptor *e1,
+		struct usb_endpoint_descriptor *e2)
 {
+	if (e1->bEndpointAddress =3D=3D e2->bEndpointAddress)
+		return true;
+
+	if (usb_endpoint_xfer_control(e1) || usb_endpoint_xfer_control(e2)) {
+		if (usb_endpoint_num(e1) =3D=3D usb_endpoint_num(e2))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check for duplicate endpoint addresses in other interfaces and in the
+ * altsetting currently being parsed.
+ */
+static bool config_endpoint_is_duplicate(struct usb_host_config *config,
+		int inum, int asnum, struct usb_endpoint_descriptor *d)
+{
+	struct usb_endpoint_descriptor *epd;
+	struct usb_interface_cache *intfc;
+	struct usb_host_interface *alt;
+	int i, j, k;
+
+	for (i =3D 0; i < config->desc.bNumInterfaces; ++i) {
+		intfc =3D config->intf_cache[i];
+
+		for (j =3D 0; j < intfc->num_altsetting; ++j) {
+			alt =3D &intfc->altsetting[j];
+
+			if (alt->desc.bInterfaceNumber =3D=3D inum &&
+					alt->desc.bAlternateSetting !=3D asnum)
+				continue;
+
+			for (k =3D 0; k < alt->desc.bNumEndpoints; ++k) {
+				epd =3D &alt->endpoint[k].desc;
+
+				if (endpoint_is_duplicate(epd, d))
+					return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static int usb_parse_endpoint(struct device *ddev, int cfgno,
+		struct usb_host_config *config, int inum, int asnum,
+		struct usb_host_interface *ifp, int num_ep,
+		unsigned char *buffer, int size)
+{
+	struct usb_device *udev =3D to_usb_device(ddev);
 	unsigned char *buffer0 =3D buffer;
 	struct usb_endpoint_descriptor *d;
 	struct usb_host_endpoint *endpoint;
@@ -208,11 +258,18 @@ static int usb_parse_endpoint(struct device *ddev, in=
t cfgno, int inum,
 		goto skip_to_next_endpoint_or_interface_descriptor;
=20
 	/* Check for duplicate endpoint addresses */
-	for (i =3D 0; i < ifp->desc.bNumEndpoints; ++i) {
-		if (ifp->endpoint[i].desc.bEndpointAddress =3D=3D
-		    d->bEndpointAddress) {
-			dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate en=
dpoint with address 0x%X, skipping\n",
-			    cfgno, inum, asnum, d->bEndpointAddress);
+	if (config_endpoint_is_duplicate(config, inum, asnum, d)) {
+		dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate end=
point with address 0x%X, skipping\n",
+				cfgno, inum, asnum, d->bEndpointAddress);
+		goto skip_to_next_endpoint_or_interface_descriptor;
+	}
+
+	/* Ignore blacklisted endpoints */
+	if (udev->quirks & USB_QUIRK_ENDPOINT_BLACKLIST) {
+		if (usb_endpoint_is_blacklisted(udev, ifp, d)) {
+			dev_warn(ddev, "config %d interface %d altsetting %d has a blacklisted =
endpoint with address 0x%X, skipping\n",
+					cfgno, inum, asnum,
+					d->bEndpointAddress);
 			goto skip_to_next_endpoint_or_interface_descriptor;
 		}
 	}
@@ -481,8 +538,8 @@ static int usb_parse_interface(struct device *ddev, int=
 cfgno,
 		if (((struct usb_descriptor_header *) buffer)->bDescriptorType
 		     =3D=3D USB_DT_INTERFACE)
 			break;
-		retval =3D usb_parse_endpoint(ddev, cfgno, inum, asnum, alt,
-		    num_ep, buffer, size);
+		retval =3D usb_parse_endpoint(ddev, cfgno, config, inum, asnum,
+				alt, num_ep, buffer, size);
 		if (retval < 0)
 			return retval;
 		++n;
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2e9e0012286b..464e4ac307a8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1125,6 +1125,7 @@ static void hub_activate(struct usb_hub *hub, enum hu=
b_activation_type type)
 			 * PORT_OVER_CURRENT is not. So check for any of them.
 			 */
 			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+			    (portchange & USB_PORT_STAT_C_CONNECTION) ||
 			    (portstatus & USB_PORT_STAT_OVERCURRENT) ||
 			    (portchange & USB_PORT_STAT_C_OVERCURRENT))
 				set_bit(port1, hub->change_bits);
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 33772a954df6..312eee48cda1 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -206,6 +206,10 @@ static const struct usb_device_id usb_quirk_list[] =3D=
 {
 	{ USB_DEVICE(0x0904, 0x6103), .driver_info =3D
 			USB_QUIRK_LINEAR_FRAME_INTR_BINTERVAL },
=20
+	/* Sound Devices USBPre2 */
+	{ USB_DEVICE(0x0926, 0x0202), .driver_info =3D
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Keytouch QWERTY Panel keyboard */
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =3D
 			USB_QUIRK_CONFIG_INTF_STRINGS },
@@ -318,6 +322,39 @@ static const struct usb_device_id usb_amd_resume_quirk=
_list[] =3D {
 	{ }  /* terminating entry must be last */
 };
=20
+/*
+ * Entries for blacklisted endpoints that should be ignored when parsing
+ * configuration descriptors.
+ *
+ * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
+ */
+static const struct usb_device_id usb_endpoint_blacklist[] =3D {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info =3D 0x85 },
+	{ }
+};
+
+bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd)
+{
+	const struct usb_device_id *id;
+	unsigned int address;
+
+	for (id =3D usb_endpoint_blacklist; id->match_flags; ++id) {
+		if (!usb_match_device(udev, id))
+			continue;
+
+		if (!usb_match_one_id_intf(udev, intf, id))
+			continue;
+
+		address =3D id->driver_info;
+		if (address =3D=3D epd->bEndpointAddress)
+			return true;
+	}
+
+	return false;
+}
+
 static bool usb_match_any_interface(struct usb_device *udev,
 				    const struct usb_device_id *id)
 {
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index ce5f13d62b64..65ffab5e9a8d 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -40,6 +40,7 @@ void usb_init_urb(struct urb *urb)
 	if (urb) {
 		memset(urb, 0, sizeof(*urb));
 		kref_init(&urb->kref);
+		INIT_LIST_HEAD(&urb->urb_list);
 		INIT_LIST_HEAD(&urb->anchor_list);
 	}
 }
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index d7ac1603826b..283de7f3840e 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -29,6 +29,9 @@ extern int usb_deauthorize_device(struct usb_device *);
 extern int usb_authorize_device(struct usb_device *);
 extern void usb_detect_quirks(struct usb_device *udev);
 extern void usb_detect_interface_quirks(struct usb_device *udev);
+extern bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd);
 extern int usb_remove_device(struct usb_device *udev);
=20
 extern int usb_get_device_descriptor(struct usb_device *dev,
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 69f27169081b..1b1ef79f02fa 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -30,6 +30,21 @@
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
 #define PCI_DEVICE_ID_INTEL_BYT		0x0f37
 #define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
+#define PCI_DEVICE_ID_INTEL_BSW		0x22B7
+#define PCI_DEVICE_ID_INTEL_SPTLP	0x9d30
+#define PCI_DEVICE_ID_INTEL_SPTH	0xa130
+#define PCI_DEVICE_ID_INTEL_BXT		0x0aaa
+#define PCI_DEVICE_ID_INTEL_BXT_M	0x1aaa
+#define PCI_DEVICE_ID_INTEL_APL		0x5aaa
+#define PCI_DEVICE_ID_INTEL_KBP		0xa2b0
+#define PCI_DEVICE_ID_INTEL_CMLLP	0x02ee
+#define PCI_DEVICE_ID_INTEL_CMLH	0x06ee
+#define PCI_DEVICE_ID_INTEL_GLK		0x31aa
+#define PCI_DEVICE_ID_INTEL_CNPLP	0x9dee
+#define PCI_DEVICE_ID_INTEL_CNPH	0xa36e
+#define PCI_DEVICE_ID_INTEL_ICLLP	0x34ee
+#define PCI_DEVICE_ID_INTEL_EHLLP	0x4b7e
+#define PCI_DEVICE_ID_INTEL_TGPLP	0xa0ee
=20
 struct dwc3_pci {
 	struct device		*dev;
@@ -183,8 +198,23 @@ static const struct pci_device_id dwc3_pci_id_table[] =
=3D {
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS,
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CMLLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CMLH), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SPTLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SPTH), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BXT), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BXT_M), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_APL), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_KBP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_GLK), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CNPH), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICLLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EHLLP), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGPLP), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 54f5332f814d..230c56d40557 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -40,6 +40,10 @@
=20
 /*------------------------------------------------------------------------=
-*/
=20
+/* PID Codes that are used here, from EHCI specification, Table 3-16. */
+#define PID_CODE_IN    1
+#define PID_CODE_SETUP 2
+
 /* fill a qtd, returning how much of the buffer we were able to queue up */
=20
 static int
@@ -199,7 +203,7 @@ static int qtd_copy_status (
 	int	status =3D -EINPROGRESS;
=20
 	/* count IN/OUT bytes, not SETUP (even short packets) */
-	if (likely (QTD_PID (token) !=3D 2))
+	if (likely(QTD_PID(token) !=3D PID_CODE_SETUP))
 		urb->actual_length +=3D length - QTD_LENGTH (token);
=20
 	/* don't modify error codes */
@@ -215,6 +219,13 @@ static int qtd_copy_status (
 		if (token & QTD_STS_BABBLE) {
 			/* FIXME "must" disable babbling device's port too */
 			status =3D -EOVERFLOW;
+		/*
+		 * When MMF is active and PID Code is IN, queue is halted.
+		 * EHCI Specification, Table 4-13.
+		 */
+		} else if ((token & QTD_STS_MMF) &&
+					(QTD_PID(token) =3D=3D PID_CODE_IN)) {
+			status =3D -EPROTO;
 		/* CERR nonzero + halt --> stall */
 		} else if (QTD_CERR(token)) {
 			status =3D -EPIPE;
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 79dabb14c2bf..d527dcebed81 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -580,7 +580,7 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 		struct xhci_bus_state *bus_state,
 		__le32 __iomem **port_array,
 		u16 wIndex, u32 raw_port_status,
-		unsigned long flags)
+		unsigned long *flags)
 	__releases(&xhci->lock)
 	__acquires(&xhci->lock)
 {
@@ -670,12 +670,12 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 			xhci_set_link_state(xhci, port_array, wIndex,
 					XDEV_U0);
=20
-			spin_unlock_irqrestore(&xhci->lock, flags);
+			spin_unlock_irqrestore(&xhci->lock, *flags);
 			time_left =3D wait_for_completion_timeout(
 					&bus_state->rexit_done[wIndex],
 					msecs_to_jiffies(
 						XHCI_MAX_REXIT_TIMEOUT_MS));
-			spin_lock_irqsave(&xhci->lock, flags);
+			spin_lock_irqsave(&xhci->lock, *flags);
=20
 			if (time_left) {
 				slot_id =3D xhci_find_slot_id_by_port(hcd,
@@ -834,7 +834,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, =
u16 wValue,
 			break;
 		}
 		status =3D xhci_get_port_status(hcd, bus_state, port_array,
-				wIndex, temp, flags);
+				wIndex, temp, &flags);
 		if (status =3D=3D 0xffffffff)
 			goto error;
=20
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ae3b2b5fa9f6..0d18385f85bb 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2345,7 +2345,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	case COMP_SUCCESS:
 		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) =3D=3D 0)
 			break;
-		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH ||
+		    ep_ring->last_td_was_short)
 			trb_comp_code =3D COMP_SHORT_TX;
 		else
 			xhci_warn_ratelimited(xhci,
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 684ce2ad1a39..ab5be88930d7 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -682,7 +682,7 @@ static int adu_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
=20
-	iface_desc =3D &interface->altsetting[0];
+	iface_desc =3D interface->cur_altsetting;
=20
 	/* set up the endpoint information */
 	for (i =3D 0; i < iface_desc->desc.bNumEndpoints; ++i) {
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index 6d4e75785710..066dce850cc6 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -342,7 +342,7 @@ static int idmouse_probe(struct usb_interface *interfac=
e,
 	int result;
=20
 	/* check if we have gotten the data or the hid interface */
-	iface_desc =3D &interface->altsetting[0];
+	iface_desc =3D interface->cur_altsetting;
 	if (iface_desc->desc.bInterfaceClass !=3D 0x0A)
 		return -ENODEV;
=20
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index bbec84dd34fb..4c5aa817162f 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1034,12 +1034,18 @@ static long mon_bin_ioctl(struct file *file, unsign=
ed int cmd, unsigned long arg
=20
 		mutex_lock(&rp->fetch_lock);
 		spin_lock_irqsave(&rp->b_lock, flags);
-		mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
-		kfree(rp->b_vec);
-		rp->b_vec  =3D vec;
-		rp->b_size =3D size;
-		rp->b_read =3D rp->b_in =3D rp->b_out =3D rp->b_cnt =3D 0;
-		rp->cnt_lost =3D 0;
+		if (rp->mmap_active) {
+			mon_free_buff(vec, size/CHUNK_SIZE);
+			kfree(vec);
+			ret =3D -EBUSY;
+		} else {
+			mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
+			kfree(rp->b_vec);
+			rp->b_vec  =3D vec;
+			rp->b_size =3D size;
+			rp->b_read =3D rp->b_in =3D rp->b_out =3D rp->b_cnt =3D 0;
+			rp->cnt_lost =3D 0;
+		}
 		spin_unlock_irqrestore(&rp->b_lock, flags);
 		mutex_unlock(&rp->fetch_lock);
 		}
@@ -1211,13 +1217,21 @@ mon_bin_poll(struct file *file, struct poll_table_s=
truct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp =3D vma->vm_private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
=20
 static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
+	unsigned long flags;
+
 	struct mon_reader_bin *rp =3D vma->vm_private_data;
+	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
=20
 /*
@@ -1229,16 +1243,12 @@ static int mon_bin_vma_fault(struct vm_area_struct =
*vma, struct vm_fault *vmf)
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
=20
-	mutex_lock(&rp->fetch_lock);
 	offset =3D vmf->pgoff << PAGE_SHIFT;
-	if (offset >=3D rp->b_size) {
-		mutex_unlock(&rp->fetch_lock);
+	if (offset >=3D rp->b_size)
 		return VM_FAULT_SIGBUS;
-	}
 	chunk_idx =3D offset / CHUNK_SIZE;
 	pageptr =3D rp->b_vec[chunk_idx].pg;
 	get_page(pageptr);
-	mutex_unlock(&rp->fetch_lock);
 	vmf->page =3D pageptr;
 	return 0;
 }
diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index d006f54d5e15..5edca85a491a 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -396,7 +396,7 @@ struct dma_controller *dma_controller_create(struct mus=
b *musb, void __iomem *ba
 	controller->controller.channel_abort =3D dma_channel_abort;
=20
 	if (request_irq(irq, dma_controller_irq, 0,
-			dev_name(musb->controller), &controller->controller)) {
+			dev_name(musb->controller), controller)) {
 		dev_err(dev, "request_irq %d failed!\n", irq);
 		dma_controller_destroy(&controller->controller);
=20
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 83b2602c6ae1..9b0282cc927a 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -571,9 +571,13 @@ static int ch341_tiocmget(struct tty_struct *tty)
 static int ch341_reset_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port =3D serial->port[0];
-	struct ch341_private *priv =3D usb_get_serial_port_data(port);
+	struct ch341_private *priv;
 	int ret;
=20
+	priv =3D usb_get_serial_port_data(port);
+	if (!priv)
+		return 0;
+
 	/* reconfigure ch341 serial port after bus-reset */
 	ch341_configure(serial->dev, priv);
=20
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgep=
ort.c
index 6947985ccfb0..aea82f20deaa 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -638,7 +638,7 @@ static void edge_interrupt_callback(struct urb *urb)
 			if (txCredits) {
 				port =3D edge_serial->serial->port[portNumber];
 				edge_port =3D usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock(&edge_port->ep_lock);
 					edge_port->txCredits +=3D txCredits;
 					spin_unlock(&edge_port->ep_lock);
@@ -1666,7 +1666,8 @@ static void edge_break(struct tty_struct *tty, int br=
eak_state)
 static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				unsigned char *buffer, __u16 bufferLength)
 {
-	struct device *dev =3D &edge_serial->serial->dev->dev;
+	struct usb_serial *serial =3D edge_serial->serial;
+	struct device *dev =3D &serial->dev->dev;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
 	__u16 lastBufferLength;
@@ -1771,11 +1772,10 @@ static void process_rcvd_data(struct edgeport_seria=
l *edge_serial,
=20
 			/* spit this data back into the tty driver if this
 			   port is open */
-			if (rxLen) {
-				port =3D edge_serial->serial->port[
-							edge_serial->rxPort];
+			if (rxLen && edge_serial->rxPort < serial->num_ports) {
+				port =3D serial->port[edge_serial->rxPort];
 				edge_port =3D usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);
@@ -1783,8 +1783,8 @@ static void process_rcvd_data(struct edgeport_serial =
*edge_serial,
 							rxLen);
 					edge_port->port->icount.rx +=3D rxLen;
 				}
-				buffer +=3D rxLen;
 			}
+			buffer +=3D rxLen;
 			break;
=20
 		case EXPECT_HDR3:	/* Expect 3rd byte of status header */
@@ -1819,6 +1819,8 @@ static void process_rcvd_status(struct edgeport_seria=
l *edge_serial,
 	__u8 code =3D edge_serial->rxStatusCode;
=20
 	/* switch the port pointer to the one being currently talked about */
+	if (edge_serial->rxPort >=3D edge_serial->serial->num_ports)
+		return;
 	port =3D edge_serial->serial->port[edge_serial->rxPort];
 	edge_port =3D usb_get_serial_port_data(port);
 	if (edge_port =3D=3D NULL) {
@@ -2859,16 +2861,18 @@ static int edge_startup(struct usb_serial *serial)
 	response =3D 0;
=20
 	if (edge_serial->is_epic) {
+		struct usb_host_interface *alt;
+
+		alt =3D serial->interface->cur_altsetting;
+
 		/* EPIC thing, set up our interrupt polling now and our read
 		 * urb, so that the device knows it really is connected. */
 		interrupt_in_found =3D bulk_in_found =3D bulk_out_found =3D false;
-		for (i =3D 0; i < serial->interface->altsetting[0]
-						.desc.bNumEndpoints; ++i) {
+		for (i =3D 0; i < alt->desc.bNumEndpoints; ++i) {
 			struct usb_endpoint_descriptor *endpoint;
 			int buffer_size;
=20
-			endpoint =3D &serial->interface->altsetting[0].
-							endpoint[i].desc;
+			endpoint =3D &alt->endpoint[i].desc;
 			buffer_size =3D usb_endpoint_maxp(endpoint);
 			if (!interrupt_in_found &&
 			    (usb_endpoint_is_int_in(endpoint))) {
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 38112be0dbae..f211d0792d63 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -962,6 +962,10 @@ static void usa67_glocont_callback(struct urb *urb)
 	for (i =3D 0; i < serial->num_ports; ++i) {
 		port =3D serial->port[i];
 		p_priv =3D usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
+		if (!p_priv)
+			continue;
=20
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 64bf258e7e00..9606dde3194c 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -116,7 +116,7 @@ static int send_control_msg(struct usb_serial_port *por=
t, u8 requesttype,
 	retval =3D usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
-				0, 0, buffer, 1, 0);
+				0, 0, buffer, 1, USB_CTRL_SET_TIMEOUT);
 	kfree(buffer);
=20
 	if (retval < 0)
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index af0c87276299..82f28192694f 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -872,7 +872,10 @@ static void qt2_update_msr(struct usb_serial_port *por=
t, unsigned char *ch)
 	u8 newMSR =3D (u8) *ch;
 	unsigned long flags;
=20
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv =3D usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
=20
 	spin_lock_irqsave(&port_priv->lock, flags);
 	port_priv->shadowMSR =3D newMSR;
@@ -900,7 +903,10 @@ static void qt2_update_lsr(struct usb_serial_port *por=
t, unsigned char *ch)
 	unsigned long flags;
 	u8 newLSR =3D (u8) *ch;
=20
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv =3D usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
=20
 	if (newLSR & UART_LSR_BI)
 		newLSR &=3D (u8) (UART_LSR_OE | UART_LSR_BI);
diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/us=
b-serial-simple.c
index 235733c69272..11d925bfdf1e 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -89,6 +89,8 @@ DEVICE(moto_modem, MOTO_IDS);
 #define MOTOROLA_TETRA_IDS()			\
 	{ USB_DEVICE(0x0cad, 0x9011) },	/* Motorola Solutions TETRA PEI */ \
 	{ USB_DEVICE(0x0cad, 0x9012) },	/* MTP6550 */ \
+	{ USB_DEVICE(0x0cad, 0x9013) },	/* MTP3xxx */ \
+	{ USB_DEVICE(0x0cad, 0x9015) },	/* MTP85xx */ \
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
=20
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index 97b9af49c1d2..f3ed3c65e855 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1337,6 +1337,9 @@ static int usb_serial_register(struct usb_serial_driv=
er *driver)
 		return -EINVAL;
 	}
=20
+	/* Prevent individual ports from being unbound. */
+	driver->driver.suppress_bind_attrs =3D true;
+
 	usb_serial_operations_init(driver);
=20
 	/* Add this device to our list of devices */
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 3f16c299263f..c99c71afcd5c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -843,11 +843,7 @@ static int vhost_net_release(struct inode *inode, stru=
ct file *f)
=20
 static struct socket *get_raw_socket(int fd)
 {
-	struct {
-		struct sockaddr_ll sa;
-		char  buf[MAX_ADDR_LEN];
-	} uaddr;
-	int uaddr_len =3D sizeof uaddr, r;
+	int r;
 	struct socket *sock =3D sockfd_lookup(fd, &r);
=20
 	if (!sock)
@@ -859,12 +855,7 @@ static struct socket *get_raw_socket(int fd)
 		goto err;
 	}
=20
-	r =3D sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa,
-			       &uaddr_len, 0);
-	if (r)
-		goto err;
-
-	if (uaddr.sa.sll_family !=3D AF_PACKET) {
+	if (sock->sk->sk_family !=3D AF_PACKET) {
 		r =3D -EPFNOSUPPORT;
 		goto err;
 	}
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 6e6aa704fe84..ba0ef937e517 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1312,6 +1312,9 @@ static int vgacon_font_get(struct vc_data *c, struct =
console_font *font)
 static int vgacon_resize(struct vc_data *c, unsigned int width,
 			 unsigned int height, unsigned int user)
 {
+	if ((width << 1) * height > vga_vram_size)
+		return -EINVAL;
+
 	if (width % 2 || width > screen_info.orig_video_cols ||
 	    height > (screen_info.orig_video_lines * vga_default_font_height)/
 	    c->vc_font.height)
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloo=
n.c
index 5ca1928979f6..341c025a230b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -403,6 +403,16 @@ static int virtballoon_migratepage(struct address_spac=
e *mapping,
=20
 	get_page(newpage); /* balloon reference */
=20
+	/*
+	  * When we migrate a page to a different zone and adjusted the
+	  * managed page count when inflating, we have to fixup the count of
+	  * both involved zones.
+	  */
+	if (page_zone(page) !=3D page_zone(newpage)) {
+		adjust_managed_page_count(page, 1);
+		adjust_managed_page_count(newpage, -1);
+	}
+
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
 	balloon_page_insert(newpage, mapping, &vb_dev_info->pages);
diff --git a/firmware/Makefile b/firmware/Makefile
index 0862d34cf7d1..3a678382b8cc 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -156,7 +156,7 @@ quiet_cmd_fwbin =3D MK_FW   $@
 		  PROGBITS=3D$(if $(CONFIG_ARM),%,@)progbits;		     \
 		  echo "/* Generated by firmware/Makefile */"		> $@;\
 		  echo "    .section .rodata"				>>$@;\
-		  echo "    .p2align $${ASM_ALIGN}"			>>$@;\
+		  echo "    .p2align 4"					>>$@;\
 		  echo "_fw_$${FWSTR}_bin:"				>>$@;\
 		  echo "    .incbin \"$(2)\""				>>$@;\
 		  echo "_fw_end:"					>>$@;\
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 6d1d0b93b1aa..c792df826e12 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y +=3D super.o ctree.o extent-tree.o print-tree.o roo=
t-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o
+	   uuid-tree.o props.o hash.o tree-checker.o
=20
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) +=3D acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) +=3D check-integrity.o
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8c65bac0c8a2..4d1766e5438a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -418,7 +418,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_in=
fo,
 	for (node =3D rb_first(tm_root); node; node =3D next) {
 		next =3D rb_next(node);
 		tm =3D container_of(node, struct tree_mod_elem, node);
-		if (tm->seq > min_seq)
+		if (tm->seq >=3D min_seq)
 			continue;
 		rb_erase(node, tm_root);
 		kfree(tm);
@@ -1721,20 +1721,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *tr=
ans,
 	return err;
 }
=20
-/*
- * The leaf data grows from end-to-front in the node.
- * this returns the address of the start of the last item,
- * which is the stop of the leaf data stack
- */
-static inline unsigned int leaf_data_end(struct btrfs_root *root,
-					 struct extent_buffer *leaf)
-{
-	u32 nr =3D btrfs_header_nritems(leaf);
-	if (nr =3D=3D 0)
-		return BTRFS_LEAF_DATA_SIZE(root);
-	return btrfs_item_offset_nr(leaf, nr - 1);
-}
-
=20
 /*
  * search for key in the extent_buffer.  The items start at offset p,
@@ -4609,8 +4595,7 @@ void btrfs_truncate_item(struct btrfs_root *root, str=
uct btrfs_path *path,
 				ptr =3D btrfs_item_ptr_offset(leaf, slot);
 				memmove_extent_buffer(leaf, ptr,
 				      (unsigned long)fi,
-				      offsetof(struct btrfs_file_extent_item,
-						 disk_bytenr));
+				      BTRFS_FILE_EXTENT_INLINE_DATA_START);
 			}
 		}
=20
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 796f1d2374ff..6bcfc5a98548 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/btrfs.h>
 #include <linux/workqueue.h>
+#include <linux/sizes.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -392,9 +393,11 @@ struct btrfs_header {
 				     sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->leafsize))
+#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
+		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
 					sizeof(struct btrfs_item) - \
-					sizeof(struct btrfs_file_extent_item))
+					BTRFS_FILE_EXTENT_INLINE_DATA_START)
 #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
@@ -872,6 +875,7 @@ struct btrfs_balance_item {
 #define BTRFS_FILE_EXTENT_INLINE 0
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
+#define BTRFS_FILE_EXTENT_TYPES	2
=20
 struct btrfs_file_extent_item {
 	/*
@@ -904,6 +908,8 @@ struct btrfs_file_extent_item {
 	/*
 	 * disk space consumed by the extent, checksum blocks are included
 	 * in these numbers
+	 *
+	 * At this offset in the structure, the inline extent data start.
 	 */
 	__le64 disk_bytenr;
 	__le64 disk_num_bytes;
@@ -2134,7 +2140,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
=20
 struct btrfs_map_token {
-	struct extent_buffer *eb;
+	const struct extent_buffer *eb;
 	char *kaddr;
 	unsigned long offset;
 };
@@ -2165,18 +2171,19 @@ static inline void btrfs_init_map_token (struct btr=
fs_map_token *token)
 			   sizeof(((type *)0)->member)))
=20
 #define DECLARE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
-			       unsigned long off,			\
-                              struct btrfs_map_token *token);		\
-void btrfs_set_token_##bits(struct extent_buffer *eb, void *ptr,	\
+u##bits btrfs_get_token_##bits(const struct extent_buffer *eb,		\
+			       const void *ptr, unsigned long off,	\
+			       struct btrfs_map_token *token);		\
+void btrfs_set_token_##bits(struct extent_buffer *eb, const void *ptr,	\
 			    unsigned long off, u##bits val,		\
 			    struct btrfs_map_token *token);		\
-static inline u##bits btrfs_get_##bits(struct extent_buffer *eb, void *ptr=
, \
+static inline u##bits btrfs_get_##bits(const struct extent_buffer *eb,	\
+				       const void *ptr,			\
 				       unsigned long off)		\
 {									\
 	return btrfs_get_token_##bits(eb, ptr, off, NULL);		\
 }									\
-static inline void btrfs_set_##bits(struct extent_buffer *eb, void *ptr, \
+static inline void btrfs_set_##bits(struct extent_buffer *eb, void *ptr,\
 				    unsigned long off, u##bits val)	\
 {									\
        btrfs_set_token_##bits(eb, ptr, off, val, NULL);			\
@@ -2188,7 +2195,8 @@ DECLARE_BTRFS_SETGET_BITS(32)
 DECLARE_BTRFS_SETGET_BITS(64)
=20
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-static inline u##bits btrfs_##name(struct extent_buffer *eb, type *s)	\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb,	\
+				   const type *s)			\
 {									\
 	BUILD_BUG_ON(sizeof(u##bits) !=3D sizeof(((type *)0))->member);	\
 	return btrfs_get_##bits(eb, s, offsetof(type, member));		\
@@ -2199,7 +2207,8 @@ static inline void btrfs_set_##name(struct extent_buf=
fer *eb, type *s,	\
 	BUILD_BUG_ON(sizeof(u##bits) !=3D sizeof(((type *)0))->member);	\
 	btrfs_set_##bits(eb, s, offsetof(type, member), val);		\
 }									\
-static inline u##bits btrfs_token_##name(struct extent_buffer *eb, type *s=
, \
+static inline u##bits btrfs_token_##name(const struct extent_buffer *eb,\
+					 const type *s,			\
 					 struct btrfs_map_token *token)	\
 {									\
 	BUILD_BUG_ON(sizeof(u##bits) !=3D sizeof(((type *)0))->member);	\
@@ -2214,9 +2223,9 @@ static inline void btrfs_set_token_##name(struct exte=
nt_buffer *eb,	\
 }
=20
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb)	\
 {									\
-	type *p =3D page_address(eb->pages[0]);				\
+	const type *p =3D page_address(eb->pages[0]);			\
 	u##bits res =3D le##bits##_to_cpu(p->member);			\
 	return res;							\
 }									\
@@ -2228,7 +2237,7 @@ static inline void btrfs_set_##name(struct extent_buf=
fer *eb,		\
 }
=20
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(type *s)				\
+static inline u##bits btrfs_##name(const type *s)			\
 {									\
 	return le##bits##_to_cpu(s->member);				\
 }									\
@@ -2554,7 +2563,7 @@ static inline unsigned long btrfs_node_key_ptr_offset=
(int nr)
 		sizeof(struct btrfs_key_ptr) * nr;
 }
=20
-void btrfs_node_key(struct extent_buffer *eb,
+void btrfs_node_key(const struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr);
=20
 static inline void btrfs_set_node_key(struct extent_buffer *eb,
@@ -2583,28 +2592,28 @@ static inline struct btrfs_item *btrfs_item_nr(int =
nr)
 	return (struct btrfs_item *)btrfs_item_nr_offset(nr);
 }
=20
-static inline u32 btrfs_item_end(struct extent_buffer *eb,
+static inline u32 btrfs_item_end(const struct extent_buffer *eb,
 				 struct btrfs_item *item)
 {
 	return btrfs_item_offset(eb, item) + btrfs_item_size(eb, item);
 }
=20
-static inline u32 btrfs_item_end_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_end_nr(const struct extent_buffer *eb, int nr)
 {
 	return btrfs_item_end(eb, btrfs_item_nr(nr));
 }
=20
-static inline u32 btrfs_item_offset_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_offset_nr(const struct extent_buffer *eb, int=
 nr)
 {
 	return btrfs_item_offset(eb, btrfs_item_nr(nr));
 }
=20
-static inline u32 btrfs_item_size_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_size_nr(const struct extent_buffer *eb, int n=
r)
 {
 	return btrfs_item_size(eb, btrfs_item_nr(nr));
 }
=20
-static inline void btrfs_item_key(struct extent_buffer *eb,
+static inline void btrfs_item_key(const struct extent_buffer *eb,
 			   struct btrfs_disk_key *disk_key, int nr)
 {
 	struct btrfs_item *item =3D btrfs_item_nr(nr);
@@ -2640,8 +2649,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct b=
trfs_dir_item,
 BTRFS_SETGET_STACK_FUNCS(stack_dir_transid, struct btrfs_dir_item,
 			 transid, 64);
=20
-static inline void btrfs_dir_item_key(struct extent_buffer *eb,
-				      struct btrfs_dir_item *item,
+static inline void btrfs_dir_item_key(const struct extent_buffer *eb,
+				      const struct btrfs_dir_item *item,
 				      struct btrfs_disk_key *key)
 {
 	read_eb_member(eb, item, struct btrfs_dir_item, location, key);
@@ -2649,7 +2658,7 @@ static inline void btrfs_dir_item_key(struct extent_b=
uffer *eb,
=20
 static inline void btrfs_set_dir_item_key(struct extent_buffer *eb,
 					  struct btrfs_dir_item *item,
-					  struct btrfs_disk_key *key)
+					  const struct btrfs_disk_key *key)
 {
 	write_eb_member(eb, item, struct btrfs_dir_item, location, key);
 }
@@ -2661,8 +2670,8 @@ BTRFS_SETGET_FUNCS(free_space_bitmaps, struct btrfs_f=
ree_space_header,
 BTRFS_SETGET_FUNCS(free_space_generation, struct btrfs_free_space_header,
 		   generation, 64);
=20
-static inline void btrfs_free_space_key(struct extent_buffer *eb,
-					struct btrfs_free_space_header *h,
+static inline void btrfs_free_space_key(const struct extent_buffer *eb,
+					const struct btrfs_free_space_header *h,
 					struct btrfs_disk_key *key)
 {
 	read_eb_member(eb, h, struct btrfs_free_space_header, location, key);
@@ -2670,7 +2679,7 @@ static inline void btrfs_free_space_key(struct extent=
_buffer *eb,
=20
 static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
 					    struct btrfs_free_space_header *h,
-					    struct btrfs_disk_key *key)
+					    const struct btrfs_disk_key *key)
 {
 	write_eb_member(eb, h, struct btrfs_free_space_header, location, key);
 }
@@ -2697,25 +2706,25 @@ static inline void btrfs_cpu_key_to_disk(struct btr=
fs_disk_key *disk,
 	disk->objectid =3D cpu_to_le64(cpu->objectid);
 }
=20
-static inline void btrfs_node_key_to_cpu(struct extent_buffer *eb,
-				  struct btrfs_key *key, int nr)
+static inline void btrfs_node_key_to_cpu(const struct extent_buffer *eb,
+					 struct btrfs_key *key, int nr)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_node_key(eb, &disk_key, nr);
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
=20
-static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
-				  struct btrfs_key *key, int nr)
+static inline void btrfs_item_key_to_cpu(const struct extent_buffer *eb,
+					 struct btrfs_key *key, int nr)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_item_key(eb, &disk_key, nr);
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
=20
-static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
-				      struct btrfs_dir_item *item,
-				      struct btrfs_key *key)
+static inline void btrfs_dir_item_key_to_cpu(const struct extent_buffer *e=
b,
+					     const struct btrfs_dir_item *item,
+					     struct btrfs_key *key)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_dir_item_key(eb, item, &disk_key);
@@ -2748,7 +2757,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_header_nritems, struct=
 btrfs_header,
 			 nritems, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_header_bytenr, struct btrfs_header, bytenr,=
 64);
=20
-static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
+static inline int btrfs_header_flag(const struct extent_buffer *eb, u64 fl=
ag)
 {
 	return (btrfs_header_flags(eb) & flag) =3D=3D flag;
 }
@@ -2767,7 +2776,7 @@ static inline int btrfs_clear_header_flag(struct exte=
nt_buffer *eb, u64 flag)
 	return (flags & flag) =3D=3D flag;
 }
=20
-static inline int btrfs_header_backref_rev(struct extent_buffer *eb)
+static inline int btrfs_header_backref_rev(const struct extent_buffer *eb)
 {
 	u64 flags =3D btrfs_header_flags(eb);
 	return flags >> BTRFS_BACKREF_REV_SHIFT;
@@ -2787,12 +2796,12 @@ static inline unsigned long btrfs_header_fsid(void)
 	return offsetof(struct btrfs_header, fsid);
 }
=20
-static inline unsigned long btrfs_header_chunk_tree_uuid(struct extent_buf=
fer *eb)
+static inline unsigned long btrfs_header_chunk_tree_uuid(const struct exte=
nt_buffer *eb)
 {
 	return offsetof(struct btrfs_header, chunk_tree_uuid);
 }
=20
-static inline int btrfs_is_leaf(struct extent_buffer *eb)
+static inline int btrfs_is_leaf(const struct extent_buffer *eb)
 {
 	return btrfs_header_level(eb) =3D=3D 0;
 }
@@ -2826,12 +2835,12 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrf=
s_root_item,
 BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
=20
-static inline bool btrfs_root_readonly(struct btrfs_root *root)
+static inline bool btrfs_root_readonly(const struct btrfs_root *root)
 {
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) !=
=3D 0;
 }
=20
-static inline bool btrfs_root_dead(struct btrfs_root *root)
+static inline bool btrfs_root_dead(const struct btrfs_root *root)
 {
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_DEAD)) !=3D=
 0;
 }
@@ -2888,51 +2897,51 @@ BTRFS_SETGET_STACK_FUNCS(backup_num_devices, struct=
 btrfs_root_backup,
 /* struct btrfs_balance_item */
 BTRFS_SETGET_FUNCS(balance_flags, struct btrfs_balance_item, flags, 64);
=20
-static inline void btrfs_balance_data(struct extent_buffer *eb,
-				      struct btrfs_balance_item *bi,
+static inline void btrfs_balance_data(const struct extent_buffer *eb,
+				      const struct btrfs_balance_item *bi,
 				      struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
 }
=20
 static inline void btrfs_set_balance_data(struct extent_buffer *eb,
-					  struct btrfs_balance_item *bi,
-					  struct btrfs_disk_balance_args *ba)
+				  struct btrfs_balance_item *bi,
+				  const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
 }
=20
-static inline void btrfs_balance_meta(struct extent_buffer *eb,
-				      struct btrfs_balance_item *bi,
+static inline void btrfs_balance_meta(const struct extent_buffer *eb,
+				      const struct btrfs_balance_item *bi,
 				      struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
 }
=20
 static inline void btrfs_set_balance_meta(struct extent_buffer *eb,
-					  struct btrfs_balance_item *bi,
-					  struct btrfs_disk_balance_args *ba)
+				  struct btrfs_balance_item *bi,
+				  const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
 }
=20
-static inline void btrfs_balance_sys(struct extent_buffer *eb,
-				     struct btrfs_balance_item *bi,
+static inline void btrfs_balance_sys(const struct extent_buffer *eb,
+				     const struct btrfs_balance_item *bi,
 				     struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
 }
=20
 static inline void btrfs_set_balance_sys(struct extent_buffer *eb,
-					 struct btrfs_balance_item *bi,
-					 struct btrfs_disk_balance_args *ba)
+				 struct btrfs_balance_item *bi,
+				 const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
 }
=20
 static inline void
 btrfs_disk_balance_args_to_cpu(struct btrfs_balance_args *cpu,
-			       struct btrfs_disk_balance_args *disk)
+			       const struct btrfs_disk_balance_args *disk)
 {
 	memset(cpu, 0, sizeof(*cpu));
=20
@@ -2950,7 +2959,7 @@ btrfs_disk_balance_args_to_cpu(struct btrfs_balance_a=
rgs *cpu,
=20
 static inline void
 btrfs_cpu_balance_args_to_disk(struct btrfs_disk_balance_args *disk,
-			       struct btrfs_balance_args *cpu)
+			       const struct btrfs_balance_args *cpu)
 {
 	memset(disk, 0, sizeof(*disk));
=20
@@ -3018,7 +3027,7 @@ BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_su=
per_block, magic, 64);
 BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_bl=
ock,
 			 uuid_tree_generation, 64);
=20
-static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
+static inline int btrfs_super_csum_size(const struct btrfs_super_block *s)
 {
 	u16 t =3D btrfs_super_csum_type(s);
 	/*
@@ -3032,6 +3041,21 @@ static inline unsigned long btrfs_leaf_data(struct e=
xtent_buffer *l)
 	return offsetof(struct btrfs_leaf, items);
 }
=20
+/*
+ * The leaf data grows from end-to-front in the node.
+ * this returns the address of the start of the last item,
+ * which is the stop of the leaf data stack
+ */
+static inline unsigned int leaf_data_end(const struct btrfs_root *root,
+					 const struct extent_buffer *leaf)
+{
+	u32 nr =3D btrfs_header_nritems(leaf);
+
+	if (nr =3D=3D 0)
+		return BTRFS_LEAF_DATA_SIZE(root);
+	return btrfs_item_offset_nr(leaf, nr - 1);
+}
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, =
8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
@@ -3048,16 +3072,14 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compress=
ion,
 			 struct btrfs_file_extent_item, compression, 8);
=20
 static inline unsigned long
-btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
+btrfs_file_extent_inline_start(const struct btrfs_file_extent_item *e)
 {
-	unsigned long offset =3D (unsigned long)e;
-	offset +=3D offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return offset;
+	return (unsigned long)e + BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
=20
 static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
 {
-	return offsetof(struct btrfs_file_extent_item, disk_bytenr) + datasize;
+	return BTRFS_FILE_EXTENT_INLINE_DATA_START + datasize;
 }
=20
 BTRFS_SETGET_FUNCS(file_extent_disk_bytenr, struct btrfs_file_extent_item,
@@ -3084,20 +3106,19 @@ BTRFS_SETGET_FUNCS(file_extent_other_encoding, stru=
ct btrfs_file_extent_item,
  * size of any extent headers.  If a file is compressed on disk, this is
  * the compressed size
  */
-static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *=
eb,
-						    struct btrfs_item *e)
+static inline u32 btrfs_file_extent_inline_item_len(
+						const struct extent_buffer *eb,
+						struct btrfs_item *e)
 {
-	unsigned long offset;
-	offset =3D offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return btrfs_item_size(eb, e) - offset;
+	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
=20
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
-static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
-					       int slot,
-					       struct btrfs_file_extent_item *fi)
+static inline u32 btrfs_file_extent_inline_len(const struct extent_buffer =
*eb,
+					int slot,
+					const struct btrfs_file_extent_item *fi)
 {
 	struct btrfs_map_token token;
=20
@@ -3119,8 +3140,8 @@ static inline u32 btrfs_file_extent_inline_len(struct=
 extent_buffer *eb,
=20
=20
 /* btrfs_dev_stats_item */
-static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
-					struct btrfs_dev_stats_item *ptr,
+static inline u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
+					const struct btrfs_dev_stats_item *ptr,
 					int index)
 {
 	u64 val;
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7ee449d0da8a..7542ba457f09 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -614,7 +614,7 @@ static void btrfs_dev_replace_update_device_in_mapping_=
tree(
 		em =3D lookup_extent_mapping(em_tree, start, (u64)-1);
 		if (!em)
 			break;
-		map =3D (struct map_lookup *)em->bdev;
+		map =3D em->map_lookup;
 		for (i =3D 0; i < map->num_stripes; i++)
 			if (srcdev =3D=3D map->stripes[i].dev)
 				map->stripes[i].dev =3D tgtdev;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64cd85a24ab8..c3669e689db8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "tree-checker.h"
=20
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -507,72 +508,6 @@ static int check_tree_block_fsid(struct btrfs_root *ro=
ot,
 	return ret;
 }
=20
-#define CORRUPT(reason, eb, root, slot)				\
-	btrfs_crit(root->fs_info, "corrupt leaf, %s: block=3D%llu,"	\
-		   "root=3D%llu, slot=3D%d", reason,			\
-	       btrfs_header_bytenr(eb),	root->objectid, slot)
-
-static noinline int check_leaf(struct btrfs_root *root,
-			       struct extent_buffer *leaf)
-{
-	struct btrfs_key key;
-	struct btrfs_key leaf_key;
-	u32 nritems =3D btrfs_header_nritems(leaf);
-	int slot;
-
-	if (nritems =3D=3D 0)
-		return 0;
-
-	/* Check the 0 item */
-	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=3D
-	    BTRFS_LEAF_DATA_SIZE(root)) {
-		CORRUPT("invalid item offset size pair", leaf, root, 0);
-		return -EIO;
-	}
-
-	/*
-	 * Check to make sure each items keys are in the correct order and their
-	 * offsets make sense.  We only have to loop through nritems-1 because
-	 * we check the current slot against the next slot, which verifies the
-	 * next slot's offset+size makes sense and that the current's slot
-	 * offset is correct.
-	 */
-	for (slot =3D 0; slot < nritems - 1; slot++) {
-		btrfs_item_key_to_cpu(leaf, &leaf_key, slot);
-		btrfs_item_key_to_cpu(leaf, &key, slot + 1);
-
-		/* Make sure the keys are in the right order */
-		if (btrfs_comp_cpu_keys(&leaf_key, &key) >=3D 0) {
-			CORRUPT("bad key order", leaf, root, slot);
-			return -EIO;
-		}
-
-		/*
-		 * Make sure the offset and ends are right, remember that the
-		 * item data starts at the end of the leaf and grows towards the
-		 * front.
-		 */
-		if (btrfs_item_offset_nr(leaf, slot) !=3D
-			btrfs_item_end_nr(leaf, slot + 1)) {
-			CORRUPT("slot offset bad", leaf, root, slot);
-			return -EIO;
-		}
-
-		/*
-		 * Check to make sure that we don't point outside of the leaf,
-		 * just incase all the items are consistent to eachother, but
-		 * all point outside of the leaf.
-		 */
-		if (btrfs_item_end_nr(leaf, slot) >
-		    BTRFS_LEAF_DATA_SIZE(root)) {
-			CORRUPT("slot end outside of leaf", leaf, root, slot);
-			return -EIO;
-		}
-	}
-
-	return 0;
-}
-
 static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
@@ -640,11 +575,14 @@ static int btree_readpage_end_io_hook(struct btrfs_io=
_bio *io_bio,
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level =3D=3D 0 && check_leaf(root, eb)) {
+	if (found_level =3D=3D 0 && btrfs_check_leaf_full(root, eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret =3D -EIO;
 	}
=20
+	if (found_level > 0 && btrfs_check_node(root, eb))
+		ret =3D -EIO;
+
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
 err:
@@ -3764,7 +3702,13 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *b=
uf)
 				     buf->len,
 				     root->fs_info->dirty_metadata_batch);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-	if (btrfs_header_level(buf) =3D=3D 0 && check_leaf(root, buf)) {
+	/*
+	 * Since btrfs_mark_buffer_dirty() can be called with item pointer set
+	 * but item data not updated.
+	 * So here we should only check item pointers, not item data.
+	 */
+	if (btrfs_header_level(buf) =3D=3D 0 &&
+	    btrfs_check_leaf_relaxed(root, buf)) {
 		btrfs_print_leaf(root, buf);
 		ASSERT(0);
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 62a92d7ed0aa..1c1cb07f51f8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2258,7 +2258,13 @@ static int run_delayed_tree_ref(struct btrfs_trans_h=
andle *trans,
 		ins.type =3D BTRFS_EXTENT_ITEM_KEY;
 	}
=20
-	BUG_ON(node->ref_mod !=3D 1);
+	if (node->ref_mod !=3D 1) {
+		btrfs_err(root->fs_info,
+	"btree block(%llu) has %d references rather than 1: action %d ref_root %l=
lu parent %llu",
+			  node->bytenr, node->ref_mod, node->action, ref_root,
+			  parent);
+		return -EIO;
+	}
 	if (node->action =3D=3D BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
 		ret =3D alloc_reserved_tree_block(trans, root,
@@ -8550,6 +8556,8 @@ static int find_first_block_group(struct btrfs_root *=
root,
 	int ret =3D 0;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
+	struct btrfs_block_group_item bg;
+	u64 flags;
 	int slot;
=20
 	ret =3D btrfs_search_slot(NULL, root, key, path, 0, 0);
@@ -8571,7 +8579,47 @@ static int find_first_block_group(struct btrfs_root =
*root,
=20
 		if (found_key.objectid >=3D key->objectid &&
 		    found_key.type =3D=3D BTRFS_BLOCK_GROUP_ITEM_KEY) {
-			ret =3D 0;
+			struct extent_map_tree *em_tree;
+			struct extent_map *em;
+
+			em_tree =3D &root->fs_info->mapping_tree.map_tree;
+			read_lock(&em_tree->lock);
+			em =3D lookup_extent_mapping(em_tree, found_key.objectid,
+						   found_key.offset);
+			read_unlock(&em_tree->lock);
+			if (!em) {
+				btrfs_err(root->fs_info,
+			"logical %llu len %llu found bg but no related chunk",
+					  found_key.objectid, found_key.offset);
+				ret =3D -ENOENT;
+			} else if (em->start !=3D found_key.objectid ||
+				   em->len !=3D found_key.offset) {
+				btrfs_err(root->fs_info,
+		"block group %llu len %llu mismatch with chunk %llu len %llu",
+					  found_key.objectid, found_key.offset,
+					  em->start, em->len);
+				ret =3D -EUCLEAN;
+			} else {
+				read_extent_buffer(leaf, &bg,
+					btrfs_item_ptr_offset(leaf, slot),
+					sizeof(bg));
+				flags =3D btrfs_block_group_flags(&bg) &
+					BTRFS_BLOCK_GROUP_TYPE_MASK;
+
+				if (flags !=3D (em->map_lookup->type &
+					      BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+					btrfs_err(root->fs_info,
+"block group %llu len %llu type flags 0x%llx mismatch with chunk type flag=
s 0x%llx",
+						found_key.objectid,
+						found_key.offset, flags,
+						(BTRFS_BLOCK_GROUP_TYPE_MASK &
+						 em->map_lookup->type));
+					ret =3D -EUCLEAN;
+				} else {
+					ret =3D 0;
+				}
+			}
+			free_extent_map(em);
 			goto out;
 		}
 		path->slots[0]++;
@@ -8771,6 +8819,62 @@ btrfs_create_block_group_cache(struct btrfs_root *ro=
ot, u64 start, u64 size)
 	return cache;
 }
=20
+
+/*
+ * Iterate all chunks and verify that each of them has the corresponding b=
lock
+ * group
+ */
+static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_mapping_tree *map_tree =3D &fs_info->mapping_tree;
+	struct extent_map *em;
+	struct btrfs_block_group_cache *bg;
+	u64 start =3D 0;
+	int ret =3D 0;
+
+	while (1) {
+		read_lock(&map_tree->map_tree.lock);
+		/*
+		 * lookup_extent_mapping will return the first extent map
+		 * intersecting the range, so setting @len to 1 is enough to
+		 * get the first chunk.
+		 */
+		em =3D lookup_extent_mapping(&map_tree->map_tree, start, 1);
+		read_unlock(&map_tree->map_tree.lock);
+		if (!em)
+			break;
+
+		bg =3D btrfs_lookup_block_group(fs_info, em->start);
+		if (!bg) {
+			btrfs_err(fs_info,
+	"chunk start=3D%llu len=3D%llu doesn't have corresponding block group",
+				     em->start, em->len);
+			ret =3D -EUCLEAN;
+			free_extent_map(em);
+			break;
+		}
+		if (bg->key.objectid !=3D em->start ||
+		    bg->key.offset !=3D em->len ||
+		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=3D
+		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+			btrfs_err(fs_info,
+"chunk start=3D%llu len=3D%llu flags=3D0x%llx doesn't match block group st=
art=3D%llu len=3D%llu flags=3D0x%llx",
+				em->start, em->len,
+				em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK,
+				bg->key.objectid, bg->key.offset,
+				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
+			ret =3D -EUCLEAN;
+			free_extent_map(em);
+			btrfs_put_block_group(bg);
+			break;
+		}
+		start =3D em->start + em->len;
+		free_extent_map(em);
+		btrfs_put_block_group(bg);
+	}
+	return ret;
+}
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -8933,7 +9037,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	}
=20
 	init_global_block_rsv(info);
-	ret =3D 0;
+	ret =3D check_chunk_block_group_mappings(info);
 error:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 604d31e85c82..417a4cf6035c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2082,7 +2082,7 @@ int repair_eb_io_failure(struct btrfs_root *root, str=
uct extent_buffer *eb,
 		return -EROFS;
=20
 	for (i =3D 0; i < num_pages; i++) {
-		struct page *p =3D extent_buffer_page(eb, i);
+		struct page *p =3D eb->pages[i];
 		ret =3D repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
 					start, p, mirror_num);
 		if (ret)
@@ -3558,7 +3558,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
=20
 	num_pages =3D num_extent_pages(eb->start, eb->len);
 	for (i =3D 0; i < num_pages; i++) {
-		struct page *p =3D extent_buffer_page(eb, i);
+		struct page *p =3D eb->pages[i];
=20
 		if (!trylock_page(p)) {
 			if (!flush) {
@@ -3617,8 +3617,10 @@ static noinline_for_stack int write_one_eb(struct ex=
tent_buffer *eb,
 	struct block_device *bdev =3D fs_info->fs_devices->latest_bdev;
 	struct extent_io_tree *tree =3D &BTRFS_I(fs_info->btree_inode)->io_tree;
 	u64 offset =3D eb->start;
+	u32 nritems;
 	unsigned long i, num_pages;
 	unsigned long bio_flags =3D 0;
+	unsigned long start, end;
 	int rw =3D (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret =3D 0;
=20
@@ -3628,8 +3630,25 @@ static noinline_for_stack int write_one_eb(struct ex=
tent_buffer *eb,
 	if (btrfs_header_owner(eb) =3D=3D BTRFS_TREE_LOG_OBJECTID)
 		bio_flags =3D EXTENT_BIO_TREE_LOG;
=20
+	/* set btree blocks beyond nritems with 0 to avoid stale content. */
+	nritems =3D btrfs_header_nritems(eb);
+	if (btrfs_header_level(eb) > 0) {
+		end =3D btrfs_node_key_ptr_offset(nritems);
+
+		memset_extent_buffer(eb, 0, end, eb->len - end);
+	} else {
+		/*
+		 * leaf:
+		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
+		 */
+		start =3D btrfs_item_nr_offset(nritems);
+		end =3D btrfs_leaf_data(eb) +
+		      leaf_data_end(fs_info->tree_root, eb);
+		memset_extent_buffer(eb, 0, start, end - start);
+	}
+
 	for (i =3D 0; i < num_pages; i++) {
-		struct page *p =3D extent_buffer_page(eb, i);
+		struct page *p =3D eb->pages[i];
=20
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
@@ -3652,10 +3671,8 @@ static noinline_for_stack int write_one_eb(struct ex=
tent_buffer *eb,
 	}
=20
 	if (unlikely(ret)) {
-		for (; i < num_pages; i++) {
-			struct page *p =3D extent_buffer_page(eb, i);
-			unlock_page(p);
-		}
+		for (; i < num_pages; i++)
+			unlock_page(eb->pages[i]);
 	}
=20
 	return ret;
@@ -4459,7 +4476,7 @@ static void btrfs_release_extent_buffer_page(struct e=
xtent_buffer *eb,
=20
 	do {
 		index--;
-		page =3D extent_buffer_page(eb, index);
+		page =3D eb->pages[index];
 		if (page && mapped) {
 			spin_lock(&page->mapping->private_lock);
 			/*
@@ -4641,7 +4658,8 @@ static void mark_extent_buffer_accessed(struct extent=
_buffer *eb,
=20
 	num_pages =3D num_extent_pages(eb->start, eb->len);
 	for (i =3D 0; i < num_pages; i++) {
-		struct page *p =3D extent_buffer_page(eb, i);
+		struct page *p =3D eb->pages[i];
+
 		if (p !=3D accessed)
 			mark_page_accessed(p);
 	}
@@ -4810,7 +4828,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrf=
s_fs_info *fs_info,
 	 */
 	SetPageChecked(eb->pages[0]);
 	for (i =3D 1; i < num_pages; i++) {
-		p =3D extent_buffer_page(eb, i);
+		p =3D eb->pages[i];
 		ClearPageChecked(p);
 		unlock_page(p);
 	}
@@ -4921,7 +4939,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *=
eb)
 	num_pages =3D num_extent_pages(eb->start, eb->len);
=20
 	for (i =3D 0; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		if (!PageDirty(page))
 			continue;
=20
@@ -4957,7 +4975,7 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
=20
 	for (i =3D 0; i < num_pages; i++)
-		set_page_dirty(extent_buffer_page(eb, i));
+		set_page_dirty(eb->pages[i]);
 	return was_dirty;
 }
=20
@@ -4970,7 +4988,7 @@ int clear_extent_buffer_uptodate(struct extent_buffer=
 *eb)
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages =3D num_extent_pages(eb->start, eb->len);
 	for (i =3D 0; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		if (page)
 			ClearPageUptodate(page);
 	}
@@ -4986,7 +5004,7 @@ int set_extent_buffer_uptodate(struct extent_buffer *=
eb)
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages =3D num_extent_pages(eb->start, eb->len);
 	for (i =3D 0; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		SetPageUptodate(page);
 	}
 	return 0;
@@ -5026,7 +5044,7 @@ int read_extent_buffer_pages(struct extent_io_tree *t=
ree,
=20
 	num_pages =3D num_extent_pages(eb->start, eb->len);
 	for (i =3D start_i; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		if (wait =3D=3D WAIT_NONE) {
 			if (!trylock_page(page))
 				goto unlock_exit;
@@ -5049,7 +5067,7 @@ int read_extent_buffer_pages(struct extent_io_tree *t=
ree,
 	eb->read_mirror =3D 0;
 	atomic_set(&eb->io_pages, num_reads);
 	for (i =3D start_i; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
 			err =3D __extent_read_full_page(tree, page,
@@ -5074,7 +5092,7 @@ int read_extent_buffer_pages(struct extent_io_tree *t=
ree,
 		return ret;
=20
 	for (i =3D start_i; i < num_pages; i++) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		wait_on_page_locked(page);
 		if (!PageUptodate(page))
 			ret =3D -EIO;
@@ -5085,7 +5103,7 @@ int read_extent_buffer_pages(struct extent_io_tree *t=
ree,
 unlock_exit:
 	i =3D start_i;
 	while (locked_pages > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		i++;
 		unlock_page(page);
 		locked_pages--;
@@ -5093,9 +5111,8 @@ int read_extent_buffer_pages(struct extent_io_tree *t=
ree,
 	return ret;
 }
=20
-void read_extent_buffer(struct extent_buffer *eb, void *dstv,
-			unsigned long start,
-			unsigned long len)
+void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
+			unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5111,7 +5128,7 @@ void read_extent_buffer(struct extent_buffer *eb, voi=
d *dstv,
 	offset =3D (start_offset + start) & (PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
=20
 		cur =3D min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr =3D page_address(page);
@@ -5124,9 +5141,9 @@ void read_extent_buffer(struct extent_buffer *eb, voi=
d *dstv,
 	}
 }
=20
-int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
-			unsigned long start,
-			unsigned long len)
+int read_extent_buffer_to_user(const struct extent_buffer *eb,
+			       void __user *dstv,
+			       unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5143,7 +5160,7 @@ int read_extent_buffer_to_user(struct extent_buffer *=
eb, void __user *dstv,
 	offset =3D (start_offset + start) & (PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
=20
 		cur =3D min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr =3D page_address(page);
@@ -5161,10 +5178,10 @@ int read_extent_buffer_to_user(struct extent_buffer=
 *eb, void __user *dstv,
 	return ret;
 }
=20
-int map_private_extent_buffer(struct extent_buffer *eb, unsigned long star=
t,
-			       unsigned long min_len, char **map,
-			       unsigned long *map_start,
-			       unsigned long *map_len)
+int map_private_extent_buffer(const struct extent_buffer *eb,
+			      unsigned long start, unsigned long min_len,
+			      char **map, unsigned long *map_start,
+			      unsigned long *map_len)
 {
 	size_t offset =3D start & (PAGE_CACHE_SIZE - 1);
 	char *kaddr;
@@ -5192,16 +5209,15 @@ int map_private_extent_buffer(struct extent_buffer =
*eb, unsigned long start,
 		return -EINVAL;
 	}
=20
-	p =3D extent_buffer_page(eb, i);
+	p =3D eb->pages[i];
 	kaddr =3D page_address(p);
 	*map =3D kaddr + offset;
 	*map_len =3D PAGE_CACHE_SIZE - offset;
 	return 0;
 }
=20
-int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
-			  unsigned long start,
-			  unsigned long len)
+int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
+			 unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5218,7 +5234,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, co=
nst void *ptrv,
 	offset =3D (start_offset + start) & (PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
=20
 		cur =3D min(len, (PAGE_CACHE_SIZE - offset));
=20
@@ -5252,7 +5268,7 @@ void write_extent_buffer(struct extent_buffer *eb, co=
nst void *srcv,
 	offset =3D (start_offset + start) & (PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		WARN_ON(!PageUptodate(page));
=20
 		cur =3D min(len, PAGE_CACHE_SIZE - offset);
@@ -5282,7 +5298,7 @@ void memset_extent_buffer(struct extent_buffer *eb, c=
har c,
 	offset =3D (start_offset + start) & (PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(eb, i);
+		page =3D eb->pages[i];
 		WARN_ON(!PageUptodate(page));
=20
 		cur =3D min(len, PAGE_CACHE_SIZE - offset);
@@ -5313,7 +5329,7 @@ void copy_extent_buffer(struct extent_buffer *dst, st=
ruct extent_buffer *src,
 		(PAGE_CACHE_SIZE - 1);
=20
 	while (len > 0) {
-		page =3D extent_buffer_page(dst, i);
+		page =3D dst->pages[i];
 		WARN_ON(!PageUptodate(page));
=20
 		cur =3D min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
@@ -5391,8 +5407,7 @@ void memcpy_extent_buffer(struct extent_buffer *dst, =
unsigned long dst_offset,
 		cur =3D min_t(unsigned long, cur,
 			(unsigned long)(PAGE_CACHE_SIZE - dst_off_in_page));
=20
-		copy_pages(extent_buffer_page(dst, dst_i),
-			   extent_buffer_page(dst, src_i),
+		copy_pages(dst->pages[dst_i], dst->pages[src_i],
 			   dst_off_in_page, src_off_in_page, cur);
=20
 		src_offset +=3D cur;
@@ -5438,8 +5453,7 @@ void memmove_extent_buffer(struct extent_buffer *dst,=
 unsigned long dst_offset,
=20
 		cur =3D min_t(unsigned long, len, src_off_in_page + 1);
 		cur =3D min(cur, dst_off_in_page + 1);
-		copy_pages(extent_buffer_page(dst, dst_i),
-			   extent_buffer_page(dst, src_i),
+		copy_pages(dst->pages[dst_i], dst->pages[src_i],
 			   dst_off_in_page - cur + 1,
 			   src_off_in_page - cur + 1, cur);
=20
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ccc264e7bde1..5095cb199128 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -286,25 +286,18 @@ static inline unsigned long num_extent_pages(u64 star=
t, u64 len)
 		(start >> PAGE_CACHE_SHIFT);
 }
=20
-static inline struct page *extent_buffer_page(struct extent_buffer *eb,
-					      unsigned long i)
-{
-	return eb->pages[i];
-}
-
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
 	atomic_inc(&eb->refs);
 }
=20
-int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
-			  unsigned long start,
-			  unsigned long len);
-void read_extent_buffer(struct extent_buffer *eb, void *dst,
+int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
+			 unsigned long start, unsigned long len);
+void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
-int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dst,
-			       unsigned long start,
+int read_extent_buffer_to_user(const struct extent_buffer *eb,
+			       void __user *dst, unsigned long start,
 			       unsigned long len);
 void write_extent_buffer(struct extent_buffer *eb, const void *src,
 			 unsigned long start, unsigned long len);
@@ -323,10 +316,10 @@ int set_extent_buffer_uptodate(struct extent_buffer *=
eb);
 int clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_under_io(struct extent_buffer *eb);
-int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offs=
et,
-		      unsigned long min_len, char **map,
-		      unsigned long *map_start,
-		      unsigned long *map_len);
+int map_private_extent_buffer(const struct extent_buffer *eb,
+			      unsigned long offset, unsigned long min_len,
+			      char **map, unsigned long *map_start,
+			      unsigned long *map_len);
 int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 en=
d);
 int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6a98bddd8f33..84fb56d5c018 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -76,7 +76,7 @@ void free_extent_map(struct extent_map *em)
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
-			kfree(em->bdev);
+			kfree(em->map_lookup);
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index b2991fd8583e..eb8b8fae036b 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -32,7 +32,15 @@ struct extent_map {
 	u64 block_len;
 	u64 generation;
 	unsigned long flags;
-	struct block_device *bdev;
+	union {
+		struct block_device *bdev;
+
+		/*
+		 * used for chunk mappings
+		 * flags & EXTENT_FLAG_FS_MAPPING must be set
+		 */
+		struct map_lookup *map_lookup;
+	};
 	atomic_t refs;
 	unsigned int compress_type;
 	struct list_head list;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e597cc1c5d5b..8ac270f3fa92 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1283,7 +1283,11 @@ static noinline int run_delalloc_nocow(struct inode =
*inode,
 				btrfs_file_extent_num_bytes(leaf, fi);
 			disk_num_bytes =3D
 				btrfs_file_extent_disk_num_bytes(leaf, fi);
-			if (extent_end <=3D start) {
+			/*
+			 * If the extent we got ends before our current offset,
+			 * skip to the next extent.
+			 */
+			if (extent_end <=3D cur_offset) {
 				path->slots[0]++;
 				goto next_slot;
 			}
@@ -4027,7 +4031,6 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *tr=
ans,
=20
 		leaf =3D path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		btrfs_release_path(path);
 		index =3D key.offset;
 	}
 	btrfs_release_path(path);
@@ -5140,7 +5143,6 @@ static void inode_tree_del(struct inode *inode)
 	spin_unlock(&root->inode_lock);
=20
 	if (empty && btrfs_root_refs(&root->root_item) =3D=3D 0) {
-		synchronize_srcu(&root->fs_info->subvol_srcu);
 		spin_lock(&root->inode_lock);
 		empty =3D RB_EMPTY_ROOT(&root->inode_tree);
 		spin_unlock(&root->inode_lock);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 379c88b17c07..c4c26586318d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -580,12 +580,18 @@ static noinline int create_subvol(struct inode *dir,
=20
 	btrfs_i_size_write(dir, dir->i_size + namelen * 2);
 	ret =3D btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
=20
 	ret =3D btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 btrfs_ino(dir), index, name, namelen);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
=20
 	ret =3D btrfs_uuid_tree_add(trans, root->fs_info->uuid_root,
 				  root_item.uuid, BTRFS_UUID_KEY_SUBVOL,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9cba36820c72..54d79d8af015 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4449,6 +4449,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 				       reloc_root->root_key.offset);
 		if (IS_ERR(fs_root)) {
 			err =3D PTR_ERR(fs_root);
+			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			goto out_free;
 		}
=20
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 360a728a639f..9bdcae8336ff 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -373,11 +373,13 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *tra=
ns,
 		leaf =3D path->nodes[0];
 		ref =3D btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
-
-		WARN_ON(btrfs_root_ref_dirid(leaf, ref) !=3D dirid);
-		WARN_ON(btrfs_root_ref_name_len(leaf, ref) !=3D name_len);
 		ptr =3D (unsigned long)(ref + 1);
-		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
+		if ((btrfs_root_ref_dirid(leaf, ref) !=3D dirid) ||
+		    (btrfs_root_ref_name_len(leaf, ref) !=3D name_len) ||
+		    memcmp_extent_buffer(leaf, name, ptr, name_len)) {
+			err =3D -ENOENT;
+			goto out;
+		}
 		*sequence =3D btrfs_root_ref_sequence(leaf, ref);
=20
 		ret =3D btrfs_del_item(trans, tree_root, path);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 70edd60db654..e3a687c472ec 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2637,7 +2637,7 @@ static noinline_for_stack int scrub_chunk(struct scru=
b_ctx *sctx,
 	if (!em)
 		return -EINVAL;
=20
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	if (em->start !=3D chunk_offset)
 		goto out;
=20
diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index b976597b0721..63ffd213b0b7 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -50,8 +50,8 @@ static inline void put_unaligned_le8(u8 val, void *p)
  */
=20
 #define DEFINE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
-			       unsigned long off,			\
+u##bits btrfs_get_token_##bits(const struct extent_buffer *eb,		\
+			       const void *ptr, unsigned long off,	\
 			       struct btrfs_map_token *token)		\
 {									\
 	unsigned long part_offset =3D (unsigned long)ptr;			\
@@ -90,7 +90,8 @@ u##bits btrfs_get_token_##bits(struct extent_buffer *eb, =
void *ptr,	\
 	return res;							\
 }									\
 void btrfs_set_token_##bits(struct extent_buffer *eb,			\
-			    void *ptr, unsigned long off, u##bits val,	\
+			    const void *ptr, unsigned long off,		\
+			    u##bits val,				\
 			    struct btrfs_map_token *token)		\
 {									\
 	unsigned long part_offset =3D (unsigned long)ptr;			\
@@ -133,7 +134,7 @@ DEFINE_BTRFS_SETGET_BITS(16)
 DEFINE_BTRFS_SETGET_BITS(32)
 DEFINE_BTRFS_SETGET_BITS(64)
=20
-void btrfs_node_key(struct extent_buffer *eb,
+void btrfs_node_key(const struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr)
 {
 	unsigned long ptr =3D btrfs_node_key_ptr_offset(nr);
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
new file mode 100644
index 000000000000..5b98f3c76ce4
--- /dev/null
+++ b/fs/btrfs/tree-checker.c
@@ -0,0 +1,649 @@
+/*
+ * Copyright (C) Qu Wenruo 2017.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program.
+ */
+
+/*
+ * The module is used to catch unexpected/corrupted tree block data.
+ * Such behavior can be caused either by a fuzzed image or bugs.
+ *
+ * The objective is to do leaf/node validation checks when tree block is r=
ead
+ * from disk, and check *every* possible member, so other code won't
+ * need to checking them again.
+ *
+ * Due to the potential and unwanted damage, every checker needs to be
+ * carefully reviewed otherwise so it does not prevent mount of valid imag=
es.
+ */
+
+#include "ctree.h"
+#include "tree-checker.h"
+#include "disk-io.h"
+#include "compression.h"
+#include "hash.h"
+#include "volumes.h"
+
+#define CORRUPT(reason, eb, root, slot)					\
+	btrfs_crit(root->fs_info,					\
+		   "corrupt %s, %s: block=3D%llu, root=3D%llu, slot=3D%d",	\
+		   btrfs_header_level(eb) =3D=3D 0 ? "leaf" : "node",	\
+		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
+
+/*
+ * Error message should follow the following format:
+ * corrupt <type>: <identifier>, <reason>[, <bad_value>]
+ *
+ * @type:	leaf or node
+ * @identifier:	the necessary info to locate the leaf/node.
+ * 		It's recommened to decode key.objecitd/offset if it's
+ * 		meaningful.
+ * @reason:	describe the error
+ * @bad_value:	optional, it's recommened to output bad value and its
+ *		expected value (range).
+ *
+ * Since comma is used to separate the components, only space is allowed
+ * inside each component.
+ */
+
+/*
+ * Append generic "corrupt leaf/node root=3D%llu block=3D%llu slot=3D%d: "=
 to @fmt.
+ * Allows callers to customize the output.
+ */
+__printf(4, 5)
+static void generic_err(const struct btrfs_root *root,
+			const struct extent_buffer *eb, int slot,
+			const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt =3D fmt;
+	vaf.va =3D &args;
+
+	btrfs_crit(root->fs_info,
+		"corrupt %s: root=3D%llu block=3D%llu slot=3D%d, %pV",
+		btrfs_header_level(eb) =3D=3D 0 ? "leaf" : "node",
+		root->objectid, btrfs_header_bytenr(eb), slot, &vaf);
+	va_end(args);
+}
+
+static int check_extent_data_item(struct btrfs_root *root,
+				  struct extent_buffer *leaf,
+				  struct btrfs_key *key, int slot)
+{
+	struct btrfs_file_extent_item *fi;
+	u32 sectorsize =3D root->sectorsize;
+	u32 item_size =3D btrfs_item_size_nr(leaf, slot);
+
+	if (!IS_ALIGNED(key->offset, sectorsize)) {
+		CORRUPT("unaligned key offset for file extent",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	fi =3D btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
+		CORRUPT("invalid file extent type", leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * Support for new compression/encrption must introduce incompat flag,
+	 * and must be caught in open_ctree().
+	 */
+	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
+		CORRUPT("invalid file extent compression", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (btrfs_file_extent_encryption(leaf, fi)) {
+		CORRUPT("invalid file extent encryption", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (btrfs_file_extent_type(leaf, fi) =3D=3D BTRFS_FILE_EXTENT_INLINE) {
+		/* Inline extent must have 0 as key offset */
+		if (key->offset) {
+			CORRUPT("inline extent has non-zero key offset",
+				leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/* Compressed inline extent has no on-disk size, skip it */
+		if (btrfs_file_extent_compression(leaf, fi) !=3D
+		    BTRFS_COMPRESS_NONE)
+			return 0;
+
+		/* Uncompressed inline extent size must match item size */
+		if (item_size !=3D BTRFS_FILE_EXTENT_INLINE_DATA_START +
+		    btrfs_file_extent_ram_bytes(leaf, fi)) {
+			CORRUPT("plaintext inline extent has invalid size",
+				leaf, root, slot);
+			return -EUCLEAN;
+		}
+		return 0;
+	}
+
+	/* Regular or preallocated extent has fixed item size */
+	if (item_size !=3D sizeof(*fi)) {
+		CORRUPT(
+		"regluar or preallocated extent data item size is invalid",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
+		CORRUPT(
+		"regular or preallocated extent data item has unaligned value",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
+static int check_csum_item(struct btrfs_root *root, struct extent_buffer *=
leaf,
+			   struct btrfs_key *key, int slot)
+{
+	u32 sectorsize =3D root->sectorsize;
+	u32 csumsize =3D btrfs_super_csum_size(root->fs_info->super_copy);
+
+	if (key->objectid !=3D BTRFS_EXTENT_CSUM_OBJECTID) {
+		CORRUPT("invalid objectid for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(key->offset, sectorsize)) {
+		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
+		CORRUPT("unaligned csum item size", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
+/*
+ * Customized reported for dir_item, only important new info is key->objec=
tid,
+ * which represents inode number
+ */
+__printf(4, 5)
+static void dir_item_err(const struct btrfs_root *root,
+			 const struct extent_buffer *eb, int slot,
+			 const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt =3D fmt;
+	vaf.va =3D &args;
+
+	btrfs_crit(root->fs_info,
+	"corrupt %s: root=3D%llu block=3D%llu slot=3D%d ino=3D%llu, %pV",
+		btrfs_header_level(eb) =3D=3D 0 ? "leaf" : "node", root->objectid,
+		btrfs_header_bytenr(eb), slot, key.objectid, &vaf);
+	va_end(args);
+}
+
+static int check_dir_item(struct btrfs_root *root,
+			  struct extent_buffer *leaf,
+			  struct btrfs_key *key, int slot)
+{
+	struct btrfs_dir_item *di;
+	u32 item_size =3D btrfs_item_size_nr(leaf, slot);
+	u32 cur =3D 0;
+
+	di =3D btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+	while (cur < item_size) {
+		u32 name_len;
+		u32 data_len;
+		u32 max_name_len;
+		u32 total_size;
+		u32 name_hash;
+		u8 dir_type;
+
+		/* header itself should not cross item boundary */
+		if (cur + sizeof(*di) > item_size) {
+			dir_item_err(root, leaf, slot,
+		"dir item header crosses item boundary, have %zu boundary %u",
+				cur + sizeof(*di), item_size);
+			return -EUCLEAN;
+		}
+
+		/* dir type check */
+		dir_type =3D btrfs_dir_type(leaf, di);
+		if (dir_type >=3D BTRFS_FT_MAX) {
+			dir_item_err(root, leaf, slot,
+			"invalid dir item type, have %u expect [0, %u)",
+				dir_type, BTRFS_FT_MAX);
+			return -EUCLEAN;
+		}
+
+		if (key->type =3D=3D BTRFS_XATTR_ITEM_KEY &&
+		    dir_type !=3D BTRFS_FT_XATTR) {
+			dir_item_err(root, leaf, slot,
+		"invalid dir item type for XATTR key, have %u expect %u",
+				dir_type, BTRFS_FT_XATTR);
+			return -EUCLEAN;
+		}
+		if (dir_type =3D=3D BTRFS_FT_XATTR &&
+		    key->type !=3D BTRFS_XATTR_ITEM_KEY) {
+			dir_item_err(root, leaf, slot,
+			"xattr dir type found for non-XATTR key");
+			return -EUCLEAN;
+		}
+		if (dir_type =3D=3D BTRFS_FT_XATTR)
+			max_name_len =3D XATTR_NAME_MAX;
+		else
+			max_name_len =3D BTRFS_NAME_LEN;
+
+		/* Name/data length check */
+		name_len =3D btrfs_dir_name_len(leaf, di);
+		data_len =3D btrfs_dir_data_len(leaf, di);
+		if (name_len > max_name_len) {
+			dir_item_err(root, leaf, slot,
+			"dir item name len too long, have %u max %u",
+				name_len, max_name_len);
+			return -EUCLEAN;
+		}
+		if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root)) {
+			dir_item_err(root, leaf, slot,
+			"dir item name and data len too long, have %u max %zu",
+				name_len + data_len,
+				BTRFS_MAX_XATTR_SIZE(root));
+			return -EUCLEAN;
+		}
+
+		if (data_len && dir_type !=3D BTRFS_FT_XATTR) {
+			dir_item_err(root, leaf, slot,
+			"dir item with invalid data len, have %u expect 0",
+				data_len);
+			return -EUCLEAN;
+		}
+
+		total_size =3D sizeof(*di) + name_len + data_len;
+
+		/* header and name/data should not cross item boundary */
+		if (cur + total_size > item_size) {
+			dir_item_err(root, leaf, slot,
+		"dir item data crosses item boundary, have %u boundary %u",
+				cur + total_size, item_size);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Special check for XATTR/DIR_ITEM, as key->offset is name
+		 * hash, should match its name
+		 */
+		if (key->type =3D=3D BTRFS_DIR_ITEM_KEY ||
+		    key->type =3D=3D BTRFS_XATTR_ITEM_KEY) {
+			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+
+			read_extent_buffer(leaf, namebuf,
+					(unsigned long)(di + 1), name_len);
+			name_hash =3D btrfs_name_hash(namebuf, name_len);
+			if (key->offset !=3D name_hash) {
+				dir_item_err(root, leaf, slot,
+		"name hash mismatch with key, have 0x%016x expect 0x%016llx",
+					name_hash, key->offset);
+				return -EUCLEAN;
+			}
+		}
+		cur +=3D total_size;
+		di =3D (struct btrfs_dir_item *)((void *)di + total_size);
+	}
+	return 0;
+}
+
+__printf(4, 5)
+__cold
+static void block_group_err(const struct btrfs_fs_info *fs_info,
+			    const struct extent_buffer *eb, int slot,
+			    const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt =3D fmt;
+	vaf.va =3D &args;
+
+	btrfs_crit(fs_info,
+	"corrupt %s: root=3D%llu block=3D%llu slot=3D%d bg_start=3D%llu bg_len=3D=
%llu, %pV",
+		btrfs_header_level(eb) =3D=3D 0 ? "leaf" : "node",
+		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
+		key.objectid, key.offset, &vaf);
+	va_end(args);
+}
+
+static int check_block_group_item(struct btrfs_fs_info *fs_info,
+				  struct extent_buffer *leaf,
+				  struct btrfs_key *key, int slot)
+{
+	struct btrfs_block_group_item bgi;
+	u32 item_size =3D btrfs_item_size_nr(leaf, slot);
+	u64 flags;
+	u64 type;
+
+	/*
+	 * Here we don't really care about alignment since extent allocator can
+	 * handle it.  We care more about the size, as if one block group is
+	 * larger than maximum size, it's must be some obvious corruption.
+	 */
+	if (key->offset > BTRFS_MAX_DATA_CHUNK_SIZE || key->offset =3D=3D 0) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid block group size, have %llu expect (0, %llu]",
+				key->offset, BTRFS_MAX_DATA_CHUNK_SIZE);
+		return -EUCLEAN;
+	}
+
+	if (item_size !=3D sizeof(bgi)) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid item size, have %u expect %zu",
+				item_size, sizeof(bgi));
+		return -EUCLEAN;
+	}
+
+	read_extent_buffer(leaf, &bgi, btrfs_item_ptr_offset(leaf, slot),
+			   sizeof(bgi));
+	if (btrfs_block_group_chunk_objectid(&bgi) !=3D
+	    BTRFS_FIRST_CHUNK_TREE_OBJECTID) {
+		block_group_err(fs_info, leaf, slot,
+		"invalid block group chunk objectid, have %llu expect %llu",
+				btrfs_block_group_chunk_objectid(&bgi),
+				BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+		return -EUCLEAN;
+	}
+
+	if (btrfs_block_group_used(&bgi) > key->offset) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid block group used, have %llu expect [0, %llu)",
+				btrfs_block_group_used(&bgi), key->offset);
+		return -EUCLEAN;
+	}
+
+	flags =3D btrfs_block_group_flags(&bgi);
+	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
+		block_group_err(fs_info, leaf, slot,
+"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 b=
it set",
+			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
+			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
+		return -EUCLEAN;
+	}
+
+	type =3D flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
+	if (type !=3D BTRFS_BLOCK_GROUP_DATA &&
+	    type !=3D BTRFS_BLOCK_GROUP_METADATA &&
+	    type !=3D BTRFS_BLOCK_GROUP_SYSTEM &&
+	    type !=3D (BTRFS_BLOCK_GROUP_METADATA |
+			   BTRFS_BLOCK_GROUP_DATA)) {
+		block_group_err(fs_info, leaf, slot,
+"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x=
%llx or 0x%llx",
+			type, hweight64(type),
+			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
+			BTRFS_BLOCK_GROUP_SYSTEM,
+			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
+/*
+ * Common point to switch the item-specific validation.
+ */
+static int check_leaf_item(struct btrfs_root *root,
+			   struct extent_buffer *leaf,
+			   struct btrfs_key *key, int slot)
+{
+	int ret =3D 0;
+
+	switch (key->type) {
+	case BTRFS_EXTENT_DATA_KEY:
+		ret =3D check_extent_data_item(root, leaf, key, slot);
+		break;
+	case BTRFS_EXTENT_CSUM_KEY:
+		ret =3D check_csum_item(root, leaf, key, slot);
+		break;
+	case BTRFS_DIR_ITEM_KEY:
+	case BTRFS_DIR_INDEX_KEY:
+	case BTRFS_XATTR_ITEM_KEY:
+		ret =3D check_dir_item(root, leaf, key, slot);
+		break;
+	case BTRFS_BLOCK_GROUP_ITEM_KEY:
+		ret =3D check_block_group_item(root->fs_info, leaf, key, slot);
+		break;
+	}
+	return ret;
+}
+
+static int check_leaf(struct btrfs_root *root, struct extent_buffer *leaf,
+		      bool check_item_data)
+{
+	struct btrfs_fs_info *fs_info =3D root->fs_info;
+	/* No valid key type is 0, so all key should be larger than this key */
+	struct btrfs_key prev_key =3D {0, 0, 0};
+	struct btrfs_key key;
+	u32 nritems =3D btrfs_header_nritems(leaf);
+	int slot;
+
+	if (btrfs_header_level(leaf) !=3D 0) {
+		generic_err(root, leaf, 0,
+			"invalid level for leaf, have %d expect 0",
+			btrfs_header_level(leaf));
+		return -EUCLEAN;
+	}
+
+	/*
+	 * Extent buffers from a relocation tree have a owner field that
+	 * corresponds to the subvolume tree they are based on. So just from an
+	 * extent buffer alone we can not find out what is the id of the
+	 * corresponding subvolume tree, so we can not figure out if the extent
+	 * buffer corresponds to the root of the relocation tree or not. So
+	 * skip this check for relocation trees.
+	 */
+	if (nritems =3D=3D 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)=
) {
+		u64 owner =3D btrfs_header_owner(leaf);
+		struct btrfs_root *check_root;
+
+		/* These trees must never be empty */
+		if (owner =3D=3D BTRFS_ROOT_TREE_OBJECTID ||
+		    owner =3D=3D BTRFS_CHUNK_TREE_OBJECTID ||
+		    owner =3D=3D BTRFS_EXTENT_TREE_OBJECTID ||
+		    owner =3D=3D BTRFS_DEV_TREE_OBJECTID ||
+		    owner =3D=3D BTRFS_FS_TREE_OBJECTID ||
+		    owner =3D=3D BTRFS_DATA_RELOC_TREE_OBJECTID) {
+			generic_err(root, leaf, 0,
+			"invalid root, root %llu must never be empty",
+				    owner);
+			return -EUCLEAN;
+		}
+		key.objectid =3D owner;
+		key.type =3D BTRFS_ROOT_ITEM_KEY;
+		key.offset =3D (u64)-1;
+
+		check_root =3D btrfs_get_fs_root(fs_info, &key, false);
+		/*
+		 * The only reason we also check NULL here is that during
+		 * open_ctree() some roots has not yet been set up.
+		 */
+		if (!IS_ERR_OR_NULL(check_root)) {
+			struct extent_buffer *eb;
+
+			eb =3D btrfs_root_node(check_root);
+			/* if leaf is the root, then it's fine */
+			if (leaf !=3D eb) {
+				CORRUPT("non-root leaf's nritems is 0",
+					leaf, check_root, 0);
+				free_extent_buffer(eb);
+				return -EUCLEAN;
+			}
+			free_extent_buffer(eb);
+		}
+		return 0;
+	}
+
+	if (nritems =3D=3D 0)
+		return 0;
+
+	/*
+	 * Check the following things to make sure this is a good leaf, and
+	 * leaf users won't need to bother with similar sanity checks:
+	 *
+	 * 1) key ordering
+	 * 2) item offset and size
+	 *    No overlap, no hole, all inside the leaf.
+	 * 3) item content
+	 *    If possible, do comprehensive sanity check.
+	 *    NOTE: All checks must only rely on the item data itself.
+	 */
+	for (slot =3D 0; slot < nritems; slot++) {
+		u32 item_end_expected;
+		int ret;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		/* Make sure the keys are in the right order */
+		if (btrfs_comp_cpu_keys(&prev_key, &key) >=3D 0) {
+			CORRUPT("bad key order", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Make sure the offset and ends are right, remember that the
+		 * item data starts at the end of the leaf and grows towards the
+		 * front.
+		 */
+		if (slot =3D=3D 0)
+			item_end_expected =3D BTRFS_LEAF_DATA_SIZE(root);
+		else
+			item_end_expected =3D btrfs_item_offset_nr(leaf,
+								 slot - 1);
+		if (btrfs_item_end_nr(leaf, slot) !=3D item_end_expected) {
+			CORRUPT("slot offset bad", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Check to make sure that we don't point outside of the leaf,
+		 * just in case all the items are consistent to each other, but
+		 * all point outside of the leaf.
+		 */
+		if (btrfs_item_end_nr(leaf, slot) >
+		    BTRFS_LEAF_DATA_SIZE(root)) {
+			CORRUPT("slot end outside of leaf", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/* Also check if the item pointer overlaps with btrfs item. */
+		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
+		    btrfs_item_ptr_offset(leaf, slot)) {
+			CORRUPT("slot overlap with its data", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		if (check_item_data) {
+			/*
+			 * Check if the item size and content meet other
+			 * criteria
+			 */
+			ret =3D check_leaf_item(root, leaf, &key, slot);
+			if (ret < 0)
+				return ret;
+		}
+
+		prev_key.objectid =3D key.objectid;
+		prev_key.type =3D key.type;
+		prev_key.offset =3D key.offset;
+	}
+
+	return 0;
+}
+
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *l=
eaf)
+{
+	return check_leaf(root, leaf, true);
+}
+
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf)
+{
+	return check_leaf(root, leaf, false);
+}
+
+int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
+{
+	unsigned long nr =3D btrfs_header_nritems(node);
+	struct btrfs_key key, next_key;
+	int slot;
+	int level =3D btrfs_header_level(node);
+	u64 bytenr;
+	int ret =3D 0;
+
+	if (level <=3D 0 || level >=3D BTRFS_MAX_LEVEL) {
+		generic_err(root, node, 0,
+			"invalid level for node, have %d expect [1, %d]",
+			level, BTRFS_MAX_LEVEL - 1);
+		return -EUCLEAN;
+	}
+	if (nr =3D=3D 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
+		btrfs_crit(root->fs_info,
+"corrupt node: root=3D%llu block=3D%llu, nritems too %s, have %lu expect r=
ange [1,%zu]",
+			   root->objectid, node->start,
+			   nr =3D=3D 0 ? "small" : "large", nr,
+			   BTRFS_NODEPTRS_PER_BLOCK(root));
+		return -EUCLEAN;
+	}
+
+	for (slot =3D 0; slot < nr - 1; slot++) {
+		bytenr =3D btrfs_node_blockptr(node, slot);
+		btrfs_node_key_to_cpu(node, &key, slot);
+		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
+
+		if (!bytenr) {
+			generic_err(root, node, slot,
+				"invalid NULL node pointer");
+			ret =3D -EUCLEAN;
+			goto out;
+		}
+		if (!IS_ALIGNED(bytenr, root->sectorsize)) {
+			generic_err(root, node, slot,
+			"unaligned pointer, have %llu should be aligned to %u",
+				bytenr, root->sectorsize);
+			ret =3D -EUCLEAN;
+			goto out;
+		}
+
+		if (btrfs_comp_cpu_keys(&key, &next_key) >=3D 0) {
+			generic_err(root, node, slot,
+	"bad key order, current (%llu %u %llu) next (%llu %u %llu)",
+				key.objectid, key.type, key.offset,
+				next_key.objectid, next_key.type,
+				next_key.offset);
+			ret =3D -EUCLEAN;
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
new file mode 100644
index 000000000000..3d53e8d6fda0
--- /dev/null
+++ b/fs/btrfs/tree-checker.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) Qu Wenruo 2017.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program.
+ */
+
+#ifndef __BTRFS_TREE_CHECKER__
+#define __BTRFS_TREE_CHECKER__
+
+#include "ctree.h"
+#include "extent_io.h"
+
+/*
+ * Comprehensive leaf checker.
+ * Will check not only the item pointers, but also every possible member
+ * in item data.
+ */
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *l=
eaf);
+
+/*
+ * Less strict leaf checker.
+ * Will only check item pointers, not reading item data.
+ */
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf);
+int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node);
+
+#endif
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f4e90842eb08..323a8f924896 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4583,9 +4583,29 @@ int btrfs_recover_log_trees(struct btrfs_root *log_r=
oot_tree)
 		wc.replay_dest =3D btrfs_read_fs_root_no_name(fs_info, &tmp_key);
 		if (IS_ERR(wc.replay_dest)) {
 			ret =3D PTR_ERR(wc.replay_dest);
+
+			/*
+			 * We didn't find the subvol, likely because it was
+			 * deleted.  This is ok, simply skip this log and go to
+			 * the next one.
+			 *
+			 * We need to exclude the root because we can't have
+			 * other log replays overwriting this log as we'll read
+			 * it back in a few more times.  This will keep our
+			 * block from being modified, and we'll just bail for
+			 * each subsequent pass.
+			 */
+			if (ret =3D=3D -ENOENT)
+				ret =3D btrfs_pin_extent_for_log_replay(
+							fs_info->extent_root,
+							log->node->start,
+							log->node->len);
 			free_extent_buffer(log->node);
 			free_extent_buffer(log->commit_root);
 			kfree(log);
+
+			if (!ret)
+				goto next;
 			btrfs_error(fs_info, ret, "Couldn't read target root "
 				    "for tree log recovery.");
 			goto error;
@@ -4600,7 +4620,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_ro=
ot_tree)
 						      path);
 		}
=20
-		key.offset =3D found_key.offset - 1;
 		wc.replay_dest->log_root =3D NULL;
 		free_extent_buffer(log->node);
 		free_extent_buffer(log->commit_root);
@@ -4608,9 +4627,10 @@ int btrfs_recover_log_trees(struct btrfs_root *log_r=
oot_tree)
=20
 		if (ret)
 			goto error;
-
+next:
 		if (found_key.offset =3D=3D 0)
 			break;
+		key.offset =3D found_key.offset - 1;
 	}
 	btrfs_release_path(path);
=20
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index f6a4c03ee7d8..dc29f56cc1b3 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -333,6 +333,8 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_in=
fo,
 				}
 				if (ret < 0 && ret !=3D -ENOENT)
 					goto out;
+				key.offset++;
+				goto again_search_slot;
 			}
 			item_size -=3D sizeof(subid_le);
 			offset +=3D sizeof(subid_le);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0ff553ed19b0..812b5e1f5697 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1047,7 +1047,7 @@ static int contains_pending_extent(struct btrfs_trans=
_handle *trans,
 		struct map_lookup *map;
 		int i;
=20
-		map =3D (struct map_lookup *)em->bdev;
+		map =3D em->map_lookup;
 		for (i =3D 0; i < map->num_stripes; i++) {
 			if (map->stripes[i].dev !=3D device)
 				continue;
@@ -2533,7 +2533,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *ro=
ot,
=20
 	BUG_ON(!em || em->start > chunk_offset ||
 	       em->start + em->len < chunk_offset);
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
=20
 	for (i =3D 0; i < map->num_stripes; i++) {
 		ret =3D btrfs_free_dev_extent(trans, map->stripes[i].dev,
@@ -3248,7 +3248,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	}
=20
-	num_devices =3D fs_info->fs_devices->num_devices;
+	/*
+	 * rw_devices will not change at the moment, device add/delete/replace
+	 * are excluded by EXCL_OP
+	 */
+	num_devices =3D fs_info->fs_devices->rw_devices;
 	btrfs_dev_replace_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		BUG_ON(num_devices < 1);
@@ -4134,7 +4138,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_han=
dle *trans,
=20
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size =3D 1024 * 1024 * 1024;
-		max_chunk_size =3D 10 * max_stripe_size;
+		max_chunk_size =3D BTRFS_MAX_DATA_CHUNK_SIZE;
 		if (!devs_max)
 			devs_max =3D BTRFS_MAX_DEVS(info->chunk_root);
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
@@ -4322,7 +4326,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_han=
dle *trans,
 		goto error;
 	}
 	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
-	em->bdev =3D (struct block_device *)map;
+	em->map_lookup =3D map;
 	em->start =3D start;
 	em->len =3D num_bytes;
 	em->block_start =3D 0;
@@ -4405,7 +4409,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handl=
e *trans,
 		return -EINVAL;
 	}
=20
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	item_size =3D btrfs_chunk_item_size(map->num_stripes);
 	stripe_size =3D em->orig_block_len;
=20
@@ -4547,7 +4551,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64=
 chunk_offset)
 		return 0;
 	}
=20
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	for (i =3D 0; i < map->num_stripes; i++) {
 		if (!map->stripes[i].dev->writeable) {
 			readonly =3D 1;
@@ -4613,7 +4617,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u=
64 logical, u64 len)
 		return 1;
 	}
=20
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret =3D map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
@@ -4649,7 +4653,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_root=
 *root,
 	BUG_ON(!em);
=20
 	BUG_ON(em->start > logical || em->start + em->len < logical);
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6)) {
 		len =3D map->stripe_len * nr_data_stripes(map);
@@ -4672,7 +4676,7 @@ int btrfs_is_parity_mirror(struct btrfs_mapping_tree =
*map_tree,
 	BUG_ON(!em);
=20
 	BUG_ON(em->start > logical || em->start + em->len < logical);
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6))
 		ret =3D 1;
@@ -4794,7 +4798,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs=
_info, int rw,
 		return -EINVAL;
 	}
=20
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
 	offset =3D logical - em->start;
=20
 	stripe_len =3D map->stripe_len;
@@ -5321,7 +5325,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_t=
ree,
 		free_extent_map(em);
 		return -EIO;
 	}
-	map =3D (struct map_lookup *)em->bdev;
+	map =3D em->map_lookup;
=20
 	length =3D em->len;
 	rmap_len =3D map->stripe_len;
@@ -5805,6 +5809,101 @@ struct btrfs_device *btrfs_alloc_device(struct btrf=
s_fs_info *fs_info,
 	return dev;
 }
=20
+/* Return -EIO if any error, otherwise return 0. */
+static int btrfs_check_chunk_valid(struct btrfs_root *root,
+				   struct extent_buffer *leaf,
+				   struct btrfs_chunk *chunk, u64 logical)
+{
+	u64 length;
+	u64 stripe_len;
+	u16 num_stripes;
+	u16 sub_stripes;
+	u64 type;
+	u64 features;
+	bool mixed =3D false;
+
+	length =3D btrfs_chunk_length(leaf, chunk);
+	stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes =3D btrfs_chunk_num_stripes(leaf, chunk);
+	sub_stripes =3D btrfs_chunk_sub_stripes(leaf, chunk);
+	type =3D btrfs_chunk_type(leaf, chunk);
+
+	if (!num_stripes) {
+		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
+			  num_stripes);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(logical, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			  "invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (btrfs_chunk_sector_size(leaf, chunk) !=3D root->sectorsize) {
+		btrfs_err(root->fs_info, "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			"invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len)) {
+		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
+			  stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    type) {
+		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=3D 0) {
+		btrfs_err(root->fs_info, "missing chunk type flag: 0x%llx", type);
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+		btrfs_err(root->fs_info,
+			"system chunk with data or metadata type: 0x%llx", type);
+		return -EIO;
+	}
+
+	features =3D btrfs_super_incompat_flags(root->fs_info->super_copy);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed =3D true;
+
+	if (!mixed) {
+		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+		    (type & BTRFS_BLOCK_GROUP_DATA)) {
+			btrfs_err(root->fs_info,
+			"mixed chunk type in non-mixed mode: 0x%llx", type);
+			return -EIO;
+		}
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes !=3D 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes !=3D 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes !=3D 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) =3D=3D 0 &&
+	     num_stripes !=3D 1)) {
+		btrfs_err(root->fs_info,
+			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			num_stripes, sub_stripes,
+			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -5814,6 +5913,7 @@ static int read_one_chunk(struct btrfs_root *root, st=
ruct btrfs_key *key,
 	struct extent_map *em;
 	u64 logical;
 	u64 length;
+	u64 stripe_len;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int num_stripes;
@@ -5822,6 +5922,12 @@ static int read_one_chunk(struct btrfs_root *root, s=
truct btrfs_key *key,
=20
 	logical =3D key->offset;
 	length =3D btrfs_chunk_length(leaf, chunk);
+	stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes =3D btrfs_chunk_num_stripes(leaf, chunk);
+
+	ret =3D btrfs_check_chunk_valid(root, leaf, chunk, logical);
+	if (ret)
+		return ret;
=20
 	read_lock(&map_tree->map_tree.lock);
 	em =3D lookup_extent_mapping(&map_tree->map_tree, logical, 1);
@@ -5838,7 +5944,6 @@ static int read_one_chunk(struct btrfs_root *root, st=
ruct btrfs_key *key,
 	em =3D alloc_extent_map();
 	if (!em)
 		return -ENOMEM;
-	num_stripes =3D btrfs_chunk_num_stripes(leaf, chunk);
 	map =3D kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
 		free_extent_map(em);
@@ -5846,7 +5951,7 @@ static int read_one_chunk(struct btrfs_root *root, st=
ruct btrfs_key *key,
 	}
=20
 	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
-	em->bdev =3D (struct block_device *)map;
+	em->map_lookup =3D map;
 	em->start =3D logical;
 	em->len =3D length;
 	em->orig_start =3D 0;
@@ -6032,13 +6137,14 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
-	u8 *ptr;
-	unsigned long sb_ptr;
+	u8 *array_ptr;
+	unsigned long sb_array_offset;
 	int ret =3D 0;
 	u32 num_stripes;
 	u32 array_size;
 	u32 len =3D 0;
-	u32 cur;
+	u32 cur_offset;
+	u64 type;
 	struct btrfs_key key;
=20
 	sb =3D btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -6065,35 +6171,73 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size =3D btrfs_super_sys_array_size(super_copy);
=20
-	ptr =3D super_copy->sys_chunk_array;
-	sb_ptr =3D offsetof(struct btrfs_super_block, sys_chunk_array);
-	cur =3D 0;
+	array_ptr =3D super_copy->sys_chunk_array;
+	sb_array_offset =3D offsetof(struct btrfs_super_block, sys_chunk_array);
+	cur_offset =3D 0;
+
+	while (cur_offset < array_size) {
+		disk_key =3D (struct btrfs_disk_key *)array_ptr;
+		len =3D sizeof(*disk_key);
+		if (cur_offset + len > array_size)
+			goto out_short_read;
=20
-	while (cur < array_size) {
-		disk_key =3D (struct btrfs_disk_key *)ptr;
 		btrfs_disk_key_to_cpu(&key, disk_key);
=20
-		len =3D sizeof(*disk_key); ptr +=3D len;
-		sb_ptr +=3D len;
-		cur +=3D len;
+		array_ptr +=3D len;
+		sb_array_offset +=3D len;
+		cur_offset +=3D len;
=20
 		if (key.type =3D=3D BTRFS_CHUNK_ITEM_KEY) {
-			chunk =3D (struct btrfs_chunk *)sb_ptr;
+			chunk =3D (struct btrfs_chunk *)sb_array_offset;
+			/*
+			 * At least one btrfs_chunk with one stripe must be
+			 * present, exact stripe count check comes afterwards
+			 */
+			len =3D btrfs_chunk_item_size(1);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
+			num_stripes =3D btrfs_chunk_num_stripes(sb, chunk);
+			if (!num_stripes) {
+				printk(KERN_ERR
+	    "BTRFS: invalid number of stripes %u in sys_array at offset %u\n",
+					num_stripes, cur_offset);
+				ret =3D -EIO;
+				break;
+			}
+
+			type =3D btrfs_chunk_type(sb, chunk);
+			if ((type & BTRFS_BLOCK_GROUP_SYSTEM) =3D=3D 0) {
+				btrfs_err(root->fs_info,
+			    "invalid chunk type %llu in sys_array at offset %u",
+					type, cur_offset);
+				ret =3D -EIO;
+				break;
+			}
+
+			len =3D btrfs_chunk_item_size(num_stripes);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
 			ret =3D read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
-			num_stripes =3D btrfs_chunk_num_stripes(sb, chunk);
-			len =3D btrfs_chunk_item_size(num_stripes);
 		} else {
 			ret =3D -EIO;
 			break;
 		}
-		ptr +=3D len;
-		sb_ptr +=3D len;
-		cur +=3D len;
+		array_ptr +=3D len;
+		sb_array_offset +=3D len;
+		cur_offset +=3D len;
 	}
 	free_extent_buffer(sb);
 	return ret;
+
+out_short_read:
+	printk(KERN_ERR "BTRFS: sys_array too short to read %u bytes at offset %u=
\n",
+			len, cur_offset);
+	free_extent_buffer(sb);
+	return -EIO;
 }
=20
 int btrfs_read_chunk_tree(struct btrfs_root *root)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4292c68196ff..9c6a1cfa122d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -24,6 +24,8 @@
 #include <linux/btrfs.h>
 #include "async-thread.h"
=20
+#define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
+
 #define BTRFS_STRIPE_LEN	(64 * 1024)
=20
 struct buffer_head;
diff --git a/fs/char_dev.c b/fs/char_dev.c
index f77f7702fabe..abed99abcf5a 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -348,7 +348,7 @@ static struct kobject *cdev_get(struct cdev *p)
=20
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj =3D kobject_get(&p->kobj);
+	kobj =3D kobject_get_unless_zero(&p->kobj);
 	if (!kobj)
 		module_put(owner);
 	return kobj;
@@ -488,6 +488,85 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	return 0;
 }
=20
+/**
+ * cdev_set_parent() - set the parent kobject for a char device
+ * @p: the cdev structure
+ * @kobj: the kobject to take a reference to
+ *
+ * cdev_set_parent() sets a parent kobject which will be referenced
+ * appropriately so the parent is not freed before the cdev. This
+ * should be called before cdev_add.
+ */
+void cdev_set_parent(struct cdev *p, struct kobject *kobj)
+{
+	WARN_ON(!kobj->state_initialized);
+	p->kobj.parent =3D kobj;
+}
+
+/**
+ * cdev_device_add() - add a char device and it's corresponding
+ *	struct device, linkink
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_add() adds the char device represented by @cdev to the syst=
em,
+ * just as cdev_add does. It then adds @dev to the system using device_add
+ * The dev_t for the char device will be taken from the struct device which
+ * needs to be initialized first. This helper function correctly takes a
+ * reference to the parent device so the parent will not get released until
+ * all references to the cdev are released.
+ *
+ * This helper uses dev->devt for the device number. If it is not set
+ * it will not add the cdev and it will be equivalent to device_add.
+ *
+ * This function should be used whenever the struct cdev and the
+ * struct device are members of the same structure whose lifetime is
+ * managed by the struct device.
+ *
+ * NOTE: Callers must assume that userspace was able to open the cdev and
+ * can call cdev fops callbacks at any time, even if this function fails.
+ */
+int cdev_device_add(struct cdev *cdev, struct device *dev)
+{
+	int rc =3D 0;
+
+	if (dev->devt) {
+		cdev_set_parent(cdev, &dev->kobj);
+
+		rc =3D cdev_add(cdev, dev->devt, 1);
+		if (rc)
+			return rc;
+	}
+
+	rc =3D device_add(dev);
+	if (rc)
+		cdev_del(cdev);
+
+	return rc;
+}
+
+/**
+ * cdev_device_del() - inverse of cdev_device_add
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_del() is a helper function to call cdev_del and device_del.
+ * It should be used whenever cdev_device_add is used.
+ *
+ * If dev->devt is not set it will not remove the cdev and will be equival=
ent
+ * to device_del.
+ *
+ * NOTE: This guarantees that associated sysfs callbacks are not running
+ * or runnable, however any cdevs already open will remain and their fops
+ * will still be callable even after this function returns.
+ */
+void cdev_device_del(struct cdev *cdev, struct device *dev)
+{
+	device_del(dev);
+	if (dev->devt)
+		cdev_del(cdev);
+}
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
@@ -499,6 +578,10 @@ static void cdev_unmap(dev_t dev, unsigned count)
  *
  * cdev_del() removes @p from the system, possibly freeing the structure
  * itself.
+ *
+ * NOTE: This guarantees that cdev device will no longer be able to be
+ * opened, however any cdevs already open will remain and their fops will
+ * still be callable even after cdev_del returns.
  */
 void cdev_del(struct cdev *p)
 {
@@ -589,6 +672,9 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(cdev_set_parent);
+EXPORT_SYMBOL(cdev_device_add);
+EXPORT_SYMBOL(cdev_device_del);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
 EXPORT_SYMBOL(directly_mappable_cdev_bdi);
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 20e6a870d114..4d17006a1b8e 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -78,6 +78,11 @@ int __ext4_check_dir_entry(const char *function, unsigne=
d int line,
 		error_msg =3D "rec_len is too small for name_len";
 	else if (unlikely(((char *) de - buf) + rlen > size))
 		error_msg =3D "directory entry overrun";
+	else if (unlikely(((char *) de - buf) + rlen >
+			  size - EXT4_DIR_REC_LEN(1) &&
+			  ((char *) de - buf) + rlen !=3D size)) {
+		error_msg =3D "directory entry too close to block end";
+	}
 	else if (unlikely(le32_to_cpu(de->inode) >
 			le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg =3D "inode out of bounds";
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 550a1bfe98d1..09e978818474 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -937,6 +937,15 @@ struct ext4_inode_info {
 	 * by other means, so we have i_data_sem.
 	 */
 	struct rw_semaphore i_data_sem;
+	/*
+	 * i_mmap_sem is for serializing page faults with truncate / punch hole
+	 * operations. We have to make sure that new page cannot be faulted in
+	 * a section of the inode that is being punched. We cannot easily use
+	 * i_data_sem for this since we need protection for the whole punch
+	 * operation and i_data_sem ranks below transaction start so we have
+	 * to occasionally drop it.
+	 */
+	struct rw_semaphore i_mmap_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
=20
@@ -2205,6 +2214,7 @@ extern int ext4_chunk_trans_blocks(struct inode *, in=
t nrblocks);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *=
vmf);
+extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault =
*vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
@@ -2550,6 +2560,9 @@ static inline int ext4_update_inode_size(struct inode=
 *inode, loff_t newsize)
 	return changed;
 }
=20
+int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
+				      loff_t len);
+
 struct ext4_group_info {
 	unsigned long   bb_state;
 	struct rb_root  bb_free_root;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 25620fc51bf3..02dca6c43316 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4772,7 +4772,6 @@ static long ext4_zero_range(struct file *file, loff_t=
 offset,
 	int partial_begin, partial_end;
 	loff_t start, end;
 	ext4_lblk_t lblk;
-	struct address_space *mapping =3D inode->i_mapping;
 	unsigned int blkbits =3D inode->i_blkbits;
=20
 	trace_ext4_zero_range(inode, offset, len, mode);
@@ -4787,17 +4786,6 @@ static long ext4_zero_range(struct file *file, loff_=
t offset,
 			return ret;
 	}
=20
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret =3D filemap_write_and_wait_range(mapping, offset,
-						   offset + len - 1);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * Round up offset. This is not fallocate, we neet to zero out
 	 * blocks, so convert interior block aligned part of the range to
@@ -4842,6 +4830,10 @@ static long ext4_zero_range(struct file *file, loff_=
t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |=3D EXT4_GET_BLOCKS_KEEP_SIZE;
=20
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret =3D ext4_alloc_file_blocks(file,
@@ -4850,7 +4842,7 @@ static long ext4_zero_range(struct file *file, loff_t=
 offset,
 				 round_down(offset, 1 << blkbits)) >> blkbits,
 				new_size, flags, mode);
 		if (ret)
-			goto out_mutex;
+			goto out_dio;
=20
 	}
=20
@@ -4859,16 +4851,23 @@ static long ext4_zero_range(struct file *file, loff=
_t offset,
 		flags |=3D (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
 			  EXT4_EX_NOCACHE);
=20
-		/* Now release the pages and zero block aligned part of pages*/
+		/*
+		 * Prevent page faults from reinstantiating pages we have
+		 * released from page cache.
+		 */
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		ret =3D ext4_update_disksize_before_punch(inode, offset, len);
+		if (ret) {
+			up_write(&EXT4_I(inode)->i_mmap_sem);
+			goto out_dio;
+		}
+		/* Now release the pages and zero block aligned part of pages */
 		truncate_pagecache_range(inode, start, end - 1);
 		inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
=20
-		/* Wait all existing dio workers, newcomers will block on i_mutex */
-		ext4_inode_block_unlocked_dio(inode);
-		inode_dio_wait(inode);
-
 		ret =3D ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
 					     flags, mode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 		if (ret)
 			goto out_dio;
 	}
@@ -4985,8 +4984,13 @@ long ext4_fallocate(struct file *file, int mode, lof=
f_t offset, loff_t len)
 			goto out;
 	}
=20
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	ret =3D ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
 				     flags, mode);
+	ext4_inode_resume_unlocked_dio(inode);
 	if (ret)
 		goto out;
=20
@@ -5454,21 +5458,7 @@ int ext4_collapse_range(struct inode *inode, loff_t =
offset, loff_t len)
 			return ret;
 	}
=20
-	/*
-	 * Need to round down offset to be aligned with page size boundary
-	 * for page size > block size.
-	 */
-	ioffset =3D round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret =3D filemap_write_and_wait_range(inode->i_mapping, ioffset,
-					   LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -5484,17 +5474,43 @@ int ext4_collapse_range(struct inode *inode, loff_t=
 offset, loff_t len)
 		goto out_mutex;
 	}
=20
-	truncate_pagecache(inode, ioffset);
-
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
 	inode_dio_wait(inode);
=20
+	/*
+	 * Prevent page faults from reinstantiating pages we have released from
+	 * page cache.
+	 */
+	down_write(&EXT4_I(inode)->i_mmap_sem);
+	/*
+	 * Need to round down offset to be aligned with page size boundary
+	 * for page size > block size.
+	 */
+	ioffset =3D round_down(offset, PAGE_SIZE);
+	/*
+	 * Write tail of the last page before removed range since it will get
+	 * removed from the page cache below.
+	 */
+	ret =3D filemap_write_and_wait_range(inode->i_mapping, ioffset, offset);
+	if (ret)
+		goto out_mmap;
+	/*
+	 * Write data that will be shifted to preserve them when discarding
+	 * page cache below. We are also protected from pages becoming dirty
+	 * by i_mmap_sem.
+	 */
+	ret =3D filemap_write_and_wait_range(inode->i_mapping, offset + len,
+					   LLONG_MAX);
+	if (ret)
+		goto out_mmap;
+	truncate_pagecache(inode, ioffset);
+
 	credits =3D ext4_writepage_trans_blocks(inode);
 	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
-		goto out_dio;
+		goto out_mmap;
 	}
=20
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -5534,7 +5550,8 @@ int ext4_collapse_range(struct inode *inode, loff_t o=
ffset, loff_t len)
=20
 out_stop:
 	ext4_journal_stop(handle);
-out_dio:
+out_mmap:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 773b653bae51..20c76e3250d9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -199,7 +199,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_ite=
r *from)
 }
=20
 static const struct vm_operations_struct ext4_file_vm_ops =3D {
-	.fault		=3D filemap_fault,
+	.fault		=3D ext4_filemap_fault,
 	.map_pages	=3D filemap_map_pages,
 	.page_mkwrite   =3D ext4_page_mkwrite,
 };
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5e07fcdef52f..66aed5f01784 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3651,6 +3651,35 @@ int ext4_can_truncate(struct inode *inode)
 	return 0;
 }
=20
+/*
+ * We have to make sure i_disksize gets properly updated before we truncate
+ * page cache due to hole punching or zero range. Otherwise i_disksize upd=
ate
+ * can get lost as it may have been postponed to submission of writeback b=
ut
+ * that will never happen after we truncate page cache.
+ */
+int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
+				      loff_t len)
+{
+	handle_t *handle;
+	loff_t size =3D i_size_read(inode);
+
+	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	if (offset > size || offset + len < size)
+		return 0;
+
+	if (EXT4_I(inode)->i_disksize >=3D size)
+		return 0;
+
+	handle =3D ext4_journal_start(inode, EXT4_HT_MISC, 1);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	ext4_update_i_disksize(inode, size);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	return 0;
+}
+
 /*
  * ext4_punch_hole: punches a hole in a file by releaseing the blocks
  * associated with the given offset and length
@@ -3716,17 +3745,26 @@ int ext4_punch_hole(struct inode *inode, loff_t off=
set, loff_t length)
=20
 	}
=20
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
+	/*
+	 * Prevent page faults from reinstantiating pages we have released from
+	 * page cache.
+	 */
+	down_write(&EXT4_I(inode)->i_mmap_sem);
 	first_block_offset =3D round_up(offset, sb->s_blocksize);
 	last_block_offset =3D round_down((offset + length), sb->s_blocksize) - 1;
=20
 	/* Now release the pages and zero block aligned part of pages*/
-	if (last_block_offset > first_block_offset)
+	if (last_block_offset > first_block_offset) {
+		ret =3D ext4_update_disksize_before_punch(inode, offset, length);
+		if (ret)
+			goto out_dio;
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
-
-	/* Wait all existing dio workers, newcomers will block on i_mutex */
-	ext4_inode_block_unlocked_dio(inode);
-	inode_dio_wait(inode);
+	}
=20
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits =3D ext4_writepage_trans_blocks(inode);
@@ -3773,11 +3811,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offs=
et, loff_t length)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
=20
-	/* Now release the pages again to reduce race window */
-	if (last_block_offset > first_block_offset)
-		truncate_pagecache_range(inode, first_block_offset,
-					 last_block_offset);
-
 	inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	if (ret >=3D 0)
@@ -3785,6 +3818,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offse=
t, loff_t length)
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
@@ -4809,8 +4843,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr=
 *attr)
 		ext4_journal_stop(handle);
 	}
=20
-	if (attr->ia_valid & ATTR_SIZE && attr->ia_size !=3D inode->i_size) {
+	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
+		loff_t oldsize =3D inode->i_size;
+		int shrink =3D (attr->ia_size <=3D inode->i_size);
=20
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
@@ -4818,27 +4854,37 @@ int ext4_setattr(struct dentry *dentry, struct iatt=
r *attr)
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
+		if (!S_ISREG(inode->i_mode))
+			return -EINVAL;
=20
 		if (IS_I_VERSION(inode) && attr->ia_size !=3D inode->i_size)
 			inode_inc_iversion(inode);
=20
-		if (S_ISREG(inode->i_mode) &&
+		if (ext4_should_order_data(inode) &&
 		    (attr->ia_size < inode->i_size)) {
-			if (ext4_should_order_data(inode)) {
-				error =3D ext4_begin_ordered_truncate(inode,
+			error =3D ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
-				if (error)
-					goto err_out;
-			}
+			if (error)
+				goto err_out;
+		}
+		if (attr->ia_size !=3D inode->i_size) {
 			handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 3);
 			if (IS_ERR(handle)) {
 				error =3D PTR_ERR(handle);
 				goto err_out;
 			}
-			if (ext4_handle_valid(handle)) {
+			if (ext4_handle_valid(handle) && shrink) {
 				error =3D ext4_orphan_add(handle, inode);
 				orphan =3D 1;
 			}
+			/*
+			 * Update c/mtime on truncate up, ext4_truncate() will
+			 * update c/mtime in shrink case below
+			 */
+			if (!shrink) {
+				inode->i_mtime =3D ext4_current_time(inode);
+				inode->i_ctime =3D inode->i_mtime;
+			}
 			down_write(&EXT4_I(inode)->i_data_sem);
 			EXT4_I(inode)->i_disksize =3D attr->ia_size;
 			rc =3D ext4_mark_inode_dirty(handle, inode);
@@ -4854,15 +4900,13 @@ int ext4_setattr(struct dentry *dentry, struct iatt=
r *attr)
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error) {
-				ext4_orphan_del(NULL, inode);
+				if (orphan)
+					ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else {
-			loff_t oldsize =3D inode->i_size;
-
-			i_size_write(inode, attr->ia_size);
-			pagecache_isize_extended(inode, oldsize, inode->i_size);
 		}
+		if (!shrink)
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
=20
 		/*
 		 * Blocks are going to be removed from the inode. Wait
@@ -4877,18 +4921,16 @@ int ext4_setattr(struct dentry *dentry, struct iatt=
r *attr)
 			} else
 				ext4_wait_for_tail_page_commit(inode);
 		}
+		down_write(&EXT4_I(inode)->i_mmap_sem);
 		/*
 		 * Truncate pagecache after we've waited for commit
 		 * in data=3Djournal mode to make pages freeable.
 		 */
 			truncate_pagecache(inode, inode->i_size);
+		if (shrink)
+			ext4_truncate(inode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 	}
-	/*
-	 * We want to call ext4_truncate() even if attr->ia_size =3D=3D
-	 * inode->i_size for cases like truncation of fallocated space
-	 */
-	if (attr->ia_valid & ATTR_SIZE)
-		ext4_truncate(inode);
=20
 	if (!rc) {
 		setattr_copy(inode, attr);
@@ -5340,6 +5382,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, str=
uct vm_fault *vmf)
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
=20
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+
 	ret =3D ext4_convert_inline_data(inode);
 	if (ret)
 		goto out_ret;
@@ -5413,6 +5457,19 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, st=
ruct vm_fault *vmf)
 out_ret:
 	ret =3D block_page_mkwrite_return(ret);
 out:
+	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
+
+int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct inode *inode =3D file_inode(vma->vm_file);
+	int err;
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	err =3D filemap_fault(vma, vmf);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+
+	return err;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7410cca5bf39..a0864cc67b03 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -967,6 +967,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&ei->i_orphan);
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
+	init_rwsem(&ei->i_mmap_sem);
 	inode_init_once(&ei->vfs_inode);
 }
=20
diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
index 011ba6670d99..c70d06a383e2 100644
--- a/fs/ext4/truncate.h
+++ b/fs/ext4/truncate.h
@@ -10,8 +10,10 @@
  */
 static inline void ext4_truncate_failed_write(struct inode *inode)
 {
+	down_write(&EXT4_I(inode)->i_mmap_sem);
 	truncate_inode_pages(inode->i_mapping, inode->i_size);
 	ext4_truncate(inode);
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 }
=20
 /*
diff --git a/fs/inode.c b/fs/inode.c
index 49df50c900ca..dd757025ecbe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -131,6 +131,7 @@ int inode_init_always(struct super_block *sb, struct in=
ode *inode)
 	inode->i_sb =3D sb;
 	inode->i_blkbits =3D sb->s_blocksize_bits;
 	inode->i_flags =3D 0;
+	atomic64_set(&inode->i_sequence, 0);
 	atomic_set(&inode->i_count, 1);
 	inode->i_op =3D &empty_iops;
 	inode->i_fop =3D &empty_fops;
diff --git a/fs/locks.c b/fs/locks.c
index 10bd454eaf98..c5303e2ac167 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2488,7 +2488,7 @@ static void lock_get_status(struct seq_file *f, struc=
t file_lock *fl,
 				inode->i_sb->s_id, inode->i_ino);
 #else
 		/* userspace relies on this representation of dev_t ;-( */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 #endif
diff --git a/fs/namei.c b/fs/namei.c
index 2ec89079ddbd..aa4e00cb4dd7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -723,6 +723,8 @@ static inline void put_link(struct nameidata *nd, struc=
t path *link, void *cooki
=20
 int sysctl_protected_symlinks __read_mostly =3D 0;
 int sysctl_protected_hardlinks __read_mostly =3D 0;
+int sysctl_protected_fifos __read_mostly;
+int sysctl_protected_regular __read_mostly;
=20
 /**
  * may_follow_link - Check symlink following for unsafe situations
@@ -837,6 +839,46 @@ static int may_linkat(struct path *link)
 	return -EPERM;
 }
=20
+/**
+ * may_create_in_sticky - Check whether an O_CREAT open in a sticky direct=
ory
+ *			  should be allowed, or not, on files that already
+ *			  exist.
+ * @dir_mode: mode bits of directory
+ * @dir_uid: owner of directory
+ * @inode: the inode of the file to open
+ *
+ * Block an O_CREAT open of a FIFO (or a regular file) when:
+ *   - sysctl_protected_fifos (or sysctl_protected_regular) is enabled
+ *   - the file already exists
+ *   - we are in a sticky directory
+ *   - we don't own the file
+ *   - the owner of the directory doesn't own the file
+ *   - the directory is world writable
+ * If the sysctl_protected_fifos (or sysctl_protected_regular) is set to 2
+ * the directory doesn't have to be world writable: being group writable w=
ill
+ * be enough.
+ *
+ * Returns 0 if the open is allowed, -ve on error.
+ */
+static int may_create_in_sticky(umode_t dir_mode, kuid_t dir_uid,
+				struct inode * const inode)
+{
+	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
+	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
+	    likely(!(dir_mode & S_ISVTX)) ||
+	    uid_eq(inode->i_uid, dir_uid) ||
+	    uid_eq(current_fsuid(), inode->i_uid))
+		return 0;
+
+	if (likely(dir_mode & 0002) ||
+	    (dir_mode & 0020 &&
+	     ((sysctl_protected_fifos >=3D 2 && S_ISFIFO(inode->i_mode)) ||
+	      (sysctl_protected_regular >=3D 2 && S_ISREG(inode->i_mode))))) {
+		return -EACCES;
+	}
+	return 0;
+}
+
 static __always_inline int
 follow_link(struct path *link, struct nameidata *nd, void **p)
 {
@@ -2903,6 +2945,8 @@ static int do_last(struct nameidata *nd, struct path =
*path,
 		   int *opened, struct filename *name)
 {
 	struct dentry *dir =3D nd->path.dentry;
+	kuid_t dir_uid =3D nd->inode->i_uid;
+	umode_t dir_mode =3D nd->inode->i_mode;
 	int open_flag =3D op->open_flag;
 	bool will_truncate =3D (open_flag & O_TRUNC) !=3D 0;
 	bool got_write =3D false;
@@ -3057,9 +3101,15 @@ static int do_last(struct nameidata *nd, struct path=
 *path,
 		return error;
 	}
 	audit_inode(name, nd->path.dentry, 0);
-	error =3D -EISDIR;
-	if ((open_flag & O_CREAT) && d_is_dir(nd->path.dentry))
-		goto out;
+	if (open_flag & O_CREAT) {
+		error =3D -EISDIR;
+		if (d_is_dir(nd->path.dentry))
+			goto out;
+		error =3D may_create_in_sticky(dir_mode, dir_uid,
+					     d_backing_inode(nd->path.dentry));
+		if (unlikely(error))
+			goto out;
+	}
 	error =3D -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b992a89abde2..5ed3e773c2e0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -284,6 +284,7 @@ struct queue_limits {
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
 	unsigned int		physical_block_size;
+	unsigned int		logical_block_size;
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
@@ -292,7 +293,6 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
=20
-	unsigned short		logical_block_size;
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
=20
@@ -447,7 +447,7 @@ struct request_queue {
 	unsigned int		sg_reserved_size;
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
-	struct blk_trace	*blk_trace;
+	struct blk_trace __rcu	*blk_trace;
 	struct mutex		blk_trace_mutex;
 #endif
 	/*
@@ -1017,7 +1017,7 @@ extern void blk_queue_max_discard_sectors(struct requ=
est_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
-extern void blk_queue_logical_block_size(struct request_queue *, unsigned =
short);
+extern void blk_queue_logical_block_size(struct request_queue *, unsigned =
int);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned=
 int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
@@ -1232,7 +1232,7 @@ static inline unsigned int queue_max_segment_size(str=
uct request_queue *q)
 	return q->limits.max_segment_size;
 }
=20
-static inline unsigned short queue_logical_block_size(struct request_queue=
 *q)
+static inline unsigned queue_logical_block_size(struct request_queue *q)
 {
 	int retval =3D 512;
=20
@@ -1242,7 +1242,7 @@ static inline unsigned short queue_logical_block_size=
(struct request_queue *q)
 	return retval;
 }
=20
-static inline unsigned short bdev_logical_block_size(struct block_device *=
bdev)
+static inline unsigned int bdev_logical_block_size(struct block_device *bd=
ev)
 {
 	return queue_logical_block_size(bdev_get_queue(bdev));
 }
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index afc1343df3c7..e644bfe50019 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -51,9 +51,13 @@ void __trace_note_message(struct blk_trace *, const char=
 *fmt, ...);
  **/
 #define blk_add_trace_msg(q, fmt, ...)					\
 	do {								\
-		struct blk_trace *bt =3D (q)->blk_trace;			\
+		struct blk_trace *bt;					\
+									\
+		rcu_read_lock();					\
+		bt =3D rcu_dereference((q)->blk_trace);			\
 		if (unlikely(bt))					\
 			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
+		rcu_read_unlock();					\
 	} while (0)
 #define BLK_TN_MAX_MSG		128
=20
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index fb4591977b03..71d087f7eb39 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -4,6 +4,7 @@
 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
 #include <linux/list.h>
+#include <linux/device.h>
=20
 struct file_operations;
 struct inode;
@@ -26,6 +27,10 @@ void cdev_put(struct cdev *p);
=20
 int cdev_add(struct cdev *, dev_t, unsigned);
=20
+void cdev_set_parent(struct cdev *p, struct kobject *kobj);
+int cdev_device_add(struct cdev *cdev, struct device *dev);
+void cdev_device_del(struct cdev *cdev, struct device *dev);
+
 void cdev_del(struct cdev *);
=20
 void cd_forget(struct inode *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 49ca7649e5b5..b4335a6e9c6b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -61,6 +61,8 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_fifos;
+extern int sysctl_protected_regular;
=20
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
@@ -568,6 +570,7 @@ struct inode {
 		struct rcu_head		i_rcu;
 	};
 	u64			i_version;
+	atomic64_t		i_sequence; /* see futex */
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 83fe0d85f8db..41563bfa54a1 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -39,23 +39,26 @@ handle_futex_death(u32 __user *uaddr, struct task_struc=
t *curr,
=20
 union futex_key {
 	struct {
+		u64 i_seq;
 		unsigned long pgoff;
-		struct inode *inode;
-		int offset;
+		unsigned int offset;
 	} shared;
 	struct {
+		union {
+			struct mm_struct *mm;
+			u64 __tmp;
+		};
 		unsigned long address;
-		struct mm_struct *mm;
-		int offset;
+		unsigned int offset;
 	} private;
 	struct {
+		u64 ptr;
 		unsigned long word;
-		void *ptr;
-		int offset;
+		unsigned int offset;
 	} both;
 };
=20
-#define FUTEX_KEY_INIT (union futex_key) { .both =3D { .ptr =3D NULL } }
+#define FUTEX_KEY_INIT (union futex_key) { .both =3D { .ptr =3D 0ULL } }
=20
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index d5569734f672..676cf8d0acca 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -28,6 +28,14 @@ static inline struct ethhdr *eth_hdr(const struct sk_buf=
f *skb)
 	return (struct ethhdr *)skb_mac_header(skb);
 }
=20
+/* Prefer this version in TX path, instead of
+ * skb_reset_mac_header() + eth_hdr()
+ */
+static inline struct ethhdr *skb_eth_hdr(const struct sk_buff *skb)
+{
+	return (struct ethhdr *)skb->data;
+}
+
 int eth_header_parse(const struct sk_buff *skb, unsigned char *haddr);
=20
 extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int =
len);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 2d61b909f414..d947e541cac8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -107,6 +107,8 @@ extern int __must_check kobject_rename(struct kobject *=
, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
=20
 extern struct kobject *kobject_get(struct kobject *kobj);
+extern struct kobject * __must_check kobject_get_unless_zero(
+						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
=20
 extern const void *kobject_namespace(struct kobject *kobj);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetabl=
e.h
index 44eeef0da186..4c546028b035 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -497,9 +497,9 @@ struct platform_device_id {
=20
 #define MDIO_MODULE_PREFIX	"mdio:"
=20
-#define MDIO_ID_FMT "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%=
d%d%d%d%d%d"
+#define MDIO_ID_FMT "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%=
u%u%u%u%u%u"
 #define MDIO_ID_ARGS(_id) \
-	(_id)>>31, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1,	\
+	((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1, \
 	((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 1, \
 	((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 1, \
 	((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 1, \
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfi=
lter_arp/arp_tables.h
index cfb7191e6efa..f817d1866428 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -51,7 +51,7 @@ extern void *arpt_alloc_initial_table(const struct xt_tab=
le *);
 extern struct xt_table *arpt_register_table(struct net *net,
 					    const struct xt_table *table,
 					    const struct arpt_replace *repl);
-extern void arpt_unregister_table(struct xt_table *table);
+extern void arpt_unregister_table(struct net *, struct xt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  unsigned int hook,
 				  const struct net_device *in,
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 34c4498b800f..6b192187c7ba 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -104,29 +104,32 @@ struct posix_clock_operations {
  *
  * @ops:     Functional interface to the clock
  * @cdev:    Character device instance for this clock
- * @kref:    Reference count.
+ * @dev:     Pointer to the clock's device.
  * @rwsem:   Protects the 'zombie' field from concurrent access.
  * @zombie:  If 'zombie' is true, then the hardware has disappeared.
- * @release: A function to free the structure when the reference count rea=
ches
- *           zero. May be NULL if structure is statically allocated.
  *
  * Drivers should embed their struct posix_clock within a private
  * structure, obtaining a reference to it during callbacks using
  * container_of().
+ *
+ * Drivers should supply an initialized but not exposed struct device
+ * to posix_clock_register(). It is used to manage lifetime of the
+ * driver's private structure. It's 'release' field should be set to
+ * a release function for this private structure.
  */
 struct posix_clock {
 	struct posix_clock_operations ops;
 	struct cdev cdev;
-	struct kref kref;
+	struct device *dev;
 	struct rw_semaphore rwsem;
 	bool zombie;
-	void (*release)(struct posix_clock *clk);
 };
=20
 /**
  * posix_clock_register() - register a new clock
- * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
- * @devid: Allocated device id
+ * @clk:   Pointer to the clock. Caller must provide 'ops' field
+ * @dev:   Pointer to the initialized device. Caller must provide
+ *         'release' field
  *
  * A clock driver calls this function to register itself with the
  * clock device subsystem. If 'clk' points to dynamically allocated
@@ -135,7 +138,7 @@ struct posix_clock {
  *
  * Returns zero on success, non-zero otherwise.
  */
-int posix_clock_register(struct posix_clock *clk, dev_t devid);
+int posix_clock_register(struct posix_clock *clk, struct device *dev);
=20
 /**
  * posix_clock_unregister() - unregister a clock
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index c2c41f6a65e2..660f59f3dcd1 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -21,7 +21,7 @@ static inline struct quota_info *sb_dqopt(struct super_bl=
ock *sb)
 /* i_mutex must being held */
 static inline bool is_quota_modification(struct inode *inode, struct iattr=
 *ia)
 {
-	return (ia->ia_valid & ATTR_SIZE && ia->ia_size !=3D inode->i_size) ||
+	return (ia->ia_valid & ATTR_SIZE) ||
 		(ia->ia_valid & ATTR_UID && !uid_eq(ia->ia_uid, inode->i_uid)) ||
 		(ia->ia_valid & ATTR_GID && !gid_eq(ia->ia_gid, inode->i_gid));
 }
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index efc4e51c425a..b0a25fdfb1be 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -62,4 +62,7 @@
 /* Hub needs extra delay after resetting its port. */
 #define USB_QUIRK_HUB_SLOW_RESET		BIT(14)
=20
+/* device has blacklisted endpoints */
+#define USB_QUIRK_ENDPOINT_BLACKLIST		BIT(15)
+
 #endif /* __LINUX_USB_QUIRKS_H */
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78f1ee2..00bbd679864a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -60,7 +60,7 @@ struct device;
 struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
-	struct media_devnode devnode;
+	struct media_devnode *devnode;
=20
 	char model[32];
 	char serial[40];
@@ -84,9 +84,6 @@ struct media_device {
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
=20
-/* media_devnode to media_device */
-#define to_media_device(node) container_of(node, struct media_device, devn=
ode)
-
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MOD=
ULE)
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 0dc7060f9625..6b370e97efae 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -33,6 +33,8 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
=20
+struct media_device;
+
 /*
  * Flag to mark the media_devnode struct as registered. Drivers must not t=
ouch
  * this flag directly, it will be set and cleared by media_devnode_registe=
r and
@@ -63,6 +65,8 @@ struct media_file_operations {
  * before registering the node.
  */
 struct media_devnode {
+	struct media_device *media_dev;
+
 	/* device ops */
 	const struct media_file_operations *fops;
=20
@@ -76,24 +80,42 @@ struct media_devnode {
 	unsigned long flags;		/* Use bitops to access flags */
=20
 	/* callbacks */
-	void (*release)(struct media_devnode *mdev);
+	void (*release)(struct media_devnode *devnode);
 };
=20
 /* dev to media_devnode */
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
=20
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner);
-void media_devnode_unregister(struct media_devnode *mdev);
+
+/**
+ * media_devnode_unregister_prepare - clear the media device node register=
 bit
+ * @devnode: the device node to prepare for unregister
+ *
+ * This clears the passed device register bit. Future open calls will be m=
et
+ * with errors. Should be called before media_devnode_unregister() to avoid
+ * races with unregister and device file open calls.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+void media_devnode_unregister_prepare(struct media_devnode *devnode);
+
+void media_devnode_unregister(struct media_devnode *devnode);
=20
 static inline struct media_devnode *media_devnode_data(struct file *filp)
 {
 	return filp->private_data;
 }
=20
-static inline int media_devnode_is_registered(struct media_devnode *mdev)
+static inline int media_devnode_is_registered(struct media_devnode *devnod=
e)
 {
-	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	if (!devnode)
+		return false;
+
+	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
=20
 #endif /* _MEDIA_DEVNODE_H */
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index c9766ab9c87c..19d0e56375f7 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -156,8 +156,9 @@ struct ipv6_stub {
 				 const struct in6_addr *addr);
 	int (*ipv6_sock_mc_drop)(struct sock *sk, int ifindex,
 				 const struct in6_addr *addr);
-	int (*ipv6_dst_lookup)(struct sock *sk, struct dst_entry **dst,
-				struct flowi6 *fl6);
+	struct dst_entry *(*ipv6_dst_lookup_flow)(struct sock *sk,
+						  struct flowi6 *fl6,
+						  const struct in6_addr *final_dst);
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, struct neighbour *neigh,
 			      const struct in6_addr *daddr,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5d636bbd81a9..e1e51d674c2a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3626,6 +3626,17 @@ const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, in=
t len);
 const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
 				  const u8 *ies, int len);
=20
+/**
+ * cfg80211_send_layer2_update - send layer 2 update frame
+ *
+ * @dev: network device
+ * @addr: STA MAC address
+ *
+ * Wireless drivers can use this function to update forwarding tables in b=
ridge
+ * devices upon STA association.
+ */
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr);
+
 /**
  * DOC: Regulatory enforcement infrastructure
  *
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 47f425464f84..c24981a8d1a8 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -71,7 +71,6 @@ struct neigh_parms {
 	struct net_device *dev;
 	struct neigh_parms *next;
 	int	(*neigh_setup)(struct neighbour *);
-	void	(*neigh_cleanup)(struct neighbour *);
 	struct neigh_table *tbl;
=20
 	void	*sysctl_table;
diff --git a/kernel/futex.c b/kernel/futex.c
index 7976a19877e4..4efd512b062d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -309,9 +309,9 @@ static inline int hb_waiters_pending(struct futex_hash_=
bucket *hb)
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
 {
-	u32 hash =3D jhash2((u32*)&key->both.word,
-			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
+	u32 hash =3D jhash2((u32 *)key, offsetof(typeof(*key), both.offset) / 4,
 			  key->both.offset);
+
 	return &futex_queues[hash & (futex_hashsize - 1)];
 }
=20
@@ -338,7 +338,7 @@ static void get_futex_key_refs(union futex_key *key)
=20
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode); /* implies MB (B) */
+		smp_mb();		/* explicit smp_mb(); (B) */
 		break;
 	case FUT_OFF_MMSHARED:
 		futex_get_mm(key); /* implies MB (B) */
@@ -362,7 +362,6 @@ static void drop_futex_key_refs(union futex_key *key)
=20
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		iput(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		mmdrop(key->private.mm);
@@ -370,6 +369,46 @@ static void drop_futex_key_refs(union futex_key *key)
 	}
 }
=20
+/*
+ * Generate a machine wide unique identifier for this inode.
+ *
+ * This relies on u64 not wrapping in the life-time of the machine; which =
with
+ * 1ns resolution means almost 585 years.
+ *
+ * This further relies on the fact that a well formed program will not unm=
ap
+ * the file while it has a (shared) futex waiting on it. This mapping will=
 have
+ * a file reference which pins the mount and inode.
+ *
+ * If for some reason an inode gets evicted and read back in again, it wil=
l get
+ * a new sequence number and will _NOT_ match, even though it is the exact=
 same
+ * file.
+ *
+ * It is important that match_futex() will never have a false-positive, es=
p.
+ * for PI futexes that can mess up the state. The above argues that false-=
negatives
+ * are only possible for malformed programs.
+ */
+static u64 get_inode_sequence_number(struct inode *inode)
+{
+	static atomic64_t i_seq;
+	u64 old;
+
+	/* Does the inode already have a sequence number? */
+	old =3D atomic64_read(&inode->i_sequence);
+	if (likely(old))
+		return old;
+
+	for (;;) {
+		u64 new =3D atomic64_add_return(1, &i_seq);
+		if (WARN_ON_ONCE(!new))
+			continue;
+
+		old =3D atomic64_cmpxchg(&inode->i_sequence, 0, new);
+		if (old)
+			return old;
+		return new;
+	}
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -382,9 +421,15 @@ static void drop_futex_key_refs(union futex_key *key)
  *
  * The key words are stored in *key on success.
  *
- * For shared mappings, it's (page->index, file_inode(vma->vm_file),
- * offset_within_page).  For private mappings, it's (uaddr, current->mm).
- * We can usually work out the index without swapping in the page.
+ * For shared mappings (when @fshared), the key is:
+ *   ( inode->i_sequence, page->index, offset_within_page )
+ * [ also see get_inode_sequence_number() ]
+ *
+ * For private mappings (or when !@fshared), the key is:
+ *   ( current->mm, address, 0 )
+ *
+ * This allows (cross process, where applicable) identification of the fut=
ex
+ * without keeping the page pinned for the duration of the FUTEX_WAIT.
  *
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
@@ -545,8 +590,6 @@ get_futex_key(u32 __user *uaddr, int fshared, union fut=
ex_key *key, int rw)
 		key->private.mm =3D mm;
 		key->private.address =3D address;
=20
-		get_futex_key_refs(key); /* implies smp_mb(); (B) */
-
 	} else {
 		struct inode *inode;
=20
@@ -578,40 +621,14 @@ get_futex_key(u32 __user *uaddr, int fshared, union f=
utex_key *key, int rw)
 			goto again;
 		}
=20
-		/*
-		 * Take a reference unless it is about to be freed. Previously
-		 * this reference was taken by ihold under the page lock
-		 * pinning the inode in place so i_lock was unnecessary. The
-		 * only way for this check to fail is if the inode was
-		 * truncated in parallel which is almost certainly an
-		 * application bug. In such a case, just retry.
-		 *
-		 * We are not calling into get_futex_key_refs() in file-backed
-		 * cases, therefore a successful atomic_inc return below will
-		 * guarantee that get_futex_key() will still imply smp_mb(); (B).
-		 */
-		if (!atomic_inc_not_zero(&inode->i_count)) {
-			rcu_read_unlock();
-			put_page(page_head);
-
-			goto again;
-		}
-
-		/* Should be impossible but lets be paranoid for now */
-		if (WARN_ON_ONCE(inode->i_mapping !=3D mapping)) {
-			err =3D -EFAULT;
-			rcu_read_unlock();
-			iput(inode);
-
-			goto out;
-		}
-
 		key->both.offset |=3D FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode =3D inode;
+		key->shared.i_seq =3D get_inode_sequence_number(inode);
 		key->shared.pgoff =3D basepage_index(page);
 		rcu_read_unlock();
 	}
=20
+	get_futex_key_refs(key); /* implies smp_mb(); (B) */
+
 out:
 	put_page(page_head);
 	return err;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6f4e876162f5..c5da3c8a67e8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1652,6 +1652,24 @@ static struct ctl_table fs_table[] =3D {
 		.extra1		=3D &zero,
 		.extra2		=3D &one,
 	},
+	{
+		.procname	=3D "protected_fifos",
+		.data		=3D &sysctl_protected_fifos,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0600,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &zero,
+		.extra2		=3D &two,
+	},
+	{
+		.procname	=3D "protected_regular",
+		.data		=3D &sysctl_protected_regular,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0600,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &zero,
+		.extra2		=3D &two,
+	},
 	{
 		.procname	=3D "suid_dumpable",
 		.data		=3D &suid_dumpable,
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 13d2f7cd65db..158c877e5327 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -591,25 +591,33 @@ static int taskstats_user_cmd(struct sk_buff *skb, st=
ruct genl_info *info)
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig =3D tsk->signal;
-	struct taskstats *stats;
+	struct taskstats *stats_new, *stats;
=20
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
+	/* Pairs with smp_store_release() below. */
+	stats =3D smp_load_acquire(&sig->stats);
+	if (stats || thread_group_empty(tsk))
+		return stats;
=20
 	/* No problem if kmem_cache_zalloc() fails */
-	stats =3D kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+	stats_new =3D kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
=20
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats =3D stats;
-		stats =3D NULL;
+	stats =3D sig->stats;
+	if (!stats) {
+		/*
+		 * Pairs with smp_store_release() above and order the
+		 * kmem_cache_zalloc().
+		 */
+		smp_store_release(&sig->stats, stats_new);
+		stats =3D stats_new;
+		stats_new =3D NULL;
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
=20
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-ret:
-	return sig->stats;
+	if (stats_new)
+		kmem_cache_free(taskstats_cache, stats_new);
+
+	return stats;
 }
=20
 /* Send pid data out on exit */
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 9cff0ab82b63..dfb386931512 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -25,8 +25,6 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
=20
-static void delete_clock(struct kref *kref);
-
 /*
  * Returns NULL if the posix_clock instance attached to 'fp' is old and st=
ale.
  */
@@ -168,7 +166,7 @@ static int posix_clock_open(struct inode *inode, struct=
 file *fp)
 		err =3D 0;
=20
 	if (!err) {
-		kref_get(&clk->kref);
+		get_device(clk->dev);
 		fp->private_data =3D clk;
 	}
 out:
@@ -184,7 +182,7 @@ static int posix_clock_release(struct inode *inode, str=
uct file *fp)
 	if (clk->ops.release)
 		err =3D clk->ops.release(clk);
=20
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
=20
 	fp->private_data =3D NULL;
=20
@@ -206,38 +204,35 @@ static const struct file_operations posix_clock_file_=
operations =3D {
 #endif
 };
=20
-int posix_clock_register(struct posix_clock *clk, dev_t devid)
+int posix_clock_register(struct posix_clock *clk, struct device *dev)
 {
 	int err;
=20
-	kref_init(&clk->kref);
 	init_rwsem(&clk->rwsem);
=20
 	cdev_init(&clk->cdev, &posix_clock_file_operations);
+	err =3D cdev_device_add(&clk->cdev, dev);
+	if (err) {
+		pr_err("%s unable to add device %d:%d\n",
+			dev_name(dev), MAJOR(dev->devt), MINOR(dev->devt));
+		return err;
+	}
 	clk->cdev.owner =3D clk->ops.owner;
-	err =3D cdev_add(&clk->cdev, devid, 1);
+	clk->dev =3D dev;
=20
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(posix_clock_register);
=20
-static void delete_clock(struct kref *kref)
-{
-	struct posix_clock *clk =3D container_of(kref, struct posix_clock, kref);
-
-	if (clk->release)
-		clk->release(clk);
-}
-
 void posix_clock_unregister(struct posix_clock *clk)
 {
-	cdev_del(&clk->cdev);
+	cdev_device_del(&clk->cdev, clk->dev);
=20
 	down_write(&clk->rwsem);
 	clk->zombie =3D true;
 	up_write(&clk->rwsem);
=20
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
 }
 EXPORT_SYMBOL_GPL(posix_clock_unregister);
=20
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 9a9d0288576b..db28c5fabfac 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -302,6 +302,7 @@ static void blk_trace_free(struct blk_trace *bt)
=20
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
+	synchronize_rcu();
 	blk_trace_free(bt);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
@@ -448,7 +449,7 @@ int do_blk_trace_setup(struct request_queue *q, char *n=
ame, dev_t dev,
 		       struct block_device *bdev,
 		       struct blk_user_trace_setup *buts)
 {
-	struct blk_trace *old_bt, *bt =3D NULL;
+	struct blk_trace *bt =3D NULL;
 	struct dentry *dir =3D NULL;
 	int ret, i;
=20
@@ -532,11 +533,8 @@ int do_blk_trace_setup(struct request_queue *q, char *=
name, dev_t dev,
 	bt->trace_state =3D Blktrace_setup;
=20
 	ret =3D -EBUSY;
-	old_bt =3D xchg(&q->blk_trace, bt);
-	if (old_bt) {
-		(void) xchg(&q->blk_trace, old_bt);
+	if (cmpxchg(&q->blk_trace, NULL, bt))
 		goto err;
-	}
=20
 	if (atomic_inc_return(&blk_probes_ref) =3D=3D 1)
 		blk_register_tracepoints();
@@ -619,8 +617,10 @@ static int compat_blk_trace_setup(struct request_queue=
 *q, char *name,
 static int __blk_trace_startstop(struct request_queue *q, int start)
 {
 	int ret;
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
+	bt =3D rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (bt =3D=3D NULL)
 		return -EINVAL;
=20
@@ -729,8 +729,8 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned=
 cmd, char __user *arg)
 void blk_trace_shutdown(struct request_queue *q)
 {
 	mutex_lock(&q->blk_trace_mutex);
-
-	if (q->blk_trace) {
+	if (rcu_dereference_protected(q->blk_trace,
+				      lockdep_is_held(&q->blk_trace_mutex))) {
 		__blk_trace_startstop(q, 0);
 		__blk_trace_remove(q);
 	}
@@ -756,10 +756,14 @@ void blk_trace_shutdown(struct request_queue *q)
 static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 			     unsigned int nr_bytes, u32 what)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
-	if (likely(!bt))
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
=20
 	if (rq->cmd_type =3D=3D REQ_TYPE_BLOCK_PC) {
 		what |=3D BLK_TC_ACT(BLK_TC_PC);
@@ -770,6 +774,7 @@ static void blk_add_trace_rq(struct request_queue *q, s=
truct request *rq,
 		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes,
 				rq->cmd_flags, what, rq->errors, 0, NULL);
 	}
+	rcu_read_unlock();
 }
=20
 static void blk_add_trace_rq_abort(void *ignore,
@@ -819,16 +824,21 @@ static void blk_add_trace_rq_complete(void *ignore,
 static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 			      u32 what, int error)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
-	if (likely(!bt))
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
=20
 	if (!error && !bio_flagged(bio, BIO_UPTODATE))
 		error =3D EIO;
=20
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio->bi_rw, what, error, 0, NULL);
+	rcu_read_unlock();
 }
=20
 static void blk_add_trace_bio_bounce(void *ignore,
@@ -873,10 +883,13 @@ static void blk_add_trace_getrq(void *ignore,
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);
 	else {
-		struct blk_trace *bt =3D q->blk_trace;
+		struct blk_trace *bt;
=20
+		rcu_read_lock();
+		bt =3D rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, BLK_TA_GETRQ, 0, 0, NULL);
+		rcu_read_unlock();
 	}
 }
=20
@@ -888,27 +901,35 @@ static void blk_add_trace_sleeprq(void *ignore,
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
 	else {
-		struct blk_trace *bt =3D q->blk_trace;
+		struct blk_trace *bt;
=20
+		rcu_read_lock();
+		bt =3D rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, BLK_TA_SLEEPRQ,
 					0, 0, NULL);
+		rcu_read_unlock();
 	}
 }
=20
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
 	if (bt)
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
+	rcu_read_unlock();
 }
=20
 static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 				    unsigned int depth, bool explicit)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
 	if (bt) {
 		__be64 rpdu =3D cpu_to_be64(depth);
 		u32 what;
@@ -920,14 +941,17 @@ static void blk_add_trace_unplug(void *ignore, struct=
 request_queue *q,
=20
 		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
 	}
+	rcu_read_unlock();
 }
=20
 static void blk_add_trace_split(void *ignore,
 				struct request_queue *q, struct bio *bio,
 				unsigned int pdu)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
 	if (bt) {
 		__be64 rpdu =3D cpu_to_be64(pdu);
=20
@@ -936,6 +960,7 @@ static void blk_add_trace_split(void *ignore,
 				!bio_flagged(bio, BIO_UPTODATE),
 				sizeof(rpdu), &rpdu);
 	}
+	rcu_read_unlock();
 }
=20
 /**
@@ -955,11 +980,15 @@ static void blk_add_trace_bio_remap(void *ignore,
 				    struct request_queue *q, struct bio *bio,
 				    dev_t dev, sector_t from)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
=20
-	if (likely(!bt))
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
=20
 	r.device_from =3D cpu_to_be32(dev);
 	r.device_to   =3D cpu_to_be32(bio->bi_bdev->bd_dev);
@@ -968,6 +997,7 @@ static void blk_add_trace_bio_remap(void *ignore,
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio->bi_rw, BLK_TA_REMAP,
 			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+	rcu_read_unlock();
 }
=20
 /**
@@ -988,11 +1018,15 @@ static void blk_add_trace_rq_remap(void *ignore,
 				   struct request *rq, dev_t dev,
 				   sector_t from)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
=20
-	if (likely(!bt))
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
=20
 	r.device_from =3D cpu_to_be32(dev);
 	r.device_to   =3D cpu_to_be32(disk_devt(rq->rq_disk));
@@ -1001,6 +1035,7 @@ static void blk_add_trace_rq_remap(void *ignore,
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
 			sizeof(r), &r);
+	rcu_read_unlock();
 }
=20
 /**
@@ -1018,10 +1053,14 @@ void blk_add_driver_data(struct request_queue *q,
 			 struct request *rq,
 			 void *data, size_t len)
 {
-	struct blk_trace *bt =3D q->blk_trace;
+	struct blk_trace *bt;
=20
-	if (likely(!bt))
+	rcu_read_lock();
+	bt =3D rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
=20
 	if (rq->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
 		__blk_add_trace(bt, 0, blk_rq_bytes(rq), 0,
@@ -1029,6 +1068,7 @@ void blk_add_driver_data(struct request_queue *q,
 	else
 		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), 0,
 				BLK_TA_DRV_DATA, rq->errors, len, data);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
=20
@@ -1540,6 +1580,7 @@ static int blk_trace_remove_queue(struct request_queu=
e *q)
 	spin_lock_irq(&running_trace_lock);
 	list_del(&bt->running_list);
 	spin_unlock_irq(&running_trace_lock);
+	synchronize_rcu();
 	blk_trace_free(bt);
 	return 0;
 }
@@ -1550,7 +1591,7 @@ static int blk_trace_remove_queue(struct request_queu=
e *q)
 static int blk_trace_setup_queue(struct request_queue *q,
 				 struct block_device *bdev)
 {
-	struct blk_trace *old_bt, *bt =3D NULL;
+	struct blk_trace *bt =3D NULL;
 	int ret =3D -ENOMEM;
=20
 	bt =3D kzalloc(sizeof(*bt), GFP_KERNEL);
@@ -1566,12 +1607,9 @@ static int blk_trace_setup_queue(struct request_queu=
e *q,
=20
 	blk_trace_setup_lba(bt, bdev);
=20
-	old_bt =3D xchg(&q->blk_trace, bt);
-	if (old_bt !=3D NULL) {
-		(void)xchg(&q->blk_trace, old_bt);
-		ret =3D -EBUSY;
+	ret =3D -EBUSY;
+	if (cmpxchg(&q->blk_trace, NULL, bt))
 		goto free_bt;
-	}
=20
 	if (atomic_inc_return(&blk_probes_ref) =3D=3D 1)
 		blk_register_tracepoints();
@@ -1704,6 +1742,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct devic=
e *dev,
 	struct hd_struct *p =3D dev_to_part(dev);
 	struct request_queue *q;
 	struct block_device *bdev;
+	struct blk_trace *bt;
 	ssize_t ret =3D -ENXIO;
=20
 	bdev =3D bdget(part_devt(p));
@@ -1716,21 +1755,23 @@ static ssize_t sysfs_blk_trace_attr_show(struct dev=
ice *dev,
=20
 	mutex_lock(&q->blk_trace_mutex);
=20
+	bt =3D rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (attr =3D=3D &dev_attr_enable) {
-		ret =3D sprintf(buf, "%u\n", !!q->blk_trace);
+		ret =3D sprintf(buf, "%u\n", !!bt);
 		goto out_unlock_bdev;
 	}
=20
-	if (q->blk_trace =3D=3D NULL)
+	if (bt =3D=3D NULL)
 		ret =3D sprintf(buf, "disabled\n");
 	else if (attr =3D=3D &dev_attr_act_mask)
-		ret =3D blk_trace_mask2str(buf, q->blk_trace->act_mask);
+		ret =3D blk_trace_mask2str(buf, bt->act_mask);
 	else if (attr =3D=3D &dev_attr_pid)
-		ret =3D sprintf(buf, "%u\n", q->blk_trace->pid);
+		ret =3D sprintf(buf, "%u\n", bt->pid);
 	else if (attr =3D=3D &dev_attr_start_lba)
-		ret =3D sprintf(buf, "%llu\n", q->blk_trace->start_lba);
+		ret =3D sprintf(buf, "%llu\n", bt->start_lba);
 	else if (attr =3D=3D &dev_attr_end_lba)
-		ret =3D sprintf(buf, "%llu\n", q->blk_trace->end_lba);
+		ret =3D sprintf(buf, "%llu\n", bt->end_lba);
=20
 out_unlock_bdev:
 	mutex_unlock(&q->blk_trace_mutex);
@@ -1747,6 +1788,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct devi=
ce *dev,
 	struct block_device *bdev;
 	struct request_queue *q;
 	struct hd_struct *p;
+	struct blk_trace *bt;
 	u64 value;
 	ssize_t ret =3D -EINVAL;
=20
@@ -1777,8 +1819,10 @@ static ssize_t sysfs_blk_trace_attr_store(struct dev=
ice *dev,
=20
 	mutex_lock(&q->blk_trace_mutex);
=20
+	bt =3D rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (attr =3D=3D &dev_attr_enable) {
-		if (!!value =3D=3D !!q->blk_trace) {
+		if (!!value =3D=3D !!bt) {
 			ret =3D 0;
 			goto out_unlock_bdev;
 		}
@@ -1790,18 +1834,21 @@ static ssize_t sysfs_blk_trace_attr_store(struct de=
vice *dev,
 	}
=20
 	ret =3D 0;
-	if (q->blk_trace =3D=3D NULL)
+	if (bt =3D=3D NULL) {
 		ret =3D blk_trace_setup_queue(q, bdev);
+		bt =3D rcu_dereference_protected(q->blk_trace,
+				lockdep_is_held(&q->blk_trace_mutex));
+	}
=20
 	if (ret =3D=3D 0) {
 		if (attr =3D=3D &dev_attr_act_mask)
-			q->blk_trace->act_mask =3D value;
+			bt->act_mask =3D value;
 		else if (attr =3D=3D &dev_attr_pid)
-			q->blk_trace->pid =3D value;
+			bt->pid =3D value;
 		else if (attr =3D=3D &dev_attr_start_lba)
-			q->blk_trace->start_lba =3D value;
+			bt->start_lba =3D value;
 		else if (attr =3D=3D &dev_attr_end_lba)
-			q->blk_trace->end_lba =3D value;
+			bt->end_lba =3D value;
 	}
=20
 out_unlock_bdev:
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c59d43d54d32..ff5281a9c5d7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -595,8 +595,7 @@ static int function_stat_show(struct seq_file *m, void =
*v)
=20
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_printf(m, "    ");
-	avg =3D rec->time;
-	do_div(avg, rec->counter);
+	avg =3D div64_ul(rec->time, rec->counter);
=20
 	/* Sample standard deviation (s^2) */
 	if (rec->counter <=3D 1)
@@ -613,7 +612,8 @@ static int function_stat_show(struct seq_file *m, void =
*v)
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
+		stddev =3D div64_ul(stddev,
+				  rec->counter * (rec->counter - 1) * 1000);
 	}
=20
 	trace_seq_init(&s);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 19bd8928ce94..0928ea8c5567 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -567,7 +567,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_migrate_task\n");
-		return;
+		goto fail_deprobe_sched_switch;
 	}
=20
 	wakeup_reset(tr);
@@ -585,6 +585,8 @@ static void start_wakeup_tracer(struct trace_array *tr)
 		printk(KERN_ERR "failed to start wakeup tracer\n");
=20
 	return;
+fail_deprobe_sched_switch:
+	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 fail_deprobe_wake_new:
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 fail_deprobe:
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8a4e5cb66a4c..27eb7e96dabe 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -182,6 +182,11 @@ check_stack(unsigned long ip, unsigned long *stack)
 	local_irq_restore(flags);
 }
=20
+/* Some archs may not define MCOUNT_INSN_SIZE */
+#ifndef MCOUNT_INSN_SIZE
+# define MCOUNT_INSN_SIZE 0
+#endif
+
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip,
 		 struct ftrace_ops *op, struct pt_regs *pt_regs)
diff --git a/lib/kobject.c b/lib/kobject.c
index 58751bb80a7c..370f169ab88f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -581,12 +581,15 @@ struct kobject *kobject_get(struct kobject *kobj)
 	return kobj;
 }
=20
-static struct kobject * __must_check kobject_get_unless_zero(struct kobjec=
t *kobj)
+struct kobject * __must_check kobject_get_unless_zero(struct kobject *kobj)
 {
+	if (!kobj)
+		return NULL;
 	if (!kref_get_unless_zero(&kobj->kref))
 		kobj =3D NULL;
 	return kobj;
 }
+EXPORT_SYMBOL(kobject_get_unless_zero);
=20
 /*
  * kobject_cleanup - free kobject resources.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index aaf4c2e002e2..ad5f8f16270c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2711,7 +2711,9 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 	switch (mode) {
 	case MPOL_PREFERRED:
 		/*
-		 * Insist on a nodelist of one node only
+		 * Insist on a nodelist of one node only, although later
+		 * we use first_node(nodes) to grab a single node, so here
+		 * nodelist (or nodes) cannot be empty.
 		 */
 		if (nodelist) {
 			char *rest =3D nodelist;
@@ -2719,6 +2721,8 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 				rest++;
 			if (*rest)
 				goto out;
+			if (nodes_empty(nodes))
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 8ac8a5cc2143..cfcc4cd12944 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -92,11 +92,13 @@ static int vlan_changelink(struct net_device *dev,
 	struct ifla_vlan_flags *flags;
 	struct ifla_vlan_qos_mapping *m;
 	struct nlattr *attr;
-	int rem;
+	int rem, err;
=20
 	if (data[IFLA_VLAN_FLAGS]) {
 		flags =3D nla_data(data[IFLA_VLAN_FLAGS]);
-		vlan_dev_change_flags(dev, flags->flags, flags->mask);
+		err =3D vlan_dev_change_flags(dev, flags->flags, flags->mask);
+		if (err)
+			return err;
 	}
 	if (data[IFLA_VLAN_INGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_INGRESS_QOS], rem) {
@@ -107,7 +109,9 @@ static int vlan_changelink(struct net_device *dev,
 	if (data[IFLA_VLAN_EGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_EGRESS_QOS], rem) {
 			m =3D nla_data(attr);
-			vlan_dev_set_egress_priority(dev, m->from, m->to);
+			err =3D vlan_dev_set_egress_priority(dev, m->from, m->to);
+			if (err)
+				return err;
 		}
 	}
 	return 0;
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distri=
buted-arp-table.c
index ab83d8b16c45..a326c4fe1087 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -207,9 +207,11 @@ static uint32_t batadv_hash_dat(const void *data, uint=
32_t size)
 {
 	uint32_t hash =3D 0;
 	const struct batadv_dat_entry *dat =3D data;
+	__be16 vid;
=20
 	hash =3D batadv_hash_bytes(hash, &dat->ip, sizeof(dat->ip));
-	hash =3D batadv_hash_bytes(hash, &dat->vid, sizeof(dat->vid));
+	vid =3D htons(dat->vid);
+	hash =3D batadv_hash_bytes(hash, &vid, sizeof(vid));
=20
 	hash +=3D (hash << 3);
 	hash ^=3D (hash >> 11);
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 7ddb8b322556..3829136c245a 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -850,6 +850,9 @@ static unsigned int br_nf_forward_arp(const struct nf_h=
ook_ops *ops,
 		nf_bridge_pull_encap_header(skb);
 	}
=20
+	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
+		return NF_DROP;
+
 	if (arp_hdr(skb)->ar_pln !=3D 4) {
 		if (IS_VLAN_ARP(skb))
 			nf_bridge_push_encap_header(skb);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtable=
s.c
index 1596736ff268..df1b8c147062 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1603,7 +1603,8 @@ static int compat_match_to_user(struct ebt_entry_matc=
h *m, void __user **dstptr,
 	int off =3D ebt_compat_match_offset(match, m->match_size);
 	compat_uint_t msize =3D m->match_size - off;
=20
-	BUG_ON(off >=3D m->match_size);
+	if (WARN_ON(off >=3D m->match_size))
+		return -EINVAL;
=20
 	if (copy_to_user(cm->u.name, match->name,
 	    strlen(match->name) + 1) || put_user(msize, &cm->match_size))
@@ -1630,7 +1631,8 @@ static int compat_target_to_user(struct ebt_entry_tar=
get *t,
 	int off =3D xt_compat_target_offset(target);
 	compat_uint_t tsize =3D t->target_size - off;
=20
-	BUG_ON(off >=3D t->target_size);
+	if (WARN_ON(off >=3D t->target_size))
+		return -EINVAL;
=20
 	if (copy_to_user(cm->u.name, target->name,
 	    strlen(target->name) + 1) || put_user(tsize, &cm->match_size))
@@ -1853,12 +1855,13 @@ static int ebt_buf_count(struct ebt_entries_buf_sta=
te *state, unsigned int sz)
 }
=20
 static int ebt_buf_add(struct ebt_entries_buf_state *state,
-		       void *data, unsigned int sz)
+		       const void *data, unsigned int sz)
 {
 	if (state->buf_kern_start =3D=3D NULL)
 		goto count_only;
=20
-	BUG_ON(state->buf_kern_offset + sz > state->buf_kern_len);
+	if (WARN_ON(state->buf_kern_offset + sz > state->buf_kern_len))
+		return -EINVAL;
=20
 	memcpy(state->buf_kern_start + state->buf_kern_offset, data, sz);
=20
@@ -1871,7 +1874,8 @@ static int ebt_buf_add_pad(struct ebt_entries_buf_sta=
te *state, unsigned int sz)
 {
 	char *b =3D state->buf_kern_start;
=20
-	BUG_ON(b && state->buf_kern_offset > state->buf_kern_len);
+	if (WARN_ON(b && state->buf_kern_offset > state->buf_kern_len))
+		return -EINVAL;
=20
 	if (b !=3D NULL && sz > 0)
 		memset(b + state->buf_kern_offset, 0, sz);
@@ -1885,7 +1889,7 @@ enum compat_mwt {
 	EBT_COMPAT_TARGET,
 };
=20
-static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
+static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 				enum compat_mwt compat_mwt,
 				struct ebt_entries_buf_state *state,
 				const unsigned char *base)
@@ -1949,8 +1953,10 @@ static int compat_mtw_from_user(struct compat_ebt_en=
try_mwt *mwt,
 	pad =3D XT_ALIGN(size_kern) - size_kern;
=20
 	if (pad > 0 && dst) {
-		BUG_ON(state->buf_kern_len <=3D pad);
-		BUG_ON(state->buf_kern_offset - (match_size + off) + size_kern > state->=
buf_kern_len - pad);
+		if (WARN_ON(state->buf_kern_len <=3D pad))
+			return -EINVAL;
+		if (WARN_ON(state->buf_kern_offset - (match_size + off) + size_kern > st=
ate->buf_kern_len - pad))
+			return -EINVAL;
 		memset(dst + size_kern, 0, pad);
 	}
 	return off + match_size;
@@ -1960,22 +1966,23 @@ static int compat_mtw_from_user(struct compat_ebt_e=
ntry_mwt *mwt,
  * return size of all matches, watchers or target, including necessary
  * alignment and padding.
  */
-static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
+static int ebt_size_mwt(const struct compat_ebt_entry_mwt *match32,
 			unsigned int size_left, enum compat_mwt type,
 			struct ebt_entries_buf_state *state, const void *base)
 {
+	const char *buf =3D (const char *)match32;
 	int growth =3D 0;
-	char *buf;
=20
 	if (size_left =3D=3D 0)
 		return 0;
=20
-	buf =3D (char *) match32;
-
-	while (size_left >=3D sizeof(*match32)) {
+	do {
 		struct ebt_entry_match *match_kern;
 		int ret;
=20
+		if (size_left < sizeof(*match32))
+			return -EINVAL;
+
 		match_kern =3D (struct ebt_entry_match *) state->buf_kern_start;
 		if (match_kern) {
 			char *tmp;
@@ -2001,7 +2008,8 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *=
match32,
 		if (ret < 0)
 			return ret;
=20
-		BUG_ON(ret < match32->match_size);
+		if (WARN_ON(ret < match32->match_size))
+			return -EINVAL;
 		growth +=3D ret - match32->match_size;
 		growth +=3D ebt_compat_entry_padsize();
=20
@@ -2011,22 +2019,18 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt=
 *match32,
 		if (match_kern)
 			match_kern->match_size =3D ret;
=20
-		/* rule should have no remaining data after target */
-		if (type =3D=3D EBT_COMPAT_TARGET && size_left)
-			return -EINVAL;
-
 		match32 =3D (struct compat_ebt_entry_mwt *) buf;
-	}
+	} while (size_left);
=20
 	return growth;
 }
=20
 /* called for all ebt_entry structures. */
-static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *ba=
se,
+static int size_entry_mwt(const struct ebt_entry *entry, const unsigned ch=
ar *base,
 			  unsigned int *total,
 			  struct ebt_entries_buf_state *state)
 {
-	unsigned int i, j, startoff, new_offset =3D 0;
+	unsigned int i, j, startoff, next_expected_off, new_offset =3D 0;
 	/* stores match/watchers/targets & offset of next struct ebt_entry: */
 	unsigned int offsets[4];
 	unsigned int *offsets_update =3D NULL;
@@ -2114,10 +2118,13 @@ static int size_entry_mwt(struct ebt_entry *entry, =
const unsigned char *base,
 			return ret;
 	}
=20
-	startoff =3D state->buf_user_offset - startoff;
+	next_expected_off =3D state->buf_user_offset - startoff;
+	if (next_expected_off !=3D entry->next_offset)
+		return -EINVAL;
=20
-	BUG_ON(*total < startoff);
-	*total -=3D startoff;
+	if (*total < entry->next_offset)
+		return -EINVAL;
+	*total -=3D entry->next_offset;
 	return 0;
 }
=20
@@ -2246,7 +2253,8 @@ static int compat_do_replace(struct net *net, void __=
user *user,
 	state.buf_kern_len =3D size64;
=20
 	ret =3D compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	BUG_ON(ret < 0);	/* parses same data again */
+	if (WARN_ON(ret < 0))
+		goto out_unlock;
=20
 	vfree(entries_tmp);
 	tmp.entries_size =3D size64;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9137f30c78b8..e48e552be9fe 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -103,9 +103,6 @@ static int neigh_blackhole(struct neighbour *neigh, str=
uct sk_buff *skb)
=20
 static void neigh_cleanup_and_release(struct neighbour *neigh)
 {
-	if (neigh->parms->neigh_cleanup)
-		neigh->parms->neigh_cleanup(neigh);
-
 	__neigh_notify(neigh, RTM_DELNEIGH, 0);
 	neigh_release(neigh);
 }
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 15019c2408c2..d491af8a11be 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -480,11 +480,12 @@ static int mark_source_chains(const struct xt_table_i=
nfo *newinfo,
 	return 1;
 }
=20
-static inline int check_target(struct arpt_entry *e, const char *name)
+static int check_target(struct arpt_entry *e, struct net *net, const char =
*name)
 {
 	struct xt_entry_target *t =3D arpt_get_target(e);
 	int ret;
 	struct xt_tgchk_param par =3D {
+		.net       =3D net,
 		.table     =3D name,
 		.entryinfo =3D e,
 		.target    =3D t->u.kernel.target,
@@ -502,8 +503,9 @@ static inline int check_target(struct arpt_entry *e, co=
nst char *name)
 	return 0;
 }
=20
-static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
+static int
+find_check_entry(struct arpt_entry *e, struct net *net, const char *name,
+		 unsigned int size)
 {
 	struct xt_entry_target *t;
 	struct xt_target *target;
@@ -519,7 +521,7 @@ find_check_entry(struct arpt_entry *e, const char *name=
, unsigned int size)
 	}
 	t->u.kernel.target =3D target;
=20
-	ret =3D check_target(e, name);
+	ret =3D check_target(e, net, name);
 	if (ret)
 		goto err;
 	return 0;
@@ -600,12 +602,13 @@ static inline int check_entry_size_and_hooks(struct a=
rpt_entry *e,
 	return 0;
 }
=20
-static inline void cleanup_entry(struct arpt_entry *e)
+static void cleanup_entry(struct arpt_entry *e, struct net *net)
 {
 	struct xt_tgdtor_param par;
 	struct xt_entry_target *t;
=20
 	t =3D arpt_get_target(e);
+	par.net      =3D net;
 	par.target   =3D t->u.kernel.target;
 	par.targinfo =3D t->data;
 	par.family   =3D NFPROTO_ARP;
@@ -617,7 +620,9 @@ static inline void cleanup_entry(struct arpt_entry *e)
 /* Checks and translates the user-supplied table segment (held in
  * newinfo).
  */
-static int translate_table(struct xt_table_info *newinfo, void *entry0,
+static int translate_table(struct net *net,
+			   struct xt_table_info *newinfo,
+			   void *entry0,
                            const struct arpt_replace *repl)
 {
 	struct arpt_entry *iter;
@@ -692,7 +697,7 @@ static int translate_table(struct xt_table_info *newinf=
o, void *entry0,
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret =3D find_check_entry(iter, repl->name, repl->size);
+		ret =3D find_check_entry(iter, net, repl->name, repl->size);
 		if (ret !=3D 0)
 			break;
 		++i;
@@ -702,7 +707,7 @@ static int translate_table(struct xt_table_info *newinf=
o, void *entry0,
 		xt_entry_foreach(iter, entry0, newinfo->size) {
 			if (i-- =3D=3D 0)
 				break;
-			cleanup_entry(iter);
+			cleanup_entry(iter, net);
 		}
 		return ret;
 	}
@@ -1047,7 +1052,7 @@ static int __do_replace(struct net *net, const char *=
name,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry =3D oldinfo->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
=20
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1100,7 +1105,7 @@ static int do_replace(struct net *net, const void __u=
ser *user,
 		goto free_newinfo;
 	}
=20
-	ret =3D translate_table(newinfo, loc_cpu_entry, &tmp);
+	ret =3D translate_table(net, newinfo, loc_cpu_entry, &tmp);
 	if (ret !=3D 0)
 		goto free_newinfo;
=20
@@ -1114,7 +1119,7 @@ static int do_replace(struct net *net, const void __u=
ser *user,
=20
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1287,7 +1292,8 @@ compat_copy_entry_from_user(struct compat_arpt_entry =
*e, void **dstptr,
 	}
 }
=20
-static int translate_compat_table(struct xt_table_info **pinfo,
+static int translate_compat_table(struct net *net,
+				  struct xt_table_info **pinfo,
 				  void **pentry0,
 				  const struct compat_arpt_replace *compatr)
 {
@@ -1356,7 +1362,7 @@ static int translate_compat_table(struct xt_table_inf=
o **pinfo,
 	repl.num_counters =3D 0;
 	repl.counters =3D NULL;
 	repl.size =3D newinfo->size;
-	ret =3D translate_table(newinfo, entry1, &repl);
+	ret =3D translate_table(net, newinfo, entry1, &repl);
 	if (ret)
 		goto free_newinfo;
=20
@@ -1412,7 +1418,7 @@ static int compat_do_replace(struct net *net, void __=
user *user,
 		goto free_newinfo;
 	}
=20
-	ret =3D translate_compat_table(&newinfo, &loc_cpu_entry, &tmp);
+	ret =3D translate_compat_table(net, &newinfo, &loc_cpu_entry, &tmp);
 	if (ret !=3D 0)
 		goto free_newinfo;
=20
@@ -1426,7 +1432,7 @@ static int compat_do_replace(struct net *net, void __=
user *user,
=20
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1685,7 +1691,7 @@ struct xt_table *arpt_register_table(struct net *net,
 	loc_cpu_entry =3D newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
=20
-	ret =3D translate_table(newinfo, loc_cpu_entry, repl);
+	ret =3D translate_table(net, newinfo, loc_cpu_entry, repl);
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret !=3D 0)
 		goto out_free;
@@ -1703,7 +1709,7 @@ struct xt_table *arpt_register_table(struct net *net,
 	return ERR_PTR(ret);
 }
=20
-void arpt_unregister_table(struct xt_table *table)
+void arpt_unregister_table(struct net *net, struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
@@ -1715,7 +1721,7 @@ void arpt_unregister_table(struct xt_table *table)
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry =3D private->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arpt=
able_filter.c
index 802ddecb30b8..5375fb03d26b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -54,7 +54,7 @@ static int __net_init arptable_filter_net_init(struct net=
 *net)
=20
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	arpt_unregister_table(net->ipv4.arptable_filter);
+	arpt_unregister_table(net, net->ipv4.arptable_filter);
 }
=20
 static struct pernet_operations arptable_filter_net_ops =3D {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a42b6671d542..fc0425cff370 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1713,8 +1713,11 @@ tcp_sacktag_write_queue(struct sock *sk, const struc=
t sk_buff *ack_skb,
 		}
=20
 		/* Ignore very old stuff early */
-		if (!after(sp[used_sacks].end_seq, prior_snd_una))
+		if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
+			if (i =3D=3D 0)
+				first_sack_index =3D -1;
 			continue;
+		}
=20
 		used_sacks++;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e292792e9964..51f560d5bc03 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1992,6 +1992,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned=
 int mss_now, int nonagle,
 		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))
 			break;
=20
+		/* Argh, we hit an empty skb(), presumably a thread
+		 * is sleeping in sendmsg()/sk_stream_wait_memory().
+		 * We do not want to send a pure-ack packet and have
+		 * a strange looking rtx queue with empty packet(s).
+		 */
+		if (TCP_SKB_CB(skb)->end_seq =3D=3D TCP_SKB_CB(skb)->seq)
+			break;
+
 		TCP_SKB_CB(skb)->when =3D tcp_time_stamp;
=20
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d5db3ce7b463..afe276635163 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -820,7 +820,7 @@ static struct pernet_operations inet6_net_ops =3D {
 static const struct ipv6_stub ipv6_stub_impl =3D {
 	.ipv6_sock_mc_join =3D ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop =3D ipv6_sock_mc_drop,
-	.ipv6_dst_lookup =3D ip6_dst_lookup,
+	.ipv6_dst_lookup_flow =3D ip6_dst_lookup_flow,
 	.udpv6_encap_enable =3D udpv6_encap_enable,
 	.ndisc_send_na =3D ndisc_send_na,
 	.nd_tbl	=3D &nd_tbl,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46d0ecf362bf..a377edbd90e5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1196,50 +1196,6 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, st=
ruct net_device *dev)
 	return 0;
 }
=20
-/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
-struct iapp_layer2_update {
-	u8 da[ETH_ALEN];	/* broadcast */
-	u8 sa[ETH_ALEN];	/* STA addr */
-	__be16 len;		/* 6 */
-	u8 dsap;		/* 0 */
-	u8 ssap;		/* 0 */
-	u8 control;
-	u8 xid_info[3];
-} __packed;
-
-static void ieee80211_send_layer2_update(struct sta_info *sta)
-{
-	struct iapp_layer2_update *msg;
-	struct sk_buff *skb;
-
-	/* Send Level 2 Update Frame to update forwarding tables in layer 2
-	 * bridge devices */
-
-	skb =3D dev_alloc_skb(sizeof(*msg));
-	if (!skb)
-		return;
-	msg =3D (struct iapp_layer2_update *)skb_put(skb, sizeof(*msg));
-
-	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
-	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
-
-	eth_broadcast_addr(msg->da);
-	memcpy(msg->sa, sta->sta.addr, ETH_ALEN);
-	msg->len =3D htons(6);
-	msg->dsap =3D 0;
-	msg->ssap =3D 0x01;	/* NULL LSAP, CR Bit: Response */
-	msg->control =3D 0xaf;	/* XID response lsb.1111F101.
-				 * F=3D0 (no poll command; unsolicited frame) */
-	msg->xid_info[0] =3D 0x81;	/* XID format identifier */
-	msg->xid_info[1] =3D 1;	/* LLC types/classes: Type 1 LLC */
-	msg->xid_info[2] =3D 0;	/* XID sender's receive window size (RW) */
-
-	skb->dev =3D sta->sdata->dev;
-	skb->protocol =3D eth_type_trans(skb, sta->sdata->dev);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx_ni(skb);
-}
-
 static int sta_apply_auth_flags(struct ieee80211_local *local,
 				struct sta_info *sta,
 				u32 mask, u32 set)
@@ -1480,7 +1436,6 @@ static int ieee80211_add_station(struct wiphy *wiphy,=
 struct net_device *dev,
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
-	int layer2_update;
=20
 	if (params->vlan) {
 		sdata =3D IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -1525,18 +1480,12 @@ static int ieee80211_add_station(struct wiphy *wiph=
y, struct net_device *dev,
 	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		rate_control_rate_init(sta);
=20
-	layer2_update =3D sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN ||
-		sdata->vif.type =3D=3D NL80211_IFTYPE_AP;
-
 	err =3D sta_info_insert_rcu(sta);
 	if (err) {
 		rcu_read_unlock();
 		return err;
 	}
=20
-	if (layer2_update)
-		ieee80211_send_layer2_update(sta);
-
 	rcu_read_unlock();
=20
 	return 0;
@@ -1640,7 +1589,9 @@ static int ieee80211_change_station(struct wiphy *wip=
hy,
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 		}
=20
-		ieee80211_send_layer2_update(sta);
+		if (sta->sta_state =3D=3D IEEE80211_STA_AUTHORIZED)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 	}
=20
 	err =3D sta_apply_parameters(local, sta, params);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c006801f3d83..f89e76effb42 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1666,6 +1666,10 @@ int sta_info_move_state(struct sta_info *sta,
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
+		if (sta->sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN ||
+		    sta->sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 		break;
 	default:
 		break;
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/=
ip_set_bitmap_gen.h
index f2c7d83dc23f..6338b96d8f17 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -66,12 +66,12 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
=20
-	ip_set_free(map->members);
 	if (set->dsize) {
 		if (set->extensions & IPSET_EXT_DESTROY)
 			mtype_ext_cleanup(set);
 		ip_set_free(map->extensions);
 	}
+	ip_set_free(map->members);
 	kfree(map);
=20
 	set->data =3D NULL;
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set=
_core.c
index efed6315c695..87c469098350 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1549,6 +1549,7 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 	struct ip_set *set;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1] =3D {};
 	int ret =3D 0;
+	u32 lineno;
=20
 	if (unlikely(protocol_failed(attr) ||
 		     attr[IPSET_ATTR_SETNAME] =3D=3D NULL ||
@@ -1565,7 +1566,7 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 		return -IPSET_ERR_PROTOCOL;
=20
 	read_lock_bh(&set->lock);
-	ret =3D set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
+	ret =3D set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
 	read_unlock_bh(&set->lock);
 	/* Userspace can't trigger element to be re-added */
 	if (ret =3D=3D -EAGAIN)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index b9bf8b0f4ec1..63c984e01ff8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3225,6 +3225,9 @@ static void __net_exit ctnetlink_net_exit_batch(struc=
t list_head *net_exit_list)
=20
 	list_for_each_entry(net, net_exit_list, exit_list)
 		ctnetlink_net_exit(net);
+
+	/* wait for other cpus until they are done with ctnl_notifiers */
+	synchronize_rcu();
 }
=20
 static struct pernet_operations ctnetlink_net_ops =3D {
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index c9e847ff6451..4ee55017cd58 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -86,16 +86,25 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	err =3D nft_data_init(NULL, &priv->mask, &d1, tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len !=3D priv->len)
-		return -EINVAL;
+	if (d1.type !=3D NFT_DATA_VALUE || d1.len !=3D priv->len) {
+		err =3D -EINVAL;
+		goto err1;
+	}
=20
 	err =3D nft_data_init(NULL, &priv->xor, &d2, tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		return err;
-	if (d2.len !=3D priv->len)
-		return -EINVAL;
+		goto err1;
+	if (d2.type !=3D NFT_DATA_VALUE || d2.len !=3D priv->len) {
+		err =3D -EINVAL;
+		goto err2;
+	}
=20
 	return 0;
+err2:
+	nft_data_uninit(&priv->xor, d2.type);
+err1:
+	nft_data_uninit(&priv->mask, d1.type);
+	return err;
 }
=20
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *ex=
pr)
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 109b91deb69a..109793a93ec9 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,6 +84,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const=
 struct nft_expr *expr,
 	if (desc.len > U8_MAX)
 		return -ERANGE;
=20
+	if (desc.type !=3D NFT_DATA_VALUE) {
+		err =3D -EINVAL;
+		nft_data_uninit(&priv->data, desc.type);
+		return err;
+	}
+
 	priv->len =3D desc.len;
 	return 0;
 }
@@ -201,10 +207,18 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const s=
truct nlattr * const tb[])
 	if (err < 0)
 		return ERR_PTR(err);
=20
+	if (desc.type !=3D NFT_DATA_VALUE) {
+		err =3D -EINVAL;
+		goto err1;
+	}
+
 	if (desc.len <=3D sizeof(u32) && op =3D=3D NFT_CMP_EQ)
 		return &nft_cmp_fast_ops;
-	else
-		return &nft_cmp_ops;
+
+	return &nft_cmp_ops;
+err1:
+	nft_data_uninit(&data, desc.type);
+	return ERR_PTR(-EINVAL);
 }
=20
 static struct nft_expr_type nft_cmp_type __read_mostly =3D {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2ba9b1a03229..fe436431bd2d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -608,7 +608,8 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *=
po,
 			msec =3D 1;
 			div =3D speed / 1000;
 		}
-	}
+	} else
+		return DEFAULT_PRB_RETIRE_TOV;
=20
 	mbits =3D (blk_size_in_bytes * 8) / (1024 * 1024);
=20
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index a2abc449ce8f..eaf8e3e727dc 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -266,12 +266,12 @@ static int tcf_em_validate(struct tcf_proto *tp,
 				}
 				em->data =3D (unsigned long) v;
 			}
+			em->datalen =3D data_len;
 		}
 	}
=20
 	em->matchid =3D em_hdr->matchid;
 	em->flags =3D em_hdr->flags;
-	em->datalen =3D data_len;
=20
 	err =3D 0;
 errout:
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index da3621feae74..1a0f943a3423 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -687,8 +687,14 @@ static int fq_change(struct Qdisc *sch, struct nlattr =
*opt)
 	if (tb[TCA_FQ_FLOW_PLIMIT])
 		q->flow_plimit =3D nla_get_u32(tb[TCA_FQ_FLOW_PLIMIT]);
=20
-	if (tb[TCA_FQ_QUANTUM])
-		q->quantum =3D nla_get_u32(tb[TCA_FQ_QUANTUM]);
+	if (tb[TCA_FQ_QUANTUM]) {
+		u32 quantum =3D nla_get_u32(tb[TCA_FQ_QUANTUM]);
+
+		if (quantum > 0 && quantum <=3D (1 << 20))
+			q->quantum =3D quantum;
+		else
+			err =3D -EINVAL;
+	}
=20
 	if (tb[TCA_FQ_INITIAL_QUANTUM])
 		q->initial_quantum =3D nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 5e30bdce1d21..ec0eeb35b334 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1327,8 +1327,10 @@ static int sctp_cmd_interpreter(sctp_event_t event_t=
ype,
 			/* Generate an INIT ACK chunk.  */
 			new_obj =3D sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
 						     0);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error =3D -ENOMEM;
+				break;
+			}
=20
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1350,7 +1352,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_ty=
pe,
 			if (!new_obj) {
 				if (cmd->obj.chunk)
 					sctp_chunk_free(cmd->obj.chunk);
-				goto nomem;
+				error =3D -ENOMEM;
+				break;
 			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1397,8 +1400,10 @@ static int sctp_cmd_interpreter(sctp_event_t event_t=
ype,
=20
 			/* Generate a SHUTDOWN chunk.  */
 			new_obj =3D sctp_make_shutdown(asoc, chunk);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error =3D -ENOMEM;
+				break;
+			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
 			break;
@@ -1727,11 +1732,17 @@ static int sctp_cmd_interpreter(sctp_event_t event_=
type,
 			break;
 		}
=20
-		if (error)
+		if (error) {
+			cmd =3D sctp_next_cmd(commands);
+			while (cmd) {
+				if (cmd->verb =3D=3D SCTP_CMD_REPLY)
+					sctp_chunk_free(cmd->obj.chunk);
+				cmd =3D sctp_next_cmd(commands);
+			}
 			break;
+		}
 	}
=20
-out:
 	/* If this is in response to a received chunk, wait until
 	 * we are done with the packet to open the queue so that we don't
 	 * send multiple packets in response to a single request.
@@ -1742,8 +1753,5 @@ static int sctp_cmd_interpreter(sctp_event_t event_ty=
pe,
 	} else if (local_cork)
 		error =3D sctp_outq_uncork(&asoc->outqueue);
 	return error;
-nomem:
-	error =3D -ENOMEM;
-	goto out;
 }
=20
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2d8e3d82ad74..731da31aa246 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1583,3 +1583,48 @@ EXPORT_SYMBOL(rfc1042_header);
 const unsigned char bridge_tunnel_header[] __aligned(2) =3D
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
+
+/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
+struct iapp_layer2_update {
+	u8 da[ETH_ALEN];	/* broadcast */
+	u8 sa[ETH_ALEN];	/* STA addr */
+	__be16 len;		/* 6 */
+	u8 dsap;		/* 0 */
+	u8 ssap;		/* 0 */
+	u8 control;
+	u8 xid_info[3];
+} __packed;
+
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr)
+{
+	struct iapp_layer2_update *msg;
+	struct sk_buff *skb;
+
+	/* Send Level 2 Update Frame to update forwarding tables in layer 2
+	 * bridge devices */
+
+	skb =3D dev_alloc_skb(sizeof(*msg));
+	if (!skb)
+		return;
+	msg =3D (struct iapp_layer2_update *)skb_put(skb, sizeof(*msg));
+
+	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
+	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
+
+	eth_broadcast_addr(msg->da);
+	ether_addr_copy(msg->sa, addr);
+	msg->len =3D htons(6);
+	msg->dsap =3D 0;
+	msg->ssap =3D 0x01;	/* NULL LSAP, CR Bit: Response */
+	msg->control =3D 0xaf;	/* XID response lsb.1111F101.
+				 * F=3D0 (no poll command; unsolicited frame) */
+	msg->xid_info[0] =3D 0x81;	/* XID format identifier */
+	msg->xid_info[1] =3D 1;	/* LLC types/classes: Type 1 LLC */
+	msg->xid_info[2] =3D 0;	/* XID sender's receive window size (RW) */
+
+	skb->dev =3D dev;
+	skb->protocol =3D eth_type_trans(skb, dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx_ni(skb);
+}
+EXPORT_SYMBOL(cfg80211_send_layer2_update);
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index a97ae04f5d2a..1d03915bf822 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -52,6 +52,10 @@
 #define R_AARCH64_ABS64	257
 #endif
=20
+#define R_ARM_PC24		1
+#define R_ARM_THM_CALL		10
+#define R_ARM_CALL		28
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static char gpfx;	/* prefix for global symbol name (sometimes '_') */
@@ -355,6 +359,18 @@ is_mcounted_section_name(char const *const txtname)
 #define RECORD_MCOUNT_64
 #include "recordmcount.h"
=20
+static int arm_is_fake_mcount(Elf32_Rel const *rp)
+{
+	switch (ELF32_R_TYPE(w(rp->r_info))) {
+	case R_ARM_THM_CALL:
+	case R_ARM_CALL:
+	case R_ARM_PC24:
+		return 0;
+	}
+
+	return 1;
+}
+
 /* 64-bit EM_MIPS has weird ELF64_Rela.r_info.
  * http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4658-=
001.pdf
  * We interpret Table 29 Relocation Operation (Elf64_Rel, Elf64_Rela) [p.4=
0]
@@ -443,6 +459,7 @@ do_file(char const *const fname)
 		break;
 	case EM_ARM:	 reltype =3D R_ARM_ABS32;
 			 altmcount =3D "__gnu_mcount_nc";
+			 is_fake_mcount32 =3D arm_is_fake_mcount;
 			 break;
 	case EM_AARCH64:
 			 reltype =3D R_AARCH64_ABS64; gpfx =3D '_'; break;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index a0ee065a9f8c..4195e3c8b641 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -459,6 +459,10 @@ static int snd_pcm_hw_params(struct snd_pcm_substream =
*substream,
 	while (runtime->boundary * 2 <=3D LONG_MAX - runtime->buffer_size)
 		runtime->boundary *=3D 2;
=20
+	/* clear the buffer for avoiding possible kernel info leaks */
+	if (runtime->dma_area)
+		memset(runtime->dma_area, 0, runtime->dma_bytes);
+
 	snd_pcm_timer_resolution_change(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
=20
diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
index 0e6210000fa9..f6fa4b55d33d 100644
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -484,15 +484,19 @@ void snd_seq_info_timer_read(struct snd_info_entry *e=
ntry,
 		q =3D queueptr(idx);
 		if (q =3D=3D NULL)
 			continue;
-		if ((tmr =3D q->timer) =3D=3D NULL ||
-		    (ti =3D tmr->timeri) =3D=3D NULL) {
-			queuefree(q);
-			continue;
-		}
+		mutex_lock(&q->timer_mutex);
+		tmr =3D q->timer;
+		if (!tmr)
+			goto unlock;
+		ti =3D tmr->timeri;
+		if (!ti)
+			goto unlock;
 		snd_iprintf(buffer, "Timer for queue %i : %s\n", q->queue, ti->timer->na=
me);
 		resolution =3D snd_timer_resolution(ti) * tmr->ticks;
 		snd_iprintf(buffer, "  Period time : %lu.%09lu\n", resolution / 10000000=
00, resolution % 1000000000);
 		snd_iprintf(buffer, "  Skew : %u / %u\n", tmr->skew, tmr->skew_base);
+unlock:
+		mutex_unlock(&q->timer_mutex);
 		queuefree(q);
  	}
 }
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 554a138efdbf..9e2387efa4ec 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1271,13 +1271,14 @@ struct scp_msg {
=20
 static void dspio_clear_response_queue(struct hda_codec *codec)
 {
+	unsigned long timeout =3D jiffies + msecs_to_jiffies(1000);
 	unsigned int dummy =3D 0;
-	int status =3D -1;
+	int status;
=20
 	/* clear all from the response queue */
 	do {
 		status =3D dspio_read(codec, &dummy);
-	} while (status =3D=3D 0);
+	} while (status =3D=3D 0 && time_before(jiffies, timeout));
 }
=20
 static int dspio_get_response_data(struct hda_codec *codec)
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 5e7948f3efe9..45f5793465b8 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -663,6 +663,7 @@ static int snd_vt1724_set_pro_rate(struct snd_ice1712 *=
ice, unsigned int rate,
 	unsigned long flags;
 	unsigned char mclk_change;
 	unsigned int i, old_rate;
+	bool call_set_rate =3D false;
=20
 	if (rate > ice->hw_rates->list[ice->hw_rates->count - 1])
 		return -EINVAL;
@@ -686,7 +687,7 @@ static int snd_vt1724_set_pro_rate(struct snd_ice1712 *=
ice, unsigned int rate,
 		 * setting clock rate for internal clock mode */
 		old_rate =3D ice->get_rate(ice);
 		if (force || (old_rate !=3D rate))
-			ice->set_rate(ice, rate);
+			call_set_rate =3D true;
 		else if (rate =3D=3D ice->cur_rate) {
 			spin_unlock_irqrestore(&ice->reg_lock, flags);
 			return 0;
@@ -694,12 +695,14 @@ static int snd_vt1724_set_pro_rate(struct snd_ice1712=
 *ice, unsigned int rate,
 	}
=20
 	ice->cur_rate =3D rate;
+	spin_unlock_irqrestore(&ice->reg_lock, flags);
+
+	if (call_set_rate)
+		ice->set_rate(ice, rate);
=20
 	/* setting master clock */
 	mclk_change =3D ice->set_mclk(ice, rate);
=20
-	spin_unlock_irqrestore(&ice->reg_lock, flags);
-
 	if (mclk_change && ice->gpio.i2s_mclk_changed)
 		ice->gpio.i2s_mclk_changed(ice);
 	if (ice->gpio.set_pro_rate)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 0caaa8fa4231..af54f736c01d 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2795,7 +2795,7 @@ static int fll_factors(struct _fll_div *fll_div, unsi=
gned int Fref,
=20
 	if (target % Fref =3D=3D 0) {
 		fll_div->theta =3D 0;
-		fll_div->lambda =3D 0;
+		fll_div->lambda =3D 1;
 	} else {
 		gcd_fll =3D gcd(target, fratio * Fref);
=20
@@ -2865,7 +2865,7 @@ static int wm8962_set_fll(struct snd_soc_codec *codec=
, int fll_id, int source,
 		return -EINVAL;
 	}
=20
-	if (fll_div.theta || fll_div.lambda)
+	if (fll_div.theta)
 		fll1 |=3D WM8962_FLL_FRAC;
=20
 	/* Stop the FLL while we reconfigure */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 63d5303cc868..cb47c924c92a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -324,6 +324,7 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb=
_substream *subs,
 	struct usb_host_interface *alts;
 	struct usb_interface *iface;
 	unsigned int ep;
+	unsigned int ifnum;
=20
 	/* Implicit feedback sync EPs consumers are always playback EPs */
 	if (subs->direction !=3D SNDRV_PCM_STREAM_PLAYBACK)
@@ -333,34 +334,23 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_u=
sb_substream *subs,
 	case USB_ID(0x0763, 0x2030): /* M-Audio Fast Track C400 */
 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */
 		ep =3D 0x81;
-		iface =3D usb_ifnum_to_if(dev, 3);
-
-		if (!iface || iface->num_altsetting =3D=3D 0)
-			return -EINVAL;
-
-		alts =3D &iface->altsetting[1];
-		goto add_sync_ep;
-		break;
+		ifnum =3D 3;
+		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x0763, 0x2080): /* M-Audio FastTrack Ultra */
 	case USB_ID(0x0763, 0x2081):
 		ep =3D 0x81;
-		iface =3D usb_ifnum_to_if(dev, 2);
-
-		if (!iface || iface->num_altsetting =3D=3D 0)
-			return -EINVAL;
-
-		alts =3D &iface->altsetting[1];
-		goto add_sync_ep;
-	case USB_ID(0x1397, 0x0002):
+		ifnum =3D 2;
+		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x2466, 0x8003): /* Fractal Audio Axe-Fx II */
+		ep =3D 0x86;
+		ifnum =3D 2;
+		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */
 		ep =3D 0x81;
-		iface =3D usb_ifnum_to_if(dev, 1);
-
-		if (!iface || iface->num_altsetting =3D=3D 0)
-			return -EINVAL;
-
-		alts =3D &iface->altsetting[1];
-		goto add_sync_ep;
+		ifnum =3D 1;
+		goto add_sync_ep_from_ifnum;
 	}
+
 	if (attr =3D=3D USB_ENDPOINT_SYNC_ASYNC &&
 	    altsd->bInterfaceClass =3D=3D USB_CLASS_VENDOR_SPEC &&
 	    altsd->bInterfaceProtocol =3D=3D 2 &&
@@ -375,6 +365,14 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_us=
b_substream *subs,
 	/* No quirk */
 	return 0;
=20
+add_sync_ep_from_ifnum:
+	iface =3D usb_ifnum_to_if(dev, ifnum);
+
+	if (!iface || iface->num_altsetting < 2)
+		return -EINVAL;
+
+	alts =3D &iface->altsetting[1];
+
 add_sync_ep:
 	subs->sync_endpoint =3D snd_usb_add_endpoint(subs->stream->chip,
 						   alts, ep, !subs->direction,

--M9NhX3UHpAaciwkO--

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6ogSkACgkQ57/I7JWG
EQmEAA//VS2gvWaGeELNPqioAf+RRR2k4HaWJETmP2bbojCnPbJ4eFUcjKtf3/hf
h0qAporApmxO/UiLoDImgU/okQZuTNtNWuDiZZfCIkKELq7MyfRQPSEWWJQww5t7
gLsOWycx4G/IYQOcPjzRE73zDzxpGTi6LthH7skRfm7SskrK8yl17aj9ysyheh53
A8aDBAYcBqsaig0cIBxr9SfM3nDyoTl/mwDalYTWxkx4SJqclMK7hfyPZOYzxi5l
Yum6B7uY11BiQiwXfUKlV2+CDRBhEZd6FG6raB1b3N5eeYX9pRn10D3ZxRhrXpFS
LWcJiLX/2huxgqGrPvY3E4NT1OcrL1CdVv2rQTp1JCRy329JYt2Secx0BBW6tzbA
wnDM+RfAtHQYr7KCcw0515kNypawEr7mYGNYfCm+ebzMyCzTeYBBAS5Xkvp2hclU
MUMBorIV3glu0qij5XXvP4tVrkET/mIxCZS63T+Dwqwy0Q9B4sfOm7G6cDPeagW0
pBXa2ILOUMBqyMdlYEanOtVID7aMse/gZNMBCQdRIj+sGhhwpIuA99/ClTGB0hri
/bDy0sQ5Nul8bSm8l2JIfQlRamaTbK+C/7IfAyvglwU8cEnO3+gYBcV/SAYch1nO
PxBGN/87ByB7A/+koOD/W898vaYsYt9lXkWcEw8pNaHaug3A9r4=
=ZNjT
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
