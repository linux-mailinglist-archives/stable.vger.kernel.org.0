Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C223C2E2F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732894AbfJAHY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 03:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732887AbfJAHY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 03:24:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B332133F;
        Tue,  1 Oct 2019 07:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569914695;
        bh=u1Tk2qtdJfcfRf+LjS9hP6b7mZdzRh5jJzWr+VGoNhU=;
        h=Date:From:To:Cc:Subject:From;
        b=h8X1Z31kA36y0vSh79tb6Bqm5Au1ng31UWtMZipcXNSwTSo03BW+0R5e3Gn+b9nub
         xtKY8bowBYMurijyNgj1sUnbtDTTi473VfRAUO2NZqsNl/SrkbJvWyrM/lD0+IKxhO
         WIEiuKJHfefQdnYACbJXicZWWno5VyZ441Kfbn0U=
Date:   Tue, 1 Oct 2019 09:24:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.18
Message-ID: <20191001072452.GA2912323@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.18 kernel.

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

 Makefile                                          |    2=20
 arch/powerpc/include/asm/opal.h                   |    2=20
 arch/powerpc/platforms/powernv/opal-call.c        |    2=20
 arch/powerpc/sysdev/xive/native.c                 |   11 ++
 drivers/acpi/acpi_video.c                         |   37 +++++++++
 drivers/bluetooth/btrtl.c                         |   20 ++++
 drivers/bluetooth/btrtl.h                         |    6 +
 drivers/bluetooth/btusb.c                         |    4=20
 drivers/clk/imx/clk-imx8mm.c                      |    4=20
 drivers/crypto/talitos.c                          |    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   56 ++++++++++---
 drivers/gpu/drm/amd/display/dc/calcs/Makefile     |    4=20
 drivers/gpu/drm/amd/display/dc/dml/Makefile       |    4=20
 drivers/gpu/drm/drm_dp_helper.c                   |    4=20
 drivers/gpu/drm/drm_probe_helper.c                |    9 +-
 drivers/gpu/drm/nouveau/dispnv50/head.c           |   28 +++++-
 drivers/hid/hid-ids.h                             |    1=20
 drivers/hid/hid-lg.c                              |   10 +-
 drivers/hid/hid-lg4ff.c                           |    1=20
 drivers/hid/hid-logitech-dj.c                     |   10 +-
 drivers/hid/hid-logitech-hidpp.c                  |   20 ----
 drivers/hid/hid-prodikeys.c                       |   12 ++
 drivers/hid/hid-quirks.c                          |    1=20
 drivers/hid/hid-sony.c                            |    2=20
 drivers/hid/hidraw.c                              |    2=20
 drivers/md/dm-zoned-target.c                      |    2=20
 drivers/mtd/chips/cfi_cmdset_0002.c               |   18 ++--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c     |   23 -----
 drivers/net/ethernet/ibm/ibmvnic.c                |    9 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c               |   33 +++-----
 drivers/platform/x86/i2c-multi-instantiate.c      |    2=20
 fs/cifs/smb2ops.c                                 |   21 ++---
 fs/f2fs/checkpoint.c                              |   12 ++
 fs/f2fs/data.c                                    |   16 +--
 fs/f2fs/dir.c                                     |    2=20
 fs/f2fs/f2fs.h                                    |    3=20
 fs/f2fs/file.c                                    |    2=20
 fs/f2fs/gc.c                                      |    4=20
 fs/f2fs/inline.c                                  |    4=20
 fs/f2fs/inode.c                                   |    4=20
 fs/f2fs/node.c                                    |    6 -
 fs/f2fs/recovery.c                                |    6 -
 fs/f2fs/segment.c                                 |   52 ++++++++++--
 fs/f2fs/segment.h                                 |    4=20
 fs/f2fs/super.c                                   |    2=20
 fs/f2fs/xattr.c                                   |    4=20
 fs/xfs/libxfs/xfs_bmap.c                          |   29 +++++--
 include/drm/drm_dp_helper.h                       |    7 +
 mm/z3fold.c                                       |   90 -----------------=
-----
 net/bluetooth/hci_event.c                         |    5 -
 net/bluetooth/l2cap_core.c                        |    9 --
 net/ipv4/raw_diag.c                               |    3=20
 net/netfilter/nft_socket.c                        |    6 -
 net/rds/bind.c                                    |   45 +++++------
 net/sched/sch_api.c                               |    2=20
 net/xfrm/xfrm_policy.c                            |    6 -
 sound/firewire/dice/dice-alesis.c                 |    2=20
 sound/pci/hda/hda_intel.c                         |    3=20
 sound/pci/hda/patch_analog.c                      |    1=20
 sound/usb/quirks.c                                |    2=20
 tools/objtool/Makefile                            |    2=20
 tools/testing/selftests/net/xfrm_policy.sh        |    7 +
 62 files changed, 395 insertions(+), 306 deletions(-)

Alan Stern (3):
      HID: prodikeys: Fix general protection fault during probe
      HID: logitech: Fix general protection fault caused by Logitech driver
      HID: hidraw: Fix invalid read in hidraw_ioctl

Benjamin Tissoires (1):
      Revert "HID: logitech-hidpp: add USB PID for a few more supported mic=
e"

Bjorn Andersson (1):
      phy: qcom-qmp: Correct ready status, again

