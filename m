Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD06F16A4
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 14:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfKFNHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 08:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfKFNHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 08:07:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD58B207FA;
        Wed,  6 Nov 2019 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573045623;
        bh=9kP1d/Y1EFhvym5chtqisgHg7+dhB2k9gkbuS45A0fs=;
        h=Date:From:To:Cc:Subject:From;
        b=SMU+64Fs5nG8/zhwlLJkaiBqzODZY+PBRY9u6BzSnce1L0KEcilDfFhC7+54n3Yvi
         0P6Z/AsK3FH+H5U34AJrPqiAsGpdi1Xmxl1RAq6W7zqP++U1Xi/3HOcwyRfSM5a0pE
         +QUrOe7GqbAdm1cJlcTvaBtNaSCIVrUGUBmd7IA8=
Date:   Wed, 6 Nov 2019 14:07:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.152
Message-ID: <20191106130700.GA3247971@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.152 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt  |    4=20
 Makefile                                         |    2=20
 arch/arm64/include/asm/pgtable-prot.h            |   15 +
 arch/arm64/kernel/ftrace.c                       |    8 -
 arch/mips/fw/sni/sniprom.c                       |    2=20
 arch/mips/include/asm/cmpxchg.h                  |    9 -
 arch/powerpc/platforms/powernv/memtrace.c        |    4=20
 arch/s390/include/asm/uaccess.h                  |    4=20
 arch/s390/kernel/idle.c                          |   29 ++-
 arch/s390/mm/cmm.c                               |   12 -
 arch/x86/events/amd/core.c                       |   30 ++-
 arch/x86/include/asm/intel-family.h              |    3=20
 arch/x86/platform/efi/efi.c                      |    3=20
 arch/x86/xen/enlighten.c                         |   28 +++
 drivers/block/nbd.c                              |   25 ++-
 drivers/block/zram/zram_drv.c                    |    5=20
 drivers/clk/imgtec/clk-boston.c                  |   18 +-
 drivers/dma/cppi41.c                             |   21 ++
 drivers/firmware/efi/cper.c                      |    2=20
 drivers/gpio/gpio-max77620.c                     |    6=20
 drivers/hid/hid-axff.c                           |   11 +
 drivers/hid/hid-core.c                           |    7=20
 drivers/hid/hid-dr.c                             |   12 +
 drivers/hid/hid-emsff.c                          |   12 +
 drivers/hid/hid-gaff.c                           |   12 +
 drivers/hid/hid-holtekff.c                       |   12 +
 drivers/hid/hid-hyperv.c                         |   56 +------
 drivers/hid/hid-input.c                          |    3=20
 drivers/hid/hid-lg2ff.c                          |   12 +
 drivers/hid/hid-lg3ff.c                          |   11 +
 drivers/hid/hid-lg4ff.c                          |   11 +
 drivers/hid/hid-lgff.c                           |   11 +
 drivers/hid/hid-logitech-hidpp.c                 |   11 +
 drivers/hid/hid-sony.c                           |   12 +
 drivers/hid/hid-tmff.c                           |   12 +
 drivers/hid/hid-zpff.c                           |   12 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c         |   35 ++++
 drivers/iio/accel/bmc150-accel-core.c            |    2=20
 drivers/iio/adc/meson_saradc.c                   |   10 -
 drivers/infiniband/core/cma.c                    |    3=20
 drivers/infiniband/hw/hfi1/sdma.c                |    5=20
 drivers/md/dm-bio-prison-v1.c                    |    2=20
 drivers/md/dm-bio-prison-v2.c                    |    2=20
 drivers/md/dm-io.c                               |    2=20
 drivers/md/dm-kcopyd.c                           |    2=20
 drivers/md/dm-region-hash.c                      |    2=20
 drivers/md/dm-snap.c                             |  178 +++++++++++++++---=
