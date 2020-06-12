Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807121F74FB
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 10:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgFLICw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 04:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgFLICu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 04:02:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2525EC03E96F
        for <stable@vger.kernel.org>; Fri, 12 Jun 2020 01:02:50 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jjee9-0005y1-Pv; Fri, 12 Jun 2020 10:02:41 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jjee8-0002KU-He; Fri, 12 Jun 2020 10:02:40 +0200
Date:   Fri, 12 Jun 2020 10:02:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Fugang Duan <B38611@freescale.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Gao Pan <b54642@freescale.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Wolfram Sang <wsa@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612080240.73xkiu2esgg6nbp3@pengutronix.de>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612055114.alhm2uakoze6epvf@pengutronix.de>
 <20200612073815.GA25803@pi3>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="exe7tgb6se3ukbnm"
Content-Disposition: inline
In-Reply-To: <20200612073815.GA25803@pi3>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:42:33 up 209 days, 23:01, 197 users,  load average: 0.01, 0.03,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--exe7tgb6se3ukbnm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2020 at 09:38:15AM +0200, Krzysztof Kozlowski wrote:
> On Fri, Jun 12, 2020 at 07:51:14AM +0200, Oleksij Rempel wrote:
> > Hi Krzysztof,
> >=20
> > thank you for your patch.
> >=20
> > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> > > the i2c_imx_isr() will access registers before the I2C hardware is
> > > initialized.  This leads to external abort on non-linefetch on Toradex
> > > Colibri VF50 module (with Vybrid VF5xx):
> > >=20
> > >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x88=
82d003
> > >     Internal error: : 1008 [#1] ARM
> > >     Modules linked in:
> > >     CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
> > >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > >       (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
> > >       (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
> > >       (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
> > >       (really_probe) from [<80580380>] (driver_probe_device+0x60/0x17=
0)
> > >       (driver_probe_device) from [<80580630>] (device_driver_attach+0=
x58/0x60)
> > >       (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/=
0xc0)
> > >       (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
> > >       (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1e=
c)
> > >       (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
> > >       (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
> > >       (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178=
/0x1dc)
> > >       (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
> > >       (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)
> > >=20
> > > Additionally, the i2c_imx_isr() could wake up the wait queue
> > > (imx_i2c_struct->queue) before its initialization happens.
> > >=20
> > > Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> >=20
> >=20
> > I assume register access is aborted, because the IP core clock is not
> > enabled. In this case we have bigger problem then just probe.
>=20
> If by IP core clock you mean the clock which driver is getting, then
> answer is no. This clock is enabled.
>=20
> > Since this driver support runtime power management, the clock will be
> > disabled as soon as transfer is done. It means, on shared interrupt, we
> > will get in trouble even if there is no active transfer.
>=20
> The driver's runtime PM plays only with this one clock, so it seems
> you meant i2c_imx->clk. It is not this problem.
>=20
> >=20
> > So, probably the only way to fix it, is to check in i2c_imx_isr() if the
> > HW is expected to be active and register access should be save.
>=20
> Checking in every interrupt whether the interrupt should be serviced
> based on some SW flag because HW might be disabled? That looks unusual,
> like a hack.
>=20
> No, the interrupt should be registered when the driver and some other
> pieces of HW are ready to service it.

OK.
please make sure, irq is probed before calling
i2c_add_numbered_adapter(). This will trigger deferred probing of
slave devices. Since the irq handler will be added later, tx completion
of some requests will be lost or fail.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--exe7tgb6se3ukbnm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7jNpcACgkQ4omh9DUa
UbPcng//UVsGN28mv1+t7JOIEucwlTOIZAiNvZ74YvumoRi+5bOa84YTnZKQE1Bp
vpdeG7H+ciZj6WGLLU/TPNUZCr5ii06UFpWHvRsA/fCDnMtu5nFUrj6CKyrVZpXP
kYv1ZqBn7ExANbhDQr8XMz5dXjF4t04/1jm1+Yv7NwlCGCyyweH2ivByfBskvavc
GXdmwhqt4nI8JA8q4oINjOrDq0HDgK7gixplmsH4Ta3fHXnPnWdCujqGz5IBPsrf
23X+hm3QWrVlPIKCHZ8j+aolgONO2zoDl1V6eKpNwKWbPRgqmP+X2QEeJniuewXa
6ge05cdpzhPYAm06o/G/b5gWe5qKpoJAqhYh/s7/1QA5bDw/bj3eKBMNWzkwoYbr
MoNZUw+J5vP9kr1cBUbOegYOYeDWNCWzEgx8HHVYxmPWj+e2rZnY3d8UNJfu1dyG
3tsT0sWwRY2mT1Di/PWg7H/i1LgXLJFm3n2D28ITx4elwFlVhe2+eBwFLwvo5MPA
wK8xpmBTZeV3vW+B6PFtJzG20h4yYXCPhZiXhdvvi0DFAcYPuyQbYnNzI/UJIuB4
KIP2ZAsb8Pl7NZkb1x3fkgnzDv0KHWyuIjks/cQvIN5+QAF26N4j0v5vMG5XTKf9
efZvqZJ2cLHqLs48H3atMXx7xH4tKOsFGyVQsonAJ/O/QRRywrY=
=5oXh
-----END PGP SIGNATURE-----

--exe7tgb6se3ukbnm--
