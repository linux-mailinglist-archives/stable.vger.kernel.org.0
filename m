Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0184547B208
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 18:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhLTRW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 12:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhLTRWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 12:22:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960DC061574;
        Mon, 20 Dec 2021 09:22:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v25so4888012pge.2;
        Mon, 20 Dec 2021 09:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nowcKDccwKgaTNo4Kzdq1MLqPv2Sy1k6sohYfNAF0WE=;
        b=mePBu7WyFvk6TAyQZaqqc7FzfYURuaqPkDGdkPCuLtajcaXOlYbzE4yCz1ZYFTWBCI
         a+sCEptLIqw0HnMxQ6aCeJmaxf1i/617PaZ9Xjssq9ete8JyToVVMsgjrF2yCEcy8JAz
         Ifi4PzRSnk/XVl8PqM7R3Kub5cRS0pVSt59aaLQVICtA06qtc0XOOqM/uZJr+M/UrT6X
         d3ZYcDtHRzot5KDJxG9gdu7rICDsTsWjj7SOrtGq8g+Ormoc5yIm0FjnJ+bgkfJh0L7+
         olg30y1OQWPsUGEt0/Ddg7LQBAWvdzn6t6LpZE1wbA73ycDwOIgaD1OTXuSlXorImxO2
         81Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nowcKDccwKgaTNo4Kzdq1MLqPv2Sy1k6sohYfNAF0WE=;
        b=RUX9NOKBgVT2uNuA2DsF6MAXmPZsu0kBBJQm3Ip/T/IiEqO0lH2y6ZSExbCfctERlD
         VAJwXEUQdXJpwBjnsGifpKp78pU1kf8QKSIIjzd4S6svDPJ7kpFdxwU4TCVNzHQYGc4t
         GytwLtDCfmRZ8RG6VaBIA/KWpJCB13NQcLMVhDCs6v6clS0TSPWhb1Jg+jU6NakStxfI
         EMAItUuobjw3YzqLkwf3OEUzjWD6Sk3Ez7Ty9NKJN8G8JRgXSbp57WCQQfX+JX8WH06L
         0kBoIm1tubJ++pO0mrFqNiydSdKSZL+FgEoX6KFbJb1ldvznS/TxbfH4olwGJB6ysnCD
         LgsA==
X-Gm-Message-State: AOAM530S/L0/w1VpFne2zcO1l+Wc9s8OAqmWm1vDIf+/WTo3yYi1xvmO
        bUmupnI7ampsSDoYvrmq4nY=
X-Google-Smtp-Source: ABdhPJz3s2aM4rqat9iv5qI1WelGaeZv6IRjbIyauZnH43r62IW6GywHdKT6DS3ZY3+Bz0/PYz5FiA==
X-Received: by 2002:aa7:81d4:0:b0:4ba:95d4:81ee with SMTP id c20-20020aa781d4000000b004ba95d481eemr13075910pfn.14.1640020945015;
        Mon, 20 Dec 2021 09:22:25 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id i11sm1616415pfq.206.2021.12.20.09.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 09:22:24 -0800 (PST)
Message-ID: <2e5da84f-35b0-c336-868a-48ee574dfa27@gmail.com>
Date:   Mon, 20 Dec 2021 09:22:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 4.9 00/31] 4.9.294-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211220143019.974513085@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/20/2021 6:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.294 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.294-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
