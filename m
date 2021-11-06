Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA979446E78
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhKFPDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 11:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhKFPDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 11:03:21 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7526C061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 08:00:39 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o29so5626826wms.2
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 08:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=VX5Sto7XPRppKnzjACz4r8u0lyuO5rL3by41T4yf3v0=;
        b=NPkMxXIpSS0akDePR+hT7SYkdVEVi91/NWD12zbRhsXkG3UjEuNENu3qOCAXZHcWH7
         OJ9lFFKYWrLw8PiAHinypF/F9EypVpzaPQGynSlTInNB91KfCF/C1vAxdrNjBDYmGuR/
         vE4RGqLybagDyqNFSUS9aeuszDFjYkA6xxppFG/joagTfqUYX3uWViKTHAvI5jOkpyPz
         xbLpQGkz9ZFPwF/hBWr61ylfKAA86Oo2RuWwYeUHgFmpN9P/cQAOLGQGCXs+VwYEufJ9
         3uvKOSw79MuLOcWC6Wb/hK/pV7JDGgufUkKBU5UN+jmonRw0EGEcU3Lgsvamb+0BsfPW
         xpiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=VX5Sto7XPRppKnzjACz4r8u0lyuO5rL3by41T4yf3v0=;
        b=GBtV1JheH6G26ClNRv3UPQ+xaRiQdnR4XylXNyVItSjUz/+5lCcRuA0dA5N127EaG9
         qIOskGuuTOwq/NCQIObM7Af3ZSo8iY4fDNl3UsvDJYZjygoS4R2tdreCPWj7xCcy95Z0
         mEez5BH39pSQnoF1+Fl+t0emOD+OAHPZOAHvNgZ3bibM3su7+qe6/whHIlIiRIVkr9je
         Br1WeF/gLSe9fSJM0VGGiskvBR/4GkGV09L4Derk7E7Nt+zXu9sBJFdanyCpfMD4PfIA
         KqkTlAvNf4yj5wpO1jor+7RI68aqCbEZnjuztuc5bmPbdusikrEdNabPkFQ9TEZZTRBI
         8rug==
X-Gm-Message-State: AOAM531yl3o11j//rMvXrAJvXCjBZFiNTwcY9ZwThWOMwmWAwUy/N92a
        iId5t/mle/NUQ+rwj4T8s1QRNSBuhQvdog==
X-Google-Smtp-Source: ABdhPJx/pHbRrL7wn8C/zD958cDKOqJh/N2pljO7scQKdWWQl8LKlS+MHX85/s0ZVaTDzPRi4lAiJg==
X-Received: by 2002:a05:600c:4f8a:: with SMTP id n10mr27979982wmq.54.1636210838444;
        Sat, 06 Nov 2021 08:00:38 -0700 (PDT)
Received: from ?IPV6:2003:d9:973c:5300:2047:e88a:31d4:666? (p200300d9973c53002047e88a31d40666.dip0.t-ipconnect.de. [2003:d9:973c:5300:2047:e88a:31d4:666])
        by smtp.googlemail.com with ESMTPSA id u15sm6991688wmq.13.2021.11.06.08.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 08:00:37 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------7r6io3rUbRb3xAA6X0PuE8Wm"
Message-ID: <311f94c6-671b-8bb0-37f4-e25116267cdc@colorfullife.com>
Date:   Sat, 6 Nov 2021 16:00:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: +
 shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch
 added to -mm tree
Content-Language: en-US
To:     akpm@linux-foundation.org, alexander.mikhalitsyn@virtuozzo.com,
        avagin@gmail.com, dave@stgolabs.net, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        ptikhomirov@virtuozzo.com, stable@vger.kernel.org,
        vvs@virtuozzo.com
References: <20211027225149.siEnQFirE%akpm@linux-foundation.org>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20211027225149.siEnQFirE%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------7r6io3rUbRb3xAA6X0PuE8Wm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

On 10/28/21 00:51, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: shm: extend forced shm destroy to support objects from several IPC nses
> has been added to the -mm tree.  Its filename is
>       shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch

Could you replace the patch with the attached version?

See 
https://lore.kernel.org/all/8ba678da-207e-ea00-a56d-736a2184e69e@colorfullife.com/ 
for details

> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Subject: shm: extend forced shm destroy to support objects from several IPC nses
>
> Currently, exit_shm function not designed to work properly when
> task->sysvshm.shm_clist holds shm objects from different IPC namespaces.
>
> This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
> leads to use-after-free (reproducer exists).
>
> That particular patch is attempt to fix the problem by extending exit_shm
> mechanism to handle shm's destroy from several IPC ns'es.
>
> To achieve that we do several things:
>
> 1. add namespace (non-refcounted) pointer to the struct shmid_kernel
>
> 2. during new shm object creation (newseg()/shmget syscall) we
>     initialize this pointer by current task IPC ns
>
> 3. exit_shm() fully reworked such that it traverses over all shp's in
>     task->sysvshm.shm_clist and gets IPC namespace not from current task as
>     it was before but from shp's object itself, then call shm_destroy(shp,
>     ns).
>
> Note.  We need to be really careful here, because as it was said before
> (1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we using
> special helper get_ipc_ns_not_zero() which allows to get IPC ns refcounter
> only if IPC ns not in the "state of destruction".
>
> Q/A
>
> Q: Why we can access shp->ns memory using non-refcounted pointer?
> A: Because shp object lifetime is always shorther than IPC namespace
>     lifetime, so, if we get shp object from the task->sysvshm.shm_clist
>     while holding task_lock(task) nobody can steal our namespace.
>
> Q: Does this patch change semantics of unshare/setns/clone syscalls?
> A: Not.  It's just fixes non-covered case when process may leave IPC
>     namespace without getting task->sysvshm.shm_clist list cleaned up.
>
> Link: https://lkml.kernel.org/r/20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com
> Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
> Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/ipc_namespace.h |   15 ++
>   include/linux/sched/task.h    |    2
>   include/linux/shm.h           |    2
>   ipc/shm.c                     |  170 +++++++++++++++++++++++---------
>   4 files changed, 142 insertions(+), 47 deletions(-)
>
> --- a/include/linux/ipc_namespace.h~shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses
> +++ a/include/linux/ipc_namespace.h
> @@ -131,6 +131,16 @@ static inline struct ipc_namespace *get_
>   	return ns;
>   }
>   
> +static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
> +{
> +	if (ns) {
> +		if (refcount_inc_not_zero(&ns->ns.count))
> +			return ns;
> +	}
> +
> +	return NULL;
> +}
> +
>   extern void put_ipc_ns(struct ipc_namespace *ns);
>   #else
>   static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
> @@ -146,6 +156,11 @@ static inline struct ipc_namespace *get_
>   {
>   	return ns;
>   }
> +
> +static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
> +{
> +	return ns;
> +}
>   
>   static inline void put_ipc_ns(struct ipc_namespace *ns)
>   {
> --- a/include/linux/sched/task.h~shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses
> +++ a/include/linux/sched/task.h
> @@ -157,7 +157,7 @@ static inline struct vm_struct *task_sta
>    * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
>    * subscriptions and synchronises with wait4().  Also used in procfs.  Also
>    * pins the final release of task.io_context.  Also protects ->cpuset and
> - * ->cgroup.subsys[]. And ->vfork_done.
> + * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
>    *
>    * Nests both inside and outside of read_lock(&tasklist_lock).
>    * It must not be nested with write_lock_irq(&tasklist_lock),
> --- a/include/linux/shm.h~shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses
> +++ a/include/linux/shm.h
> @@ -11,7 +11,7 @@ struct file;
>   
>   #ifdef CONFIG_SYSVIPC
>   struct sysv_shm {
> -	struct list_head shm_clist;
> +	struct list_head	shm_clist;
>   };
>   
>   long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
> --- a/ipc/shm.c~shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses
> +++ a/ipc/shm.c
> @@ -62,9 +62,18 @@ struct shmid_kernel /* private to the ke
>   	struct pid		*shm_lprid;
>   	struct ucounts		*mlock_ucounts;
>   
> -	/* The task created the shm object.  NULL if the task is dead. */
> +	/*
> +	 * The task created the shm object, for looking up
> +	 * task->sysvshm.shm_clist_lock
> +	 */
>   	struct task_struct	*shm_creator;
> -	struct list_head	shm_clist;	/* list by creator */
> +
> +	/*
> +	 * list by creator. shm_clist_lock required for read/write
> +	 * if list_empty(), then the creator is dead already
> +	 */
> +	struct list_head	shm_clist;
> +	struct ipc_namespace	*ns;
>   } __randomize_layout;
>   
>   /* shm_mode upper byte flags */
> @@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_names
>   	struct shmid_kernel *shp;
>   
>   	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
> +	WARN_ON(ns != shp->ns);
>   
>   	if (shp->shm_nattch) {
>   		shp->shm_perm.mode |= SHM_DEST;
> @@ -225,10 +235,36 @@ static void shm_rcu_free(struct rcu_head
>   	kfree(shp);
>   }
>   
> -static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
> +/*
> + * It has to be called with shp locked.
> + * It must be called before ipc_rmid()
> + */
> +static inline void shm_clist_rm(struct shmid_kernel *shp)
>   {
> -	list_del(&s->shm_clist);
> -	ipc_rmid(&shm_ids(ns), &s->shm_perm);
> +	struct task_struct *creator;
> +
> +	/*
> +	 * A concurrent exit_shm may do a list_del_init() as well.
> +	 * Just do nothing if exit_shm already did the work
> +	 */
> +	if (list_empty(&shp->shm_clist))
> +		return;
> +
> +	/*
> +	 * shp->shm_creator is guaranteed to be valid *only*
> +	 * if shp->shm_clist is not empty.
> +	 */
> +	creator = shp->shm_creator;
> +
> +	task_lock(creator);
> +	list_del_init(&shp->shm_clist);
> +	task_unlock(creator);
> +}
> +
> +static inline void shm_rmid(struct shmid_kernel *s)
> +{
> +	shm_clist_rm(s);
> +	ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
>   }
>   
>   
> @@ -283,7 +319,7 @@ static void shm_destroy(struct ipc_names
>   	shm_file = shp->shm_file;
>   	shp->shm_file = NULL;
>   	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	shm_rmid(ns, shp);
> +	shm_rmid(shp);
>   	shm_unlock(shp);
>   	if (!is_file_hugepages(shm_file))
>   		shmem_lock(shm_file, 0, shp->mlock_ucounts);
> @@ -306,10 +342,10 @@ static void shm_destroy(struct ipc_names
>    *
>    * 2) sysctl kernel.shm_rmid_forced is set to 1.
>    */
> -static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> +static bool shm_may_destroy(struct shmid_kernel *shp)
>   {
>   	return (shp->shm_nattch == 0) &&
> -	       (ns->shm_rmid_forced ||
> +	       (shp->ns->shm_rmid_forced ||
>   		(shp->shm_perm.mode & SHM_DEST));
>   }
>   
> @@ -340,7 +376,7 @@ static void shm_close(struct vm_area_str
>   	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
>   	shp->shm_dtim = ktime_get_real_seconds();
>   	shp->shm_nattch--;
> -	if (shm_may_destroy(ns, shp))
> +	if (shm_may_destroy(shp))
>   		shm_destroy(ns, shp);
>   	else
>   		shm_unlock(shp);
> @@ -361,10 +397,10 @@ static int shm_try_destroy_orphaned(int
>   	 *
>   	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
>   	 */
> -	if (shp->shm_creator != NULL)
> +	if (!list_empty(&shp->shm_clist))
>   		return 0;
>   
> -	if (shm_may_destroy(ns, shp)) {
> +	if (shm_may_destroy(shp)) {
>   		shm_lock_by_ptr(shp);
>   		shm_destroy(ns, shp);
>   	}
> @@ -382,48 +418,87 @@ void shm_destroy_orphaned(struct ipc_nam
>   /* Locking assumes this will only be called with task == current */
>   void exit_shm(struct task_struct *task)
>   {
> -	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
> -	struct shmid_kernel *shp, *n;
> +	for (;;) {
> +		struct shmid_kernel *shp;
> +		struct ipc_namespace *ns;
>   
> -	if (list_empty(&task->sysvshm.shm_clist))
> -		return;
> +		task_lock(task);
> +
> +		if (list_empty(&task->sysvshm.shm_clist)) {
> +			task_unlock(task);
> +			break;
> +		}
> +
> +		shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
> +				shm_clist);
> +
> +		/* 1) unlink */
> +		list_del_init(&shp->shm_clist);
>   
> -	/*
> -	 * If kernel.shm_rmid_forced is not set then only keep track of
> -	 * which shmids are orphaned, so that a later set of the sysctl
> -	 * can clean them up.
> -	 */
> -	if (!ns->shm_rmid_forced) {
> -		down_read(&shm_ids(ns).rwsem);
> -		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
> -			shp->shm_creator = NULL;
>   		/*
> -		 * Only under read lock but we are only called on current
> -		 * so no entry on the list will be shared.
> +		 * 2) Get pointer to the ipc namespace. It is worth to say
> +		 * that this pointer is guaranteed to be valid because
> +		 * shp lifetime is always shorter than namespace lifetime
> +		 * in which shp lives.
> +		 * We taken task_lock it means that shp won't be freed.
>   		 */
> -		list_del(&task->sysvshm.shm_clist);
> -		up_read(&shm_ids(ns).rwsem);
> -		return;
> -	}
> +		ns = shp->ns;
>   
> -	/*
> -	 * Destroy all already created segments, that were not yet mapped,
> -	 * and mark any mapped as orphan to cover the sysctl toggling.
> -	 * Destroy is skipped if shm_may_destroy() returns false.
> -	 */
> -	down_write(&shm_ids(ns).rwsem);
> -	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
> -		shp->shm_creator = NULL;
> +		/*
> +		 * 3) If kernel.shm_rmid_forced is not set then only keep track of
> +		 * which shmids are orphaned, so that a later set of the sysctl
> +		 * can clean them up.
> +		 */
> +		if (!ns->shm_rmid_forced) {
> +			task_unlock(task);
> +			continue;
> +		}
>   
> -		if (shm_may_destroy(ns, shp)) {
> +		/*
> +		 * 4) get a reference to the namespace.
> +		 *    The refcount could be already 0. If it is 0, then
> +		 *    the shm objects will be free by free_ipc_work().
> +		 */
> +		ns = get_ipc_ns_not_zero(ns);
> +		if (ns) {
> +			/*
> +			 * 5) get a reference to the shp itself.
> +			 *   This cannot fail: shm_clist_rm() is called before
> +			 *   ipc_rmid(), thus the refcount cannot be 0.
> +			 */
> +			WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
> +		}
> +
> +		task_unlock(task);
> +
> +		if (ns) {
> +			down_write(&shm_ids(ns).rwsem);
>   			shm_lock_by_ptr(shp);
> -			shm_destroy(ns, shp);
> +			/*
> +			 * rcu_read_lock was implicitly taken in
> +			 * shm_lock_by_ptr, it's safe to call
> +			 * ipc_rcu_putref here
> +			 */
> +			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
> +
> +			if (ipc_valid_object(&shp->shm_perm)) {
> +				if (shm_may_destroy(shp))
> +					shm_destroy(ns, shp);
> +				else
> +					shm_unlock(shp);
> +			} else {
> +				/*
> +				 * Someone else deleted the shp from namespace
> +				 * idr/kht while we have waited.
> +				 * Just unlock and continue.
> +				 */
> +				shm_unlock(shp);
> +			}
> +
> +			up_write(&shm_ids(ns).rwsem);
> +			put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
>   		}
>   	}
> -
> -	/* Remove the list head from any segments still attached. */
> -	list_del(&task->sysvshm.shm_clist);
> -	up_write(&shm_ids(ns).rwsem);
>   }
>   
>   static vm_fault_t shm_fault(struct vm_fault *vmf)
> @@ -680,7 +755,11 @@ static int newseg(struct ipc_namespace *
>   	if (error < 0)
>   		goto no_id;
>   
> +	shp->ns = ns;
> +
> +	task_lock(current);
>   	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
> +	task_unlock(current);
>   
>   	/*
>   	 * shmid gets reported as "inode#" in /proc/pid/maps.
> @@ -1573,7 +1652,8 @@ out_nattch:
>   	down_write(&shm_ids(ns).rwsem);
>   	shp = shm_lock(ns, shmid);
>   	shp->shm_nattch--;
> -	if (shm_may_destroy(ns, shp))
> +
> +	if (shm_may_destroy(shp))
>   		shm_destroy(ns, shp);
>   	else
>   		shm_unlock(shp);
> _
>
> Patches currently in -mm which might be from alexander.mikhalitsyn@virtuozzo.com are
>
> ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch
> shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch


--------------7r6io3rUbRb3xAA6X0PuE8Wm
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-shm-extend-forced-shm-destroy-to-support-objects-fro.patch"
Content-Disposition: attachment;
 filename*0="0001-shm-extend-forced-shm-destroy-to-support-objects-fro.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkZjAyNGQ2MjdiZWIzZjIzZjJjNWI3OTVlMWFlODQxYTJkZDZmZjQ5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4YW5kZXIgTWlraGFsaXRzeW4gPGFsZXhhbmRl
ci5taWtoYWxpdHN5bkB2aXJ0dW96em8uY29tPgpEYXRlOiBUaHUsIDI4IE9jdCAyMDIxIDAx
OjQzOjQ4ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gc2htOiBleHRlbmQgZm9yY2VkIHNobSBk
ZXN0cm95IHRvIHN1cHBvcnQgb2JqZWN0cyBmcm9tCiBzZXZlcmFsIElQQyBuc2VzCgpDdXJy
ZW50bHksIGV4aXRfc2htIGZ1bmN0aW9uIG5vdCBkZXNpZ25lZCB0byB3b3JrIHByb3Blcmx5
IHdoZW4KdGFzay0+c3lzdnNobS5zaG1fY2xpc3QgaG9sZHMgc2htIG9iamVjdHMgZnJvbSBk
aWZmZXJlbnQgSVBDIG5hbWVzcGFjZXMuCgpUaGlzIGlzIGEgcmVhbCBwYWluIHdoZW4gc3lz
Y3RsIGtlcm5lbC5zaG1fcm1pZF9mb3JjZWQgPSAxLCBiZWNhdXNlCml0IGxlYWRzIHRvIHVz
ZS1hZnRlci1mcmVlIChyZXByb2R1Y2VyIGV4aXN0cykuCgpUaGF0IHBhcnRpY3VsYXIgcGF0
Y2ggaXMgYXR0ZW1wdCB0byBmaXggdGhlIHByb2JsZW0gYnkgZXh0ZW5kaW5nIGV4aXRfc2ht
Cm1lY2hhbmlzbSB0byBoYW5kbGUgc2htJ3MgZGVzdHJveSBmcm9tIHNldmVyYWwgSVBDIG5z
J2VzLgoKVG8gYWNoaWV2ZSB0aGF0IHdlIGRvIHNldmVyYWwgdGhpbmdzOgoxLiBhZGQgbmFt
ZXNwYWNlIChub24tcmVmY291bnRlZCkgcG9pbnRlciB0byB0aGUgc3RydWN0IHNobWlkX2tl
cm5lbAoyLiBkdXJpbmcgbmV3IHNobSBvYmplY3QgY3JlYXRpb24gKG5ld3NlZygpL3NobWdl
dCBzeXNjYWxsKSB3ZSBpbml0aWFsaXplCnRoaXMgcG9pbnRlciBieSBjdXJyZW50IHRhc2sg
SVBDIG5zCjMuIGV4aXRfc2htKCkgZnVsbHkgcmV3b3JrZWQgc3VjaCB0aGF0IGl0IHRyYXZl
cnNlcyBvdmVyIGFsbApzaHAncyBpbiB0YXNrLT5zeXN2c2htLnNobV9jbGlzdCBhbmQgZ2V0
cyBJUEMgbmFtZXNwYWNlIG5vdApmcm9tIGN1cnJlbnQgdGFzayBhcyBpdCB3YXMgYmVmb3Jl
IGJ1dCBmcm9tIHNocCdzIG9iamVjdCBpdHNlbGYsIHRoZW4KY2FsbCBzaG1fZGVzdHJveShz
aHAsIG5zKS4KCk5vdGUuIFdlIG5lZWQgdG8gYmUgcmVhbGx5IGNhcmVmdWwgaGVyZSwgYmVj
YXVzZSBhcyBpdCB3YXMgc2FpZCBiZWZvcmUKKDEpLCBvdXIgcG9pbnRlciB0byBJUEMgbnMg
bm9uLXJlZmNudCdlZC4gVG8gYmUgb24gdGhlIHNhZmUgc2lkZSB3ZSB1c2luZwpzcGVjaWFs
IGhlbHBlciBnZXRfaXBjX25zX25vdF96ZXJvKCkgd2hpY2ggYWxsb3dzIHRvIGdldCBJUEMg
bnMgcmVmY291bnRlcgpvbmx5IGlmIElQQyBucyBub3QgaW4gdGhlICJzdGF0ZSBvZiBkZXN0
cnVjdGlvbiIuCgpRL0EKClE6IFdoeSB3ZSBjYW4gYWNjZXNzIHNocC0+bnMgbWVtb3J5IHVz
aW5nIG5vbi1yZWZjb3VudGVkIHBvaW50ZXI/CkE6IEJlY2F1c2Ugc2hwIG9iamVjdCBsaWZl
dGltZSBpcyBhbHdheXMgc2hvcnRoZXIKdGhhbiBJUEMgbmFtZXNwYWNlIGxpZmV0aW1lLCBz
bywgaWYgd2UgZ2V0IHNocCBvYmplY3QgZnJvbSB0aGUKdGFzay0+c3lzdnNobS5zaG1fY2xp
c3Qgd2hpbGUgaG9sZGluZyB0YXNrX2xvY2sodGFzaykgbm9ib2R5IGNhbgpzdGVhbCBvdXIg
bmFtZXNwYWNlLgoKUTogRG9lcyB0aGlzIHBhdGNoIGNoYW5nZSBzZW1hbnRpY3Mgb2YgdW5z
aGFyZS9zZXRucy9jbG9uZSBzeXNjYWxscz8KQTogTm90LiBJdCdzIGp1c3QgZml4ZXMgbm9u
LWNvdmVyZWQgY2FzZSB3aGVuIHByb2Nlc3MgbWF5IGxlYXZlCklQQyBuYW1lc3BhY2Ugd2l0
aG91dCBnZXR0aW5nIHRhc2stPnN5c3ZzaG0uc2htX2NsaXN0IGxpc3QgY2xlYW5lZCB1cC4K
CkZpeGVzOiBhYjYwMmY3OTkxNSAoInNobTogbWFrZSBleGl0X3NobSB3b3JrIHByb3BvcnRp
b25hbCB0byB0YXNrIGFjdGl2aXR5IikKCkNjOiAiRXJpYyBXLiBCaWVkZXJtYW4iIDxlYmll
ZGVybUB4bWlzc2lvbi5jb20+CkNjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnPgpDYzogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZlQHN0Z29sYWJzLm5ldD4KQ2M6
IEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPgpDYzogQW5kcmVpIFZhZ2lu
IDxhdmFnaW5AZ21haWwuY29tPgpDYzogUGF2ZWwgVGlraG9taXJvdiA8cHRpa2hvbWlyb3ZA
dmlydHVvenpvLmNvbT4KQ2M6IFZhc2lseSBBdmVyaW4gPHZ2c0B2aXJ0dW96em8uY29tPgpD
YzogTWFuZnJlZCBTcHJhdWwgPG1hbmZyZWRAY29sb3JmdWxsaWZlLmNvbT4KQ2M6IEFsZXhh
bmRlciBNaWtoYWxpdHN5biA8YWxleGFuZGVyQG1paGFsaWN5bi5jb20+CkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnCkNvLWRldmVsb3BlZC1ieTogTWFuZnJlZCBTcHJhdWwgPG1hbmZy
ZWRAY29sb3JmdWxsaWZlLmNvbT4KU2lnbmVkLW9mZi1ieTogTWFuZnJlZCBTcHJhdWwgPG1h
bmZyZWRAY29sb3JmdWxsaWZlLmNvbT4KU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIE1pa2hh
bGl0c3luIDxhbGV4YW5kZXIubWlraGFsaXRzeW5AdmlydHVvenpvLmNvbT4KLSBjb21tZW50
IGNvcnJlY3Rpb25zLCBzaG1fY2xpc3RfbG9jayB3YXMgcmVwbGFjZWQgYnkgdGFza19sb2Nr
KCkKLSBpZi9lbHNlIGV4Y2hhbmdlZCBhcyByZWNvbW1lbmRlZCBieSBFcmljCi0gYnVnZml4
IGZvciBzaHAgcmVmY291bnRpbmcuIEFjdHVhbGx5LCB0aGlzIHByb2JhYmx5IHRoZSByZWFs
CiAgdXNlLWFmdGVyLWZyZWUgYnVnLCB0aGUgY3VycmVudCBjb2RlIGNvbnRhaW5zIGEgdXNl
LWFmdGVyLWZyZWUgZXZlbgogIHdpdGhvdXQgdXNpbmcgbmFtZXNwYWNlcy4KLSBhZGQgcmN1
X3JlYWRfbG9jaygpIGludG8gc2htX2NsaXN0X3JtKCksIHRvIHByb3RlY3QgYWdhaW5zdAog
IGEgdXNlLWFmdGVyLWZyZWUgZm9yIHNobV9jcmVhdG9yLT5hbGxvY19sb2NrLgpTaWduZWQt
b2ZmLWJ5OiBNYW5mcmVkIFNwcmF1bCA8bWFuZnJlZEBjb2xvcmZ1bGxpZmUuY29tPgotLS0K
IGluY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIHwgIDE1ICsrKwogaW5jbHVkZS9saW51
eC9zY2hlZC90YXNrLmggICAgfCAgIDIgKy0KIGlwYy9zaG0uYyAgICAgICAgICAgICAgICAg
ICAgIHwgMTg2ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIDMgZmlsZXMg
Y2hhbmdlZCwgMTU2IGluc2VydGlvbnMoKyksIDQ3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIGIvaW5jbHVkZS9saW51eC9pcGNf
bmFtZXNwYWNlLmgKaW5kZXggMDVlMjI3NzBhZjUxLi5iNzUzOTVlYzhkNTIgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oCisrKyBiL2luY2x1ZGUvbGludXgv
aXBjX25hbWVzcGFjZS5oCkBAIC0xMzEsNiArMTMxLDE2IEBAIHN0YXRpYyBpbmxpbmUgc3Ry
dWN0IGlwY19uYW1lc3BhY2UgKmdldF9pcGNfbnMoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5z
KQogCXJldHVybiBuczsKIH0KIAorc3RhdGljIGlubGluZSBzdHJ1Y3QgaXBjX25hbWVzcGFj
ZSAqZ2V0X2lwY19uc19ub3RfemVybyhzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMpCit7CisJ
aWYgKG5zKSB7CisJCWlmIChyZWZjb3VudF9pbmNfbm90X3plcm8oJm5zLT5ucy5jb3VudCkp
CisJCQlyZXR1cm4gbnM7CisJfQorCisJcmV0dXJuIE5VTEw7Cit9CisKIGV4dGVybiB2b2lk
IHB1dF9pcGNfbnMoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zKTsKICNlbHNlCiBzdGF0aWMg
aW5saW5lIHN0cnVjdCBpcGNfbmFtZXNwYWNlICpjb3B5X2lwY3ModW5zaWduZWQgbG9uZyBm
bGFncywKQEAgLTE0Nyw2ICsxNTcsMTEgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgaXBjX25h
bWVzcGFjZSAqZ2V0X2lwY19ucyhzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMpCiAJcmV0dXJu
IG5zOwogfQogCitzdGF0aWMgaW5saW5lIHN0cnVjdCBpcGNfbmFtZXNwYWNlICpnZXRfaXBj
X25zX25vdF96ZXJvKHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucykKK3sKKwlyZXR1cm4gbnM7
Cit9CisKIHN0YXRpYyBpbmxpbmUgdm9pZCBwdXRfaXBjX25zKHN0cnVjdCBpcGNfbmFtZXNw
YWNlICpucykKIHsKIH0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2NoZWQvdGFzay5o
IGIvaW5jbHVkZS9saW51eC9zY2hlZC90YXNrLmgKaW5kZXggYmE4OGE2OTg3NDAwLi4wNThk
N2YzNzFlMjUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQvdGFzay5oCisrKyBi
L2luY2x1ZGUvbGludXgvc2NoZWQvdGFzay5oCkBAIC0xNTgsNyArMTU4LDcgQEAgc3RhdGlj
IGlubGluZSBzdHJ1Y3Qgdm1fc3RydWN0ICp0YXNrX3N0YWNrX3ZtX2FyZWEoY29uc3Qgc3Ry
dWN0IHRhc2tfc3RydWN0ICp0KQogICogUHJvdGVjdHMgLT5mcywgLT5maWxlcywgLT5tbSwg
LT5ncm91cF9pbmZvLCAtPmNvbW0sIGtleXJpbmcKICAqIHN1YnNjcmlwdGlvbnMgYW5kIHN5
bmNocm9uaXNlcyB3aXRoIHdhaXQ0KCkuICBBbHNvIHVzZWQgaW4gcHJvY2ZzLiAgQWxzbwog
ICogcGlucyB0aGUgZmluYWwgcmVsZWFzZSBvZiB0YXNrLmlvX2NvbnRleHQuICBBbHNvIHBy
b3RlY3RzIC0+Y3B1c2V0IGFuZAotICogLT5jZ3JvdXAuc3Vic3lzW10uIEFuZCAtPnZmb3Jr
X2RvbmUuCisgKiAtPmNncm91cC5zdWJzeXNbXS4gQW5kIC0+dmZvcmtfZG9uZS4gQW5kIC0+
c3lzdnNobS5zaG1fY2xpc3QuCiAgKgogICogTmVzdHMgYm90aCBpbnNpZGUgYW5kIG91dHNp
ZGUgb2YgcmVhZF9sb2NrKCZ0YXNrbGlzdF9sb2NrKS4KICAqIEl0IG11c3Qgbm90IGJlIG5l
c3RlZCB3aXRoIHdyaXRlX2xvY2tfaXJxKCZ0YXNrbGlzdF9sb2NrKSwKZGlmZiAtLWdpdCBh
L2lwYy9zaG0uYyBiL2lwYy9zaG0uYwppbmRleCBhYjc0OWJlNmQ4YjcuLjkzOWZhMmRlNGRl
NyAxMDA2NDQKLS0tIGEvaXBjL3NobS5jCisrKyBiL2lwYy9zaG0uYwpAQCAtNjIsOSArNjIs
MTggQEAgc3RydWN0IHNobWlkX2tlcm5lbCAvKiBwcml2YXRlIHRvIHRoZSBrZXJuZWwgKi8K
IAlzdHJ1Y3QgcGlkCQkqc2htX2xwcmlkOwogCXN0cnVjdCB1Y291bnRzCQkqbWxvY2tfdWNv
dW50czsKIAotCS8qIFRoZSB0YXNrIGNyZWF0ZWQgdGhlIHNobSBvYmplY3QuICBOVUxMIGlm
IHRoZSB0YXNrIGlzIGRlYWQuICovCisJLyoKKwkgKiBUaGUgdGFzayBjcmVhdGVkIHRoZSBz
aG0gb2JqZWN0LCBmb3IKKwkgKiB0YXNrX2xvY2soc2hwLT5zaG1fY3JlYXRvcikKKwkgKi8K
IAlzdHJ1Y3QgdGFza19zdHJ1Y3QJKnNobV9jcmVhdG9yOwotCXN0cnVjdCBsaXN0X2hlYWQJ
c2htX2NsaXN0OwkvKiBsaXN0IGJ5IGNyZWF0b3IgKi8KKworCS8qCisJICogTGlzdCBieSBj
cmVhdG9yLiB0YXNrX2xvY2soLT5zaG1fY3JlYXRvcikgcmVxdWlyZWQgZm9yIHJlYWQvd3Jp
dGUuCisJICogSWYgbGlzdF9lbXB0eSgpLCB0aGVuIHRoZSBjcmVhdG9yIGlzIGRlYWQgYWxy
ZWFkeS4KKwkgKi8KKwlzdHJ1Y3QgbGlzdF9oZWFkCXNobV9jbGlzdDsKKwlzdHJ1Y3QgaXBj
X25hbWVzcGFjZQkqbnM7CiB9IF9fcmFuZG9taXplX2xheW91dDsKIAogLyogc2htX21vZGUg
dXBwZXIgYnl0ZSBmbGFncyAqLwpAQCAtMTE1LDYgKzEyNCw3IEBAIHN0YXRpYyB2b2lkIGRv
X3NobV9ybWlkKHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGtlcm5faXBjX3Bl
cm0gKmlwY3ApCiAJc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwOwogCiAJc2hwID0gY29udGFp
bmVyX29mKGlwY3AsIHN0cnVjdCBzaG1pZF9rZXJuZWwsIHNobV9wZXJtKTsKKwlXQVJOX09O
KG5zICE9IHNocC0+bnMpOwogCiAJaWYgKHNocC0+c2htX25hdHRjaCkgewogCQlzaHAtPnNo
bV9wZXJtLm1vZGUgfD0gU0hNX0RFU1Q7CkBAIC0yMjUsMTAgKzIzNSw0MyBAQCBzdGF0aWMg
dm9pZCBzaG1fcmN1X2ZyZWUoc3RydWN0IHJjdV9oZWFkICpoZWFkKQogCWtmcmVlKHNocCk7
CiB9CiAKLXN0YXRpYyBpbmxpbmUgdm9pZCBzaG1fcm1pZChzdHJ1Y3QgaXBjX25hbWVzcGFj
ZSAqbnMsIHN0cnVjdCBzaG1pZF9rZXJuZWwgKnMpCisvKgorICogSXQgaGFzIHRvIGJlIGNh
bGxlZCB3aXRoIHNocCBsb2NrZWQuCisgKiBJdCBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgaXBj
X3JtaWQoKQorICovCitzdGF0aWMgaW5saW5lIHZvaWQgc2htX2NsaXN0X3JtKHN0cnVjdCBz
aG1pZF9rZXJuZWwgKnNocCkKK3sKKwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKmNyZWF0b3I7CisK
KwkvKiBlbnN1cmUgdGhhdCBzaG1fY3JlYXRvciBkb2VzIG5vdCBkaXNhcHBlYXIgKi8KKwly
Y3VfcmVhZF9sb2NrKCk7CisKKwkvKgorCSAqIEEgY29uY3VycmVudCBleGl0X3NobSBtYXkg
ZG8gYSBsaXN0X2RlbF9pbml0KCkgYXMgd2VsbC4KKwkgKiBKdXN0IGRvIG5vdGhpbmcgaWYg
ZXhpdF9zaG0gYWxyZWFkeSBkaWQgdGhlIHdvcmsKKwkgKi8KKwlpZiAoIWxpc3RfZW1wdHko
JnNocC0+c2htX2NsaXN0KSkgeworCQkvKgorCQkgKiBzaHAtPnNobV9jcmVhdG9yIGlzIGd1
YXJhbnRlZWQgdG8gYmUgdmFsaWQgKm9ubHkqCisJCSAqIGlmIHNocC0+c2htX2NsaXN0IGlz
IG5vdCBlbXB0eS4KKwkJICovCisJCWNyZWF0b3IgPSBzaHAtPnNobV9jcmVhdG9yOworCisJ
CXRhc2tfbG9jayhjcmVhdG9yKTsKKwkJLyoKKwkJICogbGlzdF9kZWxfaW5pdCgpIGlzIGEg
bm9wIGlmIHRoZSBlbnRyeSB3YXMgYWxyZWFkeSByZW1vdmVkCisJCSAqIGZyb20gdGhlIGxp
c3QuCisJCSAqLworCQlsaXN0X2RlbF9pbml0KCZzaHAtPnNobV9jbGlzdCk7CisJCXRhc2tf
dW5sb2NrKGNyZWF0b3IpOworCX0KKwlyY3VfcmVhZF91bmxvY2soKTsKK30KKworc3RhdGlj
IGlubGluZSB2b2lkIHNobV9ybWlkKHN0cnVjdCBzaG1pZF9rZXJuZWwgKnMpCiB7Ci0JbGlz
dF9kZWwoJnMtPnNobV9jbGlzdCk7Ci0JaXBjX3JtaWQoJnNobV9pZHMobnMpLCAmcy0+c2ht
X3Blcm0pOworCXNobV9jbGlzdF9ybShzKTsKKwlpcGNfcm1pZCgmc2htX2lkcyhzLT5ucyks
ICZzLT5zaG1fcGVybSk7CiB9CiAKIApAQCAtMjgzLDcgKzMyNiw3IEBAIHN0YXRpYyB2b2lk
IHNobV9kZXN0cm95KHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IHNobWlkX2tl
cm5lbCAqc2hwKQogCXNobV9maWxlID0gc2hwLT5zaG1fZmlsZTsKIAlzaHAtPnNobV9maWxl
ID0gTlVMTDsKIAlucy0+c2htX3RvdCAtPSAoc2hwLT5zaG1fc2Vnc3ogKyBQQUdFX1NJWkUg
LSAxKSA+PiBQQUdFX1NISUZUOwotCXNobV9ybWlkKG5zLCBzaHApOworCXNobV9ybWlkKHNo
cCk7CiAJc2htX3VubG9jayhzaHApOwogCWlmICghaXNfZmlsZV9odWdlcGFnZXMoc2htX2Zp
bGUpKQogCQlzaG1lbV9sb2NrKHNobV9maWxlLCAwLCBzaHAtPm1sb2NrX3Vjb3VudHMpOwpA
QCAtMzA2LDEwICszNDksMTAgQEAgc3RhdGljIHZvaWQgc2htX2Rlc3Ryb3koc3RydWN0IGlw
Y19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3Qgc2htaWRfa2VybmVsICpzaHApCiAgKgogICogMikg
c3lzY3RsIGtlcm5lbC5zaG1fcm1pZF9mb3JjZWQgaXMgc2V0IHRvIDEuCiAgKi8KLXN0YXRp
YyBib29sIHNobV9tYXlfZGVzdHJveShzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMsIHN0cnVj
dCBzaG1pZF9rZXJuZWwgKnNocCkKK3N0YXRpYyBib29sIHNobV9tYXlfZGVzdHJveShzdHJ1
Y3Qgc2htaWRfa2VybmVsICpzaHApCiB7CiAJcmV0dXJuIChzaHAtPnNobV9uYXR0Y2ggPT0g
MCkgJiYKLQkgICAgICAgKG5zLT5zaG1fcm1pZF9mb3JjZWQgfHwKKwkgICAgICAgKHNocC0+
bnMtPnNobV9ybWlkX2ZvcmNlZCB8fAogCQkoc2hwLT5zaG1fcGVybS5tb2RlICYgU0hNX0RF
U1QpKTsKIH0KIApAQCAtMzQwLDcgKzM4Myw3IEBAIHN0YXRpYyB2b2lkIHNobV9jbG9zZShz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkKIAlpcGNfdXBkYXRlX3BpZCgmc2hwLT5zaG1f
bHByaWQsIHRhc2tfdGdpZChjdXJyZW50KSk7CiAJc2hwLT5zaG1fZHRpbSA9IGt0aW1lX2dl
dF9yZWFsX3NlY29uZHMoKTsKIAlzaHAtPnNobV9uYXR0Y2gtLTsKLQlpZiAoc2htX21heV9k
ZXN0cm95KG5zLCBzaHApKQorCWlmIChzaG1fbWF5X2Rlc3Ryb3koc2hwKSkKIAkJc2htX2Rl
c3Ryb3kobnMsIHNocCk7CiAJZWxzZQogCQlzaG1fdW5sb2NrKHNocCk7CkBAIC0zNjEsMTAg
KzQwNCwxMCBAQCBzdGF0aWMgaW50IHNobV90cnlfZGVzdHJveV9vcnBoYW5lZChpbnQgaWQs
IHZvaWQgKnAsIHZvaWQgKmRhdGEpCiAJICoKIAkgKiBBcyBzaHAtPiogYXJlIGNoYW5nZWQg
dW5kZXIgcndzZW0sIGl0J3Mgc2FmZSB0byBza2lwIHNocCBsb2NraW5nLgogCSAqLwotCWlm
IChzaHAtPnNobV9jcmVhdG9yICE9IE5VTEwpCisJaWYgKCFsaXN0X2VtcHR5KCZzaHAtPnNo
bV9jbGlzdCkpCiAJCXJldHVybiAwOwogCi0JaWYgKHNobV9tYXlfZGVzdHJveShucywgc2hw
KSkgeworCWlmIChzaG1fbWF5X2Rlc3Ryb3koc2hwKSkgewogCQlzaG1fbG9ja19ieV9wdHIo
c2hwKTsKIAkJc2htX2Rlc3Ryb3kobnMsIHNocCk7CiAJfQpAQCAtMzgyLDQ4ICs0MjUsOTQg
QEAgdm9pZCBzaG1fZGVzdHJveV9vcnBoYW5lZChzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMp
CiAvKiBMb2NraW5nIGFzc3VtZXMgdGhpcyB3aWxsIG9ubHkgYmUgY2FsbGVkIHdpdGggdGFz
ayA9PSBjdXJyZW50ICovCiB2b2lkIGV4aXRfc2htKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFz
aykKIHsKLQlzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMgPSB0YXNrLT5uc3Byb3h5LT5pcGNf
bnM7Ci0Jc3RydWN0IHNobWlkX2tlcm5lbCAqc2hwLCAqbjsKKwlmb3IgKDs7KSB7CisJCXN0
cnVjdCBzaG1pZF9rZXJuZWwgKnNocDsKKwkJc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zOwog
Ci0JaWYgKGxpc3RfZW1wdHkoJnRhc2stPnN5c3ZzaG0uc2htX2NsaXN0KSkKLQkJcmV0dXJu
OworCQl0YXNrX2xvY2sodGFzayk7CisKKwkJaWYgKGxpc3RfZW1wdHkoJnRhc2stPnN5c3Zz
aG0uc2htX2NsaXN0KSkgeworCQkJdGFza191bmxvY2sodGFzayk7CisJCQlicmVhazsKKwkJ
fQorCisJCXNocCA9IGxpc3RfZmlyc3RfZW50cnkoJnRhc2stPnN5c3ZzaG0uc2htX2NsaXN0
LCBzdHJ1Y3Qgc2htaWRfa2VybmVsLAorCQkJCXNobV9jbGlzdCk7CiAKLQkvKgotCSAqIElm
IGtlcm5lbC5zaG1fcm1pZF9mb3JjZWQgaXMgbm90IHNldCB0aGVuIG9ubHkga2VlcCB0cmFj
ayBvZgotCSAqIHdoaWNoIHNobWlkcyBhcmUgb3JwaGFuZWQsIHNvIHRoYXQgYSBsYXRlciBz
ZXQgb2YgdGhlIHN5c2N0bAotCSAqIGNhbiBjbGVhbiB0aGVtIHVwLgotCSAqLwotCWlmICgh
bnMtPnNobV9ybWlkX2ZvcmNlZCkgewotCQlkb3duX3JlYWQoJnNobV9pZHMobnMpLnJ3c2Vt
KTsKLQkJbGlzdF9mb3JfZWFjaF9lbnRyeShzaHAsICZ0YXNrLT5zeXN2c2htLnNobV9jbGlz
dCwgc2htX2NsaXN0KQotCQkJc2hwLT5zaG1fY3JlYXRvciA9IE5VTEw7CiAJCS8qCi0JCSAq
IE9ubHkgdW5kZXIgcmVhZCBsb2NrIGJ1dCB3ZSBhcmUgb25seSBjYWxsZWQgb24gY3VycmVu
dAotCQkgKiBzbyBubyBlbnRyeSBvbiB0aGUgbGlzdCB3aWxsIGJlIHNoYXJlZC4KKwkJICog
MSkgZ2V0IGEgcmVmZXJlbmNlIHRvIHNocC4KKwkJICogICAgVGhpcyBtdXN0IGJlIGRvbmUg
Zmlyc3Q6IFJpZ2h0IG5vdywgdGFza19sb2NrKCkgcHJldmVudHMKKwkJICogICAgYW55IGNv
bmN1cnJlbnQgSVBDX1JNSUQgY2FsbHMuIEFmdGVyIHRoZSBsaXN0X2RlbF9pbml0KCksCisJ
CSAqICAgIElQQ19STUlEIHdpbGwgbm90IGFjcXVpcmUgdGFza19sb2NrKC0+c2htX2NyZWF0
b3IpCisJCSAqICAgIGFueW1vcmUuCiAJCSAqLwotCQlsaXN0X2RlbCgmdGFzay0+c3lzdnNo
bS5zaG1fY2xpc3QpOwotCQl1cF9yZWFkKCZzaG1faWRzKG5zKS5yd3NlbSk7Ci0JCXJldHVy
bjsKLQl9CisJCVdBUk5fT04oIWlwY19yY3VfZ2V0cmVmKCZzaHAtPnNobV9wZXJtKSk7CiAK
LQkvKgotCSAqIERlc3Ryb3kgYWxsIGFscmVhZHkgY3JlYXRlZCBzZWdtZW50cywgdGhhdCB3
ZXJlIG5vdCB5ZXQgbWFwcGVkLAotCSAqIGFuZCBtYXJrIGFueSBtYXBwZWQgYXMgb3JwaGFu
IHRvIGNvdmVyIHRoZSBzeXNjdGwgdG9nZ2xpbmcuCi0JICogRGVzdHJveSBpcyBza2lwcGVk
IGlmIHNobV9tYXlfZGVzdHJveSgpIHJldHVybnMgZmFsc2UuCi0JICovCi0JZG93bl93cml0
ZSgmc2htX2lkcyhucykucndzZW0pOwotCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShzaHAs
IG4sICZ0YXNrLT5zeXN2c2htLnNobV9jbGlzdCwgc2htX2NsaXN0KSB7Ci0JCXNocC0+c2ht
X2NyZWF0b3IgPSBOVUxMOworCQkvKiAyKSB1bmxpbmsgKi8KKwkJbGlzdF9kZWxfaW5pdCgm
c2hwLT5zaG1fY2xpc3QpOworCisJCS8qCisJCSAqIDMpIEdldCBwb2ludGVyIHRvIHRoZSBp
cGMgbmFtZXNwYWNlLiBJdCBpcyB3b3J0aCB0byBzYXkKKwkJICogdGhhdCB0aGlzIHBvaW50
ZXIgaXMgZ3VhcmFudGVlZCB0byBiZSB2YWxpZCBiZWNhdXNlCisJCSAqIHNocCBsaWZldGlt
ZSBpcyBhbHdheXMgc2hvcnRlciB0aGFuIG5hbWVzcGFjZSBsaWZldGltZQorCQkgKiBpbiB3
aGljaCBzaHAgbGl2ZXMuCisJCSAqIFdlIHRha2VuIHRhc2tfbG9jayBpdCBtZWFucyB0aGF0
IHNocCB3b24ndCBiZSBmcmVlZC4KKwkJICovCisJCW5zID0gc2hwLT5uczsKIAotCQlpZiAo
c2htX21heV9kZXN0cm95KG5zLCBzaHApKSB7Ci0JCQlzaG1fbG9ja19ieV9wdHIoc2hwKTsK
LQkJCXNobV9kZXN0cm95KG5zLCBzaHApOworCQkvKgorCQkgKiA0KSBJZiBrZXJuZWwuc2ht
X3JtaWRfZm9yY2VkIGlzIG5vdCBzZXQgdGhlbiBvbmx5IGtlZXAgdHJhY2sgb2YKKwkJICog
d2hpY2ggc2htaWRzIGFyZSBvcnBoYW5lZCwgc28gdGhhdCBhIGxhdGVyIHNldCBvZiB0aGUg
c3lzY3RsCisJCSAqIGNhbiBjbGVhbiB0aGVtIHVwLgorCQkgKi8KKwkJaWYgKCFucy0+c2ht
X3JtaWRfZm9yY2VkKSB7CisJCQlpcGNfcmN1X3B1dHJlZigmc2hwLT5zaG1fcGVybSwgc2ht
X3JjdV9mcmVlKTsKKwkJCXRhc2tfdW5sb2NrKHRhc2spOworCQkJY29udGludWU7CiAJCX0K
LQl9CiAKLQkvKiBSZW1vdmUgdGhlIGxpc3QgaGVhZCBmcm9tIGFueSBzZWdtZW50cyBzdGls
bCBhdHRhY2hlZC4gKi8KLQlsaXN0X2RlbCgmdGFzay0+c3lzdnNobS5zaG1fY2xpc3QpOwot
CXVwX3dyaXRlKCZzaG1faWRzKG5zKS5yd3NlbSk7CisJCS8qCisJCSAqIDUpIGdldCBhIHJl
ZmVyZW5jZSB0byB0aGUgbmFtZXNwYWNlLgorCQkgKiAgICBUaGUgcmVmY291bnQgY291bGQg
YmUgYWxyZWFkeSAwLiBJZiBpdCBpcyAwLCB0aGVuCisJCSAqICAgIHRoZSBzaG0gb2JqZWN0
cyB3aWxsIGJlIGZyZWUgYnkgZnJlZV9pcGNfd29yaygpLgorCQkgKi8KKwkJbnMgPSBnZXRf
aXBjX25zX25vdF96ZXJvKG5zKTsKKwkJaWYgKCFucykgeworCQkJaXBjX3JjdV9wdXRyZWYo
JnNocC0+c2htX3Blcm0sIHNobV9yY3VfZnJlZSk7CisJCQl0YXNrX3VubG9jayh0YXNrKTsK
KwkJCWNvbnRpbnVlOworCQl9CisJCXRhc2tfdW5sb2NrKHRhc2spOworCisJCS8qCisJCSAq
IDYpIHdlIGhhdmUgYWxsIHJlZmVyZW5jZXMKKwkJICogICAgVGh1cyBsb2NrICYgaWYgbmVl
ZGVkIGRlc3Ryb3kgc2hwLgorCQkgKi8KKwkJZG93bl93cml0ZSgmc2htX2lkcyhucykucndz
ZW0pOworCQlzaG1fbG9ja19ieV9wdHIoc2hwKTsKKwkJLyoKKwkJICogcmN1X3JlYWRfbG9j
ayB3YXMgaW1wbGljaXRseSB0YWtlbiBpbiBzaG1fbG9ja19ieV9wdHIsIGl0J3MKKwkJICog
c2FmZSB0byBjYWxsIGlwY19yY3VfcHV0cmVmIGhlcmUKKwkJICovCisJCWlwY19yY3VfcHV0
cmVmKCZzaHAtPnNobV9wZXJtLCBzaG1fcmN1X2ZyZWUpOworCisJCWlmIChpcGNfdmFsaWRf
b2JqZWN0KCZzaHAtPnNobV9wZXJtKSkgeworCQkJaWYgKHNobV9tYXlfZGVzdHJveShzaHAp
KQorCQkJCXNobV9kZXN0cm95KG5zLCBzaHApOworCQkJZWxzZQorCQkJCXNobV91bmxvY2so
c2hwKTsKKwkJfSBlbHNlIHsKKwkJCS8qCisJCQkgKiBTb21lb25lIGVsc2UgZGVsZXRlZCB0
aGUgc2hwIGZyb20gbmFtZXNwYWNlCisJCQkgKiBpZHIva2h0IHdoaWxlIHdlIGhhdmUgd2Fp
dGVkLgorCQkJICogSnVzdCB1bmxvY2sgYW5kIGNvbnRpbnVlLgorCQkJICovCisJCQlzaG1f
dW5sb2NrKHNocCk7CisJCX0KKworCQl1cF93cml0ZSgmc2htX2lkcyhucykucndzZW0pOwor
CQlwdXRfaXBjX25zKG5zKTsgLyogcGFpcmVkIHdpdGggZ2V0X2lwY19uc19ub3RfemVybyAq
LworCX0KIH0KIAogc3RhdGljIHZtX2ZhdWx0X3Qgc2htX2ZhdWx0KHN0cnVjdCB2bV9mYXVs
dCAqdm1mKQpAQCAtNjgwLDcgKzc2OSwxMSBAQCBzdGF0aWMgaW50IG5ld3NlZyhzdHJ1Y3Qg
aXBjX25hbWVzcGFjZSAqbnMsIHN0cnVjdCBpcGNfcGFyYW1zICpwYXJhbXMpCiAJaWYgKGVy
cm9yIDwgMCkKIAkJZ290byBub19pZDsKIAorCXNocC0+bnMgPSBuczsKKworCXRhc2tfbG9j
ayhjdXJyZW50KTsKIAlsaXN0X2FkZCgmc2hwLT5zaG1fY2xpc3QsICZjdXJyZW50LT5zeXN2
c2htLnNobV9jbGlzdCk7CisJdGFza191bmxvY2soY3VycmVudCk7CiAKIAkvKgogCSAqIHNo
bWlkIGdldHMgcmVwb3J0ZWQgYXMgImlub2RlIyIgaW4gL3Byb2MvcGlkL21hcHMuCkBAIC0x
NTczLDcgKzE2NjYsOCBAQCBsb25nIGRvX3NobWF0KGludCBzaG1pZCwgY2hhciBfX3VzZXIg
KnNobWFkZHIsIGludCBzaG1mbGcsCiAJZG93bl93cml0ZSgmc2htX2lkcyhucykucndzZW0p
OwogCXNocCA9IHNobV9sb2NrKG5zLCBzaG1pZCk7CiAJc2hwLT5zaG1fbmF0dGNoLS07Ci0J
aWYgKHNobV9tYXlfZGVzdHJveShucywgc2hwKSkKKworCWlmIChzaG1fbWF5X2Rlc3Ryb3ko
c2hwKSkKIAkJc2htX2Rlc3Ryb3kobnMsIHNocCk7CiAJZWxzZQogCQlzaG1fdW5sb2NrKHNo
cCk7Ci0tIAoyLjMxLjEKCg==
--------------7r6io3rUbRb3xAA6X0PuE8Wm--

