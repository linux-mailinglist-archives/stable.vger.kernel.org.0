Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B683A19BBA3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 08:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgDBG02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 02:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgDBG01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 02:26:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77E04206D3;
        Thu,  2 Apr 2020 06:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585808784;
        bh=9t3QFsfMnBwg73lC7+GDMLXRSXRD6YDJKPSre/hB7IE=;
        h=Date:From:To:Cc:Subject:From;
        b=uPNOqjYrp7HqOZOhJkZc+8Wrq8BDGLo8pnD/TOlzbgJdVV7AV5O3hHdROJfAJ6xOe
         SpD3QKwTBvgd5NnMoianj9Quo3GyOLVWFEnADxTjLvfvtXg57F7JFaEy2sPGIaK87d
         PIDkVjK15YPdr417fhySmb/OEXhhSWywmi9PllXE=
Date:   Thu, 2 Apr 2020 08:26:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.2
Message-ID: <20200402062620.GA2678935@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.2 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 drivers/platform/x86/pmc_atom.c              |    8 ++
 drivers/tty/serial/sprd_serial.c             |    3 -
 drivers/tty/vt/selection.c                   |    5 +
 drivers/tty/vt/vt.c                          |   30 +++++++++-
 drivers/tty/vt/vt_ioctl.c                    |   75 ++++++++++++++--------=
-----
 include/linux/selection.h                    |    4 +
 include/linux/vt_kern.h                      |    2=20
 net/mac80211/tx.c                            |    3 -
 tools/testing/selftests/bpf/verifier/jmp32.c |    9 ++-
 10 files changed, 93 insertions(+), 48 deletions(-)

Daniel Borkmann (1):
      bpf: update jmp32 test cases to fix range bound deduction

Eric Biggers (3):
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Georg M=FCller (1):
      platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Greg Kroah-Hartman (1):
      Linux 5.6.2

Jiri Slaby (3):
      vt: selection, introduce vc_is_sel
      vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
      vt: switch vt_dont_switch to bool

Johannes Berg (1):
      mac80211: fix authentication with iwlwifi/mvm

Lanqing Liu (1):
      serial: sprd: Fix a dereference warning


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6FhYkACgkQONu9yGCS
aT7qKw//aIhkpWkdMMYM06ZOtXmWzaJWDKGjYFWZSnx9ywsYYbaUvqBHlhFdrUor
yYTg1iBSTGyH3QhF3278KugyJVDO5rqGNSdocPIDRe5zvpDsRS1GMIim3dmldglz
dKX6ykouMO6BeP2NR710ulGYpcF3LUCk0EG3Z/v7ppEmayyKOou+NYYvMgLtbWF6
7vYIs3P2sWNJp/9dyp++X6FV+UKy+bi07yM2x7RyGDLrqIEOBL2756gouf9JJImO
Uceycs17n0pVG2PjNYQhBQ5DsATMimEjZ/vgwGt/ySeki14eXfIzSvVx8/MrhiFX
wxLQNV4gZumDQZm+fFR3AnNk6LCIYUwFHgx6csAlEOw+0IeOGWP16gle2O4ay6Rz
N9c6vH+Bm/cGbbz29jeT56iShqdhAggNBMqSJPWuHnW0zlYv+OBXdjguckP8Vf1+
jbW1j+ffr7gz6zWnhRbNhj1dn4vSfg9DSsu5O/neBWbCS3fOcpGhy/Unl29pl2C4
ce9dCGKCIEnDh8fhuZ0gLM02y7C0BfP6LJXRI6saStFEyuZiWxGEKyNFF0ZB13lu
MVK8qx/4ZSry26jD/yr5IS6klNl75JjNDNNOrZgcIsO7xGkJ++xUKo2KZfHAqWie
+UcpvdI3i/aTiAQjehFOGJtj4Miei//ER05e3rrxVy2y4kCqtrU=
=45zP
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
