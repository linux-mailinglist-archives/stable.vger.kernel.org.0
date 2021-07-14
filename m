Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852B83C922B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhGNUjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhGNUjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 16:39:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A81C061762
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 13:36:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3lcB-0007Hc-J7; Wed, 14 Jul 2021 22:36:19 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3lcA-0007cN-W8; Wed, 14 Jul 2021 22:36:18 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3lcA-0005Zc-VE; Wed, 14 Jul 2021 22:36:18 +0200
Date:   Wed, 14 Jul 2021 22:35:50 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.13 024/108] ARM: dts: imx25-pinfunc: Fix gpio
 function name for pads GPIO_[A-F]
Message-ID: <20210714203550.zlbvfh6rfnah6iir@pengutronix.de>
References: <20210714193800.52097-1-sashal@kernel.org>
 <20210714193800.52097-24-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k3zb7i65xmj5fean"
Content-Disposition: inline
In-Reply-To: <20210714193800.52097-24-sashal@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k3zb7i65xmj5fean
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2021 at 03:36:36PM -0400, Sasha Levin wrote:
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit e0cdd26af8eb9001689a4cde4f72c61c1c4b06be ]
>=20
> The pinfunc definitions used GPIO_A as function instead of GPIO_1_0 as
> done for all the other pins with GPIO functionality. Fix for consistency.
>=20
> There are no mainline users that needs adaption.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm not convinced it's a good idea to take this patch for stable.
in-tree users are unaffected and the only effect this can have on
out-of-tree users is to break them. So the gain of having this is not
positive.

Am I missing something?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--k3zb7i65xmj5fean
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDvSqMACgkQwfwUeK3K
7AnZuQf+NV8hcDo2RjWPLrtLPXe2b1g/CaaokgXh2p8Q/LvRQ6BsTgjRG0bqGx/V
333ywJeLqwfb1xA8xLcM8vz10fcf9/JeeBE1j2QT+RoKKtqmeaRqVplNzq4KCxKL
/84XA28SfDdqvPBjuuIABMEwJ6rxUmnE15gslXTivz9qg7Cp8480eDTQbzBU3Iww
qXg2KVJUED1CnCOnL6D6o8hsMmENZHAJ1E5Y4NcvgA/DHx5PZHn4aOYIe7jTBHgH
FKOPlu61k+Sw0YpnNBxIB4mHtNMcLucUZEBT6qTUe2ueCweLV8uqaRn3wV20jXHr
x1enkacTlJjdJdt14hhqeerWMn9wyw==
=G5Oc
-----END PGP SIGNATURE-----

--k3zb7i65xmj5fean--
