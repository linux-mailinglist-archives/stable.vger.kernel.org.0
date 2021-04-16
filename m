Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F72D3627A8
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 20:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhDPSYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 14:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbhDPSYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 14:24:32 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6461C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 11:24:05 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v19-20020a0568300913b029028423b78c2dso17938685ott.8
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 11:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=NGL2DZ81iiy8zZ9X98sR3lExSRtmhzsEE2kmMo2vY6Y=;
        b=qRxg1AQVpABQRxRIqNU5TKPRxviJzaAJJQvMgYRNOw77gh3Yu7WQSV0s+T33hqXGiZ
         YBFdsywjmDeOsHpxDxYDsyBhOUeP377VvaPhkfyg1tqcZdAk8HxXX3LG3j/0I+oOX4Yr
         ggCsVdEKnxJGiqAcoWSC1Eg4vrEBC8ZnMNIH93EITdtCdb3PHD2BnenltnN05fYQ2WMi
         gm48T9giGwX9vwYFGU0RAs+fLMtWFJ5iGTQJSlvpbPpgFGkXLK1+hmGMSI1W4ilk9T+O
         8ruuAxK28VWV0B/hOOHgqrB69eysFrQkUM91ZAAW/yMAz7cEA/VNS3cd9pYTDqiN3rQw
         S2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=NGL2DZ81iiy8zZ9X98sR3lExSRtmhzsEE2kmMo2vY6Y=;
        b=nLoB6MwM/sCDkQnI+o/lyOcE0lVFwcjGfJggRGpX7fGQKrpRZc4zVFJAEyyfrJbRO/
         SaXOGOoCo1zmv+NrhPeRGvhOUAZYgBu6dbeCCfhUKtYzAN0mm9pVuVadGRfLqwkJhm/h
         MNF/wk2ntGxa9C31BdRy0Fd66pFmlo20ENP0yq6DS9Fb+isFbQdrNldwJKCRQ/tZJJt6
         w1svK8SWM9dWgoM21zfacfo6aChX+N3tu3Vp0hBcOYBtt+KSdIZjqMcsQ4OmltCJDxW+
         18bVZiludNd002AS63424zfvC42O75X9qtJjbzstIjLJxGaXnMpnK5g1zXZqq9j8u6C5
         wAzg==
X-Gm-Message-State: AOAM531Z3k8maMBjFJH8z7aRz+Sp4r/UPjRUXq0WVt3kxM6VzNJ1D51M
        SlrH7RUH5HGuu8cQy6tPnRR66PFTzkRXgpEMMD+VEFiIEOnrUPUt
X-Received: by 2002:a05:6830:200e:: with SMTP id e14mt4156139otp.111.1618597444844;
 Fri, 16 Apr 2021 11:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210416181421.2374588-1-jiancai@google.com>
In-Reply-To: <20210416181421.2374588-1-jiancai@google.com>
From:   Jian Cai <jiancai@google.com>
Date:   Fri, 16 Apr 2021 11:23:53 -0700
Message-ID: <CA+SOCLL28Hej9zMmKJpU5vffVGviDo59uG=kWm0zPtCyZodR5g@mail.gmail.com>
Subject: Re: [PATCH] arm64: vdso: remove commas between macro name and arguments
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I should've mentioned this patch is for 4.19 only as the code has been
rewritten in later versions, but requires a large amount of backports
(https://github.com/ClangBuiltLinux/linux/issues/1349). This is the
only blocker for 4.19 migration to LLVM's integrated assembler on CrOS
that I am aware of.

Thanks,
Jian

On Fri, Apr 16, 2021 at 11:14 AM Jian Cai <jiancai@google.com> wrote:
>
> LLVM's integrated assembler does not support using commas separating
> the name and arguments in .macro. However, only spaces are used in the
> manual page. This replaces commas between macro names and the subsequent
> arguments with space in calls to clock_gettime_return to make it
> compatible with IAS.
>
> Link:
> https://sourceware.org/binutils/docs/as/Macro.html#Macro
> Signed-off-by: Jian Cai <jiancai@google.com>
> ---
>  arch/arm64/kernel/vdso/gettimeofday.S | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
> index 856fee6d3512..7ee685d9adfc 100644
> --- a/arch/arm64/kernel/vdso/gettimeofday.S
> +++ b/arch/arm64/kernel/vdso/gettimeofday.S
> @@ -122,7 +122,7 @@ x_tmp               .req    x8
>  9998:
>         .endm
>
> -       .macro clock_gettime_return, shift=0
> +       .macro clock_gettime_return shift=0
>         .if \shift == 1
>         lsr     x11, x11, x12
>         .endif
> @@ -227,7 +227,7 @@ realtime:
>         seqcnt_check fail=realtime
>         get_ts_realtime res_sec=x10, res_nsec=x11, \
>                 clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
> -       clock_gettime_return, shift=1
> +       clock_gettime_return shift=1
>
>         ALIGN
>  monotonic:
> @@ -250,7 +250,7 @@ monotonic:
>                 clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
>
>         add_ts sec=x10, nsec=x11, ts_sec=x3, ts_nsec=x4, nsec_to_sec=x9
> -       clock_gettime_return, shift=1
> +       clock_gettime_return shift=1
>
>         ALIGN
>  monotonic_raw:
> @@ -271,7 +271,7 @@ monotonic_raw:
>                 clock_nsec=x15, nsec_to_sec=x9
>
>         add_ts sec=x10, nsec=x11, ts_sec=x13, ts_nsec=x14, nsec_to_sec=x9
> -       clock_gettime_return, shift=1
> +       clock_gettime_return shift=1
>
>         ALIGN
>  realtime_coarse:
> --
> 2.31.1.368.gbe11c130af-goog
>
