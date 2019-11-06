Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDF3F1698
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 14:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfKFNGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 08:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbfKFNGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 08:06:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBA7217F4;
        Wed,  6 Nov 2019 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573045561;
        bh=91PYUfqUCzLv8NiwThz+K99+CJocBD0WEzANA98OLZY=;
        h=Date:From:To:Cc:Subject:From;
        b=eTmINooa8Kky5he2JogjlJfj1abhYMeOa3ZIy0MPJYguzbLW4D3R+E+j225aGsIYe
         9qLhSpReNdhKm8z685B+rHDxpswC8CNo2F06+U6TkUQK2/r/DLhLn8Zqj60ALajiIO
         DPQX3jzlNZya9hZgz/xFWxc6JswxMVkieaw4UVKs=
Date:   Wed, 6 Nov 2019 14:05:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.199
Message-ID: <20191106130558.GA3240034@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.199 kernel.

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

 Makefile                                    |    2=20
 arch/mips/fw/sni/sniprom.c                  |    2=20
 arch/s390/include/asm/uaccess.h             |    4=20
 arch/s390/mm/cmm.c                          |   12 -
 arch/x86/include/asm/intel-family.h         |    3=20
 arch/x86/platform/efi/efi.c                 |    3=20
 drivers/dma/cppi41.c                        |   21 +++
 drivers/firmware/efi/cper.c                 |    2=20
 drivers/gpio/gpio-max77620.c                |    6=20
 drivers/hid/hid-axff.c                      |   11 +
 drivers/hid/hid-core.c                      |    7 -
 drivers/hid/hid-dr.c                        |   12 +
 drivers/hid/hid-emsff.c                     |   12 +
 drivers/hid/hid-gaff.c                      |   12 +
 drivers/hid/hid-holtekff.c                  |   12 +
 drivers/hid/hid-lg2ff.c                     |   12 +
 drivers/hid/hid-lg3ff.c                     |   11 +
 drivers/hid/hid-lg4ff.c                     |   11 +
 drivers/hid/hid-lgff.c                      |   11 +
 drivers/hid/hid-logitech-hidpp.c            |   11 +
 drivers/hid/hid-sony.c                      |   12 +
 drivers/hid/hid-tmff.c                      |   12 +
 drivers/hid/hid-zpff.c                      |   12 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c    |   35 +++++
 drivers/iio/accel/bmc150-accel-core.c       |    2=20
 drivers/infiniband/core/cma.c               |    3=20
 drivers/md/dm-bio-prison.c                  |    2=20
 drivers/md/dm-io.c                          |    2=20
 drivers/md/dm-kcopyd.c                      |    2=20
 drivers/md/dm-region-hash.c                 |    2=20
 drivers/md/dm-snap.c                        |  178 ++++++++++++++++++-----=
-----
 drivers/md/dm-thin.c                        |    2=20
 drivers/net/bonding/bond_main.c             |    2=20
 drivers/net/usb/sr9800.c                    |    2=20
 drivers/net/wireless/ath/ath6kl/usb.c       |    8 +
 drivers/net/wireless/realtek/rtlwifi/ps.c   |    6=20
 drivers/rtc/rtc-pcf8523.c                   |   28 +++-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    6=20
 drivers/thunderbolt/nhi.c                   |   22 ++-
 drivers/tty/serial/sc16is7xx.c              |   28 ++++
 drivers/tty/serial/serial_mctrl_gpio.c      |    3=20
 drivers/usb/core/hub.c                      |    7 +
 drivers/usb/gadget/udc/core.c               |   11 +
 drivers/usb/misc/ldusb.c                    |    6=20
 drivers/usb/misc/legousbtower.c             |    2=20
 drivers/usb/serial/whiteheat.c              |   13 +-
 drivers/usb/serial/whiteheat.h              |    2=20
 drivers/usb/storage/scsiglue.c              |   10 -
 drivers/usb/storage/uas.c                   |   20 ---
 fs/binfmt_script.c                          |   57 +++++++-
 fs/cifs/netmisc.c                           |    4=20
 fs/fuse/dir.c                               |   13 ++
 fs/fuse/file.c                              |   10 +
 fs/nfs/nfs4proc.c                           |    1=20
 fs/ocfs2/aops.c                             |   25 +++
 fs/ocfs2/ioctl.c                            |    2=20
 fs/ocfs2/xattr.c                            |   56 +++-----
 fs/xfs/xfs_buf.c                            |    2=20
 include/net/llc_conn.h                      |    2=20
 include/net/sch_generic.h                   |    5=20
 include/net/sctp/sctp.h                     |    2=20
 include/sound/timer.h                       |    2=20
 kernel/trace/trace.c                        |    1=20
 net/llc/llc_c_ac.c                          |    8 -
 net/llc/llc_conn.c                          |   32 +----
 net/llc/llc_s_ac.c                          |   12 +
 net/llc/llc_sap.c                           |   23 +--
 net/sched/sch_netem.c                       |    2=20
 net/sctp/ipv6.c                             |    2=20
 net/sctp/protocol.c                         |    2=20
 net/sctp/socket.c                           |   55 ++++----
 net/wireless/nl80211.c                      |    3=20
 scripts/setlocalversion                     |   12 +
 sound/core/hrtimer.c                        |    1=20
 sound/core/timer.c                          |  141 +++++++++++++++-------
 sound/firewire/bebob/bebob_stream.c         |    3=20
 sound/hda/hdac_controller.c                 |    2=20
 sound/pci/hda/hda_intel.c                   |    2=20
 tools/perf/pmu-events/jevents.c             |   12 -
 tools/perf/util/map.c                       |    3=20
 80 files changed, 754 insertions(+), 360 deletions(-)

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

