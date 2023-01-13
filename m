Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6965D66932A
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 10:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjAMJn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 04:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240940AbjAMJmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 04:42:38 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C236C13F37;
        Fri, 13 Jan 2023 01:33:02 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D17141C0AB2; Fri, 13 Jan 2023 10:33:00 +0100 (CET)
Date:   Fri, 13 Jan 2023 10:32:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y8ElS+jivE5FWvku@amd.ucw.cz>
References: <20230110180017.145591678@linuxfoundation.org>
 <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XYCzQcN7upoMrEuL"
Content-Disposition: inline
In-Reply-To: <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XYCzQcN7upoMrEuL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 Raspberry Pi 4 Model B.
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> While running LTP controllers cgroup_fj_stress_blkio test cases
> the Insufficient stack space to handle exception! occurred and
> followed by kernel panic on arm64 Raspberry Pi 4 Model B with
> clang-15 built kernel Image.
>=20
> The full boot and test log attached to this email and build and
> Kconfig links provided in the bottom of this email.

Full log is 11MB. That's rather... big for an email. Please post such
stuff as a link or at least compress them...

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XYCzQcN7upoMrEuL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8ElSwAKCRAw5/Bqldv6
8nsQAJ9lZgYFZdyj9N+xPb683pLscM0lqgCcDrW+2w/2k3wcoopdIFYzgsvsejA=
=ON0+
-----END PGP SIGNATURE-----

--XYCzQcN7upoMrEuL--
