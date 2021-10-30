Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9B7440905
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhJ3NOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJ3NOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 09:14:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97391C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 06:11:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r8so8241150wra.7
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 06:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=BweyXDb8pENScXKEN7X+5pvEtlDzn4voGIPfnEgyxBo=;
        b=R9e+ukzKWP5y1i7y5OduNuu9VMMORTwBdHkG5rXpCNe1RZ3zenJ4QPgcO5QAXxMxoE
         YFuWH1YIG9VkFPXX9KviRyMA9u7PFnIDTdFe34YmEloqedmxHyVawyRaGkshnwvhC5c0
         X5S+gG7R+wmBbLWDXfASEZwZUAa111IqQBWBM9AQdkdBt6xoy6Zy1PQEBon2qvRUWhz1
         C/vlF+4kyiZt4pPBgd8nRgI0bpajS02KorExbukBCXe1L/2ZhZFKxIpMEbTz6mMNKV/V
         rmFOpmHJxsI0w8eE/llZvJSeQyMB3JV5JF55EsX9Zjd6NsHRT9Si9/Yer4iXTk4Vf6vv
         pQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=BweyXDb8pENScXKEN7X+5pvEtlDzn4voGIPfnEgyxBo=;
        b=WbasusWlpCahYbN90vwT4ANt2mLg532DE6vP1HOdTR2Q+nGcL6WUH8Jn+uNbS7xyGr
         tr2raD05997duyvXGMXqJd4NUbc9+m84mhfitMm7CzL6zJxzphjL+PgO3CjfweLtgi9T
         maaihW1TM0/FvWHLm4Om7WG0zJWRWo0n+KsKk+88xOaeYdIcJVBMwKxI6Kbb4VPingy4
         oY8Rlgs5kJthTyl5kSlnxWrvZeHye4Iv4okqoCVFM3VwDN6n2b8DNv6BP0t1XR061m0X
         b/QzR8LtwqLRn6+4NxJ9saJOIlocysogyj8wE0cw9Mc3jW2Xk66trtF8CW7xM8yPr32m
         No+w==
X-Gm-Message-State: AOAM531d53gWb27eKgBB1bo7UgDAlz7zLkmsDAf8XDFzhAJVu0pUI5Ti
        DaJvASzpTEtHzYeumEP8qvgPdeA28LE8iqDGd18=
X-Google-Smtp-Source: ABdhPJyFbSgpEtXFwFcwlWoZXKgI0Y+bhwFqE2Zv5z2M7NGbPuFSzp3OYn6zTPOm0k60NGQWeGDPug==
X-Received: by 2002:adf:f48d:: with SMTP id l13mr22471366wro.94.1635599507106;
        Sat, 30 Oct 2021 06:11:47 -0700 (PDT)
Received: from ?IPV6:2003:d9:973c:7000:3d32:1275:61f:ae2? (p200300d9973c70003d321275061f0ae2.dip0.t-ipconnect.de. [2003:d9:973c:7000:3d32:1275:61f:ae2])
        by smtp.googlemail.com with ESMTPSA id u6sm7318316wmc.29.2021.10.30.06.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Oct 2021 06:11:46 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------QPtkF8yHY6tv2bPLk5OOzrzn"
Message-ID: <8a5d8ac1-327d-cee0-150a-3ec152134351@colorfullife.com>
Date:   Sat, 30 Oct 2021 15:11:44 +0200
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
 <878rybcf41.fsf@disp2133>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <878rybcf41.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------QPtkF8yHY6tv2bPLk5OOzrzn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/30/21 06:26, Eric W. Biederman wrote:
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> writes:
>
>> Currently, exit_shm function not designed to work properly when
>> task->sysvshm.shm_clist holds shm objects from different IPC namespaces.
>>
>> This is a real pain when sysctl kernel.shm_rmid_forced = 1, because
>> it leads to use-after-free (reproducer exists).
>>
>> That particular patch is attempt to fix the problem by extending exit_shm
>> mechanism to handle shm's destroy from several IPC ns'es.
>>
>> To achieve that we do several things:
>> 1. add namespace (non-refcounted) pointer to the struct shmid_kernel
>> 2. during new shm object creation (newseg()/shmget syscall) we initialize
>> this pointer by current task IPC ns
>> 3. exit_shm() fully reworked such that it traverses over all
>> shp's in task->sysvshm.shm_clist and gets IPC namespace not
>> from current task as it was before but from shp's object itself, then
>> call shm_destroy(shp, ns).
>>
>> Note. We need to be really careful here, because as it was said before
>> (1), our pointer to IPC ns non-refcnt'ed. To be on the safe side we using
>> special helper get_ipc_ns_not_zero() which allows to get IPC ns refcounter
>> only if IPC ns not in the "state of destruction".
>
>
>
>> Q/A
>>
>> Q: Why we can access shp->ns memory using non-refcounted pointer?
>> A: Because shp object lifetime is always shorther
>> than IPC namespace lifetime, so, if we get shp object from the
>> task->sysvshm.shm_clist while holding task_lock(task) nobody can
>> steal our namespace.
> Not true.  A struct shmid_kernel can outlive the namespace in which it
> was created.  I you look at do_shm_rmid which is called when the
> namespace is destroyed for every shmid_kernel in the namespace that if
> the struct shmid_kernel still has users only ipc_set_key_private is
> called.  The struct shmid_kernel continues to exist.

No, shm_nattach is always 0 when a namespace is destroyed.

Thus it is impossible that shmid_kernel continues to exist.

Let's check all shm_nattach modifications:

1) do_shmat:

     shp->shm_nattach++;

     sfd->ns = get_ipc_ns(ns);

     shp->shm_nattach--;

pairs with

    shm_release()

         put_ipc_ns()

2) shm_open()

only shp->shm_nattach++

shm_open unconditionally accesses shm_file_data, i.e. sfd must be valid, 
there must be a reference to the namespace

pairs with shm_close()

only shp->shm_nattach--;

shm_close unconditionally accesses shm_file_data, i.e. sfd must be 
valid, there must be a reference to the namespace

As shm_open()/close "nests" inside do_shmat: there is always a get_ipc_ns().

Or, much simpler: Check shm_open() and shm_close():

These two functions address a shm segment by namespace and  ID, not by a 
shm pointer. Thus _if_ it is possible that shm_nattach is > 0 at 
namespace destruction, then there would be far more issues.


Or: Attached is a log file, a test application, and a patch that adds 
pr_info statements.

The namespace is destroyed immediately when no segments are mapped, the 
destruction is delayed until exit() if there are mapped segments.


>> Q: Does this patch change semantics of unshare/setns/clone syscalls?
>> A: Not. It's just fixes non-covered case when process may leave
>> IPC namespace without getting task->sysvshm.shm_clist list cleaned up.
>
> Just reading through exit_shm the code is not currently safe.
>
> At a minimum do_shm_rmid needs to set the shp->ns to NULL.  Otherwise
> the struct shmid_kernel can contain a namespace pointer after
> the namespace exits.  Which results in a different use after free.
No [unless there are additional bugs]
>
> Beyond that there is dropping the task lock.  The code holds a reference
> to the namespace which means that the code does not need to worry about
> free_ipcs.  References from mappings are still possible.
>
> Which means that the code could see:
> exit_shm()
>     task_lock()
>     shp = ...;

>     task_unlock()
>                                       shm_close()
>                                           down_write(&shm_ids(ns).rwsem);
>                                           ...
>                                           shm_destroy(shp);
>                                           up_write(&shm_ids(ns).rwsem);
>     down_write(&shm_ids(ns)->rwsem);
>     shm_lock_by_ptr(shp);	/* use after free */
>
>
> I am trying to imagine how to close that race with the current code
> structure.  Maybe something could be done by looking at shm_nattach
> count and making it safe to look at that count under the task_lock.

There is no race. Before dropping task_lock, a reference to both the 
namespace and the shp pointer is obtained.

Thus neither one can disappear.

> But even then because shmid_kernel is still in the hash table it could
> be mapped and unmapped in the window when task_lock was dropped.

We have ipc_valid_object(), i.e. perm->deleted. If set, then the pointer 
and the spinlock are valid, even though the rest is already destroyed.

ipc_rmid() just sets deleted, the (rcu delayed) kfree is done via 
ipc_rcu_putref().
> Alternatively shmctl(id, IPC_RMID) can be called in when task_lock is
> dropped.  Much less code is involved than mapping and unmapping so it is
> much more likely to win the race.
>
> I don't see how that race can be closed.
>
> Am I missing something?
>
> Eric
>
>
>> Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
>>
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: Andrei Vagin <avagin@gmail.com>
>> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> Cc: Vasily Averin <vvs@virtuozzo.com>
>> Cc: Manfred Spraul <manfred@colorfullife.com>
>> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
>> Cc: stable@vger.kernel.org
>> Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
>> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
>> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

Should/can I mark that I have tested the code?

I would drop one change and one comment is incorrect, otherwise no 
findings. See the attached 0002 patch

Tested-by: Manfred Spraul <manfred@colorfullife.com>