-----
 drivers/md/dm-thin.c                             |    2=20
 drivers/media/platform/vimc/vimc-sensor.c        |    7=20
 drivers/net/bonding/bond_main.c                  |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |   62 +++++---
 drivers/net/usb/sr9800.c                         |    2=20
 drivers/net/wireless/ath/ath6kl/usb.c            |    8 +
 drivers/net/wireless/realtek/rtlwifi/ps.c        |    6=20
 drivers/nfc/pn533/usb.c                          |    9 +
 drivers/pci/pcie/pme.c                           |    1=20
 drivers/power/supply/max14656_charger_detector.c |   17 +-
 drivers/rtc/rtc-pcf8523.c                        |   28 ++-
 drivers/scsi/lpfc/lpfc_scsi.c                    |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |    6=20
 drivers/target/iscsi/cxgbit/cxgbit_cm.c          |    3=20
 drivers/thunderbolt/nhi.c                        |   22 ++
 drivers/tty/n_hdlc.c                             |    5=20
 drivers/tty/serial/owl-uart.c                    |    2=20
 drivers/tty/serial/sc16is7xx.c                   |   28 +++
 drivers/tty/serial/serial_mctrl_gpio.c           |    3=20
 drivers/usb/core/hub.c                           |    7=20
 drivers/usb/gadget/udc/core.c                    |   11 +
 drivers/usb/misc/ldusb.c                         |    6=20
 drivers/usb/misc/legousbtower.c                  |    2=20
 drivers/usb/serial/whiteheat.c                   |   13 +
 drivers/usb/serial/whiteheat.h                   |    2=20
 drivers/usb/storage/scsiglue.c                   |   10 -
 drivers/usb/storage/uas.c                        |   20 --
 fs/binfmt_script.c                               |   57 ++++++-
 fs/cifs/netmisc.c                                |    4=20
 fs/f2fs/super.c                                  |    6=20
 fs/fuse/dir.c                                    |   13 +
 fs/fuse/file.c                                   |   10 -
 fs/nfs/nfs4proc.c                                |    1=20
 fs/nfs/write.c                                   |    5=20
 fs/ocfs2/aops.c                                  |   25 ++-
 fs/ocfs2/ioctl.c                                 |    2=20
 fs/ocfs2/xattr.c                                 |   56 ++-----
 fs/xfs/xfs_buf.c                                 |    2=20
 include/net/llc_conn.h                           |    2=20
 include/net/sch_generic.h                        |    5=20
 include/net/sctp/sctp.h                          |    2=20
 kernel/sched/cputime.c                           |    6=20
 kernel/trace/trace.c                             |    1=20
 net/llc/llc_c_ac.c                               |    8 -
 net/llc/llc_conn.c                               |   32 +---
 net/llc/llc_s_ac.c                               |   12 +
 net/llc/llc_sap.c                                |   23 +-
 net/rxrpc/sendmsg.c                              |    1=20
 net/sched/sch_api.c                              |    2=20
 net/sched/sch_netem.c                            |    2=20
 net/sctp/ipv6.c                                  |    2=20
 net/sctp/protocol.c                              |    2=20
 net/sctp/socket.c                                |   55 +++----
 net/wireless/nl80211.c                           |    3=20
 scripts/setlocalversion                          |   12 +
 sound/core/timer.c                               |   63 ++++----
 sound/firewire/bebob/bebob_stream.c              |    3=20
 sound/hda/hdac_controller.c                      |    2=20
 sound/pci/hda/hda_intel.c                        |    2=20
 sound/pci/hda/patch_realtek.c                    |   15 +
 tools/lib/subcmd/Makefile                        |    8 -
 tools/perf/pmu-events/jevents.c                  |   12 -
 tools/perf/tests/perf-hooks.c                    |    3=20
 tools/perf/util/map.c                            |    3=20
 111 files changed, 959 insertions(+), 479 deletions(-)

Aaron Ma (1):
      ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Adam Ford (1):
      serial: mctrl_gpio: Check for NULL pointer

