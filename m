Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18526A2EFD
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 10:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBZJSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 04:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBZJSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 04:18:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A44A5FC
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 01:18:01 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWDAH-0008Ad-S8; Sun, 26 Feb 2023 10:17:53 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWDAG-000MiI-QF; Sun, 26 Feb 2023 10:17:52 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWDAF-000OyU-HT; Sun, 26 Feb 2023 10:17:51 +0100
Date:   Sun, 26 Feb 2023 10:17:52 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     thierry.reding@gmail.com, tobetter@gmail.com,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pwm: core: Zero-initialize the temp state
Message-ID: <20230226091752.wtnj7oqzmn6azahl@pengutronix.de>
References: <20230226013722.1802842-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5rbivgnxok4x6fcf"
Content-Disposition: inline
In-Reply-To: <20230226013722.1802842-1-kamatam@amazon.com>
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


--5rbivgnxok4x6fcf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> Zero-initialize the on-stack structure to avoid unexpected behaviors. Some
> drivers may not set or initialize all the values in pwm_state through the=
ir
> .get_state() callback and therefore some random values may remain there a=
nd
> be set into pwm->state eventually.
>=20
> This actually caused regression on ODROID-N2+ as reported in [1]; kernel
> fails to boot due to random panic or hang-up.
>=20
> [1] https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360

Looking through the report I wonder what actually made the machine fail
to boot. Doesn't this paper over a problem that should be fixed (also)
somewhere else?

Which driver is the one that the problem occur for?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5rbivgnxok4x6fcf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmP7I70ACgkQwfwUeK3K
7AkSqQf+PQRB/iBxK2N2bbBFz6/yzLKrxeWeKcrWi5kCfwRHvJSMMmwGNUoq8HBp
mnNhvceIZDBrRCKcXosWgcUcf8jNFRlUqyLXf58yqIPJ5Tr7UGUBDYPmB6c/OasZ
CuGMiySQE36V32IvlJAUEIjQ7pnPSrwWg8fE8ZESo7L0hc1I7+XYVQPwJqklOZr3
OQkIlUKClBoe6Ak4C+dGbXAK8NVWHdRrmGbIWCNsILBM4uQopOXNA7ZWELf9f5m5
NcOCNkQNghhCMVEVEElcC0fDrV+ilwZJRNy5axMksQdDpPbPoiSs59bNDN9i3fj6
jn8SCuQbds+QDygig7ltfZB7w27MpA==
=MkIE
-----END PGP SIGNATURE-----

--5rbivgnxok4x6fcf--
