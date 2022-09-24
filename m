Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7FA5E8A3B
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 10:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiIXInF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 04:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiIXInE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 04:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B6EB5A4D
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 01:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2420C60B39
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 08:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27744C433D7;
        Sat, 24 Sep 2022 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664008982;
        bh=2UAS/cIaEkDmRGGyUn2UjGO5Sdca/y+F8m52WEqjbnQ=;
        h=Subject:To:Cc:From:Date:From;
        b=oIGHblBSFr2NAHMxJj2T74JvciDuBhL6mQi++NyiOmD1zF/YQy6D0TRixVPIwvOUt
         sNwsG/Fmc0xs4s3jCe4qO2IBaNb0+7Qh6RhqAK8uD1ISl9x4nYa/K1nr4F8hErqV2E
         CV7Xpzyi1VThNhAaPc3db6mIbKn2Oob5AgO33MHg=
Subject: FAILED: patch "[PATCH] KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 10:42:59 +0200
Message-ID: <16640089794516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

50b2d49bafa1 ("KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled")
92f9895c146d ("KVM: x86: Move XSETBV emulation to common code")
63129754178c ("KVM: SVM: Pass struct kvm_vcpu to exit handlers (and many, many other places)")
2a32a77cefa6 ("KVM: SVM: merge update_cr0_intercept into svm_set_cr0")
11f0cbf0c605 ("KVM: nSVM: Trace VM-Enter consistency check failures")
6906e06db9b0 ("KVM: nSVM: Add missing checks for reserved bits to svm_set_nested_state()")
c08f390a75c1 ("KVM: nSVM: only copy L1 non-VMLOAD/VMSAVE data in svm_set_nested_state()")
9e8f0fbfff1a ("KVM: nSVM: rename functions and variables according to vmcbXY nomenclature")
193015adf40d ("KVM: nSVM: Track the ASID generation of the vmcb vmrun through the vmcb")
af18fa775d07 ("KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb")
4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
6d1b867d0456 ("KVM: SVM: Don't strip the C-bit from CR2 on #PF interception")
43c11d91fb1e ("KVM: x86: to track if L1 is running L2 VM")
9e46f6c6c959 ("KVM: SVM: Clear the CR4 register on reset")
2df8d3807ce7 ("KVM: SVM: Fix nested VM-Exit on #GP interception handling")
d2df592fd8c6 ("KVM: nSVM: prepare guest save area while is_guest_mode is true")
a04aead144fd ("KVM: nSVM: fix running nested guests when npt=0")
996ff5429e98 ("KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers")
e6c804a848d6 ("KVM: SVM: Move AVIC vCPU kicking snippet to helper function")
ca29e14506bd ("KVM: x86: SEV: Treat C-bit as legal GPA bit regardless of vCPU mode")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50b2d49bafa16e6311ab2da82f5aafc5f9ada99b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 24 Aug 2022 03:30:57 +0000
Subject: [PATCH] KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't
 enabled

Inject #UD when emulating XSETBV if CR4.OSXSAVE is not set.  This also
covers the "XSAVE not supported" check, as setting CR4.OSXSAVE=1 #GPs if
XSAVE is not supported (and userspace gets to keep the pieces if it
forces incoherent vCPU state).

Add a comment to kvm_emulate_xsetbv() to call out that the CPU checks
CR4.OSXSAVE before checking for intercepts.  AMD'S APM implies that #UD
has priority (says that intercepts are checked before #GP exceptions),
while Intel's SDM says nothing about interception priority.  However,
testing on hardware shows that both AMD and Intel CPUs prioritize the #UD
over interception.

Fixes: 02d4160fbd76 ("x86: KVM: add xsetbv to the emulator")
Cc: stable@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220824033057.3576315-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d5ec3a2ed5a4..aacb28c83e43 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4132,6 +4132,9 @@ static int em_xsetbv(struct x86_emulate_ctxt *ctxt)
 {
 	u32 eax, ecx, edx;
 
+	if (!(ctxt->ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE))
+		return emulate_ud(ctxt);
+
 	eax = reg_read(ctxt, VCPU_REGS_RAX);
 	edx = reg_read(ctxt, VCPU_REGS_RDX);
 	ecx = reg_read(ctxt, VCPU_REGS_RCX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c95cf18a796c..b0c47b41c264 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1065,6 +1065,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
+	/* Note, #UD due to CR4.OSXSAVE=0 has priority over the intercept. */
 	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
 		kvm_inject_gp(vcpu, 0);

