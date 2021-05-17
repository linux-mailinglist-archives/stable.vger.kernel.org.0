Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA6382B85
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhEQLzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:55:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60715 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhEQLzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:55:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 23F19968;
        Mon, 17 May 2021 07:54:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 May 2021 07:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3vykRV
        j5MCvBw5jz5VyKl/E8NLdl7C2QWaW3fkAMn7o=; b=hWlpSESGKg46IBGtDXRupJ
        BW1A0+izW9GYDqQTvC7HgBljAJhcxVw4YvYrl+ywDsg6EqZlu76yEBPljlJRXvQm
        GydJkxnPgLIVouD+/YA/ZWQzH98Ds+sw/BsBghxW5+5KWnm6o7TWPdlRKvT/GXvk
        bbzKvuJQ4nUlid5RVaQBHJNdYhNCEfVQO2uaiUQ//1T95qz4DNWMNLl8kWssiyaY
        /Xk7tk6UIshPmv8e4ONYKswUH5eOGbajHPQbxtjkfsW4Lt8WUwPFwFXyLTOKZa8J
        Z/6tdZYHboWFYDt7cdMnglwDonN7iLcGBUM2g5hosuVonDsPVmJRwViIePgP4BYw
        ==
X-ME-Sender: <xms:V1miYG-axvMp2LJA3P1sWAA6fHwx44I_V26sQsGIsnyo9LBO_MpsJg>
    <xme:V1miYGuXmSI1afvrBcLsem27lGTOyNEy6bKhjSp6guer3pYwjBU-Km6Ikm_7WIJss
    4sItQDqz-R5oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:V1miYMDycxHiDfEXJxb5Tij4VA0TH1wgCneRkjg5PtzRwl_g40oVGA>
    <xmx:V1miYOdHWijAUVByBVzHbr9PW2YXicN7pGXmDiZw0bifYNZV8-I3_g>
    <xmx:V1miYLPrQSJYrVfuNtDXDqvX4UX_8QARhAFEwE8kf7jV_59w3mbCYg>
    <xmx:V1miYNWnxMEY_ZV-Uset56cXktxOKU394Jsi8zFRUKaHF1-rE__QcHAxgSE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 07:53:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Prevent deadlock against tk_core.seq" failed to apply to 4.9-stable tree
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 13:53:47 +0200
Message-ID: <162125242724756@kroah.com>
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

