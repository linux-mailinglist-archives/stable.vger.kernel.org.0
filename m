Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65FF382B83
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhEQLzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:55:13 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46279 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhEQLzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:55:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 383CBC36;
        Mon, 17 May 2021 07:53:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 May 2021 07:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PBCq6Y
        tDitz8U9q1NfLSS5C0JkT2R/SkoBUwghA5vsU=; b=rK6z9w5OEaHnyYuR1szgCF
        EH5/M14PuXye63dQorpUjVZxVH8XQtJjTst/UmblYWSJeAqEANKWfe+Wy0CQbYWo
        bIuIoT2690oVywkM38X++bBqElu0ycMEbk9FvQtfUu4IHW0KqLJoDMG17UvFfZtc
        7Dg86zadmHolKmRv89vWW8T7PkgYqqHCQT7Um+y3AT/K4p3+pcVo3DMR13uzpVk0
        tPtAJhg+Hk4L28crgkvTxJAUidzYu97KQtplHcN6qsX0umWWFUoefdJUiXIlLGVF
        YqScriCTZJBYcE05JBscQoW8jyzURi+ESf4LpWMh0eGwDPR4DTPxnmc2EXUNODWg
        ==
X-ME-Sender: <xms:TFmiYI12v7bjC_rXMkVI8gh7b73ZRWyUFASFmU5VQoNC-YJOI1Nn3A>
    <xme:TFmiYDFE-qvpI2lrfnz7LaljEHSg0GEyLQR2oi5wsB6mBghQd1OlFarJe_k2l-pbn
    KpJ0ssPA0nUBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:TFmiYA5nX2X6cR8Xuw6s6z9A_4FWU774Byxbplg8pZNp3kGxiEI6rw>
    <xmx:TFmiYB3hAEpe9y3-7OJxZdy-BDD0as0n5gg9Lp9v5u2Hf2PZunsrRA>
    <xmx:TFmiYLGrnzV-644JfLrqJCgkOZMEBS0illW5Wrs-aCES2ydbnRNoEg>
    <xmx:TFmiYOMXoRHupllWgHKEnxysiB9Mbg_ns-5dNTzoLNvdjeC1jnmTCp5DA80>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 07:53:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Prevent deadlock against tk_core.seq" failed to apply to 4.4-stable tree
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 13:53:46 +0200
Message-ID: <16212524269090@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

