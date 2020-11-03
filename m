Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0562A4A04
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCPiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:38:54 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56167 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbgKCPiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:38:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B6FDC1942D6A;
        Tue,  3 Nov 2020 10:38:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:38:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PGeGuO
        JckqU9ZtUr4UYtRYo4F4kgm1m4erhtVzfjAh8=; b=Er8TvjbTtnJqt5QpuzQrLD
        ZEmwDVy0TpoE2QhIxrXVDKyA9WpokEKWRwkC4W2sOFgHxioQvsNXtXJmSr/ewllf
        M6MTapEWDlKRwG/+lY8NyojyIojCbPYDqz/OmN+Mh7UqQRG2fP+6EsF7zxR+iTZn
        heF63mio34dmZsHuMXb1wdRvg8PyiNbghASHdv6BfauOvKa0GUMIVfeYNumLSfT7
        HHmGYeGGnA5abqwwW7b0S2E1nLdZco3tB4OR/Q8fzcxIzuhLJQD8aApjAqqC0k8x
        S9O4Fv+qvymOwb3ov1GgH3/ReGLmBbj6NUe1QDroKTBAtp2kCEoWjREkkD0POUEg
        ==
X-ME-Sender: <xms:iXmhX1iAt-Rq9QV3ysS4kpGoFHJe7Y8rDcHL9c5v6ahns5cudlDYyw>
    <xme:iXmhX6DRhijCp4s_uCAArdKy9sTcnlCdLL_ksGL50lJ_pFkcNurqJawycdXcIzHR5
    CJnYzsj_nm-RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iXmhX1FZnVg3t8CmP0TeiKwCeUd9ASfWTEbBFXg3ZkGyQ2u6jwAk4w>
    <xmx:iXmhX6Q5zfLmT6RqJOZdWU6I60IMmBtF7iEYcuv9wG4qvKaMNhhY_Q>
    <xmx:iXmhXyynnlq8Tq46COSY908tG3rb0JOV7YA7UigbUkaQDG3RlcWSmg>
    <xmx:jHmhX3HR5xSn3LqRore0Ee-ae7ywuJmaHWYhirRNVT8xkp-CkV57qldj4Pk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D32853064674;
        Tue,  3 Nov 2020 10:38:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf vendor events amd: Add L2 Prefetch events for zen1" failed to apply to 5.4-stable tree
To:     kim.phillips@amd.com, acme@redhat.com, ak@linux.intel.com,
        alexander.shishkin@linux.intel.com, bp@suse.de, eranian@google.com,
        irogers@google.com, john.garry@huawei.com, jolsa@redhat.com,
        jon.grimm@amd.com, kan.liang@linux.intel.com, mark.rutland@arm.com,
        mjambor@suse.cz, mliska@suse.cz, mpetlan@redhat.com,
        namhyung@kernel.org, peterz@infradead.org, vijaythakkar@me.com,
        wcohen@redhat.com, yao.jin@linux.intel.com, yeyunfeng@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:39:42 +0100
Message-ID: <1604417982189233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60d804521ec4cd01217a96f33cd1bb29e295333d Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Tue, 1 Sep 2020 17:09:41 -0500
Subject: [PATCH] perf vendor events amd: Add L2 Prefetch events for zen1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Later revisions of PPRs that post-date the original Family 17h events
submission patch add these events.

Specifically, they were not in this 2017 revision of the F17h PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors Rev 1.14 - April 15, 2017

But e.g., are included in this 2019 version of the PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 18h, Revision B1 Processors Rev. 3.14 - Sep 26, 2019

Fixes: 98c07a8f74f8 ("perf vendor events amd: perf PMU events for AMD Family 17h")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Jon Grimm <jon.grimm@amd.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin Jambor <mjambor@suse.cz>
Cc: Martin Liška <mliska@suse.cz>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
Cc: Vijay Thakkar <vijaythakkar@me.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Yunfeng Ye <yeyunfeng@huawei.com>
Link: http://lore.kernel.org/lkml/20200901220944.277505-1-kim.phillips@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
index 404d4c569c01..695ed3ffa3a6 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
@@ -249,6 +249,24 @@
     "BriefDescription": "Cycles with fill pending from L2. Total cycles spent with one or more fill requests in flight from L2.",
     "UMask": "0x1"
   },
+  {
+    "EventName": "l2_pf_hit_l2",
+    "EventCode": "0x70",
+    "BriefDescription": "L2 prefetch hit in L2.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_hit_l3",
+    "EventCode": "0x71",
+    "BriefDescription": "L2 prefetcher hits in L3. Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_l3",
+    "EventCode": "0x72",
+    "BriefDescription": "L2 prefetcher misses in L3. All L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches.",
+    "UMask": "0xff"
+  },
   {
     "EventName": "l3_request_g1.caching_l3_cache_accesses",
     "EventCode": "0x01",

