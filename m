Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D8FCF39A
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfJHHUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:20:48 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:39901 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730144AbfJHHUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:20:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B110F5D8;
        Tue,  8 Oct 2019 03:20:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Mi9nJV
        HLGg2/PA1iUxuAmaxWUkEXY46Gdy5nw3C+Rw8=; b=Jfs0N7s7k1qy+haLzDqiPa
        Nyn415DKypCPJGORDb5jZhabm3GHiGvsHPHKFlwwLkTZ3Jdd4Kutp8bO52mnbrw+
        HVbgj/6WM1cUT558O6O/bj6pYB5xP4lhzYy0BQ/J135aNlr96L9H9owe+f2IRBZY
        WBqckqhsJ60wCBEG4V42YwOV4Bc+tgrahoptDMTgV3dbpfO9veyWxJ67gdEJDxul
        4H7pRqQciMsN0rZ/7xDl2HPWhZ/MBw+grDWlYz0/m1+ShsaBi4XYoW9+1Lz+MYJL
        j1fFDMgHBLa+txGQ6PYP3/+wu+tFPeZUZrutouxBJMFZhG8vr3wAHZzjwBwHA5eQ
        ==
X-ME-Sender: <xms:zjicXQ8WPKITAzQZRtLP9TKyWDTOrQgMtktkLTNbQpR8vWeL7xyTwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehrmhhhrghnughlvghrshdrshgspdhkvghrnhgvlhdrohhrgh
    enucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:zjicXf0PWtojK2oFRBuMtHs9Wg9nBqGBtCrxJxdH8f5XK_oLbjCi5A>
    <xmx:zjicXYaZzPVxucbDM_aCt0FbjanXkyCZBzPqfpWo3amu0Dg-jupzpA>
    <xmx:zjicXaKs8_KoJiL1qlElowy_iWp32f7BgiBEKRGpn7KGlwcKl14-uQ>
    <xmx:zjicXQFo8gZNEWSi80HrTycoiMrQ1Or7aeemgYMfWwvrvajf1DOWNw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE95D8005A;
        Tue,  8 Oct 2019 03:20:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Don't push XIVE context when not using" failed to apply to 4.19-stable tree
To:     paulus@ozlabs.org, clg@kaod.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:20:35 +0200
Message-ID: <157051923563238@kroah.com>
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

From 8d4ba9c931bc384bcc6889a43915aaaf19d3e499 Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@ozlabs.org>
Date: Tue, 13 Aug 2019 20:01:00 +1000
Subject: [PATCH] KVM: PPC: Book3S HV: Don't push XIVE context when not using
 XIVE device
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

At present, when running a guest on POWER9 using HV KVM but not using
an in-kernel interrupt controller (XICS or XIVE), for example if QEMU
is run with the kernel_irqchip=off option, the guest entry code goes
ahead and tries to load the guest context into the XIVE hardware, even
though no context has been set up.

To fix this, we check that the "CAM word" is non-zero before pushing
it to the hardware.  The CAM word is initialized to a non-zero value
in kvmppc_xive_connect_vcpu() and kvmppc_xive_native_connect_vcpu(),
and is now cleared in kvmppc_xive_{,native_}cleanup_vcpu.

Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Reported-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190813100100.GC9567@blackberry

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 2e7e788eb0cf..07181d0dfcb7 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -942,6 +942,8 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
 	li	r9, TM_QW1_OS
 	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
+	cmpwi	r8, 0
+	beq	no_xive
 	li	r7, TM_QW1_OS + TM_WORD2
 	mfmsr	r0
 	andi.	r0, r0, MSR_DR		/* in real mode? */
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 09f838aa3138..586867e46e51 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -67,8 +67,14 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
 	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
 	u64 pq;
 
-	if (!tima)
+	/*
+	 * Nothing to do if the platform doesn't have a XIVE
+	 * or this vCPU doesn't have its own XIVE context
+	 * (e.g. because it's not using an in-kernel interrupt controller).
+	 */
+	if (!tima || !vcpu->arch.xive_cam_word)
 		return;
+
 	eieio();
 	__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
 	__raw_writel(vcpu->arch.xive_cam_word, tima + TM_QW1_OS + TM_WORD2);
@@ -1146,6 +1152,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		struct xive_q *q = &xc->queues[i];
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 368427fcad20..11b91b46fc39 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -81,6 +81,9 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		kvmppc_xive_native_cleanup_queue(vcpu, i);

