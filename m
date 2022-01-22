Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC6496E02
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 21:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiAVUpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 15:45:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56420 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiAVUpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 15:45:40 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 78BB91C0B76; Sat, 22 Jan 2022 21:45:38 +0100 (CET)
Date:   Sat, 22 Jan 2022 21:45:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        linux@armlinux.org.uk, linus.walleij@linaro.org, daniel@thingy.jp,
        avolmat@me.com, krzysztof.kozlowski@canonical.com,
        romain.perier@gmail.com, eugen.hristev@microchip.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.4 06/29] ARM: imx: rename
 DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
Message-ID: <20220122204537.GA31487@duo.ucw.cz>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-6-sashal@kernel.org>
 <20220120100849.GA14998@amd>
 <YexahcZZO1z/pM94@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <YexahcZZO1z/pM94@sashalap>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > >=20
> > > [ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]
> > >=20
> > > Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the con=
fig
> > > DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.
> >=20
> > This is unsuitable for 4.4 as imx21 is still supported there.
>=20
> I'll drop it, thanks!

Thank you.

I have not checked which is the newest kernel that supports imx21,
other kernels may have same issue, too.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYexs8QAKCRAw5/Bqldv6
8sPMAJ0Ru+Wuf16Ox2dRQUCWSmL6Pa+miQCeItBzUjW/5yODWS1xoZfyqm9rYCE=
=4cY3
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
