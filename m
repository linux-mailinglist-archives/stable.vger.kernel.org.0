Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1A49B9C0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbiAYRI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:08:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33264 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiAYRFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:05:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 928791C0B88; Tue, 25 Jan 2022 18:05:43 +0100 (CET)
Date:   Tue, 25 Jan 2022 18:05:43 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
Message-ID: <20220125170543.GA26196@duo.ucw.cz>
References: <20220125155348.141138434@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any new kernel problems here (but we still
hit the gmp.h compilation issue; people are working to provide newer
build environment):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfAt5wAKCRAw5/Bqldv6
8rt0AJwOmCs1KTQIzCW+P8wnBn53dM4Y8QCcDOasgytvzoPeZhbp0qNL5F9K/pE=
=vKVJ
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
