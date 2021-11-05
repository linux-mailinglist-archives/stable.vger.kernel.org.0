Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89991446AA8
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 22:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKEViD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 17:38:03 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36028 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhKEViD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 17:38:03 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:36280)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj6rp-009Nlt-Mq; Fri, 05 Nov 2021 15:35:21 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:56042 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj6ro-00ERg8-9D; Fri, 05 Nov 2021 15:35:21 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Manfred Spraul <manfred@colorfullife.com>
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
Date:   Fri, 05 Nov 2021 16:34:38 -0500
In-Reply-To: <61ca7331-4a86-2bf6-9ccb-50f6a7824e12@colorfullife.com> (Manfred
        Spraul's message of "Fri, 5 Nov 2021 20:03:21 +0100")
Message-ID: <87lf22qob5.fsf_-_@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mj6ro-00ERg8-9D;;;mid=<87lf22qob5.fsf_-_@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19xhpNroBoF3r2t1A+QDBl+aNknbl4c8hw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TooManySym_01,XMSubLong,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Manfred Spraul <manfred@colorfullife.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 810 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.5 (0.6%), b_tie_ro: 3.1 (0.4%), parse: 1.78
        (0.2%), extract_message_metadata: 8 (0.9%), get_uri_detail_list: 5
        (0.6%), tests_pri_-1000: 3.2 (0.4%), tests_pri_-950: 1.16 (0.1%),
        tests_pri_-900: 0.84 (0.1%), tests_pri_-90: 161 (19.9%), check_bayes:
        159 (19.7%), b_tokenize: 15 (1.9%), b_tok_get_all: 12 (1.5%),
        b_comp_prob: 2.5 (0.3%), b_tok_touch_all: 126 (15.5%), b_finish: 0.96
        (0.1%), tests_pri_0: 612 (75.5%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 3.1 (0.4%), poll_dns_idle: 1.78 (0.2%), tests_pri_10:
        2.7 (0.3%), tests_pri_500: 8 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: [RFC] shm: extend forced shm destroy to support objects from several IPC nses (simplified)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


I have to dash so this is short.

This is what I am thinking this change should look like.

I am not certain this is truly reviewable as a single change, so I will
break it into a couple of smaller ones next time I get the chance.

Eric

 include/linux/ipc_namespace.h |  12 ++++
 include/linux/sched/task.h    |   2 +-
 ipc/shm.c                     | 135 +++++++++++++++++++++++++-----------------
 ipc/util.c                    |   5 ++
 ipc/util.h                    |   1 +
 kernel/fork.c                 |   1 -
 6 files changed, 100 insertions(+), 56 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 05e22770af51..c220767a0cc1 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -131,6 +131,13 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	if (ns && refcount_inc_not_zero(&ns->ns.count))
+		return ns;
+	return NULL;
+}
+
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
@@ -147,6 +154,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	return ns;
+}
+
 static inline void put_ipc_ns(struct ipc_namespace *ns)
 {
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ef02be869cf2..1d9533d66f7e 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -157,7 +157,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. And ->vfork_done. And ->shmvshm.shm_clist.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/ipc/shm.c b/ipc/shm.c
index ab749be6d8b7..80e3595d3a69 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -63,8 +63,9 @@ struct shmid_kernel /* private to the kernel */
 	struct ucounts		*mlock_ucounts;
 
 	/* The task created the shm object.  NULL if the task is dead. */
-	struct task_struct	*shm_creator;
+	struct task_struct __rcu *shm_creator;
 	struct list_head	shm_clist;	/* list by creator */
+	struct ipc_namespace	*shm_ns;	/* valid when shm_nattch != 0 */
 } __randomize_layout;
 
 /* shm_mode upper byte flags */
@@ -106,29 +107,17 @@ void shm_init_ns(struct ipc_namespace *ns)
 	ipc_init_ids(&shm_ids(ns));
 }
 
