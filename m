Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6414327F53
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhCANV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:21:26 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:52233 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235531AbhCANVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:21:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 694B21941E6F;
        Mon,  1 Mar 2021 08:20:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:20:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TJsbSs
        Z52QHrxsMRxXhlCQMk4UlCEWIfIxsBOxsuZbY=; b=n28IJGzW2imR4aP6h2oN42
        cXX9FOmH3R7XCF/EDoFSmJU/Q9wZVzuVeMPipI9SJkZd+CA6ZbBC/AdA+ZLVczPm
        ifwF3AEdnZ7ZBUdLxqB0J8EgVAfkLfEYqq4xmxUTCv9SSk51dJgg0hkA64D/2Twg
        akM9/7qoth3VWiBvM8zXCBgz4CDOV7AFcB79nA8odoO66YCOmFjHsCERcz7zTHMg
        c9hUiUHt/Gy7fvlSrzEO8us3tjLLJH2CYrt8MfWtvNvSZC9CHzXAJOwsKmu4sJ8+
        QUK7vP/93FMGw7sqgTzUDinCUEui6CGGjbMOAkq5ya+1O10RZDju+MVwKrxsliRA
        ==
X-ME-Sender: <xms:I-o8YP1wv9NPgViln0Y4cCrLbieWIMABStS1mnra0fwGDEX316uwhA>
    <xme:I-o8YOGFOP8aMnWWjmI7mJh6dqu16tb6X7C1qJ7bLLds8kpe92ErLqIbDlVpB_ohl
    KkJOzCzpPQ3Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:I-o8YP5-JfTfGE4i77HryMX2AifwDMr8_WECQG3UeZ8yAAan-ub9YA>
    <xmx:I-o8YE2yGj9o0fycVRPwSZSJZj4BbP1fvYYHOdudQt19S1W7Cj8fHw>
    <xmx:I-o8YCHdzjuYXohnstFEy_7tADidBUfIcXf7Sz3OQ0Zj6u5BGKfG1A>
    <xmx:I-o8YEPapmoGd14bw9BhLFaZr1qzbIqBcdS_Emk0L5uV5bAymee6Mg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E759524005A;
        Mon,  1 Mar 2021 08:20:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] printk: fix deadlock when kernel panic" failed to apply to 4.9-stable tree
To:     songmuchun@bytedance.com, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:20:32 +0100
Message-ID: <1614604832185174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a8109f303e25a27f92c1d8edd67d7cbbc60a4eb Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Wed, 10 Feb 2021 11:48:23 +0800
Subject: [PATCH] printk: fix deadlock when kernel panic

printk_safe_flush_on_panic() caused the following deadlock on our
server:

CPU0:                                         CPU1:
panic                                         rcu_dump_cpu_stacks
  kdump_nmi_shootdown_cpus                      nmi_trigger_cpumask_backtrace
    register_nmi_handler(crash_nmi_callback)      printk_safe_flush
                                                    __printk_safe_flush
                                                      raw_spin_lock_irqsave(&read_lock)
    // send NMI to other processors
    apic_send_IPI_allbutself(NMI_VECTOR)
                                                        // NMI interrupt, dead loop
                                                        crash_nmi_callback
  printk_safe_flush_on_panic
    printk_safe_flush
      __printk_safe_flush
        // deadlock
        raw_spin_lock_irqsave(&read_lock)

DEADLOCK: read_lock is taken on CPU1 and will never get released.

It happens when panic() stops a CPU by NMI while it has been in
the middle of printk_safe_flush().

Handle the lock the same way as logbuf_lock. The printk_safe buffers
are flushed only when both locks can be safely taken. It can avoid
the deadlock _in this particular case_ at expense of losing contents
of printk_safe buffers.

Note: It would actually be safe to re-init the locks when all CPUs were
      stopped by NMI. But it would require passing this information
      from arch-specific code. It is not worth the complexity.
      Especially because logbuf_lock and printk_safe buffers have been
      obsoleted by the lockless ring buffer.

Fixes: cf9b1106c81c ("printk/nmi: flush NMI messages on the system panic")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210210034823.64867-1-songmuchun@bytedance.com

diff --git a/kernel/printk/printk_safe.c b/kernel/printk/printk_safe.c
index a0e6f746de6c..2e9e3ed7d63e 100644
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -45,6 +45,8 @@ struct printk_safe_seq_buf {
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, safe_print_seq);
 static DEFINE_PER_CPU(int, printk_context);
 
+static DEFINE_RAW_SPINLOCK(safe_read_lock);
+
 #ifdef CONFIG_PRINTK_NMI
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, nmi_print_seq);
 #endif
@@ -180,8 +182,6 @@ static void report_message_lost(struct printk_safe_seq_buf *s)
  */
 static void __printk_safe_flush(struct irq_work *work)
 {
-	static raw_spinlock_t read_lock =
-		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct printk_safe_seq_buf *s =
 		container_of(work, struct printk_safe_seq_buf, work);
 	unsigned long flags;
@@ -195,7 +195,7 @@ static void __printk_safe_flush(struct irq_work *work)
 	 * different CPUs. This is especially important when printing
 	 * a backtrace.
 	 */
-	raw_spin_lock_irqsave(&read_lock, flags);
+	raw_spin_lock_irqsave(&safe_read_lock, flags);
 
 	i = 0;
 more:
@@ -232,7 +232,7 @@ static void __printk_safe_flush(struct irq_work *work)
 
 out:
 	report_message_lost(s);
-	raw_spin_unlock_irqrestore(&read_lock, flags);
+	raw_spin_unlock_irqrestore(&safe_read_lock, flags);
 }
 
 /**
@@ -278,6 +278,14 @@ void printk_safe_flush_on_panic(void)
 		raw_spin_lock_init(&logbuf_lock);
 	}
 
+	if (raw_spin_is_locked(&safe_read_lock)) {
+		if (num_online_cpus() > 1)
+			return;
+
+		debug_locks_off();
+		raw_spin_lock_init(&safe_read_lock);
+	}
+
 	printk_safe_flush();
 }
 

