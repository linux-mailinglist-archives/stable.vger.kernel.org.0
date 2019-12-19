Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76A512679E
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 18:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLSRFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 12:05:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53160 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfLSRFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 12:05:23 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ihzEl-0007SX-0P; Thu, 19 Dec 2019 17:05:19 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ihzEk-0005aC-8y; Thu, 19 Dec 2019 17:05:18 +0000
Date:   Thu, 19 Dec 2019 17:05:18 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.80
Message-ID: <lsq.1576775085.691534336@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.80 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.16.79 is attached to this message.

Ben.

------------

 Documentation/usb/rio.txt                          | 138 -----
 MAINTAINERS                                        |   7 -
 Makefile                                           |   2 +-
 arch/arc/kernel/perf_event.c                       |   4 +-
 arch/arm/configs/badge4_defconfig                  |   1 -
 arch/arm/configs/corgi_defconfig                   |   1 -
 arch/arm/configs/s3c2410_defconfig                 |   1 -
 arch/arm/configs/spitz_defconfig                   |   1 -
 arch/arm/mm/alignment.c                            |  44 +-
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/configs/mtx1_defconfig                   |   1 -
 arch/mips/configs/rm200_defconfig                  |   1 -
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 arch/mips/mm/tlbex.c                               |  23 +-
 arch/parisc/mm/ioremap.c                           |  12 +-
 arch/powerpc/configs/c2k_defconfig                 |   1 -
 arch/s390/mm/cmm.c                                 |  12 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |   5 +-
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/xtensa/kernel/xtensa_ksyms.c                  |   7 -
 drivers/block/drbd/drbd_main.c                     |   1 -
 drivers/char/virtio_console.c                      |  28 +-
 drivers/clk/at91/clk-main.c                        |   5 +-
 drivers/clk/at91/clk-slow.c                        |  15 +-
 drivers/clk/samsung/clk-exynos5420.c               |   6 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   1 +
 drivers/hid/hid-core.c                             |   7 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   3 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/net/bonding/bond_main.c                    |   6 +-
 drivers/net/can/c_can/c_can.c                      |  25 +-
 drivers/net/can/c_can/c_can.h                      |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  17 +-
 drivers/net/can/usb/usb_8dev.c                     |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  15 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   6 +-
 drivers/net/ethernet/sfc/ptp.c                     |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/bcm7xxx.c                          |   1 +
 drivers/net/usb/hso.c                              |  12 +-
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/pci/pci.c                                  |  24 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/scsi/sd.c                                  |   3 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |   2 +-
 drivers/tty/serial/uartlite.c                      |   3 +-
 drivers/usb/class/usblp.c                          |  12 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   6 +-
 drivers/usb/gadget/dummy_hcd.c                     |   3 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |   6 +-
 drivers/usb/host/xhci.c                            |  30 +-
 drivers/usb/image/microtek.c                       |   4 +
 drivers/usb/misc/Kconfig                           |  10 -
 drivers/usb/misc/Makefile                          |   1 -
 drivers/usb/misc/adutux.c                          |  19 +-
 drivers/usb/misc/iowarrior.c                       |   9 +-
 drivers/usb/misc/ldusb.c                           |  50 +-
 drivers/usb/misc/legousbtower.c                    |  63 +--
 drivers/usb/misc/rio500.c                          | 578 -----------------=
----
 drivers/usb/misc/rio500_usb.h                      |  37 --
 drivers/usb/misc/usblcd.c                          |  33 +-
 drivers/usb/misc/yurex.c                           |  18 +-
 drivers/usb/renesas_usbhs/common.h                 |   1 +
 drivers/usb/renesas_usbhs/fifo.c                   |   2 +-
 drivers/usb/renesas_usbhs/fifo.h                   |   1 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |  18 +-
 drivers/usb/renesas_usbhs/pipe.c                   |  15 +
 drivers/usb/renesas_usbhs/pipe.h                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   9 +
 drivers/usb/serial/keyspan.c                       |   4 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 drivers/usb/serial/usb-serial.c                    |   5 +-
 drivers/usb/serial/whiteheat.c                     |  13 +-
 drivers/usb/serial/whiteheat.h                     |   2 +-
 drivers/usb/usb-skeleton.c                         |  15 +-
 drivers/video/fbdev/omap2/dss/dss.c                |   2 +-
 fs/btrfs/file.c                                    |  36 +-
 fs/ceph/caps.c                                     |  10 +-
 fs/ceph/inode.c                                    |   1 +
 fs/ceph/mds_client.c                               |  21 +-
 fs/cifs/dir.c                                      |   8 +-
 fs/cifs/file.c                                     |   6 +
 fs/cifs/inode.c                                    |  53 +-
 fs/cifs/smb1ops.c                                  |   3 +
 fs/dcache.c                                        |   2 +-
 fs/ecryptfs/inode.c                                |  19 +-
 fs/fuse/dir.c                                      |  13 +
 fs/fuse/file.c                                     |  10 +-
 include/linux/gfp.h                                |  22 +
 include/linux/hrtimer.h                            |   2 +
 include/linux/usb/gadget.h                         |  10 +
 include/net/inetpeer.h                             |   1 +
 include/net/ip_vs.h                                |   1 +
 include/net/netfilter/nf_tables.h                  |   3 +-
 include/net/sock.h                                 |  11 +-
 kernel/hrtimer.c                                   |   1 +
 kernel/panic.c                                     |   1 +
 kernel/sched/fair.c                                |  36 +-
 kernel/time/tick-broadcast-hrtimer.c               |  57 +-
 kernel/trace/trace.c                               |  17 +-
 lib/dump_stack.c                                   |   7 +-
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/ksm.c                                           |  14 +-
 mm/memcontrol.c                                    |   2 +-
 mm/slub.c                                          |  13 +-
 mm/vmstat.c                                        |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |  61 ++-
 net/batman-adv/hard-interface.c                    |   2 +
 net/batman-adv/types.h                             |   3 +
 net/dccp/ipv4.c                                    |   4 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/inetpeer.c                                |   1 +
 net/ipv4/route.c                                   |  12 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/ip6_input.c                               |  10 +
 net/llc/llc_s_ac.c                                 |  12 +-
 net/llc/llc_sap.c                                  |  23 +-
 net/mac80211/mlme.c                                |   5 +-
 net/netfilter/ipset/ip_set_core.c                  |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  15 +-
 net/nfc/llcp_sock.c                                |   7 +-
 net/sched/act_api.c                                |  12 +-
 net/sched/act_pedit.c                              |   4 +-
 net/sched/sch_cbq.c                                |  31 +-
 net/sched/sch_dsmark.c                             |   2 +
 net/sched/sch_netem.c                              |   2 +
 net/sctp/socket.c                                  |   2 +-
 net/wireless/nl80211.c                             |   3 +-
 sound/core/timer.c                                 |  67 ++-
 sound/firewire/bebob/bebob_focusrite.c             |   3 +
 sound/firewire/bebob/bebob_stream.c                |   3 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |   8 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/mixer.c                                  |   4 +-
 tools/perf/util/hist.c                             |   2 +-
 142 files changed, 957 insertions(+), 1235 deletions(-)

Al Viro (3):
      ceph: add missing check in d_revalidate snapdir handling
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable eit=
her

Alan Stern (2):
      USB: yurex: Don't retry on unexpected errors
      USB: gadget: Reject endpoints with 0 maxpacket value

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue

Alexandre Belloni (1):
      clk: at91: avoid sleeping early

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU

Andreas Sandberg (1):
      tick: hrtimer-broadcast: Prevent endless restarting when broadcast de=
vice is unused

Andrey Ryabinin (1):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

Balasubramani Vivekanandan (1):
      tick: broadcast-hrtimer: Fix a race in bc_set_next

Bart Van Assche (1):
      RDMA/iwcm: Fix a lock inversion issue

Bastien Nocera (1):
      USB: rio500: Remove Rio 500 kernel driver

Ben Hutchings (1):
      Linux 3.16.80

Beni Mahler (1):
      USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20

Christophe JAILLET (1):
      memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Dan Carpenter (3):
      USB: legousbtower: fix a signedness bug in tower_probe()
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()
      block: drbd: remove a stray unlock in __drbd_send_protocol()

Daniel Wagner (1):
      scsi: lpfc: Honor module parameter lpfc_use_adisc

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Denis Efremov (1):
      staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()

Doug Berger (2):
      net: phy: bcm7xxx: define soft_reset for 40nm EPHY
      net: bcmgenet: reset 40nm EPHY on energy detect

Eric Biggers (1):
      llc: fix sk_buff leak in llc_sap_state_process()

Eric Dumazet (8):
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
      ipv6: drop incoming packets having a v4mapped source address
      sch_dsmark: fix potential NULL deref in dsmark_init()
      nfc: fix memory leak in llcp_sock_bind()
      net: avoid potential infinite loop in tc_ctl_action()
      ipvs: move old_secure_tcp into struct netns_ipvs
      inet: stop leaking jiffies on the wire
      dccp: do not leak jiffies on the wire

Filipe Manana (1):
      Btrfs: check for the full sync flag while holding the inode lock duri=
ng fsync

Florian Fainelli (1):
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3

Gustavo A. R. Silva (1):
      usb: udc: lpc32xx: fix bad bit shift operation

Helge Deller (1):
      parisc: Fix vmap memory leak in ioremap()/iounmap()

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

Jacky.Cao@sony.com (1):
      USB: dummy-hcd: fix power budget for SuperSpeed mode

Jakub Kicinski (1):
      net: netem: correct the parent's backlog when corrupted packet was dr=
opped

Jan Schmidt (1):
      xhci: Check all endpoints for LPM timeout

Jeff Layton (1):
      ceph: just skip unrecognized info in ceph_reply_info_extra

Jiri Olsa (1):
      perf tools: Fix time sorting

Johan Hovold (30):
      hso: fix NULL-deref on tty open
      USB: serial: keyspan: fix NULL-derefs on open() and write()
      USB: microtek: fix info-leak at probe
      USB: adutux: fix NULL-derefs on disconnect
      USB: usblcd: fix I/O after disconnect
      USB: legousbtower: fix slab info leak at probe
      USB: legousbtower: fix deadlock on disconnect
      USB: legousbtower: fix potential NULL-deref on disconnect
      USB: legousbtower: fix open after failed reset request
      USB: usb-skeleton: fix runtime PM after driver unbind
      USB: usblp: fix runtime PM after driver unbind
      USB: serial: fix runtime PM after driver unbind
      media: stkwebcam: fix runtime PM after driver unbind
      USB: usb-skeleton: fix NULL-deref on disconnect
      USB: legousbtower: fix use-after-free on release
      USB: ldusb: fix NULL-derefs on driver unbind
      USB: adutux: fix use-after-free on release
      USB: iowarrior: fix use-after-free on release
      USB: iowarrior: fix use-after-free after driver unbind
      USB: yurex: fix NULL-derefs on disconnect
      USB: ldusb: fix memleak on disconnect
      USB: legousbtower: fix memleak on disconnect
      USB: usblp: fix use-after-free on disconnect
      USB: serial: ti_usb_3410_5052: fix port-close races
      USB: ldusb: fix read info leaks
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness
      can: usb_8dev: fix use-after-free on disconnect

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Jose Abreu (1):
      net: stmmac: Correctly take timestamp for PTPv2

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()

Kai-Heng Feng (1):
      x86/quirks: Disable HPET on Intel Coffe Lake platforms

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus pre=
cise RIP validity
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family=
 (10h)

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Lorenzo Bianconi (1):
      net: ipv4: use a dedicated counter for icmp_v4 redirect packets

Luis Henriques (1):
      ceph: fix use-after-free in __ceph_remove_cap()

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Marek Szyprowski (1):
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/r=
esume

Markus Pargmann (1):
      batman-adv: iv_ogm_iface_enable, direct return values

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Mathias Nyman (1):
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too l=
ong

Max Filippov (1):
      xtensa: drop EXPORT_SYMBOL for outs*/ins*

Michal Hocko (1):
      mm, vmstat: hide /proc/pagetypeinfo from normal users

Micha=C5=82 Miros=C5=82aw (1):
      HID: fix error message in hid_open_report()

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Nakajima Akira (1):
      Fix to check Unique id and FileType when client refer file directly.

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Paul Burton (1):
      MIPS: tlbex: Fix build_restore_pagemask KScratch restore

Pavel Shilovsky (3):
      CIFS: Gracefully handle QueryInfo errors during open
      CIFS: Force revalidate inode when dentry is stale
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Qian Cai (1):
      mm/slub: fix a deadlock in show_slab_objects()

Rafael J. Wysocki (1):
      PCI: PM: Fix pci_power_up()

Randy Dunlap (1):
      serial: uartlite: fix exit path null pointer

Rick Tseng (1):
      usb: xhci: wait for CNR controller not ready bit in xhci resume

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Ross Lagerwall (1):
      cifs: Check uniqueid for SMB2+ and return -ESTALE if necessary

Russell King (2):
      ARM: mm: fix alignment handler faults under memory pressure
      ASoC: kirkwood: fix external clock probe defer

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Steven Rostedt (VMware) (1):
      tracing: Get trace_array reference for available_tracers files

Sven Eckelmann (1):
      batman-adv: Avoid free/alloc race when handling OGM buffer

Taehee Yoo (1):
      bonding: fix unexpected IFF_BONDING bit unset

Takashi Iwai (4):
      ALSA: timer: Simplify error path in snd_timer_open()
      ALSA: timer: Fix incorrectly assigned timer instance
      ALSA: timer: Fix mutex deadlock at releasing card
      ALSA: usb-audio: Fix missing error check at mixer resolution test

Takashi Sakamoto (2):
      ALSA: bebob: Fix prototype of helper function to return negative value
      ALSA: bebob: fix to detect configured source of sampling clock for Fo=
cusrite Saffire Pro i/o series

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Thomas Gleixner (1):
      tick: broadcast-hrtimer: Remove overly clever return value abuse

Tomi Valkeinen (1):
      drm/omap: fix max fclk divider for omap36xx

Viresh Kumar (1):
      hrtimer: Store cpu-number in struct hrtimer_cpu_base

Will Deacon (2):
      mac80211: Reject malformed SSID elements
      panic: ensure preemption is disabled during panic()

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/per=
iod ratio precision

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt=
,wedge}()
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

Yufen Yu (1):
      scsi: core: try to get module before removing device

zhangyi (F) (1):
      fs/dcache: move security_d_instantiate() behind attaching dentry to i=
node


--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.80.patch"
Content-Disposition: attachment; filename="linux-3.16.80.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/usb/rio.txt b/Documentation/usb/rio.txt
deleted file mode 100644
index aee715af7db7..000000000000
--- a/Documentation/usb/rio.txt
+++ /dev/null
@@ -1,138 +0,0 @@
-Copyright (C) 1999, 2000 Bruce Tenison
-Portions Copyright (C) 1999, 2000 David Nelson
-Thanks to David Nelson for guidance and the usage of the scanner.txt
-and scanner.c files to model our driver and this informative file.
-
-Mar. 2, 2000
-
-CHANGES
-
-- Initial Revision
-
-
-OVERVIEW
-
-This README will address issues regarding how to configure the kernel
-to access a RIO 500 mp3 player. =20
-Before I explain how to use this to access the Rio500 please be warned:
-
-W A R N I N G:
---------------
-
-Please note that this software is still under development.  The authors
-are in no way responsible for any damage that may occur, no matter how
-inconsequential.
-
-It seems that the Rio has a problem when sending .mp3 with low batteries.
-I suggest when the batteries are low and you want to transfer stuff that y=
ou
-replace it with a fresh one. In my case, what happened is I lost two 16kb
-blocks (they are no longer usable to store information to it). But I don't
-know if that's normal or not; it could simply be a problem with the flash=
=20
-memory.
-
-In an extreme case, I left my Rio playing overnight and the batteries wore=
=20
-down to nothing and appear to have corrupted the flash memory. My RIO=20
-needed to be replaced as a result.  Diamond tech support is aware of the=
=20
-problem.  Do NOT allow your batteries to wear down to nothing before=20
-changing them.  It appears RIO 500 firmware does not handle low battery=20
-power well at all.=20
-
-On systems with OHCI controllers, the kernel OHCI code appears to have=20
-power on problems with some chipsets.  If you are having problems=20
-connecting to your RIO 500, try turning it on first and then plugging it=
=20
-into the USB cable. =20
-
-Contact information:
---------------------
-
-   The main page for the project is hosted at sourceforge.net in the follo=
wing
-   URL: <http://rio500.sourceforge.net>. You can also go to the project's
-   sourceforge home page at: <http://sourceforge.net/projects/rio500/>.
-   There is also a mailing list: rio500-users@lists.sourceforge.net
-
-Authors:
--------
-
-Most of the code was written by Cesar Miquel <miquel@df.uba.ar>. Keith=20
-Clayton <kclayton@jps.net> is incharge of the PPC port and making sure
-things work there. Bruce Tenison <btenison@dibbs.net> is adding support
-for .fon files and also does testing. The program will mostly sure be
-re-written and Pete Ikusz along with the rest will re-design it. I would
-also like to thank Tri Nguyen <tmn_3022000@hotmail.com> who provided use=
=20
-with some important information regarding the communication with the Rio.
-
-ADDITIONAL INFORMATION and Userspace tools
-
-http://rio500.sourceforge.net/
-
-
-REQUIREMENTS
-
-A host with a USB port.  Ideally, either a UHCI (Intel) or OHCI
-(Compaq and others) hardware port should work.
-
-A Linux development kernel (2.3.x) with USB support enabled or a
-backported version to linux-2.2.x.  See http://www.linux-usb.org for
-more information on accomplishing this.
-
-A Linux kernel with RIO 500 support enabled.
-
-'lspci' which is only needed to determine the type of USB hardware
-available in your machine.
-
-CONFIGURATION
-
-Using `lspci -v`, determine the type of USB hardware available.
-
-  If you see something like:
-
-    USB Controller: ......
-    Flags: .....
-    I/O ports at ....
-
-  Then you have a UHCI based controller.
-
-  If you see something like:
-
-     USB Controller: .....
-     Flags: ....
-     Memory at .....
-
-  Then you have a OHCI based controller.
-
-Using `make menuconfig` or your preferred method for configuring the
-kernel, select 'Support for USB', 'OHCI/UHCI' depending on your
-hardware (determined from the steps above), 'USB Diamond Rio500 support', =
and
-'Preliminary USB device filesystem'.  Compile and install the modules
-(you may need to execute `depmod -a` to update the module
-dependencies).
-
-Add a device for the USB rio500:
-  `mknod /dev/usb/rio500 c 180 64`
-
-Set appropriate permissions for /dev/usb/rio500 (don't forget about
-group and world permissions).  Both read and write permissions are
-required for proper operation.
-
-Load the appropriate modules (if compiled as modules):
-
-  OHCI:
-    modprobe usbcore
-    modprobe usb-ohci
-    modprobe rio500
-
-  UHCI:
-    modprobe usbcore
-    modprobe usb-uhci  (or uhci)
-    modprobe rio500
-
-That's it.  The Rio500 Utils at: http://rio500.sourceforge.net should
-be able to access the rio500.
-
-BUGS
-
-If you encounter any problems feel free to drop me an email.
-
-Bruce Tenison
-btenison@dibbs.net
-
diff --git a/MAINTAINERS b/MAINTAINERS
index 61dbb398b540..c886cb2e95f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9420,13 +9420,6 @@ W:	http://www.linux-usb.org/usbnet
 S:	Maintained
 F:	drivers/net/usb/dm9601.c
=20
-USB DIAMOND RIO500 DRIVER
-M:	Cesar Miquel <miquel@df.uba.ar>
-L:	rio500-users@lists.sourceforge.net
-W:	http://rio500.sourceforge.net
-S:	Maintained
-F:	drivers/usb/misc/rio500*
-
 USB EHCI DRIVER
 M:	Alan Stern <stern@rowland.harvard.edu>
 L:	linux-usb@vger.kernel.org
