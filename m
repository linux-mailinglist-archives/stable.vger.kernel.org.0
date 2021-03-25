Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB834932C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 14:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCYNiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 09:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhCYNiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 09:38:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7FAC06175F
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 06:38:51 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k25so1940076iob.6
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eM1i1Yk87DzUyuufIUGNIKd4zH4tVzCeadWKa9Xb/JU=;
        b=XdHRtgYk0+DLpDrv3ToQu5LWl0EYWRXpd/TbmPrRxtPCCkTI1FtzSRyh+dBxxClmvL
         +q9RzafC27umFrgzVkXSOeHFGrfjKrrqJTm7RqEDtLXp7PwkuxLlD46X/G1Tssmszq6G
         H3bjL9t24Wj3tcTTmVqNoHu/QwKYDo76LNFmaag0zJ9hhsFJ0dJ4VNFm70qp+KBVcXpJ
         M1thxus4OrUpRTyMkoXMORYOiKpO+fQx3AnD0lUgQ0Wih12kQpF+7omp4c3lv1Uihm8i
         n94wWdDv7paeA6/5WbaZxsn/dwpQScoYDCcQKuTXN4/s52NloR4Al9i92lhhyd0lTdCF
         GfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eM1i1Yk87DzUyuufIUGNIKd4zH4tVzCeadWKa9Xb/JU=;
        b=fnRT0nr9AjiwbZ6ZEcvU7daP+kAFk3dsQ/FzRj+s1mSOj2cGy90ztak5jY0T+coCE8
         QHWwpYRJPVxg2Bow7q5KeZdKQ6N9J9+ORTj7zcRacFFNRcXHQqdPJNyBMlKUNBl3xmOp
         Yt6PbnFkpnrWX3S6eIkhlnzMtAg2Ol5ZcZVUCR+5caUrawMg/VjEXhowdyOFml6chgKE
         BPIScxcCd5E+c+8BmDalnHfXk5HZBDz+uVxuk9q43R1r0CwGOevL/kKL//jF8GWHKOFZ
         zhDbF8UDYvdZIeUYF5kWzx3G3K9z1Vmb6tp4q0xcMpqiKdDBxUwV5oViXy1fhZ8ZS/Gn
         WtQA==
X-Gm-Message-State: AOAM532/+VP6roVeQoyizPxcBxzM6sxOadwmNwogRYTyALokpzlY8PUJ
        AwTMbMueFBSjzh60bNHKXgn+7w==
X-Google-Smtp-Source: ABdhPJztg2JZ0lfPBKpRS5e6PcjYOMvW4/3r4DT52HfPZ2N9pX0RvjFWOsn0Ee82mHqUxfdIURFLbw==
X-Received: by 2002:a02:11c9:: with SMTP id 192mr7529596jaf.135.1616679530405;
        Thu, 25 Mar 2021 06:38:50 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v7sm2770160ilu.72.2021.03.25.06.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 06:38:50 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
To:     Stefan Metzmacher <metze@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-43-sashal@kernel.org>
 <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
 <m1r1k34ey1.fsf@fess.ebiederm.org>
 <41589c56-9219-3ec2-55b3-3f010752ac7b@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b2a9701-cbe0-4538-ed3b-6917b85bebf8@kernel.dk>
Date:   Thu, 25 Mar 2021 07:38:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <41589c56-9219-3ec2-55b3-3f010752ac7b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/21 6:11 AM, Stefan Metzmacher wrote:
> 
> Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
>> Stefan Metzmacher <metze@samba.org> writes:
>>
>>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>
>>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>>
>>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>>> signals in general, and have no means of flushing out a stop either.
>>>>
>>>> Longer term, we may want to look into allowing stop of these threads,
>>>> as it relates to eg process freezing. For now, this prevents a spin
>>>> issue if a SIGSTOP is delivered to the parent task.
>>>>
>>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>> ---
>>>>  kernel/signal.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>> index 55526b941011..00a3840f6037 100644
>>>> --- a/kernel/signal.c
>>>> +++ b/kernel/signal.c
>>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>>  
>>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>>> +	if (unlikely(fatal_signal_pending(task) ||
>>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>>  		return false;
>>>>  
>>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>>
>>>
>>> Again, why is this proposed for 5.11 and 5.10 already?
>>
>> Has the bit about the io worker kthreads been backported?
>> If so this isn't horrible.  If not this is nonsense.

No not yet - my plan is to do that, but not until we're 100% satisfied
with it.

> I don't know, I hope not...
> 
> But I just tested v5.12-rc4 and attaching to
> an application with iothreads with gdb is still not possible,
> it still loops forever trying to attach to the iothreads.

I do see the looping, gdb apparently doesn't give up when it gets
-EPERM trying to attach to the threads. Which isn't really a kernel
thing, but:

> And I tested 'kill -9 $pidofiothread', and it feezed the whole
> machine...

that sounds very strange, I haven't seen anything like that running
the exact same scenario.

> So there's still work to do in order to get 5.12 stable.
> 
> I'm short on time currently, but I hope to send more details soon.

Thanks! I'll play with it this morning and see if I can provoke
something odd related to STOP/attach.

-- 
Jens Axboe

