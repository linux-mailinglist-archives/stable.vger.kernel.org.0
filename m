Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4AF679E6
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 13:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfGMLML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 07:12:11 -0400
Received: from terminus.zytor.com ([198.137.202.136]:60651 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfGMLMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 07:12:10 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x6DBBZOE3841752
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 13 Jul 2019 04:11:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x6DBBZOE3841752
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1563016296;
        bh=otuByoDP0t/zpW5lFi6qIpRPgYUEBP1U0bXRUDzizkM=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=rYwno2U5rjKLDcVSHuQgpS5FECWsZ7JOHL7uvn3Fj8pXTK2XnC85akDlEL2oXsd7W
         OnGA333lDPcGp21pNDRcQYqqukV1jCAfd93GXPZqtCVu31oeBasNcckcPnaO8XJIz+
         vO4obHUKthvNcTHSErCfEUoGhgxCAfPPLO0pzp/1YnQCL7j28CWO8d0E1c5udQpsqg
         0JyHOJeujBhPMptrtyMP4IiaZmDWhXiWqIHqnnfr1j8Kgrr0f26X+JFfWKaAsnMnvT
         v8H4UX8VVth/zwTCZOWxWAz13EbkTFAEUzHCdn7T0fDNpTQzHjXhByW3hpLWznZNRg
         HcfR4szdN87CA==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x6DBBYFp3841749;
        Sat, 13 Jul 2019 04:11:34 -0700
Date:   Sat, 13 Jul 2019 04:11:34 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Kim Phillips <tipbot@zytor.com>
Message-ID: <tip-2f217d58a8a086d3399fecce39fb358848e799c4@git.kernel.org>
Cc:     hpa@zytor.com, tglx@linutronix.de, kim.phillips@amd.com,
        acme@redhat.com, torvalds@linux-foundation.org, Gary.Hook@amd.com,
        puwen@hygon.cn, alexander.shishkin@linux.intel.com,
        Suravee.Suthikulpanit@amd.com, mingo@kernel.org, mliska@suse.cz,
        bp@alien8.de, namhyung@kernel.org, Janakarajan.Natarajan@amd.com,
        stable@vger.kernel.org, peterz@infradead.org, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, eranian@google.com,
        vincent.weaver@maine.edu
Reply-To: hpa@zytor.com, tglx@linutronix.de, acme@redhat.com,
          kim.phillips@amd.com, torvalds@linux-foundation.org,
          puwen@hygon.cn, alexander.shishkin@linux.intel.com,
          Gary.Hook@amd.com, Suravee.Suthikulpanit@amd.com,
          mingo@kernel.org, mliska@suse.cz, namhyung@kernel.org,
          bp@alien8.de, Janakarajan.Natarajan@amd.com,
          peterz@infradead.org, stable@vger.kernel.org,
          linux-kernel@vger.kernel.org, jolsa@redhat.com,
          eranian@google.com, vincent.weaver@maine.edu
In-Reply-To: <20190628215906.4276-2-kim.phillips@amd.com>
References: <20190628215906.4276-2-kim.phillips@amd.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/amd/uncore: Set the thread mask for F17h
 L3 PMCs
Git-Commit-ID: 2f217d58a8a086d3399fecce39fb358848e799c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  2f217d58a8a086d3399fecce39fb358848e799c4
Gitweb:     https://git.kernel.org/tip/2f217d58a8a086d3399fecce39fb358848e799c4
Author:     Kim Phillips <kim.phillips@amd.com>
AuthorDate: Fri, 28 Jun 2019 21:59:33 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 13 Jul 2019 11:21:27 +0200

perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Fill in the L3 performance event select register ThreadMask
bitfield, to enable per hardware thread accounting.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Gary Hook <Gary.Hook@amd.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Liska <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20190628215906.4276-2-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/events/amd/uncore.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index c2c4ae5fbbfc..a6ea07f2aa84 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -202,15 +202,22 @@ static int amd_uncore_event_init(struct perf_event *event)
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
+	if (event->cpu < 0)
+		return -EINVAL;
+
 	/*
 	 * SliceMask and ThreadMask need to be set for certain L3 events in
 	 * Family 17h. For other events, the two fields do not affect the count.
 	 */
-	if (l3_mask && is_llc_event(event))
-		hwc->config |= (AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK);
+	if (l3_mask && is_llc_event(event)) {
+		int thread = 2 * (cpu_data(event->cpu).cpu_core_id % 4);
 
-	if (event->cpu < 0)
-		return -EINVAL;
+		if (smp_num_siblings > 1)
+			thread += cpu_data(event->cpu).apicid & 1;
+
+		hwc->config |= (1ULL << (AMD64_L3_THREAD_SHIFT + thread) &
+				AMD64_L3_THREAD_MASK) | AMD64_L3_SLICE_MASK;
+	}
 
 	uncore = event_to_amd_uncore(event);
 	if (!uncore)
