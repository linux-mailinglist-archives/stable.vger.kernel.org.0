Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3A733489D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 21:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhCJUEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 15:04:31 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56222 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbhCJUEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 15:04:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A708F1C0B79; Wed, 10 Mar 2021 21:04:06 +0100 (CET)
Date:   Wed, 10 Mar 2021 21:04:06 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Jasper St. Pierre" <jstpierre@mecheye.net>,
        Chris Chiu <chiu@endlessos.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 23/49] ACPI: video: Add DMI quirk for GIGABYTE
 GB-BXBT-2807
Message-ID: <20210310200406.GA11868@amd>
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.685806668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20210310132322.685806668@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> From: Jasper St. Pierre <jstpierre@mecheye.net>

Something is funny with the From header here. But that's not main
thing -- this patch is evil.

> Unfortunately, the backlight controller only confuses userspace, which
> sees the existence of a backlight device node and has the unrealistic
> belief that there is actually a backlight there!

> +++ b/drivers/acpi/video_detect.c
> @@ -140,6 +140,13 @@ static const struct dmi_system_id video_detect_dmi_t=
able[] =3D {
>  	},
>  	{
>  	.callback =3D video_detect_force_vendor,
> +	.ident =3D "GIGABYTE GB-BXBT-2807",
> +	.matches =3D {
> +		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
> +		},
> +	},
> +	{
>  	.ident =3D "Sony VPCEH3U1E",
>  	.matches =3D {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),

Yup, and it looks like this fixes the problem for GIGABYTE
GB-BXBT-2807 but re-introduces the problem for Sony VPCEH3U1E.

Best regards,

							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBJJjYACgkQMOfwapXb+vL6mQCgkZcAv4l2s5EVv/WKgUSkdl1N
mdcAoLobiDVyoHbzEKIaqxkUFDJUyfO4
=CVrc
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
