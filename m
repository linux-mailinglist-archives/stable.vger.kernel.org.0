Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51D0118C8D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfLJPcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:32:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46702 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfLJPcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:32:00 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iehUR-00044m-8O; Tue, 10 Dec 2019 15:31:55 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iehUQ-0007aj-Bv; Tue, 10 Dec 2019 15:31:54 +0000
Message-ID: <e1df16f96a889e870045d6198b3cd301d135003f.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 10/72] video: of: display_timing: Add of_node_put()
 in of_get_display_timing()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Doug Anderson <dianders@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 10 Dec 2019 15:31:49 +0000
In-Reply-To: <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.830287385@decadent.org.uk>
         <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ekvcjEuOJjj69DSg13MY"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ekvcjEuOJjj69DSg13MY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-12-09 at 13:19 -0800, Doug Anderson wrote:
> Hi,
>=20
> On Sun, Dec 8, 2019 at 5:54 AM Ben Hutchings <ben@decadent.org.uk> wrote:
> > 3.16.79-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Douglas Anderson <dianders@chromium.org>
> >=20
> > commit 4faba50edbcc1df467f8f308893edc3fdd95536e upstream.
> >=20
> > =3D46romcode inspection it can be seen that of_get_display_timing() is
> > lacking an of_node_put().  Add it.
>=20
> I don't object, but I am curious why "From code" got turned into
> "=3D46romcode" in the commit message.

I'm not sure why this happened, but it has happened in the process of
generating the review mail.  The patch file I'm actually going to apply
is not affected.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner



--=-ekvcjEuOJjj69DSg13MY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3vumUACgkQ57/I7JWG
EQkGRRAAxOkWOx0oI/kMsYlf9iX8k6HAXnLbZ/em6+gnuT8sVhqpJ3oHcnZttUAe
dgSZIH6nvhOlfj7tVhcK0GVtlfkSOc+YnlM5ieRkDbS7CM3NVD8DcGr7JMVMUdDv
ftYJQrv3aa/ptHUmdr4W3OzG9ZmVaM6A1acKgVd0Ot5QB1mbeChyNaRFme1sesFf
pzdM05cbMfRD5aNB+Bp6WMsQenHMrJkTTjE4LkgrSN7VMoi9uhsOJK1W3wA7u2yM
P3Nq/7rE+rrgtCfXYSvjlXkwplF+eYhP90YvrHCrpZZiOoS4EpPIg11jmmtK7zQH
19MZZwc+SX3jtX+rPcKUckp6S9CoEEapqGTL74JoEcy5DodwfcnGrPzU3tSD7Rwm
BGdyRoEzEHw7lhrNzBMtZ+QUv3+mqM3Qtd7CWTsJLj2RMxzB/qsaUAMh9VE1Wlr7
nspF96mLXXL8Hy6sjheHLsV4xq6KpSaivLrSqIcmUUo2tU7MUra+YxyQzn/icwyB
uJLi1yQxJlYdgBN4Mkb+xOQtk9zO719mDQYcPeYDn2L2+vC29aPQBYX3Eu+pmQfk
cs8sWddjb5ZQmupeSEX37svxZ0hBnNGKowP+wFtLYdlymn5KG5dLjJy5/fKupVAa
TDhcwheI8OpJm+IhffaLoJre+A3HZQCPIKTnYtRLrtzGQVnZxHo=
=JsqF
-----END PGP SIGNATURE-----

--=-ekvcjEuOJjj69DSg13MY--
