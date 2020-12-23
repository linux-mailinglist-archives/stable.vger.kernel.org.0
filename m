Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BA12E1D51
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgLWOPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:44 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52839 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728830AbgLWOPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:24 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 284C61B8F;
        Wed, 23 Dec 2020 09:14:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 23 Dec 2020 09:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LLq3ht
        BxgezncwO+gMn15GB9K/dczjDduI3N9lPACXQ=; b=WbrTXztKMf05fbiXnoPnNt
        N6gijM0k7NHa8fG3QKQNBrNXwLokvyQP9AGytT60n3d4VVy6UobSZtWNR1yxmXrh
        S3jnibQm12osxshuo5fRafYa7OGRewJNJUw2C2tPL3Vjrnd3wgRwrmhHoX7IRoFd
        YE0/QoH/r+lLmwaTY7G+rGXqheDkK8fMtGmK8t0FVVw6FHwJeNLomlFgVO7fFZNJ
        p6eYuSFT9pLyF81ozAgedhTddNlVEbBi4qW3kL7lIE1z20uos414alDbsh/ZZ4qN
        D/EQVl0FJZiEqzfXr6ZWotU7kmkMpJYwBLqB2UbGFlJbVJT64u/H1i8nW1SVjnQQ
        ==
X-ME-Sender: <xms:qlDjX1-fKHri3FHtYRXFOKM_khFC4u0dUaZqTuX2wRydxQtU-sRfdA>
    <xme:qlDjX7ugMUz1jI0qsVBwbPgsGCWo82Gn9kJkfuC9ZDA1N38wE0XqDL9tAvgZOcAJ9
    nFnRc5T-tKFpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qlDjX8byYsZjjY0v_gZGrAIPZAdn5jZxUC8vcijarEBJ3afO7seNaw>
    <xmx:qlDjX7o37IE-SyHKqTVFVLllEnVDxdYQgACO83yLIAZIj4CXTLkdMA>
    <xmx:qlDjXx_Dx_ixUtVDVHeKRumw_EKvupwAcKjdFYTwKbYzCGTaA0F3ww>
    <xmx:qlDjXxzUIlUw6EQp4KdVd0na3i0OGGo15vNNtNlCHgQLTpTxOPymBKBoYqY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74C9D1080059;
        Wed, 23 Dec 2020 09:14:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: prevent creating duplicate encrypted filenames" failed to apply to 4.19-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:13 +0100
Message-ID: <16087329138816@kroah.com>
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

From 76786a0f083473de31678bdb259a3d4167cf756d Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:08 -0800
Subject: [PATCH] ubifs: prevent creating duplicate encrypted filenames

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ubifs by rejecting no-key dentries in ubifs_create(),
ubifs_mkdir(), ubifs_mknod(), and ubifs_symlink().

Note that ubifs doesn't actually report the duplicate filenames from
readdir, but rather it seems to replace the original dentry with a new
one (which is still wrong, just a different effect from ext4).

On ubifs, this fixes xfstest generic/595 as well as the new xfstest I
wrote specifically for this bug.

Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 155521e51ac5..08fde777c324 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -270,6 +270,15 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
+static int ubifs_prepare_create(struct inode *dir, struct dentry *dentry,
+				struct fscrypt_name *nm)
+{
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
+	return fscrypt_setup_filename(dir, &dentry->d_name, 0, nm);
+}
+
 static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 			bool excl)
 {
@@ -293,7 +302,7 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	if (err)
 		return err;
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
+	err = ubifs_prepare_create(dir, dentry, &nm);
 	if (err)
 		goto out_budg;
 
@@ -953,7 +962,7 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (err)
 		return err;
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
+	err = ubifs_prepare_create(dir, dentry, &nm);
 	if (err)
 		goto out_budg;
 
@@ -1038,7 +1047,7 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
 		return err;
 	}
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
+	err = ubifs_prepare_create(dir, dentry, &nm);
 	if (err) {
 		kfree(dev);
 		goto out_budg;
@@ -1122,7 +1131,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
+	err = ubifs_prepare_create(dir, dentry, &nm);
 	if (err)
 		goto out_budg;
 

