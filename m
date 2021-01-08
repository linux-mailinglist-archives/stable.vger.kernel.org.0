Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D302EF9FC
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbhAHVLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbhAHVLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:11:31 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673D3C061574;
        Fri,  8 Jan 2021 13:10:51 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id u21so7534840qtw.11;
        Fri, 08 Jan 2021 13:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3JRySsR0y1lPgH/q9MB+jQS3iEkJKrJjNV+INCLiO5I=;
        b=jsZr5xv1oPiOpT3wN+5lQzceXP9kYYbPmyH95MvSX9XPNkxqoSk5pFsROFwPIwtt9b
         vvaW7/llwaT5bqK7+LxZgOLe7Xbgvxxs1j5gtqqYWD39dfE2EQqJcjSeMDDLKz3Nl6WP
         dlypl7DlRhz37s2Hc6Jd/KBlHPoMHZ1K1y6I7bFDEedgMc83M8yABuQYFYlB5ZGFVws/
         jxrZdd4gIlGkr197Row3R4zX4Ly9L7eyatgVxYyIJJUrVxBBxmTW7pONHNalZB7+IlHm
         hwrDor75ekvoWYdYFxNCwi475/BguKoV6NYq9+miGhSdi2KKhZj0gTl5n5zRVD33lVGX
         JZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3JRySsR0y1lPgH/q9MB+jQS3iEkJKrJjNV+INCLiO5I=;
        b=FSd5m8x7cmeKOQQIP80t74J9RrxA+b8TPEk09NgkB4MqT4TPWZSgdLfWXQJDSu3V9U
         XG5wdl7KuHlmy2WeFxQzBaNKDmT/he3f71Oxqndr2uCjqW394viqXl4KNr6zej95xHNO
         1Ax8R9/qf1OVmS/NORvo/GQkiqd39TAkbXRwrFfXAAZkp2IcSLDbHz22T3AmcSBJVu0W
         4eIStqNSHsiOUmrTSYSK4Ak/0DorMdlryaYf/r0UOS5rxKywnn1tY9ZdBBhYre4ufP0b
         4yiHyYKdm0I5qfT14SRAK6ICtPSOhckjoLHKcWTMELWuWKAscaylNAt+iUy6+ZWgHnLQ
         al9g==
X-Gm-Message-State: AOAM533ahuKZiq06YDWSOHhV0V2aVJHRHaVt0ax6TZ9MliVK/OabuBMT
        k7eQ/SpchcoCKJu9vkT//8A=
X-Google-Smtp-Source: ABdhPJzUqh5hJvTW8M8USXkMtF+AtfvR+Be56U3LAFLPVwO86EtlvnYWjDNfOWY1G4Tqlc5H5VZTPw==
X-Received: by 2002:ac8:72c1:: with SMTP id o1mr2813356qtp.35.1610140250520;
        Fri, 08 Jan 2021 13:10:50 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id s186sm5517909qka.98.2021.01.08.13.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:10:49 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:10:48 -0700
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
Subject: Re: [PATCH v4 mips-next 1/7] MIPS: vmlinux.lds.S: add missing
 PAGE_ALIGNED_DATA() section
Message-ID: <20210108211048.GA2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107123428.354231-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123428.354231-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:34:47PM +0000, Alexander Lobakin wrote:
> MIPS uses its own declaration of rwdata, and thus it should be kept
> in sync with the asm-generic one. Currently PAGE_ALIGNED_DATA() is
> missing from the linker script, which emits the following ld
> warnings:
> 
> mips-alpine-linux-musl-ld: warning: orphan section
> `.data..page_aligned' from `arch/mips/kernel/vdso.o' being placed
> in section `.data..page_aligned'
> mips-alpine-linux-musl-ld: warning: orphan section
> `.data..page_aligned' from `arch/mips/vdso/vdso-image.o' being placed
> in section `.data..page_aligned'
> 
> Add the necessary declaration, so the mentioned structures will be
> placed in vmlinux as intended:
> 
> ffffffff80630580 D __end_once
> ffffffff80630580 D __start___dyndbg
> ffffffff80630580 D __start_once
> ffffffff80630580 D __stop___dyndbg
> ffffffff80634000 d mips_vdso_data
> ffffffff80638000 d vdso_data
> ffffffff80638580 D _gp
> ffffffff8063c000 T __init_begin
> ffffffff8063c000 D _edata
> ffffffff8063c000 T _sinittext
> 
> ->
> 
> ffffffff805a4000 D __end_init_task
> ffffffff805a4000 D __nosave_begin
> ffffffff805a4000 D __nosave_end
> ffffffff805a4000 d mips_vdso_data
> ffffffff805a8000 d vdso_data
> ffffffff805ac000 D mmlist_lock
> ffffffff805ac080 D tasklist_lock
> 
> Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
> Cc: stable@vger.kernel.org # 4.4+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/vmlinux.lds.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 5e97e9d02f98..83e27a181206 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -90,6 +90,7 @@ SECTIONS
>  
>  		INIT_TASK_DATA(THREAD_SIZE)
>  		NOSAVE_DATA
> +		PAGE_ALIGNED_DATA(PAGE_SIZE)
>  		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
>  		READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
>  		DATA_DATA
> -- 
> 2.30.0
> 
> 
