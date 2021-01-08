Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC562EFA41
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbhAHVUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbhAHVUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:20:03 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2407C061793;
        Fri,  8 Jan 2021 13:19:22 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id f26so9827319qka.0;
        Fri, 08 Jan 2021 13:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hnXLl4sHbKEop6wOqXRNzmI1tuKMV2HMaSYRF/O+288=;
        b=unfNElP7xA2Sx2i4/PYLes/KURdHDgTBaRSIhvDyW1dATgDtcLx8X7bdS3KdW8COcH
         hq46bxmUjaPgcv5cHp0eTddMSVvu9fj1f772wnAxJwi9gGEhY6aXcHu/rcx/DKMdp4Bt
         USaMgeXqktWYH8f78nEQv0dP4ftyWtZ1eyVIsZveFCwBwOw/DhqO/Xc8przOBA5FDTjm
         XehhfkW/vSUFay0ft5eiEvAOMB7MJBXTV99GFXbu7r+4diYhqjJbT6f4bZkQpqf5ifvc
         UE7pZArnW+Sl+dBeWuqLc6mYCfvzmRCZAoGu4kCdSW4bdq5BZRNdAKvsOwweEPzLdDKw
         aBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hnXLl4sHbKEop6wOqXRNzmI1tuKMV2HMaSYRF/O+288=;
        b=gdv2gPfPejbrZgovXh2iMfzTXDumJTsZpIZrYOJvFPF/OwPMj/pjWcAFJl+lxgLNO4
         biy+HQSdtmxksit3Gl/KpTgH1YwGj2flxkr5vRyAzI/M1kDnaFpFE34uL4FUIUhwzJ6i
         JaEcc05UYccKNIgfSlGwwe0JLoHHt3UjPwKxhdazbeGZ2FhRsb/7pdT8Lf5Ol8GoADsR
         E5mohBIDwb/dniXadVKnubo4H7BCz6GTxwWht7Fq8a9be/Ztml2BQEBgReBmnu4Q9sZK
         /YwACuUi+GiEH++4M2vmjHtxUFoyl+Fpttpyn2KBWrDczO8jChepfr9kHr+Yauj7K3bO
         KI/g==
X-Gm-Message-State: AOAM530dX5nyn4xNiyVAEel9Gb9jRgeK8IL8cWzET8ajmPQ8RB6CFDQx
        GHOhw5i2Otzq/1w5mNoYJ5E=
X-Google-Smtp-Source: ABdhPJxdd6u4Oceg1KPjIbdklnamT9CZ5Zdtmx32wCgErkWYrB9pYGhZFRq1edyAuj4fGTauhEeq0Q==
X-Received: by 2002:a05:620a:ec5:: with SMTP id x5mr5797597qkm.143.1610140761875;
        Fri, 08 Jan 2021 13:19:21 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id p128sm5732545qkb.101.2021.01.08.13.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:19:21 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:19:19 -0700
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
Subject: Re: [PATCH v4 mips-next 7/7] MIPS: select ARCH_WANT_LD_ORPHAN_WARN
Message-ID: <20210108211919.GG2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107132010.463129-1-alobakin@pm.me>
 <20210107132010.463129-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107132010.463129-4-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 01:21:02PM +0000, Alexander Lobakin wrote:
> Now, after that all the sections are explicitly described and
> declared in vmlinux.lds.S, we can enable ld orphan warnings to
> prevent from missing any new sections in future.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index d68df1febd25..d3e64cc0932b 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -18,6 +18,7 @@ config MIPS
>  	select ARCH_USE_QUEUED_SPINLOCKS
>  	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
>  	select ARCH_WANT_IPC_PARSE_VERSION
> +	select ARCH_WANT_LD_ORPHAN_WARN
>  	select BUILDTIME_TABLE_SORT
>  	select CLONE_BACKWARDS
>  	select CPU_NO_EFFICIENT_FFS if (TARGET_ISA_REV < 1)
> -- 
> 2.30.0
> 
> 
