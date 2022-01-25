Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AF049B678
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348475AbiAYOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388356AbiAYOdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:33:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A6C061763
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:32:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCMrc-0007qU-Ck; Tue, 25 Jan 2022 15:32:04 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCMrb-00CMQF-9W; Tue, 25 Jan 2022 15:32:02 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCMrZ-001Jm0-PV; Tue, 25 Jan 2022 15:32:01 +0100
Date:   Tue, 25 Jan 2022 15:31:58 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Max Kellermann <max.kellermann@gmail.com>
Cc:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nv55ukvgufa57okb"
Content-Disposition: inline
In-Reply-To: <20220125123429.3490883-1-max.kellermann@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nv55ukvgufa57okb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Jan 25, 2022 at 01:34:27PM +0100, Max Kellermann wrote:
> Its value is calculated in sun4i_pwm_apply() and is used only there.
>=20
> Cc: stable@vger.kernel.org

I think I'd drop this. This isn't a fix worth on it's own to be
backported and if this is needed for one of the next patches, the stable
maintainers will notice themselves (and it might be worth to shuffle
this series to make the fixes come first).

> Signed-off-by: Max Kellermann <max.kellermann@gmail.com>

Other than that, LGTM:

Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--nv55ukvgufa57okb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHwCdsACgkQwfwUeK3K
7AlCUQgAmTJBEU1qYIFs7bSSrRibekONtOo/9V9pse9XnO7rJAsW9HW/0wCvSETt
8LsEqV4XrhNhZQ3Xjd+Mv14jsY+uux1oKQdtto+BsWChWkw6LBtOf6CiPh1KjuHb
cxPOIn2dIQMVeEuAJ51G9vSOD/zpp7N4r+rPt1cUBkHt0Cvng0K+ogrxfnrfueiI
NcnLnor2D1QXDXyM70cfStiaE7+prL7c82B+3GprzrVMt/QB0CJI8N+u4boS7D8H
WGu7dCKwb+qk8QcwWIGqsTxRC4z1E3jef9qz/aSH8YlASIg5gfT8wvKcYK+MLjG4
46Xa7o+mSN8ZmZk16Dfz//CzFj4snA==
=ntdC
-----END PGP SIGNATURE-----

--nv55ukvgufa57okb--
