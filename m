Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75496EE600
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbjDYQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 12:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjDYQpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 12:45:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B3316F13;
        Tue, 25 Apr 2023 09:45:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f0dd117dcso873455066b.3;
        Tue, 25 Apr 2023 09:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682441143; x=1685033143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CbOvRoEUKSyfGhCu7C/NoXqYG19IKk52zJ9SBJ/R7g8=;
        b=MRo7kFU3t+at2VOSzayEGWbwHHmEXpen/bcgV9GkLz8XacX2JmX7gQ3mkxvpurvdiv
         473TFrKNtjdYHQcETkZQF8qjJhYQdP+z8uN84zaletSTX2sI0NZ0LTFJGTym0cmJM66l
         RIKwRrUE2OyGUNHwWvPcyekHbzfX6Sy8MhTcr923dLKWtBUDor9UBPLg86gjSUNCajSL
         p04QKXbFs64gRCYYIlHLmCOxIrGbRoPx1piTGC7oHs9j4whrChQsq4GomiEcXmI2aiJa
         kV/UMsjNfVQf+WwzdN1bnTomo/kAAfFhUuk1jWxmG3/FQ2S/xQDmQJUfhqhV/kEaKkVB
         EG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682441143; x=1685033143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CbOvRoEUKSyfGhCu7C/NoXqYG19IKk52zJ9SBJ/R7g8=;
        b=Cov0owVNBk2vSbsUAbET1UsGZm/fscmjnXUTjXOwVcH0vHaAtiIFf/B6IVVUmut0yL
         3GOHd9uB2PttmOhH/CSNpIGcYVBCk0+SySdics90+91hMawMdz0jLdGK/YeiJt3EwoQL
         Sj+u/9+7j8fImidkPqYpOsySoDMISra9SiFGpUmaOMHWLEmETi8fVEF+LxTW3gCEX46s
         BBDEfT1Z3YmkwN+ih0EZ/9r+dDSxRIwyd9krvbnmANJqr1rGk1viXTwdy9XaMGnyGC8s
         4G4gZLjXFPO3Z+A7OM71ItLRfflysmj8SPKq/BHnJDHffer5pA+Cue/Q0sZCzMPYRL+G
         J1Kg==
X-Gm-Message-State: AAQBX9f7EehjrnZn7T5UdNWZaKI3+DCrxSSm3E27zDwBQU8gjzQZHrO+
        desqNFDurdbCALcDDErEYxQ=
X-Google-Smtp-Source: AKy350Yx5muNN+fiinUjUh1ezlUca6HMzS4jspwZNzhpBdA2gGx0pG8yUP58PLZ/3mOUkEqhJD8unQ==
X-Received: by 2002:a17:907:c312:b0:94f:5e17:e80d with SMTP id tl18-20020a170907c31200b0094f5e17e80dmr14391434ejc.45.1682441143427;
        Tue, 25 Apr 2023 09:45:43 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id gz19-20020a170907a05300b0095076890fc1sm6978512ejc.1.2023.04.25.09.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:45:43 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Ziwei Dai <ziwei.dai@unisoc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH 1/1] linux-6.2/rcu/kvfree: Avoid freeing new kfree_rcu() memory after old grace period
Date:   Tue, 25 Apr 2023 18:45:41 +0200
Message-Id: <20230425164541.423811-1-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziwei Dai <ziwei.dai@unisoc.com>

commit 5da7cb193db32da783a3f3e77d8b639989321d48 upstream.

Memory passed to kvfree_rcu() that is to be freed is tracked by a
per-CPU kfree_rcu_cpu structure, which in turn contains pointers
to kvfree_rcu_bulk_data structures that contain pointers to memory
that has not yet been handed to RCU, along with an kfree_rcu_cpu_work
structure that tracks the memory that has already been handed to RCU.
These structures track three categories of memory: (1) Memory for
kfree(), (2) Memory for kvfree(), and (3) Memory for both that arrived
during an OOM episode.  The first two categories are tracked in a
cache-friendly manner involving a dynamically allocated page of pointers
(the aforementioned kvfree_rcu_bulk_data structures), while the third
uses a simple (but decidedly cache-unfriendly) linked list through the
rcu_head structures in each block of memory.

On a given CPU, these three categories are handled as a unit, with that
CPU's kfree_rcu_cpu_work structure having one pointer for each of the
three categories.  Clearly, new memory for a given category cannot be
placed in the corresponding kfree_rcu_cpu_work structure until any old
memory has had its grace period elapse and thus has been removed.  And
the kfree_rcu_monitor() function does in fact check for this.

Except that the kfree_rcu_monitor() function checks these pointers one
at a time.  This means that if the previous kfree_rcu() memory passed
to RCU had only category 1 and the current one has only category 2, the
kfree_rcu_monitor() function will send that current category-2 memory
along immediately.  This can result in memory being freed too soon,
that is, out from under unsuspecting RCU readers.

