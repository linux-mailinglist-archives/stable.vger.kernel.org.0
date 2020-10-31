Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464C12A1370
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 06:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgJaFJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 01:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgJaFJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 01:09:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4D7C0613D5;
        Fri, 30 Oct 2020 22:09:18 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id r3so4026272plo.1;
        Fri, 30 Oct 2020 22:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/QYgX7jmDmZ/5C2esaRsn+aOZTolMLn2ocrsNfVvcy0=;
        b=gKWgHftbGrOdn834mddCqRUieroHULWR3rrAPXb3w7r3m0Sw3CyB7zMOnssmvgQ5Ff
         k8YdO1+h3m4g1Y2yPhdBxC8yCo0pGNvi9XJ2RA3S4GvMx7lJLPyPrHt+6HKBHyzK6VNj
         5kL4/aEWEuhBwzMabtYRZD5vKRvCc1iP75L3SdrBh/T1nLsb5CXIVSwibILpHHeJQ8Uv
         oKQETHvaI6+vl+GTtP0ENWBefbqdLvhqGsxqDQJNRU7ZTM4WOHCmhG9PkQwfOPJhz8XC
         tM2yGrknIOMj34EkjubaK0L+v/GTb2wSFtvdyuVrRqAhRJxA1xnS+qPopf9r3MZ/yeSC
         645g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/QYgX7jmDmZ/5C2esaRsn+aOZTolMLn2ocrsNfVvcy0=;
        b=fBeuZL8Ds3VRgotm0QBudDxtlijDywlbIHKPRl5gN7gR/Ky8UphwEoO+cR0XhKeOsB
         ANqtCn+3sz2FbKCkIVtGyKgSF3yCl7crQssDJ6LiZVM2nt4FP1RnesewOZJwpGZmfKIZ
         98z512hP603yrc3PKNYcs8XZXpR0gmn0wRlcuXzRw8cm7g7AZgqnnvKMyaHLWoWAoH3X
         kc0COhVin/R7lKjbV1QP1OpPvJ6ALV+cLY5SirgEP2phFNhkt9ATrp6g4cVMP4qLJzd/
         16Cgo7k1OgMX/P8HXu6oVJ7A5MJ7GuF3FNVERXkGQB+FbKGXfLhn94QNE1cGKB7aD8lW
         UaPw==
X-Gm-Message-State: AOAM5322C0bqqp/10lMSslYlCWwT3NYwNcn/4fRj2kvGaFtyLjdyUQeh
        KwYEqrgUFGDM+MhRn/LKcTJPWdOKyHSf
X-Google-Smtp-Source: ABdhPJxnkRrn5aCmJrl9Oj4kSF2BOlH0RmWcFy9bYvGaXSp9grFE/PqWRxELe56IO5T3n+Epa8WJPQ==
X-Received: by 2002:a17:90a:fd02:: with SMTP id cv2mr626350pjb.176.1604120957620;
        Fri, 30 Oct 2020 22:09:17 -0700 (PDT)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id 17sm7342488pfj.49.2020.10.30.22.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 22:09:16 -0700 (PDT)
Date:   Sat, 31 Oct 2020 01:09:10 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>, daniel.vetter@ffwll.ch,
        gregkh@linuxfoundation.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        yepeilin.cs@gmail.com
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201031050910.GA1289347@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030181822.570402-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lee,

On Fri, Oct 30, 2020 at 06:18:22PM +0000, Lee Jones wrote:
> Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> built-in fonts") introduced the following error when building
> rpc_defconfig (only this build appears to be affected):
> 
>  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
>     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
>  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
>     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
>  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
>  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
>  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> 
> The .data section is discarded at link time.  Reinstating
> acorndata_8x8 as const ensures it is still available after linking.

Thanks a lot for fixing this up! I wasn't aware that the symbol is being
referenced in arch/arm/boot/compressed/ll_char_wr.S. I'm sorry for the
trouble. The patch is,

> Cc: <stable@vger.kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tested-by: Peilin Ye <yepeilin.cs@gmail.com>

Thank you,
Peilin Ye

