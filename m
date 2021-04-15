Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703A93615A2
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhDOWoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbhDOWoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:44:38 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66FBC061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:44:14 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id 6so21536563ilt.9
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bM0GJUz7EeI8fLWH+TtYrvFRkhckSsQfBWTt1TPM9Ww=;
        b=ZoQ1y99csx19bj16W78ajXkJtj1E3q/iL2vB7upe79Bh4hAYiunqORgZtkmQJhvCpE
         4Xb0ycaxU0VXXiW/fzq+d1lebucf4zesvWwFj5PXYyT69uMPtL2rn5bKtPhOUmXLbiMn
         hi0pRkZc69QMnE+9UFujF/fuR7uhUTliTf964=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bM0GJUz7EeI8fLWH+TtYrvFRkhckSsQfBWTt1TPM9Ww=;
        b=jcE7ezcJM5pABGpFE/qvRezFQDMrk7rhgkNoZGMe+Mb67IuT5RyaNpaSvyGVA6XHfQ
         oxmjR809jU3TpKFI3AXOiJPYXISSrmGlMANamRg+k7xkxYSR9N5n2n/oxhc6rgW7NpQM
         WkHfq3RzjseMxIW+q8oBLBRXafs1qSsWyURJJTUNIq1SDcgiy5EKEA5tJdBufHUKD30w
         GenQYdTyBmg+ENktiiKuA5yMMsxakgmcuduKYIvcu4YsCmAB6ZdDaKZAEZebr3DmsSb1
         u/8PqCsE1tsc12SmM+IMZPN9WXXHjJAFoL5WfhOQ3Mpx4mhsd1Vc/nAEtyGMtC8sXbK8
         J+Hg==
X-Gm-Message-State: AOAM533GfY1TUEWnpGArxAP+2LY+kf58dOUr2zu/2958d6vTANzn3zMs
        AnFYYK8oEdBHGSYMFyweMDoIhw==
X-Google-Smtp-Source: ABdhPJzpbowzjekEbQbbwYmbOYuD+HKOOryCp0HjLLnqMsAJ6uzE8cLMhNUolQUl8BA042SL+M0F7Q==
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr4644659ili.157.1618526654238;
        Thu, 15 Apr 2021 15:44:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l5sm1841133ils.61.2021.04.15.15.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:44:13 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/68] 4.14.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8e5c3d2b-63b2-be3f-6368-4e163c28b539@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:44:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.231 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
