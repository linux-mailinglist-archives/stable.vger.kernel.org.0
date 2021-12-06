Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B298246AB21
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344125AbhLFWBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245690AbhLFWBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:01:17 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088F9C0613F8
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:57:48 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z26so14657601iod.10
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AO2bWAy1B4Ooq61ctjEk4EKvJwCYL/K6i5aqLYRm81c=;
        b=UyNh5ZcBVcrEQHYw/Q7bo3T4Dd2yNnXxyce8yD+361N5NurZHyE1HbbFbuZcdvc1w/
         SMJxHoW+cFedLCjDXuMS7vniFuMFaYWX65RvdNPdt31sLUQsUkJrEsCnl+Waj8hErp24
         H+a/IvoLkbFG92OVsOJevPW4zpj2zTh7ewReA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AO2bWAy1B4Ooq61ctjEk4EKvJwCYL/K6i5aqLYRm81c=;
        b=GP6haMFLoQA3LxcztBrlJT1iVMgjB6JeS43d46SCUv74PjOrlOcVar1w0fHajKKipk
         PVPS+8YXrs6ltAZn3SLyLxBO8bh1hCar8LfXKVDaG4MstlGdeLcV43zL4J20hU8Fc1Lt
         i6rU2gDTVK7pxRg2mz3rS4PDRb8VIj1r6rtOpPb4CJfNe7JdOPskuPuDTG6Q0RQgPnq0
         F7iTHjE1YdNuC74/nDYpZIvGncEIc2VRv46C8ZccmEPkmVDb6zXJnKqLGnTuOnkWYpek
         L4yk9DJ93JPFwjwV0ucpOKRooW6e8BRSzoJs5t0RivMSpTggbqaKJYEebdHLpohC/Gqu
         pJhA==
X-Gm-Message-State: AOAM532JSA9h1d8omz7yBIDk08mhJvn8LOkzngQzCSxHN2B7sSfRhu+v
        haeLvds7NNRo1HkED285PT7kevpj53sKeA==
X-Google-Smtp-Source: ABdhPJwfnGvmnpWid22abU1KEVMKHBSNRFZ3PgWgH6pQASI2CxQKB4TAcG84iENdfslKolhsL4jFYQ==
X-Received: by 2002:a05:6602:493:: with SMTP id y19mr37111374iov.126.1638827867488;
        Mon, 06 Dec 2021 13:57:47 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h13sm7254753ilj.39.2021.12.06.13.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:57:47 -0800 (PST)
Subject: Re: [PATCH 4.9 00/62] 4.9.292-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <73dd283c-a975-0444-58c6-8f07eff572a9@linuxfoundation.org>
Date:   Mon, 6 Dec 2021 14:57:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 7:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.292 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.292-rc1.gz
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
