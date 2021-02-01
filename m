Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A27630A7DA
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBAMml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:42:41 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:55465 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231378AbhBAMmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:42:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 71CCB30B;
        Mon,  1 Feb 2021 07:41:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=10vbjE
        Fu5Jfjd4rJPgLm4l6UIY3ioy1ikHg8FCmiBwc=; b=nB9tpLx/wGWVvg2bgj7Dzt
        XEGqQchAik/Wa8qnrQsuU2pL/Ud5B7tPfURGM7jjQm6+l0kYduM0qPiA3Kp+3GCE
        ytFPXV9GftBpeGJhoSTAQGz6NDIyKzYS5rx6HN+PyrVhtxZ7I+dA6A2cdW1mBQXY
        WFGvS89VTJz7bZSxGvlwHWx2+WO7Xa/9PX7rm8rYQGO/04F1ayzotNjFpqGL/cII
        80l7c4+TbNNZ5Ij38q+pS1wdqax/zjiSWQdzp8+erLwBQ+dXvETuTtuSlidPRc2i
        1ZAcKzPrR5KR3QnbuYAx3ahmgorQdn0/cREZ5mn8gp8+BISvs/W23I9HeotZKu9Q
        ==
X-ME-Sender: <xms:_PYXYLh27C7YbT7gfWNmmIAJvp8SGxH4cDYuV2_h7WWrZrX0XA6Kcw>
    <xme:_PYXYID47baiNJCBVI4WhXNRNdA2dLMIGth7XpqlNjE_8SFp8m3iD9lbD_2YmccA-
    G8jJkmQC2hVxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:_PYXYLEm9r21-fN86fMgfKbAxNNPvDSfM6tpjbdNOXHGw6pCompK4Q>
    <xmx:_PYXYITroHZtt_OfwqOVieK_zhLkVUzvl32tgdjVQ8c_M98EH0KszA>
    <xmx:_PYXYIyjEOi53le6AJi3Q_w0u3cuFFHIaxXrPZX7aS8l7WhDC7ZM8w>
    <xmx:_fYXYFpjcF45YI8TJnInOJZxrLOrg0YtvsEgDEzeL5d3R4jl8ZJZpYwhbz4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D391240062;
        Mon,  1 Feb 2021 07:41:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Forbid the use of tagged userspace addresses for" failed to apply to 5.4-stable tree
To:     maz@kernel.org, catalin.marinas@arm.com, rick.p.edgecombe@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:41:29 +0100
Message-ID: <16121832895919@kroah.com>
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

