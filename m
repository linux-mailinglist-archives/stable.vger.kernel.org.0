Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D53845E291
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 22:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351020AbhKYVgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351102AbhKYVeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 16:34:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCD8C0613F1
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 13:21:10 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqMAx-00086M-Rl; Thu, 25 Nov 2021 22:21:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqMAt-0013Fq-1C; Thu, 25 Nov 2021 22:20:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqMAr-0008CR-QS; Thu, 25 Nov 2021 22:20:57 +0100
Date:   Thu, 25 Nov 2021 22:20:54 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Marek Vasut <marex@denx.de>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        peter.chen@kernel.org, USB list <linux-usb@vger.kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        stable <stable@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] usb: chipidea: ci_hdrc_imx: Fix -EPROBE_DEFER handling
 for phy
Message-ID: <20211125212054.deazlz5jwvt6xgcp@pengutronix.de>
References: <20210921113754.767631-1-festevam@gmail.com>
 <20211125083400.h7qoyj52fcn4khum@pengutronix.de>
 <CAOMZO5BXGxXKZAq2jeJ=yRww+Hoft_9=6jUheM92w5majQ1UdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ttjarkphnhjgpgh2"
Content-Disposition: inline
In-Reply-To: <CAOMZO5BXGxXKZAq2jeJ=yRww+Hoft_9=6jUheM92w5majQ1UdQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ttjarkphnhjgpgh2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 25, 2021 at 08:16:12AM -0300, Fabio Estevam wrote:
> Hi Uwe,
>=20
> On Thu, Nov 25, 2021 at 5:34 AM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> >
> > With an old style device tree using fsl,usbphy
> > devm_usb_get_phy_by_phandle() returning ERR_PTR(-EPROBE_DEFER) results =
in
> > ci->usb_phy =3D ERR_PTR(-EPROBE_DEFER) in the chipidea driver which then
> > chokes on that with
> >
> >         Unable to handle kernel paging request at virtual address fffff=
e93
> >
> > Handle errors other then -ENODEV as was done before v5.15-rc5 in
> > ci_hdrc_imx_probe().
> >
> > Fixes: 8253a34bfae3 ("usb: chipidea: ci_hdrc_imx: Also search for 'phys=
' phandle")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >
> > this patch became commit 8253a34bfae3278baca52fc1209b7c29270486ca in
> > v5.15-rc5. On an i.MX25 I experience the following fault:
> >
> > [    2.248749] 8<--- cut here ---
> > [    2.259025] Unable to handle kernel paging request at virtual addres=
s fffffe93
>=20
> Sorry for the breakage.
>=20
> Dan has sent a fix for this:
> https://www.spinics.net/lists/linux-usb/msg219148.html

Ah, I see this is already in next as
d4d2e5329ae9dfd6742c84d79f7d143d10410f1b via the usb tree. I know why I
missed that when I looked for fixes, but I spare you from the details.

Thanks and sorry for the noise,
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ttjarkphnhjgpgh2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGf/jMACgkQwfwUeK3K
7Ako0Qf/VMTREhOOrbdj9i5yAg6O9vj1B9qPj/OwN3ckUMaoyUJn3XrxU0cbt5wj
X+JuifEZqrOkmrplFc4xog2qVVlE5CMtk22mMqVqpNYVbEGiLVO/myYpvPcvZGcm
oDG/JuG2c5MOZaSvc6tjYZJmdSKJC272RXRtg6pcvUQ3NfkjncmblMa70uRV7b5q
phYcS1OxW4YMuoXbQ2uqe0QWqagaKhuEoZZPZaKrmTirG5PeOaJdUS2FrZLKtxnN
QjWy+10t3ZLLKFgHHKuqJcoWNu4mJm5Dxlb5vCxsHALkTQ+3USS/wN1+E9b+P4a2
YuT9dUcluc8BJ57JTd7l30nzVvqWZA==
=+uBJ
-----END PGP SIGNATURE-----

--ttjarkphnhjgpgh2--
