Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1421A46C1F3
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhLGRmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 12:42:17 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56510 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhLGRmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 12:42:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A49371C0B82; Tue,  7 Dec 2021 18:38:41 +0100 (CET)
Date:   Tue, 7 Dec 2021 18:38:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/125] 5.10.84-rc2 review
Message-ID: <20211207173837.GA27023@duo.ucw.cz>
References: <20211207081114.760201765@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.
CIP testing did not find any problems here:                                =
               =20
                                                                           =
               =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y         =20
                                                                           =
               =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
               =20
                                                                           =
               =20
Best regards,                                                              =
               =20
                                                                Pavel      =
               =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYa+cHQAKCRAw5/Bqldv6
8gPpAJ9VH8ge+EBxF2CezwBHSdbqWV4asQCfaRUxan/99Mnqjz0utsRBZddHqXo=
=lQ+S
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
