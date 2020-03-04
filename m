Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304911796AC
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgCDR1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:27:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44578 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDR1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 12:27:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 28B561C0321; Wed,  4 Mar 2020 18:27:52 +0100 (CET)
Date:   Wed, 4 Mar 2020 18:27:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 60/87] usb: charger: assign specific number for enum
 value
Message-ID: <20200304172736.GC2367@duo.ucw.cz>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174355.750234821@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <20200303174355.750234821@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-03-03 18:43:51, Greg Kroah-Hartman wrote:
> From: Peter Chen <peter.chen@nxp.com>
>=20
> commit ca4b43c14cd88d28cfc6467d2fa075aad6818f1d upstream.
>=20
> To work properly on every architectures and compilers, the enum value
> needs to be specific numbers.

All compilers are expected to handle this in the same way, as this is
in C standard. This patch is not neccessary, and should not be in mainline,
either.

http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf

6.7.2.2 Enumeration specifiers
Syntax
=2E..
3 The identifiers in an enumerator list are declared as constants that have=
 type int and
may appear wherever such are permitted.107) An enumerator with =3D defines =
its
enumeration constant as the value of the constant expression. If the first =
enumerator has
no =3D, the value of its enumeration constant is 0. Each subsequent enumera=
tor with no =3D
defines its enumeration constant as the value of the constant expression ob=
tained by
adding 1 to the value of the previous enumeration constant. (The use of enu=
merators with
=3D may produce enumeration constants with values that duplicate other valu=
es in the same
enumeration.) The enumerators of an enumeration are also known as its membe=
rs.

Best regards,
								Pavel

>  enum usb_charger_type {
> -	UNKNOWN_TYPE,
> -	SDP_TYPE,
> -	DCP_TYPE,
> -	CDP_TYPE,
> -	ACA_TYPE,
> +	UNKNOWN_TYPE =3D 0,
> +	SDP_TYPE =3D 1,
> +	DCP_TYPE =3D 2,
> +	CDP_TYPE =3D 3,
> +	ACA_TYPE =3D 4,
>  };
> =20
>  /* USB charger state */
>  enum usb_charger_state {
> -	USB_CHARGER_DEFAULT,
> -	USB_CHARGER_PRESENT,
> -	USB_CHARGER_ABSENT,
> +	USB_CHARGER_DEFAULT =3D 0,
> +	USB_CHARGER_PRESENT =3D 1,
> +	USB_CHARGER_ABSENT =3D 2,
>  };
> =20
>  #endif /* _UAPI__LINUX_USB_CHARGER_H */
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXl/lCAAKCRAw5/Bqldv6
8sHeAJ9tJGXlsIh9klP4VfoBN25aD/3XhACfbsT37Ww/GjwtxlnneGkE48RrJWw=
=+4hz
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
