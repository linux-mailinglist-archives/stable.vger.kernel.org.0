Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0863C3A0C
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 05:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhGKECA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 00:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhGKECA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 00:02:00 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908F8C0613DD;
        Sat, 10 Jul 2021 20:59:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m83so5176643pfd.0;
        Sat, 10 Jul 2021 20:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X/EQQKppqgbfsqBSJj0WKfpFQ+bVsBg3tkp3u97wDog=;
        b=JEi3mk3fkKPY0yXYjN6P2K1cEyUSBlgGqN816ua6/pMHMAw5BoXCM4UtdUu6wYO1HY
         cJpAVOxQNR+8xKKm+BHSIsSEdkxH7BMHfCUTZ62ZwDEM+M/iNd/7cQ2SQRO9tuE24sLb
         +ClGSTm7reIkA3HzYOK7tZaaqAFe8Nmu98Lv8gSyh2jmspElvL2LOl2G3W2ubCqy8YHW
         bZ3wdL+0v5blPpPZqBCD544j1xI6Bn2AN/HnDR8uIeRDkjSGQnn6SVJ0VI7aJW1LkMY9
         CfCPveLcykjARNpQ2I9xoYteYWsGuXZGM0let73hCCcSJtumgd7yQYx9Cc5uAi13PHM1
         7mkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/EQQKppqgbfsqBSJj0WKfpFQ+bVsBg3tkp3u97wDog=;
        b=dTYeaJKAoyBREdc+iGQnkzhAlVsO8gnpKAUkNJPgl0Z3Pj0QkGRXdk+4pWGQl3s9Id
         hUSEqCNSz8AheAx9iLA34qV72FEncIJ4l2ImVgKjQ40nYLtDRqpG5pg9gL1BOKdkgZis
         Dm5JJ2qPQu6QQzBkaChmbr3zmRH8aDCuHnnqE5I1HpYLz8CtAdHrHaXmRcK82mXxFPZJ
         yxQmdz/x5fW+FhtpVx9dBoMV4J4/PQjO4IJa4hNfI7K5FeL7PTqug/1Od69O3/1gC4Ch
         eZSXNW+aFiOlRT/dlRsClz30kHJy77t6KTOPwXgiWeNhnzFBcycvsehdbiJUFbD8qW6i
         54uA==
X-Gm-Message-State: AOAM5316P7sI0n7nzdOmzXYd50X7xNq2JxghcDm+gwtmWqSNBZG88IQw
        lMw/fubW/Fqiv68ZpbOndPHx4YRBAsc=
X-Google-Smtp-Source: ABdhPJwn2j4GpAnimor5ge0YM1rgVHUen9omcrgHFm5rSmFAVyrXsW2cNs+w3CtoeiHqjWo0VMPD6g==
X-Received: by 2002:a63:ef12:: with SMTP id u18mr46191843pgh.331.1625975952500;
        Sat, 10 Jul 2021 20:59:12 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x7sm3985879pfc.96.2021.07.10.20.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jul 2021 20:59:11 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210709131542.410636747@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <973b8925-de61-873a-3e9b-9ec59e5ca2e1@gmail.com>
Date:   Sat, 10 Jul 2021 20:58:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 6:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