>> ---
>>   include/linux/ipc_namespace.h |  15 +++
>>   include/linux/sched/task.h    |   2 +-
>>   include/linux/shm.h           |   2 +-
>>   ipc/shm.c                     | 170 +++++++++++++++++++++++++---------
>>   4 files changed, 142 insertions(+), 47 deletions(-)
>>
>> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
>> index 05e22770af51..b75395ec8d52 100644
>> --- a/include/linux/ipc_namespace.h
>> +++ b/include/linux/ipc_namespace.h
>> @@ -131,6 +131,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
>>   	return ns;
>>   }
>>   
>> +static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
>> +{
>> +	if (ns) {
>> +		if (refcount_inc_not_zero(&ns->ns.count))
>> +			return ns;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   extern void put_ipc_ns(struct ipc_namespace *ns);
>>   #else
>>   static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
>> @@ -147,6 +157,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
>>   	return ns;
>>   }
>>   
>> +static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
>> +{
>> +	return ns;
>> +}
>> +
>>   static inline void put_ipc_ns(struct ipc_namespace *ns)
>>   {
>>   }
>> diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
>> index ef02be869cf2..bfdf84dab4be 100644
>> --- a/include/linux/sched/task.h
>> +++ b/include/linux/sched/task.h
>> @@ -157,7 +157,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
>>    * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
>>    * subscriptions and synchronises with wait4().  Also used in procfs.  Also
>>    * pins the final release of task.io_context.  Also protects ->cpuset and
>> - * ->cgroup.subsys[]. And ->vfork_done.
>> + * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
>>    *
>>    * Nests both inside and outside of read_lock(&tasklist_lock).
>>    * It must not be nested with write_lock_irq(&tasklist_lock),
>> diff --git a/include/linux/shm.h b/include/linux/shm.h
>> index d8e69aed3d32..709f6d0451c0 100644
>> --- a/include/linux/shm.h
>> +++ b/include/linux/shm.h
>> @@ -11,7 +11,7 @@ struct file;
>>   
>>   #ifdef CONFIG_SYSVIPC
>>   struct sysv_shm {
>> -	struct list_head shm_clist;
>> +	struct list_head	shm_clist;
>>   };
>>   
This is a whitespace only change. We can drop it.
>>   long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
>> diff --git a/ipc/shm.c b/ipc/shm.c
>> index 748933e376ca..29667e17b12a 100644
>> --- a/ipc/shm.c
>> +++ b/ipc/shm.c
>> @@ -62,9 +62,18 @@ struct shmid_kernel /* private to the kernel */
>>   	struct pid		*shm_lprid;
>>   	struct ucounts		*mlock_ucounts;
>>   
>> -	/* The task created the shm object.  NULL if the task is dead. */
>> +	/*
>> +	 * The task created the shm object, for looking up
>> +	 * task->sysvshm.shm_clist_lock
>> +	 */
>>   	struct task_struct	*shm_creator;
>> -	struct list_head	shm_clist;	/* list by creator */
>> +
>> +	/*
>> +	 * list by creator. shm_clist_lock required for read/write
>> +	 * if list_empty(), then the creator is dead already
>> +	 */
shm_clist_lock was replaced by task_lock(->shm_creator).
>> +	struct list_head	shm_clist;
>> +	struct ipc_namespace	*ns;
>>   } __randomize_layout;
>>   
>>   /* shm_mode upper byte flags */
>> @@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>>   	struct shmid_kernel *shp;
>>   
>>   	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
>> +	WARN_ON(ns != shp->ns);
>>   
>>   	if (shp->shm_nattch) {
>>   		shp->shm_perm.mode |= SHM_DEST;
>> @@ -225,10 +235,36 @@ static void shm_rcu_free(struct rcu_head *head)
>>   	kfree(shp);
>>   }
>>   
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
> Lock ordering
>     rwsem
>         ipc_lock
>            task_lock
>         
correct.
>> +}
>> +
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
>> +			/*
>> +			 * 5) get a reference to the shp itself.
>> +			 *   This cannot fail: shm_clist_rm() is called before
>> +			 *   ipc_rmid(), thus the refcount cannot be 0.
>> +			 */
>> +			WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
>> +		}
>> +
>> +		task_unlock(task);
> <<<<<<<<< BOOM >>>>>>>
>
> I don't see anything that prevents another task from
> calling shm_destroy(ns, shp) here and freeing it before
> this task can take the rwsem for writing.

shm_destroy() can be called. But due to the ipc_rcu_getref(), the 
structure will remain valid.


