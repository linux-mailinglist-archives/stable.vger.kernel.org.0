Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB837BB12
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhELKpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:45:10 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50129 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:45:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AE07E12DD;
        Wed, 12 May 2021 06:44:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fmLGL2
        aBN5MNTvkTTp8dEgSwC29yuqhZuH4cfyZz9dQ=; b=g53UGoR9JnlJEbL144xKcJ
        aWxPUXeUBfnBHfyEO4MsRwCtUSlBaM4gFaW7y8oJ4FllSOW7Z1GE4s6G3lZ3Zfqj
        ZFbuobDX31oGFbes75lN5EKcnSnbcw5S/BgLoTlEMHZiNM0xkMuUj/eFdQCCQhke
        vFN9z18YtkkLuPx3ScjX3S/4p5kYSbX5wKvrBEtHoatMZwwCthN+KQ9YW0jkNWWG
        gl8rT6S1LAhCcf2PlO1JuexqFQulb9mcrZspVQeV/CxPpWoSOSH9qn7pBXk7M1Bz
        sSSqKi0ErTVsYtX9orpp7xrqhMrMwyUfQWWd3LVudEKQJ4/SLAQN+4WqGxH0mevA
        ==
X-ME-Sender: <xms:cbGbYFhPlfEfiQB8pI_AnFH6aAcEuOFiJoQADV1mvQPFVwJrqoLmEA>
    <xme:cbGbYKD08b6OvydlPm5zamXdDPzCYxqL8Yj9nS2X7dS0FnlPbtxsEqL82Z677nhW2
    l1G-p8FQP_17Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:cbGbYFFAreno7rjB8oiezLuV_2bGb_EOUSf69bNbYpzorGSUSDNnLA>
    <xmx:cbGbYKSUHPRD8dYfGsCYbAJSiuxBghphpmVdOT1IhbPqMvgo8ZcrZg>
    <xmx:cbGbYCxmKhnUdCKqIniIZJ-4xgbG4ENe73Z79cQoDvuASBQhXfKkFg>
    <xmx:cbGbYIa2SX3jkvsxd4hJZoBXaDrd4Vf9WBFS-6HQ6ROOgewQCps5xb2Eo1o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:44:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and CR accesses in" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:43:51 +0200
Message-ID: <16208162316492@kroah.com>
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

