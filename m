Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7270737BAD9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELKkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:11 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51845 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 612901264;
        Wed, 12 May 2021 06:39:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eKbWmG
        O1jBvQu99c9/XS/2j0y90qnl78ssMYrQ0luZI=; b=dR3nS/R/wqOCJv8zsE6wnh
        n63q889qthYCNiDnw9nFBDeku+K8PhFyn4sTrEZFNeH90S1B+fX310K5dU+veYLI
        HoaThwLSOmfppfGh9tQD1R0vIA1xN4h6SGXUVhMTEUblhsv8cqDLNHOUAIjnbxCL
        VPYkzyU1ZBuqb4dNV+R1YNVM1JlEvXPO9djngXx0dciDVYOPiksGHMmUqKtSIvwC
        Lz8K9PDHxghnz3KoH/2wOTXbiiaTcWpvgFRV1pBT6ed4PglDv2fr/h0PiI7XMqu4
        6RS7mMKEz0xl7M1HnJAWIItM4P/Xz6F9TkPKglEkba4DFy5bICE1UUPm+iTwMgog
        ==
X-ME-Sender: <xms:RbCbYDFceBpyXEmNeibo_MGgzXiS1b9kfmI-CVXFYIr0GukKVnC_Lg>
    <xme:RbCbYAVjNSvZ8RVLmX-viwG8zQk8JWzK3XR6yx8bWvUUq-aZ3xqiMFp5Xf75pCXBe
    J2QxXNzZ8ftUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:RbCbYFL_rfI0l35U0-m_GNUQpaIlbLyCr1IqG9QdfKvax9JrNNTsDA>
    <xmx:RbCbYBHO9Gdd2GnQCEwlfYwNh8Z514mG5cmxgqGrMAd1tJEujmqziA>
    <xmx:RbCbYJXHTiZxhMyFvISBSOjjk_i422HV5EmLm6WVQ9l4OowFRPKJqA>
    <xmx:RrCbYKf0KFcQLF-C9g7gxWxEdqRbDp5jLY65sJh8WPKZBukBx91rvnGI2Eg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:38:45 +0200
Message-ID: <162081592520882@kroah.com>
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

From 886bbcc7a523b8d4fac60f1015d2e0fcad50db82 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:21 -0700
Subject: [PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode

Check CR3 for an invalid GPA even if the vCPU isn't in long mode.  For
bigger emulation flows, notably RSM, the vCPU mode may not be accurate
if CR0/CR4 are loaded after CR3.  For MOV CR3 and similar flows, the
caller is responsible for truncating the value.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c9c9592a437..3010284dc59b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1077,10 +1077,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu) && kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	/*
+	 * Do not condition the GPA check on long mode, this helper is used to
+	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
+	 * the current vCPU mode is accurate.
+	 */
+	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
-	else if (is_pae_paging(vcpu) &&
-		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+
+	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);

