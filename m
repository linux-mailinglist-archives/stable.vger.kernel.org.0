Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FB73432E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFDJaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:30:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34386 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfFDJaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:30:35 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 00F4680302; Tue,  4 Jun 2019 11:30:22 +0200 (CEST)
Date:   Tue, 4 Jun 2019 11:30:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 29/32] jump_label: move asm goto support test to
 Kconfig
Message-ID: <20190604093032.GA2689@amd>
References: <20190603090308.472021390@linuxfoundation.org>
 <20190603090315.474902271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20190603090315.474902271@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-06-03 11:08:23, Greg Kroah-Hartman wrote:
> From: Masahiro Yamada <yamada.masahiro@socionext.com>
>=20
> commit e9666d10a5677a494260d60d1fa0b73cc7646eb3 upstream.
>=20
> Currently, CONFIG_JUMP_LABEL just means "I _want_ to use jump label".
>=20
> The jump label is controlled by HAVE_JUMP_LABEL, which is defined
> like this:
>=20
>   #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>   # define HAVE_JUMP_LABEL
>   #endif
>=20
> We can improve this by testing 'asm goto' support in Kconfig, then
> make JUMP_LABEL depend on CC_HAS_ASM_GOTO.
>=20
> Ugly #ifdef HAVE_JUMP_LABEL will go away, and CONFIG_JUMP_LABEL will
> match to the real kernel capability.
>=20
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> [nc: Fix trivial conflicts in 4.19
>      arch/xtensa/kernel/jump_label.c doesn't exist yet
>      Ensured CC_HAVE_ASM_GOTO and HAVE_JUMP_LABEL were sufficiently
>      eliminated]
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This does not matche stable-kernel rules. It is nice cleanup, but it
does not really fix any bug (does it?), and resulting patch is too
big.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz2OjgACgkQMOfwapXb+vJg6ACfTJHn2/dpEQHUJGSjB7L709iu
ob4An3gjfbXgf03/ZaByt6D+YOfo0kYZ
=grxE
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
