Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5E28A253
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 00:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgJJW44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 18:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732646AbgJJTyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:45 -0400
Received: from localhost (p5486c996.dip0.t-ipconnect.de [84.134.201.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FAFF221FC;
        Sat, 10 Oct 2020 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602328185;
        bh=uQHAiDa6UwVzkeCNcXIht55Jnp6noC/hcJNuIPqmHCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0z0W8fNw4fEhhciSCnPL+grc2lVTijBpwyFLBjDvdKH1g6Hsfviwtw9WzcLRa8erQ
         iz5uYhPXdUa49k98N/TQOkCKLoULKVqwnSWpSLfxlJLrkTynwPe1yrBx+nC9AYyhWL
         80JkjDpLcPpXIy8QCbKnQl0xJqEPFoxyRL0Pj0lM=
Date:   Sat, 10 Oct 2020 13:09:37 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v6 3/3] i2c: imx: Don't generate STOP condition if
 arbitration has been lost
Message-ID: <20201010110937.GD4669@ninjato>
References: <20201009110320.20832-1-ceggers@arri.de>
 <20201009110320.20832-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <20201009110320.20832-4-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2020 at 01:03:20PM +0200, Christian Eggers wrote:
> If arbitration is lost, the master automatically changes to slave mode.
> I2SR_IBB may or may not be reset by hardware. Raising a STOP condition
> by resetting I2CR_MSTA has no effect and will not clear I2SR_IBB.
>=20
> So calling i2c_imx_bus_busy() is not required and would busy-wait until
> timeout.
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Tested (not extensively) on Vybrid VF500 (Toradex VF50):
> Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: stable@vger.kernel.org # Requires trivial backporting, simple remove
>                            # the 3rd argument from the calls to
>                            # i2c_imx_bus_busy().

Applied to for-next, thanks!


--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl+BlnEACgkQFA3kzBSg
KbZqtw//b4hEFkfLFb1etf0/EeQm4uXhVbUaXFusSVs5rfpiSQo73CrMk4DoL2uv
K3QyXs4hXYVx9n976MRbAHGF3Epo74HnVyij6RxIgdQYLzmYHdy5XnDRJCvFFZIm
nQzSPaQ67CNOgxn4+r7tpFeX9Ap094ewIpms/OjJbv0JKDuBWuoBf52e+UAuqtpw
FnfKMJtA6zsC/cbWW1O7kwJylxVdExChZ2x+yByeDV+p4y+M4xL6dUGkz13uVorX
OTxnCfQgsgouhwrxC+cWvb7y37hbu4zGwmTjTsKHYSR/IhQ/NRCDq6x94nXauYT6
CpaqqikT+aqeq6reO5wCd/ci3IiZOlAwAXBQdsaJav0N9dsvzxOetggM/uXAvkIH
C+HDyMiZJib2pFGkdmmF4P+mdgmqCuXwWdvnOO2mqnk17VHva8js/FhJPgW84bA+
O4bMbofkVJNeOLTnXvnikVwXNVz02C/XUiAPq4PEhMPWNGLgaoHuBngDwghxQR2K
8GaGrQ968GAkimnTsMl8wIsimxUkFiwGTxHKm6p1cs4Ekmr14aeiVmXOmFzRKmLa
aJQ/uy/U+mo+YMoBobROlomjAZP/GfplxgWtCIu79apQg6fZZ5ivnG8XEG/CD3zX
KS9MkYPdTSd7fXqBMUkIoIUa+sllE87Yr6prvHiRaxrAPVf2tKg=
=+4FV
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
