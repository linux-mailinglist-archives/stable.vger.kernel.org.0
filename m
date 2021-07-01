Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ECB3B9159
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhGAL5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 07:57:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33642 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhGAL5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 07:57:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A5DC21C0B77; Thu,  1 Jul 2021 13:55:18 +0200 (CEST)
Date:   Thu, 1 Jul 2021 13:55:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
Message-ID: <20210701115517.GA7328@amd>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.47 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Could I get Cc-ed on these mails for 5.10-stable releases? You'll get
more timely test results in exchange.

CIP testing did not find any kernel problems there (siemens board has
problems with network connectivity in bootloader?)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDdrSUACgkQMOfwapXb+vLhIwCglEgclh0qjyXLGJkW6zzSkXUL
yfcAniscUs9NkURJ7PjRtsL/QQAm6Mqq
=wkg1
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
