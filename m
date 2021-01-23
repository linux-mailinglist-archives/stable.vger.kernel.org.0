Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0719C30145D
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 10:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbhAWJxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 04:53:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53640 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbhAWJxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 04:53:36 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DDAB81C0B77; Sat, 23 Jan 2021 10:52:46 +0100 (CET)
Date:   Sat, 23 Jan 2021 10:52:45 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <20210123095244.GA6686@amd>
References: <20210122135735.652681690@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.10 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAL8ewACgkQMOfwapXb+vJ0oACaA4NZf4nzt1q9PlCcXKoKCziV
iPsAoL6vZNxRo7bd+gEvZoGbfd1TmvGg
=x5RA
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
