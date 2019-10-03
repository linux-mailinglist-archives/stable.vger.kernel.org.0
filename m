Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED7DC9A15
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfJCIlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34695 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EDC2421B84;
        Thu,  3 Oct 2019 04:41:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YTm0pb
        X2f5UF7n8tl8QWAVsEt7VJteZRdHPXtdCChTU=; b=qGNsxWQzPYMRKZzTWgPzmn
        VUHcldMCk+6hcD/+QJNI8YBI+vss1NKV2rT/QEpRhkRV7BOUIZ4dAvRdrkzFu/++
        9tqyWIG5xSUQZsHAaSG3b0hHlx0J/Sx8I/MyDdPHm17oCf23aWsLcuKTTSvmRH2F
        w0fvdtH4s6ZKuNbv73fLzea+ELpl7qNczM5U3kxC/Z6Qhl3DfHbS32D24bblVSZ6
        W7vpNQoKE5ZqcFYgchKtXerJaQ6sWpSt99F/IjjEzQKT6FzUKQWVvzIptk+xKbgy
        UZrSrOeYGh0v7L89blmOU5BHkhZc01+Y9W0kU/OI+H25d+SbwRnxuxn2PMpuXtQw
        ==
X-ME-Sender: <xms:TLSVXRw4ylS7cwPGNmEqxypIFg4r69u9voCotHmEiuRXJCrI9mRkxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeple
X-ME-Proxy: <xmx:TLSVXWuh65pkyY5lZVh4AIVONr5_iN-MEPeCPGKO4h7n-Oi1QqhjwQ>
    <xmx:TLSVXQH8BBV7dgYM4CXEgvnuWrMCW_iu9qRXAl_ucC4EFrwob7ubYQ>
    <xmx:TLSVXUeb5-B3N7YtwPpe-VjlgW-NuaKzhkCw3hBxuvyaBQHSPJL9zg>
    <xmx:TLSVXW_Dnrhl9gbKrvasOWbITCtXelu969pGU0tCvKsZ9BzCM5A1Rg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8645980061;
        Thu,  3 Oct 2019 04:41:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: detect potential multiref due to corrupted" failed to apply to 5.2-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:39 +0200
Message-ID: <157009209936117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
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

