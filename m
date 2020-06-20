Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A060C2023FB
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 15:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgFTNoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 09:44:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51454 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728051AbgFTNoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 09:44:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jmdni-0004lz-02; Sat, 20 Jun 2020 14:44:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jmdnh-000RWX-Je; Sat, 20 Jun 2020 14:44:53 +0100
Message-ID: <18c10148a1621d2f4e67abf7ab50c0cd4866bbf8.camel@decadent.org.uk>
Subject: Re: Linux 3.16.x EOL planning
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Charlemagne Lasse <charlemagnelasse@gmail.com>,
        stable@vger.kernel.org
Date:   Sat, 20 Jun 2020 14:44:41 +0100
In-Reply-To: <CAFGhKbw03b1MB8Q5nuMo+7KqUC=-ZhhdosS3ibB2wwzunSstOw@mail.gmail.com>
References: <CAFGhKbw03b1MB8Q5nuMo+7KqUC=-ZhhdosS3ibB2wwzunSstOw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-NNGUrIPUAmTqPw2J5J2v"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-NNGUrIPUAmTqPw2J5J2v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-06-20 at 08:18 +0200, Charlemagne Lasse wrote:
> Hi,
>=20
> https://www.kernel.org/category/releases.html marked the EOL of 3.16.x
> as 2020-06 and the main page has an 3.16.x entry (3.16.85 from
> 2020-06-11) marked as non-EOL.
>=20
> Will there be a special EOL release (3.16.86?) or will 3.16.85 just be
> marked as the last release at some point?

Quoting the announcement of 3.16.85:

"This is probably the last release in the 3.16 stable series, unless
some critical fix comes up later this month."

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.


--=-NNGUrIPUAmTqPw2J5J2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7uEskACgkQ57/I7JWG
EQnzGw/+OaT9gdFE4y05e+RhU3IDD9JUOANA9nEOKQmr4tj9zMwowZqBuQjXq/fS
U+kXSQq58J8QUEBzgxbKZHrh1fDB9x+YpnPQoEtP4LbCsTtcSAi/JNdCLcXVy6Q7
1dKHtiE5bZd6HZFpn+cFuIE3vAgX5y96mnEoj9oeULoskTFx9xskUwFvsyxfWwaD
QlMWrjAr2CXz+cmm4ULNwGKV8dy8d4gzczIJHeAClLBW6Iy4i2DR678syar7q6r9
1wu6R0QcM5vH+ImUW7/KRFU/CIa/1U+Ojaq1Seqz8p+v6iLiFvlsRnKab/QiFF8B
vBhI+pe23tRPPvx5fQe7mdIJIT4hQQQcVh8aU9zqUd6QPtlWLAMls9I3Wm9kENbE
dw4wIQf+JPO5DOF51T/TA3Jppa58V+rTXiZQoK9zDGZ0NClxZuRk1JtedYpsrCRi
XPRXRS+Ce9L1jbbNAUyGq6TuV0j9U27Dqbm8OfmD2axUkHKfEw75mHqr0WuUI05N
dbo0s/9pGEZBeCI5uaDYXIkkr91GeuWVIjWmWiaQ4/R2yYRirG4NbjYmzV8gZd6P
mGv9GMNSzRYrhTN7LMmguP6qE3SZQqm1vGKtZZ2m9lUf0O0W9RJtmkcc6UXjW7F7
CVuu0/2nblUMQR3dMngksAKUXt2CHMu8he2vMvH3Jp8SIZGFQD8=
=OFdR
-----END PGP SIGNATURE-----

--=-NNGUrIPUAmTqPw2J5J2v--
