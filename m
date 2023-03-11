Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566646B5C1A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 14:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCKNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 08:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKNJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 08:09:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D8C2BEE0
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 05:09:20 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g10so2515582eda.1
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 05:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678540159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtoTxlABpXgN80Oy53eXVsPxiUYVB9iJEB+lzgUsW0Y=;
        b=HFafK8FEdirvE3NoWAnomJcrIMcPknErqnC2eP56jRGFJEgvma5kihJNuhWXkhpTTF
         Rph7ZtGmOYFW6MMXnHMP7zYngQ/yxoR3yFzTUQym7cxhVI9vouuMjKxxV2TcL8ugnKh1
         pPnjBdjbdYFMsT1OdumClrUadzAGJgdZtlz5dmSMIa8z6H8427qdnjTR8iWnC5k1Q8/d
         ITCcnp1aboWnfin9AzE6IlQ+h9uY7RXn5SPGfMKbAAmQhL2bTtiIa2MDo5Mr1jLEDcjc
         JkwLOHBqDOfCYY1nOB68xbhwgbxuin5dxo+e2C7XXiMHCNqGjsabDmGqkjpX9FkJQtpw
         umig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678540159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtoTxlABpXgN80Oy53eXVsPxiUYVB9iJEB+lzgUsW0Y=;
        b=lQTC9879heaQu1ollZj1JgKxKSqPdCgS7D/Pifp9foWAQyof4GR79TG7HjP+WSphNd
         sRPXpxxyCE7gZgsHYfmGvV+pQ9EVi/YxBAnM49HS7cSgxIRR49HRkQNK9fHl2b1UQAKX
         +MqHp6H2HDLqjce9nstMfMEvaDTLLy/yk13PbfhKjhIJGQxi/T/vK+NpFqqRcaMiWCiJ
         mmtd3+eS4Y3ubhokmGL074CRticP1U3Y2yrRjp0qBegxp2b1eUPL+4bNLWF79oIz7bWw
         izPnFK911P2X4DlD/M0CkM7GCizyvO5UczF5hPTvqcSgWRdUD+RPHpPlQH6qwnxCNtxq
         5Rew==
X-Gm-Message-State: AO0yUKVBI1E4x8s0A7m3sSRgP4v7WAR8LDOfnisgxPjl9O/UIe3lZ0W7
        /KVQyCo/GNVv+gtM4KbBfxvvLW5mRbbpyD6fTHg=
X-Google-Smtp-Source: AK7set+PCI94riQCj/eTKSat8hnM3VFgM9wwA3Lqj2CTO9g7UIC9U8FF3ByEuETC3TXfkeka+3mAkHluhlozsAqFlIo=
X-Received: by 2002:a17:907:20d1:b0:8b1:7e1b:5ec1 with SMTP id
 qq17-20020a17090720d100b008b17e1b5ec1mr14568963ejb.6.1678540158611; Sat, 11
 Mar 2023 05:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20230308220842.1231003-1-conor@kernel.org> <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
 <243c92f1-c1e0-428b-ab31-3d9c9088b2c2@spud> <CAEUhbmUf+-a8u_qaC3weP1xBy8gjsbdV=29bM8gp6SWA5KqH5A@mail.gmail.com>
 <ZAxcpTolZ74MweEW@aurel32.net>
In-Reply-To: <ZAxcpTolZ74MweEW@aurel32.net>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Sat, 11 Mar 2023 21:09:07 +0800
Message-ID: <CAEUhbmX1O-E-coJN_3Vgh4=5Rcg1KRr6c_rAJ6pfa9TsY3WTmQ@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     Conor Dooley <conor@kernel.org>, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 6:49=E2=80=AFPM Aurelien Jarno <aurelien@aurel32.ne=
t> wrote:
>
> On 2023-03-11 13:41, Bin Meng wrote:
> > On Sat, Mar 11, 2023 at 12:40=E2=80=AFAM Conor Dooley <conor@kernel.org=
> wrote:
> > >
> > > On Fri, Mar 10, 2023 at 11:35:57PM +0800, Bin Meng wrote:
> > > > On Fri, Mar 10, 2023 at 11:07=E2=80=AFPM Bin Meng <bmeng.cn@gmail.c=
om> wrote:
> > > > >
> > > > > > From: Conor Dooley <conor.dooley@microchip.com>
> > > > > >
> > > > > > The spec folk, in their infinite wisdom, moved both control and=
 status
