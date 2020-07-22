Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1827A2297E5
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgGVMJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:09:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51102 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731563AbgGVMJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 08:09:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E8F8C1C0BDA; Wed, 22 Jul 2020 14:09:30 +0200 (CEST)
Date:   Wed, 22 Jul 2020 14:09:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 066/133] regmap: debugfs: Dont sleep while atomic
 for fast_io regmaps
Message-ID: <20200722120930.GB25691@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152806.931980695@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20200720152806.931980695@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Douglas Anderson <dianders@chromium.org>
>=20
> [ Upstream commit 299632e54b2e692d2830af84be51172480dc1e26 ]
>

> +	err =3D kstrtobool_from_user(user_buf, count, &new_val);
> +	/* Ignore malforned data like debugfs_write_file_bool() */

> +	err =3D kstrtobool_from_user(user_buf, count, &new_val);
> +	/* Ignore malforned data like debugfs_write_file_bool() */

I guess that should be "malformed" in both cases.

Plus it would not be bad to share code between those two functions, as
they are pretty much identical...

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxgsegAKCRAw5/Bqldv6
8jjKAJ9XM6BGEO5Sp5iv5rUAtHF9vjKwNACfY5+7HjeXDBXVMTH1O0t9/AmYp20=
=XYw2
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
