Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615DD1F3979
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgFILU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 07:20:28 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47166 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgFILU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 07:20:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DF5761C0C0C; Tue,  9 Jun 2020 13:20:25 +0200 (CEST)
Date:   Tue, 9 Jun 2020 13:20:25 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Daniel Axtens <dja@axtens.net>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 4.14 72/72] string.h: fix incompatibility between
 FORTIFY_SOURCE and KASAN
Message-ID: <20200609112025.GA2523@amd>
References: <20200608232500.3369581-1-sashal@kernel.org>
 <20200608232500.3369581-72-sashal@kernel.org>
 <87ftb5t933.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <87ftb5t933.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-06-09 09:46:08, Daniel Axtens wrote:
> Hi Sasha,
>=20
> There's nothing inherently wrong with these patches being backported,
> but they fix a bug that doesn't cause a crash and only affects debug
> kernels compiled with KASAN and FORTIFY_SOURCE. Personally I wouldn't
> change a core header file in a stable kernel for that. Perhaps I'm too
> risk-averse.

You are in agreement with existing documentation -- stable is only for
serious bugs.

								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7fcHkACgkQMOfwapXb+vLcrQCgwqN9j6+yHdjtyMjKkGUCSYtm
nkAAoMQ5LJ/YoXoLmXAi7ApbNSlbIQEC
=olTB
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
