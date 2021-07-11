Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9903C3CC2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGKNO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:14:58 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39251 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKNO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:14:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 856D51AC067A;
        Sun, 11 Jul 2021 09:12:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 09:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PpHEEf
        6ASb1xp0g1u4d1Dv7z88TDQ+KPFHsqNkXxM+4=; b=E4Uu6dDt28VbYVjNq7YGtP
        KlLGUs0FYfGzxWrzB+5UqTYQWUcHY8mdOrPp5Cnk1rdUMT/an3hEC/ljsNJG7ZWo
        IxJbJO/j3vzZqZUC6UE/MB9eMiJe4tVoFtbTmLsAOgFhm+mT4YSnVgB5Fqj5itL8
        rV2eGbtsD7tZz8xddxTfvL26ElnzTmpiVDQocP7YeRrCnaYq1OfAjAvu8r9Q3hEz
        znh+Y5p3YMgiBOZEvqGPtEpGLZZG5smC5f+0A18qJ7encx1Ph4eMcszP0X0Fy9+u
        qezo8WRvM3CMgE1lbX/pNYHD60k4KbsbUNkToukFm5kagALIGN3gqxtNwWCaL9qg
        ==
X-ME-Sender: <xms:K-7qYIskNFjlaROrYeAieodKuzOpq7crv90Lbh5ekpE1DrtxQbisUQ>
    <xme:K-7qYFeNIumxH_Sx9NK8KDDxAiP9MPNY9pFhZD9xKW0gy_qQrBvW13EWqhwy_-uvs
    ii06bzA7HOUWw>
X-ME-Received: <xmr:K-7qYDywRgRrsrdNXmxWgy58rSUJHePqTeVErse7UDEW-EDwQXYMfotXyMH23BLS3mNrd21zTCShqT4X1I-6CSV_wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K-7qYLNdohjvyuc90ye5wDGJ12F8zCxTgOSg3g54hxGLvMer0pi9kQ>
    <xmx:K-7qYI97mDT6cigvu3VGTRrE89IUCw474t5DjLJbRH4Vf97mzyqetA>
    <xmx:K-7qYDWyqc6G8Im4z3exoYaiRiaJf9NyHYkeSfhYB3DGgY6DBkzpRw>
    <xmx:K-7qYKLL2-VM9XAEzbIyB85OyZxu5GuY-pSdufKTtC0cr1Ip1PN3YPjALzI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:12:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fuse: reject internal errno" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, anatoly.trosinenko@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:11:59 +0200
Message-ID: <1626009119113182@kroah.com>
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

From 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 22 Jun 2021 09:15:35 +0200
Subject: [PATCH] fuse: reject internal errno

Don't allow userspace to report errors that could be kernel-internal.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6e63bcba2a40..b8d58aa08206 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1867,7 +1867,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto copy_finish;
 
 	spin_lock(&fpq->lock);

