Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7ABCF394
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfJHHUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:20:19 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43205 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730144AbfJHHUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:20:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4E6FF5B9;
        Tue,  8 Oct 2019 03:20:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VAzlMj
        Dad6y6Qdx2IctU+RuAPoTuZ5A7qNe2/FVwqpU=; b=ZtxFu1roYai2oCam/M5Sr0
        uyC6VwslcZV1vhS2yueRaXmnxL8I7DSCJ4AJO6H/GNpb/OKaXuGh8dA6q//YQO4l
        zn2qcTFoJbD08h2fH/fTsbgkDvp+bDdkOkrdKGR08KUOVezHNLjYpVnuKEsZGRXi
        9l1NQOnoUS01UkU7/Owgg4P8sptrmvg9d9JcRLGq0qaF2sqq4M8/BpGNuxZBpM5s
        0+hev6FrzSZKxaDWnq59CQ6V6s43HBKRMz1S/VxLLvM8xFoDBncHKRWhtSlIi/Zw
        wO7gdvplOL3uF4XvDEx0o9mvSeyaegf5NweGXH4uPtrxUj1T69AW3v6NRS/igvSw
        ==
X-ME-Sender: <xms:sTicXdIGr5ybbMH2Coi2ukzZGtLc2vgtQALhuOJapFV2ImY4_WA4Jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:sTicXTh7r_o50Be-4-sDOEElHUhU91TEwS4JCYeuBQCKD_QAIXJnIQ>
    <xmx:sTicXRRI5Sh4fl2ts2_X1pKWRBnxyzZFd9gtbjHsyWa7ARjUHXpPGg>
    <xmx:sTicXYZjcYAaS8eOkfcdzwaOcolG4MKnsyO2EBu-9e7uclm4L6H8JQ>
    <xmx:sTicXZMkQVECccqhehwE1lAZ2VitL5-iuPdjUk982HKQX2cit_QyzA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94A2CD6005B;
        Tue,  8 Oct 2019 03:20:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before" failed to apply to 4.19-stable tree
To:     clg@kaod.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:20:08 +0200
Message-ID: <1570519208179101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 237aed48c642328ff0ab19b63423634340224a06 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Date: Tue, 6 Aug 2019 19:25:38 +0200
Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before
 disabling the VP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a vCPU is brought done, the XIVE VP (Virtual Processor) is first
disabled and then the event notification queues are freed. When freeing
the queues, we check for possible escalation interrupts and free them
also.

But when a XIVE VP is disabled, the underlying XIVE ENDs also are
disabled in OPAL. When an END (Event Notification Descriptor) is
disabled, its ESB pages (ESn and ESe) are disabled and loads return all
1s. Which means that any access on the ESB page of the escalation
interrupt will return invalid values.

When an interrupt is freed, the shutdown handler computes a 'saved_p'
field from the value returned by a load in xive_do_source_set_mask().
This value is incorrect for escalation interrupts for the reason
described above.

This has no impact on Linux/KVM today because we don't make use of it
but we will introduce in future changes a xive_get_irqchip_state()
handler. This handler will use the 'saved_p' field to return the state
of an interrupt and 'saved_p' being incorrect, softlockup will occur.

Fix the vCPU cleanup sequence by first freeing the escalation interrupts
if any, then disable the XIVE VP and last free the queues.

Fixes: 90c73795afa2 ("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode")
Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190806172538.5087-1-clg@kaod.org

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index e3ba67095895..09f838aa3138 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1134,20 +1134,22 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Mask the VP IPI */
 	xive_vm_esb_load(&xc->vp_ipi_data, XIVE_ESB_SET_PQ_01);
 
-	/* Disable the VP */
-	xive_native_disable_vp(xc->vp_id);
-
-	/* Free the queues & associated interrupts */
+	/* Free escalations */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
-		struct xive_q *q = &xc->queues[i];
-
-		/* Free the escalation irq */
 		if (xc->esc_virq[i]) {
 			free_irq(xc->esc_virq[i], vcpu);
 			irq_dispose_mapping(xc->esc_virq[i]);
 			kfree(xc->esc_virq_names[i]);
 		}
-		/* Free the queue */
+	}
+
+	/* Disable the VP */
+	xive_native_disable_vp(xc->vp_id);
+
+	/* Free the queues */
+	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
+		struct xive_q *q = &xc->queues[i];
+
 		xive_native_disable_queue(xc->vp_id, q, i);
 		if (q->qpage) {
 			free_pages((unsigned long)q->qpage,
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index a998823f68a3..368427fcad20 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -67,10 +67,7 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	xc->valid = false;
 	kvmppc_xive_disable_vcpu_interrupts(vcpu);
 
-	/* Disable the VP */
-	xive_native_disable_vp(xc->vp_id);
-
-	/* Free the queues & associated interrupts */
+	/* Free escalations */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		/* Free the escalation irq */
 		if (xc->esc_virq[i]) {
@@ -79,8 +76,13 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 			kfree(xc->esc_virq_names[i]);
 			xc->esc_virq[i] = 0;
 		}
+	}
 
-		/* Free the queue */
+	/* Disable the VP */
+	xive_native_disable_vp(xc->vp_id);
+
+	/* Free the queues */
+	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		kvmppc_xive_native_cleanup_queue(vcpu, i);
 	}
 