Alan Stern (4):
      UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gathe=
r segments")
      USB: gadget: Reject endpoints with 0 maxpacket value
      usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_bound=
ary_mask to avoid SG overflows")
      HID: Fix assumption that devices have inputs

Andi Kleen (1):
      perf jevents: Fix period for Intel fixed counters

Austin Kim (1):
      fs: cifs: mute -Wunused-const-variable message

Bart Van Assche (2):
      RDMA/iwcm: Fix a lock inversion issue
      scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Boris Ostrovsky (1):
      x86/xen: Return from panic notifier

Brian Norris (1):
      scripts/setlocalversion: Improve -dirty check with git-status --no-op=
tional-locks

Catalin Marinas (1):
      arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Christian Borntraeger (1):
      s390/uaccess: avoid (false positive) compiler warnings

Christophe JAILLET (1):
      tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'

Chuck Lever (1):
      NFSv4: Fix leak of clp->cl_acceptor string

Cong Wang (1):
      net_sched: check cops->tcf_block in tc_bind_tclass()

Connor Kuehl (1):
      staging: rtl8188eu: fix null dereference when kzalloc fails

Dan Carpenter (1):
      USB: legousbtower: fix a signedness bug in tower_probe()

Dave Young (1):
      efi/x86: Do not clean dummy variable in kexec path

David Hildenbrand (1):
      powerpc/powernv: hold device_hotplug_lock when calling memtrace_offli=
ne_pages()

David Howells (1):
      rxrpc: Fix call ref leak

Dexuan Cui (1):
      HID: hyperv: Use in-place iterator API in the channel callback

Eric Biggers (2):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()

Eric Dumazet (2):
      bonding: fix potential NULL deref in bond_update_slave_arr
      sch_netem: fix rcu splat in netem_enqueue()

Frederic Weisbecker (1):
      sched/vtime: Fix guest/system mis-accounting on task switch

Greg Kroah-Hartman (1):
      Linux 4.14.152

Hans de Goede (2):
      HID: i2c-hid: Add Odys Winbook 13 to descriptor override
      HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Heiko Carstens (1):
      s390/idle: fix cpu idle time calculation

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Ian Rogers (2):
      libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature
      perf tests: Avoid raising SEGV using an obvious NULL dereference

Jaegeuk Kim (1):
      f2fs: flush quota blocks after turnning it off

James Morse (1):
      arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1=
542419

James Smart (1):
      scsi: lpfc: Fix a duplicate 0711 log message number.

Jan-Marek Glogowski (1):
      usb: handle warm-reset port requests on hub resume

Jia Guo (1):
      ocfs2: clear zero in unaligned direct IO

Jia-Ju Bai (3):
      fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare=
_entry()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end=
_nolock()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan=
_inode_alloc()

Johan Hovold (5):
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness
      NFC: pn533: fix use-after-free and memleaks

Julian Sax (1):
      HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override

Kailang Yang (1):
      ALSA: hda/realtek - Add support for ALC623

Kan Liang (1):
      x86/cpu: Add Atom Tremont (Jacobsville)

Kees Cook (1):
      exec: load_script: Do not exec truncated interpreter path

Kent Overstreet (1):
      dm: Use kzalloc for all structs with embedded biosets/mempools

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Lucas A. M. Magalh=C3=A3es (1):
      media: vimc: Remove unused but set variables

Lukas Wunner (1):
      efi/cper: Fix endianness of PCIe class code

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Micha=C5=82 Miros=C5=82aw (1):
      HID: fix error message in hid_open_report()

Mika Westerberg (1):
      thunderbolt: Use 32-bit writes when writing ring producer/consumer

Mike Christie (1):
      nbd: verify socket is supported during setup

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Mikulas Patocka (3):
      dm snapshot: use mutex instead of rw_semaphore
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock

NOGUCHI Hiroshi (1):
      HID: Add ASUS T100CHI keyboard dock battery quirks

