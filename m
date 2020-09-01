Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9210F25A15F
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIAWWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgIAWWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 18:22:11 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617DBC061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 15:22:11 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id j21so2570613oii.10
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 15:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpZ/pqn/gZKDamwMZKx9sZztrXuD+zfU6JEPUgfZM7M=;
        b=FvVnYaPj7/wShDJ26GhbuXrYzH3SxX96TS7Vcq9mq5lSSMdZ9nWBy0o4o+crv9vnWY
         K09OPOVsVZrljuGivlpZceMj/ctiERJpvxYGtvJn9DtohgnjTTzPFJWAG3bVLX1PbKmN
         lobaHKQKGZqueIdaXR/xIrmbw9s7qI+JNgojg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpZ/pqn/gZKDamwMZKx9sZztrXuD+zfU6JEPUgfZM7M=;
        b=Ad7hqsoDqRxl7MV1vZhZeBfroQOTJxsT10ozeaG/tslotupvOHh+LZ06SLXfjtkOD7
         BrswssLOpQW99Ox8fNntFiwsACPDWRkQFkyH77gHMSqUS7HqNS8fIyJkPEUM1hHX4c8a
         ROW9Ek9kFDwoVw8jxLpM3FaSWc/6psKhs7mUroEpGYxyPo7/BNZRtjf0/3SY8FAZKn4M
         KLiaOw9lCTL9XSuHgVEb69OvbPj4bcfRFdIOO6+Skj5ZTk1q8au9tgEhzjF+hVuZQSoS
         dEh9yqKeT1SE2ADTp9rgUmysqw/hXzfrgoIxEByVJFc1tQuwHYaDvvDUBlxGp0u7M/gW
         k07Q==
X-Gm-Message-State: AOAM533Akg5PI5j19RyuFNEKvdeYiv+d7/W4TH6aKNRzYgej+HRuQHNb
        UXxEtqH2pcXY/LqUtII2jOJBRQ==
X-Google-Smtp-Source: ABdhPJyaeSvW23yiAYE3kUusSuO/5hOP4D/KXP8p9Buo+tol+IhqxU4bxRMllJ0XZrpY5PrypG3eWg==
X-Received: by 2002:aca:3c43:: with SMTP id j64mr196648oia.178.1598998930171;
        Tue, 01 Sep 2020 15:22:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w12sm265707oow.22.2020.09.01.15.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:22:09 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/125] 4.19.143-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <96cd2e66-0ede-01a0-d323-914f591c3675@linuxfoundation.org>
Date:   Tue, 1 Sep 2020 16:22:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/20 9:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.143 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.143-rc1.gz
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

