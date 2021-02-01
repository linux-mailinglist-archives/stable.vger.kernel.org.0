Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2628730A7DC
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhBAMmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:42:55 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:59169 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhBAMmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:42:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7DB195F9;
        Mon,  1 Feb 2021 07:41:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lktYG4
        TiS10txvFwgy5p9mkxgFVP01mMer416U9oQm8=; b=NSnXJhUgPJXMkNlxep5/jK
        0cr6l5UiLWjhHpqM6z4dDVTtpnxVnk0OdFHAIkOlnejfXrUga8hMfLx2Vi5S5tv1
        1Wr3CL85RyuKT+pAfui+mq+3fM6bFefCcmCNF4fOpXbLLCYmOuWhdbfmDCnfVbY1
        WJtVUmGWWIKTnwkPMjdEB7Y1avS81rs2QscLOcWpPbbUCjoIj7K5jg/Dmomxpv8C
        fz4tFKay0+0YzIkv8Y1bZmEXv0OF7eyurxTenoZ6ehfb+ZV+4b/D2Q3KwUjuOyVT
        vtrcl6FSEhfnAYsmTrCDGTTinVnIRBeunYpmCcuwaeh4HRZ4amGI0JtVh4eWKxdA
        ==
X-ME-Sender: <xms:BvcXYNAHXWnGeTr4GJ_pP4UGiKnqt5TSigRJoEiBtsQjAesjytMG4A>
    <xme:BvcXYLhPV03QqXDQbS4cCW4fYfXs3JO2tfiGw2LVa5gqsopZxDtxtzCRj9c0tiNYm
    fVXjW7Kn07gDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:BvcXYImZzGQSdTXiX8VXcz7wevT_CzhVbD_8-4DvTzTYA15_wDL_MQ>
    <xmx:BvcXYHzhPVqEgK1OdJe5Tm17J5DxXHjEW2iiHfQwop6jFX_BDHmZ3Q>
    <xmx:BvcXYCQugqejkS3d16gI2jke9TjnceHXqT2hK5Df9t4jF6HX1XpEiw>
    <xmx:BvcXYFIgScfDXTVNK4XA7nIoSh_CE9zmvyE8aPSSS6FQ6EmGqKBTOipsdYE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABD3024005E;
        Mon,  1 Feb 2021 07:41:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Forbid the use of tagged userspace addresses for" failed to apply to 4.4-stable tree
To:     maz@kernel.org, catalin.marinas@arm.com, rick.p.edgecombe@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:41:30 +0100
Message-ID: <161218329038111@kroah.com>
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

From 139bc8a6146d92822c866cf2fd410159c56b3648 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 21 Jan 2021 12:08:15 +0000
Subject: [PATCH] KVM: Forbid the use of tagged userspace addresses for
 memslots

The use of a tagged address could be pretty confusing for the
whole memslot infrastructure as well as the MMU notifiers.

Forbid it altogether, as it never quite worked the first place.

Cc: stable@vger.kernel.org
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4e5316ed10e9..c347b7083abf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1269,6 +1269,9 @@ field userspace_addr, which must point at user addressable memory for
 the entire memory slot size.  Any object may back this memory, including
 anonymous memory, ordinary files, and hugetlbfs.
 
+On architectures that support a form of address tagging, userspace_addr must
+be an untagged address.
+
 It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..a9abaf5f8e53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1290,6 +1290,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	/* We can read the guest memory with __xxx_user() later on. */
 	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size))
 		return -EINVAL;

