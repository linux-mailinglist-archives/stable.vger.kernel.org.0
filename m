Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B128D017
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHNJw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 05:52:56 -0400
Received: from sauhun.de ([88.99.104.3]:47030 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfHNJwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 05:52:55 -0400
Received: from localhost (p54B33326.dip0.t-ipconnect.de [84.179.51.38])
        by pokefinder.org (Postfix) with ESMTPSA id E99402C311C;
        Wed, 14 Aug 2019 11:52:53 +0200 (CEST)
Date:   Wed, 14 Aug 2019 11:52:53 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux@rempel-privat.de, linux-imx@nxp.com, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        cphealy@gmail.com, andrew.smirnov@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] Revert "i2c: imx: improve the error handling in
 i2c_imx_dma_request()"
Message-ID: <20190814095253.GC1511@ninjato>
References: <20190808210136.10294-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <20190808210136.10294-1-festevam@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 06:01:36PM -0300, Fabio Estevam wrote:
> Since commit e1ab9a468e3b ("i2c: imx: improve the error handling in
> i2c_imx_dma_request()") when booting with the DMA driver as module (such
> as CONFIG_FSL_EDMA=3Dm) the following endless clk warnings are seen:
>=20

A bit surprised nobody acked or tested this patch, still:

Applied to for-current, thanks!


--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl1T2fUACgkQFA3kzBSg
KbZnvBAAmEk80qUX88ybzLbMMbcb6Dye0laI5GuoIQwEDmKBiwvwlBHfR58oD/mp
Umf7UojOEfg2HRHrfURZ/DDBfxdLN8k2uPITqV7vwEaOsG8X63VUq9Q5xtCqwlfo
fcpsgsDQb5mlXu/ZUSjJebTo0IB9oupHeEIgy1wbunyU7T7gFQZWVRiCJZJTkbRV
NdA0y/QpUVz6PnsD/c5O9Wmh6I0qhfDk2gMe81Du5ehKYoy7WAFK3RsgUb+AfXQR
N69twC00dhwpup6UYatQ+lmKzIbfplZrsXZJEawV3sJMea2IDh5W5g/l5DgiZpPz
mrANfat/cNOkaK5uWxGGCIlsmAXq0EyiyCIzlInwMdA399+or3nC0pTw7MH82UCa
yZU18kvz8P8ceZ+hSpnYnWD8OftyXrmQlrBkqvhf5xHnDTgKjex+jgfnVMe8PmSl
wErzq5C8Z1XP7wL+5MCnVGzbxepCY9Rjxs+n5a9qyzOGJIPR8YosLPGXFqUBLPMF
rEagRDcFw4F96hpDHT1RBp2++G0WcS1V81DkCtxZYUOFibfyTooCVNRP5thYo6oC
GLBvs1RJDPOggPNirkSkSiUlPaKyoJ25xeqAIy6gjrend5aJl8DQc8QibLvMFXK6
TVGmwq1lVPVI56/0q/l6Z/dOmd34X9C0RNPg6LrfM6dK8cvUcWo=
=OuCg
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
