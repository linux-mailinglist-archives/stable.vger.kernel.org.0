Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B213402F68
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 22:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243501AbhIGUIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242658AbhIGUIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 16:08:37 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB89CC061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 13:07:30 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a15so126052iot.2
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 13:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5iHx13QiJ9FmYs9Km/Jd+rwidFqCEp0Wg4GaD8IYr1Q=;
        b=BUrR2RYiBH4EYSIU1Gy1/LgpE17M1MdA3xpKlkESoPYK7tnyW/ZDZ83uvlbHBvh5tj
         228/J+Ta7SZwsTc4NXpRvkFpsBv3zLlbiIbj7vMevM+sWdOLiHBPovpZMqGs1qUYVbJ/
         0W3BcQ91ynfcVGl9MJGKQd4r7ZucfcUhsp2a0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5iHx13QiJ9FmYs9Km/Jd+rwidFqCEp0Wg4GaD8IYr1Q=;
        b=RpqNY9axPJL+Mb+vh0y6Bu6vN8kpiaka5mWMqO3WHKMZNv8ufNtictOiwwswIhJeEW
         OK2DEXco15y3qRklluH6QpPBZN/8G9h/Cr5rXfRUQyfZEj/A5GiHv3dC6EAKdlIofLUo
         JzbYjdV1NT4PhTCZn213CuY464TnIxIiTvRN+NJYglDKRAoSDQSlvi5Ex+xpnNbVRmI1
         M24c75+dIRHb5AP3x450r/2ERDhG4L841L1VutCqyil78Hg8GJZTYX40c5CBcF+pFlij
         JBSF/Sv3QNNNdCqGvLtd1nBFccBS3es4xWI96ozwwCGnWMPFKojAiffxpORFOAek3PvW
         Q9XQ==
X-Gm-Message-State: AOAM5301KulpsaJVfMTNrNG+dzXSPM1yYk7aCOKKcHt25g/KjR/1zCjt
        ccWGSNfMyDU5VOozYSSdkQrZUg==
X-Google-Smtp-Source: ABdhPJylUA2Vxs76U7jRVgrmB+og7YtoF8ojFZCEfuvH/O826WYjijBxrY8CJYRFg507rNE2/YofPg==
X-Received: by 2002:a02:7710:: with SMTP id g16mr75515jac.148.1631045250191;
        Tue, 07 Sep 2021 13:07:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b19sm41660ile.88.2021.09.07.13.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 13:07:29 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b28f973d-a5d0-7771-bff8-9de130122062@linuxfoundation.org>
Date:   Tue, 7 Sep 2021 14:07:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
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
