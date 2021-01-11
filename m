Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93242F0E86
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbhAKIuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:50:13 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48835 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727948AbhAKIuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:50:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 11E59195B121;
        Mon, 11 Jan 2021 03:49:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gnKRnw
        GwQk7sqZ2SIh/M9K0X23bAVfrSSIEwDs6fu0A=; b=dZGQ4MBLMNjzLes6Rcg7KZ
        p9gHmDPM3m0PKa35KirveJM8mlf6P8b3YCqIrWHbk/zTMUFEFrg66sIz4RDueObh
        h2Hztg1m7fmFCOxgcyJP3XmDVhYVKzhQgS4y3ji+QT3psTS/K5jTik/ucHYATGjO
        E8SPuKpjg1JVUAJCInLgwCEOD4Gmf723fZUp98QWpFNA0WvrMQ3JVszuVQszwriB
        o1R7VRDQewJNhykaLeLj0kx+FDFsE4bRyyKO8tjXhpH1AdrpPD3s07hXswkiPikt
        K4pLqaacwTQ2wJwTxr2iu7gwYgAfZ8ugRDAPwstfV+//r5sNIZkZfpHLTHscLRrg
        ==
X-ME-Sender: <xms:ARH8XznYDXPVfamLkkWj8RL12wYXpgs_kbfAxFbSrTu14ClHRnYeYA>
    <xme:ARH8X21iqnedd8J438hc9-47eou7kst4IXoWKN_29zSlOHxW00xInKDyUgMi9zXfX
    xLBlTA8R0XqGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ARH8X5ou1kF_w7goHw5XZLQRZceqdl3b-XyiBAjoo_CC_Kk2Xr_83Q>
    <xmx:ARH8X7mf6zzyrp3StpljPjuJraSKBHwR74tnultHqF02BusYnN3mig>
    <xmx:ARH8Xx38ooo5D0sqRV2YI82uj9bn1C5NA9euNsJodLcssPvaxcUIQg>
    <xmx:AhH8X59T73zdKnuAUawaR7V-3N1dYNEPyCBY0fm-uiEcrgf3JQasxA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61429240062;
        Mon, 11 Jan 2021 03:49:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Use an IPI instead of task_work_add() to update" failed to apply to 4.14-stable tree
To:     fenghua.yu@intel.com, bp@suse.de, james.morse@arm.com,
        reinette.chatre@intel.com, shakeelb@google.com,
        tony.luck@intel.com, valentin.schneider@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:50:18 +0100
Message-ID: <1610355018111165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae28d1aae48a1258bd09a6f707ebb4231d79a761 Mon Sep 17 00:00:00 2001
From: Fenghua Yu <fenghua.yu@intel.com>
Date: Thu, 17 Dec 2020 14:31:18 -0800
Subject: [PATCH] x86/resctrl: Use an IPI instead of task_work_add() to update
 PQR_ASSOC MSR

Currently, when moving a task to a resource group the PQR_ASSOC MSR is
updated with the new closid and rmid in an added task callback. If the
task is running, the work is run as soon as possible. If the task is not
running, the work is executed later in the kernel exit path when the
kernel returns to the task again.

Updating the PQR_ASSOC MSR as soon as possible on the CPU a moved task
is running is the right thing to do. Queueing work for a task that is
not running is unnecessary (the PQR_ASSOC MSR is already updated when
the task is scheduled in) and causing system resource waste with the way
in which it is implemented: Work to update the PQR_ASSOC register is
queued every time the user writes a task id to the "tasks" file, even if
the task already belongs to the resource group.

This could result in multiple pending work items associated with a
single task even if they are all identical and even though only a single
update with most recent values is needed. Specifically, even if a task
is moved between different resource groups while it is sleeping then it
is only the last move that is relevant but yet a work item is queued
during each move.

This unnecessary queueing of work items could result in significant
system resource waste, especially on tasks sleeping for a long time.
For example, as demonstrated by Shakeel Butt in [1] writing the same
task id to the "tasks" file can quickly consume significant memory. The
same problem (wasted system resources) occurs when moving a task between
different resource groups.

As pointed out by Valentin Schneider in [2] there is an additional issue
with the way in which the queueing of work is done in that the task_struct
update is currently done after the work is queued, resulting in a race with
the register update possibly done before the data needed by the update is
available.

To solve these issues, update the PQR_ASSOC MSR in a synchronous way
right after the new closid and rmid are ready during the task movement,
only if the task is running. If a moved task is not running nothing
is done since the PQR_ASSOC MSR will be updated next time the task is
scheduled. This is the same way used to update the register when tasks
are moved as part of resource group removal.

