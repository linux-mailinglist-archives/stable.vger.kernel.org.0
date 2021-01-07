Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EABB2EE7F5
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 22:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbhAGVw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 16:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbhAGVw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 16:52:26 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F69BC0612FC
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 13:51:41 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id h186so4872991pfe.0
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 13:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gkilXEcZuToD5vPEj+Iw2iyngHBEJ9jViAa6mux7/AE=;
        b=PnZqIrWhxcDfjmbGE75JBePgC4PFM1qGfPEhfhbT1bTzuSG6DEasZacDbvCKVBdceT
         T7zD6Zk+UVtji3j4dz5CGa/MDJC13QJ8zpkOon95bTSuKXsjnS9GueP4eo2zO3kxj2Ym
         uryPmXHf06rD6C34hfBrb7YcB9PLp2yQ/pERM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gkilXEcZuToD5vPEj+Iw2iyngHBEJ9jViAa6mux7/AE=;
        b=JylZjrJKy1X2eMjyJrn/XSUguM0nZEeEs+WjGrS0icWE1x2luLpZp2XlWsV37SOLYe
         unVj5L7WS3TjmjUnEnm0fdZCsfnjTKOL4YlWXiyDPhQQLVxQfqH/cFi6rQfTjlJMWjfk
         hqJB6crEXpu9/dDwDstISiJa/nE/OKUoRHGw5HtBM5n0/6IzmqS0GOz7FUXBjdQJFXkQ
         4j7G196DSlocYMl/D/MsOLiWOh630KI8Di5ZWmvFG+neQsvmhWrm6QDnPTNigIcuZ/9R
         v4B/nwzIOFzKLqlS1IIJcJLz6bqKKm1fGRWml1W/V2Lx3zKLtl4Z5/vCEdJBGEgZXnMQ
         Iv2w==
X-Gm-Message-State: AOAM532/XAA+mIiifRsSQ9uAyzi7NvZcTWoAufCGakBUq9AzGyhP5NvK
        +PNASTRNZDASuwdzObIwlfVLiw==
X-Google-Smtp-Source: ABdhPJx6Eiyate0dX5kPVmbgfsXZh+4uKr25slbHDdvfM14FtVTlDHkX0SOnxAtoGtlNnD3KkF2iYQ==
X-Received: by 2002:a63:eb0c:: with SMTP id t12mr3820364pgh.7.1610056301288;
        Thu, 07 Jan 2021 13:51:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b6sm6608979pfd.43.2021.01.07.13.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:51:40 -0800 (PST)
Date:   Thu, 7 Jan 2021 13:51:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
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
Subject: Re: [PATCH v4 mips-next 0/7] MIPS: vmlinux.lds.S sections fixes &
 cleanup
Message-ID: <202101071351.1CFD6D8@keescook>
References: <20210107123331.354075-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123331.354075-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:33:38PM +0000, Alexander Lobakin wrote:
> This series hunts the problems discovered after manual enabling of
> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>    placement (marked for stable);
>  - properly stops .eh_frame section generation.
> 
> Compile and runtime tested on MIPS32R2 CPS board with no issues
> using two different toolkits:
>  - Binutils 2.35.1, GCC 10.2.0;
>  - LLVM stack 11.0.0.

Nice! Thanks for hunting down the corner cases. :)

-- 
Kees Cook
