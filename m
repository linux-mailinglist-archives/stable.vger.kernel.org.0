Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069A73CEFA0
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352683AbhGSWTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354304AbhGSUXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 16:23:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DCFC061788;
        Mon, 19 Jul 2021 14:02:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b2so5751458plx.1;
        Mon, 19 Jul 2021 14:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OhK3u3FqQBViJYF9EHyu7f3sYqoxbsemvfR7CYLIyP0=;
        b=IFGsz6nN1pnrS96DBQAHtNcq5gjiVVi7KPSamFL7ln4A/BY57kuHcGHJvqOJoZKKl7
         av/MmjUMwc5cM5TKjRuzDraaIF2h7Xr7NF9J46qo/BDIZVBPpiib8T1cIMl66KJkpz+7
         JkHe7+CxJeRw31PZ8HirqPKkoSJoqtsqlsLquJvVdD4dEs29KvoNa03j7sDtVfCaGyeB
         p3PZ0XjccnmskDjnSAN6lezSZjzz7ponqbq+Kwzl517+EmJNSD2gJAYWXupAp878rRJc
         ASyC4ISq48RzpJslK4zheKKxnFoa6SLplErC5zQo469S8VKFrBF7YzjqNQlrRWQS4Rlb
         B5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OhK3u3FqQBViJYF9EHyu7f3sYqoxbsemvfR7CYLIyP0=;
        b=FAVxE71sk6uzikjnuLSvA+YC81GQz+NLvQGnOK9kjgCAaPxNpJXf8MIEZd5kdVeLyN
         XFd+s8ZpkBPh1kgpZlYqSsi7hKZ8VdV6V/fUHSMdXWba8bKMeJ7BN3LBBcIwDpbnJr7A
         YcgZf3ravGv4lBXMMCVuyCFQks19zWV2SqVYs+dD73Gr7hu1ZQxj7pmUq2twEOHmy8DS
         M5fD4Vme8diEexupRIXmhuhFYSTueQbi4wB8ybWLzTYQrlVBhcbLBPDYHuO/9wmhiSrn
         z0uMLjVrkJfbYmhTTTdXz2qpoguNBljFf2TnaOeRZMWfV28LLjSZnDCsuJnu+7pagQqT
         kxow==
X-Gm-Message-State: AOAM532QWXI79i9MUv/mN+Ds7DzyQa+/gwCwTyAHs5ZVK/4//iGnGw23
        ziL4lVSAh3Hy9KfZ7PSP/+ydFNpXIdnA9w==
X-Google-Smtp-Source: ABdhPJxn32UuhK8Qw1HPKzbBqqU6QBsxWwlMklk7fFT89dGmX2ooX9wq6oPWA6gPNfjw2Q+a5AoUMA==
X-Received: by 2002:a17:90a:885:: with SMTP id v5mr32474845pjc.54.1626728601465;
        Mon, 19 Jul 2021 14:03:21 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 11sm23547432pge.7.2021.07.19.14.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 14:03:21 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719184320.888029606@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <03b1d9eb-7c87-7463-9dcf-a98a64be9997@gmail.com>
Date:   Mon, 19 Jul 2021 14:03:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc2.gz
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
