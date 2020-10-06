Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707D285290
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 21:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgJFTgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 15:36:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46774 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJFTgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 15:36:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EAC451C0B90; Tue,  6 Oct 2020 21:36:34 +0200 (CEST)
Date:   Tue, 6 Oct 2020 21:36:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 21/38] spi: fsl-espi: Only process interrupts for
 expected events
Message-ID: <20201006193634.GB8771@duo.ucw.cz>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.694666032@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20201005142109.694666032@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b867eef4cf548cd9541225aadcdcee644669b9e1 ]
>=20
> The SPIE register contains counts for the TX FIFO so any time the irq
> handler was invoked we would attempt to process the RX/TX fifos. Use the
> SPIM value to mask the events so that we only process interrupts that
> were expected.
>=20
> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
> Implement soft interrupt replay in C").

We don't seem to have commit 3282... in 4.19, so we don't need this
one in 4.19-stable according to the changelog.

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3zHQgAKCRAw5/Bqldv6
8rerAJ9phDKjwCx3Hxdu+LKZs3EYH2O+dgCffeg5dYQnbCMt4fruw+/c5gCS+Ac=
=zgKk
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
