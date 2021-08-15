Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836C43ECAB7
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 21:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhHOTtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 15:49:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48386 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhHOTtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 15:49:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9FBE61C0B77; Sun, 15 Aug 2021 21:48:59 +0200 (CEST)
Date:   Sun, 15 Aug 2021 21:48:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/19] 5.10.59-rc1 review
Message-ID: <20210815194859.GA23194@duo.ucw.cz>
References: <20210813150522.623322501@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.59 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.

CIP testing did not find any kernel problems here: (but we have some
infrastructure problems)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRlvqwAKCRAw5/Bqldv6
8j7yAJ4xgeywrjtkhTtZ+CzILvx6lrDR/wCgmHDWpUAtkpeO1ADAqIlWnyRpYmY=
=il0U
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
