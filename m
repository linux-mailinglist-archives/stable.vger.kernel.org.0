Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB933C99F
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhCOXEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:36 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232661AbhCOXEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:31 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id 1C0C14B4021D;
        Mon, 15 Mar 2021 15:57:04 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:03 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
Message-ID: <20210315155703.2024ca46@pc.lan>
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/0iRP7VtiU4LzdSRG9DD8iLk"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/0iRP7VtiU4LzdSRG9DD8iLk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:56:30 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 4.14.226 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/0iRP7VtiU4LzdSRG9DD8iLk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5j8ACgkQnQ2zG1Ra
MZjKExAAoUN+CLSU3K2D14vBTe4Br+kvrIJOSXVzVzz0F4U7g7Mm0uvdnKBB1jks
SP1jcgdam1d5PcCl7ratHttS23j7baC3g7Fk47L6sY/QsbbfZqsrkoxeu5zOTgy5
2K+pXm2fUbc9dKrfg1+PqtIhOjl2EqOaqM1sEtyOALTvu2Soeb+ElLtmzfO9eVTi
mFEvAQbHQGMqauTo+O94zYBXbANBb/VBaWv8mPVfIyxiJwdazaVsmHTuiwGe4ZgI
c0CX2UkjOA4JRw5BSOVvO0AT5GZNSAXGHSVDbCfs3jUX07roj9N+d83S9SzszXJb
XIgQQg76ehZA3sYfTOutgbFijxx1E26iGOvSsZ3ONcxD4cnd4BOV0owAfbbCzkRb
/+HKVUDEqkiu3hVIwZVcPv4qnqXBkc0qdyfQW+NnmeBC/yLiqn5ELbkyE10gGSMb
z6NAZ6caHHLGCVHs4yUysXGJCxFYvhWsaq6kYTMQq8euyAd3COU1fxWKt9P9jH0q
HcHLQxt3XvDoHqSlJchXAghvPN4gjg+5OetzgSVD6doBYsSq24NEwpiPC/6RYSSE
4u59sS40uZxjQi6tv9e6dJ+zLiArYa6zBeHwnMjYPrgo//QJ/qvTbPeAmgSldFcs
76H7zFeqLC2jiWh/lpfXPcZ/B1OU3IFGV3QVk+H0jkMf0dT6BsA=
=8oQo
-----END PGP SIGNATURE-----

--Sig_/0iRP7VtiU4LzdSRG9DD8iLk--
