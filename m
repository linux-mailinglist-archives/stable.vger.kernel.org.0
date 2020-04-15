Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEFD1AB1EE
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438459AbgDOTkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 15:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438405AbgDOTki (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 15:40:38 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09DC061A0C;
        Wed, 15 Apr 2020 12:40:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u15so5078060ljd.3;
        Wed, 15 Apr 2020 12:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g11hhgVDfWrK50P2wFGEQ+rhm9YH6tO11UJ098pNsjk=;
        b=QhPVdjScB5TaLr6tHbcEhVShDdWhBXeXPv/HcTvO3WZxV1Ie0ZGKi4CgTS5WucUkC+
         PBFtAQmEkJKM2AtIPk6VpU4NBlmXDmTbJS/Rtu+bh8efv/vjIAI8iCQ5i6PF0Ujzooag
         lokco0leP2/cfZUr3Y1xCthKqBvQ9cm+f7pvPE4accqwd/EpAKSxHhdAvf2/OzVoIMVL
         Se4VFWYWFwYZX+Q/OSNot4ZWJ05sjZqRt4akRXUSVQ9Pm1a/WfDhHuTsF+OaloSePosQ
         ua7gDNWENtMECREsCMq2f3RmL2ZBYG6oeYEUVSbsUFCb+AYsC4u2u/p42hH0Uj/wcFqL
         TNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g11hhgVDfWrK50P2wFGEQ+rhm9YH6tO11UJ098pNsjk=;
        b=ndisbAX7z/G5+V+zqzv5sP6hVNwZ9A6DK+lfhfRJiAqncw1omulBEJNXxA1CmDh65q
         O/Vj98byPDCel+i4v03DuUnxwXiZ1yyyhWL61SbS6TgFSWVKeM5d6jp0YQ9Njrhcj6CQ
         lJ/Zljpd5IRkHZt61hg8jYxEhhS+0ncUKjY868mu2juL4t6l+qAmBINsOwReZUDI8Tsr
         /UKRV/Y2Rj+ppGnXFE34xEo0PrGoyJmRM0cY0rJIB6b020E5tDYA31CzsmQoPqqqlGsh
         l2woViNgTHzO5bdntr1sf0LQAnHqprBabcvQDSEIMmKVeJWe4y7cKrqnS+KXnHkzGKHG
         9HHw==
X-Gm-Message-State: AGi0PuZCfcud5zrYYIKsQd8JmC5t5ze2jzgF8ReXPHkACRux2Xa5N/kX
        cG8jV6+0CGMtWWY9Z7kDHSU=
X-Google-Smtp-Source: APiQypKCCQxJRxoAY+tMwcDypL2lWlAAvMjvbTWWnRb7fboPS+t9cRwq4pdZo60ltFVv5MyXKKytuA==
X-Received: by 2002:a2e:b605:: with SMTP id r5mr2775346ljn.40.1586979635888;
        Wed, 15 Apr 2020 12:40:35 -0700 (PDT)
Received: from rikard (h-98-128-228-126.NA.cust.bahnhof.se. [98.128.228.126])
        by smtp.gmail.com with ESMTPSA id p28sm12304016ljn.24.2020.04.15.12.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 12:40:35 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
X-Google-Original-From: Rikard Falkeborn <rikard.falkeborn>
Date:   Wed, 15 Apr 2020 21:40:32 +0200
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haren Myneni <haren@us.ibm.com>, Joe Perches <joe@perches.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 5.4 52/84] linux/bits.h: add compile time sanity
 check of GENMASK inputs
Message-ID: <20200415194032.GA935@rikard>
References: <20200415114442.14166-1-sashal@kernel.org>
 <20200415114442.14166-52-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415114442.14166-52-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 07:44:09AM -0400, Sasha Levin wrote:
> From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> 
> [ Upstream commit 295bcca84916cb5079140a89fccb472bb8d1f6e2 ]
> 
> GENMASK() and GENMASK_ULL() are supposed to be called with the high bit as
> the first argument and the low bit as the second argument.  Mixing them
> will return a mask with zero bits set.
> 
> Recent commits show getting this wrong is not uncommon, see e.g.  commit
> aa4c0c9091b0 ("net: stmmac: Fix misuses of GENMASK macro") and commit
> 9bdd7bb3a844 ("clocksource/drivers/npcm: Fix misuse of GENMASK macro").
> 
> To prevent such mistakes from appearing again, add compile time sanity
> checking to the arguments of GENMASK() and GENMASK_ULL().  If both
> arguments are known at compile time, and the low bit is higher than the
> high bit, break the build to detect the mistake immediately.
> 
> Since GENMASK() is used in declarations, BUILD_BUG_ON_ZERO() must be used
> instead of BUILD_BUG_ON().
> 
> __builtin_constant_p does not evaluate is argument, it only checks if it
> is a constant or not at compile time, and __builtin_choose_expr does not
> evaluate the expression that is not chosen.  Therefore, GENMASK(x++, 0)
> does only evaluate x++ once.
> 
> Commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends
> available in assembly") made the macros in linux/bits.h available in
> assembly.  Since BUILD_BUG_OR_ZERO() is not asm compatible, disable the
> checks if the file is included in an asm file.
> 
> Due to bugs in GCC versions before 4.9 [0], disable the check if building
> with a too old GCC compiler.
> 
> [0]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=19449
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Haren Myneni <haren@us.ibm.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: lkml <linux-kernel@vger.kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/20200308193954.2372399-1-rikard.falkeborn@gmail.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/bits.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bits.h b/include/linux/bits.h
> index 669d69441a625..f108302a3121c 100644
> --- a/include/linux/bits.h
> +++ b/include/linux/bits.h
> @@ -18,12 +18,30 @@
>   * position @h. For example
>   * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>   */
> -#define GENMASK(h, l) \
> +#if !defined(__ASSEMBLY__) && \
> +	(!defined(CONFIG_CC_IS_GCC) || CONFIG_GCC_VERSION >= 49000)
> +#include <linux/build_bug.h>
> +#define GENMASK_INPUT_CHECK(h, l) \
> +	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
> +		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
> +#else
> +/*
> + * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
> + * disable the input check if that is the case.
> + */
> +#define GENMASK_INPUT_CHECK(h, l) 0
> +#endif
> +
> +#define __GENMASK(h, l) \
>  	(((~UL(0)) - (UL(1) << (l)) + 1) & \
>  	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
> +#define GENMASK(h, l) \
> +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>  
> -#define GENMASK_ULL(h, l) \
> +#define __GENMASK_ULL(h, l) \
>  	(((~ULL(0)) - (ULL(1) << (l)) + 1) & \
>  	 (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
> +#define GENMASK_ULL(h, l) \
> +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
>  
>  #endif	/* __LINUX_BITS_H */
> -- 
> 2.20.1
> 

This does not really fix anything, it's compile time prevention, so I
don't know how appropriate this is for stable (it was also picked for
5.5 and 5.6, but I'm just replying here now, I can ping the other
selections if necessary if the patch should be dropped)?

Also, for 5.4, it does somewhat depend on commit 8788994376d8
("linux/build_bug.h: change type to int"). Without it, there may be a
subtle integer promotion issue if sizeof(size_t) > sizeof(unsigned long)
(I don't *think* such platform exists, but I don't have a warm a fuzzy
feeling about it).

Rikard

