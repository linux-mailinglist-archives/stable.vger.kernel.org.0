Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31674880C
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 17:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfFQP5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 11:57:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50439 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbfFQP5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 11:57:02 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 2352980278; Mon, 17 Jun 2019 17:56:50 +0200 (CEST)
Date:   Mon, 17 Jun 2019 17:57:00 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 033/375] leds: avoid races with workqueue
Message-ID: <20190617155659.GB32544@amd>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-33-sashal@kernel.org>
 <20190524225505.GA16076@amd>
 <20190529185143.GH12898@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20190529185143.GH12898@sasha-vm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >Could we hold this patch for now?
>=20
> Sure, dropped. Thanks!

So... fix for this now should be in mainline. But as original problem
is not too severe, I don't think we need to apply this or the fixed
version to stable.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0HuEsACgkQMOfwapXb+vIN9gCghh2mt0P0yiQz64VCwTSsLCGE
8k0AoLxWHBoA6YRevOHIQHADmm7JTh3U
=ve35
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