-/*
- * Called with shm_ids.rwsem (writer) and the shp structure locked.
- * Only shm_ids.rwsem remains locked on exit.
- */
-static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+static void do_shm_destroy(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
-	struct shmid_kernel *shp;
-
-	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
-
-	if (shp->shm_nattch) {
-		shp->shm_perm.mode |= SHM_DEST;
-		/* Do not find it any more */
-		ipc_set_key_private(&shm_ids(ns), &shp->shm_perm);
-		shm_unlock(shp);
-	} else
-		shm_destroy(ns, shp);
+	struct shmid_kernel *shp =
+		container_of(ipcp, struct shmid_kernel, shm_perm);
+	shm_destroy(ns, shp);
 }
 
 #ifdef CONFIG_IPC_NS
 void shm_exit_ns(struct ipc_namespace *ns)
 {
-	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	free_ipcs(ns, &shm_ids(ns), do_shm_destroy);
 	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 	rhashtable_destroy(&ns->ids[IPC_SHM_IDS].key_ht);
 }
@@ -225,9 +214,22 @@ static void shm_rcu_free(struct rcu_head *head)
 	kfree(shp);
 }
 
+static inline void shm_clist_del(struct shmid_kernel *shp)
+{
+	struct task_struct *creator;
+
+	rcu_read_lock();
+	creator = rcu_dereference(shp->shm_creator);
+	if (creator) {
+		task_lock(creator);
+		list_del(&shp->shm_clist);
+		task_unlock(creator);
+	}
+	rcu_read_unlock();
+}
+
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
-	list_del(&s->shm_clist);
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
@@ -283,7 +285,9 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	shm_file = shp->shm_file;
 	shp->shm_file = NULL;
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	shm_clist_del(shp);
 	shm_rmid(ns, shp);
+	shp->shm_ns = NULL;
 	shm_unlock(shp);
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_ucounts);
@@ -361,7 +365,7 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
 	 *
 	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
 	 */
-	if (shp->shm_creator != NULL)
+	if (rcu_access_pointer(shp->shm_creator) != NULL)
 		return 0;
 
 	if (shm_may_destroy(ns, shp)) {
@@ -382,48 +386,62 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 /* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
-	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
-	struct shmid_kernel *shp, *n;
-
-	if (list_empty(&task->sysvshm.shm_clist))
-		return;
-
-	/*
-	 * If kernel.shm_rmid_forced is not set then only keep track of
-	 * which shmids are orphaned, so that a later set of the sysctl
-	 * can clean them up.
-	 */
-	if (!ns->shm_rmid_forced) {
-		down_read(&shm_ids(ns).rwsem);
-		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
-			shp->shm_creator = NULL;
-		/*
-		 * Only under read lock but we are only called on current
-		 * so no entry on the list will be shared.
-		 */
-		list_del(&task->sysvshm.shm_clist);
-		up_read(&shm_ids(ns).rwsem);
-		return;
-	}
+	struct list_head *head = &task->sysvshm.shm_clist;
 
 	/*
 	 * Destroy all already created segments, that were not yet mapped,
 	 * and mark any mapped as orphan to cover the sysctl toggling.
 	 * Destroy is skipped if shm_may_destroy() returns false.
 	 */
-	down_write(&shm_ids(ns).rwsem);
-	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
-		shp->shm_creator = NULL;
+	for (;;) {
+		struct ipc_namespace *ns;
+		struct shmid_kernel *shp;
 
-		if (shm_may_destroy(ns, shp)) {
+		task_lock(task);
+		if (list_empty(head)) {
+			task_unlock(task);
+			break;
+		}
+
+		shp = list_first_entry(head, struct shmid_kernel, shm_clist);
+
+		list_del(&shp->shm_clist);
+		rcu_assign_pointer(shp->shm_creator, NULL);
+
+		/*
+		 * Guarantee that ns lives after task_list is dropped.
+		 *
+		 * This shm segment may not be attached and it's ipc
+		 * namespace may be exiting.  If so ignore the shm
+		 * segment as it will be destroyed by shm_exit_ns.
+		 */
+		ns = get_ipc_ns_not_zero(shp->shm_ns);
+		if (!ns) {
+			task_unlock(task);
+			continue;
+		}
+
+		/* Guarantee shp lives after task_lock is dropped */
+		ipc_getref(&shp->shm_perm);
+
+		/* Drop task_lock so that shm_destroy may take it */
+		task_unlock(task);
+
+		/* Can the shm segment be destroyed? */
+		down_write(&shm_ids(ns).rwsem);
+		shm_lock_by_ptr(shp);
+		if (ipc_valid_object(&shp->shm_perm) &&
+		    shm_may_destroy(ns, shp)) {
 			shm_lock_by_ptr(shp);
 			shm_destroy(ns, shp);
+		} else {
+			shm_unlock(shp);
 		}
-	}
 
-	/* Remove the list head from any segments still attached. */
-	list_del(&task->sysvshm.shm_clist);
-	up_write(&shm_ids(ns).rwsem);
+		ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+		up_write(&shm_ids(ns).rwsem);
+		put_ipc_ns(ns);
+	}
 }
 
 static vm_fault_t shm_fault(struct vm_fault *vmf)
