Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8718C22FB58
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgG0V00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:26:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51014 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgG0V00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 17:26:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B73521C0BE9; Mon, 27 Jul 2020 23:26:23 +0200 (CEST)
Date:   Mon, 27 Jul 2020 23:26:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 48/86] Input: add `SW_MACHINE_COVER`
Message-ID: <20200727212623.GA3724@duo.ucw.cz>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134916.823991118@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20200727134916.823991118@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit c463bb2a8f8d7d97aa414bf7714fc77e9d3b10df ]
>=20
> This event code represents the state of a removable cover of a device.
> Value 0 means that the cover is open or removed, value 1 means that the
> cover is closed.

This is only needed for N900 cover changes. I don't see them in
stable, so I believe this should be dropped.

Best regards,
								Pavel

> index 61a5799b440b9..c3e84f7c8261a 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -795,7 +795,8 @@
>  #define SW_LINEIN_INSERT	0x0d  /* set =3D inserted */
>  #define SW_MUTE_DEVICE		0x0e  /* set =3D device disabled */
>  #define SW_PEN_INSERTED		0x0f  /* set =3D pen inserted */
> -#define SW_MAX			0x0f
> +#define SW_MACHINE_COVER	0x10  /* set =3D cover closed */
> +#define SW_MAX			0x10
>  #define SW_CNT			(SW_MAX+1)
> =20
>  /*
> --=20
> 2.25.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXx9GfwAKCRAw5/Bqldv6
8uhnAJ9l8ZyrX58fFEQINvvYzsi+LTL8gACgwOrpq8l5YqNjfMyfPLRack6ez3I=
=8J1Y
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
