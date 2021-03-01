Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72BC32937F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhCAVWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:22:04 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60370 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhCAVUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:20:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5197B1C0B88; Mon,  1 Mar 2021 22:19:26 +0100 (CET)
Date:   Mon, 1 Mar 2021 22:19:25 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <20210301211925.GC1284@amd>
References: <20210301193642.707301430@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here (failures are due to
unavailable boards).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA9Wl0ACgkQMOfwapXb+vJCYQCfUIHyXlIJEKBoplox3h40px7g
zC4An2wdb25JBFs2959aQbYr1cKUxnKZ
=JGHQ
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
