Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB95382B87
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhEQLzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:55:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50995 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhEQLzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:55:22 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 2D311C53;
        Mon, 17 May 2021 07:54:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 17 May 2021 07:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tvXSyJ
        vgTbmH9V237pfZdPfgp7WHC1w3TPRRDHZUr/U=; b=U1KEtOcwKn3gjXA4mrwW2o
        wVzwTT1XLeWB6vbFNRwl9y3T3TIcpKpObTvgnNOlu7s/I1zwE0TwAkLhJe1rR9fb
        KswZfzc6ewN4HrOZxjwD9HQ3618a8hR0QMBdeHftB44CJesmbuxj9T0QhRHs5+Jk
        Fye9TQr/ArFSkk+GzpyE6jZF1Qbl23pMSBbs9WcTa0gewz5tGMFRGvjvgUHWBT2R
        CMRlERu4VmErYQs49i9JECdhojtgn7aS2sfZZOgS3QvBZ+GXUds3MaN8KEe5Cb62
        8EcJJ4aOit2c3BOzYHA7TdsFH+lnyXZzHU1o+PeNi5aGp3m+rP8LRPYokhsTZmLg
        ==
X-ME-Sender: <xms:XVmiYJugmxQkxtR3Ytav1n0HOGS4NEnM3jZJKK7BVI_a2JfBRFlt8Q>
    <xme:XVmiYCfAaFm5Xw__8W3tqVHljlALYQoOf1wq3YgQaXYu2VqK6SV7THOQLlQH1YevZ
    azqe8iKDO8Gsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XVmiYMwykRvcPZO1Uw4vKuENGjv0r6coUpJTI2M2S--CRV7Rmz-aFQ>
    <xmx:XVmiYANVaTHeN1ux1flO9hiyQjXkuM-BzKCvwMG1J00D8UI7TBuD8g>
    <xmx:XVmiYJ-oQeHYBvd_nz9SPFj0nxZz-bYCYr24qHvjWq5GTvmUugoJ0w>
    <xmx:XVmiYGFdDfBi-Z9QtvZPtQODw_qj3ZS7t_76I8iZkm1ZAQq5mXzZBMRzxXk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 07:54:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Prevent deadlock against tk_core.seq" failed to apply to 4.19-stable tree
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 13:53:48 +0200
Message-ID: <1621252428147114@kroah.com>
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

From 3f804f6d201ca93adf4c3df04d1bfd152c1129d6 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 6 May 2021 15:21:37 +0200
Subject: [PATCH] KVM: x86: Prevent deadlock against tk_core.seq

syzbot reported a possible deadlock in pvclock_gtod_notify():

CPU 0  		  	   	    	    CPU 1
write_seqcount_begin(&tk_core.seq);
  pvclock_gtod_notify()			    spin_lock(&pool->lock);
    queue_work(..., &pvclock_gtod_work)	    ktime_get()
     spin_lock(&pool->lock);		      do {
     						seq = read_seqcount_begin(tk_core.seq)
						...
				              } while (read_seqcount_retry(&tk_core.seq, seq);

While this is unlikely to happen, it's possible.

Delegate queue_work() to irq_work() which postpones it until the
tk_core.seq write held region is left and interrupts are reenabled.

Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
Reported-by: syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Message-Id: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 259139a145cb..5bd550eaf683 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8094,6 +8094,18 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
 
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
 
+/*
+ * Indirection to move queue_work() out of the tk_core.seq write held
+ * region to prevent possible deadlocks against time accessors which
+ * are invoked with work related locks held.
+ */
+static void pvclock_irq_work_fn(struct irq_work *w)
+{
+	queue_work(system_long_wq, &pvclock_gtod_work);
+}
+
+static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
+
 /*
  * Notification about pvclock gtod data update.
  */
@@ -8105,13 +8117,14 @@ static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
 
 	update_pvclock_gtod(tk);
 
-	/* disable master clock if host does not trust, or does not
-	 * use, TSC based clocksource.
+	/*
+	 * Disable master clock if host does not trust, or does not use,
+	 * TSC based clocksource. Delegate queue_work() to irq_work as
+	 * this is invoked with tk_core.seq write held.
 	 */
 	if (!gtod_is_based_on_tsc(gtod->clock.vclock_mode) &&
 	    atomic_read(&kvm_guest_has_master_clock) != 0)
-		queue_work(system_long_wq, &pvclock_gtod_work);
-
+		irq_work_queue(&pvclock_irq_work);
 	return 0;
 }
 
@@ -8224,6 +8237,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	irq_work_sync(&pvclock_irq_work);
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;

