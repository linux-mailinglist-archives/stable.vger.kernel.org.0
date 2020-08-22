Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1624EA03
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 23:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHVVZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 17:25:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36176 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgHVVZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 17:25:44 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 391521C0BB0; Sat, 22 Aug 2020 23:25:42 +0200 (CEST)
Date:   Sat, 22 Aug 2020 23:25:41 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-ID: <20200822212541.GB14071@amd>
References: <20200821123746.16904-1-joro@8bytes.org>
 <20200821133548.be58a3b0881b41a32759fa04@linux-foundation.org>
 <159804301810.32652.14249776487575415877@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <159804301810.32652.14249776487575415877@build.alporthouse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> > > The __apply_to_page_range() function is also used to change and/or
> > > allocate page-table pages in the vmalloc area of the address space.
> > > Make sure these changes get synchronized to other page-tables in the
> > > system by calling arch_sync_kernel_mappings() when necessary.
> >=20
> > There's no description here of the user-visible effects of the bug.=20
> > Please always provide this, especially when proposing a -stable
> > backport.  Take pity upon all the downstream kernel maintainers who are
> > staring at this wondering whether they should risk adding it to their
> > kernels.
>=20
> The impact appears limited to x86-32, where apply_to_page_range may miss
> updating the PMD. That leads to explosions in drivers like

Is this alone supposed to fix my problems with graphics on Thinkpad
X60? Let me try...

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9BjVUACgkQMOfwapXb+vLhDwCgsB41bHFj++LVnm2DkfXOTwEm
k7UAoLObJuOLmCfuoVbRfRzOInnL8XTV
=ayRy
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
