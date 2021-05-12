Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6555337BB1A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELKpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:45:30 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36671 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhELKp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:45:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 746B7E89;
        Wed, 12 May 2021 06:44:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=p4r3Ir
        Y0Ao6DD4saZAbBHOb9vF2FaUtWfza2SpCOZV4=; b=MZjz+ahlLPNLEjH65U26yP
        IYvj+YhoCGNAY3TunrmOUKssLpunBcXzaNalCPBDUZeAHUOGlZS6JQYweabs8Qhr
        1hJyrY0AEAE2y13yHex7tQ+cmUcGhHbXY21Xvi38d+D3xxWYwhHJPsWLUx2WuyOY
        cjpJ9hzF0caV/tFjlTnRFdI1V1I8azQ0nkQM68wTHss02PRHjUoiheLTnIJjRBB7
        Cq3J7VHiB9ZRzURNQFyhTddG66lvUoMcVG8wvME0gqszQVxYhyH3dJGl6HF6uzx3
        iEH+pvd0MnsL+ec81CH2QBzSwG3zxaBCRTg5Is+dfXkqgSg0W4tGh+1j2ggTJexg
        ==
X-ME-Sender: <xms:hbGbYD3aWPM0YAl5Xc06hZht4qwQ-VXwGPdHgz3glMbQc94y02AMMQ>
    <xme:hbGbYCHWGc8U6K1qnfbwf8T2lkpjGw7PayHrDBi-kjMpaZNU0BkIBVdEa1Z3LU6cm
    TQX0AMZUNWRVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hbGbYD4qLmCQHjNDkXi1R-hfer8asAiHBNo6PqRRAIfzHTvBmIpzGw>
    <xmx:hbGbYI0cp2dAFZ4-Bf7UohtVFd7Il5KO4tGvEu-vgJkknpkI6Af0hg>
    <xmx:hbGbYGGaDRoZufr7YSQFTES0870jTLYzKQ_dCQ8ZmV_YkQiOXv7fIQ>
    <xmx:hbGbYBMRc9cJ5HSj8NhqZcd0kjUqMzo7NY0mFGD91yT8xguGd2tv7IpHumo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:44:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Use default rAX size for INVLPGA emulation" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:44:05 +0200
Message-ID: <162081624518114@kroah.com>
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