[1] https://lore.kernel.org/lkml/CALvZod7E9zzHwenzf7objzGKsdBmVwTgEJ0nPgs0LUFU3SN5Pw@mail.gmail.com/
[2] https://lore.kernel.org/lkml/20201123022433.17905-1-valentin.schneider@arm.com

 [ bp: Massage commit message and drop the two update_task_closid_rmid()
   variants. ]

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 29ffb95b25ff..1c6f8a60ac52 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -525,89 +525,63 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 	kfree(rdtgrp);
 }
 
-struct task_move_callback {
-	struct callback_head	work;
-	struct rdtgroup		*rdtgrp;
-};
-
-static void move_myself(struct callback_head *head)
+static void _update_task_closid_rmid(void *task)
 {
-	struct task_move_callback *callback;
-	struct rdtgroup *rdtgrp;
-
-	callback = container_of(head, struct task_move_callback, work);
-	rdtgrp = callback->rdtgrp;
-
 	/*
-	 * If resource group was deleted before this task work callback
-	 * was invoked, then assign the task to root group and free the
-	 * resource group.
+	 * If the task is still current on this CPU, update PQR_ASSOC MSR.
+	 * Otherwise, the MSR is updated when the task is scheduled in.
 	 */
-	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
-	    (rdtgrp->flags & RDT_DELETED)) {
-		current->closid = 0;
-		current->rmid = 0;
-		rdtgroup_remove(rdtgrp);
-	}
-
-	if (unlikely(current->flags & PF_EXITING))
-		goto out;
-
-	preempt_disable();
-	/* update PQR_ASSOC MSR to make resource group go into effect */
-	resctrl_sched_in();
-	preempt_enable();
+	if (task == current)
+		resctrl_sched_in();
+}
 
-out:
-	kfree(callback);
+static void update_task_closid_rmid(struct task_struct *t)
+{
+	if (IS_ENABLED(CONFIG_SMP) && task_curr(t))
+		smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);
+	else
+		_update_task_closid_rmid(t);
 }
 
 static int __rdtgroup_move_task(struct task_struct *tsk,
 				struct rdtgroup *rdtgrp)
 {
-	struct task_move_callback *callback;
-	int ret;
-
-	callback = kzalloc(sizeof(*callback), GFP_KERNEL);
-	if (!callback)
-		return -ENOMEM;
-	callback->work.func = move_myself;
-	callback->rdtgrp = rdtgrp;
-
 	/*
-	 * Take a refcount, so rdtgrp cannot be freed before the
-	 * callback has been invoked.
+	 * Set the task's closid/rmid before the PQR_ASSOC MSR can be
+	 * updated by them.
+	 *
+	 * For ctrl_mon groups, move both closid and rmid.
+	 * For monitor groups, can move the tasks only from
+	 * their parent CTRL group.
 	 */
-	atomic_inc(&rdtgrp->waitcount);
-	ret = task_work_add(tsk, &callback->work, TWA_RESUME);
-	if (ret) {
-		/*
-		 * Task is exiting. Drop the refcount and free the callback.
-		 * No need to check the refcount as the group cannot be
-		 * deleted before the write function unlocks rdtgroup_mutex.
-		 */
-		atomic_dec(&rdtgrp->waitcount);
-		kfree(callback);
-		rdt_last_cmd_puts("Task exited\n");
-	} else {
-		/*
-		 * For ctrl_mon groups move both closid and rmid.
-		 * For monitor groups, can move the tasks only from
-		 * their parent CTRL group.
-		 */
-		if (rdtgrp->type == RDTCTRL_GROUP) {
-			tsk->closid = rdtgrp->closid;
+
+	if (rdtgrp->type == RDTCTRL_GROUP) {
+		tsk->closid = rdtgrp->closid;
+		tsk->rmid = rdtgrp->mon.rmid;
+	} else if (rdtgrp->type == RDTMON_GROUP) {
+		if (rdtgrp->mon.parent->closid == tsk->closid) {
 			tsk->rmid = rdtgrp->mon.rmid;
-		} else if (rdtgrp->type == RDTMON_GROUP) {
-			if (rdtgrp->mon.parent->closid == tsk->closid) {
-				tsk->rmid = rdtgrp->mon.rmid;
-			} else {
-				rdt_last_cmd_puts("Can't move task to different control group\n");
-				ret = -EINVAL;
-			}
+		} else {
+			rdt_last_cmd_puts("Can't move task to different control group\n");
+			return -EINVAL;
 		}
 	}
-	return ret;
+
+	/*
+	 * Ensure the task's closid and rmid are written before determining if
+	 * the task is current that will decide if it will be interrupted.
+	 */
+	barrier();
+
+	/*
+	 * By now, the task's closid and rmid are set. If the task is current
+	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
+	 * group go into effect. If the task is not current, the MSR will be
+	 * updated when the task is scheduled in.
+	 */
+	update_task_closid_rmid(tsk);
+
+	return 0;
 }
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)

