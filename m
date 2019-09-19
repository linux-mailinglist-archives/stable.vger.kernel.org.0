Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38299B745D
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 09:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfISHqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 03:46:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47201 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbfISHqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 03:46:06 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 5A56E8164C; Thu, 19 Sep 2019 09:45:48 +0200 (CEST)
Date:   Thu, 19 Sep 2019 09:46:01 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4.19 16/50] gpiolib: acpi: Add
 gpiolib_acpi_run_edge_events_on_boot option and blacklist
Message-ID: <20190919074601.GA6968@amd>
References: <20190918061223.116178343@linuxfoundation.org>
 <20190918061224.680169319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20190918061224.680169319@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-09-18 08:18:59, Greg Kroah-Hartman wrote:
> From: Hans de Goede <hdegoede@redhat.com>
>=20
> commit 61f7f7c8f978b1c0d80e43c83b7d110ca0496eb4 upstream.
>=20
> Another day; another DSDT bug we need to workaround...
>=20
> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
> at least once on boot") we call _AEI edge handlers at boot.
>=20
> In some rare cases this causes problems. One example of this is the Minix
> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
> and pasted code for dealing with Micro USB-B connector host/device role
> switching, while the mini PC does not even have a micro-USB connector.
> This code, which should not be there, messes with the DDC data pin from
> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
>=20
> To avoid problems like this, this commit adds a new
> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
> allows disabling the running of _AEI edge event handlers at boot.

So... apparently Windows does _not_ run _AEI edge event handlers at
boot, otherwise Minix would realize that fault.

Would it make sense not to do it by default, either?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAl2DMjkACgkQMOfwapXb+vI6ugCdEebfVH22q7FiPfHqC6qCzlnC
CLMAliAngsZDT3SZdRjwMFvR/UPcfew=
=Vg10
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
