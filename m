Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D131737F665
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 13:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhEMLIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhEMLIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 07:08:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1753C06174A
        for <stable@vger.kernel.org>; Thu, 13 May 2021 04:07:21 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j3-20020a05600c4843b02901484662c4ebso1188564wmo.0
        for <stable@vger.kernel.org>; Thu, 13 May 2021 04:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L1Rs0oxlRge0qzOeFq0tx+oSL+//C6msY0LMqH5lEJs=;
        b=UfmbqwKWPIdaOVfwjyMXYHlRMeuPfQe2tS1dxgzp9lcC2DKlB6n5x7sLOxwLQuQn7d
         V69lN0hMUMBgvquWzFmb51GU0aWKFtSn/+59BMg6Krr1aA+XsSNtSIVmf43riZWUNU3C
         OSZ6mwdBXsfsNjTyfNrPGpclohv341toj3iK6cRR9VILpW61HrMd1h9Sh84X0DALpnL5
         ENei0SdPbb7t8pkgBfw/PKuqs9qLRFn3eiRf9r61KKMQlg4D7HYyRVLLfloygAWKiId9
         HBlUhD08Su2HY49L+9lKhUfs5ypG0sHxOZeR283CD6+ON+tozDYW6QJks2QbIJv2RqTA
         xZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L1Rs0oxlRge0qzOeFq0tx+oSL+//C6msY0LMqH5lEJs=;
        b=oCub1l7sRBOhk6EAwQZxDeESm6JCEcPy4EHshU5KXbnsGXhAvd5poygsNGpkhwjAXB
         Ha5+vVFLH3MDw8HZwBhtzW1u3utyMwiKXcD5ZHcGaOm7YxQwuPxxPtYAYdnMt6Uyeief
         wNk8rq9amjOFa3DRQs8jws16I+BjptRSgRMPvN64cPw6pw82Fx5IwQcMF9d6UjSg/Q1Z
         8WwGTS2ge9fH5uy6fdgvKdxFjq3EDn9Z2YfMmasUIslcPE6E5JL4ml4Ln08s8eGlpvwu
         8Cfec+oaqYbAUTZHtSay2q4US7SuieU9f0PGxx5MVM795LRxjKklwOczPLyNtc8NQMkT
         IRNw==
X-Gm-Message-State: AOAM530zmTx6eimny/WhB4AFhXWAHD7Kbl9ZfVI43uBbfJ7d5RuFM7DR
        6ldLSkYdLVtFMX3Xf5+L09Mz7g==
X-Google-Smtp-Source: ABdhPJwoPSyjUjRVlrMarrwmNlorL54H3jsq17PlEllH9h0xlrlFpUHhQj+r8LKAhGeAf+q13tMx3g==
X-Received: by 2002:a1c:a507:: with SMTP id o7mr3293234wme.130.1620904040559;
        Thu, 13 May 2021 04:07:20 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id e38sm7979662wmp.21.2021.05.13.04.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:19 -0700 (PDT)
Date:   Thu, 13 May 2021 12:07:17 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mike Rapoport <rppt@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] ARM: fix gcc-10 thumb2-kernel regression
Message-ID: <20210513110717.s2gr4l5upqzjkb5a@maple.lan>
References: <20210512081211.200025-1-arnd@kernel.org>
 <CAMj1kXECGjpxx5ouWuvnKUigzMGu=GcE8_ab2rrxt98yU1jUnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXECGjpxx5ouWuvnKUigzMGu=GcE8_ab2rrxt98yU1jUnw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 02:38:36PM +0200, Ard Biesheuvel wrote:
> On Wed, 12 May 2021 at 10:13, Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When building the kernel wtih gcc-10 or higher using the
> > CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y flag, the compiler picks a slightly
> > different set of registers for the inline assembly in cpu_init() that
> > subsequently results in a corrupt kernel stack as well as remaining in
> > FIQ mode. If a banked register is used for the last argument, the wrong
> > version of that register gets loaded into CPSR_c.  When building in Arm
> > mode, the arguments are passed as immediate values and the bug cannot
> > happen.
> >
> > This got introduced when Daniel reworked the FIQ handling and was
> > technically always broken, but happened to work with both clang and gcc
> > before gcc-10 as long as they picked one of the lower registers.
> > This is probably an indication that still very few people build the
> > kernel in Thumb2 mode.
> >
> > Marek pointed out the problem on IRC, Arnd narrowed it down to this
> > inline assembly and Russell pinpointed the exact bug.
> >
> > Change the constraints to force the final mode switch to use a non-banked
> > register for the argument to ensure that the correct constant gets loaded.
> > Another alternative would be to always use registers for the constant
> > arguments to avoid the #ifdef that has now become more complex.
> >
> > Cc: <stable@vger.kernel.org> # v3.18+
> > Cc: Daniel Thompson <daniel.thompson@linaro.org>
> > Reported-by: Marek Vasut <marek.vasut@gmail.com>
> > Fixes: c0e7f7ee717e ("ARM: 8150/3: fiq: Replace default FIQ handler")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Nice bug!

Indeed. Many thanks for those involved with the find and fix!


Daniel.
