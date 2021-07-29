Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75D3DAC07
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhG2Trn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 15:47:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43694 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhG2Trn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 15:47:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9547E1C0B79; Thu, 29 Jul 2021 21:47:38 +0200 (CEST)
Date:   Thu, 29 Jul 2021 21:47:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/17] 4.19.200-rc1 review
Message-ID: <20210729194738.GB11477@duo.ucw.cz>
References: <20210729135137.260993951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.200 release.
> There are 17 patches in this series, all will be posted as a response
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

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYQMF2gAKCRAw5/Bqldv6
8nwFAJ0Yn+/dVdiLYOnbp+9qP0KiDFMVCQCgmHD4s3LIUUqLEkARK1Hbsc70/YM=
=p2ls
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
