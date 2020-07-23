Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CC522A6AA
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgGWEpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWEpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:45:20 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CF0C0619DC;
        Wed, 22 Jul 2020 21:45:19 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id t131so4948154iod.3;
        Wed, 22 Jul 2020 21:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=90gci2CYuVeFvRuDOKJ8IZ7wmWfckk95B8pyfbNrP8I=;
        b=rT2onajDa5xZgllpEdCVeQNMCJ0bPaBbZB+eGVBLuQyicYUG44Bd/yFs0Es37OLPvg
         4Yi1DqMudJEawaTnwtHpqcZD/55vtFbxEzOURogn3VR+TGVm80Pt9gZtXmagSfq4yE9Z
         NgPA4b8nSZRS/bLK0rYPFJ2JFaxR307EvV2WT2zKjpnkOz4MFAENe/5HPWnGgPgGnzqH
         tlk+nIX9h8DQE/S0BB6Qy5XK35Kg5Y54ure6vRddBPPLAYA1lGiwOOmZSD4nLoeI2X1l
         tbWgdBpTJq2ugYlGE5SURW2mWptIugxLyzxSgk6WDIPWqCrubfsXsfalZSi5BsTCTSR4
         Djqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=90gci2CYuVeFvRuDOKJ8IZ7wmWfckk95B8pyfbNrP8I=;
        b=eg1PalA3ePqJJ9SniOhda0dlW5noqLfDZxs5AWeL2EoKCqkLAq8rEYGU8woU3yTPs8
         meFCOYNrPdAth0nbiR1j9uA5Ui6FsgI5NvXHxb5nWFR2lERJ1vG5HUtZmiuhv5I8I/wd
         xiSRxC5xjQVfzC6GeBoIEx1jnenL6fnfR5rb4ZMAcnKmankAwCdZFcKHjWIWIWssUeHI
         9OUWU/rF5DdLV5sn6yYDPa3JyGGNBxIB4gJEwJB03sKOVXlUW7ekdXtxamn17i32Ay9K
         XW9WObynTe1+S8Ia2dedMdKx5B42Dqz0Z+66lw14IsfN54tZRlMq7nojtOj96BKmS7ox
         Q+HQ==
X-Gm-Message-State: AOAM531rLOAmBLP4hlMpDii68j6lYK8I/BaK/M0TVImt+bFakwgEmjF7
        tbe+Io6lswWYNQl+sgxx3XvUW4X4j4WBhJBKBxQ=
X-Google-Smtp-Source: ABdhPJwELqlE6SY7KfgT4pn5Pqo+42cuA1/MPW/qJs0A5ybLi3p+cfBPZSB5yUzWNHekkQfPf6TaBeExb76QXJ/3YBw=
X-Received: by 2002:a02:9469:: with SMTP id a96mr4168jai.121.1595479519517;
 Wed, 22 Jul 2020 21:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200723041509.400450-1-natechancellor@gmail.com>
In-Reply-To: <20200723041509.400450-1-natechancellor@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 23 Jul 2020 06:45:07 +0200
Message-ID: <CA+icZUVUSnC9F5RKzRLV50CU8SwortEFGH5f2LHTu=UQx8dT8g@mail.gmail.com>
Subject: Re: [PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions
 of clang
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 6:15 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Newer versions of clang only look for $(COMPAT_GCC_TOOLCHAIN_DIR)as [1],
> rather than $(COMPAT_GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE_COMPAT)as,
> resulting in the following build error:
>
> $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> CROSS_COMPILE_COMPAT=arm-linux-gnueabi- LLVM=1 O=out/aarch64 distclean \
> defconfig arch/arm64/kernel/vdso32/
> ...
> /home/nathan/cbl/toolchains/llvm-binutils/bin/as: unrecognized option '-EL'
> clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
> make[3]: *** [arch/arm64/kernel/vdso32/Makefile:181: arch/arm64/kernel/vdso32/note.o] Error 1
> ...
>
> Adding the value of CROSS_COMPILE_COMPAT (adding notdir to account for a
> full path for CROSS_COMPILE_COMPAT) fixes this issue, which matches the
> solution done for the main Makefile [2].
>

[ CC Masahiro ]

Masahiro added a slightly adapted version of [2] in <kbuild.git#fixes>.
Shall this go through kbuild subsystem or folded into [1]?

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/commit/?h=fixes&id=ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51

> [1]: https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90
> [2]: https://lore.kernel.org/lkml/20200721173125.1273884-1-maskray@google.com/
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  arch/arm64/kernel/vdso32/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
> index d88148bef6b0..5139a5f19256 100644
> --- a/arch/arm64/kernel/vdso32/Makefile
> +++ b/arch/arm64/kernel/vdso32/Makefile
> @@ -14,7 +14,7 @@ COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
>  COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
>
>  CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
> -CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)
> +CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
>  CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
>  ifneq ($(COMPAT_GCC_TOOLCHAIN),)
>  CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)
>
> base-commit: d15be546031cf65a0fc34879beca02fd90fe7ac7
> --
> 2.28.0.rc1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200723041509.400450-1-natechancellor%40gmail.com.
