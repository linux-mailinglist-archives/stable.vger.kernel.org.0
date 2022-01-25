Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEC949AA02
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323964AbiAYDaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415601AbiAYBsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:48:09 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F96C055A81
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:48:09 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id s1so300265ilj.7
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TcTjktdwQBBVKF9vPy6VlJWnBnsd4qaUxxJFKbh9HNI=;
        b=NCVUneneGDmkiDvfCj82fwHeBQ0NoayROmABAiQwmGxAU4kJCX0L8garbYQzzANF8D
         fNA7WLz3sIkMnBxu8xVJcj5PSOFPV1Goj5Noj+CWQxbYD7fJ2fWmMnRSx1btCN+u+kOZ
         HYL4a50k+9C1zNXEgg/vfRWZIMaI3IBTBDhFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TcTjktdwQBBVKF9vPy6VlJWnBnsd4qaUxxJFKbh9HNI=;
        b=H+ZQ44CJHapmWj4OOTZDHNF/PHzm18SAwsmze/1zjZBME4ZGQl0t31TNXlcQgLyvpa
         ZBWGjh4vE5xMlnXxJ1FAGWq+AzqLonBLXmD9HAqJBiXQ+MNpzU8+hGB0YRdBag6pBnfO
         9AVi96f3cenElr7EsN/R/pvKJ1yTQ8Mek8HbEQYqAsLvMuPMki55kAT1n43D8+jgFoTC
         IH2NzxYQ3d9p8rKJqPpF+yoFccrVqItoqZAi6HkIlZGp9ThrBYJYUrIyHSd/cP74vHHQ
         YnTndnq+nggWP2L6ZDfkWimMlCmoyXPGQ39Pgh+Ni9s6DuHHYHYEkus9eTiJFVJZ/YSx
         g4uw==
X-Gm-Message-State: AOAM5302lsNHZK8/Cb7jH42ZkD2oQvSZrMl0d2R+ee6gMIlXaiJXX6/x
        nUhcGHM1cwoWRzdDv6Ovmxfw6A==
X-Google-Smtp-Source: ABdhPJzWq9bmRGqaqSAji+NFuJz0q6lFuPq+ULQ4SAt3uCy2B+6AUo6o4mKPYBzY208jdnggHRa1Kw==
X-Received: by 2002:a05:6e02:180e:: with SMTP id a14mr8264008ilv.307.1643075288943;
        Mon, 24 Jan 2022 17:48:08 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id e5sm8081707ilq.9.2022.01.24.17.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:48:08 -0800 (PST)
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cf082288-9b77-c7af-f64a-cf94a9c3fdfe@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:48:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 846 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
