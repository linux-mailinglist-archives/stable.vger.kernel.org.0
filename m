Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192E74627B5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhK2XJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbhK2XIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:08:12 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCEAC133F46
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 10:44:34 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 137so15488025wma.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 10:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=imo29pYhiDp/nOjCdBH9iDXhnUOWLF6uWkqGilZNCw8=;
        b=5iGRYBvxhiiChDFQHt/qg8ovCtHIU+2XmvpDxNxAackU5PkN0DoGUhLYvk5LMrm5TQ
         ehcAmRmoX+God/Ai+VJ9CM2pGnfjc/axDqh/U5vVD6hJtj+VkL7ciCWWqUhwqYmnu8Hp
         Fty/bqXVvWves91Hk/EXbCMZn5cZN7ol4mXKXX/mQ7o/vKWSv87IQEpHhR+4yZQG3uca
         wVwYjAxl0OHvrtcjRaEBsXDFKlTlAFphp+uI/8RmK8dKTHqKa9b12StBWPRBxXiRQymx
         juyyMxWnpj8PVmmwvYdhyxx+/WgIZUHJJ/wAy7uRg4x70t2pH1ysiWWSrbkR3mKPDSkT
         GYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=imo29pYhiDp/nOjCdBH9iDXhnUOWLF6uWkqGilZNCw8=;
        b=W1fp0R3K3lKtKnRYeRj3alyp3PD07Sk3bhAhzzMGE4gxnChvzkltk4ZAvv4OrFcajB
         YZbKHap2KnJb5WnvGQ1JW72V05cDuphfNN5hFTguGGhZvBQireFxd+zSeksNQjgCmvuC
         BxYZbPZwkkVOCgjzc8oX9Z5SyHnoP50aIEno18tP5Rq9+j0eco2Gp6Y+GKPiuqdUVT4v
         lwpFTiYDnTXgupQXysi+na4UVl+atFlplN5PSRwBCY0cUtj181PIEitg+2Lc885IPOlm
         T26vb/Rn0+ui9Qn1HvvNzgYmb3a8XvosxYKZrA1fbpUNhLnJwj6Ev+GNjlS1qVfUuL4o
         AKMg==
X-Gm-Message-State: AOAM532P+rdfH8EcPlTf8Wd6Iiv7apwmBEpMElzPlMnJLenG/TpQQLG6
        0E99/KchRYvhNiSySyvIs+ehsg==
X-Google-Smtp-Source: ABdhPJwUg+qTTp6Co2rb/WEzNF7twNMyF//I4DqaFeK9lrJn/EgeV6FV6sMIIuJL+3f00SMU98N6SA==
X-Received: by 2002:a05:600c:6016:: with SMTP id az22mr11403wmb.11.1638211473360;
        Mon, 29 Nov 2021 10:44:33 -0800 (PST)
Received: from localhost.localdomain (p200300d997079c006c1886fece95031d.dip0.t-ipconnect.de. [2003:d9:9707:9c00:6c18:86fe:ce95:31d])
        by smtp.googlemail.com with ESMTPSA id s24sm90568wmj.26.2021.11.29.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:44:32 -0800 (PST)
From:   Manfred Spraul <manfred@colorfullife.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] shm: extend forced shm destroy to support objects from several IPC nses
Date:   Mon, 29 Nov 2021 19:44:29 +0100
Message-Id: <20211129184429.40660-1-manfred@colorfullife.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <163758375777179@kroah.com>
References: <163758375777179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

For 4.19.y:

Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")

Currently, the exit_shm() function not designed to work properly when
task->sysvshm.shm_clist holds shm objects from different IPC namespaces.

This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
leads to use-after-free (reproducer exists).

This is an attempt to fix the problem by extending exit_shm mechanism to
handle shm's destroy from several IPC ns'es.

To achieve that we do several things:

1. add a namespace (non-refcounted) pointer to the struct shmid_kernel

2. during new shm object creation (newseg()/shmget syscall) we
   initialize this pointer by current task IPC ns

3. exit_shm() fully reworked such that it traverses over all shp's in
   task->sysvshm.shm_clist and gets IPC namespace not from current task
   as it was before but from shp's object itself, then call
   shm_destroy(shp, ns).

