Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53756379B00
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 02:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhEKACW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 20:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhEKACT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 20:02:19 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398CFC061574;
        Mon, 10 May 2021 17:01:14 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id t4-20020a05683014c4b02902ed26dd7a60so5890982otq.7;
        Mon, 10 May 2021 17:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R7PZx7AAGOoy8PxHbzIFSV8IwSpbdv1qjIMRryoTTBY=;
        b=ixwF8KIuKBQZDFafik8Y2JQGFm8kpWm7iIK0LJSppHYLN6Qp4GtvBH9pDBmIetUpMj
         VfM1s9U+NCrQ9fwcC4tYeuctHiv03pS/Xu1JJTqOiijpyMmgVxgF/8k0Jm4lE+TCa30S
         qhZiQX+Y6C4dsFOGsc+THH4jx6oQV7h3MIwJGBzfsQYIo3IZAhRVdTYdSzAC8dSlNY9h
         P67phQj3R/SvlgWvhT7m0LOF3OzTRhjfiincbkjHdl6FefhrqBLbRUO28fPU9+5Ofhhl
         vvSa9MEInQQU48KiRvhZ7kzPGYgZZv27aoM5/Bnc17KAhSPzXdPtyTILKfE3Jmx9Okuw
         5KYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R7PZx7AAGOoy8PxHbzIFSV8IwSpbdv1qjIMRryoTTBY=;
        b=MTvBg97yALJ+wJmrTM0dYMtKtY4oS2g7VCoK928duyIROpEuX0zWzMSldPmb3dkVzc
         MNEC7h8WGbGabmS3+0zuIAJw1W01z1hTX9uk80DU6CRMIQuUxgfppSV3I2LkjYUNW19T
         qcekXJKRRyXtu++BbWO1n8U+FqVgCd+PuUC57ainWjaJa52ueCsuAbUXNZqlrpPKFBVZ
         ISIWm6F1ztK3J8NhbzkzIHP46yWpvJ7exptbCH+QciO/w+ApYvXbOrLTFPtCC6UmlXCL
         qRYnqPy1GU4GLxBe8mpRTLO/e327mJaXxJlQzG3W5VcFWso5qZnWCpFyl9MZEOedal7V
         ED7A==
X-Gm-Message-State: AOAM530GtJbZ4VgAdIe5fmUCfZm3ijDMtZeBDpUDFSua2vcYjS3pdnV6
        JN34AnD6p5jCPfNIjDXFoEARYc+lBfQ=
X-Google-Smtp-Source: ABdhPJxxZhuwMM6NtLn98z76+j+QlPtjKTxrmr2bzNPo+2yrV3aXCOEsp10YFpFHAkFb353JRxUI+Q==
X-Received: by 2002:a05:6830:18fb:: with SMTP id d27mr6537877otf.235.1620691273387;
        Mon, 10 May 2021 17:01:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm3505889otf.47.2021.05.10.17.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 17:01:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210510102010.096403571@linuxfoundation.org>
 <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0f93da1a-14c4-8ce8-9afc-eab883a4fa66@roeck-us.net>
Date:   Mon, 10 May 2021 17:01:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 3:48 PM, Shuah Khan wrote:
> On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.11.20 release.
>> There are 342 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compiled and doesn't boot. Dies in kmem_cache_alloc_node() called
> from alloc_skb_with_frags()
> 
> I will start bisect.
> 
This is interesting; unless I am missing something, no other testbed
seems to have caught this problem. Do you have a backtrace, by any chance ?

Guenter

> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> thanks,
> -- Shuah
> 

