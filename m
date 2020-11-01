Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC372A21F7
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgKAV4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 16:56:46 -0500
Received: from ozlabs.org ([203.11.71.1]:40619 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgKAV4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 16:56:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CPVHs3jcWz9sVH;
        Mon,  2 Nov 2020 08:56:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604267804;
        bh=x3e7Q7r/2Ihzgt9EqYR8twrT/Y1TOjYm10EQ3uguY3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PPAe5Ep8fUPlw1ouHFR3xmm6hFWv4Mw3BMrkgsJwDoZKhKedgtA/u+NsO0YLw0zYF
         YOQg0l5rcTcro7xxdA0CfPiOjePx5bmcKKN5k6EZKBh3gwkTjs7E+lopestv8khgDq
         MUmtK8+ZuogXnhkxav1h4loIS6STLiqOdF6FYDrsxrTJkjkNJHu/PpdCCCozRxW3Rx
         s0qd5Ksuz2KPcNwAWW7Frj/yE1fKGgwnfTDY77+d3H9yDW1K4SLIP+zTcXtIKfP7T9
         o535myMe7GnoDMjbwTyLG+BrxGp+iddfo0Ph2E6FkSjyiI4MPBpKn5GbJDCx9IDo/b
         8XKC308vu4ddw==
Date:   Mon, 2 Nov 2020 08:56:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Matthew Wilcox <willy@infradead.org>,
        kernel test robot <lkp@intel.com>,
        linux-next@vger.kernel.org, kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201102084544.301e1a35@canb.auug.org.au>
In-Reply-To: <20201101173835.GC27442@casper.infradead.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
        <20201101173105.1723648-1-nivedita@alum.mit.edu>
        <20201101173835.GC27442@casper.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ngyV3pvXSLnohVhaQ3Wm_WB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/ngyV3pvXSLnohVhaQ3Wm_WB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 1 Nov 2020 17:38:35 +0000 Matthew Wilcox <willy@infradead.org> wrot=
e:
>
> On Sun, Nov 01, 2020 at 12:31:05PM -0500, Arvind Sankar wrote:
> > Commit
> >   b9de06783f01 ("compiler.h: fix barrier_data() on clang")
> > moved the definition of barrier() into compiler.h. =20
>=20
> That's not a real commit ID.  It only exists in linux-next and
> will expire after a few weeks.

Which also means that the Cc: <stable@vger.kernel.org> is also
unnecessary.

--=20
Cheers,
Stephen Rothwell

--Sig_/ngyV3pvXSLnohVhaQ3Wm_WB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+fLw4ACgkQAVBC80lX
0GwlnwgAgAlsZ1CoLCDD68uF4nVaKIBY6HzC8yRRRGflQDAA6t1pGIo5cOwfk1ki
3RF+mEAnDiRH8q5TiwlOQE519dm6WMu/GqP6cNMbZdJ4gsh9gQU/9PdzFERJTE+T
3qgo2ys2d6AAyqOZn/g8mq7f1OZD/PiUpMMLbXATkfU9TELpTW4tywrSmTRfDPgk
1jY6vz0EVD94vZt+aMga4SRRE6n8SUESvBR5G8ituxNbWeHWK4wux37+EoKyS/hn
Il/7Yyc2FXVnqRMksRquCmthBcxWTtFiOcqX9AbYvIkLecUggnzBA9gbXwf0rmlP
TSyggvQIEOj0giPIOj+Re21fvD4IlA==
=MsnM
-----END PGP SIGNATURE-----

--Sig_/ngyV3pvXSLnohVhaQ3Wm_WB--
