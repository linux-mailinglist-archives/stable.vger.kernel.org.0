Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6F16EC6CF
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjDXHIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 03:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjDXHIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 03:08:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432AA1AC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 00:08:15 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqqJ3-00075o-OA; Mon, 24 Apr 2023 09:08:13 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqqJ2-00DQEb-8L; Mon, 24 Apr 2023 09:08:12 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqqJ1-00Fld8-Ic; Mon, 24 Apr 2023 09:08:11 +0200
Date:   Mon, 24 Apr 2023 09:07:57 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Munehisa Kamata <kamatam@amazon.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: stable-rc: 5.4: drivers/pwm/pwm-meson.c:313:25: error:
 assignment of member 'polarity' in read-only object
Message-ID: <20230424070757.walwm3q76a536556@pengutronix.de>
References: <CA+G9fYuZdBJx8jF2STHzRZ8dw86awZ68OQen6bzgB=H+Z-tPAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pdwmzgflt4h5e3aq"
Content-Disposition: inline
In-Reply-To: <CA+G9fYuZdBJx8jF2STHzRZ8dw86awZ68OQen6bzgB=H+Z-tPAQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pdwmzgflt4h5e3aq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Apr 24, 2023 at 03:16:34AM +0530, Naresh Kamboju wrote:
> Following build errors noticed on arm64 and arm while building stable-rc =
5.4.
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> Build error:
> -----------
>   drivers/pwm/pwm-meson.c: In function 'meson_pwm_apply':
>   drivers/pwm/pwm-meson.c:313:25: error: assignment of member
> 'polarity' in read-only object
>     313 |         state->polarity =3D PWM_POLARITY_NORMAL;
>         |                         ^
>   make[3]: *** [scripts/Makefile.build:262: drivers/pwm/pwm-meson.o] Erro=
r 1
>   make[3]: Target '__build' not remade because of errors.
>   make[2]: *** [scripts/Makefile.build:497: drivers/pwm] Error 2
>=20
>=20
> Suspected commit:
> ------------
>   pwm: meson: Explicitly set .polarity in .get_state()
>   commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 upstream.

Thanks for the report. I sent a fix to that patch in reply to the patch
being announced to be picked for 5.4.y, but failed to Cc you. I just
replied to the mail, so it didn't even go to stable@vger.kernel.org.

For reference, here comes the fixed patch again, see below.

Best regards
Uwe

------->8--------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Date: Wed, 22 Mar 2023 22:45:44 +0100
Subject: [PATCH] pwm: meson: Explicitly set .polarity in .get_state()

[ Upstream commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 ]

The driver only supports normal polarity. Complete the implementation of
=2Eget_state() by setting .polarity accordingly.

This fixes a regression that was possible since commit c73a3107624d
("pwm: Handle .get_state() failures") which stopped to zero-initialize
the state passed to the .get_state() callback. This was reported at
https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360 . While this was an
unintended side effect, the real issue is the driver's callback not
setting the polarity.

There is a complicating fact, that the .apply() callback fakes support
for inversed polarity. This is not (and cannot) be matched by
=2Eget_state(). As fixing this isn't easy, only point it out in a comment
to prevent authors of other drivers from copying that approach.

Fixes: c375bcbaabdb ("pwm: meson: Read the full hardware state in meson_pwm=
_get_state()")
Reported-by: Munehisa Kamata <kamatam@amazon.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230310191405.2606296-1-u.kleine-koenig@pe=
ngutronix.de
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/pwm-meson.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 6245bbdb6e6c..3c81858a8261 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -168,6 +168,12 @@ static int meson_pwm_calc(struct meson_pwm *meson, str=
uct pwm_device *pwm,
 	duty =3D state->duty_cycle;
 	period =3D state->period;
=20
+	/*
+	 * Note this is wrong. The result is an output wave that isn't really
+	 * inverted and so is wrongly identified by .get_state as normal.
+	 * Fixing this needs some care however as some machines might rely on
+	 * this.
+	 */
 	if (state->polarity =3D=3D PWM_POLARITY_INVERSED)
 		duty =3D period - duty;
=20
@@ -366,6 +372,7 @@ static void meson_pwm_get_state(struct pwm_chip *chip, =
struct pwm_device *pwm,
 		state->period =3D 0;
 		state->duty_cycle =3D 0;
 	}
+	state->polarity =3D PWM_POLARITY_NORMAL;
 }
=20
 static const struct pwm_ops meson_pwm_ops =3D {
--=20
2.39.2

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--pdwmzgflt4h5e3aq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmRGKrwACgkQj4D7WH0S
/k4+wggAtqrbN38/LsXHvres745QnSZWGnPdXfyNlFjkhcon1cmCBaCBN+6UK2BS
eBgSf8fFHqp1VdF6Jd55lJl6UTTy+Ah9Th3s5GamCXmS1lg2AEHs72uw7rsgp9kL
xIIlGqfqU2G1RdIoPLmoxMTfmi48+9np7CQCZRZquiT6ESUQzvnXKnn1o6Exccr2
v7OKSWTfx0Wj4um3zQyoz5g0+va2457IARQXyhKQn6F4uIAF9OMHQ1jfFDTod6RT
v2rt887fR1AjE/yNMD7zxxn3YHPHRjWqIeJbTRIdg1aSb8xf9o6ht8541Jelcv7R
fw6DcVYsTs5g5JcMw8nUWDEgZkFT7w==
=x1IB
-----END PGP SIGNATURE-----

--pdwmzgflt4h5e3aq--
