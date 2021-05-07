Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F72376677
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhEGN5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:57:09 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36955 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234081AbhEGN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:57:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3A5301941607;
        Fri,  7 May 2021 09:56:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 07 May 2021 09:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=91wnwG
        qhcfFRlZJXysfJR8jQLbv3wfikDsjAxyWVWAY=; b=M+6/ZTGTnlR3LrGMVyGUI4
        p5zaVV4xmjoQaoA7XxHoLsaVslPBR9e9BMVhnMafsgTn7g1XWsGuOXuGsbyOeJ2Q
        IRtz2XLtjQkvl5tFzTl/jzZgjQUPOA0hFc3RuOFafR36xQvXB8/Eu+iFCz8F4kZz
        /+dQANRKALtHFM+6day+SGi/lR7Gmd6wwRPMQoXlYHG+vUdFrB1w3zwZ55QWEZN9
        hS3GsqlyocmL/GmFsIot4FXO4kuq+RzBHj4dtdJ8r0FCgDXmh9hasIiHRdyxlNhH
        KJCwdvqc7qVsxIzLhWXQtpRVXal4BAkT6515Ee2US77ry6tiKbkMBfYcXtAONl2g
        ==
X-ME-Sender: <xms:-UaVYKGHG8nQFJkPDxgWYIv0_eZBMgaHrujl7t_BUUCfpwebImb1OQ>
    <xme:-UaVYLWB9UrICdYsYhyHDWY6fID3kRP0VYNslT441QcxJ8ziLBlJWeA387ScFm41u
    2_hasm9isK4AQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-UaVYEIwTf1-WEChUngtDIkpyXf_AzjLU1ex30md8PsiaDdWWx3y4A>
    <xmx:-UaVYEFE9DCV_G00VDPISQsyqws_Gmi34DkFbXmkZU4jQM2sQxptXA>
    <xmx:-UaVYAU6g9Ow5kVJ0bbELWchj-wExkJHGnd21UJ3yH32tZgqgErmOQ>
    <xmx:-UaVYJdTw7dfSvRTx48-QpOnIYx7W-hGXoGDqYTYmdCg8t_pLaVU6A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:56:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] erofs: add unsupported inode i_format check" failed to apply to 4.19-stable tree
To:     hsiangkao@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:56:06 +0200
Message-ID: <162039576612327@kroah.com>
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

From 24a806d849c0b0c1d0cd6a6b93ba4ae4c0ec9f08 Mon Sep 17 00:00:00 2001
From: Gao Xiang <hsiangkao@redhat.com>
Date: Mon, 29 Mar 2021 08:36:14 +0800
Subject: [PATCH] erofs: add unsupported inode i_format check

If any unknown i_format fields are set (may be of some new incompat
inode features), mark such inode as unsupported.

Just in case of any new incompat i_format fields added in the future.

Link: https://lore.kernel.org/r/20210329003614.6583-1-hsiangkao@aol.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 9ad1615f4474..e8d04d808fa6 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -75,6 +75,9 @@ static inline bool erofs_inode_is_data_compressed(unsigned int datamode)
 #define EROFS_I_VERSION_BIT             0
 #define EROFS_I_DATALAYOUT_BIT          1
 
+#define EROFS_I_ALL	\
+	((1 << (EROFS_I_DATALAYOUT_BIT + EROFS_I_DATALAYOUT_BITS)) - 1)
+
 /* 32-byte reduced form of an ondisk inode */
 struct erofs_inode_compact {
 	__le16 i_format;	/* inode format hints */
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 119fdce1b520..7ed2d7391692 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -44,6 +44,13 @@ static struct page *erofs_read_inode(struct inode *inode,
 	dic = page_address(page) + *ofs;
 	ifmt = le16_to_cpu(dic->i_format);
 
+	if (ifmt & ~EROFS_I_ALL) {
+		erofs_err(inode->i_sb, "unsupported i_format %u of nid %llu",
+			  ifmt, vi->nid);
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	vi->datalayout = erofs_inode_datalayout(ifmt);
 	if (vi->datalayout >= EROFS_INODE_DATALAYOUT_MAX) {
 		erofs_err(inode->i_sb, "unsupported datalayout %u of nid %llu",

