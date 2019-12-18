Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9D0124CF6
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLRQSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:18:09 -0500
Received: from foss.arm.com ([217.140.110.172]:51630 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbfLRQSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 11:18:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93BA330E;
        Wed, 18 Dec 2019 08:18:08 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 017063F719;
        Wed, 18 Dec 2019 08:18:07 -0800 (PST)
Date:   Wed, 18 Dec 2019 16:18:06 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218161806.GF3219@sirena.org.uk>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
 <20191218122157.GA17086@kroah.com>
 <20191218131114.GD3219@sirena.org.uk>
 <20191218142219.GB234539@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Content-Disposition: inline
In-Reply-To: <20191218142219.GB234539@kroah.com>
X-Cookie: Power is poison.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2019 at 03:22:19PM +0100, Greg KH wrote:
> On Wed, Dec 18, 2019 at 01:11:14PM +0000, Mark Brown wrote:
> > On Wed, Dec 18, 2019 at 01:21:57PM +0100, Greg KH wrote:

> > > It is, but it's the latest stable kernel (well close to), and your pa=
tch
> > > was tagged by you to be backported to here, so if there's a problem w=
ith
> > > a stable branch, I want to know about it as I don't want to see
> > > regressions happen in it.

> > I don't track what's in older stable kernels, it wanted to go back at
> > least one kernel revision but the issue has been around since forever.

> Ok, you can always mark patches that way if you want to :)

That's what a tag to stable with no particular revision attached to it
is isn't it?

> > If you don't want to be messing with timing luck then you probably want
> > to be having a look at what Sasha's bot is doing, it's picking up a lot
> > of things that are *well* into this sort of territory (and the bad
> > interactions with out of tree code territory).  I personally would not
> > be using stable these days if I wasn't prepared to be digging into
> > something like this.

> I watch what his bot is doing, and we have tons of testing happening as
> well, which is reflected by the fact that THIS WAS CAUGHT HERE.  This is

You don't have anywhere near the level of testing that you'd need to
cover what the bot is trying to pull in, the subsystem and driver
coverage is extremely thin relative to the enthusiasm with which things
are being picked up.  All the pushback I see in review is on me for=20
being conservative about what gets pulled into stable and worrying about
interactions with out of tree code.

> a sign that things are working, it's just that some SoC trees are slower
> than mainline by a few months, and that's fine.  It's worlds better than
> the SoC trees that are no where close to mainline, and as such, totally
> insecure :)

What you appear to have caught here is an interaction with some
unreviewed vendor code - how much of that is going on in the vendor
trees you're not testing?  If we want to encourage people to pull in
stable we should be paying attention to that sort of stuff.

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl36UT0ACgkQJNaLcl1U
h9BlHgf+Lej6XHTubrNWZ8oveb0WTVY+QashlrnUsPg7WSkmwUBUE3+k/KdTnWLj
z94tCTR+vfpGWSTtyldy0GVbHjac5ejNawHIlqFpGyaeFSmD76poL+GBfVcrehac
1xK65l1tui0SXFCSxKKtSFzdL00o7stgjGjMWAJWjrmuSr9RjXSoIIVo1BfClxD2
D2Y5msLo9b0GDWPQtYsMNjwtanEPObFvicstMokRdZEfvHug1/KXR0Fvk2EqARlh
BmpNgf3KPSkuBXGxaXnOcQCqEwDOeYNGp5lamG9XaEdZd/vuYrFInTDcO25LfX/L
vhwwbp4uQHlTPoHhLhBmTfxaEjXqvQ==
=kXeF
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
