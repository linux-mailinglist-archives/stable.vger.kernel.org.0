Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D82E1D4F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgLWOPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:43 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49343 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728850AbgLWOPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7BFF01B85;
        Wed, 23 Dec 2020 09:14:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5VL/uE
        eN0BIKewrKaoEP9c87b3/xu6VcvC4iKOBBqdU=; b=iXiuWa+A3ipqXGUH+9Wavy
        Vso3du0052SDTrPlR7cM1tcxQOZ3Q0ygv7zxc1RhFz7nFFFfCyLUSwwQH8eX5pEA
        4C0H/4SC1uksiebi2VV7MW8HWRcx6V05yGj2I4Mq8fQfqpmonMzU/cfH5GC6uXI2
        NcasntbmVmagtFWlwN1f71gTW9HxFeNqgA6oUrmBLPsDhDxI2eeJAj7F/3e36z21
        zeyuZT46ztuB/mDk59BhsHP6/0k5zHxhc2uEI5+lpjUhKVRw69/BjfEX9ntvtqxy
        y5ACokkjvBLLdM0GmRSbvMTtyplP5kazRRtGQwxtC3MY4qLyt4KOuHW+IJDZW2+g
        ==
X-ME-Sender: <xms:qVDjX39XhuG-IdhRQv_V0i04U0DhNisTx4m2MGxVxHOxWlnW4J1LUQ>
    <xme:qVDjXzt32csPe3GMQp2CQEngSMPwq73pn3CnWQIxHqVZGqhYlLrzrOn9HHS81PD29
    okMxoGIGPdHEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qVDjX1AeeziC0eZl1bx_-hdrJsnbVDXSeIfnv82sP1DbjyRhrDGnOQ>
    <xmx:qVDjXzc0S0DTMzozDy5WKIpYcE_ZkWU28mM9zzLx13cJma1Plgl0YQ>
    <xmx:qVDjX8Np5gHeA6UNaedgwF8KFIPCqRst5CluL9D7eHKeiyje-iPJfg>
    <xmx:qVDjX3Y2Yaj8dsqnbmyi3jvwDVmrhBe8lAzf9jzwoeB86UBtxWs2aFDmv2k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C867324005B;
        Wed, 23 Dec 2020 09:14:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: prevent creating duplicate encrypted filenames" failed to apply to 5.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:13 +0100
Message-ID: <1608732913239200@kroah.com>
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
 

