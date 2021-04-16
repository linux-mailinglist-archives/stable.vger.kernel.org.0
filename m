Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB66362850
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhDPTIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235753AbhDPTIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 15:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE64613B7;
        Fri, 16 Apr 2021 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618600095;
        bh=NaGNzCN+2i1mRkbQ3L8O3kT96tguq6/zzGA/BfG16zE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Se7Phvu52mCL6v++fyg/yYnlisNjRghz6hwAV2XsD/4Kby7/H1VU1GIpLdHLvw2xV
         edCOHjiY8uPmTO6Yj+0J7kj1B8Y/SJYSXiqhmjdptegP7aVKdrFzTsqtEyP4YdY9Bu
         CPqNVlUE2weVJfZrLQnD0JTTrBwmIV9Afz4HKK1ujz08pxlBxAdMsnX+z7ZQHvRy3H
         ee3CkWSQaLufdbInyVJ169R2Etx5aG7M98khcKPFS4SYr5Gc+7lzWOOeIISCsRdnbu
         5iez+ua0fYrUgbINs0fNnaPDyVIH8Mgls3T/4Isv7vaC8WIpKAvoTi45cJcQJt7bY2
         fIUGNrOhq31eQ==
Received: by mail-ot1-f47.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso4190085otl.0;
        Fri, 16 Apr 2021 12:08:15 -0700 (PDT)
X-Gm-Message-State: AOAM530XDXOhcp6l2VFPqnriLWPIix4NzpD2dTJYTuzmC8UjgnwRccJk
        JxWHKZcHbH89n7gqVViR77KRCCpI9n9p5a5+3kM=
X-Google-Smtp-Source: ABdhPJzH4WO2KOFQOPbyOUxhDnRNTxX6dPIFmPJydsDOQ9kfHGzNvNc+8aTDKXSJsr1QIEoNWd6hBlT/LoVfvEmILo0=
X-Received: by 2002:a9d:75c1:: with SMTP id c1mr4730792otl.108.1618600094987;
 Fri, 16 Apr 2021 12:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210416181421.2374588-1-jiancai@google.com>
In-Reply-To: <20210416181421.2374588-1-jiancai@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 16 Apr 2021 21:08:03 +0200
X-Gmail-Original-Message-ID: <CAMj1kXER9EmB4wD9SbFhJL5VHc1qJ_bDC+GhPTFdxzHAJWLT0w@mail.gmail.com>
Message-ID: <CAMj1kXER9EmB4wD9SbFhJL5VHc1qJ_bDC+GhPTFdxzHAJWLT0w@mail.gmail.com>
Subject: Re: [PATCH] arm64: vdso: remove commas between macro name and arguments
To:     Jian Cai <jiancai@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Apr 2021 at 20:16, Jian Cai <jiancai@google.com> wrote:
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

Are you sure the definition needs to be changed as well? The majority
of GAS macros in arch/arm64 (if not all) use a comma after the
identifier, so I would prefer not to deviate from that arbitrarily.

Just look at

$ git grep -E \.macro\\s+\\S+,  arch/arm64/*.S


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
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
