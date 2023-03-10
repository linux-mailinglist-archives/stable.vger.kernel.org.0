Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843C06B50C6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCJTQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 14:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCJTQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 14:16:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4E512DDD1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:16:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1paiDe-0003QZ-7p; Fri, 10 Mar 2023 20:15:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1paiDd-003F52-Fw; Fri, 10 Mar 2023 20:15:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1paiDc-003s9D-S6; Fri, 10 Mar 2023 20:15:56 +0100
Date:   Fri, 10 Mar 2023 20:15:55 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, thierry.reding@gmail.com,
        kernel@pengutronix.de, tobetter@gmail.com
Subject: Re: [PATCH] pwm: Zero-initialize the pwm_state passed to driver's
 .get_state()
Message-ID: <20230310191555.jxxwhtl5ql5zgqah@pengutronix.de>
References: <20230228101558.b4dosk54jojfqkgi@pengutronix.de>
 <20230228194327.1237008-1-kamatam@amazon.com>
 <20230228214818.zkzmr6zuqica4bqa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="44kagmuyev3czqv2"
Content-Disposition: inline
In-Reply-To: <20230228214818.zkzmr6zuqica4bqa@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--44kagmuyev3czqv2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Feb 28, 2023 at 10:48:18PM +0100, Uwe Kleine-K=F6nig wrote:
> On Tue, Feb 28, 2023 at 11:43:27AM -0800, Munehisa Kamata wrote:
> > Perhaps, you should also add Cc tag for the stable tree? I did that in =
my
> > patch and we're actually CCing to the stable list, but I'm not sure if =
it
> > can pick up your patch without the tag. This should be fixed in linux-6=
=2E2.y.
>=20
> IMHO the problem you reported should be fixed by adapting .get_state()
> in the meson driver.

Note I sent a patch that implements this now. Find it at
https://lore.kernel.org/linux-pwm/20230310191405.2606296-1-u.kleine-koenig@=
pengutronix.de

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--44kagmuyev3czqv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQLgegACgkQwfwUeK3K
7AkdYgf+JNz00EvRYa6n4Gf2Wkt89K4VQ3P7Fs9akbXwhiPvqMBiwRqsA8DD4seY
oxNV8cNGvroVR6PliVsr3QfD3e7V5+61hafGu+Ripwc753FvbKlqH3+jPOpbKpaj
tsVfu3Fma/stwNBiH0Z79chIJ3d+nTCZha6Zwv+e66/TfBXKd0Zbtv4bJuTJ6kju
wPcUbYSuMwQjyoferF6X9au43KxAntLEZBF1D/dn3v8MbNLnfl99Hi/x9B06KnHI
moO2mKTu56HyZncB8JmS/9/QjY8STS1psjBoUD/NLIQAbgiuLykM1XUlUt06GaXj
RIC8yBoz/hJoytGhemmMu/152ZWGZA==
=BO0e
-----END PGP SIGNATURE-----

--44kagmuyev3czqv2--
