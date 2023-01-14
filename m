Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20C666AAC8
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjANJxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjANJxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:53:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494A7A81
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528B7B80765
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7101FC433EF;
        Sat, 14 Jan 2023 09:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673690009;
        bh=Oqyf4gFMQPi8foS1mlA8LYVgsfq28FnOwJ05Gv/XZLU=;
        h=Subject:To:Cc:From:Date:From;
        b=uZhQCiNQKQ6IRmVsMxsfusiXZE/ufR9U3vwpk6PksXmGZ0id/YkCUjtGDvMo8goNU
         BTiPdgVRUd7swG9gl17UISLEYtcVXbLG77AHgDV3DAuYDbYtD9sTLgMuYYzMkHksHT
         lU2DzrWVu1oNrth4ofPFXwwaIv1p6ew4/A4KeG+k=
Subject: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()" failed to apply to 5.15-stable tree
To:     longman@redhat.com, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:53:19 +0100
Message-ID: <1673689999203204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

87ca4f9efbd7 ("sched/core: Fix use-after-free bug in dup_user_cpus_ptr()")
8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
713a2e21a513 ("sched: Introduce affinity_context")
d664e399128b ("sched: Fix missing prototype warnings")
e81daa7b6489 ("sched/headers: Reorganize, clean up and optimize kernel/sched/build_utility.c dependencies")
0dda4eeb4849 ("sched/headers: Reorganize, clean up and optimize kernel/sched/build_policy.c dependencies")
c4ad6fcb67c4 ("sched/headers: Reorganize, clean up and optimize kernel/sched/fair.c dependencies")
e66f6481a8c7 ("sched/headers: Reorganize, clean up and optimize kernel/sched/core.c dependencies")
b9e9c6ca6e54 ("sched/headers: Standardize kernel/sched/sched.h header dependencies")
f96eca432015 ("sched/headers: Introduce kernel/sched/build_policy.c and build multiple .c files there")
801c14195510 ("sched/headers: Introduce kernel/sched/build_utility.c and build multiple .c files there")
d90a2f160a1c ("sched/headers: Add header guard to kernel/sched/stats.h and kernel/sched/autogroup.h")
99cf983cc8bc ("sched/preempt: Add PREEMPT_DYNAMIC using static keys")
33c64734be34 ("sched/preempt: Decouple HAVE_PREEMPT_DYNAMIC from GENERIC_ENTRY")
4624a14f4daa ("sched/preempt: Simplify irqentry_exit_cond_resched() callers")
8a69fe0be143 ("sched/preempt: Refactor sched_dynamic_update()")
4c7485584d48 ("sched/preempt: Move PREEMPT_DYNAMIC logic later")
6ae71436cda7 ("Merge tag 'sched_core_for_v5.17_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Fri, 30 Dec 2022 23:11:19 -0500
Subject: [PATCH] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
restricted on asymmetric systems"), the setting and clearing of
user_cpus_ptr are done under pi_lock for arm64 architecture. However,
dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
protection. Since sched_setaffinity() can be invoked from another
process, the process being modified may be undergoing fork() at
the same time.  When racing with the clearing of user_cpus_ptr in
__set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
possibly double-free in arm64 kernel.

Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
cpumask") fixes this problem as user_cpus_ptr, once set, will never
be cleared in a task's lifetime. However, this bug was re-introduced
in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
do_set_cpus_allowed(). This time, it will affect all arches.

Fix this bug by always clearing the user_cpus_ptr of the newly
cloned/forked task before the copying process starts and check the
user_cpus_ptr state of the source task under pi_lock.

Note to stable, this patch won't be applicable to stable releases.
Just copy the new dup_user_cpus_ptr() function over.

Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221231041120.440785-2-longman@redhat.com

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 965d813c28ad..f9f6e5413dcf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2612,19 +2612,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
 		      int node)
 {
+	cpumask_t *user_mask;
 	unsigned long flags;
 
-	if (!src->user_cpus_ptr)
+	/*
+	 * Always clear dst->user_cpus_ptr first as their user_cpus_ptr's
+	 * may differ by now due to racing.
+	 */
+	dst->user_cpus_ptr = NULL;
+
+	/*
+	 * This check is racy and losing the race is a valid situation.
+	 * It is not worth the extra overhead of taking the pi_lock on
+	 * every fork/clone.
+	 */
+	if (data_race(!src->user_cpus_ptr))
 		return 0;
 
-	dst->user_cpus_ptr = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
-	if (!dst->user_cpus_ptr)
+	user_mask = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
+	if (!user_mask)
 		return -ENOMEM;
 
-	/* Use pi_lock to protect content of user_cpus_ptr */
+	/*
+	 * Use pi_lock to protect content of user_cpus_ptr
+	 *
+	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
+	 * do_set_cpus_allowed().
+	 */
 	raw_spin_lock_irqsave(&src->pi_lock, flags);
-	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	if (src->user_cpus_ptr) {
+		swap(dst->user_cpus_ptr, user_mask);
+		cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	}
 	raw_spin_unlock_irqrestore(&src->pi_lock, flags);
+
+	if (unlikely(user_mask))
+		kfree(user_mask);
+
 	return 0;
 }
 

