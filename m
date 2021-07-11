Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD63C3C64
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKMkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:40:08 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40491 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:40:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 239871940790;
        Sun, 11 Jul 2021 08:37:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kxzan4
        zQM27fLFkxqvxUfUvTUrW/FiCnFZgUao5MLyw=; b=wzQTUc+fPQH0wDQHc8WkZq
        KkG270bBIDHrYaAuNOFoPJhCPxQG3SzWDsQ1580IOIaiBNuaENToPT7n1ZBHYRNX
        sN+TKZc8DS/mQ2/9NOLbTQb4rrH1BzABiJvCq+SYbZt7Lcaof7Y+4i1eNuCdkiAr
        Mb5CEz+QVj8X5Poo+8fdcPCEGQIVzGqMIJU8ALNyxlIAJeUR1MQAre8bJP+Ns0KZ
        6HvciTayEEoP+4JzPauQInvodAL9Qy3UQ8EItK1FfBe6jvlXqiLE8/Q2PcYbxSPU
        5QDQ+dpwf01rgbsZeD3MPi7IeWpPHVML16UzKw5e+O8ENLTSwqV9xFEyFwOuFDoQ
        ==
X-ME-Sender: <xms:AebqYB_fU-9dR2s5iwZFosBnN6q1G80sl0d76-ZIKvFNjBKbTVYACA>
    <xme:AebqYFv2tRuz0fazzByGWN0Pg0Jobem0uZKkZMG8nhwHQNmgNyV1eW3and-e07Itd
    c8KHH6YlsMzEg>
X-ME-Received: <xmr:AebqYPD-E0Xpi9flN3KJSO6pnB7e9iZM2VpypwLxTa0o9ef19Pt8fVHv-fhwYzRpjGh8BLC1gyEojKvupf0wgGrD_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:AebqYFeYsspgNFC1r84hKbyrCpGqZ-0vgVc-pkBuNim1fRkmRE81ng>
    <xmx:AebqYGPLYOECg5nJSm1bJoGVFj3KOjf2VVsmzR61UO11s0CTVYGVYg>
    <xmx:AebqYHknHMfvyf2fd_qfxiJ0diVzBVhMcOcicLfLpBy8_-yS3N_meA>
    <xmx:AebqYFfNxSg0TtNrJ-4ZsXJ5q7B6dJ18pt0PEGvvQx8_bbXacxZVWA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:37:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/gup: fix try_grab_compound_head() race with" failed to apply to 4.9-stable tree
To:     jannh@google.com, akpm@linux-foundation.org, jack@suse.cz,
        jhubbard@nvidia.com, kirill@shutemov.name, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:37:19 +0200
Message-ID: <16260070395179@kroah.com>
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

From c24d37322548a6ec3caec67100d28b9c1f89f60a Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jun 2021 19:33:23 -0700
Subject: [PATCH] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()

try_grab_compound_head() is used to grab a reference to a page from
get_user_pages_fast(), which is only protected against concurrent freeing
of page tables (via local_irq_save()), but not against concurrent TLB
flushes, freeing of data pages, or splitting of compound pages.

Because no reference is held to the page when try_grab_compound_head() is
called, the page may have been freed and reallocated by the time its
refcount has been elevated; therefore, once we're holding a stable
reference to the page, the caller re-checks whether the PTE still points
to the same page (with the same access rights).

The problem is that try_grab_compound_head() has to grab a reference on
the head page; but between the time we look up what the head page is and
the time we actually grab a reference on the head page, the compound page
may have been split up (either explicitly through split_huge_page() or by
freeing the compound page to the buddy allocator and then allocating its
individual order-0 pages).  If that happens, get_user_pages_fast() may end
up returning the right page but lifting the refcount on a now-unrelated
page, leading to use-after-free of pages.

To fix it: Re-check whether the pages still belong together after lifting
the refcount on the head page.  Move anything else that checks
compound_head(page) below the refcount increment.

