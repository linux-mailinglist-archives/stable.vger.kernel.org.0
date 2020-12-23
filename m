Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D142E1CF3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgLWOIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:08:36 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50235 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbgLWOIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:08:35 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 016BC95D;
        Wed, 23 Dec 2020 09:07:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 23 Dec 2020 09:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=l7KD6M
        7y5JtIZQrRUm0hCH39PQvG6h/zvlUX746ZvDg=; b=hDSwvEwpasJ8P+xykLo/Wj
        eLp6od6lt2k2z28MAV9JnqCUQUx4s3I7D18eDJVM5LzxBYvtMkTDAkfoBtmbKUCX
        znuX6mZLEegrgkRYdFpH+YzZ9k89u1lT22/xmU1GWxNktjJP2YMf/LSEI4neIr3V
        iSp9rUuJ68K/Oc7tvEgz/wsd1rziidMylFO0tO+gSUtNYzTJunECA4u5UWWN/dG0
        MMlKg5zzDtaySRUSgQqtmsoEbZmBw2t7hFGB00ervw4LRclkD9IzW0ftlLWQ8Slw
        8Wizkn0UIAwrGiNJSlLBBP9GNA8OF1j+v6YxpEWUVxOgcJj0s05f8bzd6EHTkbMA
        ==
X-ME-Sender: <xms:NU_jX6VlVfT_VKkT1P-q1jfHbFXvQV7AhKLjWkiqz7ZAU-sVbNoOIQ>
    <xme:NU_jX4nw7AdiomQugBfjPlu07cMzr_xCWTxaRJEH6999CrSLcKB-9gwr-kU6C_XKE
    xOGMOFpf3Pvsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NU_jX3wBvzTfiGociLGbFxFOBLz3xK4K26IeBpYkbbjlg0K4jFHRGg>
    <xmx:NU_jXzj_HZhx0rc77_y639tf-7fanYwC9czRi0tCE_xVUvLiwe9Qqg>
    <xmx:NU_jX8XnXFHFLRy6OCHiB9kDaidpRPE9xLawIFpt1eDSKEpisBhZDQ>
    <xmx:NU_jX6oPn1k_OyOYB50vmb_m-i348dmLlHyIPAUyhT6qGNfql7YRbIT-YuY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2EDF2108005B;
        Wed, 23 Dec 2020 09:07:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 4.14-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:08:52 +0100
Message-ID: <160873253225197@kroah.com>
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

