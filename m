Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4762A77A2
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 07:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKEG6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 01:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgKEG6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 01:58:48 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23215C0613CF;
        Wed,  4 Nov 2020 22:58:48 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id u19so758046ion.3;
        Wed, 04 Nov 2020 22:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xgK5C/kmHCdYMo/R51mOn46TRz+P9lQZN5x72FBClZg=;
        b=qU8KRHAWTdGzsF4J6Ys7Tkj08FpemaSAAMbCgNpt5J8Kk8GMVGg76D6IuyudobkT0A
         YRQ2xjCPHxFr2drMUqmnf58Rz7bGVZqElO+2JrJTclL0F35iqzn0bnlPIFH2md3bYgre
         L7mTQ49VriewSJLeluMG20EweK80i4oGywhchKA2YuF39yKBg6Gdhw1sz/t+NyHwn2Zr
         yuZeLjekvBtSAYtaaQWHt3Dv7POzD4Z7oGixqo/p/9fqG3pyrJGdFusuRk5z0eEYaFdW
         n/JmT6qGzEmRsOYjmsuY/2e8UaTVft3qLPWU5QB0sj+JHD1p8YcIT6f08Cm/SAN/Ka7H
         qhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xgK5C/kmHCdYMo/R51mOn46TRz+P9lQZN5x72FBClZg=;
        b=dWbbHhoxC34CgjtrDEVqijLMfKTtw4sydjerFI/gh5YD6OkoXYdYOvsUJQQqQIp0kY
         /ejmyXpjqYyUqMfhv2g5mTVoBlH31nkjudnZJDkTg3zCuzVihQcvca4zC7w2MGK7lRLm
         OmUktc/4ulrFfJphKp2phcR5QFV9l00BRXYJHFrmS+DMpx3HiELy6UWBjST0gcDYG6Ys
         KLm4Do0n8cq2z8ccZX7Zwdp8zX0Cd78cSaMtHFf0sJnq8jVId0j3FBoOKopY7xDZjaVq
         dJStBOkAZQfnPbKh5B6erQy7dhmEH5Fd2xuJpvDdhEBBAwwjTf7rx5XXpB6DMC1JyIp0
         wCyQ==
X-Gm-Message-State: AOAM532Q1LVheZTXLa6g04JoT7dZSjs4O/8vnVsN3NLuoGIIb1cHLEdg
        uICexS3HnCId+pdxJiK5ack=
X-Google-Smtp-Source: ABdhPJzFmZM1hex1Mo0bDhYe1yj7LOV2SnmMToXn3dPj+RK5ZWGd5alBm12txPxzgJYNE4mOwE3uXg==
X-Received: by 2002:a02:3842:: with SMTP id v2mr981798jae.50.1604559527215;
        Wed, 04 Nov 2020 22:58:47 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id i3sm520813iom.8.2020.11.04.22.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 22:58:46 -0800 (PST)
Date:   Wed, 4 Nov 2020 23:58:44 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Kbuild: do not emit debug info for assembly with
 LLVM_IAS=1
Message-ID: <20201105065844.GA3243074@ubuntu-m3-large-x86>
References: <CAK7LNAST0Ma4bGGOA_HATzYAmRhZG=x_X=8p_9dKGX7bYc2FMA@mail.gmail.com>
 <20201104005343.4192504-1-ndesaulniers@google.com>
 <20201104005343.4192504-3-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104005343.4192504-3-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 04:53:41PM -0800, Nick Desaulniers wrote:
> Clang's integrated assembler produces the warning for assembly files:
> 
> warning: DWARF2 only supports one section per compilation unit
> 
> If -Wa,-gdwarf-* is unspecified, then debug info is not emitted.  This

Is this something that should be called out somewhere? If I understand
this correctly, LLVM_IAS=1 + CONFIG_DEBUG_INFO=y won't work? Maybe this
should be handled in Kconfig?

> will be re-enabled for new DWARF versions in a follow up patch.
> 
> Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
> 
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/716
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Dmitry Golovin <dima@golovin.in>

If you happen to respin, Dmitry deserves a Reported-by tag too :)

> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Regardless of the other two comments, this is fine as is as a fix for
stable to unblock Android + CrOS since we have been running something
similar to it in CI:

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index f353886dbf44..75b1a3dcbf30 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -826,7 +826,9 @@ else
>  DEBUG_CFLAGS	+= -g
>  endif
>  
> +ifndef LLVM_IAS

Nit: this should probably match the existing LLVM_IAS check

ifneq ($(LLVM_IAS),1)

>  KBUILD_AFLAGS	+= -Wa,-gdwarf-2
> +endif
>  
>  ifdef CONFIG_DEBUG_INFO_DWARF4
>  DEBUG_CFLAGS	+= -gdwarf-4
> -- 
> 2.29.1.341.ge80a0c044ae-goog
> 