Chao Yu (3):
      Revert "f2fs: avoid out-of-range memory access"
      f2fs: fix to do sanity check on segment bitmap of LFS curseg
      f2fs: use generic EFSBADCRC/EFSCORRUPTED

Chris Wilson (1):
      drm: Flush output polling on shutdown

Cong Wang (1):
      net_sched: check cops->tcf_block in tc_bind_tclass()

Darrick J. Wong (1):
      xfs: don't crash on null attr fork xfs_bmapi_read

David S. Miller (1):
      Revert "net: hns: fix LED configuration for marvell phy"

Fernando Fernandez Mancera (1):
      netfilter: nft_socket: fix erroneous socket assignment

Florian Westphal (1):
      xfrm: policy: avoid warning splat when merging nodes

Greg Kroah-Hartman (1):
      Linux 5.2.18

Greg Kurz (1):
      powerpc/xive: Fix bogus error code returned by OPAL

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans de Goede (2):
      HID: logitech-dj: Fix crash when initial logi_dj_recv_query_paired_de=
vices fails
      ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easyno=
te MZ35

Heikki Krogerus (1):
      platform/x86: i2c-multi-instantiate: Derive the device name from pare=
nt

Ilia Mirkin (1):
      drm/nouveau/disp/nv50-: fix center/aspect-corrected scaling

Ilya Pshonkin (1):
      ALSA: usb-audio: Add Hiby device family to quirks for native DSD supp=
ort

Jian-Hong Pan (2):
      Bluetooth: btrtl: HCI reset on close for Realtek BT chip
      Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Josh Poimboeuf (1):
      objtool: Clobber user CFLAGS variable

Juliet Kim (1):
      net/ibmvnic: free reset work of removed device from queue

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for EVGA NU Audio

Ka-Cheong Poon (2):
      net/rds: An rds_sock is added too early to the hash table
      net/rds: Check laddr_check before calling it

Marc Gonzalez (1):
      phy: qcom-qmp: Raise qcom_qmp_phy_enable() polling delay

Marcel Holtmann (1):
      Revert "Bluetooth: validate BLE connection interval updates"

Michal Suchanek (1):
      net/ibmvnic: Fix missing { in __ibmvnic_reset

Mikulas Patocka (1):
      dm zoned: fix invalid memory access

Nicholas Kazlauskas (3):
      drm/amd/display: Allow cursor async updates for framebuffer swaps
      drm/amd/display: Skip determining update type for async updates
      drm/amd/display: Don't replace the dc_state for fast updates

Nick Desaulniers (1):
      drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls=
 to undefined SW FP routines

Peng Fan (1):
      clk: imx: imx8mm: fix audio pll setting

Roderick Colenbrander (1):
      HID: sony: Fix memory corruption issue on cleanup.

Sebastian Parschauer (1):
      HID: Add quirk for HP X500 PIXART OEM mouse

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Stephen Hemminger (1):
      net: don't warn in inet diag when IPV6 is disabled

Steve French (1):
      smb3: fix unmount hang in open_shroot

Takashi Iwai (1):
      ALSA: hda - Apply AMD controller workaround for Raven platform

Takashi Sakamoto (1):
      ALSA: dice: fix wrong packet parameter for Alesis iO26

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Ville Syrj=E4l=E4 (1):
      drm/dp: Add DP_DPCD_QUIRK_NO_SINK_COUNT

Vitaly Wool (1):
      Revert "mm/z3fold.c: fix race between migration and destruction"


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2S/0EACgkQONu9yGCS
aT5XohAAmuCqoQve7RohkyFlzzLAYMpjEfXiA9WGq8b3QW6DCB5I89CJL8FVGZXQ
IMBHgZUzMhKv2dj0G1EhmOCNOT5UY4ulrkyRIk87fiPiWAz6IApdlk1lq5p9PSuz
odoVYzlWCH+Gx2S+QCieHEv4Qjc5KqZE20M1W8OPbNF7V2A7Yr4Hps+A8UYPtkTr
1eHyDLa0FToRv0hAvDOLZd6OiU2UnFO3e8xnDTpGg5P7Kd28q4G6N1gfG0oXeqmO
glHh9+N2xOTXi39z7EqFVYKBqyL7u62ezEhZ3PKUAePwcVbZeUgYIuZ8I7ObYYmd
YH99JGS0Ihahl8gCFaV+jWdi1Bn6gX5Tm2yVeOyWqXcnpbpqrPjvEUYtLnEj8SLC
OvZZQ7NGnRnG8qvBt0G5v1Gfl5D01wneBHQHUXCH6M9LeEPJGZea7AczKPhzVlEJ
CypWabetshh0xXdEii4HN/ffKbjA4YN0mAyLkDjxg/beeXs9u7ZLpilJ/LgfZJcy
pcTPSzl70KWqGRxcffQwJQoLySLFUWHeqZC1wlsZj0OwH2q4PGW3rE1faRPvjoZH
+9QNPppR/B5dG3DsD/Aq8Eklm6p9ohHOSm1V2d37Et/yAds6axdVRIsxa8TEPPxM
gGxrdLWwi33XpwERHVFAYIu3tMyaEHGofBzgpB0dd8XiOaO/SJo=
=Ka1i
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