@@ -673,14 +691,17 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
-	shp->shm_creator = current;
+	RCU_INIT_POINTER(shp->shm_creator, current);
+	shp->shm_ns = ns;
 
 	/* ipc_addid() locks shp upon success. */
 	error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (error < 0)
 		goto no_id;
 
+	task_lock(current);
 	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
+	task_unlock(current);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
@@ -913,8 +934,14 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 	switch (cmd) {
 	case IPC_RMID:
 		ipc_lock_object(&shp->shm_perm);
-		/* do_shm_rmid unlocks the ipc object and rcu */
-		do_shm_rmid(ns, ipcp);
+		if (shp->shm_nattch) {
+			shp->shm_perm.mode |= SHM_DEST;
+			/* Do not find it any more */
+			ipc_set_key_private(&shm_ids(ns), &shp->shm_perm);
+			shm_unlock(shp);
+		} else
+			shm_destroy(ns, shp);
+		/* shm_unlock unlocked the ipc object and rcu */
 		goto out_up;
 	case IPC_SET:
 		ipc_lock_object(&shp->shm_perm);
diff --git a/ipc/util.c b/ipc/util.c
index fa2d86ef3fb8..58228f342397 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -525,6 +525,11 @@ void ipc_set_key_private(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 	ipcp->key = IPC_PRIVATE;
 }
 
+void ipc_getref(struct kern_ipc_perm *ptr)
+{
+	return refcount_inc(&ptr->refcount);
+}
+
 bool ipc_rcu_getref(struct kern_ipc_perm *ptr)
 {
 	return refcount_inc_not_zero(&ptr->refcount);
diff --git a/ipc/util.h b/ipc/util.h
index 2dd7ce0416d8..e13b46ff675f 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -170,6 +170,7 @@ static inline int ipc_get_maxidx(struct ipc_ids *ids)
  * refcount is initialized by ipc_addid(), before that point call_rcu()
  * must be used.
  */
+void ipc_getref(struct kern_ipc_perm *ptr);
 bool ipc_rcu_getref(struct kern_ipc_perm *ptr);
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
 			void (*func)(struct rcu_head *head));
diff --git a/kernel/fork.c b/kernel/fork.c
index 38681ad44c76..3e881f78bcf2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3095,7 +3095,6 @@ int ksys_unshare(unsigned long unshare_flags)
 		if (unshare_flags & CLONE_NEWIPC) {
 			/* Orphan segments in old ns (see sem above). */
 			exit_shm(current);
-			shm_init_task(current);
 		}
 
 		if (new_nsproxy)

