Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2729D44680C
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 18:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhKERsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 13:48:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41084 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhKERsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 13:48:55 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:53150)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj3I5-004X77-31; Fri, 05 Nov 2021 11:46:13 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:49706 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj3I2-0064kl-8C; Fri, 05 Nov 2021 11:46:12 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
References: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com>
Date:   Fri, 05 Nov 2021 12:46:03 -0500
In-Reply-To: <20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com>
        (Alexander Mikhalitsyn's message of "Thu, 28 Oct 2021 01:43:48 +0300")
Message-ID: <87wnlmqyw4.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mj3I2-0064kl-8C;;;mid=<87wnlmqyw4.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18nTlhdwAdjFuJBDemCiC4UQLNJnjFT+SA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: *******
X-Spam-Status: No, score=7.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,TR_XM_PhishingBody,T_TM2_M_HEADER_IN_MSG,
        T_XMDrugObfuBody_08,T_XMDrugObfuBody_12,XMNoVowels,XMSubLong,
        XM_B_Investor,XM_B_Phish66,XM_B_SpammyWords autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 XM_B_Investor BODY: Commonly used business phishing phrases
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  2.0 XM_B_Phish66 BODY: Obfuscated XMission
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
        *  1.0 T_XMDrugObfuBody_12 obfuscated drug references
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 TR_XM_PhishingBody Phishing flag in body of message
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;Alexander Mikhalitsyn
        <alexander.mikhalitsyn@virtuozzo.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1201 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 4.5 (0.4%), b_tie_ro: 3.1 (0.3%), parse: 2.1
        (0.2%), extract_message_metadata: 37 (3.1%), get_uri_detail_list: 9
        (0.7%), tests_pri_-1000: 19 (1.6%), tests_pri_-950: 1.15 (0.1%),
        tests_pri_-900: 0.89 (0.1%), tests_pri_-90: 201 (16.7%), check_bayes:
        168 (14.0%), b_tokenize: 27 (2.2%), b_tok_get_all: 48 (4.0%),
        b_comp_prob: 5 (0.5%), b_tok_touch_all: 84 (7.0%), b_finish: 0.69
        (0.1%), tests_pri_0: 918 (76.5%), check_dkim_signature: 0.63 (0.1%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.91 (0.1%), tests_pri_10:
        2.7 (0.2%), tests_pri_500: 10 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] shm: extend forced shm destroy to support objects from several IPC nses
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> writes:

> Currently, exit_shm function not designed to work properly when
> task->sysvshm.shm_clist holds shm objects from different IPC namespaces.
>
> This is a real pain when sysctl kernel.shm_rmid_forced = 1, because
> it leads to use-after-free (reproducer exists).
>
> That particular patch is attempt to fix the problem by extending exit_shm
> mechanism to handle shm's destroy from several IPC ns'es.
>
> To achieve that we do several things:
> 1. add namespace (non-refcounted) pointer to the struct shmid_kernel
> 2. during new shm object creation (newseg()/shmget syscall) we initialize
> this pointer by current task IPC ns
> 3. exit_shm() fully reworked such that it traverses over all
> shp's in task->sysvshm.shm_clist and gets IPC namespace not
> from current task as it was before but from shp's object itself, then
> call shm_destroy(shp, ns).
>
> Note. We need to be really careful here, because as it was said before
> (1), our pointer to IPC ns non-refcnt'ed. To be on the safe side we using
> special helper get_ipc_ns_not_zero() which allows to get IPC ns refcounter
> only if IPC ns not in the "state of destruction".
>
> Q/A
>
> Q: Why we can access shp->ns memory using non-refcounted pointer?
> A: Because shp object lifetime is always shorther
> than IPC namespace lifetime, so, if we get shp object from the
> task->sysvshm.shm_clist while holding task_lock(task) nobody can
> steal our namespace.
>
> Q: Does this patch change semantics of unshare/setns/clone syscalls?
> A: Not. It's just fixes non-covered case when process may leave
> IPC namespace without getting task->sysvshm.shm_clist list cleaned up.
>
> Fixes: ab602f79915 ("shm: make exit_shm work proportional to task
> activity")

After reading Manfred's explanation I see what I was missing.

The ipc namespace exists as long as shm_nattach != 0.  I am annoyed
that shm_exit_ns calls do_shm_rmid which implies otherwise.

I had totally missed that ipc_rcu_getref and ipc_rcu_putref existed.
Which is what makes taking a reference and then dropping and retaking
locking possible.

From 10,000 feet:
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This approach does directly address the reported issue without
touching anything else so I think this is a good approach to solve
the reported crash.


Comments on the actual code are below.  Mostly it is little
nits.  But at least one substantive issue as well.

> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Cc: stable@vger.kernel.org
> Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> ---
>  include/linux/ipc_namespace.h |  15 +++
>  include/linux/sched/task.h    |   2 +-
>  include/linux/shm.h           |   2 +-
>  ipc/shm.c                     | 170 +++++++++++++++++++++++++---------
>  4 files changed, 142 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 05e22770af51..b75395ec8d52 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -131,6 +131,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
>  	return ns;
>  }
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
>  extern void put_ipc_ns(struct ipc_namespace *ns);
>  #else
>  static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
> @@ -147,6 +157,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
>  	return ns;
>  }
>  
> +static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
> +{
> +	return ns;
> +}
> +
>  static inline void put_ipc_ns(struct ipc_namespace *ns)
>  {
>  }
> diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
> index ef02be869cf2..bfdf84dab4be 100644
> --- a/include/linux/sched/task.h
> +++ b/include/linux/sched/task.h
> @@ -157,7 +157,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
>   * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
>   * subscriptions and synchronises with wait4().  Also used in procfs.  Also
>   * pins the final release of task.io_context.  Also protects ->cpuset and
> - * ->cgroup.subsys[]. And ->vfork_done.
> + * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
>   *
>   * Nests both inside and outside of read_lock(&tasklist_lock).
>   * It must not be nested with write_lock_irq(&tasklist_lock),
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index d8e69aed3d32..709f6d0451c0 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -11,7 +11,7 @@ struct file;
>  
>  #ifdef CONFIG_SYSVIPC
>  struct sysv_shm {
> -	struct list_head shm_clist;
> +	struct list_head	shm_clist;
>  };

