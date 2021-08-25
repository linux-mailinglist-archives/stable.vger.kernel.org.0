Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4F33F7EB2
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 00:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhHYWho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 18:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhHYWhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 18:37:43 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A714BC061757
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:36:57 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id m11-20020a056820034b00b0028bb60b551fso284705ooe.5
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M2aZX3TC9GGdOKjZL/h6zHfZIU58Dq7i+vHq70pNozk=;
        b=Qm9pn6insLZfdz+ObgYWhjw/lPlg+FY/1Y6mE/clQ0N8OS5wtJ9rGNI9b2Ti3TWrC+
         BIi/ZdlTQ3nrViJ+DXUqML8HX2GybGw1HoIdYo8vQOPgwokJT4Hy7Rnte63xq7Ie1mAF
         HgJQ59MFTSW2NpMyRPwD1u5lmrvyfXooQTIZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M2aZX3TC9GGdOKjZL/h6zHfZIU58Dq7i+vHq70pNozk=;
        b=t1fPYvHIHiuomW4Mp6hDsfFllrpqyZbp5L0QHQ/IWG2j97zaXUUHZuhO6j1Vz1S/an
         ckYlJeFqDsRxvK8Gl6ABTPDevklm9I65d4Elu13C8Ev3tGEfZGGvE5W1NFHUxWzh4vMX
         2bnQ6VcnJqB1blXn9Yfo/3ucl04+XWXdmKkTTd7TCiIr9CLcdv0k8x8w47BYTKuLdrNU
         dSWpQNmcx0CHaXe7J8bLt1lLL51NhECWOnR4ghraOg7sqfRUtXCouqwbN1rXmthMWpz3
         xKblygiYwPdBoHtJfVZjEFT24xcCvMIl6sfy2ehcsfCxnqOq9H+d+LEpQ+pm/fgC9S6K
         oPNA==
X-Gm-Message-State: AOAM532VGP/jl+BloZ4w6T9pazpY+bs3XrYSn8eY3vvv1fvVzFhsn1KO
        vgwgIexl4pFgBZdOzVBvR18s6+XBsMMMjA==
X-Google-Smtp-Source: ABdhPJxAset5nbsfIWG2/zupplYBLZlEAnvX5W7ZCWIOZVG4ukgR9cNuf7YTOEI6ynBpPxpI/0UGsw==
X-Received: by 2002:a4a:a552:: with SMTP id s18mr506353oom.1.1629931017080;
        Wed, 25 Aug 2021 15:36:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b11sm237517ooi.0.2021.08.25.15.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 15:36:56 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/84] 4.19.205-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824170250.710392-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dbb944ad-268d-0b44-a163-4bd35547663b@linuxfoundation.org>
Date:   Wed, 25 Aug 2021 16:36:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/21 11:01 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.205 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:02:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.19.y&id2=v4.19.204
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
