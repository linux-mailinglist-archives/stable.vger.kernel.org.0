Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7463BFDD
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 13:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiK2MQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 07:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiK2MQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 07:16:10 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207C5D686;
        Tue, 29 Nov 2022 04:16:08 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n20so33367528ejh.0;
        Tue, 29 Nov 2022 04:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0o9F921tSmBZ1JHe5u3FFmxlhdizuFsO6Knet+JYII=;
        b=CtdLezQ4I7c+qZE3ToqORB+8lPw6hxPRYuP8OooffHwTLBint5TdxwF8Ty/+P1RrMz
         V7ZU8oAsKkAaGc6uCDWax9aBHHhFSL+rhqqPnfiQs18AC14+tYnJxJ7VwYMjeJt4ZewF
         NNoxFr0jyBavh1BBv/0e0FKzB7tZw81PF9NUgScVuZ32EkO9P6zEgFh3+PyP/lB1qKpS
         6Y7HOzg9GmifmRGe2lFdiVzoEFTiijdSdgRfku44EJq6nB7jyxTZApR1Y66eyAwjoOza
         YqOKXSKNWz1Mu8GbnMOxesBUA9FRRcleJU2/GDk/gsUnKooFDb1prG4AmT54/3VQgzAd
         imTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0o9F921tSmBZ1JHe5u3FFmxlhdizuFsO6Knet+JYII=;
        b=53cKL8YKMtUl9FljaKL1oDZp+vB56h7vlVkpeKuX39jMs7anQSPrAf6JCnMxVSP6K3
         aC+5trbcn1ooC6ngqnrnjkeHC4OrVpGy90elGWPa8EZILEooSfpigEglS7xnoCg/xbB6
         tNocFBP2PQpuFWwk8lxTBSLRGzkV3YIlheyIbJ6wuSZNYq2QrKD0o140OYZqYsxxR+vz
         mpS7Dy3/fwFEkSXenHwLrWkfvJmCCUjckmifbFjmaeivoYYM/LxDHW7MtcBn9DM+CQQD
         MT6ddWqSKnghenCAzV7Z3sfynMCzGrzxnj6syWCGVohGnl6FPxUJzmRDMscEy4awlUJB
         0IIg==
X-Gm-Message-State: ANoB5pm9SYzNqeM68YvpLC8VWecYnnfMlPqEg8g8towbY+AI/B9IMBjX
        1lC72LxW7yOuEht/0OWy95pTyLvr120=
X-Google-Smtp-Source: AA0mqf5AB61kO2Wng+skL0utnyOYCmrCTCdFm0g5dgh02NtsLVAZr3RuuXrOf17UDayOA167cRT8/w==
X-Received: by 2002:a17:906:3e13:b0:78d:502c:aeb5 with SMTP id k19-20020a1709063e1300b0078d502caeb5mr32376632eji.88.1669724167296;
        Tue, 29 Nov 2022 04:16:07 -0800 (PST)
