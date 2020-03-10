Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B99917EDDD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 02:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgCJBO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 21:14:27 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46155 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgCJBO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 21:14:27 -0400
Received: by mail-ot1-f66.google.com with SMTP id 111so7254526oth.13;
        Mon, 09 Mar 2020 18:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TWCOqZf4rQwYyc1Kb2FkK7gjUGqcI184ib87ZKwWExU=;
        b=tpdBWNo81gSnjnSInkT5xF/QamNd45XfKBeJmvpqnKRE2kChiW4Cw4BX0ytEjWENvH
         KcECugblmgWqwQfzmXnMjrtDNpl9tf+bkufYM8LVY2PHfogBt4LSONLqJDb5EQnYgGBJ
         tX/qZi5TFhsJAdW7Q8gSV4r289vmzNwrnMbaVxvi9zYCNlwOrLDIVn/e9Rxt00QkdA05
         Xl41hFRuklUgs+yiO3cyzWEJb1xkZNo7bK8GDA76YspVk0lqF1qmtAIPLL5YTj0NM8oN
         mjxdXzHuoy3jQO5R/xlPPzq/gll4wCG3zSfzbgmipqeXGbzuR6UP4r8lQuUFzT7fPd/m
         57ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TWCOqZf4rQwYyc1Kb2FkK7gjUGqcI184ib87ZKwWExU=;
        b=iTg6mPj/oqSxTUq1jV2StIWTLmwejjg8nW/rY/0hZlAviG0X1r2m95IVfmzSZljMpy
         N2dPoXFVKOBegfSHMQDWTcSFWttOna91Ip0Y33ekd8kj1MBtAS0bn3DHGppXyWrHAqDB
         uCfYdeZWlrb/bZOmQqXt5KjB6W6LA/h0lDUcpvhOdcjiJtRxW2LPaHAHFF/vzhu1aFNh
         zJSysa9ZY3yF75gkDqK5ji9U8/BiHK0pUsGXybgeBSnN4nTcqft0DR5AZsqD6SQfgd/M
         73EoImDGzut+epP3/Z0uXQRCxidQFIacWK/SV72i9HLiV0Ans9LEyafkElA+eohoqeIV
         4jbw==
X-Gm-Message-State: ANhLgQ0rfgWORPOx7Vv2EqjfGI1l/uIj7IVz44DTGQIjl4jmS/hFCf1Y
        lUs7+WvnZT8YCLo/Ruz6YQg=
X-Google-Smtp-Source: ADFU+vsFQnmA8w0Ey1H2luI12I0h7M/1b+sthGU0WHzpthNRCwcV+9bzk+wp+IUWWjGZIok6A7CBzg==
X-Received: by 2002:a9d:748c:: with SMTP id t12mr14298777otk.38.1583802865803;
        Mon, 09 Mar 2020 18:14:25 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id m15sm1514128otp.8.2020.03.09.18.14.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Mar 2020 18:14:25 -0700 (PDT)
Date:   Mon, 9 Mar 2020 18:14:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
Message-ID: <20200310011423.GA1578@ubuntu-m2-xlarge-x86>
References: <20200308073400.23398-1-natechancellor@gmail.com>
 <20200309122505.5043620866@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309122505.5043620866@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 12:25:04PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.
