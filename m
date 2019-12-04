Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1F1127CB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 10:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfLDJiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 04:38:04 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56304 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfLDJiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 04:38:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 74A261C25FD; Wed,  4 Dec 2019 10:38:02 +0100 (CET)
Date:   Wed, 4 Dec 2019 10:38:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/321] reset: fix reset_control_ops kerneldoc
 comment
Message-ID: <20191204093801.GB7678@amd>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223427.758333833@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <20191203223427.758333833@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-03 23:31:18, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> [ Upstream commit f430c7ed8bc22992ed528b518da465b060b9223f ]
>=20
> Add a missing short description to the reset_control_ops
> documentation.

Why is it pending for stable? It does not break anything, but neither
it fixes anything, it adds to reviewer load...

Sasha, what is your process for selecting commits for stable?

Best regards,

							Pavel

> +++ b/include/linux/reset-controller.h
> @@ -7,7 +7,7 @@
>  struct reset_controller_dev;
> =20
>  /**
> - * struct reset_control_ops
> + * struct reset_control_ops - reset controller driver callbacks
>   *
>   * @reset: for self-deasserting resets, does all necessary
>   *         things to reset the device

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3nfnkACgkQMOfwapXb+vJvBACgl2X2MqD8ooBF9KXrkQFMeFpy
QHEAn1PQZYiX4C+gJZGXQQYtVjiKRzpV
=RbuH
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
