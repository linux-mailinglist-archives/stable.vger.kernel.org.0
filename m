Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF232AFFC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344329AbhCCAyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:13 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39052 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhCBVa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 16:30:57 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5204D1C0B81; Tue,  2 Mar 2021 22:29:20 +0100 (CET)
Date:   Tue, 2 Mar 2021 22:29:19 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc4 review
Message-ID: <20210302212919.GA25395@amd>
References: <20210302192550.512870321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20210302192550.512870321@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA+ri8ACgkQMOfwapXb+vJVYACgmRIht0l1gNFh+9370cEP+o+5
dw0AoJ4S2/1GkOQkW9p0HP3IBBRS0CfC
=/9qU
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
