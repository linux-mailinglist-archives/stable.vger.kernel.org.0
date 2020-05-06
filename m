Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300571C66F6
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 06:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgEFEac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 00:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgEFEab (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 00:30:31 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80774C061A0F;
        Tue,  5 May 2020 21:30:31 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x10so634514oie.1;
        Tue, 05 May 2020 21:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xZONTa1LCuYbn7xKCYYHFEkVfOQmQt+9e4kIPuOoC/M=;
        b=pRdL+sMEbjKfSWJ/5OMm/8fZScf5QshJvFb9rQTHmz9XZg/aAdibcbCQ+MzyGnuhM5
         UQ7DdolQ3SM3iShOZgJpN9W8qaQe+DkllZdUbbHywdxWYA8P3F3mjyyZjZm/6R5N1wTd
         vO11GUlE6tyTBRIIgK24l4S693u4/euXjUxDnny49hgG+tLgwjNntbzfqd46crTztT/q
         Y83QRD1hHjLinA7cuLr5zFuh4KH3T6yTQuVuqhk4h1EyjhCgbedcRaAgT2xYs28VsAWR
         PwlPGGqlhp3MBm2UVvjnJjsMITKw2txP4amcbTQMcLAtOSwvZMTAWiABFwtJ7TOjTcS0
         LqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xZONTa1LCuYbn7xKCYYHFEkVfOQmQt+9e4kIPuOoC/M=;
        b=GaKZXOyrcnMDerHaWJjZUUXZBm3hc4nSpFW68+HXHg0cPfYS6s12GzZIRMWBzHjVq5
         TNbnLQpiFl7tVlTWHceN9Z8LOdyh1P1TTbwweNzEvXNamwiAbf1QY9+Pw+emETnMVqSp
         2dfWgp9bo23FPo3AdpjDGblOkGnhwbLUt6DUofMZXDF5trFpSC/z9Y/e23pbI8DlRRLh
         DAnSsUzQuyHf1q4k8rquNfLtk5NhtgHSB9Nn1AqSbrY6RCQC3oDxLXs53kiVrrashrxU
         sCjClasfdkOBrdiAiiOwTsWGEKl3jcTaRpYeZ3rLC0vhaiGGclepjp/NULNePNAiCg1B
         IEyw==
X-Gm-Message-State: AGi0PubQCE5gJowcf1/p6ORluj292Ehm+2GNKePkfq+6S2r4gzpkU/vc
        e7rO3DPxr5PtP8vm7qrOUdo=
X-Google-Smtp-Source: APiQypIPryKY+J4O5rbYmU8PKKioDfJfdoZqt8XnswMivCeRCT3jlVAfH7JCK/dF5/Om9yV18yPS2Q==
X-Received: by 2002:a05:6808:919:: with SMTP id w25mr1358214oih.111.1588739430872;
        Tue, 05 May 2020 21:30:30 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id k24sm280294otn.32.2020.05.05.21.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 21:30:30 -0700 (PDT)
Date:   Tue, 5 May 2020 21:30:28 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86: bitops: fix build regression
Message-ID: <20200506043028.GA663805@ubuntu-s3-xlarge-x86>
References: <20200505174423.199985-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505174423.199985-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 10:44:22AM -0700, Nick Desaulniers wrote:
> From: Sedat Dilek <sedat.dilek@gmail.com>
> 
> It turns out that if your config tickles __builtin_constant_p via
> differences in choices to inline or not, this now produces invalid
> assembly:
> 
> $ cat foo.c
> long a(long b, long c) {
>   asm("orb\t%1, %0" : "+q"(c): "r"(b));
>   return c;
> }
> $ gcc foo.c
> foo.c: Assembler messages:
> foo.c:2: Error: `%rax' not allowed with `orb'
> 
> The "q" constraint only has meanting on -m32 otherwise is treated as
> "r".
> 
> This is easily reproducible via Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> or Clang+allyesconfig.

For what it's worth, I don't see this with allyesconfig.

> Keep the masking operation to appease sparse (`make C=1`), add back the
> cast in order to properly select the proper 8b register alias.
> 
>  [Nick: reworded]
> 
> Cc: stable@vger.kernel.org

The offending commit was added in 5.7-rc1; we shouldn't need to
Cc stable since this should be picked up as an -rc fix.

> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/961
> Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Suggested-by: Ilie Halip <ilie.halip@gmail.com>

Not to split hairs but this is Ilie's diff, he should probably be the
author with Sedat's Reported-by/Tested-by.

https://github.com/ClangBuiltLinux/linux/issues/961#issuecomment-608239458

But eh, it's all a team effort plus that can only happen with Ilie's
explicit consent for a Signed-off-by.

I am currently doing a set of builds with clang-11 with this patch on
top of 5.7-rc4 to make sure that all of the cases I have found work.
Once that is done, I'll comment back with a tag.

> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/x86/include/asm/bitops.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index b392571c1f1d..139122e5b25b 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
>  	if (__builtin_constant_p(nr)) {
>  		asm volatile(LOCK_PREFIX "orb %1,%0"
>  			: CONST_MASK_ADDR(nr, addr)
> -			: "iq" (CONST_MASK(nr) & 0xff)
> +			: "iq" ((u8)(CONST_MASK(nr) & 0xff))
>  			: "memory");
>  	} else {
>  		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> @@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
>  	if (__builtin_constant_p(nr)) {
>  		asm volatile(LOCK_PREFIX "andb %1,%0"
>  			: CONST_MASK_ADDR(nr, addr)
> -			: "iq" (CONST_MASK(nr) ^ 0xff));
> +			: "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
>  	} else {
>  		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
>  			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
> -- 
> 2.26.2.526.g744177e7f7-goog
> 

Cheers,
Nathan