Note: We need to be really careful here, because as it was said before
(1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we
using special helper get_ipc_ns_not_zero() which allows to get IPC ns
refcounter only if IPC ns not in the "state of destruction".

Q/A

Q: Why can we access shp->ns memory using non-refcounted pointer?
A: Because shp object lifetime is always shorther than IPC namespace
   lifetime, so, if we get shp object from the task->sysvshm.shm_clist
   while holding task_lock(task) nobody can steal our namespace.

Q: Does this patch change semantics of unshare/setns/clone syscalls?
A: No. It's just fixes non-covered case when process may leave IPC
   namespace without getting task->sysvshm.shm_clist list cleaned up.

Link: https://lkml.kernel.org/r/67bb03e5-f79c-1815-e2bf-949c67047418@colorfullife.com
Link: https://lkml.kernel.org/r/20211109151501.4921-1-manfred@colorfullife.com
Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/ipc_namespace.h |  15 +++
 include/linux/sched/task.h    |   2 +-
 ipc/shm.c                     | 189 +++++++++++++++++++++++++---------
 3 files changed, 159 insertions(+), 47 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 6ab8c1bada3f..36ffbe330abe 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -129,6 +129,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	if (ns) {
+		if (refcount_inc_not_zero(&ns->count))
+			return ns;
+	}
+
+	return NULL;
+}
+
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
@@ -145,6 +155,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
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
index 44c6f15800ff..91401309b1aa 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -136,7 +136,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/ipc/shm.c b/ipc/shm.c
index 1c65fb357395..ba99f48c6e2b 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -62,9 +62,18 @@ struct shmid_kernel /* private to the kernel */
 	struct pid		*shm_lprid;
 	struct user_struct	*mlock_user;
 
-	/* The task created the shm object.  NULL if the task is dead. */
+	/*
+	 * The task created the shm object, for
+	 * task_lock(shp->shm_creator)
+	 */
 	struct task_struct	*shm_creator;
-	struct list_head	shm_clist;	/* list by creator */
+
+	/*
+	 * List by creator. task_lock(->shm_creator) required for read/write.
+	 * If list_empty(), then the creator is dead already.
+	 */
+	struct list_head	shm_clist;
+	struct ipc_namespace	*ns;
 } __randomize_layout;
 
 /* shm_mode upper byte flags */
@@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct shmid_kernel *shp;
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+	WARN_ON(ns != shp->ns);
 
 	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
@@ -225,10 +235,43 @@ static void shm_rcu_free(struct rcu_head *head)
 	kvfree(shp);
 }
 
-static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
+/*
+ * It has to be called with shp locked.
+ * It must be called before ipc_rmid()
+ */
+static inline void shm_clist_rm(struct shmid_kernel *shp)
 {
-	list_del(&s->shm_clist);
-	ipc_rmid(&shm_ids(ns), &s->shm_perm);
+	struct task_struct *creator;
+
+	/* ensure that shm_creator does not disappear */
+	rcu_read_lock();
+
+	/*
+	 * A concurrent exit_shm may do a list_del_init() as well.
+	 * Just do nothing if exit_shm already did the work
+	 */
+	if (!list_empty(&shp->shm_clist)) {
+		/*
+		 * shp->shm_creator is guaranteed to be valid *only*
+		 * if shp->shm_clist is not empty.
+		 */
+		creator = shp->shm_creator;
+
+		task_lock(creator);
+		/*
+		 * list_del_init() is a nop if the entry was already removed
+		 * from the list.
+		 */
+		list_del_init(&shp->shm_clist);
+		task_unlock(creator);
+	}
+	rcu_read_unlock();
+}
+
+static inline void shm_rmid(struct shmid_kernel *s)
+{
+	shm_clist_rm(s);
+	ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
 }
 
 
@@ -283,7 +326,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	shm_file = shp->shm_file;
 	shp->shm_file = NULL;
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp);
+	shm_rmid(shp);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_user);
@@ -306,10 +349,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
  *
  * 2) sysctl kernel.shm_rmid_forced is set to 1.
  */
