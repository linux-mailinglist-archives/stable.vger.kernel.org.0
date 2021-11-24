Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010BD45C898
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhKXPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKXPa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:30:57 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4B6C061574;
        Wed, 24 Nov 2021 07:27:47 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id n12so8287162lfe.1;
        Wed, 24 Nov 2021 07:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gdIiCbj4hBmhJr4yAIpZpRe5Af6qcRX9G1t9suKr/pc=;
        b=Pa1k5XL9OLP4z0q6Tc5VlYAfWivV2lZRJkDGRHu4xmr0Dupv4V3ThRqEjDHpXj0/kt
         vcWaJ8k6sFSdem2PXCNHYW3bwtaU+tVB2AXcLuiYZtRwCLgp1kusXxircKUdGNXdnDVR
         3dyvvKUiOvz/wGH9+0W2ny7bOzUDlbCZKgdQ5JD3nOMMlGBU0AUU33CEdKWOpyxhO+aX
         BJrW+o/VBBwLC6j+ub/W+JMixYmBJuArSv/+MDPZzP62GrCuuOYyGScET4Qe45DbmlFF
         fOe1Lh40gAampq0qvdem8qR8ENkUyfv00DV5jVKsKoWNcG4DTYXmDbMRzapbDMp9R14I
         r9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gdIiCbj4hBmhJr4yAIpZpRe5Af6qcRX9G1t9suKr/pc=;
        b=5cNzPNvYDoRVYh7cCgZfUgzVxP2pC7/J9Eg7zAGemwZEBpvkuZAZ0bDqeMG9ilZ0wP
         IFJ2YysNcDHwMebWvTx7GqswvDX3rySZxE3Cp/rXhp28kCFxyn2J7O1Pz6YGm7R261O0
         6mu465mra4Kf63lJ4Kc0DfOwWyuDvCoiqG9q2CCfyzVHZuq/jlv38qxrM/XAI4lCTLFz
         xF8JYGCLYM5LNy+m6O8dfwoTeZhFU3alIOFUGnC/YrcBDCk53STjZDrNHb+H4O0lEBBp
         LdMj76cAdDrD2GlibuVh8gLk/4lxxMptdtvTc8vxv2oCT0ag+zvjV63ixRfTncnFMKEQ
         NXvg==
X-Gm-Message-State: AOAM532TbD/hsdqdw62uds26hTdH557IFI7dyeT3Kl2fCkJnWQOpqUJk
        9g7k9KEJ1u/2nDu5iGH9l1U=
X-Google-Smtp-Source: ABdhPJxMQfR9uOSWQ1+iKTRJa9ncFlZS2H9W5aKBpN900yklN5bfT8sfmQ1la6Bq1XfRWH002w3ygg==
X-Received: by 2002:a05:6512:3c9a:: with SMTP id h26mr15548608lfv.155.1637767665498;
        Wed, 24 Nov 2021 07:27:45 -0800 (PST)
Received: from [192.168.2.145] (94-29-48-99.dynamic.spd-mgts.ru. [94.29.48.99])
        by smtp.googlemail.com with ESMTPSA id t4sm13416lfe.220.2021.11.24.07.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 07:27:44 -0800 (PST)
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thierry Reding <treding@nvidia.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <CA+G9fYsmeKPRicvsjwT3gfQurf-k=15vm+kNCCKfOOoyAQE1oQ@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <14fbe436-7bd0-5310-6e06-1c3b006b7916@gmail.com>
Date:   Wed, 24 Nov 2021 18:27:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsmeKPRicvsjwT3gfQurf-k=15vm+kNCCKfOOoyAQE1oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

24.11.2021 18:16, Naresh Kamboju пишет:
> On Wed, 24 Nov 2021 at 18:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.10.82 release.
>> There are 154 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regression found on arm gcc-11 builds
> As I have already reported,
> https://lore.kernel.org/stable/CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com/
> 
> drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> drivers/cpuidle/cpuidle-tegra.c:349:38: error:
> 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
> you mean 'TEGRA_SUSPEND_NONE'?
>   349 |  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~~
>       |                                      TEGRA_SUSPEND_NONE
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Due to the following patch,
> 
> cpuidle: tegra: Check whether PMC is ready
> [ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]

Hi Greg and all,

Greg, could you please drop this patch from the stable trees? It
shouldn't be backported since the actual offending patch which causes
the "fixed" problem is still pending to be merged. I assumed that all
patches would be merged much earlier when was typing the commit message,
but only a part of patches were merged yet. Sorry for noticing this so late.