Bart Van Assche (1):
      RDMA/iwcm: Fix a lock inversion issue

Brian Norris (1):
      scripts/setlocalversion: Improve -dirty check with git-status --no-op=
tional-locks

Christian Borntraeger (1):
      s390/uaccess: avoid (false positive) compiler warnings

Chuck Lever (1):
      NFSv4: Fix leak of clp->cl_acceptor string

Connor Kuehl (1):
      staging: rtl8188eu: fix null dereference when kzalloc fails

Dan Carpenter (1):
      USB: legousbtower: fix a signedness bug in tower_probe()

Dave Young (1):
      efi/x86: Do not clean dummy variable in kexec path

Eric Biggers (2):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()

Eric Dumazet (2):
      bonding: fix potential NULL deref in bond_update_slave_arr
      sch_netem: fix rcu splat in netem_enqueue()

Greg Kroah-Hartman (1):
      Linux 4.9.199

Hans de Goede (2):
      HID: i2c-hid: Add Odys Winbook 13 to descriptor override
      HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

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

Johan Hovold (4):
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness

Julian Sax (1):
      HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override

Kan Liang (1):
      x86/cpu: Add Atom Tremont (Jacobsville)

Kees Cook (1):
      exec: load_script: Do not exec truncated interpreter path

Kent Overstreet (1):
      dm: Use kzalloc for all structs with embedded biosets/mempools

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Lukas Wunner (1):
      efi/cper: Fix endianness of PCIe class code

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Micha=C5=82 Miros=C5=82aw (1):
      HID: fix error message in hid_open_report()

Mika Westerberg (1):
      thunderbolt: Use 32-bit writes when writing ring producer/consumer

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Mikulas Patocka (3):
      dm snapshot: use mutex instead of rw_semaphore
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock

Pascal Bouwmann (1):
      iio: fix center temperature of bmc150-accel-core

Petr Mladek (1):
      tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Phil Elwell (1):
      sc16is7xx: Fix for "Unexpected interrupt: 8"

Sam Ravnborg (1):
      rtc: pcf8523: set xtal load capacitance from DT

Steve MacLean (1):
      perf map: Fix overlapped map handling

Takashi Iwai (5):
      ALSA: timer: Follow standard EXPORT_SYMBOL() declarations
      ALSA: timer: Limit max instances per timer
      ALSA: timer: Simplify error path in snd_timer_open()
      ALSA: timer: Fix mutex deadlock at releasing card
      Revert "ALSA: hda: Flush interrupts on disabling"

Takashi Sakamoto (1):
      ALSA: bebob: Fix prototype of helper function to return negative value

Thierry Reding (1):
      gpio: max77620: Use correct unit for debounce times

Thomas Bogendoerfer (1):
      MIPS: fw: sni: Fix out of bounds init of o32 stack

Tony Lindgren (1):
      dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Vratislav Bendel (1):
      xfs: Correctly invert xfs_buftarg LRU isolation logic

Xin Long (2):
      sctp: fix the issue that flags are ignored when using kernel_connect
      sctp: not bind the socket in sctp_connect

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3CxTAACgkQONu9yGCS
aT7PdBAAuwTOSvUGBSej8Q0B1il2jlLxYRaLldyZ+BR44xbzRKQGPB34QgJfm2BJ
ofjkF+FH3AeiK3gMfSz1zPWiVFhhtVZZC7vN2hMa4F6tx5LCnvoBHFpMulAU5OS1
M8Prn5cyEkuJSVJUQlsF00Wlb5MEtDGmZmvj6NF9pROZGFASP8CdPzawJZONdxbU
9DWYJyCqtUM2dhZQEH53UvFRjYlkRIPq+aLiYzRYEu+Y38yRUFfWP35Cujbsrzuj
cMsQBX7All2ebYrfw9QrYleivpqMeu1KA++cLR6p/mHP9Dvx6k4zdWcTbIODNc+Y
QxDi74b8b5Yp6dJvrhgJ53kho0WrrpSX1sUE02xxv/mE3jRM98uQl2C7tCgqZVtc
6osyRzC2deeNsfV5mFloSOYZrwA5Sf7twzGJLypHXQLs8uEOWYh4WB9r8EcQ7prw
8sRLUyEa2jJmWiUahv+e9cc/PClyeXzRLjzKtbIGm75l35B6WCjJu7AhqRvyUZG9
8puAmwoTfDapMFYE9PmH+8I51BuIL9z+UQFCPcZ8b3itpf3XANc3mF1j5dCpn0O4
mkl1OLGfEjnEGeH6imdH43AIz4Mo+Pa3ZD9StHG69XE8yZj+DZMnI55pJLU6YWXV
VZmJqz1zze1J1FHulTMeWa4bq1REFoU9rBqhWSOKJ/EmblPMR/Q=
=s+qY
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