>> +
>> +		if (ns) {
>> +			down_write(&shm_ids(ns).rwsem);
>>   			shm_lock_by_ptr(shp);
>> -			shm_destroy(ns, shp);
>> +			/*
>> +			 * rcu_read_lock was implicitly taken in
>> +			 * shm_lock_by_ptr, it's safe to call
>> +			 * ipc_rcu_putref here
>> +			 */
>> +			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
>> +
>> +			if (ipc_valid_object(&shp->shm_perm)) {

And this will return false if there was a shm_destroy().


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

-> just do a NOP if shm_destroy() was alread performed.

Actually, the same design is used by find_alloc_undo() in ipc/sem.c.

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


--------------QPtkF8yHY6tv2bPLk5OOzrzn
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-shm-extend-forced-shm-destroy-to-support-objects-fro.patch"
Content-Disposition: attachment;
 filename*0="0002-shm-extend-forced-shm-destroy-to-support-objects-fro.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBjOWIwYjUwMzc4NjVhYTc3MTRiMGU3Yzk2MDgyZTAyOTZkOGE0MmI5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4YW5kZXIgTWlraGFsaXRzeW4gPGFsZXhhbmRl
ci5taWtoYWxpdHN5bkB2aXJ0dW96em8uY29tPgpEYXRlOiBUaHUsIDI4IE9jdCAyMDIxIDAx
OjQzOjQ4ICswMzAwClN1YmplY3Q6IFtQQVRDSCAyLzNdIHNobTogZXh0ZW5kIGZvcmNlZCBz
aG0gZGVzdHJveSB0byBzdXBwb3J0IG9iamVjdHMgZnJvbQogc2V2ZXJhbCBJUEMgbnNlcwoK
Q3VycmVudGx5LCBleGl0X3NobSBmdW5jdGlvbiBub3QgZGVzaWduZWQgdG8gd29yayBwcm9w
ZXJseSB3aGVuCnRhc2stPnN5c3ZzaG0uc2htX2NsaXN0IGhvbGRzIHNobSBvYmplY3RzIGZy
b20gZGlmZmVyZW50IElQQyBuYW1lc3BhY2VzLgoKVGhpcyBpcyBhIHJlYWwgcGFpbiB3aGVu
IHN5c2N0bCBrZXJuZWwuc2htX3JtaWRfZm9yY2VkID0gMSwgYmVjYXVzZQppdCBsZWFkcyB0
byB1c2UtYWZ0ZXItZnJlZSAocmVwcm9kdWNlciBleGlzdHMpLgoKVGhhdCBwYXJ0aWN1bGFy
IHBhdGNoIGlzIGF0dGVtcHQgdG8gZml4IHRoZSBwcm9ibGVtIGJ5IGV4dGVuZGluZyBleGl0
X3NobQptZWNoYW5pc20gdG8gaGFuZGxlIHNobSdzIGRlc3Ryb3kgZnJvbSBzZXZlcmFsIElQ
QyBucydlcy4KClRvIGFjaGlldmUgdGhhdCB3ZSBkbyBzZXZlcmFsIHRoaW5nczoKMS4gYWRk
IG5hbWVzcGFjZSAobm9uLXJlZmNvdW50ZWQpIHBvaW50ZXIgdG8gdGhlIHN0cnVjdCBzaG1p
ZF9rZXJuZWwKMi4gZHVyaW5nIG5ldyBzaG0gb2JqZWN0IGNyZWF0aW9uIChuZXdzZWcoKS9z
aG1nZXQgc3lzY2FsbCkgd2UgaW5pdGlhbGl6ZQp0aGlzIHBvaW50ZXIgYnkgY3VycmVudCB0
YXNrIElQQyBucwozLiBleGl0X3NobSgpIGZ1bGx5IHJld29ya2VkIHN1Y2ggdGhhdCBpdCB0
cmF2ZXJzZXMgb3ZlciBhbGwKc2hwJ3MgaW4gdGFzay0+c3lzdnNobS5zaG1fY2xpc3QgYW5k
IGdldHMgSVBDIG5hbWVzcGFjZSBub3QKZnJvbSBjdXJyZW50IHRhc2sgYXMgaXQgd2FzIGJl
Zm9yZSBidXQgZnJvbSBzaHAncyBvYmplY3QgaXRzZWxmLCB0aGVuCmNhbGwgc2htX2Rlc3Ry
b3koc2hwLCBucykuCgpOb3RlLiBXZSBuZWVkIHRvIGJlIHJlYWxseSBjYXJlZnVsIGhlcmUs
IGJlY2F1c2UgYXMgaXQgd2FzIHNhaWQgYmVmb3JlCigxKSwgb3VyIHBvaW50ZXIgdG8gSVBD
IG5zIG5vbi1yZWZjbnQnZWQuIFRvIGJlIG9uIHRoZSBzYWZlIHNpZGUgd2UgdXNpbmcKc3Bl
Y2lhbCBoZWxwZXIgZ2V0X2lwY19uc19ub3RfemVybygpIHdoaWNoIGFsbG93cyB0byBnZXQg
SVBDIG5zIHJlZmNvdW50ZXIKb25seSBpZiBJUEMgbnMgbm90IGluIHRoZSAic3RhdGUgb2Yg
ZGVzdHJ1Y3Rpb24iLgoKUS9BCgpROiBXaHkgd2UgY2FuIGFjY2VzcyBzaHAtPm5zIG1lbW9y
eSB1c2luZyBub24tcmVmY291bnRlZCBwb2ludGVyPwpBOiBCZWNhdXNlIHNocCBvYmplY3Qg
bGlmZXRpbWUgaXMgYWx3YXlzIHNob3J0aGVyCnRoYW4gSVBDIG5hbWVzcGFjZSBsaWZldGlt
ZSwgc28sIGlmIHdlIGdldCBzaHAgb2JqZWN0IGZyb20gdGhlCnRhc2stPnN5c3ZzaG0uc2ht
X2NsaXN0IHdoaWxlIGhvbGRpbmcgdGFza19sb2NrKHRhc2spIG5vYm9keSBjYW4Kc3RlYWwg
b3VyIG5hbWVzcGFjZS4KClE6IERvZXMgdGhpcyBwYXRjaCBjaGFuZ2Ugc2VtYW50aWNzIG9m
IHVuc2hhcmUvc2V0bnMvY2xvbmUgc3lzY2FsbHM/CkE6IE5vdC4gSXQncyBqdXN0IGZpeGVz
IG5vbi1jb3ZlcmVkIGNhc2Ugd2hlbiBwcm9jZXNzIG1heSBsZWF2ZQpJUEMgbmFtZXNwYWNl
IHdpdGhvdXQgZ2V0dGluZyB0YXNrLT5zeXN2c2htLnNobV9jbGlzdCBsaXN0IGNsZWFuZWQg
dXAuCgpGaXhlczogYWI2MDJmNzk5MTUgKCJzaG06IG1ha2UgZXhpdF9zaG0gd29yayBwcm9w
b3J0aW9uYWwgdG8gdGFzayBhY3Rpdml0eSIpCgpDYzogIkVyaWMgVy4gQmllZGVybWFuIiA8
ZWJpZWRlcm1AeG1pc3Npb24uY29tPgpDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1m
b3VuZGF0aW9uLm9yZz4KQ2M6IERhdmlkbG9ociBCdWVzbyA8ZGF2ZUBzdGdvbGFicy5uZXQ+
CkNjOiBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4KQ2M6IEFuZHJlaSBW
YWdpbiA8YXZhZ2luQGdtYWlsLmNvbT4KQ2M6IFBhdmVsIFRpa2hvbWlyb3YgPHB0aWtob21p
cm92QHZpcnR1b3p6by5jb20+CkNjOiBWYXNpbHkgQXZlcmluIDx2dnNAdmlydHVvenpvLmNv
bT4KQ2M6IE1hbmZyZWQgU3ByYXVsIDxtYW5mcmVkQGNvbG9yZnVsbGlmZS5jb20+CkNjOiBB
bGV4YW5kZXIgTWlraGFsaXRzeW4gPGFsZXhhbmRlckBtaWhhbGljeW4uY29tPgpDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZwpDby1kZXZlbG9wZWQtYnk6IE1hbmZyZWQgU3ByYXVsIDxt
YW5mcmVkQGNvbG9yZnVsbGlmZS5jb20+ClNpZ25lZC1vZmYtYnk6IE1hbmZyZWQgU3ByYXVs
IDxtYW5mcmVkQGNvbG9yZnVsbGlmZS5jb20+ClNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBN
aWtoYWxpdHN5biA8YWxleGFuZGVyLm1pa2hhbGl0c3luQHZpcnR1b3p6by5jb20+Ci0tLQog
aW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmggfCAgMTUgKysrCiBpbmNsdWRlL2xpbnV4
L3NjaGVkL3Rhc2suaCAgICB8ICAgMiArLQogaW5jbHVkZS9saW51eC9zaG0uaCAgICAgICAg
ICAgfCAgIDIgKy0KIGlwYy9zaG0uYyAgICAgICAgICAgICAgICAgICAgIHwgMTcwICsrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIDQgZmlsZXMgY2hhbmdlZCwgMTQyIGlu
c2VydGlvbnMoKyksIDQ3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvaXBjX25hbWVzcGFjZS5oIGIvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKaW5k
ZXggMDVlMjI3NzBhZjUxLi5iNzUzOTVlYzhkNTIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGlu
dXgvaXBjX25hbWVzcGFjZS5oCisrKyBiL2luY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5o
CkBAIC0xMzEsNiArMTMxLDE2IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IGlwY19uYW1lc3Bh
Y2UgKmdldF9pcGNfbnMoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zKQogCXJldHVybiBuczsK
IH0KIAorc3RhdGljIGlubGluZSBzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqZ2V0X2lwY19uc19u
b3RfemVybyhzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMpCit7CisJaWYgKG5zKSB7CisJCWlm
IChyZWZjb3VudF9pbmNfbm90X3plcm8oJm5zLT5ucy5jb3VudCkpCisJCQlyZXR1cm4gbnM7
CisJfQorCisJcmV0dXJuIE5VTEw7Cit9CisKIGV4dGVybiB2b2lkIHB1dF9pcGNfbnMoc3Ry
dWN0IGlwY19uYW1lc3BhY2UgKm5zKTsKICNlbHNlCiBzdGF0aWMgaW5saW5lIHN0cnVjdCBp
cGNfbmFtZXNwYWNlICpjb3B5X2lwY3ModW5zaWduZWQgbG9uZyBmbGFncywKQEAgLTE0Nyw2
ICsxNTcsMTEgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqZ2V0X2lw
Y19ucyhzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMpCiAJcmV0dXJuIG5zOwogfQogCitzdGF0
aWMgaW5saW5lIHN0cnVjdCBpcGNfbmFtZXNwYWNlICpnZXRfaXBjX25zX25vdF96ZXJvKHN0
cnVjdCBpcGNfbmFtZXNwYWNlICpucykKK3sKKwlyZXR1cm4gbnM7Cit9CisKIHN0YXRpYyBp
bmxpbmUgdm9pZCBwdXRfaXBjX25zKHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucykKIHsKIH0K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2NoZWQvdGFzay5oIGIvaW5jbHVkZS9saW51
eC9zY2hlZC90YXNrLmgKaW5kZXggZWYwMmJlODY5Y2YyLi5iZmRmODRkYWI0YmUgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQvdGFzay5oCisrKyBiL2luY2x1ZGUvbGludXgv
c2NoZWQvdGFzay5oCkBAIC0xNTcsNyArMTU3LDcgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qg
dm1fc3RydWN0ICp0YXNrX3N0YWNrX3ZtX2FyZWEoY29uc3Qgc3RydWN0IHRhc2tfc3RydWN0
ICp0KQogICogUHJvdGVjdHMgLT5mcywgLT5maWxlcywgLT5tbSwgLT5ncm91cF9pbmZvLCAt
PmNvbW0sIGtleXJpbmcKICAqIHN1YnNjcmlwdGlvbnMgYW5kIHN5bmNocm9uaXNlcyB3aXRo
IHdhaXQ0KCkuICBBbHNvIHVzZWQgaW4gcHJvY2ZzLiAgQWxzbwogICogcGlucyB0aGUgZmlu
YWwgcmVsZWFzZSBvZiB0YXNrLmlvX2NvbnRleHQuICBBbHNvIHByb3RlY3RzIC0+Y3B1c2V0
IGFuZAotICogLT5jZ3JvdXAuc3Vic3lzW10uIEFuZCAtPnZmb3JrX2RvbmUuCisgKiAtPmNn
cm91cC5zdWJzeXNbXS4gQW5kIC0+dmZvcmtfZG9uZS4gQW5kIC0+c3lzdnNobS5zaG1fY2xp
c3QuCiAgKgogICogTmVzdHMgYm90aCBpbnNpZGUgYW5kIG91dHNpZGUgb2YgcmVhZF9sb2Nr
KCZ0YXNrbGlzdF9sb2NrKS4KICAqIEl0IG11c3Qgbm90IGJlIG5lc3RlZCB3aXRoIHdyaXRl
X2xvY2tfaXJxKCZ0YXNrbGlzdF9sb2NrKSwKZGlmZiAtLWdpdCBhL2lwYy9zaG0uYyBiL2lw
Yy9zaG0uYwppbmRleCBhYjc0OWJlNmQ4YjcuLmViYjI1YThlY2M1OCAxMDA2NDQKLS0tIGEv
aXBjL3NobS5jCisrKyBiL2lwYy9zaG0uYwpAQCAtNjIsOSArNjIsMTggQEAgc3RydWN0IHNo
bWlkX2tlcm5lbCAvKiBwcml2YXRlIHRvIHRoZSBrZXJuZWwgKi8KIAlzdHJ1Y3QgcGlkCQkq
c2htX2xwcmlkOwogCXN0cnVjdCB1Y291bnRzCQkqbWxvY2tfdWNvdW50czsKIAotCS8qIFRo
ZSB0YXNrIGNyZWF0ZWQgdGhlIHNobSBvYmplY3QuICBOVUxMIGlmIHRoZSB0YXNrIGlzIGRl
YWQuICovCisJLyoKKwkgKiBUaGUgdGFzayBjcmVhdGVkIHRoZSBzaG0gb2JqZWN0LCBmb3Ig
bG9va2luZyB1cAorCSAqIHRhc2stPnN5c3ZzaG0uc2htX2NsaXN0X2xvY2sKKwkgKi8KIAlz
dHJ1Y3QgdGFza19zdHJ1Y3QJKnNobV9jcmVhdG9yOwotCXN0cnVjdCBsaXN0X2hlYWQJc2ht
X2NsaXN0OwkvKiBsaXN0IGJ5IGNyZWF0b3IgKi8KKworCS8qCisJICogTGlzdCBieSBjcmVh
dG9yLiB0YXNrX2xvY2soLT5zaG1fY3JlYXRvcikgcmVxdWlyZWQgZm9yIHJlYWQvd3JpdGUu
CisJICogSWYgbGlzdF9lbXB0eSgpLCB0aGVuIHRoZSBjcmVhdG9yIGlzIGRlYWQgYWxyZWFk
eS4KKwkgKi8KKwlzdHJ1Y3QgbGlzdF9oZWFkCXNobV9jbGlzdDsKKwlzdHJ1Y3QgaXBjX25h
bWVzcGFjZQkqbnM7CiB9IF9fcmFuZG9taXplX2xheW91dDsKIAogLyogc2htX21vZGUgdXBw
ZXIgYnl0ZSBmbGFncyAqLwpAQCAtMTE1LDYgKzEyNCw3IEBAIHN0YXRpYyB2b2lkIGRvX3No
bV9ybWlkKHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGtlcm5faXBjX3Blcm0g
KmlwY3ApCiAJc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwOwogCiAJc2hwID0gY29udGFpbmVy
X29mKGlwY3AsIHN0cnVjdCBzaG1pZF9rZXJuZWwsIHNobV9wZXJtKTsKKwlXQVJOX09OKG5z
ICE9IHNocC0+bnMpOwogCiAJaWYgKHNocC0+c2htX25hdHRjaCkgewogCQlzaHAtPnNobV9w
ZXJtLm1vZGUgfD0gU0hNX0RFU1Q7CkBAIC0yMjUsMTAgKzIzNSwzNiBAQCBzdGF0aWMgdm9p
ZCBzaG1fcmN1X2ZyZWUoc3RydWN0IHJjdV9oZWFkICpoZWFkKQogCWtmcmVlKHNocCk7CiB9
CiAKLXN0YXRpYyBpbmxpbmUgdm9pZCBzaG1fcm1pZChzdHJ1Y3QgaXBjX25hbWVzcGFjZSAq
bnMsIHN0cnVjdCBzaG1pZF9rZXJuZWwgKnMpCisvKgorICogSXQgaGFzIHRvIGJlIGNhbGxl
ZCB3aXRoIHNocCBsb2NrZWQuCisgKiBJdCBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgaXBjX3Jt
aWQoKQorICovCitzdGF0aWMgaW5saW5lIHZvaWQgc2htX2NsaXN0X3JtKHN0cnVjdCBzaG1p
ZF9rZXJuZWwgKnNocCkKIHsKLQlsaXN0X2RlbCgmcy0+c2htX2NsaXN0KTsKLQlpcGNfcm1p
ZCgmc2htX2lkcyhucyksICZzLT5zaG1fcGVybSk7CisJc3RydWN0IHRhc2tfc3RydWN0ICpj
cmVhdG9yOworCisJLyoKKwkgKiBBIGNvbmN1cnJlbnQgZXhpdF9zaG0gbWF5IGRvIGEgbGlz
dF9kZWxfaW5pdCgpIGFzIHdlbGwuCisJICogSnVzdCBkbyBub3RoaW5nIGlmIGV4aXRfc2ht
IGFscmVhZHkgZGlkIHRoZSB3b3JrCisJICovCisJaWYgKGxpc3RfZW1wdHkoJnNocC0+c2ht
X2NsaXN0KSkKKwkJcmV0dXJuOworCisJLyoKKwkgKiBzaHAtPnNobV9jcmVhdG9yIGlzIGd1
YXJhbnRlZWQgdG8gYmUgdmFsaWQgKm9ubHkqCisJICogaWYgc2hwLT5zaG1fY2xpc3QgaXMg
bm90IGVtcHR5LgorCSAqLworCWNyZWF0b3IgPSBzaHAtPnNobV9jcmVhdG9yOworCisJdGFz
a19sb2NrKGNyZWF0b3IpOworCWxpc3RfZGVsX2luaXQoJnNocC0+c2htX2NsaXN0KTsKKwl0
YXNrX3VubG9jayhjcmVhdG9yKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIHNobV9ybWlk
KHN0cnVjdCBzaG1pZF9rZXJuZWwgKnMpCit7CisJc2htX2NsaXN0X3JtKHMpOworCWlwY19y
bWlkKCZzaG1faWRzKHMtPm5zKSwgJnMtPnNobV9wZXJtKTsKIH0KIAogCkBAIC0yODMsNyAr
MzE5LDcgQEAgc3RhdGljIHZvaWQgc2htX2Rlc3Ryb3koc3RydWN0IGlwY19uYW1lc3BhY2Ug
Km5zLCBzdHJ1Y3Qgc2htaWRfa2VybmVsICpzaHApCiAJc2htX2ZpbGUgPSBzaHAtPnNobV9m
aWxlOwogCXNocC0+c2htX2ZpbGUgPSBOVUxMOwogCW5zLT5zaG1fdG90IC09IChzaHAtPnNo
bV9zZWdzeiArIFBBR0VfU0laRSAtIDEpID4+IFBBR0VfU0hJRlQ7Ci0Jc2htX3JtaWQobnMs
IHNocCk7CisJc2htX3JtaWQoc2hwKTsKIAlzaG1fdW5sb2NrKHNocCk7CiAJaWYgKCFpc19m
aWxlX2h1Z2VwYWdlcyhzaG1fZmlsZSkpCiAJCXNobWVtX2xvY2soc2htX2ZpbGUsIDAsIHNo
cC0+bWxvY2tfdWNvdW50cyk7CkBAIC0zMDYsMTAgKzM0MiwxMCBAQCBzdGF0aWMgdm9pZCBz
aG1fZGVzdHJveShzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMsIHN0cnVjdCBzaG1pZF9rZXJu
ZWwgKnNocCkKICAqCiAgKiAyKSBzeXNjdGwga2VybmVsLnNobV9ybWlkX2ZvcmNlZCBpcyBz
ZXQgdG8gMS4KICAqLwotc3RhdGljIGJvb2wgc2htX21heV9kZXN0cm95KHN0cnVjdCBpcGNf
bmFtZXNwYWNlICpucywgc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwKQorc3RhdGljIGJvb2wg
c2htX21heV9kZXN0cm95KHN0cnVjdCBzaG1pZF9rZXJuZWwgKnNocCkKIHsKIAlyZXR1cm4g
KHNocC0+c2htX25hdHRjaCA9PSAwKSAmJgotCSAgICAgICAobnMtPnNobV9ybWlkX2ZvcmNl
ZCB8fAorCSAgICAgICAoc2hwLT5ucy0+c2htX3JtaWRfZm9yY2VkIHx8CiAJCShzaHAtPnNo
bV9wZXJtLm1vZGUgJiBTSE1fREVTVCkpOwogfQogCkBAIC0zNDAsNyArMzc2LDcgQEAgc3Rh
dGljIHZvaWQgc2htX2Nsb3NlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQogCWlwY191
cGRhdGVfcGlkKCZzaHAtPnNobV9scHJpZCwgdGFza190Z2lkKGN1cnJlbnQpKTsKIAlzaHAt
PnNobV9kdGltID0ga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpOwogCXNocC0+c2htX25hdHRj
aC0tOwotCWlmIChzaG1fbWF5X2Rlc3Ryb3kobnMsIHNocCkpCisJaWYgKHNobV9tYXlfZGVz
dHJveShzaHApKQogCQlzaG1fZGVzdHJveShucywgc2hwKTsKIAllbHNlCiAJCXNobV91bmxv
Y2soc2hwKTsKQEAgLTM2MSwxMCArMzk3LDEwIEBAIHN0YXRpYyBpbnQgc2htX3RyeV9kZXN0
cm95X29ycGhhbmVkKGludCBpZCwgdm9pZCAqcCwgdm9pZCAqZGF0YSkKIAkgKgogCSAqIEFz
IHNocC0+KiBhcmUgY2hhbmdlZCB1bmRlciByd3NlbSwgaXQncyBzYWZlIHRvIHNraXAgc2hw
IGxvY2tpbmcuCiAJICovCi0JaWYgKHNocC0+c2htX2NyZWF0b3IgIT0gTlVMTCkKKwlpZiAo
IWxpc3RfZW1wdHkoJnNocC0+c2htX2NsaXN0KSkKIAkJcmV0dXJuIDA7CiAKLQlpZiAoc2ht
X21heV9kZXN0cm95KG5zLCBzaHApKSB7CisJaWYgKHNobV9tYXlfZGVzdHJveShzaHApKSB7
CiAJCXNobV9sb2NrX2J5X3B0cihzaHApOwogCQlzaG1fZGVzdHJveShucywgc2hwKTsKIAl9
CkBAIC0zODIsNDggKzQxOCw4NyBAQCB2b2lkIHNobV9kZXN0cm95X29ycGhhbmVkKHN0cnVj
dCBpcGNfbmFtZXNwYWNlICpucykKIC8qIExvY2tpbmcgYXNzdW1lcyB0aGlzIHdpbGwgb25s
eSBiZSBjYWxsZWQgd2l0aCB0YXNrID09IGN1cnJlbnQgKi8KIHZvaWQgZXhpdF9zaG0oc3Ry
dWN0IHRhc2tfc3RydWN0ICp0YXNrKQogewotCXN0cnVjdCBpcGNfbmFtZXNwYWNlICpucyA9
IHRhc2stPm5zcHJveHktPmlwY19uczsKLQlzdHJ1Y3Qgc2htaWRfa2VybmVsICpzaHAsICpu
OworCWZvciAoOzspIHsKKwkJc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwOworCQlzdHJ1Y3Qg
aXBjX25hbWVzcGFjZSAqbnM7CiAKLQlpZiAobGlzdF9lbXB0eSgmdGFzay0+c3lzdnNobS5z
aG1fY2xpc3QpKQotCQlyZXR1cm47CisJCXRhc2tfbG9jayh0YXNrKTsKKworCQlpZiAobGlz
dF9lbXB0eSgmdGFzay0+c3lzdnNobS5zaG1fY2xpc3QpKSB7CisJCQl0YXNrX3VubG9jayh0
YXNrKTsKKwkJCWJyZWFrOworCQl9CisKKwkJc2hwID0gbGlzdF9maXJzdF9lbnRyeSgmdGFz
ay0+c3lzdnNobS5zaG1fY2xpc3QsIHN0cnVjdCBzaG1pZF9rZXJuZWwsCisJCQkJc2htX2Ns
aXN0KTsKKworCQkvKiAxKSB1bmxpbmsgKi8KKwkJbGlzdF9kZWxfaW5pdCgmc2hwLT5zaG1f
Y2xpc3QpOwogCi0JLyoKLQkgKiBJZiBrZXJuZWwuc2htX3JtaWRfZm9yY2VkIGlzIG5vdCBz
ZXQgdGhlbiBvbmx5IGtlZXAgdHJhY2sgb2YKLQkgKiB3aGljaCBzaG1pZHMgYXJlIG9ycGhh
bmVkLCBzbyB0aGF0IGEgbGF0ZXIgc2V0IG9mIHRoZSBzeXNjdGwKLQkgKiBjYW4gY2xlYW4g
dGhlbSB1cC4KLQkgKi8KLQlpZiAoIW5zLT5zaG1fcm1pZF9mb3JjZWQpIHsKLQkJZG93bl9y
ZWFkKCZzaG1faWRzKG5zKS5yd3NlbSk7Ci0JCWxpc3RfZm9yX2VhY2hfZW50cnkoc2hwLCAm
dGFzay0+c3lzdnNobS5zaG1fY2xpc3QsIHNobV9jbGlzdCkKLQkJCXNocC0+c2htX2NyZWF0
b3IgPSBOVUxMOwogCQkvKgotCQkgKiBPbmx5IHVuZGVyIHJlYWQgbG9jayBidXQgd2UgYXJl
IG9ubHkgY2FsbGVkIG9uIGN1cnJlbnQKLQkJICogc28gbm8gZW50cnkgb24gdGhlIGxpc3Qg
d2lsbCBiZSBzaGFyZWQuCisJCSAqIDIpIEdldCBwb2ludGVyIHRvIHRoZSBpcGMgbmFtZXNw
YWNlLiBJdCBpcyB3b3J0aCB0byBzYXkKKwkJICogdGhhdCB0aGlzIHBvaW50ZXIgaXMgZ3Vh
cmFudGVlZCB0byBiZSB2YWxpZCBiZWNhdXNlCisJCSAqIHNocCBsaWZldGltZSBpcyBhbHdh
eXMgc2hvcnRlciB0aGFuIG5hbWVzcGFjZSBsaWZldGltZQorCQkgKiBpbiB3aGljaCBzaHAg
bGl2ZXMuCisJCSAqIFdlIHRha2VuIHRhc2tfbG9jayBpdCBtZWFucyB0aGF0IHNocCB3b24n
dCBiZSBmcmVlZC4KIAkJICovCi0JCWxpc3RfZGVsKCZ0YXNrLT5zeXN2c2htLnNobV9jbGlz
dCk7Ci0JCXVwX3JlYWQoJnNobV9pZHMobnMpLnJ3c2VtKTsKLQkJcmV0dXJuOwotCX0KKwkJ
bnMgPSBzaHAtPm5zOwogCi0JLyoKLQkgKiBEZXN0cm95IGFsbCBhbHJlYWR5IGNyZWF0ZWQg
c2VnbWVudHMsIHRoYXQgd2VyZSBub3QgeWV0IG1hcHBlZCwKLQkgKiBhbmQgbWFyayBhbnkg
bWFwcGVkIGFzIG9ycGhhbiB0byBjb3ZlciB0aGUgc3lzY3RsIHRvZ2dsaW5nLgotCSAqIERl
c3Ryb3kgaXMgc2tpcHBlZCBpZiBzaG1fbWF5X2Rlc3Ryb3koKSByZXR1cm5zIGZhbHNlLgot
CSAqLwotCWRvd25fd3JpdGUoJnNobV9pZHMobnMpLnJ3c2VtKTsKLQlsaXN0X2Zvcl9lYWNo
X2VudHJ5X3NhZmUoc2hwLCBuLCAmdGFzay0+c3lzdnNobS5zaG1fY2xpc3QsIHNobV9jbGlz
dCkgewotCQlzaHAtPnNobV9jcmVhdG9yID0gTlVMTDsKKwkJLyoKKwkJICogMykgSWYga2Vy
bmVsLnNobV9ybWlkX2ZvcmNlZCBpcyBub3Qgc2V0IHRoZW4gb25seSBrZWVwIHRyYWNrIG9m
CisJCSAqIHdoaWNoIHNobWlkcyBhcmUgb3JwaGFuZWQsIHNvIHRoYXQgYSBsYXRlciBzZXQg
b2YgdGhlIHN5c2N0bAorCQkgKiBjYW4gY2xlYW4gdGhlbSB1cC4KKwkJICovCisJCWlmICgh
bnMtPnNobV9ybWlkX2ZvcmNlZCkgeworCQkJdGFza191bmxvY2sodGFzayk7CisJCQljb250
aW51ZTsKKwkJfQogCi0JCWlmIChzaG1fbWF5X2Rlc3Ryb3kobnMsIHNocCkpIHsKKwkJLyoK
KwkJICogNCkgZ2V0IGEgcmVmZXJlbmNlIHRvIHRoZSBuYW1lc3BhY2UuCisJCSAqICAgIFRo
ZSByZWZjb3VudCBjb3VsZCBiZSBhbHJlYWR5IDAuIElmIGl0IGlzIDAsIHRoZW4KKwkJICog
ICAgdGhlIHNobSBvYmplY3RzIHdpbGwgYmUgZnJlZSBieSBmcmVlX2lwY193b3JrKCkuCisJ
CSAqLworCQlucyA9IGdldF9pcGNfbnNfbm90X3plcm8obnMpOworCQlpZiAobnMpIHsKKwkJ
CS8qCisJCQkgKiA1KSBnZXQgYSByZWZlcmVuY2UgdG8gdGhlIHNocCBpdHNlbGYuCisJCQkg
KiAgIFRoaXMgY2Fubm90IGZhaWw6IHNobV9jbGlzdF9ybSgpIGlzIGNhbGxlZCBiZWZvcmUK
KwkJCSAqICAgaXBjX3JtaWQoKSwgdGh1cyB0aGUgcmVmY291bnQgY2Fubm90IGJlIDAuCisJ
CQkgKi8KKwkJCVdBUk5fT04oIWlwY19yY3VfZ2V0cmVmKCZzaHAtPnNobV9wZXJtKSk7CisJ
CX0KKworCQl0YXNrX3VubG9jayh0YXNrKTsKKworCQlpZiAobnMpIHsKKwkJCWRvd25fd3Jp
dGUoJnNobV9pZHMobnMpLnJ3c2VtKTsKIAkJCXNobV9sb2NrX2J5X3B0cihzaHApOwotCQkJ
c2htX2Rlc3Ryb3kobnMsIHNocCk7CisJCQkvKgorCQkJICogcmN1X3JlYWRfbG9jayB3YXMg
aW1wbGljaXRseSB0YWtlbiBpbgorCQkJICogc2htX2xvY2tfYnlfcHRyLCBpdCdzIHNhZmUg
dG8gY2FsbAorCQkJICogaXBjX3JjdV9wdXRyZWYgaGVyZQorCQkJICovCisJCQlpcGNfcmN1
X3B1dHJlZigmc2hwLT5zaG1fcGVybSwgc2htX3JjdV9mcmVlKTsKKworCQkJaWYgKGlwY192
YWxpZF9vYmplY3QoJnNocC0+c2htX3Blcm0pKSB7CisJCQkJaWYgKHNobV9tYXlfZGVzdHJv
eShzaHApKQorCQkJCQlzaG1fZGVzdHJveShucywgc2hwKTsKKwkJCQllbHNlCisJCQkJCXNo
bV91bmxvY2soc2hwKTsKKwkJCX0gZWxzZSB7CisJCQkJLyoKKwkJCQkgKiBTb21lb25lIGVs
c2UgZGVsZXRlZCB0aGUgc2hwIGZyb20gbmFtZXNwYWNlCisJCQkJICogaWRyL2todCB3aGls
ZSB3ZSBoYXZlIHdhaXRlZC4KKwkJCQkgKiBKdXN0IHVubG9jayBhbmQgY29udGludWUuCisJ
CQkJICovCisJCQkJc2htX3VubG9jayhzaHApOworCQkJfQorCisJCQl1cF93cml0ZSgmc2ht
X2lkcyhucykucndzZW0pOworCQkJcHV0X2lwY19ucyhucyk7IC8qIHBhaXJlZCB3aXRoIGdl
dF9pcGNfbnNfbm90X3plcm8gKi8KIAkJfQogCX0KLQotCS8qIFJlbW92ZSB0aGUgbGlzdCBo
ZWFkIGZyb20gYW55IHNlZ21lbnRzIHN0aWxsIGF0dGFjaGVkLiAqLwotCWxpc3RfZGVsKCZ0
YXNrLT5zeXN2c2htLnNobV9jbGlzdCk7Ci0JdXBfd3JpdGUoJnNobV9pZHMobnMpLnJ3c2Vt
KTsKIH0KIAogc3RhdGljIHZtX2ZhdWx0X3Qgc2htX2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAq
dm1mKQpAQCAtNjgwLDcgKzc1NSwxMSBAQCBzdGF0aWMgaW50IG5ld3NlZyhzdHJ1Y3QgaXBj
X25hbWVzcGFjZSAqbnMsIHN0cnVjdCBpcGNfcGFyYW1zICpwYXJhbXMpCiAJaWYgKGVycm9y
IDwgMCkKIAkJZ290byBub19pZDsKIAorCXNocC0+bnMgPSBuczsKKworCXRhc2tfbG9jayhj
dXJyZW50KTsKIAlsaXN0X2FkZCgmc2hwLT5zaG1fY2xpc3QsICZjdXJyZW50LT5zeXN2c2ht
LnNobV9jbGlzdCk7CisJdGFza191bmxvY2soY3VycmVudCk7CiAKIAkvKgogCSAqIHNobWlk
IGdldHMgcmVwb3J0ZWQgYXMgImlub2RlIyIgaW4gL3Byb2MvcGlkL21hcHMuCkBAIC0xNTcz
LDcgKzE2NTIsOCBAQCBsb25nIGRvX3NobWF0KGludCBzaG1pZCwgY2hhciBfX3VzZXIgKnNo
bWFkZHIsIGludCBzaG1mbGcsCiAJZG93bl93cml0ZSgmc2htX2lkcyhucykucndzZW0pOwog
CXNocCA9IHNobV9sb2NrKG5zLCBzaG1pZCk7CiAJc2hwLT5zaG1fbmF0dGNoLS07Ci0JaWYg
KHNobV9tYXlfZGVzdHJveShucywgc2hwKSkKKworCWlmIChzaG1fbWF5X2Rlc3Ryb3koc2hw
KSkKIAkJc2htX2Rlc3Ryb3kobnMsIHNocCk7CiAJZWxzZQogCQlzaG1fdW5sb2NrKHNocCk7
Ci0tIAoyLjMxLjEKCg==
--------------QPtkF8yHY6tv2bPLk5OOzrzn
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-DEBUG-CODE-instrummented-ipc-shm.c.patch"
Content-Disposition: attachment;
 filename="0003-DEBUG-CODE-instrummented-ipc-shm.c.patch"
Content-Transfer-Encoding: base64

RnJvbSBlZDY3MTczMzU3MDMxZDlhNTAxZTQxYjZiZTA1Y2ZjNDM4ZjQ0YWRjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5mcmVkIFNwcmF1bCA8bWFuZnJlZEBjb2xvcmZ1
bGxpZmUuY29tPgpEYXRlOiBTYXQsIDMwIE9jdCAyMDIxIDE0OjI3OjI1ICswMjAwClN1Ympl
Y3Q6IFtQQVRDSCAzLzNdIFtERUJVRyBDT0RFXSBpbnN0cnVtbWVudGVkIGlwYy9zaG0uYwoK
VGFyZ2V0OiBzaG93IHRoYXQgbmFtZXNwYWNlcyBjYW5ub3Qgb3V0bGl2ZSBhIHNobSBzZWdt
ZW50LgoKU2lnbmVkLW9mZi1ieTogTWFuZnJlZCBTcHJhdWwgPG1hbmZyZWRAY29sb3JmdWxs
aWZlLmNvbT4KLS0tCiBpcGMvc2htLmMgfCAxMSArKysrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDExIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pcGMvc2htLmMgYi9pcGMvc2ht
LmMKaW5kZXggZWJiMjVhOGVjYzU4Li42MjIyZDViOGFjZjYgMTAwNjQ0Ci0tLSBhL2lwYy9z
aG0uYworKysgYi9pcGMvc2htLmMKQEAgLTEyNiw2ICsxMjYsNyBAQCBzdGF0aWMgdm9pZCBk
b19zaG1fcm1pZChzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMsIHN0cnVjdCBrZXJuX2lwY19w
ZXJtICppcGNwKQogCXNocCA9IGNvbnRhaW5lcl9vZihpcGNwLCBzdHJ1Y3Qgc2htaWRfa2Vy
bmVsLCBzaG1fcGVybSk7CiAJV0FSTl9PTihucyAhPSBzaHAtPm5zKTsKIAorcHJfaW5mbygi
ZG9fc2htX3JtaWQoKTogc2hwICVweDogc2hwLT5zaG1fbmF0dGNoICVsZC5cbiIsIHNocCwg
c2hwLT5zaG1fbmF0dGNoKTsKIAlpZiAoc2hwLT5zaG1fbmF0dGNoKSB7CiAJCXNocC0+c2ht
X3Blcm0ubW9kZSB8PSBTSE1fREVTVDsKIAkJLyogRG8gbm90IGZpbmQgaXQgYW55IG1vcmUg
Ki8KQEAgLTEzOCw5ICsxMzksMTEgQEAgc3RhdGljIHZvaWQgZG9fc2htX3JtaWQoc3RydWN0
IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3Qga2Vybl9pcGNfcGVybSAqaXBjcCkKICNpZmRl
ZiBDT05GSUdfSVBDX05TCiB2b2lkIHNobV9leGl0X25zKHN0cnVjdCBpcGNfbmFtZXNwYWNl
ICpucykKIHsKK3ByX2luZm8oIm5hbWVzcGFjZSAlcHg6IGluIGV4aXRfbnMuXG4iLCBucyk7
CiAJZnJlZV9pcGNzKG5zLCAmc2htX2lkcyhucyksIGRvX3NobV9ybWlkKTsKIAlpZHJfZGVz
dHJveSgmbnMtPmlkc1tJUENfU0hNX0lEU10uaXBjc19pZHIpOwogCXJoYXNodGFibGVfZGVz
dHJveSgmbnMtPmlkc1tJUENfU0hNX0lEU10ua2V5X2h0KTsKK3ByX2luZm8oIm5hbWVzcGFj
ZSAlcHg6IGVuZCBvZiBleGl0X25zLlxuIiwgbnMpOwogfQogI2VuZGlmCiAKQEAgLTI4Nyw2
ICsyOTAsNyBAQCBzdGF0aWMgaW50IF9fc2htX29wZW4oc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEpCiAKIAlzaHAtPnNobV9hdGltID0ga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpOwog
CWlwY191cGRhdGVfcGlkKCZzaHAtPnNobV9scHJpZCwgdGFza190Z2lkKGN1cnJlbnQpKTsK
K3ByX2luZm8oIl9fc2htX29wZW4oKTogYmVmb3JlICsrOiBzaHAgJXB4LCBzZmQtPmZpbGUg
JXB4OiBzaHAtPnNobV9uYXR0Y2ggJWxkLlxuIiwgc2hwLCBzZmQtPmZpbGUsIHNocC0+c2ht
X25hdHRjaCk7CiAJc2hwLT5zaG1fbmF0dGNoKys7CiAJc2htX3VubG9jayhzaHApOwogCXJl
dHVybiAwOwpAQCAtMzQ0LDYgKzM0OCw3IEBAIHN0YXRpYyB2b2lkIHNobV9kZXN0cm95KHN0
cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwKQogICov
CiBzdGF0aWMgYm9vbCBzaG1fbWF5X2Rlc3Ryb3koc3RydWN0IHNobWlkX2tlcm5lbCAqc2hw
KQogeworcHJfaW5mbygic2htX21heV9kZXN0cm95KCk6IHNocCAlcHg6IHNocC0+c2htX25h
dHRjaCAlbGQuXG4iLCBzaHAsIHNocC0+c2htX25hdHRjaCk7CiAJcmV0dXJuIChzaHAtPnNo
bV9uYXR0Y2ggPT0gMCkgJiYKIAkgICAgICAgKHNocC0+bnMtPnNobV9ybWlkX2ZvcmNlZCB8
fAogCQkoc2hwLT5zaG1fcGVybS5tb2RlICYgU0hNX0RFU1QpKTsKQEAgLTM3NSw2ICszODAs
NyBAQCBzdGF0aWMgdm9pZCBzaG1fY2xvc2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEp
CiAKIAlpcGNfdXBkYXRlX3BpZCgmc2hwLT5zaG1fbHByaWQsIHRhc2tfdGdpZChjdXJyZW50
KSk7CiAJc2hwLT5zaG1fZHRpbSA9IGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKTsKK3ByX2lu
Zm8oInNobV9jbG9zZSgpOiBiZWZvcmUgLS06IHNocCAlcHg6IHNocC0+c2htX25hdHRjaCAl
bGQuXG4iLCBzaHAsIHNocC0+c2htX25hdHRjaCk7CiAJc2hwLT5zaG1fbmF0dGNoLS07CiAJ
aWYgKHNobV9tYXlfZGVzdHJveShzaHApKQogCQlzaG1fZGVzdHJveShucywgc2hwKTsKQEAg
LTU5MCw2ICs1OTYsNyBAQCBzdGF0aWMgaW50IHNobV9yZWxlYXNlKHN0cnVjdCBpbm9kZSAq
aW5vLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIHsKIAlzdHJ1Y3Qgc2htX2ZpbGVfZGF0YSAqc2Zk
ID0gc2htX2ZpbGVfZGF0YShmaWxlKTsKIAorcHJfaW5mbygic2htX3JlbGVhc2U6IGZpbGUg
JXB4LCBwdXRfaXBjX25zKCkuXG4iLCBzZmQtPmZpbGUpOwogCXB1dF9pcGNfbnMoc2ZkLT5u
cyk7CiAJZnB1dChzZmQtPmZpbGUpOwogCXNobV9maWxlX2RhdGEoZmlsZSkgPSBOVUxMOwpA
QCAtNzQ4LDYgKzc1NSw3IEBAIHN0YXRpYyBpbnQgbmV3c2VnKHN0cnVjdCBpcGNfbmFtZXNw
YWNlICpucywgc3RydWN0IGlwY19wYXJhbXMgKnBhcmFtcykKIAlzaHAtPnNobV9zZWdzeiA9
IHNpemU7CiAJc2hwLT5zaG1fbmF0dGNoID0gMDsKIAlzaHAtPnNobV9maWxlID0gZmlsZTsK
K3ByX2luZm8oIm5ld3NlZygpOiBzaHAgJXB4OiBzaHAtPnNobV9uYXR0Y2ggJWxkIC0+c2ht
ZmlsZSAlcHguXG4iLCBzaHAsIHNocC0+c2htX25hdHRjaCwgc2hwLT5zaG1fZmlsZSk7CiAJ
c2hwLT5zaG1fY3JlYXRvciA9IGN1cnJlbnQ7CiAKIAkvKiBpcGNfYWRkaWQoKSBsb2NrcyBz
aHAgdXBvbiBzdWNjZXNzLiAqLwpAQCAtMTU4OCw2ICsxNTk2LDcgQEAgbG9uZyBkb19zaG1h
dChpbnQgc2htaWQsIGNoYXIgX191c2VyICpzaG1hZGRyLCBpbnQgc2htZmxnLAogCSAqIGRl
dGVjdCBzaG0gSUQgcmV1c2Ugd2UgbmVlZCB0byBjb21wYXJlIHRoZSBmaWxlIHBvaW50ZXJz
LgogCSAqLwogCWJhc2UgPSBnZXRfZmlsZShzaHAtPnNobV9maWxlKTsKK3ByX2luZm8oImRv
X3NobWF0KCk6IHNocCAlcHg6IHNocC0+c2htX25hdHRjaCAlbGQuXG4iLCBzaHAsIHNocC0+
c2htX25hdHRjaCk7CiAJc2hwLT5zaG1fbmF0dGNoKys7CiAJc2l6ZSA9IGlfc2l6ZV9yZWFk
KGZpbGVfaW5vZGUoYmFzZSkpOwogCWlwY191bmxvY2tfb2JqZWN0KCZzaHAtPnNobV9wZXJt
KTsKQEAgLTE2MTIsNiArMTYyMSw3IEBAIGxvbmcgZG9fc2htYXQoaW50IHNobWlkLCBjaGFy
IF9fdXNlciAqc2htYWRkciwgaW50IHNobWZsZywKIAl9CiAKIAlzZmQtPmlkID0gc2hwLT5z
aG1fcGVybS5pZDsKK3ByX2luZm8oImRvX3NobWF0KCk6IHNocCAlcHg6IGdldF9pcGNfbnMo
KS5cbiIsIHNocCk7CiAJc2ZkLT5ucyA9IGdldF9pcGNfbnMobnMpOwogCXNmZC0+ZmlsZSA9
IGJhc2U7CiAJc2ZkLT52bV9vcHMgPSBOVUxMOwpAQCAtMTY1MSw2ICsxNjYxLDcgQEAgbG9u
ZyBkb19zaG1hdChpbnQgc2htaWQsIGNoYXIgX191c2VyICpzaG1hZGRyLCBpbnQgc2htZmxn
LAogb3V0X25hdHRjaDoKIAlkb3duX3dyaXRlKCZzaG1faWRzKG5zKS5yd3NlbSk7CiAJc2hw
ID0gc2htX2xvY2sobnMsIHNobWlkKTsKK3ByX2luZm8oImRvX3NobWF0KCkgYmVmb3JlIC0t
OiBzaHAgJXB4OiBzaHAtPnNobV9uYXR0Y2ggJWxkLlxuIiwgc2hwLCBzaHAtPnNobV9uYXR0
Y2gpOwogCXNocC0+c2htX25hdHRjaC0tOwogCiAJaWYgKHNobV9tYXlfZGVzdHJveShzaHAp
KQotLSAKMi4zMS4xCgo=
--------------QPtkF8yHY6tv2bPLk5OOzrzn
Content-Type: text/x-csrc; charset=UTF-8; name="shmns4.c"
Content-Disposition: attachment; filename="shmns4.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RkYm9vbC5oPgojaW5jbHVkZSA8c3Rk
aW8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CgojZGVmaW5lIF9HTlVfU09VUkNFCiNkZWZpbmUg
X19VU0VfR05VCiNpbmNsdWRlIDxzY2hlZC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1
ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3dhaXQuaD4KI2luY2x1ZGUgPHN5cy9p
cGMuaD4KI2luY2x1ZGUgPHN5cy9zaG0uaD4KI2luY2x1ZGUgPHB0aHJlYWQuaD4KI2luY2x1
ZGUgPHVuaXN0ZC5oPgoKc3RhdGljIHZvaWQgZG9fdW5zaGFyZShpbnQgbnVtLCBpbnQgZmxh
Z3MpCnsKCWludCByZXM7CgoJcHJpbnRmKCIgJWQpIHVuc2hhcmUoMHgleCkuXG4iLCBudW0s
IGZsYWdzKTsKCXJlcyA9IHVuc2hhcmUoZmxhZ3MpOwoJaWYgKHJlcyAhPSAwKSB7CgkJcHJp
bnRmKCIgICVkOiB1bnNoYXJlKDB4JXgpIGZhaWxlZCwgZXJybm8gJWQuXG4iLCBudW0sIGZs
YWdzLCBlcnJubyk7CgkJZXhpdCgzKTsKCX0KfQoKc3RhdGljIHZvaWQgc2V0X3JtaWRfZm9y
Y2VkKGNoYXIgKnZhbHVlKQp7CglpbnQgZmQ7CglpbnQgaTsKCglmZD1vcGVuKCIvcHJvYy9z
eXMva2VybmVsL3NobV9ybWlkX2ZvcmNlZCIsIE9fUkRXUik7CglpZiAoZmQgPT0gLTEpIHsK
CQlwcmludGYoIm9wZW4gc2htX3JtaWRfZm9yY2VkIGZhaWxlZCwgZXJybm8gJWQuXG4iLCBl
cnJubyk7CgkJZXhpdCAoMSk7Cgl9CglpID0gd3JpdGUoZmQsIHZhbHVlLCAyKTsKCWlmIChp
ICE9IDIpIHsKCQlwcmludGYoInVuZXhwZWN0ZWQgcmVzdWx0IHdoZW4gd3JpdGluZyAlcyB0
byBzaG1fcm1pZF9mb3JjZWQ6ICVkLCBlcnJubyAlZC5cbiIsIHZhbHVlLCBpLCBlcnJubyk7
CgkJZXhpdCAoMik7Cgl9CgljbG9zZShmZCk7Cn0KCnN0YXRpYyB2b2lkICpkb19zaG1nZXQo
Ym9vbCBtYXBfaXQpCnsKCWludCBzZWc7Cgl2b2lkICpwdHI7CgoJaWYgKChzZWcgPSBzaG1n
ZXQgKElQQ19QUklWQVRFLCAxLCBJUENfQ1JFQVR8IDA2MDApKSA9PSAtMSkgewoJCXBlcnJv
cigic2htZ2V0Iik7CgkJZXhpdCgzKTsKCX0KCWlmIChtYXBfaXQpIHsKCQlpZiAoKHB0ciA9
IHNobWF0IChzZWcsIDAsIDApKSA9PSAodm9pZCopLTEpIHsKCQkJcGVycm9yICgic2htYXQi
KTsKCQkJZXhpdCg0KTsKCQl9Cgl9IGVsc2UgewoJCXB0ciA9IE5VTEw7Cgl9CglyZXR1cm4g
cHRyOwp9CgppbnQgbWFpbiAoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CglwaWRfdCBjaGls
ZDsKCgkodm9pZClhcmd2OwoJKHZvaWQpYXJnYzsKCglwcmludGYoInNobW5zNDpcbiIpOwoJ
cHJpbnRmKCIgIE9uZSBwcm9jZXNzIGNyZWF0ZXMgYW5kIG1hcHMgc2htIHNlZ21lbnRzIGlu
IG11bHRpcGxlIG5hbWVzcGFjZXMuXG4iKTsKCXByaW50ZigiICBUaGUgbmFtZXNwYWNlcyBh
cmUgcmVwbGFjZWQgYmVmb3JlIHVubWFwcGluZyB0aGUgc2VnbWVudHMuXG4iKTsKCglkb191
bnNoYXJlKDEsIENMT05FX05FV0lQQyk7CglzZXRfcm1pZF9mb3JjZWQoIjFcbiIpOwoKCWNo
aWxkID0gZm9yaygpOwoJaWYgKGNoaWxkID09IC0xKSB7CgkJcGVycm9yICgiZm9yayIpOwoJ
CWV4aXQoNSk7Cgl9CglpZiAoY2hpbGQgPT0gMCkgewoJCXByaW50ZigiY3JlYXRlIGEgbmFt
ZXNwYWNlLCBjcmVhdGUgMiBzaG0gc2VnbWVudHMsIGRvIG5vdCBtYXAgdGhlbS5cbiIpOwoJ
CWRvX3Vuc2hhcmUoMiwgQ0xPTkVfTkVXSVBDKTsKCQlzZXRfcm1pZF9mb3JjZWQoIjFcbiIp
OwoJCWRvX3NobWdldChmYWxzZSk7CgkJZG9fc2htZ2V0KGZhbHNlKTsKCgkJZG9fdW5zaGFy
ZSgyLCBDTE9ORV9ORVdJUEMpOwoJCXNldF9ybWlkX2ZvcmNlZCgiMFxuIik7CgkJc2xlZXAo
NSk7IC8qIG5hbWVzcGFjZSBkZXN0cnVjdGlvbiBpcyBkb25lIGluIGEgd29ya2VyLCB0aHVz
IHdhaXQgYSBiaXQgKi8KCgkJcHJpbnRmKCJjcmVhdGUgYSBuYW1lc3BhY2UsIGNyZWF0ZSAy
IHNobSBzZWdtZW50cywgZG8gbm90IG1hcCB0aGVtLCBubyBhdXRvLXJtLlxuIik7CgkJZG9f
c2htZ2V0KGZhbHNlKTsKCQlkb19zaG1nZXQoZmFsc2UpOwoKCQlkb191bnNoYXJlKDIsIENM
T05FX05FV0lQQyk7CgkJc2V0X3JtaWRfZm9yY2VkKCIxXG4iKTsKCQlzbGVlcCg1KTsgLyog
bmFtZXNwYWNlIGRlc3RydWN0aW9uIGlzIGRvbmUgaW4gYSB3b3JrZXIsIHRodXMgd2FpdCBh
IGJpdCAqLwoKCQlwcmludGYoImNyZWF0ZSBhIG5hbWVzcGFjZSwgY3JlYXRlIDIgc2htIHNl
Z21lbnRzLCBtYXAgdGhlbS5cbiIpOwoJCWRvX3NobWdldCh0cnVlKTsKCQlkb19zaG1nZXQo
dHJ1ZSk7CgoJCWRvX3Vuc2hhcmUoMiwgQ0xPTkVfTkVXSVBDKTsKCQlzZXRfcm1pZF9mb3Jj
ZWQoIjBcbiIpOwoJCXNsZWVwKDUpOyAvKiBuYW1lc3BhY2UgZGVzdHJ1Y3Rpb24gaXMgZG9u
ZSBpbiBhIHdvcmtlciwgdGh1cyB3YWl0IGEgYml0ICovCgoJCXByaW50ZigiT25jZSBtb3Jl
OiBDcmVhdGUgYSBuYW1lc3BhY2UsIGNyZWF0ZSAyIHNobSBzZWdtZW50cywgbWFwIHRoZW0s
IG5vIGF1dG8tcm0uXG4iKTsKCQlkb19zaG1nZXQodHJ1ZSk7CgkJZG9fc2htZ2V0KHRydWUp
OwoKCgkJcHJpbnRmKCJPcnBoYW4gbmFtZXNwYWNlIChzd2l0Y2ggYmFjayB0byBwYXJlbnQg
bmFtZXNwYWNlKS5cbiIpOwoJCXsKCQkJY2hhciBwYXRoWzI1NV07CgkJCWludCBmZDsKCgkJ
CXNwcmludGYocGF0aCwgIi9wcm9jLyVkL25zL2lwYyIsIGdldHBwaWQoKSk7CgkJCWZkID0g
b3BlbihwYXRoLCBPX1JET05MWSk7CgkJCWlmIChmZCA9PSAtMSkgewoJCQkJcGVycm9yKCJv
cGVuIGlwYyBucyIpOwoJCQkJZXhpdCg2KTsKCQkJfQoJCQlpZiAoc2V0bnMoZmQsIDApID09
IC0xKSB7CgkJCQlwZXJyb3IoInNldG5zIHRvIHBhcmVudCIpOwoJCQkJZXhpdCg3KTsJCQkK
CQkJfQoJCX0KCQlzbGVlcCg1KTsgLyogbmFtZXNwYWNlIGRlc3RydWN0aW9uIGlzIGRvbmUg
aW4gYSB3b3JrZXIsIHRodXMgd2FpdCBhIGJpdCAqLwoKCQlwcmludGYoIkJlZm9yZSBleGl0
IG9mIGNoaWxkOiA0IG1hcHBpbmdzIGV4aXN0IGluIDIgbmFtZXNwYWNlcy5cbiIpOwoKCQll
eGl0KDApOwoJCQoJfSBlbHNlIHsKCQlpbnQgc3RhdHVzOwoJCWludCByZXQ7CgoJCXNsZWVw
KDEpOwoJCXJldCA9IHdhaXRwaWQoY2hpbGQsICZzdGF0dXMsIDApOwoJCXNsZWVwKDEwKTsK
CQlwcmludGYoInBhcmVudDp3YWl0cGlkIHJldHVybmVkICVkLCBzdGF0dXMgJWQuXG4iLCBy
ZXQsIHN0YXR1cyk7Cgl9CglyZXR1cm4gMDsKfQo=
--------------QPtkF8yHY6tv2bPLk5OOzrzn
Content-Type: text/plain; charset=UTF-8; name="log-ns4.txt"
Content-Disposition: attachment; filename="log-ns4.txt"
Content-Transfer-Encoding: base64

Iy4vc2htbnM0CnNobW5zNDoKICBPbmUgcHJvY2VzcyBjcmVhdGVzIGFuZCBtYXBzIHNobSBz
ZWdtZW50cyBpbiBtdWx0aXBsZSBuYW1lc3BhY2VzLgogIFRoZSBuYW1lc3BhY2VzIGFyZSBy
ZXBsYWNlZCBiZWZvcmUgdW5tYXBwaW5nIHRoZSBzZWdtZW50cy4KIDEpIHVuc2hhcmUoMHg4
MDAwMDAwKS4KY3JlYXRlIGEgbmFtZXNwYWNlLCBjcmVhdGUgMiBzaG0gc2VnbWVudHMsIGRv
IG5vdCBtYXAgdGhlbS4KIDIpIHVuc2hhcmUoMHg4MDAwMDAwKS4KWyAgIDcxLjQ0NDg5MF0g
bmV3c2VnKCk6IHNocCBmZmZmODg4MDAzYTg0ZjAwOiBzaHAtPnNobV9uYXR0Y2ggMCAtPnNo
bWZpbGUgZmZmZjg4ODAwNDI4ZjUwMC4KWyAgIDcxLjQ0ODY5Nl0gbmV3c2VnKCk6IHNocCBm
ZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMCAtPnNobWZpbGUgZmZmZjg4ODAw
NDI4ZjkwMC4KIDIpIHVuc2hhcmUoMHg4MDAwMDAwKS4KWyAgIDcxLjQ1MzM1Ml0gc2htX21h
eV9kZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMC4K
WyAgIDcxLjQ1NTgyMl0gc2htX21heV9kZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0ZjAw
OiBzaHAtPnNobV9uYXR0Y2ggMC4KWyAgIDcxLjQ2MDMzMl0gbmFtZXNwYWNlIGZmZmY4ODgw
MDM2Nzk0MDA6IGluIGV4aXRfbnMuClsgICA3MS40NjE3ODNdIG5hbWVzcGFjZSBmZmZmODg4
MDAzNjc5NDAwOiBlbmQgb2YgZXhpdF9ucy4KY3JlYXRlIGEgbmFtZXNwYWNlLCBjcmVhdGUg
MiBzaG0gc2VnbWVudHMsIGRvIG5vdCBtYXAgdGhlbSwgbm8gYXV0by1ybS4KWyAgIDc2LjQ4
MTUyN10gbmV3c2VnKCk6IHNocCBmZmZmODg4MDAzYTg0ZjAwOiBzaHAtPnNobV9uYXR0Y2gg
MCAtPnNobWZpbGUgZmZmZjg4ODAwNDI4ZjgwMC4KWyAgIDc2LjQ4NjE2Ml0gbmV3c2VnKCk6
IHNocCBmZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMCAtPnNobWZpbGUgZmZm
Zjg4ODAwNDI4ZjkwMC4KIDIpIHVuc2hhcmUoMHg4MDAwMDAwKS4KWyAgIDc2LjQ5NjQ4MF0g
bmFtZXNwYWNlIGZmZmY4ODgwMDM2Nzk4MDA6IGluIGV4aXRfbnMuClsgICA3Ni40OTk3NThd
IGRvX3NobV9ybWlkKCk6IHNocCBmZmZmODg4MDAzYTg0ZjAwOiBzaHAtPnNobV9uYXR0Y2gg
MC4KWyAgIDc2LjUxNTkzNF0gZG9fc2htX3JtaWQoKTogc2hwIGZmZmY4ODgwMDNhODRlMDA6
IHNocC0+c2htX25hdHRjaCAwLgpbICAgNzYuNTM3MTI2XSBuYW1lc3BhY2UgZmZmZjg4ODAw
MzY3OTgwMDogZW5kIG9mIGV4aXRfbnMuCmNyZWF0ZSBhIG5hbWVzcGFjZSwgY3JlYXRlIDIg
c2htIHNlZ21lbnRzLCBtYXAgdGhlbS4KWyAgIDgxLjUxNzQ2NF0gbmV3c2VnKCk6IHNocCBm
ZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMCAtPnNobWZpbGUgZmZmZjg4ODAw
NDI4ZjgwMC4KWyAgIDgxLjUyNjk2NF0gZG9fc2htYXQoKTogc2hwIGZmZmY4ODgwMDNhODRl
MDA6IHNocC0+c2htX25hdHRjaCAwLgpbICAgODEuNTMxNTc1XSBkb19zaG1hdCgpOiBzaHAg
ZmZmZjg4ODAwM2E4NGUwMDogZ2V0X2lwY19ucygpLgpbICAgODEuNTQyNDU5XSBfX3NobV9v
cGVuKCk6IGJlZm9yZSArKzogc2hwIGZmZmY4ODgwMDNhODRlMDAsIHNmZC0+ZmlsZSBmZmZm
ODg4MDA0MjhmODAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KWyAgIDgxLjU0OTM5MF0gZG9fc2ht
YXQoKSBiZWZvcmUgLS06IHNocCBmZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2gg
Mi4KWyAgIDgxLjU1NDY5OV0gc2htX21heV9kZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0
ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KWyAgIDgxLjU2MDY0OV0gbmV3c2VnKCk6IHNocCBm
ZmZmODg4MDAzYTg0ZjAwOiBzaHAtPnNobV9uYXR0Y2ggMCAtPnNobWZpbGUgZmZmZjg4ODAw
NDI4ZjUwMC4KWyAgIDgxLjU2NDY0OV0gZG9fc2htYXQoKTogc2hwIGZmZmY4ODgwMDNhODRm
MDA6IHNocC0+c2htX25hdHRjaCAwLgpbICAgODEuNTY4NjgxXSBkb19zaG1hdCgpOiBzaHAg
ZmZmZjg4ODAwM2E4NGYwMDogZ2V0X2lwY19ucygpLgpbICAgODEuNTczODY1XSBfX3NobV9v
cGVuKCk6IGJlZm9yZSArKzogc2hwIGZmZmY4ODgwMDNhODRmMDAsIHNmZC0+ZmlsZSBmZmZm
ODg4MDA0MjhmNTAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KWyAgIDgxLjU3Njg2Nl0gZG9fc2ht
YXQoKSBiZWZvcmUgLS06IHNocCBmZmZmODg4MDAzYTg0ZjAwOiBzaHAtPnNobV9uYXR0Y2gg
Mi4KWyAgIDgxLjU4MDQ5NF0gc2htX21heV9kZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0
ZjAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KIDIpIHVuc2hhcmUoMHg4MDAwMDAwKS4KWyAgIDgx
LjU4OTY0OF0gc2htX21heV9kZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0ZjAwOiBzaHAt
PnNobV9uYXR0Y2ggMS4KWyAgIDgxLjU5MjQzMV0gc2htX21heV9kZXN0cm95KCk6IHNocCBm
ZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KT25jZSBtb3JlOiBDcmVhdGUg
YSBuYW1lc3BhY2UsIGNyZWF0ZSAyIHNobSBzZWdtZW50cywgbWFwIHRoZW0sIG5vIGF1dG8t
cm0uClsgICA4Ni42MDk4MDddIG5ld3NlZygpOiBzaHAgZmZmZjg4ODAwM2E4NDAwMDogc2hw
LT5zaG1fbmF0dGNoIDAgLT5zaG1maWxlIGZmZmY4ODgwMDQwMjNhMDAuClsgICA4Ni42MTM5
NzhdIGRvX3NobWF0KCk6IHNocCBmZmZmODg4MDAzYTg0MDAwOiBzaHAtPnNobV9uYXR0Y2gg
MC4KWyAgIDg2LjYxNjYxNl0gZG9fc2htYXQoKTogc2hwIGZmZmY4ODgwMDNhODQwMDA6IGdl
dF9pcGNfbnMoKS4KWyAgIDg2LjYyMTcxNF0gX19zaG1fb3BlbigpOiBiZWZvcmUgKys6IHNo
cCBmZmZmODg4MDAzYTg0MDAwLCBzZmQtPmZpbGUgZmZmZjg4ODAwNDAyM2EwMDogc2hwLT5z
aG1fbmF0dGNoIDEuClsgICA4Ni42MjU5NzVdIGRvX3NobWF0KCkgYmVmb3JlIC0tOiBzaHAg
ZmZmZjg4ODAwM2E4NDAwMDogc2hwLT5zaG1fbmF0dGNoIDIuClsgICA4Ni42Mjk1NzhdIHNo
bV9tYXlfZGVzdHJveSgpOiBzaHAgZmZmZjg4ODAwM2E4NDAwMDogc2hwLT5zaG1fbmF0dGNo
IDEuClsgICA4Ni42MzM3NjZdIG5ld3NlZygpOiBzaHAgZmZmZjg4ODAwM2E4NDEwMDogc2hw
LT5zaG1fbmF0dGNoIDAgLT5zaG1maWxlIGZmZmY4ODgwMDQwMjNlMDAuClsgICA4Ni42Mzk2
NDJdIGRvX3NobWF0KCk6IHNocCBmZmZmODg4MDAzYTg0MTAwOiBzaHAtPnNobV9uYXR0Y2gg
MC4KWyAgIDg2LjY0MzYzNF0gZG9fc2htYXQoKTogc2hwIGZmZmY4ODgwMDNhODQxMDA6IGdl
dF9pcGNfbnMoKS4KWyAgIDg2LjY0Njk1MV0gX19zaG1fb3BlbigpOiBiZWZvcmUgKys6IHNo
cCBmZmZmODg4MDAzYTg0MTAwLCBzZmQtPmZpbGUgZmZmZjg4ODAwNDAyM2UwMDogc2hwLT5z
aG1fbmF0dGNoIDEuClsgICA4Ni42NTE2NDhdIGRvX3NobWF0KCkgYmVmb3JlIC0tOiBzaHAg
ZmZmZjg4ODAwM2E4NDEwMDogc2hwLT5zaG1fbmF0dGNoIDIuClsgICA4Ni42NjA1MjddIHNo
bV9tYXlfZGVzdHJveSgpOiBzaHAgZmZmZjg4ODAwM2E4NDEwMDogc2hwLT5zaG1fbmF0dGNo
IDEuCk9ycGhhbiBuYW1lc3BhY2UgKHN3aXRjaCBiYWNrIHRvIHBhcmVudCBuYW1lc3BhY2Up
LgpCZWZvcmUgZXhpdCBvZiBjaGlsZDogNCBtYXBwaW5ncyBleGlzdCBpbiAyIG5hbWVzcGFj
ZXMuClsgICA5MS43NTAzODVdIHNobV9jbG9zZSgpOiBiZWZvcmUgLS06IHNocCBmZmZmODg4
MDAzYTg0MTAwOiBzaHAtPnNobV9uYXR0Y2ggMS4KWyAgIDkxLjc1NTUwM10gc2htX21heV9k
ZXN0cm95KCk6IHNocCBmZmZmODg4MDAzYTg0MTAwOiBzaHAtPnNobV9uYXR0Y2ggMC4KWyAg
IDkxLjc1ODcxMF0gc2htX2Nsb3NlKCk6IGJlZm9yZSAtLTogc2hwIGZmZmY4ODgwMDNhODQw
MDA6IHNocC0+c2htX25hdHRjaCAxLgpbICAgOTEuNzYxODI4XSBzaG1fbWF5X2Rlc3Ryb3ko
KTogc2hwIGZmZmY4ODgwMDNhODQwMDA6IHNocC0+c2htX25hdHRjaCAwLgpbICAgOTEuNzY0
ODc5XSBzaG1fY2xvc2UoKTogYmVmb3JlIC0tOiBzaHAgZmZmZjg4ODAwM2E4NGYwMDogc2hw
LT5zaG1fbmF0dGNoIDEuClsgICA5MS43NjgyNDhdIHNobV9tYXlfZGVzdHJveSgpOiBzaHAg
ZmZmZjg4ODAwM2E4NGYwMDogc2hwLT5zaG1fbmF0dGNoIDAuClsgICA5MS43NzI2NDJdIHNo
bV9jbG9zZSgpOiBiZWZvcmUgLS06IHNocCBmZmZmODg4MDAzYTg0ZTAwOiBzaHAtPnNobV9u
YXR0Y2ggMS4KWyAgIDkxLjc3NjQxN10gc2htX21heV9kZXN0cm95KCk6IHNocCBmZmZmODg4
MDAzYTg0ZTAwOiBzaHAtPnNobV9uYXR0Y2ggMC4KWyAgIDkxLjc5MDg2MV0gc2htX3JlbGVh
c2U6IGZpbGUgZmZmZjg4ODAwNDI4ZjgwMCwgcHV0X2lwY19ucygpLgpbICAgOTEuNzk2ODU4
XSBzaG1fcmVsZWFzZTogZmlsZSBmZmZmODg4MDA0MjhmNTAwLCBwdXRfaXBjX25zKCkuClsg
ICA5MS44MDU4NjZdIG5hbWVzcGFjZSBmZmZmODg4MDAzNjc5NDAwOiBpbiBleGl0X25zLgpb
ICAgOTEuODA4NDU4XSBuYW1lc3BhY2UgZmZmZjg4ODAwMzY3OTQwMDogZW5kIG9mIGV4aXRf
bnMuClsgICA5MS44MTY2MTNdIHNobV9yZWxlYXNlOiBmaWxlIGZmZmY4ODgwMDQwMjNhMDAs
IHB1dF9pcGNfbnMoKS4KWyAgIDkxLjgyMTM5Ml0gc2htX3JlbGVhc2U6IGZpbGUgZmZmZjg4
ODAwNDAyM2UwMCwgcHV0X2lwY19ucygpLgpbICAgOTEuODI1NzE1XSBuYW1lc3BhY2UgZmZm
Zjg4ODAwMzY3OTgwMDogaW4gZXhpdF9ucy4KWyAgIDkxLjgyODgxMV0gZG9fc2htX3JtaWQo
KTogc2hwIGZmZmY4ODgwMDNhODQwMDA6IHNocC0+c2htX25hdHRjaCAwLgpbICAgOTEuODMy
NDUzXSBkb19zaG1fcm1pZCgpOiBzaHAgZmZmZjg4ODAwM2E4NDEwMDogc2hwLT5zaG1fbmF0
dGNoIDAuClsgICA5MS44NDM4NDFdIG5hbWVzcGFjZSBmZmZmODg4MDAzNjc5ODAwOiBlbmQg
b2YgZXhpdF9ucy4KcGFyZW50OndhaXRwaWQgcmV0dXJuZWQgMjg1LCBzdGF0dXMgMC4KWyAg
MTAxLjg4Mjg0Ml0gbmFtZXNwYWNlIGZmZmY4ODgwMDM2NzkwMDA6IGluIGV4aXRfbnMuClsg
IDEwMS44ODU3MDddIG5hbWVzcGFjZSBmZmZmODg4MDAzNjc5MDAwOiBlbmQgb2YgZXhpdF9u
cy4KIyAK
--------------QPtkF8yHY6tv2bPLk5OOzrzn--

