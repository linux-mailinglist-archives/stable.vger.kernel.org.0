Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE7118D10
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLJPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:52:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46816 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbfLJPwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:52:46 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iehoZ-0004zV-8y; Tue, 10 Dec 2019 15:52:43 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iehoY-0000Jh-Mn; Tue, 10 Dec 2019 15:52:42 +0000
Message-ID: <579a587821a4f9571881d583fd5650aee6eb5d0f.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 10/72] video: of: display_timing: Add of_node_put()
 in of_get_display_timing()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 10 Dec 2019 15:52:37 +0000
In-Reply-To: <20191210132732.GG2703785@ulmo>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.830287385@decadent.org.uk>
         <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
         <20191210132732.GG2703785@ulmo>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UkQufnX/opDL5IZVgKKo"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-UkQufnX/opDL5IZVgKKo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-12-10 at 14:27 +0100, Thierry Reding wrote:
> On Mon, Dec 09, 2019 at 01:19:01PM -0800, Doug Anderson wrote:
> > Hi,
> >=20
> > On Sun, Dec 8, 2019 at 5:54 AM Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > > 3.16.79-rc1 review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Douglas Anderson <dianders@chromium.org>
> > >=20
> > > commit 4faba50edbcc1df467f8f308893edc3fdd95536e upstream.
> > >=20
> > > =3D46romcode inspection it can be seen that of_get_display_timing() i=
s
> > > lacking an of_node_put().  Add it.
> >=20
> > I don't object, but I am curious why "From code" got turned into
> > "=3D46romcode" in the commit message.
>=20
> I vaguely recall earlier versions of patchwork doing something similar.
> This has to do with lines starting with "From" needing special treatment
> in some situations. I'm not exactly sure about the details, but I think
> this is only needed for the mailbox format, so whatever happened here
> was probably a bit over the top.

I generate a single mbox file for review, and then feed that through
"formail ... sendmail".  So "From " in a mail body does need to be
escaped (but this shouldn't be visibile to receivers).  The Perl MIME
module doesn't handle mbox output, so I had to implement it myself and
I got this wrong.  I've now committed a fix so this shouldn't happen
again.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner



--=-UkQufnX/opDL5IZVgKKo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3vv0UACgkQ57/I7JWG
EQk6/BAAu4Ji3PwblaG50Y5rR3VtqcvqRt4SmZcF1jjempowdJR79wVgCh3IdUlG
31CLJN9kNCX0yzq0t694m/WB+6zv2U2IjGg797TBw08tQfdUdRMpbBP6yj03QUss
d1NiCcU9hKdZ0DMm4kPon4uwjTQQKmHWtsM8FaTuXJiTK7fO9pMKRY8tFwHIOsdd
gytssgYPTjw67T8YoQAQQlLnc+atTxSiO/Np/LM2LAvebXmXC0TdK5B+M6j5VGp/
RXNDQQQvlovCzOhD8qGOfopflgXcTRfcA56ht+kcKIM5jEddCUY/+e66KAwCoWdj
OBx6lvsdNf9wqKuYf/II7JRKU76C3b3hC8gY83nJvUpqOuycllUDWcjA7poAL24Z
URk21aJDkzA3ZGwBqsZJl505w755xjQyBaQ6+buqe5J6c0aY06hm6+vLvt0Yt1Ca
OfHa5mbQaSTr3JQUcnglDOniopsXx77r3g+AtwT7scJz9fj4BLP0+NgaOQQTGGuq
CDf73UibPqAH2syUNo+WGw0K8ekB/lKOX7shXc1V5Si0D8YIR7XgLbphR6PN58/L
xDeuMXAZoJsETaUb0r1zfaOLCD58QRu7u7nVHLcTDBX2vU8pZRvZWLj2OxX9Paq3
3P17A/OrbjTU1R2VQT3g5KQv/v2w0VOYDhfuQKHJDKTL1/VkW2w=
=fw8B
-----END PGP SIGNATURE-----

--=-UkQufnX/opDL5IZVgKKo--
