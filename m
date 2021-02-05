Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB6311046
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhBEREr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:04:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34756 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbhBERCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:02:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 425531C0B77; Fri,  5 Feb 2021 19:44:13 +0100 (CET)
Date:   Fri, 5 Feb 2021 19:44:12 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <20210205184412.GA20410@duo.ucw.cz>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <20210205090659.GA22517@amd>
 <YB0Q3UUzTUmgvH7V@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <YB0Q3UUzTUmgvH7V@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Ugh, I thought this was an internal representation, not an external o=
ne
> > > :(
> > >=20
> > > > It might work somewhere, but there are a lot of (X * 65536 + Y * 25=
6 + Z)
> > > > assumptions all around the world. So this doesn't look like a good =
idea.
> > >=20
> > > Ok, so what happens if we "wrap"?  What will break with that?  At fir=
st
> > > glance, I can't see anything as we keep the padding the same, and our
> > > build scripts seem to pick the number up from the Makefile and treat =
it
> > > like a string.
> > >=20
> > > It's only the crazy out-of-tree kernel stuff that wants to do minor
> > > version checks that might go boom.  And frankly, I'm not all that
> > > concerned if they have problems :)
> > >=20
> > > So, let's leave it alone and just see what happens!
> >=20
> > Yeah, stable is a great place to do the experiments. Not that this is
> > the first time :-(.
>=20
> How else can we "test this out"?
>=20
> Should I do an "empty" release of 4.4.256 and see if anyone complains?

It seems that would be bad idea, as it would cause problems when stuff
is compiled on 4.4.256, not simply by running it.

Sasha's patch seems like one option that could work.

Even safer option is to switch to 4.4.255-st1, 4.4.255-st2 ... scheme.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYB2R/AAKCRAw5/Bqldv6
8je0AKC7mwfmi+1yhI0pGTqkqokgvNOATgCeJTrYsMHSUshxMB9ki1ID4ldzuzU=
=nI+5
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
