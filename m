Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8647CF396
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfJHHUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:20:38 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48699 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730144AbfJHHUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:20:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2379D5D0;
        Tue,  8 Oct 2019 03:20:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wrnR0A
        E37MWko/TJVP3MKi8SY/98/LOeMtl1pPxsPVY=; b=immymcjLjKyBJ1OyG0XWSr
        TQZ2sFEmgukEup0mz2HpNTlEoJjIyJSSiX3ctd2ZZfNeXwrrgSOyq8y/WSPzRr+p
        n919Uy89kox8LXKTyb69kOEpt78q7vo2sOHpl94m6y1jV40kHRcb2VG+esINfgYC
        cYV4m10Ybln1BtrTuPVaZ/tvGRIx9mSZ/GyaNpvsA+hdI3313H+gOTaRSIU90X/M
        hIpby67TwWyuX4wumWcwWc03EXZA0VwD0VG/2CCsqSxjzf2pM6KS4p9wnkFKljKo
        mEj4jWzEI39Z+eHCT7CYf6WrXumQ52yOyicN02ZZobqFUohMeTBx4wi6jLEOzaWw
        ==
X-ME-Sender: <xms:xDicXa-kdCapQMLIfZEWra0msqV9fhdscJoZtEQJEQziNiJHIC252w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehrmhhhrghnughlvghrshdrshgspdhkvghrnhgvlhdrohhrgh
    enucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:xDicXTAPtn4DBgNKurEqpocFAN-InI3J_WxwcAIVi7-Q8zvPdm0jOA>
    <xmx:xDicXaAe0KjhN3Jd-58ZZ53BpP-YZN0i7Obm6KXC99GfcEI-ShTbpg>
    <xmx:xDicXQS0CPFLfUSkWyaWph5AEovqaQe0EzxRfXumdUMHBfuOemmmwg>
    <xmx:xDicXRcc08QhJYubmixpvimRicLK2thoKjRsdOmqDzpQS5KmDYRfuw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28A90D6005F;
        Tue,  8 Oct 2019 03:20:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Don't push XIVE context when not using" failed to apply to 4.14-stable tree
To:     paulus@ozlabs.org, clg@kaod.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:20:35 +0200
Message-ID: <15705192352691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

