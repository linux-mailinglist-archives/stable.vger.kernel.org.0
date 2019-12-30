Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090A012CEF1
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 11:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfL3KcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 05:32:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60364 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfL3KcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 05:32:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8DE3A1C2604; Mon, 30 Dec 2019 11:32:19 +0100 (CET)
Date:   Mon, 30 Dec 2019 11:32:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony camuso <tcamuso@redhat.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 089/219] ipmi: Dont allow device module unload when
 in use
Message-ID: <20191230103218.GA10304@amd>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162520.260768030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20191229162520.260768030@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-29 18:18:11, Greg Kroah-Hartman wrote:
> From: Corey Minyard <cminyard@mvista.com>
>=20
> [ Upstream commit cbb79863fc3175ed5ac506465948b02a893a8235 ]
>=20
> If something has the IPMI driver open, don't allow the device
> module to be unloaded.  Before it would unload and the user would
> get errors on use.
>=20
> This change is made on user request, and it makes it consistent
> with the I2C driver, which has the same behavior.
>=20
> It does change things a little bit with respect to kernel users.
> If the ACPI or IPMI watchdog (or any other kernel user) has
> created a user, then the device module cannot be unloaded.  Before
> it could be unloaded,
>=20
> This does not affect hot-plug.  If the device goes away (it's on
> something removable that is removed or is hot-removed via sysfs)
> then it still behaves as it did before.

I don't think this is good idea for stable. First, it includes
unrelated function rename, and second, it does not really fix any bug;
it just changes behaviour.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4J0jIACgkQMOfwapXb+vIKggCgl+EWWYdfU5yQtZi0Q4qW0y6Z
U0QAnA5Tj/Bb01z6IIIqyU9tF6PPDzx2
=7iOH
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
