Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58789C18E0
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfI2SI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:08:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38276 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfI2SI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:08:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so8496552wro.5;
        Sun, 29 Sep 2019 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q7Nt4+duQpotUrg9cZce+XjSv5bPAauflILLelR5rNY=;
        b=lGlRE8qPfkrZlUOxjW7gvZ1eaqxs7xFRNqpWaBnQChVBSPqp5p4IxTfXitvtbdt+Jy
         VCkOnzb38e7uAptUVRPCG/P4hZbwze1evk4mJSvvcQ06RENDhE+OQmWUR5o8iju3/gHN
         b059o3mHgmjuGzL8Pfvayep+YDYU+luhq8A27xj5G/pS/DSGI5E1LJKsOdKdVXyZjqHN
         ZrpygPZQ8Xdtv1F3tKCnSvPXGVDw3Lhp2q1uWVdgv+Hjy9lq/Pdz79mc96eqshpFet6A
         GNeQnFB9R7NR5gQMdc0ZGjSo001H/VFMoKXXii/ulc+mRLpneSraI3II4HuKwl52mrXC
         zNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q7Nt4+duQpotUrg9cZce+XjSv5bPAauflILLelR5rNY=;
        b=bOLEa52YYXxyG2x6AZKx28ppCZEAoqccB93F+Ft624DWpVAG9k08sf5tDhw0yjmCGY
         dly8IR1nbFIE5Yr2xyEn94Og5uNB4LUw+hPRl0kBv9LCrGFLSv4PTcL6n5vNLCJhMrU1
         45ntwIsjxTUBnXHBKdXkoYjufL18l9HBgzsolVlZyXacTZP4NpgsJrqQomuHWB0DhuSE
         Cxm+Y7OFik5rzOEr00UH+YZ6Ja2FwN/gM1Tw6Ft5GAZXXCw6AgfL2INMBn0RKLwKuzMp
         C1Dmgu6SG8Y4+d3fP0hxj6SEzget1gBIsLYCigf/TxbVaaxSs07wY+1JH/icCZbYkire
         Lc1w==
X-Gm-Message-State: APjAAAVcySXKOs/Oui1kXpeuEm866ak2plqV2FaMHbssBhHIyTPx4g6n
        tFHrRC3889mBE2E5OwHGBrg=
X-Google-Smtp-Source: APXvYqyc6oALJdKNYfHzCYAHERLZa5ARLq/Lrua9iN0miCoy+W5ztmfwfCqDO6fe92p4++q8I/oC5Q==
X-Received: by 2002:adf:e442:: with SMTP id t2mr9030685wrm.87.1569780534389;
        Sun, 29 Sep 2019 11:08:54 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id i1sm26645189wmb.19.2019.09.29.11.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 11:08:53 -0700 (PDT)
Date:   Sun, 29 Sep 2019 11:08:52 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 4.14 08/23] ARM: 8875/1: Kconfig: default to
 AEABI w/ Clang
Message-ID: <20190929180852.GA901024@archlinux-threadripper>
References: <20190929173535.9744-1-sashal@kernel.org>
 <20190929173535.9744-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929173535.9744-8-sashal@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 01:35:18PM -0400, Sasha Levin wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> [ Upstream commit a05b9608456e0d4464c6f7ca8572324ace57a3f4 ]
> 
> Clang produces references to __aeabi_uidivmod and __aeabi_idivmod for
> arm-linux-gnueabi and arm-linux-gnueabihf targets incorrectly when AEABI
> is not selected (such as when OABI_COMPAT is selected).
> 
> While this means that OABI userspaces wont be able to upgraded to
> kernels built with Clang, it means that boards that don't enable AEABI
> like s3c2410_defconfig will stop failing to link in KernelCI when built
> with Clang.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/482
> Link: https://groups.google.com/forum/#!msg/clang-built-linux/yydsAAux5hk/GxjqJSW-AQAJ
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/Kconfig | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index cf69aab648fbd..f0080864b9ce8 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1595,8 +1595,9 @@ config ARM_PATCH_IDIV
>  	  code to do integer division.
>  
>  config AEABI
> -	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && !CPU_V7M && !CPU_V6 && !CPU_V6K
> -	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K
> +	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && \
> +		!CPU_V7M && !CPU_V6 && !CPU_V6K && !CC_IS_CLANG
> +	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K || CC_IS_CLANG
>  	help
>  	  This option allows for the kernel to be compiled using the latest
>  	  ARM ABI (aka EABI).  This is only useful if you are using a user
> -- 
> 2.20.1
> 

Hi Sasha,

This patch will not do anything for 4.14 because CC_IS_CLANG is not
defined in this tree. The Kconfig patches that make this symbol possible
were not merged until 4.18. I would recommend dropping it (unless Nick
has an idea to make this work).

Cheers,
Nathan
