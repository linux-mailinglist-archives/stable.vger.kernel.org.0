Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81A338E661
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhEXMO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:14:28 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59653 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232516AbhEXMO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:14:27 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 73FEA1940438;
        Mon, 24 May 2021 08:12:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 24 May 2021 08:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RbqU+0
        4pEtW+ygc6aiYHYStzD4wZ4Bf6OY162uCgWK4=; b=YQNxja+yD7csxGuyMYriKi
        O7fJTztrIfU1W8KxDXTiEqXc9d6b4mxV90d0R5Q3OOHAMvwOaxEfQrrTv2eiLzJK
        f8bjaK6XCpNb14o/QPPuZRknRWNcd9WrwnTehsBcAA0zI8u4he9fbmaGPut29Ipw
        2E0xBIu5eOAhjyD8RbWc5PfDG9L5gK4ygY0xyI5ma5zPB3MzK7gvVHoiNmPUiKE5
        f7iLtcuCv5hnbdUG4V5+zy1gtEY+qgwA3SNJ+2YEy9Bbx6I/tr88lNNzquP1y6FU
        g1npoTyvWgUs7Me8SlWcIC2aZKkvEyzth4wwYiB8DL7DdOVMz4l1dgP0ZWkstCTQ
        ==
X-ME-Sender: <xms:SpirYDZ7Rwnilc6KoM9sPciuARMnQuXz8WhBwEvrxm1PRetq7vMNjQ>
    <xme:SpirYCYW4N2Uw91aMe8vOYh98spD1dKqmCD1-g9coqU6s1o8IUdQLBT6BE1mNtbty
    Mh8ZyjjupoK6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S5irYF_qtyKoRFtZzBYkTk3TpkWAhx4_xfWDe-0JKV15uMV-ccC6eg>
    <xmx:S5irYJqQV7sIi2-xYxNfEQnPlWdwEZMqGKJWwEg63Jw740v7G8dFIw>
    <xmx:S5irYOqxbobEoTa7l7UXnjrmEVtfqPVHAknzEdNNGhyjUISD5TzN4w>
    <xmx:S5irYDBVsjDpmP7h3sp3nCNLfTByHF9VLAuiL-s8ncmwyWBbqs1ELA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:12:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/x86/lbr: Remove cpuc->lbr_xsave allocation from atomic" failed to apply to 5.12-stable tree
To:     like.xu@linux.intel.com, kan.liang@linux.intel.com,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 14:12:48 +0200
Message-ID: <162185836897136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 488e13a489e9707a7e81e1991fdd1f20c0f04689 Mon Sep 17 00:00:00 2001
From: Like Xu <like.xu@linux.intel.com>
Date: Fri, 30 Apr 2021 13:22:47 +0800
Subject: [PATCH] perf/x86/lbr: Remove cpuc->lbr_xsave allocation from atomic
 context

If the kernel is compiled with the CONFIG_LOCKDEP option, the conditional
might_sleep_if() deep in kmem_cache_alloc() will generate the following
trace, and potentially cause a deadlock when another LBR event is added:

  [] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:196
  [] Call Trace:
  []  kmem_cache_alloc+0x36/0x250
  []  intel_pmu_lbr_add+0x152/0x170
  []  x86_pmu_add+0x83/0xd0

Make it symmetric with the release_lbr_buffers() call and mirror the
existing DS buffers.

Fixes: c085fb8774 ("perf/x86/intel/lbr: Support XSAVES for arch LBR read")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
[peterz: simplified]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20210430052247.3079672-2-like.xu@linux.intel.com

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 8e509325c2c3..8f71dd72ef95 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -396,10 +396,12 @@ int x86_reserve_hardware(void)
 	if (!atomic_inc_not_zero(&pmc_refcount)) {
 		mutex_lock(&pmc_reserve_mutex);
 		if (atomic_read(&pmc_refcount) == 0) {
-			if (!reserve_pmc_hardware())
+			if (!reserve_pmc_hardware()) {
 				err = -EBUSY;
-			else
+			} else {
 				reserve_ds_buffers();
+				reserve_lbr_buffers();
+			}
 		}
 		if (!err)
 			atomic_inc(&pmc_refcount);
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 76dbab6ac9fb..4409d2cccfda 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -658,7 +658,6 @@ static inline bool branch_user_callstack(unsigned br_sel)
 
 void intel_pmu_lbr_add(struct perf_event *event)
 {
-	struct kmem_cache *kmem_cache = event->pmu->task_ctx_cache;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!x86_pmu.lbr_nr)
@@ -696,11 +695,6 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	perf_sched_cb_inc(event->ctx->pmu);
 	if (!cpuc->lbr_users++ && !event->total_time_running)
 		intel_pmu_lbr_reset();
-
-	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
-	    kmem_cache && !cpuc->lbr_xsave &&
-	    (cpuc->lbr_users != cpuc->lbr_pebs_users))
-		cpuc->lbr_xsave = kmem_cache_alloc(kmem_cache, GFP_KERNEL);
 }
 
 void release_lbr_buffers(void)
@@ -722,6 +716,26 @@ void release_lbr_buffers(void)
 	}
 }
 
+void reserve_lbr_buffers(void)
+{
+	struct kmem_cache *kmem_cache;
+	struct cpu_hw_events *cpuc;
+	int cpu;
+
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	for_each_possible_cpu(cpu) {
+		cpuc = per_cpu_ptr(&cpu_hw_events, cpu);
+		kmem_cache = x86_get_pmu(cpu)->task_ctx_cache;
+		if (!kmem_cache || cpuc->lbr_xsave)
+			continue;
+
+		cpuc->lbr_xsave = kmem_cache_alloc_node(kmem_cache, GFP_KERNEL,
+							cpu_to_node(cpu));
+	}
+}
+
 void intel_pmu_lbr_del(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 27fa85e7d4fd..ad87cb36f7c8 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1244,6 +1244,8 @@ void reserve_ds_buffers(void);
 
 void release_lbr_buffers(void);
 
+void reserve_lbr_buffers(void);
+
 extern struct event_constraint bts_constraint;
 extern struct event_constraint vlbr_constraint;
 
@@ -1393,6 +1395,10 @@ static inline void release_lbr_buffers(void)
 {
 }
 
+static inline void reserve_lbr_buffers(void)
+{
+}
+
 static inline int intel_pmu_init(void)
 {
 	return 0;

