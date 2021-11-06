Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A710446CF1
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 08:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhKFHxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 03:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhKFHxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 03:53:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F344FC061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 00:50:43 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c4so17266853wrd.9
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 00:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1G4+Yh01LoLMuYIgkdnhfoAQ9amM2lRToHxyXgKYjZw=;
        b=zp15R4a08jKwUdKSIUzvb0P7N7xId+nK+tW7PRahdNpN4haZUi2902nfKbFdmXBrEK
         FzICRAIOImTRkUci7UJPJzCuvtSQvOZcNsoWrIBX+y2Vla7xl9xTWOw/cuP+6QESSNrE
         BZU8Tvngoucf5xO22wHcR31ziNdQxMlYgUmMJBFHPq/qleUx7pqcenYpP3sQgVi+bjaS
         yiBEV4L5jAgOx1lrpihNRe/rtq5GnWAOEBliUu1YBZYdnrlBZR0N9adz8AmqUcoKB2pG
         WEHlgtjbVknezYv70KFJLKbe6SEF6T2sG+F1rUGF/4K5FacDFoincvglYLbqZlrS6hGM
         H8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1G4+Yh01LoLMuYIgkdnhfoAQ9amM2lRToHxyXgKYjZw=;
        b=1GGO3BzRNGC/DqzC5IBEss5OAwdhSiYnbS0hKozyPstFxJJ0PmfhnUGj0219IG/Hvr
         fQgONKRJHmrXfZ4bByJV8q8ZT02H/5cL4FtUERbyRu74dw4lYtjp5AWpSGZAESeo5k6E
         /mWf7Jiv//dYoy5/Oi3FCcpGhNV1zfIygbMQpzinzqrymtehE7O81jVcaRi0BscgwYu4
         SkoiWNTwBugeu+/3ttlIPfcWxTW0DPsrTQq3lu4TIduuhT5jG7PjgyDS9q4pcQBx3PWw
         JPlDu6fT+JOSqn8NzwvA55Et/yF/bSXyNPCIyRqgqHicRKk1i+fvB7NYGNpkMy7wGdEE
         K+eA==
X-Gm-Message-State: AOAM532XfNBIjsr8u3SP9FYWURXQfnIBo8i48C1avNaOU+kQuPU7tlcc
        mJdvPsjTwk8Z3gWxgPFlVOZo8A==
X-Google-Smtp-Source: ABdhPJxNzyjfhxUc7J3SG48VEIu7sDLkWP2TL7xFnSQNir6v5vjbQZqHCpTqY/7/uLC8wrs/1O3LHQ==
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr19721662wrg.433.1636185042490;
        Sat, 06 Nov 2021 00:50:42 -0700 (PDT)
Received: from ?IPV6:2003:d9:973c:5300:2047:e88a:31d4:666? (p200300d9973c53002047e88a31d40666.dip0.t-ipconnect.de. [2003:d9:973c:5300:2047:e88a:31d4:666])
        by smtp.googlemail.com with ESMTPSA id t4sm835645wmi.48.2021.11.06.00.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 00:50:42 -0700 (PDT)
Message-ID: <803cf1bf-1934-abf7-727a-91a0458e3b3a@colorfullife.com>
Date:   Sat, 6 Nov 2021 08:50:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC] shm: extend forced shm destroy to support objects from
 several IPC nses (simplified)
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org,
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
 <61ca7331-4a86-2bf6-9ccb-50f6a7824e12@colorfullife.com>
 <87lf22qob5.fsf_-_@disp2133>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <87lf22qob5.fsf_-_@disp2133>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On 11/5/21 22:34, Eric W. Biederman wrote:
> I have to dash so this is short.

As last time, I'll review the change and check for new/good ideas.

As first question: Is the change tested?

[...]

>   
>   	/* The task created the shm object.  NULL if the task is dead. */
> -	struct task_struct	*shm_creator;
> +	struct task_struct __rcu *shm_creator;
>   	struct list_head	shm_clist;	/* list by creator */
> +	struct ipc_namespace	*shm_ns;	/* valid when shm_nattch != 0 */
>   } __randomize_layout;
>   
There is no reason to modify shm_creator:

We need _one_ indicator that the creator has died, not two.

We have both list_empty() and shm_creator. Thus we should/must define 
what is the relevant indicator, and every function must use the same one.

exit_sem() must walk shm_clist. list_empty() must return the correct answer.

Thus I think it is simpler that list_empty() is the indicator.

In addition, as you have correctly noticed: If we make shm_creator==NULL 
the indicator, then we must use at __rcu or at least READ_ONCE() accessors.

