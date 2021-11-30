Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5506B463137
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhK3Kmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbhK3Kmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:42:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAC9C061746
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 02:39:17 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ms0XU-00020W-4z; Tue, 30 Nov 2021 11:39:08 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1ms0XH-001u5G-Rn; Tue, 30 Nov 2021 11:38:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1ms0XG-0006Qj-PJ; Tue, 30 Nov 2021 11:38:54 +0100
Date:   Tue, 30 Nov 2021 11:38:54 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Billy Tsai <billy_tsai@aspeedtech.com>
Cc:     b.zolnierkie@samsung.com, jdelvare@suse.com, linux@roeck-us.net,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        BMC-SW@aspeedtech.com, stable@vger.kernel.org
Subject: Re: [PATCH] hwmon: (pwm-fan) Ensure the fan going on in .probe()
Message-ID: <20211130103854.gwt5bib34t2qvbgg@pengutronix.de>
References: <20211130092212.17783-1-billy_tsai@aspeedtech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fzjl6gjehnbdzyrr"
Content-Disposition: inline
In-Reply-To: <20211130092212.17783-1-billy_tsai@aspeedtech.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fzjl6gjehnbdzyrr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2021 at 05:22:12PM +0800, Billy Tsai wrote:
> Before commit 86585c61972f ("hwmon: (pwm-fan) stop using legacy
> PWM functions and some cleanups") pwm_apply_state() was called
> unconditionally in pwm_fan_probe(). In this commit this direct
> call was replaced by a call to __set_pwm(ct, MAX_PWM) which
> however is a noop if ctx->pwm_value already matches the value to
> set.
> After probe the fan is supposed to run at full speed, and the
> internal driver state suggests it does, but this isn't asserted
> and depending on bootloader and pwm low-level driver, the fan
> might just be off.
> So drop setting pwm_value to MAX_PWM to ensure the check in
> __set_pwm doesn't make it exit early and the fan goes on as
> intended.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 86585c61972f ("hwmon: (pwm-fan) stop using legacy PWM functions an=
d some cleanups")
> Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>

Nice commit log :-)

Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--fzjl6gjehnbdzyrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGl/zUACgkQwfwUeK3K
7Almggf+OiugVJ7TlXxSFbcLyiNTc3kujV+5lVDZVY5j8+qn9hsAJJo5Rrqsvc1+
KmfRHw4L6gWJxlNkJHLRoUcimSqOPJ8PtjRb+OA/d8Tzh1ymOornyGGglw6YAHF3
yWL9hiltGqNXlfUEboQalHpQoVi5J78x9axEoZFSBzQE6Qeiu/3geU+n2kLP/syz
DEHZrdv3jLrCOIkI3mZz7Obp6SNn49j2acAt347kcnwKKt9T9e14cjBIQdY/Ergk
CfbkO9vy8ZOd2Cuh83zRwxkqCSdc7aBwyLFPhPYUYKVYla7XCfBMMomPYN+k1jnx
dztkexQN+JZ4JyDRqyaoHAExjcl1Dg==
=b/hm
-----END PGP SIGNATURE-----

--fzjl6gjehnbdzyrr--
