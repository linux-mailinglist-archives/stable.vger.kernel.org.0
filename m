Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09644C3223
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiBXQvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiBXQvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:51:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256631CD9C2
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:50:37 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHJx-00013C-V6; Thu, 24 Feb 2022 17:50:26 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHJx-00138Z-TI; Thu, 24 Feb 2022 17:50:25 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHJw-005Gmy-GY; Thu, 24 Feb 2022 17:50:24 +0100
Date:   Thu, 24 Feb 2022 17:50:24 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Max Kellermann <max.kellermann@gmail.com>
Cc:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] pwm-sun4i: calculate "delay_jiffies" directly,
 eliminate absolute time
Message-ID: <20220224165024.c76hawufdbe32rjj@pengutronix.de>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125123429.3490883-2-max.kellermann@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6rwb7qkkozklm54a"
Content-Disposition: inline
In-Reply-To: <20220125123429.3490883-2-max.kellermann@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6rwb7qkkozklm54a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2022 at 01:34:28PM +0100, Max Kellermann wrote:
> Basically this code did "jiffies + period - jiffies", and we can
> simply eliminate the "jiffies" time stamp here.
>=20
> Cc: stable@vger.kernel.org

I don't see how this is relevant for stable, but the change looks fine:

Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--6rwb7qkkozklm54a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIXt0wACgkQwfwUeK3K
7Amqdwf9GAUan7K0PAFqHgtejdhyiyyrO0YjnQfmhJ9PO4uWvoqYsHaNVop+fEWs
bmMj2jq6FJBUkS1l6Ee+x4itJrIbW/iyamW6msOWSsVbE9+Kr9ceA/WsJNtogq3N
isv+YGmB6jNxq9WMeZZjMZQG5Q04VqGsS6n8MFO/IFVThkDu5hKebT9UO4p9KSml
FzfHDNUKnuZXJ8v0XLyi0tTYc21iEbIAbTga/jYYVgEtVAIzdJg/OXRvijve8IDN
qlx0KK5tI7yNvMk9KqEhwtqJbILqGYRZVaH48mgbQ1I8jLmgC2lACUFkaU6j5YLe
9wpJbUXX4PA25AXQ0acWJoz2B8w4tA==
=xfcm
-----END PGP SIGNATURE-----

--6rwb7qkkozklm54a--
