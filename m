Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D076B2EFA32
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbhAHVSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbhAHVSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:18:12 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4BDC061786;
        Fri,  8 Jan 2021 13:17:31 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 186so9807720qkj.3;
        Fri, 08 Jan 2021 13:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CwnmURqbXWi83+YJ2u0BfQ7YOsLloUGg9mtui9lPXE4=;
        b=NmZdsAfKHe+255PDndngVtKAu8nMd2MXHttlqF5HxQ45ZAGa/mNYrYpfHamJYuZgXl
         qyI2TRugzunZHHus/iRK/ZWD7Obx5ZiOiuf8V2ea76rwDLH+BWXZIUVzHXbhkVZclZzG
         S8u9q8PO10jcQUZkIGqKXDMNaggK/xl5lrkYhT2NYP6F9lGjhUORxa1QoLE//En6pd/4
         S/FX0ZNzchl27Fzu/llHmIVhh8sNdMhYnrGtgy26ayrTz42NFcXsEMMwOHTmF4uZFyLs
         uV15EYT6Wp5d8oSinBhwOHMg+2zihEnwQwR2z+ETl4jLiIsifubLzZPUwv375BE/BEPm
         vYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CwnmURqbXWi83+YJ2u0BfQ7YOsLloUGg9mtui9lPXE4=;
        b=a1sEj93XrNU5sIMVf1BCsaC00iV6Z9hjnOwsGptgjsQxI110TCE78LFuGpfNVuQJhF
         qhe6f/Ma54hknULt88MzZcEtPFb2Jl+y8ynqVMV76keZQhnGcQM9SS6VNL4DX6nrS8aN
         J1JwtIRybEIjU2Y2gXtZ4YTiQ8/Fgnp7eky79gmmL+ZafAZcDWynd2PKB9hgaCfbQ9MA
         5jVXy+ESFyCtSru87mWaOfQCMUqbFSaB4Ppkc7AJb7RTzHLVgLnBi1NbVHK8mKI0lXFe
         0o0DMBK2iLEuBr0JILD8UttUAtM5ccywCOmLyslkYm02VnrdseKeYpMpfLwG5ZvKe9SN
         klfg==
X-Gm-Message-State: AOAM531Um/AUMUxP33Ofcl0vf2T4BhYwdZBlkvLzgG94PgiPxlLrxzbX
        O49iv7c90NbkRM6XdSBHdGc=
X-Google-Smtp-Source: ABdhPJwYeJUt6gB0gAwhAnxzXp2NRRU8FBnM8XYYTz56YtbWM7wJOLi/BpXWdEJ/8lynUZTreKO2Eg==
X-Received: by 2002:a37:c442:: with SMTP id h2mr5841601qkm.283.1610140650847;
        Fri, 08 Jan 2021 13:17:30 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id a9sm5412026qkk.39.2021.01.08.13.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:17:30 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:17:28 -0700
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
Subject: Re: [PATCH v4 mips-next 5/7] MIPS: vmlinux.lds.S: explicitly declare
 .got table
Message-ID: <20210108211728.GE2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107132010.463129-1-alobakin@pm.me>
 <20210107132010.463129-2-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107132010.463129-2-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 01:20:49PM +0000, Alexander Lobakin wrote:
> LLVM stack generates GOT table when building the kernel:
> 
> ld.lld: warning: <internal>:(.got) is being placed in '.got'
> 
> According to the debug assertions, it's not zero-sized and thus
> can't be handled the same way as .rel.dyn (like it's done for x86).
> Use the ARM/ARM64 path here and place it at the end of .text section.
> 
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/vmlinux.lds.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 0f736d60d43e..4709959f6985 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -69,6 +69,7 @@ SECTIONS
>  		*(.text.*)
>  		*(.fixup)
>  		*(.gnu.warning)
> +		*(.got)
>  	} :text = 0
>  	_etext = .;	/* End of text section */
>  
> -- 
> 2.30.0
> 
> 
