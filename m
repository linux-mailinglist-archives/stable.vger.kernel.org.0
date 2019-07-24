Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC0A74255
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 01:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGXXt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 19:49:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41174 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfGXXt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 19:49:29 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so89193384ioj.8
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 16:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJ1aMEs74UNhuCKOoREVlxCR5HtwdPtwGYYolQWtluU=;
        b=JE6IcczQ5f/hbM3+uOk5DeF3km0i6S1v2qMN2hLOmzWuIMvRmmkzxoUyYuIRqOqJcj
         4n9clhqmquxRucZo683IIpTaTRlqTT2vpQC3jw0mNe3WuL/gdTVK5AY1fFm4NDN36ggu
         DOwapZjU5ow4QNQkazEqvMBksYoS88ckhmbKFzPFmJpLJ4dWSKmg1+LnaSBHEEBQApYa
         4yXdBCL+OiNRV6A5YFSJuAhNnWWPW3q3JeoHeKx6VarHPJR2PvjOjs6K4mUh+NzH7+cX
         f+cub60d8J0eSSbBy7u+mUwCPgeuB+IHJUH5/N62c3EdssLAXUegH/t5Gs2fP2T1ZGWO
         yG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJ1aMEs74UNhuCKOoREVlxCR5HtwdPtwGYYolQWtluU=;
        b=KcnclEOYLZN879XWj/oRmD0GyE3ixFjjgZlcqhrPWhLRj2IM3yavtWRpuIaChawsIs
         Z343zHncpU1MH/TQCvllPwQn1aCRHMVeCD20EXQVJmTBSzuqv/d3nz+bcsLDSsMCyM81
         mh9SxBPZVs9SfarIWJfXP7GZjhUKE012FTXB1jc9FwHYV7hSITjj21UMyfra4iHucDip
         cnpTwElfDwxzE9eMrlWIeuaPhFkBLrVdgQ2g0snza/CkcC6zIRCAFCD6QkU2ne4GHAR+
         7Di273OC571RDu0NUYZTZPz1maiIO3T9nB6nLwhkl3d2TyWJ/0lDUqEe4+M4atEnVj1Z
         MoRQ==
X-Gm-Message-State: APjAAAWTVbJO+blVlGl1KR6hZwOSxVyQGbyTkSSYlXunn96/OCGpyViN
        KCDiXV+CeD22CtRkomEgX51DlA5DxYG7TuD3EeCX8Q==
X-Google-Smtp-Source: APXvYqy1+fcxQkXA20RVRVcjJIYV7Fvs9RqiUJH7cbfv7SCurHmz51LfgVrIsY7cjoftF3TVV2MeQjq9H0cY1ggRSrk=
X-Received: by 2002:a5d:8b52:: with SMTP id c18mr14203913iot.89.1564012167930;
 Wed, 24 Jul 2019 16:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190723212418.36379-1-ndesaulniers@google.com> <20190723212418.36379-2-ndesaulniers@google.com>
In-Reply-To: <20190723212418.36379-2-ndesaulniers@google.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Wed, 24 Jul 2019 16:49:16 -0700
Message-ID: <CAMVonLggcXdcScZSi3ZXZUyRnkHGK7Jv5sED43hHpGmXnKQfWA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] x86/purgatory: use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        yamada.masahiro@socionext.com, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 2:24 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
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
> Cc: stable@vger.kernel.org
> Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Alternatively, we could put these in all in one variable and remove it
> without any conditional checks (I think that's ok to do so with
> CFLAGS_REMOVE).
>
> Changes v2 -> v3:
> * Prefer $(CC_FLAGS_FTRACE) which is exported to -pg.
> * Also check CONFIG_STACKPROTECTOR and CONFIG_STACKPROTECTOR_STRONG.
> * Cc stable.
> Changes v1 -> v2:
> Rather than manually add -mno-sse, -mno-mmx, -mno-sse2, prefer to filter
> -pg flags.
>
>  arch/x86/purgatory/Makefile | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 91ef244026d2..6ef0ced59b9c 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -20,11 +20,27 @@ KCOV_INSTRUMENT := n
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
> +CFLAGS_REMOVE_sha256.o += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_purgatory.o += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_string.o += $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_kexec-purgatory.o += $(CC_FLAGS_FTRACE)
> +endif
> +
> +ifdef CONFIG_STACKPROTECTOR
> +CFLAGS_REMOVE_sha256.o += -fstack-protector
> +CFLAGS_REMOVE_purgatory.o += -fstack-protector
> +CFLAGS_REMOVE_string.o += -fstack-protector
> +CFLAGS_REMOVE_kexec-purgatory.o += -fstack-protector
> +endif
> +
> +ifdef CONFIG_STACKPROTECTOR_STRONG
> +CFLAGS_REMOVE_sha256.o += -fstack-protector-strong
> +CFLAGS_REMOVE_purgatory.o += -fstack-protector-strong
> +CFLAGS_REMOVE_string.o += -fstack-protector-strong
> +CFLAGS_REMOVE_kexec-purgatory.o += -fstack-protector-strong
> +endif
>
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>                 $(call if_changed,ld)
> --
> 2.22.0.709.g102302147b-goog
>

Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>

I tested the v3 patch series with clang compiled kernel for below
scenarios:

1. kexec'ing into a new kernel.
2. Purposely crashing the running kernel to generate kdump logs.

Thanks,
Vaibhav
