Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC26047E5D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 11:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfFQJ06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 05:26:58 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56845 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726286AbfFQJ05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 05:26:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5D96B78E;
        Mon, 17 Jun 2019 05:26:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Jun 2019 05:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=f/25c7
        3ju6WY5I5hx7DtE2vAR6y8Tbm2E0Sw7fsG6cg=; b=xzDhu2mPUW5IHn2tBQIx6k
        oC87vGdfZI2nzJbhhGCiyozcGX7cD6dk6vdFrQ5cO6wTGkiGzIHOOlIcuF4BvYZJ
        cNr3sv/phv6UdvQ0LdJSoeIfYhF+4imSv1V5SJrLP3JVbPLTggaxglX6ZXqo8B98
        T8ubAvM6qirRrlhyXPXltsaDaW/cXPdCvx/Brpohnjn3u8RC712a0NdEt2Nuu5/h
        11z40qCs1KUQn8IfTkE83QQsh+tRQ/2LFE5CkcZ6IGySxr1OBftU/YNHQhPvviBG
        xPWSLPegd7RPUFPG9HEnpob46sQOn84MT3P7JBZ5ieEM/dMVji6ZyC/uyq7+3q6w
        ==
X-ME-Sender: <xms:3FwHXX9tAPDU8-ODM8EKIro403-aIran0rB_Ht5aENymNNTRToRsgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3FwHXQVc5D5LUE-pjqM0l8VmrLMipjW0cNYMr1KEZuYpde4FU-Q-EQ>
    <xmx:3FwHXQyafgtEQ84sct5sfzG4dUG_EDFruCZ86L82v-U8q_97tUUNtw>
    <xmx:3FwHXXQV_YgWKimfB8OCG2GlLgfcCHiWsarxZNZSZlb4aGdirILOsQ>
    <xmx:3VwHXc238Waw44EY6xszQ0W8r28VWjuyoO1Rv7UIxtj31PL1jxYMwQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6679E380086;
        Mon, 17 Jun 2019 05:26:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RAS/CEC: Convert the timer callback to a workqueue" failed to apply to 4.14-stable tree
To:     xiyou.wangcong@gmail.com, bp@suse.de, linux-edac@vger.kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 11:26:49 +0200
Message-ID: <15607636091776@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0ade0b6240c4853cf9725924c46c10f4251639d7 Mon Sep 17 00:00:00 2001
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 16 Apr 2019 14:33:51 -0700
Subject: [PATCH] RAS/CEC: Convert the timer callback to a workqueue

cec_timer_fn() is a timer callback which reads ce_arr.array[] and
updates its decay values. However, it runs in interrupt context and the
mutex protection the CEC uses for that array, is inadequate. Convert the
used timer to a workqueue to keep the tasks the CEC performs preemptible
and thus low-prio.

 [ bp: Rewrite commit message.
   s/timer/decay/gi to make it agnostic as to what facility is used. ]

Fixes: 011d82611172 ("RAS: Add a Corrected Errors Collector")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190416213351.28999-2-xiyou.wangcong@gmail.com

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index dbfe3e61d2c2..673f8a128397 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/workqueue.h>
 
 #include <asm/mce.h>
 
@@ -123,16 +124,12 @@ static u64 dfs_pfn;
 /* Amount of errors after which we offline */
 static unsigned int count_threshold = COUNT_MASK;
 
-/*
- * The timer "decays" element count each timer_interval which is 24hrs by
- * default.
- */
-
-#define CEC_TIMER_DEFAULT_INTERVAL	24 * 60 * 60	/* 24 hrs */
-#define CEC_TIMER_MIN_INTERVAL		 1 * 60 * 60	/* 1h */
-#define CEC_TIMER_MAX_INTERVAL	   30 *	24 * 60 * 60	/* one month */
-static struct timer_list cec_timer;
-static u64 timer_interval = CEC_TIMER_DEFAULT_INTERVAL;
+/* Each element "decays" each decay_interval which is 24hrs by default. */
+#define CEC_DECAY_DEFAULT_INTERVAL	24 * 60 * 60	/* 24 hrs */
+#define CEC_DECAY_MIN_INTERVAL		 1 * 60 * 60	/* 1h */
+#define CEC_DECAY_MAX_INTERVAL	   30 *	24 * 60 * 60	/* one month */
+static struct delayed_work cec_work;
+static u64 decay_interval = CEC_DECAY_DEFAULT_INTERVAL;
 
 /*
  * Decrement decay value. We're using DECAY_BITS bits to denote decay of an
@@ -160,20 +157,21 @@ static void do_spring_cleaning(struct ce_array *ca)
 /*
  * @interval in seconds
  */
-static void cec_mod_timer(struct timer_list *t, unsigned long interval)
+static void cec_mod_work(unsigned long interval)
 {
 	unsigned long iv;
 
-	iv = interval * HZ + jiffies;
-
-	mod_timer(t, round_jiffies(iv));
+	iv = interval * HZ;
+	mod_delayed_work(system_wq, &cec_work, round_jiffies(iv));
 }
 
-static void cec_timer_fn(struct timer_list *unused)
+static void cec_work_fn(struct work_struct *work)
 {
+	mutex_lock(&ce_mutex);
 	do_spring_cleaning(&ce_arr);
+	mutex_unlock(&ce_mutex);
 
-	cec_mod_timer(&cec_timer, timer_interval);
+	cec_mod_work(decay_interval);
 }
 
 /*
@@ -380,15 +378,15 @@ static int decay_interval_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
 
-	if (val < CEC_TIMER_MIN_INTERVAL)
+	if (val < CEC_DECAY_MIN_INTERVAL)
 		return -EINVAL;
 
-	if (val > CEC_TIMER_MAX_INTERVAL)
+	if (val > CEC_DECAY_MAX_INTERVAL)
 		return -EINVAL;
 
-	timer_interval = val;
+	decay_interval = val;
 
-	cec_mod_timer(&cec_timer, timer_interval);
+	cec_mod_work(decay_interval);
 	return 0;
 }
 DEFINE_DEBUGFS_ATTRIBUTE(decay_interval_ops, u64_get, decay_interval_set, "%lld\n");
@@ -432,7 +430,7 @@ static int array_dump(struct seq_file *m, void *v)
 
 	seq_printf(m, "Flags: 0x%x\n", ca->flags);
 
-	seq_printf(m, "Timer interval: %lld seconds\n", timer_interval);
+	seq_printf(m, "Decay interval: %lld seconds\n", decay_interval);
 	seq_printf(m, "Decays: %lld\n", ca->decays_done);
 
 	seq_printf(m, "Action threshold: %d\n", count_threshold);
@@ -478,7 +476,7 @@ static int __init create_debugfs_nodes(void)
 	}
 
 	decay = debugfs_create_file("decay_interval", S_IRUSR | S_IWUSR, d,
-				    &timer_interval, &decay_interval_ops);
+				    &decay_interval, &decay_interval_ops);
 	if (!decay) {
 		pr_warn("Error creating decay_interval debugfs node!\n");
 		goto err;
@@ -514,8 +512,8 @@ void __init cec_init(void)
 	if (create_debugfs_nodes())
 		return;
 
-	timer_setup(&cec_timer, cec_timer_fn, 0);
-	cec_mod_timer(&cec_timer, CEC_TIMER_DEFAULT_INTERVAL);
+	INIT_DELAYED_WORK(&cec_work, cec_work_fn);
+	schedule_delayed_work(&cec_work, CEC_DECAY_DEFAULT_INTERVAL);
 
 	pr_info("Correctable Errors collector initialized.\n");
 }