This can't actually happen on bare-metal x86 (because there, disabling
IRQs locks out remote TLB flushes), but it can happen on virtualized x86
(e.g.  under KVM) and probably also on arm64.  The race window is pretty
narrow, and constantly allocating and shattering hugepages isn't exactly
fast; for now I've only managed to reproduce this in an x86 KVM guest with
an artificially widened timing window (by adding a loop that repeatedly
calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits, so
that PV TLB flushes are used instead of IPIs).

As requested on the list, also replace the existing VM_BUG_ON_PAGE() with
a warning and bailout.  Since the existing code only performed the BUG_ON
check on DEBUG_VM kernels, ensure that the new code also only performs the
check under that configuration - I don't want to mix two logically
separate changes together too much.  The macro VM_WARN_ON_ONCE_PAGE()
doesn't return a value on !DEBUG_VM, so wrap the whole check in an #ifdef
block.  An alternative would be to change the VM_WARN_ON_ONCE_PAGE()
definition for !DEBUG_VM such that it always returns false, but since that
would differ from the behavior of the normal WARN macros, it might be too
confusing for readers.

Link: https://lkml.kernel.org/r/20210615012014.1100672-1-jannh@google.com
Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/gup.c b/mm/gup.c
index 3ded6a5f26b2..90262e448552 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -44,6 +44,23 @@ static void hpage_pincount_sub(struct page *page, int refs)
 	atomic_sub(refs, compound_pincount_ptr(page));
 }
 
+/* Equivalent to calling put_page() @refs times. */
+static void put_page_refs(struct page *page, int refs)
+{
+#ifdef CONFIG_DEBUG_VM
+	if (VM_WARN_ON_ONCE_PAGE(page_ref_count(page) < refs, page))
+		return;
+#endif
+
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 /*
  * Return the compound head page with ref appropriately incremented,
  * or NULL if that failed.
@@ -56,6 +73,21 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
 		return NULL;
 	if (unlikely(!page_cache_add_speculative(head, refs)))
 		return NULL;
+
+	/*
+	 * At this point we have a stable reference to the head page; but it
+	 * could be that between the compound_head() lookup and the refcount
+	 * increment, the compound page was split, in which case we'd end up
+	 * holding a reference on a page that has nothing to do with the page
+	 * we were given anymore.
+	 * So now that the head page is stable, recheck that the pages still
+	 * belong together.
+	 */
+	if (unlikely(compound_head(page) != head)) {
+		put_page_refs(head, refs);
+		return NULL;
+	}
+
 	return head;
 }
 
@@ -95,6 +127,14 @@ __maybe_unused struct page *try_grab_compound_head(struct page *page,
 			     !is_pinnable_page(page)))
 			return NULL;
 
+		/*
+		 * CAUTION: Don't use compound_head() on the page before this
+		 * point, the result won't be stable.
+		 */
+		page = try_get_compound_head(page, refs);
+		if (!page)
+			return NULL;
+
 		/*
 		 * When pinning a compound page of order > 1 (which is what
 		 * hpage_pincount_available() checks for), use an exact count to
@@ -103,15 +143,10 @@ __maybe_unused struct page *try_grab_compound_head(struct page *page,
 		 * However, be sure to *also* increment the normal page refcount
 		 * field at least once, so that the page really is pinned.
 		 */
-		if (!hpage_pincount_available(page))
-			refs *= GUP_PIN_COUNTING_BIAS;
-
-		page = try_get_compound_head(page, refs);
-		if (!page)
-			return NULL;
-
 		if (hpage_pincount_available(page))
 			hpage_pincount_add(page, refs);
+		else
+			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
 
 		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
 				    orig_refs);
@@ -135,14 +170,7 @@ static void put_compound_head(struct page *page, int refs, unsigned int flags)
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
+	put_page_refs(page, refs);
 }
 
 /**

