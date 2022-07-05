Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5656714B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiGEOiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiGEOiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:38:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF2A1E5
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 07:38:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a15so5635779pjs.0
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 07:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hSS62a24JfP5IQgmlklLK9+ea4RUKYpDcuvi8FclMOw=;
        b=a2W5LFX8yCsj1//yEQ4C6Hja4zwvmmkdgl2htcidvxuqcDbGeBa/xhqc0LCQ+pp0WX
         1VM81Hrvmiy4NSqM0+hcOUJkrswDt0oqL3OQBZJA80hxy5H6maWaitIcbm87OpXzgv2F
         m7FxzhM06I6maf2sQfjWbUpYYwrRSs1FsbuskyqTQ4rkaL9lQKT2CAKBEnQY1lXvsGBN
         jKn8XwSCYZIA2p3XtAAawK+ZPEj5cfUDWz3Pe328uoKu5+F0kktSBDquzX8gf2CTP8V9
         smTjk2Ank97nK86KcBoBU7thBrb6T0Ndx1XQddO3v7ucqS6OhUI0+2gbbnNG9Sz7RXsY
         2b1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hSS62a24JfP5IQgmlklLK9+ea4RUKYpDcuvi8FclMOw=;
        b=6pXZnKOqu53M8bbbvuxEG19o6HQFYYwiu+ldHeyUlQc9L//M/mMAn+DeGhM2+z0N0e
         /gXXG37yyX2GWW+Jv6qTsja3jS+m6Ye3De4ryzgvPYhAJIUicT4nwJMOUoW/MlZsDf17
         dsnko7hWVT2u1KRVoBsXN33uC4BF+1dbePYm7gu00UinzGJ8qEqvjtdBGK/ILY5Uj8OY
         Ea8LCJdryQgjqBXHXm+6qxTdiYn9cqELY1gezIQbhDGGPUAlHTeY2qZtMH0/vrshgTjr
         ovQbijVz5iQ7zvNujfsvx8R1aj6fenmITskZN/jhUDSrPElha6H2gMsuTgZwaRmJc28H
         OGgA==
X-Gm-Message-State: AJIora/QtlSD/kWALSDLe4F4r2+CAoiA0hPfhaGLUj9NLcb0mPc7+tgw
        LDBV59R5wDErTsqoRgBCb+s6Sg==
X-Google-Smtp-Source: AGRyM1tOVIj/+mi5GOuZPLoaeMF0Wklsm73jfAVkFQJb8BxMpWn8nDgOJP6kXOhSWsQiVwZ6TDuziA==
X-Received: by 2002:a17:90b:33d2:b0:1ed:2038:b949 with SMTP id lk18-20020a17090b33d200b001ed2038b949mr41103258pjb.61.1657031900921;
        Tue, 05 Jul 2022 07:38:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bk21-20020aa78315000000b005254e44b748sm22761162pfb.84.2022.07.05.07.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 07:38:20 -0700 (PDT)
Message-ID: <7fc4edd2-e394-6dfc-dd81-b2cad102dca0@kernel.dk>
Date:   Tue, 5 Jul 2022 08:38:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] io_uring: fix provided buffer import"
 failed to apply to 5.18-stable tree
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1656941060218130@kroah.com>
 <459dd43dc3f05e34eaf520752f3eb46daacd536a.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <459dd43dc3f05e34eaf520752f3eb46daacd536a.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 8:36 AM, Dylan Yudaken wrote:
> On Mon, 2022-07-04 at 15:24 +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.18-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git
>> commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 09007af2b627f0f195c6c53c4829b285cc3990ec Mon Sep 17 00:00:00
>> 2001
>> From: Dylan Yudaken <dylany@fb.com>
>> Date: Thu, 30 Jun 2022 06:20:06 -0700
>> Subject: [PATCH] io_uring: fix provided buffer import
>>
>> io_import_iovec uses the s pointer, but this was changed immediately
>> after the iovec was re-imported and so it was imported into the wrong
>> place.
>>
>> Change the ordering.
>>
>> Fixes: 2be2eb02e2f5 ("io_uring: ensure reads re-import for selected
>> buffers")
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>> Link:
>> https://lore.kernel.org/r/20220630132006.2825668-1-dylany@fb.com
>> [axboe: ensure we don't half-import as well]
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index aeb042ba5cc5..0d491ad15b66 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4318,18 +4318,19 @@ static int io_read(struct io_kiocb *req,
>> unsigned int issue_flags)
>>                 if (unlikely(ret < 0))
>>                         return ret;
>>         } else {
>> +               rw = req->async_data;
>> +               s = &rw->s;
>> +
>>                 /*
>>                  * Safe and required to re-import if we're using
>> provided
>>                  * buffers, as we dropped the selected one before
>> retry.
>>                  */
>> -               if (req->flags & REQ_F_BUFFER_SELECT) {
>> +               if (io_do_buffer_select(req)) {
>>                         ret = io_import_iovec(READ, req, &iovec, s,
>> issue_flags);
>>                         if (unlikely(ret < 0))
>>                                 return ret;
>>                 }
>>  
>> -               rw = req->async_data;
>> -               s = &rw->s;
>>                 /*
>>                  * We come here from an earlier attempt, restore our
>> state to
>>                  * match in case it doesn't. It's cheap enough that
>> we don't
>>
> 
> Hi,
> 
> I have attached a fixed patch which fixes the problem on 5.18

Looks good to me, thanks Dylan!

-- 
Jens Axboe

