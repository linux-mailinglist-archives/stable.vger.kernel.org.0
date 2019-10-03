Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A3CCA094
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfJCOsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 10:48:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41660 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729617AbfJCOsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 10:48:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG2Oe-00020B-Jy; Thu, 03 Oct 2019 15:48:00 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG2Oe-0006A4-Dt; Thu, 03 Oct 2019 15:48:00 +0100
Message-ID: <3fe1cd65a7860464d3780b57c734d12880df4b92.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 29/87] staging: iio: cdc: Don't put an else right
 after a return
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 15:47:49 +0100
In-Reply-To: <6436567dd141e5528a5363dd3aaad21815a1c111.camel@perches.com>
References: <lsq.1570043211.136218297@decadent.org.uk>
         <6436567dd141e5528a5363dd3aaad21815a1c111.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-KcJewQ6EZ1qfkZkd7xZA"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-KcJewQ6EZ1qfkZkd7xZA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-10-02 at 14:36 -0700, Joe Perches wrote:
> On Wed, 2019-10-02 at 20:06 +0100, Ben Hutchings wrote:
> > 3.16.75-rc1 review patch.  If anyone has any objections, please let me =
know.
>=20
> This doesn't look necessary.

It allows the next patch to apply cleanly.

Ben.

> > ------------------
> >=20
> > From: Catalina Mocanu <catalina.mocanu@gmail.com>
> >=20
> > commit 288903f6b91e759b0a813219acd376426cbb8f14 upstream.
> >=20
> > This fixes the following checkpatch.pl warning:
> > WARNING: else is not generally useful after a break or return.
> >=20
> > While at it, remove new line for symmetry with the rest of the code.
> >=20
> > Signed-off-by: Catalina Mocanu <catalina.mocanu@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/staging/iio/cdc/ad7150.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> >=20
> > --- a/drivers/staging/iio/cdc/ad7150.c
> > +++ b/drivers/staging/iio/cdc/ad7150.c
> > @@ -143,19 +143,15 @@ static int ad7150_read_event_config(stru
> >  	case IIO_EV_TYPE_MAG_ADAPTIVE:
> >  		if (dir =3D=3D IIO_EV_DIR_RISING)
> >  			return adaptive && (threshtype =3D=3D 0x1);
> > -		else
> > -			return adaptive && (threshtype =3D=3D 0x0);
> > +		return adaptive && (threshtype =3D=3D 0x0);
> >  	case IIO_EV_TYPE_THRESH_ADAPTIVE:
> >  		if (dir =3D=3D IIO_EV_DIR_RISING)
> >  			return adaptive && (threshtype =3D=3D 0x3);
> > -		else
> > -			return adaptive && (threshtype =3D=3D 0x2);
> > -
> > +		return adaptive && (threshtype =3D=3D 0x2);
> >  	case IIO_EV_TYPE_THRESH:
> >  		if (dir =3D=3D IIO_EV_DIR_RISING)
> >  			return !adaptive && (threshtype =3D=3D 0x1);
> > -		else
> > -			return !adaptive && (threshtype =3D=3D 0x0);
> > +		return !adaptive && (threshtype =3D=3D 0x0);
> >  	default:
> >  		break;
> >  	}
> >=20
--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.



--=-KcJewQ6EZ1qfkZkd7xZA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2WChUACgkQ57/I7JWG
EQntehAA0+HkJV3LROwrDyJi08Zdjvgi7F7cPNgylHPy7zOR6jR4FJeieCvhNF6W
vYOttr6E72uAMDqdB3EZPGn2rL8016re1CqioDOCtWa9rBcCb/JLFFFBkeHeCthk
eBeQHOittYdEUvLhQyWGI9xAzY+9F0Yex+mFrykOP7P//YJ11nKl6ETHreY5Gobd
qxH4mC+A2VQ+/7wXm5CMti7sz3I2NwbdSjH4+C4ZVPRcr15ZVDk0S0xnMiHlEWAl
nmuW6+DMxWFnfa2pVDQQo53x0BJiYQNtQZlJWVI0EMTsZp05bMTWULvUkAShp5/C
BEO2R+MCbWoO/fNt7z43SNC8Q3ch+a6mVLELs8/KcZbEsneHqUJ0wzdGJRyyxyH3
ik15AYNqBpwb7quVmhzcDP3UHGCBBw5EuPRPXoP3pEsIGOZgtNIHuQaTQCf2tFj9
0/Mh2baQ0quWTwrleD1UTVR/bGARwpOv2WYYEiTGwF53r5rc2SoDVD1RFYOFKFNd
82Mqu1f+XNJLG5DI3awkP3myhPk6cUb0nxTgUpKKM6qlMEEOA9n/hO7BaAV5y4I3
oriKD16LLJ2TAYDzNMA4W9WPkbI9y/tWnC4WzUD9uno4jBFbUJnMI4X6nf/PVqQk
ELlDpXlrmbsezqh5UsJcggQJpSDi9bMknHBP8NrOGkNrWiazdxo=
=uPEd
-----END PGP SIGNATURE-----

--=-KcJewQ6EZ1qfkZkd7xZA--
