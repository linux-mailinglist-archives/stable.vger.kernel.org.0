Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4244BCDB4
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 11:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiBTKNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 05:13:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiBTKNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 05:13:20 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9324614B;
        Sun, 20 Feb 2022 02:12:59 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5AC6E1C0B77; Sun, 20 Feb 2022 11:12:58 +0100 (CET)
Date:   Sun, 20 Feb 2022 11:12:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tommaso Merciai <tomm.merciai@gmail.com>,
        Richard Leitner <richard.leitner@linux.dev>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        richard.leitner@skidata.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 04/23] usb: usb251xb: add boost-up property
 support
Message-ID: <20220220101256.GC7321@amd>
References: <20220215152957.581303-1-sashal@kernel.org>
 <20220215152957.581303-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20220215152957.581303-4-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Tommaso Merciai <tomm.merciai@gmail.com>
>=20
> [ Upstream commit 5c2b9c61ae5d8ad0a196d33b66ce44543be22281 ]
>=20
> Add support for boost-up register of usb251xb hub.
> boost-up property control USB electrical drive strength
> This register can be set:
>=20
>  - Normal mode -> 0x00
>  - Low         -> 0x01
>  - Medium      -> 0x10
>  - High        -> 0x11
>=20
> (Normal Default)
>=20
> References:
>  - http://www.mouser.com/catalog/specsheets/2514.pdf p29

Should the boost-up property be documented somewhere in the kernel
tree? We normally do that for device tree properties. And we normally
have properties used somewhere in the device tree. What is going on here?

Best regards,
							Pavel

> +++ b/drivers/usb/misc/usb251xb.c
> @@ -543,6 +543,9 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
>  	if (of_property_read_u16_array(np, "language-id", &hub->lang_id, 1))
>  		hub->lang_id =3D USB251XB_DEF_LANGUAGE_ID;
> =20
> +	if (of_property_read_u8(np, "boost-up", &hub->boost_up))
> +		hub->boost_up =3D USB251XB_DEF_BOOST_UP;
> +
>  	cproperty_char =3D of_get_property(np, "manufacturer", NULL);
>  	strlcpy(str, cproperty_char ? : USB251XB_DEF_MANUFACTURER_STRING,
>  		sizeof(str));
> @@ -584,7 +587,6 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
>  	 * may be as soon as needed.
>  	 */
>  	hub->bat_charge_en =3D USB251XB_DEF_BATTERY_CHARGING_ENABLE;
> -	hub->boost_up =3D USB251XB_DEF_BOOST_UP;
>  	hub->boost_57 =3D USB251XB_DEF_BOOST_57;
>  	hub->boost_14 =3D USB251XB_DEF_BOOST_14;
>  	hub->port_map12 =3D USB251XB_DEF_PORT_MAP_12;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmISFCgACgkQMOfwapXb+vIfPwCgiRbG5/YkD82ahvEKxpNruxsN
/KUAni/lKCLt5eONZbc+NqccFx5/ndlj
=18nN
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
