Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C511D2F0ACA
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 02:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbhAKB2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 20:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAKB2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 20:28:53 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84306C061786;
        Sun, 10 Jan 2021 17:28:13 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e7so1532598ili.2;
        Sun, 10 Jan 2021 17:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RAxSHTZDZlT6yDjj0fm6U/ExdlmA3H8wyIJvn7l+DzI=;
        b=qSv/XpjfVT/EuN9MhavzUKyDjfAu2YH8znDEpJAL4hh2eaUqLmi/aRqM+mSHmNsc8S
         NlVdtopuesiO8cs4IM2xmvXTDoW6AYlEleBpmMS+2H7+UphFBa7DtArJELLVFnjKTey5
         AxIDqkE62mF0gxHkuZcOUF3+DwNt86h/RT7X4idOVscFCSjs2sSuCqt/3kYxqebsQDGy
         HKncjElq4v7GpGuVhSNZwHPZgsCvuYMgPwUKb2M6ssmjVQ7eSTAozjkln9IchTwaEhcJ
         j/gohOag6umPBdfhpBEpKMtpqfPRuCcL1/wOy4tDhJWtIUBt0B+PaZRJhQocTTaAqkX7
         xhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RAxSHTZDZlT6yDjj0fm6U/ExdlmA3H8wyIJvn7l+DzI=;
        b=LE8PrOwfhbvKEwnItVw5bSDw7wnwkIhMRjKTb0f+YLyY5CSiJBm2E85J+ZVk//q8Wc
         yS+yuITNaRgTUUH1poXFfuLZtnLk9gzjCsYG2gXtkyjinpsAYYM9iuYiNvzhafhLGF4c
         GBoakPRi9e+MXE6ND4O/1rVpfDEytaWh8okXXBRhb7g10FmBaJi6bsr6c9mULBzly54/
         ubNfM6AfDwAvucvhSDQyu76CKoIC+JCspPHYN0BN7QIA5stBfFySW9Pep2xGGVeEqCtA
         Ovuo5hjg/TnnDt8l893/UfHKiwzFm9pD/qErPO4+8XfsZ4iE8pb6unmS+Odi4Kgs1Hbc
         bn3A==
X-Gm-Message-State: AOAM530zIkU0mrAPq1H6oFpFbOIW8luy42hMt6NQJ+KCMQzq0YR5RwG3
        0DG+d8tKdMJYTbu+pufuPNM=
X-Google-Smtp-Source: ABdhPJzdENz7nIvxsLGzkDfRnGYxQIVnzJO6KI6K2yb50R26SbYPDHBjZV5oG1VS2aCkHvkz6i3Q3g==
X-Received: by 2002:a92:9f0a:: with SMTP id u10mr14002915ili.158.1610328492662;
        Sun, 10 Jan 2021 17:28:12 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id b12sm14065824ilc.21.2021.01.10.17.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 17:28:11 -0800 (PST)
Date:   Sun, 10 Jan 2021 18:28:09 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Kees Cook <keescook@chromium.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v5 mips-next 5/9] MIPS: vmlinux.lds.S: explicitly catch
 .rel.dyn symbols
Message-ID: <20210111012809.GA2918900@ubuntu-m3-large-x86>
References: <20210110115245.30762-1-alobakin@pm.me>
 <20210110115546.30970-1-alobakin@pm.me>
 <20210110115546.30970-5-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110115546.30970-5-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 11:56:34AM +0000, Alexander Lobakin wrote:
> According to linker warnings, both GCC and LLVM generate '.rel.dyn'
> symbols:
> 
> mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
> from `init/main.o' being placed in section `.rel.dyn'
> 
> Link-time assertion shows that this section is sometimes empty,
> sometimes not, depending on machine bitness and the compiler [0]:
> 
>   LD      .tmp_vmlinux.kallsyms1
> mips64-linux-gnu-ld: Unexpected run-time relocations (.rel) detected!
> 
> Just use the ARM64 approach and declare it in vmlinux.lds.S closer
> to __init_end.
> 
> [0] https://lore.kernel.org/linux-mips/20210109111259.GA4213@alpha.franken.de
> 
> Reported-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/vmlinux.lds.S | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 10d8f0dcb76b..70bba1ff08da 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -137,6 +137,11 @@ SECTIONS
>  	PERCPU_SECTION(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
>  #endif
>  
> +	.rel.dyn : ALIGN(8) {
> +		*(.rel)
> +		*(.rel*)
> +	}
> +
>  #ifdef CONFIG_MIPS_ELF_APPENDED_DTB
>  	.appended_dtb : AT(ADDR(.appended_dtb) - LOAD_OFFSET) {
>  		*(.appended_dtb)
> -- 
> 2.30.0
> 
> 
