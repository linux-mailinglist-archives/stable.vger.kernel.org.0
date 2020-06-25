Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4A420A55F
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 21:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbgFYTBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 15:01:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55180 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390330AbgFYTBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 15:01:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 97AD01C0BD2; Thu, 25 Jun 2020 21:01:19 +0200 (CEST)
Date:   Thu, 25 Jun 2020 21:01:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 003/206] ASoC: tegra: tegra_wm8903: Support nvidia,
 headset property
Message-ID: <20200625190119.GA5531@duo.ucw.cz>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195317.089299546@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20200623195317.089299546@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 3ef9d5073b552d56bd6daf2af1e89b7e8d4df183 ]
>=20
> The microphone-jack state needs to be masked in a case of a 4-pin jack
> when microphone and ground pins are shorted. Presence of nvidia,headset
> tells that WM8903 CODEC driver should mask microphone's status if short
> circuit is detected, i.e headphones are inserted.

> +	if (of_property_read_bool(card->dev->of_node, "nvidia,headset"))
> +		shrt =3D SND_JACK_MICROPHONE;
> +

This property is not properly documented, not it is used anywhere.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvT0fwAKCRAw5/Bqldv6
8rs3AJ9UuqYiXBscp38HKtHWwXh71sBtYQCfYUmGT8EHdksG5RIL+o8icarWYYY=
=I6Xm
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
