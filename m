Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388652E1D2D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgLWOOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:14:52 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57231 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728888AbgLWOOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:14:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F38771B61;
        Wed, 23 Dec 2020 09:13:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WnvkWZ
        CyyJppPoNUffxXnkOBqwYFAtwqA3cZu97nrMs=; b=F1In4x8oyvrDERzvbMWhvH
        YVxc+6fzB2QVGszF3zztPVGI4SNRM67vjHdh6YkacNJHtiCPZWzIORgnpNsvzrv7
        BIPPvIdAds2WJvOTqlKEDSHd9vBSolEHCwWLpLfJ/829EqbcYggCcWMgUlkPUnc4
        3MZ/EwxZhYWL4UT59Fs6JFbggk/7xfQMRlFvWTUIFcDQCUyrQ30gpTbDYcoBlw8F
        M/I0RRouq+0WxfuryjPBqQLCt45DlhzL5oHqxSrC2DW+hVfekoCxwYFV4zZrGNLs
        pj3ZrgmDZ2qhH9ep4gfX4Vcz0q27w7a/ygdHq8RNZsbghgtxAF8tg8QacBZbXzvw
        ==
X-ME-Sender: <xms:mFDjX3zuStATefWAto0RIGuFzs3SymWPgWKti0PFuOgQDd4Bc4srkA>
    <xme:mFDjX_QOcaxt_4GoG36J6aVlqAaVJ0n57ONk0czeGDYyOEj8Em8OIg7yobE3ROvq7
    _zTZWBsoszp7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mFDjXxXu4legIyd92BNwPmj74ExUqgFVRjjrGZ9XRJQndDnfLLZ18w>
    <xmx:mFDjXxipxUOSl4c8ntz5cvblDH3rIULDCmf51fE4VKa83Q7C4feVZg>
    <xmx:mFDjX5BTeF_ihaUV00u3urFmdeX4srefTn3UlzivOHJcUyI2WDNBEw>
    <xmx:mFDjX0-s5JcGdfDnMy3QmI_1C6RV77Xn_h0Q0SgR4Zg3AV0AZgGbMQghNbE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B164240057;
        Wed, 23 Dec 2020 09:13:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] fscrypt: add fscrypt_is_nokey_name()" failed to apply to 4.9-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:14:55 +0100
Message-ID: <1608732895207178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 159e1de201b6fca10bfec50405a3b53a561096a8 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:05 -0800
Subject: [PATCH] fscrypt: add fscrypt_is_nokey_name()

It's possible to create a duplicate filename in an encrypted directory
by creating a file concurrently with adding the encryption key.

Specifically, sys_open(O_CREAT) (or sys_mkdir(), sys_mknod(), or
sys_symlink()) can lookup the target filename while the directory's
encryption key hasn't been added yet, resulting in a negative no-key
dentry.  The VFS then calls ->create() (or ->mkdir(), ->mknod(), or
->symlink()) because the dentry is negative.  Normally, ->create() would
return -ENOKEY due to the directory's key being unavailable.  However,
if the key was added between the dentry lookup and ->create(), then the
filesystem will go ahead and try to create the file.

If the target filename happens to already exist as a normal name (not a
no-key name), a duplicate filename may be added to the directory.

In order to fix this, we need to fix the filesystems to prevent
->create(), ->mkdir(), ->mknod(), and ->symlink() on no-key names.
(->rename() and ->link() need it too, but those are already handled
correctly by fscrypt_prepare_rename() and fscrypt_prepare_link().)

In preparation for this, add a helper function fscrypt_is_nokey_name()
that filesystems can use to do this check.  Use this helper function for
the existing checks that fs/crypto/ does for rename and link.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 20b0df47fe6a..061418be4b08 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -61,7 +61,7 @@ int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 		return err;
 
 	/* ... in case we looked up no-key name before key was added */
-	if (dentry->d_flags & DCACHE_NOKEY_NAME)
+	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 
 	if (!fscrypt_has_permitted_context(dir, inode))
@@ -86,7 +86,8 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 
 	/* ... in case we looked up no-key name(s) before key was added */
-	if ((old_dentry->d_flags | new_dentry->d_flags) & DCACHE_NOKEY_NAME)
+	if (fscrypt_is_nokey_name(old_dentry) ||
+	    fscrypt_is_nokey_name(new_dentry))
 		return -ENOKEY;
 
 	if (old_dir != new_dir) {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index a8f7a43f031b..8e1d31c959bf 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -111,6 +111,35 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 	dentry->d_flags &= ~DCACHE_NOKEY_NAME;
 }
 
+/**
+ * fscrypt_is_nokey_name() - test whether a dentry is a no-key name
+ * @dentry: the dentry to check
+ *
+ * This returns true if the dentry is a no-key dentry.  A no-key dentry is a
+ * dentry that was created in an encrypted directory that hasn't had its
+ * encryption key added yet.  Such dentries may be either positive or negative.
+ *
+ * When a filesystem is asked to create a new filename in an encrypted directory
+ * and the new filename's dentry is a no-key dentry, it must fail the operation
+ * with ENOKEY.  This includes ->create(), ->mkdir(), ->mknod(), ->symlink(),
+ * ->rename(), and ->link().  (However, ->rename() and ->link() are already
+ * handled by fscrypt_prepare_rename() and fscrypt_prepare_link().)
+ *
+ * This is necessary because creating a filename requires the directory's
+ * encryption key, but just checking for the key on the directory inode during
+ * the final filesystem operation doesn't guarantee that the key was available
+ * during the preceding dentry lookup.  And the key must have already been
+ * available during the dentry lookup in order for it to have been checked
+ * whether the filename already exists in the directory and for the new file's
+ * dentry not to be invalidated due to it incorrectly having the no-key flag.
+ *
+ * Return: %true if the dentry is a no-key name
+ */
+static inline bool fscrypt_is_nokey_name(const struct dentry *dentry)
+{
+	return dentry->d_flags & DCACHE_NOKEY_NAME;
+}
+
 /* crypto.c */
 void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
@@ -244,6 +273,11 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 {
 }
 
+static inline bool fscrypt_is_nokey_name(const struct dentry *dentry)
+{
+	return false;
+}
+
 /* crypto.c */
 static inline void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {

