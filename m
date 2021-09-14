Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE45840B71E
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhINSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhINSps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:45:48 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2891CC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:44:31 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id bi4so515144oib.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YMq8aCZWj1J7gBknt6YaBXHRP9BmThe153cQ2IgzTlI=;
        b=lF04Q1jFDNBdkV5bxF2gjYlf7GMzLqFqlgph3Q0XpGXRoF3iJTAlsiZ8LLgmN0oPZ7
         /EWLR8upBDFQERCdorklyIYQyUVj6x4Bz+qnJ/0+/XbW678FuAnSTndiOnFLIuqFUpSO
         CO6lCAPVtckUZ4F5SkpzsXsYz5ZLShuHj+kPeuuqCqiegsajAglxXMMyRdPkIK95BdxN
         qn6scKioTyQg6K2LSlgdsrt5WBnH8DP2s+bBhMxWuJqDS4UOzdHNjny9tsoj5LZ86CZI
         oyAPahJgx7vQSSw3VBKIcjoJ4BDEKWe0Qm5f+Srh+JomcBSOiG1ODErRE3UJQHDVhTmd
         MFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YMq8aCZWj1J7gBknt6YaBXHRP9BmThe153cQ2IgzTlI=;
        b=yS6E0fFnNJR6J9pEow4p3l4VxSXp996pB/jzFGUMDy5Ux0t1FyhYy6u6pv+DrosAQJ
         kRNpOUvNi6PvQ3Rm8PYx1eZhmIjDZcr4NAITe/dkwgyrqjMs9FY3oX6dhpelSAF2PJDA
         v8v7iDoZ6QHBzXlAmWWE9H8bni+U1gms2sm1UrapN1MR+YjN4dLpyzIFEGlDa8bHkuM8
         2ZCKWpBMsvbq7nNN0bP+bfX6yckzbsySsdg17cZJehzPDyzywWYLx3TVYqOwrdtz3n4m
         GcKF2aW009zxYEdv8ed75Eu68mumH84sx8VHE3YL1eOcumJtn70I93/XaSQoGlCqn2X0
         whiA==
X-Gm-Message-State: AOAM532p6HsrqGTqvDbhz2r5QM58rWWm8bAtixhU4FFHeYaD67kM798A
        GqVdHlh2pGL1x+Ltz5Jj38evlbQQPl8=
X-Google-Smtp-Source: ABdhPJz0MDj6ZKB4u3GGVqBY4eOD6jFI/mwQ4bU7bhocqkAH7VKZQdKn8xhZPCLg7sTKNhjhKjqNjQ==
X-Received: by 2002:a05:6808:2204:: with SMTP id bd4mr2655003oib.108.1631645070480;
        Tue, 14 Sep 2021 11:44:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k23sm2840943ood.12.2021.09.14.11.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:44:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: ppc crashes in v4.14.y-queue and v4.19.y-queue
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
References: <87cbd9ce-161e-7c15-fbf4-66abd2540bed@roeck-us.net>
 <YUDKnfT6RJJDXs94@kroah.com> <20210914180307.GA567043@roeck-us.net>
 <YUDlQAGwVCDJgylW@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <144203c0-d7c8-6a53-7f51-44f47277c1d1@roeck-us.net>
Date:   Tue, 14 Sep 2021 11:44:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YUDlQAGwVCDJgylW@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/21 11:09 AM, Greg Kroah-Hartman wrote:
> On Tue, Sep 14, 2021 at 11:03:07AM -0700, Guenter Roeck wrote:
>> On Tue, Sep 14, 2021 at 06:15:25PM +0200, Greg Kroah-Hartman wrote:
>>> On Tue, Sep 14, 2021 at 09:03:38AM -0700, Guenter Roeck wrote:
>>>> Hi,
>>>>
>>>> I see the following crashes in v4.14.y-queue and v4.19.y-queue.
>>>> Please let me know if I need to bisect.
>>>>
>> [ ... ]
>>
>>>
>>> Bisection would be great to track this down if at all possible.
>>>
>> Attached. Reverting the offending patch fixes the problem in both v4.14.y-queue
>> and v4.19.y-queue.
>>
>> Guenter
>>
>> ---
>> # bad: [d73a5c7790019b70d9454ee9797c223198ad8ff0] Linux 4.14.247-rc1
>> # good: [f96eb53cbd76415edfba99c2cfa88567a885a428] Linux 4.14.246
>> git bisect start 'HEAD' 'v4.14.246'
>> # bad: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor
>> git bisect bad 33a419b7cde2a3b8a0932319b6d54914717797f0
>> # good: [69f55eceb19466d9b20f926dbd16a4a0ad22ddbb] Revert "btrfs: compression: don't try to compress if we don't have enough pages"
>> git bisect good 69f55eceb19466d9b20f926dbd16a4a0ad22ddbb
>> # good: [f749b828e2bd070a33c3e8a1eda0e5e2de15ae81] power: supply: max17042_battery: fix typo in MAx17042_TOFF
>> git bisect good f749b828e2bd070a33c3e8a1eda0e5e2de15ae81
>> # good: [adccd339c64fbcd7098cf58a57acc3b7db3488d5] crypto: qat - fix naming for init/shutdown VF to PF notifications
>> git bisect good adccd339c64fbcd7098cf58a57acc3b7db3488d5
>> # good: [fe223807816e23234dc25460fabbe8957fec14e4] m68k: emu: Fix invalid free in nfeth_cleanup()
>> git bisect good fe223807816e23234dc25460fabbe8957fec14e4
>> # good: [17c695dab8970f9c7396bb7ccb25cc204b685f0b] spi: spi-pic32: Fix issue with uninitialized dma_slave_config
>> git bisect good 17c695dab8970f9c7396bb7ccb25cc204b685f0b
>> # good: [e2ff046bc5c21120d29085f33d3c56e3cf024ec3] clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel
>> git bisect good e2ff046bc5c21120d29085f33d3c56e3cf024ec3
>> # first bad commit: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor
> 
> Odd, but thanks for letting me know, I'll go drop this patch from 4.14.y
> and 4.19.y queues.
> 

This is not odd: the cleanup code in v4.14.y and v4.19.y is messed up after
this patch (the code was rearranged later). It looks like the new check
fails there for some reason, leaving a mess behind.

Guenter
