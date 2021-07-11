Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18F3C3C16
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhGKMDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:03:15 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60041 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhGKMDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:03:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 663FB1AC0CD4;
        Sun, 11 Jul 2021 08:00:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uPu1CS
        DnTs2ML20MlM/q5yKtEOOkwk+dUQCbTj9NVyQ=; b=rKoKm/HaSXSg6qVWqBZcCb
        Hui20/HHI6ywzXAjTInhOAdeV340lMNk9nOUfZrkI3EI1JPN+YD2XLDVAXF9phlR
        vQRsXc6ufjZfOdyZFvxLSm5TqEjEKO7T23z4S4KYT2yL44tVplkFuZq8UJzHc6Xe
        ldI2UKsb63Hl60dGLl5f1UopVp69UU0NIb2Gpx/cMXvBZWMvqQLhHtJz0VtyJtvy
        LCQQschLM866dNkSm0i+Tr0HyNwsGwOIVvVTcoWPecb5a1Fj+CXCs4oqg40IlyHe
        BxLfSqFVzxUb0KWWfEk12bb2Nbb1sNIuft8oXxs9vLoozG+ophz8etz/LaIgrQfg
        ==
X-ME-Sender: <xms:W93qYDnQRakaNupM-Rp8YJJ1laWkG0Pm0IwGFKINmGOSwu_AYe7VdA>
    <xme:W93qYG36Tna4oEHkqBMiD3AZRTxJS7JQpS78niTJHaNDz1P3SwmacPmxaDVBcT1CN
    pm3pw9CLI7K1Q>
X-ME-Received: <xmr:W93qYJrmeq5UqFoqLjgjKQMt7jexufheDLiSXFXoUPpLBeN6n05PeKaB3IzOnkfdBGcorx_6UcmNZ6lsW0yK7oNFbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:W93qYLn3XRzh7mQnU0oGKhFX0rLmXWbBXS-STy0CEI8rJ3k-dc1qaA>
    <xmx:W93qYB10YokGtktazaedkpMD0up7oriY7QNAW3ieisifmLxqa2kzPA>
    <xmx:W93qYKsa4KQwD0LHQyxpuf5dNUP2B1cTigOxCAqyp0qMegXn0cb-gA>
    <xmx:XN3qYO98oPVoB1N184UahSlxqbsvYR9jQnWR0u1-g4uwXyD_V623uPlvcek>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:00:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] teach copy_page_to_iter() to handle compound pages" failed to apply to 5.10-stable tree
To:     viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:00:15 +0200
Message-ID: <16260048155141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

