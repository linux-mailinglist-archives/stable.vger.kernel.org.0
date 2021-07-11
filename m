Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25DF3C3CC0
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGKNOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:14:48 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45387 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:14:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id D305A1AC0349;
        Sun, 11 Jul 2021 09:12:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 09:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7H7jjy
        H5M9aU3wdHhKs/ETaHld/ldInRkLUnfv2VH6c=; b=S6fe+6fXP0fZDUA17OROLD
        Dc5D6dRtS8wKPvXCSHRF6Wdjmwuyqo6mlKJ351fKiIiTV7yd111HlzKPY+lRn7hB
        EqvgSnl0mpiHZ4no/ayPSWkgHPv/vwBKC0tziS9W8sAwsl3ygdUzl4PW0itU4sn+
        Pz0PNddM3usZK1Xgk5e9fnbMnxHv3VyaiadRE6OeSWqHMOujhIJojbgIyYjupkRe
        JcUCG846hG/wH277CQ+Oy9gJzuixPEjbE3frpY8TdGvu/yuOaGtKduRRirH5shC6
        hD43XRgx2Fcultiu06MaQ1myYG++BMpfA6mSE2+ajrr/DUW7HAop/iSiRsA7zKbg
        ==
X-ME-Sender: <xms:IO7qYD68byEC_z7UE67tXIPVYKRvjlHJNSxhdDVXI5Uc4dXIpEMY3A>
    <xme:IO7qYI720DT9cTWFX95_RKQcNsksbDI3CfrmwkPaWvStlV_HtvskNsDQd1jAhs8As
    iPyDv3ZQ5eoUw>
X-ME-Received: <xmr:IO7qYKfmxKAn_YnexbStsE06bXlec7CBNqOkxPmQ5i5aFUJKqLVlkwa1ZgKkIYVd6_Q9igPtXstTPPT4u-VKIkEfdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IO7qYEKr5xPq3zXQI60dLzVUj1pVk-BuJfrp7z5xHTthaD1m2i7jLA>
    <xmx:IO7qYHL7nPb68UeqOZujdJJT5G8-HAQVloe-Jq3asEAzipIMqdS5Xw>
    <xmx:IO7qYNwXvjTdzSPnxu8Y0GPVy7b2aZ8kF8ADGURCrFrWCIeSKdEVUA>
    <xmx:IO7qYOVErSwlNYpH8KjO8igIMS0hcNaAaUSNa_YeTmnglXkMKzCwp9The0A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:11:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fuse: reject internal errno" failed to apply to 4.4-stable tree
To:     mszeredi@redhat.com, anatoly.trosinenko@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:11:58 +0200
Message-ID: <162600911821044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

