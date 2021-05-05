Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6FE3735CE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhEEHrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:47:41 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60497 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEHrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:47:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3362416FD;
        Wed,  5 May 2021 03:46:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 05 May 2021 03:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xhSWER
        orE34HSi4X4CgujzzXEkUl7D3kqXE9CzlekFc=; b=LbWx3Dlx5llXDk1jKwnMYF
        tCeO88No/EzLpZwxihAKeRCHk3XiS+y7GL8pPlEs0OJQhPtBY6j6B478oFu0J8Ss
        57b8e57qevYCsYr3sWm0YAym5DvHQTh55Lmuv3wKeDBKdeRzqinlop+aEruiHJ09
        nykNVdteJojFXHG8QW2o7/pD9asp3KsWZm2kKY3aqsktUEjJt9nDD41x8rjbE8yH
        7cv+pHXrYsS/Tjm9+OaQ3n2aExWq5x2hEZI0j67sWGXUtVoRlhgmVZWmZe0Bggpe
        M1n3RN1z1LO99JLkHjx/7huPFpT3t8pRER5oLhxBTikHR9eDpmJ8XVnPqo10yEFA
        ==
X-ME-Sender: <xms:ZE2SYGT7plRf0dbCx4tsF9ZX9ris67THonaWoe5wuXjRKt3NLe_l0A>
    <xme:ZE2SYLz9GtHfm3P7nKUv1Olb8iv6QKpAPylxiD8u8VY95KgL0lw7Ep0Mv4keOGueJ
    b6SMcJiMengWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZE2SYD1JJTFXij5rl-gpFglvj4hhVDXqkWnq85j-Om7qyPP-OlIgFA>
    <xmx:ZE2SYCBpzBuTzdh0E1uUd_otiLIpJE8MZN-lQmQt72T7wGMV5bbfmQ>
    <xmx:ZE2SYPhGP2KCk0725H08LVfJM320x6YRnK2f5--zcLF2DXK-wirhHQ>
    <xmx:ZE2SYPJwaR_IjSc6NizuaewqhG-b-8taM-05wZG2lGYLvpKKwELw7iQn7Z0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:46:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ovl: allow upperdir inside lowerdir" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 05 May 2021 09:46:35 +0200
Message-ID: <162020079520641@kroah.com>
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

