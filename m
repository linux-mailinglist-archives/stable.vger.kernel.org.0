Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DBE33033A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 18:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhCGRSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 12:18:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49780 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhCGRS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 12:18:28 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F155C1C0B76; Sun,  7 Mar 2021 18:18:25 +0100 (CET)
Date:   Sun, 7 Mar 2021 18:18:25 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <20210307171824.GA22500@amd>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305221030.GB27686@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20210305221030.GB27686@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.21 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> Here situation is similar to 4.4
>=20
> [   27.349919] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2017-5715 RESULT=
=3Dfail>
> Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2017-5715 RESULT=3Dfail
>=20
> So I see some kind of failure, and this time I suspect real kernel
> problem.
>=20
> https://lava.ciplatform.org/scheduler/job/171825
>=20
> 4.19 has similar problem:
>=20
> https://lava.ciplatform.org/scheduler/job/171812
>=20
> Again, Ccing Chris, but it looks like something is wrong there.

It went away after I reran the tests, and the old tests failed due to
timeout. So it looks like server with qemu was overloaded or something
like that. There are still failures, but they are "boards not
available" kind, so not a kernel problem.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBFCuAACgkQMOfwapXb+vLl1gCgtiAJQL+9+8BJavKH8SrLJ1xb
KHYAn1HaW4nh2NQqvvYmD7Uxx7kmcZ7Y
=acNo
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
