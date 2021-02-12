Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BE431A27A
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 17:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhBLQSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 11:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhBLQR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 11:17:58 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56595C061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 08:17:15 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id e24so9848041ioc.1
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 08:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=caRDYdH8hzxAnk3La5B4p3k+zmOXXpmwnnS/me/9Xo4=;
        b=bHvBvO9nMVOVuHh/hK45iSGA8moDu+Yn0NKWSn6SjpCtFo246Tv3GTu/o3uDDklqd9
         Solpkq/cYY+LixmxZtv2LcOQluvpbeEJlbDOoRSWQAmBX7hPGa0PZDGA0gmz4wEvU4SQ
         SaUdlvPN/0YIX9KyJ0v7wL3H65I+5+BNx+udU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=caRDYdH8hzxAnk3La5B4p3k+zmOXXpmwnnS/me/9Xo4=;
        b=Jh9gNd+D/KgJF2PDGnL4zC/ITXtccXr6kqP0+KS95MlOjd+cY0gCvuxW0TSBMM/OxT
         xP+jVUQV5fjxrCxFEXYkO18hg2DWexSWJPm6WsfE1678ECuYOW+mPwCceuz3LAMgLRbL
         29KzGQoo14OJJrgtpsZQvbvjHzD3+wPDaGNyQPp5jeKCEVJaBqOsFBl8QW2oAtBUp+QQ
         vff8XIkfZfxPs4zOVVLYSixx5bm/nj8six4JXfaUFZvYeXQwWlYmQU6CMBQGE3HGXsST
         AlUUK0P8o6lb8AvrtAwdhNnE9vKmt+nBwFroZpOhHOQs1nNHeHaMniYRog7ZZR57je/M
         kJIA==
X-Gm-Message-State: AOAM530BOWYVsP9C4Q0cAmspZ3jmlbPlJylpEkSByBVA1xWfH5rAc2yT
        dDblT4OZL+E2F4bGyreSwhnvHsH/pVRvtQ==
X-Google-Smtp-Source: ABdhPJz8znk/YpAOPRKoB5bA+N9PP2fT8/r+kkUrLuxrlDEWBnpY8v5UH1FKeI9KAP5RgOIQOG2cVA==
X-Received: by 2002:a02:cba5:: with SMTP id v5mr3390739jap.72.1613146634787;
        Fri, 12 Feb 2021 08:17:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m4sm4619764ilc.53.2021.02.12.08.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 08:17:14 -0800 (PST)
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0825d0d8-0183-9653-dd74-d5921e360bb7@linuxfoundation.org>
Date:   Fri, 12 Feb 2021 09:17:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/21 8:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.16 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Note: gdm doesn't start and no response to keyboard and mouse.

I can ssh in and use the system. I am going debug and update you.
5.4.98-rc1 and 4.9.176-rc1 are fine and no such issues.

thanks,
-- Shuah

