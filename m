Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AEDCF3D7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfJHH32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:29:28 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:60755 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730171AbfJHH32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:29:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E38E55B7;
        Tue,  8 Oct 2019 03:29:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xbhgs2
        VU/81gdaUY6671lefXgzCL+0nzW8fEjm3lvng=; b=ySlDz8gxc2nbQpiixkWuIA
        8VEDpx2WK0yr+YffrL4p2NeZJ1mIEMYcMK/dS5tfi15Vy4Gau5UAN3gDcI7/6oyT
        l4DmLem62F+a/g0c6E4eWLcAioSPl+d6ndw2yK7Xl8IyBCG/ZIBngQ1Z1bM5EgqD
        6GL8/Atn6AYue40IyhqFhG3ZXxn1M6S2XC8+0VE0g58QNTGaKGAMWEFjSMLrPuDJ
        ZRS7R1kRCK2B7icMHP740XUw6Qsb5/XPjdNwFKZKdWrcq37fNu2N8GtjNyh6LjyX
        Y/eP2bySjebdf05ssdjlHzrh+Av4yGaIcRdMDyI6U4zaLadb5YquoYZpkOQutlAA
        ==
X-ME-Sender: <xms:1jqcXWVdsWPy5OpmNN7jK9GYErTBzT-3snMjdBQ0PeAcF4lVxpeJ3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:1jqcXfRfd5LpoQqjYr5tIyHGzHlqjp5i17rWoccdHn7BWfOCoPnX5A>
    <xmx:1jqcXVvLq_9sAYxfMMbyRL03KeYHsh1dLLPIb9xfV2sKJKa5GHSx4w>
    <xmx:1jqcXQU1En_FKe3uAVT2HKn32vTI9hH5vLsXxjyVKPG2FKp0A3_ZPg>
    <xmx:1jqcXUK2fGkNZzwGcAmjJJBFNrPMAvwz5BOn0WL9AiUUS2QVW_lcJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BA0A8005C;
        Tue,  8 Oct 2019 03:29:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/xive: Implement get_irqchip_state method for XIVE to" failed to apply to 4.14-stable tree
To:     paulus@ozlabs.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:29:24 +0200
Message-ID: <157051976420512@kroah.com>
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

From da15c03b047dca891d37b9f4ef9ca14d84a6484f Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@ozlabs.org>
Date: Tue, 13 Aug 2019 20:06:48 +1000
Subject: [PATCH] powerpc/xive: Implement get_irqchip_state method for XIVE to
 fix shutdown race

Testing has revealed the existence of a race condition where a XIVE
interrupt being shut down can be in one of the XIVE interrupt queues
(of which there are up to 8 per CPU, one for each priority) at the
point where free_irq() is called.  If this happens, can return an
interrupt number which has been shut down.  This can lead to various
symptoms:

- irq_to_desc(irq) can be NULL.  In this case, no end-of-interrupt
  function gets called, resulting in the CPU's elevated interrupt
  priority (numerically lowered CPPR) never gets reset.  That then
  means that the CPU stops processing interrupts, causing device
  timeouts and other errors in various device drivers.

- The irq descriptor or related data structures can be in the process
  of being freed as the interrupt code is using them.  This typically
  leads to crashes due to bad pointer dereferences.

