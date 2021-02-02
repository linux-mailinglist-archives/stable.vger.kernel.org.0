Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1C930C875
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237894AbhBBRux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:50:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58800 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbhBBRtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 12:49:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 297A41C0B7A; Tue,  2 Feb 2021 18:48:02 +0100 (CET)
Date:   Tue, 2 Feb 2021 18:48:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.173-rc1 review
Message-ID: <20210202174801.GA10685@amd>
References: <20210202132942.915040339@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.173 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAZkFEACgkQMOfwapXb+vLKAwCgqm71RZjhzEPV8oVKzk+Hyxgu
JyMAnR9z80Fz2Q0uG1xUhBiv+pXBVdU4
=n+Em
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
