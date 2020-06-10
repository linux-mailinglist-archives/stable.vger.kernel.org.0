Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0781F5DAA
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 23:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgFJVZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 17:25:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50698 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgFJVZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 17:25:19 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jj8Dl-0006uu-4d; Wed, 10 Jun 2020 22:25:17 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jj8Dk-00024e-Or; Wed, 10 Jun 2020 22:25:16 +0100
Message-ID: <7a8648afb2af6c3d47bf43edec7346e85c548c95.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/61] 3.16.85-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 10 Jun 2020 22:25:11 +0100
In-Reply-To: <20200610190847.GA232340@roeck-us.net>
References: <lsq.1591725831.850867383@decadent.org.uk>
         <20200610190847.GA232340@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-3a98SMwW65qTTRrj603Y"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-3a98SMwW65qTTRrj603Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-06-10 at 12:08 -0700, Guenter Roeck wrote:
> On Tue, Jun 09, 2020 at 07:03:51PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.85 release.
> > There are 61 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu Jun 11 18:03:51 UTC 2020.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 135 pass: 135 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0

Thanks for testing,

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.



--=-3a98SMwW65qTTRrj603Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7hT7cACgkQ57/I7JWG
EQk55Q//Y7aZmbj2p66Tio3T9l1uOovhjba8eToR6XE5782uW/MvlovNkHB2laPv
cXqfzzvDe+SHb2Wz4XMxvvjTtKtgRrRx1ERVQIL6FEmGACO5JhgIP4xYuT9jGUEh
NrFYn6rwbbCKFW169OS621coK/fc/5T1r1+2qtcNr0nqiiPo98NXS+ym/H+Jo+al
4t6ubrg0AnFOJ6vcKVbqowwwtUkK7z1zrU1ODYSBQmyl7bAAx2BejGeoNcRaZDVk
3vImf1FmnY/sAU44RFJbl0QqtULmJd/V58IRoXgP1NBCov/urlVZpw/PHKTSdeWY
FH9JHUs/5X0lOzfNGJTxNVtfcRJ1S8HOg94MooUw+DLraEiMGj/sDVoDpTWLRjVL
svyj7cH6AXF7oy6WJjCgU8mnsxO+7V68ZkfRSorxUFkAahvJdsRVzxCoZKcHmHzT
wSpVW/TRESk1TrdUxbck0uAMyG1pfUZCaxHqV3x+YG2jcoQpA7ByLIx4Xqn6SzVz
H4YrcdBK1f0Jvjoi7oXdFO/ZUGJKpY+JuryK7FDVJOHXnPeBbu8knxeEfShIITjZ
Z05XhCKBnhnF3tLwU6bOG1qRfpunctYRnTU58Mv7FRRwc3YS5sZhNIFwNRxCVjXg
j3YZgW86nJGabwwcLrbMOwQTylEMZhKwgLc2pKlzgClxI9gBk7Y=
=ZHjK
-----END PGP SIGNATURE-----

--=-3a98SMwW65qTTRrj603Y--
