Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88921BE0F
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 21:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGJTrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 15:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgGJTrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 15:47:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A774C08C5DD
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 12:47:07 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1jtyz9-0006yQ-Bx; Fri, 10 Jul 2020 21:47:03 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1jtyz8-0004JW-8a; Fri, 10 Jul 2020 21:47:02 +0200
Date:   Fri, 10 Jul 2020 21:47:02 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        tsbogend@alpha.franken.de
Subject: Re: [PATCH] [stable v5.4.x] pwm: jz4740: Fix build failure
Message-ID: <20200710194702.ire4deel2zn7mnxk@pengutronix.de>
References: <20200710102758.8341-1-u.kleine-koenig@pengutronix.de>
 <DB8C7C01-0FBB-4A9F-B068-15C06BBC0873@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i5nxag3vhy7nqukt"
Content-Disposition: inline
In-Reply-To: <DB8C7C01-0FBB-4A9F-B068-15C06BBC0873@goldelico.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i5nxag3vhy7nqukt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 12:48:36PM +0200, H. Nikolaus Schaller wrote:
>=20
> > Am 10.07.2020 um 12:27 schrieb Uwe Kleine-K=F6nig <u.kleine-koenig@peng=
utronix.de>:
> >=20
> > When commit 9017dc4fbd59 ("pwm: jz4740: Enhance precision in calculation
> > of duty cycle") from v5.8-rc1 was backported to v5.4.x its dependency on
> > commit ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver") was not
> > noticed which made the pwm-jz4740 driver fail to build.
>=20
> Please can you add my "reported by?"

Greg, can you please add this while applying? (Assuming you're ok with
this change and ideally Paul can confirm the change is fine.)

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--i5nxag3vhy7nqukt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl8IxbIACgkQwfwUeK3K
7Annsgf5ASCw9N+4nsVPlurKYW/tl+25A2JMt+u3ASGqGMGwcayAvQw5rQ8X47W3
gwdmGGV7IlwvktVkhICGhTWAMYEJmH3amOYNjJWYhrdBv6jSh/84UVHF6VSDBqPv
DbxdosDUpYptJsiv5ABrFpYdkWfp4hguU6vJhth5fYaE8N4qnpIliWL4RGDanNFc
lGpdw6CrVdmAtJNgfOj/ocMr/rTEsKdzWeNgZ5uWTS95hGHvXqj9h1tOOi3tAGBb
HKIosCI+UOyJZt1bL8hJbi5M8WO1DbZfMOZmvN/IMgaSOY4A3yIvqFWyKlX9pzEX
YPmEoNW6huLwU4fpTP/J1rfXVRcklg==
=fuWC
-----END PGP SIGNATURE-----

--i5nxag3vhy7nqukt--
