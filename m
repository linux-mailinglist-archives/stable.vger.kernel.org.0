Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C36F3011A6
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 01:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhAWAZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 19:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbhAWAZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 19:25:37 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A199C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y19so14878478iov.2
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tHfFPQepXImtGnWIbBYCnaHP2s4s4Z1kO98E30rgKmA=;
        b=DZHT198wKn4KLlF9pn9JrU4U8FmUZtUQZvrDgaKkr48EBSQp/XlHd9c2mERKlrN8FI
         P5OdUa4HveeaMQlZELTDsAbwWg+aD7o99bmYH3fspjXD9+IAQrRnW9+c2RHEVXMzzcnC
         cs5oIB7tCytMfadpntoPBAXUz8YdVo1xboWBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tHfFPQepXImtGnWIbBYCnaHP2s4s4Z1kO98E30rgKmA=;
        b=PTNCsxNmGUGBXbfgPlQKZe4zbzlfRWV5t6GetjtfSaNP+mwWpH3514SdzK9mV7b5ft
         XcxHsEeUtmeCKFkN7AdWKuDCnGg8Rjmc2cQ3cfWvnkRhCdd145D/6rw680wkTl0AShPg
         17Nqpl040VQJkWglREZktlb6RKSn2LzyoTdxKwjiv9doMt0aDAoIHHGI8n1ot4K2cSJ8
         qDZBJPlNOjp4Eqs98u11n02TqXMZxMcxuT4OBekaGIC40ZZQSZIsBO5r8Ln83qQUh/g5
         //y/6XnRyJ7AHRoNbllQF9yosLlP8l+yvuamLy0Glv5OIjg8zwtLTMzhaDnmU/n9Eveo
         yElg==
X-Gm-Message-State: AOAM532j8Jca6kfJM4sFh/XK5HbJjdBX+nN9xBLpyL+qjd/ydKxwh04G
        zvi+J/C9RLtNSZAStGtrBdDRgg==
X-Google-Smtp-Source: ABdhPJzqj/vHsUt8v+yI/yAohoiXodmdff3euZujHbyhcF7T3TGI2OT+zeS4bF7QHWlLpk20fGUv4A==
X-Received: by 2002:a05:6e02:1311:: with SMTP id g17mr1685142ilr.47.1611361495395;
        Fri, 22 Jan 2021 16:24:55 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k8sm7088799ilc.28.2021.01.22.16.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 16:24:54 -0800 (PST)
Subject: Re: [PATCH 4.19 00/22] 4.19.170-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <302da632-517c-0e68-5da7-11b1838ac1a3@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 17:24:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.170 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.170-rc1.gz
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

