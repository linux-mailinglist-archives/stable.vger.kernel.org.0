Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA2944DBEC
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 20:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhKKTIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 14:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKKTID (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 14:08:03 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5B0C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:05:13 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id r26so13333571oiw.5
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sHiKyPgSNuxtmex5u0KUVb7fFlNPXHPqvsOM+r5AGf4=;
        b=PDPTyEcr+jYb3X8b4S6+sAhBowBEOOYbm7sjGKFKGa686P48JY9tPuFwxia7ybCy4R
         shE/dkVqBbR7XKqUXFgoH/QPaNN4PKHJwkmLcW1XgjoPf3OIDUxv+7+uFoxJzuq32OUv
         Lh7LgQiD8M9QO3ApSKMvzJYMIk1uKAY524h+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sHiKyPgSNuxtmex5u0KUVb7fFlNPXHPqvsOM+r5AGf4=;
        b=uCSjbKsg4Z9w+QZETGFWBcwsqR9KNEcSgWxz6RGIkexU0FgacbnAcs22mPsJYf/S3b
         uBOb9p6QVdH/BZ8odxa4doYfL8ceH8fNrneF/FWBHUzc59KbAOJ8qnwyP02c0dYJne4E
         /09Z1YlnNVIgWRKOs0COT2+jS+03yzFEbSSXy9kpWjwLgEMmRe5+1EqW4nU5Fsbov94D
         a5n4TuE5f5omzj4XR3mdFMesJX4JIfcjMbl7rpRmPWrL+NQUl4me6HyCaEDQ5KWHseUP
         VPkMDPaYX3ClaYirGh5WKRAAcByWCauumA6nuWYNXU7j445oNPOC8m/IxgZ/KobZYKRA
         Luxw==
X-Gm-Message-State: AOAM533nOedjUnpdBohhts/YxLQNDBLxFdWyeJWto1NHXOqNcuRQpV8K
        cGcVyEFaMoW2a6Gtlkk/h7rys1UzEm7Ccg==
X-Google-Smtp-Source: ABdhPJzlXbPXTodm8cnOd3BC/lFOwHX/u2S3yx6cSuuJ/n4rltVEEpGneOcXYZlAaREUn1Xc5WgpYg==
X-Received: by 2002:a54:418a:: with SMTP id 10mr8070795oiy.13.1636657513002;
        Thu, 11 Nov 2021 11:05:13 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q63sm815159oia.55.2021.11.11.11.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 11:05:12 -0800 (PST)
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182002.206203228@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0ff7cf90-72b8-a8d4-d2d2-4f070a761a88@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 12:05:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.159-rc1.gz
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
