Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D54471FC
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 22:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfFOUFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 16:05:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59707 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfFOUFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 16:05:11 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 9933B80211; Sat, 15 Jun 2019 22:04:54 +0200 (CEST)
Date:   Sat, 15 Jun 2019 22:05:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 080/118] ARM: dts: imx51: Specify IMX5_CLK_IPG as
 "ahb" clock to SDMA
Message-ID: <20190615200503.GA31108@amd>
References: <20190613075643.642092651@linuxfoundation.org>
 <20190613075648.475709941@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20190613075648.475709941@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 918bbde8085ae147a43dcb491953e0dd8f3e9d6a ]
>=20
> Since 25aaa75df1e6 SDMA driver uses clock rates of "ipg" and "ahb"
> clock to determine if it needs to configure the IP block as operating
> at 1:1 or 1:2 clock ratio (ACR bit in SDMAARM_CONFIG). Specifying both
> clocks as IMX5_CLK_SDMA results in driver incorrectly thinking that
> ratio is 1:1 which results in broken SDMA funtionality. Fix the code
> to specify IMX5_CLK_AHB as "ahb" clock for SDMA, to avoid detecting
> incorrect clock ratio.

I don't see 25aaa75df1e6 commit in stable-4.19.y branch. Is that intentiona=
l?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0FT28ACgkQMOfwapXb+vL6dgCfYW2JjV1nayaQSK9FOWnkOf8B
ZOcAnRoMrSeSUpv79gq3VOQGJA5FSa8m
=hmem
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
