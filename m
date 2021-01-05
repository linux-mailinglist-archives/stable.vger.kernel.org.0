Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D442EA14D
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 01:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbhAEAKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbhAEAKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 19:10:20 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483FBC061796;
        Mon,  4 Jan 2021 16:09:39 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id l7so13957196qvt.4;
        Mon, 04 Jan 2021 16:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1uhXG5VLD6CUWlhDkTTNObylxsn0kU6AAjea0UpYc9Q=;
        b=Wdw5+9ayMkyUjE86o9LD+DLDPhWZSBgPYRrKLJABWOUK0ScKeOK6gUu5kxe7Xm2/Dm
         X2GOzpIRxzUQ6G3QaRI+I5m2NJfeq272OE5bMHI8ICIod1eL4aYE0FR4ApEiNAh2w74m
         2H9lZuy9r6iFT08w9jbSPmpBIe2HjHa3AGMP55k9mpR7D4OEpdmNAIAkTdoix20yhKKD
         73r8RhyPB65nvjDjDnEgHL/H7SWqaKcG6E6QYvg6UqGqghk5PyRpAvPi3LW7Flww0WUU
         q3onOZY9Negv/VMkzkAGzjOQWgxj2JibBOmq/1n+Ybg3RoUbA0yf7C9b7Ptr9i8kV9CM
         FbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1uhXG5VLD6CUWlhDkTTNObylxsn0kU6AAjea0UpYc9Q=;
        b=GUen2ulEI/OjZX3RuFAVjHVtmB6E+WHjvLTk+Zv2iPayZxzGUmdJSswGTXDbnSMss8
         KSH1nYnAD9CU4TBV/ln2sbvBrssw246Le2q8QKYZVDNOCfYNFsFUNb8ka/3twg5MDR76
         E/TNw9QPtvcqIxlceiJMJpLfZBCT53OXhI7Ac0tiXHW/7zMRNnoEvfqBMqUyyKEOFcng
         N3letBthKOohUwL3FWqRvHUUEwy8ZJV0MMeGwQxwGoTbvFDjcdDHwCQoh3LOuegk46pB
         cl1A9z0nnpbHMfXVX1V0Ke4O7K3z6yWkw5wkwo3qERC8vZDmoXKdpI3SJoAquHZXMqrP
         +35g==
X-Gm-Message-State: AOAM53066AdubmhRARNzkza7nnQocovEwsKByvZXTQDPHvwsq9yMsYAl
        rtYaYJdrlRjSk0xLpd1KB70=
X-Google-Smtp-Source: ABdhPJzeBD+3xgKhHIcXSJTOBqR0uRZrJ9tts6d+f2ljfZGyPPE0opqUHa88iSp86VgmC9J2ozLGuQ==
X-Received: by 2002:ad4:4761:: with SMTP id d1mr79302383qvx.12.1609805378458;
        Mon, 04 Jan 2021 16:09:38 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id f59sm38218142qtd.84.2021.01.04.16.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 16:09:37 -0800 (PST)
Date:   Mon, 4 Jan 2021 17:09:36 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH mips-next 0/4] MIPS: vmlinux.lds.S sections fix & cleanup
Message-ID: <20210105000936.GA3877085@ubuntu-m3-large-x86>
References: <20210104121729.46981-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104121729.46981-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 12:18:10PM +0000, Alexander Lobakin wrote:
> This series hunts the problems discovered after manual enabling of
> ARCH_WANT_LD_ORPHAN_WARN, notably the missing PAGE_ALIGNED_DATA()
> section affecting VDSO placement (marked for stable).
> 
> Compile and runtime tested on MIPS32R2 CPS board with no issues.
> 
> Alexander Lobakin (4):
>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>   MIPS: vmlinux.lds.S: add ".rel.dyn" to DISCARDS
>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
> 
>  arch/mips/Kconfig              | 1 +
>  arch/mips/kernel/vmlinux.lds.S | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> -- 
> 2.30.0
> 

Glad to see ARCH_WANT_LD_ORPHAN_WARN catching on :)

I took this for a spin with clang with malta_kvm_guest_defconfig and I
only see one section unaccounted for:

$ make -skj"$(nproc)" ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- LLVM=1 O=out/mips distclean malta_kvm_guest_defconfig all
...
ld.lld: warning: <internal>:(.got) is being placed in '.got'
ld.lld: warning: <internal>:(.got) is being placed in '.got'
ld.lld: warning: <internal>:(.got) is being placed in '.got'

Looks like most architectures place it in .got (ia64, nios2, powerpc)
or .text (arm64).

Cheers,
Nathan
