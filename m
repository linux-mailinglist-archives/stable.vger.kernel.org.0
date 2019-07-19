Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907086EB61
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfGST6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 15:58:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46684 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGST6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 15:58:55 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 38FC58032D; Fri, 19 Jul 2019 21:58:42 +0200 (CEST)
Date:   Fri, 19 Jul 2019 21:58:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4.19 30/47] genirq: Delay deactivation in free_irq()
Message-ID: <20190719195852.GA21625@amd>
References: <20190718030045.780672747@linuxfoundation.org>
 <20190718030051.289662042@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20190718030051.289662042@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Something went wrong in this mail:

On Thu 2019-07-18 12:01:44, Greg Kroah-Hartman wrote:
> From: Thomas Gleixner tglx@linutronix.de
>=20

normally there should be <> around the email address. And they are in
the git, and in 5.1 patch series, so I guess that is not a big deal.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0yIPwACgkQMOfwapXb+vIW/QCfe5x32r5LxQHmfqiOKHZ8zyrQ
zgUAoL3Qj+qeyPPm2moM18K+Ib2UC4E5
=QzI0
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
