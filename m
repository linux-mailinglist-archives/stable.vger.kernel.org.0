Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8406424ECC0
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHWKpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 06:45:02 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48730 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgHWKpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 06:45:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A4BEA1C0BBB; Sun, 23 Aug 2020 12:44:59 +0200 (CEST)
Date:   Sun, 23 Aug 2020 12:44:59 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-ID: <20200823104459.untmn33r46wqxi66@duo.ucw.cz>
References: <20200821123746.16904-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ab2tecr4xsmyxrrm"
Content-Disposition: inline
In-Reply-To: <20200821123746.16904-1-joro@8bytes.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ab2tecr4xsmyxrrm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The __apply_to_page_range() function is also used to change and/or
> allocate page-table pages in the vmalloc area of the address space.
> Make sure these changes get synchronized to other page-tables in the
> system by calling arch_sync_kernel_mappings() when necessary.
>=20
> Tested-by: Chris Wilson <chris@chris-wilson.co.uk> #x86-32
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

This seems to solve screen blinking problems on Thinkpad X60. (It
already survived few unison runs, which would usually kill it.).

Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks and best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ab2tecr4xsmyxrrm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0JIqwAKCRAw5/Bqldv6
8kjIAJoD97mGm2SLYscxJlq2IzZ34vE4vQCcDwXVYWTvZgJt0mtfFG77d0syZ0o=
=f1aM
-----END PGP SIGNATURE-----

--ab2tecr4xsmyxrrm--
