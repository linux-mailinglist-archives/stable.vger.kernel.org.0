Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD52330519
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 23:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhCGW6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 17:58:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50770 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbhCGW6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 17:58:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1465C1C0B76; Sun,  7 Mar 2021 23:57:58 +0100 (CET)
Date:   Sun, 7 Mar 2021 23:57:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/52] 4.19.179-rc1 review
Message-ID: <20210307225757.GA1911@amd>
References: <20210305120853.659441428@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.179 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here (apart from missing boards
-- not a kernel problem):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBFWnQACgkQMOfwapXb+vLongCgleNZnHl5GPb/DsYvVK4RuZ4j
HxQAnjDcOx9eq9s719L7j0/Exx3hpwsZ
=ffof
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
