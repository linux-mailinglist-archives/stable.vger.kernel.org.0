Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0B66B5A94
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCKKlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKKlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:41:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85A4125DB9
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 02:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A06CB824FA
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 10:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5986C433EF;
        Sat, 11 Mar 2023 10:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678531254;
        bh=7zsjzpHaJ2URUrzqH21gfr7zcR06Vsq1WlYTpLGN67k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hz/QgQV+tol0QGs1uiyUVU1YmQC/AXzitZL+kbYA7GInRtmiVQFTEY2iVDRO3dg9W
         Dn+aohn+jBeSOIE/jhaWHFlmdrQSfM29KnKsXPxiQb+ErCGf7hJ0loT1671wCPg4qU
         YipOiQZ7PMrtj+RmT4g2gYZo0eKssfXShK1dKJeNS1Y1iyjI/PTio57fapGQZFt27J
         IB7DAaBhis1H3YM2RwmK+MKXMV2SXZbF3nXtb0RVv+SBYOReSerBiB+mmvdrTaW7fI
         sxx3EVlcjjn4d5TnL56sL+iQzholyCixL7ZEsZgFWalbgwSIRW02F92fkaoBbKpOiX
         SLQGUBS/XfmKA==
Date:   Sat, 11 Mar 2023 10:40:49 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     Bin Meng <bmeng.cn@gmail.com>, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Message-ID: <88fadde1-27eb-40c6-b90e-881ebf9690df@spud>
References: <20230308220842.1231003-1-conor@kernel.org>
 <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
 <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud>
 <ZAxT7T9Xy1Fo3d5W@aurel32.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Uu0eTYwFSIAxBZgb"
Content-Disposition: inline
In-Reply-To: <ZAxT7T9Xy1Fo3d5W@aurel32.net>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Uu0eTYwFSIAxBZgb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 11, 2023 at 11:11:57AM +0100, Aurelien Jarno wrote:
> On 2023-03-10 16:40, Conor Dooley wrote:
> > On Fri, Mar 10, 2023 at 11:35:57PM +0800, Bin Meng wrote:
> > > On Fri, Mar 10, 2023 at 11:07=E2=80=AFPM Bin Meng <bmeng.cn@gmail.com=
> wrote:
> > > >
> > > > > From: Conor Dooley <conor.dooley@microchip.com>
> > > > >
> > > > > The spec folk, in their infinite wisdom, moved both control and s=
tatus
> > > > > registers & the FENCE.I instructions out of the I extension into =
their
> > > > > own extensions (Zicsr, Zifencei) in the 20190608 version of the I=
SA
> > > > > spec [0].
> > > > > The GCC/binutils crew decided [1] to move their default version o=
f the
> > > > > ISA spec to the 20191213 version of the ISA spec, which came into=
 being
