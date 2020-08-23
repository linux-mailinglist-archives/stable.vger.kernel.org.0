Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D8624ED32
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgHWM1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:27:03 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35235 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgHWM06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:26:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6E165194115D;
        Sun, 23 Aug 2020 08:26:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KmyKeL
        gn7sCkY/Mog5Bn+Hsg9qRZXTg27+C4mgfyrec=; b=QKX+nyurc/fvyaKEwpWDWe
        +LcgRH8qoH/JoBFWIzyvqFSbJpCZwJb9LvDV9J1HJoC5jwloAtIzyISSSl2DsV+C
        dN1WYhaOe6LoZC0n0xFTlsZzu3IWwdbR80QPxzmbEK1y3/8G4y0uYZDS1bsnCHy1
        fzaZ86iRRf1ju+ImhRtU7f1ESRO3OVSS81b/Z9OZM4qFeoydLO5CwsDoMCJCyWGR
        qacpo3opflj24nbZYgXYJacFKUEjcFo89mU2TX9jtxdGh/rL1I4/ctagnUIrfuoO
        iWoqZqHkc7OezGIQngIymX3AO+mNTSFVylDVkV+BDcXHSQ2KnDEKfGjq97IsD5TA
        ==
X-ME-Sender: <xms:kGBCX10uNYmHC2EkWKu1jEnFdrkynoFzXS4Pzzjn72ngQkXwh_LBwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:kGBCX8Fn_t4YDIcpwcGccwTlmLJjvXHO6uO7mHUmBmeBn8YmrlHEDQ>
    <xmx:kGBCX17r1X6DXP2TkLrX-bmATU5iiI0wSvZqsKN-Xp02eM0fL-8Vxw>
    <xmx:kGBCXy0XF_azsHShCbm6AlEGKI0uF5LflJjL6kycKtjqieFNnbTl8Q>
    <xmx:kGBCX9RM-TRzWMC1EMpHsg72q4okTAMbrolstxkhdpdKcjZKZiB_Ww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10B053280059;
        Sun, 23 Aug 2020 08:26:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE" failed to apply to 4.4-stable tree
To:     will@kernel.org, james.morse@arm.com, maz@kernel.org,
        pbonzini@redhat.com, stable@vger.kernel.org, suzuki.poulose@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:27:12 +0200
Message-ID: <159818563224179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5331379bc62611d1026173a09c73573384201d9 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Tue, 11 Aug 2020 11:27:25 +0100
Subject: [PATCH] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE
 is not set

When an MMU notifier call results in unmapping a range that spans multiple
PGDs, we end up calling into cond_resched_lock() when crossing a PGD boundary,
since this avoids running into RCU stalls during VM teardown. Unfortunately,
if the VM is destroyed as a result of OOM, then blocking is not permitted
and the call to the scheduler triggers the following BUG():

 | BUG: sleeping function called from invalid context at arch/arm64/kvm/mmu.c:394
 | in_atomic(): 1, irqs_disabled(): 0, non_block: 1, pid: 36, name: oom_reaper
 | INFO: lockdep is turned off.
 | CPU: 3 PID: 36 Comm: oom_reaper Not tainted 5.8.0 #1
 | Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 | Call trace:
 |  dump_backtrace+0x0/0x284
 |  show_stack+0x1c/0x28
 |  dump_stack+0xf0/0x1a4
 |  ___might_sleep+0x2bc/0x2cc
 |  unmap_stage2_range+0x160/0x1ac
 |  kvm_unmap_hva_range+0x1a0/0x1c8
 |  kvm_mmu_notifier_invalidate_range_start+0x8c/0xf8
 |  __mmu_notifier_invalidate_range_start+0x218/0x31c
 |  mmu_notifier_invalidate_range_start_nonblock+0x78/0xb0
 |  __oom_reap_task_mm+0x128/0x268
 |  oom_reap_task+0xac/0x298
 |  oom_reaper+0x178/0x17c
 |  kthread+0x1e4/0x1fc
 |  ret_from_fork+0x10/0x30

Use the new 'flags' argument to kvm_unmap_hva_range() to ensure that we
only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is set in the notifier
flags.

Cc: <stable@vger.kernel.org>
Fixes: 8b3405e345b5 ("kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd")
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20200811102725.7121-3-will@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dc351802ff18..ba00bcc0c884 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -343,7 +343,8 @@ static void unmap_stage2_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
+				 bool may_block)
 {
 	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
@@ -369,11 +370,16 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
 		 */
-		if (next != end)
+		if (may_block && next != end)
 			cond_resched_lock(&kvm->mmu_lock);
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+{
+	__unmap_stage2_range(mmu, start, size, true);
+}
+
 static void stage2_flush_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 			      phys_addr_t addr, phys_addr_t end)
 {
@@ -2208,7 +2214,10 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	unsigned flags = *(unsigned *)data;
+	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
+
+	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
 	return 0;
 }
 
@@ -2219,7 +2228,7 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 		return 0;
 
 	trace_kvm_unmap_hva_range(start, end);
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
+	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
 	return 0;
 }
 

