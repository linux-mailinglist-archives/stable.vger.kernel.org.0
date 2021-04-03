Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0C353310
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 10:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhDCIHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 04:07:31 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55029 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhDCIHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 04:07:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8DD8EE26;
        Sat,  3 Apr 2021 04:07:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 04:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hfQshv
        D04AB6CXLvhMP2M78cR4REXkec7oQ9j+df/Qg=; b=A8TCgb1UfLFjX4LTuJpKdP
        6q97hL7ZDUFm+XoxCWb8RZ90zym+M1kBuPioriZqlPKTysXrfL+hLgSevc822CJy
        IxDh7LSsKnRQng30YA2pyPZk7iSNgq+Jjkb0GyuYI4GrIoCoeIiNCJRlliBSfz7D
        ZwIgdZI7eDKTaXypPZEbRqK4YwT49xJ3kB5SaxKmC7WG1EXiGFsWZASWrNPGuSrU
        ovcwbA1Xicf19qrK2Y1ozhkqMS+UZlIE8EMS9cBq2dpgkshDPDflMqIN3JCk/Mdv
        nbyFbyYtWu7az6L7ymsSLs/m4VDsJ+FS5gjdOF63P+ROw8MMYF6vj8H1W8cBKdCw
        ==
X-ME-Sender: <xms:PiJoYIGTCf3ycVZElm7zxskOAp0bsLMYKIUWGLYRSPTbdpn3JS2T9g>
    <xme:PiJoYBXQe3h86L57aLBNfS0zyMZ_KPOkKdxYJToNcg5CNSl3ybf6Vlu3FkSmAmJGh
    4MvCP2NAvLCMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:PiJoYCLPZooGspqOA43p9ybGTFMXqmk90dSs3ohFEx-RKhyXLO_dqw>
    <xmx:PiJoYKEpGgD7CmWFC3JL09yU3hl3wGTw8LEHzPzYNuXjPRaXpVtmlg>
    <xmx:PiJoYOUjOseuP2DbMnaROgFZfZJeOwHSLnv9Y_P7sW4UTuj8TUUHzw>
    <xmx:PiJoYBdo1mFOsRT2qCznmowSVVnI-9tTOQb-ZB3Woz4E4Z1J5OWf0KzhW4Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D853924005B;
        Sat,  3 Apr 2021 04:07:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Ensure TLBs are flushed when yielding during" failed to apply to 5.10-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Apr 2021 10:07:16 +0200
Message-ID: <161743723620634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a835429cda91621fca915d80672a157b47738afb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Mar 2021 13:01:17 -0700
Subject: [PATCH] KVM: x86/mmu: Ensure TLBs are flushed when yielding during
 GFN range zap

When flushing a range of GFNs across multiple roots, ensure any pending
flush from a previous root is honored before yielding while walking the
tables of the current root.

Note, kvm_tdp_mmu_zap_gfn_range() now intentionally overwrites its local
"flush" with the result to avoid redundant flushes.  zap_gfn_range()
preserves and return the incoming "flush", unless of course the flush was
performed prior to yielding and no new flush was triggered.

Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
Cc: stable@vger.kernel.org
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210325200119.1359384-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d78915019b08..f80648ac1d15 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -86,7 +86,7 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -99,7 +99,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -678,20 +678,21 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
- * operation can cause a soft lockup.
+ * operation can cause a soft lockup.  Note, in some use cases a flush may be
+ * required by prior actions.  Ensure the pending flush is performed prior to
+ * yielding.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield)
+			  gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
 	struct tdp_iter iter;
-	bool flush_needed = false;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
-			flush_needed = false;
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -709,11 +710,11 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush_needed = true;
+		flush = true;
 	}
 
 	rcu_read_unlock();
-	return flush_needed;
+	return flush;
 }
 
 /*
@@ -728,7 +729,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush |= zap_gfn_range(kvm, root, start, end, true);
+		flush = zap_gfn_range(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -940,7 +941,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,

