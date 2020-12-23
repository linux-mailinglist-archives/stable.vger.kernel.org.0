Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F58E2E1CF4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgLWOIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:08:46 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60411 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbgLWOIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:08:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id F0281275;
        Wed, 23 Dec 2020 09:07:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 23 Dec 2020 09:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o3eu3R
        Fz+WM6w7s7ycvbyYaRQ45T2A5Oq0ppDs4M64o=; b=ObD8umKh1uzb/bdX7r4cwo
        We7ZePzC2qaiTMdX/JF800jWGc6OKGBD4Kq2HVRlGqkB3nEFfN3BEgK0V6JLvbAH
        bxQEtHvy1enX3sV+kuGq6hVbhjYN59C+M4BCFG0EYZ7BAsGsVspDR12pxgPKwGc3
        CdKLhm+TTMWx5cF3igaeqXu4V848dEaQUBQsmuxaQNTo77dkSrbFMm6Mh8GsKNEN
        eNDnyE71SpGQ4tkmuZHZt9JvEim2aichcDtU73PxNnaoEQbyY952Z2TVqzeKYTYa
        fAetBikAOKfq+HFTT3v2v+O2wGKmJXIMlVU0wbsF1khosKFsCAjZ53tUZNcwlX8Q
        ==
X-ME-Sender: <xms:K0_jX2piKjfIT7zrhM8qeNrWdxglM0h6euzbfShWxhOATPlhdYUOXA>
    <xme:K0_jX00ZeGvw9q4RVYw-0tDAm7ewfbTEsW10HVBe0iLmZRIJTNzEp1eWltzFvg5nI
    FlhHH6hZztK5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K0_jX9A8tOnPIUW2FNqp7wrScixurTHxBUYyZbCdD9sgZ_fdcoGOMw>
    <xmx:K0_jX0dC58mGheoL8NC5sSeyaTf25ucds5GIe1CsSHiICzqAxO-NhQ>
    <xmx:K0_jX6jtDgYH5PqT4eQygviirM91-wn625j2CZXdgaF9Evkwkziw0g>
    <xmx:K0_jX3szmLX5fwmUuMnNnTzK9hmKYBhEjCERJvTjGlVBOpEW5TeUygLgCHk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19726108005F;
        Wed, 23 Dec 2020 09:07:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 4.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:08:51 +0100
Message-ID: <160873253146173@kroah.com>
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

