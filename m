Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849CF3C3C80
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGKMoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:44:23 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52195 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:44:23 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 7A2B61AC0F9A;
        Sun, 11 Jul 2021 08:41:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 11 Jul 2021 08:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=e4IwTU
        WgchkCUMIyTw+pkWnEGuNhic0Sdk952oSnBUg=; b=kHAlse9KmoffiM7zN/qk0x
        4zi/hzOmrKwhA3K0mMKHtep4Ql2IXkrIkHbVcQPA7YZjJEa8NSWsAevJYOpmBq8n
        uMEiiLtAUkly5KWFVdZK8Qo4Pn1P/Y6Rok5ttcIj8g5B6OM2DF+/kkEGAEp2hci4
        oZZ1/4be1TTjPC/MWZqed36oT8nReSj77jXWrLkOv3aOjiEkAGRYBGW4l8OCkNp4
        GIiaBn3vq5yyh4XSGGQbub5hoqM88rs1DVjjM0hlKx2BZTnObdQKCwhdEoCKahb7
        ztVsBxDysZF2j7WWktYxHl1Id/vbxUhegIqJpGhuE02dmspRpYVdlNtbBM7PbDNw
        ==
X-ME-Sender: <xms:AOfqYHN9f7Tw6iXRK1X-jJpVWP7m89zGcewtQlV3AdSNgT0qVRi_qw>
    <xme:AOfqYB_Y9wxsJjoTyQt83pP2rFq2TrhLSs3foW9oAMHSHAbz-zEF8k-sfD5rkHL42
    9SoNG8mnI51NQ>
X-ME-Received: <xmr:AOfqYGQ3p0cXWnmprw6EW8_tQ8aM5gpiLKodfM2mDSqj-G2BR1XIFfcduPQD6uPFjA8D18QlFDUN4UFqB6Dq40eTnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AOfqYLvZCcutk-Q1qRDvR2KhAR2YlRFFd8V5V9xyFor0Y1kCt4yf7w>
    <xmx:AOfqYPd6d2thQAf1MxgdcdJcdrVMYkZIzz_7uB9Co-ecextOYP9qsw>
    <xmx:AOfqYH3h8yhieHqNJt_jnTv7a5UicqewLvxeaoPnAig9vWVHFZSxjw>
    <xmx:AOfqYHFB3gKFAZXWFPr9DjF1fjvN2dSmmJeVlVrfz3Do8WnEA3mmblv8hAg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:41:34 +0200
Message-ID: <1626007294131216@kroah.com>
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

