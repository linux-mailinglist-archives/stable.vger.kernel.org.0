Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDB62B71A7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 23:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgKQWhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 17:37:15 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:50178 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbgKQWhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 17:37:14 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2020 17:37:14 EST
Date:   Tue, 17 Nov 2020 23:29:16 +0100
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Hussam Al-Tayeb <ht990332@gmx.com>
Cc:     stable@vger.kernel.org
Subject: Re: Suggestion: Lengthen the review period for stable releases from
 48 hours to 7 days.
Message-ID: <1605651898@msgid.manchmal.in-ulm.de>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
 <20201117080141.GA6275@amd>
 <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>> On Sat 2020-11-14 17:40:36, Hussam Al-Tayeb wrote:

>>> Hello. I would like to suggest lengthening the review period for stable
>>> releases from 48 hours to 7 days.
>>> The rationale is that 48 hours is not enough for people to test those
>>> stable releases and make sure there are no regressions for
>>> particular workflows.

Disclaimer: I am mostly a user of stable

It's hard to make a good decision here. I share your position the 48-ish
hours are a fairly short amound of time, and increasing it would grant
more time for tests. As for me, I might resume testing -rc on a regular
base as I used to in the past - which is a time-consuming procedure, and
since I do that as a hobby, sometimes more important things are in the
way. But I have to concede the number of issues that occured only here
was never high, and I don't expect it would grow significantly.

On the other hand the pace of the stable patches became fairly high=C2=B9, =
so
during a week of -rc review a *lot* of them will queue up and I predict
we'll see requests for fast-laning some of them. Also, a release would
immediately be followed by the next -rc review period, a procedure that
gives me a bad feeling.

So for me, I'd appreciate an extension of the review period, even if
it's just four days. But I understand if people prefer to keep the
procedures simple, and get fixes out of the door as soon as possible.

My 2=C2=A2

    Christoph

=C2=B9 If somebody made statistics on the development of the number of
  patches for stable kernels (in count/second), I'd be curious to see
  the numbers.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAl+0TrgACgkQxCxY61kU
kv3WVRAAgcgNcSd/s5EG/rpPZ4XhwzksCx61QegKbyoFGpnFMUx/HlmEv34wRbaG
djTNr6EODFg+mznSHHuP0vDu4b9DakPyAavYO99GxVFkIW2tnHhii8NByPLf5/GC
2QTemHPmcqp4AHlljHFBX8rFOQMTKcSWwdxVD6SoSw1JtoMxMUalkD0bNQbsFTmj
5K5+aXtPGjVYQ7zFW0dEdQ1O0DH3F6o2qpQ0++z4TK5I+iKoPS5gg6H3GvQmQa9r
CfF8e90FBCYyunhMUn0yDERvcGT/bMGBbyYQ0Ea6mopgLsIFDYGK3BsuydmuyqGz
EMHLmgIvXt2AIoaiF7l+yag0wdM1QRwRXMck7tcIKtpJIxzbvCo8U/IOGQgO8n0W
bi4L/wceTVR/Tej/c5XMOwAPyhgPPePUr1Wb3UqT47hNupwFpoiGKWCy8sxQ5Ezm
jc4WeR9Cr177TLTcuTvZqz1tc8U5fIZnzS6BUMobH1Rc7l22QXpjGoy+kqbDB9j9
Z0YJGy4Fxyj3N92HXDb2wQo1rHQQ+TukGSvnojK69t/vVwMr+CHgN0q6OYMHKtB7
9T5TTmZG/WSwiBK5HdQb0uM0KDOojM54y6QMqUvQmx+k46uoZdICgA5dd+5Aqs3I
lLn3d8gHBW8djHGAkbtaCGeO1FUhaMwQPmXfYaOeLXUiqeHopio=
=jC9Y
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
