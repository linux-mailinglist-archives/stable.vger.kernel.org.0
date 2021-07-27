Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9583D6B1C
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhGZXz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhGZXz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 19:55:56 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDDCC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:36:23 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id a5-20020a05683012c5b029036edcf8f9a6so11847019otq.3
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lVGVxllSNuzOKXJcAPm7NjeofRovuHgcN20+tIeGpfA=;
        b=ZOmdhlnyfMrG7BoCdWiaPBn8GrtqQ4INRH6nA3mQxJaToxQ8U+rAdrG/z6a1fLbIY4
         JFgkkcbp2MnB/LVcBp16VTg44zA6P/W8J4PtnGXPNeA+tvGyNbnH1e+L+Z/7y3SjkE6h
         VjHJtwKOHRFocsECeOeo48hNL2kwIiX6ed1Eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lVGVxllSNuzOKXJcAPm7NjeofRovuHgcN20+tIeGpfA=;
        b=QoOShK3/fehPaDlD9ddp2nC30ghMn23LgMuem3nDS4uCLNiPmKos3ogjedsb2bFj2H
         uoSf66MhLQFm+u+WmFC0wmIzgkrWsIgMouxXSzrI2O1Z/9fTEXpD6HIUuXNEwCZRPMtw
         OuzMx3lOpmphDKGpRI3WJoGXXCablYeicgUaNT5yeyyV5Wdchq71PzANfoO5OoKtKjoO
         B0oDW356xLNYcc9KzXCMVpRfu8/uxrfmGR487sDC0lqJXqjSzkPdXNEO1INTmCNIn69Y
         Lt6ceu3KVvgjak/GDb8lEAOcVGMXRihYPqGNNCS1fFKhTHqoTb7iye0pICI/bLZDdqON
         rFDQ==
X-Gm-Message-State: AOAM530LWihoQD8tL5tUFeqDyBzfqMfqTMzJSKDbb52QfC6FI1VpMjAd
        q+mH1j7t1Q9JcDsPyV4XrNPUJg==
X-Google-Smtp-Source: ABdhPJw1TdRisFk8xkp4rx/wWkYtcHwVByiEr0fYGM/HAJf7fcfedpurvuUGo6WEZ5EdaTYvhiRSoA==
X-Received: by 2002:a05:6830:2385:: with SMTP id l5mr13708205ots.227.1627346182558;
        Mon, 26 Jul 2021 17:36:22 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k7sm281558otn.60.2021.07.26.17.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:36:22 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/120] 4.19.199-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <20b5575d-d5cf-d915-9a47-40da892b6a72@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 18:36:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 9:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

