Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A740103B85
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfKTNdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:33:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37522 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbfKTNdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 08:33:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 005D01C1A59; Wed, 20 Nov 2019 14:33:42 +0100 (CET)
Date:   Wed, 20 Nov 2019 14:33:42 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 389/422] crypto: s5p-sss: Fix Fix argument list
 alignment
Message-ID: <20191120133342.GB32699@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051424.311206784@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <20191119051424.311206784@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-11-19 06:19:46, Greg Kroah-Hartman wrote:
> From: Christoph Manszewski <c.manszewski@samsung.com>
>=20
> [ Upstream commit 6c12b6ba45490eeb820fdceccf5a53f42a26799c ]
>=20
> Fix misalignment of continued argument list.

Including whitespace changes in -stable is forbidden by rules.

This one is _just_ whitespace change. Please drop.

									Pavel

> +++ b/drivers/crypto/s5p-sss.c
> @@ -491,7 +491,7 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
>  }
> =20
>  static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *=
src,
> -			    struct scatterlist **dst)
> +			   struct scatterlist **dst)
>  {
>  	void *pages;
>  	int len;
> @@ -1889,7 +1889,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev =
*dev,
>  }
> =20
>  static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
> -				struct ablkcipher_request *req)
> +				 struct ablkcipher_request *req)
>  {
>  	struct scatterlist *sg;
>  	int err;
> --=20
> 2.20.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdVAtgAKCRAw5/Bqldv6
8pKmAKDBGFlnbyzuWtGNXnw2tGuBjVOZcACeNvsmqaXMyq4Ibvw9NK3hVnZUPto=
=bhrj
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
