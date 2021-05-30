Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD601395115
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhE3Nv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:51:28 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48361 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3Nv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:51:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 276F019407CF;
        Sun, 30 May 2021 09:49:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 30 May 2021 09:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I8youu
        XcO/3yYzrLNsgbmpWgCEb3N2zlgkT33zQq1s4=; b=G1iB/7HMawKQyLAVZmEoKZ
        kdtD8//AjwIj07OWtI9h1O6Ops5fr+I48kUr5IhU1SOeiUqHAy2EstjRyYLqNr68
        FIhzuX0rCU8ujPa+setFMJJ73xCRgqk3PqPa9YR/Zwev/iIY2ElvJaNoVk/pD1zs
        lgB04GbK4p1oIakSJy4eXf17GG+WlT+NuXKiRoqqSlnzA8r4x/kZV2ao6Ze//2W7
        ZIkM2lmzS8Q3ot8C8puiRvWPWBcPWkQYAFipLMEliW7IOk7tvTmUZvTIj7n4f6se
        YMR9RAoudSg3qsDMUaUw40Zy9r0yXMbFEWw2li4qzREd5syCXX2iqF6vNIA4vGMw
        ==
X-ME-Sender: <xms:_pezYIM2RvM2655CncwFpbNo1OeY2oILQ3yc8yMMhwUBEntJ9rXkqg>
    <xme:_pezYO8DmcybKaVMgebDOtRrHWzoAA7sYhnObM2jjzYOb53JLi2SM1GkdB08q4lwl
    czGNk7tBcj4Lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_pezYPS-Y3CXTNaJhlRG8P_ljJ-szJpT52HaO9Pdwc7pjGKgU9G3Bg>
    <xmx:_pezYAvy2l0JMF4nLguar164x9RdklHdMpwzzGzr3OVBa3kn_XQ-TQ>
    <xmx:_pezYAe1FpRyi9YSZUNPLxY7HlqntOwK_sj3Wsxto7EcvMq1Tl4bGA>
    <xmx:_pezYKoletvfkfqQaW9gMsRcd_BoopGMOPE3nReHq1lShfQ-53fVaA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:49:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFS: Fix an Oopsable condition in __nfs_pageio_add_request()" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:49:39 +0200
Message-ID: <16223825796137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 56517ab958b7c11030e626250c00b9b1a24b41eb Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 25 May 2021 10:23:05 -0400
Subject: [PATCH] NFS: Fix an Oopsable condition in __nfs_pageio_add_request()

Ensure that nfs_pageio_error_cleanup() resets the mirror array contents,
so that the structure reflects the fact that it is now empty.
Also change the test in nfs_pageio_do_add_request() to be more robust by
checking whether or not the list is empty rather than relying on the
value of pg_count.

Fixes: a7d42ddb3099 ("nfs: add mirroring support to pgio layer")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 6c20b28d9d7c..d35c84af44e0 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1094,15 +1094,16 @@ nfs_pageio_do_add_request(struct nfs_pageio_descriptor *desc,
 	struct nfs_page *prev = NULL;
 	unsigned int size;
 
-	if (mirror->pg_count != 0) {
-		prev = nfs_list_entry(mirror->pg_list.prev);
-	} else {
+	if (list_empty(&mirror->pg_list)) {
 		if (desc->pg_ops->pg_init)
 			desc->pg_ops->pg_init(desc, req);
 		if (desc->pg_error < 0)
 			return 0;
 		mirror->pg_base = req->wb_pgbase;
-	}
+		mirror->pg_count = 0;
+		mirror->pg_recoalesce = 0;
+	} else
+		prev = nfs_list_entry(mirror->pg_list.prev);
 
 	if (desc->pg_maxretrans && req->wb_nio > desc->pg_maxretrans) {
 		if (NFS_SERVER(desc->pg_inode)->flags & NFS_MOUNT_SOFTERR)

