Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5C437BB1C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELKpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:45:34 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:45667 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhELKpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:45:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4A7E8E89;
        Wed, 12 May 2021 06:44:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=elrmXx
        /S0exw8SW9N015+z+yZ6A+OWu+YgwbpJucAGo=; b=BDZPoQ9WbpwR8avQsmGj8u
        LQiLSPwQ8Y0Q0MIxvs/yBTBtW0XGkMEYItAvLsMGm0Y1ja9T1GneL3eWV/BiGfaE
        xBaaTV9WdzgLk6jaxmhhDZ0vfzwRRCoSbwHykjKuBDJ3q4bs7GkDFjvpdxyCv4Np
        nj4rk2ufoG57SU04UaXBhJ3mKKa1erYvWTtc+C/QNFWowJC2kRfQqDcv7CWwu3oY
        r4I438K/qdMWuSvvwxa4rXoRjYMPADlWSe/reMh//jkFpGW3OI43DAz4jUGXUYRq
        urUn2dq71kA3kbaAiQHnRXAL+KeTHiPeC1WeaiVVY9j8NvJajrX3h1qZna1jvZjA
        ==
X-ME-Sender: <xms:ibGbYHHxf4_BTctR3tq6TlCW2gMjdTPc0sNB7D7UG1aP5FHZOwKxEg>
    <xme:ibGbYEVvh-bpFBDIEprR3vOBSlys1AFkJL9oWVRTOFWMZGoQu-_IfSzrk2S5R11Bk
    NSr-cAuvvbc1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ibGbYJK2njZAwYrdBHj85gIP2z-7E9_P9om3J5epAxhM0b--2skUaQ>
    <xmx:ibGbYFFUFglHf_rL_8lebt9UGjaac3N1AY7y7sm34aP7du7YREbQvw>
    <xmx:ibGbYNVwMiNdwep-EufUidvBa-7uuI1sNmuus5M-zBSVNI46WA_vWQ>
    <xmx:ibGbYOdTQde-pP6M8LtqnYR-LsEP6lpTBnn4u8trgl-3fDhHbDJZ6K09CNY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:44:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Use default rAX size for INVLPGA emulation" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:44:06 +0200
Message-ID: <1620816246227131@kroah.com>
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

From bc9eff67fc35d733e2de0e0017dc3f5a86e8daf8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:27 -0700
Subject: [PATCH] KVM: SVM: Use default rAX size for INVLPGA emulation

Drop bits 63:32 of RAX when grabbing the address for INVLPGA emulation
outside of 64-bit mode to make KVM's emulation slightly less wrong.  The
address for INVLPGA is determined by the effective address size, i.e.
it's not hardcoded to 64/32 bits for a given mode.  Add a FIXME to call
out that the emulation is wrong.

Opportunistically tweak the ASID handling to make it clear that it's
defined by ECX, not rCX.

Per the APM:
   The portion of rAX used to form the address is determined by the
   effective address size (current execution mode and optional address
   size prefix). The ASID is taken from ECX.

Fixes: ff092385e828 ("KVM: SVM: Implement INVLPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 857bcf3a4cda..1f5a8e7872c1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2290,11 +2290,17 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
 
 static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
-	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, kvm_rcx_read(vcpu),
-			  kvm_rax_read(vcpu));
+	gva_t gva = kvm_rax_read(vcpu);
+	u32 asid = kvm_rcx_read(vcpu);
+
+	/* FIXME: Handle an address size prefix. */
+	if (!is_long_mode(vcpu))
+		gva = (u32)gva;
+
+	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
 
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
-	kvm_mmu_invlpg(vcpu, kvm_rax_read(vcpu));
+	kvm_mmu_invlpg(vcpu, gva);
 
 	return kvm_skip_emulated_instruction(vcpu);
 }

