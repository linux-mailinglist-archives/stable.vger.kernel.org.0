Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B61549386C
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353687AbiASK3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:29:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44346 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiASK3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:29:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3FA051C0B9B; Wed, 19 Jan 2022 11:28:59 +0100 (CET)
Date:   Wed, 19 Jan 2022 11:28:58 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: 4.4 series end of line was Re: [PATCH 4.4 00/17] 4.4.297-rc1 review
Message-ID: <20220119102858.GB4984@amd>
References: <20211227151315.962187770@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.297 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

4.4.X series is scheduled for EOL next month. Do you have any
estimates if it will be more like Feb 2 or Feb 27?

CIP project is commited to maintaining 4.4.X after the EOL, and we
need to figure out what to do next. Is there anyone else interested in
maintaining 4.4.X after the February?

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHn5+kACgkQMOfwapXb+vK8uwCgxIPieXyeg2AHYBxOvxbcuHrA
Hw0AnjXHUxJS8GKTTn8ytrC3km7+L9WN
=UDuj
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
