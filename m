Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3EA2E1CF5
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgLWOJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:09:17 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49397 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728620AbgLWOJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:09:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 62F741682;
        Wed, 23 Dec 2020 09:08:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sD3Evz
        VaiAEnBHig6KFimaBms7orGjSlsGaf/+aFes0=; b=fZ8b1laeL2I5+z/3Su2toD
        XgfTIZKRBGm398KPW1EOSMJ2dNFifsWD0VZK8n64jK2tGQD44b+/DgrY39+Nl3sX
        LaQM5q/cxPaaHsqg0/ahoI0WTI924veQlqx8LvuRRgMbPbFd/FVjfbRB03LmSvAt
        UpM2Pby7swD6Pz/CNlCGzuTQFY+feJIN7Dg5lmDuqXfe4uO2e5L+WO9RmD25MOeD
        kyhTYvrh/FtMK3g0uFhR72siZDoiVsm4wZV0QP8CC7F6Z6YRmi4re+8UtCqaihBe
        6HUQJdRBGdxE2yto+gtLg+rt3RnDXPjTSH+BN+oDDgb0ybRDjrt03dT5kR+gPHKQ
        ==
X-ME-Sender: <xms:Xk_jXyXAFF_yEmHWluV8V6gwMuNf7iBGsDH5FLYc0DT1-4DG2Y5wNA>
    <xme:Xk_jX4PAJzRofDogwghEEiIOxTGaUeCAm1yHZTod29gSeU6NmIRwOJCPhPW1H0dVI
    WG9Q1PYK9JjGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Xk_jX2aheLDmc6exVRzrUGIlZpoZNnkozK_apDWT4fVlLVdK37fMMw>
    <xmx:Xk_jX8pk5PajVGW4h5BvB5mlcsc9ktj1Xcl_t6ieRztNzgr6WIWRGQ>
    <xmx:Xk_jX6bpzlCIxP35hkkEnUgtUNx3iNd5cQf0F-z4PdEE96MtN4VLhg>
    <xmx:X0_jX4WJsrVD2k2uLcivmm5p_pu-XpU8SZdbIvnd4YFKLvdzOJhZxuqiYtE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89961240057;
        Wed, 23 Dec 2020 09:08:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 4.19-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:09:42 +0100
Message-ID: <1608732582239152@kroah.com>
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

