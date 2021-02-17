Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86631E2C1
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhBQWsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhBQWqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:46:31 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F20C061788
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:45:51 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id a7so4442726iok.12
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/EtfkUw3oZIbZL9grKTp0TlguZ3YnmMueDqnvSR1hLE=;
        b=G99JtRFF1vdJjqqn/RABCm0tquMOxGy/oN/WY6kPzHzvkPQe8hZMxlQg0hgzA2aCLm
         RHelWdYkBN/tBxpfN13BUrYDTH2GRsxVLqnEPb6P+eP+qxlDVT896QegUP6Z4R3gIRii
         qVu98AnXgk52wPoQVXX1jeDSYthy+MjlgTWmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/EtfkUw3oZIbZL9grKTp0TlguZ3YnmMueDqnvSR1hLE=;
        b=RNS2XeifNM+Q0CNKjdqS1vEhcgD1gxyJm7RunSaOTQeRCJ4iNv7DFIRONmL50IbGYt
         9Q0XgYWnaA3IVJLLeEX4BbVbE1+8UMv86XQwgLlLjlk6NGZAu17dsLJzRnTzxRBDtomN
         5FyHhtXX59XHvaifo1nqgCr6V/bwKvZ/O10imNOSdVYiVv9UQ8VCn2v1wQDEaGtD9wdX
         XllU3nmxDNeW15F/M0zrDd9NkxFyjiwVvt1Jn3jdFlW1hf8PnhEKIM/gUGFFbNLvRZXn
         FbfzBs9lLoyP15TjLQKtWzQnSXN/7rUHCr/IlliAm+L+YrlS9pGv/edpkz9Yrl+Id33u
         DKHA==
X-Gm-Message-State: AOAM532BDU8NWWE/86XKqkaCR/2+7eKgl9LbOOEx2C7MUvyAHGzZYEUA
        WAMXjrQiMWrFPeHRFuf6V0WM1f3p7ieM4Q==
X-Google-Smtp-Source: ABdhPJylgVAULFgtptVHAUmPUexHtfoFldtftsHUnw61VU/Ievg/yJs/ECX6BTjV7Uk5u2OQUiH3Fw==
X-Received: by 2002:a05:6638:42:: with SMTP id a2mr1635369jap.99.1613601950364;
        Wed, 17 Feb 2021 14:45:50 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id e1sm2547255iod.17.2021.02.17.14.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 14:45:49 -0800 (PST)
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
 <0825d0d8-0183-9653-dd74-d5921e360bb7@linuxfoundation.org>
 <YCfM/llSa65fhR4m@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0ec4ad3c-3cbd-aa69-db3f-999f2622037d@linuxfoundation.org>
Date:   Wed, 17 Feb 2021 15:45:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YCfM/llSa65fhR4m@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/21 5:58 AM, Greg Kroah-Hartman wrote:
> On Fri, Feb 12, 2021 at 09:17:13AM -0700, Shuah Khan wrote:
>> On 2/11/21 8:01 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.16 release.
>>> There are 54 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled and booted on my test system. No dmesg regressions.
>>
>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> Note: gdm doesn't start and no response to keyboard and mouse.
>>
>> I can ssh in and use the system. I am going debug and update you.
>> 5.4.98-rc1 and 4.9.176-rc1 are fine and no such issues.
> 
> Did you ever track this down?
> 

I am planning make time this week to track this down.

thanks,
-- Shuah

