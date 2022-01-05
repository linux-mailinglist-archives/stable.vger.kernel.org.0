Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD9484C5F
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 03:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbiAECQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 21:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbiAECQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 21:16:54 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50173C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 18:16:54 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e8so29777699ilm.13
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 18:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d4b6IKxMdSuEUGh33dsjvNqLws/L4vemr/w9s2WFO/U=;
        b=dZM9lo5l8HjzUE3uAN9EwKgF3JJaCSDkEkrR16W6xjCq4VPy+rWJL66R9USOjwtV1/
         DdI9Hd6QHBgLQ75dzowEpUU6+izMG39lygb7b6earHdHHa0Q1tgfWujhR40CZookmiYx
         NsLSnA84/V5vfOfgX+Zduhz9EvSNwUA8pTodE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d4b6IKxMdSuEUGh33dsjvNqLws/L4vemr/w9s2WFO/U=;
        b=VJheuTYrMS04jLj15rCHHTn9Hgb/zJ2nn1l4W0kpq/znoUz4eTYTmdLwhBGqoRpvFC
         Tor9bBuEIp+OW5bEOOk7IizCm2fsXvhI65V8Lw9gE5ySUlquS9wMWXp+EFnEfTNZ6sqx
         +ixdDh/UelSNlFDAgpnkez59KIB1VO/Zrkli3eCqqssPdyAZY2yNfB2i7ft/OY0P8Ohz
         9jessb7Y1rPNdyQtlwZUnzDUy0d+cy05Fn2h0WRXaE22Wwth1/e1OByh7kzUidRXR5kA
         xN2xgGlaRseu1t54rSqckoIzyPbMnA9QAqBMX+PA4+ebslxZKqL7ak2ZZR38OS5A4wFp
         Ccdw==
X-Gm-Message-State: AOAM531uBMXJ98BhLT0ZVL/uo3TvEYdhFIlR1CkOtqHjby7YZ0g/ycX4
        M8cmlLlAnqasKkfquxROKC2VhA==
X-Google-Smtp-Source: ABdhPJyRc2s6ESavNX7Chhaed8PMpbWOl+AZEGzBTKKCU5zRTZCqjv8RVEg7od8gSTAfmJsQVdgDsQ==
X-Received: by 2002:a92:cd8a:: with SMTP id r10mr20032187ilb.145.1641349013384;
        Tue, 04 Jan 2022 18:16:53 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j3sm25352251ilu.64.2022.01.04.18.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 18:16:53 -0800 (PST)
Subject: Re: [PATCH 5.10 00/47] 5.10.90-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220104073841.681360658@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c89f5aae-f955-7727-dfbf-35d4fa080974@linuxfoundation.org>
Date:   Tue, 4 Jan 2022 19:16:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220104073841.681360658@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/22 12:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
