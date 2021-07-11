Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A341C3C3C7F
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhGKMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:44:20 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40971 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:44:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id A07811AC0DBA;
        Sun, 11 Jul 2021 08:41:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0dXpik
        buZ7hcDriRAsZ90XIE9xxE8lyoetrz8HOLvWQ=; b=gT002RFSjnr8SnBycHj4sr
        YJJpsjti28AVkDxbhtFsp0LL2wV50nNgFbfhsaAC6u84olQVZcoV9mDuk/YfUhfd
        NAXX9qXVvwRiChVWCQ+Jsdq31ObvSUwGJP6jjgUgzGZn3EN72+BAQhZZ2X1z5Blb
        GEajrtxvgAkXiw3Y2RWkQdJ2T7LsLekQjQgvBs2y3B9pZwxl0Z6v2pJ0cKC3Tkpo
        O6Qs8PmiAJMj5x2ug2FXHACMOClHRZ+X9V59SioUw4CEQnri8G33vzr/I/qcBt46
        SIyVqxTGjOQwfd5SKK3T43XRo8HDx6/mLLw6ShnO6YavK2VBQ1lL4+1C0iSeHxVg
        ==
X-ME-Sender: <xms:_ObqYCYeImpV7Ibw0-U-65UF-FoF4A1tgkSRBaei-9Vm-CCXUEZShw>
    <xme:_ObqYFYWm967oDcgtkrNwNJC0ogqjEFOMJ5CP7w8cMffbQsL0rE_C8Wokyp3zIIw5
    9YktQ4eJ6s2sQ>
X-ME-Received: <xmr:_ObqYM8ewkBVkj0Ly-gb4UAa4BWtlGpEIciHQwo_15ZMnGzHWlp-4iaUKfgrNmOUqhEghreE1ovnKLIxDQr4mohKjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_ObqYEqEDCjHHSAA7E-aPLV1Teay3207lVYqwDBxVxf1Q4fE7lU0ag>
    <xmx:_ObqYNqTqqjiGo3s6N5XQMhc3DyT00CExiou2Gj5FQc9GgRsTpmImw>
    <xmx:_ObqYCRsVevhllieO-WSyLLIQAXbChu66HwOM1YZG5EYH0S0g9ckPA>
    <xmx:_ebqYOAO0B-zFq6ybzXC3xlm89t1dYXO33bqoxEN9UoaotH0OUSJ2uVXAfw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:41:31 +0200
Message-ID: <1626007291956@kroah.com>
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

