Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D29C269D40
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 06:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgIOEWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 00:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgIOEWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 00:22:37 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628B2C06174A;
        Mon, 14 Sep 2020 21:22:37 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v54so2218403qtj.7;
        Mon, 14 Sep 2020 21:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvCpaWoKl3y2G34oeLNnfPa7Fz736trZYpBdRyWF9i8=;
        b=LngxjjfDPrOlJfXqYYh4WhSQl5B5mZ1YqcI7LFSdhb8cl4ismbWIH30hiFPk3dE3Eo
         ldA+hfAmuzEFVbfmV/C7FQk5bv3d6FuVjdjFofUTfJyXJuBt7AQX+4eoWoSBcJThvkMO
         ZL3VSX7L173IJVjvaog1KCwHuP0UVAc82iLBE/cO1Ph0n4E7auJ90ECRg0451DxKdLDd
         DEDUjXykbedQya734Un/uY+tDRP6UrMIYSJ6IEVVvrmLQrZUmz77yk3cau7JQbUXNoMa
         4HjFC0BPY83V3BEF29MVU+RsWCTvH2c5uC0lcPpEMD5BRCkxRqCApUFte7g7eBG48hca
         Y5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvCpaWoKl3y2G34oeLNnfPa7Fz736trZYpBdRyWF9i8=;
        b=WgAgc4BnylK4cZMai7Mb633s5bESk1vhU2VjRHO0JO05soSSyq3+W+k2FutCkcFlcP
         JZ2dRCPeErhfUoN8MeUSsT3hkM1HrD1y8y7oJlza0JYSsQL7rrMooc1603BqDXf5f+0F
         I+UXr0/tLPSCPHU3jzDAnCH1luwbA6jkGsKBEKgCoyT4m1geQGBGdqVEUiST0RkeimIx
         S9pn4226cYlGCdhnfZc7B+duyLvS8W45PJBjnCKERLw7WPvEHUe2EHS6j7NExnUxw4U1
         pKooRzv5rHHPX6FvN8ZZqvTEGfRqgtKeD4tNqXp7Y0JPc0kV32v8K7oVtxxg0UywLZmg
         bj/g==
X-Gm-Message-State: AOAM530Sn4S19r7Tys/PR0GmTF9sQL2AOBIP/5ifF7W4JiNDmljm8U5e
        S1baML8kMymb1K3lM9+RtfM=
X-Google-Smtp-Source: ABdhPJz4bfs9/+ONXJ1VQ6YvzTdoWKSnoNzoKQ723kW8RplJdRZl9qTCJi/dGvPt6h4913anqPG1ug==
X-Received: by 2002:ac8:5d43:: with SMTP id g3mr4191287qtx.295.1600143756335;
        Mon, 14 Sep 2020 21:22:36 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id u66sm17422235qka.136.2020.09.14.21.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 21:22:35 -0700 (PDT)
Date:   Mon, 14 Sep 2020 21:22:33 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Andy Lavr <andy.lavr@gmail.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5] lib/string.c: implement stpcpy
Message-ID: <20200915042233.GA816510@ubuntu-n2-xlarge-x86>
References: <20200914160958.889694-1-ndesaulniers@google.com>
 <20200914161643.938408-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914161643.938408-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 09:16:43AM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  `stpcpy` is just like `strcpy` except it
