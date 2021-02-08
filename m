Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB529313DAA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhBHShB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:37:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbhBHSf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 13:35:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6801C1C0B78; Mon,  8 Feb 2021 19:34:54 +0100 (CET)
Date:   Mon, 8 Feb 2021 19:34:53 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.175-rc1 review
Message-ID: <20210208183453.GB14334@duo.ucw.cz>
References: <20210208145806.141056364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.175 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYCGETQAKCRAw5/Bqldv6
8jltAKCaVrVxCm2N2dxvGMzTnFU8fkJMFwCeNPo+lofjqRhTIWTVX1s2YsGE5wc=
=GEEE
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
