Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5E24A726
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHSTr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 15:47:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59362 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgHSTr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:47:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E4FB51C0BD2; Wed, 19 Aug 2020 21:47:23 +0200 (CEST)
Date:   Wed, 19 Aug 2020 21:47:23 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/gem: Replace reloc chain with terminator on
 error unwind
Message-ID: <20200819194723.GA7451@amd.ucw.cz>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk>
 <20200819172331.GA4796@amd>
 <159785861047.667.10730572472834322633@build.alporthouse.com>
 <20200819193326.p62h2dj7jpzfkeyy@duo.ucw.cz>
 <159786604254.667.11923001796829417234@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <159786604254.667.11923001796829417234@build.alporthouse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Yep, my machines are low on memory.
> >=20
> > But ... test did not work that well. I have dead X and blinking
> > screen. Machine still works reasonably well over ssh, so I guess
> > that's an improvement.
>=20
> > [ 7744.718473] BUG: unable to handle page fault for address: f8c00000
> > [ 7744.718484] #PF: supervisor write access in kernel mode
> > [ 7744.718487] #PF: error_code(0x0002) - not-present page
> > [ 7744.718491] *pdpt =3D 0000000031b0b001 *pde =3D 0000000000000000=20
> > [ 7744.718500] Oops: 0002 [#1] PREEMPT SMP PTI
> > [ 7744.718506] CPU: 0 PID: 3004 Comm: Xorg Not tainted 5.9.0-rc1-next-2=
0200819+ #134
> > [ 7744.718509] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.=
19 ) 03/31/2011
> > [ 7744.718518] EIP: eb_relocate_vma+0xdbf/0xf20
>=20
> To save me guessing, paste the above location into
> 	./scripts/decode_stacktrace.sh ./vmlinux . ./drivers/gpu/drm/i915
>=20
> The f8c00000 is something running off the end of a kmap, but I didn't
> spot a path were we would ignore an error and keep on writing.
> Nevertheless it must exist.

Like this?

$ ./scripts/decode_stacktrace.sh ./vmlinux . ./drivers/gpu/drm/i915
f8c00000
f8c00000
eb_relocate_vma+0xdbf/0xf20
eb_relocate_vma (i915_gem_execbuffer.c:?)=20

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXz2BywAKCRAw5/Bqldv6
8rQ3AJ48gceUdw0++l1nMSQ34uMDJpR/wQCgk2/pSdCWIvl6fFmCQGle7PUR/eI=
=WWF5
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