Received: from orome (p200300e41f201d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f20:1d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id hs32-20020a1709073ea000b007a8de84ce36sm6139596ejc.206.2022.11.29.04.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 04:16:06 -0800 (PST)
Date:   Tue, 29 Nov 2022 13:16:05 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Paul Cercueil <paul@crapouillou.net>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 2
Message-ID: <Y4X4BQ7t2OnH+OGb@orome>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-3-paul@crapouillou.net>
 <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
 <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
 <20221128143911.n3woy6mjom5n4sad@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Koq0Peq3tkGe0FPn"
Content-Disposition: inline
In-Reply-To: <20221128143911.n3woy6mjom5n4sad@pengutronix.de>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Koq0Peq3tkGe0FPn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28, 2022 at 03:39:11PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> On Tue, Oct 25, 2022 at 11:10:46AM +0100, Paul Cercueil wrote:
> > Le mar. 25 oct. 2022 =C3=A0 08:44:10 +0200, Uwe Kleine-K=C3=B6nig
> > <u.kleine-koenig@pengutronix.de> a =C3=A9crit :
> > > On Mon, Oct 24, 2022 at 09:52:10PM +0100, Paul Cercueil wrote:
> > > >  After commit a020f22a4ff5 ("pwm: jz4740: Make PWM start with the
> > > > active part"),
> > > >  the trick to set duty > period to properly shut down TCU2 channels
> > > > did
> > > >  not work anymore, because of the polarity inversion.
> > > >=20
> > > >  Address this issue by restoring the proper polarity before
> > > > disabling the
> > > >  channels.
> > > >=20
> > > >  Fixes: a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active
> > > > part")
> > > >  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > > >  Cc: stable@vger.kernel.org
> > > >  ---
> > > >   drivers/pwm/pwm-jz4740.c | 62
> > > > ++++++++++++++++++++++++++--------------
> > > >   1 file changed, 40 insertions(+), 22 deletions(-)
> > > >=20
> > > >  diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> > > >  index 228eb104bf1e..65462a0052af 100644
> > > >  --- a/drivers/pwm/pwm-jz4740.c
> > > >  +++ b/drivers/pwm/pwm-jz4740.c
> > > >  @@ -97,6 +97,19 @@ static int jz4740_pwm_enable(struct pwm_chip
> > > > *chip, struct pwm_device *pwm)
> > > >   	return 0;
> > > >   }
> > > >=20
> > > >  +static void jz4740_pwm_set_polarity(struct jz4740_pwm_chip *jz,
> > > >  +				    unsigned int hwpwm,
> > > >  +				    enum pwm_polarity polarity)
> > > >  +{
> > > >  +	unsigned int value =3D 0;
> > > >  +
> > > >  +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
> > > >  +		value =3D TCU_TCSR_PWM_INITL_HIGH;
> > > >  +
> > > >  +	regmap_update_bits(jz->map, TCU_REG_TCSRc(hwpwm),
> > > >  +			   TCU_TCSR_PWM_INITL_HIGH, value);
> > > >  +}
> > > >  +
> > > >   static void jz4740_pwm_disable(struct pwm_chip *chip, struct
> > > > pwm_device *pwm)
> > > >   {
> > > >   	struct jz4740_pwm_chip *jz =3D to_jz4740(chip);
> > > >  @@ -130,6 +143,7 @@ static int jz4740_pwm_apply(struct pwm_chip
> > > > *chip, struct pwm_device *pwm,
> > > >   	unsigned long long tmp =3D 0xffffull * NSEC_PER_SEC;
> > > >   	struct clk *clk =3D pwm_get_chip_data(pwm);
> > > >   	unsigned long period, duty;
> > > >  +	enum pwm_polarity polarity;
> > > >   	long rate;
> > > >   	int err;
> > > >=20
> > > >  @@ -169,6 +183,9 @@ static int jz4740_pwm_apply(struct pwm_chip
> > > > *chip, struct pwm_device *pwm,
> > > >   	if (duty >=3D period)
> > > >   		duty =3D period - 1;
> > > >=20
> > > >  +	/* Restore regular polarity before disabling the channel. */
> > > >  +	jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, state->polarity);
> > > >  +
> > >=20
> > > Does this introduce a glitch?
> >=20
> > Maybe. But the PWM is shut down before finishing its period anyway, so =
there
> > was already a glitch.
> >=20
> > > >   	jz4740_pwm_disable(chip, pwm);
> > > >=20
> > > >   	err =3D clk_set_rate(clk, rate);
> > > >  @@ -190,29 +207,30 @@ static int jz4740_pwm_apply(struct pwm_chip
> > > > *chip, struct pwm_device *pwm,
> > > >   	regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
> > > >   			   TCU_TCSR_PWM_SD, TCU_TCSR_PWM_SD);
> > > >=20
> > > >  -	/*
> > > >  -	 * Set polarity.
> > > >  -	 *
> > > >  -	 * The PWM starts in inactive state until the internal timer
> > > > reaches the
> > > >  -	 * duty value, then becomes active until the timer reaches the
> > > > period
> > > >  -	 * value. In theory, we should then use (period - duty) as the
> > > > real duty
> > > >  -	 * value, as a high duty value would otherwise result in the PWM
> > > > pin
> > > >  -	 * being inactive most of the time.
> > > >  -	 *
> > > >  -	 * Here, we don't do that, and instead invert the polarity of the
> > > > PWM
> > > >  -	 * when it is active. This trick makes the PWM start with its
> > > > active
> > > >  -	 * state instead of its inactive state.
> > > >  -	 */
> > > >  -	if ((state->polarity =3D=3D PWM_POLARITY_NORMAL) ^ state->enable=
d)
> > > >  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
> > > >  -				   TCU_TCSR_PWM_INITL_HIGH, 0);
> > > >  -	else
> > > >  -		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
> > > >  -				   TCU_TCSR_PWM_INITL_HIGH,
> > > >  -				   TCU_TCSR_PWM_INITL_HIGH);
> > > >  -
> > > >  -	if (state->enabled)
> > > >  +	if (state->enabled) {
> > > >  +		/*
> > > >  +		 * Set polarity.
> > > >  +		 *
> > > >  +		 * The PWM starts in inactive state until the internal timer
> > > >  +		 * reaches the duty value, then becomes active until the timer
> > > >  +		 * reaches the period value. In theory, we should then use
> > > >  +		 * (period - duty) as the real duty value, as a high duty value
> > > >  +		 * would otherwise result in the PWM pin being inactive most of
> > > >  +		 * the time.
> > > >  +		 *
> > > >  +		 * Here, we don't do that, and instead invert the polarity of
> > > >  +		 * the PWM when it is active. This trick makes the PWM start
> > > >  +		 * with its active state instead of its inactive state.
> > > >  +		 */
> > > >  +		if (state->polarity =3D=3D PWM_POLARITY_NORMAL)
> > > >  +			polarity =3D PWM_POLARITY_INVERSED;
> > > >  +		else
> > > >  +			polarity =3D PWM_POLARITY_NORMAL;
> > > >  +
> > > >  +		jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, polarity);
> > > >  +
> > > >   		jz4740_pwm_enable(chip, pwm);
> > > >  +	}
> > >=20
> > > Note that for disabled PWMs there is no official guaranty about the p=
in
> > > state. So it would be ok (but admittedly not great) to simplify the
> > > driver and accept that the pinstate is active while the PWM is off.
> > > IMHO this is also better than a glitch.
> > >=20
> > > If a consumer wants the PWM to be in its inactive state, they should
> > > not disable it.
> >=20
> > Completely disagree. I absolutely do not want the backlight to go full
> > bright mode when the PWM pin is disabled. And disabling the backlight i=
s a
> > thing (for screen blanking and during mode changes).
>=20
> For some hardwares there is no pretty choice. So the gist is: If the
> backlight driver wants to ensure that the PWM pin is driven to its
> inactive level, it should use:
>=20
> 	pwm_apply(pwm, { .period =3D ..., .duty_cycle =3D 0, .enabled =3D true }=
);
>=20
> and better not
>=20
> 	pwm_apply(pwm, { ..., .enabled =3D false });

