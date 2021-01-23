Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416BF3011A1
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 01:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbhAWAYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 19:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAWAYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 19:24:49 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F29C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:03 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x21so14833419iog.10
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJV7GoX9NeC9Cf+uGRyB54/V6KkpqqSntpSBmaHYsEE=;
        b=ZXJNjzN/Di9kdGwcthHiDgZlA0lhjhc9faD5BzTjtjHcStIwmHt8S6CCe1iLcPmRUq
         S06yWhgpdYAZvpVsjNG2AVjErbWoB52d16c4hDFjyl7qWPanGxpri5SDFkjY+l9CxNGv
         D9f/PjSkgp7wYrLcqKRvLFA10shAo1Y/+lpnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJV7GoX9NeC9Cf+uGRyB54/V6KkpqqSntpSBmaHYsEE=;
        b=CkCduL0Go6mAxORq796/25Gl4kmmJCo5/TgjzT/UWvtj4vNuSzLR9b43pvkq2WCDTk
         Zetihk3AUxe4YorOFAfctYTGu8YmmguaQobipoBjhh+McZpOluYRcAQyJcMkzedWph+q
         J8NXe5cPx7EbLzUvrDvIWbFUQhm6d5fX8O35mro66RkcmrEDzANAW4YO5AlfIXIyzy9N
         fNtS46KXf8xFMH4SvSbix2NS/7QJpQhw7a5keFT+pRJoijfCErAmcpCk5PmtelQIsBMT
         uQ62Twp/ur2BYJrLK6ANmPprNyBtPPBxS3TrdIh6J/CmjIjoCxNdBjsI1GN75mWra6y6
         iobw==
X-Gm-Message-State: AOAM530D2IhHIuBceBf5rbpH5BWWaMs4V8BnJU1O+nONnGogB26ffY2T
        rWFeJ2PSyFeKUh4Wl/x3O8IUGw==
X-Google-Smtp-Source: ABdhPJyg8Lk3GiSWe4uw5lVnE56IFdtnAoxaVzebSRwP6oX9Cm5/GyR/a8qvyLjJyq5Vh5SEYzumFQ==
X-Received: by 2002:a05:6638:b12:: with SMTP id a18mr2254892jab.114.1611361443140;
        Fri, 22 Jan 2021 16:24:03 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j1sm4363380ilu.78.2021.01.22.16.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 16:24:02 -0800 (PST)
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5ce91f74-86d0-778c-d884-769cf4d7e3b2@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 17:24:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.10 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.10-rc1.gz
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

thanks,
-- Shuah
