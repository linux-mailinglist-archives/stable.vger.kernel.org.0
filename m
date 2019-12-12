Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEDB11CCEB
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfLLMTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:19:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40846 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfLLMTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 07:19:41 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 178C51C246E; Thu, 12 Dec 2019 13:19:39 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:19:38 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 148/350] media: ad5820: Define entity function
Message-ID: <20191212121938.GB17876@duo.ucw.cz>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-109-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-109-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-10 16:04:13, Sasha Levin wrote:
> From: Ricardo Ribalda Delgado <ribalda@kernel.org>
>=20
> [ Upstream commit 801ef7c4919efba6b96b5aed1e72844ca69e26d3 ]
>=20
> Without this patch, media_device_register_entity throws a warning:
>=20
> dev_warn(mdev->dev,
> 	 "Entity type for entity %s was not initialized!\n",
> 	 entity->name);

This fixes warning, not a serious bug. Thus it is against stable
rules.

Please either update the rules to the real rules in use, or stop
pushing such pages to stable.

Best regards,
								Pavel


> index 925c171e77976..7a49651f4d1f2 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -309,6 +309,7 @@ static int ad5820_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
>  	coil->subdev.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	coil->subdev.internal_ops =3D &ad5820_internal_ops;
> +	coil->subdev.entity.function =3D MEDIA_ENT_F_LENS;
>  	strscpy(coil->subdev.name, "ad5820 focus", sizeof(coil->subdev.name));
> =20
>  	ret =3D media_entity_pads_init(&coil->subdev.entity, 0, NULL);
> --=20
> 2.20.1

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfIwWgAKCRAw5/Bqldv6
8mPuAKCTD2vWmTbZq6rDI/hxj2csiiW8GgCgwgqev2YgRPLpjjjb134mrnrnfEs=
=N+Yw
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
