Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64E12CD12
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 06:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfL3Ft3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 00:49:29 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:36948 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfL3Ft3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 00:49:29 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47mRMV2kFdzQlB0;
        Mon, 30 Dec 2019 06:49:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id Osl2T2x5pLfL; Mon, 30 Dec 2019 06:49:22 +0100 (CET)
Date:   Mon, 30 Dec 2019 16:49:13 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vstjrid4bmeb3iov"
Content-Disposition: inline
In-Reply-To: <20191230054413.GX4203@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vstjrid4bmeb3iov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Dec 30, 2019 at 04:20:35PM +1100, Aleksa Sarai wrote:
>=20
> > A reasonably detailed explanation of the issues is provided in the patch
> > itself, but the full traces produced by both the oopses and deadlocks is
> > included below (it makes little sense to include them in the commit sin=
ce we
> > are disabling this feature, not directly fixing the bugs themselves).
> >=20
> > I've posted this as an RFC on whether this feature should be allowed at
> > all (and if anyone knows of legitimate uses for it), or if we should
> > work on fixing these other kernel bugs that it exposes.
>=20
> Umm...  Are all of those traces
> 	a) reproducible on mainline and

This was on viro/for-next, I'll retry it on v5.5-rc4.

> 	b) reproducible as the first oopsen?

The NULL and garbage pointer derefs are reproducible as the first oops.
Looking at my logs, it looks like the deadlocks were always triggered
after the oops, but that might just have been a mistake on my part while
testing things.

> As it is, quite a few might be secondary results of earlier memory
> corruption...

Yeah, I thought that might be the case but decided to include them
anyway (the /proc/self/stack RCU stall is definitely the result of other
corruption and stalls).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--vstjrid4bmeb3iov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgmP1gAKCRCdlLljIbnQ
En8yAP4heusqckPwVD1E6oISJdz6Un9hh96337R1CzO+HkhhwgEAwXuurrT9WDJY
vzW4vyGjAMtEZpNg3y1cdnODYnBG6Qs=
=FWL9
-----END PGP SIGNATURE-----

--vstjrid4bmeb3iov--
