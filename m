Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B932EFA05
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbhAHVMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbhAHVMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:12:50 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD05C061574;
        Fri,  8 Jan 2021 13:12:10 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id p14so9770669qke.6;
        Fri, 08 Jan 2021 13:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6xrx36MCllhkC/SSYNU9FX21dLUBr12VQ4uA3o+Xi4U=;
        b=r9pjJ8n5tYXlLPPxSEIzSJ25YWxhjrv8+ExIXNGrip1Z7+IVcukGmAmsHVmkAu4KnU
         R+9M83P52Our6sHgNPs4udSqvHr86FrFdyMO8wmL6CEHkCHMVKFkCHjYtDdM9naKvAA5
         PR4ZIPbQdDRqpwxLO8hJSvQ5NtBEcvfgfc0+BI/jR9PWivraO9h4kck50gX9HstHqsJk
         W65l3tkGhIz1IrYpVUcMdi4Db1WUZcD/b/yj8pMvqSetBIXWMni7YwIUq//fZQFJu0YW
         MepQrx+Hy5FKCLkSU84GChl7P7R1BN5hq4QAuCzN0vs/cibcRcW8RUcd9XjWDyIFTGfX
         MYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6xrx36MCllhkC/SSYNU9FX21dLUBr12VQ4uA3o+Xi4U=;
        b=kst5l1bBhK/0i06qVMsBmRfQ7Mp2v22xbwYeq75VnWOYyZXQXU/iyHrNRBds5THSAx
         7LcUQYkIcJ7bszyVv+Poaw9fvMN1ySWXlrg1PW6MhqWEDkxWWnrYbgtG5cPwVr228eG4
         V7MTYeaG+XiyiKl+dLmxD6C32XOdGuorQ21999Vi4hGeNKUxNvrAbacHjyCPPBchjdkL
         MNwnoRUzOeuZH9VP/xXfhwqTDZ5H0mHtmyp1hwCYfxt107s5AQj5R7RXhg+SbDLaIeIy
         HxIFvjp1JsM/fScwi2BQAR6HonafbkXTe5kxBUD4lCIgCZDFXcuV+FSILDqhIvQhGWKp
         OcrA==
X-Gm-Message-State: AOAM533QKv8eroGYhb9xHK4FoJlhc7BGlgCjRH+wplyycYFyfdKWxJJP
        3TWj7HY8klccM+zNkaB0RGI=
X-Google-Smtp-Source: ABdhPJygjj44MQ3gLe0hjN4mMcYX2BbIDORIFU1CKTxikCWNzwjwDdaeRpDJEH81xgO06fLTH0XVqg==
X-Received: by 2002:a37:418d:: with SMTP id o135mr5954034qka.426.1610140329673;
        Fri, 08 Jan 2021 13:12:09 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 60sm4850070qth.14.2021.01.08.13.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:12:08 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:12:07 -0700
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
Subject: Re: [PATCH v4 mips-next 2/7] MIPS: vmlinux.lds.S: add
 ".gnu.attributes" to DISCARDS
Message-ID: <20210108211207.GB2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107123428.354231-1-alobakin@pm.me>
 <20210107123428.354231-2-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123428.354231-2-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:34:53PM +0000, Alexander Lobakin wrote:
> Discard GNU attributes (MIPS FP type, GNU Hash etc.) at link time
> as kernel doesn't use it at all.
> Solves a dozen of the following ld warnings (one per every file):
> 
> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
> from `arch/mips/kernel/head.o' being placed in section
> `.gnu.attributes'
> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
> from `init/main.o' being placed in section `.gnu.attributes'
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/vmlinux.lds.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 83e27a181206..16468957cba2 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -221,6 +221,7 @@ SECTIONS
>  		/* ABI crap starts here */
>  		*(.MIPS.abiflags)
>  		*(.MIPS.options)
> +		*(.gnu.attributes)
>  		*(.options)
>  		*(.pdr)
>  		*(.reginfo)
> -- 
> 2.30.0
> 
> 
