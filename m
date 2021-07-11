Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9F73C3B1E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 09:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhGKICS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 04:02:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59226 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhGKICR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 04:02:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A9E1D1C0B79; Sun, 11 Jul 2021 09:59:29 +0200 (CEST)
Date:   Sun, 11 Jul 2021 09:59:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
Message-ID: <20210711075929.GA14434@duo.ucw.cz>
References: <20210709131644.969303901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
             =20
                                                                           =
             =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y       =20
                                                                           =
             =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
             =20
                                                                           =
             =20
Best regards,                                                              =
             =20
                                                                Pavel      =
             =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYOqk4QAKCRAw5/Bqldv6
8tLzAKCQ41jKpbeRp0/5iGFM8QBzPefz6ACfbRW3k2ru4yDAtRdvXnTRvujV3EU=
=2XPl
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
