Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F513615A0
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbhDOWoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbhDOWoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:44:13 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD61CC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:43:49 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id v123so18994547ioe.10
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rzXQGwGNx2LDWqNVnrJSEZgKv6HyJ75m5VuY8WBJ4U0=;
        b=Ht0JkDNDwJEVPLlZPJlBXZdSBkaaT5bKUfRnea0DGvRWTE5FkJOMpLiCm8iWk+OAz4
         W5S8mRJ5Um0xBlFCzavS71CTnugALK7linGyQlomc0IpILTcO4sOwF/KNxtzC7TV8Dsz
         /YeHARh8fKqvyZLaW2LqBzK5XCy/Vldi4deks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rzXQGwGNx2LDWqNVnrJSEZgKv6HyJ75m5VuY8WBJ4U0=;
        b=t1sKGJTHBgL+6Nn9YaQ8ucl0uuiTTGtVK1tc9ZiHCPYYAtT28nKV+lVymVO8CeBsgy
         YF2djHZdhyDHNfzUVsKFEMV+dEtg4NgrDNvqGSXhAE3BB7CYRuiNIuXd0yBexDzpgw1C
         F8RamlT2ykzaVdfmXrhdvasokjui2AVrKf52bx5A2AK/uvdXR4oA6xAEtfpVdcom3act
         YV0hNQpvD/NwTua3lNmm0DNRADCLKIFsHln+Ja2xi/+2jyhAubWXiW1td5Pj+FXVDAE3
         M3gDeNvsJB3xJcYDxjrPlrw9MlTzLvstKAcMoboH5jxMcLyt9wU7j8uf2Fde5IEVgNFU
         0lyQ==
X-Gm-Message-State: AOAM531HOT/f2keHoBcUbpgZk1g4HtS2dOspE0AZxvtK+zo9SL2ikfim
        VlS1/vlO7MYed9DYbhQqUWj2ng==
X-Google-Smtp-Source: ABdhPJwfu4JpzEAJirYpVnrQI384B6cOr08HYYMXNnB1MMJVpvLvEbZ/ovOrWBdA+l8lYeyiiFdyxQ==
X-Received: by 2002:a05:6638:34a0:: with SMTP id t32mr1404679jal.10.1618526629315;
        Thu, 15 Apr 2021 15:43:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i17sm1723521ioj.30.2021.04.15.15.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:43:49 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/18] 5.4.113-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dc0ef84a-8f3c-b9c9-0b8e-4190249b3716@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:43:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.113 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.113-rc1.gz
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

