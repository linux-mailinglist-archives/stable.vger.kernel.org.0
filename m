Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7B32EFA3C
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbhAHVTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbhAHVTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:19:46 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3368BC061574;
        Fri,  8 Jan 2021 13:19:06 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id 2so7548241qtt.10;
        Fri, 08 Jan 2021 13:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FT8leUKcQW0PbWbAqTVuy6I1pPu6asWx5VuvUk3OGU0=;
        b=ldFjd7QEAoot+4bc90T+cGOopb7MJhsAriABNvpBJNnORtF7foNGMXIt/DCLHLLiko
         X/E1kW0YQ0ajzR7D6Hd3PWn/Q79xZrFAQxptsdz4Zk5+H0K6F03nTYXck82taYpiqwYD
         EjCsKxf1rhikMbj/TtRWKbkPl4qCxhnhgvF6Qp+0avDZ3W6/18yPCJ/d8vxruCIDjVhD
         X3iGWWyabEB+60KSJwxj34YUl1ZiPewWP7RkIyYpVgpV7OLKapEnaTqvZys+mEw1BJes
         Q6ArnijyCqb1UgCNHOvZAnRpnbFpOjzF91L2LduPR3oXSLmP++shftBTipa+KFwzieAz
         fKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FT8leUKcQW0PbWbAqTVuy6I1pPu6asWx5VuvUk3OGU0=;
        b=TmZQFi2R9X157Q9n74IG0cVoklpOfQWue+t4A7vppk/mX8+GVYg8YcWeTDTO52v+t4
         3gD/MyiCztCZwPbt41fT0Iaz0ScEoS6FBpbqZXr6+4RGy/1kzATqoQ7YoVBKMXnbpXt4
         1ZczhddDrzVCeEQ89bCHM5Y7MMazYaIo2woiqb3p9NXfFPudiDPsptB/RZPIwy/e1C81
         Pm5hKJ5hV0sySKl/Xf8kgszNwHAUc1fUNPs1JU6hWj4XsixhQcdEyNbwxgl9TU4v+l1T
         ZC3FFHfaGRcpicu1biqh/c5UjfzXqPHD+7Goh66AaYvn80SCUPKDQaNGLFjIuxW1zBAs
         h8Tw==
X-Gm-Message-State: AOAM532V4uzgLWAf2C/UYMyLd1fST2kEa5ZfMEbACIvi29uqaJ0Tqecm
        p4AJ/ikiTEW+fc2vgUMO44Q=
X-Google-Smtp-Source: ABdhPJwXR85WUk2uK/FbRNd/B1DnI7feLX9vmw2Gdl1bj4XQ72b9R23KlhnbciRs+xN7GkOABAJUTQ==
X-Received: by 2002:aed:231d:: with SMTP id h29mr5412755qtc.238.1610140745288;
        Fri, 08 Jan 2021 13:19:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id l204sm5408189qke.56.2021.01.08.13.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:19:04 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:19:03 -0700
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
Subject: Re: [PATCH v4 mips-next 6/7] vmlinux.lds.h: catch compound literals
 into data and BSS
Message-ID: <20210108211903.GF2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107132010.463129-1-alobakin@pm.me>
 <20210107132010.463129-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107132010.463129-3-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 01:20:55PM +0000, Alexander Lobakin wrote:
> When building kernel with LD_DEAD_CODE_DATA_ELIMINATION, LLVM stack
> generates separate sections for compound literals, just like in case
> with enabled LTO [0]:
> 
> ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
> (.data..compoundliteral.14) is being placed in
> '.data..compoundliteral.14'
> ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
> (.data..compoundliteral.15) is being placed in
> '.data..compoundliteral.15'
> ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
> (.data..compoundliteral.16) is being placed in
> '.data..compoundliteral.16'
> ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
> (.data..compoundliteral.17) is being placed in
> '.data..compoundliteral.17'
> 
> [...]
> 
> Handle this by adding the related sections to generic definitions
> as suggested by Sami [0].
> 
> [0] https://lore.kernel.org/lkml/20201211184633.3213045-3-samitolvanen@google.com
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  include/asm-generic/vmlinux.lds.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2b3d81b1535..5f2f5b1db84f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -95,10 +95,10 @@
>   */
>  #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
>  #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> -#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
> +#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliteral*
>  #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
> -#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
> -#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
> +#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
> +#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
>  #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
>  #else
>  #define TEXT_MAIN .text
> -- 
> 2.30.0
> 
> 
