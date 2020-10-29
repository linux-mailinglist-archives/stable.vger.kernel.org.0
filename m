Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A540F29F4B5
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJ2TQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgJ2TPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 15:15:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769A5C0613D4
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 12:15:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w65so3179887pfd.3
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBw1GAOtbTvacIIrPn9i1fR24iJjUEupxZ8BqkGfkX8=;
        b=rLxjrKJkfdarAbU5LQR2J3NDEGOd/HlQ5qaK1cWFEI9CdzmP5LKaZYdaJB3qNnhasn
         bHjamibs41FlTSjY16UQhOJgsEaCh4YT3c8iclba5MAhS3Ez86suEbNHRp99w5bOkgpO
         tDI91DE5nIlYabtlRXeNmnJYh0A1JvXJwl88wnOrWBwhRMpeQD68nUIZ4HrMrPublP0a
         BlRsffrp0CVMtZl/0v09G4gmx65pxoEfvw+VWuLM/I4+YgStzIB946M9PesfYCeIpTVe
         fko/hKgIFSNvVrvKeCnF9G2I4FfB31tcsUEYnEUHk/wH0jvR4cWelae7e+xWo6W/1Kup
         nrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBw1GAOtbTvacIIrPn9i1fR24iJjUEupxZ8BqkGfkX8=;
        b=oDF5yAcUx5NqVc/XPMxn9ZhKNNMq32DidA4rYgHfjACzff3wNoy+lQHyXwPR8yvBXJ
         ICn5LF6HnxLW1/pVpxKHd8kQW4Bc2htWkxGmyvSz2G5d9BuOky2Ed3qHyXBubJ1+U4CY
         RTy1e6n/S4lpKFnFi3l6HHXJIt52Bu4XnDoZk6rGZQdO0e09M7Zy7sKVX69u9JMCuBK9
         NDagoCRK3VwMQl7hDojqkt72PjoE0Sa92LkeBbmrsVQE5Szg9CfMdS4oZCFDRAOUiYAD
         F7/wRzo8U+BLMMjUEcKr7ZhQcZgzw0OM4HNpNMGZctJoOwackdeQAEGt73ON6MjjUyKg
         l0Lg==
X-Gm-Message-State: AOAM530Pqp441thi4svnG5WuukXrB0ZzkjI7ewM8U/y9rSTuHj3THWBt
        79Eqy0nG3A8Dajw3K1z0K+9qE0Ur+IOBJXc6j4q76v9DHRsPwA==
X-Google-Smtp-Source: ABdhPJwYdVF9qQqsFl/2fT3g6wMxSp+dYJzciikmQCcGLw9RgY3xJy6EvWCRkGmxRIHjfkObQtlNcNvEuXyVMP6odYs=
X-Received: by 2002:a17:90a:740a:: with SMTP id a10mr1329483pjg.32.1603998938686;
 Thu, 29 Oct 2020 12:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201029181951.1866093-1-maskray@google.com>
In-Reply-To: <20201029181951.1866093-1-maskray@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 29 Oct 2020 12:15:26 -0700
Message-ID: <CAKwvOd=wBKYMWMSvRbfWWUPJ3pUThKF5=1iRvwg0yDWTyE-TLg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
To:     Fangrui Song <maskray@google.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:20 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
> arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
> macros. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
>
> Use the appropriate SYM_FUNC_START_WEAK_PI instead.
>
> Fixes: 39d114ddc682 ("arm64: add KASAN support")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>

Before your patch, with GNU `as`:
$ llvm-readelf -s arch/arm64/lib/memcpy.o | grep memcpy
    19: 0000000000000000   340 FUNC    WEAK   DEFAULT     1 memcpy
    20: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __memcpy
    21: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __pi_memcpy
$ llvm-readelf -s arch/arm64/lib/memmove.o | grep memmove
    19: 0000000000000000   340 FUNC    WEAK   DEFAULT     1 memmove
    20: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __memmove
    21: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __pi_memmove
