Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88137BB14
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhELKpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:45:15 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:57173 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:45:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id D45CDE89;
        Wed, 12 May 2021 06:44:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1k2+ok
        J6llHX6xeeoIUYZ57PpP1PJUZiQIKh+kRIvTE=; b=hjEIDOEh+NP2XiX1Gh0+nB
        zq+YSPAl1Pozczbbq2vZ+7AUU3nIPqrYSn0Gt4q0C9jWGJRyn9zmlHN6yBAMRlRy
        RxB7BH3aAz0pnlImWTQrLBQSAPLBNjaAvgfquP5rpbAVfwSC774cBsmGa5YPo0va
        hAmhhkbzQqRb/3FwXrN/DHfjNm7BmCLDPvaNb6piAnr+F65qr52g3Kgk+SOFGmWN
        1L5J2T5otSHi2qc3CZb1TpvzmziMjD7DfpkUL8TVNy9g/toa77G8U1TTn+2tY7Wx
        TU3vySPzFTjVFzeOx7pcugmlM7h2GEzB0LordC5yINX5tehsCqxzHdQAsfa+HSqA
        ==
X-ME-Sender: <xms:drGbYEbMsTxf0ohBRd9UvSSQn-83oaxyocqwNb3-Qo1lkiB_V3Lb_w>
    <xme:drGbYPb5uOGnY9MGrUijNmQieYqUYrzL7Xu7531AzvP8oBaFXhm8w-VHyR6HJlHmS
    bLFk3hdtz0x0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:drGbYO_JfQalaGIdg9IyQUug5IhshN99k3teutSah1C6rMIm_yhb6g>
    <xmx:drGbYOogM3bklM68iHUAd9EtZ6pVUUsWAsLqzRnMyHKwXXwNF3ZQQg>
    <xmx:drGbYPoDU8PkvGG-zRPNUs4iGVJaDb9xLLwvx0WVgGJrlMpVXFusXw>
    <xmx:drGbYOSVer8m5B4yNJQYw48TMBvm_lVFHdjnX54YPGysgoFS57tfSAoL-Fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:44:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and CR accesses in" failed to apply to 5.11-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:43:52 +0200
Message-ID: <162081623246216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

