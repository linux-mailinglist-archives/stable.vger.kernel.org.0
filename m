Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9941B45C58F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348961AbhKXN7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:20 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44680 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352962AbhKXN4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 08:56:30 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2BA271C0B7C; Wed, 24 Nov 2021 14:53:19 +0100 (CET)
Date:   Wed, 24 Nov 2021 14:53:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
Message-ID: <20211124135311.GA29193@duo.ucw.cz>
References: <20211124115702.361983534@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.82 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP is running tests here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

And there's a build failure in CIP testing there:

  CC      drivers/mmc/core/sdio_ops.o
5040drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
5041drivers/cpuidle/cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY=
' undeclared (first use in this function); did you mean 'TEGRA_SUSPEND_NONE=
'?
5042  if (tegra_pmc_get_suspend_mode() =3D=3D TEGRA_SUSPEND_NOT_READY)
5043                                      ^~~~~~~~~~~~~~~~~~~~~~~
5044                                      TEGRA_SUSPEND_NONE
5045drivers/cpuidle/cpuidle-tegra.c:349:38: note: each undeclared identifie=
r is reported only once for each function it appears in
5046  CC      drivers/gpu/drm/drm_dma.o
5047scripts/Makefile.build:280: recipe for target 'drivers/cpuidle/cpuidle-=
tegra.o' failed
5048scripts/Makefile.build:497: recipe for target 'drivers/cpuidle' failed
5049make[2]: *** [drivers/cpuidle/cpuidle-tegra.o] Error 1
5050make[1]: *** [drivers/cpuidle] Error 2
5051make[1]: *** Waiting for unfinished jobs....
5052  CC      drivers/cpufreq/raspberrypi-cpufreq.o

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYZ5DxwAKCRAw5/Bqldv6
8nyxAJ932Uynpn1BTYP3wbBqxvMUdHuJpACXVo2qXdIKO2L3nXQIWy/TlNZkrA==
=lZc9
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
