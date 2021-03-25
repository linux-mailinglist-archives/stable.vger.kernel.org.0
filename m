Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E517F34938C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 15:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCYOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 10:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhCYOCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 10:02:15 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B37C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 07:02:13 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n21so2015739ioa.7
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HFv8VCE+2t0FkrFbMVVnvkMOygoCtlm+GkhoqToaFus=;
        b=g1ARPunAo2VHJVSakV91ELUKWVfsgFM9+LE2zSLWzhFrruzS+YNpsJawyae5LImEz9
         37saVXKhErs5MFN6pe6cVKpTgBzfxsApdISEst6QHmZDLKCbPjW9cWsylvj2Q2MTrzf+
         nHtuahMcBockm/6hGM2LnLW0osKNaLaXh3vRNu0HGBL/Rh9f/W5/WBtSFrPg80pZz99U
         yr5ISSyHv2Xq4fz4ubkJZS/sBTKO2k2e9CQgXbL31o3zsXnho7/V3GLhTL9XC+zeYKQB
         or1LZlSYhYuuW1HyeauzZweA9ntOD367mQsO420U0HWtXTToSQF24semz9dW200po4lD
         pjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFv8VCE+2t0FkrFbMVVnvkMOygoCtlm+GkhoqToaFus=;
        b=bej/NWZ6Ow1YFWuetsSSoK0hKNbdkvbzb42FmAFP/HxYg3GETXIcBpUZO8AIVxfZLW
         z1FWoQ2rrCtXVEJI8ix9npdtxU+ytcYFefFmQT3q5wZFZpn9NSsH7zSsFD9LwGWalWrm
         eXMVezfdR9+erYu3UBQs2o/NNulVSyvt4oPvdyiVTwozLFb6jacYJ5XFE7huh08qSPC/
         Mp2RtlXQ+Oxd27QGqDLQePT9DHu3Zvayru/gH0Rpm7dRYemVcu0+nynDrL0//GoYui9Q
         qZMqO/85POSeE5TEcAahY8CwXHV22mGCg/cYvklQANHkbaMuzBKapxdfrGGzYFw4/Ls/
         Or3Q==
X-Gm-Message-State: AOAM533S4ih4yprSnnYDiCFKrUvHGJKqTZFJLrg+lVciC1bqI70NWDFy
        xFM2Lv4yvLLNNa0JXCr5FWpjxmc9TcJa0Q==
X-Google-Smtp-Source: ABdhPJy+wtzxwAMmr8FbRmDcChSqZ0BJZf3wTR1j8uSjlatyEB5QXaMK2w9Q0zg77ULZ6kMCsL5xOA==
X-Received: by 2002:a6b:ed08:: with SMTP id n8mr6427941iog.197.1616680933027;
        Thu, 25 Mar 2021 07:02:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q12sm2877518ilm.63.2021.03.25.07.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:02:12 -0700 (PDT)
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
 <2b2a9701-cbe0-4538-ed3b-6917b85bebf8@kernel.dk>
 <acf9263d-7572-525d-9116-acb119399c13@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15712d38-8ea4-e8c7-85ba-9d800b99c976@kernel.dk>
Date:   Thu, 25 Mar 2021 08:02:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <acf9263d-7572-525d-9116-acb119399c13@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/21 7:56 AM, Stefan Metzmacher wrote:
> Am 25.03.21 um 14:38 schrieb Jens Axboe:
>> On 3/25/21 6:11 AM, Stefan Metzmacher wrote:
>>>
>>> Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
>>>> Stefan Metzmacher <metze@samba.org> writes:
>>>>
>>>>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>
>>>>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>>>>
>>>>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>>>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>>>>> signals in general, and have no means of flushing out a stop either.
>>>>>>
>>>>>> Longer term, we may want to look into allowing stop of these threads,
>>>>>> as it relates to eg process freezing. For now, this prevents a spin
>>>>>> issue if a SIGSTOP is delivered to the parent task.
>>>>>>
>>>>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>> ---
>>>>>>  kernel/signal.c | 3 ++-
>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>>>> index 55526b941011..00a3840f6037 100644
>>>>>> --- a/kernel/signal.c
>>>>>> +++ b/kernel/signal.c
>>>>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>>>>  
>>>>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>>>>> +	if (unlikely(fatal_signal_pending(task) ||
>>>>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>>>>  		return false;
>>>>>>  
>>>>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>>>>
>>>>>
>>>>> Again, why is this proposed for 5.11 and 5.10 already?
>>>>
>>>> Has the bit about the io worker kthreads been backported?
>>>> If so this isn't horrible.  If not this is nonsense.
>>
>> No not yet - my plan is to do that, but not until we're 100% satisfied
>> with it.
> 
> Do you understand why the patches where autoselected for 5.11 and 5.10?

As far as I know, selections like these (AUTOSEL) are done by some bot
that uses whatever criteria to see if they should be applied for earlier
revisions. I'm sure Sasha can expand on that :-)

Hence it's reasonable to expect that sometimes it'll pick patches that
should not go into stable, at least not just yet. It's important to
understand that this message is just a notice that it's queued up for
stable -rc, not that it's _in_ stable just yet. There's time to object.

>>> I don't know, I hope not...
>>>
>>> But I just tested v5.12-rc4 and attaching to
>>> an application with iothreads with gdb is still not possible,
>>> it still loops forever trying to attach to the iothreads.
>>
>> I do see the looping, gdb apparently doesn't give up when it gets
>> -EPERM trying to attach to the threads. Which isn't really a kernel
>> thing, but:
> 
> Maybe we need to remove the iothreads from /proc/pid/tasks/

Is that how it finds them? It's arguably a bug in gdb that it just
keeps retrying, but it would be nice if we can ensure that it just
ignores them. Because if gdb triggers something like that, probably
others too...

>>> And I tested 'kill -9 $pidofiothread', and it feezed the whole
>>> machine...
>>
>> that sounds very strange, I haven't seen anything like that running
>> the exact same scenario.
>>
>>> So there's still work to do in order to get 5.12 stable.
>>>
>>> I'm short on time currently, but I hope to send more details soon.
>>
>> Thanks! I'll play with it this morning and see if I can provoke
>> something odd related to STOP/attach.
> 
> Thanks!
> 
> Somehow I have the impression that your same_thread_group_account patch
> may fix a lot of things...

Maybe? I'll look closer.

-- 
Jens Axboe

