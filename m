Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F732FDF4
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 00:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCFXIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 18:08:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54154 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCFXHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 18:07:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 523F31C0B76; Sun,  7 Mar 2021 00:07:42 +0100 (CET)
Date:   Sun, 7 Mar 2021 00:07:39 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <20210306230738.GA10472@amd>
References: <20210305120849.381261651@linuxfoundation.org>
 <20210305220634.GA27686@amd>
 <YEM4d6O+6Jfw3RH/@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <YEM4d6O+6Jfw3RH/@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.4.260 release.
> > > There are 30 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Ok, so we ran some tests.
> >=20
> > And they failed:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/10=
75959449
> >=20
> > [   26.785861] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2018-3639 RESUL=
T=3Dfail>
> > Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2018-3639 RESULT=3Dfail
> >=20
> > Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
> > strange, but it looks like real test failure.
> >=20
> > I'm cc: ing Chris, perhaps he can help.
>=20
> Can you bisect?

I'm kind of hoping someone else hits this, too, as I'm not that
experienced with the CIP q/a system.

But in the meantime I resubmitted older kerneland it is passing on
qemu, so it looks it might be real.=20

I can probably bisect it on Monday. I may try to start bisection on
Sunday.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBECzkACgkQMOfwapXb+vLYsgCcDq6xNI1KHZ1Ln8p//eZ98ibu
YswAn2918UP8KkvwtVydTyyF0X3425UR
=bfQT
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
