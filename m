Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A03A5803
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhFMLni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:43:38 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48709 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLni (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:43:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CE32F10C0;
        Sun, 13 Jun 2021 07:41:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 13 Jun 2021 07:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AR1Q1t
        pKL7lF0zyQUA0W+Js1OcDT82BSKo+xrcFcYdg=; b=EkEgx2PK12m5Z72B4vr7ZT
        i5tDc4w59rAu4Eu/To/VOTq3eSxvOyIDAvL81TnWFrFL0kN+to7uLcloxEngYV89
        1lVCbY14/jt3YrN7p6n/XOiD3zlkjEY8xN2UHLvKWb70V8e3TyNd6GHBtED7l6K+
        sCNecOClWyFhwKHjephpPyG0Y7itiCQQKWPdTcc0ISoYqGQqK/Hn9PlzFvwX6+ME
        HQAda0pAdXpOXL8MkYP1ePIx9hAFbxUALBWDTdFKwpwy0L9fdibbLhua52/JyRt4
        b4GuP329U2Y9ImFCRiEungj91M02LdWUfXOUf9zc/vKA1jVda2TpADWL87UqRV9Q
        ==
X-ME-Sender: <xms:8O7FYDVL1EjMnTbV2KUiJUSxNfs5EOKmTaqTdeAn3RA2_YQVZQ81Kw>
    <xme:8O7FYLm_x1AQaqzu6fOwLxFairue6anUE_C-ev91FjBXaysm2FgqR8Y2DCznJYNz7
    5JgiTApv4kDxQ>
X-ME-Received: <xmr:8O7FYPYvOf9LwNjt0TaQ_wg3MK0R7xRvB6CPKE5UU3dsGxNKJizLK5b-MrQd7znBKp0UvDHf35eqys3dzmvdgtBWQ4ivRpwE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8O7FYOXbG9wIMsZvbD2dGceAkaG0SEXeMy6uz0JM405_MC5dh8OU4Q>
    <xmx:8O7FYNkizEguVZjZVW0-sPoQn_PhYIennrV-peVPMzu5zeDY-zx5VQ>
    <xmx:8O7FYLdoLDXgjYwe7bp1UdZ4RRL7IJOAvT5dVTCi6caD5Ue-rVRuGw>
    <xmx:8O7FYDiO3iBTDjG_gv71KAOXY1zYn1qhlms2-Hs0ScskOm7I_ChwBEt5muw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:41:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Unload MMU on guest TLB flush if TDP disabled to" failed to apply to 5.10-stable tree
To:     laijs@linux.alibaba.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:41:22 +0200
Message-ID: <162358448219252@kroah.com>
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
 

