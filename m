Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E46411F100
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 09:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfLNInA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 03:43:00 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37034 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfLNInA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 03:43:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 940251C25FC; Sat, 14 Dec 2019 09:42:58 +0100 (CET)
Date:   Sat, 14 Dec 2019 09:42:58 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 033/134] leds: an30259a: add a check for
 devm_regmap_init_i2c
Message-ID: <20191214084258.GC16834@duo.ucw.cz>
References: <20191211151150.19073-1-sashal@kernel.org>
 <20191211151150.19073-33-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
In-Reply-To: <20191211151150.19073-33-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-12-11 10:10:09, Sasha Levin wrote:
> From: Chuhong Yuan <hslester96@gmail.com>
>=20
> [ Upstream commit fc7b5028f2627133c7c18734715a08829eab4d1f ]
>=20
> an30259a_probe misses a check for devm_regmap_init_i2c and may cause
> problems.
> Add a check and print errors like other leds drivers.

Please drop.
								Pavel

> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/leds/leds-an30259a.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/leds/leds-an30259a.c b/drivers/leds/leds-an30259a.c
> index 250dc9d6f6350..82350a28a5644 100644
> --- a/drivers/leds/leds-an30259a.c
> +++ b/drivers/leds/leds-an30259a.c
> @@ -305,6 +305,13 @@ static int an30259a_probe(struct i2c_client *client)
> =20
>  	chip->regmap =3D devm_regmap_init_i2c(client, &an30259a_regmap_config);
> =20
> +	if (IS_ERR(chip->regmap)) {
> +		err =3D PTR_ERR(chip->regmap);
> +		dev_err(&client->dev, "Failed to allocate register map: %d\n",
> +			err);
> +		goto exit;
> +	}
> +
>  	for (i =3D 0; i < chip->num_leds; i++) {
>  		struct led_init_data init_data =3D {};
> =20
> --=20
> 2.20.1

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfSgkgAKCRAw5/Bqldv6
8v1wAJ9gd7l3Y6sYuUg30GQElhPfZZgwbACeNxKs8yWJBc+Zx7cq4qpRGXe6nXQ=
=1Hfy
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
