Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822AFB9F8D
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 21:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbfIUTKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 15:10:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45236 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732340AbfIUTKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 15:10:15 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBkIF-0004QF-LF; Sat, 21 Sep 2019 19:39:39 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBkIF-000402-Dw; Sat, 21 Sep 2019 19:39:39 +0100
Message-ID: <0f95821e580f5dc8d4805c8246da88059c776dee.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 114/132] ALSA: usb-audio: Fix a stack buffer
 overflow bug in check_input_term
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Hui Peng <benquike@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, kda@linux-powerpc.org,
        mathias.payer@nebelwelt.net, gregkh@linuxfoundation.org,
        tiwai@suse.de
Date:   Sat, 21 Sep 2019 19:39:34 +0100
In-Reply-To: <94525609-b88e-cc24-dfe5-9db470e105ef@gmail.com>
References: <lsq.1568989415.723106414@decadent.org.uk>
         <94525609-b88e-cc24-dfe5-9db470e105ef@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-z5SbhgLXkyBYomEAs86a"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-z5SbhgLXkyBYomEAs86a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-09-20 at 21:26 -0400, Hui Peng wrote:
> I want to confirm the patches.
>=20
> Which version of GCC do you use to compile 3.16?
>=20
> I tried gcc-4.8, it seems that the built kernel can not be boot by qemu.
[...]

For my own limited testing, I build for x86 with gcc 4.9.  Debian's
packages are built with gcc 4.8 (arm) or 4.9 (x86).

Guenter Roeck does build and boot tests on multiple architectures using
a variety of (mostly quite recent) compiler versions.

Ben.

--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.



--=-z5SbhgLXkyBYomEAs86a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2GbmYACgkQ57/I7JWG
EQl7Gw//T0vF2dKtK49fz0Vtyw2GduhCf9QWwUmQcCWQK1E+TEPFJuYACOGYNu+w
YMW+LBE9IuQs+nVfhX7QfcSKcFox9pp56aiiR+UVNvba5q8NPLtE6ITAdkrFE/qa
f2hxxxnpZk5w2R38o7JBYcs9/Oc+DgrySiN1DnQjZr9nuRDtpXPx7wlqqwiYpNHo
MK+nY/2aGl2XvTA2eIBe2TgYorUaKGtobbItbXQHjji6gAi62SpskQa3FGqF9v3A
h5aA9tHR8rXBAGI15x0Jb3FTzBuDgcjYGlMRV+PRdMZztLN+JQITqziTGVEtiaWO
uOmLyF+sOJYqwuBSMmYUl+Yy2aGf5Wr1/zM6+D0zKuPx5vjFz1VFREvqXoo80TJl
5L4xe2bFYZPTLs8ya87+xEWDdKQ4fGRBhfiuYhjkgCsJUAYbeenDimoY85q9929j
kRtulAK9XSvhhtv6YKvSb3WoEQlO1K1tJNNaWathBkf1TXeQeS3j0FA/p9T9RjpC
IOxOgQZa7B9kqa1waDSQFXC8NX08URqUcUZTL5La+dZvV2KIBgUUE9tXjIdKA7bB
U2qUYNbEUQ+coAbzgN7r8i/hISAJBBzVtgQzTcw6RDThYcuTAHav/BC91/3Hgka4
+cfPCW+HlVgnH2uur4w8iEa9GJYr4LiwfYp1ihGMNytFnvnQFIc=
=2R6D
-----END PGP SIGNATURE-----

--=-z5SbhgLXkyBYomEAs86a--
