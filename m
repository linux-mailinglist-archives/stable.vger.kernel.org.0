Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B092CA798
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbgLAQA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:00:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59974 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388374AbgLAQA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 11:00:28 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 825211C0BCB; Tue,  1 Dec 2020 16:59:47 +0100 (CET)
Date:   Tue, 1 Dec 2020 16:59:46 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/24] 4.4.247-rc1 review
Message-ID: <20201201155946.GB25115@amd>
References: <20201201084637.754785180@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.247 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>

No problems detected during testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/GaHIACgkQMOfwapXb+vJdpwCeJIJrfA3avbcJF5LbyVfXx/hU
fxIAn3BZBay1MMmBFw3uW9IL3MC27wrw
=vHeW
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
