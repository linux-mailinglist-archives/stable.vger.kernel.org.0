Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A04A3A5801
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFMLn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:43:26 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39427 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:43:25 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 51721FCD;
        Sun, 13 Jun 2021 07:41:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 07:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KkxvND
        jg5w5QaX96eRsQI0cPZEmzNnk+VEEYNNbiqLE=; b=LVqHgwYLIj8OSD3VYOIHNH
        kqyznA69XgcjepCFpPIFrdQX91MunupPGi9zdHkkAmu82+ewsm0fv7tG3hWdRSu3
        RusZYb0CDXSFFM4M7c3ptGf+TnEEmpVgGrmQuKQB47LIhFsazQ92kQhSUgDQ7cJ9
        x5QjV3gGQDXvgDL3Vj1XXViJNqGpop/xOYfx27sfi16Vlj3zfjOxwAQu5Bc+tM28
        6xxJuay7RlimlMyEnnVICFXn2Zk/5meBAGu7Pe+FXLIbEz+8tDou3zRTcboeOSne
        WZcLFLSzedJA+lWUiAwRMcQSFhbUOPJ4Viu+Gzua0IDNTXc1VQZ7PB9qkVO7mimw
        ==
X-ME-Sender: <xms:4-7FYD7VUTIshIcii3tYIHOhlye0e30lOxR-BSg_jQJClShU1jmByQ>
    <xme:4-7FYI6bi5O_Yyz4MTCxsxKZrVBJlRhCrAzimsm-SkRAEPY4EZfkzaCa4G1bHw-it
    TX38I4qK3D0dQ>
X-ME-Received: <xmr:4-7FYKcne8L35DaLFXxYDYkuOvwnL6aHx45YMqqB8-SJdL57tzvcCJgPc9nP8aiYE9A038YHgdU5vcvcAP-5kF4hwhslutG0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4-7FYEJY5xgXrDJ747iYyaiTcu_L_f7lfg1XFKh9lrydYc1DGzDdvQ>
    <xmx:4-7FYHKk50jHsAS8okFL_IXTs8KAjn8ZOPJMKF8q3jgWX-0aq5qy7A>
    <xmx:4-7FYNwMXh4AkDclYI-klscyKC3qY0qDAE5VY4aVmezzQjnNkuIm2w>
    <xmx:4-7FYP2xkLm5gEZKQY1vfNKjiRKdY85Uj10V8tUDEI7W92QJcghfMifxupI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:41:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Unload MMU on guest TLB flush if TDP disabled to" failed to apply to 4.19-stable tree
To:     laijs@linux.alibaba.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:41:20 +0200
Message-ID: <16235844808926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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
 

