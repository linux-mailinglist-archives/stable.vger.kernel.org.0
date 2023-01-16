Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED866C434
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjAPPoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjAPPol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:44:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D91E2B5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:44:39 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q23-20020a17090a065700b002290913a521so12006044pje.5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ep+gu8Wzxz1XzGkyuWB0bLCmC8cV8aaLkxDrtlaBNIE=;
        b=c9zNawnK2UWJhD/sNZEYHGKiNRlWVDyJijBtFtC8agG3fvskxGdpuCfktsi/Lotk9X
         pIx7QRICwargwIAnL5DuRxsUS0SIYEuq1t07E1RKcyacojSWF3KkzwrFGAyqlMOiV1IE
         s7OkG9vlFc4Al7DdkOWL+V9RVs/rhEMiNvWZRTy8vZgKc/ZCZK3++xFtE6u4c83mtXN8
         hftxLgO3Rv1kD2AcwM7y82t3Oh+0u+dKixBRpiwSgDAjNKF2Z3lwGPeWVXj4ZpehAVnm
         HYIj23INl6+EAGxC3EeAiGIAaNeYB+lhXaKlP48JC0WPEhaOv03T7bmgUjR9MAPctPuA
         t5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ep+gu8Wzxz1XzGkyuWB0bLCmC8cV8aaLkxDrtlaBNIE=;
        b=n7XGo01oFnwFSLaLyjeMBCRq+NMzUQRpwtFCsW+HPJgx76AKohZL7UZFUeo1rQcQG8
         YqZKe7VzBHtKjsvnm1SUFJy05b0U3tg8THCdeT3YlIg232yFIwSlIvaUgKh+QHR3mUSv
         GYAM5WcQ/Ki5IdDDTx5Gh9Au44ANxN/n85uOn5HO4C/SF1Lcfq47TOOpfOX/a+l+H7Lw
         yH9Ph0b3xzsFFzrB/3nMUJTtPVLk/3xjj6+Y9xgi0FwcUoRK8ZpJ2RUX5jWsaPn3xm3n
         B5tDH2aYOJ5KGqUq8GL0qCuejrw6jEICOcrlCWZv6wt7yGfQ37//D3gNVDBgeORqgzLq
         n4JA==
X-Gm-Message-State: AFqh2kpZ0fp+G+vdfYcRFdBhCTG1ndtSyd58NFwxR5hbKa14dvvBeqr1
        LkCn0kt+48+MlFCnVbjVRuKnfykkF2t+xGVx
X-Google-Smtp-Source: AMrXdXt0BZIJaIf2dPN5YJX2ElhkSG66V59emcBOnQUbzsek5vKyKYZiPt7whP8yZXNyuRHMVUbr5Q==
X-Received: by 2002:a17:902:d3c9:b0:189:b74f:46ad with SMTP id w9-20020a170902d3c900b00189b74f46admr53348plb.3.1673883879034;
        Mon, 16 Jan 2023 07:44:39 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b00172cb8b97a8sm5715112plh.5.2023.01.16.07.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 07:44:38 -0800 (PST)
Message-ID: <e921f92d-52ac-1dc7-7720-c270910c2a2d@kernel.dk>
Date:   Mon, 16 Jan 2023 08:44:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8VkB6Q2xqeut5N8@kroah.com>
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

On 1/16/23 7:49 AM, Greg Kroah-Hartman wrote:
> On Mon, Jan 16, 2023 at 07:13:40AM -0700, Jens Axboe wrote:
>> On 1/16/23 6:42 AM, Jens Axboe wrote:
>>> On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
>>>> Hi, this is your Linux kernel regression tracker.
>>>>
>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>>>> kernel developer don't keep an eye on it, I decided to forward it by
>>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
>>>
>>> Looks like:
>>>
>>> commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Wed Jan 4 08:52:06 2023 -0700
>>>
>>>     block: don't allow splitting of a REQ_NOWAIT bio
>>>
>>> got picked up by stable, but not the required prep patch:
>>>
>>>
>>> commit 613b14884b8595e20b9fac4126bf627313827fbe
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Wed Jan 4 08:51:19 2023 -0700
>>>
>>>     block: handle bio_split_to_limits() NULL return
>>>
>>> Greg/team, can you pick the latter too? It'll pick cleanly for
>>> 6.1-stable, not sure how far back the other patch has gone yet.
>>
>> Looked back, and 5.15 has it too, but the cherry-pick won't work
>> on that kernel.
>>
>> Here's one for 5.15-stable that I verified crashes before this one,
>> and works with it. Haven't done an allmodconfig yet...
> 
> All now queued up, thanks!

Thanks Greg! This one was my fault, as it was a set of 2 patches and
I only marked 2/2 for stable. But how is that best handled? 1/2 could've
been marked stable as well, but I don't think that would have prevented
2/2 applying fine and 1/2 failing and hence not getting queued up until
I would've done a backport.

What's the recommended way to describe the dependency that you only
want 2/2 applied when 1/2 is in as well?

-- 
Jens Axboe


