Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D4E235024
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 05:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgHADvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 23:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbgHADvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 23:51:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7FCC06174A;
        Fri, 31 Jul 2020 20:51:32 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l23so30808831qkk.0;
        Fri, 31 Jul 2020 20:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PayQ/qqXfalVrPUBjKqmyKH4cdevaDuV7wVHaPmWgJ4=;
        b=iUUSE8iLfcI6s6NX41YiqlZCybbN3zgkT1DuyL6+KDDMRGZhvzbo331ZnhNM9lM7C9
         b5iGfRpwAEEwA6Y24PPe/6Kt8N/ZODHeXv3dplknicJPcvNee7YKffeSoTb/XMjwwD9Z
         HGbWF18J44yhay/XWRYWrrDUgjL5MWGJl4kSctIcEWH3iEdpIczrjVlAfWwBfpoj1tGV
         D53H+UcLqF+flpYca6OyjcRHDBkYJ+vvIgqPTVrk/DihkJcf+gtodS3QTOMgN3h6daZX
         G6ybC5mq4kXpx9XNZmGuCvIEGYUbKN+wQwSPDHP02LqTESmCjvtZ4aN7gCqH63XheylX
         OU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=PayQ/qqXfalVrPUBjKqmyKH4cdevaDuV7wVHaPmWgJ4=;
        b=Fk+ngXDO0gw9WRzO3m4n1jT6EYQMn4eaRT0LSOL68vBod/q1PXY1Gv9tvOLVUZsI03
         0VnpgP8crWZmHiyeFdciZmAXVyt4DmdiGQxPm+w0w5D69MfP6VMKc5DWLWlyVk3ar9BB
         r2Fvv9nItydqmuZG32LyApY9rfZrVLZ8s10gmLjFNfX61m52zZYsDSg1XpcUcyy1tb7+
         oAIEfUxyeSRhlh2Ex7S8eiAHQeUE3QGfwAVWwvlDGUi4ha9Mv0B4rTtcV+wFeQSJKrO0
         hdvlIRQwmclqB5GbmUNhbn91KeDdgLC28ELxqeNJsz2RH3+qLGPo62CgbTSF+aRF/uJv
         /mHQ==
X-Gm-Message-State: AOAM532PhsKoaL8inh3EX2A1O7PoCvbVnhyFAjpB7x7JHaKqi3oyYI7g
        nWEfSI6fBv2aAQv4iUP+JqA=
X-Google-Smtp-Source: ABdhPJzmPdzsMhqNPMTyf2fTToKhn6MYA8bBHK8a+Vko2Q6LhFht8yVEAh9qElAVkuMNUyUQPE21fA==
X-Received: by 2002:a37:a187:: with SMTP id k129mr6752037qke.196.1596253891434;
        Fri, 31 Jul 2020 20:51:31 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id 139sm9716015qkl.13.2020.07.31.20.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 20:51:30 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 31 Jul 2020 23:51:28 -0400
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michal Marek <michal.lkml@markovi.net>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input
 sections
Message-ID: <20200801035128.GB2800311@rani.riverdale.lan>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200731230820.1742553-14-keescook@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 04:07:57PM -0700, Kees Cook wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.
> 
> When compiling with profiling information (collected via PGO
> instrumentations or AutoFDO sampling), Clang will separate code into
> .text.hot, .text.unlikely, or .text.unknown sections based on profiling
> information. After D79600 (clang-11), these sections will have a
> trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..
> 
> When using -ffunction-sections together with profiling infomation,
> either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
> sections following the convention:
> .text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
> where <foo>, <bar>, and <baz> are functions.  (This produces one section
> per function; we generally try to merge these all back via linker script
> so that we don't have 50k sections).
> 
> For the above cases, we need to teach our linker scripts that such
> sections might exist and that we'd explicitly like them grouped
> together, otherwise we can wind up with code outside of the
> _stext/_etext boundaries that might not be mapped properly for some
> architectures, resulting in boot failures.
> 
> If the linker script is not told about possible input sections, then
> where the section is placed as output is a heuristic-laiden mess that's
> non-portable between linkers (ie. BFD and LLD), and has resulted in many
> hard to debug bugs.  Kees Cook is working on cleaning this up by adding
> --orphan-handling=warn linker flag used in ARCH=powerpc to additional
> architectures. In the case of linker scripts, borrowing from the Zen of
> Python: explicit is better than implicit.
> 
> Also, ld.bfd's internal linker script considers .text.hot AND
> .text.hot.* to be part of .text, as well as .text.unlikely and
> .text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
> see Clang producing such code in our kernel builds, but I see code in
> LLVM that can produce such section names if profiling information is
> missing. That may point to a larger issue with generating or collecting
> profiles, but I would much rather be safe and explicit than have to
> debug yet another issue related to orphan section placement.
> 
> Reported-by: Jian Cai <jiancai@google.com>
> Suggested-by: Fāng-ruì Sòng <maskray@google.com>
> Tested-by: Luis Lozano <llozano@google.com>
> Tested-by: Manoj Gupta <manojgupta@google.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
> Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
> Link: https://reviews.llvm.org/D79600
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
> Debugged-by: Luis Lozano <llozano@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/asm-generic/vmlinux.lds.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 2593957f6e8b..af5211ca857c 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -561,7 +561,10 @@
>   */
>  #define TEXT_TEXT							\
>  		ALIGN_FUNCTION();					\
> -		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
> +		*(.text.hot .text.hot.*)				\
> +		*(TEXT_MAIN .text.fixup)				\
> +		*(.text.unlikely .text.unlikely.*)			\
> +		*(.text.unknown .text.unknown.*)			\
>  		NOINSTR_TEXT						\
>  		*(.text..refcount)					\
>  		*(.ref.text)						\
> -- 
> 2.25.1
> 

This also changes the ordering to place all hot resp unlikely sections separate
from other text, while currently it places the hot/unlikely bits of each file
together with the rest of the code in that file. That seems like a reasonable
change and should be mentioned in the commit message.

However, the history of their being together comes from

  9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")

which seems to indicate there was some problem with having them separated out,
although I don't quite understand what the issue was from the commit message.

Cc Andi and Michal to see if they remember.
