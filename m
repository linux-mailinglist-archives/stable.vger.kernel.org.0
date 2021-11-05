Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE514468C3
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhKETGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 15:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhKETGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 15:06:07 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F9C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 12:03:26 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d24so15234955wra.0
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 12:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y5p5/3s9+swaH4gGzzKi63N1a5Vk7cEhY+gptCjzn7M=;
        b=h6DGdgZKCgSGCBEpw/dZjb3AOjowVMu6aYKmDl4jAB6tskvarxZbMd20IpIvXo++jC
         oa7U23ia3sCjBGZoUyXFviGE/gZ+q0oTUpq/zG7EeAXF+B1vOZGciLwvnd0LJMM0tQDk
         NXwNfhxHpycCVxmYHAppbBIDCk5ju5qW2wjUVQwB79/LFPnXpxCVgFNzB1bxKVf+oJzh
         DyVn05/vcUrdlWc4oIH6gfncBx1mrdbUBS9pmh/rKYH/65N8kYPpHy3eYaiXpOkAPGWp
         Hwib+g6fophL5tFX1hxpWXRmvIryZZ5yEXZ8elh4rfyxZKW64rZOyZzTbB7dRy7W8Agk
         MPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y5p5/3s9+swaH4gGzzKi63N1a5Vk7cEhY+gptCjzn7M=;
        b=CovfZu2ZpNiJS+pVvRCy2H3c2lfTBm1NUyOhIsl33/25ruWnMXbzpiOFZbIy0rLTOy
         FCuluy7fshuC5f7APsud7NDpddsj99Y0uEJaX3YilunFnL7qu/S4C6v6Noug2KYMs4B0
         0dlyHsNxK5C8l9gPK783mxjplabbThZrtTuLTi6vPVXbTkJ22Aa94t20F4kG+kj6HDMF
         /92nobYYKvvqdlQyZrZa+NLS1Md3FYirUBNX/60yfXtZoVYGMwjENIWD8tTYc4lmxwIX
         j5yJryxHAJL5Sh4wfwwJluZmEAcbqH3svjdXZikTg+nL3lnAieH5Jc6n3MrPj4V4/Oak
         axSg==
X-Gm-Message-State: AOAM533NWn8cknGFWkBiuoMdpHRZQA586CDQKmnot2avyDGIiTXVcVQi
        rWOhfwKd19w0+f/XZNgZaHOjVw==
X-Google-Smtp-Source: ABdhPJyKn24/mSzPKuNNTheO0mmjfjhS2LVFyFyTIPUhbGN5+xokRXbb+qqzdKupkK0AxHhkMDxJ3A==
X-Received: by 2002:adf:e38d:: with SMTP id e13mr54495356wrm.402.1636139005160;
        Fri, 05 Nov 2021 12:03:25 -0700 (PDT)
Received: from ?IPV6:2003:d9:970e:c600:70d7:fd76:b5b5:ab92? (p200300d9970ec60070d7fd76b5b5ab92.dip0.t-ipconnect.de. [2003:d9:970e:c600:70d7:fd76:b5b5:ab92])
        by smtp.googlemail.com with ESMTPSA id z135sm14555571wmc.45.2021.11.05.12.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 12:03:24 -0700 (PDT)
Message-ID: <61ca7331-4a86-2bf6-9ccb-50f6a7824e12@colorfullife.com>
Date:   Fri, 5 Nov 2021 20:03:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] shm: extend forced shm destroy to support objects
 from several IPC nses
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
References: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com>
 <87wnlmqyw4.fsf@disp2133>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <87wnlmqyw4.fsf@disp2133>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On 11/5/21 18:46, Eric W. Biederman wrote:
