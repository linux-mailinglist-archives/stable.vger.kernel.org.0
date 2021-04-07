Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85AB3566B3
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhDGIXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:23:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47104 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhDGIXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 04:23:48 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 21EB61C0BD8; Wed,  7 Apr 2021 10:23:37 +0200 (CEST)
Date:   Wed, 7 Apr 2021 10:23:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/56] 4.19.185-rc1 review
Message-ID: <20210407082336.GB5425@amd>
References: <20210405085022.562176619@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.185 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (Siemens boards
are unavailable)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBtbAgACgkQMOfwapXb+vIU7QCggowsFdeFY/+FND5xN6kCckK7
4ZIAn3gtv1eRKGjYTgLAiKQs1Iby8feR
=vkVN
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
