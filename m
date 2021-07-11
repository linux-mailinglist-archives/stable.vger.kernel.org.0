Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9343C3C13
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKMDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:03:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47643 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhGKMDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:03:04 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id D27651AC0D1D;
        Sun, 11 Jul 2021 08:00:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 11 Jul 2021 08:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ij0nAi
        3bpno/dNIq5ikjF0o7CbKhXSsPi2Mz+Qnwlnc=; b=gYTAFEkc7tPoyB+GV82tyc
        gkKqrAoXGP3Nlcg+Jp/UNhRith1epPtGwywsI2OFK9GHqwJNUgl1Uk3KShw1DOqQ
        4GucBCIVM7qFq3UwKzC7FlYeANvsKoLYwTw+jQsqmSA3s5Li02pve078vi7OrBLE
        +r3rgEEjD9DC/oMp3aTMU0iCUBqXzFHpXzXTft169HgDQVcHyIanLxqG11EifZ1g
        u9v8Kt6F51Bld9MV5lzLIHgtsrMxttg4sM4I3T8IHrANwDQ4sVslpNZfBvH/yMiX
        jGdu/0b8clCJkn+wXQDU4YgdikG1DFU3EoDR6LozZvWcJlwayvm/NPkkbje3U58w
        ==
X-ME-Sender: <xms:UN3qYD1MJeUw8ODRbeNyIx1QiEgE1uy2L_GvpmbvJ73gan4KI8y_9Q>
    <xme:UN3qYCFgkok1-2wMo0Ijm8bomeNFPriqUq2aB0IjGs7AxedThbNqjBE24Ogj6HS-x
    db7q6pFPtsBOg>
X-ME-Received: <xmr:UN3qYD7sfEk3R4yEUP7ps_BF4BN2YmJ8baG1M1wqXPQjQyZiTCXrDYc_up8vKhviqB2Ujt-szFMeN6OCXTkJU6-J8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UN3qYI22e1h0n_58AGv69rnPIts_Z_3l0D5bWdIxOm2A3O4rJDgv9Q>
    <xmx:UN3qYGEs757AhT7UgEXVL1tuvjgGx_-CoxwYepIAEU3B2cvQFtLt9A>
    <xmx:UN3qYJ-nBxYwR2jYWk0v_XQqZcqT0oSGPhHcvdhNhQUKDF-XpPoZ_w>
    <xmx:UN3qYBMTGN9LRuIoD4j1zYXuCtoLlQVXvtAGjsYdGSsCn7y4o9Ze7hR6V5w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:00:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] teach copy_page_to_iter() to handle compound pages" failed to apply to 5.4-stable tree
To:     viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:00:14 +0200
Message-ID: <1626004814159241@kroah.com>
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

From 08aa64796016cb47b2ef3d0924653b4d944b0d65 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 29 Apr 2021 20:42:25 -0400
Subject: [PATCH] teach copy_page_to_iter() to handle compound pages

	In situation when copy_page_to_iter() got a compound page the current
code would only work on systems with no CONFIG_HIGHMEM.  It *is* the majority
of real-world setups, or we would've drown in bug reports by now.  Still needs
fixing.

	Current variant works for solitary page; rename that to
__copy_page_to_iter() and turn the handling of compound pages into a loop over
subpages.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 8f5ce5b1ff91..12fb04b23143 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -957,11 +957,9 @@ static inline bool page_copy_sane(struct page *page, size_t offset, size_t n)
 	return false;
 }
 
-size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
+static size_t __copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (unlikely(!page_copy_sane(page, offset, bytes)))
-		return 0;
 	if (i->type & (ITER_BVEC | ITER_KVEC | ITER_XARRAY)) {
 		void *kaddr = kmap_atomic(page);
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
@@ -974,6 +972,30 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 	else
 		return copy_page_to_iter_pipe(page, offset, bytes, i);
 }
+
+size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
+{
+	size_t res = 0;
+	if (unlikely(!page_copy_sane(page, offset, bytes)))
+		return 0;
+	page += offset / PAGE_SIZE; // first subpage
+	offset %= PAGE_SIZE;
+	while (1) {
+		size_t n = __copy_page_to_iter(page, offset,
+				min(bytes, (size_t)PAGE_SIZE - offset), i);
+		res += n;
+		bytes -= n;
+		if (!bytes || !n)
+			break;
+		offset += n;
+		if (offset == PAGE_SIZE) {
+			page++;
+			offset = 0;
+		}
+	}
+	return res;
+}
 EXPORT_SYMBOL(copy_page_to_iter);
 
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,

