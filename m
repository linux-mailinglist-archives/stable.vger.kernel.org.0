Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9D3C3C83
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhGKMpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:45:13 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40163 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:45:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 33AD01AC0DBA;
        Sun, 11 Jul 2021 08:42:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sU9Bxs
        RWVlqIKftSAFPQCCORYD52Br+fu6u88KvBXJc=; b=ccislS52No3dwS10Tvg9B5
        5w4GzJKdNxYsc28TYQrRL+h6xCJFt8hwi55Vt6MynYxJWsnABpgkfhGRAg/dfg3w
        EibmOfei+Dawnbhv7o4rRFu3aAreTkt3FW1huv8etBdfHXfjACTl6u09UixpC4jk
        3dJws7kgCGhS7VVDEZBYVaZfY88NjwXUKbJIgcZklU78ekARHjszBOA1zwLvHN3h
        eZONQpE6qVd4JiXK9E9b4sS3sO6cFNmuvZQe1E0IvF3WmypBs9SLRbiUaqB6DCWB
        07gOsNW4amC+Waneavd1LuLAYBCyuYS0vTLc969w9pRMBSUuWapX47B67J9ayQEg
        ==
X-ME-Sender: <xms:MefqYLFEA22G4l0J-OeAt2bfD9dad7rOlfNcXLHRoNwocBcES-ooGA>
    <xme:MefqYIVhPXOVBUwNLd_6unOa-o7H5HU1CItrq3ud0LhLUBvw5S77WSC0sD0ThAV7S
    Pk7tEnx4qlzsA>
X-ME-Received: <xmr:MefqYNJbvGqMIjebyOYrTz7-tx4DeM4qQesrkRJ8ghqPS5mmW6nZFWzOSKgBoQ6kjlxlDJ1aqJj75ieRU2LphFZe_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MefqYJEwLbMUKmj6wcPr0nZ-szzj6a__LPahPXvyGluFQ8bjvIUgVw>
    <xmx:MefqYBW4z6NhAHRHInNV0PUivEMREFw-oCdLarL2fekBf7tuoGSl2A>
    <xmx:MefqYEPbFslS4MESq3S7G0_I655MDJXf7MHm_49utWY4h02GSRbX0A>
    <xmx:MefqYOjS74PeLuSMW2TMZoS21KNwxY37RGtoqmQGN_zRq-G59X_mSyvEfGo>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:42:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Force all MMUs to reinitialize if guest CPUID is" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:42:23 +0200
Message-ID: <162600734361124@kroah.com>
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

From 49c6f8756cdffeb9af1fbcb86bacacced26465d7 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 22 Jun 2021 10:56:51 -0700
Subject: [PATCH] KVM: x86: Force all MMUs to reinitialize if guest CPUID is
 modified

Invalidate all MMUs' roles after a CPUID update to force reinitizliation
of the MMU context/helpers.  Despite the efforts of commit de3ccd26fafc
("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role"),
there are still a handful of CPUID-based properties that affect MMU
behavior but are not incorporated into mmu_role.  E.g. 1gb hugepage
support, AMD vs. Intel handling of bit 8, and SEV's C-Bit location all
factor into the guest's reserved PTE bits.

The obvious alternative would be to add all such properties to mmu_role,
but doing so provides no benefit over simply forcing a reinitialization
on every CPUID update, as setting guest CPUID is a rare operation.

Note, reinitializing all MMUs after a CPUID update does not fix all of
KVM's woes.  Specifically, kvm_mmu_page_role doesn't track the CPUID
properties, which means that a vCPU can reuse shadow pages that should
not exist for the new vCPU model, e.g. that map GPAs that are now illegal
(due to MAXPHYADDR changes) or that set bits that are now reserved
(PAGE_SIZE for 1gb pages), etc...

Tracking the relevant CPUID properties in kvm_mmu_page_role would address
the majority of problems, but fully tracking that much state in the
shadow page role comes with an unpalatable cost as it would require a
non-trivial increase in KVM's memory footprint.  The GBPAGES case is even
worse, as neither Intel nor AMD provides a way to disable 1gb hugepage
support in the hardware page walker, i.e. it's a virtualization hole that
can't be closed when using TDP.

In other words, resetting the MMU after a CPUID update is largely a
superficial fix.  But, it will allow reverting the tracking of MAXPHYADDR
in the mmu_role, and that case in particular needs to mostly work because
KVM's shadow_root_level depends on guest MAXPHYADDR when 5-level paging
is supported.  For cases where KVM botches guest behavior, the damage is
limited to that guest.  But for the shadow_root_level, a misconfigured
MMU can cause KVM to incorrectly access memory, e.g. due to walking off
the end of its shadow page tables.

Fixes: 7dcd57552008 ("x86/kvm/mmu: check if tdp/shadow MMU reconfiguration is needed")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a474cd13b0c8..f1e4d5f2bf8d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1496,6 +1496,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu);
 void kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b4da665bb892..c42613cfb5ba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -202,10 +202,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
 
 	/*
-	 * Except for the MMU, which needs to be reset after any vendor
-	 * specific adjustments to the reserved GPA bits.
+	 * Except for the MMU, which needs to do its thing any vendor specific
+	 * adjustments to the reserved GPA bits.
 	 */
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_after_set_cpuid(vcpu);
 }
 
 static int is_efer_nx(void)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa35762f325c..1ab3fdb1f2e4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4903,6 +4903,18 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 	return role.base;
 }
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Invalidate all MMU roles to force them to reinitialize as CPUID
+	 * information is factored into reserved bit calculations.
+	 */
+	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	kvm_mmu_reset_context(vcpu);
+}
+
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);

