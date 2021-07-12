Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AECE3C5A31
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhGLJiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:38:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59590 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbhGLJiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 05:38:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7D86A1C0B7C; Mon, 12 Jul 2021 11:35:26 +0200 (CEST)
Date:   Mon, 12 Jul 2021 11:35:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
Message-ID: <20210712093526.GA23916@duo.ucw.cz>
References: <20210712060843.180606720@linuxfoundation.org>
 <dfcae9165b814757b9853c28cc11e820@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <dfcae9165b814757b9853c28cc11e820@HQMAIL111.nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

(2000 lines trimmed)

> >  tools/testing/selftests/vm/protection_keys.c       |  12 +-
> >  638 files changed, 5205 insertions(+), 2782 deletions(-)

> All tests passing for Tegra ...
>=20
> Test results for stable-v5.10:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     70 tests:	70 pass, 0 fail
>=20
> Linux version:	5.10.50-rc1-g3e2628c73ba0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
>=20
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing... but could we get you to snip the parts of email
not important for the reply?

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYOwM3gAKCRAw5/Bqldv6
8hloAKC5GOBRcQKI/g7kJoTE6e2uI59+pQCfQlFRU1kMQ5dcTj6R52OmeeYEpvk=
=+L7R
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
