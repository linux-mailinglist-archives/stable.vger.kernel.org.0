Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6108044DBD0
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhKKS4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:56:00 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33612 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbhKKS4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 13:56:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A902F1C0BAC; Thu, 11 Nov 2021 19:53:09 +0100 (CET)
Date:   Thu, 11 Nov 2021 19:53:08 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Message-ID: <20211111185308.GA7933@duo.ucw.cz>
References: <20211110182001.994215976@linuxfoundation.org>
 <20211110182002.041203616@linuxfoundation.org>
 <20211111164754.GA29545@duo.ucw.cz>
 <YY1OHxpimjKYgxGR@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <YY1OHxpimjKYgxGR@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This patch introduces helpers of 'mp_bvec_iter_*' for multi-page bvec
> > > support.
> > >=20
> > > The introduced helpers treate one bvec as real multi-page segment,
> > > which may include more than one pages.
> > >=20
> > > The existed helpers of bvec_iter_* are interfaces for supporting curr=
ent
> > > bvec iterator which is thought as single-page by drivers, fs, dm and
> > > etc. These introduced helpers will build single-page bvec in flight, =
so
> > > this way won't break current bio/bvec users, which needn't any
> > > change.
> >=20
> > I don't understand why we have this in 4.19-stable. I don't see
> > followup patches needing it, and it does not claim to fix a bug.
>=20
>=20
> There is some more context on this at:
> https://lore.kernel.org/linux-block/YXweJ00CVsDLCI7b@google.com/T/#u
> and
> https://lore.kernel.org/stable/YYVZBuDaWBKT3vOS@google.com/T/#u

Thank you!
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYY1mlAAKCRAw5/Bqldv6
8vvMAKCMbppninrtAgZkbe2MuItOvGszxQCfVj3ShnFC6ZuRevOSGhJ7A+iu/ek=
=j/nP
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
