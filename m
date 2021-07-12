Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6993C61A4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 19:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhGLRPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbhGLRPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:15:15 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1887AC0613E8;
        Mon, 12 Jul 2021 10:12:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o201so11949513pfd.1;
        Mon, 12 Jul 2021 10:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WCRRaRl9ViNQYcLjj8Pvk5/hKyaKb5DkmBptNf5pL0k=;
        b=uyatqZ5ZeHy3PJMUMFcxhxH7aTF/fb375LvlXwn8t73XShIGnvgGOgdsLYWCJQtz1s
         KU3uHw/86BCDYGNsL8MuXFMF54RVnr5BkaXVXlKxSIG+y3BDdhS95QucB+/CEnKwyjoF
         pC66NlwmWAu8rLVNsN2foSdk8HKDvWJNrwMhdJgy9400dAfZKcv5bQlG4/OqZmbsAEJX
         ah3GHM5HSnUpE3tZ6KI9idxqsNo7frovW/y3FC3nI3kx8jccFYgGddIjxyp0hn+XsGu4
         L1wcko+uKXhwuW6fJTIRH+WN4N9YRND4hqBHoiyaDIyomqqqN0QUJ5SZBmUKNeogFvV1
         rLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCRRaRl9ViNQYcLjj8Pvk5/hKyaKb5DkmBptNf5pL0k=;
        b=tI0nxXkQVGStD04I9UxyFACm5AnOJRvoMl4XDu66cOvT3gaRfTkoEuyZBEhgfyjchx
         +B6EMiPrtM7plmOqZsr+lXEjsimK6Mjw79A0+zyt6Fp1nBYjeXlLkawZLyhHLfKRcuDn
         +8YKOjalMDAE7/Mv9f3a/aEiLIw3ftja7AN34gPmmY51aWKSvGxqGju0yL1RrdMg2fF0
         v1txl9gg7+Q8CdYdGGBpplBiQVSpAMddzipUO7gvg1yXvCUIdxemDE0XsEoDvxTvXQgr
         /zxioRpqgiDcsuVeuPQsSNStCLJ0H16vXoQX2nTKrHzih39PiU5a2AXlch2pwNU/ks+X
         LtjA==
X-Gm-Message-State: AOAM533gStTjyowaUgZ9AV250Wu/cISav+2LQxXNSKryT64roBBjn2jV
        weD2w9KqVls8vW7/+DWAIrIgU5ytQfDbUw==
X-Google-Smtp-Source: ABdhPJxawsD+n7HhDtAS+H52YtXnjq8g1Cp+UOxGtvqbzGMfGhWtNxOvC4+7J9fnGK+Zpe49PQsKcg==
X-Received: by 2002:a62:2ec7:0:b029:301:fe50:7d4b with SMTP id u190-20020a622ec70000b0290301fe507d4bmr73328pfu.78.1626109945219;
        Mon, 12 Jul 2021 10:12:25 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk16sm8451377pjb.54.2021.07.12.10.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:12:24 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712060924.797321836@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46e6dd5b-ccd4-7e1f-fff5-be080c7d07a7@gmail.com>
Date:   Mon, 12 Jul 2021 10:12:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
