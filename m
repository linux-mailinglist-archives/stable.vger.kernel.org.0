Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07042141EC9
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgASPPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:15:02 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47331 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726860AbgASPPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:15:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4352F48C;
        Sun, 19 Jan 2020 10:15:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 10:15:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qj6S12
        LS6e6Hd6pB9UiyyiQwYjUKUYLqzIgtk6cnlcU=; b=KZEythjUxYmmg9Y9UqwUr7
        wde2thmFZT8WX9El3uzWZa8rptX0jCWhF+cqabCA6cNG3/kO+vCaH5VOI506xNtW
        GqQ9YDWvT72mCjhwk+P1h1WJUa6YHIkNSxsGVCyUNNQOO0bFOkpNceN2u33OfO/5
        mDDUWU0pFjf+fde2hsGxSEeVB/44fG3fo8LNyKRX5MikwpBfM1GxC20ZDO1jbH/k
        +tmLuIpN5uRGCj1e/aBmT0H+xxMFwNZLMcTDgznurnVp+u0/zh/1ybNBt0kY9ngV
        pJnm3uWmSCMwPnVufRHrjSOSwVw35mjwXGIvDEGV8KZGqijECAjt3J9Qt6ovS8Uw
        ==
X-ME-Sender: <xms:dHIkXj_z7g9pVGugWfdKm7gmdYq67xlZ3F6kAxx-If5IbxVdLuy-Sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvdeguddrudelje
    drieejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dHIkXhmUSrqYNHscnXWkoPVqlp8Tcs9hxbj7-MMXna5kPuZho0vArw>
    <xmx:dHIkXlrBm5LjWf5UT_yLIFW-xI-oCkEvrPLgYe4DgIFnmaQIa_dK3Q>
    <xmx:dHIkXt93aTpRACLSjpr9x2uLWfSTF1K8Gcq3pBwYrwqOqWDzeychOg>
    <xmx:dHIkXjql2KpZ36h_OunpZjfWCX_fPvX47ipseL10RI6nGwGHUwT4zA>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id BDE933060B12;
        Sun, 19 Jan 2020 10:14:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/huge_memory.c: thp: fix conflict of above-47bit hint" failed to apply to 4.14-stable tree
To:     kirill@shutemov.name, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com,
        kirill.shutemov@linux.intel.com, otto.g.bruggeman@intel.com,
        stable@vger.kernel.org, thomas.willhalm@intel.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 16:14:57 +0100
Message-ID: <157944689715736@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 97d3d0f9a1cf132c63c0b8b8bd497b8a56283dd9 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Mon, 13 Jan 2020 16:29:10 -0800
Subject: [PATCH] mm/huge_memory.c: thp: fix conflict of above-47bit hint
 address and PMD alignment

Patch series "Fix two above-47bit hint address vs.  THP bugs".

The two get_unmapped_area() implementations have to be fixed to provide
THP-friendly mappings if above-47bit hint address is specified.

This patch (of 2):

Filesystems use thp_get_unmapped_area() to provide THP-friendly
mappings.  For DAX in particular.

Normally, the kernel doesn't create userspace mappings above 47-bit,
even if the machine allows this (such as with 5-level paging on x86-64).
Not all user space is ready to handle wide addresses.  It's known that
at least some JIT compilers use higher bits in pointers to encode their
information.

Userspace can ask for allocation from full address space by specifying
hint address (with or without MAP_FIXED) above 47-bits.  If the
application doesn't need a particular address, but wants to allocate
from whole address space it can specify -1 as a hint address.

Unfortunately, this trick breaks thp_get_unmapped_area(): the function
would not try to allocate PMD-aligned area if *any* hint address
specified.

Modify the routine to handle it correctly:

 - Try to allocate the space at the specified hint address with length
   padding required for PMD alignment.
 - If failed, retry without length padding (but with the same hint
   address);
 - If the returned address matches the hint address return it.
 - Otherwise, align the address as required for THP and return.

The user specified hint address is passed down to get_unmapped_area() so
above-47bit hint address will be taken into account without breaking
alignment requirements.

Link: http://lkml.kernel.org/r/20191220142548.7118-2-kirill.shutemov@linux.intel.com
Fixes: b569bab78d8d ("x86/mm: Prepare to expose larger address space to userspace")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Thomas Willhalm <thomas.willhalm@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 41a0fbddc96b..a88093213674 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -527,13 +527,13 @@ void prep_transhuge_page(struct page *page)
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+static unsigned long __thp_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size)
 {
-	unsigned long addr;
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad;
+	unsigned long len_pad, ret;
 
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
@@ -542,30 +542,40 @@ static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long le
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	addr = current->mm->get_unmapped_area(filp, 0, len_pad,
+	ret = current->mm->get_unmapped_area(filp, addr, len_pad,
 					      off >> PAGE_SHIFT, flags);
-	if (IS_ERR_VALUE(addr))
+
+	/*
+	 * The failure might be due to length padding. The caller will retry
+	 * without the padding.
+	 */
+	if (IS_ERR_VALUE(ret))
 		return 0;
 
-	addr += (off - addr) & (size - 1);
-	return addr;
+	/*
+	 * Do not try to align to THP boundary if allocation at the address
+	 * hint succeeds.
+	 */
+	if (ret == addr)
+		return addr;
+
+	ret += (off - ret) & (size - 1);
+	return ret;
 }
 
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
+	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	if (addr)
-		goto out;
 	if (!IS_DAX(filp->f_mapping->host) || !IS_ENABLED(CONFIG_FS_DAX_PMD))
 		goto out;
 
-	addr = __thp_get_unmapped_area(filp, len, off, flags, PMD_SIZE);
-	if (addr)
-		return addr;
-
- out:
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE);
+	if (ret)
+		return ret;
+out:
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);

