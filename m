Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1974C3C3C7C
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKMoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:44:11 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46949 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:44:11 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 8843D1AC0DBA;
        Sun, 11 Jul 2021 08:41:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 11 Jul 2021 08:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Blnrw7
        XHuLHp9EBW7X1I50vtyk2xaYmMvIDLLCS9Oto=; b=flohmrf+6xGG/D2ftqdaOz
        yc5qcpT6wR3vFDl2JsCPucKUZNJjZd5Anc/uCk8L8YOEHvn7x7S72iRGhaWOQOte
        s5+teZ55T9cikGWkkkp6ioygWTDKCkbXNMRMr8l3aRINgSShMxnv9yLN90ilJW55
        /mutgOWfJn1ikHwsoi/XwIWHf5Fzp+IbkmjGkbhw8r70CZJa9oLXZSO2UWvRtCWt
        6odf6ciDxT58Be8l6E7GFKNmrrP3rM5EdzkgOiEpRv/RkR/lWurkh+ybKBpdBFwv
        sofB3zCzFpEhhom5M2N9mayHGRJL0qT0j28fPKgkLUhn2L3ZPAHIV1AB18OrwQxQ
        ==
X-ME-Sender: <xms:8-bqYD5t-NKcD-ujIbhNPJWEZpXyfbnMUhRKr4eKs2v1zqeHfcGXXw>
    <xme:8-bqYI5TCsfrtbXFAF6PphIMf-Yk-AAbbXcUtnySIm7O_cMpb0QaEKLnniAtL4Dzb
    M0sQ9_es7ROEw>
X-ME-Received: <xmr:8-bqYKd_vyj313gkLHpbdfZVYptmW1h-_pqEZtZE9X7WHcSsdj9aY3Cri3xOQOya-j4LEurxI4rII1WHaa6AnJOVfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8-bqYELQECuKKYiu_D6q_skxbKZBGBXYhCJLgd_YEXTFPAl4ZNFA3g>
    <xmx:8-bqYHK8X-YKV_69-M_tiaBypCtrl7NiMaoFT3CqYPekUbVbhQueIA>
    <xmx:8-bqYNxEEDCcmAM5ssumEocWuppFM00vnE-7OQlwMyFoYQB3gRQfuQ>
    <xmx:9ObqYNjhZDGFxd4AcQrJhiRGm3wL4KoxSzSGDWEV0iUEjqjLdT-xNmlJoDU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in" failed to apply to 4.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:41:22 +0200
Message-ID: <162600728245242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ef318b9edf66a082f23d00d79b70c17b4c055a26 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 22 Jun 2021 10:56:49 -0700
Subject: [PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in
 nested NPT walk

Use the MMU's role to get its effective SMEP value when injecting a fault
into the guest.  When walking L1's (nested) NPT while L2 is active, vCPU
state will reflect L2, whereas NPT uses the host's (L1 in this case) CR0,
CR4, EFER, etc...  If L1 and L2 have different settings for SMEP and
L1 does not have EFER.NX=1, this can result in an incorrect PFEC.FETCH
when injecting #NPF.

Fixes: e57d4a356ad3 ("KVM: Add instruction fetch checking when walking guest page table")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 823a5919f9fa..52fffd68b522 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -471,8 +471,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 error:
 	errcode |= write_fault | user_fault;
-	if (fetch_fault && (mmu->nx ||
-			    kvm_read_cr4_bits(vcpu, X86_CR4_SMEP)))
+	if (fetch_fault && (mmu->nx || mmu->mmu_role.ext.cr4_smep))
 		errcode |= PFERR_FETCH_MASK;
 
 	walker->fault.vector = PF_VECTOR;

