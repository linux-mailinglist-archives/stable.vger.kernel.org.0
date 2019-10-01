Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368C0C2DBE
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJAHFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 03:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfJAHFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 03:05:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B53215EA;
        Tue,  1 Oct 2019 07:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569913499;
        bh=W2B0nz7oJdULryzpKt3T+gxH45sheTNxKJ9Gr4J31Bs=;
        h=Date:From:To:Cc:Subject:From;
        b=vkj9SHsbOyRRhqFuzvVrQ8WGVW+1gMepRYUFqaaF48sDSfA1HtRVlxNi1rXVi1+W4
         iAKfIppkruAW8oXXh75lwtOfyAmFJK0MeTgcRW2vocwzrETmlN9UdwTQByct2aJZuR
         +i0FezyCakB+ekN5qJjhpQMy0lgf+pKOjcUrlsFI=
Date:   Tue, 1 Oct 2019 09:04:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.2
Message-ID: <20191001070457.GA2893807@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.2 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
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
 drivers/clk/imx/clk-imx8mm.c                      |    4=20
 drivers/clocksource/timer-of.c                    |    6 -
 drivers/clocksource/timer-probe.c                 |    4=20
 drivers/crypto/talitos.c                          |    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   56 ++++++++++---
 drivers/gpu/drm/amd/display/dc/calcs/Makefile     |    4=20
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile     |    4=20
 drivers/gpu/drm/amd/display/dc/dml/Makefile       |    4=20
 drivers/gpu/drm/amd/display/dc/dsc/Makefile       |    4=20
 drivers/hid/hid-ids.h                             |    1=20
 drivers/hid/hid-lg.c                              |   10 +-
 drivers/hid/hid-lg4ff.c                           |    1=20
 drivers/hid/hid-logitech-dj.c                     |   10 +-
 drivers/hid/hid-prodikeys.c                       |   12 ++
 drivers/hid/hid-quirks.c                          |    1=20
 drivers/hid/hid-sony.c                            |    2=20
 drivers/hid/hidraw.c                              |    2=20
 drivers/mtd/chips/cfi_cmdset_0002.c               |   18 ++--
 drivers/platform/x86/i2c-multi-instantiate.c      |    2=20
 include/net/netfilter/nf_tables.h                 |    4=20
 mm/z3fold.c                                       |   90 -----------------=
-----
 sound/firewire/dice/dice-alesis.c                 |    2=20
 sound/pci/hda/hda_intel.c                         |    3=20
 sound/pci/hda/patch_analog.c                      |    1=20
 sound/usb/quirks.c                                |    2=20
 tools/objtool/Makefile                            |    2=20
 30 files changed, 129 insertions(+), 138 deletions(-)

Alan Stern (3):
      HID: prodikeys: Fix general protection fault during probe
      HID: logitech: Fix general protection fault caused by Logitech driver
      HID: hidraw: Fix invalid read in hidraw_ioctl

Greg Kroah-Hartman (1):
      Linux 5.3.2

Greg Kurz (1):
      powerpc/xive: Fix bogus error code returned by OPAL

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Hans de Goede (1):
      HID: logitech-dj: Fix crash when initial logi_dj_recv_query_paired_de=
vices fails

Heikki Krogerus (1):
      platform/x86: i2c-multi-instantiate: Derive the device name from pare=
nt

Ilya Pshonkin (1):
      ALSA: usb-audio: Add Hiby device family to quirks for native DSD supp=
ort

Jeremy Sowden (1):
      netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-f=
ile.

Jon Hunter (2):
      clocksource/drivers/timer-of: Do not warn on deferred probe
      clocksource/drivers: Do not warn on probe defer

Josh Poimboeuf (1):
      objtool: Clobber user CFLAGS variable

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for EVGA NU Audio

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

Takashi Iwai (1):
      ALSA: hda - Apply AMD controller workaround for Raven platform

Takashi Sakamoto (1):
      ALSA: dice: fix wrong packet parameter for Alesis iO26

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Vitaly Wool (1):
      Revert "mm/z3fold.c: fix race between migration and destruction"


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2S+pkACgkQONu9yGCS
aT7+yw//f/EL3s4nJNNICMtm+4/cCVJJkgOtkPTxBdvT8nkSagDPwvYMuEk6I08w
hsrQK2nd3skok3sCVvc8lusC+sG9Xop0uh5PiHvuQXY0Rq/gBIqmCGQxKmrA0ktK
2zKq3Gxy0s3bRAZHNXC7U5HmnEr2BN7l7B573WbdMnceVKsg8/bEz27ptDOQWHtq
74racmRvHl+5nYUoGeM91AHB+dHkPd2yOjabNLOnMbDe8RZOBznYA8k6iJOihztG
Tsjffdyiw2hdG6Z7cXr4m6XDHUuXKQsZO/6boYQPpWvkl0VX1U1eiQtihp2dyYxu
3abaQ8qrfEDDHC+IuXYF1UGLkOLRc5C9WnOw/xYKjJ1wfwCiORn+9spABSkvSkqd
A4bxW8PBfXCZEe/0Sxitgzqy21cvEUZyAuPeCnQ5y65i3MYiMCVZpikKmngoXRXY
5bwuQwyRYdoNFOxaVMuEE1BqFcbCgHm8hB2voNi6IMf8d8uguWmpgh+isol44Yw0
Q4fKfCwhuOIT3B618uBOZ9lEWG8HhBLmYzIYI9/MLMYxfzhLAsUrgLFCzVNt9cxh
9mIf9feiSeKWrz1LJgwWKGZTWc/5NFxdiyi6WmS1bvxMrBzBjY3e52Tl1b6I32aR
4wcZy0ueDuCbiwQi5+nAxdbaisqdtRZ+H4Sem6B8J/z+SfYPujI=
=Z0T8
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
