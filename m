Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0424AD5A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 05:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHTDdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 23:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgHTDdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 23:33:22 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0184CC061757;
        Wed, 19 Aug 2020 20:33:21 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id p4so510390qkf.0;
        Wed, 19 Aug 2020 20:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=U70M0DthPhvBPm+JwSxLRJEdOyYLX1RXRnFN4J4OreQ=;
        b=KpEwD66yBrruBO3QsYyaOwDCrPWzetFsZPTJHveDTAvV1wImb3iajyGumgOLMInvG7
         1CqtCH/mQh0g1h+p6uDlkosEkWf6vH2BS75hPQl8PQ5k7+kZkyYFgbO7cG9y+PPErHx/
         zdYz540CUfXWEFO2pCSN9B0kvqTLx5NoIDqLKqE4n+1K8Zggfon6oG3WWwlDYDQL7qq7
         /WhzyMaJB6+wCB7FTbgpyEnk6t1MNmt++2xRVZ01/lA2DlkQ2tfq77V1PiHiEIyTmiML
         U0sbQ7Xfyksip8Kv5pqhnnuDcVTY6tf3Z64dMyGspTd6AsrkMNsPk1kLcILoMFJbHXFK
         mVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=U70M0DthPhvBPm+JwSxLRJEdOyYLX1RXRnFN4J4OreQ=;
        b=s10v2pZa5FLmZT+DGgEYckrgccI18iIceUOvZrSDIJa7jyouSLTrkVIh9SCWGWm1zq
         ztg7waEZvmZTqqCmwmKXpGB2Y3A0RHC9AV42Llh6vyVMesAlFCD+egeC2DK/T5jKxbzJ
         t3Kk9lU4K0apSMpuLFzJRifmFXEPBXYE6dlpH2dbZv4cXwBred0EoMfiNRflGDYZiVr2
         9cGKTDIx++Y7cMwqqpgukrF+sbw180oJwWp/8dD7xWYFW2pBuwzjzH5OinC3PX4tS8QN
         SYJMcLNMO1botiEUy2dznTHUJ7hz3+9xYyJ6gne4o3Bpz9OEaC0ME8QFsRQK2y8NMi3d
         4CUg==
X-Gm-Message-State: AOAM532bYB8j3IWTICNwwW5TY/PmrIo0m5n9dnNoXp7Lb1zcEmGGUKQn
        NcR0fvldGG6GXZsusDqiUP8=
X-Google-Smtp-Source: ABdhPJzRVPFYZRfVAtXW6RVInl7yWIxXxbXikBLG/HFjIjUou4gqQQBd089gpfngD73D+Yu+O6Iudw==
X-Received: by 2002:a05:620a:12ef:: with SMTP id f15mr1079654qkl.120.1597894399877;
        Wed, 19 Aug 2020 20:33:19 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id t32sm1713805qtb.3.2020.08.19.20.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 20:33:18 -0700 (PDT)
Date:   Wed, 19 Aug 2020 20:33:17 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 1/5] Makefile: add -fno-builtin-stpcpy
Message-ID: <20200820033317.GA2167124@ubuntu-n2-xlarge-x86>
References: <20200819191654.1130563-1-ndesaulniers@google.com>
 <20200819191654.1130563-2-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200819191654.1130563-2-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 12:16:50PM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings. This optimization was introduced into
> clang-12. Because the kernel does not provide an implementation of
> stpcpy, we observe linkage failures for almost all targets when building
> with ToT clang.
> 
> The interface is unsafe as it does not perform any bounds checking.
> Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
> 
> Cc: stable@vger.kernel.org # 4.4
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://reviews.llvm.org/D85963
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: Dávid Bolvanský <david.bolvansky@gmail.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index 9cac6fde3479..e523dc8d30e0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -578,6 +578,7 @@ ifneq ($(LLVM_IAS),1)
>  CLANG_FLAGS	+= -no-integrated-as
>  endif
>  CLANG_FLAGS	+= -Werror=unknown-warning-option
> +CLANG_FLAGS	+= -fno-builtin-stpcpy
>  KBUILD_CFLAGS	+= $(CLANG_FLAGS)
>  KBUILD_AFLAGS	+= $(CLANG_FLAGS)
>  export CLANG_FLAGS
> -- 
> 2.28.0.297.g1956fa8f8d-goog
> 
