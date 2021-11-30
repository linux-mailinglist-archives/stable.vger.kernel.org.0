Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16113463AE5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 17:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhK3QG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 11:06:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60164 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbhK3QG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 11:06:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 423541C0B9C; Tue, 30 Nov 2021 17:03:06 +0100 (CET)
Date:   Tue, 30 Nov 2021 17:03:05 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
Message-ID: <20211130160305.GB12931@duo.ucw.cz>
References: <20211129181711.642046348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
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

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYaZLOQAKCRAw5/Bqldv6
8l7DAJwM0CBCfqe2Fwo4wWlrPAZkoz7P9gCdFXpUUILmp2GQJE6KX6dFBL5RQv0=
=q96R
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