>
>> -static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
>> +/*
>> + * It has to be called with shp locked.
>> + * It must be called before ipc_rmid()
>> + */
>> +static inline void shm_clist_rm(struct shmid_kernel *shp)
>>   {
>> -	list_del(&s->shm_clist);
>> -	ipc_rmid(&shm_ids(ns), &s->shm_perm);
>> +	struct task_struct *creator;
>> +
>> +	/*
>> +	 * A concurrent exit_shm may do a list_del_init() as well.
>> +	 * Just do nothing if exit_shm already did the work
>> +	 */
>> +	if (list_empty(&shp->shm_clist))
>> +		return;
> This looks like a problem.  With no lock is held the list_empty here is
> fundamentally an optimization.  So the rest of the function should run
> properly if this list_empty is removed.
>
> It does not look to me like the rest of the function will run properly
> if list_empty is removed.
>
> The code needs an rcu_lock or something like that to ensure that
> shm_creator does not go away between the time it is read and when the
> lock is taken.

>> +
>> +	/*
>> +	 * shp->shm_creator is guaranteed to be valid *only*
>> +	 * if shp->shm_clist is not empty.
>> +	 */
>> +	creator = shp->shm_creator;
>> +
>> +	task_lock(creator);
>> +	list_del_init(&shp->shm_clist);
>> +	task_unlock(creator);
>> +}
>> +

You are right!
I had checked the function several times, but I have overlooked the 
simple case. exit_shm() contains:

> task_lock()
> list_del_init()
> task_unlock()
>
> down_write(&shm_ids(ns).rwsem);
> shm_lock_by_ptr(shp);
>
<<< since the shm_clist_rm() is called when holding the shp lock, 
exit_shm() cannot proceed. Thus if !list_empty()) is guarantees that 
->creator will not disappear.

