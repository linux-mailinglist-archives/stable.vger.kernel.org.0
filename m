Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FC624CE60
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHUHCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:02:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47614 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHUHCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:02:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3BDA51C0BE7; Fri, 21 Aug 2020 09:02:17 +0200 (CEST)
Date:   Fri, 21 Aug 2020 09:02:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 196/212] gpu: ipu-v3: image-convert: Combine
 rotate/no-rotate irq handlers
Message-ID: <20200821070216.GB23823@amd>
References: <20200820091602.251285210@linuxfoundation.org>
 <20200820091612.258939813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20200820091612.258939813@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Steve Longerbeam <slongerbeam@gmail.com>
>=20
> [ Upstream commit 0f6245f42ce9b7e4d20f2cda8d5f12b55a44d7d1 ]
>=20
> Combine the rotate_irq() and norotate_irq() handlers into a single
> eof_irq() handler.

AFAICT this is preparation for next patch, not a backfix. And actual
fix patch is not there for 4.19, so this can be dropped, too.

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8/cXgACgkQMOfwapXb+vID1wCgupaXZlylVTOocz4db3lSAhBD
tBIAnjzvK4RFX9DT8ly3bLWxoEW6hAAM
=2jcA
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
