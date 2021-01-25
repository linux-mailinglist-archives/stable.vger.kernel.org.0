Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F71302CF5
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbhAYUv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:51:59 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47416 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732000AbhAYUvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 15:51:50 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0E7231C0B81; Mon, 25 Jan 2021 21:51:09 +0100 (CET)
Date:   Mon, 25 Jan 2021 21:51:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/199] 5.10.11-rc1 review
Message-ID: <20210125205108.GB5220@duo.ucw.cz>
References: <20210125183216.245315437@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.11 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

(siemens board has problems before kernel is started, so that is not
real failure)

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYA8vPAAKCRAw5/Bqldv6
8ttIAJ9g8H6CjEPuKTdtMxz0sGpo7anEHwCffL1Pvv0DkLQrSLPgG9bSHxar9kQ=
=YzUW
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
