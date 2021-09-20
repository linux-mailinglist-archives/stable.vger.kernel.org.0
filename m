Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2659412742
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 22:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhITU2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 16:28:42 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47086 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhITU0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 16:26:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A9EBA1C0B77; Mon, 20 Sep 2021 22:25:13 +0200 (CEST)
Date:   Mon, 20 Sep 2021 22:25:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
Message-ID: <20210920202513.GB17566@duo.ucw.cz>
References: <20210920163933.258815435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUjuKQAKCRAw5/Bqldv6
8u1tAKCUVZSEz+5zIOOZFa10UyF00UkFiwCghI+W7AqlTFB97av5XTeU3cqwz+c=
=Imd3
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
