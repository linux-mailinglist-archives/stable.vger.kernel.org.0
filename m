Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C583422A6BD
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgGWEzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWEzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:55:37 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D74AC0619DC;
        Wed, 22 Jul 2020 21:55:37 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id t131so4962544iod.3;
        Wed, 22 Jul 2020 21:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=9zEAOSiaWo87pEOphY61gvGs/JjkhFbMIfi5ABUGzWw=;
        b=WGtj4Y5kJzmpHHK0Iw1hC4SWsQxMJO+kdGfqc2CZ1JXxArziWRfJNjhjIq+s3CqLbm
         TwQlsoV1+AWikVkaUeCmZtkIKzs4YUuvnwmxQqJRh6An2Lxlw2ujCw5+p0ZrBBgR9R7G
         kigxyKkpThz9U+WjV/h1T3RDWfJoUNxPmG1blbfjygCwjWe9WhLTY3xXMNrXSkER+CNA
         R1CabZZjW6jqaEl2L2VGDLCgxKOFYHmKLc0i5wNJSmU1syDl185C8t10IBkJ1WaVxiBi
         jIoNs7rmlvymgZ4ftpT/3jfYKRuhW3yntGL8fcBsjTLaqEoc0ezOskYt/B1S7o36jeQ9
         1LHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=9zEAOSiaWo87pEOphY61gvGs/JjkhFbMIfi5ABUGzWw=;
        b=KXbCKYgniguHcabpEgfXLFeOhP+KsiDLCmm6LPBbFUTc/Q5karwQ1qgONhQHayh59H
         4/lSrUuknu4/Q6lYLYRI07z3V3VYBvWr54PCbGzp9lsDTEXslMmOK0UJunLAwvc9qVHp
         zCm4qfKUlg1Zuk30zfvMNQ+Fms3acRkyRj6gqe4PjcdvbGB/FdzDFl4UC+3QCER0QOy0
         rEIlyX26OUAilyglk4fSzqUv5UjgQD3wGg5vdpXBlQSUFOfQfVDReNGy54Fq73+gBxrN
         9VqmQ19KPpE7HRsF2pifdsQBLd3CZNbgonSfAsJUw5UjoFxnukhbB6GKrJfPymaOVcMs
         lQ5w==
X-Gm-Message-State: AOAM530NtPrvGhO5yHowQBJ5OFiTQtNgBqHepNSyUAyQg6ccXixNtm6w
        +Zyb4b2n0n/0T7mSIUAgdhvXy7eyoePjONIw1wQ=
X-Google-Smtp-Source: ABdhPJy4z/uC9McqJCIkcLAG9o7Yy0ItmWLFR4Lg5zsXZsHsiNsx3zbjEJBOE5tTKiqpix/UMTHQi4VQl1eAG+bC9aQ=
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr862526iof.70.1595480136862;
 Wed, 22 Jul 2020 21:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200723041509.400450-1-natechancellor@gmail.com>
 <CA+icZUVUSnC9F5RKzRLV50CU8SwortEFGH5f2LHTu=UQx8dT8g@mail.gmail.com> <20200723045145.GA448242@ubuntu-n2-xlarge-x86>
In-Reply-To: <20200723045145.GA448242@ubuntu-n2-xlarge-x86>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 23 Jul 2020 06:55:25 +0200
Message-ID: <CA+icZUUOjYoCoEYyRzBdMoh_Fh4DszWoNhpmapqgYOAt8wHO-g@mail.gmail.com>
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

On Thu, Jul 23, 2020 at 6:51 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, Jul 23, 2020 at 06:45:07AM +0200, Sedat Dilek wrote:
> > On Thu, Jul 23, 2020 at 6:15 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > Newer versions of clang only look for $(COMPAT_GCC_TOOLCHAIN_DIR)as [1],
> > > rather than $(COMPAT_GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE_COMPAT)as,
> > > resulting in the following build error:
> > >
> > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > CROSS_COMPILE_COMPAT=arm-linux-gnueabi- LLVM=1 O=out/aarch64 distclean \
> > > defconfig arch/arm64/kernel/vdso32/
> > > ...
> > > /home/nathan/cbl/toolchains/llvm-binutils/bin/as: unrecognized option '-EL'
> > > clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
> > > make[3]: *** [arch/arm64/kernel/vdso32/Makefile:181: arch/arm64/kernel/vdso32/note.o] Error 1
> > > ...
> > >
> > > Adding the value of CROSS_COMPILE_COMPAT (adding notdir to account for a
> > > full path for CROSS_COMPILE_COMPAT) fixes this issue, which matches the
> > > solution done for the main Makefile [2].
> > >
> >
> > [ CC Masahiro ]
> >
> > Masahiro added a slightly adapted version of [2] in <kbuild.git#fixes>.
> > Shall this go through kbuild subsystem or folded into [1]?
> >
> > - Sedat -
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/commit/?h=fixes&id=ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51
>
> Sorry, should have cc'd Masahiro, slipped my mind.
>
> Note, I kept this separate as the patches have to go back different
> distances; only 5.7 has working clang support for vdso32, see
> commit a5d442f50a41 ("arm64: vdso32: Enable Clang Compilation") in
> Linus' tree, which appeared in 5.7-rc1 so this only needs to go into
> linux-5.7.y. The main patch needs to back all the way to 4.4 so we would
> need to drop this hunk when backporting, which would be annoying, as the
> main patch backports cleanly to 4.9.
>

Clarify your patch by adding...?

Cc: stable@vger.kernel.org # 5.7

> It could be routed via the kbuild tree but the arm64 maintainers are
> pretty good at getting these fixes into the hands of Linus so I see no
> reason to go around them.
>

As you and arm64 maintainers prefer.

- Sedat -

> Cheers,
> Nathan
>
> > > [1]: https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90
> > > [2]: https://lore.kernel.org/lkml/20200721173125.1273884-1-maskray@google.com/
> > >
> > > Cc: stable@vger.kernel.org
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  arch/arm64/kernel/vdso32/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
> > > index d88148bef6b0..5139a5f19256 100644
> > > --- a/arch/arm64/kernel/vdso32/Makefile
> > > +++ b/arch/arm64/kernel/vdso32/Makefile
> > > @@ -14,7 +14,7 @@ COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
> > >  COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
> > >
> > >  CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
> > > -CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)
> > > +CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
> > >  CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
> > >  ifneq ($(COMPAT_GCC_TOOLCHAIN),)
> > >  CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)
> > >
> > > base-commit: d15be546031cf65a0fc34879beca02fd90fe7ac7
> > > --
> > > 2.28.0.rc1
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200723041509.400450-1-natechancellor%40gmail.com.
