Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA46E6532
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjDRNBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjDRNB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:01:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A7617901
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:01:25 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pokxX-0004qj-U8; Tue, 18 Apr 2023 15:01:23 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pokxW-00C6un-6j; Tue, 18 Apr 2023 15:01:22 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pokxV-00EDfC-Gl; Tue, 18 Apr 2023 15:01:21 +0200
Date:   Tue, 18 Apr 2023 15:01:21 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 003/124] pwm: cros-ec: Explicitly set .polarity in
 .get_state()
Message-ID: <20230418130121.rx2zfwkzjyasghkg@pengutronix.de>
References: <20230418120309.539243408@linuxfoundation.org>
 <20230418120309.688458749@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g52g47n37ng5h7dl"
Content-Disposition: inline
In-Reply-To: <20230418120309.688458749@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--g52g47n37ng5h7dl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:20:22PM +0200, Greg Kroah-Hartman wrote:
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 30006b77c7e130e01d1ab2148cc8abf73dfcc4bf ]
>=20
> The driver only supports normal polarity. Complete the implementation of
> .get_state() by setting .polarity accordingly.
>=20
> Reviewed-by: Guenter Roeck <groeck@chromium.org>
> Fixes: 1f0d3bb02785 ("pwm: Add ChromeOS EC PWM driver")
> Link: https://lore.kernel.org/r/20230228135508.1798428-3-u.kleine-koenig@=
pengutronix.de
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I see you picked this one and the similar sprd patch, but not

	8caa81eb950c pwm: meson: Explicitly set .polarity in .get_state()
	b20b097128d9 pwm: iqs620a: Explicitly set .polarity in .get_state()
	6f5793798014 pwm: hibvt: Explicitly set .polarity in .get_state()

(At least I didn't get a mail about these). These should qualify in the sam=
e way.

Maybe you also want to pick

	1271a7b98e79 pwm: Zero-initialize the pwm_state passed to driver's .get_st=
ate()

Best regards
Uwe


--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--g52g47n37ng5h7dl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmQ+lKAACgkQj4D7WH0S
/k6YEAgAu3Zzmo/fksVPCdyMlil6ppIGbLNolDf5fRIjbF9u7sykPbSKIebOUXvu
wZuwHo8WpDM27/tixjxrGxXt4bCgRMdBsOQewqma5vLAbAoRmAqKvuOCNfrVdH8+
Ri6SqGg9tatlt1SPaWyghvxnCwgrLMNV3YIWzkmP+zDXvnA2nYVZlxnNXRPv2Joz
sLK71EmWFtwO6zBnkLwwWk8tmSx5LHHTqyYZrCtFg5S6b/oKQxQxPPMjIJPh6+ak
vaNh4iC7ej798Cpc23BoBiQ0tfbeoxebpxRRSBGkLcpwlv7N96s1ev0LHfhhHsw8
9iBMdDjBpz9g1gSkpQqW7P4KkpA8mQ==
=6KWX
-----END PGP SIGNATURE-----

--g52g47n37ng5h7dl--
