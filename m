Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB537ABA0
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEKQRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhEKQRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 12:17:09 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F10BC061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 09:16:02 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z24so18714061ioi.3
        for <stable@vger.kernel.org>; Tue, 11 May 2021 09:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n2KUFu8ow80GHnxi+JxVNH57ozVQcAi5xG0BCiV+y8M=;
        b=UBu6FhuCwAzNuDFjeVsGkc7yZ/ORR1DgADeGI5L7jyTTyLOouIzn6a5K2LqRNF3ZZL
         hYzagoLd/tadvwoozJ34HGH7E+Kq/VYzjJTmqRC7MJWGiIAyAogt2y+Uxsu22yKp/pOo
         jDxRveGYSGX6g+p+H1f+YlmN6iMsL24rkPzeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n2KUFu8ow80GHnxi+JxVNH57ozVQcAi5xG0BCiV+y8M=;
        b=ESwAcNpScor3+Feyg+rP1a4YszCI2pbzdpLZ8BRoY7TWXLbU25k3mkoYcpdm1N/kVZ
         1l3MXxjgZM2Vo9pCokESbdgL/nnh7SpEYEKnfdpczIXhHpgjTTG8CEkE5bUAcVIqc1SY
         3QmtQPqc8wUCZ3AgLVB8EMQihUtIwLCRMqa9mntTaDErTlJFBYKpbkbmAUw15q9bdgc6
         +eVxtrs50soF+dyUj+JXF4KqvdvCPukdRGBZAtQjjZdja1P00tSB82DBALkZA5N6FsUh
         RYSBsoN/YqBA4hMgnOtYrSEkwYBL8JuWmiEUIJsRmsT36iLhbF4b+LV7mhKsTl8/fvyA
         ta4Q==
X-Gm-Message-State: AOAM530Uficko9aD4KWQ1/3i2ISF1nCD8NyxoFvj2I59h6HRI0AFgoyT
        ghk67pcqy6n5iIP/81gr1QVLXQ==
X-Google-Smtp-Source: ABdhPJy1BhfKf9/iuX1pnfY0KoOSGFimEx3rO1IgqtsP4aG5k3XobqGiJlCI6PaInWF/6J7ZLPB/lw==
X-Received: by 2002:a6b:f808:: with SMTP id o8mr23307829ioh.140.1620749762070;
        Tue, 11 May 2021 09:16:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t10sm225049ils.36.2021.05.11.09.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 09:16:01 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
 <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
 <YJqIOajso0EyqgjO@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3244bd40-3afa-8386-3378-220ff2e2527d@linuxfoundation.org>
Date:   Tue, 11 May 2021 10:16:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJqIOajso0EyqgjO@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/11/21 7:35 AM, Greg Kroah-Hartman wrote:
> On Mon, May 10, 2021 at 04:48:01PM -0600, Shuah Khan wrote:
>> On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.11.20 release.
>>> There are 342 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled and doesn't boot. Dies in kmem_cache_alloc_node() called
>> from alloc_skb_with_frags()
>>
>> I will start bisect.
>>
>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> It might be due to 79fcd446e7e1 ("drm/amdgpu: Fix memory leak") which I
> have reverted from 5.12 and 5.11 queues now and pushed out a -rc2.  If
> you could test those to verify this or not, that would be great.
> 

I am seeing other display issues as well. This might be it.

I couldn't find rc2. Checking out 
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
linux-5.11.y

I will let you know the status of both 5.12.3 and 5.11.20 in a bit.

thanks,
-- Shuah