This race is basically what commit 62e0468650c3 ("genirq: Add optional
hardware synchronization for shutdown", 2019-06-28) is intended to
fix, given a get_irqchip_state() method for the interrupt controller
being used.  It works by polling the interrupt controller when an
interrupt is being freed until the controller says it is not pending.

With XIVE, the PQ bits of the interrupt source indicate the state of
the interrupt source, and in particular the P bit goes from 0 to 1 at
the point where the hardware writes an entry into the interrupt queue
that this interrupt is directed towards.  Normally, the code will then
process the interrupt and do an end-of-interrupt (EOI) operation which
will reset PQ to 00 (assuming another interrupt hasn't been generated
in the meantime).  However, there are situations where the code resets
P even though a queue entry exists (for example, by setting PQ to 01,
which disables the interrupt source), and also situations where the
code leaves P at 1 after removing the queue entry (for example, this
is done for escalation interrupts so they cannot fire again until
they are explicitly re-enabled).

The code already has a 'saved_p' flag for the interrupt source which
indicates that a queue entry exists, although it isn't maintained
consistently.  This patch adds a 'stale_p' flag to indicate that
P has been left at 1 after processing a queue entry, and adds code
to set and clear saved_p and stale_p as necessary to maintain a
consistent indication of whether a queue entry may or may not exist.

With this, we can implement xive_get_irqchip_state() by looking at
stale_p, saved_p and the ESB PQ bits for the interrupt.

There is some additional code to handle escalation interrupts
properly; because they are enabled and disabled in KVM assembly code,
which does not have access to the xive_irq_data struct for the
escalation interrupt.  Hence, stale_p may be incorrect when the
escalation interrupt is freed in kvmppc_xive_{,native_}cleanup_vcpu().
Fortunately, we can fix it up by looking at vcpu->arch.xive_esc_on,
with some careful attention to barriers in order to ensure the correct
result if xive_esc_irq() races with kvmppc_xive_cleanup_vcpu().

Finally, this adds code to make noise on the console (pr_crit and
WARN_ON(1)) if we find an interrupt queue entry for an interrupt
which does not have a descriptor.  While this won't catch the race
reliably, if it does get triggered it will be an indication that
the race is occurring and needs to be debugged.

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190813100648.GE9567@blackberry

diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
index e4016985764e..efb0e597b272 100644
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -46,7 +46,15 @@ struct xive_irq_data {
 
 	/* Setup/used by frontend */
 	int target;
+	/*
+	 * saved_p means that there is a queue entry for this interrupt
+	 * in some CPU's queue (not including guest vcpu queues), even
+	 * if P is not set in the source ESB.
+	 * stale_p means that there is no queue entry for this interrupt
+	 * in some CPU's queue, even if P is set in the source ESB.
+	 */
 	bool saved_p;
+	bool stale_p;
 };
 #define XIVE_IRQ_FLAG_STORE_EOI	0x01
 #define XIVE_IRQ_FLAG_LSI	0x02
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 586867e46e51..591bfb4bfd0f 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -166,6 +166,9 @@ static irqreturn_t xive_esc_irq(int irq, void *data)
 	 */
 	vcpu->arch.xive_esc_on = false;
 
+	/* This orders xive_esc_on = false vs. subsequent stale_p = true */
+	smp_wmb();	/* goes with smp_mb() in cleanup_single_escalation */
+
 	return IRQ_HANDLED;
 }
 
@@ -1119,6 +1122,31 @@ void kvmppc_xive_disable_vcpu_interrupts(struct kvm_vcpu *vcpu)
 	vcpu->arch.xive_esc_raddr = 0;
 }
 
+/*
+ * In single escalation mode, the escalation interrupt is marked so
+ * that EOI doesn't re-enable it, but just sets the stale_p flag to
+ * indicate that the P bit has already been dealt with.  However, the
+ * assembly code that enters the guest sets PQ to 00 without clearing
+ * stale_p (because it has no easy way to address it).  Hence we have
+ * to adjust stale_p before shutting down the interrupt.
+ */
+void xive_cleanup_single_escalation(struct kvm_vcpu *vcpu,
+				    struct kvmppc_xive_vcpu *xc, int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
+
+	/*
+	 * This slightly odd sequence gives the right result
+	 * (i.e. stale_p set if xive_esc_on is false) even if
+	 * we race with xive_esc_irq() and xive_irq_eoi().
+	 */
+	xd->stale_p = false;
+	smp_mb();		/* paired with smb_wmb in xive_esc_irq */
+	if (!vcpu->arch.xive_esc_on)
+		xd->stale_p = true;
+}
+
 void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
@@ -1143,6 +1171,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Free escalations */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		if (xc->esc_virq[i]) {
+			if (xc->xive->single_escalation)
+				xive_cleanup_single_escalation(vcpu, xc,
+							xc->esc_virq[i]);
 			free_irq(xc->esc_virq[i], vcpu);
 			irq_dispose_mapping(xc->esc_virq[i]);
 			kfree(xc->esc_virq_names[i]);
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 50494d0ee375..955b820ffd6d 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -282,6 +282,8 @@ int kvmppc_xive_select_target(struct kvm *kvm, u32 *server, u8 prio);
 int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
 				  bool single_escalation);
 struct kvmppc_xive *kvmppc_xive_get_device(struct kvm *kvm, u32 type);
