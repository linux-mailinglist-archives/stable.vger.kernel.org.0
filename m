Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA61382B86
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhEQLzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:55:20 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41731 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhEQLzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:55:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B1429968;
        Mon, 17 May 2021 07:54:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 07:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/XMM1m
        PiCbC82tiin+BXuoR2FUsBn6L4L75UczWULG8=; b=QLDF9S3wmUMvDIG08rkP4I
        1kLlcipBvWNydx8X9jJttNioPOYR8Wtv915VA21sq8J2BSPols3cdTeGdHqMpmHI
        N9ZEbFUw+MOZ24e5eN3ayhzYY8zJz4fHwDaxlxwtwuq00iSvxtJriNXlQCrtsorf
        o5Qy7jxupO8XYGEF3T5ZYUmlIobkuLuAHRoxEf6rbveGt+wJu3poSiTNe2Ems0L3
        8RFpakzacTZA0BTTlXlRYkL/WltXi3r0VTIHQvOCmsYlYCdNlCwEvQN1JwUCzSOc
        v7VJjHQaKqHAAsoqT6+lveC8pvMI7TxhiOuQSVU5TGzY9obDLaHaXTSvJIjE2/Qg
        ==
X-ME-Sender: <xms:WlmiYMpl2ZDnTD0FxDzqA366tORCsdespMNHLEkIeGlY6jq0AaHufA>
    <xme:WlmiYCrvMUj3NsP2tUbEEY48DXla1MLMX10c5FFa3DKxHsFmoOZ2-d677DzKHxPxK
    WiRYTVfe5hzmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:WlmiYBPpOng7yOhJ-O74M3XzEleeI8oyRMrOu372D-RAg-W4qORW6w>
    <xmx:WlmiYD6747qW_-DIPYpFPvEidmL7yR76UDnFnRuweCeBxmn2Vt7THA>
    <xmx:WlmiYL4xnMp_kOz45_NlPkthpXhPVt0RCyiQHJl2oKnwQa74BuIEfg>
    <xmx:WlmiYIj1ZrskCldjMqOrHIVuL0IrJo-sIeSzgAfrxfl56K9mg6d7fYjZtNA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 07:54:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Prevent deadlock against tk_core.seq" failed to apply to 5.4-stable tree
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 13:53:48 +0200
Message-ID: <1621252428140194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

