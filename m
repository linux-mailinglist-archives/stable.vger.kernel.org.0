Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FE529F45C
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJ2S6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgJ2S6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:58:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0EC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:58:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z24so3118986pgk.3
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygdtL6CnTQH7Tnq1yUpsax8Newnu3ysggevTfg1LisY=;
        b=SlVYufBS5tCcv0R6+JmhzzJvGNoXoY5S2nsAlRGRGq+Fe2+1EJbpkQKzA5Gnd7iO6+
         cw0lZqZsxTCmwcfJnpSdZXyU/SS2WFTqicH0O9VngeXPi7mr4WMJBEDI50G2jUjX9EDY
         Rc2Y/r84AwAx5OlZrEOvxmjRAOQOts5uyNJicFafTbb/6zzc4SQlxCJ9R8gOdvt4nvzy
         lGCUHN57g+aM0+XfUQ6PmF/KyF8kebq1r+ROplDVGmXF0gLcgZwmZ1mEKewFabAFnfTj
         t7QNguANFCGy59+TFInKISflN+qm/82xNMHpzHl6vx0H43nS7AEPO/1oa9oLmdzR183N
         iyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygdtL6CnTQH7Tnq1yUpsax8Newnu3ysggevTfg1LisY=;
        b=VovqZ+XrsDd1ZXqaUDokQloEuKuD81+wM9o1fWdJ5BwiVqa5qlBtUrG0IRypzjHi1r
         svQ97NrD0kjfYYWtpI9FQMhBjWMwhWNt1lBKi0RPdaVwLJRULlvJzR9yBmDJfpBO4UQE
         sVR1Opk782lAWccOnmiDex7+SebBlnFBFAXQsUwUv9DEkvmn06V2aP7WYfBFagrrSJ8e
         BHF93VssOvoz20eMX7NBA0bjThHzvYYdIEowOdL1JkSWaPWNRddWNQQhsvcCtt4XoyZN
         xQnzIuuQWzh9g7DyqMj0uPlwllUlR3A2wa6yrjs/He2dn9HbpRpTl429hONP7wFBXSf8
         SZBQ==
X-Gm-Message-State: AOAM530CSGTDMgq9Co/mv79o1lCnZHhZ3wfhsb74fBzTPn7Mn2qG7k7T
        t3og2Z5416QDBgm4Fe8HSzPsaVvxtTLND2Z/lOiZVA==
X-Google-Smtp-Source: ABdhPJz4PoYDzphWyJBEp8RiYQueGGU5MN7SjJhtFj5K2T9gbIjRlRf3SlSdmK6ZvImEza0+mUDiAJ8UlfPRN7OlFsA=
X-Received: by 2002:a17:90b:110b:: with SMTP id gi11mr546213pjb.25.1603997895872;
 Thu, 29 Oct 2020 11:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201029180525.1797645-1-maskray@google.com>
In-Reply-To: <20201029180525.1797645-1-maskray@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 29 Oct 2020 11:58:03 -0700
Message-ID: <CAKwvOdk+72TmStpCr0jrCTeBB2mKuNAVqju5zD3m-K21BKfg-g@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
To:     Fangrui Song <maskray@google.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:05 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
> memset/memmove/memcpy functions") added .weak directives to
> arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_*
> macros. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
>
> Use the appropriate SYM_FUNC_START_WEAK instead.
>
> Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/lib/memcpy_64.S  | 4 +---
>  arch/x86/lib/memmove_64.S | 4 +---
>  arch/x86/lib/memset_64.S  | 4 +---
>  3 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index 037faac46b0c..1e299ac73c86 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -16,8 +16,6 @@
>   * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
>   */
>
> -.weak memcpy
> -
>  /*
>   * memcpy - Copy a memory block.
>   *
> @@ -30,7 +28,7 @@
>   * rax original destination
>   */
>  SYM_FUNC_START_ALIAS(__memcpy)
> -SYM_FUNC_START_LOCAL(memcpy)
> +SYM_FUNC_START_WEAK(memcpy)
>         ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
>                       "jmp memcpy_erms", X86_FEATURE_ERMS