> > > > > > registers & the FENCE.I instructions out of the I extension int=
o their
> > > > > > own extensions (Zicsr, Zifencei) in the 20190608 version of the=
 ISA
> > > > > > spec [0].
> > > > > > The GCC/binutils crew decided [1] to move their default version=
 of the
> > > > > > ISA spec to the 20191213 version of the ISA spec, which came in=
to being
> > > > > > for version 2.38 of binutils and GCC 12. Building with this too=
lchain
> > > > > > configuration would result in assembler issues:
> > > > > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Asse=
mbler messages:
> > > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: E=
rror: unrecognized opcode `csrr a5,0xc01'
> > > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: E=
rror: unrecognized opcode `csrr a5,0xc01'
> > > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: E=
rror: unrecognized opcode `csrr a5,0xc01'
> > > > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: E=
rror: unrecognized opcode `csrr a5,0xc01'
> > > > > > This was fixed in commit 6df2a016c0c8 ("riscv: fix build with b=
inutils
> > > > > > 2.38") by Aurelien Jarno, but has proven fragile.
> > > > > >
> > > > > > Before LLVM 17, LLVM did not support these extensions and, as s=
uch, the
> > > > > > cc-option check added by Aurelien worked. Since commit 22e199e6=
afb1
> > > > > > ("[RISCV] Accept zicsr and zifencei command line options") howe=
ver, LLVM
> > > > > > *does* support them and the cc-option check passes.
> > > > > >
> > > > > > This surfaced as a problem while building the 5.10 stable kerne=
l using
> > > > > > the default Tuxmake Debian image [2], as 5.10 did not yet suppo=
rt ld.lld,
> > > > > > and uses the Debian provided binutils 2.35.
> > > > > > Versions of ld prior to 2.38 will refuse to link if they encoun=
ter
> > > > > > unknown ISA extensions, and unfortunately Zifencei is not suppo=
rted by
> > > > > > bintuils 2.35.
> > > > > >
> > > > > > Instead of dancing around with adding these extensions to march=
, as we
> > > > > > currently do, Palmer suggested locking GCC builds to the same v=
ersion of
> > > > > > the ISA spec that is used by LLVM. As far as I can tell, that i=
s 2.2,
> > > > > > with, apparently [3], a lack of interest in implementing a flag=
 like
> > > > > > GCC's -misa-spec at present.
> > > > > >
> > > > > > Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAG=
S when
> > > > > > GCC is used & remove the march dance.
> > > > > >
> > > > > > As clang does not accept this argument, I had expected to encou=
nter
> > > > > > issues with the assembler, as neither zicsr nor zifencei are pr=
esent in
> > > > > > the ISA string and the spec version *should* be defaulting to a=
 version
> > > > > > that requires them to be present. The build passed however and =
the
> > > > > > resulting kernel worked perfectly fine for me on a PolarFire So=
C...
> > > > > >
> > > > > > Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.p=
df [0]
> > > > > > Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/a=
E1ZeHHCYf4 [1]
> > > > > > Link: https://lore.kernel.org/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf=
4pZcDO=3DhuCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> > > > > > Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec=
-version-misa-spec-gcc-flag-equivalent/66935 [3]
> > > > > > CC: stable@vger.kernel.org
> > > > > > Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > > > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > > > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > > > > > ---
> > > > > > I think Aurelien's original commit message might actually not b=
e quite
> > > > > > correct? I found, in my limited testing, that it is not the def=
ault
> > > > > > behaviour of gas that matters, but rather the toolchain itself?
> > > > > > My binutils versions (both those built using the clang-built-li=
nux
> > > > > > tc-build scripts which do not set an ISA spec version, and one =
built
> > > > > > using the riscv-gnu-toolchain infra w/ an explicit 20191213 spe=
c version
> > > > > > set) do not encounter these issues.
> > > > >
> > > > > I am unable to reproduce the build failure as reported by commit =
6df2a016c0c8
> > > > > ("riscv: fix build with binutils 2.38") by Aurelien Jarno using k=
ernel.org
> > > > > pre-built GCC 11.3.0 [1] which includes binutils 2.38.
> > > > >
> > > > > [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin=
/x86_64/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz
> > > > >
> > > > > The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17=
) builds fine
> > > > > for me. Anything I am missing?
> > > > >
> > > >
> > > > Some further note:
> > > >
> > > > After I switched to kernel.org pre-built GCC 12.2.0 [1] which inclu=
des
> > > > binutils 2.39, I was able to reproduce the exact same build failure=
 of
> > > > v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> > > > build with binutils 2.38") by Aurelien Jarno.
> > > >
> > > > To verify the commit message of 6df2a016c0c8 is accurate or not, I
> > > > built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> > > > kernel.org package, surprisingly kernel v5.16 did not build with th=
e
> > > > same build failure.
> > > >
> > > > So it seems that it's GCC that caused the build failure instead of =
GAS
> > > > from binutils??
> > >
> > > Right, that's what I was getting at in the bit below the --- line in =
my
> > > patch. I think Aurelien was misled by the failure message and your em=
ail
> > > ([1] in my links above) which claimed that binutils would default to
> > > the 20191213 spec.
> > > It appears (and I'm not a tc person) that GCC must call GAS with the
> > > --misa-spec argument, and in GCC 12 the value used is 20191213.
> > > Either GCC 11 must pass --misa-spec=3D2.2 to binutils, or it passes
> > > nothing, leading binutils to be permissive about what -march=3Drv64i
> > > means.
> >
> > I verified that "-misa-spec" is a new option introduced in GCC 12 and
> > the default value is set to 20191213 which is unfortunately backward
> > incompatible.
> >
> > GCC 11 does not have the "-misa-spec" option, so I assume it produces
> > backward compatible codes.
> >
> > IOW, what commit 6df2a016c0c8 was trying to fix has nothing to do with
> > binutils 2.38+. It's the GCC changes that is the culprit.
>
> I disagree with that statement. Your tests seems to have been done using
> the toolchains from [1], which changes two parameters, i.e. both the GCC
> and binutils version.
>
> The original issue can be demonstrated the following way:
>
> - Revert commit 6df2a016c0c8
> - Get toolchain from:
>   https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/11=
.1.0/x86_64-gcc-11.1.0-nolibc-riscv64-linux.tar.xz
> - Get toolchain from:
>   https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/11=
.3.0/x86_64-gcc-11.3.0-nolibc-riscv64-linux.tar.xz
> - Replace the as version in the 11.1.0 toolchain (2.36.1) with the one
>   from the 1.3.0 one (2.38), for instance using:
>   ln -sf ../../../../gcc-11.3.0-nolibc/riscv64-linux/riscv64-linux/bin/as=
 gcc-11.1.0-nolibc/riscv64-linux/riscv64-linux/bin/as
> - Build a defconfig kernel using the 11.1.0 toolchain, so using GCC 11.1
>   with binutils 2.38
>
> [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/
>

Okay, thanks for sharing the info of binutils's configuration of "-misa-spe=
c".

Indeed I checked the "-misa-spec" default value was changed from 2.2
to 20191213 in binutils 2.38 via the following commit:

commit aed44286efa8ae8717a77d94b51ac3614e2ca6dc
Author: Nelson Chu <nelson.chu@sifive.com>
Date:   Thu Dec 30 23:23:46 2021 +0800

    RISC-V: Updated the default ISA spec to 20191213.

    Update the default ISA spec from 2.2 to 20191213 will change the defaul=
t
    version of i from 2.0 to 2.1.  Since zicsr and zifencei are separated
    from i 2.1, users need to add them in the architecture string if they n=
eed
    fence.i and csr instructions.  Besides, we also allow old ISA spec can
    recognize zicsr and zifencei, but we won't output them since they are
    already included in the i extension when i's version is less than 2.1.

So the original commit message of 6df2a016c0c8 was correct at the time
of writing.

As you mentioned, now GCC also brings the "-misa-spec" starting from
GCC 12. This makes things complicated ...

Regards,
Bin