But: for !shm_rmid_forced, there is no lock of shp :-(


>> +static inline void shm_rmid(struct shmid_kernel *s)
>> +{
>> +	shm_clist_rm(s);
>> +	ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
>>   }
>>   
>>   
>> @@ -283,7 +319,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>>   	shm_file = shp->shm_file;
>>   	shp->shm_file = NULL;
>>   	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> -	shm_rmid(ns, shp);
>> +	shm_rmid(shp);
>>   	shm_unlock(shp);
>>   	if (!is_file_hugepages(shm_file))
>>   		shmem_lock(shm_file, 0, shp->mlock_ucounts);
>> @@ -306,10 +342,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>>    *
>>    * 2) sysctl kernel.shm_rmid_forced is set to 1.
>>    */
>> -static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>> +static bool shm_may_destroy(struct shmid_kernel *shp)
>>   {
>>   	return (shp->shm_nattch == 0) &&
>> -	       (ns->shm_rmid_forced ||
>> +	       (shp->ns->shm_rmid_forced ||
>>   		(shp->shm_perm.mode & SHM_DEST));
>>   }
>>   
>> @@ -340,7 +376,7 @@ static void shm_close(struct vm_area_struct *vma)
>>   	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
>>   	shp->shm_dtim = ktime_get_real_seconds();
>>   	shp->shm_nattch--;
>> -	if (shm_may_destroy(ns, shp))
>> +	if (shm_may_destroy(shp))
>>   		shm_destroy(ns, shp);
>>   	else
>>   		shm_unlock(shp);
>> @@ -361,10 +397,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
>>   	 *
>>   	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
>>   	 */
> We should add a comment why testing list_empty here is safe/reliable.
>
> Now that the list deletion is only protected by task_lock it feels like
> this introduces a race.
>
> I don't think the race is meaningful as either the list is non-empty
> or it is empty.  Plus none of the following tests are racy.  So there
> is no danger of an attached segment being destroyed.
It shp can be destroyed, in the sense that ->deleted is set. But this is 
handled.
>> -	if (shp->shm_creator != NULL)
>> +	if (!list_empty(&shp->shm_clist))
>>   		return 0;
>>   
>> -	if (shm_may_destroy(ns, shp)) {
>> +	if (shm_may_destroy(shp)) {
>>   		shm_lock_by_ptr(shp);
>>   		shm_destroy(ns, shp);
>>   	}
>> @@ -382,48 +418,87 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
>>   /* Locking assumes this will only be called with task == current */
>>   void exit_shm(struct task_struct *task)
>>   {
>> -	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
>> -	struct shmid_kernel *shp, *n;
>> +	for (;;) {
>> +		struct shmid_kernel *shp;
>> +		struct ipc_namespace *ns;
>>   
>> -	if (list_empty(&task->sysvshm.shm_clist))
>> -		return;
>> +		task_lock(task);
>> +
>> +		if (list_empty(&task->sysvshm.shm_clist)) {
>> +			task_unlock(task);
>> +			break;
>> +		}
>> +
>> +		shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
>> +				shm_clist);
>> +
>> +		/* 1) unlink */
>> +		list_del_init(&shp->shm_clist);
>                  ^^^^^^^
>                  The code should also clear shm_creator here as well.
>                  So that a stale reference becomes a NULL pointer
>                  dereference instead of use-after-free.  Something like:
list_del_init() already contains a write_once, and that pairs with a 
READ_ONCE() in list_empty.

Using both shp->shm_creator ==NULL and list_empty() as protection 
doesn't help, it can only introduce new races.



> 		/*
>                   * The old shm_creator value will remain valid for
>                   * at least an rcu grace period after this, see
> 		 * put_task_struct_rcu_user.
>                   */
>                   
> 		rcu_assign_pointer(shp->shm_creator, NULL);
>
> This allows shm_clist_rm to look like:
> static inline void shm_clist_rm(struct shmid_kernel *shp)
> {
> 	struct task_struct *creator;
>
> 	rcu_read_lock();
>          creator = rcu_dereference(shp->shm_clist);

We must protect against a parallel: 
exit_sem();<...>;kmem_cache_free(,creator), correct?

No other races are relevant, as shp->shm_creator is written once and 
then never updated.

Thus, my current understanding: We need the rcu_read_lock().

And rcu_read_lock() is sufficient, as release_task ends with 
put_task_struct_rcu_user().

>          if (creator) {
>          	task_lock(creator);
>                  list_del_init(&shp->shm_clist);
>                  task_unlock(creator);
>          }
>          rcu_read_unlock();
> }
> 	
>>   
>> -	/*
>> -	 * If kernel.shm_rmid_forced is not set then only keep track of
>> -	 * which shmids are orphaned, so that a later set of the sysctl
>> -	 * can clean them up.
>> -	 */
>> -	if (!ns->shm_rmid_forced) {
>> -		down_read(&shm_ids(ns).rwsem);
>> -		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
>> -			shp->shm_creator = NULL;
>>   		/*
>> -		 * Only under read lock but we are only called on current
>> -		 * so no entry on the list will be shared.
>> +		 * 2) Get pointer to the ipc namespace. It is worth to say
>> +		 * that this pointer is guaranteed to be valid because
>> +		 * shp lifetime is always shorter than namespace lifetime
>> +		 * in which shp lives.
>> +		 * We taken task_lock it means that shp won't be freed.
>>   		 */
>> -		list_del(&task->sysvshm.shm_clist);
>> -		up_read(&shm_ids(ns).rwsem);
>> -		return;
>> -	}
>> +		ns = shp->ns;
>>   
>> -	/*
>> -	 * Destroy all already created segments, that were not yet mapped,
>> -	 * and mark any mapped as orphan to cover the sysctl toggling.
>> -	 * Destroy is skipped if shm_may_destroy() returns false.
>> -	 */
>> -	down_write(&shm_ids(ns).rwsem);
>> -	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
>> -		shp->shm_creator = NULL;
>> +		/*
>> +		 * 3) If kernel.shm_rmid_forced is not set then only keep track of
>> +		 * which shmids are orphaned, so that a later set of the sysctl
>> +		 * can clean them up.
>> +		 */
>> +		if (!ns->shm_rmid_forced) {
>> +			task_unlock(task);
>> +			continue;
>> +		}
>>   
>> -		if (shm_may_destroy(ns, shp)) {
>> +		/*
>> +		 * 4) get a reference to the namespace.
>> +		 *    The refcount could be already 0. If it is 0, then
>> +		 *    the shm objects will be free by free_ipc_work().
>> +		 */
>> +		ns = get_ipc_ns_not_zero(ns);
>> +		if (ns) {
>                  ^^^^^^^^^
>
>                  This test is probably easier to follow if it was simply:
>                  if (!ns) {
>                  	task_unlock(task);
>                          continue;
>                  }
>
>                  Then the basic logic can all stay at the same
>                  indentation level, and ns does not need to be
>                  tested a second time.
>
>> +			/*
>> +			 * 5) get a reference to the shp itself.
>> +			 *   This cannot fail: shm_clist_rm() is called before
>> +			 *   ipc_rmid(), thus the refcount cannot be 0.
>> +			 */
>> +			WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                          This calls for an ipc_getref that simply calls
>                          refcount_inc.  Then the refcount code can
>                          perform all of the sanity checks for you,
>                          and the WARN_ON becomes unnecessary.
>
>                          Plus the code then documents the fact you know
>                          the refcount must be non-zero here.
>> +		}
>> +
>> +		task_unlock(task);
>> +
>> +		if (ns) {
>> +			down_write(&shm_ids(ns).rwsem);
>>   			shm_lock_by_ptr(shp);
>> -			shm_destroy(ns, shp);
>> +			/*
>> +			 * rcu_read_lock was implicitly taken in
>> +			 * shm_lock_by_ptr, it's safe to call
>> +			 * ipc_rcu_putref here
>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                            This comment should say something like:
>
>                            rcu_read_lock was taken in shm_lock_by_ptr.
>                            With rcu protecting our accesses of shp
>                            holding a reference to shp is unnecessary.
>                            
>> +			 */
>> +			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                          It probably makes most sense just to move
>                          this decrement of the extra reference down to
>                          just before put_ipc_ns.  Removing the need
>                          for the comment and understanding the subtleties
>                          there, and keeping all of the taking and putting
>                          in a consistent order.
>                          
>
>> +
>> +			if (ipc_valid_object(&shp->shm_perm)) {
>> +				if (shm_may_destroy(shp))
>> +					shm_destroy(ns, shp);
>> +				else
>> +					shm_unlock(shp);
>> +			} else {
>> +				/*
>> +				 * Someone else deleted the shp from namespace
>> +				 * idr/kht while we have waited.
>> +				 * Just unlock and continue.
>> +				 */
>> +				shm_unlock(shp);
>> +			}
>> +
>> +			up_write(&shm_ids(ns).rwsem);
>> +			put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
>>   		}
>>   	}
>> -
>> -	/* Remove the list head from any segments still attached. */
>> -	list_del(&task->sysvshm.shm_clist);
>> -	up_write(&shm_ids(ns).rwsem);
>>   }
>>   
>>   static vm_fault_t shm_fault(struct vm_fault *vmf)
>> @@ -680,7 +755,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>>   	if (error < 0)
>>   		goto no_id;
>>   
>> +	shp->ns = ns;
>> +
>> +	task_lock(current);
>>   	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
>> +	task_unlock(current);
>>   
>>   	/*
>>   	 * shmid gets reported as "inode#" in /proc/pid/maps.
>> @@ -1573,7 +1652,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
>>   	down_write(&shm_ids(ns).rwsem);
>>   	shp = shm_lock(ns, shmid);
>>   	shp->shm_nattch--;
>> -	if (shm_may_destroy(ns, shp))
>> +
>> +	if (shm_may_destroy(shp))
>>   		shm_destroy(ns, shp);
>>   	else
>>   		shm_unlock(shp);
> Eric


