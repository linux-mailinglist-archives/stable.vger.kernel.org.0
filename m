Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7312C2A8
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 15:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL2OVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 09:21:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44853 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbfL2OVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 09:21:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CB3D21583;
        Sun, 29 Dec 2019 09:21:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 09:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=t1gbS+
        tCZ+nAnAA/pIoNNdF63NwyT/MWAODzBl6BCHo=; b=CBJf3zIo96ztnTEKxIplUT
        qyAmA84Ng5f01WXM0dmlG5AN7k7JU94Z9B0LKwSiUwh9WwFdfmLvmhPZgmBbNIEN
        c137b8FDEJgNNR/rSpqDDsGjO322uqh7lJkkA4YT47P2XadNtkCrI0NUNAbCoR9v
        SVBIaKPgqCiYtTU1iGV+t+t6kG4FLOATfsGPVX4kK5j/B5D9NBHtiKYEvgWdevIR
        J721UZpN/TMVOzezWzT7ujVI+GrqFxcBM9sgT0smxFmqHoGYNnecKnn6DebRWwZx
        YRBpKz1cueRjRPs9JzIZCeW2ggtOdKDnZm+kSqEGcixhKLJhSQXJhWMO6rfmkQrg
        ==
X-ME-Sender: <xms:fLYIXguT4sCqMZmCmkYyfPCjvF0GGzwPKdQxPETjRnzmjhXw6viIpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:fLYIXgulY_WvKLM9t1QRHJVOOV3T-SUp7E1KiAIlTIBvIEcwO1gqUA>
    <xmx:fLYIXv2TaLvw3VtSueTlXQ9sEbT0rU6DsEZwAGQqLSI396PoBLUJ6g>
    <xmx:fLYIXtOLQ1xFCwB-f8RkpW_mAWf6vxqOFmNAaCtiRsyM_SxCuFzJMg>
    <xmx:fLYIXpDaf3q5bdlygjpxsF00iFAPNXIP3qtnhKWdS02I95V5A2qwfw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 97DC680059;
        Sun, 29 Dec 2019 09:21:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] cpufreq: Avoid leaving stale IRQ work items during CPU" failed to apply to 4.14-stable tree
To:     rafael.j.wysocki@intel.com, anson.huang@nxp.com, peng.fan@nxp.com,
        stable@vger.kernel.org, viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 15:21:46 +0100
Message-ID: <15776293061514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 85572c2c4a45a541e880e087b5b17a48198b2416 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Wed, 11 Dec 2019 11:28:41 +0100
Subject: [PATCH] cpufreq: Avoid leaving stale IRQ work items during CPU
 offline

The scheduler code calling cpufreq_update_util() may run during CPU
offline on the target CPU after the IRQ work lists have been flushed
for it, so the target CPU should be prevented from running code that
may queue up an IRQ work item on it at that point.

Unfortunately, that may not be the case if dvfs_possible_from_any_cpu
is set for at least one cpufreq policy in the system, because that
allows the CPU going offline to run the utilization update callback
of the cpufreq governor on behalf of another (online) CPU in some
cases.

If that happens, the cpufreq governor callback may queue up an IRQ
work on the CPU running it, which is going offline, and the IRQ work
may not be flushed after that point.  Moreover, that IRQ work cannot
be flushed until the "offlining" CPU goes back online, so if any
other CPU calls irq_work_sync() to wait for the completion of that
IRQ work, it will have to wait until the "offlining" CPU is back
online and that may not happen forever.  In particular, a system-wide
deadlock may occur during CPU online as a result of that.

The failing scenario is as follows.  CPU0 is the boot CPU, so it
creates a cpufreq policy and becomes the "leader" of it
(policy->cpu).  It cannot go offline, because it is the boot CPU.
Next, other CPUs join the cpufreq policy as they go online and they
leave it when they go offline.  The last CPU to go offline, say CPU3,
may queue up an IRQ work while running the governor callback on
behalf of CPU0 after leaving the cpufreq policy because of the
dvfs_possible_from_any_cpu effect described above.  Then, CPU0 is
the only online CPU in the system and the stale IRQ work is still
queued on CPU3.  When, say, CPU1 goes back online, it will run
irq_work_sync() to wait for that IRQ work to complete and so it
will wait for CPU3 to go back online (which may never happen even
in principle), but (worse yet) CPU0 is waiting for CPU1 at that
point too and a system-wide deadlock occurs.

