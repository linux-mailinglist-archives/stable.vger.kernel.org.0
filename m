Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C382E1CF6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgLWOJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:09:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46215 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728449AbgLWOJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:09:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4F105961;
        Wed, 23 Dec 2020 09:09:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:09:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KWAcCI
        wCgEWDTbWdNTGDqqSzdFYQHBmDrw4BnvrzrBc=; b=dbQPCZaYMcvV0S6sc2wUie
        Ampi+9UmhKf7OsJ2oJK1/W9BPpG1Y2+XxF8PWXpqD/uq7UkFQjIIRG/V+wRj/uhc
        KFOmAQwu6kxB68SOTiXSZMOKeZaVly9JH1O5PaGalz6F1W5crJJv3F+HtmO2v++n
        NSSAiASidSh9CBOsRk7eLeZKeqs0fHqIP8gZpPz20GgdKeggGMw+NfxcaYSdA59T
        ys+LIpm+9Z/8qPDVH0ZlUfbEcEAP8UCTnHwTtP9jTMYxqdDGbu7poe9nMp8qX0sM
        8CSio9OLAokjZvO5zntTn3NR8hT4ERhCO7SCZMub/4Qr8+iz0MU9nXh3LaAAWakQ
        ==
X-ME-Sender: <xms:iE_jX8myfq1Wg7DBryN7INivZGWacgdlPWSKf_OVzrS63DwWXgAC3g>
    <xme:iE_jX73R1BqgLI4xrN2vATg4gR5tUyNURKtlkrzc09LZFuzBoQceVLbLgV0_myL4L
    ErZbJAkCKe7kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iE_jX6pzqdhSStwWTXSsjFrLAR6qyiW1b_W6lTnZ1atzdoYUMwuYIg>
    <xmx:iE_jX4lnrM9AN-TG9gF0V_p8OVK7bXshgGFzSz35faPwJ3Md6tDT_w>
    <xmx:iE_jX63v_M21XMeDjJrYDAxDtL-kwsoKuY3-JeilUUP9eegsNsqntA>
    <xmx:iE_jXzifyMYVkmlZUidO5RsOp4UQZRaV2H1tGrJo3oLmV2Bj81IdbqHXNsA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 999E2240065;
        Wed, 23 Dec 2020 09:09:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 5.10-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:10:24 +0100
Message-ID: <1608732624714@kroah.com>
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

From bfc2b7e8518999003a61f91c1deb5e88ed77b07d Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:07 -0800
Subject: [PATCH] f2fs: prevent creating duplicate encrypted filenames

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on f2fs by rejecting no-key dentries in f2fs_add_link().

Note that the weird check for the current task in f2fs_do_add_link()
seems to make this bug difficult to reproduce on f2fs.

Fixes: 9ea97163c6da ("f2fs crypto: add filename encryption for f2fs_add_link")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cb700d797296..9a321c52face 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3251,6 +3251,8 @@ bool f2fs_empty_dir(struct inode *dir);
 
 static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 {
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
 	return f2fs_do_add_link(d_inode(dentry->d_parent), &dentry->d_name,
 				inode, inode->i_ino, inode->i_mode);
 }

