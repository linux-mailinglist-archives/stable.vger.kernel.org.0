Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB47E22A6B7
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGWEvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWEvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:51:48 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBD1C0619DC;
        Wed, 22 Jul 2020 21:51:47 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j187so4230109qke.11;
        Wed, 22 Jul 2020 21:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rvBqlrD6Q5JTwbMgKl8jawCIv/MTpPv1KCBt3CoZeTM=;
        b=HKRkrUiadqCQpRQAGoSpWNnIs/79cjxNlrPLzZa/0GT+6fBv72T8n+fmRX3DI1qnrm
         quRYaXS0+//Mb1Lo2deBoa5O/9fbsa2lNs5ni8m2mijtMcl7tFaMDUKSO2aq2f9S57Ur
         35EM4mu/Bta3CREb/UL/BZW17OS/QhglkG9IrbKpPHXZawuc5Tbq4RFejYJ3cOZO/JMx
         DHi2e9EYFaIbCCKyQ3x+w05T3eh9xmsEYVVknAAB3OUda0xPXrsysLwikAtUodnuGq52
         L6LMB2cWrFnzcxUqSRZBheBpVouWcCS7sEG0WPrfWaglx35lbs+NimZYpLmP3cgHdatJ
         srxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rvBqlrD6Q5JTwbMgKl8jawCIv/MTpPv1KCBt3CoZeTM=;
        b=drHgW1NFtRJ+rSElwQJ0Ve1+9D/I/SmUsPzdiJgXNc0t0TAgBAMBXO3gXcJ6VFFKO9
         QfyoJxnkicaG8tHso1grcQ9ITVIFDV8oAwXACUT88KAlr/x/TytQhguctd2v8AARJ0pv
         pTti3Y/qZUqaX5Fsf4zJ0qXZT7+Uaz/RodyppDKdXmahF1mYs1kxzX/BhE7hGONoUnpQ
         JYuWra4DKTv60KgKlQaIIK5OTmBSdab5AxBJDNc7tOm9UUsGKFeCND06a0+iQRKOPrPJ
         chplQDMnNn31lbVplPRCQ7FuiCSQfFbSGJZRJSTX0SQVPddq/+HkJrDiqLshGXja8B6+
         2wKg==
X-Gm-Message-State: AOAM532S1FDISji8MhqZBBts2py1FD/hLUzwPftQFQ5gz+kP6bYJKsUr
        y6wYGlYOGyQZzZS1LB7EN6E=
X-Google-Smtp-Source: ABdhPJx4rMLPck1N4oRfXFt5qqyyV0LGK9ZQpqF35qb6srTX45zfer2/xaZe0T01AiEYXIVr9W4n+A==
X-Received: by 2002:a37:9bca:: with SMTP id d193mr511954qke.131.1595479907011;
        Wed, 22 Jul 2020 21:51:47 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id f130sm1677053qke.99.2020.07.22.21.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 21:51:46 -0700 (PDT)
Date:   Wed, 22 Jul 2020 21:51:45 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions
 of clang
Message-ID: <20200723045145.GA448242@ubuntu-n2-xlarge-x86>
References: <20200723041509.400450-1-natechancellor@gmail.com>
 <CA+icZUVUSnC9F5RKzRLV50CU8SwortEFGH5f2LHTu=UQx8dT8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVUSnC9F5RKzRLV50CU8SwortEFGH5f2LHTu=UQx8dT8g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 06:45:07AM +0200, Sedat Dilek wrote:
> On Thu, Jul 23, 2020 at 6:15 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Newer versions of clang only look for $(COMPAT_GCC_TOOLCHAIN_DIR)as [1],
> > rather than $(COMPAT_GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE_COMPAT)as,
> > resulting in the following build error:
> >
> > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > CROSS_COMPILE_COMPAT=arm-linux-gnueabi- LLVM=1 O=out/aarch64 distclean \
> > defconfig arch/arm64/kernel/vdso32/
> > ...
> > /home/nathan/cbl/toolchains/llvm-binutils/bin/as: unrecognized option '-EL'
> > clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
> > make[3]: *** [arch/arm64/kernel/vdso32/Makefile:181: arch/arm64/kernel/vdso32/note.o] Error 1
> > ...
> >
> > Adding the value of CROSS_COMPILE_COMPAT (adding notdir to account for a
> > full path for CROSS_COMPILE_COMPAT) fixes this issue, which matches the
> > solution done for the main Makefile [2].
> >
> 
> [ CC Masahiro ]
> 
> Masahiro added a slightly adapted version of [2] in <kbuild.git#fixes>.
> Shall this go through kbuild subsystem or folded into [1]?
> 
> - Sedat -
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/commit/?h=fixes&id=ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51

Sorry, should have cc'd Masahiro, slipped my mind.

Note, I kept this separate as the patches have to go back different
distances; only 5.7 has working clang support for vdso32, see
commit a5d442f50a41 ("arm64: vdso32: Enable Clang Compilation") in
Linus' tree, which appeared in 5.7-rc1 so this only needs to go into
linux-5.7.y. The main patch needs to back all the way to 4.4 so we would
need to drop this hunk when backporting, which would be annoying, as the
main patch backports cleanly to 4.9.

It could be routed via the kbuild tree but the arm64 maintainers are
pretty good at getting these fixes into the hands of Linus so I see no
reason to go around them.

Cheers,
Nathan

> > [1]: https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90
> > [2]: https://lore.kernel.org/lkml/20200721173125.1273884-1-maskray@google.com/
> >
> > Cc: stable@vger.kernel.org
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  arch/arm64/kernel/vdso32/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
> > index d88148bef6b0..5139a5f19256 100644
> > --- a/arch/arm64/kernel/vdso32/Makefile
> > +++ b/arch/arm64/kernel/vdso32/Makefile
> > @@ -14,7 +14,7 @@ COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
> >  COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
> >
> >  CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
> > -CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)
> > +CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
> >  CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
> >  ifneq ($(COMPAT_GCC_TOOLCHAIN),)
> >  CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)
> >
> > base-commit: d15be546031cf65a0fc34879beca02fd90fe7ac7
> > --
> > 2.28.0.rc1
> >
> > --
> > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200723041509.400450-1-natechancellor%40gmail.com.
