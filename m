Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253CD3318B0
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 21:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCHUgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 15:36:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCHUgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 15:36:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5624F1C0B76; Mon,  8 Mar 2021 21:35:59 +0100 (CET)
Date:   Mon, 8 Mar 2021 21:35:58 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
Message-ID: <20210308203558.GA24229@duo.ucw.cz>
References: <20210308122718.120213856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here (failures are due to
offline boards, not due to kernel problem):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYEaKrgAKCRAw5/Bqldv6
8pVHAKCiFumTtZxvjp6KcA8sl3nkWPriuQCfXYJIH64/PlWwYh1IfuygyEU2dnc=
=3wAt
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
