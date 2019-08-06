Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0772883D5B
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHFWbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:31:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49197 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfHFWbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 18:31:43 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 42B3E80249; Wed,  7 Aug 2019 00:31:28 +0200 (CEST)
Date:   Wed, 7 Aug 2019 00:31:39 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 4.19 46/74] mmc: dw_mmc: Fix occasional hang after tuning
 on eMMC
Message-ID: <20190806223139.GA9937@amd>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124939.613665562@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20190805124939.613665562@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm hoping that whatever problems exynos was having in the past are
> somehow magically fixed now and we can make the behavior the same for
> all commands.

Dunno. Maybe they are in mainline, but are they fixed in all the
stable releases this is being applied to?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1J/8sACgkQMOfwapXb+vJoZACghpsASllLQgsUqU2l0CcJATpY
+SkAoJpedwMmOnvunt89uj4L/VO+nxfj
=X+Fj
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
