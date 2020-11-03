Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B04E2A3A02
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKCBqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgKCBqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 20:46:06 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51960C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 17:46:06 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h12so10697643qtu.1
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 17:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E/SrOBohrp1WVAfSWcnV6YmgfBval4808Jfz9b1VIxs=;
        b=gV0UaB7619mFO/3giDcBL/jBIGMj+0T+VdMmKaDdh9cu86+98lcyvGvmRsTXfhX+X9
         AanfmFGqT8Ys1srC7wrtAwPNcOXExn4Zy8V0OS83v+yMij37AN3Dy64Zngn9lDws7mIC
         LNgFRfFDMLHkCSRevp/iJAKqHzlMmfPq2pHR2vVo+VZ+psClh3bmG+tN7Twa08WvJCka
         PaAC2uMLyuoRFBoHopIp+R6mK8NdCelziMnj6hz9b/DFlz/fFB7L1bD32o9AoTzWOr9D
         E7PaCuzs/HTvtm4w63ezQah/hWkLuAm14srN2t8MhvEVRUFS0Eeju9VQ7KyBvprO5fax
         7VYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E/SrOBohrp1WVAfSWcnV6YmgfBval4808Jfz9b1VIxs=;
        b=GhkN3TleBrCOC1MrHgP/diZ5iCrQAYEg1dmKl7LpJWZdJtLz+hvy99tRDHHBVbcjCl
         TA/uDrjuhw4ogL7xPTGc/J8o5pK8jgXeqeGX4vUmDCz5Aj8xK/VR6zFzw83mtPDOmiCz
         MnNeJNufLTR+PT2KtFzVGoXvZp7qdbveEz9VQxUj665y6H/UerRLs4tn54DbFcuaaHEb
         bCjteps+sOEfgFsMc86EYlHMZKYlyrEZBKrr85V1Sv9tJp18Tl183qkjut7/X+5l+7w/
         XB87/KlNxOhsDuI+SVeE1CGWqZdbh85frJnvvCa4vuic2Op3uFp3FGDKTxr+2Jv92zL1
         UEUw==
X-Gm-Message-State: AOAM532e76bME3pdU6H9ABC1g/OAgCDLWRCEc3vlwXisfQMughBu9vme
        fc+7QS+FoC09UdHClp3H7A8=
X-Google-Smtp-Source: ABdhPJzDU0SqlYfrOmU4TeKQlXULGa1MKM2USVlbP14O0liaM6D3LI9wpyTc1JoZpuSF33Zyvik9qQ==
X-Received: by 2002:ac8:5bc5:: with SMTP id b5mr17780288qtb.268.1604367965330;
        Mon, 02 Nov 2020 17:46:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 137sm7594048qkk.63.2020.11.02.17.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 17:46:04 -0800 (PST)
Date:   Mon, 2 Nov 2020 18:46:02 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Fangrui Song <maskray@google.com>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux@googlegroups.com, Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86_64: Change .weak to SYM_FUNC_START_WEAK for
 arch/x86/lib/mem*_64.S
Message-ID: <20201103014602.GA3271702@ubuntu-m3-large-x86>
References: <20201103012358.168682-1-maskray@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103012358.168682-1-maskray@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 05:23:58PM -0800, 'Fangrui Song' via Clang Built Linux wrote:
> Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
> memset/memmove/memcpy functions") added .weak directives to
> arch/x86/lib/mem*_64.S instead of changing the existing ENTRY macros to
> WEAK. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
> 
> Commit ef1e03152cb0 ("x86/asm: Make some functions local") changed ENTRY in
> arch/x86/lib/memcpy_64.S to SYM_FUNC_START_LOCAL, which was ineffective due to
> the preceding .weak directive.
> 
> Use the appropriate SYM_FUNC_START_WEAK instead.
> 
> Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
> Fixes: ef1e03152cb0 ("x86/asm: Make some functions local")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>

This resolves the build error I see with LLVM_IAS=1 and ToT LLVM.

Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
> Changes in v2
> * Correct the message: SYM_FUNC_START_WEAK was not available at commit 393f203f5fd5.
> * Mention Fixes: ef1e03152cb0
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
>  	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
>  		      "jmp memcpy_erms", X86_FEATURE_ERMS
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
>  	mov %rdi, %rax
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
>  	/*
>  	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
> -- 
> 2.29.1.341.ge80a0c044ae-goog
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201103012358.168682-1-maskray%40google.com.
