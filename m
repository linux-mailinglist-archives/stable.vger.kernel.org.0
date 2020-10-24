Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C6297BB5
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760501AbgJXJnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:43:31 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:49373 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760500AbgJXJn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:43:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6A2F0B69;
        Sat, 24 Oct 2020 05:43:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RkQ+Op
        y1iS8GmO9Mjpj3jgkYVcHehtklZtxwM/+s8kI=; b=fqYgL8W7bQpBPqMDnGo8zc
        QX4Zn2RFdB4KF+OAFnmMrB8QiB5j9wG38tG+wjqrUT1PSJB6fnddnsfwJGxY0Llx
        VUvFEHGoLLQjDkKKpIodKkSnMaVTLKtS8T5I03O4tu2s7Tq2rsWP1mLpFB/vMQUa
        Xjq7nZUaYQz9f9SSoPNdqELYSCCTMZcOIy3NWBw4O/Rq39hLrCrzw8mzHMrZbaeJ
        it7bMdv99PauxRtF3O6q51NoAC+LDQH3LSWTakw+gikeBqjHzsZDoFuzOyt5CANW
        BcStkNqBFOsB361jaPi3FFCSIPVTR8NWP4arZ1Gj/DkNNRU7c6lTCk7cpAW8TabA
        ==
X-ME-Sender: <xms:P_eTX2nGkRjs5h7daHANC98UXmqIHK6SGVi2AJo7_CvXlB8EK339fA>
    <xme:P_eTX93sFa2SLMaFqIn9Z7MzGZBc4PoDI6jJm2KVzYmxHERCMfGpyHgUN3RmhEFfZ
    2bWdKilEFupLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:P_eTX0rAQF6Ell0cEaEXAJ-ZZ_iDebZpTeOe6M-S_HTDjp4Em2Rh1g>
    <xmx:P_eTX6nHbwN7NrzIE6fAfUdG6afNasOSawV7OZDZ6V2hvy_rIRLbag>
    <xmx:P_eTX02dCb5b6_axgVMNUn_uF1loYI_xrugeFv40l60ULmcx6LqqHQ>
    <xmx:QPeTX5_cxUaFWrCNWeiqPWBA_2mD2bAxxb7miQvfPZkDh9cHa8dKZ72BXm4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F8BA3064674;
        Sat, 24 Oct 2020 05:43:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Explicitly check for valid guest state for" failed to apply to 5.8-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:44:01 +0200
Message-ID: <160353264123027@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ba4493a8b195cc1d7dd5b762a84e6235c2d67bd Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 23 Sep 2020 11:44:48 -0700
Subject: [PATCH] KVM: nVMX: Explicitly check for valid guest state for
 !unrestricted guest

Call guest_state_valid() directly instead of querying emulation_required
when checking if L1 is attempting VM-Enter with invalid guest state.
If emulate_invalid_guest_state is false, KVM will fixup segment regs to
avoid emulation and will never set emulation_required, i.e. KVM will
incorrectly miss the associated consistency checks because the nested
path stuffs segments directly into vmcs02.

Opportunsitically add Consistency Check tracing to make future debug
suck a little less.

Fixes: 2bb8cafea80bf ("KVM: vVMX: signal failure for nested VMEntry if emulation_required")
Fixes: 3184a995f782c ("KVM: nVMX: fix vmentry failure code when L2 state would require emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200923184452.980-4-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 321a6790ad9f..e004ab8c2ea6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2576,7 +2576,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * which means L1 attempted VMEntry to L2 with invalid state.
 	 * Fail the VMEntry.
 	 */
-	if (vmx->emulation_required) {
+	if (CC(!vmx_guest_state_valid(vcpu))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68b9a9b3661c..d87c8d2892ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -337,7 +337,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 };
 module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
-static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
 							  u32 msr, int type);
@@ -1340,7 +1339,7 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 
 static bool emulation_required(struct kvm_vcpu *vcpu)
 {
-	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
+	return emulate_invalid_guest_state && !vmx_guest_state_valid(vcpu);
 }
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -3402,11 +3401,8 @@ static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
  * not.
  * We assume that registers are always usable
  */
-static bool guest_state_valid(struct kvm_vcpu *vcpu)
+bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 {
-	if (is_unrestricted_guest(vcpu))
-		return true;
-
 	/* real mode guest state checks */
 	if (!is_protmode(vcpu) || (vmx_get_rflags(vcpu) & X86_EFLAGS_VM)) {
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_CS))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 60bb7a125f0b..e87fae204d3d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -321,6 +321,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
 		   int root_level);
+
 void update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
@@ -472,6 +473,12 @@ static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
 	    SECONDARY_EXEC_UNRESTRICTED_GUEST));
 }
 
+bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu);
+static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
+{
+	return is_unrestricted_guest(vcpu) || __vmx_guest_state_valid(vcpu);
+}
+
 void dump_vmcs(void);
 
 #endif /* __KVM_X86_VMX_H */

