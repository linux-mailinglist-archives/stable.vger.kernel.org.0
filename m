Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F006000E3
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJPPrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJPPrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD438699
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB8560C05
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ED0C433D6;
        Sun, 16 Oct 2022 15:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935238;
        bh=E4ZDo/WUT11lLBs8Mv6BzzOT1j0JFdgIUtZgkM/7zEY=;
        h=Subject:To:Cc:From:Date:From;
        b=epVztkJT9eODmOokBkwXNeEGLXHW2iy0BdOa5irClt7E4B54R8f4wgmS4kTy4Ut+F
         scw5Az7PlmCodK7NfT9DW66EqbvNqxmWrTf7g7YQVVHBcAbYIg9hGNCR4mxWWVtCP/
         hEzEtWVKCO2V5nXSHeYDUoo5I1vpVfJPcqJllkKg=
Subject: FAILED: patch "[PATCH] KVM: x86: Treat #DBs from the emulator as fault-like (code" failed to apply to 4.9-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:47:54 +0200
Message-ID: <1665935274157226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
a61d7c5432ac ("KVM: x86: Trace re-injected exceptions")
b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
cb6a32c2b877 ("KVM: x86: Handle triple fault in L2 without killing L1")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5623f751bd9c438ed12840e086f33c4646440d19 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Aug 2022 23:15:55 +0000
Subject: [PATCH] KVM: x86: Treat #DBs from the emulator as fault-like (code
 and DR7.GD=1)

Add a dedicated "exception type" for #DBs, as #DBs can be fault-like or
trap-like depending the sub-type of #DB, and effectively defer the
decision of what to do with the #DB to the caller.

For the emulator's two calls to exception_type(), treat the #DB as
fault-like, as the emulator handles only code breakpoint and general
detect #DBs, both of which are fault-like.

For event injection, which uses exception_type() to determine whether to
set EFLAGS.RF=1 on the stack, keep the current behavior of not setting
RF=1 for #DBs.  Intel and AMD explicitly state RF isn't set on code #DBs,
so exempting by failing the "== EXCPT_FAULT" check is correct.  The only
other fault-like #DB is General Detect, and despite Intel and AMD both
strongly implying (through omission) that General Detect #DBs should set
RF=1, hardware (multiple generations of both Intel and AMD), in fact does
not.  Through insider knowledge, extreme foresight, sheer dumb luck, or
some combination thereof, KVM correctly handled RF for General Detect #DBs.

Fixes: 38827dbd3fb8 ("KVM: x86: Do not update EFLAGS on faulting emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220830231614.3580124-9-seanjc@google.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee22264ab471..ee3041da222b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -533,6 +533,7 @@ static int exception_class(int vector)
 #define EXCPT_TRAP		1
 #define EXCPT_ABORT		2
 #define EXCPT_INTERRUPT		3
+#define EXCPT_DB		4
 
 static int exception_type(int vector)
 {
@@ -543,8 +544,14 @@ static int exception_type(int vector)
 
 	mask = 1 << vector;
 
-	/* #DB is trap, as instruction watchpoints are handled elsewhere */
-	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
+	/*
+	 * #DBs can be trap-like or fault-like, the caller must check other CPU
+	 * state, e.g. DR6, to determine whether a #DB is a trap or fault.
+	 */
+	if (mask & (1 << DB_VECTOR))
+		return EXCPT_DB;
+
+	if (mask & ((1 << BP_VECTOR) | (1 << OF_VECTOR)))
 		return EXCPT_TRAP;
 
 	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
@@ -8844,6 +8851,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
+
+		/*
+		 * Note, EXCPT_DB is assumed to be fault-like as the emulator
+		 * only supports code breakpoints and general detect #DB, both
+		 * of which are fault-like.
+		 */
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
 			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
@@ -9767,6 +9780,16 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
+		/*
+		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
+		 * value pushed on the stack.  Trap-like exception and all #DBs
+		 * leave RF as-is (KVM follows Intel's behavior in this regard;
+		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
+		 *
+		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
+		 * describe the behavior of General Detect #DBs, which are
+		 * fault-like.  They do _not_ set RF, a la code breakpoints.
+		 */
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);