To see this, consider the following sequence of events, in which:

o	Task A on CPU 0 calls rcu_read_lock(), then uses "from_cset",
	then is preempted.

o	CPU 1 calls kfree_rcu(cset, rcu_head) in order to free "from_cset"
	after a later grace period.  Except that "from_cset" is freed
	right after the previous grace period ended, so that "from_cset"
	is immediately freed.  Task A resumes and references "from_cset"'s
	member, after which nothing good happens.

In full detail:

CPU 0					CPU 1
----------------------			----------------------
count_memcg_event_mm()
|rcu_read_lock()  <---
|mem_cgroup_from_task()
 |// css_set_ptr is the "from_cset" mentioned on CPU 1
 |css_set_ptr = rcu_dereference((task)->cgroups)
 |// Hard irq comes, current task is scheduled out.

					cgroup_attach_task()
					|cgroup_migrate()
					|cgroup_migrate_execute()
					|css_set_move_task(task, from_cset, to_cset, true)
					|cgroup_move_task(task, to_cset)
					|rcu_assign_pointer(.., to_cset)
					|...
					|cgroup_migrate_finish()
					|put_css_set_locked(from_cset)
					|from_cset->refcount return 0
					|kfree_rcu(cset, rcu_head) // free from_cset after new gp
					|add_ptr_to_bulk_krc_lock()
					|schedule_delayed_work(&krcp->monitor_work, ..)

					kfree_rcu_monitor()
					|krcp->bulk_head[0]'s work attached to krwp->bulk_head_free[]
					|queue_rcu_work(system_wq, &krwp->rcu_work)
					|if rwork->rcu.work is not in WORK_STRUCT_PENDING_BIT state,
					|call_rcu(&rwork->rcu, rcu_work_rcufn) <--- request new gp

					// There is a perious call_rcu(.., rcu_work_rcufn)
					// gp end, rcu_work_rcufn() is called.
					rcu_work_rcufn()
					|__queue_work(.., rwork->wq, &rwork->work);

					|kfree_rcu_work()
					|krwp->bulk_head_free[0] bulk is freed before new gp end!!!
					|The "from_cset" is freed before new gp end.

// the task resumes some time later.
 |css_set_ptr->subsys[(subsys_id) <--- Caused kernel crash, because css_set_ptr is freed.

This commit therefore causes kfree_rcu_monitor() to refrain from moving
kfree_rcu() memory to the kfree_rcu_cpu_work structure until the RCU
grace period has completed for all three categories.

v2: Use helper function instead of inserted code block at kfree_rcu_monitor().

[UR: backport to 6.2-stable]
Fixes: 34c881745549 ("rcu: Support kfree_bulk() interface in kfree_rcu()")
Fixes: 5f3c8d620447 ("rcu/tree: Maintain separate array for vmalloc ptrs")
Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Ziwei Dai <ziwei.dai@unisoc.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index cf34a961821a..522129193771 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3131,6 +3131,18 @@ need_offload_krc(struct kfree_rcu_cpu *krcp)
 	return !!krcp->head;
 }
 
+static bool
+need_wait_for_krwp_work(struct kfree_rcu_cpu_work *krwp)
+{
+	int i;
+
+	for (i = 0; i < FREE_N_CHANNELS; i++)
+		if (krwp->bkvhead_free[i])
+			return true;
+
+	return !!krwp->head_free;
+}
+
 static void
 schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
 {
@@ -3162,14 +3174,13 @@ static void kfree_rcu_monitor(struct work_struct *work)
 	for (i = 0; i < KFREE_N_BATCHES; i++) {
 		struct kfree_rcu_cpu_work *krwp = &(krcp->krw_arr[i]);
 
-		// Try to detach bkvhead or head and attach it over any
-		// available corresponding free channel. It can be that
-		// a previous RCU batch is in progress, it means that
-		// immediately to queue another one is not possible so
-		// in that case the monitor work is rearmed.
-		if ((krcp->bkvhead[0] && !krwp->bkvhead_free[0]) ||
-			(krcp->bkvhead[1] && !krwp->bkvhead_free[1]) ||
-				(krcp->head && !krwp->head_free)) {
+		// Try to detach bulk_head or head and attach it, only when
+		// all channels are free.  Any channel is not free means at krwp
+		// there is on-going rcu work to handle krwp's free business.
+		if (need_wait_for_krwp_work(krwp))
+			continue;
+
+		if (need_offload_krc(krcp)) {
 			// Channel 1 corresponds to the SLAB-pointer bulk path.
 			// Channel 2 corresponds to vmalloc-pointer bulk path.
 			for (j = 0; j < FREE_N_CHANNELS; j++) {
-- 
2.30.2

