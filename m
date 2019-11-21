Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC11E105C23
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 22:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfKUVkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 16:40:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33534 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUVkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 16:40:25 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXuBa-00007U-NA; Thu, 21 Nov 2019 21:40:22 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXuBa-000495-61; Thu, 21 Nov 2019 21:40:22 +0000
Message-ID: <50f93d1066a031bf77bba78150b6cc1c35e73e4f.camel@decadent.org.uk>
Subject: Re: [PATCH website] releases: Extend 3.16 EOL to match Debian 8
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg KH <greg@kroah.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        stable@vger.kernel.org
Date:   Thu, 21 Nov 2019 21:40:17 +0000
In-Reply-To: <20191121065728.GA343863@kroah.com>
References: <20191119213141.GA19244@decadent.org.uk>
         <20191121065728.GA343863@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-5r6odpFAz5DpvRnw4eEW"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-5r6odpFAz5DpvRnw4eEW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-21 at 07:57 +0100, Greg KH wrote:
> On Tue, Nov 19, 2019 at 09:31:41PM +0000, Ben Hutchings wrote:
> > I'm maintaining 3.16 primarily for Debian 8.  I originally expected
> > that to have an EOL of April 2020 but it's actually June.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Acked-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> > ---
> >  content/releases.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/content/releases.rst b/content/releases.rst
> > index dbbe0d69db9d..0908fd090cdc 100644
> > --- a/content/releases.rst
> > +++ b/content/releases.rst
> > @@ -45,7 +45,7 @@ Longterm
> >      4.14     Greg Kroah-Hartman & Sasha Levin 2017-11-12   Jan, 2024
> >      4.9      Greg Kroah-Hartman & Sasha Levin 2016-12-11   Jan, 2023
> >      4.4      Greg Kroah-Hartman & Sasha Levin 2016-01-10   Feb, 2022
> > -    3.16     Ben Hutchings                    2014-08-03   Apr, 2020
> > +    3.16     Ben Hutchings                    2014-08-03   Jun, 2020
> >      =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > =20
> >  Distribution kernels
>=20
> Now applied to the tree, the website should update on the public side
> "soon".

Thanks,

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.



--=-5r6odpFAz5DpvRnw4eEW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3XBEEACgkQ57/I7JWG
EQnMDw//b4MhARg4JfteNHvufE9WUGVMn1F/O4yxHNE/lxif7VadC05aqIU3E/E1
1x4aCoFvFxbv/O815lTIt0ZFDGjZhzlyQUeTvenC9wWuFq8rI7pOqU+ynYD3Bv8G
jYrDpDPSgjR293y5O7PLsUPEy9P63kOl3gsiiLpb+ZYJ9+D7msBWVoB8e6aLEul8
4UMJhx61QIA5hSUuP5OJRtOjwtGhU7fA766jvZ2kwCEHiAHNF050oOaH7Zb2tqDU
sQQ7U/V1i8Yvt47IJtStLnZtmbOSPl4QDksCP61RRXDSU5fi5xHHu9VTiHhaY0kv
0BuN7J+miL/fNRAMm0ULKqw80rCOWK9L/UKqY0zNCuIxyCN1Voc3Y2QRRC0QRNsP
mHPcvTzHrj3S1lD+27Jg7V7H9sgrGlItE3gW77AXUwG6j1TJaY4K1dU0esGYDOXr
N8BF51+aD+CLNQuOjEfG+5SSRWl4of7YVsNC9ZregxKWUqOy1eElNovi+0K4bysM
Q6E6Z/chxsAy122ffhPlnFGnMMldKEIW9DcOOeaSMuoD30w2p4ZVH6HbPqUTCpA6
oA/aHWpUkto8vpBX5FTmt1ZMvs42LQmsCxe3+UtSIwHgCES+NtG/MEye4WXh+emA
ky4zVrKzbmhIPD8i5b4RCYPEWlQwAXxDdmG1hEYSJI1otFba1xQ=
=SNIE
-----END PGP SIGNATURE-----

--=-5r6odpFAz5DpvRnw4eEW--
