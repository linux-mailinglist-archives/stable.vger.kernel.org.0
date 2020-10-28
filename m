Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539629E137
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 02:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgJ2By0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 21:54:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgJ1V44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:56:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 183C61C0BAE; Wed, 28 Oct 2020 17:00:01 +0100 (CET)
Date:   Wed, 28 Oct 2020 17:00:00 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201028160000.GD28011@duo.ucw.cz>
References: <20201027135430.632029009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.153 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> Anything received after that time might be too late.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
08235954

It shows failed run -- https://lava.ciplatform.org/scheduler/job/73174
-- but that seems to be something wrong with our test infrastructure.
So... no problems detected by CIP project.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5mVgAAKCRAw5/Bqldv6
8hCaAJ4ubMHIgAMFAzmXt392RWQgNu5oewCffWQyaI8MpT5kRh+CaRsrvfrhJ7A=
=d4xn
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
