Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11C62292D
	for <lists+stable@lfdr.de>; Sun, 19 May 2019 23:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfESVb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 May 2019 17:31:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59805 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbfESVb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 May 2019 17:31:26 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id A29C780378; Sun, 19 May 2019 23:31:14 +0200 (CEST)
Date:   Sun, 19 May 2019 23:31:24 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 06/16] power: supply: cpcap-battery: Fix
 division by zero
Message-ID: <20190519213124.GE31403@amd>
References: <20190516114107.8963-1-sashal@kernel.org>
 <20190516114107.8963-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <20190516114107.8963-6-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-05-16 07:40:57, Sasha Levin wrote:
> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit dbe7208c6c4aec083571f2ec742870a0d0edbea3 ]
>=20
> If called fast enough so samples do not increment, we can get
> division by zero in kernel:
>=20
> __div0
> cpcap_battery_cc_raw_div
> cpcap_battery_get_property
> power_supply_get_property.part.1
> power_supply_get_property
> power_supply_show_property
> power_supply_uevent
>=20
> Fixes: 874b2adbed12 ("power: supply: cpcap-battery: Add a battery driver")
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Yup, this one makes sense for stable

 Acked-for-stable-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzhyywACgkQMOfwapXb+vI0cgCgqDdY05iCOme5tsF19qlUHEJ/
kHAAnRDH7KmcqMhj3Z7HyS8NRGoTAv1L
=NXfl
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
