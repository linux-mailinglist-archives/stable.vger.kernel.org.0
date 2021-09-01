Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B43FDF3C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhIAP75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 11:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhIAP75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 11:59:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E90C061575;
        Wed,  1 Sep 2021 08:59:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l3so2174807pji.5;
        Wed, 01 Sep 2021 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q4NDRG4trDiOA+lVkleeHrHertW81intr4IAkddj2ko=;
        b=m4OXwmWzSCjtlXGZZsbYbM+YGbicuLfDh9fLJI4HE45J8gAZjXFm7itPYuKzX3rImR
         o8Jx2RQHPTLc2kbR20hfqU2DQJTvg5dIqf3MESxx3XU3BPoXCjP/KrU9erjSiJNSlYAb
         XnDg3NHjYpkjm8SL3Dc9i7B0ipu2qY5WQp8R2cPPpbHqOn2p2QXyVRbK7vfr3WBBvq+W
         KgBzKVKFXkbu22U0dajsyLk/l6oK2n/7rZuaHMrs0Hst/JiqQcIpR4aaoD+USOOAITPe
         4SFeN/Asjg3C9c6b8CgG2EE21w7P3+DXdhygjd/DYBUX0OlNCHEV3kQsQnBZL7oEjoeN
         csOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q4NDRG4trDiOA+lVkleeHrHertW81intr4IAkddj2ko=;
        b=r7e2f+ssh/8NRdLHNFmPeA0yx/5nA20Cvuk+7XE8l+KVWCl7I3kntfkUJ7FNSJ6y4Y
         edI13NytiE46ZBGBpLRodRLaXcEQkkWf63prrH8NUm7fg9Uk9x3VQyZ+f2R9Ip4TzaBN
         /ZAbCInqPUQ2e38ugEc6TiPy56uR7Z10wGWaCDz6UreItjT1O4gWRgDkR/50YBbKsDa0
         MEby7OSxnA4s0kVPkN3FjAzLQjo7sYI7ElXyyzKgdG2xkIgHh8F4UznU6AN+fC3tgvMa
         tdSkVRmAkSulem2HaaiWSeLFNqL4G7JOhnOggMpkJvEpG4BZ3lihuT3ruVciW+ugajy6
         vsaA==
X-Gm-Message-State: AOAM530BFOO2Nveh+RlBJsbH1BmhcdK0cmLT4zAnbFWDqk/ZynNi4u69
        6LGi8xs7NdeEnfOb8bFskQw=
X-Google-Smtp-Source: ABdhPJzySvSrexdKwntgxfluy5f845Z+amHvmWsxXHIEjdR4BUFz9tEob+k1XOLOIYmjuD7+oPv+vQ==
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr47264pjo.231.1630511940168;
        Wed, 01 Sep 2021 08:59:00 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n13sm340239pff.164.2021.09.01.08.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 08:58:59 -0700 (PDT)
Message-ID: <0168539e-63b6-73ad-632a-841af1049a27@gmail.com>
Date:   Wed, 1 Sep 2021 08:58:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210901122253.388326997@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2021 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
