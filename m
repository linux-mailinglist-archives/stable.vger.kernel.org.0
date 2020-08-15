Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA99D2453DB
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgHOWGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgHOVus (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:50:48 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAC1C061367;
        Fri, 14 Aug 2020 19:58:20 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id x6so5226155qvr.8;
        Fri, 14 Aug 2020 19:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/fEGoVdDdtmlO46PesKTLAIEf8IpLdTiSt2G5gOFkkI=;
        b=ak5n+gjxWktOhaG3EfOxzTfr2MLh+0OTCoxqLg7/D9ChzdjAZqrEtSq9K4E2AXAH4U
         D8QKIb/Rt40mfh8OGPveRMmHNU05hLmn4D5KsXXJggq5ilU5uCj35Q/oMZOqkXHf5PlL
         f5Y3FG67UkXHtCDxuxJk3FPnYihj+QpQ9SyOBtGw32hfkBN5GDj7agH2hTRiEvoMrmwv
         YTUx23aisA3filv2zrS0f5RQtLH9z4JNxlzlAHs+VuPSwvDmAYiq9kNFDNGFe70btUDM
         BewEQQ96bbfG1KqJtNpNti7aG34/0IhN27l3hg4bEP297lJmCQMsJ5xgWJhOSEVK5z61
         f4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/fEGoVdDdtmlO46PesKTLAIEf8IpLdTiSt2G5gOFkkI=;
        b=NFH8MWkg9qEy3cAkiG9Hq+xVV9nxGN+CJmXp5ocChLUo40FE72ve0kNEqHmB/5pHII
         eol/5ZbcCcs+COT8n4yiDhDstvdd0oUmZrjPfIn38axrn5u+e9fZst7wPNSS9QzVl+LF
         t0ztTDwNhCjxqjVVz9sVda5ebBek5QyxbF4z3lEYdsvRUl2ppU4V0HtO5biN8mXHzugP
         zcnSh1Vavd8hn5ZdhsMnqDgVPY3OFUywcqt9rumZDeXdQ8WrUhQDnCthPz2TK9YnB7Xz
         IwxnmobUH5bf/DWB/QRgSrZKfKXHwMOQajeob2BAlyKNmvg4162lEz3IH3B1BBpz7315
         81hg==
X-Gm-Message-State: AOAM532jjsgCOl9wrHP//sqglJG774SjRz0xVWGiJixudKwUsG4cfl7Y
        AddV0evK7Ya7oMMPES+wP7Q=
X-Google-Smtp-Source: ABdhPJz4IJa9DVP0cyngnO8Zo4A7gSjgQXeL4X1dcUNiJlQGPfPvHSbi8Jgcd36sVDStuI+OMkHi3g==
X-Received: by 2002:a05:6214:1742:: with SMTP id dc2mr5652005qvb.90.1597460299518;
        Fri, 14 Aug 2020 19:58:19 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id c33sm12431516qtk.40.2020.08.14.19.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 19:58:18 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 14 Aug 2020 22:58:16 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <20200815025816.GA221583@rani.riverdale.lan>
References: <20200815014006.GB99152@rani.riverdale.lan>
 <20200815020946.1538085-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200815020946.1538085-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  Calling `sprintf` with overlapping arguments
> was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> 
> `stpcpy` is just like `strcpy` except it returns the pointer to the new
> tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> one statement.
> 
> `stpcpy` was first standardized in POSIX.1-2008.
> 
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
> 
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> This optimization was introduced into clang-12.
> 
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Tested-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Changes V2:
> * Added Sami's Tested by; though the patch changed implementation, the
>   missing symbol at link time was the problem Sami was observing.
> * Fix __restrict -> __restrict__ typo as per Joe.
> * Drop note about restrict from commit message as per Arvind.
> * Fix NULL -> NUL as per Arvind; NUL is ASCII '\0'. TIL
> * Fix off by one error as per Arvind; I had another off by one error in
>   my test program that was masking this.
> 
>  include/linux/string.h |  3 +++
>  lib/string.c           | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index b1f3894a0a3e..7686dbca8582 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -31,6 +31,9 @@ size_t strlcpy(char *, const char *, size_t);
>  #ifndef __HAVE_ARCH_STRSCPY
>  ssize_t strscpy(char *, const char *, size_t);
>  #endif
> +#ifndef __HAVE_ARCH_STPCPY
> +extern char *stpcpy(char *__restrict__, const char *__restrict__);
> +#endif
>  
>  /* Wraps calls to strscpy()/memset(), no arch specific code required */
>  ssize_t strscpy_pad(char *dest, const char *src, size_t count);
> diff --git a/lib/string.c b/lib/string.c
> index 6012c385fb31..68ddbffbbd58 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -272,6 +272,29 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
>  }
>  EXPORT_SYMBOL(strscpy_pad);
>  
> +#ifndef __HAVE_ARCH_STPCPY
> +/**
> + * stpcpy - copy a string from src to dest returning a pointer to the new end
> + *          of dest, including src's NUL terminator. May overrun dest.
> + * @dest: pointer to end of string being copied into. Must be large enough
> + *        to receive copy.
> + * @src: pointer to the beginning of string being copied from. Must not overlap
> + *       dest.
> + *
> + * stpcpy differs from strcpy in two key ways:
> + * 1. inputs must not overlap.

Looks like you missed my second email: strcpy also does not allow inputs
to overlap. Couple typos below.

> + * 2. return value is the new NULL terminated character. (for strcpy, the
				 ^^ NUL terminator.
> + *    return value is a pointer to src.
				      ^^ dest.)
> + */
> +#undef stpcpy
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
> +{
> +	while ((*dest++ = *src++) != '\0')
> +		/* nothing */;
> +	return --dest;
> +}
> +#endif
> +
>  #ifndef __HAVE_ARCH_STRCAT
>  /**
>   * strcat - Append one %NUL-terminated string to another
> -- 
> 2.28.0.220.ged08abb693-goog
> 

The kernel-doc comments in string.c currently have a mix of %NUL and
NUL, but the former seems to be more common. %NUL-terminator appears to
be the preferred wording.
