Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2C353311
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 10:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhDCIHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 04:07:55 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39411 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhDCIHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 04:07:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CD156E9E;
        Sat,  3 Apr 2021 04:07:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 04:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LRg+wN
        ghWvCLZEsWj18DaC2/rAi9MHo1RAI2O2d4RNg=; b=MEexKfprTPaAM1lnC87MNA
        +3sUFsmqtd2qlDFOLzwf7JRRvHk3zcF+5d5OURBSqkHUIWLb2Mmr5rQLncouwznt
        wEOyAWHbl3UlagmRMAKEw6BZ/rxdPMVf21Y+d558oU/wPbB/j/FM5BJyrqHZ/V9D
        gce9bPnKTtruq/FW1sYYUgSvf4Q7zRGT/AG28GLtOBEV8Aw1Tp7BjoOinkYEGr9j
        emP7fcQcRBVuShraicEHOFOvPEyzDKp3wrDohoyaaUmc/ED/QPVxDEZX2nOlN7JZ
        XvIss71+bsQqkz3WlWOzPGbcHeWpuk0MkCjcCQVvtd4+OtzJt5hlchUwkj+RUXsg
        ==
X-ME-Sender: <xms:VyJoYPd4eIqW7YUPctnFIsxkMetLgud9RAHv63IMzSvjuS50SOS7oQ>
    <xme:VyJoYFOHoy-CZ_qSb7W8DTPCIftriNqTT-SzM88y2qWQ_mZpJQukZSSK-aGrzQVp1
    Q5hQDZig6eHAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:VyJoYIiIGebKJrdngsvjjEJui-ZzJ8_p4szuMOVooLIM8mkKHCm4cA>
    <xmx:VyJoYA--zPvBRwZDBV6nUzRKPv-Ys-1obR_hwy_QKBFSOSYYnxOD9A>
    <xmx:VyJoYLsqBp11x0XvsUme0xiLSUaTyt9tkE_7D5rbIg9njvXqMqKBXA>
    <xmx:VyJoYEXc8YPFc1PsowWDtcpUyGoNIoz-dzgUa2f_Feebpl6Juw8dhbnfxks>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22B531080054;
        Sat,  3 Apr 2021 04:07:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX" failed to apply to 5.10-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Apr 2021 10:07:49 +0200
Message-ID: <1617437269138191@kroah.com>
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

