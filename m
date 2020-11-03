Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C72A43CA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgKCLMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:12:34 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:49699 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgKCLMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:12:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 36C654E5;
        Tue,  3 Nov 2020 06:12:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OmF0yN
        RU4k+5FmuNIOImFGMfhcRknYTsqtb8h5XMpwA=; b=dfHrhbRREjxNSY/+1delNm
        uEiyS+aK5CPjg0NqfwSPezj8ZlnjXLI88+nhQl+VuIfIKrEeXZNJJV4iclAATnsG
        ytOAXawMzTHtkNZFR187D8EGH5WCnyhgdA6XFit3gGBxkLXDEKeNEY+6HMz5H/O0
        IJORJOfpiX3DtrFgKSU/lN90hNvJn6rS5Y5N7K/y/QlE9t4bIDEC7OCDRdevcrp/
        c03CDvaPg6zzIixdY70qxXI5V7Np8grj3pCDxjaUpb+qZdpB1E8hhnWmD26fjRld
        AZ754aUT1/ePuBkksmBkEi5Uyh5VbphP42mZqbaP5qwCFptMtb2XZJLAomhEXWOw
        ==
X-ME-Sender: <xms:IDuhX3C3ZLUPceqW4JOtc1kgJqTWWxC42-fBEuuOMFwtDuqwzs1UpA>
    <xme:IDuhX9jW5js1AJmLAf7yovTqnw0Yoi9L2uTlbvU6gdsoGg5YmQbj7Kv1-v50wiC3M
    vERIjWfnd6nuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IDuhXynizzzVWH6AtoksUWTR8eg5F6x6Sl25aY6NwexyJ2nZMCitEg>
    <xmx:IDuhX5yNY_oTnFXWeNFxDuNqZYigGPw_9s3RTUKVjwolVbI4okaXiA>
    <xmx:IDuhX8Q3sR1FfagWsIceUUfXeDVqZQIB_wAvz-hYetO2Z1uN1DsgGA>
    <xmx:IDuhX167fUNpxWjjdReKSkREoegsoTx1YsDD_OZk1iemV6ksIuI5hjQg4e8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76FA93064680;
        Tue,  3 Nov 2020 06:12:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf/amd/uncore: Set all slices and threads to restore perf" failed to apply to 4.19-stable tree
To:     kim.phillips@amd.com, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 12:13:18 +0100
Message-ID: <160440199819590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8fe99d0701fec9fb849ec880a86bc5592530496 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Tue, 8 Sep 2020 16:47:34 -0500
Subject: [PATCH] perf/amd/uncore: Set all slices and threads to restore perf
 stat -a behaviour

Commit 2f217d58a8a0 ("perf/x86/amd/uncore: Set the thread mask for
F17h L3 PMCs") inadvertently changed the uncore driver's behaviour
wrt perf tool invocations with or without a CPU list, specified with
-C / --cpu=.

Change the behaviour of the driver to assume the former all-cpu (-a)
case, which is the more commonly desired default.  This fixes
'-a -A' invocations without explicit cpu lists (-C) to not count
L3 events only on behalf of the first thread of the first core
in the L3 domain.

BEFORE:

Activity performed by the first thread of the last core (CPU#43) in
CPU#40's L3 domain is not reported by CPU#40:

sudo perf stat -a -A -e l3_request_g1.caching_l3_cache_accesses taskset -c 43 perf bench mem memcpy -s 32mb -l 100 -f default
...
CPU36                 21,835      l3_request_g1.caching_l3_cache_accesses
CPU40                 87,066      l3_request_g1.caching_l3_cache_accesses
CPU44                 17,360      l3_request_g1.caching_l3_cache_accesses
...

AFTER:

The L3 domain activity is now reported by CPU#40:

sudo perf stat -a -A -e l3_request_g1.caching_l3_cache_accesses taskset -c 43 perf bench mem memcpy -s 32mb -l 100 -f default
...
CPU36                354,891      l3_request_g1.caching_l3_cache_accesses
CPU40              1,780,870      l3_request_g1.caching_l3_cache_accesses
CPU44                315,062      l3_request_g1.caching_l3_cache_accesses
...

Fixes: 2f217d58a8a0 ("perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200908214740.18097-2-kim.phillips@amd.com

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 76400c052b0e..e7e61c8b56bd 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -181,28 +181,16 @@ static void amd_uncore_del(struct perf_event *event, int flags)
 }
 
 /*
- * Convert logical CPU number to L3 PMC Config ThreadMask format
+ * Return a full thread and slice mask until per-CPU is
+ * properly supported.
  */
-static u64 l3_thread_slice_mask(int cpu)
+static u64 l3_thread_slice_mask(void)
 {
-	u64 thread_mask, core = topology_core_id(cpu);
-	unsigned int shift, thread = 0;
+	if (boot_cpu_data.x86 <= 0x18)
+		return AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK;
 
-	if (topology_smt_supported() && !topology_is_primary_thread(cpu))
-		thread = 1;
-
-	if (boot_cpu_data.x86 <= 0x18) {
-		shift = AMD64_L3_THREAD_SHIFT + 2 * (core % 4) + thread;
-		thread_mask = BIT_ULL(shift);
-
-		return AMD64_L3_SLICE_MASK | thread_mask;
-	}
-
-	core = (core << AMD64_L3_COREID_SHIFT) & AMD64_L3_COREID_MASK;
-	shift = AMD64_L3_THREAD_SHIFT + thread;
-	thread_mask = BIT_ULL(shift);
-
-	return AMD64_L3_EN_ALL_SLICES | core | thread_mask;
+	return AMD64_L3_EN_ALL_SLICES | AMD64_L3_EN_ALL_CORES |
+	       AMD64_L3_F19H_THREAD_MASK;
 }
 
 static int amd_uncore_event_init(struct perf_event *event)
@@ -232,7 +220,7 @@ static int amd_uncore_event_init(struct perf_event *event)
 	 * For other events, the two fields do not affect the count.
 	 */
 	if (l3_mask && is_llc_event(event))
-		hwc->config |= l3_thread_slice_mask(event->cpu);
+		hwc->config |= l3_thread_slice_mask();
 
 	uncore = event_to_amd_uncore(event);
 	if (!uncore)