diff --git a/Makefile b/Makefile
index a53770703aa1..05ef2a1167fc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 79
+SUBLEVEL =3D 80
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 63177e4cb66d..99e4cc6941e0 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -274,8 +274,8 @@ static int arc_pmu_device_probe(struct platform_device =
*pdev)
=20
 	for (j =3D 0; j < cc_bcr.c; j++) {
 		write_aux_reg(ARC_REG_CC_INDEX, j);
-		cc_name.indiv.word0 =3D read_aux_reg(ARC_REG_CC_NAME0);
-		cc_name.indiv.word1 =3D read_aux_reg(ARC_REG_CC_NAME1);
+		cc_name.indiv.word0 =3D le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME0));
+		cc_name.indiv.word1 =3D le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME1));
 		for (i =3D 0; i < ARRAY_SIZE(arc_pmu_ev_hw_map); i++) {
 			if (arc_pmu_ev_hw_map[i] &&
 			    !strcmp(arc_pmu_ev_hw_map[i], cc_name.str) &&
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_de=
fconfig
index 0494c8f229a2..7765ff673863 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -98,7 +98,6 @@ CONFIG_USB_SERIAL_PL2303=3Dm
 CONFIG_USB_SERIAL_CYBERJACK=3Dm
 CONFIG_USB_SERIAL_XIRCOM=3Dm
 CONFIG_USB_SERIAL_OMNINET=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_EXT2_FS=3Dm
 CONFIG_EXT3_FS=3Dm
 CONFIG_MSDOS_FS=3Dy
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defc=
onfig
index c1470a00f55a..031d9d3549b9 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -207,7 +207,6 @@ CONFIG_USB_SERIAL_XIRCOM=3Dm
 CONFIG_USB_SERIAL_OMNINET=3Dm
 CONFIG_USB_EMI62=3Dm
 CONFIG_USB_EMI26=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_=
defconfig
index eb4d204bff47..4b9521fc6834 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -355,7 +355,6 @@ CONFIG_USB_EMI62=3Dm
 CONFIG_USB_EMI26=3Dm
 CONFIG_USB_ADUTUX=3Dm
 CONFIG_USB_SEVSEG=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defc=
onfig
index a1ede1966baf..7d9aa284cb6f 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -202,7 +202,6 @@ CONFIG_USB_SERIAL_XIRCOM=3Dm
 CONFIG_USB_SERIAL_OMNINET=3Dm
 CONFIG_USB_EMI62=3Dm
 CONFIG_USB_EMI26=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 33ca98085cd5..3029ca1a21c2 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -746,6 +746,36 @@ do_alignment_t32_to_handler(unsigned long *pinstr, str=
uct pt_regs *regs,
 	return NULL;
 }
=20
+static int alignment_get_arm(struct pt_regs *regs, u32 *ip, unsigned long =
*inst)
+{
+	u32 instr =3D 0;
+	int fault;
+
+	if (user_mode(regs))
+		fault =3D get_user(instr, ip);
+	else
+		fault =3D probe_kernel_address(ip, instr);
+
+	*inst =3D __mem_to_opcode_arm(instr);
+
+	return fault;
+}
+
+static int alignment_get_thumb(struct pt_regs *regs, u16 *ip, u16 *inst)
+{
+	u16 instr =3D 0;
+	int fault;
+
+	if (user_mode(regs))
+		fault =3D get_user(instr, ip);
+	else
+		fault =3D probe_kernel_address(ip, instr);
+
+	*inst =3D __mem_to_opcode_thumb16(instr);
+
+	return fault;
+}
+
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
@@ -753,10 +783,10 @@ do_alignment(unsigned long addr, unsigned int fsr, st=
ruct pt_regs *regs)
 	unsigned long instr =3D 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *r=
egs);
 	unsigned int type;
-	unsigned int fault;
 	u16 tinstr =3D 0;
 	int isize =3D 4;
 	int thumb2_32b =3D 0;
+	int fault;
=20
 	if (interrupts_enabled(regs))
 		local_irq_enable();
@@ -765,15 +795,14 @@ do_alignment(unsigned long addr, unsigned int fsr, st=
ruct pt_regs *regs)
=20
 	if (thumb_mode(regs)) {
 		u16 *ptr =3D (u16 *)(instrptr & ~1);
-		fault =3D probe_kernel_address(ptr, tinstr);
-		tinstr =3D __mem_to_opcode_thumb16(tinstr);
+
+		fault =3D alignment_get_thumb(regs, ptr, &tinstr);
 		if (!fault) {
 			if (cpu_architecture() >=3D CPU_ARCH_ARMv7 &&
 			    IS_T32(tinstr)) {
 				/* Thumb-2 32-bit */
-				u16 tinst2 =3D 0;
-				fault =3D probe_kernel_address(ptr + 1, tinst2);
-				tinst2 =3D __mem_to_opcode_thumb16(tinst2);
+				u16 tinst2;
+				fault =3D alignment_get_thumb(regs, ptr + 1, &tinst2);
 				instr =3D __opcode_thumb32_compose(tinstr, tinst2);
 				thumb2_32b =3D 1;
 			} else {
@@ -782,8 +811,7 @@ do_alignment(unsigned long addr, unsigned int fsr, stru=
ct pt_regs *regs)
 			}
 		}
 	} else {
-		fault =3D probe_kernel_address(instrptr, instr);
-		instr =3D __mem_to_opcode_arm(instr);
+		fault =3D alignment_get_arm(regs, (void *)instrptr, &instr);
 	}
=20
 	if (fault) {
diff --git a/arch/mips/bcm63xx/prom.c b/arch/mips/bcm63xx/prom.c
index e1f27d653f60..5942c6470cce 100644
--- a/arch/mips/bcm63xx/prom.c
+++ b/arch/mips/bcm63xx/prom.c
@@ -88,7 +88,7 @@ void __init prom_init(void)
 		 * Here we will start up CPU1 in the background and ask it to
 		 * reconfigure itself then go back to sleep.
 		 */
-		memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
+		memcpy((void *)0xa0000200, bmips_smp_movevec, 0x20);
 		__sync();
 		set_c0_cause(C_SW0);
 		cpumask_set_cpu(1, &bmips_booted_mask);
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defc=
onfig
index d269a5326a30..2ced9a2080a0 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -637,7 +637,6 @@ CONFIG_USB_SERIAL_OMNINET=3Dm
 CONFIG_USB_EMI62=3Dm
 CONFIG_USB_EMI26=3Dm
 CONFIG_USB_ADUTUX=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_de=
fconfig
index 73e7bf49461c..7edd70fa9209 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -351,7 +351,6 @@ CONFIG_USB_SERIAL_SAFE_PADDED=3Dy
 CONFIG_USB_SERIAL_CYBERJACK=3Dm
 CONFIG_USB_SERIAL_XIRCOM=3Dm
 CONFIG_USB_SERIAL_OMNINET=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/mips/include/asm/bmips.h b/arch/mips/include/asm/bmips.h
index cbaccebf5065..799276202db1 100644
--- a/arch/mips/include/asm/bmips.h
+++ b/arch/mips/include/asm/bmips.h
@@ -75,11 +75,11 @@ static inline int register_bmips_smp_ops(void)
 #endif
 }
=20
-extern char bmips_reset_nmi_vec;
-extern char bmips_reset_nmi_vec_end;
-extern char bmips_smp_movevec;
-extern char bmips_smp_int_vec;
-extern char bmips_smp_int_vec_end;
+extern char bmips_reset_nmi_vec[];
+extern char bmips_reset_nmi_vec_end[];
+extern char bmips_smp_movevec[];
+extern char bmips_smp_int_vec[];
+extern char bmips_smp_int_vec_end[];
=20
 extern int bmips_smp_enabled;
 extern int bmips_cpu_offset;
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index c142b1ff089d..1767facdc2e5 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -467,10 +467,10 @@ static void bmips_wr_vec(unsigned long dst, char *sta=
rt, char *end)
=20
 static inline void bmips_nmi_handler_setup(void)
 {
-	bmips_wr_vec(BMIPS_NMI_RESET_VEC, &bmips_reset_nmi_vec,
-		&bmips_reset_nmi_vec_end);
-	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, &bmips_smp_int_vec,
-		&bmips_smp_int_vec_end);
+	bmips_wr_vec(BMIPS_NMI_RESET_VEC, bmips_reset_nmi_vec,
+		bmips_reset_nmi_vec_end);
+	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, bmips_smp_int_vec,
+		bmips_smp_int_vec_end);
 }
=20
 void bmips_ebase_setup(void)
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 04c86cfffe6f..ae9e82026e3c 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -652,6 +652,13 @@ static void build_restore_pagemask(u32 **p, struct uas=
m_reloc **r,
 				   int restore_scratch)
 {
 	if (restore_scratch) {
+		/*
+		 * Ensure the MFC0 below observes the value written to the
+		 * KScratch register by the prior MTC0.
+		 */
+		if (scratch_reg >=3D 0)
+			uasm_i_ehb(p);
+
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
 			uasm_i_lui(p, tmp, PM_DEFAULT_MASK >> 16);
@@ -666,12 +673,10 @@ static void build_restore_pagemask(u32 **p, struct ua=
sm_reloc **r,
 			uasm_i_mtc0(p, 0, C0_PAGEMASK);
 			uasm_il_b(p, r, lid);
 		}
-		if (scratch_reg >=3D 0) {
-			uasm_i_ehb(p);
+		if (scratch_reg >=3D 0)
 			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-		} else {
+		else
 			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-		}
 	} else {
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
@@ -893,6 +898,10 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l=
, struct uasm_reloc **r,
 	}
 	if (mode !=3D not_refill && check_for_high_segbits) {
 		uasm_l_large_segbits_fault(l, *p);
+
+		if (mode =3D=3D refill_scratch && scratch_reg >=3D 0)
+			uasm_i_ehb(p);
+
 		/*
 		 * We get here if we are an xsseg address, or if we are
 		 * an xuseg address above (PGDIR_SHIFT+PGDIR_BITS) boundary.
@@ -909,12 +918,10 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **=
l, struct uasm_reloc **r,
 		uasm_i_jr(p, ptr);
=20
 		if (mode =3D=3D refill_scratch) {
-			if (scratch_reg >=3D 0) {
-				uasm_i_ehb(p);
+			if (scratch_reg >=3D 0)
 				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-			} else {
+			else
 				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-			}
 		} else {
 			uasm_i_nop(p);
 		}
diff --git a/arch/parisc/mm/ioremap.c b/arch/parisc/mm/ioremap.c
index 838d0259cd27..3741f91fc186 100644
--- a/arch/parisc/mm/ioremap.c
+++ b/arch/parisc/mm/ioremap.c
@@ -2,7 +2,7 @@
  * arch/parisc/mm/ioremap.c
  *
  * (C) Copyright 1995 1996 Linus Torvalds
- * (C) Copyright 2001-2006 Helge Deller <deller@gmx.de>
+ * (C) Copyright 2001-2019 Helge Deller <deller@gmx.de>
  * (C) Copyright 2005 Kyle McMartin <kyle@parisc-linux.org>
  */
=20
@@ -83,7 +83,7 @@ void __iomem * __ioremap(unsigned long phys_addr, unsigne=
d long size, unsigned l
 	addr =3D (void __iomem *) area->addr;
 	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
 			       phys_addr, pgprot)) {
-		vfree(addr);
+		vunmap(addr);
 		return NULL;
 	}
=20
@@ -91,9 +91,11 @@ void __iomem * __ioremap(unsigned long phys_addr, unsign=
ed long size, unsigned l
 }
 EXPORT_SYMBOL(__ioremap);
=20
-void iounmap(const volatile void __iomem *addr)
+void iounmap(const volatile void __iomem *io_addr)
 {
-	if (addr > high_memory)
-		return vfree((void *) (PAGE_MASK & (unsigned long __force) addr));
+	unsigned long addr =3D (unsigned long)io_addr & PAGE_MASK;
+
+	if (is_vmalloc_addr((void *)addr))
+		vunmap((void *)addr);
 }
 EXPORT_SYMBOL(iounmap);
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_=
defconfig
index 5e2aa43562b5..a3ffb9abb6ce 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -315,7 +315,6 @@ CONFIG_USB_SERIAL_CYBERJACK=3Dm
 CONFIG_USB_SERIAL_XIRCOM=3Dm
 CONFIG_USB_SERIAL_OMNINET=3Dm
 CONFIG_USB_EMI62=3Dm
-CONFIG_USB_RIO500=3Dm
 CONFIG_USB_LEGOTOWER=3Dm
 CONFIG_USB_LCD=3Dm
 CONFIG_USB_LED=3Dm
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 79ddd580d605..ca6fab51eea1 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -306,16 +306,16 @@ static int cmm_timeout_handler(struct ctl_table *ctl,=
 int write,
 	}
=20
 	if (write) {
-		len =3D *lenp;
-		if (copy_from_user(buf, buffer,
-				   len > sizeof(buf) ? sizeof(buf) : len))
+		len =3D min(*lenp, sizeof(buf));
+		if (copy_from_user(buf, buffer, len))
 			return -EFAULT;
-		buf[sizeof(buf) - 1] =3D '\0';
+		buf[len - 1] =3D '\0';
 		cmm_skip_blanks(buf, &p);
 		nr =3D simple_strtoul(p, &p, 0);
 		cmm_skip_blanks(p, &p);
 		seconds =3D simple_strtoul(p, &p, 0);
 		cmm_set_timeout(nr, seconds);
+		*ppos +=3D *lenp;
 	} else {
 		len =3D sprintf(buf, "%ld %ld\n",
 			      cmm_timeout_pages, cmm_timeout_seconds);
@@ -323,9 +323,9 @@ static int cmm_timeout_handler(struct ctl_table *ctl, i=
nt write,
 			len =3D *lenp;
 		if (copy_to_user(buffer, buf, len))
 			return -EFAULT;
+		*lenp =3D len;
+		*ppos +=3D len;
 	}
-	*lenp =3D len;
-	*ppos +=3D len;
 	return 0;
 }
=20
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu=
/perf_event_amd_ibs.c
index cbb1be3ed9e4..bf7c266f6154 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -351,7 +351,8 @@ static inline void perf_ibs_disable_event(struct perf_i=
bs *perf_ibs,
 					  struct hw_perf_event *hwc, u64 config)
 {
 	config &=3D ~perf_ibs->cnt_mask;
-	wrmsrl(hwc->config_base, config);
+	if (boot_cpu_data.x86 =3D=3D 0x10)
+		wrmsrl(hwc->config_base, config);
 	config &=3D ~perf_ibs->enable_mask;
 	wrmsrl(hwc->config_base, config);
 }
@@ -555,7 +556,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ib=
s, struct pt_regs *iregs)
 	if (event->attr.sample_type & PERF_SAMPLE_RAW)
 		offset_max =3D perf_ibs->offset_max;
 	else if (check_rip)
