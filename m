Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FEF2F2CC2
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390371AbhALK0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbhALK0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 05:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C51F1206F1;
        Tue, 12 Jan 2021 10:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610447168;
        bh=htYiuiUKPwhQA9k7M+tn7QWnfbZ2lpr4ZpKaqRPAiiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaqbS9nX6o+CQTD5/htQij+u9EZunwXr/0K/Nn8AWdoIaEPlLeO64018fX1ZALM0H
         9JxrrSgYcalyOR1AYD5PNZuODUm0x7qmYh/C2Ni+Bzen0cpr9fUa2Dpts3NzjZ4D0U
         E2YOUyO1LWBykvkTCZ3pSyW5cpFgqJ/oOA7aUvxsX9NoGgraJZKg0D6SIQU5Uh0PfS
         ZbP9fliqx9o77oTyIkX+1wieGNuBKseKiuPZl2zvwE73jbl4G1JFuEFTlPglsmpc7v
         hAZR7bdX2kq3Yiq/U4TiDEwa33GeiRtejOCTrJJ9uOrdDPH8yiTkLVGxEgN1j69MS/
         XBle3dQJPXM4g==
Date:   Tue, 12 Jan 2021 11:26:05 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Mikko Perttunen <cyndis@kapsi.fi>
Cc:     Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra-bpmp: ignore DMA safe buffer flag
Message-ID: <20210112102605.GB973@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <cyndis@kapsi.fi>,
        Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org
References: <20210111155816.3656820-1-mperttunen@nvidia.com>
 <20210111214221.GF17475@kunai>
 <92fb3f30-a08c-eb42-0741-affc3ceae0c0@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <92fb3f30-a08c-eb42-0741-affc3ceae0c0@kapsi.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I wonder if bailing out on an unknown flag shouldn't be revisited in
> > general? I mean this will happen again when a new I2C_M_* flag is
> > introduced.
> >=20
>=20
> If it's guaranteed that any new flags are optional to handle by the drive=
r,
> than that is certainly better. I'll post a v3 with that approach.

If there will be a new flag, it is highly likely that it will handle
some corner case which only gets applied when there is a I2C_FUNC_* flag
guarding it. If the new flag turns out to be mandatory, the (poor)
author needs to check with all existing drivers anyhow.


--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/9eT0ACgkQFA3kzBSg
Kbbo1xAAkEUtAp5Foqgl/yeRqU1cpcdFBhRzeTCRutMpwjIYWKYTZqM/7R8NmqBC
e8OYDzWVSQE6BtGOVCdB2KttGQAmuuf4e8hjttKNStZUDwHfgGp6MaHP0+rU3w6T
yQwjQMEl+G1eXEXWELVqJx8+Hxlk4eXQr5wJgjJjo7LhWPGpMhoIXqwcouA7Hsb2
DejkzUe9tx2omZfho8HVYc/cnG8+d/CZGu5JoLZDnQED7HSTAqp4qcIUMk9Vyyut
qqWafoM5Dsf9MYqJQOEP2P5iTK5B30pFimKqYn/InaSoVhJceOU1NtMP2i4ZOayw
/CR637J2yMO67XfKWK4vpKZ8ZJUCtWS6KTq2vk+6km0T9bbhNFmbsrFgi303H7pQ
kgRJuE6yCBPkj3Cp4t3jEckwVru2EN45QkKmlD/HTVaEmg5Hh1h/JWoGqC78D40W
SijegmmhAU/tOMNZN/KJfcYVGqp36bBfjXLeUEXvV0o5nhqd6bwKtdYXYTvwAmX5
LX78EOeM9QFKVz9hYT0RGS+Nzj8bbpfvHXR5ysBIt8HzisrmlhZb0MNoZxrXi55K
JG3vYVZ4qB3Ileq8PXCo/Z84Kx0P3NK3BjX0E+kK6swRD92FC+opMkCM7QldO4Sc
ZW4pJAhSvVhMWO6S+XErCAJVwJ5HM2Cemr373m0GqivFg6UouxU=
=gEhV
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
