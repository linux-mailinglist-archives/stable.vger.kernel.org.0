Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA46716CD
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 10:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjARJA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 04:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjARI7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 03:59:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA5510F1
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:17:11 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pI3cu-0005iS-4F; Wed, 18 Jan 2023 09:16:56 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pI3ct-006rqX-8R; Wed, 18 Jan 2023 09:16:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pI3cs-00Do1d-I9; Wed, 18 Jan 2023 09:16:54 +0100
Date:   Wed, 18 Jan 2023 09:16:54 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@opendingux.net,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2
 channels, part 1
Message-ID: <20230118081654.qggjaockxwg2u2sg@pengutronix.de>
References: <20221024205213.327001-1-paul@crapouillou.net>
 <20221024205213.327001-2-paul@crapouillou.net>
 <20221025062129.drzltbavg6hrhv7r@pengutronix.de>
 <CVZAKR.06MA7BGA170W3@crapouillou.net>
 <20221117132927.mom5klfd4eww5amk@pengutronix.de>
 <SKFJLR.07UMT1VWJOD52@crapouillou.net>
 <20230117213556.vdurctncvnjom62g@pengutronix.de>
 <846b27400a72db8ca9b7497a6c032bdaacd62fc6.camel@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j264dxttbxzuunju"
Content-Disposition: inline
In-Reply-To: <846b27400a72db8ca9b7497a6c032bdaacd62fc6.camel@crapouillou.net>
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


--j264dxttbxzuunju
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Paul,

On Tue, Jan 17, 2023 at 11:05:10PM +0000, Paul Cercueil wrote:
> > I really lost track of the problem here and would appreciate a new
> > submission of the remaining (and improved?) patches.
>=20
> Sure. I still have the patchset on the backburner and plan to
> (eventually) send an updated version.
>=20
> If you are fishing for patches I think you can take patches 3/5 and 4/5
> of this patchset. Then I won't have to send them again in v2.

These are already in Linus' tree :-)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--j264dxttbxzuunju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmPHqvMACgkQwfwUeK3K
7AmjYQf/WDoRbGo4RiKUlL/jqsaejKvM+ue+qPcwVdGY4h9cxjc4Gn4B9atEPSoB
sPQpq1or9Zz5YwRRVeNTrLl386e0HzoKJXJl9lc+bdIjweHZCr1XvW2naauqtwjP
pXaDGv2YJrCzbIl4qIrFSsu2xO+B68UVocfAF93jEaNJqdgD7UvDSjhAf9MIuryV
SpCK3vIyUrkEdNY7TnRQFKprUE47XzoE6IUrMnqeaTN+i2IKKTPHnDYvD33axQ3v
9vOC9NDpGCqxgwo8moEO5ESaUvbgVr8wX54ar/Z2pH1opR/WQ382S92SmO0d/cCs
zTFvsc+MzysY135/3omJsXTfHuO4HQ==
=V8+j
-----END PGP SIGNATURE-----

--j264dxttbxzuunju--
