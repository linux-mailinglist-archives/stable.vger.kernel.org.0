Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F2251F4E
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 20:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgHYSv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 14:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYSvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 14:51:25 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE01C061574;
        Tue, 25 Aug 2020 11:51:25 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id i20so12030244qkk.8;
        Tue, 25 Aug 2020 11:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6x0iz9JUsWXmCzILUsCg/89oPKkQvuUuZ5mSr/G7CCc=;
        b=ghGTgj4Nu47q9B5RTknR8QOLlVRGwQKsRF4h60+v59AdwRLeWtRni/4llQCoxt4n0m
         v0xZ+78rKDEx4vhho4cTxEFc2uzldInEdxoLfx+wwfs3mN5OIVCub+TKHjdDWSLdxZIE
         cNKvtgQvA7as/hKzdTDPwgEJAUeJBPYVN/7lWLTlAoz+RxorL+Ws3YQh4dh5ALeMBoRx
         yr5hzqdCPYjQ61P4MVr3e4fYr8sdtxPv7WxV/ATS+9joExTLkkMj0AL8xw5dYs1nv86d
         vAlEqZUBbqDnZLD8uXPx9kaFB6Lk9yYKW53H2GbGT2vcy7OWXSY7JOUF5K7MuvXE/f+m
         MqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6x0iz9JUsWXmCzILUsCg/89oPKkQvuUuZ5mSr/G7CCc=;
        b=qSj5WfCaOO0M0Wr5oYbcB011lt2jZHq4m1OZ5n+MifytGadhmbRqWD/zHCblSckCgg
         wht7onq8B/csrpnXOA+8M5TpZX/hIZ87e39qVwYb97V/ubN5BUpkDtXTMOw2jY5duBJ8
         xGt/gw0q8xGwccWcLBqr9asZVmJ2yxg5hQ4A37VxUph/ksnDwCEEwqHVUDmDeaFsadQ6
         oqlR7qEQgSW8PlzsAhqXqmOJnTniIAfnDv2eL8ospFuXFVFvGs/729VA51MhlXVNooE1
         +2ZQh6A4vrAafrz7HS2BXov9LvXUhSFL/arvc6lhoXTH+6euq6AxYwiQSbh7n78uWeDR
         Jp0w==
X-Gm-Message-State: AOAM5329Cn7bTT4OGt0uWWUuqpvC6n7EHikvnpjJ8Jza4yr+OUA7A+Vk
        IFw9SZtG41nmc160IvicuQU=
X-Google-Smtp-Source: ABdhPJyzaWhn7iXWu/e6eMxG4wr1Xi1OEWmXBPDTIUpJN/oWNMEdX1hHR+VF3B1LC8+FgGykLM7v8w==
X-Received: by 2002:ae9:e507:: with SMTP id w7mr10448078qkf.264.1598381484105;
        Tue, 25 Aug 2020 11:51:24 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id o72sm12491217qka.113.2020.08.25.11.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 11:51:23 -0700 (PDT)
Date:   Tue, 25 Aug 2020 11:51:21 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, h@ubuntu-n2-xlarge-x86
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org,
        Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
Message-ID: <20200825185121.GA602430@ubuntu-n2-xlarge-x86>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825135838.2938771-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 06:58:36AM -0700, Nick Desaulniers wrote:
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
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://bugs.llvm.org/show_bug.cgi?id=47280
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
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
> index 6012c385fb31..6bd0cf0fb009 100644
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
> + * stpcpy differs from strcpy in a key way: the return value is the new
> + * %NUL-terminated character. (for strcpy, the return value is a pointer to
> + * src. This interface is considered unsafe as it doesn't perform bounds
> + * checking of the inputs. As such it's not recommended for usage. Instead,
> + * its definition is provided in case the compiler lowers other libcalls to
> + * stpcpy.
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
> 2.28.0.297.g1956fa8f8d-goog
> 
