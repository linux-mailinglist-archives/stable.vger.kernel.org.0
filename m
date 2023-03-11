Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F12B6B5AAB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCKKt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCKKtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:49:25 -0500
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD91E9CFD
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 02:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=DZvC+QNj8PHK37bCOUI9RaMY9M3fMNUqgaN+cHoRwBo=; b=QLZf8Nm28yWNluwu6O/LOSHmnC
        +r6/Fgip9cLuGax+yctzFZ3rokqNN9A7wOjFP+gnZTz606y/lG6nWV5AJ51N3DgX9uwmgQPkCuwhQ
        7XQYwtIb0YGswLwhtkCexHGtI0ZK/O1dxXCKA3MmQhUh2SZVgJ9GF/Y3gQLBelYS+SyoQoA4ZIShH
        bPqA+820AhxYqh2zjnQW9QOVz3/CQbXFY8AtG6SC3gXrGVmVolNAe1ZjJh7zfuXiar/EF47I/j3gX
        7cwM9x2ou+GMaTwuCG3aBSoLsXPRPkexnaajzWbGpOrTSbCaenweq1LU8v7rXJHQOVb3SoMHn6U2n
        dHdqL1pQ==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1pawmk-00Bk8D-A7; Sat, 11 Mar 2023 11:49:10 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.96)
        (envelope-from <aurelien@aurel32.net>)
        id 1pawmj-00AAIA-2G;
        Sat, 11 Mar 2023 11:49:09 +0100
Date:   Sat, 11 Mar 2023 11:49:09 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Bin Meng <bmeng.cn@gmail.com>
Cc:     Conor Dooley <conor@kernel.org>, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Message-ID: <ZAxcpTolZ74MweEW@aurel32.net>
References: <20230308220842.1231003-1-conor@kernel.org>
 <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
 <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud>
 <CAEUhbmUf+-a8u_qaC3weP1xBy8gjsbdV=29bM8gp6SWA5KqH5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAEUhbmUf+-a8u_qaC3weP1xBy8gjsbdV=29bM8gp6SWA5KqH5A@mail.gmail.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-11 13:41, Bin Meng wrote:
> On Sat, Mar 11, 2023 at 12:40=E2=80=AFAM Conor Dooley <conor@kernel.org> =
wrote:
> >
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
> > >
> > > Some further note:
> > >
> > > After I switched to kernel.org pre-built GCC 12.2.0 [1] which includes
> > > binutils 2.39, I was able to reproduce the exact same build failure of
> > > v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> > > build with binutils 2.38") by Aurelien Jarno.
> > >
> > > To verify the commit message of 6df2a016c0c8 is accurate or not, I
> > > built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> > > kernel.org package, surprisingly kernel v5.16 did not build with the
> > > same build failure.
> > >
> > > So it seems that it's GCC that caused the build failure instead of GAS
> > > from binutils??
> >
> > Right, that's what I was getting at in the bit below the --- line in my
> > patch. I think Aurelien was misled by the failure message and your email
> > ([1] in my links above) which claimed that binutils would default to
> > the 20191213 spec.
> > It appears (and I'm not a tc person) that GCC must call GAS with the
> > --misa-spec argument, and in GCC 12 the value used is 20191213.
> > Either GCC 11 must pass --misa-spec=3D2.2 to binutils, or it passes
> > nothing, leading binutils to be permissive about what -march=3Drv64i
> > means.
>=20
> I verified that "-misa-spec" is a new option introduced in GCC 12 and
> the default value is set to 20191213 which is unfortunately backward
> incompatible.
>=20
> GCC 11 does not have the "-misa-spec" option, so I assume it produces
> backward compatible codes.
>=20
> IOW, what commit 6df2a016c0c8 was trying to fix has nothing to do with
> binutils 2.38+. It's the GCC changes that is the culprit.

I disagree with that statement. Your tests seems to have been done using
the toolchains from [1], which changes two parameters, i.e. both the GCC
and binutils version.

The original issue can be demonstrated the following way:

- Revert commit 6df2a016c0c8
- Get toolchain from:
  https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/11.1=
=2E0/x86_64-gcc-11.1.0-nolibc-riscv64-linux.tar.xz
- Get toolchain from:
  https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/11.3=
=2E0/x86_64-gcc-11.3.0-nolibc-riscv64-linux.tar.xz
- Replace the as version in the 11.1.0 toolchain (2.36.1) with the one
  from the 1.3.0 one (2.38), for instance using:
  ln -sf ../../../../gcc-11.3.0-nolibc/riscv64-linux/riscv64-linux/bin/as g=
cc-11.1.0-nolibc/riscv64-linux/riscv64-linux/bin/as
- Build a defconfig kernel using the 11.1.0 toolchain, so using GCC 11.1
  with binutils 2.38

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
