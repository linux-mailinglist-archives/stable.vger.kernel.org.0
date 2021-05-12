Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561FC37EF96
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhELXOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443380AbhELWSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 18:18:01 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48956C061357
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:13:59 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id p15so21506506iln.3
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9A8eCafiJPjQr8zBkAZz7V9G8/qtWqo/jCrI3/TxBLs=;
        b=AdRjyLy9pf7YQezEAk/LkNnn62CTG2JZVC69VlevY2dfLX1Chx99th9lBqjRMwxRMJ
         XGHPpEHBXTOYj1RGEKI59jGyfTfyqL82XZUkn9HsBItGJAlomYCLcuVY7Qp304/1IoX7
         Ei44z+0ZI/OCyFdGmp2+XZjxFDJZb+JkCU2pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9A8eCafiJPjQr8zBkAZz7V9G8/qtWqo/jCrI3/TxBLs=;
        b=hvFQ0RTnff7N0K4SGhQzT2FdhRdhcc1T1Ikl8aBErMcCtV3ubNPpCnUGrqYWP6LEOU
         XyL30m4vy8ZPu0UrW/9iGpWjzRXLJtoatj2p2Up1ZVO8+kW7muh6Rz+sOxIc/gdZF0V8
         eTKMTAZ0RTZ77v+qYAmqKOBNZwTv8hTmvGaEjXnXrccn/KMgDrkWXHfBTb+C3Z2Nihq5
         Ga5pafg49kD5rc7HaMa4XM78xig82dFvNc237iKrXnbTewameWRn8XyqjFIezTUVnEtH
         nRbkgne1nsCaC9Z/u93A64LHLLOStXAjCsnTBaRJVQREcFSn1t53U4bXXfgMcmLz7P40
         1njQ==
X-Gm-Message-State: AOAM533o+ceL4oCd2dwmuMEXpSc+Ywl4Jc9H//0nyiJV/kbKSYxzGQYT
        vHydVCzoZALJMLQWSkdZTSjMmQ==
X-Google-Smtp-Source: ABdhPJxQ2fBY469WmC7Bh1p6zfc/HRME2ie+OpXqhVg2tXVfN1jyEKc4Py0M7kv4g34DVPRAN/G1Fg==
X-Received: by 2002:a05:6e02:d41:: with SMTP id h1mr31992882ilj.0.1620857638803;
        Wed, 12 May 2021 15:13:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c13sm449549ioi.1.2021.05.12.15.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 15:13:58 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ac969ec2-a0fa-5b72-c026-67c42f2d78ab@linuxfoundation.org>
Date:   Wed, 12 May 2021 16:13:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/21 8:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
