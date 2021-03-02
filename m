Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27C32B0D9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhCCAjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:42 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50346 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574196AbhCBPOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 10:14:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6A3241C0B8E; Tue,  2 Mar 2021 16:13:22 +0100 (CET)
Date:   Tue, 2 Mar 2021 16:13:21 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/247] 4.19.178-rc3 review
Message-ID: <20210302151321.GA16953@duo.ucw.cz>
References: <20210302122300.309814713@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20210302122300.309814713@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.178 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 04 Mar 2021 12:22:09 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here (failures are not kernel
related). Compile problem we saw in -rc2 is gone.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYD5WEQAKCRAw5/Bqldv6
8qJWAJ487NYijpcf4r0mzGaBPzaaYvB37gCfZKiv2uTaQsjXqMzxWop65gDnUXA=
=cWKN
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
