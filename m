Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4FE10080E
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:22:44 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57107 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfKRPWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:22:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DFF796AC;
        Mon, 18 Nov 2019 10:22:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=k060ZI
        21SV8knSM2fblN7/7meobiyWVh4MEgBU+On3A=; b=Uxnu+BZur2R+M9e8fv7c+q
        kzMd+IF9dHB+Ku9Za0xdou6X8yuvoql1NXsq4KkZb/pUQ/HdwZW7bv2EDRr+FeVw
        AuV8FY2buzpyHEQg3UyqR4xCKsgYr6df8KL28y2l/0b9+zEu+YdXnktUPGTr6GG7
        8ZCFjlPwlAREv+OqM/BzrUzY5JnHEpqbPFFT2+e1/hfmXRjw9uKP/qYXMr4pXF1Y
        6sYdHtBGcw+Td2dA4vMmP3W/caLqs6PdJeDHYF4INPXRMhwuk1gTQIRFMHDSPG09
        8UIS4FDfjkrQEDKoYC/CBROkgnkdNvx50GYwpmVTESLI8GUqkuUkHuzUBX5sdgGQ
        ==
X-ME-Sender: <xms:QrfSXRhpE9QtZXS65eraImIJMYQzh0l2b25n_nuxFdciVEaOL1oK0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:QrfSXftcIWWWejZcGsNQkCtFXWbUB_uIXrqB8x1NKD3KnbIi_O6dIA>
    <xmx:QrfSXYD4miVuUVlJFQ2fBSscWyia-po8ubG9KKv2SCV7ps1VtU0lEA>
    <xmx:QrfSXaXrdvhfr3usbaf4H1Y_H0-PZJhvWF75uFYhoAoW3sUpsuKF-g>
    <xmx:QrfSXZCktLUl73hlRCPeV9pInmjuuEoru0Du3voniZhV9HZu3nDyuA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C456C3060064;
        Mon, 18 Nov 2019 10:22:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, dan.j.williams@intel.com,
        david@redhat.com, kilobyte@angband.pl, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:22:40 +0100
Message-ID: <1574090560219@kroah.com>
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

From a78986aae9b2988f8493f9f65a587ee433e83bc3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 11 Nov 2019 14:12:27 -0800
Subject: [PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
pages, e.g. put pages grabbed via gup().  But for flows such as setting
A/D bits or shifting refcounts for transparent huge pages, KVM needs to
to avoid processing ZONE_DEVICE pages as the flows in question lack the
underlying machinery for proper handling of ZONE_DEVICE pages.

This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
when running a KVM guest backed with /dev/dax memory, as KVM straight up
doesn't put any references to ZONE_DEVICE pages acquired by gup().

Note, Dan Williams proposed an alternative solution of doing put_page()
on ZONE_DEVICE pages immediately after gup() in order to simplify the
auditing needed to ensure is_zone_device_page() is called if and only if
the backing device is pinned (via gup()).  But that approach would break
kvm_vcpu_{un}map() as KVM requires the page to be pinned from map() 'til
unmap() when accessing guest memory, unlike KVM's secondary MMU, which
coordinates with mmu_notifier invalidations to avoid creating stale
page references, i.e. doesn't rely on pages being pinned.

[*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl

Reported-by: Adam Borowski <kilobyte@angband.pl>
Analyzed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..bf82b1f2e834 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    level == PT_PAGE_TABLE_LEVEL &&
+	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
@@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct &&
-			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompoundMap(pfn_to_page(pfn))) {
+		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		    !kvm_is_zone_device_pfn(pfn) &&
+		    PageTransCompoundMap(pfn_to_page(pfn))) {
 			pte_list_remove(rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..290dbe353a47 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e7a07132cd7f..0dac149ead16 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -149,10 +149,30 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	return 0;
 }
 
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
+{
+	/*
+	 * The metadata used by is_zone_device_page() to determine whether or
+	 * not a page is ZONE_DEVICE is guaranteed to be valid if and only if
+	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
+	 * page_count() is zero to help detect bad usage of this helper.
+	 */
+	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+		return false;
+
+	return is_zone_device_page(pfn_to_page(pfn));
+}
+
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 {
+	/*
+	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
+	 * perspective they are "normal" pages, albeit with slightly different
+	 * usage rules.
+	 */
 	if (pfn_valid(pfn))
-		return PageReserved(pfn_to_page(pfn));
+		return PageReserved(pfn_to_page(pfn)) &&
+		       !kvm_is_zone_device_pfn(pfn);
 
 	return true;
 }
@@ -1857,7 +1877,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn)) {
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		SetPageDirty(page);
@@ -1867,7 +1887,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);

