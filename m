Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04A9325BA9
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 03:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBZCZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 21:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhBZCZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 21:25:57 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1B3C06174A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:25:17 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 81so4502627iou.11
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lqXbWCJGBIPVgVxxSDmyOyCMM2UA/hJXlk+zAVYN7IE=;
        b=ZfvW4KQCKrDOTRqtKKqgizRlbL2ys03rIOscmlUrfTXE7HBOVCOqFSO0CeRc/oUywd
         uL2XJbqzPRhFJmV6HduetLrUydBu1I47cuOrjBKZfQ37WUvAL9I57vt+S4sqQxFkrcYg
         2iva5OXQcAVcmT3GsJmZGy7bpO5vQmwA0l7V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lqXbWCJGBIPVgVxxSDmyOyCMM2UA/hJXlk+zAVYN7IE=;
        b=VT+ht8pcSH+g2+hVUr52S+Mq5xU2DMbLxf8UVxyK1ji5ZWvYN7hN+LwLDrB7/UKNDa
         2RRlzoF70nLiQ+6nIZKXeYXycbSiWCw2VMFDdpUHrMNkeoo6jtHy+2fCVS4YOZ9UPjrS
         UOGp9K7Q2sPJm4jHqcOauQ7GnQ38nqFK7uWMm1lS0hgA7HtY04iKIJD1Q+46FKsUGrF7
         XG3yvVon+H2IkUjDO4/iBvdBjYkW4ElG/jAmWiB8Jq5sU9IlkSiUwDsQVdASeDYqQgKB
         /ET/eEvhGaFSFdmWvTYUKUZ7dyljONFztMH7wlsVxnjFldzFDqGvuxre4YKRIvcs1bY4
         FWAg==
X-Gm-Message-State: AOAM532yvJ5uRQMVyPaJCk3bPnPvRrgeDSMxqBBqNV6eJ23+OW/7KTdp
        No86c7OGAC6N+7ugyXSIt1lBGQ==
X-Google-Smtp-Source: ABdhPJwNf7ZANkcdp7vduRmoYMpGAZ9izicAegqMLu5E6xNcJU4ii429MO6OseGSgh1Cf+dJOyA0Eg==
X-Received: by 2002:a02:2a01:: with SMTP id w1mr757910jaw.19.1614306317133;
        Thu, 25 Feb 2021 18:25:17 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k14sm2945177iob.34.2021.02.25.18.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 18:25:16 -0800 (PST)
Subject: Re: [PATCH 5.4 00/17] 5.4.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f695cd09-c066-3a6b-b4f1-e827fb4e77aa@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 19:25:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/25/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.101 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
