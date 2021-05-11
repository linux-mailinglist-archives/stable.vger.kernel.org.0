Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DE437AF95
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 21:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhEKTwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhEKTwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:52:19 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45709C061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 12:51:13 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so18523212otf.12
        for <stable@vger.kernel.org>; Tue, 11 May 2021 12:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zS+0U7rFCvEdcad2NE4wCvZL55gXsvgUbeBp8zYD6rA=;
        b=O4cFNgt9Jj3EcdrZLFMSfVjVR2QsWADPFtTkFGaO/Hq9cewBfIRvy9B2vzLjI3iLNU
         JHDiwolKAbXfr72r6vmXhPc7Dy+NKp+eCF0dhx5UzM3YSdC527kzRmsla33h312V8P6L
         O8QrhDz5dPQKQ4kjLSWejQ7E8gzkzZuVGeLkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zS+0U7rFCvEdcad2NE4wCvZL55gXsvgUbeBp8zYD6rA=;
        b=ojjReQN5r1m+M5yzOGuJV1xgpqitBhop0RDSUDm1x1UZ9IQ+fIFFBPKuvEDbviltYe
         oPU5+9e6kmCf3iLC8QogB5SFQ/Oqa+rel6CMt2lkwbr4DvQMLm7sxG68rMrxqHjLw4Ny
         mVi8DZLqCxHV08r9MwJ8zfpaujizMCoiBA4qyTXslaZp5kUwLpcZvmbn0fpFthPQ9RNT
         X83mtAYfC+nn76GjPgx+5z8X2CAn2w1TcvNrqXDto08xFIZjArAlvE98sacKpj2gu5fM
         /I1IMDVJvdVsKFf5BpE+kkdvPoJVc576XC+fsS3nkBH1585RikzL/2xqf87/Dg8isUFu
         ptdA==
X-Gm-Message-State: AOAM5322DnPmQVGqpB5J1cd9j0CD1Nk1mzgWyphB/hmE/tlTAN7OG1/X
        QbEkOpeuEBV/4eaqyMljvNWgjQ==
X-Google-Smtp-Source: ABdhPJxiHpeaipdbdpy34PypoLh5n3lSHEYF+Cr94pZJvF0c8vInzC168+gnnUw6WnZ+wPeRSgOOYg==
X-Received: by 2002:a05:6830:33ea:: with SMTP id i10mr27119289otu.212.1620762672684;
        Tue, 11 May 2021 12:51:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i130sm3481567oif.49.2021.05.11.12.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 12:51:12 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
 <142fd239-2f8a-26d9-68d0-706e90096b66@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6f3090eb-9a21-6530-ee6b-1f088478774d@linuxfoundation.org>
Date:   Tue, 11 May 2021 13:51:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <142fd239-2f8a-26d9-68d0-706e90096b66@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 4:52 PM, Shuah Khan wrote:
> On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.12.3 release.
>> There are 384 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.3-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 

5.12.3-rc2 compiled and booted on my test system with
79fcd446e7e1 ("drm/amdgpu: Fix memory leak")
reverted. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
