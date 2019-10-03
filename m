Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818E9C9A14
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfJCIll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53315 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIll (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F8E420EAA;
        Thu,  3 Oct 2019 04:41:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v1HaYL
        Q6pzH+Gp1QkrAbmR1z7k+hw16K7J49pO3wKuI=; b=iBWjsEkPLz+sWkdOEDQl1n
        3gp6Fh28xC/+x4Mjyi2waHqf7IcN8LRChtET6TKs3S/yYq+PMlPtYf4zKs3NIN5g
        5moU80RXkTHu2l6wKl1+Lrj/33Y8ebqLupQiZ1eSrDYWFvZz+xKDXNBFh/ziPZFk
        K3jCbQVpB91ZuDLsUqgUqjZswbs4zksZJBz7Ruy84iCdZagnYfmRqcoLwycTYfhj
        7usA4hZ52qgjMgwC8A/pnI+5TFgLDDLZEIvJMP14XumN6+LEjgUC+LoD+ypAx+lO
        qcrdAUg4tfF/EEaqJrs3HzQEbEX+JWxgymyWV8yszIdiXgAE9BVT9+38CjSzGFBQ
        ==
X-ME-Sender: <xms:RLSVXbPtZK_hnFPfki7ePtNYzk1KBrEDHX6j7sofnqRP3zcSStLQtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepke
X-ME-Proxy: <xmx:RLSVXRixw8Rixyr9CtbMPkNpOoGkCnEj4evkpXag3m8pqgUKHRdjDg>
    <xmx:RLSVXRhBXd_XF4NG5Ev7HC8cdYOOFumE3dXbD9dGvoyiD1n3-pX42w>
    <xmx:RLSVXYGKJAUr-5hRwgARF1UA_3AD1CzLWZdjbu1LruwSBS-zQTqu7w>
    <xmx:RLSVXUOXIUx6VuIhVKxCMSnS4Kg4wlm9RkHbNH2Mn86YkoUlGW0XdA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C4D5D60062;
        Thu,  3 Oct 2019 04:41:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: detect potential multiref due to corrupted" failed to apply to 5.3-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:39 +0200
Message-ID: <1570092099109138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e12a0ce2fa69798194f3a8628baf6edfbd5c548f Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Wed, 21 Aug 2019 22:01:52 +0800
Subject: [PATCH] staging: erofs: detect potential multiref due to corrupted
 images

As reported by erofs-utils fuzzer, currently, multiref
(ondisk deduplication) hasn't been supported for now,
we should forbid it properly.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190821140152.229648-1-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 4d6faaab04f5..60d7c20db87d 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -798,6 +798,7 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
+	err = 0;
 	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_NR_INLINE_PAGEVECS,
 				  cl->pagevec, 0);
 
@@ -819,8 +820,17 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 		DBG_BUGON(pagenr >= nr_pages);
-		DBG_BUGON(pages[pagenr]);
 
+		/*
+		 * currently EROFS doesn't support multiref(dedup),
+		 * so here erroring out one multiref page.
+		 */
+		if (unlikely(pages[pagenr])) {
+			DBG_BUGON(1);
+			SetPageError(pages[pagenr]);
+			z_erofs_onlinepage_endio(pages[pagenr]);
+			err = -EFSCORRUPTED;
+		}
 		pages[pagenr] = page;
 	}
 	z_erofs_pagevec_ctor_exit(&ctor, true);
@@ -828,7 +838,6 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	overlapped = false;
 	compressed_pages = pcl->compressed_pages;
 
-	err = 0;
 	for (i = 0; i < clusterpages; ++i) {
 		unsigned int pagenr;
 
@@ -852,7 +861,12 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 			DBG_BUGON(pagenr >= nr_pages);
-			DBG_BUGON(pages[pagenr]);
+			if (unlikely(pages[pagenr])) {
+				DBG_BUGON(1);
+				SetPageError(pages[pagenr]);
+				z_erofs_onlinepage_endio(pages[pagenr]);
+				err = -EFSCORRUPTED;
+			}
 			pages[pagenr] = page;
 
 			overlapped = true;

