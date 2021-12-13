Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81898472A44
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhLMKf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:35:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:41520 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbhLMKfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:35:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 036AD1C0B79; Mon, 13 Dec 2021 11:35:38 +0100 (CET)
Date:   Mon, 13 Dec 2021 11:35:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20211213103536.GC17683@duo.ucw.cz>
References: <20211213092939.074326017@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm getting a lot of build failures -- missing gmp.h:

  UPD     include/generated/utsrelease.h
1317In file included from /builds/hVatwYBy/68/cip-project/cip-testing/linux=
-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-lin=
ux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
1318                 from scripts/gcc-plugins/gcc-common.h:7,
1319                 from scripts/gcc-plugins/arm_ssp_per_task_plugin.c:3:
1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-=
8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0/plugi=
n/include/system.h:687:10: fatal error: gmp.h: No such file or directory
1321 #include <gmp.h>
1322          ^~~~~~~
1323compilation terminated.
1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc-plugins=
/arm_ssp_per_task_plugin.so' failed
1325

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYbch+AAKCRAw5/Bqldv6
8vFlAJ4/cFdcZ0mHwlIpdGlD/JLWEPQdFACgren9AHtAWKjtur3o7vGPP4MJ6bo=
=DOah
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
