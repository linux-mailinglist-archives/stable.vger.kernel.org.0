Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3447E3E90FA
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhHKM2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 08:28:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37918 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhHKM11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 08:27:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 874411C0B77; Wed, 11 Aug 2021 14:27:02 +0200 (CEST)
Date:   Wed, 11 Aug 2021 14:27:02 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in
 eb_parse()
Message-ID: <20210811122702.GA8045@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <YROARN2fMPzhFMNg@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2021-08-11 09:46:12, Greg Kroah-Hartman wrote:
> On Wed, Aug 11, 2021 at 09:28:43AM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Jonathan Gray <jsg@jsg.id.au>
> > >=20
> > > The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
> > > 6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
> > > have leading to 'batch' being used uninitialised.  The 5.13 backport =
and
> > > the mainline commit did not remove the portion this patch adds back.
> >=20
> > This patch has no upstream equivalent, right?
> >=20
> > Which is okay -- it explains it in plain english, but it shows that
> > scripts should not simply search for anything that looks like SHA and
> > treat it as upsteam commit it.
>=20
> Sounds like you have a broken script if you do it that way.

That is what you told me to do!

https://lore.kernel.org/stable/YQEvUay+1Rzp04SO@kroah.com/

I would happily adapt my script, but there's no
good/documented/working way to determine upstream commit given -stable
commit.

If we could agree on

Commit: (SHA)

in the beggining of body, that would be great.

Upstream: (SHA)

in sign-off area would be even better.

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRPCFgAKCRAw5/Bqldv6
8mQcAJ9AKlFoH8jnzzSxqkYLGTi8OCpOXQCdFy3CePlHbLfq+roeM+HiygkP9mo=
=jAGr
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
