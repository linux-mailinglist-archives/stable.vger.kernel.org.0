Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81A63616F8
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 02:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhDPAwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 20:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhDPAwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 20:52:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E4C061574;
        Thu, 15 Apr 2021 17:52:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a85so16786289pfa.0;
        Thu, 15 Apr 2021 17:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5vKfH0j/f6fb4wkpRoHHS0wOSCD6x6RBlRUQeYmds5U=;
        b=gSjtGQeWRjn3O9fXiPwIrc7is7Rj+Po/FZNwG13Rw7B591MpNq4Y8EubJLQwqgqk63
         42OwbKbDgKUGivmKIDuvowlqy0Uc5Vu7SV+NI8fxvPCgc2WE7gmIG7/8rSTxvMh8Z3wh
         S511qlzEdVDoxzMl5oIFMesnLRKYLLbD3xld+vTkSmXfeGsmFtRpwzoXNGwQd5I6EiP9
         vGeaotvL8oV8jpvt3FyLwVn+2iBBd91/179JWytBcBTgz+4sYOgpFKy2cgNSc4SpEssA
         1lfioK8/kJ3Cy4m9AP9puN7GBTvCwLT3g/IQwmXEVRaS2wIKe6wm/MfL+c8ksiX0fFUO
         GmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5vKfH0j/f6fb4wkpRoHHS0wOSCD6x6RBlRUQeYmds5U=;
        b=psQ06j/Z0eBCvbmJyumi4fJRcfo7mAQEfVSORd7tY6YT1G+dMviybwAHiv8zk2enB8
         1Cu/cQ41IvGAeuKXbgkkjCii3zwnfRjIAJvzmfI5lDCdMBW/sbFiuLwtL7+Lyhq5u5RO
         cCE2QVJfkgkxOSEXbmliwc8+xFNK4sLr1nMqOCosQsdjCImLOmHsINfVZJIT7CM1kQE2
         6KlOnhZy9jUJVkFxEOX2moD9pSQw20z4gvINIu0EdNCfIJS1FSjRfAjqfqhiXrEQUOda
         U3w/wDqr0jHkqrOcn03JcJprliqPZTH/njD4CQD8Bv2Q/e3rUSpXcBjf3tKmFJEVD5T+
         djLQ==
X-Gm-Message-State: AOAM532hYYZIxxUGf5TxiSeYYyJVw+4z4kql4IeX7fqyC4EbwKH2v37D
        YfgjK6gd8tC2fn35w7kjE4/7enpWYCs=
X-Google-Smtp-Source: ABdhPJz3fiylTU1hxFTWNsdQXmo9qbxS5a3PS8Td9isM2gTcVQUEBQFPiAiL0tKFNBGWvepL7z57cg==
X-Received: by 2002:a05:6a00:883:b029:247:562:f8f9 with SMTP id q3-20020a056a000883b02902470562f8f9mr5590269pfj.34.1618534325828;
        Thu, 15 Apr 2021 17:52:05 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g17sm3466630pji.40.2021.04.15.17.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 17:52:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210415144413.165663182@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cf161101-d00d-6fa6-d2a7-7026f4c72fd1@gmail.com>
Date:   Thu, 15 Apr 2021 17:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/15/2021 7:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
