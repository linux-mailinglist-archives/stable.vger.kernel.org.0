Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD3188B07
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJLZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 07:25:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33789 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfHJLZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 07:25:46 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 7C695802C3; Sat, 10 Aug 2019 13:25:32 +0200 (CEST)
Date:   Sat, 10 Aug 2019 13:25:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Edward Srouji <edwards@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH 4.19 36/45] net/mlx5: Fix modify_cq_in alignment
Message-ID: <20190810112544.GA6147@amd>
References: <20190808190453.827571908@linuxfoundation.org>
 <20190808190455.839364156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20190808190455.839364156@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Edward Srouji <edwards@mellanox.com>
>=20
> [ Upstream commit 7a32f2962c56d9d8a836b4469855caeee8766bd4 ]
>=20
> Fix modify_cq_in alignment to match the device specification.
> After this fix the 'cq_umem_valid' field will be in the right
> offset.

Is it neccessary for v4.19 stable? The cq_umem_valid field is not
there, and it is not needed by subsequent patch.

Best regards,
									Pavel
								=09
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -5623,7 +5623,12 @@ struct mlx5_ifc_modify_cq_in_bits {
> =20
>  	struct mlx5_ifc_cqc_bits cq_context;
> =20
> -	u8         reserved_at_280[0x600];
> +	u8         reserved_at_280[0x60];
> +
> + 	u8         cq_umem_valid[0x1];
> +	u8         reserved_at_2e1[0x1f];
> +
> +	u8         reserved_at_300[0x580];
> =20
>  	u8         pas[0][0x40];
>  };
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1OqbgACgkQMOfwapXb+vLy0wCeLxyJ7eeEmIAkBJa5q3u9G/Hn
2SsAn0FZbFreG9UHq197gj7ScH49fLPF
=fmXv
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
