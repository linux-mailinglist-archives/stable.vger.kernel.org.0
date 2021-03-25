Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E990B3494FB
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 16:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhCYPKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 11:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhCYPKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 11:10:03 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45697C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 08:10:03 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id r8so2390065ilo.8
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 08:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cmfGnJhW1ZKpR18NP8XlvFCkJb4ulhMaonqbFk4lIRA=;
        b=ULidRotO2LfWr6HUVz7F+13oeRHQrR0Te92Q6AhStG07v4sXu65tyzn1Dcv+PUu2N9
         ON+YiOySujyGPyvB28p4uc2dJggdZk3SHxtJbjgR7pH6TMUWdUcQHWCmk4wpyusl7B23
         sKOHn2WhHia8E84urDDxTs42Ryg9BckVetuGQZeoYUXibO8EMV5KSaDrxIkknw3GRTNv
         Xu6QqG25lALREsz637kyfIA1AfOtev0Q9TAgopelkXU3wD0OPb0avMc0cfE2MNRzNd+J
         76j6WDI9If0rRLPYu09KhvOnP7IaHNi5lFQnR0ZtW/Iczd6WhbRbTKKNsu1B46QOqeB7
         K8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cmfGnJhW1ZKpR18NP8XlvFCkJb4ulhMaonqbFk4lIRA=;
        b=eT5hAR5wWzkfdAYXvsnkyjG4CS1MTefGCHm7V5dNxdnU3K2I0STdv0kMWcs7VqHWNZ
         TkBzIgnozDV4Q+9dGSs0cc/EIjhNNxCuQhrYC+LDX1w+3hzZwmD35j1OtKx5qeVFtFtG
         KAtXvd1BoHoVimc3UpqMuCG7xeQWBkNpfTprZNc1GH4lzqXdsnzHRBnsHJFXgeXtfsx/
         byBVZUSdg3+3Z+lLf2FJk1w+AOtWjIkDcZBoXTPBi1CiXkwqT4EOBiyWWvyIc20BGXKl
         w5mnUqGiqM0+O8suLp+gYi1LMaiCmgUhDOB02uSGAitlEsvivNUoQ/MO69ty0Z1IZiD9
         uF4Q==
X-Gm-Message-State: AOAM532z2PxMVkW2VOcyZVgHwHBZgqazNnqwOTOi18hxucin9xf0Tv9S
        txiVYO66NlgYqnD+PlJsyWrhIA==
X-Google-Smtp-Source: ABdhPJzgM4t4KvMBGf+62u4KTbHXouqVgSpIz4nucxMJ6+4NWvoJtwX0BywbEEdhiSvLJXq+wcJtkg==
X-Received: by 2002:a05:6e02:1ca7:: with SMTP id x7mr7076094ill.68.1616685002463;
        Thu, 25 Mar 2021 08:10:02 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p5sm2848483iod.31.2021.03.25.08.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 08:10:02 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
From:   Jens Axboe <axboe@kernel.dk>
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
 <15712d38-8ea4-e8c7-85ba-9d800b99c976@kernel.dk>
