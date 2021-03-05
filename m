Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD332F5B9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 23:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEWKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 17:10:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46508 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCEWKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 17:10:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0223F1C0B81; Fri,  5 Mar 2021 23:10:31 +0100 (CET)
Date:   Fri, 5 Mar 2021 23:10:30 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris.Paterson2@renesas.com
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <20210305221030.GB27686@amd>
References: <20210305120903.276489876@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.21 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Here situation is similar to 4.4

[   27.349919] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2017-5715 RESULT=3D=
fail>
Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2017-5715 RESULT=3Dfail

So I see some kind of failure, and this time I suspect real kernel
problem.

https://lava.ciplatform.org/scheduler/job/171825

4.19 has similar problem:

https://lava.ciplatform.org/scheduler/job/171812

Again, Ccing Chris, but it looks like something is wrong there.

Best regards,

								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBCrFYACgkQMOfwapXb+vKHgQCfS3aJwK05gzERZdRBvpUEtW5S
8LQAnjSF2fwBZJGTyZs88M7p5GakzMHJ
=vtK4
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