> > > > > for version 2.38 of binutils and GCC 12. Building with this toolc=
hain
> > > > > configuration would result in assembler issues:
> > > > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assemb=
ler messages:
> > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Err=
or: unrecognized opcode `csrr a5,0xc01'
> > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Err=
or: unrecognized opcode `csrr a5,0xc01'
> > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Err=
or: unrecognized opcode `csrr a5,0xc01'
> > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Err=
or: unrecognized opcode `csrr a5,0xc01'
> > > > > This was fixed in commit 6df2a016c0c8 ("riscv: fix build with bin=
utils
> > > > > 2.38") by Aurelien Jarno, but has proven fragile.
> > > > >
> > > > > Before LLVM 17, LLVM did not support these extensions and, as suc=
h, the
> > > > > cc-option check added by Aurelien worked. Since commit 22e199e6af=
b1
> > > > > ("[RISCV] Accept zicsr and zifencei command line options") howeve=
r, LLVM
> > > > > *does* support them and the cc-option check passes.
> > > > >
> > > > > This surfaced as a problem while building the 5.10 stable kernel =
using
> > > > > the default Tuxmake Debian image [2], as 5.10 did not yet support=
 ld.lld,
> > > > > and uses the Debian provided binutils 2.35.
> > > > > Versions of ld prior to 2.38 will refuse to link if they encounter
> > > > > unknown ISA extensions, and unfortunately Zifencei is not support=
ed by
> > > > > bintuils 2.35.
> > > > >
> > > > > Instead of dancing around with adding these extensions to march, =
as we
> > > > > currently do, Palmer suggested locking GCC builds to the same ver=
sion of
> > > > > the ISA spec that is used by LLVM. As far as I can tell, that is =
2.2,
> > > > > with, apparently [3], a lack of interest in implementing a flag l=
ike
> > > > > GCC's -misa-spec at present.
> > > > >
> > > > > Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS =
when
> > > > > GCC is used & remove the march dance.
> > > > >
> > > > > As clang does not accept this argument, I had expected to encount=
er
> > > > > issues with the assembler, as neither zicsr nor zifencei are pres=
ent in
> > > > > the ISA string and the spec version *should* be defaulting to a v=
ersion
> > > > > that requires them to be present. The build passed however and the
> > > > > resulting kernel worked perfectly fine for me on a PolarFire SoC.=
=2E.
> > > > >
> > > > > Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf=
 [0]
> > > > > Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1=
ZeHHCYf4 [1]
> > > > > Link: https://lore.kernel.org/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf4p=
ZcDO=3DhuCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> > > > > Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-v=
ersion-misa-spec-gcc-flag-equivalent/66935 [3]
> > > > > CC: stable@vger.kernel.org
> > > > > Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > > > > ---
> > > > > I think Aurelien's original commit message might actually not be =
quite
> > > > > correct? I found, in my limited testing, that it is not the defau=
lt
> > > > > behaviour of gas that matters, but rather the toolchain itself?
> > > > > My binutils versions (both those built using the clang-built-linux
> > > > > tc-build scripts which do not set an ISA spec version, and one bu=
ilt
> > > > > using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec =
version
> > > > > set) do not encounter these issues.
> > > >
> > > > I am unable to reproduce the build failure as reported by commit 6d=
f2a016c0c8
> > > > ("riscv: fix build with binutils 2.38") by Aurelien Jarno using ker=
nel.org
> > > > pre-built GCC 11.3.0 [1] which includes binutils 2.38.
> > > >
> > > > [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x=
86_64/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz
> > > >
> > > > The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17) =
builds fine
> > > > for me. Anything I am missing?
> > > >
> > >=20
> > > Some further note:
> > >=20
> > > After I switched to kernel.org pre-built GCC 12.2.0 [1] which includes
> > > binutils 2.39, I was able to reproduce the exact same build failure of
> > > v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> > > build with binutils 2.38") by Aurelien Jarno.
> > >=20
> > > To verify the commit message of 6df2a016c0c8 is accurate or not, I
> > > built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> > > kernel.org package, surprisingly kernel v5.16 did not build with the
> > > same build failure.
> > >=20
> > > So it seems that it's GCC that caused the build failure instead of GAS
> > > from binutils??
> >=20
> > Right, that's what I was getting at in the bit below the --- line in my
> > patch. I think Aurelien was misled by the failure message and your email
> > ([1] in my links above) which claimed that binutils would default to
> > the 20191213 spec.
>=20
> No I was not misled by that, at that time GCC 11.3 and GCC 12 were not
> released.
>=20
> binutils definitely defaults to 20191213 if you do not use the
> --with-isa-spec with a different value when configuring it.

I specifically built binutils without that flag, and had no issues
building the kernel with clang, which is the source of my confusion here
really.
I'd have expected that to fail

> > It appears (and I'm not a tc person) that GCC must call GAS with the
> > --misa-spec argument, and in GCC 12 the value used is 20191213.
> > Either GCC 11 must pass --misa-spec=3D2.2 to binutils, or it passes
> > nothing, leading binutils to be permissive about what -march=3Drv64i
> > means.
>=20
> GCC 11.1 and 11.2 pass nothing to binutils, hence the issue I reported
> and the patch fixing that. Basic support for misa-spec has been
> backported to GCC 11.3, with a default to --misa-spec=3D2.2, hence the
> "permissive" behaviour you observe.
>=20
> > The permissive option would "seem" to be correct, as building with clang
> > (that to my knowledge doesn't pass --misa-spec to GAS) and with
> > -march=3Drv64i has no issues assembling.
>=20
> The "permissive" way only work if we drop support for GCC 11.1 and 11.2,
> which sounds acceptable to me.

I don't think that we can do that.

> > It'd appear to me that binutils is a *player* in this issue, but is not
> > the culprit of the issue Aurelien sought to fix.
>=20
> I *disagree*. At the time the commit has been merged, binutils was the
> only culprit.

Okay, fair enough! I was only going off my observations with
current-day, and clearly you remember well the situation that you
encountered this with!

> With more recent versions of GCC 11.3 and GCC 12 released
> in the meantime, the situation is way more complex.

This patch is going to be problematic w/ versions of gcc that do not
understand -misa-spec + binutils 2.38 then, isn't it.
Based on what Jess has said, pursuing this approach seems ill-advised
anyway.

I'm inclined to go back to my approach in v1 & only apply your march
addition when AS_IS_GNU. That still leaves a problem for a configuration
where GAS is 2.38 and LD is 2.35, which I don't think can be handled.
I feel the only option there is just erroring the build if someones
tries it.
Ditto for a future IAS + LD 2.35 combination, if IAS is using a 20190608
or later of the ISA spec.

--Uu0eTYwFSIAxBZgb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAxargAKCRB4tDGHoIJi
0swOAP9wQ/ggsW3fabpSO5xuN84Na5dj1CkvNR8szpLhZCpWogD+K74lvXnHb2AL
8lDegQ+sy61FovaHwnUCC/f9X1O/8g8=
=2vSF
-----END PGP SIGNATURE-----

--Uu0eTYwFSIAxBZgb--