$  llvm-readelf -s arch/arm64/lib/memset.o | grep memset
    19: 0000000000000000   392 FUNC    WEAK   DEFAULT     1 memset
    20: 0000000000000000   392 FUNC    GLOBAL DEFAULT     1 __memset
    21: 0000000000000000   392 FUNC    GLOBAL DEFAULT     1 __pi_memset
After your patch, with GNU `as`:
$ llvm-readelf -s arch/arm64/lib/memcpy.o | grep memcpy
    19: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __memcpy
    20: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __pi_memcpy
    21: 0000000000000000   340 FUNC    WEAK   DEFAULT     1 memcpy
$ llvm-readelf -s arch/arm64/lib/memmove.o | grep memmove
    19: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __memmove
    20: 0000000000000000   340 FUNC    GLOBAL DEFAULT     1 __pi_memmove
    21: 0000000000000000   340 FUNC    WEAK   DEFAULT     1 memmove
$ llvm-readelf -s arch/arm64/lib/memset.o | grep memset
    19: 0000000000000000   392 FUNC    GLOBAL DEFAULT     1 __memset
    20: 0000000000000000   392 FUNC    GLOBAL DEFAULT     1 __pi_memset
    21: 0000000000000000   392 FUNC    WEAK   DEFAULT     1 memset

So it didn't change any bindings (good), but it did reorder symbols.
I suspect if you flip the ordering of SYM_FUNC_START_WEAK_PI relative
to SYM_FUNC_START_ALIAS you can get the previous ordering back, but I
also suspect that the ordering of these symbols is not important.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/arm64/lib/memcpy.S  | 3 +--
>  arch/arm64/lib/memmove.S | 3 +--
>  arch/arm64/lib/memset.S  | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
> index e0bf83d556f2..dc8d2a216a6e 100644
> --- a/arch/arm64/lib/memcpy.S
> +++ b/arch/arm64/lib/memcpy.S
> @@ -56,9 +56,8 @@
>         stp \reg1, \reg2, [\ptr], \val
>         .endm
>
> -       .weak memcpy
>  SYM_FUNC_START_ALIAS(__memcpy)
> -SYM_FUNC_START_PI(memcpy)
> +SYM_FUNC_START_WEAK_PI(memcpy)
>  #include "copy_template.S"
>         ret
>  SYM_FUNC_END_PI(memcpy)
> diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
> index 02cda2e33bde..1035dce4bdaf 100644
> --- a/arch/arm64/lib/memmove.S
> +++ b/arch/arm64/lib/memmove.S
> @@ -45,9 +45,8 @@ C_h   .req    x12
>  D_l    .req    x13
>  D_h    .req    x14
>
> -       .weak memmove
>  SYM_FUNC_START_ALIAS(__memmove)
> -SYM_FUNC_START_PI(memmove)
> +SYM_FUNC_START_WEAK_PI(memmove)
>         cmp     dstin, src
>         b.lo    __memcpy
>         add     tmp1, src, count
> diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
> index 77c3c7ba0084..a9c1c9a01ea9 100644
> --- a/arch/arm64/lib/memset.S
> +++ b/arch/arm64/lib/memset.S
> @@ -42,9 +42,8 @@ dst           .req    x8
>  tmp3w          .req    w9
>  tmp3           .req    x9
>
> -       .weak memset
>  SYM_FUNC_START_ALIAS(__memset)
> -SYM_FUNC_START_PI(memset)
> +SYM_FUNC_START_WEAK_PI(memset)
>         mov     dst, dstin      /* Preserve return value.  */
>         and     A_lw, val, #255
>         orr     A_lw, A_lw, A_lw, lsl #8
> --
> 2.29.1.341.ge80a0c044ae-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201029181951.1866093-1-maskray%40google.com.



-- 
Thanks,
~Nick Desaulniers
