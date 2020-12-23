Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085A62E1CF7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgLWOKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:10:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51223 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728449AbgLWOKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:10:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8B6A53B3;
        Wed, 23 Dec 2020 09:09:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dXeyVi
        jy7FCplrnZG4SQiqn/oKX9nh7G9VjrlUFk8fI=; b=EuXeB9ax+gkCZo74+eDqUk
        bqhmGS2XYeGFcifZk3iblRgnu1Vw+xGIVQ0rojtF15Sd7sRgZ5QK+PTEvdGxF+Dy
        rBXyEMqnIgv1xVtnStacS3MOjks3bXb8IG2/NtBgOsgLkpEB2YfP4JqfQw6OmVxC
        XuYUovfN2fPH0M5aY6O6aVGOyx47hf8mx7LJxmkEiadk+eSoA9Ad4pmpEO+z2EZ0
        oTKqRPqSiw+AB6aFRzRtHrOTy0lSw7fDIV3+1H7MyStxPORVrX+x96D011OKlVt2
        nySbjHTA0jpEgTJQhlndFl7zL0Z+9RPzqppTzhmPrfMMcLNm7sj+RmkBhighYjmg
        ==
X-ME-Sender: <xms:gU_jX4iri1kfy7NpdMaEwH0fsROldOw63yx2H_S64DZkw7OxCPcnVg>
    <xme:gU_jXxBV6vVATsbpaF9wn6n6WDyatD-PvoZk-HPjveR278oF0Gm2mfQ3txbQe3RtC
    wpD7MtC3E2gCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gU_jXwHwUn8PCnLhTW58wM4Wzh8FaKcdpD1451rWo0MD3ocjfFISjg>
    <xmx:gU_jX5SCwB3llkHi9KRbvXTMgL3yb7Qj3ns1uDDCqtL1hjLzYelqTQ>
    <xmx:gU_jX1xV_JQLpUJYHSh_fljkSuVqtHMM1B6vEQEc-v8xL8e5yzI_1g>
    <xmx:gk_jX-sZHukgMttrDvZM5p_Qzo7kdm3SwvvIe_dyWNu9_m43KC0Dcw8SghU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 947481080057;
        Wed, 23 Dec 2020 09:09:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 5.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:10:17 +0100
Message-ID: <1608732617173208@kroah.com>
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

