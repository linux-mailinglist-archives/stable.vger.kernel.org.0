Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013AA27CE48
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgI2M6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgI2M6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 08:58:06 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D116AC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 05:58:05 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id b13so2188762qvl.2
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 05:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nzh3zv1JvT51DHKWka/hB8gvItiKQBW3uHlERj+52ug=;
        b=H/4CsnVkWPl+uykpWX4gCTufJyH+2nBpmLN254KoKLVK+w8ADjQh9fRufGB7YR4Zk0
         cT20GwIXPLZN1XiZU5J87vfgOC3Z+WtzWBSksQOWP+ethSc03vnJxvdEpBtkLty463Zi
         buo8B5tYeOnjq77+/YYBiwXmYnn7l4GqZ2CMo/e18rck5IqGCK1bKSYCD51O6ZzSvk/f
         OBAny/hEhlBYH4pgtC3NXXoXMNCYILyCqQg8CAI8BkUUeca7w6xCVDfyC0B4N3cVlIky
         khe6jMn97Kr5wQfNQQVmUmHCsHRg91Wq6DvMisVsJEotUcJnu3YBbQjU5iHowQHzMqMV
         X0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nzh3zv1JvT51DHKWka/hB8gvItiKQBW3uHlERj+52ug=;
        b=gFxtmZZP9zuBbXmA4fvPhy3XFGKGRRnaelTS59vAqbcp2mvi9nzRpeLFwaP8O1u1wC
         f34qXvzwk7pvn4zPDhXnIVKGvJhBIgHGQcJg/hCYDs7Jbe1gRBfNF3o3LZr+d17/+yV8
         hq2wikwJekLQMEa6qLB5m+AMA8kzJvKHFRm1Yd8qnsJKBKB1T4U3nktc0SB1ifoeGNpv
         B2xeCIY0d8JXGef0hrzAmvHlyyN6Xty5HZ1td7ii3qKSHRh9CBk9uDBHqKpswg0zpSiC
         L4Kp1PaulXq/iPGFvodjMGHlNddkJO0/hMlmKdtzpfYV3rmlXVxuBQN3yTF3o3Wly9Lw
         Cj6A==
X-Gm-Message-State: AOAM532ZisRKbMloEclusPa8SDkk2NKmgHk7r8yX/+AP4vIaWWlAVRS4
        zEtin5agGC8EhrZQlwigtuWjl3lMBBfp7BCc
X-Google-Smtp-Source: ABdhPJx6FKVGCobWjuuHLqvOPp3dPQmYxturWif6RW/dMAyStS4Nwx4LhRcFBuyqgTo9tXLnL/6DOg==
X-Received: by 2002:a0c:8e47:: with SMTP id w7mr4291254qvb.18.1601384284993;
        Tue, 29 Sep 2020 05:58:04 -0700 (PDT)
Received: from maple.netwinder.org (rfs.netwinder.org. [206.248.184.2])
        by smtp.gmail.com with ESMTPSA id m97sm5264431qte.55.2020.09.29.05.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:58:03 -0700 (PDT)
From:   Ralph Siemsen <ralph.siemsen@linaro.org>
To:     trivial@kernel.org, mel@csn.ul.ie
Cc:     vinayakm.list@gmail.com, Ralph Siemsen <ralph.siemsen@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH]  Documentation/trace/postprocess/trace-pagealloc-postprocess.pl: fix the traceevent regex
Date:   Tue, 29 Sep 2020 08:57:42 -0400
Message-Id: <20200929125742.14770-1-ralph.siemsen@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to bd7278166aaf8b33da1a3ee437354e2ed88bf70f ("Documentation/
trace/postprocess/trace-vmscan-postprocess.pl: fix the traceevent
regex"), but applied to the trace-pagealoc-postprocess.pl script.

When irq, preempt and lockdep fields are printed (field 3 in the example
below) in the trace output, the script fails.

An example entry:
  kswapd0-610   [000] ...1   158.112152: mm_vmscan_kswapd_wake: nid=0 order=0

Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Cc: stable@vger.kernel.org
Change-Id: I07e0d6f52ae7bf1de5c4054fb2ad0cef85d18513
---
 .../trace/postprocess/trace-pagealloc-postprocess.pl      | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
index 0a120aae33ce..94efc7fb272e 100644
--- a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
@@ -84,7 +84,7 @@ my $regex_fragdetails;
 
 # Static regex used. Specified like this for readability and for use with /o
 #                      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
-my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])(\s*[dX.][Nnp.][Hhs.][0-9a-fA-F.]*|)\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
 my $regex_statname = '[-0-9]*\s\((.*)\).*';
 my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';
 
@@ -195,7 +195,7 @@ EVENT_PROCESS:
 	while ($traceevent = <STDIN>) {
 		if ($traceevent =~ /$regex_traceevent/o) {
 			$process_pid = $1;
-			$tracepoint = $4;
+			$tracepoint = $5;
 
 			if ($opt_read_procstat || $opt_prepend_parent) {
 				$process_pid =~ /(.*)-([0-9]*)$/;
@@ -215,7 +215,7 @@ EVENT_PROCESS:
 
 			# Unnecessary in this script. Uncomment if required
 			# $cpus = $2;
-			# $timestamp = $3;
+			# $timestamp = $4;
 		} else {
 			next;
 		}
@@ -236,7 +236,7 @@ EVENT_PROCESS:
 		} elsif ($tracepoint eq "mm_page_alloc_extfrag") {
 
 			# Extract the details of the event now
-			$details = $5;
+			$details = $6;
 
 			my ($page, $pfn);
 			my ($alloc_order, $fallback_order, $pageblock_order);
-- 
2.17.1

