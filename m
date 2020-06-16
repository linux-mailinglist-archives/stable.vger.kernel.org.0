Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316AD1FAE49
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgFPKnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:43:17 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:58055 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgFPKnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:43:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0706B1940577;
        Tue, 16 Jun 2020 06:43:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 06:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hTyiNn
        xpMiyijgs4+42c2pETEW0L8+LN0vso/4jUHKY=; b=K/4W0ehG9uICAgWZfZUbyW
        SY+jSE5zbCmLEoZx+h6qCfzF8hTgsVyEWWi6/PPaec1x3177SEX2G1qTKo7lmBlb
        U3XmI5aD4Jea2TBomW/qCS6RLyivFeVWcPEJsWv4vWDWK70ADpHZlqfRALoToL+u
        C0VO29501htVMR8DRx9SU+niBpVh8qWkcLDxfj9dDBbsDEg/qdGEPeeNjiwf24/e
        iBZNpze375AyWGt9wHn4l1fvPaHp7sS3Q4NePhVgqZtX36EPzSdekobzVq7HH/35
        bc+LQgUyf9Kbvrgce54gI66SU8Ph0gGyvw+RaVlTktITLaJI9+yjzjuj3JY81wTA
        ==
X-ME-Sender: <xms:QaLoXrLkbXFVTKrpC5Mv_isK9uyMJ8gWXRstO7E2kzx0ZpKd8duS1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:QaLoXvJnUH8VaNCtQgjZWJylpigs-tHO6o4XOxUg8zvyScnJMRhssQ>
    <xmx:QaLoXjsGGBnVIAP1AZF0kWdOeI19DhuvJNxwSDgm-1ETCW-USneqYQ>
    <xmx:QaLoXkYVG3JZtoc9cjfT_XxQzctMog93W9eysfkJ1ZAT9mhqk9JR0A>
    <xmx:QqLoXlxDKTCUUeL3L6DXqCLUZ5P_riJbuQNUE-RKyhW9WOsO92uk3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9949E328005E;
        Tue, 16 Jun 2020 06:43:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02" failed to apply to 4.9-stable tree
To:     sean.j.christopherson@intel.com, graf@amazon.com,
        karahmed@amazon.de, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 12:43:07 +0200
Message-ID: <1592304187103223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c911beff20aa8639e7a1f28988736c13e03ed54 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 1 May 2020 09:31:17 -0700
Subject: [PATCH] KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02

Skip the Indirect Branch Prediction Barrier that is triggered on a VMCS
switch when running with spectre_v2_user=on/auto if the switch is
between two VMCSes in the same guest, i.e. between vmcs01 and vmcs02.
The IBPB is intended to prevent one guest from attacking another, which
is unnecessary in the nested case as it's the same guest from KVM's
perspective.

This all but eliminates the overhead observed for nested VMX transitions
when running with CONFIG_RETPOLINE=y and spectre_v2_user=on/auto, which
can be significant, e.g. roughly 3x on current systems.

Reported-by: Alexander Graf <graf@amazon.com>
Cc: KarimAllah Raslan <karahmed@amazon.de>
Cc: stable@vger.kernel.org
Fixes: 15d45071523d ("KVM/x86: Add IBPB support")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200501163117.4655-1-sean.j.christopherson@intel.com>
[Invert direction of bool argument. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 669445136144..7f754b3bc6dd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -303,7 +303,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	cpu = get_cpu();
 	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load_vmcs(vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, prev);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fbede089d0f7..db842ce74e5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1311,10 +1311,12 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
+			struct loaded_vmcs *buddy)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
+	struct vmcs *prev;
 
 	if (!already_loaded) {
 		loaded_vmcs_clear(vmx->loaded_vmcs);
@@ -1333,10 +1335,18 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		local_irq_enable();
 	}
 
-	if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
+	prev = per_cpu(current_vmcs, cpu);
+	if (prev != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
 		vmcs_load(vmx->loaded_vmcs->vmcs);
-		indirect_branch_prediction_barrier();
+
+		/*
+		 * No indirect branch prediction barrier needed when switching
+		 * the active VMCS within a guest, e.g. on nested VM-Enter.
+		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 */
+		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
+			indirect_branch_prediction_barrier();
 	}
 
 	if (!already_loaded) {
@@ -1377,7 +1387,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmx_vcpu_load_vmcs(vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b5e773267abe..d3d48acc6bd9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -320,7 +320,8 @@ struct kvm_vmx {
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
+			struct loaded_vmcs *buddy);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);

