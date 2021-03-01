Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6735F327FB1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhCANil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:38:41 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48427 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235871AbhCANik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:38:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id F23C81941F95;
        Mon,  1 Mar 2021 08:37:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aGapSh
        rvcSyCSKbz8uruCATiFA3LE8F7yRoqj3JbZ1c=; b=CTu1j4iOXS/DpNLclr9ux4
        D6MfkPxiSDkHqGzYZtx0nPWrpNfIOAdz6lsuP5/7W3WUtH0RqLCOPzcCkhYI60LP
        wXOuvuczaLMikSBahoATEgMk/62LfksWMnfLahQxpbQXcyxTg9adwJ7vusc4oHd4
        AWKIqBkLo39ng8KpABn/iorkZALrXGGao2lvJ9XmamTyb3G/9ZW8soyr1eYL4zL5
        /KOrUBxX11fMnJjS/K68ImYQ8e3lMmm+ezn6APUmCnaJe1vtVNbzvVINcr8K/NKj
        cOmQWbHVxtfxFR8TWudj73VC2qU8QJ/l6R6yfYSdrQfuY0NRIpmAlnmojzFWScMQ
        ==
X-ME-Sender: <xms:He48YMauiRQN-RN3Og8qKpJMyYdSiv3-Mk60ABuuvBjdt0f3Ob-KWA>
    <xme:He48YHZqI4wHjafwQTjtdhRL5oWzhKPUwP6rN0OkAC3386lRrwLslF13VTHtCj0QS
    0LVdNHk1pPeOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:He48YG-w4uz646C_u0SRcwjPWkz-pHogH8gSI6B_nf9ZF_gRx7sWEw>
    <xmx:He48YGpFQLS4aUD-4bMrFRiBLF1umaYt_D06vRhClZBqxKcGVYwaBQ>
    <xmx:He48YHqOtqOUuT0ICLPJythJgJZQuR1cQgQY9UaPryTltTeZT2GJCg>
    <xmx:He48YGTMJe7xqwRfB8ZDDyUW1Z6KR_LDsOnn2kUPmUR5ubOrTN0H6w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 774C9240054;
        Mon,  1 Mar 2021 08:37:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] um: mm: check more comprehensively for stub changes" failed to apply to 4.9-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:37:22 +0100
Message-ID: <161460584290137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