Thanks for the patch.  This exposes a lack of symmetry in the
assembler subroutine for memcpy; memmove and memset use SYM_FUNC_START
for their double underscore prefixed symbols, and SYM_FUNC_START_WEAK
for the non prefixed symbols, and no SYM_FUNC_START_ALIAS after your
patch.  It's also curious to me why you removed SYM_FUNC_START_ALIAS
for memmove and memset, but not memcpy?  Can we sort that out so that
they all follow the same convention?

Before your patch, with GNU `as` I see:
$ llvm-readelf -s arch/x86/lib/memcpy_64.o | grep -e memcpy -e __memcpy
    16: 0000000000000000    26 FUNC    GLOBAL DEFAULT     4 __memcpy
    17: 0000000000000000    26 FUNC    WEAK   DEFAULT     4 memcpy
$ llvm-readelf -s arch/x86/lib/memmove_64.o| grep -e memmove -e __memmove
    13: 0000000000000000   409 FUNC    WEAK   DEFAULT     1 memmove
    14: 0000000000000000   409 FUNC    GLOBAL DEFAULT     1 __memmove
$ llvm-readelf -s arch/x86/lib/memset_64.o| grep -e memset -e __memset
    15: 0000000000000000    47 FUNC    WEAK   DEFAULT     1 memset
    16: 0000000000000000    47 FUNC    GLOBAL DEFAULT     1 __memset

After your patch, with GNU `as` I see:
$ llvm-readelf -s arch/x86/lib/memcpy_64.o | grep -e memcpy -e __memcpy
    16: 0000000000000000    26 FUNC    GLOBAL DEFAULT     4 __memcpy
    17: 0000000000000000    26 FUNC    WEAK   DEFAULT     4 memcpy
$ llvm-readelf -s arch/x86/lib/memmove_64.o| grep -e memmove -e __memmove
    13: 0000000000000000   409 FUNC    WEAK   DEFAULT     1 memmove
    14: 0000000000000000   409 FUNC    GLOBAL DEFAULT     1 __memmove
$ llvm-readelf -s arch/x86/lib/memset_64.o| grep -e memset -e __memset
    15: 0000000000000000    47 FUNC    WEAK   DEFAULT     1 memset
    16: 0000000000000000    47 FUNC    GLOBAL DEFAULT     1 __memset

So in that sense, your patch is no functional change, and simply
resolves ambiguities in repeatedly defining a symbol with different
bindings.  I guess we can save uncovering why memcpy doesn't follow
the same convention for another day.  In that sense:

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

And thanks for the patch!

>
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 7ff00ea64e4f..41902fe8b859 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -24,9 +24,7 @@
>   * Output:
>   * rax: dest
>   */
> -.weak memmove
> -
> -SYM_FUNC_START_ALIAS(memmove)
> +SYM_FUNC_START_WEAK(memmove)
>  SYM_FUNC_START(__memmove)
>
>         mov %rdi, %rax
> diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
> index 9ff15ee404a4..0bfd26e4ca9e 100644
> --- a/arch/x86/lib/memset_64.S
> +++ b/arch/x86/lib/memset_64.S
> @@ -6,8 +6,6 @@
>  #include <asm/alternative-asm.h>
>  #include <asm/export.h>
>
> -.weak memset
> -
>  /*
>   * ISO C memset - set a memory block to a byte value. This function uses fast
>   * string to get better performance than the original function. The code is
> @@ -19,7 +17,7 @@
>   *
>   * rax   original destination
>   */
> -SYM_FUNC_START_ALIAS(memset)
> +SYM_FUNC_START_WEAK(memset)
>  SYM_FUNC_START(__memset)
>         /*
>          * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
> --
> 2.29.1.341.ge80a0c044ae-goog
>
> --
-- 
Thanks,
~Nick Desaulniers
