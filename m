Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9104549EB3D
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 20:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbiA0Tne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 14:43:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40506 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245680AbiA0Tne (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 14:43:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B67E71C0B77; Thu, 27 Jan 2022 20:43:32 +0100 (CET)
Date:   Thu, 27 Jan 2022 20:43:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.4 0/1] 4.4.301-rc1 review
Message-ID: <20220127194332.GA2296@duo.ucw.cz>
References: <20220127180256.347004543@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.301 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfL15AAKCRAw5/Bqldv6
8jeeAJ9dNxjyuXiu2Rhf7XI0PMAsR0+Q+gCfZNY2fr82DGKi4g2pWvNhAa1PeEY=
=TDbc
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
