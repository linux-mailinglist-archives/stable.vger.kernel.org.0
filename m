Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0337BB0F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhELKpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:45:00 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51147 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:44:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4CF77EB8;
        Wed, 12 May 2021 06:43:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=q85gms
        N4i9ts+tCAVhXfgjTPoQmrMavq50r+LblRr7c=; b=VAsd8rFHsmNbm8JVzG1eKX
        QjpL9kvAJ5zLVcEElR4cZu+Z0DeOyO55hydyF3BBCAbgd69LAEKOL9rUXyBRWQSL
        YwsDPw6S0VwTKXv0c4RVhwD5f1eejryns5VB5gazIB13P1YWDFEj/RoZjNL4+6Vp
        4JgMqnenfiSHwFVcH2y0C3hh9UN6vX7i3ZKCq5oXAM9QkiS37iHM+s+vokQoG1Ek
        R53WvnOF4Vw5kybT6NBQJYnSVExC7pQZASfLBJ0BaHRTT88nFadjyFInjBQv2k8P
        j1iOYvgFggnyCWO32FUQ87ArZ4oUCXHUABMYm3Hcn0A8DtEAPH6/GSH8n3ZLInyw
        ==
X-ME-Sender: <xms:ZrGbYNBhEKmrZU66IHzQO_VTlj_7j_GH1n8_Q6YdAMg1pSK055nU5Q>
    <xme:ZrGbYLihkIdvQWiUdf1zcag9CQsuNajV6J7-A0LiEvfEX_g3gfgMNg-jkgm1sxfTy
    4scX6gn0V-ybw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ZrGbYImD4EaJD82Tbva6ueCFXVooZP4KQgPtHwy4kXssFHEyQOpVJA>
    <xmx:ZrGbYHyD9DgU_zjHQNOI7NCVY2IizxF6k5I704Lvcln-nGL-KtKh5g>
    <xmx:ZrGbYCQo0ejsYvSTRC22PDpkuBfzqvKpRwmrDrlHS68XEJtqS0aINA>
    <xmx:ZrGbYL4ovdYP8VD2y-60WfW0di7g1-uuY-JlgroE0-3kdfQbazA-3b5P2Rg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:43:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and CR accesses in" failed to apply to 4.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:43:49 +0200
Message-ID: <162081622926159@kroah.com>
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

From 0884335a2e653b8a045083aa1d57ce74269ac81d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:22 -0700
Subject: [PATCH] KVM: SVM: Truncate GPR value for DR and CR accesses in
 !64-bit mode

Drop bits 63:32 on loads/stores to/from DRs and CRs when the vCPU is not
in 64-bit mode.  The APM states bits 63:32 are dropped for both DRs and
CRs:

  In 64-bit mode, the operand size is fixed at 64 bits without the need
  for a REX prefix. In non-64-bit mode, the operand size is fixed at 32
  bits and the upper 32 bits of the destination are forced to 0.

Fixes: 7ff76d58a9dc ("KVM: SVM: enhance MOV CR intercept handler")
Fixes: cae3797a4639 ("KVM: SVM: enhance mov DR intercept handler")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 301792542937..857bcf3a4cda 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2451,7 +2451,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_register_readl(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2497,7 +2497,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 			kvm_queue_exception(vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(vcpu, err);
@@ -2563,11 +2563,11 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_register_readl(vcpu, reg);
 		err = kvm_set_dr(vcpu, dr, val);
 	} else {
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 	}
 
 	return kvm_complete_insn_gp(vcpu, err);