-		offset_max =3D 2;
+		offset_max =3D 3;
 	else
 		offset_max =3D 1;
 	do {
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 2fa494f59828..982cda091b81 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -672,6 +672,8 @@ static struct chipset early_qrk[] __initdata =3D {
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}
diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_=
ksyms.c
index a71d2739fa82..9210b9cc4ec9 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -114,13 +114,6 @@ EXPORT_SYMBOL(__invalidate_icache_range);
 // FIXME EXPORT_SYMBOL(screen_info);
 #endif
=20
-EXPORT_SYMBOL(outsb);
-EXPORT_SYMBOL(outsw);
-EXPORT_SYMBOL(outsl);
-EXPORT_SYMBOL(insb);
-EXPORT_SYMBOL(insw);
-EXPORT_SYMBOL(insl);
-
 extern long common_exception_return;
 EXPORT_SYMBOL(common_exception_return);
=20
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 960645c26e6f..a65ef5ac107f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -786,7 +786,6 @@ int __drbd_send_protocol(struct drbd_connection *connec=
tion, enum drbd_packet cm
=20
 	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
-		mutex_unlock(&sock->mutex);
 		drbd_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 00448863f981..bce07e3d2e75 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1362,24 +1362,24 @@ static void set_console_size(struct port *port, u16=
 rows, u16 cols)
 	port->cons.ws.ws_col =3D cols;
 }
=20
-static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
+static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 {
 	struct port_buffer *buf;
-	unsigned int nr_added_bufs;
+	int nr_added_bufs;
 	int ret;
=20
 	nr_added_bufs =3D 0;
 	do {
 		buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
 		if (!buf)
-			break;
+			return -ENOMEM;
=20
 		spin_lock_irq(lock);
 		ret =3D add_inbuf(vq, buf);
 		if (ret < 0) {
 			spin_unlock_irq(lock);
 			free_buf(buf, true);
-			break;
+			return ret;
 		}
 		nr_added_bufs++;
 		spin_unlock_irq(lock);
@@ -1399,7 +1399,6 @@ static int add_port(struct ports_device *portdev, u32=
 id)
 	char debugfs_name[16];
 	struct port *port;
 	dev_t devt;
-	unsigned int nr_added_bufs;
 	int err;
=20
 	port =3D kmalloc(sizeof(*port), GFP_KERNEL);
@@ -1457,11 +1456,13 @@ static int add_port(struct ports_device *portdev, u=
32 id)
 	spin_lock_init(&port->outvq_lock);
 	init_waitqueue_head(&port->waitqueue);
=20
-	/* Fill the in_vq with buffers so the host can send us data. */
-	nr_added_bufs =3D fill_queue(port->in_vq, &port->inbuf_lock);
-	if (!nr_added_bufs) {
+	/* We can safely ignore ENOSPC because it means
+	 * the queue already has buffers. Buffers are removed
+	 * only by virtcons_remove(), not by unplug_port()
+	 */
+	err =3D fill_queue(port->in_vq, &port->inbuf_lock);
+	if (err < 0 && err !=3D -ENOSPC) {
 		dev_err(port->dev, "Error allocating inbufs\n");
-		err =3D -ENOMEM;
 		goto free_device;
 	}
=20
@@ -2079,14 +2080,11 @@ static int virtcons_probe(struct virtio_device *vde=
v)
 	INIT_WORK(&portdev->control_work, &control_work_handler);
=20
 	if (multiport) {
-		unsigned int nr_added_bufs;
-
 		spin_lock_init(&portdev->c_ivq_lock);
 		spin_lock_init(&portdev->c_ovq_lock);
=20
-		nr_added_bufs =3D fill_queue(portdev->c_ivq,
-					   &portdev->c_ivq_lock);
-		if (!nr_added_bufs) {
+		err =3D fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
+		if (err < 0) {
 			dev_err(&vdev->dev,
 				"Error allocating buffers for control queue\n");
 			/*
@@ -2097,7 +2095,7 @@ static int virtcons_probe(struct virtio_device *vdev)
 					   VIRTIO_CONSOLE_DEVICE_READY, 0);
 			/* Device was functional: we need full cleanup. */
 			virtcons_remove(vdev);
-			return -ENOMEM;
+			return err;
 		}
 	} else {
 		/*
diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 733306131b99..2714ad2de0d0 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -374,7 +374,10 @@ static int clk_main_probe_frequency(struct at91_pmc *p=
mc)
 		tmp =3D pmc_read(pmc, AT91_CKGR_MCFR);
 		if (tmp & AT91_PMC_MAINRDY)
 			return 0;
-		usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
+		if (system_state < SYSTEM_RUNNING)
+			udelay(MAINF_LOOP_MIN_WAIT);
+		else
+			usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
 	} while (time_before(prep_time, timeout));
=20
 	return -ETIMEDOUT;
diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
index ef8d458cd74a..790112edf81b 100644
--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -83,7 +83,10 @@ static int clk_slow_osc_prepare(struct clk_hw *hw)
=20
 	writel(tmp | AT91_SCKC_OSC32EN, sckcr);
=20
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
=20
 	return 0;
 }
@@ -202,7 +205,10 @@ static int clk_slow_rc_osc_prepare(struct clk_hw *hw)
=20
 	writel(readl(sckcr) | AT91_SCKC_RCEN, sckcr);
=20
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
=20
 	return 0;
 }
@@ -311,7 +317,10 @@ static int clk_sam9x5_slow_set_parent(struct clk_hw *h=
w, u8 index)
=20
 	writel(tmp, sckcr);
=20
-	usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(SLOWCK_SW_TIME_USEC);
+	else
+		usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
=20
 	return 0;
 }
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk=
-exynos5420.c
index a4e6cc782e5c..d504b9124b9f 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -162,12 +162,18 @@ static unsigned long exynos5x_clk_regs[] __initdata =
=3D {
 	GATE_BUS_CPU,
 	GATE_SCLK_CPU,
 	CLKOUT_CMU_CPU,
+	CPLL_CON0,
+	DPLL_CON0,
 	EPLL_CON0,
 	EPLL_CON1,
 	EPLL_CON2,
 	RPLL_CON0,
 	RPLL_CON1,
 	RPLL_CON2,
+	IPLL_CON0,
+	SPLL_CON0,
+	VPLL_CON0,
+	MPLL_CON0,
 	SRC_TOP0,
 	SRC_TOP1,
 	SRC_TOP2,
diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dp=
m.c
index 80f659d109f9..ae4749e43a06 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -1951,6 +1951,7 @@ static void si_initialize_powertune_defaults(struct r=
adeon_device *rdev)
 		case 0x682C:
 			si_pi->cac_weights =3D cac_weights_cape_verde_pro;
 			si_pi->dte_data =3D dte_data_sun_xt;
+			update_dte_from_pl2 =3D true;
 			break;
 		case 0x6825:
 		case 0x6827:
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 30544beb1a12..7e4da6d0af06 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -911,6 +911,7 @@ int hid_open_report(struct hid_device *device)
 	__u8 *start;
 	__u8 *buf;
 	__u8 *end;
+	__u8 *next;
 	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) =3D {
@@ -964,7 +965,8 @@ int hid_open_report(struct hid_device *device)
 	device->collection_size =3D HID_DEFAULT_NUM_COLLECTIONS;
=20
 	ret =3D -EINVAL;
-	while ((start =3D fetch_item(start, end, &item)) !=3D NULL) {
+	while ((next =3D fetch_item(start, end, &item)) !=3D NULL) {
+		start =3D next;
=20
 		if (item.format !=3D HID_ITEM_FORMAT_SHORT) {
 			hid_err(device, "unexpected long global item\n");
@@ -993,7 +995,8 @@ int hid_open_report(struct hid_device *device)
 		}
 	}
=20
-	hid_err(device, "item fetching failed at offset %d\n", (int)(end - start)=
);
+	hid_err(device, "item fetching failed at offset %u/%u\n",
+		size - (unsigned int)(end - start), size);
 err:
 	vfree(parser);
 	hid_close_report(device);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index dbe56b1b8302..895d4c776cb5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1549,9 +1549,10 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_i=
d,
 		conn_id->cm_id.iw =3D NULL;
 		cma_exch(conn_id, RDMA_CM_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
+		mutex_unlock(&listen_id->handler_mutex);
 		cma_deref_id(conn_id);
 		rdma_destroy_id(&conn_id->id);
-		goto out;
+		return ret;
 	}
=20
 	mutex_unlock(&conn_id->handler_mutex);
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/s=
tkwebcam/stk-webcam.c
index be77482c3070..a99d64d17f4d 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -644,8 +644,7 @@ static int v4l_stk_release(struct file *fp)
 		dev->owner =3D NULL;
 	}
=20
-	if (is_present(dev))
-		usb_autopm_put_interface(dev->interface);
+	usb_autopm_put_interface(dev->interface);
 	mutex_unlock(&dev->lock);
 	return v4l2_fh_release(fp);
 }
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb3=
8x_ms.c
index aeabaa5aedf7..a0efd89bbfec 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -947,7 +947,7 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 	if (!cnt) {
 		rc =3D -ENODEV;
 		pci_dev_busy =3D 1;
-		goto err_out;
+		goto err_out_int;
 	}
=20
 	jm =3D kzalloc(sizeof(struct jmb38x_ms)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 89a15afa2e7a..98f9fd6e37b6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1645,7 +1645,8 @@ int bond_enslave(struct net_device *bond_dev, struct =
net_device *slave_dev)
 	slave_disable_netpoll(new_slave);
=20
 err_close:
-	slave_dev->priv_flags &=3D ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &=3D ~IFF_BONDING;
 	dev_close(slave_dev);
=20
 err_restore_mac:
@@ -1858,7 +1859,8 @@ static int __bond_release_one(struct net_device *bond=
_dev,
=20
 	dev_set_mtu(slave_dev, slave->original_mtu);
=20
-	slave_dev->priv_flags &=3D ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &=3D ~IFF_BONDING;
=20
 	bond_free_slave(slave);
=20
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 055457619c1e..5c3af0033067 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -96,6 +96,9 @@
 #define BTR_TSEG2_SHIFT		12
 #define BTR_TSEG2_MASK		(0x7 << BTR_TSEG2_SHIFT)
=20
+/* interrupt register */
+#define INT_STS_PENDING		0x8000
+
 /* brp extension register */
 #define BRP_EXT_BRPE_MASK	0x0f
 #define BRP_EXT_BRPE_SHIFT	0
@@ -1021,10 +1024,16 @@ static int c_can_poll(struct napi_struct *napi, int=
 quota)
 	u16 curr, last =3D priv->last_status;
 	int work_done =3D 0;
=20
-	priv->last_status =3D curr =3D priv->read_reg(priv, C_CAN_STS_REG);
-	/* Ack status on C_CAN. D_CAN is self clearing */
-	if (priv->type !=3D BOSCH_D_CAN)
-		priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	/* Only read the status register if a status interrupt was pending */
+	if (atomic_xchg(&priv->sie_pending, 0)) {
+		priv->last_status =3D curr =3D priv->read_reg(priv, C_CAN_STS_REG);
+		/* Ack status on C_CAN. D_CAN is self clearing */
+		if (priv->type !=3D BOSCH_D_CAN)
+			priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	} else {
+		/* no change detected ... */
+		curr =3D last;
+	}
=20
 	/* handle state changes */
 	if ((curr & STATUS_EWARN) && (!(last & STATUS_EWARN))) {
@@ -1075,10 +1084,16 @@ static irqreturn_t c_can_isr(int irq, void *dev_id)
 {
 	struct net_device *dev =3D (struct net_device *)dev_id;
 	struct c_can_priv *priv =3D netdev_priv(dev);
+	int reg_int;
=20
-	if (!priv->read_reg(priv, C_CAN_INT_REG))
+	reg_int =3D priv->read_reg(priv, C_CAN_INT_REG);
+	if (!reg_int)
 		return IRQ_NONE;
=20
+	/* save for later use */
+	if (reg_int & INT_STS_PENDING)
+		atomic_set(&priv->sie_pending, 1);
+
 	/* disable all interrupts and schedule the NAPI */
 	c_can_irq_control(priv, false);
 	napi_schedule(&priv->napi);
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 99ad1aa576b0..d434cee11479 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -176,6 +176,7 @@ struct c_can_priv {
 	struct net_device *dev;
 	struct device *device;
 	atomic_t tx_active;
+	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
 	u16 (*read_reg) (const struct c_can_priv *priv, enum reg index);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/=
peak_usb/pcan_usb.c
index 925ab8ec9329..fcf3e1bdbb10 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -108,7 +108,7 @@ struct pcan_usb_msg_context {
 	u8 *end;
 	u8 rec_cnt;
 	u8 rec_idx;
-	u8 rec_data_idx;
+	u8 rec_ts_idx;
 	struct net_device *netdev;
 	struct pcan_usb *pdev;
 };
@@ -551,10 +551,15 @@ static int pcan_usb_decode_status(struct pcan_usb_msg=
_context *mc,
 	mc->ptr +=3D PCAN_USB_CMD_ARGS;
=20
 	if (status_len & PCAN_USB_STATUSLEN_TIMESTAMP) {
-		int err =3D pcan_usb_decode_ts(mc, !mc->rec_idx);
+		int err =3D pcan_usb_decode_ts(mc, !mc->rec_ts_idx);
=20
 		if (err)
 			return err;
+
+		/* Next packet in the buffer will have a timestamp on a single
+		 * byte
+		 */
+		mc->rec_ts_idx++;
 	}
=20
 	switch (f) {
@@ -637,10 +642,13 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_c=
ontext *mc, u8 status_len)
=20
 	cf->can_dlc =3D get_can_dlc(rec_len);
=20
-	/* first data packet timestamp is a word */
-	if (pcan_usb_decode_ts(mc, !mc->rec_data_idx))
+	/* Only first packet timestamp is a word */
+	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
=20
+	/* Next packet in the buffer will have a timestamp on a single byte */
+	mc->rec_ts_idx++;
+
 	/* read data */
 	memset(cf->data, 0x0, sizeof(cf->data));
 	if (status_len & PCAN_USB_STATUSLEN_RTR) {
@@ -695,7 +703,6 @@ static int pcan_usb_decode_msg(struct peak_usb_device *=
dev, u8 *ibuf, u32 lbuf)
 		/* handle normal can frames here */
 		} else {
 			err =3D pcan_usb_decode_data(&mc, sl);
-			mc.rec_data_idx++;
 		}
 	}
=20
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 478c1095aec0..fbca1bd0fc7b 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -1013,9 +1013,8 @@ static void usb_8dev_disconnect(struct usb_interface =
*intf)
 		netdev_info(priv->netdev, "device disconnected\n");
=20
 		unregister_netdev(priv->netdev);
-		free_candev(priv->netdev);
-
 		unlink_all_urbs(priv);
+		free_candev(priv->netdev);
 	}
=20
 }
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/e=
thernet/broadcom/genet/bcmgenet.c
index a78ea5da5883..546ad44d9a46 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1558,11 +1558,13 @@ static void init_umac(struct bcmgenet_priv *priv)
 	dev_dbg(kdev, "%s:Enabling RXDMA_BDONE interrupt\n", __func__);
=20
 	/* Monitor cable plug/unpluged event for internal PHY */
-	if (phy_is_internal(priv->phydev))
+	if (phy_is_internal(priv->phydev)) {
 		cpu_mask_clear |=3D (UMAC_IRQ_LINK_DOWN | UMAC_IRQ_LINK_UP);
-	else if (priv->ext_phy)
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			cpu_mask_clear |=3D UMAC_IRQ_PHY_DET_R;
+	} else if (priv->ext_phy) {
 		cpu_mask_clear |=3D (UMAC_IRQ_LINK_DOWN | UMAC_IRQ_LINK_UP);
-	else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MOCA) {
+	} else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MOCA) {
 		reg =3D bcmgenet_bp_mc_get(priv);
 		reg |=3D BIT(priv->hw_params->bp_in_en_shift);
=20
@@ -1861,11 +1863,16 @@ static void bcmgenet_irq_task(struct work_struct *w=
ork)
 	priv->irq0_stat =3D 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
=20
+	if (status & UMAC_IRQ_PHY_DET_R &&
+	    priv->dev->phydev->autoneg !=3D AUTONEG_ENABLE)
+		phy_init_hw(priv->dev->phydev);
+
 	/* Link UP/DOWN event */
 	if ((priv->hw_params->flags & GENET_HAS_MDIO_INTR) &&
 		(status & (UMAC_IRQ_LINK_UP|UMAC_IRQ_LINK_DOWN)))
 		phy_mac_interrupt(priv->phydev,
 			status & UMAC_IRQ_LINK_UP);
+
 }
=20
 /* bcmgenet_isr1: interrupt handler for ring buffer. */
@@ -1934,7 +1941,7 @@ static irqreturn_t bcmgenet_isr0(int irq, void *dev_i=
d)
 	}
=20
 	/* all other interested interrupts handled in bottom half */
-	status &=3D UMAC_IRQ_LINK_UP | UMAC_IRQ_LINK_DOWN;
+	status &=3D (UMAC_IRQ_LINK_UP | UMAC_IRQ_LINK_DOWN | UMAC_IRQ_PHY_DET_R);
 	if (status) {
 		/* Save irq status for bottom-half processing. */
 		spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/e=
thernet/broadcom/genet/bcmgenet.h
index 2e1e2180690f..80ff1b2ed555 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -335,6 +335,7 @@ struct bcmgenet_mib_counters {
 #define  EXT_ENERGY_DET_MASK		(1 << 12)
=20
 #define EXT_RGMII_OOB_CTRL		0x0C
+#define  RGMII_MODE_EN_V123		(1 << 0)
 #define  RGMII_LINK			(1 << 4)
 #define  OOB_DISABLE			(1 << 5)
 #define  RGMII_MODE_EN			(1 << 6)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/eth=
ernet/broadcom/genet/bcmmii.c
index da62cc910fb7..8178f69b1ced 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -280,7 +280,11 @@ int bcmgenet_mii_config(struct net_device *dev)
 		else
 			phy_name =3D "external RGMII (TX delay)";
 		reg =3D bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-		reg |=3D RGMII_MODE_EN | id_mode_dis;
+		reg |=3D id_mode_dis;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			reg |=3D RGMII_MODE_EN_V123;
+		else
+			reg |=3D RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 		bcmgenet_sys_writel(priv,
 				PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 6b861e3de4b0..ecfe03412dfa 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1310,7 +1310,8 @@ void efx_ptp_remove(struct efx_nic *efx)
 	(void)efx_ptp_disable(efx);
=20
 	cancel_work_sync(&efx->ptp_data->work);
-	cancel_work_sync(&efx->ptp_data->pps_work);
+	if (efx->ptp_data->pps_workwq)
+		cancel_work_sync(&efx->ptp_data->pps_work);
=20
 	skb_queue_purge(&efx->ptp_data->rxq);
 	skb_queue_purge(&efx->ptp_data->txq);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index 93557ec619d7..60d78a8c141c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -539,6 +539,7 @@ static int stmmac_hwtstamp_ioctl(struct net_device *dev=
, struct ifreq *ifr)
 			ptp_v2 =3D PTP_TCR_TSVER2ENA;
 			/* take time stamp for all event messages */
 			snap_type_sel =3D PTP_TCR_SNAPTYPSEL_1;
+			ts_event_en =3D PTP_TCR_TSEVNTENA;
=20
 			ptp_over_ipv4_udp =3D PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp =3D PTP_TCR_TSIPV6ENA;
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 51678e393793..60dcb51bd560 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -306,6 +306,7 @@ static struct phy_driver bcm7xxx_driver[] =3D {
 	.features	=3D PHY_GBIT_FEATURES |
 			  SUPPORTED_Pause | SUPPORTED_Asym_Pause,
 	.flags		=3D PHY_IS_INTERNAL,
+	.soft_reset	=3D genphy_soft_reset,
 	.config_init	=3D bcm7xxx_config_init,
 	.config_aneg	=3D genphy_config_aneg,
 	.read_status	=3D genphy_read_status,
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 142fada0b1e8..308096204589 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2637,14 +2637,18 @@ static struct hso_device *hso_create_bulk_serial_de=
vice(
 		 */
 		if (serial->tiocmget) {
 			tiocmget =3D serial->tiocmget;
+			tiocmget->endp =3D hso_get_ep(interface,
+						    USB_ENDPOINT_XFER_INT,
+						    USB_DIR_IN);
+			if (!tiocmget->endp) {
+				dev_err(&interface->dev, "Failed to find INT IN ep\n");
+				goto exit;
+			}
+
 			tiocmget->urb =3D usb_alloc_urb(0, GFP_KERNEL);
 			if (tiocmget->urb) {
 				mutex_init(&tiocmget->mutex);
 				init_waitqueue_head(&tiocmget->waitq);
-				tiocmget->endp =3D hso_get_ep(
-					interface,
-					USB_ENDPOINT_XFER_INT,
-					USB_DIR_IN);
 			} else
 				hso_free_tiomget(serial);
 		}
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/=
interface.c
index 9e97c7ca0ddd..bfbc5bf773a5 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -616,7 +616,6 @@ int xenvif_connect(struct xenvif_queue *queue, unsigned=
 long tx_ring_ref,
 err_unmap:
 	xenvif_unmap_frontend_rings(queue);
 err:
-	module_put(THIS_MODULE);
 	return err;
 }
=20
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0d40f2e7e1fa..1cc7c59c3831 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -656,19 +656,6 @@ void pci_update_current_state(struct pci_dev *dev, pci=
_power_t state)
 	}
 }
=20
-/**
- * pci_power_up - Put the given device into D0 forcibly
- * @dev: PCI device to power up
- */
-void pci_power_up(struct pci_dev *dev)
-{
-	if (platform_pci_power_manageable(dev))
-		platform_pci_set_power_state(dev, PCI_D0);
-
-	pci_raw_set_power_state(dev, PCI_D0);
-	pci_update_current_state(dev, PCI_D0);
-}
-
 /**
  * pci_platform_power_transition - Use platform to change device power sta=
te
  * @dev: PCI device to handle.
@@ -844,6 +831,17 @@ int pci_set_power_state(struct pci_dev *dev, pci_power=
_t state)
 }
 EXPORT_SYMBOL(pci_set_power_state);
=20
+/**
+ * pci_power_up - Put the given device into D0 forcibly
+ * @dev: PCI device to power up
+ */
+void pci_power_up(struct pci_dev *dev)
+{
+	__pci_start_power_transition(dev, PCI_D0);
+	pci_raw_set_power_state(dev, PCI_D0);
+	pci_update_current_state(dev, PCI_D0);
+}
+
 /**
  * pci_choose_state - Choose the power state of a PCI device
  * @dev: PCI device to be suspended
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 196c81435507..3b80100bba58 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -20,6 +20,11 @@
=20
 struct kmem_cache *zfcp_fsf_qtcb_cache;
=20
+static bool ber_stop =3D true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count =
in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter =3D (struct zfcp_adapter *) data;
@@ -231,10 +236,15 @@ static void zfcp_fsf_status_read_handler(struct zfcp_=
fsf_req *req)
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The error threshold for checksum statistics "
-			 "has been exceeded\n");
 		zfcp_dbf_hba_bit_err("fssrh_3", req);
+		if (ber_stop) {
+			dev_warn(&adapter->ccw_device->dev,
+				 "All paths over this FCP device are disused because of excessive bit =
errors\n");
+			zfcp_erp_adapter_shutdown(adapter, 0, "fssrh_b");
+		} else {
+			dev_warn(&adapter->ccw_device->dev,
+				 "The error threshold for checksum statistics has been exceeded\n");
+		}
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_np=
ortdisc.c
index c342f6afd747..c68d3896e092 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -742,9 +742,9 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lp=
fc_nodelist *ndlp)
=20
 	if (!(vport->fc_flag & FC_PT2PT)) {
 		/* Check config parameter use-adisc or FCP-2 */
-		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
+		if (vport->cfg_use_adisc && ((vport->fc_flag & FC_RSCN_MODE) ||
 		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
-		     (ndlp->nlp_type & NLP_FCP_TARGET))) {
+		     (ndlp->nlp_type & NLP_FCP_TARGET)))) {
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |=3D NLP_NPR_ADISC;
 			spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 86ab0b1a3e16..7896cf4c3229 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3006,6 +3006,10 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	/* Stop currently executing firmware. */
 	qla2x00_try_to_stop_firmware(vha);
=20
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
 	/* Turn adapter off line */
 	vha->flags.online =3D 0;
=20
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f26efaf3e7f1..f7a9fd501749 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -652,6 +652,14 @@ sdev_store_delete(struct device *dev, struct device_at=
tribute *attr,
 		  const char *buf, size_t count)
 {
 	struct kernfs_node *kn;
+	struct scsi_device *sdev =3D to_scsi_device(dev);
+
+	/*
+	 * We need to try to get module, avoiding the module been removed
+	 * during delete.
+	 */
+	if (scsi_device_get(sdev))
+		return -ENODEV;
=20
 	kn =3D sysfs_break_active_protection(&dev->kobj, &attr->attr);
 	WARN_ON_ONCE(!kn);
@@ -666,9 +674,10 @@ sdev_store_delete(struct device *dev, struct device_at=
tribute *attr,
 	 * state into SDEV_DEL.
 	 */
 	device_remove_file(dev, attr);
-	scsi_remove_device(to_scsi_device(dev));
+	scsi_remove_device(sdev);
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	scsi_device_put(sdev);
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 228d8250e452..2fcda75ef688 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1470,7 +1470,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
 			(sshdr.asc =3D=3D 0x3a ||	/* medium not present */
-			 sshdr.asc =3D=3D 0x20))	/* invalid command */
+			 sshdr.asc =3D=3D 0x20 ||	/* invalid command */
+			 (sshdr.asc =3D=3D 0x74 && sshdr.ascq =3D=3D 0x71)))	/* drive is passwo=
rd locked */
 				/* this is no error here */
 				return 0;
=20
diff --git a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c b/drivers=
/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
index dea220b507ad..e9b82222fd4d 100644
--- a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
+++ b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
@@ -403,7 +403,7 @@ static int odm_ARFBRefresh_8188E(struct odm_dm_struct *=
dm_odm, struct odm_ra_inf
 			pRaInfo->PTModeSS =3D 3;
 		else if (pRaInfo->HighestRate > 0x0b)
 			pRaInfo->PTModeSS =3D 2;
-		else if (pRaInfo->HighestRate > 0x0b)
+		else if (pRaInfo->HighestRate > 0x03)
 			pRaInfo->PTModeSS =3D 1;
 		else
 			pRaInfo->PTModeSS =3D 0;
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index aade351c3192..107734b30303 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -708,7 +708,8 @@ static int __init ulite_init(void)
 static void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	uart_unregister_driver(&ulite_uart_driver);
+	if (ulite_uart_driver.state)
+		uart_unregister_driver(&ulite_uart_driver);
 }
=20
 module_init(ulite_init);
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index b9adc2ec49dd..1db3ab4b846e 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -447,6 +447,7 @@ static void usblp_cleanup(struct usblp *usblp)
 	kfree(usblp->readbuf);
 	kfree(usblp->device_id_string);
 	kfree(usblp->statusbuf);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 }
=20
@@ -463,10 +464,12 @@ static int usblp_release(struct inode *inode, struct =
file *file)
=20
 	mutex_lock(&usblp_mutex);
 	usblp->used =3D 0;
-	if (usblp->present) {
+	if (usblp->present)
 		usblp_unlink_urbs(usblp);
-		usb_autopm_put_interface(usblp->intf);
-	} else		/* finish cleanup from disconnect */
+
+	usb_autopm_put_interface(usblp->intf);
+
+	if (!usblp->present)		/* finish cleanup from disconnect */
 		usblp_cleanup(usblp);
 	mutex_unlock(&usblp_mutex);
 	return 0;
@@ -1102,7 +1105,7 @@ static int usblp_probe(struct usb_interface *intf,
 	init_waitqueue_head(&usblp->wwait);
 	init_usb_anchor(&usblp->urbs);
 	usblp->ifnum =3D intf->cur_altsetting->desc.bInterfaceNumber;
-	usblp->intf =3D intf;
+	usblp->intf =3D usb_get_intf(intf);
=20
 	/* Malloc device ID string buffer to the largest expected length,
 	 * since we can re-query it on an ioctl and a dynamic string
@@ -1191,6 +1194,7 @@ static int usblp_probe(struct usb_interface *intf,
 	kfree(usblp->readbuf);
 	kfree(usblp->statusbuf);
 	kfree(usblp->device_id_string);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 abort_ret:
 	return retval;
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel=
_usba_udc.c
index 892bd9765f3b..6187cfdd920a 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -392,9 +392,11 @@ static void submit_request(struct usba_ep *ep, struct =
usba_request *req)
 		next_fifo_transaction(ep, req);
 		if (req->last_transaction) {
 			usba_ep_writel(ep, CTL_DIS, USBA_TX_PK_RDY);
-			usba_ep_writel(ep, CTL_ENB, USBA_TX_COMPLETE);
+			if (ep_is_control(ep))
+				usba_ep_writel(ep, CTL_ENB, USBA_TX_COMPLETE);
 		} else {
-			usba_ep_writel(ep, CTL_DIS, USBA_TX_COMPLETE);
+			if (ep_is_control(ep))
+				usba_ep_writel(ep, CTL_DIS, USBA_TX_COMPLETE);
 			usba_ep_writel(ep, CTL_ENB, USBA_TX_PK_RDY);
 		}
 	}
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 8c73186fc0e8..83883f88d64c 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -50,6 +50,7 @@
 #define DRIVER_VERSION	"02 May 2005"
=20
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
+#define POWER_BUDGET_3	900	/* in mA */
=20
 static const char	driver_name[] =3D "dummy_hcd";
 static const char	driver_desc[] =3D "USB Host+Gadget Emulator";
@@ -2359,7 +2360,7 @@ static int dummy_start_ss(struct dummy_hcd *dum_hcd)
 	dum_hcd->rh_state =3D DUMMY_RH_RUNNING;
 	dum_hcd->stream_en_ep =3D 0;
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
-	dummy_hcd_to_hcd(dum_hcd)->power_budget =3D POWER_BUDGET;
+	dummy_hcd_to_hcd(dum_hcd)->power_budget =3D POWER_BUDGET_3;
 	dummy_hcd_to_hcd(dum_hcd)->state =3D HC_STATE_RUNNING;
 	dummy_hcd_to_hcd(dum_hcd)->uses_new_polling =3D 1;
 #ifdef CONFIG_USB_OTG
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_=
udc.c
index e471580a2a3b..1fac99f9f614 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -1228,11 +1228,11 @@ static void udc_pop_fifo(struct lpc32xx_udc *udc, u=
8 *data, u32 bytes)
 			tmp =3D readl(USBD_RXDATA(udc->udp_baseaddr));
=20
 			bl =3D bytes - n;
-			if (bl > 3)
-				bl =3D 3;
+			if (bl > 4)
+				bl =3D 4;
=20
 			for (i =3D 0; i < bl; i++)
-				data[n + i] =3D (u8) ((tmp >> (n * 8)) & 0xFF);
+				data[n + i] =3D (u8) ((tmp >> (i * 8)) & 0xFF);
 		}
 		break;
=20
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c8abf2cfe088..6db935e820ff 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1029,6 +1029,18 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernat=
ed)
 		hibernated =3D true;
=20
 	if (!hibernated) {
+		/*
+		 * Some controllers might lose power during suspend, so wait
+		 * for controller not ready bit to clear, just as in xHC init.
+		 */
+		retval =3D xhci_handshake(xhci, &xhci->op_regs->status,
+					STS_CNR, 0, 10 * 1000 * 1000);
+		if (retval) {
+			xhci_warn(xhci, "Controller not ready at resume %d\n",
+				  retval);
+			spin_unlock_irq(&xhci->lock);
+			return retval;
+		}
 		/* step 1: restore register */
 		xhci_restore_registers(xhci);
 		/* step 2: initialize command ring buffer */
@@ -4503,12 +4515,12 @@ static int xhci_update_timeout_for_endpoint(struct =
xhci_hcd *xhci,
 	alt_timeout =3D xhci_call_host_update_timeout_for_endpoint(xhci, udev,
 		desc, state, timeout);
=20
-	/* If we found we can't enable hub-initiated LPM, or
+	/* If we found we can't enable hub-initiated LPM, and
 	 * the U1 or U2 exit latency was too high to allow
-	 * device-initiated LPM as well, just stop searching.
+	 * device-initiated LPM as well, then we will disable LPM
+	 * for this device, so stop searching any further.
 	 */
-	if (alt_timeout =3D=3D USB3_LPM_DISABLED ||
-			alt_timeout =3D=3D USB3_LPM_DEVICE_INITIATED) {
+	if (alt_timeout =3D=3D USB3_LPM_DISABLED) {
 		*timeout =3D alt_timeout;
 		return -E2BIG;
 	}
@@ -4618,10 +4630,12 @@ static u16 xhci_calculate_lpm_timeout(struct usb_hc=
d *hcd,
 		if (intf->dev.driver) {
 			driver =3D to_usb_driver(intf->dev.driver);
 			if (driver && driver->disable_hub_initiated_lpm) {
-				dev_dbg(&udev->dev, "Hub-initiated %s disabled "
-						"at request of driver %s\n",
-						state_name, driver->name);
-				return xhci_get_timeout_no_hub_lpm(udev, state);
+				dev_dbg(&udev->dev, "Hub-initiated %s disabled at request of driver %s=
\n",
+					state_name, driver->name);
+				timeout =3D xhci_get_timeout_no_hub_lpm(udev,
+								      state);
+				if (timeout =3D=3D USB3_LPM_DISABLED)
+					return timeout;
 			}
 		}
=20
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 37b44b04a701..65e7ab35cf07 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -727,6 +727,10 @@ static int mts_usb_probe(struct usb_interface *intf,
=20
 	}
=20
+	if (ep_in_current !=3D &ep_in_set[2]) {
+		MTS_WARNING("couldn't find two input bulk endpoints. Bailing out.\n");
+		return -ENODEV;
+	}
=20
 	if ( ep_out =3D=3D -1 ) {
 		MTS_WARNING( "couldn't find an output bulk endpoint. Bailing out.\n" );
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 1bca274dc3b5..6f5588cbb892 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -46,16 +46,6 @@ config USB_SEVSEG
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbsevseg.
=20
-config USB_RIO500
-	tristate "USB Diamond Rio500 support"
-	help
-	  Say Y here if you want to connect a USB Rio500 mp3 player to your
-	  computer's USB port. Please read <file:Documentation/usb/rio.txt>
-	  for more information.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rio500.
-
 config USB_LEGOTOWER
 	tristate "USB Lego Infrared Tower support"
 	help
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index e748fd5dbe94..64476efd12f3 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_USB_LCD)			+=3D usblcd.o
 obj-$(CONFIG_USB_LD)			+=3D ldusb.o
 obj-$(CONFIG_USB_LED)			+=3D usbled.o
 obj-$(CONFIG_USB_LEGOTOWER)		+=3D legousbtower.o
-obj-$(CONFIG_USB_RIO500)		+=3D rio500.o
 obj-$(CONFIG_USB_TEST)			+=3D usbtest.o
 obj-$(CONFIG_USB_EHSET_TEST_FIXTURE)    +=3D ehset.o
 obj-$(CONFIG_USB_TRANCEVIBRATOR)	+=3D trancevibrator.o
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 065db5f4b62b..684ce2ad1a39 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -80,6 +80,7 @@ struct adu_device {
 	char			serial_number[8];
=20
 	int			open_count; /* number of times this port has been opened */
+	unsigned long		disconnected:1;
=20
 	char		*read_buffer_primary;
 	int			read_buffer_length;
@@ -121,7 +122,7 @@ static void adu_abort_transfers(struct adu_device *dev)
 {
 	unsigned long flags;
=20
-	if (dev->udev =3D=3D NULL)
+	if (dev->disconnected)
 		return;
=20
 	/* shutdown transfer */
@@ -151,6 +152,7 @@ static void adu_delete(struct adu_device *dev)
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
=20
@@ -244,7 +246,7 @@ static int adu_open(struct inode *inode, struct file *f=
ile)
 	}
=20
 	dev =3D usb_get_intfdata(interface);
-	if (!dev || !dev->udev) {
+	if (!dev) {
 		retval =3D -ENODEV;
 		goto exit_no_device;
 	}
@@ -327,7 +329,7 @@ static int adu_release(struct inode *inode, struct file=
 *file)
 	}
=20
 	adu_release_internal(dev);
-	if (dev->udev =3D=3D NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		if (!dev->open_count)	/* ... and we're the last user */
 			adu_delete(dev);
@@ -356,7 +358,7 @@ static ssize_t adu_read(struct file *file, __user char =
*buffer, size_t count,
 		return -ERESTARTSYS;
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->udev =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -521,7 +523,7 @@ static ssize_t adu_write(struct file *file, const __use=
r char *buffer,
 		goto exit_nolock;
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->udev =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -676,7 +678,7 @@ static int adu_probe(struct usb_interface *interface,
=20
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev =3D udev;
+	dev->udev =3D usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
=20
@@ -801,11 +803,14 @@ static void adu_disconnect(struct usb_interface *inte=
rface)
=20
 	usb_deregister_dev(interface, &adu_class);
=20
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
=20
 	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev =3D NULL;	/* poison */
+	dev->disconnected =3D 1;
 	mutex_unlock(&dev->mtx);
=20
 	/* if the device is not opened, then we clean up right now */
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 4af9279f2cf0..83342e579233 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -89,6 +89,7 @@ struct iowarrior {
 	char chip_serial[9];		/* the serial number string of the chip connected */
 	int report_size;		/* number of bytes in a report */
 	u16 product_id;
+	struct usb_anchor submitted;
 };
=20
 /*--------------*/
@@ -248,6 +249,7 @@ static inline void iowarrior_delete(struct iowarrior *d=
ev)
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
+	usb_put_intf(dev->interface);
 	kfree(dev);
 }
=20
@@ -436,11 +438,13 @@ static ssize_t iowarrior_write(struct file *file,
 			retval =3D -EFAULT;
 			goto error;
 		}
+		usb_anchor_urb(int_out_urb, &dev->submitted);
 		retval =3D usb_submit_urb(int_out_urb, GFP_KERNEL);
 		if (retval) {
 			dev_dbg(&dev->interface->dev,
 				"submit error %d for urb nr.%d\n",
 				retval, atomic_read(&dev->write_busy));
+			usb_unanchor_urb(int_out_urb);
 			goto error;
 		}
 		/* submit was ok */
@@ -782,11 +786,13 @@ static int iowarrior_probe(struct usb_interface *inte=
rface,
 	init_waitqueue_head(&dev->write_wait);
=20
 	dev->udev =3D udev;
-	dev->interface =3D interface;
+	dev->interface =3D usb_get_intf(interface);
=20
 	iface_desc =3D interface->cur_altsetting;
 	dev->product_id =3D le16_to_cpu(udev->descriptor.idProduct);
=20
+	init_usb_anchor(&dev->submitted);
+
 	/* set up the endpoint information */
 	for (i =3D 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint =3D &iface_desc->endpoint[i].desc;
@@ -916,6 +922,7 @@ static void iowarrior_disconnect(struct usb_interface *=
interface)
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
+		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);
diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 2bbca7d674d6..30babba76883 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -168,6 +168,7 @@ MODULE_PARM_DESC(min_interrupt_out_interval, "Minimum i=
nterrupt out interval in
 struct ld_usb {
 	struct mutex		mutex;		/* locks this structure */
 	struct usb_interface*	intf;		/* save off the usb interface pointer */
+	unsigned long		disconnected:1;
=20
 	int			open_count;	/* number of times this port has been opened */
=20
@@ -207,12 +208,10 @@ static void ld_usb_abort_transfers(struct ld_usb *dev)
 	/* shutdown transfer */
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running =3D 0;
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
 	if (dev->interrupt_out_busy)
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_out_urb);
+		usb_kill_urb(dev->interrupt_out_urb);
 }
=20
 /**
@@ -220,8 +219,6 @@ static void ld_usb_abort_transfers(struct ld_usb *dev)
  */
 static void ld_usb_delete(struct ld_usb *dev)
 {
-	ld_usb_abort_transfers(dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -277,7 +274,7 @@ static void ld_usb_interrupt_in_callback(struct urb *ur=
b)
=20
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && !dev->buffer_overflow && dev->intf) {
+	if (dev->interrupt_in_running && !dev->buffer_overflow) {
 		retval =3D usb_submit_urb(dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval) {
 			dev_err(&dev->intf->dev,
@@ -397,16 +394,13 @@ static int ld_usb_release(struct inode *inode, struct=
 file *file)
 		goto exit;
 	}
=20
-	if (mutex_lock_interruptible(&dev->mutex)) {
-		retval =3D -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->mutex);
=20
 	if (dev->open_count !=3D 1) {
 		retval =3D -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->intf =3D=3D NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		mutex_unlock(&dev->mutex);
 		/* unlock here as ld_usb_delete frees dev */
@@ -437,7 +431,7 @@ static unsigned int ld_usb_poll(struct file *file, poll=
_table *wait)
=20
 	dev =3D file->private_data;
=20
-	if (!dev->intf)
+	if (dev->disconnected)
 		return POLLERR | POLLHUP;
=20
 	poll_wait(file, &dev->read_wait, wait);
@@ -476,7 +470,7 @@ static ssize_t ld_usb_read(struct file *file, char __us=
er *buffer, size_t count,
 	}
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->intf =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -484,7 +478,7 @@ static ssize_t ld_usb_read(struct file *file, char __us=
er *buffer, size_t count,
=20
 	/* wait for data */
 	spin_lock_irq(&dev->rbsl);
-	if (dev->ring_head =3D=3D dev->ring_tail) {
+	while (dev->ring_head =3D=3D dev->ring_tail) {
 		dev->interrupt_in_done =3D 0;
 		spin_unlock_irq(&dev->rbsl);
 		if (file->f_flags & O_NONBLOCK) {
@@ -494,12 +488,17 @@ static ssize_t ld_usb_read(struct file *file, char __=
user *buffer, size_t count,
 		retval =3D wait_event_interruptible(dev->read_wait, dev->interrupt_in_do=
ne);
 		if (retval < 0)
 			goto unlock_exit;
-	} else {
-		spin_unlock_irq(&dev->rbsl);
+
+		spin_lock_irq(&dev->rbsl);
 	}
+	spin_unlock_irq(&dev->rbsl);
=20
 	/* actual_buffer contains actual_length + interrupt_in_buffer */
 	actual_buffer =3D (size_t*)(dev->ring_buffer + dev->ring_tail*(sizeof(siz=
e_t)+dev->interrupt_in_endpoint_size));
+	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
+		retval =3D -EIO;
+		goto unlock_exit;
+	}
 	bytes_to_read =3D min(count, *actual_buffer);
 	if (bytes_to_read < *actual_buffer)
 		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
@@ -510,11 +509,11 @@ static ssize_t ld_usb_read(struct file *file, char __=
user *buffer, size_t count,
 		retval =3D -EFAULT;
 		goto unlock_exit;
 	}
-	dev->ring_tail =3D (dev->ring_tail+1) % ring_buffer_size;
-
 	retval =3D bytes_to_read;
=20
 	spin_lock_irq(&dev->rbsl);
+	dev->ring_tail =3D (dev->ring_tail + 1) % ring_buffer_size;
+
 	if (dev->buffer_overflow) {
 		dev->buffer_overflow =3D 0;
 		spin_unlock_irq(&dev->rbsl);
@@ -556,7 +555,7 @@ static ssize_t ld_usb_write(struct file *file, const ch=
ar __user *buffer,
 	}
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->intf =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -595,7 +594,7 @@ static ssize_t ld_usb_write(struct file *file, const ch=
ar __user *buffer,
 					 1 << 8, 0,
 					 dev->interrupt_out_buffer,
 					 bytes_to_write,
-					 USB_CTRL_SET_TIMEOUT * HZ);
+					 USB_CTRL_SET_TIMEOUT);
 		if (retval < 0)
 			dev_err(&dev->intf->dev,
 				"Couldn't submit HID_REQ_SET_REPORT %d\n",
@@ -719,7 +718,9 @@ static int ld_usb_probe(struct usb_interface *intf, con=
st struct usb_device_id *
 		dev_warn(&intf->dev, "Interrupt out endpoint not found (using control en=
dpoint instead)\n");
=20
 	dev->interrupt_in_endpoint_size =3D usb_endpoint_maxp(dev->interrupt_in_e=
ndpoint);
-	dev->ring_buffer =3D kmalloc(ring_buffer_size*(sizeof(size_t)+dev->interr=
upt_in_endpoint_size), GFP_KERNEL);
+	dev->ring_buffer =3D kcalloc(ring_buffer_size,
+			sizeof(size_t) + dev->interrupt_in_endpoint_size,
+			GFP_KERNEL);
 	if (!dev->ring_buffer) {
 		dev_err(&intf->dev, "Couldn't allocate ring_buffer\n");
 		goto error;
@@ -792,6 +793,9 @@ static void ld_usb_disconnect(struct usb_interface *int=
f)
 	/* give back our minor */
 	usb_deregister_dev(intf, &ld_usb_class);
=20
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->mutex);
=20
 	/* if the device is not opened, then we clean up right now */
@@ -799,7 +803,7 @@ static void ld_usb_disconnect(struct usb_interface *int=
f)
 		mutex_unlock(&dev->mutex);
 		ld_usb_delete(dev);
 	} else {
-		dev->intf =3D NULL;
+		dev->disconnected =3D 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtowe=
r.c
index 0f9b094343f5..4f2c31ef9cbd 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -185,7 +185,6 @@ static const struct usb_device_id tower_table[] =3D {
 };
=20
 MODULE_DEVICE_TABLE (usb, tower_table);
-static DEFINE_MUTEX(open_disc_mutex);
=20
 #define LEGO_USB_TOWER_MINOR_BASE	160
=20
@@ -197,6 +196,7 @@ struct lego_usb_tower {
 	unsigned char		minor;		/* the starting minor number for this device */
=20
 	int			open_count;	/* number of times this port has been opened */
+	unsigned long		disconnected:1;
=20
 	char*			read_buffer;
 	size_t			read_buffer_length; /* this much came in */
@@ -296,14 +296,13 @@ static inline void lego_usb_tower_debug_data(struct d=
evice *dev,
  */
 static inline void tower_delete (struct lego_usb_tower *dev)
 {
-	tower_abort_transfers (dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
 	kfree (dev->read_buffer);
 	kfree (dev->interrupt_in_buffer);
 	kfree (dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree (dev);
 }
=20
@@ -338,18 +337,14 @@ static int tower_open (struct inode *inode, struct fi=
le *file)
 		goto exit;
 	}
=20
-	mutex_lock(&open_disc_mutex);
 	dev =3D usb_get_intfdata(interface);
-
 	if (!dev) {
-		mutex_unlock(&open_disc_mutex);
 		retval =3D -ENODEV;
 		goto exit;
 	}
=20
 	/* lock this device */
 	if (mutex_lock_interruptible(&dev->lock)) {
-		mutex_unlock(&open_disc_mutex);
 	        retval =3D -ERESTARTSYS;
 		goto exit;
 	}
@@ -357,12 +352,9 @@ static int tower_open (struct inode *inode, struct fil=
e *file)
=20
 	/* allow opening only once */
 	if (dev->open_count) {
-		mutex_unlock(&open_disc_mutex);
 		retval =3D -EBUSY;
 		goto unlock_exit;
 	}
-	dev->open_count =3D 1;
-	mutex_unlock(&open_disc_mutex);
=20
 	/* reset the tower */
 	result =3D usb_control_msg (dev->udev,
@@ -402,13 +394,14 @@ static int tower_open (struct inode *inode, struct fi=
le *file)
 		dev_err(&dev->udev->dev,
 			"Couldn't submit interrupt_in_urb %d\n", retval);
 		dev->interrupt_in_running =3D 0;
-		dev->open_count =3D 0;
 		goto unlock_exit;
 	}
=20
 	/* save device in the file's private structure */
 	file->private_data =3D dev;
=20
+	dev->open_count =3D 1;
+
 unlock_exit:
 	mutex_unlock(&dev->lock);
=20
@@ -429,22 +422,19 @@ static int tower_release (struct inode *inode, struct=
 file *file)
=20
 	if (dev =3D=3D NULL) {
 		retval =3D -ENODEV;
-		goto exit_nolock;
-	}
-
-	mutex_lock(&open_disc_mutex);
-	if (mutex_lock_interruptible(&dev->lock)) {
-	        retval =3D -ERESTARTSYS;
 		goto exit;
 	}
=20
+	mutex_lock(&dev->lock);
+
 	if (dev->open_count !=3D 1) {
 		dev_dbg(&dev->udev->dev, "%s: device not opened exactly once\n",
 			__func__);
 		retval =3D -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->udev =3D=3D NULL) {
+
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
=20
 		/* unlock here as tower_delete frees dev */
@@ -462,10 +452,7 @@ static int tower_release (struct inode *inode, struct =
file *file)
=20
 unlock_exit:
 	mutex_unlock(&dev->lock);
-
 exit:
-	mutex_unlock(&open_disc_mutex);
-exit_nolock:
 	return retval;
 }
=20
@@ -483,10 +470,9 @@ static void tower_abort_transfers (struct lego_usb_tow=
er *dev)
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running =3D 0;
 		mb();
-		if (dev->udev)
-			usb_kill_urb (dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
-	if (dev->interrupt_out_busy && dev->udev)
+	if (dev->interrupt_out_busy)
 		usb_kill_urb(dev->interrupt_out_urb);
 }
=20
@@ -522,7 +508,7 @@ static unsigned int tower_poll (struct file *file, poll=
_table *wait)
=20
 	dev =3D file->private_data;
=20
-	if (!dev->udev)
+	if (dev->disconnected)
 		return POLLERR | POLLHUP;
=20
 	poll_wait(file, &dev->read_wait, wait);
@@ -569,7 +555,7 @@ static ssize_t tower_read (struct file *file, char __us=
er *buffer, size_t count,
 	}
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->udev =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -655,7 +641,7 @@ static ssize_t tower_write (struct file *file, const ch=
ar __user *buffer, size_t
 	}
=20
 	/* verify that the device wasn't unplugged */
-	if (dev->udev =3D=3D NULL) {
+	if (dev->disconnected) {
 		retval =3D -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -764,7 +750,7 @@ static void tower_interrupt_in_callback (struct urb *ur=
b)
=20
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && dev->udev) {
+	if (dev->interrupt_in_running) {
 		retval =3D usb_submit_urb (dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval)
 			dev_err(&dev->udev->dev,
@@ -832,8 +818,9 @@ static int tower_probe (struct usb_interface *interface=
, const struct usb_device
=20
 	mutex_init(&dev->lock);
=20
-	dev->udev =3D udev;
+	dev->udev =3D usb_get_dev(udev);
 	dev->open_count =3D 0;
+	dev->disconnected =3D 0;
=20
 	dev->read_buffer =3D NULL;
 	dev->read_buffer_length =3D 0;
@@ -923,8 +910,10 @@ static int tower_probe (struct usb_interface *interfac=
e, const struct usb_device
 				  get_version_reply,
 				  sizeof(*get_version_reply),
 				  1000);
-	if (result < 0) {
-		dev_err(idev, "LEGO USB Tower get version control request failed\n");
+	if (result !=3D sizeof(*get_version_reply)) {
+		if (result >=3D 0)
+			result =3D -EIO;
+		dev_err(idev, "get version request failed: %d\n", result);
 		retval =3D result;
 		goto error;
 	}
@@ -942,7 +931,6 @@ static int tower_probe (struct usb_interface *interface=
, const struct usb_device
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(idev, "Not able to get a minor for this device.\n");
-		usb_set_intfdata (interface, NULL);
 		goto error;
 	}
 	dev->minor =3D interface->minor;
@@ -974,23 +962,24 @@ static void tower_disconnect (struct usb_interface *i=
nterface)
 	int minor;
=20
 	dev =3D usb_get_intfdata (interface);
-	mutex_lock(&open_disc_mutex);
-	usb_set_intfdata (interface, NULL);
=20
 	minor =3D dev->minor;
=20
-	/* give back our minor */
+	/* give back our minor and prevent further open() */
 	usb_deregister_dev (interface, &tower_class);
=20
+	/* stop I/O */
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->lock);
-	mutex_unlock(&open_disc_mutex);
=20
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count) {
 		mutex_unlock(&dev->lock);
 		tower_delete (dev);
 	} else {
-		dev->udev =3D NULL;
+		dev->disconnected =3D 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
deleted file mode 100644
index 6e761fabffca..000000000000
--- a/drivers/usb/misc/rio500.c
+++ /dev/null
@@ -1,578 +0,0 @@
-/* -*- linux-c -*- */
-
-/*=20
- * Driver for USB Rio 500
- *
- * Cesar Miquel (miquel@df.uba.ar)
- *=20
- * based on hp_scanner.c by David E. Nelson (dnelson@jump.net)
- *=20
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Based upon mouse.c (Brad Keryan) and printer.c (Michael Gee).
- *
- * Changelog:
- * 30/05/2003  replaced lock/unlock kernel with up/down
- *             Daniele Bellucci  bellucda@tiscali.it
- * */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/mutex.h>
-#include <linux/errno.h>
-#include <linux/random.h>
-#include <linux/poll.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-
-#include "rio500_usb.h"
-
-/*
- * Version Information
- */
-#define DRIVER_VERSION "v1.1"
-#define DRIVER_AUTHOR "Cesar Miquel <miquel@df.uba.ar>"
-#define DRIVER_DESC "USB Rio 500 driver"
-
-#define RIO_MINOR	64
-
-/* stall/wait timeout for rio */
-#define NAK_TIMEOUT (HZ)
-
-#define IBUF_SIZE 0x1000
-
-/* Size of the rio buffer */
-#define OBUF_SIZE 0x10000
-
-struct rio_usb_data {
-        struct usb_device *rio_dev;     /* init: probe_rio */
-        unsigned int ifnum;             /* Interface number of the USB dev=
ice */
-        int isopen;                     /* nz if open */
-        int present;                    /* Device is present on the bus */
-        char *obuf, *ibuf;              /* transfer buffers */
-        char bulk_in_ep, bulk_out_ep;   /* Endpoint assignments */
-        wait_queue_head_t wait_q;       /* for timeouts */
-	struct mutex lock;          /* general race avoidance */
-};
-
-static DEFINE_MUTEX(rio500_mutex);
-static struct rio_usb_data rio_instance;
-
-static int open_rio(struct inode *inode, struct file *file)
-{
-	struct rio_usb_data *rio =3D &rio_instance;
-
-	/* against disconnect() */
-	mutex_lock(&rio500_mutex);
-	mutex_lock(&(rio->lock));
-
-	if (rio->isopen || !rio->present) {
-		mutex_unlock(&(rio->lock));
-		mutex_unlock(&rio500_mutex);
-		return -EBUSY;
-	}
-	rio->isopen =3D 1;
-
-	init_waitqueue_head(&rio->wait_q);
-
-	mutex_unlock(&(rio->lock));
-
-	dev_info(&rio->rio_dev->dev, "Rio opened.\n");
-	mutex_unlock(&rio500_mutex);
-
-	return 0;
-}
-
-static int close_rio(struct inode *inode, struct file *file)
-{
-	struct rio_usb_data *rio =3D &rio_instance;
-
-	/* against disconnect() */
-	mutex_lock(&rio500_mutex);
-	mutex_lock(&(rio->lock));
-
-	rio->isopen =3D 0;
-	if (!rio->present) {
-		/* cleanup has been delayed */
-		kfree(rio->ibuf);
-		kfree(rio->obuf);
-		rio->ibuf =3D NULL;
-		rio->obuf =3D NULL;
-	} else {
-		dev_info(&rio->rio_dev->dev, "Rio closed.\n");
-	}
-	mutex_unlock(&(rio->lock));
-	mutex_unlock(&rio500_mutex);
-	return 0;
-}
-
-static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long a=
rg)
-{
-	struct RioCommand rio_cmd;
-	struct rio_usb_data *rio =3D &rio_instance;
-	void __user *data;
-	unsigned char *buffer;
-	int result, requesttype;
-	int retries;
-	int retval=3D0;
-
-	mutex_lock(&(rio->lock));
-        /* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present =3D=3D 0 || rio->rio_dev =3D=3D NULL) {
-		retval =3D -ENODEV;
-		goto err_out;
-	}
-
-	switch (cmd) {
-	case RIO_RECV_COMMAND:
-		data =3D (void __user *) arg;
-		if (data =3D=3D NULL)
-			break;
-		if (copy_from_user(&rio_cmd, data, sizeof(struct RioCommand))) {
-			retval =3D -EFAULT;
-			goto err_out;
-		}
-		if (rio_cmd.length < 0 || rio_cmd.length > PAGE_SIZE) {
-			retval =3D -EINVAL;
-			goto err_out;
-		}
-		buffer =3D (unsigned char *) __get_free_page(GFP_KERNEL);
-		if (buffer =3D=3D NULL) {
-			retval =3D -ENOMEM;
-			goto err_out;
-		}
-		if (copy_from_user(buffer, rio_cmd.buffer, rio_cmd.length)) {
-			retval =3D -EFAULT;
-			free_page((unsigned long) buffer);
-			goto err_out;
-		}
-
-		requesttype =3D rio_cmd.requesttype | USB_DIR_IN |
-		    USB_TYPE_VENDOR | USB_RECIP_DEVICE;
-		dev_dbg(&rio->rio_dev->dev,
-			"sending command:reqtype=3D%0x req=3D%0x value=3D%0x index=3D%0x len=3D=
%0x\n",
-			requesttype, rio_cmd.request, rio_cmd.value,
-			rio_cmd.index, rio_cmd.length);
-		/* Send rio control message */
-		retries =3D 3;
-		while (retries) {
-			result =3D usb_control_msg(rio->rio_dev,
-						 usb_rcvctrlpipe(rio-> rio_dev, 0),
-						 rio_cmd.request,
-						 requesttype,
-						 rio_cmd.value,
-						 rio_cmd.index, buffer,
-						 rio_cmd.length,
-						 jiffies_to_msecs(rio_cmd.timeout));
-			if (result =3D=3D -ETIMEDOUT)
-				retries--;
-			else if (result < 0) {
-				dev_err(&rio->rio_dev->dev,
-					"Error executing ioctrl. code =3D %d\n",
-					result);
-				retries =3D 0;
-			} else {
-				dev_dbg(&rio->rio_dev->dev,
-					"Executed ioctl. Result =3D %d (data=3D%02x)\n",
-					result, buffer[0]);
-				if (copy_to_user(rio_cmd.buffer, buffer,
-						 rio_cmd.length)) {
-					free_page((unsigned long) buffer);
-					retval =3D -EFAULT;
-					goto err_out;
-				}
-				retries =3D 0;
-			}
-
-			/* rio_cmd.buffer contains a raw stream of single byte
-			   data which has been returned from rio.  Data is
-			   interpreted at application level.  For data that
-			   will be cast to data types longer than 1 byte, data
-			   will be little_endian and will potentially need to
-			   be swapped at the app level */
-
-		}
-		free_page((unsigned long) buffer);
-		break;
-
-	case RIO_SEND_COMMAND:
-		data =3D (void __user *) arg;
-		if (data =3D=3D NULL)
-			break;
-		if (copy_from_user(&rio_cmd, data, sizeof(struct RioCommand))) {
-			retval =3D -EFAULT;
-			goto err_out;
-		}
-		if (rio_cmd.length < 0 || rio_cmd.length > PAGE_SIZE) {
-			retval =3D -EINVAL;
-			goto err_out;
-		}
-		buffer =3D (unsigned char *) __get_free_page(GFP_KERNEL);
-		if (buffer =3D=3D NULL) {
-			retval =3D -ENOMEM;
-			goto err_out;
-		}
-		if (copy_from_user(buffer, rio_cmd.buffer, rio_cmd.length)) {
-			free_page((unsigned long)buffer);
-			retval =3D -EFAULT;
-			goto err_out;
-		}
-
-		requesttype =3D rio_cmd.requesttype | USB_DIR_OUT |
-		    USB_TYPE_VENDOR | USB_RECIP_DEVICE;
-		dev_dbg(&rio->rio_dev->dev,
-			"sending command: reqtype=3D%0x req=3D%0x value=3D%0x index=3D%0x len=
=3D%0x\n",
-			requesttype, rio_cmd.request, rio_cmd.value,
-			rio_cmd.index, rio_cmd.length);
-		/* Send rio control message */
-		retries =3D 3;
-		while (retries) {
-			result =3D usb_control_msg(rio->rio_dev,
-						 usb_sndctrlpipe(rio-> rio_dev, 0),
-						 rio_cmd.request,
-						 requesttype,
-						 rio_cmd.value,
-						 rio_cmd.index, buffer,
-						 rio_cmd.length,
-						 jiffies_to_msecs(rio_cmd.timeout));
-			if (result =3D=3D -ETIMEDOUT)
-				retries--;
-			else if (result < 0) {
-				dev_err(&rio->rio_dev->dev,
-					"Error executing ioctrl. code =3D %d\n",
-					result);
-				retries =3D 0;
-			} else {
-				dev_dbg(&rio->rio_dev->dev,
-					"Executed ioctl. Result =3D %d\n", result);
-				retries =3D 0;
-
-			}
-
-		}
-		free_page((unsigned long) buffer);
-		break;
-
-	default:
-		retval =3D -ENOTTY;
-		break;
-	}
-
-
-err_out:
-	mutex_unlock(&(rio->lock));
-	return retval;
-}
-
-static ssize_t
-write_rio(struct file *file, const char __user *buffer,
-	  size_t count, loff_t * ppos)
-{
-	DEFINE_WAIT(wait);
-	struct rio_usb_data *rio =3D &rio_instance;
-
-	unsigned long copy_size;
-	unsigned long bytes_written =3D 0;
-	unsigned int partial;
-
-	int result =3D 0;
-	int maxretry;
-	int errn =3D 0;
-	int intr;
-
-	intr =3D mutex_lock_interruptible(&(rio->lock));
-	if (intr)
-		return -EINTR;
-        /* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present =3D=3D 0 || rio->rio_dev =3D=3D NULL) {
-		mutex_unlock(&(rio->lock));
-		return -ENODEV;
-	}
-
-
-
-	do {
-		unsigned long thistime;
-		char *obuf =3D rio->obuf;
-
-		thistime =3D copy_size =3D
-		    (count >=3D OBUF_SIZE) ? OBUF_SIZE : count;
-		if (copy_from_user(rio->obuf, buffer, copy_size)) {
-			errn =3D -EFAULT;
-			goto error;
-		}
-		maxretry =3D 5;
-		while (thistime) {
-			if (!rio->rio_dev) {
-				errn =3D -ENODEV;
-				goto error;
-			}
-			if (signal_pending(current)) {
-				mutex_unlock(&(rio->lock));
-				return bytes_written ? bytes_written : -EINTR;
-			}
-
-			result =3D usb_bulk_msg(rio->rio_dev,
-					 usb_sndbulkpipe(rio->rio_dev, 2),
-					 obuf, thistime, &partial, 5000);
-
-			dev_dbg(&rio->rio_dev->dev,
-				"write stats: result:%d thistime:%lu partial:%u\n",
-				result, thistime, partial);
-
-			if (result =3D=3D -ETIMEDOUT) {	/* NAK - so hold for a while */
-				if (!maxretry--) {
-					errn =3D -ETIME;
-					goto error;
-				}
-				prepare_to_wait(&rio->wait_q, &wait, TASK_INTERRUPTIBLE);
-				schedule_timeout(NAK_TIMEOUT);
-				finish_wait(&rio->wait_q, &wait);
-				continue;
-			} else if (!result && partial) {
-				obuf +=3D partial;
-				thistime -=3D partial;
-			} else
-				break;
-		}
-		if (result) {
-			dev_err(&rio->rio_dev->dev, "Write Whoops - %x\n",
-				result);
-			errn =3D -EIO;
-			goto error;
-		}
-		bytes_written +=3D copy_size;
-		count -=3D copy_size;
-		buffer +=3D copy_size;
-	} while (count > 0);
-
-	mutex_unlock(&(rio->lock));
-
-	return bytes_written ? bytes_written : -EIO;
-
-error:
-	mutex_unlock(&(rio->lock));
-	return errn;
-}
-
-static ssize_t
-read_rio(struct file *file, char __user *buffer, size_t count, loff_t * pp=
os)
-{
-	DEFINE_WAIT(wait);
-	struct rio_usb_data *rio =3D &rio_instance;
-	ssize_t read_count;
-	unsigned int partial;
-	int this_read;
-	int result;
-	int maxretry =3D 10;
-	char *ibuf;
-	int intr;
-
-	intr =3D mutex_lock_interruptible(&(rio->lock));
-	if (intr)
-		return -EINTR;
-	/* Sanity check to make sure rio is connected, powered, etc */
-        if (rio->present =3D=3D 0 || rio->rio_dev =3D=3D NULL) {
-		mutex_unlock(&(rio->lock));
-		return -ENODEV;
-	}
-
-	ibuf =3D rio->ibuf;
-
-	read_count =3D 0;
-
-
-	while (count > 0) {
-		if (signal_pending(current)) {
-			mutex_unlock(&(rio->lock));
-			return read_count ? read_count : -EINTR;
-		}
-		if (!rio->rio_dev) {
-			mutex_unlock(&(rio->lock));
-			return -ENODEV;
-		}
-		this_read =3D (count >=3D IBUF_SIZE) ? IBUF_SIZE : count;
-
-		result =3D usb_bulk_msg(rio->rio_dev,
-				      usb_rcvbulkpipe(rio->rio_dev, 1),
-				      ibuf, this_read, &partial,
-				      8000);
-
-		dev_dbg(&rio->rio_dev->dev,
-			"read stats: result:%d this_read:%u partial:%u\n",
-			result, this_read, partial);
-
-		if (partial) {
-			count =3D this_read =3D partial;
-		} else if (result =3D=3D -ETIMEDOUT || result =3D=3D 15) {	/* FIXME: 15 =
??? */
-			if (!maxretry--) {
-				mutex_unlock(&(rio->lock));
-				dev_err(&rio->rio_dev->dev,
-					"read_rio: maxretry timeout\n");
-				return -ETIME;
-			}
-			prepare_to_wait(&rio->wait_q, &wait, TASK_INTERRUPTIBLE);
-			schedule_timeout(NAK_TIMEOUT);
-			finish_wait(&rio->wait_q, &wait);
-			continue;
-		} else if (result !=3D -EREMOTEIO) {
-			mutex_unlock(&(rio->lock));
-			dev_err(&rio->rio_dev->dev,
-				"Read Whoops - result:%u partial:%u this_read:%u\n",
-				result, partial, this_read);
-			return -EIO;
-		} else {
-			mutex_unlock(&(rio->lock));
-			return (0);
-		}
-
-		if (this_read) {
-			if (copy_to_user(buffer, ibuf, this_read)) {
-				mutex_unlock(&(rio->lock));
-				return -EFAULT;
-			}
-			count -=3D this_read;
-			read_count +=3D this_read;
-			buffer +=3D this_read;
-		}
-	}
-	mutex_unlock(&(rio->lock));
-	return read_count;
-}
-
-static const struct file_operations usb_rio_fops =3D {
-	.owner =3D	THIS_MODULE,
-	.read =3D		read_rio,
-	.write =3D	write_rio,
-	.unlocked_ioctl =3D ioctl_rio,
-	.open =3D		open_rio,
-	.release =3D	close_rio,
-	.llseek =3D	noop_llseek,
-};
-
-static struct usb_class_driver usb_rio_class =3D {
-	.name =3D		"rio500%d",
-	.fops =3D		&usb_rio_fops,
-	.minor_base =3D	RIO_MINOR,
-};
-
-static int probe_rio(struct usb_interface *intf,
-		     const struct usb_device_id *id)
-{
-	struct usb_device *dev =3D interface_to_usbdev(intf);
-	struct rio_usb_data *rio =3D &rio_instance;
-	int retval =3D 0;
-
-	mutex_lock(&rio500_mutex);
-	if (rio->present) {
-		dev_info(&intf->dev, "Second USB Rio at address %d refused\n", dev->devn=
um);
-		retval =3D -EBUSY;
-		goto bail_out;
-	} else {
-		dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
-	}
-
-	retval =3D usb_register_dev(intf, &usb_rio_class);
-	if (retval) {
-		dev_err(&dev->dev,
-			"Not able to get a minor for this device.\n");
-		retval =3D -ENOMEM;
-		goto bail_out;
-	}
-
-	rio->rio_dev =3D dev;
-
-	if (!(rio->obuf =3D kmalloc(OBUF_SIZE, GFP_KERNEL))) {
-		dev_err(&dev->dev,
-			"probe_rio: Not enough memory for the output buffer\n");
-		usb_deregister_dev(intf, &usb_rio_class);
-		retval =3D -ENOMEM;
-		goto bail_out;
-	}
-	dev_dbg(&intf->dev, "obuf address:%p\n", rio->obuf);
-
-	if (!(rio->ibuf =3D kmalloc(IBUF_SIZE, GFP_KERNEL))) {
-		dev_err(&dev->dev,
-			"probe_rio: Not enough memory for the input buffer\n");
-		usb_deregister_dev(intf, &usb_rio_class);
-		kfree(rio->obuf);
-		retval =3D -ENOMEM;
-		goto bail_out;
-	}
-	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
-
-	mutex_init(&(rio->lock));
-
-	usb_set_intfdata (intf, rio);
-	rio->present =3D 1;
-bail_out:
-	mutex_unlock(&rio500_mutex);
-
-	return retval;
-}
-
-static void disconnect_rio(struct usb_interface *intf)
-{
-	struct rio_usb_data *rio =3D usb_get_intfdata (intf);
-
-	usb_set_intfdata (intf, NULL);
-	mutex_lock(&rio500_mutex);
-	if (rio) {
-		usb_deregister_dev(intf, &usb_rio_class);
-
-		mutex_lock(&(rio->lock));
-		if (rio->isopen) {
-			rio->isopen =3D 0;
-			/* better let it finish - the release will do whats needed */
-			rio->rio_dev =3D NULL;
-			mutex_unlock(&(rio->lock));
-			mutex_unlock(&rio500_mutex);
-			return;
-		}
-		kfree(rio->ibuf);
-		kfree(rio->obuf);
-
-		dev_info(&intf->dev, "USB Rio disconnected.\n");
-
-		rio->present =3D 0;
-		mutex_unlock(&(rio->lock));
-	}
-	mutex_unlock(&rio500_mutex);
-}
-
-static const struct usb_device_id rio_table[] =3D {
-	{ USB_DEVICE(0x0841, 1) }, 		/* Rio 500 */
-	{ }					/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE (usb, rio_table);
-
-static struct usb_driver rio_driver =3D {
-	.name =3D		"rio500",
-	.probe =3D	probe_rio,
-	.disconnect =3D	disconnect_rio,
-	.id_table =3D	rio_table,
-};
-
-module_usb_driver(rio_driver);
-
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
-MODULE_LICENSE("GPL");
-
diff --git a/drivers/usb/misc/rio500_usb.h b/drivers/usb/misc/rio500_usb.h
deleted file mode 100644
index 359abc98e706..000000000000
--- a/drivers/usb/misc/rio500_usb.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*  ----------------------------------------------------------------------
-
-    Copyright (C) 2000  Cesar Miquel  (miquel@df.uba.ar)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-    ----------------------------------------------------------------------=
 */
-
-
-
-#define RIO_SEND_COMMAND			0x1
-#define RIO_RECV_COMMAND			0x2
-
-#define RIO_DIR_OUT               	        0x0
-#define RIO_DIR_IN				0x1
-
-struct RioCommand {
-	short length;
-	int request;
-	int requesttype;
-	int value;
-	int index;
-	void __user *buffer;
-	int timeout;
-};
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 1184390508e9..c77974fab29d 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
=20
@@ -56,6 +57,8 @@ struct usb_lcd {
 							   using up all RAM */
 	struct usb_anchor	submitted;		/* URBs to wait for
 							   before suspend */
+	struct rw_semaphore	io_rwsem;
+	unsigned long		disconnected:1;
 };
 #define to_lcd_dev(d) container_of(d, struct usb_lcd, kref)
=20
@@ -141,6 +144,13 @@ static ssize_t lcd_read(struct file *file, char __user=
 * buffer,
=20
 	dev =3D file->private_data;
=20
+	down_read(&dev->io_rwsem);
+
+	if (dev->disconnected) {
+		retval =3D -ENODEV;
+		goto out_up_io;
+	}
+
 	/* do a blocking bulk read to get data from the device */
 	retval =3D usb_bulk_msg(dev->udev,
 			      usb_rcvbulkpipe(dev->udev,
@@ -157,6 +167,9 @@ static ssize_t lcd_read(struct file *file, char __user =
* buffer,
 			retval =3D bytes_read;
 	}
=20
+out_up_io:
+	up_read(&dev->io_rwsem);
+
 	return retval;
 }
=20
@@ -236,11 +249,18 @@ static ssize_t lcd_write(struct file *file, const cha=
r __user * user_buffer,
 	if (r < 0)
 		return -EINTR;
=20
+	down_read(&dev->io_rwsem);
+
+	if (dev->disconnected) {
+		retval =3D -ENODEV;
+		goto err_up_io;
+	}
+
 	/* create a urb, and a buffer for it, and copy the data to the urb */
 	urb =3D usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
 		retval =3D -ENOMEM;
-		goto err_no_buf;
+		goto err_up_io;
 	}
=20
 	buf =3D usb_alloc_coherent(dev->udev, count, GFP_KERNEL,
@@ -277,6 +297,7 @@ static ssize_t lcd_write(struct file *file, const char =
__user * user_buffer,
 	   the USB core will eventually free it entirely */
 	usb_free_urb(urb);
=20
+	up_read(&dev->io_rwsem);
 exit:
 	return count;
 error_unanchor:
@@ -284,7 +305,8 @@ static ssize_t lcd_write(struct file *file, const char =
__user * user_buffer,
 error:
 	usb_free_coherent(dev->udev, count, buf, urb->transfer_dma);
 	usb_free_urb(urb);
-err_no_buf:
+err_up_io:
+	up_read(&dev->io_rwsem);
 	up(&dev->limit_sem);
 	return retval;
 }
@@ -327,6 +349,7 @@ static int lcd_probe(struct usb_interface *interface,
 	}
 	kref_init(&dev->kref);
 	sema_init(&dev->limit_sem, USB_LCD_CONCURRENT_WRITES);
+	init_rwsem(&dev->io_rwsem);
 	init_usb_anchor(&dev->submitted);
=20
 	dev->udev =3D usb_get_dev(interface_to_usbdev(interface));
@@ -437,6 +460,12 @@ static void lcd_disconnect(struct usb_interface *inter=
face)
 	/* give back our minor */
 	usb_deregister_dev(interface, &lcd_class);
=20
+	down_write(&dev->io_rwsem);
+	dev->disconnected =3D 1;
+	up_write(&dev->io_rwsem);
+
+	usb_kill_anchored_urbs(&dev->submitted);
+
 	/* decrement our usage count */
 	kref_put(&dev->kref, lcd_delete);
=20
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 093f1cc5faf1..777a661e67b1 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -64,6 +64,7 @@ struct usb_yurex {
=20
 	struct kref		kref;
 	struct mutex		io_mutex;
+	unsigned long		disconnected:1;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	waitq;
=20
@@ -111,6 +112,7 @@ static void yurex_delete(struct kref *kref)
 				dev->int_buffer, dev->urb->transfer_dma);
 		usb_free_urb(dev->urb);
 	}
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev);
 }
@@ -136,6 +138,7 @@ static void yurex_interrupt(struct urb *urb)
 	switch (status) {
 	case 0: /*success*/
 		break;
+	/* The device is terminated or messed up, give up */
 	case -EOVERFLOW:
 		dev_err(&dev->interface->dev,
 			"%s - overflow with length %d, actual length is %d\n",
@@ -144,12 +147,13 @@ static void yurex_interrupt(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 	case -EILSEQ:
-		/* The device is terminated, clean up */
+	case -EPROTO:
+	case -ETIME:
 		return;
 	default:
 		dev_err(&dev->interface->dev,
 			"%s - unknown status received: %d\n", __func__, status);
-		goto exit;
+		return;
 	}
=20
 	/* handle received message */
@@ -181,7 +185,6 @@ static void yurex_interrupt(struct urb *urb)
 		break;
 	}
=20
-exit:
 	retval =3D usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		dev_err(&dev->interface->dev, "%s - usb_submit_urb failed: %d\n",
@@ -210,7 +213,7 @@ static int yurex_probe(struct usb_interface *interface,=
 const struct usb_device_
 	init_waitqueue_head(&dev->waitq);
=20
 	dev->udev =3D usb_get_dev(interface_to_usbdev(interface));
-	dev->interface =3D interface;
+	dev->interface =3D usb_get_intf(interface);
=20
 	/* set up the endpoint information */
 	iface_desc =3D interface->cur_altsetting;
@@ -333,8 +336,9 @@ static void yurex_disconnect(struct usb_interface *inte=
rface)
=20
 	/* prevent more I/O from starting */
 	usb_poison_urb(dev->urb);
+	usb_poison_urb(dev->cntl_urb);
 	mutex_lock(&dev->io_mutex);
-	dev->interface =3D NULL;
+	dev->disconnected =3D 1;
 	mutex_unlock(&dev->io_mutex);
=20
 	/* wakeup waiters */
@@ -421,7 +425,7 @@ static ssize_t yurex_read(struct file *file, char *buff=
er, size_t count, loff_t
 	dev =3D (struct usb_yurex *)file->private_data;
=20
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		return -ENODEV;
 	}
@@ -452,7 +456,7 @@ static ssize_t yurex_write(struct file *file, const cha=
r *user_buffer, size_t co
 		goto error;
=20
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval =3D -ENODEV;
 		goto error;
diff --git a/drivers/usb/renesas_usbhs/common.h b/drivers/usb/renesas_usbhs=
/common.h
index c69dd2fba360..13c7baced956 100644
--- a/drivers/usb/renesas_usbhs/common.h
+++ b/drivers/usb/renesas_usbhs/common.h
@@ -207,6 +207,7 @@ struct usbhs_priv;
 /* DCPCTR */
 #define BSTS		(1 << 15)	/* Buffer Status */
 #define SUREQ		(1 << 14)	/* Sending SETUP Token */
+#define INBUFM		(1 << 14)	/* (PIPEnCTR) Transfer Buffer Monitor */
 #define CSSTS		(1 << 12)	/* CSSTS Status */
 #define	ACLRM		(1 << 9)	/* Buffer Auto-Clear Mode */
 #define SQCLR		(1 << 8)	/* Toggle Bit Clear */
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/f=
ifo.c
index 70d4b6ed21a3..0e5b04386f60 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -100,7 +100,7 @@ static void __usbhsf_pkt_del(struct usbhs_pkt *pkt)
 	list_del_init(&pkt->node);
 }
=20
-static struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
 {
 	if (list_empty(&pipe->list))
 		return NULL;
diff --git a/drivers/usb/renesas_usbhs/fifo.h b/drivers/usb/renesas_usbhs/f=
ifo.h
index a168a1760fce..99e42b75d476 100644
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -98,5 +98,6 @@ void usbhs_pkt_push(struct usbhs_pipe *pipe, struct usbhs=
_pkt *pkt,
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt =
*pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
=20
 #endif /* RENESAS_USB_FIFO_H */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_u=
sbhs/mod_gadget.c
index 5732dd0fbd27..b64f88b658ed 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -704,8 +704,7 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep=
, int halt, int wedge)
 	struct usbhs_priv *priv =3D usbhsg_gpriv_to_priv(gpriv);
 	struct device *dev =3D usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
-
-	usbhsg_pipe_disable(uep);
+	int ret =3D 0;
=20
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
@@ -713,6 +712,18 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *e=
p, int halt, int wedge)
 	/********************  spin lock ********************/
 	usbhs_lock(priv, flags);
=20
+	/*
+	 * According to usb_ep_set_halt()'s description, this function should
+	 * return -EAGAIN if the IN endpoint has any queue or data. Note
+	 * that the usbhs_pipe_is_dir_in() returns false if the pipe is an
+	 * IN endpoint in the gadget mode.
+	 */
+	if (!usbhs_pipe_is_dir_in(pipe) && (__usbhsf_pkt_get(pipe) ||
+	    usbhs_pipe_contains_transmittable_data(pipe))) {
+		ret =3D -EAGAIN;
+		goto out;
+	}
+
 	if (halt)
 		usbhs_pipe_stall(pipe);
 	else
@@ -723,10 +734,11 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *=
ep, int halt, int wedge)
 	else
 		usbhsg_status_clr(gpriv, USBHSG_STATUS_WEDGE);
=20
+out:
 	usbhs_unlock(priv, flags);
 	/********************  spin unlock ******************/
=20
-	return 0;
+	return ret;
 }
=20
 static int usbhsg_ep_set_halt(struct usb_ep *ep, int value)
diff --git a/drivers/usb/renesas_usbhs/pipe.c b/drivers/usb/renesas_usbhs/p=
ipe.c
index aa611807661a..c10e5937cf2d 100644
--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -263,6 +263,21 @@ int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe)
 	return -EBUSY;
 }
=20
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe)
+{
+	u16 val;
+
+	/* Do not support for DCP pipe */
+	if (usbhs_pipe_is_dcp(pipe))
+		return false;
+
+	val =3D usbhsp_pipectrl_get(pipe);
+	if (val & INBUFM)
+		return true;
+
+	return false;
+}
+
 /*
  *		PID ctrl
  */
diff --git a/drivers/usb/renesas_usbhs/pipe.h b/drivers/usb/renesas_usbhs/p=
ipe.h
index 406f36d050e4..1ae2c286e2a9 100644
--- a/drivers/usb/renesas_usbhs/pipe.h
+++ b/drivers/usb/renesas_usbhs/pipe.h
@@ -85,6 +85,7 @@ void usbhs_pipe_init(struct usbhs_priv *priv,
 int usbhs_pipe_get_maxpacket(struct usbhs_pipe *pipe);
 void usbhs_pipe_clear(struct usbhs_pipe *pipe);
 int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe);
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe);
 void usbhs_pipe_enable(struct usbhs_pipe *pipe);
 void usbhs_pipe_disable(struct usbhs_pipe *pipe);
 void usbhs_pipe_stall(struct usbhs_pipe *pipe);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8db5a3533ca7..d5d33bf5188f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1038,6 +1038,9 @@ static const struct usb_device_id id_table_combined[]=
 =3D {
 	/* EZPrototypes devices */
 	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
 	{ USB_DEVICE_INTERFACE_NUMBER(UNJO_VID, UNJO_ISODEBUG_V1_PID, 1) },
+	/* Sienna devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
+	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 3ed504675fac..655672d1be6f 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -38,6 +38,9 @@
=20
 #define FTDI_LUMEL_PD12_PID	0x6002
=20
+/* Sienna Serial Interface by Secyourit GmbH */
+#define FTDI_SIENNA_PID		0x8348
+
 /* Cyber Cortex AV by Fabulous Silicon (http://fabuloussilicon.com) */
 #define CYBER_CORTEX_AV_PID	0x8698
=20
@@ -687,6 +690,12 @@
 #define BANDB_TTL3USB9M_PID	0xAC50
 #define BANDB_ZZ_PROG1_USB_PID	0xBA02
=20
+/*
+ * Echelon USB Serial Interface
+ */
+#define ECHELON_VID		0x0920
+#define ECHELON_U20_PID		0x7500
+
 /*
  * Intrepid Control Systems (http://www.intrepidcs.com/) ValueCAN and NeoVI
  */
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7faa901ee47f..38112be0dbae 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1249,8 +1249,8 @@ static struct urb *keyspan_setup_urb(struct usb_seria=
l *serial, int endpoint,
=20
 	ep_desc =3D find_ep(serial, endpoint);
 	if (!ep_desc) {
-		/* leak the urb, something's wrong and the callers don't care */
-		return urb;
+		usb_free_urb(urb);
+		return NULL;
 	}
 	if (usb_endpoint_xfer_int(ep_desc)) {
 		ep_type_name =3D "INT";
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_=
usb_3410_5052.c
index e9bdd5bb2c6c..80896be60704 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -542,7 +542,6 @@ static void ti_close(struct usb_serial_port *port)
 	struct ti_port *tport;
 	int port_number;
 	int status;
-	int do_unlock;
 	unsigned long flags;
=20
 	tdev =3D usb_get_serial_data(port->serial);
@@ -569,16 +568,13 @@ static void ti_close(struct usb_serial_port *port)
 			"%s - cannot send close port command, %d\n"
 							, __func__, status);
=20
-	/* if mutex_lock is interrupted, continue anyway */
-	do_unlock =3D !mutex_lock_interruptible(&tdev->td_open_close_lock);
+	mutex_lock(&tdev->td_open_close_lock);
 	--tport->tp_tdev->td_open_port_count;
-	if (tport->tp_tdev->td_open_port_count <=3D 0) {
+	if (tport->tp_tdev->td_open_port_count =3D=3D 0) {
 		/* last port is closed, shut down interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-		tport->tp_tdev->td_open_port_count =3D 0;
 	}
-	if (do_unlock)
-		mutex_unlock(&tdev->td_open_close_lock);
+	mutex_unlock(&tdev->td_open_close_lock);
 }
=20
=20
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index 02bce9ab6f62..97b9af49c1d2 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -317,10 +317,7 @@ static void serial_cleanup(struct tty_struct *tty)
 	serial =3D port->serial;
 	owner =3D serial->type->driver.owner;
=20
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		usb_autopm_put_interface(serial->interface);
-	mutex_unlock(&serial->disc_mutex);
+	usb_autopm_put_interface(serial->interface);
=20
 	usb_serial_put(serial);
 	module_put(owner);
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index d3ea90bef84d..345211f1a491 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -604,6 +604,10 @@ static int firm_send_command(struct usb_serial_port *p=
ort, __u8 command,
=20
 	command_port =3D port->serial->port[COMMAND_PORT];
 	command_info =3D usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished =3D false;
=20
@@ -677,6 +681,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct device *dev =3D &port->dev;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag =3D tty->termios.c_cflag;
+	speed_t baud;
=20
 	port_settings.port =3D port->port_number + 1;
=20
@@ -737,11 +742,13 @@ static void firm_setup_port(struct tty_struct *tty)
 	dev_dbg(dev, "%s - XON =3D %2x, XOFF =3D %2x\n", __func__, port_settings.=
xon, port_settings.xoff);
=20
 	/* get the baud rate wanted */
-	port_settings.baud =3D tty_get_baud_rate(tty);
-	dev_dbg(dev, "%s - baud rate =3D %d\n", __func__, port_settings.baud);
+	baud =3D tty_get_baud_rate(tty);
+	port_settings.baud =3D cpu_to_le32(baud);
+	dev_dbg(dev, "%s - baud rate =3D %u\n", __func__, baud);
=20
 	/* fixme: should set validated settings */
-	tty_encode_baud_rate(tty, port_settings.baud, port_settings.baud);
+	tty_encode_baud_rate(tty, baud, baud);
+
 	/* handle any settings that aren't specified in the tty structure */
 	port_settings.lloop =3D 0;
=20
diff --git a/drivers/usb/serial/whiteheat.h b/drivers/usb/serial/whiteheat.h
index 38065df4d2d8..30169c859a74 100644
--- a/drivers/usb/serial/whiteheat.h
+++ b/drivers/usb/serial/whiteheat.h
@@ -91,7 +91,7 @@ struct whiteheat_simple {
=20
 struct whiteheat_port_settings {
 	__u8	port;		/* port number (1 to N) */
-	__u32	baud;		/* any value 7 - 460800, firmware calculates
+	__le32	baud;		/* any value 7 - 460800, firmware calculates
 				   best fit; arrives little endian */
 	__u8	bits;		/* 5, 6, 7, or 8 */
 	__u8	stop;		/* 1 or 2, default 1 (2 =3D 1.5 if bits =3D 5) */
diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 545d09b8081d..871c366d9229 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -63,6 +63,7 @@ struct usb_skel {
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	unsigned long		disconnected:1;
 	wait_queue_head_t	bulk_in_wait;		/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
@@ -75,6 +76,7 @@ static void skel_delete(struct kref *kref)
 	struct usb_skel *dev =3D to_skel_dev(kref);
=20
 	usb_free_urb(dev->bulk_in_urb);
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
@@ -126,10 +128,7 @@ static int skel_release(struct inode *inode, struct fi=
le *file)
 		return -ENODEV;
=20
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
-		usb_autopm_put_interface(dev->interface);
-	mutex_unlock(&dev->io_mutex);
+	usb_autopm_put_interface(dev->interface);
=20
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
@@ -241,7 +240,7 @@ static ssize_t skel_read(struct file *file, char *buffe=
r, size_t count,
 	if (rv < 0)
 		return rv;
=20
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		rv =3D -ENODEV;
 		goto exit;
 	}
@@ -422,7 +421,7 @@ static ssize_t skel_write(struct file *file, const char=
 *user_buffer,
=20
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
 		retval =3D -ENODEV;
 		goto error;
@@ -511,7 +510,7 @@ static int skel_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->bulk_in_wait);
=20
 	dev->udev =3D usb_get_dev(interface_to_usbdev(interface));
-	dev->interface =3D interface;
+	dev->interface =3D usb_get_intf(interface);
=20
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
@@ -590,7 +589,7 @@ static void skel_disconnect(struct usb_interface *inter=
face)
=20
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface =3D NULL;
+	dev->disconnected =3D 1;
 	mutex_unlock(&dev->io_mutex);
=20
 	usb_kill_anchored_urbs(&dev->submitted);
diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap=
2/dss/dss.c
index 6daeb7ed44c6..281f30a82910 100644
--- a/drivers/video/fbdev/omap2/dss/dss.c
+++ b/drivers/video/fbdev/omap2/dss/dss.c
@@ -708,7 +708,7 @@ static const struct dss_features omap34xx_dss_feats __i=
nitconst =3D {
 };
=20
 static const struct dss_features omap3630_dss_feats __initconst =3D {
-	.fck_div_max		=3D	32,
+	.fck_div_max		=3D	31,
 	.dss_fck_multiplier	=3D	1,
 	.parent_clk_name	=3D	"dpll4_ck",
 	.dpi_select_source	=3D	&dss_dpi_select_source_omap2_omap3,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8598807181a4..49f1868450b9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1888,23 +1888,6 @@ int btrfs_sync_file(struct file *file, loff_t start,=
 loff_t end, int datasync)
 	bool full_sync =3D 0;
 	u64 len;
=20
-	/*
-	 * If the inode needs a full sync, make sure we use a full range to
-	 * avoid log tree corruption, due to hole detection racing with ordered
-	 * extent completion for adjacent ranges, and assertion failures during
-	 * hole detection.
-	 */
-	if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-		     &BTRFS_I(inode)->runtime_flags)) {
-		start =3D 0;
-		end =3D LLONG_MAX;
-	}
-
-	/*
-	 * The range length can be represented by u64, we have to do the typecasts
-	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
-	 */
-	len =3D (u64)end - (u64)start + 1;
 	trace_btrfs_sync_file(file, datasync);
=20
 	/*
@@ -1924,6 +1907,25 @@ int btrfs_sync_file(struct file *file, loff_t start,=
 loff_t end, int datasync)
=20
 	mutex_lock(&inode->i_mutex);
=20
+	/*
+	 * If the inode needs a full sync, make sure we use a full range to
+	 * avoid log tree corruption, due to hole detection racing with ordered
+	 * extent completion for adjacent ranges, and assertion failures during
+	 * hole detection. Do this while holding the inode lock, to avoid races
+	 * with other tasks.
+	 */
+	if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+		     &BTRFS_I(inode)->runtime_flags)) {
+		start =3D 0;
+		end =3D LLONG_MAX;
+	}
+
+	/*
+	 * The range length can be represented by u64, we have to do the typecasts
+	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
+	 */
+	len =3D (u64)end - (u64)start + 1;
+
 	/*
 	 * We flush the dirty pages again to avoid some dirty pages in the
 	 * range being left.
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ba864d7154a2..943bd9bf4cb1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -913,6 +913,11 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queu=
e_release)
=20
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
=20
+	/* remove from inode's cap rbtree, and clear auth cap */
+	rb_erase(&cap->ci_node, &ci->i_caps);
+	if (ci->i_auth_cap =3D=3D cap)
+		ci->i_auth_cap =3D NULL;
+
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
 	/*
@@ -939,11 +944,6 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queu=
e_release)
 	cap->ci =3D NULL;
 	spin_unlock(&session->s_cap_lock);
=20
-	/* remove from inode list */
-	rb_erase(&cap->ci_node, &ci->i_caps);
-	if (ci->i_auth_cap =3D=3D cap)
-		ci->i_auth_cap =3D NULL;
-
 	if (removed)
 		ceph_put_cap(mdsc, cap);
=20
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 20e488053793..57a1be7ebaae 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1260,6 +1260,7 @@ int ceph_fill_trace(struct super_block *sb, struct ce=
ph_mds_request *req,
 					    req->r_request_started);
 		dout(" final dn %p\n", dn);
 	} else if (!req->r_aborted &&
+	           req->r_locked_dir &&
 		   (req->r_op =3D=3D CEPH_MDS_OP_LOOKUPSNAP ||
 		    req->r_op =3D=3D CEPH_MDS_OP_MKSNAP)) {
 		struct dentry *dn =3D req->r_dentry;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 61266439b603..cf8979a5ea22 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -199,8 +199,8 @@ static int parse_reply_info_dir(void **p, void *end,
 	}
=20
 done:
-	if (*p !=3D end)
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p =3D end;
 	return 0;
=20
 bad:
@@ -221,12 +221,10 @@ static int parse_reply_info_filelock(void **p, void *=
end,
 		goto bad;
=20
 	info->filelock_reply =3D *p;
-	*p +=3D sizeof(*info->filelock_reply);
=20
-	if (unlikely(*p !=3D end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p =3D end;
 	return 0;
-
 bad:
 	return -EIO;
 }
@@ -239,18 +237,21 @@ static int parse_reply_info_create(void **p, void *en=
d,
 				  u64 features)
 {
 	if (features & CEPH_FEATURE_REPLY_CREATE_INODE) {
+		/* Malformed reply? */
 		if (*p =3D=3D end) {
 			info->has_create_ino =3D false;
 		} else {
 			info->has_create_ino =3D true;
-			info->ino =3D ceph_decode_64(p);
+			ceph_decode_64_safe(p, end, info->ino, bad);
 		}
+	} else {
+		if (*p !=3D end)
+			goto bad;
 	}
=20
-	if (unlikely(*p !=3D end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p =3D end;
 	return 0;
-
 bad:
 	return -EIO;
 }
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 07e2465c0d50..68e53fb8db59 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -817,10 +817,16 @@ cifs_lookup(struct inode *parent_dir_inode, struct de=
ntry *direntry,
 static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
+	struct inode *inode;
+
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
=20
 	if (direntry->d_inode) {
+		inode =3D d_inode(direntry);
+		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
+			CIFS_I(inode)->time =3D 0; /* force reval */
+
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
 		else {
@@ -831,7 +837,7 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int=
 flags)
 			 * attributes will have been updated by
 			 * cifs_revalidate_dentry().
 			 */
-			if (IS_AUTOMOUNT(direntry->d_inode) &&
+			if (IS_AUTOMOUNT(inode) &&
 			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
 				spin_lock(&direntry->d_lock);
 				direntry->d_flags |=3D DCACHE_NEED_AUTOMOUNT;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4fb2a62299f4..038a810418d8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -253,6 +253,12 @@ cifs_nt_open(char *full_path, struct inode *inode, str=
uct cifs_sb_info *cifs_sb,
 		rc =3D cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
 					 xid, fid);
=20
+	if (rc) {
+		server->ops->close(xid, tcon, fid);
+		if (rc =3D=3D -ESTALE)
+			rc =3D -EOPENSTALE;
+	}
+
 out:
 	kfree(buf);
 	return rc;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f681091ec3db..4746be3c9599 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -401,9 +401,27 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 			rc =3D -ENOMEM;
 	} else {
 		/* we already have inode, update it */
+
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*pinode)->uniqueid !=3D fattr.cf_uniqueid)) {
+			CIFS_I(*pinode)->time =3D 0; /* force reval */
+			rc =3D -ESTALE;
+			goto cgiiu_exit;
+		}
+
+		/* if filetype is different, return error */
+		if (unlikely(((*pinode)->i_mode & S_IFMT) !=3D
+		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*pinode)->time =3D 0; /* force reval */
+			rc =3D -ESTALE;
+			goto cgiiu_exit;
+		}
+
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
=20
+cgiiu_exit:
 	return rc;
 }
=20
@@ -799,8 +817,21 @@ cifs_get_inode_info(struct inode **inode, const char *=
full_path,
 			}
 		} else
 			fattr.cf_uniqueid =3D iunique(sb, ROOT_I);
-	} else
-		fattr.cf_uniqueid =3D CIFS_I(*inode)->uniqueid;
+	} else {
+		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+		    validinum =3D=3D false && server->ops->get_srv_inum) {
+			/*
+			 * Pass a NULL tcon to ensure we don't make a round
+			 * trip to the server. This only works for SMB2+.
+			 */
+			tmprc =3D server->ops->get_srv_inum(xid,
+				NULL, cifs_sb, full_path,
+				&fattr.cf_uniqueid, data);
+			if (tmprc)
+				fattr.cf_uniqueid =3D CIFS_I(*inode)->uniqueid;
+		} else
+			fattr.cf_uniqueid =3D CIFS_I(*inode)->uniqueid;
+	}
=20
 	/* query for SFU type info if supported and needed */
 	if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
@@ -839,6 +870,24 @@ cifs_get_inode_info(struct inode **inode, const char *=
full_path,
 		if (!*inode)
 			rc =3D -ENOMEM;
 	} else {
+		/* we already have inode, update it */
+
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*inode)->uniqueid !=3D fattr.cf_uniqueid)) {
+			CIFS_I(*inode)->time =3D 0; /* force reval */
+			rc =3D -ESTALE;
+			goto cgii_exit;
+		}
+
+		/* if filetype is different, return error */
+		if (unlikely(((*inode)->i_mode & S_IFMT) !=3D
+		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*inode)->time =3D 0; /* force reval */
+			rc =3D -ESTALE;
+			goto cgii_exit;
+		}
+
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
=20
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 67f7073d2a52..3f7ebbc67e0d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -180,6 +180,9 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	/* we do not want to loop forever */
 	last_mid =3D cur_mid;
 	cur_mid++;
+	/* avoid 0xFFFF MID */
+	if (cur_mid =3D=3D 0xffff)
+		cur_mid++;
=20
 	/*
 	 * This nested loop looks more expensive than it is.
diff --git a/fs/dcache.c b/fs/dcache.c
index 6b0ef157a48b..9cd0e99812a5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1685,7 +1685,6 @@ void d_instantiate_new(struct dentry *entry, struct i=
node *inode)
 	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 	BUG_ON(!inode);
 	lockdep_annotate_inode_mutex_key(inode);
-	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
 	WARN_ON(!(inode->i_state & I_NEW));
@@ -1693,6 +1692,7 @@ void d_instantiate_new(struct dentry *entry, struct i=
node *inode)
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
 	spin_unlock(&inode->i_lock);
+	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate_new);
=20
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 9819a544a160..2ce9d8a8c06d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -341,9 +341,9 @@ static int ecryptfs_lookup_interpose(struct dentry *den=
try,
 				     struct dentry *lower_dentry,
 				     struct inode *dir_inode)
 {
-	struct inode *inode, *lower_inode =3D lower_dentry->d_inode;
+	struct path *path =3D ecryptfs_dentry_to_lower_path(dentry->d_parent);
+	struct inode *inode, *lower_inode;
 	struct ecryptfs_dentry_info *dentry_info;
-	struct vfsmount *lower_mnt;
 	int rc =3D 0;
=20
 	dentry_info =3D kmem_cache_alloc(ecryptfs_dentry_info_cache, GFP_KERNEL);
@@ -355,15 +355,22 @@ static int ecryptfs_lookup_interpose(struct dentry *d=
entry,
 		return -ENOMEM;
 	}
=20
-	lower_mnt =3D mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
-	fsstack_copy_attr_atime(dir_inode, lower_dentry->d_parent->d_inode);
+	fsstack_copy_attr_atime(dir_inode, path->dentry->d_inode);
 	BUG_ON(!d_count(lower_dentry));
=20
 	ecryptfs_set_dentry_private(dentry, dentry_info);
-	dentry_info->lower_path.mnt =3D lower_mnt;
+	dentry_info->lower_path.mnt =3D mntget(path->mnt);
 	dentry_info->lower_path.dentry =3D lower_dentry;
=20
-	if (!lower_dentry->d_inode) {
+	/*
+	 * negative dentry can go positive under us here - its parent is not
+	 * locked.  That's OK and that could happen just as we return from
+	 * ecryptfs_lookup() anyway.  Just need to be careful and fetch
+	 * ->d_inode only once - it's not stable here.
+	 */
+	lower_inode =3D ACCESS_ONCE(lower_dentry->d_inode);
+
+	if (!lower_inode) {
 		/* We want to add because we couldn't find in lower */
 		d_add(dentry, NULL);
 		return 0;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index a692583913c9..64dbc1bab865 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1751,6 +1751,19 @@ int fuse_do_setattr(struct dentry *dentry, struct ia=
ttr *attr,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
=20
+	/* Flush dirty data/metadata before non-truncate SETATTR */
+	if (is_wb && S_ISREG(inode->i_mode) &&
+	    attr->ia_valid &
+			(ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_MTIME_SET |
+			 ATTR_TIMES_SET)) {
+		err =3D write_inode_now(inode, true);
+		if (err)
+			return err;
+
+		fuse_set_nowrite(inode);
+		fuse_release_nowrite(inode);
+	}
+
 	if (is_truncate) {
 		fuse_set_nowrite(inode);
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a683fcd16b05..70dcd2cba124 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -237,7 +237,7 @@ int fuse_open_common(struct inode *inode, struct file *=
file, bool isdir)
 {
 	struct fuse_conn *fc =3D get_fuse_conn(inode);
 	int err;
-	bool lock_inode =3D (file->f_flags & O_TRUNC) &&
+	bool is_wb_truncate =3D (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
=20
@@ -245,16 +245,20 @@ int fuse_open_common(struct inode *inode, struct file=
 *file, bool isdir)
 	if (err)
 		return err;
=20
-	if (lock_inode)
+	if (is_wb_truncate) {
 		mutex_lock(&inode->i_mutex);
+		fuse_set_nowrite(inode);
+	}
=20
 	err =3D fuse_do_open(fc, get_node_id(inode), file, isdir);
=20
 	if (!err)
 		fuse_finish_open(inode, file);
=20
-	if (lock_inode)
+	if (is_wb_truncate) {
+		fuse_release_nowrite(inode);
 		mutex_unlock(&inode->i_mutex);
+	}
=20
 	return err;
 }
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6eb1fb37de9a..794e4c0509d6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -168,6 +168,28 @@ static inline int allocflags_to_migratetype(gfp_t gfp_=
flags)
 		((gfp_flags & __GFP_RECLAIMABLE) !=3D 0);
 }
=20
+/**
+ * gfpflags_normal_context - is gfp_flags a normal sleepable context?
+ * @gfp_flags: gfp_flags to test
+ *
+ * Test whether @gfp_flags indicates that the allocation is from the
+ * %current context and allowed to sleep.
+ *
+ * An allocation being allowed to block doesn't mean it owns the %current
+ * context.  When direct reclaim path tries to allocate memory, the
+ * allocation context is nested inside whatever %current was doing at the
+ * time of the original allocation.  The nested allocation may be allowed
+ * to block but modifying anything %current owns can corrupt the outer
+ * context's expectations.
+ *
+ * %true result from this function indicates that the allocation context
+ * can sleep and use anything that's associated with %current.
+ */
+static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
+{
+	return (gfp_flags & (__GFP_WAIT | __GFP_MEMALLOC)) =3D=3D __GFP_WAIT;
+}
+
 #ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3fa91d5..bb4ffff31c69 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
+ * @cpu:		cpu number
  * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
@@ -179,6 +180,7 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
+	unsigned int			cpu;
 	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c3a61853cd13..a708b0683af6 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -222,6 +222,16 @@ static inline void usb_ep_set_maxpacket_limit(struct u=
sb_ep *ep,
  */
 static inline int usb_ep_enable(struct usb_ep *ep)
 {
+	/* UDC drivers can't handle endpoints with maxpacket size 0 */
+	if (usb_endpoint_maxp(ep->desc) =3D=3D 0) {
+		/*
+		 * We should log an error message here, but we can't call
+		 * dev_err() because there's no way to find the gadget
+		 * given only ep.
+		 */
+		return -EINVAL;
+	}
+
 	return ep->ops->enable(ep, ep->desc);
 }
=20
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 01d590ee5e7e..7770adaa87e3 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -35,6 +35,7 @@ struct inet_peer {
=20
 	u32			metrics[RTAX_MAX];
 	u32			rate_tokens;	/* rate limiting for ICMP */
+	u32			n_redirects;
 	unsigned long		rate_last;
 	union {
 		struct list_head	gc_list;
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 624a8a54806d..f58a9de65499 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -919,6 +919,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_t=
ables.h
index 2bfcb201e653..e8dc8beecb26 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -364,7 +364,8 @@ struct nft_expr_ops {
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
-	unsigned char			data[];
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
 };
=20
 static inline void *nft_expr_priv(const struct nft_expr *expr)
diff --git a/include/net/sock.h b/include/net/sock.h
index ae9dc6ce5712..1e3b6066a344 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2103,12 +2103,17 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk=
, int size, gfp_t gfp);
  * sk_page_frag - return an appropriate page_frag
  * @sk: socket
  *
- * If socket allocation mode allows current thread to sleep, it means its
- * safe to use the per task page_frag instead of the per socket one.
+ * Use the per task page_frag instead of the per socket one for
+ * optimization when we know that we're in the normal context and owns
+ * everything that's associated with %current.
+ *
+ * Testing __GFP_WAIT isn't enough here as direct reclaim may nest
+ * inside other socket operations and end up recursing into sk_page_frag()
+ * while it's already in use.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (sk->sk_allocation & __GFP_WAIT)
+	if (gfpflags_normal_context(sk->sk_allocation))
 		return &current->task_frag;
=20
 	return &sk->sk_frag;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dbad6176fb67..aaf2b480d111 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1687,6 +1687,7 @@ static void init_hrtimers_cpu(int cpu)
 	}
=20
 	cpu_base->active_bases =3D 0;
+	cpu_base->cpu =3D cpu;
 	hrtimer_init_hres(cpu_base);
 }
=20
diff --git a/kernel/panic.c b/kernel/panic.c
index e06b7d22c3b7..4d4dbbd9e817 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -110,6 +110,7 @@ void panic(const char *fmt, ...)
 	 * after the panic_lock is acquired) from invoking panic again.
 	 */
 	local_irq_disable();
+	preempt_disable_notrace();
=20
 	/*
 	 * It's possible to come here directly from a panic-assertion and
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea2d33aa1f55..773135f534ef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3753,20 +3753,28 @@ static enum hrtimer_restart sched_cfs_period_timer(=
struct hrtimer *timer)
 		if (++count > 3) {
 			u64 new, old =3D ktime_to_ns(cfs_b->period);
=20
-			new =3D (old * 147) / 128; /* ~115% */
-			new =3D min(new, max_cfs_quota_period);
-
-			cfs_b->period =3D ns_to_ktime(new);
-
-			/* since max is 1s, this is limited to 1e9^2, which fits in u64 */
-			cfs_b->quota *=3D new;
-			cfs_b->quota =3D div64_u64(cfs_b->quota, old);
-
-			pr_warn_ratelimited(
-	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us=
 %lld, cfs_quota_us =3D %lld)\n",
-				smp_processor_id(),
-				div_u64(new, NSEC_PER_USEC),
-				div_u64(cfs_b->quota, NSEC_PER_USEC));
+			/*
+			 * Grow period by a factor of 2 to avoid losing precision.
+			 * Precision loss in the quota/period ratio can cause __cfs_schedulable
+			 * to fail.
+			 */
+			new =3D old * 2;
+			if (new < max_cfs_quota_period) {
+				cfs_b->period =3D ns_to_ktime(new);
+				cfs_b->quota *=3D 2;
+
+				pr_warn_ratelimited(
+	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us=
 =3D %lld, cfs_quota_us =3D %lld)\n",
+					smp_processor_id(),
+					div_u64(new, NSEC_PER_USEC),
+					div_u64(cfs_b->quota, NSEC_PER_USEC));
+			} else {
+				pr_warn_ratelimited(
+	"cfs_period_timer[cpu%d]: period too short, but cannot scale up without l=
osing precision (cfs_period_us =3D %lld, cfs_quota_us =3D %lld)\n",
+					smp_processor_id(),
+					div_u64(old, NSEC_PER_USEC),
+					div_u64(cfs_b->quota, NSEC_PER_USEC));
+			}
=20
 			/* reset count so we don't come right back in here */
 			count =3D 0;
diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadc=
ast-hrtimer.c
index 6aac4beedbbe..4ca2dec92489 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -22,6 +22,7 @@ static void bc_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *bc)
 {
 	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		/*
 		 * Note, we cannot cancel the timer here as we might
@@ -49,32 +50,39 @@ static void bc_set_mode(enum clock_event_mode mode,
  */
 static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
 {
-	int bc_moved;
 	/*
-	 * We try to cancel the timer first. If the callback is on
-	 * flight on some other cpu then we let it handle it. If we
-	 * were able to cancel the timer nothing can rearm it as we
-	 * own broadcast_lock.
+	 * This is called either from enter/exit idle code or from the
+	 * broadcast handler. In all cases tick_broadcast_lock is held.
 	 *
-	 * However we can also be called from the event handler of
-	 * ce_broadcast_hrtimer itself when it expires. We cannot
-	 * restart the timer because we are in the callback, but we
-	 * can set the expiry time and let the callback return
-	 * HRTIMER_RESTART.
+	 * hrtimer_cancel() cannot be called here neither from the
+	 * broadcast handler nor from the enter/exit idle code. The idle
+	 * code can run into the problem described in bc_shutdown() and the
+	 * broadcast handler cannot wait for itself to complete for obvious
+	 * reasons.
 	 *
-	 * Since we are in the idle loop at this point and because
-	 * hrtimer_{start/cancel} functions call into tracing,
-	 * calls to these functions must be bound within RCU_NONIDLE.
+	 * Each caller tries to arm the hrtimer on its own CPU, but if the
+	 * hrtimer callbback function is currently running, then
+	 * hrtimer_start() cannot move it and the timer stays on the CPU on
+	 * which it is assigned at the moment.
+	 *
+	 * As this can be called from idle code, the hrtimer_start()
+	 * invocation has to be wrapped with RCU_NONIDLE() as
+	 * hrtimer_start() can call into tracing.
 	 */
-	RCU_NONIDLE(bc_moved =3D (hrtimer_try_to_cancel(&bctimer) >=3D 0) ?
-		!hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED) :
-			0);
-	if (bc_moved) {
-		/* Bind the "device" to the cpu */
-		bc->bound_on =3D smp_processor_id();
-	} else if (bc->bound_on =3D=3D smp_processor_id()) {
-		hrtimer_set_expires(&bctimer, expires);
-	}
+	RCU_NONIDLE( {
+		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
+		/*
+		 * The core tick broadcast mode expects bc->bound_on to be set
+		 * correctly to prevent a CPU which has the broadcast hrtimer
+		 * armed from going deep idle.
+		 *
+		 * As tick_broadcast_lock is held, nothing can change the cpu
+		 * base which was just established in hrtimer_start() above. So
+		 * the below access is safe even without holding the hrtimer
+		 * base lock.
+		 */
+		bc->bound_on =3D bctimer.base->cpu_base->cpu;
+	} );
 	return 0;
 }
=20
@@ -99,10 +107,7 @@ static enum hrtimer_restart bc_handler(struct hrtimer *=
t)
 {
 	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
=20
-	if (ce_broadcast_hrtimer.next_event.tv64 =3D=3D KTIME_MAX)
-		return HRTIMER_NORESTART;
-
-	return HRTIMER_RESTART;
+	return HRTIMER_NORESTART;
 }
=20
 void tick_setup_hrtimer_broadcast(void)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c1b53a5c491b..5b1370d0228d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3311,9 +3311,14 @@ static int show_traces_open(struct inode *inode, str=
uct file *file)
 	if (tracing_disabled)
 		return -ENODEV;
=20
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	ret =3D seq_open(file, &show_traces_seq_ops);
-	if (ret)
+	if (ret) {
+		trace_array_put(tr);
 		return ret;
+	}
=20
 	m =3D file->private_data;
 	m->private =3D tr;
@@ -3321,6 +3326,14 @@ static int show_traces_open(struct inode *inode, str=
uct file *file)
 	return 0;
 }
=20
+static int show_traces_release(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr =3D inode->i_private;
+
+	trace_array_put(tr);
+	return seq_release(inode, file);
+}
+
 static ssize_t
 tracing_write_stub(struct file *filp, const char __user *ubuf,
 		   size_t count, loff_t *ppos)
@@ -3351,8 +3364,8 @@ static const struct file_operations tracing_fops =3D {
 static const struct file_operations show_traces_fops =3D {
 	.open		=3D show_traces_open,
 	.read		=3D seq_read,
-	.release	=3D seq_release,
 	.llseek		=3D seq_lseek,
+	.release	=3D show_traces_release,
 };
=20
 /*
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index c30d07e99dba..72de6444934d 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -44,7 +44,12 @@ asmlinkage __visible void dump_stack(void)
 		was_locked =3D 1;
 	} else {
 		local_irq_restore(flags);
-		cpu_relax();
+		/*
+		 * Wait for the lock to release before jumping to
+		 * atomic_cmpxchg() in order to mitigate the thundering herd
+		 * problem.
+		 */
+		do { cpu_relax(); } while (atomic_read(&dump_lock) !=3D -1);
 		goto retry;
 	}
=20
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 493f758445e7..08b225f26eb2 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -181,7 +181,7 @@ int hugetlb_cgroup_charge_cgroup(int idx, unsigned long=
 nr_pages,
 again:
 	rcu_read_lock();
 	h_cg =3D hugetlb_cgroup_from_task(current);
-	if (!css_tryget_online(&h_cg->css)) {
+	if (!css_tryget(&h_cg->css)) {
 		rcu_read_unlock();
 		goto again;
 	}
diff --git a/mm/ksm.c b/mm/ksm.c
index 9d124cde0c9c..72b43cc6488c 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -715,13 +715,13 @@ static int remove_stable_node(struct stable_node *sta=
ble_node)
 		return 0;
 	}
=20
-	if (WARN_ON_ONCE(page_mapped(page))) {
-		/*
-		 * This should not happen: but if it does, just refuse to let
-		 * merge_across_nodes be switched - there is no need to panic.
-		 */
-		err =3D -EBUSY;
-	} else {
+	/*
+	 * Page could be still mapped if this races with __mmput() running in
+	 * between ksm_exit() and exit_mmap(). Just refuse to let
+	 * merge_across_nodes/max_page_sharing be switched.
+	 */
+	err =3D -EBUSY;
+	if (!page_mapped(page)) {
 		/*
 		 * The stable node did not yet appear stale to get_ksm_page(),
 		 * since that allows for an unmapped ksm page to be recognized
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 543a3e2e11c3..6916b9c056c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1073,7 +1073,7 @@ static struct mem_cgroup *get_mem_cgroup_from_mm(stru=
ct mm_struct *mm)
 			if (unlikely(!memcg))
 				memcg =3D root_mem_cgroup;
 		}
-	} while (!css_tryget_online(&memcg->css));
+	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 287f32c1d249..abceb76efb73 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4329,7 +4329,17 @@ static ssize_t show_slab_objects(struct kmem_cache *=
s,
 		}
 	}
=20
-	get_online_mems();
+	/*
+	 * It is impossible to take "mem_hotplug_lock" here with "kernfs_mutex"
+	 * already held which will conflict with an existing lock order:
+	 *
+	 * mem_hotplug_lock->slab_mutex->kernfs_mutex
+	 *
+	 * We don't really need mem_hotplug_lock (to hold off
+	 * slab_mem_going_offline_callback) here because slab's memory hot
+	 * unplug code doesn't destroy the kmem_cache->node[] data.
+	 */
+
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -4369,7 +4379,6 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			x +=3D sprintf(buf + x, " N%d=3D%lu",
 					node, nodes[node]);
 #endif
-	put_online_mems();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8272a99dce41..9b11dc5ff32b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1318,7 +1318,7 @@ static int __init setup_vmstat(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
-	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
+	proc_create("pagetypeinfo", 0400, NULL, &pagetypeinfo_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #endif
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index b5783804c90f..51fc5daf2984 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -26,6 +26,8 @@
 #include "bat_algo.h"
 #include "network-coding.h"
=20
+#include <linux/lockdep.h>
+#include <linux/mutex.h>
=20
 /**
  * batadv_dup_status - duplicate status
@@ -307,7 +309,8 @@ static int batadv_iv_ogm_iface_enable(struct batadv_har=
d_iface *hard_iface)
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	unsigned char *ogm_buff;
 	uint32_t random_seqno;
-	int res =3D -ENOMEM;
+
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
=20
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
@@ -315,8 +318,10 @@ static int batadv_iv_ogm_iface_enable(struct batadv_ha=
rd_iface *hard_iface)
=20
 	hard_iface->bat_iv.ogm_buff_len =3D BATADV_OGM_HLEN;
 	ogm_buff =3D kmalloc(hard_iface->bat_iv.ogm_buff_len, GFP_ATOMIC);
-	if (!ogm_buff)
-		goto out;
+	if (!ogm_buff) {
+		mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+		return -ENOMEM;
+	}
=20
 	hard_iface->bat_iv.ogm_buff =3D ogm_buff;
=20
@@ -328,39 +333,60 @@ static int batadv_iv_ogm_iface_enable(struct batadv_h=
ard_iface *hard_iface)
 	batadv_ogm_packet->reserved =3D 0;
 	batadv_ogm_packet->tq =3D BATADV_TQ_MAX_VALUE;
=20
-	res =3D 0;
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
=20
-out:
-	return res;
+	return 0;
 }
=20
 static void batadv_iv_ogm_iface_disable(struct batadv_hard_iface *hard_ifa=
ce)
 {
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	kfree(hard_iface->bat_iv.ogm_buff);
 	hard_iface->bat_iv.ogm_buff =3D NULL;
+
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
=20
 static void batadv_iv_ogm_iface_update_mac(struct batadv_hard_iface *hard_=
iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff =3D hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
=20
-	batadv_ogm_packet =3D (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff =3D hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet =3D ogm_buff;
 	ether_addr_copy(batadv_ogm_packet->orig,
 			hard_iface->net_dev->dev_addr);
 	ether_addr_copy(batadv_ogm_packet->prev_sender,
 			hard_iface->net_dev->dev_addr);
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
=20
 static void
 batadv_iv_ogm_primary_iface_set(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff =3D hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
=20
-	batadv_ogm_packet =3D (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff =3D hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet =3D ogm_buff;
 	batadv_ogm_packet->flags =3D BATADV_PRIMARIES_FIRST_HOP;
 	batadv_ogm_packet->ttl =3D BATADV_TTL;
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
=20
 /* when do we schedule our own ogm to be sent */
@@ -895,7 +921,11 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_har=
d_iface *hard_iface)
 	}
 }
=20
-static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+/**
+ * batadv_iv_ogm_schedule_buff() - schedule submission of hardif ogm buffer
+ * @hard_iface: interface whose ogm buffer should be transmitted
+ */
+static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_ifa=
ce)
 {
 	struct batadv_priv *bat_priv =3D netdev_priv(hard_iface->soft_iface);
 	unsigned char **ogm_buff =3D &hard_iface->bat_iv.ogm_buff;
@@ -906,6 +936,8 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_i=
face *hard_iface)
 	uint16_t tvlv_len =3D 0;
 	unsigned long send_time;
=20
+	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	primary_if =3D batadv_primary_if_get_selected(bat_priv);
=20
 	if (hard_iface =3D=3D primary_if) {
@@ -1564,6 +1596,13 @@ batadv_iv_ogm_process_per_outif(const struct sk_buff=
 *skb, int ogm_offset,
 	kfree_skb(skb_priv);
 }
=20
+static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+{
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+	batadv_iv_ogm_schedule_buff(hard_iface);
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+}
+
 /**
  * batadv_iv_ogm_process - process an incoming batman iv OGM
  * @skb: the skb containing the OGM
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interfac=
e.c
index 7086bdc4b6a7..facdc0a533fd 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -31,6 +31,7 @@
=20
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
+#include <linux/mutex.h>
=20
 void batadv_hardif_free_rcu(struct rcu_head *rcu)
 {
@@ -591,6 +592,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	INIT_WORK(&hard_iface->cleanup_work,
 		  batadv_hardif_remove_interface_finish);
=20
+	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	hard_iface->num_bcasts =3D BATADV_NUM_BCASTS_DEFAULT;
 	if (batadv_is_wifi_netdev(net_dev))
 		hard_iface->num_bcasts =3D BATADV_NUM_BCASTS_WIRELESS;
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index e43e4cb70421..0506b4a34b7a 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -68,6 +68,9 @@ struct batadv_hard_iface_bat_iv {
 	unsigned char *ogm_buff;
 	int ogm_buff_len;
 	atomic_t ogm_seqno;
+
+	/** @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len */
+	struct mutex ogm_buff_mutex;
 };
=20
 /**
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 755cf1459e93..ca9f3d8c0c69 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -122,7 +122,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *u=
addr, int addr_len)
 						    inet->inet_daddr,
 						    inet->inet_sport,
 						    inet->inet_dport);
-	inet->inet_id =3D dp->dccps_iss ^ jiffies;
+	inet->inet_id =3D prandom_u32();
=20
 	err =3D dccp_connect(sk);
 	rt =3D NULL;
@@ -420,7 +420,7 @@ struct sock *dccp_v4_request_recv_sock(struct sock *sk,=
 struct sk_buff *skb,
 	ireq->opt	   =3D NULL;
 	newinet->mc_index  =3D inet_iif(skb);
 	newinet->mc_ttl	   =3D ip_hdr(skb)->ttl;
-	newinet->inet_id   =3D jiffies;
+	newinet->inet_id   =3D prandom_u32();
=20
 	if (dst =3D=3D NULL && (dst =3D inet_csk_route_child_sock(sk, newsk, req)=
) =3D=3D NULL)
 		goto put_and_exit;
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index f0c307cb6196..eaddffcbe654 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -74,7 +74,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockad=
dr *uaddr, int addr_len
 	inet->inet_daddr =3D fl4->daddr;
 	inet->inet_dport =3D usin->sin_port;
 	sk->sk_state =3D TCP_ESTABLISHED;
-	inet->inet_id =3D jiffies;
+	inet->inet_id =3D prandom_u32();
=20
 	sk_dst_set(sk, &rt->dst);
 	err =3D 0;
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index bd5f5928167d..c2b97cdb2e72 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -485,6 +485,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *b=
ase,
 		atomic_set(&p->rid, 0);
 		p->metrics[RTAX_LOCK-1] =3D INETPEER_METRICS_NEW;
 		p->rate_tokens =3D 0;
+		p->n_redirects =3D 0;
 		/* 60*HZ is arbitrary, but chosen enough high so that the first
 		 * calculation of tokens is at its maximum.
 		 */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 858596c80e0e..803aaa7ce9ff 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -872,13 +872,15 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	/* No redirected packets during ip_rt_redirect_silence;
 	 * reset the algorithm.
 	 */
-	if (time_after(jiffies, peer->rate_last + ip_rt_redirect_silence))
+	if (time_after(jiffies, peer->rate_last + ip_rt_redirect_silence)) {
 		peer->rate_tokens =3D 0;
+		peer->n_redirects =3D 0;
+	}
=20
 	/* Too many ignored redirects; do not send anything
 	 * set dst.rate_last to the last seen redirected packet.
 	 */
-	if (peer->rate_tokens >=3D ip_rt_redirect_number) {
+	if (peer->n_redirects >=3D ip_rt_redirect_number) {
 		peer->rate_last =3D jiffies;
 		goto out_put_peer;
 	}
@@ -889,15 +891,15 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	if (peer->rate_tokens =3D=3D 0 ||
 	    time_after(jiffies,
 		       (peer->rate_last +
-			(ip_rt_redirect_load << peer->rate_tokens)))) {
+			(ip_rt_redirect_load << peer->n_redirects)))) {
 		__be32 gw =3D rt_nexthop(rt, ip_hdr(skb)->daddr);
=20
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last =3D jiffies;
-		++peer->rate_tokens;
+		++peer->n_redirects;
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 		if (log_martians &&
-		    peer->rate_tokens =3D=3D ip_rt_redirect_number)
+		    peer->n_redirects =3D=3D ip_rt_redirect_number)
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4=
\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
 					     &ip_hdr(skb)->daddr, &gw);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 201a2d9aebd7..d3a4cb33f5f0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -241,7 +241,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *ua=
ddr, int addr_len)
 							   inet->inet_sport,
 							   usin->sin_port);
=20
-	inet->inet_id =3D tp->write_seq ^ jiffies;
+	inet->inet_id =3D prandom_u32();
=20
 	err =3D tcp_connect(sk);
=20
@@ -1449,7 +1449,7 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk, st=
ruct sk_buff *skb,
 	inet_csk(newsk)->icsk_ext_hdr_len =3D 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len =3D inet_opt->opt.optlen;
-	newinet->inet_id =3D newtp->write_seq ^ jiffies;
+	newinet->inet_id =3D prandom_u32();
=20
 	if (!dst) {
 		dst =3D inet_csk_route_child_sock(sk, newsk, req);
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 05c94d9c3776..841ce63abe5f 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -151,6 +151,16 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *d=
ev, struct packet_type *pt
 	if (ipv6_addr_is_multicast(&hdr->saddr))
 		goto err;
=20
+	/* While RFC4291 is not explicit about v4mapped addresses
+	 * in IPv6 headers, it seems clear linux dual-stack
+	 * model can not deal properly with these.
+	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
+	 *
+	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
+	 */
+	if (ipv6_addr_v4mapped(&hdr->saddr))
+		goto err;
+
 	skb->transport_header =3D skb->network_header + sizeof(*hdr);
 	IP6CB(skb)->nhoff =3D offsetof(struct ipv6hdr, nexthdr);
=20
diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index a94bd56bcac6..7ae4cc684d3a 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -58,8 +58,10 @@ int llc_sap_action_send_ui(struct llc_sap *sap, struct s=
k_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 	rc =3D llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc =3D dev_queue_xmit(skb);
+	}
 	return rc;
 }
=20
@@ -81,8 +83,10 @@ int llc_sap_action_send_xid_c(struct llc_sap *sap, struc=
t sk_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_xid_cmd(skb, LLC_XID_NULL_CLASS_2, 0);
 	rc =3D llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc =3D dev_queue_xmit(skb);
+	}
 	return rc;
 }
=20
@@ -135,8 +139,10 @@ int llc_sap_action_send_test_c(struct llc_sap *sap, st=
ruct sk_buff *skb)
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_test_cmd(skb);
 	rc =3D llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-	if (likely(!rc))
+	if (likely(!rc)) {
+		skb_get(skb);
 		rc =3D dev_queue_xmit(skb);
+	}
 	return rc;
 }
=20
diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index cdc1b620cbe1..ca82c2a29f14 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -197,29 +197,22 @@ static int llc_sap_next_state(struct llc_sap *sap, st=
ruct sk_buff *skb)
  *	After executing actions of the event, upper layer will be indicated
  *	if needed(on receiving an UI frame). sk can be null for the
  *	datalink_proto case.
+ *
+ *	This function always consumes a reference to the skb.
  */
 static void llc_sap_state_process(struct llc_sap *sap, struct sk_buff *skb)
 {
 	struct llc_sap_state_ev *ev =3D llc_sap_ev(skb);
=20
-	/*
-	 * We have to hold the skb, because llc_sap_next_state
-	 * will kfree it in the sending path and we need to
-	 * look at the skb->cb, where we encode llc_sap_state_ev.
-	 */
-	skb_get(skb);
 	ev->ind_cfm_flag =3D 0;
 	llc_sap_next_state(sap, skb);
-	if (ev->ind_cfm_flag =3D=3D LLC_IND) {
-		if (skb->sk->sk_state =3D=3D TCP_LISTEN)
-			kfree_skb(skb);
-		else {
-			llc_save_primitive(skb->sk, skb, ev->prim);
=20
-			/* queue skb to the user. */
-			if (sock_queue_rcv_skb(skb->sk, skb))
-				kfree_skb(skb);
-		}
+	if (ev->ind_cfm_flag =3D=3D LLC_IND && skb->sk->sk_state !=3D TCP_LISTEN)=
 {
+		llc_save_primitive(skb->sk, skb, ev->prim);
+
+		/* queue skb to the user. */
+		if (sock_queue_rcv_skb(skb->sk, skb) =3D=3D 0)
+			return;
 	}
 	kfree_skb(skb);
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 85eb858a2ba2..130627eb7d67 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2046,7 +2046,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee=
80211_hw *hw,
=20
 	rcu_read_lock();
 	ssid =3D ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
-	if (WARN_ON_ONCE(ssid =3D=3D NULL))
+	if (WARN_ONCE(!ssid || ssid[1] > IEEE80211_MAX_SSID_LEN,
+		      "invalid SSID element (len=3D%d)", ssid ? ssid[1] : -1))
 		ssid_len =3D 0;
 	else
 		ssid_len =3D ssid[1];
@@ -4195,7 +4196,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data =
*sdata,
=20
 	rcu_read_lock();
 	ssidie =3D ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	if (!ssidie) {
+	if (!ssidie || ssidie[1] > sizeof(assoc_data->ssid)) {
 		rcu_read_unlock();
 		kfree(assoc_data);
 		return -EINVAL;
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set=
_core.c
index 59aaa4159a36..efed6315c695 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1860,8 +1860,9 @@ ip_set_sockfn_get(struct sock *sk, int optval, void _=
_user *user, int *len)
 		}
=20
 		req_version->version =3D IPSET_PROTOCOL;
-		ret =3D copy_to_user(user, req_version,
-				   sizeof(struct ip_set_req_version));
+		if (copy_to_user(user, req_version,
+				 sizeof(struct ip_set_req_version)))
+			ret =3D -EFAULT;
 		goto done;
 	}
 	case IP_SET_OP_GET_BYNAME: {
@@ -1918,7 +1919,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void _=
_user *user, int *len)
 	}	/* end of switch(op) */
=20
 copy:
-	ret =3D copy_to_user(user, data, copylen);
+	if (copy_to_user(user, data, copylen))
+		ret =3D -EFAULT;
=20
 done:
 	vfree(data);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 509405afd174..c9bf9d0cffd3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -97,7 +97,6 @@ static bool __ip_vs_addr_is_local_v6(struct net *net,
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp =3D 0;
 	int availmem;
 	int nomem;
 	int to_change =3D -1;
@@ -178,35 +177,35 @@ static void update_defense_level(struct netns_ipvs *i=
pvs)
 	spin_lock(&ipvs->securetcp_lock);
 	switch (ipvs->sysctl_secure_tcp) {
 	case 0:
-		if (old_secure_tcp >=3D 2)
+		if (ipvs->old_secure_tcp >=3D 2)
 			to_change =3D 0;
 		break;
 	case 1:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change =3D 1;
 			ipvs->sysctl_secure_tcp =3D 2;
 		} else {
-			if (old_secure_tcp >=3D 2)
+			if (ipvs->old_secure_tcp >=3D 2)
 				to_change =3D 0;
 		}
 		break;
 	case 2:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change =3D 1;
 		} else {
-			if (old_secure_tcp >=3D 2)
+			if (ipvs->old_secure_tcp >=3D 2)
 				to_change =3D 0;
 			ipvs->sysctl_secure_tcp =3D 1;
 		}
 		break;
 	case 3:
-		if (old_secure_tcp < 2)
+		if (ipvs->old_secure_tcp < 2)
 			to_change =3D 1;
 		break;
 	}
-	old_secure_tcp =3D ipvs->sysctl_secure_tcp;
+	ipvs->old_secure_tcp =3D ipvs->sysctl_secure_tcp;
 	if (to_change >=3D 0)
 		ip_vs_protocol_timeout_change(ipvs,
 					      ipvs->sysctl_secure_tcp > 1);
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 3e2982db97e5..39bd579e1b10 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -117,9 +117,14 @@ static int llcp_sock_bind(struct socket *sock, struct =
sockaddr *addr, int alen)
 	llcp_sock->service_name =3D kmemdup(llcp_addr.service_name,
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
-
+	if (!llcp_sock->service_name) {
+		ret =3D -ENOMEM;
+		goto put_dev;
+	}
 	llcp_sock->ssap =3D nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap =3D=3D LLCP_SAP_MAX) {
+		kfree(llcp_sock->service_name);
+		llcp_sock->service_name =3D NULL;
 		ret =3D -EADDRINUSE;
 		goto put_dev;
 	}
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index e7b0c7af46dc..1318a204c6d7 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -923,10 +923,15 @@ static int
 tcf_action_add(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	       u32 portid, int ovr)
 {
-	int ret =3D 0;
+	int loop, ret;
 	LIST_HEAD(actions);
=20
-	ret =3D tcf_action_init(net, nla, NULL, NULL, ovr, 0, &actions);
+	for (loop =3D 0; loop < 10; loop++) {
+		ret =3D tcf_action_init(net, nla, NULL, NULL, ovr, 0, &actions);
+		if (ret !=3D -EAGAIN)
+			break;
+	}
+
 	if (ret)
 		goto done;
=20
@@ -969,10 +974,7 @@ static int tc_ctl_action(struct sk_buff *skb, struct n=
lmsghdr *n)
 		 */
 		if (n->nlmsg_flags & NLM_F_REPLACE)
 			ovr =3D 1;
-replay:
 		ret =3D tcf_action_add(net, tca[TCA_ACT_TAB], n, portid, ovr);
-		if (ret =3D=3D -EAGAIN)
-			goto replay;
 		break;
 	case RTM_DELACTION:
 		ret =3D tca_action_gd(net, tca[TCA_ACT_TAB], n,
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 8f357a6eb150..a206c75a1d3d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -50,13 +50,13 @@ static int tcf_pedit_init(struct net *net, struct nlatt=
r *nla,
 	if (tb[TCA_PEDIT_PARMS] =3D=3D NULL)
 		return -EINVAL;
 	parm =3D nla_data(tb[TCA_PEDIT_PARMS]);
+	if (!parm->nkeys)
+		return -EINVAL;
 	ksize =3D parm->nkeys * sizeof(struct tc_pedit_key);
 	if (nla_len(tb[TCA_PEDIT_PARMS]) < sizeof(*parm) + ksize)
 		return -EINVAL;
=20
 	if (!tcf_hash_check(parm->index, a, bind)) {
-		if (!parm->nkeys)
-			return -EINVAL;
 		ret =3D tcf_hash_create(parm->index, est, a, sizeof(*p), bind);
 		if (ret)
 			return ret;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 56d1262d8593..e5e451f14abd 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1357,6 +1357,27 @@ static const struct nla_policy cbq_policy[TCA_CBQ_MA=
X + 1] =3D {
 	[TCA_CBQ_POLICE]	=3D { .len =3D sizeof(struct tc_cbq_police) },
 };
=20
+static int cbq_opt_parse(struct nlattr *tb[TCA_CBQ_MAX + 1],
+			 struct nlattr *opt)
+{
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err =3D nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_CBQ_WRROPT]) {
+		const struct tc_cbq_wrropt *wrr =3D nla_data(tb[TCA_CBQ_WRROPT]);
+
+		if (wrr->priority > TC_CBQ_MAXPRIO)
+			err =3D -EINVAL;
+	}
+	return err;
+}
+
 static int cbq_init(struct Qdisc *sch, struct nlattr *opt)
 {
 	struct cbq_sched_data *q =3D qdisc_priv(sch);
@@ -1368,10 +1389,7 @@ static int cbq_init(struct Qdisc *sch, struct nlattr=
 *opt)
 	hrtimer_init(&q->delay_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	q->delay_timer.function =3D cbq_undelay;
=20
-	if (!opt)
-		return -EINVAL;
-
-	err =3D nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	err =3D cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
=20
@@ -1751,10 +1769,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32=
 parentid, struct nlattr **t
 	struct cbq_class *parent;
 	struct qdisc_rate_table *rtab =3D NULL;
=20
-	if (opt =3D=3D NULL)
-		return -EINVAL;
-
-	err =3D nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy);
+	err =3D cbq_opt_parse(tb, opt);
 	if (err < 0)
 		return err;
=20
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 5571e7c076de..af794e6525be 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -359,6 +359,8 @@ static int dsmark_init(struct Qdisc *sch, struct nlattr=
 *opt)
 		goto errout;
=20
 	err =3D -EINVAL;
+	if (!tb[TCA_DSMARK_INDICES])
+		goto errout;
 	indices =3D nla_get_u16(tb[TCA_DSMARK_INDICES]);
=20
 	if (hweight32(indices) !=3D 1)
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 95df63bca928..a53cee11dec5 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -599,6 +599,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 		}
 		/* Parent qdiscs accounted for 1 skb of size @prev_len */
 		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
+	} else if (!skb) {
+		return NET_XMIT_DROP;
 	}
 	return NET_XMIT_SUCCESS;
 }
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b506cd9c1b82..b3ddb62e58d1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7006,7 +7006,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *=
sk,
 	newinet->inet_rcv_saddr =3D inet->inet_rcv_saddr;
 	newinet->inet_dport =3D htons(asoc->peer.port);
 	newinet->pmtudisc =3D inet->pmtudisc;
-	newinet->inet_id =3D asoc->next_tsn ^ jiffies;
+	newinet->inet_id =3D prandom_u32();
=20
 	newinet->uc_ttl =3D inet->uc_ttl;
 	newinet->mc_loop =3D 1;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d82d35aec0ee..cafec3788750 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -289,7 +289,8 @@ static const struct nla_policy nl80211_policy[NL80211_A=
TTR_MAX+1] =3D {
 	[NL80211_ATTR_MNTR_FLAGS] =3D { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] =3D { .type =3D NLA_BINARY,
 				   .len =3D IEEE80211_MAX_MESH_ID_LEN },
-	[NL80211_ATTR_MPATH_NEXT_HOP] =3D { .type =3D NLA_U32 },
+	[NL80211_ATTR_MPATH_NEXT_HOP] =3D { .type =3D NLA_BINARY,
+					  .len =3D ETH_ALEN },
=20
 	[NL80211_ATTR_REG_ALPHA2] =3D { .type =3D NLA_STRING, .len =3D 2 },
 	[NL80211_ATTR_REG_RULES] =3D { .type =3D NLA_NESTED },
diff --git a/sound/core/timer.c b/sound/core/timer.c
index d13bb1f905bf..3be976ce5832 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -241,7 +241,8 @@ static int snd_timer_check_master(struct snd_timer_inst=
ance *master)
 	return 0;
 }
=20
-static int snd_timer_close_locked(struct snd_timer_instance *timeri);
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put);
=20
 /*
  * open a timer instance
@@ -253,21 +254,23 @@ int snd_timer_open(struct snd_timer_instance **ti,
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *timeri =3D NULL;
+	struct device *card_dev_to_put =3D NULL;
 	int err;
=20
+	mutex_lock(&register_mutex);
 	if (tid->dev_class =3D=3D SNDRV_TIMER_CLASS_SLAVE) {
 		/* open a slave instance */
 		if (tid->dev_sclass <=3D SNDRV_TIMER_SCLASS_NONE ||
 		    tid->dev_sclass > SNDRV_TIMER_SCLASS_OSS_SEQUENCER) {
 			pr_debug("ALSA: timer: invalid slave class %i\n",
 				 tid->dev_sclass);
-			return -EINVAL;
+			err =3D -EINVAL;
+			goto unlock;
 		}
-		mutex_lock(&register_mutex);
 		timeri =3D snd_timer_instance_new(owner, NULL);
 		if (!timeri) {
-			mutex_unlock(&register_mutex);
-			return -ENOMEM;
+			err =3D -ENOMEM;
+			goto unlock;
 		}
 		timeri->slave_class =3D tid->dev_sclass;
 		timeri->slave_id =3D tid->device;
@@ -275,16 +278,13 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
 		err =3D snd_timer_check_slave(timeri);
 		if (err < 0) {
-			snd_timer_close_locked(timeri);
+			snd_timer_close_locked(timeri, &card_dev_to_put);
 			timeri =3D NULL;
 		}
-		mutex_unlock(&register_mutex);
-		*ti =3D timeri;
-		return err;
+		goto unlock;
 	}
=20
 	/* open a master instance */
-	mutex_lock(&register_mutex);
 	timer =3D snd_timer_find(tid);
 #ifdef CONFIG_MODULES
 	if (!timer) {
@@ -295,25 +295,26 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	}
 #endif
 	if (!timer) {
-		mutex_unlock(&register_mutex);
-		return -ENODEV;
+		err =3D -ENODEV;
+		goto unlock;
 	}
 	if (!list_empty(&timer->open_list_head)) {
-		timeri =3D list_entry(timer->open_list_head.next,
+		struct snd_timer_instance *t =3D
+			list_entry(timer->open_list_head.next,
 				    struct snd_timer_instance, open_list);
-		if (timeri->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
-			mutex_unlock(&register_mutex);
-			return -EBUSY;
+		if (t->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
+			err =3D -EBUSY;
+			goto unlock;
 		}
 	}
 	if (timer->num_instances >=3D timer->max_instances) {
-		mutex_unlock(&register_mutex);
-		return -EBUSY;
+		err =3D -EBUSY;
+		goto unlock;
 	}
 	timeri =3D snd_timer_instance_new(owner, timer);
 	if (!timeri) {
-		mutex_unlock(&register_mutex);
-		return -ENOMEM;
+		err =3D -ENOMEM;
+		goto unlock;
 	}
 	/* take a card refcount for safe disconnection */
 	if (timer->card)
@@ -322,16 +323,16 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	timeri->slave_id =3D slave_id;
=20
 	if (list_empty(&timer->open_list_head) && timer->hw.open) {
-		int err =3D timer->hw.open(timer);
+		err =3D timer->hw.open(timer);
 		if (err) {
 			kfree(timeri->owner);
 			kfree(timeri);
+			timeri =3D NULL;
=20
 			if (timer->card)
-				put_device(&timer->card->card_dev);
+				card_dev_to_put =3D &timer->card->card_dev;
 			module_put(timer->module);
-			mutex_unlock(&register_mutex);
-			return err;
+			goto unlock;
 		}
 	}
=20
@@ -339,10 +340,15 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	timer->num_instances++;
 	err =3D snd_timer_check_master(timeri);
 	if (err < 0) {
-		snd_timer_close_locked(timeri);
+		snd_timer_close_locked(timeri, &card_dev_to_put);
 		timeri =3D NULL;
 	}
+
+ unlock:
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	*ti =3D timeri;
 	return err;
 }
@@ -351,7 +357,8 @@ int snd_timer_open(struct snd_timer_instance **ti,
  * close a timer instance
  * call this with register_mutex down.
  */
-static int snd_timer_close_locked(struct snd_timer_instance *timeri)
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put)
 {
 	struct snd_timer *timer =3D NULL;
 	struct snd_timer_instance *slave, *tmp;
@@ -403,7 +410,7 @@ static int snd_timer_close_locked(struct snd_timer_inst=
ance *timeri)
 			timer->hw.close(timer);
 		/* release a card refcount for safe disconnection */
 		if (timer->card)
-			put_device(&timer->card->card_dev);
+			*card_devp_to_put =3D &timer->card->card_dev;
 		module_put(timer->module);
 	}
=20
@@ -415,14 +422,18 @@ static int snd_timer_close_locked(struct snd_timer_in=
stance *timeri)
  */
 int snd_timer_close(struct snd_timer_instance *timeri)
 {
+	struct device *card_dev_to_put =3D NULL;
 	int err;
=20
 	if (snd_BUG_ON(!timeri))
 		return -ENXIO;
=20
 	mutex_lock(&register_mutex);
-	err =3D snd_timer_close_locked(timeri);
+	err =3D snd_timer_close_locked(timeri, &card_dev_to_put);
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	return err;
 }
=20
diff --git a/sound/firewire/bebob/bebob_focusrite.c b/sound/firewire/bebob/=
bebob_focusrite.c
index 3b052ed0fbf5..958eaa3f656b 100644
--- a/sound/firewire/bebob/bebob_focusrite.c
+++ b/sound/firewire/bebob/bebob_focusrite.c
@@ -28,6 +28,8 @@
 #define SAFFIRE_CLOCK_SOURCE_SPDIF		1
=20
 /* clock sources as returned from register of Saffire Pro 10 and 26 */
+#define SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK	0x000000ff
+#define SAFFIREPRO_CLOCK_SOURCE_DETECT_MASK	0x0000ff00
 #define SAFFIREPRO_CLOCK_SOURCE_INTERNAL	0
 #define SAFFIREPRO_CLOCK_SOURCE_SKIP		1 /* never used on hardware */
 #define SAFFIREPRO_CLOCK_SOURCE_SPDIF		2
@@ -184,6 +186,7 @@ saffirepro_both_clk_src_get(struct snd_bebob *bebob, un=
signed int *id)
 		map =3D saffirepro_clk_maps[1];
=20
 	/* In a case that this driver cannot handle the value of register. */
+	value &=3D SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK;
 	if (value >=3D SAFFIREPRO_CLOCK_SOURCE_COUNT || map[value] < 0) {
 		err =3D -EIO;
 		goto end;
diff --git a/sound/firewire/bebob/bebob_stream.c b/sound/firewire/bebob/beb=
ob_stream.c
index c05b0f6c1bc2..2ea26980f5aa 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -196,8 +196,7 @@ snd_bebob_stream_check_internal_clock(struct snd_bebob =
*bebob, bool *internal)
 	return err;
 }
=20
-static unsigned int
-map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
+static int map_data_channels(struct snd_bebob *bebob, struct amdtp_stream =
*s)
 {
 	unsigned int sec, sections, ch, channels;
 	unsigned int pcm, midi, location;
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwoo=
d-i2s.c
index 9f842222e798..4d6b6d4b0fb0 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -557,10 +557,6 @@ static int kirkwood_i2s_dev_probe(struct platform_devi=
ce *pdev)
 		return PTR_ERR(priv->clk);
 	}
=20
-	err =3D clk_prepare_enable(priv->clk);
-	if (err < 0)
-		return err;
-
 	priv->extclk =3D devm_clk_get(&pdev->dev, "extclk");
 	if (IS_ERR(priv->extclk)) {
 		if (PTR_ERR(priv->extclk) =3D=3D -EPROBE_DEFER)
@@ -576,6 +572,10 @@ static int kirkwood_i2s_dev_probe(struct platform_devi=
ce *pdev)
 		}
 	}
=20
+	err =3D clk_prepare_enable(priv->clk);
+	if (err < 0)
+		return err;
+
 	/* Some sensible defaults - this reflects the powerup values */
 	priv->ctl_play =3D KIRKWOOD_PLAYCTL_SIZE_24;
 	priv->ctl_rec =3D KIRKWOOD_RECCTL_SIZE_24;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 0f95338aa81d..94071f591833 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -377,6 +377,9 @@ static void snd_complete_urb(struct urb *urb)
 		}
=20
 		prepare_outbound_urb(ep, ctx);
+		/* can be stopped during prepare callback */
+		if (unlikely(!test_bit(EP_FLAG_RUNNING, &ep->flags)))
+			goto exit_clear;
 	} else {
 		retire_inbound_urb(ep, ctx);
 		/* can be stopped during retire callback */
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 158c84b79103..68774e172a66 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1014,7 +1014,8 @@ static int get_min_max_with_quirks(struct usb_mixer_e=
lem_info *cval,
 		if (cval->min + cval->res < cval->max) {
 			int last_valid_res =3D cval->res;
 			int saved, test, check;
-			get_cur_mix_raw(cval, minchn, &saved);
+			if (get_cur_mix_raw(cval, minchn, &saved) < 0)
+				goto no_res_check;
 			for (;;) {
 				test =3D saved;
 				if (test < cval->max)
@@ -1034,6 +1035,7 @@ static int get_min_max_with_quirks(struct usb_mixer_e=
lem_info *cval,
 			set_cur_mix_value(cval, minchn, 0, saved);
 		}
=20
+no_res_check:
 		cval->initialized =3D 1;
 	}
=20
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c2ab3677d524..771ba6efd0ed 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1032,7 +1032,7 @@ void hists__collapse_resort(struct hists *hists, stru=
ct ui_progress *prog)
 	}
 }
=20
-static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
+static int64_t hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
 	struct perf_hpp_fmt *fmt;
 	int64_t cmp =3D 0;

--a8Wt8u1KmwUX3Y2C--

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl37rc4ACgkQ57/I7JWG
EQniGhAA07kn7Z3/HAAaVNpmkiOBJ7N2+r//+NZIE3XJ1XDeOtx4KKJINv6l7/gH
3ifBxWWkCte/MQKKIzx54k1GEdfpjJ/dFqn2vJYC+CYf11VqKs/+NbxXfNo2R58h
9SBrQ4PvlrITJTOQH0tw5e2OrGSAmjzmjFzFjQRI2gwjb3I/hHJt96D8+eg2VLht
ked56dLGceoiwtBdSLRPz4CPA1lRgsF/8+EQgeNxo0sGBwd8niMkXlyDr2UxAbyI
DHRgG0d10OCbmJXzEW+vNa3a4ZAZ5HWI/1+XzkHKq+sTa6wBQLs8jMWokon0rGTg
mdQvRV9/C5aP3DmJAF1uGbygIUeKl5KY2NqMJqO7hOHH7SHP3C1gL9nHF79Yx6CH
Puk0fZaPJIXgczGpqvIaEafInRLUkAF+Vl5AStTaDWA9vtnHGIlzJYuxkN8xezVm
AshieAsZruYETNAMhAsPafpc7Jg0/Td9bJoWXnw77T9Fun+V5JZqB30kbamLMLTz
b8bDLxLMCX7oLF7Nl9JbQgRthsatwiaO+3O2VVEjGx+NdqUuQBbWexg2czp5bB6C
GWRzB17XGHtAu6L1sNY/1xOCZWQUsM7Ncap+hCBJMZfdYLF81yCGEd5hk0yxPrBN
YC42F5fqxbOkIN/Pj/312yxWJtHr1jHt43MQsIspE32ySJlu7B0=
=nmgN
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
