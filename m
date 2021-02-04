Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941B330F522
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhBDOhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 09:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbhBDOhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 09:37:00 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83399C0613D6
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 06:36:19 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id e133so3376634iof.8
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 06:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4b6g4Ixc+28bqJmLbqvgP9hQfDNHN5yB7hwfEVlSifU=;
        b=DoDUzF1FugVu39+pUjXZWuLuaHXDph+UhmdKadXCiWqSUmC1sJhnXcmmp4Eof4jQ8P
         n0AnSpOF/hTGapO/LwzkZHzuSCpF/dPQHD2XA4yXTwSxIuzq2JIi6Ziv9awcN6cBccih
         5Y3JOLQ9T2pp8qhNcx+U/65i454AmopgdlxTbkPF6eVAPep/AbT/KmIu23CqU8rCrzYg
         TLdgtYTqKwPnIozcZaDmIwaypdKVPdcGJv7tJI40nduW/Oe3pOJw/9sfbALoAdqHSfaU
         HE3293si0bclf3cih/YEV9cowsZyuoQ7mbRCbYp6C7IYGtB/sWkp2vIf7OfqizIsY35j
         ZjFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4b6g4Ixc+28bqJmLbqvgP9hQfDNHN5yB7hwfEVlSifU=;
        b=CXVvgil9x1ZHfllTZ7YSkhftNbSbTIYGhvwVefQo46Zf1mB9utSbRZ2vbfzrULImoS
         Xg6qkdlJGuMxi6xdte9aGmowutwUvZH1ZpeinRibIYOpgFQGAjRW6LFH7sMZbwc9LSpw
         2Ut6Jqd75jThPuedt3SwWSxKA2MvH799zPYH7S376ovOutDdRj4UoYlDENj/H5PJfFzn
         BR7s1PlwhnPtwTV98+wdVPyGj50JQ9TlT8gLZz4fSIp/ToOAwNXR/PqApFu52vw613xS
         G/1/JOTGMGijeVCIBtPPlq4tek3Y/g+4d5yiwBjGs3fBbNBFXlgnUcKxFlLUixn1HLay
         /LEA==
X-Gm-Message-State: AOAM531OeRH060h7yWK4sU3gRblmLN22MvVZ2z/Y33nrD9j/kU3W6PY5
        0aLQuyXuQjq30SOUXg4ge2oH4w==
X-Google-Smtp-Source: ABdhPJy348+wqNXc1ktODm1LM5/rugrEEhJsFY6OzCngNLONMVPkJQZ5wqUkewmB6iOPBWblLt6Oeg==
X-Received: by 2002:a6b:d010:: with SMTP id x16mr7164658ioa.107.1612449378915;
        Thu, 04 Feb 2021 06:36:18 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o8sm2594214ilu.55.2021.02.04.06.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:36:18 -0800 (PST)
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
To:     Andres Freund <andres@anarazel.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
 <YBqfDdVaPurYzZM2@kroah.com>
 <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
 <YBsedX0/kLwMsgTy@kroah.com> <14351e91-5a5f-d742-b087-dc9ec733bbfd@kernel.dk>
 <20210203235941.2ibyrc5z3desyd2q@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <207c4fb1-a3cb-9210-e2b6-8e5490872df6@kernel.dk>
Date:   Thu, 4 Feb 2021 07:36:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210203235941.2ibyrc5z3desyd2q@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/21 4:59 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-02-03 15:58:33 -0700, Jens Axboe wrote:
>> On 2/3/21 3:06 PM, Greg Kroah-Hartman wrote:
>>> On Wed, Feb 03, 2021 at 01:28:26PM -0800, Andres Freund wrote:
>>>> On 2021-02-03 14:03:09 +0100, Greg Kroah-Hartman wrote:
>>>>>> On v5.4.43-101-gbba91cdba612 this fails with
>>>>>> fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
>>>>>> fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
>>>>>>
>>>>>> whereas previously it worked. libaio still works...
>>>>>>
>>>>>> I haven't checked which major kernel version fixed this again, but I did
>>>>>> verify that it's still broken in 5.4.94 and that 5.10.9 works.
>>>>>>
>>>>>> I would suspect it's
>>>>>>
>>>>>> commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   2020-06-01 10:00:27 -0600
>>>>>>
>>>>>>     io_uring: catch -EIO from buffered issue request failure
>>>>>>
>>>>>>     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
>>>>>>     lower level. Play it safe and treat it like -EAGAIN in terms of sync
>>>>>>     retry, to avoid passing back an errant -EIO.
>>>>>>
>>>>>>     Catch some of these early for block based file, as non-mq devices
>>>>>>     generally do not support NOWAIT. That saves us some overhead by
>>>>>>     not first trying, then retrying from async context. We can go straight
>>>>>>     to async punt instead.
>>>>>>
>>>>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>>
>>>>>> which isn't in stable/linux-5.4.y
>>>>>
>>>>> Can you test that if the above commit is added, all works well again?
>>>>
>>>> It doesn't apply cleanly, I'll try to resolve the conflict. However, I
>>>> assume that the revert was for a concrete reason - but I can't quite
>>>> figure out what b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e was concretely
>>>> solving, and whether reverting the revert in 5.4 would re-introduce a
>>>> different problem.
>>>>
>>>> commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e (tag: block-5.7-2020-05-29, linux-block/block-5.7)
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   2020-05-28 13:19:29 -0600
>>>>
>>>>     Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
>>>>
>>>>     This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
>>>>
>>>>     io_uring does do the right thing for this case, and we're still returning
>>>>     -EAGAIN to userspace for the cases we don't support. Revert this change
>>>>     to avoid doing endless spins of resubmits.
>>>>
>>>>     Cc: stable@vger.kernel.org # v5.6
>>>>     Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> I suspect it just wasn't aimed at 5.4, and that's that, but I'm not
>>>> sure. In which case presumably reverting
>>>> bba91cdba612fbce4f8575c5d94d2b146fb83ea3 would be the right fix, not
>>>> backporting 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048 et al.
> 
> Having looked a bit more through the history, I suspect that the reason
> 5.6 doesn't need c58c1f83436b501d45d4050fd1296d71a9760bcb - which I have
> confirmed - is that ext4 was converted to the iomap infrastructure in
> 5.5, but not in 5.4.
> 
> I've confirmed that the repro I shared upthread triggers in
> 378f32bab3714f04c4e0c3aee4129f6703805550^ but not in
> 378f32bab3714f04c4e0c3aee4129f6703805550.

I checked up on this, and I do see the issue as well. As far as
io_uring is concerned, we don't need that revert in 5.4. So I think
the right solution here would be to... revert the revert :-)

-- 
Jens Axboe

