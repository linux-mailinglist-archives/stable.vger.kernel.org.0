Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0173735CD
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhEEHre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:47:34 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42297 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEHre (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:47:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 1C3411434;
        Wed,  5 May 2021 03:46:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 05 May 2021 03:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xKUkPU
        OzkFM6bPHWEcDbSXN0id57+Vlyrl4wY68KLYg=; b=io733hjoqr16kPeMropitJ
        p5UahcLvNWNno3aviJ2b56AKtNdrZFVXN8+9nFxGJ6/5Y069ML81OZ7lDBwMmjdp
        2JrZ18thvhQNcig2jHyE02nipPjgMqNS0OHAOrOWuCKwNElJ9nLRmWa4Zj/ZMIJY
        hJTpOr8cCOLErDymkztEmKwCIyiI1/u94+kOu/vBCXQcpct5PEl//6ryAJEztx5B
        uKWATww+W+aOhqJEVBCOF/U+zNY00gW7i0ZLhclpcmQbNxxyZww1zLBOivxzG1jx
        XeDbarlSubXK+K1pjA8rHzH1VCW4Y6bNNJrfIZu5rn4WqtIBqSizbjclLk2p6kkA
        ==
X-ME-Sender: <xms:XE2SYC_B-PIkmbO66dQSpdaMABkprwVkPxxkq6lFqq2rWpn0w2fYVA>
    <xme:XE2SYCuXxBLOotPp1yGR8m4UkttftXd2WKUUvcm54SHZDCqBUqfXegkAskdZLJOHr
    g36SkoDcBUzFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:XE2SYIBXiToGD3cUfsRS88MHZ9IWeZvrtHnF32MBk03lhL_L4g_D4A>
    <xmx:XE2SYKet-j9OUGZpyQgYpYiLO-LUkqt3Bzs1Oqe8V7UrV_lwkoExcQ>
    <xmx:XE2SYHO-95lYseGbvQ-ZW9ckdZqA70qsqSm6kAfmBCipHoOspWd3Iw>
    <xmx:XE2SYJXk2SZDjfp_-5jxw4ckYQifSsbWu_AZicXZocRRFSHMKfAgp59QhjE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:46:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ovl: allow upperdir inside lowerdir" failed to apply to 5.4-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 05 May 2021 09:46:34 +0200
Message-ID: <1620200794827@kroah.com>
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

From 708fa01597fa002599756bf56a96d0de1677375c Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 12 Apr 2021 12:00:37 +0200
Subject: [PATCH] ovl: allow upperdir inside lowerdir

Commit 146d62e5a586 ("ovl: detect overlapping layers") made sure we don't
have overlapping layers, but it also broke the arguably valid use case of

 mount -olowerdir=/,upperdir=/subdir,..

where upperdir overlaps lowerdir on the same filesystem.  This has been
causing regressions.

Revert the check, but only for the specific case where upperdir and/or
workdir are subdirectories of lowerdir.  Any other overlap (e.g. lowerdir
is subdirectory of upperdir, etc) case is crazy, so leave the check in
place for those.

Overlaps are detected at lookup time too, so reverting the mount time check
should be safe.

Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Cc: <stable@vger.kernel.org> # v5.2
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a33b31bf7e05..b01d4147520d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1854,7 +1854,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
  * - upper/work dir of any overlayfs instance
  */
 static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
-			   struct dentry *dentry, const char *name)
+			   struct dentry *dentry, const char *name,
+			   bool is_lower)
 {
 	struct dentry *next = dentry, *parent;
 	int err = 0;
@@ -1866,7 +1867,7 @@ static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* Walk back ancestors to root (inclusive) looking for traps */
 	while (!err && parent != next) {
-		if (ovl_lookup_trap_inode(sb, parent)) {
+		if (is_lower && ovl_lookup_trap_inode(sb, parent)) {
 			err = -ELOOP;
 			pr_err("overlapping %s path\n", name);
 		} else if (ovl_is_inuse(parent)) {
@@ -1892,7 +1893,7 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 
 	if (ovl_upper_mnt(ofs)) {
 		err = ovl_check_layer(sb, ofs, ovl_upper_mnt(ofs)->mnt_root,
-				      "upperdir");
+				      "upperdir", false);
 		if (err)
 			return err;
 
@@ -1903,7 +1904,8 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir");
+		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir",
+				      false);
 		if (err)
 			return err;
 	}
@@ -1911,7 +1913,7 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 	for (i = 1; i < ofs->numlayer; i++) {
 		err = ovl_check_layer(sb, ofs,
 				      ofs->layers[i].mnt->mnt_root,
-				      "lowerdir");
+				      "lowerdir", true);
 		if (err)
 			return err;
 	}

