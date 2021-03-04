Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6D32CD41
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCDHBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbhCDHAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 02:00:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54139C061574
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 23:00:06 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lHhxs-0002sD-Lt; Thu, 04 Mar 2021 08:00:04 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lHhxn-00069o-2p; Thu, 04 Mar 2021 07:59:59 +0100
Date:   Thu, 4 Mar 2021 07:59:58 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     jingle <jingle.wu@emc.com.tw>, kernel@pengutronix.de,
        linux-input@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="33bpheodspxdcs3h"
Content-Disposition: inline
In-Reply-To: <YEA9oajb7qj6LGPD@google.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--33bpheodspxdcs3h
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
> On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-K=F6nig wrote:
> > On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-K=F6nig wrote:
> > > On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> > > > Please updates this patchs.
> > > >=20
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/comm=
it/?h=3Dnext&id=3D056115daede8d01f71732bc7d778fb85acee8eb6
> > > >=20
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/comm=
it/?h=3Dnext&id=3De4c9062717feda88900b566463228d1c4910af6d
> > >=20
> > > The first was one of the two patches I already tried, but the latter
> > > indeed fixes my problem \o/.
> > >=20
> > > @Dmitry: If you don't consider your tree stable, feel free to add a
> > >=20
> > > 	Tested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > >=20
> > > to e4c9062717feda88900b566463228d1c4910af6d.
> >=20
> > Do you consider this patch for stable? I'd like to see it in Debian's
> > 5.10 kernel and I guess I'm not the only one who would benefit from such
> > a backport.
>=20
> When I was applying the patches I did not realize that there was already
> hardware in the wild that needed it. The patches are now in mainline, so
> I can no longer adjust the tags, but I will not object if you propose
> them for stable.

I want to propose to backport commit

e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoints i=
n SMBus mode")

to the active stable kernels. This commit repairs the track point and
the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
I don't get any events apart from an error message for each button press
or move of the track point in the kernel log. (Also the error message is
the same for all buttons and the track point, so I cannot create a new
input event driver in userspace that emulates the right event depending
on the error message :-)

At least to 5.10.x it applies cleanly, I didn't try the older stable
branches.

Best regards and thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--33bpheodspxdcs3h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmBAhWsACgkQwfwUeK3K
7AnfCgf8DepAgt5HV9T00ILyqFKOSNjsnFTcq90lM1GfCYpgcD8Nvi30lS6W8Zyg
Hv7cNfHShEPeo6FOiu0GJwp5ZwTFzXvNSGSUeqCK98ng60OqQJLRXrpQTDNh3KbP
0sh9YB/7FSVRaQ7ne8Sr3i0uzs3NIg2LJnMA0OUQySCorqMr/E6yAxWKWnQPclPt
5SvLm1pQAZbau0R//gxMdt4t8GBjp1wWVOFYO3Y/vjVJmutyeSNu7DGK+n3r4hRq
zKLQz8gy4jbJ8C3BDoWRM6mg6LjzOl2Vvw92y2RsOMug7h43LjeTRXG9G9GmXohw
6EliC0vQKR3jesUfO4JfPfLGpCqfDw==
=OGz2
-----END PGP SIGNATURE-----

--33bpheodspxdcs3h--