But: This would only solve a self created problem. Just leave 
shm_creator unmodified - and the need for READ_ONCE() goes away.

>   /* shm_mode upper byte flags */
> @@ -106,29 +107,17 @@ void shm_init_ns(struct ipc_namespace *ns)
>   	ipc_init_ids(&shm_ids(ns));
>   }
>   
> -/*
> - * Called with shm_ids.rwsem (writer) and the shp structure locked.
> - * Only shm_ids.rwsem remains locked on exit.
> - */
> -static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
> +static void do_shm_destroy(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>   {
> -	struct shmid_kernel *shp;
> -
> -	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
> -
> -	if (shp->shm_nattch) {
> -		shp->shm_perm.mode |= SHM_DEST;
> -		/* Do not find it any more */
> -		ipc_set_key_private(&shm_ids(ns), &shp->shm_perm);
> -		shm_unlock(shp);
> -	} else
> -		shm_destroy(ns, shp);
> +	struct shmid_kernel *shp =
> +		container_of(ipcp, struct shmid_kernel, shm_perm);
> +	shm_destroy(ns, shp);
>   }
>   
>   #ifdef CONFIG_IPC_NS
>   void shm_exit_ns(struct ipc_namespace *ns)
>   {
> -	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
> +	free_ipcs(ns, &shm_ids(ns), do_shm_destroy);
>   	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
>   	rhashtable_destroy(&ns->ids[IPC_SHM_IDS].key_ht);
>   }
> @@ -225,9 +214,22 @@ static void shm_rcu_free(struct rcu_head *head)
>   	kfree(shp);
>   }
>   
> +static inline void shm_clist_del(struct shmid_kernel *shp)
> +{
> +	struct task_struct *creator;
> +
> +	rcu_read_lock();
> +	creator = rcu_dereference(shp->shm_creator);
> +	if (creator) {
> +		task_lock(creator);
> +		list_del(&shp->shm_clist);

Does this work? You are using list_del() instead of list_del_init().

I fear that this might break exit_sem()

> +		task_unlock(creator);
> +	}
> +	rcu_read_unlock();
> +}
> +
>   static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
>   {
> -	list_del(&s->shm_clist);
>   	ipc_rmid(&shm_ids(ns), &s->shm_perm);
>   }
>   
> @@ -283,7 +285,9 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>   	shm_file = shp->shm_file;
>   	shp->shm_file = NULL;
>   	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	shm_clist_del(shp);
>   	shm_rmid(ns, shp);
> +	shp->shm_ns = NULL;
>   	shm_unlock(shp);
>   	if (!is_file_hugepages(shm_file))
>   		shmem_lock(shm_file, 0, shp->mlock_ucounts);
> @@ -361,7 +365,7 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
>   	 *
>   	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
>   	 */
> -	if (shp->shm_creator != NULL)
> +	if (rcu_access_pointer(shp->shm_creator) != NULL)
>   		return 0;
>   
>   	if (shm_may_destroy(ns, shp)) {
> @@ -382,48 +386,62 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
>   /* Locking assumes this will only be called with task == current */
>   void exit_shm(struct task_struct *task)
>   {
> -	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
> -	struct shmid_kernel *shp, *n;
> -
> -	if (list_empty(&task->sysvshm.shm_clist))
> -		return;
> -
> -	/*
> -	 * If kernel.shm_rmid_forced is not set then only keep track of
> -	 * which shmids are orphaned, so that a later set of the sysctl
> -	 * can clean them up.
> -	 */
> -	if (!ns->shm_rmid_forced) {
> -		down_read(&shm_ids(ns).rwsem);
> -		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
> -			shp->shm_creator = NULL;
> -		/*
> -		 * Only under read lock but we are only called on current
> -		 * so no entry on the list will be shared.
> -		 */
> -		list_del(&task->sysvshm.shm_clist);
> -		up_read(&shm_ids(ns).rwsem);
> -		return;
> -	}
> +	struct list_head *head = &task->sysvshm.shm_clist;
>   
>   	/*
>   	 * Destroy all already created segments, that were not yet mapped,
>   	 * and mark any mapped as orphan to cover the sysctl toggling.
>   	 * Destroy is skipped if shm_may_destroy() returns false.
>   	 */
> -	down_write(&shm_ids(ns).rwsem);
> -	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
> -		shp->shm_creator = NULL;
> +	for (;;) {
> +		struct ipc_namespace *ns;
> +		struct shmid_kernel *shp;
>   
> -		if (shm_may_destroy(ns, shp)) {
> +		task_lock(task);
> +		if (list_empty(head)) {
> +			task_unlock(task);
> +			break;
> +		}
> +
> +		shp = list_first_entry(head, struct shmid_kernel, shm_clist);
> +
> +		list_del(&shp->shm_clist);
> +		rcu_assign_pointer(shp->shm_creator, NULL);
> +
> +		/*
> +		 * Guarantee that ns lives after task_list is dropped.
> +		 *
> +		 * This shm segment may not be attached and it's ipc
> +		 * namespace may be exiting.  If so ignore the shm
> +		 * segment as it will be destroyed by shm_exit_ns.
> +		 */
> +		ns = get_ipc_ns_not_zero(shp->shm_ns);
> +		if (!ns) {
> +			task_unlock(task);
> +			continue;
> +		}
> +
> +		/* Guarantee shp lives after task_lock is dropped */
> +		ipc_getref(&shp->shm_perm);
> +
> +		/* Drop task_lock so that shm_destroy may take it */
> +		task_unlock(task);
> +
> +		/* Can the shm segment be destroyed? */
> +		down_write(&shm_ids(ns).rwsem);
> +		shm_lock_by_ptr(shp);
> +		if (ipc_valid_object(&shp->shm_perm) &&
> +		    shm_may_destroy(ns, shp)) {
>   			shm_lock_by_ptr(shp);
>   			shm_destroy(ns, shp);
> +		} else {
> +			shm_unlock(shp);
>   		}
> -	}
>   
> -	/* Remove the list head from any segments still attached. */
> -	list_del(&task->sysvshm.shm_clist);
> -	up_write(&shm_ids(ns).rwsem);
> +		ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
> +		up_write(&shm_ids(ns).rwsem);
> +		put_ipc_ns(ns);
> +	}
>   }
>   
>   static vm_fault_t shm_fault(struct vm_fault *vmf)
> @@ -673,14 +691,17 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>   	shp->shm_segsz = size;
>   	shp->shm_nattch = 0;
>   	shp->shm_file = file;
> -	shp->shm_creator = current;
> +	RCU_INIT_POINTER(shp->shm_creator, current);
> +	shp->shm_ns = ns;
>   
>   	/* ipc_addid() locks shp upon success. */
>   	error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
>   	if (error < 0)
>   		goto no_id;
>   
> +	task_lock(current);
>   	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
> +	task_unlock(current);
>   
>   	/*
>   	 * shmid gets reported as "inode#" in /proc/pid/maps.
> @@ -913,8 +934,14 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
>   	switch (cmd) {
>   	case IPC_RMID:
>   		ipc_lock_object(&shp->shm_perm);
> -		/* do_shm_rmid unlocks the ipc object and rcu */
> -		do_shm_rmid(ns, ipcp);
> +		if (shp->shm_nattch) {
> +			shp->shm_perm.mode |= SHM_DEST;
> +			/* Do not find it any more */
> +			ipc_set_key_private(&shm_ids(ns), &shp->shm_perm);
> +			shm_unlock(shp);
> +		} else
> +			shm_destroy(ns, shp);
> +		/* shm_unlock unlocked the ipc object and rcu */
>   		goto out_up;
>   	case IPC_SET:
>   		ipc_lock_object(&shp->shm_perm);
> diff --git a/ipc/util.c b/ipc/util.c
> index fa2d86ef3fb8..58228f342397 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -525,6 +525,11 @@ void ipc_set_key_private(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>   	ipcp->key = IPC_PRIVATE;
>   }
>   
> +void ipc_getref(struct kern_ipc_perm *ptr)
> +{
> +	return refcount_inc(&ptr->refcount);
> +}
> +
>   bool ipc_rcu_getref(struct kern_ipc_perm *ptr)
>   {
>   	return refcount_inc_not_zero(&ptr->refcount);
> diff --git a/ipc/util.h b/ipc/util.h
> index 2dd7ce0416d8..e13b46ff675f 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -170,6 +170,7 @@ static inline int ipc_get_maxidx(struct ipc_ids *ids)
>    * refcount is initialized by ipc_addid(), before that point call_rcu()
>    * must be used.
>    */
> +void ipc_getref(struct kern_ipc_perm *ptr);
>   bool ipc_rcu_getref(struct kern_ipc_perm *ptr);
>   void ipc_rcu_putref(struct kern_ipc_perm *ptr,
>   			void (*func)(struct rcu_head *head));
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 38681ad44c76..3e881f78bcf2 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3095,7 +3095,6 @@ int ksys_unshare(unsigned long unshare_flags)
>   		if (unshare_flags & CLONE_NEWIPC) {
>   			/* Orphan segments in old ns (see sem above). */
>   			exit_shm(current);
> -			shm_init_task(current);
>   		}
>   
>   		if (new_nsproxy)


