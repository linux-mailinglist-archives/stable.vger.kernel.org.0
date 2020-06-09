Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9701F3D65
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgFINzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 09:55:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37954 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgFINzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 09:55:19 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2B30D1C0C0C; Tue,  9 Jun 2020 15:55:18 +0200 (CEST)
Date:   Tue, 9 Jun 2020 15:55:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Axtens <dja@axtens.net>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 4.14 72/72] string.h: fix incompatibility between
 FORTIFY_SOURCE and KASAN
Message-ID: <20200609135517.GA4806@amd>
References: <20200608232500.3369581-1-sashal@kernel.org>
 <20200608232500.3369581-72-sashal@kernel.org>
 <87ftb5t933.fsf@dja-thinkpad.axtens.net>
 <20200609112025.GA2523@amd>
 <20200609115407.GA819153@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20200609115407.GA819153@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-06-09 13:54:07, Greg KH wrote:
> On Tue, Jun 09, 2020 at 01:20:25PM +0200, Pavel Machek wrote:
> > On Tue 2020-06-09 09:46:08, Daniel Axtens wrote:
> > > Hi Sasha,
> > >=20
> > > There's nothing inherently wrong with these patches being backported,
> > > but they fix a bug that doesn't cause a crash and only affects debug
> > > kernels compiled with KASAN and FORTIFY_SOURCE. Personally I wouldn't
> > > change a core header file in a stable kernel for that. Perhaps I'm too
> > > risk-averse.
> >=20
> > You are in agreement with existing documentation -- stable is only for
> > serious bugs.
>=20
> No, lots of people run KASAN on those kernels when they are testing
> their devices, this patch is fine.

Documentation currently says:

 - It must fix a problem that causes a build error (but not for things
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short,
    something critical.

=2E..but we also get various warning fixes (sometimes for external
tools), changes to make printk()s less verbose, changes to make
debugging easier, etc...

Could the documentation be updated to match current use?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7flMUACgkQMOfwapXb+vK3pACglGW9799N3OTLxgOM/OIQZpKv
P6gAoJr5V9ho8ygRxTBFRQuFKDpQConC
=MJK1
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
