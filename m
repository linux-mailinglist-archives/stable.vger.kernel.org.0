Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54F06AC9DE
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjCFRYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCFRYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:24:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DFA83E9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D188C6104D
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4045C433D2;
        Mon,  6 Mar 2023 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678123422;
        bh=e5eQl8ZJw8dtMQKa0XnN2fDwsE/teWPIKRlhQbPy5MY=;
        h=Subject:To:Cc:From:Date:From;
        b=l9p1Q5E8DyNpVqp0ZYdukjE1D6pO6OXDe5LvcwAPpqQHUIj2h77BjUGpfmWsnHR7n
         x7+Vmg5kbrjkEavkHRDZyajgIEyhy8eSk213jPQCWHP2+9NZfdQs3I4chL1DlCGc9z
         f4c7g3wphdunkhMA6wLzs700YdFRm1VZ6uzO5xSI=
Subject: FAILED: patch "[PATCH] KVM: SVM: Process ICR on AVIC IPI delivery failure due to" failed to apply to 5.4-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:23:35 +0100
Message-ID: <1678123415238203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 5aede752a839904059c2b5d68be0dc4501c6c15f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678123415238203@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

5aede752a839 ("KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target")
b51818afdc1d ("KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure")
dd4589eee99d ("Revert "svm: Add warning message for AVIC IPI invalid target"")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5aede752a839904059c2b5d68be0dc4501c6c15f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 6 Jan 2023 01:12:37 +0000
Subject: [PATCH] KVM: SVM: Process ICR on AVIC IPI delivery failure due to
 invalid target

Emulate ICR writes on AVIC IPI failures due to invalid targets using the
same logic as failures due to invalid types.  AVIC acceleration fails if
_any_ of the targets are invalid, and crucially VM-Exits before sending
IPIs to targets that _are_ valid.  In logical mode, the destination is a
bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
causes KVM to drop IPIs if at least one target is valid and at least one
target is invalid.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: stable@vger.kernel.org
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712330b80891..3b2c88b168ba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -502,14 +502,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
 		 * Emulate IPIs that are not handled by AVIC hardware, which
-		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
-		 * a trap, e.g. ICR holds the correct value and RIP has been
-		 * advanced, KVM is responsible only for emulating the IPI.
-		 * Sadly, hardware may sometimes leave the BUSY flag set, in
-		 * which case KVM needs to emulate the ICR write as well in
+		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
+		 * if _any_ targets are invalid, e.g. if the logical mode mask
+		 * is a superset of running vCPUs.
+		 *
+		 * The exit is a trap, e.g. ICR holds the correct value and RIP
+		 * has been advanced, KVM is responsible only for emulating the
+		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
+		 * in which case KVM needs to emulate the ICR write as well in
 		 * order to clear the BUSY flag.
 		 */
 		if (icrl & APIC_ICR_BUSY)
@@ -525,8 +529,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;

