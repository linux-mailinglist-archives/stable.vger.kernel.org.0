Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6EF3D3D94
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhGWPsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhGWPst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 11:48:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EFDC061757;
        Fri, 23 Jul 2021 09:29:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mt6so3017967pjb.1;
        Fri, 23 Jul 2021 09:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIKj31Oo/zr3jbTWMWbuyMdyd4iHxr80M6hnYhXyZl0=;
        b=a3uROgnkjjAk8YLnKU4cSVut6iQEriiijgTGY7s8/WllrjcuuG5F9ah1Jxzu/X/tHc
         GHWSEORALlH4KTH8J9iOwj+5zQCYwAhGBI/eDHhRINxFUCwmN8p+CNhTeKTsaSG6L7Ju
         S9EOrEkjmnYcwHBQB3W2Nm9kScfGpqDJZiVa6AYbHqWgYfsgo65qhG+pSycRluNrUJ/X
         CwFQ9n5J0Z/OWtDyjk202aeTA1o+VsgKn0sK6fBR32dmZVzUmx5RIfVv/rIX7hmMrH4u
         Ov27NxipynQxJRVWfBheja7mLdAm3gnOYMvJGs+kZHKB6rqBAwmzlnmTwiW4afWJ7sR/
         bvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIKj31Oo/zr3jbTWMWbuyMdyd4iHxr80M6hnYhXyZl0=;
        b=AUxGr5HTHCahfOkPYMoqcqumVEwi6kYRWVS7LPoUbhHp7G47wGwLajEfJD/9fi8bTm
         ch+B4YLZ34UXXTfy9Whn/5frMPioMia90uE3g65bCCQ1kvL2A/I4LPmGhJHgNRFRZ6Sc
         uSusuoaHlrl3h1DsGBWVT35yizjwi33q96lWYUv4obdApkXMYDdh4b9nQ0DrcQwTqhld
         ui2YN7riQKpe729mZ3OmoV+MJFHElgdQ9UvnbGTdd+ydZN8C+knhA5apNkUzqXxjtEoj
         NG4r3ep3WQVMcG2Jp/1iTxxV6F/nLOtCqVt1m5Kpab6I0OUv/BlOUmQBn0tl5sUrB0Bg
         qolA==
X-Gm-Message-State: AOAM532KnhiZP1LEBG3oip/V58ODMsvpT+LMucjNDxWI6LJFDR/Yp/1p
        eAdOMi87aTN0T0Ysu+q06css7AfEEko=
X-Google-Smtp-Source: ABdhPJydw8BYooK1lNNDqAnOt15dxU9337rlDTnh85atbsv7VSiYbJ9GGAQHXd6wS89+gowhXRaP1A==
X-Received: by 2002:a17:903:2345:b029:12a:cfac:3cd8 with SMTP id c5-20020a1709032345b029012acfac3cd8mr4390216plh.26.1627057762160;
        Fri, 23 Jul 2021 09:29:22 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id a20sm33232219pfv.101.2021.07.23.09.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 09:29:21 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210722184939.163840701@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4dbcdd07-baf3-9d0b-5dfc-110041905873@gmail.com>
Date:   Fri, 23 Jul 2021 09:29:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/22/2021 11:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.53-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
