Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382A1491229
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 00:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiAQXJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 18:09:03 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35692 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiAQXJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 18:09:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 50A9D1C0B80; Tue, 18 Jan 2022 00:09:01 +0100 (CET)
Date:   Tue, 18 Jan 2022 00:09:00 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Rod Whitby <rod@whitby.id.au>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 34/34] leds: leds-fsg: Drop FSG3 LED driver
Message-ID: <20220117230900.GB14035@duo.ucw.cz>
References: <20220117170326.1471712-1-sashal@kernel.org>
 <20220117170326.1471712-34-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20220117170326.1471712-34-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2022-01-17 12:03:24, Sasha Levin wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> [ Upstream commit b7f1ac9bb6413b739ea91bd61bdf23c9130a8007 ]
>=20
> The board file using this driver has been deleted and the
> FSG3 LEDs can be modeled using a system controller and some
> register bit LEDs in the device tree so this driver is no
> longer needed.

Please drop.
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYeX3DAAKCRAw5/Bqldv6
8uAFAJ4wNczlu5GY86dPh1N+DHt5QXqtqQCgl6SJj3ajMqBN2BzWdn7wZsH6UCc=
=mYjC
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
