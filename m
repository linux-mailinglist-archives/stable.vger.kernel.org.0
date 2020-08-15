Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F0F2452A7
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHOVyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbgHOVwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:36 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF7CC09B054;
        Sat, 15 Aug 2020 08:49:19 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id z11so2544866oon.5;
        Sat, 15 Aug 2020 08:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=CcdQzl9In/9cdITxocrz0vM3bfLjK73C35i7BkxY8gM=;
        b=Vlkrhu7XE01MxBsrAacNDdYsgy7DOQJxJEKTLz4ony4WzKDui3OeAofloeVgkW3GlA
         XkpULxbqd6+qu24KAR/8K3wK4uuBXOMcPegijHUdtu8UaQTIgnb6CaDMczPRQH4uikaK
         uA9oyRnFj/XN5+dnuUHLZp1ySFHoDaCTknCaBH1o3lPTQiV+aORMTCG25/Iv7tTVkgEN
         xrylHIrpzjxxzqO+zMGhlUlvS80mjcq24eyqaOYeK2Useweb7qoYFddTnX6ibGTGrY7d
         UJ13HzAUQqN82UPJPdK2i1lPD8Rl18nKbcGOm0f8bvgSt/Ejd/nEChzaTe8Twg+sWOtV
         +rlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=CcdQzl9In/9cdITxocrz0vM3bfLjK73C35i7BkxY8gM=;
        b=LGEor5ulV5POlc9KGqEnmiyoJmwZ6tD8XfskpbLpugvENtQYNvsiGQ+OPyDIYuRF75
         4EwWOU0nfdBoIHFucvdznbFoQg4lY0rgwUzYQ9SAoO2CdOhhFvJcSpKCymVUZkHUPGND
         2bD7+z1IM/Ebtw1GQiiZVQ5IsKomvAiNwn3DktVZH0trAKYcde6C810zw6jc8wzpcKSB
         QfZoRiFNJBZXJZop685ZVzuBAf/iYunlVJ2mLoEpq/c8yq25DJXtj0HjqYweKUFU8OeQ
         rIJAAkcwiShd6gM1TbXZIqcdycR5CShTgsSxM5sDuJwpvctdkzwsSbnclL339GhbRbcV
         IeTw==
X-Gm-Message-State: AOAM533qV4ksuxlzb6yhwb2reP/h02klj9nFF1f2FLKOwd7zZzMAu0ml
        ttOiCjPZiGu0zua0yVN6kUd5qwqc7vPX3fbHk6s=
X-Google-Smtp-Source: ABdhPJz6FH8NPvgBQM4D3K801uDf1shBf80hvVksADf7wBd8t2UhIq2MzDrivyIHy2KNAla6O/Z9UjpiKj3IffF6XP4=
X-Received: by 2002:a4a:7b4b:: with SMTP id l72mr5516085ooc.74.1597506554603;
 Sat, 15 Aug 2020 08:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200812004158.GA1447296@rani.riverdale.lan> <20200812004308.1448603-1-nivedita@alum.mit.edu>
In-Reply-To: <20200812004308.1448603-1-nivedita@alum.mit.edu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 15 Aug 2020 17:49:03 +0200
Message-ID: <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 2:43 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> The x86-64 psABI [0] specifies special relocation types
> (R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
> Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
> can take advantage of for optimization (relaxation) at link time. This
> is supported by LLD and binutils versions 2.26 onwards.
>
> The compressed kernel is position-independent code, however, when using
> LLD or binutils versions before 2.27, it must be linked without the -pie
> option. In this case, the linker may optimize certain instructions into
> a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.
>
> This potential issue has been present with LLD and binutils-2.26 for a
> long time, but it has never manifested itself before now:
> - LLD and binutils-2.26 only relax
>         movq    foo@GOTPCREL(%rip), %reg
>   to
>         leaq    foo(%rip), %reg
>   which is still position-independent, rather than
>         mov     $foo, %reg
>   which is permitted by the psABI when -pie is not enabled.
> - gcc happens to only generate GOTPCREL relocations on mov instructions.
> - clang does generate GOTPCREL relocations on non-mov instructions, but
>   when building the compressed kernel, it uses its integrated assembler
>   (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
>   which has so far defaulted to not generating the GOTPCRELX
>   relocations.
>
> Nick Desaulniers reports [1,2]:
>   A recent change [3] to a default value of configuration variable
>   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
>   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
>   relocations. LLD will relax instructions with these relocations based
>   on whether the image is being linked as position independent or not.
>   When not, then LLD will relax these instructions to use absolute
>   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
>   Clang and linked with LLD to fail to boot.
>
> Patch series [4] is a solution to allow the compressed kernel to be
> linked with -pie unconditionally, but even if merged is unlikely to be
> backported. As a simple solution that can be applied to stable as well,
> prevent the assembler from generating the relaxed relocation types using
> the -mrelax-relocations=no option. For ease of backporting, do this
> unconditionally.
>
> [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Thanks for the patch.

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/1120#issuecomment-674409705

> ---
>  arch/x86/boot/compressed/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 3962f592633d..ff7894f39e0e 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
>  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
>  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> +# Disable relocation relaxation in case the link is not PIE.
> +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
>
>  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n
> --
> 2.26.2
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200812004308.1448603-1-nivedita%40alum.mit.edu.
