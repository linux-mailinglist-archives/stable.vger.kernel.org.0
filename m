Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB21C3B9075
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhGAKYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 06:24:17 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52636 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhGAKYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 06:24:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C28701C0B77; Thu,  1 Jul 2021 12:21:45 +0200 (CEST)
Date:   Thu, 1 Jul 2021 12:21:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
Message-ID: <20210701102145.GB2837@amd>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
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

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDdlzkACgkQMOfwapXb+vIStACgikfQXWQQDO1Fq+0W7YfHczn7
7VAAn3S7RCF+VXl9QdLWWOvN0N5BzTnH
=DEQr
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
