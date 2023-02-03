Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B4689B89
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 15:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjBCOZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 09:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjBCOZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 09:25:57 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD7B8FB74
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:25:55 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a5so657855pfv.10
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 06:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZRN1E+RhTA+olmuFS64TIGFQMQ30TCOtfaqy4X85dQ=;
        b=tc3c4AMu9XflukzEFjyABsrEC5buoS2hZRRluzS3tbH8Rv8PjzLMm6GeivxDOS1M+L
         FZ0jpXuT22i6VbU9SefXs4F2PJFVC3Bl20/ejzxRiBwQzuCe5qXlONPR03HInWtYlzQh
         QNq9lBC/p/+qkLikeNDbJ2vfUuQ+1S8wvTeORJA3Fla93BtS97p+1fMEMrVf5nVL4oyH
         RqxaRrpKYZmB4PxfUXoZG0nOtx5Dvv56eghCl+GVmqKfGF0SLqe50YUQGYkL52u0N6FE
         wo+0FVt56Al/tXu/ls0P+SZo6BW2txPGVeUrc57A3zs6huzjE1QjKxV/RNWaiP4UW2Sc
         EyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZRN1E+RhTA+olmuFS64TIGFQMQ30TCOtfaqy4X85dQ=;
        b=h8D4anV9bEDAQORVRk78c37nSOn+TqCh4B3VtiDD8DnpqQJP0K2yrti+BLJVp33w2M
         knyatH7DSiGaCXhgu4VQRvbqoJgB4LKQP9T+cxLoKuCPzQw7e4Po0W/1UBVaAH70P0ng
         4jPrn7MXpAX0V+PYm9jsEHsyFobVwJGyjUNXZ5PrPAhKvFjnmh7/E6R4LxsNCQmS+Zgy
         gyo1kB0m9wFK40SCH8SIkbF6wgOPhbndzugJGk3e0b419ZtQEnK+DpEN5IUnBDVpyZn4
         NpZCQ2W7gw0Grmw5g2h/4XkZ5J5gDKffw/Bjdk0RTBAZgRz59yrLWrhDmOfPtu/e+BRl
         En5Q==
X-Gm-Message-State: AO0yUKU7AHjgimQyWEz4IgbZqgYfsJV8lyiGOHgMkjPTk+F/0czp6bag
        GoHGRtudgBBD7Wd/mPEAaIL9vw==
X-Google-Smtp-Source: AK7set8TFabb1k5qtX5qN3lZJoL2hYCj+bBL1/B3CNd7iFfw0RUNA/X1j3sCCNs0YC9HKRdOGLauiQ==
X-Received: by 2002:a05:6a00:1d13:b0:593:b112:5cf2 with SMTP id a19-20020a056a001d1300b00593b1125cf2mr9853214pfx.2.1675434354488;
        Fri, 03 Feb 2023 06:25:54 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k12-20020aa790cc000000b00592543d7363sm1798250pfk.1.2023.02.03.06.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 06:25:54 -0800 (PST)
Message-ID: <0da4031f-6706-87ef-b888-ead7c5814193@kernel.dk>
Date:   Fri, 3 Feb 2023 07:25:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216932_-_io=5furing_with_?=
 =?UTF-8?Q?libvirt_cause_kernel_NULL_pointer_dereference_since_6=2e1=2e5?=
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
 <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
 <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk> <Y8VkB6Q2xqeut5N8@kroah.com>
 <e921f92d-52ac-1dc7-7720-c270910c2a2d@kernel.dk>
 <0857ddf2-89a9-231b-89da-57cacc7342d5@kernel.dk> <Y9zRPHyAmxhJoork@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y9zRPHyAmxhJoork@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 2:17 AM, Greg Kroah-Hartman wrote:
> On Mon, Jan 16, 2023 at 08:50:20AM -0700, Jens Axboe wrote:
>> On 1/16/23 8:44 AM, Jens Axboe wrote:
>>> On 1/16/23 7:49 AM, Greg Kroah-Hartman wrote:
>>>> On Mon, Jan 16, 2023 at 07:13:40AM -0700, Jens Axboe wrote:
>>>>> On 1/16/23 6:42 AM, Jens Axboe wrote:
>>>>>> On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
>>>>>>> Hi, this is your Linux kernel regression tracker.
>>>>>>>
>>>>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>>>>>>> kernel developer don't keep an eye on it, I decided to forward it by
>>>>>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
>>>>>>
>>>>>> Looks like:
>>>>>>
>>>>>> commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   Wed Jan 4 08:52:06 2023 -0700
>>>>>>
>>>>>>     block: don't allow splitting of a REQ_NOWAIT bio
>>>>>>
>>>>>> got picked up by stable, but not the required prep patch:
>>>>>>
>>>>>>
>>>>>> commit 613b14884b8595e20b9fac4126bf627313827fbe
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   Wed Jan 4 08:51:19 2023 -0700
>>>>>>
>>>>>>     block: handle bio_split_to_limits() NULL return
>>>>>>
>>>>>> Greg/team, can you pick the latter too? It'll pick cleanly for
>>>>>> 6.1-stable, not sure how far back the other patch has gone yet.
>>>>>
>>>>> Looked back, and 5.15 has it too, but the cherry-pick won't work
>>>>> on that kernel.
>>>>>
>>>>> Here's one for 5.15-stable that I verified crashes before this one,
>>>>> and works with it. Haven't done an allmodconfig yet...
>>>>
>>>> All now queued up, thanks!
>>>
>>> Thanks Greg! This one was my fault, as it was a set of 2 patches and
>>> I only marked 2/2 for stable. But how is that best handled? 1/2 could've
>>> been marked stable as well, but I don't think that would have prevented
>>> 2/2 applying fine and 1/2 failing and hence not getting queued up until
>>> I would've done a backport.
>>>
>>> What's the recommended way to describe the dependency that you only
>>> want 2/2 applied when 1/2 is in as well?
>>
>> What I'm asking is if we have something like Depends-on or similar
>> that would explain this dependency. Then patch 2/2 could have:
>>
>> Depends-on: 613b14884b85 ("block: handle bio_split_to_limits() NULL return")
>>
>> and then it'd be clear that either both get added, or none of them.
> 
> As per the documentation, you can put this on the cc: stable line in the
> changelog text like:
>   cc: stable <stable@vger.kernel.org> # 613b14884b85

Gotcha, will try and remember that :-)

-- 
Jens Axboe


