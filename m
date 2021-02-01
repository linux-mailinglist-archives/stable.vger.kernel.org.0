Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9965B30A7DD
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhBAMm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:42:56 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:32959 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231584AbhBAMmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:42:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 24F5960D;
        Mon,  1 Feb 2021 07:41:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jCpkIV
        I3Q43Xf/QtVaYM47jZsuKesbTjLTRuHlNesc4=; b=r2LllcE7JFttS35kSvn41x
        3IbsB+0TQi7kkBGY8RIqd1P/cAfDCY7A/8uL87N1d0GKMSq+rLsmEm7lStT8wo19
        7zDJ9u2Pyp03MM0Z4T0zqhxXT+ESoFH5GKWGM0nMZLwVhUiFZc7ucRhk6Ek7Nt4f
        elXB052EwgqBjfDxviz41LzI++V0x7Jr9fpHqEsmjuUMKWWAxx6nDiDq6nsQclXg
        97bFlYy8SaUDLibhqOKbA2k4s2ZlJs7cEGKQHV9GAZi6qAY12Yp8p9sv3fAJAFTH
        mZ878x79C25xKohU5IlgTg0Tc9AF87F3G6B8PrclaF50xhlcyidQhxoHVqGHedtA
        ==
X-ME-Sender: <xms:B_cXYAjpxj369LgZ7o2Z9pPOGLQB6DR4yCdoL9aE-ItdFWeft3qJqg>
    <xme:B_cXYNVTBmSbqM_GVCGN1VfDZYIoP_oFET4mfPBFEsFxrORC-HX8M5xi5bLr6EUQT
    7i_GYlh1ddGgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:B_cXYHPC8x8fimEWc_ZjD1G5Bn5Q8YSuqampRl_2TDzQtFWHnb640w>
    <xmx:B_cXYJYUU0l-9t4x_xvhUJKFUUt79JAeONuIos5gxh7kz-pQoMPdKw>
    <xmx:B_cXYDqQpB9merH7xzXgFZ702SSRnvCwY99ZYREkvGyAsyJTo-E7Bg>
    <xmx:B_cXYNbC8ZEeIBORye_nlsHZl-s6I9QrtfDsXKmRaAHgr_4qk910cAyUkDk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C818108005B;
        Mon,  1 Feb 2021 07:41:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Forbid the use of tagged userspace addresses for" failed to apply to 4.19-stable tree
To:     maz@kernel.org, catalin.marinas@arm.com, rick.p.edgecombe@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:41:30 +0100
Message-ID: <161218329021699@kroah.com>
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

