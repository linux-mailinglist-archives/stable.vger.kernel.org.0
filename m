Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA73A5802
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhFMLnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:43:35 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47141 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLne (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:43:34 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 6FD8D1094;
        Sun, 13 Jun 2021 07:41:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 13 Jun 2021 07:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MgAyrz
        kop60wAQz11N3/bSLpYPTq8kAP/7Q9WUcJowk=; b=bMU0RFAzBAWwTDI3cD0yUB
        3CLZ111Ktcb7jrVFiWanttZb1vDmDFY1yaDfzGkX8/fjbvAHwGKGxrsHcIHDP/rx
        de3aqhHkhZBzPvtcaoDEPk8hmPAx4NGCKXksXQLbTc4BN7NH8KdnD/FNxb2U4PIr
        dnoEU8VCf3jihsMJkgUWXVplM/BTdjq3sqLxHy2b9GWmixm+9Uk1C1IQU8LZAsTd
        DI/XDcGRdPs0FsK/WGjQdErrHBkmz6Tub8M9A9TQPB8yYl08IDWzakeU9hlo5r23
        Esy1A+8MNZgxiO76ZaPcLxbkevNvqy2BELR5qwwvzsFk4erJGYZhFvRo6HkwyzcQ
        ==
X-ME-Sender: <xms:7O7FYOERYdcM_crHxW-qEU5B9HY6R6fVEAL6gApkdN65JUf4sOoGDg>
    <xme:7O7FYPXexstS0xEm6kPmO_IvClpNW5NQt_fYBIByEjsEUjxPv2Ufmx-XcAki6yOYl
    Vn6b-h2l8AtQA>
X-ME-Received: <xmr:7O7FYIJkOWf43fBDAD6Qq1mzsLbruAbO_RLfuWdlX_rt56ZtvNGgl3AQ_m8Q8P8gb3sweRoTF8oRKTxZic1ud_u5gzL-WmJE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7O7FYIEDeCxR58Q3y6ugYfv26hRThbc036CQpMG4KXOmmLlepg3DVQ>
    <xmx:7O7FYEUobxemP0t5X2v06BaVQsU2NelDU8x-lD_SvVqBi4E4IkWDVA>
    <xmx:7O7FYLO_BE-wTS-3pVEuiGFbvQMrijIR6u20zmd9mgGtYM0Egfq4gg>
    <xmx:7e7FYLRINOo60lUQeEP_nzGOD9F0BEnBejgNcAqAAZ6GqwcsbyN2OetBj9Y>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:41:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Unload MMU on guest TLB flush if TDP disabled to" failed to apply to 5.4-stable tree
To:     laijs@linux.alibaba.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:41:21 +0200
Message-ID: <1623584481239144@kroah.com>
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

From b53e84eed08b88fd3ff59e5c2a7f1a69d4004e32 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Tue, 1 Jun 2021 01:22:56 +0800
Subject: [PATCH] KVM: x86: Unload MMU on guest TLB flush if TDP disabled to
 force MMU sync

When using shadow paging, unload the guest MMU when emulating a guest TLB
flush to ensure all roots are synchronized.  From the guest's perspective,
flushing the TLB ensures any and all modifications to its PTEs will be
recognized by the CPU.

Note, unloading the MMU is overkill, but is done to mirror KVM's existing
handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
can be done to more precisely synchronize roots when servicing a guest
TLB flush.

If TDP is enabled, synchronizing the MMU is unnecessary even if nested
TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
TDP mappings.  For EPT, an explicit INVEPT is required to invalidate
guest-physical mappings; for NPT, guest mappings are always tagged with
an ASID and thus can only be invalidated via the VMCB's ASID control.

This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB.
It was only recently exposed after Linux guests stopped flushing the
local CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
"x86/mm/tlb: Flush remote and local TLBs concurrently"), but is also
visible in Windows 10 guests.

Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: massaged comment and changelog]
Message-Id: <20210531172256.2908-1-jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e2144eedaf79..9dd23bdfc6cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3072,6 +3072,19 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
+
+	if (!tdp_enabled) {
+               /*
+		 * A TLB flush on behalf of the guest is equivalent to
+		 * INVPCID(all), toggling CR4.PGE, etc., which requires
+		 * a forced sync of the shadow page tables.  Unload the
+		 * entire MMU here and the subsequent load will sync the
+		 * shadow page tables, and also flush the TLB.
+		 */
+		kvm_mmu_unload(vcpu);
+		return;
+	}
+
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 

