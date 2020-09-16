Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD726BE99
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIPH6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:58:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35846 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPH6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:58:02 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8F07C1C0B76; Wed, 16 Sep 2020 09:57:59 +0200 (CEST)
Date:   Wed, 16 Sep 2020 09:57:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jikos@suse.cz,
        vojtech@suse.cz
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yuan Ming <yuanmingbuaa@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
Message-ID: <20200916075759.GC32537@duo.ucw.cz>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140636.861676717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <20200915140636.861676717@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> commit 50145474f6ef4a9c19205b173da6264a644c7489 upstream.
>=20
> This (and the VGA soft scrollback) turns out to have various nasty small
> special cases that nobody really is willing to fight.  The soft
> scrollback code was really useful a few decades ago when you typically
> used the console interactively as the main way to interact with the
> machine, but that just isn't the case any more.
>=20
> So it's not worth dragging along.

It is still useful.

In particular, kernel is now very verbose, so important messages
during bootup scroll away. It is way bigger deal when you can no
longer get to them using shift-pageup.

fsck is rather verbose, too, and there's no easy way to run that under
X terminal... and yes, that makes scrollback very useful, too.

So, I believe we'll need to fix this. I guess I could do it. I also
guess I'll not have to, because SuSE or RedHat will want to fix it.

Anyway, this really should not be merged into stable.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2HFhwAKCRAw5/Bqldv6
8l/qAJ0WX5PBLnCVVvvT67LyY7r0YmROQACfU5ZZFE4StnZcxrW1Hmyx01Y+XG8=
=uUjO
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
