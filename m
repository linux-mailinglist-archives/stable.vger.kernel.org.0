Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDA129819F
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 13:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415674AbgJYMVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 08:21:54 -0400
Received: from sauhun.de ([88.99.104.3]:39328 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415672AbgJYMVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Oct 2020 08:21:54 -0400
Received: from localhost (p54b33def.dip0.t-ipconnect.de [84.179.61.239])
        by pokefinder.org (Postfix) with ESMTPSA id 0EB1A2C051E;
        Sun, 25 Oct 2020 13:21:51 +0100 (CET)
Date:   Sun, 25 Oct 2020 13:21:46 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5.8+ regression fix] i2c: core: Restore
 acpi_walk_dep_device_list() getting called after registering the ACPI i2c
 devs
Message-ID: <20201025122146.GA3327@kunai>
Mail-Followup-To: Wolfram Sang <wsa@the-dreams.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20201014144158.18036-1-hdegoede@redhat.com>
 <20201014144158.18036-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20201014144158.18036-2-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2020 at 04:41:58PM +0200, Hans de Goede wrote:
> Commit 21653a4181ff ("i2c: core: Call i2c_acpi_install_space_handler()
> before i2c_acpi_register_devices()")'s intention was to only move the
> acpi_install_address_space_handler() call to the point before where
> the ACPI declared i2c-children of the adapter where instantiated by
> i2c_acpi_register_devices().
>=20
> But i2c_acpi_install_space_handler() had a call to
> acpi_walk_dep_device_list() hidden (that is I missed it) at the end
> of it, so as an unwanted side-effect now acpi_walk_dep_device_list()
> was also being called before i2c_acpi_register_devices().
>=20
> Move the acpi_walk_dep_device_list() call to the end of
> i2c_acpi_register_devices(), so that it is once again called *after*
> the i2c_client-s hanging of the adapter have been created.
>=20
> This fixes the Microsoft Surface Go 2 hanging at boot.
>=20
> Fixes: 21653a4181ff ("i2c: core: Call i2c_acpi_install_space_handler() be=
fore i2c_acpi_register_devices()")
> Suggested-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-and-tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Applied to for-current, thanks!


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl+VbdYACgkQFA3kzBSg
KbYpcBAAtnlevgQhqA3wf2plhknr+IvEy5eRyL+7ykgsyfnmIRddR5KWY8rJBgEI
3M0FFpgNaiaoWQaKGaYDfOuK78PDu1OHwxsOYryYZzrLWWlmXHmI9l+PSgYiQj+J
BUjDtbNm6ymj/aaXusJ8xW8D5aYQ26VQggvEmcn3ArH1iK7TAITAI/WTzrh5zHOe
pgm1LYIqMxV9MK9HH16svYl4v2BgHoY66JEVf4DvFja5Cb4ET6U0aPNr5/c4aibM
o1D+QZjlRfO4kwR3NdXcH1uOtuT+fo3OfG5SVXWXvRJHLNF7F/JIWd6+Q+uWLfzw
DnDh9rnEFwDfeHu7nc6jT6XvwLzfSypWPU3CUI7VnbQ/BH3btzOMepjUGjynJSm0
EZNm7REFvbacaHMlq34rYHjTopJTy7If1B/Jf84g+Zs84NT0n90jbwT3/T+wwVhg
wCUG4H0/csZfojhuiUy471jed+YXwKJ4bouiEXNdo89Wxs5TGyQbubEjCzWJng/p
+Dl2npx2XWhcEf5R417R9SzCe9pTdXbi+g6LZ3MEq7qJCq7OLuoXgsY+gPpL1RhY
9I1CW2q/6GzjfHHe6Xc6q9e4YF5/2ZCORJIlyMr+3PnwgK7ZBmqTFoYOhlIBQ1LT
t+ah8PJ+FzirbsytqppSVvfvhLfAhrvKxTtB5kVNPZE6PO7IJig=
=p0ot
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
