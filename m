Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E1F1DEC
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 20:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKFTBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 14:01:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39600 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfKFTBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 14:01:24 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 57FD11C0998; Wed,  6 Nov 2019 20:01:22 +0100 (CET)
Date:   Wed, 6 Nov 2019 20:01:21 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 078/149] gpio: max77620: Use correct unit for
 debounce times
Message-ID: <20191106190121.GA2306@amd>
References: <20191104212126.090054740@linuxfoundation.org>
 <20191104212142.090938480@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20191104212142.090938480@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The gpiod_set_debounce() function takes the debounce time in
> microseconds. Adjust the switch/case values in the MAX77620 GPIO to use
> the correct unit.


> +++ b/drivers/gpio/gpio-max77620.c
> @@ -163,13 +163,13 @@ static int max77620_gpio_set_debounce(struct max776=
20_gpio *mgpio,
>  	case 0:
>  		val =3D MAX77620_CNFG_GPIO_DBNC_None;
>  		break;
> -	case 1 ... 8:
> +	case 1000 ... 8000:
>  		val =3D MAX77620_CNFG_GPIO_DBNC_8ms;
>  		break;

AFAICT the range should be 1 ... 8000, then 8001 ... 16000 etc below...

> -	case 9 ... 16:
> +	case 9000 ... 16000:
>  		val =3D MAX77620_CNFG_GPIO_DBNC_16ms;
>  		break;
> -	case 17 ... 32:
> +	case 17000 ... 32000:
>  		val =3D MAX77620_CNFG_GPIO_DBNC_32ms;
>  		break;
>  	default:

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3DGIEACgkQMOfwapXb+vKDjACdEBrHzhRnSS2tlzRywsjY1nqB
AWYAn237wdZfhpbkxh6xewtJbqZA4PRp
=4/4n
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
