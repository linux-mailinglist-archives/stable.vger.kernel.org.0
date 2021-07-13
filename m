Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5A3C6882
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 04:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhGMCaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 22:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbhGMCaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 22:30:03 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB9AC0613E9
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 19:27:14 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k11so25250687ioa.5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 19:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AW/0GNITZsaRFqj2/Dl194ei172M0FvRnwMWPjsrgZc=;
        b=PMrcJLB2oFTLbiloA/YPSDBsldKIUwfc2RJvH30zucUYvInRgrcX94x7wNG5UbHqjc
         FIFhIQ8PVRyuYLZoz+5N1NUcsXcHg0BNWDs0rDUkVQHQv+IX+bYuZ0KmHvb7oHr6AXtx
         HC2Y7cDt8+VYYoFiUyLxecXIYVOqMcyPzoJUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AW/0GNITZsaRFqj2/Dl194ei172M0FvRnwMWPjsrgZc=;
        b=RuIZ+AwWxhmfUQnsudcLlAddTxtZgnYeCDbEb9jsk2UBIZ+d8ywsNH0e61XH7r0iyL
         5uAyhZ//aOxKE62ewfp+kkNgRBLZ8FQgTLPvKr9EkXCNkXDddoZW0nC2amCZ2pAKBfvj
         vQDYcZ+UirFTgCaGhpNFWYM+EZSdY+XIvpj4h5MvVcP0UCzgW0liAxe5r5HkJPqko/tM
         kbvqACIO0zoQ+yf32N5qULLDqgIeUFDSKR00ImbHeK5IpFGf4tME2PTYz+mtE9Yw4TdJ
         9Dl6Z2bbPdj4Iscjjz6JsJaX4F4Dj4wJx3nY2S+Oy939SFfSSTHH4vyG+Y+sYrQJBQrQ
         LumQ==
X-Gm-Message-State: AOAM530ZTH0AMv0pJr3MsUoPteMRE+RULl5yLEmj/JdrS2xFFhCXADVL
        vfNQdWsKYLipFC8ea4RpQ8DMAQ==
X-Google-Smtp-Source: ABdhPJwi7YYCJBjyfLgctuijjIpfAngXLPcF3PWzZUysXqiCHMbxRyxCh+ItcQ7Tia4TCzVEHUheqg==
X-Received: by 2002:a6b:f81a:: with SMTP id o26mr1497012ioh.68.1626143233900;
        Mon, 12 Jul 2021 19:27:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h12sm9289894ilj.6.2021.07.12.19.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:27:13 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e854a220-a348-14b1-1b5d-3a69e7d84af2@linuxfoundation.org>
Date:   Mon, 12 Jul 2021 20:27:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/21 12:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
