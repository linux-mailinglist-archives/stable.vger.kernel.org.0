Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A064F59E5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 22:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKHVb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 16:31:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38616 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfKHVb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 16:31:27 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0A0461C0BF3; Fri,  8 Nov 2019 22:31:25 +0100 (CET)
Date:   Fri, 8 Nov 2019 22:31:24 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191108213124.GH23750@amd>
References: <20191027203251.029297948@linuxfoundation.org>
 <20191029162419.cumhku6smn2x2bq4@ucw.cz>
 <20191029180233.GA587491@kroah.com>
 <20191106185932.GA2183@amd>
 <20191106201818.GA105063@kroah.com>
 <c065df06c9e5d351b4a33c473fd397f27680489f.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Content-Disposition: inline
In-Reply-To: <c065df06c9e5d351b4a33c473fd397f27680489f.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-11-07 16:43:17, Ben Hutchings wrote:
> On Wed, 2019-11-06 at 21:18 +0100, Greg Kroah-Hartman wrote:
> > On Wed, Nov 06, 2019 at 07:59:32PM +0100, Pavel Machek wrote:
> [...]
> > > I'm confused. You said "by Tue ... 08:27:02 PM UTC". That 8 PM is 20h,
> > > but did the release on 10h GMT+1, or 9h UTC -- 9 AM.... so like 11
> > > hours early, if I got the timezones right.
> > >=20
> > > Does PM mean something else in the above context?
> >=20
> > Ugh, no, you are right, I was ignoring the PM thing, I thought the -u
> > option to date would give me a 24 hour date string, and so I thought
> > that was 8:27 in the morning.
> >=20
> > Let me mess around with 'date' to see if I can come up with a better
> > string to use here.  I guess:
> > 	date --rfc-3339=3Dseconds -u
> > would probably be best?
>=20
> The --rfc-822 option should give you something close to the current
> format, but with 24-hour numbering.

pavel@amd:~$ date --rfc-822
Fri, 08 Nov 2019 22:30:14 +0100

I like that more, as that is closer to format normally used in the emails:

On Thu 2019-11-07 16:43:17, Ben Hutchings wrote:
> On Wed, 2019-11-06 at 21:18 +0100, Greg Kroah-Hartman wrote:
> > On Wed, Nov 06, 2019 at 07:59:32PM +0100, Pavel Machek wrote:

Thanks and best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXcXerAAKCRAw5/Bqldv6
8v6vAJwMzXDLKrzGZLI2+kCHZ3aBasoniACgsJiFsDwLHSQy4QaGQFiIfp3pFj4=
=TvD1
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
