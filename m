Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943BE200A15
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbgFSN2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:28:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732695AbgFSN2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:28:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 863BA1C0BD2; Fri, 19 Jun 2020 15:28:10 +0200 (CEST)
Date:   Fri, 19 Jun 2020 15:28:10 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Pavel Machek (CIP)" <pavel@denx.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 047/172] ASoC: meson: add missing free_irq()
 in error path
Message-ID: <20200619132810.GA1345@amd>
References: <20200618012218.607130-1-sashal@kernel.org>
 <20200618012218.607130-47-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20200618012218.607130-47-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: "Pavel Machek (CIP)" <pavel@denx.de>
>=20
> [ Upstream commit 3b8a299a58b2afce464ae11324b59dcf0f1d10a7 ]
>=20
> free_irq() is missing in case of error, fix that.
>=20
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
>=20
> Link: https://lore.kernel.org/r/20200606153103.GA17905@amd
> Signed-off-by: Mark Brown <broonie@kernel.org>

Notice that the bug this fixes is theoretical (found by code review)
and the fix itself was not tested by me as I don't have the hardware.

It may be good idea to for mainline to test the change a bit...

Best regards,
							Pavel
						=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7svWoACgkQMOfwapXb+vKgPwCfatdZSXBo7eyLKEUcWoN1nKrh
K8kAn2+x3sAUwlj/zrlpo9y3mh1nlBDY
=nSQo
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
