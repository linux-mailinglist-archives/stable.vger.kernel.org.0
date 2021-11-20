Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD51A457C8C
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 09:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhKTIT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 03:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhKTITX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 03:19:23 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998BC06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 00:16:20 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id l190so123868pge.7
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 00:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z5XiCfj2Z/rBTd20ZhwqsBtXxdupJhG928r1bZ5XbKw=;
        b=V7uRlvAxIx773C3zXLCk7VpxwB471u1gW3g6kXxqo5q/9YcTX7O79XxsaMghxQ6SS1
         2uYEVkSAf7OJHkqRlIQ6dz3L7ikp50TBvMgzD9/D9jd8oRPfGrAc1pLAVo5QbOYqcRyG
         vJtE0ibDCwuHUHeXxLhB8orQRvlCR/K0hq/hI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z5XiCfj2Z/rBTd20ZhwqsBtXxdupJhG928r1bZ5XbKw=;
        b=MprFapX0zT8kYA4y/4klSctBetLeDDVYmeF2qovH3Jdx/zQe4G0QXFBlKI3eiGA/RR
         X9tiCS1pGntXivyaZ6p/svtqUDxN/TAYHXbjMxwHqodPV05uJLpQ25/OmCzDGd88mUKb
         muebcVw30/AC7gJEOgk/DATD7JdUinTtKHfs7hn5kX8MZilJQ/G7WoJzW7O/8sgUsu1b
         +MQW0nBrGtI0Z2jmGbzpjPMny60uU/e9pCFwJCsmUQnqBpqv5wRpxVCHzHS9d7rPkKt6
         yy1PLUKAiDq3JMknYzvyl/UjyMpkVio7z3RbsU0SqJZQzPjc0XKDXK6eyWOeXMarBKt5
         5mcQ==
X-Gm-Message-State: AOAM533HBHXmL5X5BrGoNb6+mZdxOQaHBJPr90cYmLsj8uHb1Doodb4Y
        I/LpBtut2LeTQF0MTDd0KItMbw==
X-Google-Smtp-Source: ABdhPJykhMoFh97+YbzB9sdjNxmcKIIHWRg40YYOZ3KDsrKNpdNWxI+iwlclAMTUl+Iqbl7k48oAxw==
X-Received: by 2002:a63:c158:: with SMTP id p24mr21921637pgi.53.1637396179708;
        Sat, 20 Nov 2021 00:16:19 -0800 (PST)
Received: from c3218ffcf7cf ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id t2sm2011439pfd.36.2021.11.20.00.16.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Nov 2021 00:16:19 -0800 (PST)
Date:   Sat, 20 Nov 2021 19:16:11 +1100
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/20] 5.15.4-rc1 review
Message-ID: <20211120081606.GA7@c3218ffcf7cf>
References: <20211119171444.640508836@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 06:39:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

Looking good.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)
- Radxa ROCK Pi N10c (rk3399pro)

In addition build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
