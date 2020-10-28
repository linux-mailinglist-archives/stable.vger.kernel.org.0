Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65129D464
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgJ1Vv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:51:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51266 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgJ1Vv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:51:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 869F91C0BA9; Wed, 28 Oct 2020 16:54:59 +0100 (CET)
Date:   Wed, 28 Oct 2020 16:54:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/112] 4.4.241-rc1 review
Message-ID: <20201028155459.GC28011@duo.ucw.cz>
References: <20201027134900.532249571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-10-27 14:48:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.241 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
08235853

It shows failed compilation, but that seems to be test problem, not a
real problem. So... no problems detected by CIP project.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5mUUwAKCRAw5/Bqldv6
8jRAAJ9mU+r4+x70EcfRg7V+cDUKdbElNACfWGzTf5+pOjtiWSjzIrBJeoIJRUA=
=NkX+
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
