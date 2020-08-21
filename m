Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1BB24CE59
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 08:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgHUG7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 02:59:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47328 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHUG7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 02:59:53 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D7291C0BDF; Fri, 21 Aug 2020 08:59:50 +0200 (CEST)
Date:   Fri, 21 Aug 2020 08:59:49 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 196/228] RDMA/ipoib: Return void from
 ipoib_ib_dev_stop()
Message-ID: <20200821065949.GA23823@amd>
References: <20200820091607.532711107@linuxfoundation.org>
 <20200820091617.361805582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20200820091617.361805582@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kamal Heib <kamalheib1@gmail.com>
>=20
> [ Upstream commit 95a5631f6c9f3045f26245e6045244652204dfdb ]
>=20
> The return value from ipoib_ib_dev_stop() is always 0 - change it to be
> void.

AFAICT this is not a fixup, just a preparation for "RDMA/ipoib: Fix
ABBA deadlock with ipoib_reap_ah(", but we are not merging that for
4.14, so it should not be neccessary here.

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8/cOUACgkQMOfwapXb+vJPZwCeOtAN0vtlKWd3I48DEmnY3qhL
TWgAn3SoUcUR/kbLa9tN6jW2d23/Hx0f
=Td1L
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