> returns the pointer to the new tail of `dest`.  This optimization was
> introduced into clang-12.
> 
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
> 
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> The kernel is somewhere between a "freestanding" environment (no full libc)
> and "hosted" environment (many symbols from libc exist with the same
> type, function signature, and semantics).
> 
> As H. Peter Anvin notes, there's not really a great way to inform the
> compiler that you're targeting a freestanding environment but would like
> to opt-in to some libcall optimizations (see pr/47280 below), rather than
> opt-out.
> 
> Arvind notes, -fno-builtin-* behaves slightly differently between GCC
> and Clang, and Clang is missing many __builtin_* definitions, which I
> consider a bug in Clang and am working on fixing.
> 
> Masahiro summarizes the subtle distinction between compilers justly:
>   To prevent transformation from foo() into bar(), there are two ways in
>   Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
>   only one in GCC; -fno-buitin-foo.
> 
> (Any difference in that behavior in Clang is likely a bug from a missing
> __builtin_* definition.)
> 
> Masahiro also notes:
>   We want to disable optimization from foo() to bar(),
>   but we may still benefit from the optimization from
>   foo() into something else. If GCC implements the same transform, we
>   would run into a problem because it is not -fno-builtin-bar, but
>   -fno-builtin-foo that disables that optimization.
> 
>   In this regard, -fno-builtin-foo would be more future-proof than
>   -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
>   may want to prevent calls from foo() being optimized into calls to
>   bar(), but we still may want other optimization on calls to foo().
> 
> It seems that compilers today don't quite provide the fine grain control
> over which libcall optimizations pseudo-freestanding environments would
> prefer.
> 
> Finally, Kees notes that this interface is unsafe, so we should not
> encourage its use.  As such, I've removed the declaration from any
> header, but it still needs to be exported to avoid linkage errors in
> modules.
> 
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

It would be nice to get this into mainline sooner rather than later so
that it can start filtering into the stable trees. ToT LLVM builds have
been broken for a month now.

> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://bugs.llvm.org/show_bug.cgi?id=47280
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> ---
> Changes V5:
> * fix missing parens in comment.
> 
> Changes V4:
> * Roll up Kees' comment fixup from
>   https://lore.kernel.org/lkml/202009060302.4574D8D0E0@keescook/#t.
> * Keep Nathan's tested by tag.
> * Add Kees' reviewed by tag from
>   https://lore.kernel.org/lkml/202009031446.3865FE82B@keescook/.

For the record, I don't see Kees' review tag on this.

> 
> Changes V3:
> * Drop Sami's Tested by tag; newer patch.
> * Add EXPORT_SYMBOL as per Andy.
> * Rewrite commit message, rewrote part of what Masahiro said to be
>   generic in terms of foo() and bar().
> * Prefer %NUL-terminated to NULL terminated. NUL is the ASCII character
>   '\0', as per Arvind and Rasmus.
> 
> Changes V2:
> * Added Sami's Tested by; though the patch changed implementation, the
>   missing symbol at link time was the problem Sami was observing.
> * Fix __restrict -> __restrict__ typo as per Joe.
> * Drop note about restrict from commit message as per Arvind.
> * Fix NULL -> NUL as per Arvind; NUL is ASCII '\0'. TIL
> * Fix off by one error as per Arvind; I had another off by one error in
>   my test program that was masking this.
> 
>  lib/string.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/lib/string.c b/lib/string.c
> index 6012c385fb31..4288e0158d47 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
>  }
>  EXPORT_SYMBOL(strscpy_pad);
>  
> +/**
> + * stpcpy - copy a string from src to dest returning a pointer to the new end
> + *          of dest, including src's %NUL-terminator. May overrun dest.
> + * @dest: pointer to end of string being copied into. Must be large enough
> + *        to receive copy.
> + * @src: pointer to the beginning of string being copied from. Must not overlap
> + *       dest.
> + *
> + * stpcpy differs from strcpy in a key way: the return value is a pointer
> + * to the new %NUL-terminating character in @dest. (For strcpy, the return
> + * value is a pointer to the start of @dest). This interface is considered
> + * unsafe as it doesn't perform bounds checking of the inputs. As such it's
> + * not recommended for usage. Instead, its definition is provided in case
> + * the compiler lowers other libcalls to stpcpy.
> + */
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src);
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
> +{
> +	while ((*dest++ = *src++) != '\0')
> +		/* nothing */;
> +	return --dest;
> +}
> +EXPORT_SYMBOL(stpcpy);
> +
>  #ifndef __HAVE_ARCH_STRCAT
>  /**
>   * strcat - Append one %NUL-terminated string to another
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 
