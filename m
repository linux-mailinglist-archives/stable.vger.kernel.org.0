Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FCD4862C3
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 11:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiAFKQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 05:16:22 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39046 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiAFKQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 05:16:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 398E61C0B79; Thu,  6 Jan 2022 11:16:20 +0100 (CET)
Date:   Thu, 6 Jan 2022 11:16:19 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20220106101618.GA13602@amd>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213103536.GC17683@duo.ucw.cz>
 <YbdAE9r9GXZlnyfr@kroah.com>
 <CAEUSe794fvuFwWPDvTeK1TRZw3OizSWOdDsVzVdj+SuWZA_LxA@mail.gmail.com>
 <CAEUSe7-CD5jvro+7DgM-6N_G-Ab_ovNFLG1b_F_ZsTAYJ23D-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CAEUSe7-CD5jvro+7DgM-6N_G-Ab_ovNFLG1b_F_ZsTAYJ23D-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I wonder if you saw this message of mine the other day.

Seen the message.

> > > > I'm getting a lot of build failures -- missing gmp.h:
> > > >
> > > >   UPD     include/generated/utsrelease.h
> > > > 1317In file included from /builds/hVatwYBy/68/cip-project/cip-testi=
ng/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc=
/arm-linux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
> > > > 1318                 from scripts/gcc-plugins/gcc-common.h:7,
> > > > 1319                 from scripts/gcc-plugins/arm_ssp_per_task_plug=
in.c:3:
> > > > 1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/=
gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1=
=2E0/plugin/include/system.h:687:10: fatal error: gmp.h: No such file or di=
rectory
> > > > 1321 #include <gmp.h>
> > > > 1322          ^~~~~~~
> > > > 1323compilation terminated.
> > > > 1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc=
-plugins/arm_ssp_per_task_plugin.so' failed
> > > > 1325
> > > >
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tre=
e/linux-5.10.y
> > >
> > > What gcc plugins are you trying to build with?
> >
> > We saw a similar problem with mainline/next about a year ago, after
> > v5.10 was released. In our case it failed with gmp.h because
> > libmpc-dev was not installed on the host; then libiberty-dev was
> > needed too
> [...]
>=20
> We installed libgmp-dev, libmpc-dev and libiberty-dev. That generally
> helps. FWIW, this is needed for 5.11+.

Yep, but I'm not the one that can do the installation, our q&a team
does that. They are aware of the problem now, but it may take a while
to solve due to holidays etc.

I believe -stable team should be more conservative and should not
introduce regressions like this.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHWwXIACgkQMOfwapXb+vK72gCgswvnB1KvNlN6zFVbXeHfvM9J
kz0AoKqaz1qJDBeVL9LFHN4/h8Wz23gK
=aB+j
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
