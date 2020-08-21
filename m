Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5BA24CF0D
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgHUHV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:21:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49324 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgHUHV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:21:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0555D1C0BF3; Fri, 21 Aug 2020 09:21:24 +0200 (CEST)
Date:   Fri, 21 Aug 2020 09:21:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 83/92] mfd: dln2: Run event handler loop under
 spinlock
Message-ID: <20200821072123.GC23823@amd>
References: <20200820091537.490965042@linuxfoundation.org>
 <20200820091541.964627271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <20200820091541.964627271@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>=20
> [ Upstream commit 3d858942250820b9adc35f963a257481d6d4c81d ]
>=20
> The event handler loop must be run with interrupts disabled.
> Otherwise we will have a warning:
=2E..
> Recently xHCI driver switched to tasklets in the commit 36dc01657b49
> ("usb: host: xhci: Support running urb giveback in tasklet
> context").

AFAICT, 36dc01657b49 is not included in 4.19.141, so this commit
should not be needed, either.

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8/dfMACgkQMOfwapXb+vLMTACgiwiKsJXzkeupMh+PAlL1dpn0
pQ4AoIXuQpO8hmAqR1AV1FgtPQfbD7hQ
=lTmd
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
