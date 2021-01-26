Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E9303BD1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbhAZLjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:39:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50088 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405236AbhAZLjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:39:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 64FD41C0B82; Tue, 26 Jan 2021 12:38:18 +0100 (CET)
Date:   Tue, 26 Jan 2021 12:38:17 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <20210126113817.GA23197@amd>
References: <20210126094313.589480033@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20210126094313.589480033@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.11 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here. (Due to minimal changs
between -rc1 and rc2, that's expectd I guess)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
							=09

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAP/ykACgkQMOfwapXb+vK1+wCbBObVfpAMyhSICShA6DCt1dQy
fsYAn0kLoeBXkr5RulLT9kxUBLdAKiXW
=82Cd
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
