Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237332A43CB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgKCLMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:12:35 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50751 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgKCLMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:12:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9E737B74;
        Tue,  3 Nov 2020 06:12:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4azPS5
        SU5WXSjNIrNts16KhWtnXxukGfZZDKFTFVGUQ=; b=pSPxrV5qzTWjTMbbbk4qb2
        fP8iBK8i8no1Mc6eTS90FbNRqTTkVvNIAldBkefQRgNWUtGQxnW3Nxqqb4VoYl26
        gWM2Ezk6XTWLKnRHQYY6KWvH3INFGpmswylCQTTzi+VZReIwmKzby+fE4DXEHbhW
        h92IVoUGGJ/TE4/i3ZRl1gT0faBJNPdCiAySAygZKXbPVLIaRYsUOkUWFmgZKcgj
        LkZvfm0rC9imCcvUqAubnqTe5UHFTqvscQ9RkyS/XH0D4Hqyq0P/T/ahv+4NqMHa
        /iHUEJySo+8jkfiOfj0U6/IUHVGlyki6kT9U1Cg59e4xNluodP1F9iOxhoTBShSQ
        ==
X-ME-Sender: <xms:IjuhX8ItK7kVIBbN7bRmmN55HMOvaaVuPsrQxi0a0cHyEOH7CxYnrA>
    <xme:IjuhX8LjTFX_LDhUW1uuRz4zvMUAquppeUcDRIUON4SoeMjrsx80G327Fr_THbwSd
    CmFeCfxyl6sgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IjuhX8udlZDtBtSPZ_JtlRCelEAc-4I4ZRYX2MEfVq7fWSp_ebpMSw>
    <xmx:IjuhX5b9f8GWVJ3Ra2SV9Sl8Z249plW9FQ4mF1Yw2oLcRfvle3Si1A>
    <xmx:IjuhXzaB33fM5IWgkIOon3abyDewPfM8sENOE412__A24HlLkvG_mg>
    <xmx:IjuhX0CJ7ps2BXTw7NBirnp1BzN3eUQCnzS6MBx8Kaxz05a90ro3A3Ul1BE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DED2B3280064;
        Tue,  3 Nov 2020 06:12:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf/amd/uncore: Set all slices and threads to restore perf" failed to apply to 4.14-stable tree
To:     kim.phillips@amd.com, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 12:13:20 +0100
Message-ID: <1604402000211185@kroah.com>
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

