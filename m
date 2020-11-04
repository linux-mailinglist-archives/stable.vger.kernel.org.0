Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AB2A5EB0
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 08:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKDH0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 02:26:08 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34948 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgKDH0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 02:26:08 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 83BA81C0B77; Wed,  4 Nov 2020 08:26:04 +0100 (CET)
Date:   Wed, 4 Nov 2020 08:26:03 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/191] 4.19.155-rc1 review
Message-ID: <20201104072603.GA31365@amd>
References: <20201103203232.656475008@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.155 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.

No errors detected in CIP testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+iV4sACgkQMOfwapXb+vK6HgCfUFKyL0CbG4jmgr71UJuYhX/2
uHkAoLrGKZyMooNDUGgPVRQSV3I53SdB
=GYed
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
