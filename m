Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F113C3C7E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhGKMoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:44:17 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34257 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:44:17 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id A01FE1AC0F9A;
        Sun, 11 Jul 2021 08:41:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Eirjxl
        duXB0lGalwEPwwXrnbKrSkOsIFv1Tn3CA9LCc=; b=kBV5IBdysrtObiWLINowE5
        s47yVvZEsbgS/ZXpaw4l+kyA9bPM5wN5tRU0UfCaVl6TRXDueQatLBH6/a54X2Pf
        TVybIZr5MqIo85Dwv4cjvGtCN37WnG6MlFvv2OuVl0NzzBnt6LpP0Q1wXno1waXh
        j6ZkvvfuUdxY1RjVyK6/nbyqEITYT5J9UlNzHGGqph0w7mXzBHBLcD5zwFry0lM6
        ulea3dvYi6TdICaXZQ0bUvRX88Ahn6NGT3uqwhtnf7HNYNWf7NMN1aecvLceZE9M
        yL1w/1xTZAaYljOMUODRPOEKJ5sRh/q0hGiin/KXbN+n4bQcnfuj8eubwPonh6DA
        ==
X-ME-Sender: <xms:-ubqYMKI95Iymt72_O50bkdCFBqqCHQauwYN-Lb9C-yR2UcJFkDhfA>
    <xme:-ubqYMKiEY_5o9GfYHRABOpW0dhh6Z89HTTBAZcYqVoRLRuUDS5wbOOr_pTRvdc3F
    qj71wdIbO-wxg>
X-ME-Received: <xmr:-ubqYMvw9AA1ZArMQ7nbcInWMRfe7Y_QnKKyiGmPMjM8ZUIPDRaaqVLqMPIiB8C3w_C2oZmpyZYEDPFLne1818nMAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-ubqYJZUqMIm_n4ReZieP1goJjotvsWqyiV9TspgoSfm8tOVr5F01A>
    <xmx:-ubqYDaMNmgiaemG04aGRXqCB12Xf0Komo1THTERCOCqGTFBzRwYfw>
    <xmx:-ubqYFDT4PcsTDfUP0A2ZDsDW1Jx0LFLRsh9MAneLv_wie-4w-D8Sw>
    <xmx:-ubqYKwcQSNOkJpN78B2GmN0fyih_TQ7ycPHSMQtT9I6fWkdckhv_KvOQmA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:41:28 +0200
Message-ID: <162600728899105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

