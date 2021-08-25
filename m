Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3EA3F7078
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 09:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhHYHgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 03:36:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48730 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhHYHgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 03:36:14 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3061C1C0B7A; Wed, 25 Aug 2021 09:35:28 +0200 (CEST)
Date:   Wed, 25 Aug 2021 09:35:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <20210825073527.GC4193@duo.ucw.cz>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.61 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSXyvwAKCRAw5/Bqldv6
8h1jAKDEUhA+GWQE6PbHYv5QpfrdLDau5wCeIC8zE3jYLYX0bIc1Iztd80s1XL8=
=pSc2
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
