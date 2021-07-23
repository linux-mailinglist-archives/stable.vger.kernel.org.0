Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462EC3D3D59
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhGWPgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 11:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWPgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 11:36:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08C2C061575;
        Fri, 23 Jul 2021 09:16:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e10so3832784pls.2;
        Fri, 23 Jul 2021 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8adZKflaseXf3qb6J+GzSQ0+QGtzuJR5xVxcfLjeoSo=;
        b=j+SjkE/jTyS3GknkgaFflY9OIfGrmjwY5icWXnTn9+pg0LgrSAcvdukSHh4sionjsp
         uTb3KiKPJRKWvrSEamJlxHvogpneO9vSoGt28+rsDN7y6uqOBYSjEAlPWjbwZDzctmZe
         eiwSOriV5bSOuLgPTWa0xJw35qGvVDtPdXuiKkOAj9pQbAuwpPvmjF8JKnHxumSvLcNt
         FblO03sEUtPTDzVe8R+BQX1pAVLEMJM4JW2pqY7YALwxVH2xlZHiUHqqEVInyKp3EadD
         E7P7OUwCQqu/i/XGBYJphTNyGb3wIGLWtOW4c2gR2avFEOaMU7mGC0cgpGvXNlK7nwhJ
         is9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8adZKflaseXf3qb6J+GzSQ0+QGtzuJR5xVxcfLjeoSo=;
        b=eGeslv7N8DvOdC2/NFWl+g1HyKSBo9AKkXwTyYiBasDoQBVaD0kn34fK5HnZYpCJ7Q
         t4hJd8yG5tMFyjQzo7i5ovkhYFu62Qo7aTRH4RhHkAFLp+IWz5vHQZM2FfGS7TB6kbXJ
         gNGljgIoe9vawxUM1/rXrWIhWBHvXcQ0BzKVQ9t6UFy5TABhCtqp32h4kiqvBKK23UsB
         4tT2h/NXRMlUqmfg6gqB3zmVDLJuzNZibJhYa3LN0rrPE9j1fkBJuFfTRGDHRO7qWpim
         7nseES/zFxgHj1OgYSdRPs2xpvPNtFqnm1Nkv4V0eWspXGe3E1YikcYDm5m9AZ41Mr6J
         nd+w==
X-Gm-Message-State: AOAM530xZbcVatk9XO+8ouaaHR3Kk98C9PrMBTMY/+RRwWipItdbICp7
        bcZCkRbJxWUmlmNSEcBOzXCgv7BolU0=
X-Google-Smtp-Source: ABdhPJw/JC1cFhQd8Oz2qn9+uzc+6kbrCqHt4/5IhJgqhQFIlEcwzxljaPzr/EvWCCGAqKrPGPeE9g==
X-Received: by 2002:a63:c147:: with SMTP id p7mr5589915pgi.415.1627057011974;
        Fri, 23 Jul 2021 09:16:51 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id b17sm30937984pfm.54.2021.07.23.09.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 09:16:51 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210722155617.865866034@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <45b0e7cc-56c0-a99b-6a3d-5d6c49108199@gmail.com>
Date:   Fri, 23 Jul 2021 09:16:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/22/2021 9:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
