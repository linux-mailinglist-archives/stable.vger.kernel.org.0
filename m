Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C032F5B3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 23:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCEWGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 17:06:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46280 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhCEWGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 17:06:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 573C11C0B81; Fri,  5 Mar 2021 23:06:35 +0100 (CET)
Date:   Fri, 5 Mar 2021 23:06:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris.Paterson2@renesas.com
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <20210305220634.GA27686@amd>
References: <20210305120849.381261651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.260 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Ok, so we ran some tests.

And they failed:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/107595=
9449

[   26.785861] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2018-3639 RESULT=3D=
fail>
Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2018-3639 RESULT=3Dfail

Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
strange, but it looks like real test failure.

I'm cc: ing Chris, perhaps he can help.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBCq2oACgkQMOfwapXb+vJeZgCgkQQCgXjzaDGyk/wIwvRJkfOl
qNsAn0eDH2zeeH9H1nHqNZObBvQtPd4F
=cbFg
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
