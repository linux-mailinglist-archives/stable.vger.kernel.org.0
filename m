Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56D453987
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbhKPSqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbhKPSqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:46:53 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D188C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:43:56 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i11so109988ilv.13
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+1IV/aieggyIrL6/Q01qnvaTCtM2v0mp9FZfzb4qNUY=;
        b=KYeUJ8z5tFt1d8r8q0t95j7+UHyN5cwkUymBRTuIQeh53FMWDlgng0xcfqSKUf9Y6w
         FMEIOEquOExyXS1om3+3RwjIIt0cTmTwenjy78HiCFD0wYbQPZJtkyiL+cjZwHN7ksVn
         YxhSNeNfCG1s5EzP3btj45Gy1vPj1T3CzcGXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+1IV/aieggyIrL6/Q01qnvaTCtM2v0mp9FZfzb4qNUY=;
        b=m4+LwBXVgDfAZlOjb86hh76HXwWsAaqO2RNYVPcnxCj0On73pXFjgOxdJWRRctmYru
         d0O/8m34A/N/9xLOdklKVxqbNuJGR6tjgVOoVZ/97/G6n4lpuum1CurDre2LGXgYTZyI
         +Y4fZpdVkHCn94OOMQKaXURtiqhoKYnRAID8jiSUrmIPvfwVKCQf0SNdicNyOwMuq/Tw
         YQm1hNJu1rCwL4sgYKPxoVcMfdx0E8nW1E6HZVdghvHJp7DdTirDF3+h19e/D51VeSZE
         zY/LZ5gzGauz7Y+UyO/4kPj8QMJCzcizzE1B3BQPhwXN3C3YOVfSqi1eU4U4LWi9cZ7B
         URXw==
X-Gm-Message-State: AOAM533lS6shkD19HTCrvDDSIG/P+uTcWNx+UlB5JuhZ6n5RCIatDh3p
        NfeD5dUxIGq3JY6SYE00tXVqug==
X-Google-Smtp-Source: ABdhPJwv5CfwGvMRwqiJUlsDdzLqWOGuqEqhdcJivfGpuUbB67n7Zd82raJ7v/H/gxz8NEjMxB4LaQ==
X-Received: by 2002:a05:6e02:1aaf:: with SMTP id l15mr6336339ilv.318.1637088235980;
        Tue, 16 Nov 2021 10:43:55 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d10sm11471278iog.25.2021.11.16.10.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 10:43:55 -0800 (PST)
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211116142631.571909964@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2e113685-9ce5-2bf6-a6af-fd53f5c0c316@linuxfoundation.org>
Date:   Tue, 16 Nov 2021 11:43:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 8:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
