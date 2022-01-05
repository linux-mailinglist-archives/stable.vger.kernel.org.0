Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378AD484C67
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 03:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiAECSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 21:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiAECSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 21:18:45 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A466BC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 18:18:45 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id j6so29823875ila.4
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 18:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wlNPtxZcsOPibw1mUl0kqsfX9asoOi5IsIWUpPfIolY=;
        b=Fkf0rFsjqpXPJYMOeqsmeb27up2eWUNGQMMVwRhNG+QKZ7LDCwhPYWo5u1WZ7TCBnz
         JjIkv5QuFtmnRAiF/FRb4RyG0L2ala2+UzS+pbotjz7kJZ/jw2i26rGBvtxKNs6AWrEz
         bt5Lpcy1HAeZCAk8xpvLdI093eVpKuBI6TRQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wlNPtxZcsOPibw1mUl0kqsfX9asoOi5IsIWUpPfIolY=;
        b=nLQvN7gktVmltbm3bK1qwX15+Q8pAoKg/ZDsTZ8S/fwrE3+P7DEu1L/Vp1jpOLicN7
         Twsjxf68+9muM6UWnRfVdu8eIoIUWsZvE87ic9b3zEL0afjZb4Jxs4iZJTSINOb6alyS
         iE6MTCOWIB2MT3LuYXnKX6GHMDCoDLmFL3eEP3j+jwu3m8Z9syiAN+Qv/dVuRUzQ07B+
         X1tluES0/uhbJxX6PuScmxBxTnFmwTel46+OTP8zW0c1sQqmCaeFYLcC9S1TdTI1of6/
         5PcbECVp1Xqw3+PjE/RyIUiqWTl2t5M9Jpi68AjosUe++Q4sYhk+IuWuRVrqtuOdrqmr
         CuPQ==
X-Gm-Message-State: AOAM531Tc1d6ZIaNaS8mBjTBsFZmFToYjZGhXsfzaeCRGCrk66/FKuWL
        N+JeKa3G+vcF4EVWecnqFVSmEA==
X-Google-Smtp-Source: ABdhPJxEOxjjl/KY7L2D1YreYXQMDJapAvnAt/lZE2mffx+AYiFgozZAvazMjzMEMH/bIGZTin4sIQ==
X-Received: by 2002:a92:dc8c:: with SMTP id c12mr22585534iln.43.1641349125102;
        Tue, 04 Jan 2022 18:18:45 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k17sm23423695ili.30.2022.01.04.18.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 18:18:44 -0800 (PST)
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <94904b3d-9364-0c9f-b21c-7537b68f879c@linuxfoundation.org>
Date:   Tue, 4 Jan 2022 19:18:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/22 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

