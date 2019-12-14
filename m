Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C4F11F0F9
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 09:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfLNIh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 03:37:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36612 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfLNIh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 03:37:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C1ABB1C25E0; Sat, 14 Dec 2019 09:37:55 +0100 (CET)
Date:   Sat, 14 Dec 2019 09:37:55 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Nick Stoughton <nstoughton@logitech.com>
Subject: Re: [PATCH 3.16 04/72] leds: leds-lp5562 allow firmware files up to
 the maximum length
Message-ID: <20191214083755.GA16834@duo.ucw.cz>
References: <lsq.1575813164.154362148@decadent.org.uk>
 <lsq.1575813165.827469937@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <lsq.1575813165.827469937@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-08 13:52:48, Ben Hutchings wrote:
> 3.16.79-rc1 review patch.  If anyone has any objections, please let
> me know.

Nobody is hitting this one and noone cares. Not a serious bug as
described in stable rules.

I'd recommend dropping.
								Pavel


> ------------------
>=20
> From: Nick Stoughton <nstoughton@logitech.com>
>=20
> commit ed2abfebb041473092b41527903f93390d38afa7 upstream.
>=20
> Firmware files are in ASCII, using 2 hex characters per byte. The
> maximum length of a firmware string is therefore
>=20
> 16 (commands) * 2 (bytes per command) * 2 (characters per byte) =3D 64
>=20
> Fixes: ff45262a85db ("leds: add new LP5562 LED driver")
> Signed-off-by: Nick Stoughton <nstoughton@logitech.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/leds/leds-lp5562.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/leds/leds-lp5562.c
> +++ b/drivers/leds/leds-lp5562.c
> @@ -263,7 +263,11 @@ static void lp5562_firmware_loaded(struc
>  {
>  	const struct firmware *fw =3D chip->fw;
> =20
> -	if (fw->size > LP5562_PROGRAM_LENGTH) {
> +	/*
> +	 * the firmware is encoded in ascii hex character, with 2 chars
> +	 * per byte
> +	 */
> +	if (fw->size > (LP5562_PROGRAM_LENGTH * 2)) {
>  		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
>  			fw->size);
>  		return;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfSfYwAKCRAw5/Bqldv6
8hizAJ9KPMstp0cBLL9HIBSGhx4A9Ek5awCgnSJATUmT2r9uSnXyTU/jYrooc7g=
=v+lj
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
