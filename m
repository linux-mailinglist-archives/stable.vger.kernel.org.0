Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3916A1D90D4
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgESHRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:17:09 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45666 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgESHRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:17:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E31491C025C; Tue, 19 May 2020 09:17:07 +0200 (CEST)
Date:   Tue, 19 May 2020 09:17:07 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 01/80] net: dsa: Do not make user port errors fatal
Message-ID: <20200519071707.GA2609@amd>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173450.419156571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20200518173450.419156571@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Florian Fainelli <f.fainelli@gmail.com>
>=20
> commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream.
>=20
> Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
> not treat failures to set-up an user port as fatal, but after this
> commit we would, which is a regression for some systems where interfaces
> may be declared in the Device Tree, but the underlying hardware may not
> be present (pluggable daughter cards for instance).
>=20

> +++ b/net/dsa/dsa2.c
> @@ -412,7 +412,7 @@ static int dsa_tree_setup_switches(struc
> =20
>  		err =3D dsa_switch_setup(ds);
>  		if (err)
> -			return err;
> +			continue;

The error code is discarded here, so user can now wonder "why does not
my port work" with no indications in the logs... Should we do
dev_info() here?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7Dh/MACgkQMOfwapXb+vK6EwCfbsYtW3pWBV0oHAsKPFkjovUR
EMwAn0AlL0il0dzKyEclywFJIbeOaWmh
=+Ing
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
