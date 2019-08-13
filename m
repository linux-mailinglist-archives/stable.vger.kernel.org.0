Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9108C219
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfHMUaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 16:30:08 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37477 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfHMUaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 16:30:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id bj8so2727310plb.4
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 13:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F5S8trRPYjuIcbNg5kis2gShEoMM4aqgAIm4VyEDMzE=;
        b=kXsYcI3oA/IksCzgBdmHse+haoxFudyeL7wih+cArbRbBlH51zGpUCDG/nsZ6x/iGO
         cJ5gfeHdZnVHpJcN+Vu+pVkUTxTZYF3wT9Or8ofcc56WWggnBxCZKNfi8O6V+0KYAFyG
         C7TE2Pm7ZNqF5VAeXPcqoyrRQawwVYsDja+xGZ5QUx91YXYXbft0GfQIsv+rJAcgFegD
         e/e5APQ7QBEBEOmvEJIzoytIgphLLu3OuIoJWtYYNiUoIS73h0u40T3U+ClJxO/xq1KF
         z6fIHpRPg9Dbym3F/hK313HwJNgNd1uBjCX9NIr74mLHJP4OChH2fV/cvO8lSe/gc8d4
         Q21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F5S8trRPYjuIcbNg5kis2gShEoMM4aqgAIm4VyEDMzE=;
        b=TNUyPg++QvEYPeNPSW6KTDdVwAIdUHPzpLAtSM5SS+j1OcxRuEitFTht69denQkXfV
         fszWDXKSGZvW816cqQPc4BRDF2kJeAMWJmG68imxkxCs2pIlOgd+3zye+Mj27tOgo3oK
         4SogZf/1LmKH88H8p/dodUFsPdjXmA17zw8IEyPEAVmu/8yT/iu2lCWsEWHWrRHT1WZz
         gRlISiPHrnUS9+EB+pTm7PTG/hysfz3pI06vmnVzcQVI6IdkXmaVMdkmcLFXjYFfQMSP
         9r1fMf5g6ntPtnBzoko6ysTUM3yzCkw0S8B1t2Hw9plkldu+X1+dM9/10WnRAtV2kWxB
         IGBQ==
X-Gm-Message-State: APjAAAWDgmWFFopuK0CY/3scUgQCs54ogZFdJ1iHu5tv4V1nEYjfTKr4
        xn0ThcGAy1hhvNwLMWDiMWxRQaYL3P1k/8GZYHCk7w==
X-Google-Smtp-Source: APXvYqx5crTrrhwct6kTuv/CE/R8r5hmtTSlL3aNPjo3oZyOp8YJeb3BlU8MvIq+7iQfeY4ftaVFqymIYOHnvpwppS4=
X-Received: by 2002:a17:902:9f93:: with SMTP id g19mr39000596plq.223.1565728206371;
 Tue, 13 Aug 2019 13:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <15657216291284@kroah.com>
In-Reply-To: <15657216291284@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 13 Aug 2019 13:29:55 -0700
Message-ID: <CAKwvOd=GC4NmRFsYFxUDfy4aP1ZXAUZcOnqF7zg26B9rs7yvGQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] x86/purgatory: Use CFLAGS_REMOVE rather
 than reset" failed to apply to 4.9-stable tree
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vaibhav,
What LTS kernel are you basing your distro off of?  IIRC, 4.19, or was
it further back?

On Tue, Aug 13, 2019 at 11:40 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From b059f801a937d164e03b33c1848bb3dca67c0b04 Mon Sep 17 00:00:00 2001
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Wed, 7 Aug 2019 15:15:33 -0700
> Subject: [PATCH] x86/purgatory: Use CFLAGS_REMOVE rather than reset
>  KBUILD_CFLAGS
>
> KBUILD_CFLAGS is very carefully built up in the top level Makefile,
> particularly when cross compiling or using different build tools.
> Resetting KBUILD_CFLAGS via := assignment is an antipattern.
>
> The comment above the reset mentions that -pg is problematic.  Other
> Makefiles use `CFLAGS_REMOVE_file.o = $(CC_FLAGS_FTRACE)` when
> CONFIG_FUNCTION_TRACER is set. Prefer that pattern to wiping out all of
> the important KBUILD_CFLAGS then manually having to re-add them. Seems
> also that __stack_chk_fail references are generated when using
> CONFIG_STACKPROTECTOR or CONFIG_STACKPROTECTOR_STRONG.
>
> Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20190807221539.94583-2-ndesaulniers@google.com
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 91ef244026d2..8901a1f89cf5 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -20,11 +20,34 @@ KCOV_INSTRUMENT := n
>
>  # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
>  # in turn leaves some undefined symbols like __fentry__ in purgatory and not
> -# sure how to relocate those. Like kexec-tools, use custom flags.
> -
> -KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
> -KBUILD_CFLAGS += -m$(BITS)
> -KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
> +# sure how to relocate those.
> +ifdef CONFIG_FUNCTION_TRACER
> +CFLAGS_REMOVE_sha256.o         += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_purgatory.o      += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_string.o         += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_kexec-purgatory.o        += $(CC_FLAGS_FTRACE)
> +endif
> +
> +ifdef CONFIG_STACKPROTECTOR
> +CFLAGS_REMOVE_sha256.o         += -fstack-protector
> +CFLAGS_REMOVE_purgatory.o      += -fstack-protector
> +CFLAGS_REMOVE_string.o         += -fstack-protector
> +CFLAGS_REMOVE_kexec-purgatory.o        += -fstack-protector
> +endif
> +
> +ifdef CONFIG_STACKPROTECTOR_STRONG
> +CFLAGS_REMOVE_sha256.o         += -fstack-protector-strong
> +CFLAGS_REMOVE_purgatory.o      += -fstack-protector-strong
> +CFLAGS_REMOVE_string.o         += -fstack-protector-strong
> +CFLAGS_REMOVE_kexec-purgatory.o        += -fstack-protector-strong
> +endif
> +
> +ifdef CONFIG_RETPOLINE
> +CFLAGS_REMOVE_sha256.o         += $(RETPOLINE_CFLAGS)
> +CFLAGS_REMOVE_purgatory.o      += $(RETPOLINE_CFLAGS)
> +CFLAGS_REMOVE_string.o         += $(RETPOLINE_CFLAGS)
> +CFLAGS_REMOVE_kexec-purgatory.o        += $(RETPOLINE_CFLAGS)
> +endif
>
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>                 $(call if_changed,ld)
>


-- 
Thanks,
~Nick Desaulniers
