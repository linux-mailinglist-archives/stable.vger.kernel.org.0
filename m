Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C907334A46
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCJWAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbhCJV7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 16:59:45 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2BC061756
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 13:59:45 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 81so19634496iou.11
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 13:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v3ydwsjMUocDKEw68TfeqUCpJXmD3I8t+ae6XVVyZTo=;
        b=LNX9nBg/zYrBL+0Bz/I7b8G1Na3LIfKCAw9ceDpWtXtXKU0LFwo1zB5vid+u3eI2AT
         4BsKOxgDQt2DIvnC48BeP3C1JguQAP91g6ktf5dPMQSmFzafpaUEOLE9hJ8YeAQQSrEu
         TaCrXi0gVawwmddEWMLhNZsOEjqBO7Ds+FAy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v3ydwsjMUocDKEw68TfeqUCpJXmD3I8t+ae6XVVyZTo=;
        b=SVeGW7G0ZHjsmda96GOxxFJT+vK8WiADY83wd82qYjpQG8zUrkckZOwys3usOwLJHz
         W1bc3sGFHTZauATo1QiYMb2Lle1C13MPu9RhwCwrLIG5Z7xmeJ5p7KM4Gfbf7P8bwz9v
         D18KIuDCmgX/Wy+5MqfwXUhb1vjFehXfEdbyrwOkYpP2SB8E0I+OMLh0XBS4xVj3Kx+p
         gFBeN4sZNUXAJIKoofiuXBmMe4Oa+VU5fw8zJFgOeYK1E/6S1BFv2+HQZaiRwxGUaD14
         eQ51i/9SN6DKBcp+RyWaFxhSSmEImZFmlBGF31T2lAjzx/cz3/OrQ4viA0MyIh1DO06S
         iNYg==
X-Gm-Message-State: AOAM531Yc6nXCJAzYmdhmQp04OrzqzJzVDSmfcjXn98JXm7LRZZxirh9
        v6Xn8AtXibimylJ8KTza7wqSaw==
X-Google-Smtp-Source: ABdhPJyABQ6ggqON/ub435sF2ZXpLamtJYnt29e11CqdzMDmGi2h66YFmBG6PN6ZbzYxpuB9CyNTQg==
X-Received: by 2002:a5d:8543:: with SMTP id b3mr3866882ios.137.1615413585075;
        Wed, 10 Mar 2021 13:59:45 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u14sm322866ilv.0.2021.03.10.13.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 13:59:44 -0800 (PST)
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <14801dd7-0adb-fdc3-babe-f3f6cbb64b58@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 14:59:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 6:23 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.6 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

