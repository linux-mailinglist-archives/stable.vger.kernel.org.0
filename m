Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A51F9964
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgFON4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:56:30 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53655 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729977AbgFON41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:56:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 14B186BD;
        Mon, 15 Jun 2020 09:56:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=edky0O
        vejDKcogv73YF6M4/x4Xs4W0d8APm9VX2ZO4k=; b=cNi68eT5gYlLEwpWleCIZV
        twUMe95WkjOK5q2pLvbzxGUsQt85+l87Qi0AwLWYRfQyJM9/a36BN3ucSolh1vIk
        /buK7mZOjKjRi1klxka3pDMQTAopUAWnOhPv4zJ0HgeZ8iahb0rzSlwREr+VJdK2
        GiFGfRHogBUuURcfRDX4gl1cspdW12S6YU2eShysnABSsMUoo3rePu93IzrIHnjz
        rK6yMISBxcOWaQhxvnb2YrUOedRpmHYVDrNJks7eInOfgW6MLsSgAXyc7DGHmwqT
        5nwii0AwwAHAqVqvpidPCLrRUtnfKsnoE+VvOrO+Tk0S+gO8Y13b+4u/+wRn/EtQ
        ==
X-ME-Sender: <xms:B37nXgT3fYZSU2ZkJRvlbk_jV_tp9agKaLQdbBpETMUNY0ejxXVTBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:B37nXtzgNecQndhbeCNyIwgvtg5dOW_aJAjvjJijTsYajf6QopNjyw>
    <xmx:B37nXt29JuS4blSFg2zVBYzwnUTJvr3H-L6HqTF4ZPF2gn1EQ_C9qw>
    <xmx:B37nXkDRsuXcZhqTUrEsZ8dkWWuIAtKGCc4o5pYBPKwLkeQNuDIa1w>
    <xmx:B37nXjfTKtiEfK5dJMCHFW2XCN3ImBSY9shbI90i8DKCwENXWbXJD2DOMIY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34ADB3060FE7;
        Mon, 15 Jun 2020 09:56:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:56:04 +0200
Message-ID: <1592229364131214@kroah.com>
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

From 6129ed877d409037b79866327102c9dc59a302fe Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 27 May 2020 01:49:09 -0700
Subject: [PATCH] KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be
 generated

Set the mmio_value to '0' instead of simply clearing the present bit to
squash a benign warning in kvm_mmu_set_mmio_spte_mask() that complains
about the mmio_value overlapping the lower GFN mask on systems with 52
bits of PA space.

Opportunistically clean up the code and comments.

Cc: stable@vger.kernel.org
Fixes: d43e2675e96fc ("KVM: x86: only do L1TF workaround on affected processors")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200527084909.23492-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86619631ff6a..92d056954194 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6143,25 +6143,16 @@ static void kvm_set_mmio_spte_mask(void)
 	u64 mask;
 
 	/*
-	 * Set the reserved bits and the present bit of an paging-structure
-	 * entry to generate page fault with PFER.RSV = 1.
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
 	 */
-
-	/*
-	 * Mask the uppermost physical address bit, which would be reserved as
-	 * long as the supported physical address width is less than 52.
-	 */
-	mask = 1ull << 51;
-
-	/* Set the present bit. */
-	mask |= 1ull;
-
-	/*
-	 * If reserved bit is not supported, clear the present bit to disable
-	 * mmio page fault.
-	 */
-	if (shadow_phys_bits == 52)
-		mask &= ~1ull;
+	if (shadow_phys_bits < 52)
+		mask = BIT_ULL(51) | PT_PRESENT_MASK;
+	else
+		mask = 0;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }

