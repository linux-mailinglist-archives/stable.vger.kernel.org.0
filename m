Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738412E3598
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgL1Jvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:51:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55436 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgL1Jvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:51:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 624FB1C0BA3; Mon, 28 Dec 2020 10:50:41 +0100 (CET)
Date:   Mon, 28 Dec 2020 10:50:40 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <20201228095040.GA11960@amd>
References: <20201223150515.553836647@linuxfoundation.org>
 <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
 <X+dRkTq+T+A6nWPz@kroah.com>
 <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
 <X+iwvG2d0QfPl+mc@kroah.com>
 <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.3-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0git://git.kernel.org/pub/scm/linux/kern=
el/git/stable/
> > > > > > linu
> > > > > > x-
> > > > > > stable-rc.git linux-5.10.y
> > > > > > and the diffstat can be found below.
> > > > > >=20
> > > > > > thanks,
> > > > > >=20
> > > > > > greg k-h
> > > > >=20
> > > > > hello ,
> > > > > Compiled and booted 5.10.3-rc1+.
> > > > >=20
> > > > > dmesg -l err gives...
> > > > > --------------x-------------x------------------->
> > > > > =A0=A0 43.190922] Bluetooth: hci0: don't support firmware rome
> > > > > 0x31010100
> > > > > --------------x---------------x----------------->
> > > > >=20
> > > > > My Bluetooth is Off.
> > > >=20
> > > > Is this a new warning?=A0 Does it show up on 5.10.2?
> > > >=20
> > > > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > > >=20
> > > > thanks for testing?
> > > >=20
> > > > greg k-h
> > >=20
> > > this does not show up in 5.10.2-rc1+
> >=20
> > Odd.=A0 Can you run 'git bisect' to find the offending commit?
> >=20
> > Does this same error message show up in Linus's git tree?

> i will try to do "git bisect" .  i saw this error in linus's  tree.

The bug is in -stable, too, so it is probably easiest to do bisect on
-stable tree. IIRC there's less then few hundred commits, so it should
be feasible to do bisection by hand if you are not familiar with git
bisect.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/pqnAACgkQMOfwapXb+vKC1gCgmzjlt67NwgFrNRpxB9XQH5bA
4HQAnj9CzHKtEA7HbPHvfTCuEK9pGwmY
=Ay4Y
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
