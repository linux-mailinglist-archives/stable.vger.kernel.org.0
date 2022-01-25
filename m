Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A23349BBE4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiAYTPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:15:54 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49490 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiAYTPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:15:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 978481C0B88; Tue, 25 Jan 2022 20:15:46 +0100 (CET)
Date:   Tue, 25 Jan 2022 20:15:46 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 127/239] ARM: imx: rename DEBUG_IMX21_IMX27_UART to
 DEBUG_IMX27_UART
Message-ID: <20220125191546.GA5395@duo.ucw.cz>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183947.149798691@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20220124183947.149798691@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]
>=20
> Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the config
> DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.
>=20
> So, rename this option to DEBUG_IMX27_UART and adjust dependencies in
> Kconfig and rename the definitions to IMX27 as further clean-up.
>=20
> This issue was discovered with ./scripts/checkkconfigsymbols.py, which
> reported that DEBUG_IMX21_IMX27_UART depends on the non-existing config
> SOC_IMX21.

This is unsuitable for 4.19, as CONFIG_SOC_IMX21 is still present
there. It is probably okay for 5.10. I did not check others.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfBMYgAKCRAw5/Bqldv6
8kLmAJ9Tn1pr0Eu14zkiONTP061sMm/3pgCdFHJqS6R92Z1sRdgpcR9UiA/trh8=
=1bY9
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
