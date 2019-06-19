Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F6F4C368
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 00:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfFSWDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 18:03:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32864 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfFSWDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 18:03:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdiff-0005xY-BN; Wed, 19 Jun 2019 23:03:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdiff-0004If-4N; Wed, 19 Jun 2019 23:03:11 +0100
Message-ID: <2349a7aefb2ad2d0cc623be310b2162130fc06de.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/10] 3.16.69-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 19 Jun 2019 23:02:57 +0100
In-Reply-To: <20190619215836.GA2387@roeck-us.net>
References: <lsq.1560868079.359853905@decadent.org.uk>
         <20190619215836.GA2387@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-gVg17ikfxwMw2FePTx6n"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-gVg17ikfxwMw2FePTx6n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-06-19 at 14:58 -0700, Guenter Roeck wrote:
> On Tue, Jun 18, 2019 at 03:27:59PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.69 release.
> > There are 10 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu Jun 20 14:27:59 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 231 pass: 231 fail: 0

Great, thanks for checking.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                         - Albert Camus



--=-gVg17ikfxwMw2FePTx6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0KsREACgkQ57/I7JWG
EQkEIxAAmkGctw6DIAKsRi/IRY8xVWQlEjxc13bN8iNN4Dxbv3yh/7bP1XSCxyOF
3NuorBiQzMvTz6eQVDGs3ezJ9tiE0sXTMMJjQv9BdX7vNwCyWrwaGyUqQTlBv1Di
92l+lE1WOP0qLuW0S+U0wLNhuLx7dABMfmsmvXJ6a5rjEv4XsWLiCXPrsdGRSThV
PGW28vyXTGy5l/uCWnSaclv27BaWI8eYputCPTI3QMrJO6resOjM1pUL+IJuClb/
yujq1Qg8L8k+RASYZ6E+DJUTqzsgvs8ADVebmnybnIwYz4pQg0f3f3gWWxj4niLE
Hi+rt9rT9P+sQAod9jofGutr7ubbHTn9SszD0kJkuQ63flu86zT9UW523KC530Qg
UPi4nLNhrT1HGANZmIqq4uBZnmrXpcefFZxwrfk/ZymkY0w5Z0MQs8DQoUji7jRp
lFmeoQJvBdUkHtzCaSPUjA5GGi/KaUmXeJ2kAhm8uAl3n7mpJrAAhFiXVfyWnXGc
PubcrN3Mh/0PHdzJMaSwB2kCBOfCkh42ZsF3jS4Oyb5KxRS5cV7LALrngWY/ATWZ
OnPzsBN1M0k+Lwva1DNtbiDv/UAxE7IjP39wbFxftnhagI3QWNo3DxYT7jntFkG6
81nr6OxzQWlUoL9QE3uDqRpbDLvbxQKfSUvz+edVecHHVfXMJes=
=Sb0T
-----END PGP SIGNATURE-----

--=-gVg17ikfxwMw2FePTx6n--
