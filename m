Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11EC24C7B8
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 00:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHTWVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 18:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgHTWVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 18:21:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB690C061385;
        Thu, 20 Aug 2020 15:21:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so56133pjx.5;
        Thu, 20 Aug 2020 15:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UFbUcaXhdibf9fMHCSPTDSV1bpL4d5QWyfKneZ3Yr/k=;
        b=gksUqMBTx2CP5k0wbpGbdJJvf7ARiR+SbfUrL6+UWsCFWKDY2Sb2PUy0DeRIgms/w/
         QcOe1u4xHbHDCd+chUbSefLJRAYscqQu+q1hEeIl6wJkQB+jNbhUU2A3Nh+bXJZVD0Do
         dRElyGG8M7RDxyQHMeLvx5cxoXk3o/uMdM9rI/t0O9BIIoHgSFKjpHZobH/Uo0ZlYN6D
         +R+XzTTYAoXb3hFNCadfsx8OsuwtrqPhxcfOuYhG4Y41LPAIGlSaXVokFpK0tEgwtosJ
         wIQsYENducWCwiL4YtbNkQVjlgSXMGY34WNKGbAjbl2QFEcVnTCMCffTVLd2OKFBMbny
         QANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UFbUcaXhdibf9fMHCSPTDSV1bpL4d5QWyfKneZ3Yr/k=;
        b=DDBT2bNb8y+KoGf8ANFez6/3CBEYDa4nJWJ3zk3mUjsXa55BiZYRcl1AC45bWtJ6S3
         QXG16qC/5boeFJZFlJZ7B01gd+VmeQpEFXZgRgaF5RhhZO00dpmTVN2GKR1MmweznXpN
         LLQJMuLxV3uHZXYhlVA6GgUGbN+mkxhIw5YuYDbicqsTXqQQbvZLSfj+Bw6UhvlaMif2
         dr4mANMr2AFVEwS/qtHSkV/3yuV3DWComXv1vBS3fYAd4lerH0OQTVLCmgHQ/FE8ZxSB
         39mo7WquwwaPoD8Ju05WXnb1yRTKlrEO+GUQbTanRq0YgzDsaQsMiNrJ+gK/wN4EVdiK
         eLCA==
X-Gm-Message-State: AOAM531SUvm5KtDZv2gZZ0dCh4An5p662ziLsNHc40vT0dQjZjcWtoFO
        VAlvB/hJnoVXdR5QVQXmKhY=
X-Google-Smtp-Source: ABdhPJykEVxjjC0l5nmHNKtEuv/cLRBexKGZ8KvzUgIxO8IouTHKsNGeGf8G0vG2jqPghI4W3syXuA==
X-Received: by 2002:a17:90b:8c5:: with SMTP id ds5mr365851pjb.110.1597962061288;
        Thu, 20 Aug 2020 15:21:01 -0700 (PDT)
Received: from Ryzen-9-3900X.localdomain ([89.46.114.77])
        by smtp.gmail.com with ESMTPSA id w23sm49072pgj.5.2020.08.20.15.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 15:21:00 -0700 (PDT)
Date:   Thu, 20 Aug 2020 15:20:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>, stable@vger.kernel.org,
        Matthias Maennich <maennich@google.com>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] Makefile: add -fuse-ld=lld to KBUILD_HOSTLDFLAGS when
 LLVM=1
Message-ID: <20200820222059.GA10485@Ryzen-9-3900X.localdomain>
References: <20200820220955.3325555-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820220955.3325555-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 03:09:55PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> While moving Android kernels over to use LLVM=1, we observe the failure
> when building in a hermetic docker image:
>   HOSTCC  scripts/basic/fixdep
> clang: error: unable to execute command: Executable "ld" doesn't exist!
> 
> The is because the build of the host utility fixdep builds the fixdep
> executable in one step by invoking the compiler as the driver, rather
> than individual compile then link steps.
> 
> Clang when configured from source defaults to use the system's linker,
> and not LLVM's own LLD, unless the CMake config
> -DCLANG_DEFAULT_LINKER='lld' is set when configuring a build of clang
> itself.
> 
> Don't rely on the compiler's implicit default linker; be explicit.
> 
> Cc: stable@vger.kernel.org
> Fixes: commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default tools to Clang/LLVM")

Minor nit, "commit" is unnecessary here and might be flagged by some tag
checking scripts.

> Reported-by: Matthias Maennich <maennich@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Regardless of the above, this should work fine so:

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index def590b743a9..b4e93b228a26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -436,6 +436,7 @@ OBJDUMP		= llvm-objdump
>  READELF		= llvm-readelf
>  OBJSIZE		= llvm-size
>  STRIP		= llvm-strip
> +KBUILD_HOSTLDFLAGS	+= -fuse-ld=lld
>  else
>  CC		= $(CROSS_COMPILE)gcc
>  LD		= $(CROSS_COMPILE)ld
> -- 
> 2.28.0.297.g1956fa8f8d-goog
> 
