Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7623B45EAE3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376563AbhKZKCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:02:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42100 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376568AbhKZKAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 05:00:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7B2111C0B77; Fri, 26 Nov 2021 10:57:20 +0100 (CET)
Date:   Fri, 26 Nov 2021 10:57:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
Message-ID: <20211126095718.GA2396@duo.ucw.cz>
References: <20211125092029.973858485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
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

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYaCvfgAKCRAw5/Bqldv6
8l88AJ9dd5oD0Tyt5hhIQeFmyYAvZuS4DgCeMNDtkY/HEBvR8Q7M8RX38+o15xY=
=9Ca0
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
