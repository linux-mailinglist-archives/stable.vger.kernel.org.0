Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFD327FB2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbhCANio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:38:44 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48217 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235872AbhCANio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:38:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C55FF1941EDB;
        Mon,  1 Mar 2021 08:37:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WpKms/
        v9oCTDLK2PyV8rJmkj0MBVScLrOg1SANsFWOc=; b=hVXVO9VXYQshXzal6r4nnV
        9KrCOa2n4zYCtyWoKAR+7/MW/XI2NJ1maLZwknZ75oRlPyonb6eEYI3d6IaZxv2n
        qw3Y+Cuj3/xLdB2iHLJQPev3q4jvppnlieU1HJxsn5L790QMmsL0HP07iVhV616T
        3F1qgM6AuJoNBdmPvMzindKFj5cpu6p6UMWyyKLFFAwMMu1/ZSGLgOoN5Elt3BZH
        vvbEHIc9j3dKrOLy9dV3avmyU5ivvLMdmOpYD+5KS5IIjTqJwsbquo0dlH8e2YZl
        IvCpT1duFuFF56yRAmcFPwwqirhRPlLLDFwJS5TjkBvNGjFwhXac5dJmRG1nCJIA
        ==
X-ME-Sender: <xms:H-48YKiBuFLhh_r5ObDWWLp0uCwt-J6tGgwUa8yva-SvRRkxlusnZw>
    <xme:H-48YLBA4nvzTYHnfs1r6YPVym4ws6JBoMRhfSGTQnUQqWgFQ1Uy1lixcoalFcOWt
    ZErRyoiNE7Txg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:H-48YCEDFD-800Yj_14gMWhzsCSSV1w0Q1todAGaw58xFXYIEzlq-w>
    <xmx:H-48YDRnpJthv_Zj70rcLWV-86f9fFPbaxYkv5X5vXBr28HrqNXHHQ>
    <xmx:H-48YHxt7HFb51xw3IZJQfhTn_udyVNpSFUFiWXdhMYz6SfF8vtxDg>
    <xmx:IO48YFYDmKpUdkKESyQqt5GNiLrqqQ5XE5hn9P_5zt0DjJx997ER8Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B4E11080059;
        Mon,  1 Mar 2021 08:37:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] um: mm: check more comprehensively for stub changes" failed to apply to 4.19-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:37:23 +0100
Message-ID: <1614605843254157@kroah.com>
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

From 47da29763ec9a153b9b685bff9db659e4e09e494 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Wed, 13 Jan 2021 22:08:02 +0100
Subject: [PATCH] um: mm: check more comprehensively for stub changes

If userspace tries to change the stub, we need to kill it,
because otherwise it can escape the virtual machine. In a
few cases the stub checks weren't good, e.g. if userspace
just tries to

	mmap(0x100000 - 0x1000, 0x3000, ...)

it could succeed to get a new private/anonymous mapping
replacing the stubs. Fix this by checking everywhere, and
checking for _overlap_, not just direct changes.

Cc: stable@vger.kernel.org
Fixes: 3963333fe676 ("uml: cover stubs with a VMA")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 61776790cd67..89468da6bf88 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -125,6 +125,9 @@ static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
 	struct host_vm_op *last;
 	int fd = -1, ret = 0;
 
+	if (virt + len > STUB_START && virt < STUB_END)
+		return -EINVAL;
+
 	if (hvc->userspace)
 		fd = phys_mapping(phys, &offset);
 	else
@@ -162,7 +165,7 @@ static int add_munmap(unsigned long addr, unsigned long len,
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if ((addr >= STUB_START) && (addr < STUB_END))
+	if (addr + len > STUB_START && addr < STUB_END)
 		return -EINVAL;
 
 	if (hvc->index != 0) {
@@ -192,6 +195,9 @@ static int add_mprotect(unsigned long addr, unsigned long len,
 	struct host_vm_op *last;
 	int ret = 0;
 
+	if (addr + len > STUB_START && addr < STUB_END)
+		return -EINVAL;
+
 	if (hvc->index != 0) {
 		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MPROTECT) &&
@@ -472,6 +478,10 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
 	struct mm_id *mm_id;
 
 	address &= PAGE_MASK;
+
+	if (address >= STUB_START && address < STUB_END)
+		goto kill;
+
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
 		goto kill;

