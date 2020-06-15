Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB71F996D
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgFON50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:57:26 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45233 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730194AbgFON5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:57:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 38B216CE;
        Mon, 15 Jun 2020 09:57:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mvjnRz
        7in9ZzlSvHvkK3JK7cCiH3A39XPrFrqHH48kE=; b=mHTV+LJYgAWm7XJmx4INLC
        KBnSUgAVPnpRrvAMlpDb5+KlTsC1w96x7P8gA/mWO4a7LOkMNAeWTMRj4h+EiZkg
        3/xqfYXGpkze+Akvyfh1yuHyLxzDXQU2UermDHnYjRNoayiovc7DkxIPiwmA5DQY
        MT41gV/xSfR9yloiA6cPROmRLD9Nx6mVYJypQLjhBkDr4Df9w85FwEtxoL2XaRk9
        mqD3otti0VY7ObHeOnwzSu3MZ272UKc9T55qLGYzcT50TKKtHP1fJAHpbjBHaOC/
        T5lC2Wz1qZM6H4jS+SZjRInOHCZVjEy9W8ktV9DJ/D38IAMuO0aHJGvr+9MmZeHQ
        ==
X-ME-Sender: <xms:Q37nXnspyXxkNPYm6tm5koDQQiJpW6Xtn2wIXak_EylA0IhtlrXl1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeegtdefleeguddufeekvdefgeevkeeujefgieehfe
    euudegvdffveekleetkeetnecuffhomhgrihhnpehrvgguhhgrthdrtghomhdpkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Q37nXodHRQyZspcvqNlDBUZ0JJYXcK3k8RrOnXezQFOQHY7RSWsTxA>
    <xmx:Q37nXqwWl3EvjqG8WAeu-lbdDwU6cn87hLmfawuR8BWC0jFjj2g1Xg>
    <xmx:Q37nXmObJm_oKMHEjGN_tilaSlf_2cDBwbqxVulZtP9KUy9wQ12hbA>
    <xmx:Q37nXkJEoju3E886M47aN5V83iAko-U_UHXfALWS24YBAEAalO470n5Nyws>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7621A3060FE7;
        Mon, 15 Jun 2020 09:57:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Fix APIC page invalidation race" failed to apply to 4.19-stable tree
To:     eiichi.tsukata@nutanix.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:57:10 +0200
Message-ID: <1592229430199231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From e649b3f0188f8fd34dd0dde8d43fd3312b902fb2 Mon Sep 17 00:00:00 2001
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Date: Sat, 6 Jun 2020 13:26:27 +0900
Subject: [PATCH] KVM: x86: Fix APIC page invalidation race

Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried
to fix inappropriate APIC page invalidation by re-introducing arch
specific kvm_arch_mmu_notifier_invalidate_range() and calling it from
kvm_mmu_notifier_invalidate_range_start. However, the patch left a
possible race where the VMCS APIC address cache is updated *before*
it is unmapped:

  (Invalidator) kvm_mmu_notifier_invalidate_range_start()
  (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
  (KVM VCPU) vcpu_enter_guest()
  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
  (Invalidator) actually unmap page

Because of the above race, there can be a mismatch between the
host physical address stored in the APIC_ACCESS_PAGE VMCS field and
the host physical address stored in the EPT entry for the APIC GPA
(0xfee0000).  When this happens, the processor will not trap APIC
accesses, and will instead show the raw contents of the APIC-access page.
Because Windows OS periodically checks for unexpected modifications to
the LAPIC register, this will show up as a BSOD crash with BugCheck
CRITICAL_STRUCTURE_CORRUPTION (109) we are currently seeing in
https://bugzilla.redhat.com/show_bug.cgi?id=1751017.

The root cause of the issue is that kvm_arch_mmu_notifier_invalidate_range()
cannot guarantee that no additional references are taken to the pages in
the range before kvm_mmu_notifier_invalidate_range_end().  Fortunately,
this case is supported by the MMU notifier API, as documented in
include/linux/mmu_notifier.h:

	 * If the subsystem
         * can't guarantee that no additional references are taken to
         * the pages in the range, it has to implement the
         * invalidate_range() notifier to remove any references taken
         * after invalidate_range_start().

The fix therefore is to reload the APIC-access page field in the VMCS
from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

Cc: stable@vger.kernel.org
Fixes: b1394e745b94 ("KVM: x86: fix APIC page invalidation")
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=197951
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Message-Id: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c26dd1363151..24de847af52e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8270,9 +8270,8 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end,
-		bool blockable)
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end)
 {
 	unsigned long apic_address;
 
@@ -8283,8 +8282,6 @@ int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (start <= apic_address && apic_address < end)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
-
-	return 0;
 }
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d38d6b9c24be..e2f82131bb3e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1420,8 +1420,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable);
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4db151f6101e..7b6013f2ba19 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -155,10 +155,9 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
-__weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable)
+__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+						   unsigned long start, unsigned long end)
 {
-	return 0;
 }
 
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
@@ -384,6 +383,18 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
+static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
+					      struct mm_struct *mm,
+					      unsigned long start, unsigned long end)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -408,7 +419,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
-	int ret;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
@@ -425,14 +435,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-
-	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
-					range->end,
-					mmu_notifier_range_blockable(range));
-
 	srcu_read_unlock(&kvm->srcu, idx);
 
-	return ret;
+	return 0;
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -538,6 +543,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
+	.invalidate_range	= kvm_mmu_notifier_invalidate_range,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,

