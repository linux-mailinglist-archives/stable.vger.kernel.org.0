Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4579413644
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhIUPfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbhIUPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:35:36 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8489CC061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:34:07 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id b15so23134755ils.10
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3S1E6nCsz69il0v5J7SY8NxiB6mJxxX6ylOe1IstdgU=;
        b=JJaqbndlF4mVs9rY7PoJs1D3R70aYBY5PXB4tHsBxz89wI9YOhOFn6GePCw84tMglc
         qCHBHOd5BduSMWapWwQXczu0eQ7HSXB7Mo8LxmRrzatrxtvmPotLAeIEwysCNMbLottL
         ex3gNsNvQRQefhvUVa2mNfOZDf3nD3GSrX/dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3S1E6nCsz69il0v5J7SY8NxiB6mJxxX6ylOe1IstdgU=;
        b=mef4kiYg6OIj1gU5Gj3Lx47thxRjFhmZkvmAA+CddEjkzA1eksh5Uqv1yrFE0WLg9C
         HyPDLM7AlVpqySBX7MrLWBvPKAoyqKebPQo/8JGi4xI/zLTmhuFwGYzEfI2E4+dEIs9+
         iOnUjcvKiHjTCPGp7i/Q2l7cgFuRTCOSuScdNQ9aaO/v9PaaZB9NBpwWRetH6v7uq3KG
         fYCUzCN5IMJMKzTn3Wd0CdZilH34qKUdnk+4Dvf1AJCIavbPNPNSgZqevISNjicOg1sh
         BbeDXttR1xHPHK/TDLwmplSzpq9iW+gVVcI3hsd5orjipu/2ABtWnXAMwvfcqSnCTDKC
         ehJQ==
X-Gm-Message-State: AOAM530s+K2U2/tNJ+Q6rPsSSZhKju5D53NoDkiUH994azo4CbiqSeYp
        BI9J3n/DTJ2kfwZvbQT6FQL07Q==
X-Google-Smtp-Source: ABdhPJwMfHx45MrLd2FDrnapcY9CvwFodBj3C6Yrs/p4rGHI9qqlswzCzUO4CdHAHVMLPHFc7kbyzQ==
X-Received: by 2002:a92:ca06:: with SMTP id j6mr4768480ils.243.1632238446929;
        Tue, 21 Sep 2021 08:34:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s6sm10020427iow.1.2021.09.21.08.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:34:06 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <466c8d22-1856-fe69-1915-cd93e7dfcdf6@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 09:34:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.207-rc1.gz
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
