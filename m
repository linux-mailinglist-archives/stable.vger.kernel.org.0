Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A516220FBA
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgGOOpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 10:45:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59996 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgGOOpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 10:45:53 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6E8E91C0BDB; Wed, 15 Jul 2020 16:45:47 +0200 (CEST)
Date:   Wed, 15 Jul 2020 16:45:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 15/58] drm: panel-orientation-quirks: Use generic
 orientation-data for Acer S1003
Message-ID: <20200715144546.GA20651@duo.ucw.cz>
References: <20200714184056.149119318@linuxfoundation.org>
 <20200714184056.909662669@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20200714184056.909662669@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The Acer S1003 has proper DMI strings for sys-vendor and product-name,
> so we do not need to match by BIOS-date.
>=20
> This means that the Acer S1003 can use the generic lcd800x1280_rightside_=
up
> drm_dmi_panel_orientation_data struct which is also used by other quirks.

This is	just a cleanup,	it does	not fix	anything. I don't think we
need it in stable.

Best regards,
								Pavel
							=09
> =20
> -static const struct drm_dmi_panel_orientation_data acer_s1003 =3D {
> -	.width =3D 800,
> -	.height =3D 1280,
> -	.orientation =3D DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
> -};
> -
>  static const struct drm_dmi_panel_orientation_data asus_t100ha =3D {
>  	.width =3D 800,
>  	.height =3D 1280,
> @@ -100,7 +94,7 @@ static const struct dmi_system_id orientation_data[] =
=3D {
>  		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
>  		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
>  		},
> -		.driver_data =3D (void *)&acer_s1003,
> +		.driver_data =3D (void *)&lcd800x1280_rightside_up,
>  	}, {	/* Asus T100HA */
>  		.matches =3D {
>  		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> --=20
> 2.25.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXw8WmgAKCRAw5/Bqldv6
8gylAKC4LV32Hyp+Z40bVQzp0yoG4Su2JwCfWuPV9I/hi5eWiDUWJKQ5B1H0Ilk=
=tys3
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
