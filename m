Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820D83A0A60
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhFIC7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:59:30 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:37555 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbhFIC73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:59:29 -0400
Received: by mail-ot1-f49.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so22476158otp.4
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ai/DFSSo6UQg2GJJ+mhoa+CKX48y8PzGUVihOLbaeVQ=;
        b=aspIUyaHw4dbNAnbOxFTf2trXNK68yj1KFJEgcFvt+EvPtfYUC1oyv+0rOd7LjMFim
         OBWy0I3WnQAqSdhftXcGpadYrOil5WCllMvIaZZxPMmcVBek4bVmqa6Gw2R/kSkq7e5F
         Ah31gGaPWElbg/OfdgWZWMa4Bd1qeLlHrNGwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ai/DFSSo6UQg2GJJ+mhoa+CKX48y8PzGUVihOLbaeVQ=;
        b=pr72MNbsGCCURVjfNtEaABBdMH/o+2iq7IRvLZEWUmN/J0lhs6B395P2d1AvbiQsU3
         TKF1s4VsH47TyTKSAED++lLpk+gJy8UwOycfmAvE5dHsBno4MuViNytFl5R7c73A+lwU
         5B+3PWe/DslH2fvyqiqDEikNEx5yx8+sJkBOBU/awkrMDav1RGCMvHjdg7ssjPuviHlC
         HvTn/7jKOgl7D8xcgF7phS93mHbxmnNQo33TGahuaGxWCeF5uAu7vtTFlG1De4vorhRD
         8qlJdLTgh/kFxUAlSJFqnd0fL3XZkjbXBmSO/dLun7vmWA6xrAOQZVivy0xc7eNMXmCg
         9/rg==
X-Gm-Message-State: AOAM533E8pZM2JnE/l9FL/jekMFzvmDw+ZiyTIOokc/KihY9zW3fI0hW
        JVNoc1/C/9CLywOD4u+5iOqpug==
X-Google-Smtp-Source: ABdhPJyJqMq+IQEompYqr4Z/KpmZIRKifbGQnjp9bsIVJISSzDQGEzINrxpWWna2N+4dvSlsPHnewA==
X-Received: by 2002:a9d:8a7:: with SMTP id 36mr20722222otf.287.1623207384125;
        Tue, 08 Jun 2021 19:56:24 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a74sm1173237oib.21.2021.06.08.19.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:56:23 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/23] 4.4.272-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210608175926.524658689@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e860bb90-6fa1-49c8-7ca8-4dd5e40ac4fa@linuxfoundation.org>
Date:   Tue, 8 Jun 2021 20:56:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.272 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.272-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
