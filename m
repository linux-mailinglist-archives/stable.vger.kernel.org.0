Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6A600DA4
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 13:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJQLXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 07:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJQLXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 07:23:18 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB3A5FAE8;
        Mon, 17 Oct 2022 04:23:17 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C4CBC1C0016; Mon, 17 Oct 2022 13:23:15 +0200 (CEST)
Date:   Mon, 17 Oct 2022 13:23:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 10/11] arm64: dts: uniphier: Add USB-device
 support for PXs3 reference board
Message-ID: <20221017112315.GA23442@duo.ucw.cz>
References: <20221011145358.1624959-1-sashal@kernel.org>
 <20221011145358.1624959-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20221011145358.1624959-10-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>=20
> [ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]
>=20
> PXs3 reference board can change each USB port 0 and 1 to device mode
> with jumpers. Prepare devicetree sources for USB port 0 and 1.
>=20
> This specifies dr_mode, pinctrl, and some quirks and removes nodes for
> unused phys and vbus-supply properties.

Why was this autoselected? It is a new feature, not a bugfix.

Best regards,
								Pavel

>  arch/arm/boot/dts/uniphier-pinctrl.dtsi       | 10 +++++
>  arch/arm64/boot/dts/socionext/Makefile        |  4 +-
>  .../socionext/uniphier-pxs3-ref-gadget0.dts   | 41 +++++++++++++++++++
>  .../socionext/uniphier-pxs3-ref-gadget1.dts   | 40 ++++++++++++++++++
>  4 files changed, 94 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadge=
t0.dts

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY007IwAKCRAw5/Bqldv6
8p+sAJ0dmbWz2vPNAoD4uwC2qVBzu8ew4QCcCX8M31XyibbpZ8FWinMz9Ga5eTM=
=KkB6
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
