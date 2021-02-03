Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C943630E680
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhBCXAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhBCW7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 17:59:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD5C0613ED
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 14:58:36 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e9so696111plh.3
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 14:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VI8+mzDznZXreI3+hxAHs7jNdKbUG8fpqNw3FQx4Z28=;
        b=UVoUQSB0BgEs5PAHR/kMD4pwba+L48QIxB2rizTswy/5XS+jhWrgdCb4UeKh+zlcsz
         OO2hpOlqyiHdkiky9nIqrTT7+roUHaqCpK2yZgiqEL+0pSRIohqnS0pqNASRy8yiRljK
         T18i5UJJ2R1Qx/UrpgflkjEaSA81xQ2L6aXYFwaI8xeuBr/Ssl+sMoP3B4MJT/l9FGu7
         Qy2f3fo1wgPzh8+F/c+oqKZb/pYBIWaoNAktj4X2f84TWOq0G6Q+TouvQvrNIIOU/tX8
         FiK2jm+uQW6XMOUAm7qJIA/lqCT2GTRogVgF9SpSKqMxTnIZm69FineNnIlnnn5kDi1S
         v9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VI8+mzDznZXreI3+hxAHs7jNdKbUG8fpqNw3FQx4Z28=;
        b=uXhd57pjoDQTbwbsOK2wr03DD+TJ7i76fDAOl7rlk68p57ZJbwnANxDtHVkjyeXtnz
         walkVN1A3M33LuJw+0awve5zZxmmu4eNLLzyhqppqI+RVFCuvVUfRdIfK4cRnvKLjXm6
         mTZxdZyV/H2RxC6fRkFQSy4hMsN+2aJWBQNvWqs0Fi2glwk7KyhLsMk5nL/nWN9jK6y3
         Z0Sn0bvE50sFNTGsVxcFQDhmITMiGyzNaFIyaq0qQ8OYee4ijcH6+RLrVqZuVv7ZiMDp
         MnQ6foGEh3O/vvCae79gEvEO7XxBYpbwyB2cXBzm0oi/W4XI51VUDy6pSQmdCpPtyY6f
         c0Mw==
X-Gm-Message-State: AOAM530G+F1i1U8W6VkpUsD6QeR+mCO7LoMMT+ieLPr8tSarOx1Wyi4w
        C0+Yqn0Go7gmnwOorT2SuZ39NQ==
X-Google-Smtp-Source: ABdhPJyop9GAWs+kkwennI5HB0WYgw78vTEm4XM9Qe8GmO4mKRhSXGccKwJBdxJGlb0a31OASOG+9g==
X-Received: by 2002:a17:90a:7ace:: with SMTP id b14mr5383372pjl.208.1612393115474;
        Wed, 03 Feb 2021 14:58:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z15sm102697pjz.41.2021.02.03.14.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 14:58:34 -0800 (PST)
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
 <YBqfDdVaPurYzZM2@kroah.com>
 <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
 <YBsedX0/kLwMsgTy@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <14351e91-5a5f-d742-b087-dc9ec733bbfd@kernel.dk>
Date:   Wed, 3 Feb 2021 15:58:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YBsedX0/kLwMsgTy@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/21 3:06 PM, Greg Kroah-Hartman wrote:
> On Wed, Feb 03, 2021 at 01:28:26PM -0800, Andres Freund wrote:
>> Hi,
>>
>> On 2021-02-03 14:03:09 +0100, Greg Kroah-Hartman wrote:
>>>> On v5.4.43-101-gbba91cdba612 this fails with
>>>> fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
>>>> fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
>>>>
>>>> whereas previously it worked. libaio still works...
>>>>
>>>> I haven't checked which major kernel version fixed this again, but I did
>>>> verify that it's still broken in 5.4.94 and that 5.10.9 works.
>>>>
>>>> I would suspect it's
>>>>
>>>> commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   2020-06-01 10:00:27 -0600
>>>>
>>>>     io_uring: catch -EIO from buffered issue request failure
>>>>
>>>>     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
>>>>     lower level. Play it safe and treat it like -EAGAIN in terms of sync
>>>>     retry, to avoid passing back an errant -EIO.
>>>>
>>>>     Catch some of these early for block based file, as non-mq devices
>>>>     generally do not support NOWAIT. That saves us some overhead by
>>>>     not first trying, then retrying from async context. We can go straight
>>>>     to async punt instead.
>>>>
>>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>>
>>>> which isn't in stable/linux-5.4.y
>>>
>>> Can you test that if the above commit is added, all works well again?
>>
>> It doesn't apply cleanly, I'll try to resolve the conflict. However, I
>> assume that the revert was for a concrete reason - but I can't quite
>> figure out what b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e was concretely
>> solving, and whether reverting the revert in 5.4 would re-introduce a
>> different problem.
>>
>> commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e (tag: block-5.7-2020-05-29, linux-block/block-5.7)
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   2020-05-28 13:19:29 -0600
>>
>>     Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
>>
>>     This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
>>
>>     io_uring does do the right thing for this case, and we're still returning
>>     -EAGAIN to userspace for the cases we don't support. Revert this change
>>     to avoid doing endless spins of resubmits.
>>
>>     Cc: stable@vger.kernel.org # v5.6
>>     Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> I suspect it just wasn't aimed at 5.4, and that's that, but I'm not
>> sure. In which case presumably reverting
>> bba91cdba612fbce4f8575c5d94d2b146fb83ea3 would be the right fix, not
>> backporting 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048 et al.
> 
> Ok, can you send a revert patch for this?
> 
> But it would be good to get Jens to weigh in on this...

I'll take a look at this.

-- 
Jens Axboe

