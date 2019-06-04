Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB388340AB
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfFDHtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:49:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59176 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFDHtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 03:49:33 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 3D5AF8030C; Tue,  4 Jun 2019 09:49:21 +0200 (CEST)
Date:   Tue, 4 Jun 2019 09:49:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 19/32] tipc: Avoid copying bytes beyond the supplied
 data
Message-ID: <20190604074928.GA24856@amd>
References: <20190603090308.472021390@linuxfoundation.org>
 <20190603090313.753666374@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20190603090313.753666374@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chris Packham <chris.packham@alliedtelesis.co.nz>
>=20
> TLV_SET is called with a data pointer and a len parameter that tells us
> how many bytes are pointed to by data. When invoking memcpy() we need
> to careful to only copy len bytes.

This one misses upstream commit id. AFAICT, patch is upstream and hash is=
=20

9bbcdb07a53549ed072f03a88a5012e939a64c01

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz2IogACgkQMOfwapXb+vKvMgCdHV64o5WUVlp50seYfQdX+wSv
yTMAoLANzTQ1eKz95Xd6tqv+r5pLDea8
=c0T1
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