This change is unnecessary.

>  
>  long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 748933e376ca..29667e17b12a 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -62,9 +62,18 @@ struct shmid_kernel /* private to the kernel */
>  	struct pid		*shm_lprid;
>  	struct ucounts		*mlock_ucounts;
>  
> -	/* The task created the shm object.  NULL if the task is dead. */
> +	/*
> +	 * The task created the shm object, for looking up
> +	 * task->sysvshm.shm_clist_lock
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
           task_lock
> +	 */
>  	struct task_struct	*shm_creator;
> -	struct list_head	shm_clist;	/* list by creator */
> +
> +	/*
> +	 * list by creator. shm_clist_lock required for read/write
                            ^^^^^^^^^^^^^^
                            task_lock
> +	 * if list_empty(), then the creator is dead already
> +	 */
> +	struct list_head	shm_clist;
> +	struct ipc_namespace	*ns;
>  } __randomize_layout;
>  
>  /* shm_mode upper byte flags */
> @@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  	struct shmid_kernel *shp;
>  
>  	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
> +	WARN_ON(ns != shp->ns);

>  
>  	if (shp->shm_nattch) {
>  		shp->shm_perm.mode |= SHM_DEST;
> @@ -225,10 +235,36 @@ static void shm_rcu_free(struct rcu_head *head)
>  	kfree(shp);
>  }
>  
> -static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
> +/*
> + * It has to be called with shp locked.
> + * It must be called before ipc_rmid()
> + */
> +static inline void shm_clist_rm(struct shmid_kernel *shp)
>  {
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

This looks like a problem.  With no lock is held the list_empty here is
fundamentally an optimization.  So the rest of the function should run
properly if this list_empty is removed.

It does not look to me like the rest of the function will run properly
if list_empty is removed.

The code needs an rcu_lock or something like that to ensure that
shm_creator does not go away between the time it is read and when the
lock is taken.

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
>  }
>  
>  
> @@ -283,7 +319,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>  	shm_file = shp->shm_file;
>  	shp->shm_file = NULL;
>  	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	shm_rmid(ns, shp);
> +	shm_rmid(shp);
>  	shm_unlock(shp);
>  	if (!is_file_hugepages(shm_file))
>  		shmem_lock(shm_file, 0, shp->mlock_ucounts);
> @@ -306,10 +342,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>   *
>   * 2) sysctl kernel.shm_rmid_forced is set to 1.
>   */
> -static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> +static bool shm_may_destroy(struct shmid_kernel *shp)
>  {
>  	return (shp->shm_nattch == 0) &&
> -	       (ns->shm_rmid_forced ||
> +	       (shp->ns->shm_rmid_forced ||
>  		(shp->shm_perm.mode & SHM_DEST));
>  }
>  
> @@ -340,7 +376,7 @@ static void shm_close(struct vm_area_struct *vma)
>  	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
>  	shp->shm_dtim = ktime_get_real_seconds();
>  	shp->shm_nattch--;
> -	if (shm_may_destroy(ns, shp))
> +	if (shm_may_destroy(shp))
>  		shm_destroy(ns, shp);
>  	else
>  		shm_unlock(shp);
> @@ -361,10 +397,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
>  	 *
>  	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
>  	 */

We should add a comment why testing list_empty here is safe/reliable.

Now that the list deletion is only protected by task_lock it feels like
this introduces a race.

I don't think the race is meaningful as either the list is non-empty
or it is empty.  Plus none of the following tests are racy.  So there
is no danger of an attached segment being destroyed.

> -	if (shp->shm_creator != NULL)
> +	if (!list_empty(&shp->shm_clist))
>  		return 0;
>  
> -	if (shm_may_destroy(ns, shp)) {
> +	if (shm_may_destroy(shp)) {
>  		shm_lock_by_ptr(shp);
>  		shm_destroy(ns, shp);
>  	}
> @@ -382,48 +418,87 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
>  /* Locking assumes this will only be called with task == current */
>  void exit_shm(struct task_struct *task)
>  {
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
                ^^^^^^^
                The code should also clear shm_creator here as well.
                So that a stale reference becomes a NULL pointer
                dereference instead of use-after-free.  Something like:

		/*
                 * The old shm_creator value will remain valid for
                 * at least an rcu grace period after this, see
		 * put_task_struct_rcu_user.
                 */
                 
		rcu_assign_pointer(shp->shm_creator, NULL);

This allows shm_clist_rm to look like:
static inline void shm_clist_rm(struct shmid_kernel *shp)
{
	struct task_struct *creator;

	rcu_read_lock();
        creator = rcu_dereference(shp->shm_clist);
        if (creator) {
        	task_lock(creator);
                list_del_init(&shp->shm_clist);
                task_unlock(creator);
        }
        rcu_read_unlock();
}
	
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
>  		/*
> -		 * Only under read lock but we are only called on current
> -		 * so no entry on the list will be shared.
> +		 * 2) Get pointer to the ipc namespace. It is worth to say
> +		 * that this pointer is guaranteed to be valid because
> +		 * shp lifetime is always shorter than namespace lifetime
> +		 * in which shp lives.
> +		 * We taken task_lock it means that shp won't be freed.
>  		 */
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
                ^^^^^^^^^

                This test is probably easier to follow if it was simply:
                if (!ns) {
                	task_unlock(task);
                        continue;
                }

                Then the basic logic can all stay at the same
                indentation level, and ns does not need to be
                tested a second time.

> +			/*
> +			 * 5) get a reference to the shp itself.
> +			 *   This cannot fail: shm_clist_rm() is called before
> +			 *   ipc_rmid(), thus the refcount cannot be 0.
> +			 */
> +			WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        This calls for an ipc_getref that simply calls
                        refcount_inc.  Then the refcount code can
                        perform all of the sanity checks for you,
                        and the WARN_ON becomes unnecessary.

                        Plus the code then documents the fact you know
                        the refcount must be non-zero here.
> +		}
> +
> +		task_unlock(task);
> +
> +		if (ns) {
> +			down_write(&shm_ids(ns).rwsem);
>  			shm_lock_by_ptr(shp);
> -			shm_destroy(ns, shp);
> +			/*
> +			 * rcu_read_lock was implicitly taken in
> +			 * shm_lock_by_ptr, it's safe to call
> +			 * ipc_rcu_putref here
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                          This comment should say something like:

                          rcu_read_lock was taken in shm_lock_by_ptr.
                          With rcu protecting our accesses of shp
                          holding a reference to shp is unnecessary.
                          
> +			 */
> +			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        It probably makes most sense just to move
                        this decrement of the extra reference down to
                        just before put_ipc_ns.  Removing the need
                        for the comment and understanding the subtleties
                        there, and keeping all of the taking and putting
                        in a consistent order.
                        

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
>  		}
>  	}
> -
> -	/* Remove the list head from any segments still attached. */
> -	list_del(&task->sysvshm.shm_clist);
> -	up_write(&shm_ids(ns).rwsem);
>  }
>  
>  static vm_fault_t shm_fault(struct vm_fault *vmf)
> @@ -680,7 +755,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	if (error < 0)
>  		goto no_id;
>  
> +	shp->ns = ns;
> +
> +	task_lock(current);
>  	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
> +	task_unlock(current);
>  
>  	/*
>  	 * shmid gets reported as "inode#" in /proc/pid/maps.
> @@ -1573,7 +1652,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
>  	down_write(&shm_ids(ns).rwsem);
>  	shp = shm_lock(ns, shmid);
>  	shp->shm_nattch--;
> -	if (shm_may_destroy(ns, shp))
> +
> +	if (shm_may_destroy(shp))
>  		shm_destroy(ns, shp);
>  	else
>  		shm_unlock(shp);

Eric
