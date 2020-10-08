Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A9287210
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgJHJ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgJHJ4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 05:56:36 -0400
Received: from localhost (p54b33b8c.dip0.t-ipconnect.de [84.179.59.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCB72083B;
        Thu,  8 Oct 2020 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602150995;
        bh=67+NuNT2UHBer+NKq+5rAQ1KcQNMPcWUDBXJvCqObSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z4xXoMz4bDkX00PWLz7d3A6owo1/38o5WaAOygwOVwfAOdG4z/gWSJHB2YiOzhMgD
         PLqU3tpAPn2VStKKEGU/sh8UKDzDqLSw2Kd7Y5lpKhLdbm3GK22Wl+4vuEoFmPhR7x
         tw5aTTOy98aghKJQVLu1+uo+De1yV0z5a/PrgS3c=
Date:   Thu, 8 Oct 2020 11:56:31 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
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
Subject: Re: [PATCH v5 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201008095631.GB76290@ninjato>
References: <20201007084524.10835-1-ceggers@arri.de>
 <20201007084524.10835-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20201007084524.10835-2-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 07, 2020 at 10:45:22AM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quir=
ks")
> Reviewed-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Cc: stable@vger.kernel.org

Applied to for-current, thanks!

Waiting for review tags for patches 2 & 3.


--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl9+4k8ACgkQFA3kzBSg
KbZ9qhAAgKhI6M7LDGtr4rgN5aM9C/PH7BSIAhhywx9YkeKU1XiIWnXA559eKSs+
2xFwbwZGtDXxKaxB6KFGrJvrFbeOt8M7FGZ4UyufRJStG8FYQeJRjvAOThfcUxpu
YgMkzrG962/bXPcO0LPD6n1aq4LTcr7g9OMai7CQHnyI7RrhQYZeqjPpbbfIms5U
mLLxbjvtRVJaHNbkwsAMe8AHHYRxB4gn/zIzlIEUHgkFMpnlrsPCOnZg9yH2TtpO
9J7aZeT1+0XiLpdNjdDKkzTB4fNLTikTTSORnl+WYt3D1RYjkPDOjv1bMHGa/ZxZ
dOARk4XVWqqoIZ7civGgdFCQtpY++fqtcxt6qGIwvFWRwFSleNNu7fWZI91GtPeD
hNW9meo8zoBQTsNuoYLT4cxunUVNbTx0tiVZSbRt9S3DI5UZZQL5/pDP7KLq339d
Hifhk+iPG65mR75zInjj3JBdb4bYVcSkTeL9Nsqp6RB3AQGPTy/3s/f/v/nBW690
it/YmzrH+s2LGzoH6gEXSEHxab0PP//FBAtg66zwuszN51Yrk5Je9hMOCEM6esG6
7kXWoGy7rDZ7BiOXk5pMlYOfD02U6losxRS9XUnhBGwvqNL18+MG3kq5+PcubQpv
YJFwQrFe9gR4MlZMe1CtOI21mxz91xvh8G5+u8yiXgzFZEH2WyM=
=F4QS
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
