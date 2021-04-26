Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8302936BB0D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhDZVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 17:12:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51208 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhDZVMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 17:12:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7FCBF1C0B79; Mon, 26 Apr 2021 23:11:37 +0200 (CEST)
Date:   Mon, 26 Apr 2021 23:11:36 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 1/7] ARM: dts: Fix swapped mmc order for omap3
Message-ID: <20210426211136.GA31646@amd>
References: <20210419204608.7191-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20210419204608.7191-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit a1ebdb3741993f853865d1bd8f77881916ad53a7 ]
>=20
> Also some omap3 devices like n900 seem to have eMMC and micro-sd swapped
> around with commit 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for
> drivers that existed in v4.4").
>=20
> Let's fix the issue with aliases as discussed on the mailing lists. While
> the mmc aliases should be board specific, let's first fix the issue with
> minimal changes.

21b2cec61c04 tries to make newer kernels compatible with 4.4, and this
is fixup for 21b2cec61c04. 21b2cec61c04 is not in 4.4 (obviously) so i
don't believe we need this for 4.4.

As this claims to "making it compatible with 4.4", I believe we should
leave 4.4 alone.

21b2cec61c04 is not present in v4.19, either, but what needs to be
done there is less clear.

21b2cec61c04 is in v5.10, so a1ebdb3741993f853865d1bd8f77881916ad53a7
makes sense there, too.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCHLIgACgkQMOfwapXb+vL79wCgs2jx6N45TMeX+TDZerFINSqJ
EIMAnjD8EduuGN8g5U6/iKTjK4vuJZ57
=DuMi
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
