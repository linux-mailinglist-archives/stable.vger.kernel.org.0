Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C023747F
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfFFMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 08:50:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50026 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfFFMuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 08:50:09 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 32D5380262; Thu,  6 Jun 2019 14:49:57 +0200 (CEST)
Date:   Thu, 6 Jun 2019 14:50:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     pavel@ucw.cz
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kangjie Lu <kjlu@umn.edu>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 249/276] media: si2165: fix a missing check of
 return value
Message-ID: <20190606125006.GB27432@amd>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030540.713606171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20190530030540.713606171@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0ab34a08812a3334350dbaf69a018ee0ab3d2ddd ]
>=20
> si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
> that "val_tmp" will be an uninitialized value when regmap_read() fails.
> "val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
> "val" will be a random value. Further use will lead to undefined
> behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
> its error code upstream.

Ok, but there's still undefined behaviour in si2165_readreg8, 16 and
24, where it manipulates and prints uninitialized memory, right?

									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz5C/4ACgkQMOfwapXb+vKnbwCgjf8g1YCjHfmt2pq0lnCO8Hbt
TpYAni4HDZ+1op9LKWmHXuBpGoW0nkXY
=ukvM
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
