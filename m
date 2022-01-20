Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F38494B62
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 11:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359745AbiATKIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 05:08:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51128 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiATKIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 05:08:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D40EF1C0B9D; Thu, 20 Jan 2022 11:08:49 +0100 (CET)
Date:   Thu, 20 Jan 2022 11:08:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        linux@armlinux.org.uk, linus.walleij@linaro.org, daniel@thingy.jp,
        avolmat@me.com, krzysztof.kozlowski@canonical.com,
        romain.perier@gmail.com, eugen.hristev@microchip.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.4 06/29] ARM: imx: rename
 DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
Message-ID: <20220120100849.GA14998@amd>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20220118030822.1955469-6-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>=20
> [ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]
>=20
> Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the config
> DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.

This is unsuitable for 4.4 as imx21 is still supported there.

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHpNLEACgkQMOfwapXb+vIK+QCdFpNrZaNRihZRERAmIJfqIRIR
3V4AoK2o7fGwp/CNSeLYdXXA2CP3rt/d
=1+rP
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
