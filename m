Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D84330472
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhCGUS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 15:18:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51248 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhCGUSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 15:18:12 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 04F451C0B76; Sun,  7 Mar 2021 21:18:10 +0100 (CET)
Date:   Sun, 7 Mar 2021 21:18:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <20210307201809.GA26738@amd>
References: <20210305120849.381261651@linuxfoundation.org>
 <20210305220634.GA27686@amd>
 <YEM4d6O+6Jfw3RH/@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <YEM4d6O+6Jfw3RH/@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
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

> > Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
> > strange, but it looks like real test failure.

Some kind of timeout, fixed by re-run. So CIP testing did not find any
problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBFNQAACgkQMOfwapXb+vLeawCfSi0Dk/0Zx/D7T5Y+Qyup7jff
XasAoKqaOubTWE7A3Ry1B3USYRPAO4aK
=kuGf
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
