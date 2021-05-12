Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B037EEA9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbhELWEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:04:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51830 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345496AbhELUy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:54:28 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1121A1C0B80; Wed, 12 May 2021 22:53:09 +0200 (CEST)
Date:   Wed, 12 May 2021 22:53:08 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
Message-ID: <20210512205308.GA30312@duo.ucw.cz>
References: <20210512144819.664462530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.

While trying to review the patches... I discovered 5.10.36 is not
tagged in origin/queue:

commit 72bb632d15f2eabf22b085d79590125a6e2e1aa3
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue May 11 14:47:41 2021 +0200

    Linux 5.10.36
   =20
=2E..
commit f53a3a4808625f876aebc5a0bfb354480bbf0c21 (tag: v5.10.35)

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJxANAAKCRAw5/Bqldv6
8vrYAKCxg80oK6Nqwarx3srWL5biHQKm9gCfZVs7tw29MLBUA5uFrmTUrbc9E+o=
=29Uv
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
