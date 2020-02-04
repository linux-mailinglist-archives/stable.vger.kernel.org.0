Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A8A15228C
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 23:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBDWz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 17:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgBDWzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 17:55:25 -0500
Received: from localhost (unknown [167.98.85.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E46B2087E;
        Tue,  4 Feb 2020 22:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580856925;
        bh=r2e0z47aXt0d5qyZbzAx+h6YxepxJD0+a+2oKuE7QhE=;
        h=Date:From:To:Cc:Subject:From;
        b=Ft55IBXqbxEQ9EUI1IpSoYG2gvNB4VB5laOFOJhFqAkChjJpWrsEwHY3mB6DSOiWY
         CxojKU9T1ce3ZBIkY1W2+jLl3+04axR2vvgVjix1r0Zz1lz7QvPR67XPR2U525nbNB
         tyg79SkHV5uuciJr37lPkuYNUv+tZuTo5CV/40VA=
Date:   Tue, 4 Feb 2020 22:55:22 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.2
Message-ID: <20200204225522.GA1129708@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.2 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-class-devfreq |    7 ++
 Makefile                                      |    2=20
 arch/arm64/boot/Makefile                      |    2=20
 arch/powerpc/kvm/book3s_pr.c                  |    1=20
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   32 +++++++-----
 drivers/char/ttyprintk.c                      |   15 +++--
 drivers/devfreq/devfreq.c                     |    9 +++
 drivers/media/usb/dvb-usb/af9005.c            |    2=20
 drivers/media/usb/dvb-usb/digitv.c            |   10 ++-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c       |    2=20
 drivers/media/usb/dvb-usb/vp7045.c            |   21 +++++---
 drivers/media/usb/gspca/gspca.c               |    2=20
 fs/btrfs/super.c                              |   10 +++
 fs/cifs/smb2pdu.c                             |    2=20
 fs/gfs2/lops.c                                |   68 ++++++++++++++++-----=
-----
 fs/namei.c                                    |    4 -
 fs/reiserfs/super.c                           |    2=20
 kernel/cgroup/cgroup.c                        |   11 ++--
 lib/test_bitmap.c                             |    9 +--
 mm/mempolicy.c                                |    6 +-
 net/bluetooth/hci_sock.c                      |    3 +
 security/tomoyo/common.c                      |   11 +---
 tools/include/linux/string.h                  |    8 +++
 tools/lib/string.c                            |    7 ++
 tools/perf/builtin-c2c.c                      |   10 ++-
 25 files changed, 172 insertions(+), 84 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Andreas Gruenbacher (1):
      gfs2: Another gfs2_find_jhead fix

Andres Freund (1):
      perf c2c: Fix return type for histogram sorting comparision functions

Andy Shevchenko (1):
      lib/test_bitmap: correct test data offsets for 32-bit

Chanwoo Choi (1):
      PM / devfreq: Add new name attribute for sysfs

Dan Carpenter (2):
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
      Bluetooth: Fix race condition in hci_release_sock()

David Michael (1):
      KVM: PPC: Book3S PR: Fix -Werror=3Dreturn-type build failure

Dirk Behme (1):
      arm64: kbuild: remove compressed images on 'make ARCH=3Darm64 (dist)c=
lean'

Greg Kroah-Hartman (1):
      Linux 5.5.2

Hans Verkuil (2):
      media: gspca: zero usb_buf
      media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Michal Koutn=FD (1):
      cgroup: Prevent double killing of css when enabling threaded cgroup

Ronnie Sahlberg (1):
      cifs: fix soft mounts hanging in the reconnect code

Sean Young (3):
      media: digitv: don't continue if remote control state can't be read
      media: af9005: uninitialized variable printked
      media: vp7045: do not read uninitialized values if usb transfer fails

Tetsuo Handa (1):
      tomoyo: Use atomic_t for statistics counter

Vitaly Chikunov (1):
      tools lib: Fix builds when glibc contains strlcpy()

Xiaochen Shen (3):
      x86/resctrl: Fix a deadlock due to inaccurate reference
      x86/resctrl: Fix use-after-free when deleting resource groups
      x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl459lgACgkQONu9yGCS
aT55dw/9EM+NhwvM9N6sK8TbuHX7t284gdpWeheTXUTLgd4ZsMhzz5HlqG16O1Aq
3y0jq94MCrxlixh0PIG8znY0YdcxmbGLDBqH5rAjRuw0FQZTjkSqfaYyal0m0Z4/
dBbxjqTJiTG7eaFgZD5wUp0JFUXE9YLmx9H0zidoGVhNPy/i/UFTwn3XQQIZFsl1
Z5nNc3AlX22Lkk3h8SfemX/VgG7BmiXG9nQEYbAhzeFhEEEMWDNSwIiORB0FDN0z
W0qlpeWdtSOtHys8dpKLNMK2HvCYIZNfBCvfo3rXmZe/sa0Npr81OvsX2fdHUvRU
YlT2aAYN/KkYPSMQghRpa160H+2q/tOfQ+Rv5Ah8TAM9IL1uB/H0v8KzGGZe9jiu
u9AxrWgyt9Pfu2gScxIFVq889+n88YQlRR70fSssmgNNTIp536mk6EmNa1wHInhQ
/62S1eUeVMi8/yqBVwzljeBNS55X7/b59Sfijl/5EYq0VDO4tQKfIXF7K7zQfJG5
VATzXqauxgL4z3TUVo2MSy9fVtovvRwDAWkkpjx1Q8W6z2XqyjEkFnaeZEvoS6+Z
GQUZZRBpTCH2kuKe705AlhS2LQpzzWJGBq0qIT70cyrGf0LPv8TyvR32XdNncknO
/m9YPmkrqRwYLbOAOY5JwcdtTsgRKGH0Smi9lDTtZTjIU2nZX90=
=UN3G
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
