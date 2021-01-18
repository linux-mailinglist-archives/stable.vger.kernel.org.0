Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCB2F9CCF
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbhARK0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34288 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388560AbhARJad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:30:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0D4B21C0B78; Mon, 18 Jan 2021 10:29:23 +0100 (CET)
Date:   Mon, 18 Jan 2021 10:29:22 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <20210118092922.GA3733@amd>
References: <20210115122006.047132306@linuxfoundation.org>
 <20210116075731.GA14187@amd>
 <YAQ54hsnWcKlzhdt@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <YAQ54hsnWcKlzhdt@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 5.10.8 release.
> > > There are 103 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > CIP testing did not find any problems here:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/li=
nux-5.10.y
> >=20
> > Tested-by: Pavel Machek (CIP) <pavel@denx.de>
>=20
> Hey, CIP cares about 5.10.y?  Nice?  Thanks for testing.

Yes, we do. We need "new" kernel every few years, and it is going to
be 5.10. Thanks for kernels :-).

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAFVPIACgkQMOfwapXb+vJ3XgCgpQ6JKNcY5H+9NyAw134g6cRg
qB4AniJY0ThfRLgxUBjcukDc/EYRhzTM
=3bKF
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
