Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019E354BFEC
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbiFOC7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiFOC7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:59:54 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E746675;
        Tue, 14 Jun 2022 19:59:53 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id l192so5692099qke.13;
        Tue, 14 Jun 2022 19:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3J+GQznuUXQiI93tyU1L6VthWT10VpFAq9aJ2OnWJU=;
        b=VxJHgVuTjo2QD8B+BMaw/XmEu/z4sSdLVz7HNg6xmOpYjwn3pGdVQI7lQCwRks73/I
         1KjHe0NB2gRsWl4+hPX4OhKVJyktyBMLnd2LT8juToOmEO5i3rvmtB+++fza7ToBxrQt
         5NeeJ5cakoQNoZB12wMYgYTCIU19/FDw+LH9tWV9R5EIoFyFTsq55nWj2KBAIR3OI5H+
         79r9rrjnDPyu+IV8GJFsAIqE0Y6pADHlW6V4fwV5Vqk202mKvPwPgl/GwMyZE34t3EmT
         QBZP0ntWkjGNdPep+XEH5HuL1rvtQ2KtDtr4AaudCmLcNdAcis2BQv5b5fLr4f7hSY1U
         NrGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3J+GQznuUXQiI93tyU1L6VthWT10VpFAq9aJ2OnWJU=;
        b=MWNPOOz+GWlDIIBFITVJYDMPrYJ7YU6Hc90Kt/3t84QKN9EhLEGmN5k42zTwhPkj9h
         BpYESyO8TC7R0wJPLKGpuU8E+1uH1iJQG7jSSo0fSTYGPYhtyM15hfHVFhNC47t404QK
         af/gSiWZEEjy6kt3iC6MkN97IC3c2Bz5p5FIwQROmxi4XlVeVaDkTOx77pLuT0u81c+E
         kj+b/xh6HnIlyyEdv4dcCMY1yKARItc2GUI4H934l80ogASZvlIW0Ft+es0FI6XkddSu
         gjiSw3ebiI3sbi0T3DFpFnmO8PZ6r0O4iU6i5mV5uljOQHNaJ2QLsOQWuz3srZYtE3RV
         8vuA==
X-Gm-Message-State: AOAM530+BLm9DP8VkYsOGxy77lniAt19XfBGQmyAdKtULGhTFDG5Goqw
        98Q6Db9woz2s9qifuiWkeLQ=
X-Google-Smtp-Source: ABdhPJzU8UAXP0IkfOy4H9sUURlLpB9LpqUnFHG7i620UZ67oCnA8AaZDn3plz6a+1qNFEgF+ryr8g==
X-Received: by 2002:a05:620a:2910:b0:6a6:bb03:ade0 with SMTP id m16-20020a05620a291000b006a6bb03ade0mr6544520qkp.655.1655261992417;
        Tue, 14 Jun 2022 19:59:52 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:6d39:b768:5789:ec2a])
        by smtp.gmail.com with ESMTPSA id t16-20020ac87390000000b00304edcfa109sm8239554qtp.33.2022.06.14.19.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 19:59:52 -0700 (PDT)
Date:   Tue, 14 Jun 2022 19:59:51 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matt Turner <mattst88@gmail.com>,
        Brian Cain <bcain@quicinc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-alpha@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/6] ia64, processor: fix -Wincompatible-pointer-types
 in ia64_get_irr()
Message-ID: <YqlLJ2IHAIn4kv8Z@yury-laptop>
References: <20220610113427.908751-1-alexandr.lobakin@intel.com>
 <20220610113427.908751-2-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610113427.908751-2-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 01:34:22PM +0200, Alexander Lobakin wrote:
> test_bit(), as any other bitmap op, takes `unsigned long *` as a
> second argument (pointer to the actual bitmap), as any bitmap
> itself is an array of unsigned longs. However, the ia64_get_irr()
> code passes a ref to `u64` as a second argument.
> This works with the ia64 bitops implementation due to that they
> have `void *` as the second argument and then cast it later on.
> This works with the bitmap API itself due to that `unsigned long`
> has the same size on ia64 as `u64` (`unsigned long long`), but
> from the compiler PoV those two are different.
> Define @irr as `unsigned long` to fix that. That implies no
> functional changes. Has been hidden for 16 years!
> 
> Fixes: a58786917ce2 ("[IA64] avoid broken SAL_CACHE_FLUSH implementations")
> Cc: stable@vger.kernel.org # 2.6.16+
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Reviewed-by: Yury Norov <yury.norov@gmail.com>

> ---
>  arch/ia64/include/asm/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
> index 7cbce290f4e5..757c2f6d8d4b 100644
> --- a/arch/ia64/include/asm/processor.h
> +++ b/arch/ia64/include/asm/processor.h
> @@ -538,7 +538,7 @@ ia64_get_irr(unsigned int vector)
>  {
>  	unsigned int reg = vector / 64;
>  	unsigned int bit = vector % 64;
> -	u64 irr;
> +	unsigned long irr;
>  
>  	switch (reg) {
>  	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;
> -- 
> 2.36.1
