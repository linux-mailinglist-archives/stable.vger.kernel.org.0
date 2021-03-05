Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD47F32F3B2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 20:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhCETSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 14:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhCETSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 14:18:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EE2C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 11:18:15 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lIFxj-0006kT-OZ; Fri, 05 Mar 2021 20:18:11 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lIFxe-0006wF-GI; Fri, 05 Mar 2021 20:18:06 +0100
Date:   Fri, 5 Mar 2021 20:18:06 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Nikolai Kostrigin <nickel@basealt.ru>
Cc:     stable@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>,
        jingle <jingle.wu@emc.com.tw>, kernel@pengutronix.de,
        linux-input@vger.kernel.org
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <20210305191806.twbfrkgdgf4as7c2@pengutronix.de>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
 <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
 <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wcq4hsgw6rzmyfal"
Content-Disposition: inline
In-Reply-To: <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wcq4hsgw6rzmyfal
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 04, 2021 at 11:49:59AM +0300, Nikolai Kostrigin wrote:
> Hi,
>=20
> 04.03.2021 09:59, Uwe Kleine-K=C3=B6nig =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hello,
> >=20
> > On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
> >> On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> >>> On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> >>>> On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> >>>>> Please updates this patchs.
> >>>>>
> >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/comm=
it/?h=3Dnext&id=3D056115daede8d01f71732bc7d778fb85acee8eb6
> >>>>>
> >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/comm=
it/?h=3Dnext&id=3De4c9062717feda88900b566463228d1c4910af6d
> >>>>
> >>>> The first was one of the two patches I already tried, but the latter
> >>>> indeed fixes my problem \o/.
> >>>>
> >>>> @Dmitry: If you don't consider your tree stable, feel free to add a
> >>>>
> >>>> 	Tested-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> >>>>
> >>>> to e4c9062717feda88900b566463228d1c4910af6d.
> >>>
> >>> Do you consider this patch for stable? I'd like to see it in Debian's
> >>> 5.10 kernel and I guess I'm not the only one who would benefit from s=
uch
> >>> a backport.
> >>
> >> When I was applying the patches I did not realize that there was alrea=
dy
> >> hardware in the wild that needed it. The patches are now in mainline, =
so
> >> I can no longer adjust the tags, but I will not object if you propose
> >> them for stable.
> >=20
> > I want to propose to backport commit
> >=20
> > e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoin=
ts in SMBus mode")
> >=20
> > to the active stable kernels. This commit repairs the track point and
> > the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
> > I don't get any events apart from an error message for each button press
> > or move of the track point in the kernel log. (Also the error message is
> > the same for all buttons and the track point, so I cannot create a new
> > input event driver in userspace that emulates the right event depending
> > on the error message :-)
> >=20
> > At least to 5.10.x it applies cleanly, I didn't try the older stable
> > branches.
> >=20
> > Best regards and thanks
> > Uwe
> >=20
>=20
> I'd like to propose to backport [1] also as it was checked along with
> previously proposed patch and fixes Elan Trackpoint operation on
> Thinkpad L13.
>=20
> Both patches apply cleanly to 5.10.17 in my case.
>=20
> I also tried to apply to 5.4.x, but failed.
>=20
> [1] 056115daede8 Input: elan_i2c - add new trackpoint report type 0x5F
>=20
> Additional info is available here:
>=20
> https://lore.kernel.org/linux-input/fe31f6f8-6e38-2ed6-8548-6fa271bf36e9@=
basealt.ru/T/#m514047f2c5e7e2ec4ed9658782f14221ed7598fc

FTR: I tested 5.10 + e4c9062717fe ("Input: elantech - fix protocol
errors for some trackpoints in SMBus mode") now and in this setup the
touchpad is still broken. I assume that in combination with 056115daede8
it will work. The working setup I tested was 5.10 + c7f0169e3bd2 +
056115daede8 + e4c9062717fe and I assume c7f0169e3bd2 isn't relevant.

Best regards
Uwe


--=20
Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig         =
   |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--wcq4hsgw6rzmyfal
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmBCg+sACgkQwfwUeK3K
7Am4YAf+OP00Ke+rm7oQcCgQ0J21ovdtkd20HbgWE/TQrdkxy1xE3A7YAwhiGkJM
/lyStDb1gLbzXIpTdbMkeSrMRiQr8ASozTowvz7XQobKchB0iNfMw+DQfE/H5WMJ
m73FkeZGBHfu9wWUDXIe5DRuiD/BMRe2Ml8aKg0v6C9wXeFHsFAYdXaKATxbuUOJ
vtau3svrYgwEc621bO5sr5yC4b+45DG1bUB/lPhpwS93zdVK7gI3pnVZjGSuHzx6
KjnOP/b6w146cTtgHaXIcTs0U3SiowYVm58LLKxPVHx0AhdCzAqFt0yolMfItrCN
k/HDYglZAty6MOA5slvo0KCcZ1UAfg==
=+pzN
-----END PGP SIGNATURE-----

--wcq4hsgw6rzmyfal--
