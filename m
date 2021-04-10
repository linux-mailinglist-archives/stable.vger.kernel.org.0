Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB43035ADBC
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDJNmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:42:25 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59111 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234180AbhDJNmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:42:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C718819407C0;
        Sat, 10 Apr 2021 09:42:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fWgaHI
        KEgA3plQm+g6RlFywmHC1Y9FddKYJ7lWHGLzg=; b=bosuhGyiC4yI0A/+ZW1J8P
        NDrxeeqzGiYQG+ysiZzKEbi4yk6Xglxk9NoOuD65o/ChiCpjcSErhQLYBZ1jlJuY
        udMrOnMdIZvtT5JZbXG48o4l4hH/4IytBim5L5j/TdDNnYnHbQ7h2XPWD+7MIY9J
        VqbUVadizQe9lfEAfdiwFWTxqJFVwT0K/KGfKMY4yH4XKNikiKpSGwThPiF2onP1
        zjDyNKPkGE3s5jv22x6o0IJw4N84qoH8WxEr8TwsafhLqbqFUWyZRn7mN4JTqpNn
        KAMzuRo9Fel4O/SQvDBf5TPyebUQCyXrKOvxi9Bv29QodYF+OyYC6e6IJiX4PrHw
        ==
X-ME-Sender: <xms:MatxYFhiUmnCugW3xijqahSz-k3oEGR-Zqtu50mMdrWWn0basiuwXw>
    <xme:MatxYKALhR2EWguRoyEachXC9K83QCWKU4LKb8DcfG8wjLc5G0gQuPKD9k5DKFpjS
    Oz9yMVedSWQ7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MatxYFEL-IisGy0M3pRi_Zpgu31UPwp7vki1dB4FXW_AmHmm3e7SAQ>
    <xmx:MatxYKQDVx0wOpn5G6rFvSg0hC-JRQ1Msdxl1taF0jZEeujaopEIcw>
    <xmx:MatxYCypxXpKWGj_iWTfy4NmzEKrYd_n6c90cixZIunrxZ40hiWT5A>
    <xmx:MatxYHpfhVEggzd1Ttgt3f7eD2Prqtts5x9sJ7ABjfbdepDW6tWByA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14DB8108005F;
        Sat, 10 Apr 2021 09:42:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX" failed to apply to 5.11-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:42:06 +0200
Message-ID: <16180621264333@kroah.com>
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

