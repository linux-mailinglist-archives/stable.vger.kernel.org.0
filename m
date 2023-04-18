Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113AE6E5EB1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjDRK0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjDRKZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:25:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853BE9758;
        Tue, 18 Apr 2023 03:25:23 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2a8ba5f1d6bso18088411fa.2;
        Tue, 18 Apr 2023 03:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681813521; x=1684405521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8EDCVWrrYjmdhE+3VIsyJI2fCbptGUdt113PnBa7as=;
        b=imJsla87cGI4sfCU7nvsUDxE60K8yguI5a6RXOkU3X9pu0SEiy7BOzh5gXZy0WKyFB
         eJAnT0SYMmCz3gveVIO4idMBrBTdYYXyYpK5rM4qP/DU+o/N5s2/p2UR52NAvHP3wecO
         1HbfCh6JxapW5D41LHyG107xz3hYHEwd3Ug6lr2ZIe4Gn9B3MPKgRXgKKyYSMGP82ZsG
         xdzxgSd+mbgxvXuykIjs7oKjIeD+i3ew09iaYeMClvVty6y02f2ZRKlPKvTw/h+Fbp+5
         1q0YM/xLYNtXx8eARpASjcZByV5OLiR2MOoxDgGkEXYYIjalOOhxNreC/zxT/KOp+rSS
         uz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681813521; x=1684405521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8EDCVWrrYjmdhE+3VIsyJI2fCbptGUdt113PnBa7as=;
        b=KRwfNzMvAVa1aDGje6CRvenM1zsYnY4Yl6/4qaw45fG3RxB9hMaq6SHO4ASKrYHClh
         Ki6nhUCoRK5+BIf9csnKjXLEcKw4EicWymGoCAmpcV3yVmephJMeCycupp04NrC2wQ+C
         I+e827JAHwjtlu77cvgXzd1j8zHqYCBqmWLtY6Q/0ZWbd3tWboM3YzuZCtyCuZeFTVJo
         ZioJq+lljUHVWzXDw79a6kfiba5wjRo3EpIb7NanruzpEOZx+/m0+VPLHF4lcdhS8LoO
         a7XmdVvX6s2q+jrD1+l0B04n2eSuaknl26uuVcigAUTrLoYXwFL70i1KOww1brBgD0WF
         UF2A==
X-Gm-Message-State: AAQBX9eY4ACfVe5wV/DUl6YSeWi61wcaV4Xl7T6Rx+NdNYDov1n5ia0p
        In83+5E9oMbob2QDajVkIgTMXSP0rp8=
X-Google-Smtp-Source: AKy350b6AXBnTOK7aSrfdilfwa8+ZRQvuBN3Ns2GYHU+al99cR6iDo+ckM+4wCFKcsXmUOOGlstfcg==
X-Received: by 2002:a19:ac05:0:b0:4ec:8c1e:c816 with SMTP id g5-20020a19ac05000000b004ec8c1ec816mr2594631lfc.34.1681813521503;
        Tue, 18 Apr 2023 03:25:21 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id z13-20020ac25ded000000b004ec8de8ab43sm2332421lfq.139.2023.04.18.03.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:25:21 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Ziwei Dai <ziwei.dai@unisoc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH 1/1] linux-5.15/rcu/kvfree: Avoid freeing new kfree_rcu() memory after old grace period
Date:   Tue, 18 Apr 2023 12:25:17 +0200
Message-Id: <20230418102518.5911-2-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418102518.5911-1-urezki@gmail.com>
References: <20230418102518.5911-1-urezki@gmail.com>
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

[UR: backport to 5.15-stable]
[UR: Added missing need_offload_krc() function]
Fixes: 34c881745549 ("rcu: Support kfree_bulk() interface in kfree_rcu()")
Fixes: 5f3c8d620447 ("rcu/tree: Maintain separate array for vmalloc ptrs")
Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Ziwei Dai <ziwei.dai@unisoc.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index cf101da389b0..6d638f282967 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3327,6 +3327,30 @@ static void kfree_rcu_work(struct work_struct *work)
 	}
 }
 
+static bool
+need_offload_krc(struct kfree_rcu_cpu *krcp)
+{
+	int i;
+
+	for (i = 0; i < FREE_N_CHANNELS; i++)
+		if (krcp->bkvhead[i])
+			return true;
+
+	return !!krcp->head;
+}
+
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
 /*
  * This function is invoked after the KFREE_DRAIN_JIFFIES timeout.
  */
@@ -3343,14 +3367,13 @@ static void kfree_rcu_monitor(struct work_struct *work)
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