Message-ID: <f38622bd-cd98-8c3b-8779-9384d0279f5d@kernel.dk>
Date:   Thu, 25 Mar 2021 09:10:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <15712d38-8ea4-e8c7-85ba-9d800b99c976@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/21 8:02 AM, Jens Axboe wrote:
> On 3/25/21 7:56 AM, Stefan Metzmacher wrote:
>> Am 25.03.21 um 14:38 schrieb Jens Axboe:
>>> On 3/25/21 6:11 AM, Stefan Metzmacher wrote:
>>>>
>>>> Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
>>>>> Stefan Metzmacher <metze@samba.org> writes:
>>>>>
>>>>>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>>>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>>
>>>>>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>>>>>
>>>>>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>>>>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>>>>>> signals in general, and have no means of flushing out a stop either.
>>>>>>>
>>>>>>> Longer term, we may want to look into allowing stop of these threads,
>>>>>>> as it relates to eg process freezing. For now, this prevents a spin
>>>>>>> issue if a SIGSTOP is delivered to the parent task.
>>>>>>>
>>>>>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>>> ---
>>>>>>>  kernel/signal.c | 3 ++-
>>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>>>>> index 55526b941011..00a3840f6037 100644
>>>>>>> --- a/kernel/signal.c
>>>>>>> +++ b/kernel/signal.c
>>>>>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>>>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>>>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>>>>>  
>>>>>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>>>>>> +	if (unlikely(fatal_signal_pending(task) ||
>>>>>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>>>>>  		return false;
>>>>>>>  
>>>>>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>>>>>
>>>>>>
>>>>>> Again, why is this proposed for 5.11 and 5.10 already?
>>>>>
>>>>> Has the bit about the io worker kthreads been backported?
>>>>> If so this isn't horrible.  If not this is nonsense.
>>>
>>> No not yet - my plan is to do that, but not until we're 100% satisfied
>>> with it.
>>
>> Do you understand why the patches where autoselected for 5.11 and 5.10?
> 
> As far as I know, selections like these (AUTOSEL) are done by some bot
> that uses whatever criteria to see if they should be applied for earlier
> revisions. I'm sure Sasha can expand on that :-)
> 
> Hence it's reasonable to expect that sometimes it'll pick patches that
> should not go into stable, at least not just yet. It's important to
> understand that this message is just a notice that it's queued up for
> stable -rc, not that it's _in_ stable just yet. There's time to object.
> 
>>>> I don't know, I hope not...
>>>>
>>>> But I just tested v5.12-rc4 and attaching to
>>>> an application with iothreads with gdb is still not possible,
>>>> it still loops forever trying to attach to the iothreads.
>>>
>>> I do see the looping, gdb apparently doesn't give up when it gets
>>> -EPERM trying to attach to the threads. Which isn't really a kernel
>>> thing, but:
>>
>> Maybe we need to remove the iothreads from /proc/pid/tasks/
> 
> Is that how it finds them? It's arguably a bug in gdb that it just
> keeps retrying, but it would be nice if we can ensure that it just
> ignores them. Because if gdb triggers something like that, probably
> others too...
> 
>>>> And I tested 'kill -9 $pidofiothread', and it feezed the whole
>>>> machine...
>>>
>>> that sounds very strange, I haven't seen anything like that running
>>> the exact same scenario.
>>>
>>>> So there's still work to do in order to get 5.12 stable.
>>>>
>>>> I'm short on time currently, but I hope to send more details soon.
>>>
>>> Thanks! I'll play with it this morning and see if I can provoke
>>> something odd related to STOP/attach.
>>
>> Thanks!
>>
>> Somehow I have the impression that your same_thread_group_account patch
>> may fix a lot of things...
> 
> Maybe? I'll look closer.

It needs a bit more love than that. If you have threads already in your
app, then we just want to skip over the PF_IO_WORKER threads. We can't
just terminate the loop.

Something like the below works for me.


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3851bfcdba56..abff2fe10bfa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3723,7 +3723,7 @@ static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
 	 */
 	pos = task = task->group_leader;
 	do {
-		if (!nr--)
+		if (same_thread_group(task, pos) && !nr--)
 			goto found;
 	} while_each_thread(task, pos);
 fail:
@@ -3744,16 +3744,22 @@ static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
  */
 static struct task_struct *next_tid(struct task_struct *start)
 {
-	struct task_struct *pos = NULL;
+	struct task_struct *tmp, *pos = NULL;
+
 	rcu_read_lock();
-	if (pid_alive(start)) {
-		pos = next_thread(start);
-		if (thread_group_leader(pos))
-			pos = NULL;
-		else
-			get_task_struct(pos);
+	if (!pid_alive(start))
+		goto no_thread;
+	list_for_each_entry_rcu(tmp, &start->thread_group, thread_group) {
+		if (!thread_group_leader(tmp) && same_thread_group(start, tmp)) {
+			get_task_struct(tmp);
+			pos = tmp;
+			break;
+		}
 	}
+no_thread:
 	rcu_read_unlock();
+	if (!pos)
+		return NULL;
 	put_task_struct(start);
 	return pos;
 }
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3f6a0fcaa10c..4f621e386abf 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -668,11 +668,18 @@ static inline bool thread_group_leader(struct task_struct *p)
 }
 
 static inline
-bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group_account(struct task_struct *p1, struct task_struct *p2)
 {
 	return p1->signal == p2->signal;
 }
 
+static inline
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
+{
+	return same_thread_group_account(p1, p2) &&
+			!((p1->flags | p2->flags) & PF_IO_WORKER);
+}
+
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
 	return list_entry_rcu(p->thread_group.next,
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5f611658eeab..625110cacc2a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -307,7 +307,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	 * those pending times and rely only on values updated on tick or
 	 * other scheduler action.
 	 */
-	if (same_thread_group(current, tsk))
+	if (same_thread_group_account(current, tsk))
 		(void) task_sched_runtime(current);
 
 	rcu_read_lock();

-- 
Jens Axboe

