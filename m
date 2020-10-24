Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF263297BB6
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760500AbgJXJnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:43:31 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:45159 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751459AbgJXJna (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:43:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E4FB3B86;
        Sat, 24 Oct 2020 05:43:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LmyzhO
        fnbtTPH/wbj1pchnAnxaaVm7Wy8AhEzZDento=; b=SHjd/AsUTV+1g6puda6i9O
        t4RUWZQN0WBYSSZVSLm/ddH3SpCpIXDr9V1XNbJL46Oy4R1n7Q4RDR0TM/wOZ2GK
        7vBm7aUGMGTUos5wDpPC4SuRlI1UIqDq1BtOTZlQfNjg+3AQ2vYs5JQ3JUkEMGu8
        wM0B1F5OInXMbrMzj67O5UdW78pqo7LDSYCSg+w7UiOLGBw0amGpD0VkgXmppxqR
        sJHAs7P/w2ifc/yn6Re9INFF3WkYxVUS3nbM+kM1qao94p38xyLVsvUxJ7d5DJUS
        yJ63K368iFg3MD1PUMHlRUv/aW3rT282HDBKTgieNvAu8f3P5cRJVC4OnOZE6f8Q
        ==
X-ME-Sender: <xms:QfeTX8QLWC6AHaDkZmKchYiaYQmtTodLv5cE3liEU4aW6voitgnH4Q>
    <xme:QfeTX5w2te5l6jfFuSe91voAYNpUtNJfOU9Mv1PbKst7p6ijwaiCL-seq7sErJI86
    m3C4V_8gXfzmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:QfeTX53AaAlrjDLOPT4niRXw7bWIU_lUErkwdsRu0W2u-ugIn4RNmQ>
    <xmx:QfeTXwB9Rho_y1g29_BRSA0s-wZZE4PhciKBVkmh-2v-ujzKjjRjYw>
    <xmx:QfeTX1j9lPzfNqZc61GU6F8lZz1vbliA13GV2jnaYOtIKz8T7PV0rQ>
    <xmx:QfeTX1J0IMgglKARP874V0eyz7Y9lI_PGGF2D-9imuRnkvTnZgPIYoxu9_I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2DD793280060;
        Sat, 24 Oct 2020 05:43:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Explicitly check for valid guest state for" failed to apply to 5.4-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:44:02 +0200
Message-ID: <16035326424120@kroah.com>
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

