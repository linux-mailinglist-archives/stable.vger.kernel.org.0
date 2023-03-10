Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9D6B4D60
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 17:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCJQnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 11:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCJQm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 11:42:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D158413483A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 08:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E93D61B7A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 16:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191EC433D2;
        Fri, 10 Mar 2023 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678466407;
        bh=0SfNvHsO53tpvEMlRyNBs1hU60wEUQrvF5Xwc0FXy64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mmClGFi3qhA0ckm/+OPM3W3YfK/qkBWEyxTjoBDouuI8F8W733wpo5Z3W03/2Bi5x
         sLKMrELI+RJok/xkB9nruzE+NakPjqE6Bobt7qLQKNOiOiWxrA7XCMNKk/8cYTlslF
         A4VIhbOK3+TtJhZBcQUJED6hyUOmwjWUoatB9phWaBrtURxrKXOF8XdrmdcXthdWHi
         xE2UXt2GNX7HbUcv+03Zhmgg5GWBQvwzLaqpCHv+Glx3+rXBEuXfez/ZQJw7UFG5oG
         Ply32QF74JmYNheOCPGgU62Iqij3PHbSJGTNTuPK8VfWWns8CbK7Gn/nE7nVZ33cQX
         8lv9VNebJsgjw==
Date:   Fri, 10 Mar 2023 16:40:02 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Bin Meng <bmeng.cn@gmail.com>
Cc:     aurelien@aurel32.net, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Message-ID: <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud>
References: <20230308220842.1231003-1-conor@kernel.org>
 <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SXomGqCfsV8U9y1L"
Content-Disposition: inline
In-Reply-To: <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SXomGqCfsV8U9y1L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 11:35:57PM +0800, Bin Meng wrote:
> On Fri, Mar 10, 2023 at 11:07=E2=80=AFPM Bin Meng <bmeng.cn@gmail.com> wr=
ote:
> >
> > > From: Conor Dooley <conor.dooley@microchip.com>
> > >
> > > The spec folk, in their infinite wisdom, moved both control and status
> > > registers & the FENCE.I instructions out of the I extension into their
> > > own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
> > > spec [0].
> > > The GCC/binutils crew decided [1] to move their default version of the
> > > ISA spec to the 20191213 version of the ISA spec, which came into bei=
ng
> > > for version 2.38 of binutils and GCC 12. Building with this toolchain
> > > configuration would result in assembler issues:
> > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler =
messages:
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > > This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binutils
> > > 2.38") by Aurelien Jarno, but has proven fragile.
> > >
> > > Before LLVM 17, LLVM did not support these extensions and, as such, t=
he
> > > cc-option check added by Aurelien worked. Since commit 22e199e6afb1
> > > ("[RISCV] Accept zicsr and zifencei command line options") however, L=
LVM
> > > *does* support them and the cc-option check passes.
> > >
> > > This surfaced as a problem while building the 5.10 stable kernel using
> > > the default Tuxmake Debian image [2], as 5.10 did not yet support ld.=
lld,
> > > and uses the Debian provided binutils 2.35.
> > > Versions of ld prior to 2.38 will refuse to link if they encounter
> > > unknown ISA extensions, and unfortunately Zifencei is not supported by
> > > bintuils 2.35.
> > >
> > > Instead of dancing around with adding these extensions to march, as we
> > > currently do, Palmer suggested locking GCC builds to the same version=
 of
> > > the ISA spec that is used by LLVM. As far as I can tell, that is 2.2,
> > > with, apparently [3], a lack of interest in implementing a flag like
> > > GCC's -misa-spec at present.
> > >
> > > Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS when
> > > GCC is used & remove the march dance.
> > >
> > > As clang does not accept this argument, I had expected to encounter
> > > issues with the assembler, as neither zicsr nor zifencei are present =
in
> > > the ISA string and the spec version *should* be defaulting to a versi=
on
> > > that requires them to be present. The build passed however and the
> > > resulting kernel worked perfectly fine for me on a PolarFire SoC...
> > >
> > > Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf [0]
> > > Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1ZeHH=
CYf4 [1]
> > > Link: https://lore.kernel.org/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf4pZcDO=
=3DhuCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> > > Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-versi=
on-misa-spec-gcc-flag-equivalent/66935 [3]
> > > CC: stable@vger.kernel.org
> > > Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > > ---
> > > I think Aurelien's original commit message might actually not be quite
> > > correct? I found, in my limited testing, that it is not the default
> > > behaviour of gas that matters, but rather the toolchain itself?
> > > My binutils versions (both those built using the clang-built-linux
> > > tc-build scripts which do not set an ISA spec version, and one built
> > > using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec vers=
ion
> > > set) do not encounter these issues.
> >
> > I am unable to reproduce the build failure as reported by commit 6df2a0=
16c0c8
> > ("riscv: fix build with binutils 2.38") by Aurelien Jarno using kernel.=
org
> > pre-built GCC 11.3.0 [1] which includes binutils 2.38.
> >
> > [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_6=
4/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz
> >
> > The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17) buil=
ds fine
> > for me. Anything I am missing?
> >
>=20
> Some further note:
>=20
> After I switched to kernel.org pre-built GCC 12.2.0 [1] which includes
> binutils 2.39, I was able to reproduce the exact same build failure of
> v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> build with binutils 2.38") by Aurelien Jarno.
>=20
> To verify the commit message of 6df2a016c0c8 is accurate or not, I
> built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> kernel.org package, surprisingly kernel v5.16 did not build with the
> same build failure.
>=20
> So it seems that it's GCC that caused the build failure instead of GAS
> from binutils??

Right, that's what I was getting at in the bit below the --- line in my
patch. I think Aurelien was misled by the failure message and your email
([1] in my links above) which claimed that binutils would default to
the 20191213 spec.
It appears (and I'm not a tc person) that GCC must call GAS with the
--misa-spec argument, and in GCC 12 the value used is 20191213.
Either GCC 11 must pass --misa-spec=3D2.2 to binutils, or it passes
nothing, leading binutils to be permissive about what -march=3Drv64i
means.

The permissive option would "seem" to be correct, as building with clang
(that to my knowledge doesn't pass --misa-spec to GAS) and with
-march=3Drv64i has no issues assembling.

It'd appear to me that binutils is a *player* in this issue, but is not
the culprit of the issue Aurelien sought to fix.

I dunno what I am talking about though, this is all from playing around
with many tc variants and see how it goes!

Cheers,
Conor.


--SXomGqCfsV8U9y1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAtdXAAKCRB4tDGHoIJi
0vR9AQCsm3FPRIZciwMH+/yQ+myVQsBSmy6W2G5/J5kHBkEFHAD+MjcGU1R3itn8
POZhKhW2h2sVUSXmx+nAMLcv35FXzAM=
=RGSr
-----END PGP SIGNATURE-----

--SXomGqCfsV8U9y1L--
