Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10094930A3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbiARWX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346295AbiARWXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:23:25 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C53C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:23:24 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o10so563823ilh.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XNtPWssh2PR7qIeRLLnXLaH7QUkJNkbsX89oO61tgEs=;
        b=HBCD6c1u9U+VHasxhDGkv6MsqGDiBq7Y5XHuEk54q0hoP2qnqcSjAIGaLQhh595f0U
         BrxILAgrQ2eMXRZeg3/X0jlXFodHLThFHNQhHe3qOuqn18Lw8NXEQmO1cCZ2K6wNeOAo
         TcFqEQOsJDQzZ78RTqr4UqscVddHo16AK98hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XNtPWssh2PR7qIeRLLnXLaH7QUkJNkbsX89oO61tgEs=;
        b=NKK8F24SxYGWlSvKvSgZVCFFd1JuDHgsK/3pjJKQkjuJ1vMYoNaUUz7w8krdwk66oT
         9b/eGjgjDG0/zRCp1vekdmytoV4egWy0qzxi7DKlPjWtJIbvcUJSeYu9pivVtUtgCln2
         SCmqCGHN0WbQeswqcY3JmFwHOZTFkjsZOOd73YDR/InHk7e2R9dmD+696lje+eXZyhRr
         MTK0nGXpS4nEuJN9TZKGKw0gzvAmo/cPLIXKC2xCvmUVFbSwdDc6G+2AqNC8JA5dQm4M
         Ykc1vXp/A0GFmA59WY1NdbOkbUqdGUgdt43sC0oDYNPgfErrIVj3EFrdgVTORcRyV6jk
         z3WQ==
X-Gm-Message-State: AOAM532Kg45JIeyuQd+dhrrUWdOB8xSr+Nps877W9Cejl4YUC4XPSJ5q
        IVqJx4Y+Ry9RRAKB14sSV3qTpw==
X-Google-Smtp-Source: ABdhPJwiBRUuKE5rabBe+QBx74lQbz7p8AFC/KpUmqMLxuWs7wkze1wKpEOH9zkJY1mvJG0a8axiXA==
X-Received: by 2002:a05:6e02:1c4c:: with SMTP id d12mr6954190ilg.241.1642544603945;
        Tue, 18 Jan 2022 14:23:23 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id s20sm11768549iog.25.2022.01.18.14.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 14:23:23 -0800 (PST)
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6a931b78-543f-2ee4-0d82-b65b3e408d19@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 15:23:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
