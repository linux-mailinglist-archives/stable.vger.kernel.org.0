Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098276CF61
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390494AbfGROCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 10:02:31 -0400
Received: from sauhun.de ([88.99.104.3]:45086 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfGROCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 10:02:31 -0400
Received: from localhost (p54B330C7.dip0.t-ipconnect.de [84.179.48.199])
        by pokefinder.org (Postfix) with ESMTPSA id 399802C2868;
        Thu, 18 Jul 2019 16:02:28 +0200 (CEST)
Date:   Thu, 18 Jul 2019 16:02:27 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rob Herring <robh@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] iio: adc: gyroadc: fix uninitialized return code
Message-ID: <20190718140227.GA3813@kunai>
References: <20190718135758.2672152-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20190718135758.2672152-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2019 at 03:57:49PM +0200, Arnd Bergmann wrote:
> gcc-9 complains about a blatant uninitialized variable use that
> all earlier compiler versions missed:
>=20
> drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
>=20
> Return -EINVAL instead here and a few lines above it where
> we accidentally return 0 on failure.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Yes, I checked the other error paths, too, and they look proper to me.

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl0we+8ACgkQFA3kzBSg
KbYFExAAiU0knL5icE+gKlWN8Amm/LWljBQpjQBwAEeVxaqs3PWHRxVvXYyp7ahZ
nlaDmp9pKn8/iaXdxl3OdN3P5OcuSrE9rMVZ8CGdDWHGUAg6GpeCBASitaL6OhiQ
ByF0v2XY2IelOKkwtfjiRdABKC9+p99MeBMfzIyw8ZLHaLvIrJOp2h7ArSl5QAQI
JAgOJ4haOKGL3WGFBm1cU1JVq7Zsy8oyiibLhG5b7jStr+QDuXhhpMm/MVripCJ0
516m5K1gxRO+P6yQHVTw5lD+C01fWAobltwgJDmM+0Mn/kCJvtsG497v9pt7neQs
VuryNoU+lKcNx9CR6Mbo/PScXdNeQws1cSbO9rRAUZqwgrzYe+1l5sqfddEoP7QJ
erreHy0r35a2JlpubcNlk7WFpVxDj8rDueADicLtDDEP9CtHGZahAo1n4u7MpIfC
mJgJ1MCCxvp0Nv7S0P2FFwv0Q+WTFgNHiHkppqd4IYXS6G3QMHNHXLr8CVJRupPp
RXnkQS2cK0RwXKnGqkha7mCz5hURoGhi5riD0WNU9tIqQAQ9JpAz6SQSHJWAQ14G
fyXgEk8sibz0Zj1Vp4WzSmn7bY2Z33gSMlf+LD2WB6xFiPSD2P1p3hz/e3OISaFT
YTPXPAHDc0/WIr26/K8CDqM+MBQOhFlJKJpG+YuEPDwzCWZlXJ4=
=x53J
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
