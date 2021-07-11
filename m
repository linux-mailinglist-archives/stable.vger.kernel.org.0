Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFA3C3C15
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:03:12 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33521 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhGKMDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:03:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 826171AC0CD4;
        Sun, 11 Jul 2021 08:00:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HqK55/
        sBuEVP9AnGt9mEaRF/OcZhxoa9Uz5xzlIbxXY=; b=Y3lLGJiNuIc1yx/1w3pu4n
        BoSJBQvwq0PShCtMEKawtc3UYqDPphwj0qIUAgL04lsjMvU2Gg3VSaca+Vonv7X7
        NN02tgsqxRExGi5AzTJK5bBYvRx9c4P81iyUffInT7vN6KzmRoenNvRbz7kdGhPF
        CnebP0bKA+on/JyVZXwuEUJ8wcDdqF6JgWPPd0G5OjiogxR0wjYTZ9Ym8xK4oWFW
        wPwN9tgvFK6BdxHU5rR+GE/9ul5MQJ5sJ3rKgstabXcoex3ROwXr1tdtHXqCOO7V
        SDtu/titkkYvVDleR8EAo8r1e8YPi2qs9W20q2Gmu0SJCbv8iM6fa2VfGuPSuPqQ
        ==
X-ME-Sender: <xms:WN3qYCh0k4sKmqpgGV5jyb13fDryHrMv8T1_jZ9D3MQf8z5T6-48Ww>
    <xme:WN3qYDCB-vQx6QOX6Of6TgmAqKvHUTDRimMxMgPIyHhxI5eNMZpogTRPul2Q349A1
    bfK-1J89sjLFg>
X-ME-Received: <xmr:WN3qYKF5Wg7V2iAJUgfxAKcTZ-6siT8ceckl77UcAzcx6_-qSim2-lV_kJJUHXqRe8dIH0qWdzz1ByJ1SJaw2ABP8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WN3qYLTbG2lz2rQ842k_kh7nK-hju2X3qYMaRS8ZXG-WvbOR3orzsA>
    <xmx:WN3qYPwHdKasbkg38afkdzPhGLhNjqM8epYKtwTql2FS2K-_rOx0hw>
    <xmx:WN3qYJ5qyoN_kLPCyvpHtYBfZBgC55sydqLvLHAc3cEcxvH_zO1stQ>
    <xmx:Wd3qYNbJxsZqUOWa9IqvhwSvzqjQ3agKXWnfzyWswOUm4As0rzHV4x3P60I>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:00:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] teach copy_page_to_iter() to handle compound pages" failed to apply to 5.12-stable tree
To:     viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:00:15 +0200
Message-ID: <162600481510082@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

