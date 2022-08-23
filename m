Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C1E59E57B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbiHWO6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 10:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241791AbiHWO6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 10:58:07 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544A430A79E;
        Tue, 23 Aug 2022 05:23:31 -0700 (PDT)
Received: (Authenticated sender: paul.kocialkowski@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B6140200004;
        Tue, 23 Aug 2022 12:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661257371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mH/IsYL2UPBaCXvhJbSLyyoriNuaQXpxdb7a7Mfls2k=;
        b=DAzEwz0Yj5FE2S/Gf2B5PDjuh2A9BbgMkrwUgaEn6TEf+aSR3AWc5hjukvQOyOUIX2tjnT
        VqHvjbLQRHRi83kxjT8K4c88QHMOcDAeSxydZnwV/NPnW4a7B5cx4tytI0vZMGagEYlGT8
        Wq9aDliGZjnH+ItFFvPkeblGaypN0er1s0CmnRvpvfPU1uONta8FqtcbSoCU+5A7wM3R3g
        HdM2rf13SnCK0/ta9Tn4S/AVqUE9mhik4oQhhEYpANOwI6HHZIDL8f7gR+IJ8MFa0ATeWa
        Gro75d/mDXIQ/4nkvme6/rwYAwas01UqUck8kxNFPfDGk/xTj+J0V38F/WC5ww==
Date:   Tue, 23 Aug 2022 14:22:44 +0200
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        kernel@collabora.com,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] media: cedrus: Set the platform driver data
 earlier
Message-ID: <YwTGlENw/7+SDal/@aptenodytes>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
 <4418189.LvFx2qVVIh@jernej-laptop>
 <47ce07adc73887b5afaf9815a78b793d0e9a6b54.camel@collabora.com>
 <4733096.GXAFRqVoOG@jernej-laptop>
 <0aab3720-7211-9414-0005-6a419b5f04c8@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VACStzkiwKlyW1sA"
Content-Disposition: inline
In-Reply-To: <0aab3720-7211-9414-0005-6a419b5f04c8@sholland.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VACStzkiwKlyW1sA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon 22 Aug 22, 22:57, Samuel Holland wrote:
> On 8/20/22 3:25 AM, Jernej =C5=A0krabec wrote:
> > Dne petek, 19. avgust 2022 ob 17:37:20 CEST je Nicolas Dufresne napisal=
(a):
> >> Le vendredi 19 ao=C3=BBt 2022 =C3=A0 06:17 +0200, Jernej =C5=A0krabec =
a =C3=A9crit :
> >>> Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:07 CEST je Nicolas Dufresn=
e=20
> > napisal(a):
> >>>> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >>>>
> >>>> The cedrus_hw_resume() crashes with NULL deference on driver probe if
> >>>> runtime PM is disabled because it uses platform data that hasn't been
> >>>> set up yet. Fix this by setting the platform data earlier during pro=
be.
> >>>
> >>> Does it even work without PM? Maybe it would be better if Cedrus would
> >>> select PM in Kconfig.
> >>
> >> I cannot comment myself on this, but it does not seem to invalidate th=
is
> >> Dmitry's fix.
> >=20
> > If NULL pointer dereference happens only when PM is disabled, then it d=
oes. I=20
> > have PM always enabled and I never experienced above issue.
>=20
> There's still a bug even with PM enabled: the v4l2 device is exposed to
> userspace, and therefore userspace could trigger a PM resume, before
> platform_set_drvdata() is called.

Absolutely agreed!

> >>>> Cc: stable@vger.kernel.org
> >>>> Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >>>> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>=20
> Please add a Fixes tag. With that:
>=20
> Reviewed-by: Samuel Holland <samuel@sholland.org>

Same here:

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Thanks!

Paul

> >>>> ---
> >>>>
> >>>>  drivers/staging/media/sunxi/cedrus/cedrus.c | 4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> b/drivers/staging/media/sunxi/cedrus/cedrus.c index
> >>>> 960a0130cd620..55c54dfdc585c 100644
> >>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> @@ -448,6 +448,8 @@ static int cedrus_probe(struct platform_device
> >>>> *pdev)
> >>>>
> >>>>  	if (!dev)
> >>>>  		return -ENOMEM;
> >>>>
> >>>> +	platform_set_drvdata(pdev, dev);
> >>>> +
> >>>>  	dev->vfd =3D cedrus_video_device;
> >>>>  	dev->dev =3D &pdev->dev;
> >>>>  	dev->pdev =3D pdev;
> >>>>
> >>>> @@ -521,8 +523,6 @@ static int cedrus_probe(struct platform_device
> >>>> *pdev)
> >>>>
> >>>>  		goto err_m2m_mc;
> >>>>  	}
> >>>>
> >>>> -	platform_set_drvdata(pdev, dev);
> >>>> -
> >>>>  	return 0;
> >>>> =20
> >>>>  err_m2m_mc:

--=20
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

--VACStzkiwKlyW1sA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAmMExpQACgkQ3cLmz3+f
v9Hphgf/RHIkNtIHgUBj1wEt+9CgUUYKzkUCP8Iwi0xIbXLJz4GeHQwIrL8VNnrT
1xZCbn9LrUxPEx48WPdyxs2DMCk3JgIw0M4xGltx8VBPsmRo2GzslC8nWGYt9HyX
r3sVL/Vx8GC0Do/yTaTA22LfBQOBOMebdEWZx2M05z/UL5aYC5QLHeaRo88fXqlE
RLUhSbWZg3CIRQK4K8aIIa20mW/BpPGvp4af+NqFMezJiY9XsvAmv23dNhnYxZk9
vrkXYKOK5L9WppdzVxqkBGl2jjeKqf5DHAwpIiQaf1iq7DJmdUTPZ193Vs3T9pHC
c9btoDAjNoaJGV5Vir/sRaOTUBxmrg==
=Aw5f
-----END PGP SIGNATURE-----

--VACStzkiwKlyW1sA--