Depending on your hardware capabilities you may also be able to use
pinctrl to configure the pin to behave properly when the PWM is
disabled. Not all hardware can do that, though.

Thierry

--Koq0Peq3tkGe0FPn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmOF+AIACgkQ3SOs138+
s6GOsg/+Jvr8RQdp3q4wicdqOq7B4ba3hkzQ3d1TRv6f5KbP5bLj+dUVs0nHRZ5O
w+MhlLuMDDuQb71bbxtJvw1ZAMkKuA/rO5ly+qrylrw+Pv0QmHlfiqPQX+TWLF6a
+7p/QxbttTtT6YxBl6IZ5smCP6H2nehkFzo3KB2L1G08Ch2rz0oep4eT9Du+VfJf
D5H1u06PIKANAR2YlcN5HLGrAVWTRPw+jPs9omJXH8IT5BLwWY2sBQO36D5fmqqT
NFHnijA7b6wJdnu0gcxuqZtbabi5jZuviHztRECBaQMyc4lShFNZhciF1zpWY6tJ
yz6EwbzHfMKr9dcXBWYk64UeUnD6xDBODNMs3Zrf7GVspg0eGegEYrDEOA0H0Bbe
agWBqQmHGNgdIq8PYNrFTaH3SNlHzy6kR6dGWGOl6xv4oFY0D+5ph8RFz9wtMIn4
d90z3HEHXpFt2EWjH7/VfttvRKZf43ivXrynH4+w08/V8CYZTnLYGbCj1wWorBTX
fTQCW+q8LbudzXj0GcCmenFJfRM2VHJpdiWm20YdeD7I+HLgwANFOdNMsUPL9E7q
zaBUyY03WVA31n54djzXocBnPu9JHhdncY15BGq6cfBxjEjxjXW0p6SP36p+Vi7j
rx82oieWKQO1b/wDoUCCFfWQfikmnHzk/X+t9Qq+c70d1bHHLCs=
=NnE/
-----END PGP SIGNATURE-----

--Koq0Peq3tkGe0FPn--
