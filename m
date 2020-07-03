Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD962134E0
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGCHYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 03:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgGCHYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 03:24:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A57C08C5DD
        for <stable@vger.kernel.org>; Fri,  3 Jul 2020 00:24:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so4345774pfn.12
        for <stable@vger.kernel.org>; Fri, 03 Jul 2020 00:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1awR1oXatwAPM3CxqAnDzajgAUbbG1G7hC8t8yoUY2c=;
        b=Mv9YdDouGyZG1BWTZV0nE63MJW8hW4IGvJDGE3bdMhdV/lzeXk7yELZAp5qGzaVDGn
         NuZnGJtzD5Flz9oV2rKDVxlKBJszaGFz41w39ITwTdb273AKpj1Z2rfnnNyM0Lj+qTvE
         A/oFxv6DVtea2p8eBjVHAyZO3gtI52jmAjRIliYzGXOUzWxQ+Cf6q1ya4yyHqJt0BC1H
         suDP0/7G+nAfekDSMm9lo2zzTXvsOgyWvR2W4Iyi1bw4woGwVlkUjD3l3+2MJUbIW3oh
         pJCBa2Jsx4g9ejD6GPtzmq1dJPwe+uyloJdPHz411gu0OFPYIPAcd1Zt9UV/LlW68JAN
         2s7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1awR1oXatwAPM3CxqAnDzajgAUbbG1G7hC8t8yoUY2c=;
        b=W9L1PY8Gpk46eIibxEMArHhjIu319gKqXhoIyiFG6cADGhdL5RxN/WSTUfeRrTEuDb
         DuDmKVyno3zuBd7wIPR7R6Ae33QXZNTxBFPhxK00YkRo9A7Sm4hT2JoRaMfR56HPbRa8
         mftKA+U45W9FbdtaqXlK3QbWr/dhNxEsPJ5BPsrzAVDwo59rsaaVk9JqpMeTR4tRstuX
         PVOFH7DgxVQ0f/KdyfllT0DlMSLTDyFy/mHu3HFIgyU7awF5enjiowu5WrvWxl52zkiq
         uRxh5YpKxzR4CPn6mXdjOZkBfn9YGvkddsx1qkGTqkLtbpHUzOU61/89rCwdmRy34+7i
         fdgw==
X-Gm-Message-State: AOAM532yaTRfOATFUYmduQ3MbvTCVaVuRSd4pxMzZ+Mv9pTTtBCrTdbQ
        /h+YbOvqe1R/y4BVdfZy5jA7wtpG4dk=
X-Google-Smtp-Source: ABdhPJwG26bdUSi0e1xDu2+9B7dUb5ve1+tns0gC1h3cIDe7TAGqK8L839gPpddHGM8v9METs1j4RQ==
X-Received: by 2002:a65:4209:: with SMTP id c9mr27936332pgq.445.1593761048684;
        Fri, 03 Jul 2020 00:24:08 -0700 (PDT)
Received: from localhost ([122.172.40.201])
        by smtp.gmail.com with ESMTPSA id nh14sm3877075pjb.4.2020.07.03.00.24.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:24:08 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [FOR-STABLE-3.9+] sched/rt: Show the 'sched_rr_timeslice' SCHED_RR timeslice tuning knob in milliseconds
Date:   Fri,  3 Jul 2020 12:54:04 +0530
Message-Id: <ffdfb849a11b9cd66e0aded2161869e36aec7fc0.1593757471.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shile Zhang <shile.zhang@nokia.com>

We added the 'sched_rr_timeslice_ms' SCHED_RR tuning knob in this commit:

  ce0dbbbb30ae ("sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice")

... which name suggests to users that it's in milliseconds, while in reality
it's being set in milliseconds but the result is shown in jiffies.

This is obviously confusing when HZ is not 1000, it makes it appear like the
value set failed, such as HZ=100:

  root# echo 100 > /proc/sys/kernel/sched_rr_timeslice_ms
  root# cat /proc/sys/kernel/sched_rr_timeslice_ms
  10

Fix this to be milliseconds all around.

Cc: <stable@vger.kernel.org> # v3.9+
Signed-off-by: Shile Zhang <shile.zhang@nokia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1485612049-20923-1-git-send-email-shile.zhang@nokia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/sched/sysctl.h | 1 +
 kernel/sched/core.c          | 5 +++--
 kernel/sched/rt.c            | 1 +
 kernel/sysctl.c              | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 596a0e007c62..7cae31be37cf 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -93,6 +93,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern unsigned int sysctl_sched_autogroup_enabled;
 #endif
 
+extern int sysctl_sched_rr_timeslice;
 extern int sched_rr_timeslice;
 
 extern int sched_rr_handler(struct ctl_table *table, int write,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 45dd606138b0..df6daf7301ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7804,8 +7804,9 @@ int sched_rr_handler(struct ctl_table *table, int write,
 	/* make sure that internally we keep jiffies */
 	/* also, writing zero resets timeslice to default */
 	if (!ret && write) {
-		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
-			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+		sched_rr_timeslice =
+			sysctl_sched_rr_timeslice <= 0 ? RR_TIMESLICE :
+			msecs_to_jiffies(sysctl_sched_rr_timeslice);
 	}
 	mutex_unlock(&mutex);
 	return ret;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e0e5b3314c5b..5523766af665 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 
 int sched_rr_timeslice = RR_TIMESLICE;
+int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5da3c8a67e8..db51f7b0e7a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -421,7 +421,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "sched_rr_timeslice_ms",
-		.data		= &sched_rr_timeslice,
+		.data		= &sysctl_sched_rr_timeslice,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
-- 
2.25.0.rc1.19.g042ed3e048af

