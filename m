Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75B26B5A4D
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCKKMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCKKMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:12:21 -0500
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDF51ADCC
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 02:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=AXhVj002+YM3P1P11s+c1XbHP0mwVOeTdK6U1eeL9f0=; b=XX3z7KEUArYU0H97wz7tAWgonv
        gEH1D4yg44+wbfAyQgCoT0vaEqzUfluieugd6xGg32tesqk4kCmtJqEhwBHwhfePJvpcbNP8xxQ/h
        4L4D2zxqYTr7bypQpL2invrXpDKl9km38F4kKVxal1kiN+bJrl3TJGUf0pJ32tE0ej6gNU4R/rPrq
        Syzxagr3vr0FtedSDK7LE3BDG0P4xltAvs3Ak7lDAO28PSbgd3L9jd14U2bUZylK0KB7zgkzFN9BH
        zrI+N6i7VaM8UZ2qtI7A2buqUcGf91xonLXUxrGOg6dJtPtT7vk3WCNz4Y4u7oeqAvHS84EN11bE3
        IdHKjFLA==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1pawCl-00Bj4R-FX; Sat, 11 Mar 2023 11:11:59 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.96)
        (envelope-from <aurelien@aurel32.net>)
        id 1pawCj-00A43y-0H;
        Sat, 11 Mar 2023 11:11:57 +0100
Date:   Sat, 11 Mar 2023 11:11:57 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Conor Dooley <conor@kernel.org>
Cc:     Bin Meng <bmeng.cn@gmail.com>, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Message-ID: <ZAxT7T9Xy1Fo3d5W@aurel32.net>
References: <20230308220842.1231003-1-conor@kernel.org>
 <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
 <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J2FxkmOiI/p+8WYE"
Content-Disposition: inline
In-Reply-To: <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2FxkmOiI/p+8WYE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-10 16:40, Conor Dooley wrote:
> On Fri, Mar 10, 2023 at 11:35:57PM +0800, Bin Meng wrote:
> > On Fri, Mar 10, 2023 at 11:07=E2=80=AFPM Bin Meng <bmeng.cn@gmail.com> =
wrote:
> > >
> > > > From: Conor Dooley <conor.dooley@microchip.com>
> > > >
> > > > The spec folk, in their infinite wisdom, moved both control and sta=
tus
> > > > registers & the FENCE.I instructions out of the I extension into th=
eir
> > > > own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
> > > > spec [0].
> > > > The GCC/binutils crew decided [1] to move their default version of =
the
> > > > ISA spec to the 20191213 version of the ISA spec, which came into b=
eing
> > > > for version 2.38 of binutils and GCC 12. Building with this toolcha=
in
> > > > configuration would result in assembler issues:
> > > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assemble=
r messages:
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > > This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binut=
ils
> > > > 2.38") by Aurelien Jarno, but has proven fragile.
> > > >
> > > > Before LLVM 17, LLVM did not support these extensions and, as such,=
 the
> > > > cc-option check added by Aurelien worked. Since commit 22e199e6afb1
> > > > ("[RISCV] Accept zicsr and zifencei command line options") however,=
 LLVM
> > > > *does* support them and the cc-option check passes.
> > > >
> > > > This surfaced as a problem while building the 5.10 stable kernel us=
ing
> > > > the default Tuxmake Debian image [2], as 5.10 did not yet support l=
d.lld,
> > > > and uses the Debian provided binutils 2.35.
> > > > Versions of ld prior to 2.38 will refuse to link if they encounter
> > > > unknown ISA extensions, and unfortunately Zifencei is not supported=
 by
> > > > bintuils 2.35.
> > > >
> > > > Instead of dancing around with adding these extensions to march, as=
 we