-static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+static bool shm_may_destroy(struct shmid_kernel *shp)
 {
 	return (shp->shm_nattch == 0) &&
-	       (ns->shm_rmid_forced ||
+	       (shp->ns->shm_rmid_forced ||
 		(shp->shm_perm.mode & SHM_DEST));
 }
 
@@ -340,7 +383,7 @@ static void shm_close(struct vm_area_struct *vma)
 	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
 	shp->shm_dtim = ktime_get_real_seconds();
 	shp->shm_nattch--;
-	if (shm_may_destroy(ns, shp))
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
@@ -361,10 +404,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
 	 *
 	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
 	 */
-	if (shp->shm_creator != NULL)
+	if (!list_empty(&shp->shm_clist))
 		return 0;
 
-	if (shm_may_destroy(ns, shp)) {
+	if (shm_may_destroy(shp)) {
 		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
 	}
@@ -382,48 +425,97 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 /* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
-	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
-	struct shmid_kernel *shp, *n;
+	for (;;) {
+		struct shmid_kernel *shp;
+		struct ipc_namespace *ns;
 
-	if (list_empty(&task->sysvshm.shm_clist))
-		return;
+		task_lock(task);
+
+		if (list_empty(&task->sysvshm.shm_clist)) {
+			task_unlock(task);
+			break;
+		}
+
+		shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
+				shm_clist);
 
-	/*
-	 * If kernel.shm_rmid_forced is not set then only keep track of
-	 * which shmids are orphaned, so that a later set of the sysctl
-	 * can clean them up.
-	 */
-	if (!ns->shm_rmid_forced) {
-		down_read(&shm_ids(ns).rwsem);
-		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
-			shp->shm_creator = NULL;
 		/*
-		 * Only under read lock but we are only called on current
-		 * so no entry on the list will be shared.
+		 * 1) Get pointer to the ipc namespace. It is worth to say
+		 * that this pointer is guaranteed to be valid because
+		 * shp lifetime is always shorter than namespace lifetime
+		 * in which shp lives.
+		 * We taken task_lock it means that shp won't be freed.
 		 */
-		list_del(&task->sysvshm.shm_clist);
-		up_read(&shm_ids(ns).rwsem);
-		return;
-	}
+		ns = shp->ns;
 
-	/*
-	 * Destroy all already created segments, that were not yet mapped,
-	 * and mark any mapped as orphan to cover the sysctl toggling.
-	 * Destroy is skipped if shm_may_destroy() returns false.
-	 */
-	down_write(&shm_ids(ns).rwsem);
-	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
-		shp->shm_creator = NULL;
+		/*
+		 * 2) If kernel.shm_rmid_forced is not set then only keep track of
+		 * which shmids are orphaned, so that a later set of the sysctl
+		 * can clean them up.
+		 */
+		if (!ns->shm_rmid_forced)
+			goto unlink_continue;
 
-		if (shm_may_destroy(ns, shp)) {
-			shm_lock_by_ptr(shp);
-			shm_destroy(ns, shp);
+		/*
+		 * 3) get a reference to the namespace.
+		 *    The refcount could be already 0. If it is 0, then
+		 *    the shm objects will be free by free_ipc_work().
+		 */
+		ns = get_ipc_ns_not_zero(ns);
+		if (!ns) {
+unlink_continue:
+			list_del_init(&shp->shm_clist);
+			task_unlock(task);
+			continue;
 		}
-	}
 
-	/* Remove the list head from any segments still attached. */
-	list_del(&task->sysvshm.shm_clist);
-	up_write(&shm_ids(ns).rwsem);
+		/*
+		 * 4) get a reference to shp.
+		 *   This cannot fail: shm_clist_rm() is called before
+		 *   ipc_rmid(), thus the refcount cannot be 0.
+		 */
+		WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
+
+		/*
+		 * 5) unlink the shm segment from the list of segments
+		 *    created by current.
+		 *    This must be done last. After unlinking,
+		 *    only the refcounts obtained above prevent IPC_RMID
+		 *    from destroying the segment or the namespace.
+		 */
+		list_del_init(&shp->shm_clist);
+
+		task_unlock(task);
+
+		/*
+		 * 6) we have all references
+		 *    Thus lock & if needed destroy shp.
+		 */
+		down_write(&shm_ids(ns).rwsem);
+		shm_lock_by_ptr(shp);
+		/*
+		 * rcu_read_lock was implicitly taken in shm_lock_by_ptr, it's
+		 * safe to call ipc_rcu_putref here
+		 */
+		ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+
+		if (ipc_valid_object(&shp->shm_perm)) {
+			if (shm_may_destroy(shp))
+				shm_destroy(ns, shp);
+			else
+				shm_unlock(shp);
+		} else {
+			/*
+			 * Someone else deleted the shp from namespace
+			 * idr/kht while we have waited.
+			 * Just unlock and continue.
+			 */
+			shm_unlock(shp);
+		}
+
+		up_write(&shm_ids(ns).rwsem);
+		put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
+	}
 }
 
 static vm_fault_t shm_fault(struct vm_fault *vmf)
@@ -680,7 +772,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (error < 0)
 		goto no_id;
 
+	shp->ns = ns;
+
+	task_lock(current);
 	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
+	task_unlock(current);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
@@ -1549,7 +1645,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
 	down_write(&shm_ids(ns).rwsem);
 	shp = shm_lock(ns, shmid);
 	shp->shm_nattch--;
-	if (shm_may_destroy(ns, shp))
+
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
-- 
2.31.1

