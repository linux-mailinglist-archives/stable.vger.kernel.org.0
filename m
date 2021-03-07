Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D4D32FF99
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 09:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCGIVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 03:21:23 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39270 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhCGIVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 03:21:05 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 59AEB1C0B76; Sun,  7 Mar 2021 09:20:58 +0100 (CET)
Date:   Sun, 7 Mar 2021 09:20:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: qemu meltdown test failure was Re: [PATCH 4.4 00/30] 4.4.260-rc1
 review
Message-ID: <20210307082057.GA18813@amd>
References: <20210305120849.381261651@linuxfoundation.org>
 <20210305220634.GA27686@amd>
 <YEM4d6O+6Jfw3RH/@kroah.com>
 <20210307000403.GB10472@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20210307000403.GB10472@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Ok, so we ran some tests.
> > >=20
> > > And they failed:
> > >=20
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/=
1075959449
> > >=20
> > > [   26.785861] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2018-3639 RES=
ULT=3Dfail>
> > > Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2018-3639 RESULT=3Dfail
> > >=20
> > > Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
> > > strange, but it looks like real test failure.

This is pointer to the pipeline:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
65992696

> First let me try 7d472e4a11d6a2fb1c492b02c7d7dacd3297bbf4 --
> v4.4.257-cip54. That is
> https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/266532179
> ... Qemu is OKAY.
>=20
> add3ff3730919447a7519fede0b8554132e0f8d5 Merge remote-tracking branch
> 'stable/queue/4.4' in to v4.4.260-bisect. Results will be at
> https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/266534478
> ... ... still pending.

Qemu is okay here, too.

> test 266539168       8c461bb103f89696576945ad9cb376df34fa9d28 xen-netback=
: respect gnttab_map_refs()'s return value

Qemu is ok.

> test 266538760       1efe86b456816c95485c65cf9ba46a5bff8a241e staging: fw=
serial: Fix error handling in fwserial_create

Qemu is ok.

> test 266539768       8b4bc0f97fdd13b08c2436aad01bd4515d07f93a iwlwifi: pc=
ie: fix to correct null check
								Pavel
Qemu is ok.

https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/266539768

So... failure apparently went away when trying to
bisect. That's.... strange? Aha, except that it looks like the same
"suceeded" tests still have failures in them:

https://lava.ciplatform.org/scheduler/job/173186

[   26.224557] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2017-5715
RESULT=3Dfail>
Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2017-5715 RESULT=3Dfail

=2E..I guess those fails are expected, then? And qemu tests on
-stable-rc are really failing on timeouts. ... Hmm, let's just re-run
the tests.

I'm still not sure, but it looks like a test failure now.

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBEjOkACgkQMOfwapXb+vJSawCgqzPUaxWoCbbt4lqBbSqzYHfz
5YIAn300t/XybF+CBlfvxUd8lng7PiCs
=sF+b
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