> > > > currently do, Palmer suggested locking GCC builds to the same versi=
on of
> > > > the ISA spec that is used by LLVM. As far as I can tell, that is 2.=
2,
> > > > with, apparently [3], a lack of interest in implementing a flag like
> > > > GCC's -misa-spec at present.
> > > >
> > > > Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS wh=
en
> > > > GCC is used & remove the march dance.
> > > >
> > > > As clang does not accept this argument, I had expected to encounter
> > > > issues with the assembler, as neither zicsr nor zifencei are presen=
t in
> > > > the ISA string and the spec version *should* be defaulting to a ver=
sion
> > > > that requires them to be present. The build passed however and the
> > > > resulting kernel worked perfectly fine for me on a PolarFire SoC...
> > > >
> > > > Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf [=
0]
> > > > Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1Ze=
HHCYf4 [1]
> > > > Link: https://lore.kernel.org/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf4pZc=
DO=3DhuCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> > > > Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-ver=
sion-misa-spec-gcc-flag-equivalent/66935 [3]
> > > > CC: stable@vger.kernel.org
> > > > Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > > > ---
> > > > I think Aurelien's original commit message might actually not be qu=
ite
> > > > correct? I found, in my limited testing, that it is not the default
> > > > behaviour of gas that matters, but rather the toolchain itself?
> > > > My binutils versions (both those built using the clang-built-linux
> > > > tc-build scripts which do not set an ISA spec version, and one built
> > > > using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec ve=
rsion
> > > > set) do not encounter these issues.
> > >
> > > I am unable to reproduce the build failure as reported by commit 6df2=
a016c0c8
> > > ("riscv: fix build with binutils 2.38") by Aurelien Jarno using kerne=
l.org
> > > pre-built GCC 11.3.0 [1] which includes binutils 2.38.
> > >
> > > [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86=
_64/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz
> > >
> > > The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17) bu=
ilds fine
> > > for me. Anything I am missing?
> > >
> >=20
> > Some further note:
> >=20
> > After I switched to kernel.org pre-built GCC 12.2.0 [1] which includes
> > binutils 2.39, I was able to reproduce the exact same build failure of
> > v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> > build with binutils 2.38") by Aurelien Jarno.
> >=20
> > To verify the commit message of 6df2a016c0c8 is accurate or not, I
> > built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> > kernel.org package, surprisingly kernel v5.16 did not build with the
> > same build failure.
> >=20
> > So it seems that it's GCC that caused the build failure instead of GAS
> > from binutils??
>=20
> Right, that's what I was getting at in the bit below the --- line in my
> patch. I think Aurelien was misled by the failure message and your email
> ([1] in my links above) which claimed that binutils would default to
> the 20191213 spec.

No I was not misled by that, at that time GCC 11.3 and GCC 12 were not
released.

binutils definitely defaults to 20191213 if you do not use the
--with-isa-spec with a different value when configuring it.

> It appears (and I'm not a tc person) that GCC must call GAS with the
> --misa-spec argument, and in GCC 12 the value used is 20191213.
> Either GCC 11 must pass --misa-spec=3D2.2 to binutils, or it passes
> nothing, leading binutils to be permissive about what -march=3Drv64i
> means.

GCC 11.1 and 11.2 pass nothing to binutils, hence the issue I reported
and the patch fixing that. Basic support for misa-spec has been
backported to GCC 11.3, with a default to --misa-spec=3D2.2, hence the
"permissive" behaviour you observe.

> The permissive option would "seem" to be correct, as building with clang
> (that to my knowledge doesn't pass --misa-spec to GAS) and with
> -march=3Drv64i has no issues assembling.

The "permissive" way only work if we drop support for GCC 11.1 and 11.2,
which sounds acceptable to me.

> It'd appear to me that binutils is a *player* in this issue, but is not
> the culprit of the issue Aurelien sought to fix.

I *disagree*. At the time the commit has been merged, binutils was the
only culprit. With more recent versions of GCC 11.3 and GCC 12 released
in the meantime, the situation is way more complex.

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net

--J2FxkmOiI/p+8WYE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUryGlb40+QrX1Ay4E4jA+JnoM2sFAmQMU+sACgkQE4jA+Jno
M2u4uhAAnWl27lBSEWDqEh6CPLidd5L9w2YcEV+wRUyfpC2W1UJI/c60Xlh15o3m
pExjXEXZt5dmo2pPHSv6awgqKvLXOKl3l/E1dMlBfN+Xs4QxbCKDSNSk1P5Jn3KN
EEZaqkaAjO0Q+VgC1hLAZ2hq+QSODhy04n4oWhg4WbMlUpnkVZmaSenymwjqXcy4
FSAPTVNSnq/JobUYJGdyniietMijrgIu61jzzqhTdAI2Lr0gHjXCrpVJVDZ3k4oy
h1+E/8XRo+4L4+IxFSwtqRGQbyScA4XTLClYEfGr4q2GuSQg215aRJYAX9BwwRWG
RyZKcbgw2IcydrTgBjHaYU1r9sA1ssYqZRhi8muznwB12M/ul6dyAPAuwi6U6A6d
Vk96NsT/G0Q7+NXFkdHLLgHtIJp44YKPEpoNunAycxOoleshIweYQeU0zBqwAHqv
RF8eiuWjtUewqfqXb0eB7fbMysNq4L3MSLjJfcNgUTj9qNB/lp55kviI78iMnXIt
EGUYG1mTDcEY2m0c4jjq54cvSSh4CAGe1P84B5NDNy4TwxZcI9upLkIpeS7rjdU3
I4vpFiKem1bB6XPltscpzLIh8v5fC0bA4/Qprlm6SbCbAD7uFemGyRxXwcwix4zZ
8XSwCH70YkyewxtPGZC7s+b4A4NfGADgg6iDPG2gVw7cqMf4TBQ=
=h/k0
-----END PGP SIGNATURE-----

--J2FxkmOiI/p+8WYE--