+void xive_cleanup_single_escalation(struct kvm_vcpu *vcpu,
+				    struct kvmppc_xive_vcpu *xc, int irq);
 
 #endif /* CONFIG_KVM_XICS */
 #endif /* _KVM_PPC_BOOK3S_XICS_H */
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 11b91b46fc39..f0cab43e6f4b 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -71,6 +71,9 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		/* Free the escalation irq */
 		if (xc->esc_virq[i]) {
+			if (xc->xive->single_escalation)
+				xive_cleanup_single_escalation(vcpu, xc,
+							xc->esc_virq[i]);
 			free_irq(xc->esc_virq[i], vcpu);
 			irq_dispose_mapping(xc->esc_virq[i]);
 			kfree(xc->esc_virq_names[i]);
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 1cdb39575eae..be86fce1a84e 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -135,7 +135,7 @@ static u32 xive_read_eq(struct xive_q *q, bool just_peek)
 static u32 xive_scan_interrupts(struct xive_cpu *xc, bool just_peek)
 {
 	u32 irq = 0;
-	u8 prio;
+	u8 prio = 0;
 
 	/* Find highest pending priority */
 	while (xc->pending_prio != 0) {
@@ -148,8 +148,19 @@ static u32 xive_scan_interrupts(struct xive_cpu *xc, bool just_peek)
 		irq = xive_read_eq(&xc->queue[prio], just_peek);
 
 		/* Found something ? That's it */
-		if (irq)
-			break;
+		if (irq) {
+			if (just_peek || irq_to_desc(irq))
+				break;
+			/*
+			 * We should never get here; if we do then we must
+			 * have failed to synchronize the interrupt properly
+			 * when shutting it down.
+			 */
+			pr_crit("xive: got interrupt %d without descriptor, dropping\n",
+				irq);
+			WARN_ON(1);
+			continue;
+		}
 
 		/* Clear pending bits */
 		xc->pending_prio &= ~(1 << prio);
@@ -307,6 +318,7 @@ static void xive_do_queue_eoi(struct xive_cpu *xc)
  */
 static void xive_do_source_eoi(u32 hw_irq, struct xive_irq_data *xd)
 {
+	xd->stale_p = false;
 	/* If the XIVE supports the new "store EOI facility, use it */
 	if (xd->flags & XIVE_IRQ_FLAG_STORE_EOI)
 		xive_esb_write(xd, XIVE_ESB_STORE_EOI, 0);
@@ -350,7 +362,7 @@ static void xive_do_source_eoi(u32 hw_irq, struct xive_irq_data *xd)
 	}
 }
 
-/* irq_chip eoi callback */
+/* irq_chip eoi callback, called with irq descriptor lock held */
 static void xive_irq_eoi(struct irq_data *d)
 {
 	struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
@@ -366,6 +378,8 @@ static void xive_irq_eoi(struct irq_data *d)
 	if (!irqd_irq_disabled(d) && !irqd_is_forwarded_to_vcpu(d) &&
 	    !(xd->flags & XIVE_IRQ_NO_EOI))
 		xive_do_source_eoi(irqd_to_hwirq(d), xd);
+	else
+		xd->stale_p = true;
 
 	/*
 	 * Clear saved_p to indicate that it's no longer occupying
@@ -397,11 +411,16 @@ static void xive_do_source_set_mask(struct xive_irq_data *xd,
 	 */
 	if (mask) {
 		val = xive_esb_read(xd, XIVE_ESB_SET_PQ_01);
-		xd->saved_p = !!(val & XIVE_ESB_VAL_P);
-	} else if (xd->saved_p)
+		if (!xd->stale_p && !!(val & XIVE_ESB_VAL_P))
+			xd->saved_p = true;
+		xd->stale_p = false;
+	} else if (xd->saved_p) {
 		xive_esb_read(xd, XIVE_ESB_SET_PQ_10);
-	else
+		xd->saved_p = false;
+	} else {
 		xive_esb_read(xd, XIVE_ESB_SET_PQ_00);
+		xd->stale_p = false;
+	}
 }
 
 /*
@@ -541,6 +560,8 @@ static unsigned int xive_irq_startup(struct irq_data *d)
 	unsigned int hw_irq = (unsigned int)irqd_to_hwirq(d);
 	int target, rc;
 
+	xd->saved_p = false;
+	xd->stale_p = false;
 	pr_devel("xive_irq_startup: irq %d [0x%x] data @%p\n",
 		 d->irq, hw_irq, d);
 
@@ -587,6 +608,7 @@ static unsigned int xive_irq_startup(struct irq_data *d)
 	return 0;
 }
 
+/* called with irq descriptor lock held */
 static void xive_irq_shutdown(struct irq_data *d)
 {
 	struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
@@ -601,16 +623,6 @@ static void xive_irq_shutdown(struct irq_data *d)
 	/* Mask the interrupt at the source */
 	xive_do_source_set_mask(xd, true);
 
-	/*
-	 * The above may have set saved_p. We clear it otherwise it
-	 * will prevent re-enabling later on. It is ok to forget the
-	 * fact that the interrupt might be in a queue because we are
-	 * accounting that already in xive_dec_target_count() and will
-	 * be re-routing it to a new queue with proper accounting when
-	 * it's started up again
-	 */
-	xd->saved_p = false;
-
 	/*
 	 * Mask the interrupt in HW in the IVT/EAS and set the number
 	 * to be the "bad" IRQ number
@@ -797,6 +809,10 @@ static int xive_irq_retrigger(struct irq_data *d)
 	return 1;
 }
 
+/*
+ * Caller holds the irq descriptor lock, so this won't be called
+ * concurrently with xive_get_irqchip_state on the same interrupt.
+ */
 static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 {
 	struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
@@ -820,6 +836,10 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 
 		/* Set it to PQ=10 state to prevent further sends */
 		pq = xive_esb_read(xd, XIVE_ESB_SET_PQ_10);
+		if (!xd->stale_p) {
+			xd->saved_p = !!(pq & XIVE_ESB_VAL_P);
+			xd->stale_p = !xd->saved_p;
+		}
 
 		/* No target ? nothing to do */
 		if (xd->target == XIVE_INVALID_TARGET) {
@@ -827,7 +847,7 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 			 * An untargetted interrupt should have been
 			 * also masked at the source
 			 */
-			WARN_ON(pq & 2);
+			WARN_ON(xd->saved_p);
 
 			return 0;
 		}
@@ -847,9 +867,8 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 		 * This saved_p is cleared by the host EOI, when we know
 		 * for sure the queue slot is no longer in use.
 		 */
-		if (pq & 2) {
-			pq = xive_esb_read(xd, XIVE_ESB_SET_PQ_11);
-			xd->saved_p = true;
+		if (xd->saved_p) {
+			xive_esb_read(xd, XIVE_ESB_SET_PQ_11);
 
 			/*
 			 * Sync the XIVE source HW to ensure the interrupt
@@ -862,8 +881,7 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 			 */
 			if (xive_ops->sync_source)
 				xive_ops->sync_source(hw_irq);
-		} else
-			xd->saved_p = false;
+		}
 	} else {
 		irqd_clr_forwarded_to_vcpu(d);
 
@@ -914,6 +932,23 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 	return 0;
 }
 
+/* Called with irq descriptor lock held. */
+static int xive_get_irqchip_state(struct irq_data *data,
+				  enum irqchip_irq_state which, bool *state)
+{
+	struct xive_irq_data *xd = irq_data_get_irq_handler_data(data);
+
+	switch (which) {
+	case IRQCHIP_STATE_ACTIVE:
+		*state = !xd->stale_p &&
+			 (xd->saved_p ||
+			  !!(xive_esb_read(xd, XIVE_ESB_GET) & XIVE_ESB_VAL_P));
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct irq_chip xive_irq_chip = {
 	.name = "XIVE-IRQ",
 	.irq_startup = xive_irq_startup,
@@ -925,6 +960,7 @@ static struct irq_chip xive_irq_chip = {
 	.irq_set_type = xive_irq_set_type,
 	.irq_retrigger = xive_irq_retrigger,
 	.irq_set_vcpu_affinity = xive_irq_set_vcpu_affinity,
+	.irq_get_irqchip_state = xive_get_irqchip_state,
 };
 
 bool is_xive_irq(struct irq_chip *chip)
@@ -1337,6 +1373,11 @@ static void xive_flush_cpu_queue(unsigned int cpu, struct xive_cpu *xc)
 		raw_spin_lock(&desc->lock);
 		xd = irq_desc_get_handler_data(desc);
 
+		/*
+		 * Clear saved_p to indicate that it's no longer pending
+		 */
+		xd->saved_p = false;
+
 		/*
 		 * For LSIs, we EOI, this will cause a resend if it's
 		 * still asserted. Otherwise do an MSI retrigger.

