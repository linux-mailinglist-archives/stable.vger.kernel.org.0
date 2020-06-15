Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0008A1F9896
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgFONaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:30:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58416 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:30:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9F5701C0BD2; Mon, 15 Jun 2020 15:30:23 +0200 (CEST)
Date:   Mon, 15 Jun 2020 15:30:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Othacehe <m.othacehe@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 4.19 11/25] iio: vcnl4000: Fix i2c swapped word reading.
Message-ID: <20200615133018.GA18126@duo.ucw.cz>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174049.916148213@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20200609174049.916148213@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mathieu Othacehe <m.othacehe@gmail.com>
>=20
> commit 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 upstream.
>=20
> The bytes returned by the i2c reading need to be swapped
> unconditionally. Otherwise, on be16 platforms, an incorrect value will be
> returned.
>=20
> Taking the slow path via next merge window as its been around a while
> and we have a patch set dependent on this which would be held up.

Is there some explanation how this is correct Somewhere? I assume i2c
hardware has fixed endianity (not depending on CPU), so unconditional
swapping will cause problems either on le or on be machines...?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXud36gAKCRAw5/Bqldv6
8qWCAKCEGkUDcG/NxiktjeVkI549kb/jxgCfaJisPSiR0vHZMDMtJyn9GmhwT1w=
=1tNG
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
