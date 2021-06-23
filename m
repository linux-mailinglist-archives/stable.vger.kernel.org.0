Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A303B21C4
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWU1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:27:49 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36406 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWU1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:27:48 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EABFD1C0B76; Wed, 23 Jun 2021 22:25:29 +0200 (CEST)
Date:   Wed, 23 Jun 2021 22:25:29 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
Message-ID: <20210623202529.GG8540@amd>
References: <20210520092131.308959589@linuxfoundation.org>
 <20210520092145.369052506@linuxfoundation.org>
 <20210520203625.GA6187@amd>
 <YKc4wSgWcnGh3Bbq@kroah.com>
 <YKc47AGJRaBn3qIQ@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <YKc47AGJRaBn3qIQ@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2021-05-21 06:37:00, Greg Kroah-Hartman wrote:
> On Fri, May 21, 2021 at 06:36:18AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, May 20, 2021 at 10:36:26PM +0200, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > >=20
> > > > commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb upstream.
> > > >=20
> > > > Some distributions are about to switch to Python 3 support only.
> > > > This means that /usr/bin/python, which is Python 2, is not available
> > > > anymore. Hence, switch scripts to use Python 3 explicitly.
> > >=20
> > > I'd say this is unsuitable for -stable.
> > >=20
> > > Old distributions may not have python3 installed, and we should not
> > > change this dependency in the middle of the series.
> >=20
> > What distro that was released in 2017 (the year 4.14.0 was released) did
> > not have python3 on it?
>=20
> oops, I meant 2018, when 4.19.0 was out, wrong tree...

In anything yocto-based, for example, you explicitely select which
packages you want. And changing dependencies in middle of stable
release is surprising and against our documentation.

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDTmLkACgkQMOfwapXb+vJVbACeMwxIVQcVq+g77yLg9aJHEuww
zScAn3YOTP94NukwBlTBhC5eVZfLvu0F
=epBE
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
