Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02F94145BC
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 12:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhIVKGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 06:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbhIVKGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 06:06:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A053C061756
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 03:04:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w6so1424128pll.3
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 03:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8kPH4HQkMAc0LLPHmwkdBBdxuv43if6F7MJFbKxzWKQ=;
        b=SccsmM6YBplEEDPGy4q98ObAHtwV8bntql34ItU3AoPY1KDY1I1ktRGkKE349VCiva
         72fK3Vpi5bbgW9Rj0VW0Fm9toaeEP5lb3XM+eTTC+Ov7rbrL1cCgmOP0OVTfGvXWvmGl
         /uwhiuTieRur/pnrWuEmtcPzxK1gQscu1E/9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8kPH4HQkMAc0LLPHmwkdBBdxuv43if6F7MJFbKxzWKQ=;
        b=mhSh4+w0ymZnMb7HevQ2c+iBu3LyERT/cfOa9RBFchgZEUxoR3NkIoXUVxQbPBKOyF
         4Q4ez2t5+wekEUfqHx7AAB/CSRnYO2FI583ioEivgv81p4LS01MUUrpt2ONOliekGqko
         OfkOZ4wKmIM2VBjUSWboqzpaL5jIecmpRysOb5Hu2IbxxwM9ELYpNvgkpq6FMdX2R34e
         mLI5qn0nDT2PMutK2QP4A3KjtycJMBsubMsC/oC+dZKUL6mlEiAhhkKHaRrUwJfv6RNp
         Pa5UI1FMI6xQYPwv0i7+Ae+fPJsjQhwOaJOLjsDFAGk7AoH7GBRFUlG74W5zR1ntLbGB
         NWPQ==
X-Gm-Message-State: AOAM530kTD13wH7q8M5qWIu6bCbN1y7G8fp+RrnH8fMKIJl4uzcgmYJ6
        0N2kVVckALhXeUnEIQKpenLK7A==
X-Google-Smtp-Source: ABdhPJwY0lqWIYEs1Uk4eb8NsIqvypMRF6wbzK3uAZNcm6e9OwvcrMLZV+7CgAvJokoU1SPc1PF51A==
X-Received: by 2002:a17:90a:bd18:: with SMTP id y24mr10442050pjr.83.1632305070575;
        Wed, 22 Sep 2021 03:04:30 -0700 (PDT)
Received: from af2e84e6259e (194-193-55-226.tpgi.com.au. [194.193.55.226])
        by smtp.gmail.com with ESMTPSA id d14sm2033598pfq.61.2021.09.22.03.04.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Sep 2021 03:04:29 -0700 (PDT)
Date:   Wed, 22 Sep 2021 20:04:22 +1000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
Message-ID: <20210922100417.GA360932@af2e84e6259e>
References: <20210920163921.633181900@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:42:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.

Run tested on:
- Tiger Lake x86_64
- Radxa ROCK Pi N10 (rk3399pro)

In addition build tested on:
- Allwinner H3
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
