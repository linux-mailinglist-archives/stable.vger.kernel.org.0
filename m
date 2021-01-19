Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7382FC327
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 23:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbhASWQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 17:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbhASWQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 17:16:35 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFA8C061575
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 14:15:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id s15so11348354plr.9
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 14:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXrBiBJi6Dfh9EHdaa74XDl1OgKypKBU2BA3Zhb7Oio=;
        b=BPS/wTOnGz75i92A1dMKvgYAjl1WfvabQeCxCBiesEFZOBKuNb0RKlOXxWZWuN3lAL
         qMFrwq5d2cy2nA4zhODGMB5PG/sx+BujLtSq7cBLsDxHhsC607cX08dG1y9eIYhKt6jQ
         TYXb2tCvw3Sr20XDsLw/Gv9FKl9mvUV6nwZNy1Q1QVvwKPPTLA4bt954yXZT806s+1Od
         C4UFWkkThXWrs6vfKUyYZLhorrwz+wl7TncueuJwP7DII+uje/qs/YsHrwzJRYaYiRoU
         J7ByC0DMPsHi9a+N3kR4C0CvRpgmdfIw+V4TIDsAuohANSBFkE5YxfYoKglG6QqAAMrO
         TJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXrBiBJi6Dfh9EHdaa74XDl1OgKypKBU2BA3Zhb7Oio=;
        b=Nid+d3zeA80Rs8EuwR4tLiE+nHPyFrBHLD7jV+G/FXKYpQMigx7A+t9aPSxH2bYmdR
         T2R1dLCnZRnY8beAXzJdTSFPuQ3+7c+jysMkW+Uv+MSVjtnPp0OmHK0jwVKBBnjo7iFa
         CwOZNtpnRldHzj+QOAsP1YvDHq8wqf+tD6wqg5sgCqkF4ZbY3CNXMeFTlW3iiLluQOuJ
         YivyQK30uHmEjTbx5pDYJLVSPy1tSVuwjRkr4t+xVQSGjwB3hammeeBSPeL0NWEmBFO7
         ZrLZgmHUl8qCJyD2ICtG89/QE7eBnYDJvTAy6zfqrHVBRxoydG7eBPMainuQENk6jaPu
         ieqQ==
X-Gm-Message-State: AOAM530OlDf/pBaXa6Gvo27fQZ+QFvCxON3WTvNdC2cFwFUYspRvmvar
        pX+jIS3DEqsvfWcizV/Yi6b2urNiZskQzChHPpvUlQ==
X-Google-Smtp-Source: ABdhPJweSr6AxMoV7UjQkfyCrmWN0xQnVlRGevtg7JbSUDmvq6E/SyeXrjiplkXY/nXeZGAHm5sA7IgS3H6RfKbO2BE=
X-Received: by 2002:a17:90a:6ba4:: with SMTP id w33mr2086115pjj.32.1611094554325;
 Tue, 19 Jan 2021 14:15:54 -0800 (PST)
MIME-Version: 1.0
References: <20210118135426.17372-1-will@kernel.org>
In-Reply-To: <20210118135426.17372-1-will@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 19 Jan 2021 14:15:43 -0800
Message-ID: <CAKwvOdmShphZV96PjaHbUW17mKhhRi_X0AZotryKmiGVKyiQyw@mail.gmail.com>
Subject: Re: [STABLE BACKPORT 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise
 minimum version of GCC to 5.1 for arm64
To:     Will Deacon <will@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Caroline Tice <cmtice@google.com>,
        Luis Lozano <llozano@google.com>,
        Stephen Hines <srhines@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 5:54 AM Will Deacon <will@kernel.org> wrote:
>
> commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.
>
> GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
> beyond the stack pointer, resulting in memory corruption if an interrupt
> is taken after the stack pointer has been adjusted but before the
> reference has been executed. This leads to subtle, infrequent data
> corruption such as the EXT4 problems reported by Russell King at the
> link below.
>
> Life is too short for buggy compilers, so raise the minimum GCC version
> required by arm64 to 5.1.
>
> Reported-by: Russell King <linux@armlinux.org.uk>
> Suggested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y and 4.14.y only
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
> Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [will: backport to 4.4.y/4.9.y/4.14.y]

Merging this from stable into "Android Common Kernel" trees that were
built with AOSP GCC 4.9, I expect this to break some builds.  Arnd,
IIRC did you mention that AOSP GCC had picked up a fix?  If so, did
you verify that via disassembly, or gerrit patch file?

(AOSP GCC 4.9: https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/
master branch, roll back a few commits).
It looks like AOSP GCC `#defines __android__ 1`.

I'm not arguing against a backport, just trying to think through how
we'll need to sort this out downstream.  (Revert or patch on top that
checks for __android__, if AOSP GCC does in fact have a fix.)

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  include/linux/compiler-gcc.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index af8b4a879934..3cc8adede67b 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -145,6 +145,12 @@
>
>  #if GCC_VERSION < 30200
>  # error Sorry, your compiler is too old - please upgrade it.
> +#elif defined(CONFIG_ARM64) && GCC_VERSION < 50100
> +/*
> + * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
> + * https://lore.kernel.org/r/20210107111841.GN1551@shell.armlinux.org.uk
> + */
> +# error Sorry, your version of GCC is too old - please use 5.1 or newer.
>  #endif
>
>  #if GCC_VERSION < 30300
> --
> 2.30.0.284.gd98b1dd5eaa7-goog
>


-- 
Thanks,
~Nick Desaulniers
