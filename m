Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAD2567CA
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgH2NKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 09:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgH2NIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 09:08:23 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29932C061236;
        Sat, 29 Aug 2020 06:08:23 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Bdxbg707bzQlXY;
        Sat, 29 Aug 2020 15:08:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id D4nIgZiZ-rjH; Sat, 29 Aug 2020 15:08:11 +0200 (CEST)
Subject: Re: [PATCH AUTOSEL 5.4 10/58] mips: vdso: fix 'jalr t9' crash in vdso
 code
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Victor Kamensky <kamensky@cisco.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        richard.purdie@linuxfoundation.org,
        Tony Ambardar <itugrok@yahoo.com>
References: <20200305171420.29595-1-sashal@kernel.org>
 <20200305171420.29595-10-sashal@kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <d10c1981-ab79-86a9-4cf4-bd098d8c55f4@hauke-m.de>
Date:   Sat, 29 Aug 2020 15:08:01 +0200
MIME-Version: 1.0
In-Reply-To: <20200305171420.29595-10-sashal@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Ttok1Qk9yhWqFEXqFdZWKjbdjDK9gz4Kb"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -7.15 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6B4026CF
X-Rspamd-UID: a5b109
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ttok1Qk9yhWqFEXqFdZWKjbdjDK9gz4Kb
Content-Type: multipart/mixed; boundary="nqQKqT9USiOwnMw9JxtTijqWzwgPUI9xO"

--nqQKqT9USiOwnMw9JxtTijqWzwgPUI9xO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/5/20 6:13 PM, Sasha Levin wrote:
> From: Victor Kamensky <kamensky@cisco.com>
>=20
> [ Upstream commit d3f703c4359ff06619b2322b91f69710453e6b6d ]
>=20
> Observed that when kernel is built with Yocto mips64-poky-linux-gcc,
> and mips64-poky-linux-gnun32-gcc toolchain, resulting vdso contains
> 'jalr t9' instructions in its code and since in vdso case nobody
> sets GOT table code crashes when instruction reached. On other hand
> observed that when kernel is built mips-poky-linux-gcc toolchain, the
> same 'jalr t9' instruction are replaced with PC relative function
> calls using 'bal' instructions.
>=20
> The difference boils down to -mrelax-pic-calls and -mexplicit-relocs
> gcc options that gets different default values depending on gcc
> target triplets and corresponding binutils. -mrelax-pic-calls got
> enabled by default only in mips-poky-linux-gcc case. MIPS binutils
> ld relies on R_MIPS_JALR relocation to convert 'jalr t9' into 'bal'
> and such relocation is generated only if -mrelax-pic-calls option
> is on.
>=20
> Please note 'jalr t9' conversion to 'bal' can happen only to static
> functions. These static PIC calls use mips local GOT entries that
> are supposed to be filled with start of DSO value by run-time linker
> (missing in VDSO case) and they do not have dynamic relocations.
> Global mips GOT entries must have dynamic relocations and they should
> be prevented by cmd_vdso_check Makefile rule.
>=20
> Solution call out -mrelax-pic-calls and -mexplicit-relocs options
> explicitly while compiling MIPS vdso code. That would get correct
> and consistent between different toolchains behaviour.
>=20
> Reported-by: Bruce Ashfield <bruce.ashfield@gmail.com>
> Signed-off-by: Victor Kamensky <kamensky@cisco.com>
> Signed-off-by: Paul Burton <paulburton@kernel.org>
> Cc: linux-mips@vger.kernel.org
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: James Hogan <jhogan@kernel.org>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: richard.purdie@linuxfoundation.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/mips/vdso/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>=20

Hi Sasha,

Why was this not added to the 5.4 stable branch?

Some OpenWrt users ran into this problem with kernel 5.4 on MIPS64 [0].
We backported this patch on our own in OpenWrt [1], but it should be
added to the sable branch in my opinion as it fixes a real problem.

@Sasha: Can you add it to the 5.4 stable branch or should I send some
special email?

[0]: https://bugs.openwrt.org/index.php?do=3Ddetails&task_id=3D3277
[1]: https://git.openwrt.org/2932b4d05e1d212259c2903fd9cebcee5616680b

Hauke


--nqQKqT9USiOwnMw9JxtTijqWzwgPUI9xO--

--Ttok1Qk9yhWqFEXqFdZWKjbdjDK9gz4Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl9KUzEACgkQ8bdnhZyy
68cNDQgAuO9SD2VsVnKklJb+jOba+Y9X4wL2njxZcY9ZvshYAeD4WD7qDOI+rKMh
gJHJRNZY2jAHcc2bQ8NZErrerkbKwmWxXmgUR6YAMqtFeEsg5/vHsQeMPJi8vCn/
kLFOzJ1rf/PHwV0kfNtYF6+TtcE4F539fN6pp3nhhNMpWrGhar9OOEqXKetJp2sq
0DXtErBK5OreX8YGR2YtGzY/y6eMEuaeuKTS2UnLKV78XUC2Gapmrk0Af3pB8TiT
ljvK/tUJTOMC3mqXb7L++qEVmGQvsyE8nxJPBfWLawpqovk1oHsT6YJOH6Jjyajy
3cRHor10unue+T6ezM8TjCbAmkbc3w==
=wMb2
-----END PGP SIGNATURE-----

--Ttok1Qk9yhWqFEXqFdZWKjbdjDK9gz4Kb--
