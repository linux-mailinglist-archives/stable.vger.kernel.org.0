Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2AA3B1C85
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhFWOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhFWOcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 10:32:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7C8C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 07:30:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g192so2451507pfb.6
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 07:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WKMVzZz8u7uLBmWomdYlr+oMy96WS6tUJGPPtCZ0D60=;
        b=eYVZTdGsyVwQA4kGhfrZ47tU/XyD6Gdfb5Rx3FV6lq4wWZL1YRspeUnNTaN16uOM/5
         PiZwMKxRT8JUaXAUA/B6aFfoWoCGBSxCgq9OBk8jcWvqbh7VlX3w1dMY1/ykca4/GhDN
         OY8g353DIBKO8cvg/x7Zg5+Dnx1v8r30cn340=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WKMVzZz8u7uLBmWomdYlr+oMy96WS6tUJGPPtCZ0D60=;
        b=OsndN7NbCQarVILEl8NLB3FdnjtQugwsrXUSPJMBkfQXFxVb2LyAQyD4OYXfOrbP7A
         Iy6cnCug//Mx9H8uSF92iO+x+ddAvIOLYtrBj4bMVlpyRvxeCsQ0nB/Y+Hw0Utqg1XIE
         SCrafjzPqP3KB4HP0w115XDrNx63tq2VprA9NThv0x4cAzUwkYyhodDeAw7TpKvrOXe+
         otibnd2v6Cmh/f8Fe2cgzrpxIW312Wh4J3UXn+lDUQw7Kp1JNnf4B02VAHxBj7yK5IRA
         5De5PjM4szbwudovHKW8Lmrjh4H4LuHMoaJTCluVLJmQHrWi8sVi0PdzEXhSKKnw/doa
         RPbQ==
X-Gm-Message-State: AOAM532VKMwvOty+rc1QIcm6LgurXE6C9tXHSc5QgoxOebhd8Q7kTApr
        fpDjRn2dXYsGu+j71BHsmikB8Q==
X-Google-Smtp-Source: ABdhPJzBNh/oD3wHuk2SjWKRS7Sjx1wJamx3k/4NZa6pNlIIEJ2pDtPK2Km1/JZKZW6Ey9ydWdubmQ==
X-Received: by 2002:a63:8241:: with SMTP id w62mr4176796pgd.343.1624458627555;
        Wed, 23 Jun 2021 07:30:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q4sm158954pgg.0.2021.06.23.07.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 07:30:27 -0700 (PDT)
Date:   Wed, 23 Jun 2021 07:30:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [selftests/lkdtm]  84d8cf25b0:
 kernel_BUG_at_drivers/misc/lkdtm/bugs.c
Message-ID: <202106230728.4844CE5@keescook>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <20210623143549.GA25993@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623143549.GA25993@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 10:35:50PM +0800, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 84d8cf25b0f80da0ac229214864654a7662ec7e4 ("[PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL")
> url: https://github.com/0day-ci/linux/commits/Kees-Cook/selftests-lkdtm-Use-bin-sh-not-SHELL/20210619-105959
> base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
> 
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-f8879e85-1_20210618
> with following parameters:
> 
> 	group: lkdtm
> 	ucode: 0xe2

Heh. Yes, this is working as intended. :) Most of the lkdtm tests will
trigger Oopses, and this is by design: it is checking that the kernel
catches bad conditions and freaks out appropriately.

-Kees

-- 
Kees Cook
