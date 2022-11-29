Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D8E63C6AC
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 18:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiK2Rqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 12:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiK2Rq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 12:46:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39D0663DD
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 09:46:27 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1p04gU-0005vz-NS; Tue, 29 Nov 2022 18:46:18 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p04gT-0017tc-2k; Tue, 29 Nov 2022 18:46:17 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p04gT-001HSw-1w; Tue, 29 Nov 2022 18:46:17 +0100
Date:   Tue, 29 Nov 2022 18:46:16 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 2
Message-ID: <20221129174616.tomdrudlz5e7ub6f@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-3-paul@crapouillou.net>
 <20221025064410.brrx5faa4jtwo67b@pengutronix.de>
 <Y90BKR.1BA4VWKIBIKU@crapouillou.net>
 <20221128143911.n3woy6mjom5n4sad@pengutronix.de>
 <8VZ3MR.B9R316RWSFMQ@crapouillou.net>
 <20221129162447.sqa6veugc2xn6vui@pengutronix.de>
 <dfb368f51365ab068d477154c8051117bae197de.camel@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b7nyxzolkfq6ylkb"
Content-Disposition: inline
In-Reply-To: <dfb368f51365ab068d477154c8051117bae197de.camel@crapouillou.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--b7nyxzolkfq6ylkb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2022 at 04:58:28PM +0000, Paul Cercueil wrote:
> Le mardi 29 novembre 2022 =E0 17:24 +0100, Uwe Kleine-K=F6nig a =E9crit=
=A0:
> > Hello Paul,
> >=20
> > On Tue, Nov 29, 2022 at 12:25:56PM +0000, Paul Cercueil wrote:
> > > Hi Uwe,
> > >=20
> > > Le lun. 28 nov. 2022 =E0 15:39:11 +0100, Uwe Kleine-K=F6nig
> > > <u.kleine-koenig@pengutronix.de> a =E9crit :
> > > > Hello,
> > > >=20
> > > > On Tue, Oct 25, 2022 at 11:10:46AM +0100, Paul Cercueil wrote:
> > > > > > Note that for disabled PWMs there is no official guaranty
> > > > > > about the pin
> > > > > > state. So it would be ok (but admittedly not great) to
> > > > > > simplify the
> > > > > > driver and accept that the pinstate is active while the PWM
> > > > > > is off.
> > > > > > IMHO this is also better than a glitch.
> > > > > >=20
> > > > > > If a consumer wants the PWM to be in its inactive state, they
> > > > > > should
> > > > > > not disable it.
> > > > >=20
> > > > > Completely disagree. I absolutely do not want the backlight to
> > > > > go full
> > > > > bright mode when the PWM pin is disabled. And disabling the
> > > > > backlight is a
> > > > > thing (for screen blanking and during mode changes).
> > > >=20
> > > > For some hardwares there is no pretty choice. So the gist is: If
> > > > the
> > > > backlight driver wants to ensure that the PWM pin is driven to
> > > > its
> > > > inactive level, it should use:
> > > >=20
> > > > =A0=A0=A0=A0=A0=A0=A0=A0pwm_apply(pwm, { .period =3D ..., .duty_cyc=
le =3D 0, .enabled
> > > > =3D true });
> > > >=20
> > > > and better not
> > > >=20
> > > > =A0=A0=A0=A0=A0=A0=A0=A0pwm_apply(pwm, { ..., .enabled =3D false });
> > >=20
> > > Well that sounds pretty stupid to me; why doesn't the PWM subsystem
> > > enforce
> > > that the pins must be driven to their inactive level when the PWM
> > > function
> > > is disabled?
> > >=20
> > > Then for such hardware you describe, the corresponding PWM
> > > driver could itself apply a duty_cycle =3D 0 if that's what it takes
> > > to get an
> > > inactive state.
> >=20
> > Let's assume we claim that on disable the pin is driven to the
> > inactive level.
> >=20
> > The (bad) effect is that for a use case where the pin state doesn't
> > matter (e.g. a backlight where the power regulator is off), the PWM
> > keeps running even though it could be disabled and so save some
> > power.
> >=20
> > So to make this use case properly supported, we need another flag in
> > struct pwm_state that allows the consumer to tell the lowlevel driver
> > that it's ok to disable the hardware even with the output being UB.
> > Let's call this new flag "spam" and the pin is allowed to do whatever
> > it
> > wants with .spam =3D false.
> >=20
> > After that you can realize that applying any state with:
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0.duty_cycle =3D A,
> > =A0=A0=A0=A0=A0=A0=A0=A0.period =3D B,
> > =A0=A0=A0=A0=A0=A0=A0=A0.polarity =3D C,
> > =A0=A0=A0=A0=A0=A0=A0=A0.enabled =3D false,
> > =A0=A0=A0=A0=A0=A0=A0=A0.spam =3D true,
> >=20
> > semantically (i.e. just looking at the output) has the same effect as
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0.duty_cycle =3D 0,
> > =A0=A0=A0=A0=A0=A0=A0=A0.period =3D $something,
> > =A0=A0=A0=A0=A0=A0=A0=A0.polarity =3D C,
> > =A0=A0=A0=A0=A0=A0=A0=A0.enabled =3D true,
> > =A0=A0=A0=A0=A0=A0=A0=A0.spam =3D true,
> >=20
> > So having .enabled doesn't add to the expressiveness of pwm_apply(),
> > because you can specify any configuration without having to resort to
> > .enabled =3D false. So the enabled member of struct pwm_state can be
> > dropped.
> >=20
> > Then we end up with the exact scenario we have now, just that the
> > flag
> > that specifies if the output should be held in the inactive state has
> > a
> > bad name.
>=20
> If I follow you, then it means that the PWM backlight driver pwm_bl.c
> should set state.enabled=3Dtrue in pwm_backlight_power_off() to make sure
> that the pin is inactive?

Correct, that's the only way to ensure that the pinlevel stays at the
intended level.

And lowlevel PWM drivers can be improved to disable the hardware when
they are asked for .duty_cycle =3D 0 (maybe under some additional
conditions).

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--b7nyxzolkfq6ylkb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmOGRWUACgkQwfwUeK3K
7AmPygf/YrZiaQjwEoBu0yuZx8XfGQUIjTHBaNj6Vqu5tVjGxcvb7mWxYOMs7bLY
5Qx3ZcRBR48+XWZ4/NIYshT2pwfTCV5WnTspldzH/+qkBWPZlOmEyyyXoR/gVGQU
USUJ7G2iNBdMtPH81d+nkfWA3WvYoDlRXS8YL1CudpUKlXq3sc1kXM4bNJA4lGlO
TU48wTXtCOLiP0GtPcB9eNWUcwYcpXMMuM0bCeiK23AyvMBoohm+lu6a85G9zaOX
v2YbjJGns5SOB+sfHv6pp+kht4NM+dq/kzPpeCAdY6+YWuSZvf4y3GFUoA3qG6MC
/4EYtStInVkwuzrWHO24Azam/uCmHA==
=Bc6+
-----END PGP SIGNATURE-----

--b7nyxzolkfq6ylkb--
