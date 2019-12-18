Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0963D124EB1
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 18:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfLRRDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 12:03:07 -0500
Received: from foss.arm.com ([217.140.110.172]:54154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbfLRRDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 12:03:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 895B61FB;
        Wed, 18 Dec 2019 09:03:06 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 056A43F67D;
        Wed, 18 Dec 2019 09:03:05 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:03:04 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218170304.GI3219@sirena.org.uk>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
 <20191218122157.GA17086@kroah.com>
 <20191218131114.GD3219@sirena.org.uk>
 <20191218142219.GB234539@kroah.com>
 <20191218161806.GF3219@sirena.org.uk>
 <20191218162424.GA482612@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Content-Disposition: inline
In-Reply-To: <20191218162424.GA482612@kroah.com>
X-Cookie: Power is poison.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2019 at 05:24:24PM +0100, Greg KH wrote:
> On Wed, Dec 18, 2019 at 04:18:06PM +0000, Mark Brown wrote:

> > What you appear to have caught here is an interaction with some
> > unreviewed vendor code - how much of that is going on in the vendor
> > trees you're not testing?  If we want to encourage people to pull in
> > stable we should be paying attention to that sort of stuff.

> I get weekly merge reports from all of the major SoC vendors when they
> pull these releases into their tree and run through their full suite of
> tests.  So I am paying attention to this type of thing.

Are you sure you're not just definining major SoC vendors as being
people who send you reports here?  :P  In any case, that's only going to
cover a limited subset of potential drivers and subsystems, devices that
don't appear on reference designs aren't going to get any coverage at
all that way for example.

> What I need to figure out here is what is going wrong and why the SoC's
> testing did not catch this.  That's going to take a bit longer...

There's a reasonable chance this is something board specific.

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl36W8cACgkQJNaLcl1U
h9CfnQf8CWSZuEP46wNWKFkPq8tFFHkVLzNk7rZmtBfqo2XGes7Op0rkizHA28ET
CR7+OhJEJ1xXP1xdzfdoN8E/tbYUu8Gv800GNhG+m/TsnnZBsmGWTJmGEElY8CPd
VpFIRv3Al+rcbWs6Yn7Ig3b6uzjmhbGdpvSuQL9mkPkBnMeQYCYjL9sGnpUFvmK6
Jmq1mNifpcb6snu1EY0ffbSCn95wOC+UrBBehr9+CYxBX+UVzQGGEnp8n5s0/ZCk
KF9NmXkxF/XzOQ7VxozpXKzbtsyDS0l3bCVi3ia3gcVYh7Nb82pyonbqsdiU4n2j
WofRpeJsb7azQLsu8Kliwrj+uz+cJA==
=Ih6b
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
