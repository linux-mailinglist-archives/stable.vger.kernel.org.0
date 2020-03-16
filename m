Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD72F186B9D
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbgCPM7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:59:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51127 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730896AbgCPM7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 08:59:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B26FD5C0324;
        Mon, 16 Mar 2020 08:59:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 08:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=c/wEjs
        7ASVkSxO8sbhYQzUdlJIK0wpDHIy1iN+Y7oLk=; b=g0L5IZCek+LlnA69dW9yI/
        nOmIKbU8UWWEMNgtNrqGF6XDwJpLK6gWkaz/xU2ShIOqeiNgOac3KCD4o5lrt8iN
        MbcyZDyDMYUKSeU2GKFqAE3/xUAVTfcRkK3vK0XrKXlA0pW3XKQxqV+XXzZuCTOs
        Ym2k1amUGkNLWCPyElE5LSrZWlGSnB+kf6PHtPal3Dv5/iLxgml79b2km725lYZ3
        2Z3rbl1FaM/hqo8c1ZLm1hGtUh7ni72brBj0Kf0qiykmZ6cecQ0CxHR0BaAsb+fR
        s1IP02EW/LSyPCpGz25+J1/VEzZbY/v9Jtk6X6WwxZ23jFMfDngWjzl7Uag9jfNQ
        ==
X-ME-Sender: <xms:RnhvXgV7IqB-iKAfLllNA5OKoK0CgXw6xTrh8tOtBoA7wybsmSwfow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RnhvXv_8K2Hd9VrSBcL-EYKRsb2letsm9TcX4pUPuja8Wq2Z4RbhQw>
    <xmx:RnhvXg-kouzkMVU44CpzMoevDu4KmVx2aO1b_4DK5ZxIW-SyXVjeuA>
    <xmx:RnhvXj9U985Bq5I0Ia9KWIK6sTPQBCBehLr42_FFUszLZsGlhe-ldw>
    <xmx:R3hvXsi2EtvwGFlFrltRmFDdS0TVPLAM5d_5s9V_3RjEokCUZr_xNQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96237328005E;
        Mon, 16 Mar 2020 08:59:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/amd/uncore: Replace manual sampling check with" failed to apply to 4.19-stable tree
To:     kim.phillips@amd.com, bp@suse.de, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 13:59:49 +0100
Message-ID: <158436358921825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From f967140dfb7442e2db0868b03b961f9c59418a1b Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Wed, 11 Mar 2020 14:13:21 -0500
Subject: [PATCH] perf/amd/uncore: Replace manual sampling check with
 CAP_NO_INTERRUPT flag

Enable the sampling check in kernel/events/core.c::perf_event_open(),
which returns the more appropriate -EOPNOTSUPP.

BEFORE:

  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (l3_request_g1.caching_l3_cache_accesses).
  /bin/dmesg | grep -i perf may provide additional information.

With nothing relevant in dmesg.

AFTER:

  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
  Error:
  l3_request_g1.caching_l3_cache_accesses: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200311191323.13124-1-kim.phillips@amd.com

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index a6ea07f2aa84..4d867a752f0e 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -190,15 +190,12 @@ static int amd_uncore_event_init(struct perf_event *event)
 
 	/*
 	 * NB and Last level cache counters (MSRs) are shared across all cores
-	 * that share the same NB / Last level cache. Interrupts can be directed
-	 * to a single target core, however, event counts generated by processes
-	 * running on other cores cannot be masked out. So we do not support
-	 * sampling and per-thread events.
+	 * that share the same NB / Last level cache.  On family 16h and below,
+	 * Interrupts can be directed to a single target core, however, event
+	 * counts generated by processes running on other cores cannot be masked
+	 * out. So we do not support sampling and per-thread events via
+	 * CAP_NO_INTERRUPT, and we do not enable counter overflow interrupts:
 	 */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	/* and we do not enable counter overflow interrupts */
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
@@ -306,7 +303,7 @@ static struct pmu amd_nb_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct pmu amd_llc_pmu = {
@@ -317,7 +314,7 @@ static struct pmu amd_llc_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)

