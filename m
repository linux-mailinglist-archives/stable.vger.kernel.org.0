Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676073EFD61
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbhHRHJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:09:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48546 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbhHRHJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 03:09:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 250AC1C0B7A; Wed, 18 Aug 2021 09:08:51 +0200 (CEST)
Date:   Wed, 18 Aug 2021 09:08:50 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
Message-ID: <20210818070850.GG22282@amd>
References: <20210818070209.1540451-1-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline
In-Reply-To: <20210818070209.1540451-1-michal.vokac@ysoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2021-08-18 09:02:08, Michal Vok=C3=A1=C4=8D wrote:
> Since the LED multicolor framework support was added in commit
> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> LEDs on this platform stopped working.
>=20
> Author of the framework attempted to accommodate this DT to the
> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg proper=
ty
> to the lp5562 channel node") but that is not sufficient. A color property
> is now required even if the multicolor framework is not used, otherwise
> the driver probe fails:
>=20
>   lp5562: probe of 1-0030 failed with error -22
>=20
> Add the color property to fix this.
>=20
> Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to l=
p55xx")
> Cc: <stable@vger.kernel.org>
> Cc: linux-leds@vger.kernel.org
> Signed-off-by: Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
http://www.livejournal.com/~pavelmachek

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEcsgIACgkQMOfwapXb+vKtYACfQmGYjz78By3fESspEItZ6vqd
wQ8AmgMl7zYShY7+ZTrOAsrR9yIKJLKJ
=7cmp
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--
