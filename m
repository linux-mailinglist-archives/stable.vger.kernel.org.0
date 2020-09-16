Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFDF26C021
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIPJH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:07:28 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43446 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgIPJH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 05:07:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1FCAE1C0B7D; Wed, 16 Sep 2020 11:07:24 +0200 (CEST)
Date:   Wed, 16 Sep 2020 11:07:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, jikos@suse.cz, vojtech@suse.cz,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yuan Ming <yuanmingbuaa@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
Message-ID: <20200916090723.GA4151@duo.ucw.cz>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz>
 <20200916082510.GB509119@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20200916082510.GB509119@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > >=20
> > > commit 50145474f6ef4a9c19205b173da6264a644c7489 upstream.
> > >=20
> > > This (and the VGA soft scrollback) turns out to have various nasty sm=
all
> > > special cases that nobody really is willing to fight.  The soft
> > > scrollback code was really useful a few decades ago when you typically
> > > used the console interactively as the main way to interact with the
> > > machine, but that just isn't the case any more.
> > >=20
> > > So it's not worth dragging along.
> >=20
> > It is still useful.
> >=20
> > In particular, kernel is now very verbose, so important messages
> > during bootup scroll away. It is way bigger deal when you can no
> > longer get to them using shift-pageup.
> >=20
> > fsck is rather verbose, too, and there's no easy way to run that under
> > X terminal... and yes, that makes scrollback very useful, too.
> >=20
> > So, I believe we'll need to fix this. I guess I could do it. I also
> > guess I'll not have to, because SuSE or RedHat will want to fix it.
> >=20
> > Anyway, this really should not be merged into stable.
>=20
> It's merged into the stable trees that _I_ have to maintain.  If you
> want to revert it for trees you maintain and wish to keep secure, that's
> up to you.  But it's something that I _STRONGLY_ do not advise doing.

I believe it will need to be reverted in Linus' tree, too. In fact,
the patch seems to be a way for Linus to find a maintainer for the
code, and I already stated I can do it. Patch is so new it was not
even in -rc released by Linus.

> See the email recently on oss-devel for one such reason why this was
> removed...

Would you have a link for that?
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2HVywAKCRAw5/Bqldv6
8n8IAJ9Ckk/Dt5yz2ZN03hdemFeg5cZhXACeIV86DHYDXC4IqpvDCyi6XVH55NI=
=T25L
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
