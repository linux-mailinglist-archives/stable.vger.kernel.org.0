Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B7B128A5A
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 17:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfLUQU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 11:20:59 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58948 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUQU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 11:20:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 600AC1C24DF; Sat, 21 Dec 2019 17:20:56 +0100 (CET)
Date:   Sat, 21 Dec 2019 17:20:55 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, sre@kernel.org, nekit1000@gmail.com,
        mpartap@gmx.net, merlijn@wizzup.org, martin_rysavy@centrum.cz,
        Sekhar Nori <nsekhar@ti.com>, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>
Subject: Re: TI omap compile problem in 5.5-rc1? was Re: [PATCH] ARM:
 davinci: select CONFIG_RESET_CONTROLLER
Message-ID: <20191221162055.GA28997@amd>
References: <20191210195202.622734-1-arnd@arndb.de>
 <20191217104520.GA6812@amd>
 <20191217164640.GX35479@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20191217164640.GX35479@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Selecting RESET_CONTROLLER is actually required, otherwise we
> > > can get a link failure in the clock driver:
> > >=20
> > > drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks=
':
> > > psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_re=
gister'
> > > drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> > > psc-da850.c:(.text+0x24): undefined reference to
> > > `reset_controller_add_lookup'
> >=20
> > Does omap need similar handing in 5.5-rc1?
> >=20
> >   LD      .tmp_vmlinux1
> >   drivers/soc/ti/omap_prm.o: In function `omap_prm_probe':
> >   omap_prm.c:(.text+0x4d0): undefined reference to
> >   `devm_reset_controller_register'
> >   /data/fast/l/k/Makefile:1077: recipe for target 'vmlinux' failed
> >   make[1]: *** [vmlinux] Error 1
> >=20
> > Enabling reset controller seems to help::
> >=20
> > Reset Controller Support (RESET_CONTROLLER) [Y/n/?] (NEW)
> >   TI SYSCON Reset Driver (RESET_TI_SYSCON) [N/m/y/?] (NEW)
>=20
> Yes see the patch Arnd recently posted to do that.

Thanks for the hint and sorry for the noise.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3+RmcACgkQMOfwapXb+vKm5gCdFEsAX+EXEf7Ut87c0ONSz54l
qhkAn1USmYq8ChLyUnMRl1fbdwed6pTk
=PjuJ
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