To address this problem notice that CPUs which cannot run cpufreq
utilization update code for themselves (for example, because they
have left the cpufreq policies that they belonged to), should also
be prevented from running that code on behalf of the other CPUs that
belong to a cpufreq policy with dvfs_possible_from_any_cpu set and so
in that case the cpufreq_update_util_data pointer of the CPU running
the code must not be NULL as well as for the CPU which is the target
of the cpufreq utilization update in progress.

Accordingly, change cpufreq_this_cpu_can_update() into a regular
function in kernel/sched/cpufreq.c (instead of a static inline in a
header file) and make it check the cpufreq_update_util_data pointer
of the local CPU if dvfs_possible_from_any_cpu is set for the target
cpufreq policy.

Also update the schedutil governor to do the
cpufreq_this_cpu_can_update() check in the non-fast-switch
case too to avoid the stale IRQ work issues.

Fixes: 99d14d0e16fa ("cpufreq: Process remote callbacks from any CPU if the platform permits")
Link: https://lore.kernel.org/linux-pm/20191121093557.bycvdo4xyinbc5cb@vireshk-i7/
Reported-by: Anson Huang <anson.huang@nxp.com>
Tested-by: Anson Huang <anson.huang@nxp.com>
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Peng Fan <peng.fan@nxp.com> (i.MX8QXP-MEK)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 92d5fdc8154e..31b1b0e03df8 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -595,17 +595,6 @@ struct governor_attr {
 			 size_t count);
 };
 
-static inline bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy)
-{
-	/*
-	 * Allow remote callbacks if:
-	 * - dvfs_possible_from_any_cpu flag is set
-	 * - the local and remote CPUs share cpufreq policy
-	 */
-	return policy->dvfs_possible_from_any_cpu ||
-		cpumask_test_cpu(smp_processor_id(), policy->cpus);
-}
-
 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
diff --git a/include/linux/sched/cpufreq.h b/include/linux/sched/cpufreq.h
index afa940cd50dc..cc6bcc1e96bc 100644
--- a/include/linux/sched/cpufreq.h
+++ b/include/linux/sched/cpufreq.h
@@ -12,6 +12,8 @@
 #define SCHED_CPUFREQ_MIGRATION	(1U << 1)
 
 #ifdef CONFIG_CPU_FREQ
+struct cpufreq_policy;
+
 struct update_util_data {
        void (*func)(struct update_util_data *data, u64 time, unsigned int flags);
 };
@@ -20,6 +22,7 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
                        void (*func)(struct update_util_data *data, u64 time,
 				    unsigned int flags));
 void cpufreq_remove_update_util_hook(int cpu);
+bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy);
 
 static inline unsigned long map_util_freq(unsigned long util,
 					unsigned long freq, unsigned long cap)
diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
index b5dcd1d83c7f..7c2fe50fd76d 100644
--- a/kernel/sched/cpufreq.c
+++ b/kernel/sched/cpufreq.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2016, Intel Corporation
  * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  */
+#include <linux/cpufreq.h>
+
 #include "sched.h"
 
 DEFINE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
@@ -57,3 +59,19 @@ void cpufreq_remove_update_util_hook(int cpu)
 	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), NULL);
 }
 EXPORT_SYMBOL_GPL(cpufreq_remove_update_util_hook);
+
+/**
+ * cpufreq_this_cpu_can_update - Check if cpufreq policy can be updated.
+ * @policy: cpufreq policy to check.
+ *
+ * Return 'true' if:
+ * - the local and remote CPUs share @policy,
+ * - dvfs_possible_from_any_cpu is set in @policy and the local CPU is not going
+ *   offline (in which case it is not expected to run cpufreq updates any more).
+ */
+bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy)
+{
+	return cpumask_test_cpu(smp_processor_id(), policy->cpus) ||
+		(policy->dvfs_possible_from_any_cpu &&
+		 rcu_dereference_sched(*this_cpu_ptr(&cpufreq_update_util_data)));
+}
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 322ca8860f54..9b8916fd00a2 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -82,12 +82,10 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 	 * by the hardware, as calculating the frequency is pointless if
 	 * we cannot in fact act on it.
 	 *
-	 * For the slow switching platforms, the kthread is always scheduled on
-	 * the right set of CPUs and any CPU can find the next frequency and
-	 * schedule the kthread.
+	 * This is needed on the slow switching platforms too to prevent CPUs
+	 * going offline from leaving stale IRQ work items behind.
 	 */
-	if (sg_policy->policy->fast_switch_enabled &&
-	    !cpufreq_this_cpu_can_update(sg_policy->policy))
+	if (!cpufreq_this_cpu_can_update(sg_policy->policy))
 		return false;
 
 	if (unlikely(sg_policy->limits_changed)) {

