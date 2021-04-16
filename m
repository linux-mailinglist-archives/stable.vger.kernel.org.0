Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA73362A75
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhDPVkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235540AbhDPVkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 17:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15D47610CD;
        Fri, 16 Apr 2021 21:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618609228;
        bh=f9EMaN2F4fCZmxXmeuotxslIHmkZ/94dl7T4HpTXfNI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u+fyM+ZwLXAlJk8yv0LciwwSykMvw0Rc9UjpyPdZA7Lk93OU7QwRUNHRqXuOSnROY
         g83g7pLGFUu2SA7KOIAfcduuez9vNFxXG81RRqY1OgYz/Flq/WrMmMs4zQASzUQrjf
         HUg7PfOekKDh/CFmTqsnVAiu8qXONIecZ0KVtpn8SnDb3ELNDExByYlYV6yDKW64RP
         0sLEm2lp/RMZIh+MswcJ6ewa7TV4NQz++xnc9a0egpCdsWk9B3Lhx1V1P8eoa1JLRq
         +APmYuo902xg5JSmvdqlvMDLhs6g7OzcXbUTQL71G78imxv2fECBLXjFAWDXXO+xtL
         wtJi59SKr9skw==
Received: by mail-oo1-f46.google.com with SMTP id t140-20020a4a3e920000b02901e5c1add773so5199882oot.1;
        Fri, 16 Apr 2021 14:40:28 -0700 (PDT)
X-Gm-Message-State: AOAM5332FexiILrjDk1SeWTnMo8Vez9fJv0DXcxfIG+yXA1rIAlLNihh
        TV93miBjrfb0H7oDr8birho7lgFqd/hUTple/rU=
X-Google-Smtp-Source: ABdhPJxdMfsuLGWVNA5ayxm2yN4i+p/QjzTTX7AmIEAoxUU4u9K4CkFF2lNyvgjAd1ckXELnyhHc/v9XkbxeNcsWg0c=
X-Received: by 2002:a4a:b997:: with SMTP id e23mr4811719oop.13.1618609227327;
 Fri, 16 Apr 2021 14:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210416181421.2374588-1-jiancai@google.com> <20210416203522.2397801-1-jiancai@google.com>
In-Reply-To: <20210416203522.2397801-1-jiancai@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 16 Apr 2021 23:40:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEBR7MMiXyOEHO+si1Fp7ZfzqFD-ks-tS=_3ncw_RmKVg@mail.gmail.com>
Message-ID: <CAMj1kXEBR7MMiXyOEHO+si1Fp7ZfzqFD-ks-tS=_3ncw_RmKVg@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: vdso: remove commas between macro name and arguments
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

On Fri, 16 Apr 2021 at 22:35, Jian Cai <jiancai@google.com> wrote:
>
> LLVM's integrated assembler does not support using commas separating
> the name and arguments in .macro. However, only spaces are used in the
> manual page. This replaces commas between macro names and the subsequent
> arguments with space in calls to clock_gettime_return to make it
> compatible with IAS.
>
> Link:
> https://sourceware.org/binutils/docs/as/Macro.html#Macro
> https://github.com/ClangBuiltLinux/linux/issues/1349
>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>

Please remove this tag - the only thing I suggested was to drop part
of the original patch.


> Signed-off-by: Jian Cai <jiancai@google.com>
> ---
>
> Changes v1 -> v2:
>   Keep the comma in the macro definition to be consistent with other
>   definitions.
>
>  arch/arm64/kernel/vdso/gettimeofday.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
> index 856fee6d3512..b6faf8b5d1fe 100644
> --- a/arch/arm64/kernel/vdso/gettimeofday.S
> +++ b/arch/arm64/kernel/vdso/gettimeofday.S
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
