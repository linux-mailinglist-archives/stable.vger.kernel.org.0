Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976F26B5DFF
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCKQkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 11:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCKQkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 11:40:15 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE08F28EB7
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:40:12 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y11so8740505plg.1
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 08:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678552812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6N0Ulf25aeoYIge+QpxZr0rbx1RoYJ828lEZDXjf8Y=;
        b=4qg9VKu3vLo4bCMQJ1lLsSPxbAsaQK+BCQEzv+s8BjaTrzgGkSLPdtHP/zkXYnrZ1E
         2qGDxhupxCKpPgaDCBSYT+ncBDyw5m3xHB+6kMTcSFpbyH11V8a3fyReIfuOagfArqFI
         uE27MwDu9aaGYk7CF8q8Vt5nQ9iwOIqqcaLHfp6QnTFV9I4TAYoohKXBCHhcUcUKg1HS
         KZoRwJHhenq6H68JeJnfBl81qINr25sK5P7bF3Jg4yyTM1CkRqbqnRiWF4DQwkzloGDo
         6nzA9qT7nLXpstd4CtZ+LydjS1aRTJfOQpf1WVCEh5Q2t69ZhL/aVEbCbpEZMNKeB9t/
         h0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678552812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6N0Ulf25aeoYIge+QpxZr0rbx1RoYJ828lEZDXjf8Y=;
        b=ZiqGvUo24QGjbD3xpQtE3MQNym0xNg5kciLeopLAoTh8wJcgZTZZiWi0Fx/iF01NaH
         Et1641nWJgI+6xutzo2vcZtf0ytFPxQ3HkAY9lqmQzPIcljy90E0clV8hiTC8DWloqwS
         FCGi/yT6ZVt7s/Ku3VsrL0/XCmt2rnjp1DZZlniUO3vpCgmQLhj4lymiRAcfptKArbT4
         pQ10OQxSpwx4QolsT4PE7B0r8iLDmypIYPxpEz5huM9DhLjNMFP88IyZ2H6bmyOQ0/hQ
         Mx1PaHcwduAJS6GZp9RGftC5UqcEwC6PkTXp7OVtLQMtlFbRh3RoBMkrNTiQ7MPrYOdl
         DVcQ==
X-Gm-Message-State: AO0yUKUL4hYZUqGeTZPgtM3Dmgnt3yMTYaSQtUV+W3JOYTkdOz2wPewT
        YbJRkKskZTuQfBbeetDax+0Llg==
X-Google-Smtp-Source: AK7set9fz5fdGt/ZU0CFXP9O85wO02qjjZE84smKSYAIQlQyoXRPazvJBu52ixyWt3231fvpWPvL4A==
X-Received: by 2002:a17:903:1387:b0:19f:382d:9740 with SMTP id jx7-20020a170903138700b0019f382d9740mr448884plb.3.1678552811987;
        Sat, 11 Mar 2023 08:40:11 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jx4-20020a170903138400b0019edf582a95sm1790401plb.20.2023.03.11.08.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 08:40:11 -0800 (PST)
Message-ID: <d5b5e99f-78c0-6340-4a2f-86ea593c4fab@kernel.dk>
Date:   Sat, 11 Mar 2023 09:40:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Mike Cloaked <mike.cloaked@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Genes Lists <lists@sapience.com>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain> <ZAuQOHnfa7xGvzKI@sol.localdomain>
 <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
 <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
 <ZAu030xtaPBGFPBS@sol.localdomain> <ZAxKq+Czx1dQjl6M@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZAxKq+Czx1dQjl6M@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

n 3/11/23 2:32?AM, Greg Kroah-Hartman wrote:
> On Fri, Mar 10, 2023 at 02:53:19PM -0800, Eric Biggers wrote:
>> On Fri, Mar 10, 2023 at 04:08:21PM -0500, Genes Lists wrote:
>>> On 3/10/23 15:23, Jens Axboe wrote:
>>>> On 3/10/23 1:16?PM, Eric Biggers wrote:
>>> ...
>>>> But I would revert:
>>>>
>>>> bfe46d2efe46c5c952f982e2ca94fe2ec5e58e2a
>>>> 57a425badc05c2e87e9f25713e5c3c0298e4202c
>>>>
>>>> in that order from 6.2.3 and see if that helps. Adding Yu.
>>>>
>>> Confirm the 2 Reverts fixed in my tests as well (nvme + sata drives).
>>> Nasty crash - some needed to be power cycled as they hung on shutdown.
>>>
>>> Thank you!
>>>
>>> gene
>>>
>>>
>>
>> Great, thanks.  BTW, 6.1 is also affected.  A simple reproducer is to run:
>>
>> 	dmsetup create dev --table "0 128 zero"
>> 	dmsetup remove dev
>>
>> The following kconfigs are needed for the bug to be hit:
>>
>> 	CONFIG_BLK_CGROUP=y
>> 	CONFIG_BLK_DEV_THROTTLING=y
>> 	CONFIG_BLK_DEV_THROTTLING_LOW=y
>>
>> Sasha or Greg, can you please revert the indicated commits from 6.1 and 6.2?
> 
> Yes, will go do that right now, thanks for debugging this so quickly!

The issue here is that parts of a series was auto-selected. That seems
like a bad idea to do for stable. Just because something applies without
other parts of the series doesn't mean it's sane to backport by itself.

How do we prevent that from happening? Maybe we just need to default
to "if whole series doesn't pick cleanly, don't grab any parts of it
in auto-selection"? Exception being if it's explicitly marked for stable,
not uncommon to have a series that starts with a fix or two which should
go to stable, then the feature bits.

-- 
Jens Axboe