Navid Emamdoost (1):
      RDMA/hfi1: Prevent memory leak in sdma_init

Nir Dotan (1):
      mlxsw: spectrum: Set LAG port collector only when active

Pascal Bouwmann (1):
      iio: fix center temperature of bmc150-accel-core

Petr Mladek (1):
      tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Phil Elwell (1):
      sc16is7xx: Fix for "Unexpected interrupt: 8"

Randy Dunlap (1):
      tty: n_hdlc: fix build on SPARC

Remi Pommarel (1):
      iio: adc: meson_saradc: Fix memory allocation order

Sam Ravnborg (1):
      rtc: pcf8523: set xtal load capacitance from DT

Sasha Levin (1):
      zram: fix race between backing_dev_show and backing_dev_store

Steve MacLean (1):
      perf map: Fix overlapped map handling

Sven Van Asbroeck (2):
      PCI/PME: Fix possible use-after-free on remove
      power: supply: max14656: fix potential use-after-free

Takashi Iwai (4):
      ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume
      ALSA: timer: Simplify error path in snd_timer_open()
      ALSA: timer: Fix mutex deadlock at releasing card
      Revert "ALSA: hda: Flush interrupts on disabling"

Takashi Sakamoto (1):
      ALSA: bebob: Fix prototype of helper function to return negative value

Thierry Reding (1):
      gpio: max77620: Use correct unit for debounce times

Thomas Bogendoerfer (3):
      MIPS: include: Mark __cmpxchg as __always_inline
      MIPS: include: Mark __xchg as __always_inline
      MIPS: fw: sni: Fix out of bounds init of o32 stack

Tom Lendacky (1):
      perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Tony Lindgren (1):
      dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Vratislav Bendel (1):
      xfs: Correctly invert xfs_buftarg LRU isolation logic

Xin Long (2):
      sctp: fix the issue that flags are ignored when using kernel_connect
      sctp: not bind the socket in sctp_connect

Xiubo Li (1):
      nbd: fix possible sysfs duplicate warning

Yi Wang (1):
      clk: boston: unregister clks on failure in clk_boston_setup()

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()

ZhangXiaoxu (1):
      nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3CxXQACgkQONu9yGCS
aT48PxAArDwun50iViWcp6QLoaWsmIfmJG3hi1MhtkEBMLOLsOxS7GyL2UFhV0Yd
vMMajuUowr6RLfEj4WWXGqE8jkwNSfZTXSrLVYt4D9Q+IZ0ElL/U8M0s2VtoEVG2
fbk397Ihi5D1G4LSng3GRfm+2smCaNWEOjjbUZj5tqqs2UVEYwkkVza2WXvLp4uF
Rg6ac7J5cfnH/XuOvKxTBOuXN4MjQSLM8vf6gGjk/OIoWrtwjjswmrX1uezJhoDm
xduABzEqBVeOHolNwjguObegOclQeWuV8p8mIxX98/Z4uFUzjDsnm3H+ZGuwS36/
SlxZWNq+RSz5UjUTsyoU9OXGxCOd1a9q1w088HhX5ZaxIweajn9q5x1a/x8oWdJh
Hom0iHSPe+eBknlYPynObBVqbyf5ITDCD7JzLE+yIc3uo+MznTeEI/3EbQ+GEfNI
Wq4KRJndzKKDfV3afW28LFDvPqKUQXAJ8DQmTucMCJ1Hhw5ANXb5Cw3Q8Q7UR7m5
FQfEDUKmJGBEfvVbUY+WT6ywoO5gNfPxc0DR+PMe7aDdAl9IX0SMPveicCt9GX8J
L3MNlfgEpqSNxaSrYtbUDEwuheU63lMkbs58saSeH2fRMsQD2iN+XHrUkl5PsheE
ae/OP5m/vFHN45nOJ5L4v/n86Gck0ZrMAn6KaoIAvO2a7AfCowA=
=UU5H
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
