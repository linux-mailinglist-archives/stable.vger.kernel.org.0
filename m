Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C31DDB87
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgEVAAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:00:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44298 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730105AbgEVAAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 20:00:36 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbv75-0000b1-1y; Fri, 22 May 2020 01:00:35 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbv74-007Lb0-Lt; Fri, 22 May 2020 01:00:34 +0100
Message-ID: <f7eea57f1bab1b9f321e1c52d9bfc6103b9a45a5.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/99] 3.16.84-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 22 May 2020 01:00:24 +0100
In-Reply-To: <c170c353-9fe1-a849-d062-74e42f22661c@roeck-us.net>
References: <lsq.1589984008.673931885@decadent.org.uk>
         <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
         <c01feeb17ecceeca18c852008bf0227079fbb38a.camel@decadent.org.uk>
         <c170c353-9fe1-a849-d062-74e42f22661c@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-5mtijeWolg70nhqPo19T"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-5mtijeWolg70nhqPo19T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-05-21 at 15:37 -0700, Guenter Roeck wrote:
> On 5/21/20 1:20 PM, Ben Hutchings wrote:
> > On Wed, 2020-05-20 at 14:23 -0700, Guenter Roeck wrote:
> > > On 5/20/20 7:13 AM, Ben Hutchings wrote:
> > > > This is the start of the stable review cycle for the 3.16.84 releas=
e.
> > > > There are 99 patches in this series, which will be posted as respon=
ses
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Fri May 22 20:00:00 UTC 2020.
> > > > Anything received after that time might be too late.
> > > >=20
> > > Build results:
> > > 	total: 135 pass: 135 fail: 0
> > > Qemu test results:
> > > 	total: 230 pass: 227 fail: 3
> > > Failed tests:
> > > 	arm:cubieboard:multi_v7_defconfig:mem512:sun4i-a10-cubieboard:initrd
> > > 	arm:cubieboard:multi_v7_defconfig:usb:mem512:sun4i-a10-cubieboard:ro=
otfs
> > > 	arm:cubieboard:multi_v7_defconfig:sata:mem512:sun4i-a10-cubieboard:r=
ootfs
> > >=20
> > > The arm tests fail due to a compile error.
> > >=20
> > > drivers/clk/tegra/clk-tegra-periph.c:524:65: error: 'CLK_IS_CRITICAL'=
 undeclared here (not in a function); did you mean 'CLK_IS_BASIC'?
> >=20
> > I already looked at your first test results and dropped the patch that
> > uses CLK_IS_CRITICAL, so there's something else going wrong there...
> >=20
>=20
> Ah yes. Sorry, I didn't notice that there was a rebuild.
>=20
> Images are fine; the three failing tests should not have been
> tested in the first place (they never did, but I didn't update
> the blacklist when I increased the qemu memory size to 512MB).

OK, thanks for checking.

Ben.

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky



--=-5mtijeWolg70nhqPo19T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7HFhkACgkQ57/I7JWG
EQkNChAAjUcgcmENb90PVJ0bJsxKyHeJnxly8pVNVQAqGtJhn9nwQbV/MKM9jfQU
9qOIDdTePFA8gcwqaogaBPcPsViJ/7FsT0Rx7nhMZlAmpibtl5TSTfBc6jWeU/8E
/swZNgIdpGWi/j8b3IEJLuRjqSZPvYC0FaLmvSTLC5DbAPZkrv+RenQ/7hkLkVrp
t8yuxtPL9RNb/E+e644EkwkgMpBiF5W8VoM4Sur330FIaM3CbpvH6OTWtqdOfroj
+Vig3xFwqzKosco1rSbd/aS7gyDjy02zmz9x8ZMgYa3+CzGbHghbSCbzfqPkbHcT
aSnNEWWdyMd9uv8Yh5D4Ai673kW+lHYk6fcc+ncXW/A/ZiRvCsGSwkTEEq+M8xNy
OVHdUWVMT5C+xEwG6g6HnCbc9ivcgTGmxDkMTlJzkZ5wsIA9A+r92U15KkR/xMZQ
5ODnn9/qCNK0qH/1nc3U7ZvzrCWkXsOcY1GRNqXuxWi5O1qT5YLhykWwljTWA3qM
ksoGXQBIgQgCelJWHhcf5/pVVVKDdlViD4K2WqsuEX4YKaC9zj8aiH0WRns5sVyh
7WLI72JR+xl9xQw9gUMtw1gx1aWOWzTS4vx3BUthEUKGq2uS17C9Rq/WQPj1Mt88
7JP/9Pw4i6tjDYXE1kQV2Fou3FB6oqWnTl97L0Zhslni+9Uskxg=
=Cy5J
-----END PGP SIGNATURE-----

--=-5mtijeWolg70nhqPo19T--
