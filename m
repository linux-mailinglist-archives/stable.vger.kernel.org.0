Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5E32EFA1E
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbhAHVRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbhAHVRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:17:02 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6024FC061757;
        Fri,  8 Jan 2021 13:16:22 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id p14so9781751qke.6;
        Fri, 08 Jan 2021 13:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HMTP4DMZypyBbg2Z/QgoI6zKf6gSO7jQrH+KkN6+xjM=;
        b=P4EKNOU7WlIuWILQXYWZpaP4A5X4wFLxLhnm+hXN4zmE5OoKvqwiuwb+IF1S4n80lR
         XykOhAQxPiq2qvk0qN9KSCFabubN/jMeZx95NPylCCAV2u+9+vyPdb09SLjf+7XxcNxt
         WMNdJZACLC08cevH7Gu1bbnirF3DPy9Ue7hEwRA26ffkvIVOVMtQ7BBmgR9CVk5djBhg
         8xE4eJSdBxTgqc5VUFAyqg9BoXUHtyc2gE0PZQLpL7rXjuEtNtZqFK4NVr80F3FKwslj
         Yh7W8X2XuGsBJlQ/tfBIaLwaFDGAwZyItETm9HndfUlX9Vzh73D6LwRRLEl9AK1YtLmJ
         gXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HMTP4DMZypyBbg2Z/QgoI6zKf6gSO7jQrH+KkN6+xjM=;
        b=pDS0ngAxMS91gMEO/vg3IFsy490Nxxs8kOdH8J9OSSVfV29IUK7NFOsGH1MeZvWEPH
         3j4auOAIeLiTBazgYDT5kjT+yDqyNMkm3Fil7UOxSMu5cHYyAPR6PyyHbTnuKV7tpwDE
         TUTvTiDJkphjCE7ZEEQ0djQElWrO+YVEr3YbWGv2D2EmTY8OU2dH4seJcdGKjKP7OIWY
         0nnas40cG3ZiyXgiaHSFL5+nNTBXVG+7pyCCluGiCWi8fdNHYPhWsFxp9iZcvAHs+C8j
         zc5PSovwniaAZnh8Vt1vwaRAA3SZPUnFkrPdKfh1vThwbuFiR51k4odcTuf+Cp+Pu9O9
         s6ZA==
X-Gm-Message-State: AOAM532xqjU8Bpq/5JRU3KC8SPQBFrW+FItcqyQLVNcG084IPEg+2lfP
        m2WfgU0K5kMY3cRKyAz20Js=
X-Google-Smtp-Source: ABdhPJxfL35M0hlqTEnuDKZfg9k7dtly9P6XMsUz8mpcpIMRqwYpKaliPfZszIzGV12s2+iLSRmGmw==
X-Received: by 2002:a37:c92:: with SMTP id 140mr5886796qkm.152.1610140581536;
        Fri, 08 Jan 2021 13:16:21 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id s14sm5598438qke.45.2021.01.08.13.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:16:20 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:16:19 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v4 mips-next 3/7] MIPS: properly stop .eh_frame generation
Message-ID: <20210108211619.GC2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107123428.354231-1-alobakin@pm.me>
 <20210107123428.354231-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123428.354231-3-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:35:01PM +0000, Alexander Lobakin wrote:
> Commit 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly") added
> -fno-asynchronous-unwind-tables to KBUILD_CFLAGS to prevent compiler
> from emitting .eh_frame symbols.
> However, as MIPS heavily uses CFI, that's not enough. Use the
> approach taken for x86 (as it also uses CFI) and explicitly put CFI
> symbols into the .debug_frame section (except for VDSO).
> This allows us to drop .eh_frame from DISCARDS as it's no longer
> being generated.
> 
> Fixes: 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly")
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/include/asm/asm.h    | 18 ++++++++++++++++++
>  arch/mips/kernel/vmlinux.lds.S |  1 -
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
> index 3682d1a0bb80..908f6d6ae24b 100644
> --- a/arch/mips/include/asm/asm.h
> +++ b/arch/mips/include/asm/asm.h
> @@ -20,10 +20,27 @@
>  #include <asm/sgidefs.h>
>  #include <asm/asm-eva.h>
>  
> +#ifndef __VDSO__
> +/*
> + * Emit CFI data in .debug_frame sections, not .eh_frame sections.
> + * We don't do DWARF unwinding at runtime, so only the offline DWARF
> + * information is useful to anyone. Note we should change this if we
> + * ever decide to enable DWARF unwinding at runtime.
> + */
> +#define CFI_SECTIONS	.cfi_sections .debug_frame
> +#else
> + /*
> +  * For the vDSO, emit both runtime unwind information and debug
> +  * symbols for the .dbg file.
> +  */
> +#define CFI_SECTIONS
> +#endif
> +
>  /*
>   * LEAF - declare leaf routine
>   */
>  #define LEAF(symbol)					\
> +		CFI_SECTIONS;				\
>  		.globl	symbol;				\
>  		.align	2;				\
>  		.type	symbol, @function;		\
> @@ -36,6 +53,7 @@ symbol:		.frame	sp, 0, ra;			\
>   * NESTED - declare nested routine entry point
>   */
>  #define NESTED(symbol, framesize, rpc)			\
> +		CFI_SECTIONS;				\
>  		.globl	symbol;				\
>  		.align	2;				\
>  		.type	symbol, @function;		\
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 16468957cba2..0f4e46ea4458 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -225,6 +225,5 @@ SECTIONS
>  		*(.options)
>  		*(.pdr)
>  		*(.reginfo)
> -		*(.eh_frame)
>  	}
>  }
> -- 
> 2.30.0
> 
> 
