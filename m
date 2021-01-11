Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3E2F0AF7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 03:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbhAKCG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 21:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbhAKCG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 21:06:28 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA38AC061794;
        Sun, 10 Jan 2021 18:05:46 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id q137so16276621iod.9;
        Sun, 10 Jan 2021 18:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O1Kg6nMHufkZJeFYAwU5JUMRxW+lQuNTmDBb784fKLc=;
        b=Vt8cM4sIB7OYJUrgM3yoTwIiJQRgAu2Dznr3/L7+FKAL3xZgwNjPdHWIg6GnZBz2iN
         sXumGAMQvqR/4bFAFcrCiDJeycEaHCmnDI+yCPtKmZYpWe21aqeI1j5IpbermaSNES6U
         nxd4taVf1HnNL5Y9nIIpudp7zrgNcp/Rdp8oepy81hPxByCNvhva7GhyG9Eztrx7xIft
         +hxrEezGPKuYq/PTiV0ZQ632WCGbTlv0QmWT3YyaEj7cYiO3AdYYZtw8A3Yw5l0cZqS2
         809kJQIAqF9mmoTi9VOpgAG404UJppuLzIkGtG1OpSnEMhvCsw8gYdJ2sGj+3bYlsFeJ
         g4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O1Kg6nMHufkZJeFYAwU5JUMRxW+lQuNTmDBb784fKLc=;
        b=MYwwiQ7OnGUF9PVlIxza/r0QupsA1sCY8n/s/aeg1Eo+2vydTO4WFT/nXo7tPpwP+g
         6rzrHZuqXZpz2pvSIx7dXzg/lcaMnq/uv7jXfnPcRuhACj892IxTrzJqJngBTCLzfpo1
         7/Z+/szoraATUQ4kxK+j37WYpGQgBJEjLRnncniJFotMmN5kWqNBryNP4GLAqPlqY0u9
         DJFOI5BuE+ABpg5EDtSahAgH7LAxJCZzdnVdxvBqxmtkfG2paNSp/4LEYJTZBu6QdQ2d
         pOD25k3EYUbOKITTx0Xc1Kgnx7r8Orky5Z5kA9lNzt/2FXIOLNe5L5nWyzmB8ViBC4fx
         /v7A==
X-Gm-Message-State: AOAM532jib8PLJsCEYIL1qu4nGGRDmWFHn3tey3DTn1LAbUoF8FfvHT9
        gxAftBxApc+cNcaHOJIqhrA=
X-Google-Smtp-Source: ABdhPJxpGqWV/N6xmJu1TUV1fv4X2+6NSxUeLZ0HWxBbh22Uqr5xRH23rGDIw3wopmDSmfldqAUpgA==
X-Received: by 2002:a02:8482:: with SMTP id f2mr12628976jai.93.1610330746162;
        Sun, 10 Jan 2021 18:05:46 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id k9sm9487484iob.13.2021.01.10.18.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 18:05:45 -0800 (PST)
Date:   Sun, 10 Jan 2021 19:05:43 -0700
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
Subject: Re: [PATCH v5 mips-next 8/9] vmlinux.lds.h: catch UBSAN's "unnamed
 data" into data
Message-ID: <20210111020543.GB2918900@ubuntu-m3-large-x86>
References: <20210110115245.30762-1-alobakin@pm.me>
 <20210110115546.30970-1-alobakin@pm.me>
 <20210110115546.30970-8-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110115546.30970-8-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 11:56:54AM +0000, Alexander Lobakin wrote:
> When building kernel with both LD_DEAD_CODE_DATA_ELIMINATION and
> UBSAN, LLVM stack generates lots of "unnamed data" sections:
> 
> ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_2)
> is being placed in '.data.$__unnamed_2'
> ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_3)
> is being placed in '.data.$__unnamed_3'
> ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_4)
> is being placed in '.data.$__unnamed_4'
> ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_5)
> is being placed in '.data.$__unnamed_5'
> 
> [...]
> 
> Also handle this by adding the related sections to generic definitions.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  include/asm-generic/vmlinux.lds.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 5f2f5b1db84f..cc659e77fcb0 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -95,7 +95,7 @@
>   */
>  #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
>  #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> -#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliteral*
> +#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliteral* .data.$__unnamed_*
>  #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
>  #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
>  #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
> -- 
> 2.30.0
> 
> 
