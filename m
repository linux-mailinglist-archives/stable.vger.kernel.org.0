Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87F16B4A0D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbjCJPR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbjCJPRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:17:41 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F87116BBD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:54 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id d6so3229718pgu.2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678460880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6wmqhbkcFZ9XLdQhS5fIYDEJwGeWKkLiEBNj07i144=;
        b=b/p2hZpaxx/bEWvgbBt/gpsw3wcrQuP2fT3hKuXwE9NSW2tpdNzGPvtvfMUm60F/fX
         KAFYv38lzRXSvZCmmab8CCAF87wQUnmaULE7Bft/CeoZMFIuPb6uIOXvtLx1Oa7sDfDp
         qSt30S8Abo/GVudrtG4ek3B6U/LVERM4Jjzf7YFwPmTg2CH5KG/aTrg1nPh/yGNkQ2ox
         BIIbxXwDipaUOfVRjNcNDl/kFIvVmpusjV/QRQSQt5M0ZProtBnfI0mZJXcaFrS5R8UV
         JtjYtg0+Hz3A34OBWe7IUadwbqKi1aLKcKKhP1M1vKOWfu8THWtB0k5UnAedAHRnTEVr
         oM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6wmqhbkcFZ9XLdQhS5fIYDEJwGeWKkLiEBNj07i144=;
        b=Ldbh9P95R+PrekVyJn8U/lX3j3j8OYIsZgEJz5fHjA8M+dgFazpqaf3brrwOdWKI45
         vxSMyDIbIHAAuPdi1TjdBcOrEHYr5tkjr2r4MUtk3aoIo4DZ+zJcVW6+NHMKyDg0h4wY
         M6aooXETCfqLOXkHQZO8m5FiSildBzBbYj86ZbhzVJ04OQw3qIHwyDF9neOYBFziDdRM
         JlB9G+pxCimQOdDykUvXWbJbuXkxStme4BZ4+bp/P7O/ks0K34/klSuBY00cqXLjoIjo
         5uNj3oWQKJS9uA7guu1Kb8pX/qLHxDwTcdHELKrgGlCE9x2WqIT4oENav/0gLNAQjmHr
         LTng==
X-Gm-Message-State: AO0yUKVKc8K47irAGW6cYcPKJHA+lhxVQyqRGCzs2ZjYl8+/mX8/c6kQ
        VewUAvzOUXhESJoqew2XYe/HuBZyx0Y=
X-Google-Smtp-Source: AK7set+i7uLoqEXLcdw6kfCBDyOMGpkkThKx3Rmjmh50VMUNitPfLxe8TejzJh85BT0BVaMC8VGhnA==
X-Received: by 2002:aa7:9485:0:b0:600:cc40:2589 with SMTP id z5-20020aa79485000000b00600cc402589mr22160328pfk.3.1678460880450;
        Fri, 10 Mar 2023 07:08:00 -0800 (PST)
Received: from ubuntu.. (144.168.56.201.16clouds.com. [144.168.56.201])
        by smtp.gmail.com with ESMTPSA id j9-20020aa79289000000b0058db8f8bce8sm1533758pfa.166.2023.03.10.07.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:07:59 -0800 (PST)
From:   Bin Meng <bmeng.cn@gmail.com>
To:     conor@kernel.org
Cc:     aurelien@aurel32.net, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Date:   Fri, 10 Mar 2023 23:07:54 +0800
Message-Id: <20230310150754.535425-1-bmeng.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308220842.1231003-1-conor@kernel.org>
References: <20230308220842.1231003-1-conor@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Conor Dooley <conor.dooley@microchip.com>
> 
> The spec folk, in their infinite wisdom, moved both control and status
> registers & the FENCE.I instructions out of the I extension into their
> own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
> spec [0].
> The GCC/binutils crew decided [1] to move their default version of the
> ISA spec to the 20191213 version of the ISA spec, which came into being
> for version 2.38 of binutils and GCC 12. Building with this toolchain
> configuration would result in assembler issues:
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binutils
> 2.38") by Aurelien Jarno, but has proven fragile.
> 
> Before LLVM 17, LLVM did not support these extensions and, as such, the
> cc-option check added by Aurelien worked. Since commit 22e199e6afb1
> ("[RISCV] Accept zicsr and zifencei command line options") however, LLVM
> *does* support them and the cc-option check passes.
> 
> This surfaced as a problem while building the 5.10 stable kernel using
> the default Tuxmake Debian image [2], as 5.10 did not yet support ld.lld,
> and uses the Debian provided binutils 2.35.
> Versions of ld prior to 2.38 will refuse to link if they encounter
> unknown ISA extensions, and unfortunately Zifencei is not supported by
> bintuils 2.35.
> 
> Instead of dancing around with adding these extensions to march, as we
> currently do, Palmer suggested locking GCC builds to the same version of
> the ISA spec that is used by LLVM. As far as I can tell, that is 2.2,
> with, apparently [3], a lack of interest in implementing a flag like
> GCC's -misa-spec at present.
> 
> Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS when
> GCC is used & remove the march dance.
> 
> As clang does not accept this argument, I had expected to encounter
> issues with the assembler, as neither zicsr nor zifencei are present in
> the ISA string and the spec version *should* be defaulting to a version
> that requires them to be present. The build passed however and the
> resulting kernel worked perfectly fine for me on a PolarFire SoC...
> 
> Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf [0]
> Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1ZeHHCYf4 [1]
> Link: https://lore.kernel.org/all/CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-version-misa-spec-gcc-flag-equivalent/66935 [3]
> CC: stable@vger.kernel.org
> Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
> I think Aurelien's original commit message might actually not be quite
> correct? I found, in my limited testing, that it is not the default
> behaviour of gas that matters, but rather the toolchain itself?
> My binutils versions (both those built using the clang-built-linux
> tc-build scripts which do not set an ISA spec version, and one built
> using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec version
> set) do not encounter these issues.

I am unable to reproduce the build failure as reported by commit 6df2a016c0c8
("riscv: fix build with binutils 2.38") by Aurelien Jarno using kernel.org
pre-built GCC 11.3.0 [1] which includes binutils 2.38.

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz

The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17) builds fine
for me. Anything I am missing?

> >From *my* testing, I was only able to reproduce the above build failures
> because of *GCC* defaulting to a newer ISA spec version, and saw no
> issues with CC=clang builds, where -misa-spec is not (AFAICT) passed to
> gas.
> I'm far from a toolchain person, so I am very very happy to have the
> reason for that explained to me, as I've been scratching my head about
> it all evening.
> 
> I'm also not super confident in my "as-option"ing, but it worked for me,
> so it's gotta be perfect, right? riiight??
> 
> Changes from v1:
> - entirely new approach to the issue
> ---
>  arch/riscv/Makefile | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 6203c3378922..2df7a5dc071c 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -57,10 +57,8 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
>  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
>  
> -# Newer binutils versions default to ISA spec version 20191213 which moves some
> -# instructions from the I extension to the Zicsr and Zifencei extensions.
> -toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> -riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> +KBUILD_CFLAGS += $(call cc-option,-misa-spec=2.2)
> +KBUILD_AFLAGS += $(call as-option,-Wa$(comma)-misa-spec=2.2)
>  
>  # Check if the toolchain supports Zihintpause extension
>  riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
> -- 
