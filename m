Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9271938E660
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhEXMOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:14:19 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56459 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232516AbhEXMOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:14:19 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id BCFD41940503;
        Mon, 24 May 2021 08:12:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 24 May 2021 08:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7afnoB
        Te5u4iYAAResO6T6qAnRITQB0F3aOVhiv4Oc0=; b=MfKxiTL0WI0JOqxqsFKopq
        o7Jyo5UA1fpU/Ojag5zv9YlTW30LVtTUANZATapySm9lO4bUWaN3OpODtglwyBqh
        rt10j3o/nP5zJ+ViAe9Ib4EIIgRGix0FLywOH2rIcLf8j0n+yaKoe7sKNvWL0KFw
        rnGCPhAoErkDdh8maehE3XugJ8T9a2FqCFoX/pkfwN06W6lALnCgV45ULd9Eyu1X
        eP5EruIYyQi8mmjmJwjNBUberpDX5LXKX3Vxuo1iBY4H9RlQzBdN0JLqodP7eBM0
        BMj66phGxKmCPdUHeUZ8Eg7mBtLA0X9pAu0rk/Z0IVss2g8c/WNFPBIcIJSZPyuA
        ==
X-ME-Sender: <xms:QZirYP1zb2HHGedEL6t_MJTT7m2JvsOAPkSkfRv3oiwSHdzrcKwyzg>
    <xme:QZirYOHM2zmE45L3-nALa2Va5iw4-QMylf7BYRAD1qRCwvtzQ9Gx0taEOoCfcpzmR
    h1WEGlypy0D-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QZirYP65dBGes3fVmEfG7wWw_y9hXGOse4uns-dT7B5CzbFE7rpHzA>
    <xmx:QZirYE3R2Ezsky-XvUSiUQylDsHMKIULuMbsXEYbVtfom2msix7-Iw>
    <xmx:QZirYCEQnHmgf8k7rHcnZ8PimRfjealLmiXRZXyuPDjd6fh0Q02XcA>
    <xmx:QpirYEPZacDXL_I2Mx9mgpOd-PhMhmePnB66EshJeEVY7KGXmEIYFg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:12:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/x86/lbr: Remove cpuc->lbr_xsave allocation from atomic" failed to apply to 5.10-stable tree
To:     like.xu@linux.intel.com, kan.liang@linux.intel.com,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 14:12:47 +0200
Message-ID: <162185836715815@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

