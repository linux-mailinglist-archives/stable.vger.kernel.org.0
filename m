Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26691F8896
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 13:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFNLSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 07:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgFNLSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 07:18:47 -0400
Received: from localhost (p5486c990.dip0.t-ipconnect.de [84.134.201.144])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409E22068E;
        Sun, 14 Jun 2020 11:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592133526;
        bh=cxDB1FPumFu9taynLLB3wnJOdrr5+Q2VR1Lx3+78SkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fd3cF66raaUz75ozMNM0fhwFlDNkLm798v31XglLCIAT5UccXlB+LzcHx/CB7sQyy
         X1F46mLkaBmx5Apb789Hv80eNHn9Ob5T2mOX1yzEHi+SwhvM4Li7YbRcf9hJ9IRQHp
         uGlH26D6WVEdHZ8XmCAN9JU8TCcokz5yk4jw8F1I=
Date:   Sun, 14 Jun 2020 13:18:39 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
Message-ID: <20200614111839.GA1883@ninjato>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org>
 <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > If interrupt fires early, the dspi_interrupt() could complete
> > (dspi->xfer_done) before its initialization happens.
> >
> > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait que=
ue with a simple completion")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
>=20
> Why would an interrupt fire before spi_register_controller, therefore
> before dspi_transfer_one_message could get called?

I don't know this HW, but the generic answer usually is: Bootloader used
SPI and didn't clean up properly.


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7mB4sACgkQFA3kzBSg
KbZD0A//bgaXCsITkWj3QldSdnswEWGMLXHbOZ/hiDQDQhdalBXQfKMBPRoVxp0+
IS/HwMRd/pzggXGJt7tv6LpmZ+eXx1ARmKxPQZBo/+RDF2qLAxKetkU/kX+MDw5K
wYXFv7bizFqTwTN6uMDfI44EraCHxTqtgQm9wswDCcDXG+WWCPJ4skdU9h+x/HdL
mQ5XFfFxEGIetUKsKv2AXxNH9Q06+KF4wsXBSL4E3jQjoaahEj2WNyt+FF21/4X0
gzhWjxa82acwzHHDXyLhyO9MAJOnwKQxfhsWsxsbHKVWLBLBPtNoXac7M4pLPTqK
DFREw95DQyb/IAL8eOfBokVlxdSrzQo0IrJPUtmfWN3R3ybvNNUePWvJ6udeTHyL
Wr+LqmEF0jv7+GvhG4orKqInZlaA23PdEZIPrmBaF3vbdiS6RxDTvn13r7uqGXYD
3GL8lkWzl2MEn69zuklAPAKqyb5a7QzPQkzOG9I1grXRN5ErEU6z06F+Lvngef83
VqqvQgQTXL73xsvoXysEkOWoLVp4RfSRi6271H5KO0PTGSs6E8W3quNEEAaKlQsD
jGlkbJZpVtvbgs0+QS4glIt/zCawe+M81vk1lyq0TRrGObOzin8AKVVngMuk6rJ2
gebkH6HZC8PQEc/8fxEmnUBHgrTtw5nP8qvsm3d9YkME0eG6Vbs=
=76dA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
