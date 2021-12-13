Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174FB4734BC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhLMTQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:16:59 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40674 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbhLMTQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:16:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CD67D1C0B7A; Mon, 13 Dec 2021 20:16:56 +0100 (CET)
Date:   Mon, 13 Dec 2021 20:16:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris.paterson2@renesas.com, alice.ferrazzi@miraclelinux.com
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20211213191648.GA21320@amd>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213103536.GC17683@duo.ucw.cz>
 <YbdAE9r9GXZlnyfr@kroah.com>
 <YbdCag/DPOOrweZX@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <YbdCag/DPOOrweZX@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > I'm getting a lot of build failures -- missing gmp.h:
> > >=20
> > >   UPD     include/generated/utsrelease.h
> > > 1317In file included from /builds/hVatwYBy/68/cip-project/cip-testing=
/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/a=
rm-linux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
> > > 1318                 from scripts/gcc-plugins/gcc-common.h:7,
> > > 1319                 from scripts/gcc-plugins/arm_ssp_per_task_plugin=
=2Ec:3:
> > > 1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gc=
c/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0=
/plugin/include/system.h:687:10: fatal error: gmp.h: No such file or direct=
ory
> > > 1321 #include <gmp.h>
> > > 1322          ^~~~~~~
> > > 1323compilation terminated.
> > > 1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc-p=
lugins/arm_ssp_per_task_plugin.so' failed
> > > 1325
> > >=20
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/=
linux-5.10.y
> >=20
> > What gcc plugins are you trying to build with?
>=20
> Also, kernelci seems normal for this release:
> 	https://linux.kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/v5=
=2E10.84-133-gf6a609e247c6/
>=20
> But your tests show problems:
> 	https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipeline=
s/428150268/failures
> all for gcc plugins.
>=20
> I did take changes for the gcc plugins to get them to work for gcc 11,
> maybe gcc8 is too old for them now?

Not sure. Maybe they never worked for us, but without test compile,
they are now enabled and thus can break the build?

1e8600 gcc-plugins: simplify GCC plugin-dev capability test

Could be capable of doing that. Let me cc our people doing the
testing and let me try to do some test compiles...

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmG3nCAACgkQMOfwapXb+vLX1gCgrC0HM+8dR4y2d53f4Jb1kWV+
M/MAn1myLKbua9D1EzkkTV4Izo8VdVR9
=ugbA
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
