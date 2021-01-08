Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B682E2EFA29
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbhAHVRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 16:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbhAHVRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 16:17:46 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7C1C061574;
        Fri,  8 Jan 2021 13:17:06 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id z11so9772946qkj.7;
        Fri, 08 Jan 2021 13:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpkcFsKU0saeY1OcJS3d/0PfwhXjvV9PMm7UfLxWFeQ=;
        b=pwsyvOR1TDfewdtw5elKW7YRv2TBTKC30qhCnDf/W5MlkC2eDpWCWDIw6U5sCoEuCD
         SS2vyOf1OaRIdw8hZ4WzAtAVBd/q4016QQ8hOTJvSc2Xe6UMHh+qZU18Gpuz7DZNbvX1
         c/rCRzsN+WBoNhZ4/HG6M4OF2mIf2hnDfPsGLDHIIViQjM7vLgIrIGB4HfRvj1dAlZQu
         09yvaV+ow7ZJtgNDKTRIXs7IX4wtBGVEEiLgT/Qh0zttGXqY4R6oT7upkg6s4VNxxYUF
         QJKji5AEQwg9H47OSL17iLQOJeQ6YsgEhWu6xQJt4qvzrYFY/slHtyehRqh49UdE4cb5
         lmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bpkcFsKU0saeY1OcJS3d/0PfwhXjvV9PMm7UfLxWFeQ=;
        b=cey86I0eVgXw3u8DmTfpjUxHNT++b9Sc0F6jigEeULTbvKLOAkblKEh/INias6bh5B
         Nh9535KLu7WumzTqJrD+4Mv75vXDjgljU9xy5hZf+/9y04F3f9GV/PP1c6u+V5MZoKMF
         XPGNKXT37xRDpyDKXlIfLGYlSH4Rik2+bJ0EgmEZz5PONCXLndyehvKenUGhSidosunm
         gei6ZY+/xyoO8SqqzUVRCtnVCuROz2M6XSfl+MzAMtmM/NJx0YDtitUhTrQDdeY9dMMZ
         P1kQxHbSm6MWmwfuLgz3GKs0yGmSxmz3UstlCWBLzMzKq2vgmdO+LPiJloaKv2Z3Nn42
         Zorg==
X-Gm-Message-State: AOAM533pgRH2TkIpf/BLoa6wv9YhtlA2dP4kkgXe7J42YY6pQacpKMtn
        1SssNL5NKd8M/fipUR7N9SA=
X-Google-Smtp-Source: ABdhPJzo5e9nvSTM77t7vl6NmnrUoJ53D9K/i+NynMSKbTcXStAbKwC5m/GEwqZBjbWGztYu3nnUTA==
X-Received: by 2002:a37:c89:: with SMTP id 131mr6046009qkm.468.1610140625412;
        Fri, 08 Jan 2021 13:17:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id q23sm4970567qtp.39.2021.01.08.13.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:17:04 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:17:03 -0700
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
Subject: Re: [PATCH v4 mips-next 4/7] MIPS: vmlinux.lds.S: catch bad .rel.dyn
 at link time
Message-ID: <20210108211703.GD2547542@ubuntu-m3-large-x86>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107132010.463129-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107132010.463129-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 01:20:33PM +0000, Alexander Lobakin wrote:
> Catch any symbols placed in .rel.dyn and check for these sections
> to be zero-sized at link time.
> Eliminates following ld warning:
> 
> mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
> from `init/main.o' being placed in section `.rel.dyn'
> 
> Adopted from x86/kernel/vmlinux.lds.S.
> 
> Suggested-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/mips/kernel/vmlinux.lds.S | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 0f4e46ea4458..0f736d60d43e 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -226,4 +226,15 @@ SECTIONS
>  		*(.pdr)
>  		*(.reginfo)
>  	}
> +
> +	/*
> +	 * Sections that should stay zero sized, which is safer to
> +	 * explicitly check instead of blindly discarding.
> +	 */
> +
> +	.rel.dyn : {
> +		*(.rel.*)
> +		*(.rel_*)
> +	}
> +	ASSERT(SIZEOF(.rel.dyn) == 0, "Unexpected run-time relocations (.rel) detected!")
>  }
> -- 
> 2.30.0
> 
> 
