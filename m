Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352702851E0
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 20:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgJFSqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 14:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFSqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 14:46:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C6C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 11:46:21 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPryR-0006IY-T8; Tue, 06 Oct 2020 20:46:07 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kPryO-0002kv-TF; Tue, 06 Oct 2020 20:46:04 +0200
Date:   Tue, 6 Oct 2020 20:46:04 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201006184604.sagdwpev4bimgmct@pengutronix.de>
References: <20201006160814.22047-1-ceggers@arri.de>
 <20201006160814.22047-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uyxqy6g5mcqw5ti6"
Content-Disposition: inline
In-Reply-To: <20201006160814.22047-2-ceggers@arri.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uyxqy6g5mcqw5ti6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 06, 2020 at 06:08:12PM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org

Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks=
")
Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Best regards and thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--uyxqy6g5mcqw5ti6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl98u2oACgkQwfwUeK3K
7AkdSwf/b7pXPLNUUTj/WY1RMQy5ZbKvG1tJ4Tix3ve+/r3+8PS2b4mSmwEd5Ihn
Tzu5VdaKWr/THDMxuI60jbr0owYU0oLteUtlw/rXfu4iREG7ioLkZmSAov84vP4w
GojRpkLdz/NGcFz04S21aW1SqhbMgctaZReqfo85VTititp/Cz6eFS7yBTC5O+P/
g0ksHuxm6xsSFo2J2PsYUU/Q143tVQGkG8LY/L9LTWIjPzC6IxM8o+9Hhs0o4uKh
5EWzw5iLBXc6WBga9JPmrlpsi6YPjJHrdWKu/HjjdmCF3wnv03JsHeJqRD9oLI78
EFFKGPkGlputZONPSYlu4+yqsXJ9Qg==
=aJAa
-----END PGP SIGNATURE-----

--uyxqy6g5mcqw5ti6--
