Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D174764F9
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 22:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhLOVwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 16:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhLOVwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 16:52:35 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFBEC06173E
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:52:35 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id x6so32137493iol.13
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e/EAxrRt3kxe+Lol8a7ZY4P5skpYZL/GMsfAsy/rtH4=;
        b=ODw8qSXwouQGngcKNgmsfhbc/7+btLsv52/kSIpIcprxssRRBTlH3dlvIqTyOGvciI
         cCH07JL6cCaINhYwZSGPw4T1UcQOrSC0Pys0qgTUTpG5mdH3mhlrLMb00hVSKlsMqEpw
         emPBBejt5e67QNRgFImKHKf9aigDPNskqGpy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e/EAxrRt3kxe+Lol8a7ZY4P5skpYZL/GMsfAsy/rtH4=;
        b=O/PROn//RdCpmgNAd3GzngQV2rJOrgnyNUKE1RzKM/33k9lu/p5EGSdj6ypBkyHMT9
         UDZIax+9QbTCJRuG5qMNVmTVum7RYQfogKUZ854edafJsgXM5+0khOuVgZuyHvO/swAG
         Yy7ZXYXPub9DpAxq864qrIvrchffscBeJuyDVliT7WZpqUwxS+WeGpb0hbbTSBaS/aXC
         iZW+73fH4oT3mT6vEnUwJbUu71G8EJ17LmJA1o1N4uMXcr8H53QuhMhnJlVCVCIF4ndK
         M3ynR6bZUcd7IRrworofhI7dygUkXzVaVAKNvZPuoxty8vUyVBH4zmCYrD1p2UC7NhxF
         GcKA==
X-Gm-Message-State: AOAM5335U1MU48GD79F9OXf7ypZUoOcKCify5LAzRHfp8XcQQZ7bL4X0
        eGVWxcRMCQfTIfDSU/MV3LZt0A==
X-Google-Smtp-Source: ABdhPJxw1X44InqtOw7ZLYmoXaZkucjOSkBs0oW4q0zDfYzc16xGvMSp6M4xqbkTQpHnoizyUhPm6A==
X-Received: by 2002:a05:6602:1588:: with SMTP id e8mr7692933iow.181.1639605154763;
        Wed, 15 Dec 2021 13:52:34 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k13sm1972393iow.45.2021.12.15.13.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 13:52:34 -0800 (PST)
Subject: Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6417d843-042d-607b-fef8-b58921748339@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 14:52:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
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
