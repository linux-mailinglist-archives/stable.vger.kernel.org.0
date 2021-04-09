Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0963D35A949
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 01:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhDIXgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 19:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbhDIXgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 19:36:36 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8894C061764
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 16:36:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u9so8329412ljd.11
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQEhdxl+cSU7BC7XRTZDcCsNpOwQL3MJhJomrvmkJCY=;
        b=naXn5kfXgRlukFVoSCe/aS9mSub16qMDDnXU0x9NB9VvBXEc/nCg53QsttbiYYoOdy
         NvXp8jYd89b8HUaPN7fRNWO7pgHhHGs0K2z7HvJSpG4ldxCjcMZNSGLrjUXwkFVHREQu
         EkdeDYJ7eqF5tFBnfniDsngW17bsbFPd/pBe5DFNZhQSWnOUt41ATFBagvjygDaOpiYo
         62J7wMp79geIT6GRT+gjXifp+0VcR8gXSKkd4nk/0kY3pkxISXwVA86aOf+t+AdlrKRe
         U7Y/TWL9S15pzXqvCbz7Fo4iNaFjd0uAUUBxFrQUZ7BwZ3283l1O3CNk3bQetk5ztkO4
         RIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQEhdxl+cSU7BC7XRTZDcCsNpOwQL3MJhJomrvmkJCY=;
        b=fZs9KPqpt8p2+Cnx8+BLVifKdwa4NGtCSJlqvn9Y2rn66UXuBMP5VpMnGU/1rWfvx+
         JEzNAnXdxO2oAhLIokZeCWf3bjENMRYexmTwbWEyt0PNNGEGu3wWak9hpr0Jc1EjnGZP
         XKpm5UUXkBfNLl/a4RJiP+ePdtk95sXzzxXYdObLXVIPY1vpM/wdumzAUr/PJlP2ZwGt
         pihZYa+qik+w361TmrsLRq+1WJHEBBG0o7p7jTqvlJ4t+wM672LLSUuHDDrH+w9+UdkS
         7tMDgXMXlnUfoTT4bY4d2IFLTXyO53a/nO/sOkiiQSH5NQ9jVjexpXoyjuAsvVoK01cs
         3vqQ==
X-Gm-Message-State: AOAM530gsQ4qcbLbLp+zmXEBb84g0nIpqXXcTKwWgji8JdfL9GyZCERx
        91wW6OPfhNyPQMt64POy3DB73geYGwVC1L6ceDpoDA==
X-Google-Smtp-Source: ABdhPJxPZM+yBj5h9pJP265DYko714wL+M/i9xL4wgwVQK69SoBcfbh2i4JxHFXtqH+bSlHJjvuHtaD+RYSUTCWwTuU=
X-Received: by 2002:a2e:3603:: with SMTP id d3mr10563594lja.495.1618011380903;
 Fri, 09 Apr 2021 16:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210409221155.1113205-1-nathan@kernel.org>
In-Reply-To: <20210409221155.1113205-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 9 Apr 2021 16:36:09 -0700
Message-ID: <CAKwvOdnTFXPy29L5JhcMBJAP4STfZUMn6739Mc4J_2Qwu3efBw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - Move '.fpu' after '.arch'
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 9, 2021 at 3:12 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Debian's clang carries a patch that makes the default FPU mode
> 'vfp3-d16' instead of 'neon' for 'armv7-a' to avoid generating NEON
> instructions on hardware that does not support them:
>
> https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/raw/5a61ca6f21b4ad8c6ac4970e5ea5a7b5b4486d22/debian/patches/clang-arm-default-vfp3-on-armv7a.patch
> https://bugs.debian.org/841474
> https://bugs.debian.org/842142
> https://bugs.debian.org/914268

Another good link would be the one from Jessica describing more
precisely what the ARM targets for Debian are:
https://wiki.debian.org/ArchitectureSpecificsMemo#armel

>
> This results in the following build error when clang's integrated
> assembler is used because the '.arch' directive overrides the '.fpu'
> directive:
>
> arch/arm/crypto/curve25519-core.S:25:2: error: instruction requires: NEON
>  vmov.i32 q0, #1
>  ^
> arch/arm/crypto/curve25519-core.S:26:2: error: instruction requires: NEON
>  vshr.u64 q1, q0, #7
>  ^
> arch/arm/crypto/curve25519-core.S:27:2: error: instruction requires: NEON
>  vshr.u64 q0, q0, #8
>  ^
> arch/arm/crypto/curve25519-core.S:28:2: error: instruction requires: NEON
>  vmov.i32 d4, #19
>  ^
>
> Shuffle the order of the '.arch' and '.fpu' directives so that the code
> builds regardless of the default FPU mode. This has been tested against
> both clang with and without Debian's patch and GCC.
>
> Cc: stable@vger.kernel.org
> Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
> Link: https://github.com/ClangBuiltLinux/continuous-integration2/issues/118
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Jessica Clarke <jrtc27@jrtc27.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Great work tracking down that Debian was carrying patches! Thank you!
I've run this through the same 3 assemblers.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/arm/crypto/curve25519-core.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/crypto/curve25519-core.S b/arch/arm/crypto/curve25519-core.S
> index be18af52e7dc..b697fa5d059a 100644
> --- a/arch/arm/crypto/curve25519-core.S
> +++ b/arch/arm/crypto/curve25519-core.S
> @@ -10,8 +10,8 @@
>  #include <linux/linkage.h>
>
>  .text
> -.fpu neon
>  .arch armv7-a
> +.fpu neon
>  .align 4
>
>  ENTRY(curve25519_neon)
>
> base-commit: e49d033bddf5b565044e2abe4241353959bc9120
> --
> 2.31.1.189.g2e36527f23
>


-- 
Thanks,
~Nick Desaulniers
