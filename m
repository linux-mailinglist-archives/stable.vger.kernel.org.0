Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AC9DA69
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 02:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfH0AMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 20:12:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32961 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfH0AMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 20:12:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id p77so1125250wme.0;
        Mon, 26 Aug 2019 17:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bB0HYsROX648Uz+NeihK0Ak7qHb0HK/01IOFw0GVKwo=;
        b=PKzN5DufXA7Ct1IDcxOhX7tqJGNftDV5c19iyHf0keiVZOByinTOISi8MWXzsc0/Au
         cotRan7k06FtNeSUszMvYxdqhOtLCX+AH2qUlNQb5VUnhvvvDaN2dwc4dfplPaJ5rJxv
         qNG/uvcCP1zn0QtTlKdBxos6XkGqWN9Ehupn5BNL/YIX8KaQ+nJp3S9jqHNd4h+ylFFt
         jhDKLm80SiZ4jCkxavL6Z+gnZ1vJuuPKaoUw3kq1OayjUoNFXeUjq8OrQHARqzgXHldv
         X8aWaNXhp+00OyFGHEXUpdvBj05j6ca0c3O18zH6FiSDp64nbpg1X3WqH6P78nF/02c4
         jiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bB0HYsROX648Uz+NeihK0Ak7qHb0HK/01IOFw0GVKwo=;
        b=oEf7URLuMHEnd7O90G6rRleiLFEhKWP6hqXHav8INpNToGkqKuYWRhWumbZc1Dnpbb
         wv8n7S5AWnB8EW0l6GKoFP35UalaE65Vj5u5afUjeCaGQszFUFIHMj2FnYt6MuqxDaKF
         3F88m/wyocHJsVLNnplYUk4cnXV6zjko9dbPoodZ/4tyOAyQX30Oqgr9SlcDG+OSNfD8
         hBO1hufqnHWco2/oAhqbcs1aF+Xz/jZVvUZTjLfkZoIq5zvlsR0us9MSMJT0zXbSsuMc
         aQIP19CewA1MvgQutAXc9JwvKKAb5tiLIYUyfVklDOLUqd7YsvnuPEbfNp4hjmYI8ZwJ
         OsAg==
X-Gm-Message-State: APjAAAXXHbFvWBXpPPMstpL0g3XC/xV9wVHiLFotjdKM2U2wOVdgputk
        +H4fEGZnnQ0SzlQ5bbyo8kU=
X-Google-Smtp-Source: APXvYqyeY/xd32/iOyMHcAPpAemahrY1NRnemcT8nKVRjwvjJ4BTl2OgNqWlmhqh/tMRPElrW3KXjQ==
X-Received: by 2002:a1c:f106:: with SMTP id p6mr22529010wmh.148.1566864759283;
        Mon, 26 Aug 2019 17:12:39 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id r17sm34516156wrg.93.2019.08.26.17.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 17:12:38 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:12:37 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190827001237.GA117465@archlinux-threadripper>
References: <20190812023214.107817-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812023214.107817-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 11, 2019 at 07:32:15PM -0700, Nathan Chancellor wrote:
> Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> about the setjmp and longjmp declarations.
> 
> r367387 in clang added another diagnostic around this, complaining that
> there is no jmp_buf declaration.
> 
> In file included from ../arch/powerpc/xmon/xmon.c:47:
> ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
> built-in function 'setjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern long setjmp(long *);
>             ^
> ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
> built-in function 'longjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern void longjmp(long *, long);
>             ^
> 2 errors generated.
> 
> Take the same approach as the above commit by disabling the warning for
> the same reason, we provide our own longjmp/setjmp function.
> 
> Cc: stable@vger.kernel.org # 4.19+
> Link: https://github.com/ClangBuiltLinux/linux/issues/625
> Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> It may be worth using -fno-builtin-setjmp and -fno-builtin-longjmp
> instead as it makes it clear to clang that we are not using the builtin
> longjmp and setjmp functions, which I think is why these warnings are
> appearing (at least according to the commit that introduced this waring).
> 
> Sample patch:
> https://github.com/ClangBuiltLinux/linux/issues/625#issuecomment-519251372
> 
> However, this is the most conservative approach, as I have already had
> someone notice this error when building LLVM with PGO on tip of tree
> LLVM.
> 
>  arch/powerpc/kernel/Makefile | 5 +++--
>  arch/powerpc/xmon/Makefile   | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index ea0c69236789..44e340ed4722 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -5,8 +5,9 @@
>  
>  CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
>  
> -# Disable clang warning for using setjmp without setjmp.h header
> -CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
> +CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header) \
> +			   $(call cc-disable-warning, incomplete-setjmp-declaration)
>  
>  ifdef CONFIG_PPC64
>  CFLAGS_prom_init.o	+= $(NO_MINIMAL_TOC)
> diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
> index f142570ad860..53f341391210 100644
> --- a/arch/powerpc/xmon/Makefile
> +++ b/arch/powerpc/xmon/Makefile
> @@ -1,8 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for xmon
>  
> -# Disable clang warning for using setjmp without setjmp.h header
> -subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
> +subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header) \
> +		    $(call cc-disable-warning, incomplete-setjmp-declaration)
>  
>  GCOV_PROFILE := n
>  KCOV_INSTRUMENT := n
> -- 
> 2.23.0.rc2
> 

Did any of the maintainers have any comment on this patch?

Cheers,
Nathan
