Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA32E7883
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 13:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgL3M0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 07:26:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59260 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgL3M0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 07:26:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 58B211C0B85; Wed, 30 Dec 2020 13:25:08 +0100 (CET)
Date:   Wed, 30 Dec 2020 13:25:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 5.10 527/717] media: ipu3-cio2: Validate mbus format in
 setting subdev format
Message-ID: <20201230122508.GA12190@duo.ucw.cz>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125046.214023397@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20201228125046.214023397@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit a86cf9b29e8b12811cf53c4970eefe0c1d290476 upstream.
>=20
> Validate media bus code, width and height when setting the subdev format.
>=20
> This effectively reworks how setting subdev format is implemented in the
> driver.

Something is wrong here:

> +	fmt->format.code =3D formats[0].mbus_code;
> +	for (i =3D 0; i < ARRAY_SIZE(formats); i++) {
> +		if (formats[i].mbus_code =3D=3D fmt->format.code) {
> +			fmt->format.code =3D mbus_code;
> +			break;
> +		}

This does not make sense. Loop will always exit during the first
iteration, making the whole loop crazy/redundant.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX+xxpAAKCRAw5/Bqldv6
8mYzAKCETbl52Q18bQNCV0oKy68LnQVU0gCgod2H04ZTTtHa8oxWPzrYVvIyttQ=
=H0EU
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