> 
> v5.5.8: Build OK!
> v5.4.24: Build OK!
> v4.19.108: Failed to apply! Possible dependencies:
>     076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
>     a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
> 
> v4.14.172: Failed to apply! Possible dependencies:
>     076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
>     a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
>     c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
>     ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
> 
> v4.9.215: Failed to apply! Possible dependencies:
>     076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
>     0e5e7f5e9700 ("powerpc/64: Reclaim CPU_FTR_SUBCORE")
>     1421dc6d4829 ("powerpc/kbuild: Use flags variables rather than overriding LD/CC/AS")
>     250122baed29 ("powerpc64/module: Tighten detection of mcount call sites with -mprofile-kernel")
>     2a056f58fd33 ("powerpc: consolidate -mno-sched-epilog into FTRACE flags")
>     3a849815a136 ("powerpc/book3s64: Always build for power4 or later")
>     43c9127d94d6 ("powerpc: Add option to use thin archives")
>     471d7ff8b51b ("powerpc/64s: Remove POWER4 support")
>     5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
>     6977f95e63b9 ("powerpc: avoid -mno-sched-epilog on GCC 4.9 and newer")
>     73aca179d78e ("powerpc/modules: Fix crashes by adding CONFIG_RELOCATABLE to vermagic")
>     951eedebcdea ("powerpc/64: Handle linker stubs in low .text code")
>     a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
>     a73657ea19ae ("powerpc/64: Add GENERIC_CPU support for little endian")
>     abba759796f9 ("powerpc/kbuild: move -mprofile-kernel check to Kconfig")
>     b40b2386bce9 ("powerpc/Makefile: Fix ld version check with 64-bit LE-only toolchain")
>     b71c9ffb1405 ("powerpc: Add arch/powerpc/tools directory")
>     baa25b571a16 ("powerpc/64: Do not link crtsavres.o in vmlinux")
>     badf436f6fa5 ("powerpc/Makefiles: Convert ifeq to ifdef where possible")
>     c0d64cf9fefd ("powerpc: Use feature bit for RTC presence rather than timebase presence")
>     c1807e3f8466 ("powerpc/64: Free up CPU_FTR_ICSWX")
>     c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
>     cf43d3b26452 ("powerpc: Enable pkey subsystem")
>     ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
>     efe0160cfd40 ("powerpc/64: Linker on-demand sfpr functions for modules")
>     f188d0524d7e ("powerpc: Use the new post-link pass to check relocations")
> 
> v4.4.215: Failed to apply! Possible dependencies:
>     076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
>     07e45c120c9c ("powerpc: Don't disable kernel FP/VMX/VSX MSR bits on context switch")
>     152d523e6307 ("powerpc: Create context switch helpers save_sprs() and restore_sprs()")
>     20dbe6706206 ("powerpc: Call restore_sprs() before _switch()")
>     2a056f58fd33 ("powerpc: consolidate -mno-sched-epilog into FTRACE flags")
>     3f3b5dc14c25 ("powerpc/pseries: PACA save area fix for general exception vs MCE")
>     579e633e764e ("powerpc: create flush_all_to_thread()")
>     57f266497d81 ("powerpc: Use gas sections for arranging exception vectors")
>     6977f95e63b9 ("powerpc: avoid -mno-sched-epilog on GCC 4.9 and newer")
>     70fe3d980f5f ("powerpc: Restore FPU/VEC/VSX if previously used")
>     8c50b72a3b4f ("powerpc/ftrace: Add Kconfig & Make glue for mprofile-kernel")
>     951eedebcdea ("powerpc/64: Handle linker stubs in low .text code")
>     a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
>     a74599a50419 ("powerpc/pseries: PACA save area fix for MCE vs MCE")
>     abba759796f9 ("powerpc/kbuild: move -mprofile-kernel check to Kconfig")
>     c208505900b2 ("powerpc: create giveup_all()")
>     c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
>     caca285e5ab4 ("powerpc/mm/radix: Use STD_MMU_64 to properly isolate hash related code")
>     d1e1cf2e38de ("powerpc: clean up asm/switch_to.h")
>     d8d42b0511fe ("powerpc/64: Do load of PACAKBASE in LOAD_HANDLER")
>     ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
>     f0f558b131db ("powerpc/mm: Preserve CFAR value on SLB miss caused by access to bogus address")
>     f3d885ccba85 ("powerpc: Rearrange __switch_to()")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha

Hi Sasha,

If/when this patch hits mainline and I get the rejected emails from
Greg, I will send a manual backport.

Cheers,
Nathan
