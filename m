Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3148F374
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 01:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiAOAYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 19:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiAOAYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 19:24:38 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F423EC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:24:37 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w7so9171325ioj.5
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s46FKFnKvlAbgM9CUb1xKtQxAj80C92DlWTSyX2PTA0=;
        b=PrJDg7sYywQBBKicY/lslA1ct1LHjE1GVO+MhYctAnz18S4hptjdM2YPd07FuknTyF
         sdlWePzqU7x8TEKSvXVuO3q+ajq2FIh/8yXRoZQBkhC3C13nrPLXuC2ozOL0Bq2QJ2K+
         Sd0IisAr+ijWxFNi5uuignLzgt1d5YXV/HdP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s46FKFnKvlAbgM9CUb1xKtQxAj80C92DlWTSyX2PTA0=;
        b=eiv+f4Tqd5TtQoq9+M/riRz6yUP5JWJJjfIj5L2biS29rK7j6x4OjJNKSEu3a+91xG
         PB8iTZH+n0X+eXAE2SINUxP8p3RBMi7LelNAO994LYICVf+tJC+LPLOjtzPsZPARpkBu
         1XG78ZvZ8/jJufXkw6/seeh7fHRYPE7hGmqdrjsxO6pLvx1cRfiLDg669Xk2NIT/caUv
         MMVb7NExWBwfbGDmotX9GfF6tH+JMhzgycGNqe4j2AHbB7FGuvjLv4EpFlo8DOHgYP7c
         TkSu2Tbuc16/lwoEqtMHzX47KK5tdyQYw9VQIAZK/+P2CmRObtdGLnzejJQiaA1yw8b3
         u4pQ==
X-Gm-Message-State: AOAM5328LnetOTb/M0E4L/J4nndDRMyCowLGa9cNRGuEoCI7XAUWyAU+
        Q4zuEYzslWsPlae/GlvdQ89/bQ==
X-Google-Smtp-Source: ABdhPJzQGgrqixo3QFF6AfPtOI+f4x2VAUNV1Tqd1tDr+6GP6CAmTELSFc9nOUUfsic61qkMpmSwbA==
X-Received: by 2002:a02:b386:: with SMTP id p6mr5676836jan.6.1642206277345;
        Fri, 14 Jan 2022 16:24:37 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g20sm6104203iov.35.2022.01.14.16.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 16:24:36 -0800 (PST)
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <234fe9a0-e54a-61d6-f3e4-a9ac171279fe@linuxfoundation.org>
Date:   Fri, 14 Jan 2022 17:24:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 1:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
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


