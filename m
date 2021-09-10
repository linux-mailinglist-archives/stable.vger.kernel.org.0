Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C37407195
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhIJTDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhIJTDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:03:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B8AC061574;
        Fri, 10 Sep 2021 12:02:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j2so1760517pll.1;
        Fri, 10 Sep 2021 12:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jf3+vhrXJG9ay5pG/QtKVNqFS5TdYiq8331goxWgBQw=;
        b=cEJvAJJNpBU40cq3P7Lef7/ESaxCATEQVPQTPazuVbjLHCiuaJ0ZPsNAT9nyx5nfsE
         6KWiRnw5JAGM3WtX7DpXhG1MFZ9AOUBEm9/zJVxxtqgxYmCJmVfbuGKJ05+xZnn8QJBa
         c4eImtGZEb/RuF9hKS0jn92p0so/JW8LX/EMmvbPQ5Qs2M6vqHrqOrJ4s7OyJ+sI6CKa
         Y4vR5lF3W0Jemw/A7ju+Qailc5GyjNyjuSIHpPPMBxqQjey97Xdbw+KPU7Mg/wNx+RHx
         eDgyMuSiYsnxuDfAmqt3LqHkmgQBN1wmu+B8cEFTHDoJXoyv4VfA4dFh7e5JLsXykueW
         U9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jf3+vhrXJG9ay5pG/QtKVNqFS5TdYiq8331goxWgBQw=;
        b=SgCBO0uZK9acaKNmFDIWj1ZOJX7vDRHy1ylwwB0wqjoeOuZxVLRpBbLytXnpsN56tp
         Dbek9LEtFbuZq88lHX/8CbHUhxDJ1JZ9Dwyn7UQVrk6shg1uWjajbLS0t9CnMZT4Nu7W
         v7KV90Q4ybk1PTKMOJy7bp7mdzUJ8v/+5vTws76tA566J3wcpUkHrvJXfVWiwGeJtBQT
         vHJ2H7krf0Wju03BLYhYLc2pvNINz/oBrLOD4xJKVBP4mytDZIZElvzRssZVNQHuwoKk
         0yJ/SJLOwnvm2GMv8/n9fxBTwmYLGmU1mtQ0B96nqszhAdx27Ozb9d/SEnW6SltOUW2U
         /9nw==
X-Gm-Message-State: AOAM531MlcTz3HfasBBOQoMfD71JJTuHw0A0rH6LDSmUughzCXeUa4gV
        KMoFx7HM7B/gnMli6qR5zis=
X-Google-Smtp-Source: ABdhPJx+uzQFWFx65Zp2IcwgFaoQfVpKJ0X7QGMnGgsaXzO8obWgM4n9xRwU/kwvLXycEkO4L7ESHg==
X-Received: by 2002:a17:902:bf43:b0:13a:ae0:9dee with SMTP id u3-20020a170902bf4300b0013a0ae09deemr9095833pls.62.1631300556356;
        Fri, 10 Sep 2021 12:02:36 -0700 (PDT)
Received: from [10.230.24.142] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id k12sm6077657pjm.52.2021.09.10.12.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 12:02:35 -0700 (PDT)
Message-ID: <08c7411d-4a6d-7b7e-f95d-cedb79451da6@gmail.com>
Date:   Fri, 10 Sep 2021 12:02:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.10 00/26] 5.10.64-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210910122916.253646001@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2021 5:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
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
