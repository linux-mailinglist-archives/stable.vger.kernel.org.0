Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0208124A4DE
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 19:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgHSRXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 13:23:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45174 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSRXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 13:23:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B65381C0BBB; Wed, 19 Aug 2020 19:23:31 +0200 (CEST)
Date:   Wed, 19 Aug 2020 19:23:31 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/gem: Replace reloc chain with terminator on
 error unwind
Message-ID: <20200819172331.GA4796@amd>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20200819103952.19083-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> If we hit an error during construction of the reloc chain, we need to
> replace the chain into the next batch with the terminator so that upon
> flushing the relocations so far, we do not execute a hanging batch.

Thanks for the patches. I assume this should fix problem from
"5.9-rc1: graphics regression moved from -next to mainline" thread.

I have applied them over current -next, and my machine seems to be
working so far (but uptime is less than 30 minutes).

If the machine still works tommorow, I'll assume problem is solved.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl89YBIACgkQMOfwapXb+vI87QCghjYcIRWZI+jQEfQrwplelp6u
l/EAnRdT9hnEvkBhQSbOSUOmosDR3fZT
=jUba
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
