Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDCA262204
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfGHPV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36992 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387725AbfGHPV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 11:21:29 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkVSJ-0004kw-1p; Mon, 08 Jul 2019 16:21:27 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkVSI-0002yG-7I; Mon, 08 Jul 2019 16:21:26 +0100
Message-ID: <2d22b1fedc748e99a9975e3f9e105f7928676042.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/129] 3.16.70-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 08 Jul 2019 16:21:25 +0100
In-Reply-To: <89ecc914-674d-6626-6741-2076ba974d46@roeck-us.net>
References: <lsq.1562518456.876074874@decadent.org.uk>
         <89ecc914-674d-6626-6741-2076ba974d46@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-BOLlnUszxZL14Izn6Si0"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-BOLlnUszxZL14Izn6Si0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-07-08 at 04:05 -0700, Guenter Roeck wrote:
> On 7/7/19 9:54 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.70 release.
> > There are 129 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Jul 09 20:00:00 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> drivers/mtd/devices/docg3.c:1836:15: error: implicit declaration of funct=
ion 'devm_kasprintf'
>=20
> Seen in various builds.

Sorry, I dropped the patch that causes that before sending out this
series for review but I did not push to linux-stable-queue.git
afterward.  I have done that now, so hopefully your builds should go
green.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.



--=-BOLlnUszxZL14Izn6Si0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0jX3UACgkQ57/I7JWG
EQkuUw/7BknzVIFGJY7OipTRF/F25KUwnVVBIHXaIHkiMfmufQbI4vkCc4nXnkMX
Loc5DLIVDNNeYQHYvEH2vmeXDKMwO0xxHqQvZAPpWogoYGpogYv4eh0+j30UFJqd
XTi2sO0TG3QosRaaxADD3pALnrdsglwFeIRFRM/PNKUQJxHbC82VsDMB98s1f2vV
Q4DjBcWaaN3jop2McA1V4rth+pluGRDFkSYHrZCvlElsaosgbHfOPg6Mkk8a9Bj+
wR8YSwH9XUALYerMUXSh3LMapxxre+EKHef7WiyuHokqNczgT2xkfZHS/AZ/Awgt
6Z9fdKP1y6Ij4o8NJHByJchZYH4O8y4jcgLLUB3q7vHm5wSkuaB4NSaFby93/yPz
gAtf+g7tX7MGKxUzyu7zwBJ8OthaTGBrYS5s97bABbwYqIycNS6Oaii1KKrp/fli
TjQJ70ULJaBiA15P2epG7DzSa1mkkmwibqAZJFLOgELUe7EvlfvYDcNSzyiKfTsb
G34ZnONQ32BbDiPeQ5sFHgP6WQgJ9ltAm6hEIlsK+5Boa2RY4dMupug6Gaezb1Ac
cbtqti9OS4MVrdV4pq6vggeOL3yNYyF1j4GWljqQT25xoH5+O2uFR4/cT50md6GZ
14aEbpC7b06IVqVZRkgGZacnx1pMnLQ4CzVnn0VVsNzMePIhZas=
=N24r
-----END PGP SIGNATURE-----

--=-BOLlnUszxZL14Izn6Si0--
