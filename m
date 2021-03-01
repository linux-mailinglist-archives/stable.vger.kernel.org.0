Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82924327E78
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhCAMmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:42:14 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37835 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233353AbhCAMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:42:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9AB901941BE8;
        Mon,  1 Mar 2021 07:41:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gGJygo
        OfWvigIRf7EWpwuhAgVofeaGxhBNK7n/eLMJQ=; b=ttaMWKkEVNzkZLKZBY0S0W
        xjrST/WPyU9hnNSo7QRolQah+j7wWwTxatAkxLx8IHxC2fr0U/Dfba5FdUgZh/l4
        rLQJ8hCg1jKERtFbNFK/+s9eUifUReekwqpC7Zc1VHKoYEHRneDWY6VrLVQY5LcZ
        +Rn1FpRqMIv0mB1UOAn5UTbULJIsCwZ+P4nRpz5qu39ceQa6VI2FhWucSZREmLh9
        +NLWZjgtBqioqM03vbkutqII6TtEkF3lbXVohKMENJN5FSjnzrggSVPC50qV4S+s
        IIBhrFAuJmk85LCVas5o+E5ETBeEhwOXsyshhsP8orZPsmaYPXj1uTsiCYhbvcYg
        ==
X-ME-Sender: <xms:4uA8YN_gfMH5sCUHwJ332L6gwMBBYH41RZsZmabZPghT9xMammLuIg>
    <xme:4uA8YBs1vouJhrv4FwLXkA0l1O0wKrs6HdRJ7iIVgS6-e7Qp__oL5AjVfiQiG158g
    k3-dQVGtyw0oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihfeile
    eiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4uA8YLA297kk2Hm3RvVyCVhrGHN_V7ecfje24mq5UTe9AxoIFwMY3A>
    <xmx:4uA8YBfVh5gz4IDoARI--bGw8Rt_k_rbW6jnpsqTOzWQ559b8ZW6NA>
    <xmx:4uA8YCMpwJoZzr-SUKQ_SFuL1yGDpYIB5NjjhTP-TV6MaA_vOXEqmA>
    <xmx:4uA8YDgroSXPT_1sjDLFqJH7rFYEOQH4VfX1Q21aNG6lj5tRE71YWnLAkEI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14B611080057;
        Mon,  1 Mar 2021 07:41:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig page struct" failed to apply to 4.14-stable tree
To:     mike.kravetz@oracle.com, aarcange@redhat.com,
        akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:41:00 +0100
Message-ID: <16146024608753@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From dbfee5aee7e54f83d96ceb8e3e80717fac62ad63 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Wed, 24 Feb 2021 12:07:50 -0800
Subject: [PATCH] hugetlb: fix update_and_free_page contig page struct
 assumption
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine update_and_free_page can encounter a gigantic page, yet it assumes
page structs are contiguous when setting page flags in subpages.

If update_and_free_page encounters non-contiguous page structs, we can see
“BUG: Bad page state in process …” errors.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where
the gigantic page will be allocated.  Zi Yan outlined steps to reproduce
here [1].

[1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@nvidia.com/

Link: https://lkml.kernel.org/r/20210217184926.33567-1-mike.kravetz@oracle.com
Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6786b313e6ac..3f6a50373d4f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1321,14 +1321,16 @@ static inline void destroy_compound_gigantic_page(struct page *page,
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct page *subpage = page;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
+	for (i = 0; i < pages_per_huge_page(h);
+	     i++, subpage = mem_map_next(subpage, page, i)) {
+		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);

