Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C085353312
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 10:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhDCIH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 04:07:57 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:49235 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhDCIH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 04:07:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A3620EB1;
        Sat,  3 Apr 2021 04:07:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 04:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fWgaHI
        KEgA3plQm+g6RlFywmHC1Y9FddKYJ7lWHGLzg=; b=BqRDL9o/7mitNbYo8Vri8C
        SMl0sTUXoHgKXaGNW8QOvokQGwusHi8fhK1B/7Xo8Obl2WACha77LnQshPFAyOUw
        ujBntyKuwJmvf2aa5iCWe8NW0V/BcsvffZeThg+MK3R4rLJPbDNRxP+yKe1CjY0X
        L86WFaS6F7tQIW3AKjGosPV/9OeOsnuNiAowwVr4tV6ClLHADOp0w+AKHNB41MxE
        jD+SvhKd4mSHawlZ8v6XB8iBAgn/TzJR6eRFbmrwjm7INfoScyz5JSi1tNJ4jQ+R
        0T1PEKxs77a5b0puP6yUsATgE+feNlMQM9TU8hMwTFU9W25SvRyDjUWmUplFrCDw
        ==
X-ME-Sender: <xms:WSJoYLd9SNsU1XiVy0ycn3iYqv45Q-vSJiNj8auEwglF-V-0f2aEIQ>
    <xme:WSJoYBMNel0wqZX_U9fWX2gMbed4GM9YVqI6Y9k8ISK5HbwGJv9CmeB6DvnqUDLLp
    Ru52ncscXd4Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:WSJoYEj7mvPJC1un8pzHsy88u6utXhjJxCK302B1eeGoYE8sHBrbqQ>
    <xmx:WSJoYM8ZA1JatczhPJtLCwc0s71Ed42BBp4b4YGLp5d0jTA7edV1_g>
    <xmx:WSJoYHu7mT34Cxv6aZghdYHfHQkH_eEwEDBwrPK3o69Nx-pqAisdng>
    <xmx:WSJoYAXwr-YbJHOWFDCJiXCeLHgIDLbWSgTvmHaUgf3JVeNqhUjJZIr9SNs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE4E5240054;
        Sat,  3 Apr 2021 04:07:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX" failed to apply to 5.11-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Apr 2021 10:07:51 +0200
Message-ID: <1617437271212111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 048f49809c526348775425420fb5b8e84fd9a133 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Mar 2021 13:01:18 -0700
Subject: [PATCH] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX
 zapping

Honor the "flush needed" return from kvm_tdp_mmu_zap_gfn_range(), which
does the flush itself if and only if it yields (which it will never do in
this particular scenario), and otherwise expects the caller to do the
flush.  If pages are zapped from the TDP MMU but not the legacy MMU, then
no flush will occur.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210325200119.1359384-3-seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d75524bc8423..2705f9fa22b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5884,6 +5884,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	struct kvm_mmu_page *sp;
 	unsigned int ratio;
 	LIST_HEAD(invalid_list);
+	bool flush = false;
+	gfn_t gfn_end;
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
@@ -5905,19 +5907,20 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
-			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+			gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			cond_resched_rwlock_write(&kvm->mmu_lock);
+			flush = false;
 		}
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);

