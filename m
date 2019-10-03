Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4F9C9A0E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfJCIlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58773 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DF4EB21EAE;
        Thu,  3 Oct 2019 04:41:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NGNf69
        WN27MHY/Sst8ZbPqc0AiYa5tpAZjQq7uHRQS0=; b=mOB7QW+G7PzVQZxUczVLB5
        zN0Lj/yPo0opM3NhtVMU1gyl4R89isyker9AGXpegd+PG24Tj4w1PbXzRNib6GNk
        fSQ5hPbY0wKNRUn1pnnqpg+sadkY4oa4QvJH5NAWauNWw20c9FU6Q/0epzuwRWKw
        ymIKMjuNmrQMsXOFbfl6vhpalyNI4o/NrxBgUvksHWHGr4b1OjKHcSo02pDDkyqC
        +RClGI8gRtc2mrqtscDtoMFKXkSyTYCDGBnu8mh5XIyhq7FkXtaIoZ3NZBPNbHqc
        aHcmLL1ybbqbMy6VlJ0G3yHj/uTHKVplxevuy956MYUzKkM0vOSDvMniPt3Zit7Q
        ==
X-ME-Sender: <xms:KLSVXYRD0JkCDB6ghD0tv9sgYzKRMenRysuyO36NBKnpONi4o2Oc1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:KLSVXQCQ9utznGRG5KEo03Dbx7UspZm3qie9JnwpWtaQKPNwkWBCPA>
    <xmx:KLSVXUz8n7ochWHzxxD2sH1rpLaeax3kokjOLsENOTD1inSV4n-uyg>
    <xmx:KLSVXTrTGc9tYAKkNW7pv4dygK-XEru2DtFhyX8x5235-i3wu6ZReg>
    <xmx:KLSVXUFUnEhL3d6fSQXa2X8SPp0Zqdmq623E_AnGkcCEEuMU6x_cXg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F3378005A;
        Thu,  3 Oct 2019 04:41:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: some compressed cluster should be submitted" failed to apply to 5.2-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:02 +0200
Message-ID: <1570092062198241@kroah.com>
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

From ee45197c807895e156b2be0abcaebdfc116487c8 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:21 +0800
Subject: [PATCH] staging: erofs: some compressed cluster should be submitted
 for corrupted images

As reported by erofs_utils fuzzer, a logical page can belong
to at most 2 compressed clusters, if one compressed cluster
is corrupted, but the other has been ready in submitting chain.

The chain needs to submit anyway in order to keep the page
working properly (page unlocked with PG_error set, PG_uptodate
not set).

Let's fix it now.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-2-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 2d7aaf98f7de..87b0c96caf8f 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -1307,19 +1307,18 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_collector_end(&f.clt);
 
-	if (err) {
+	/* if some compressed cluster ready, need submit them anyway */
+	z_erofs_submit_and_unzip(inode->i_sb, &f.clt, &pagepool, true);
+
+	if (err)
 		errln("%s, failed to read, err [%d]", __func__, err);
-		goto out;
-	}
 
-	z_erofs_submit_and_unzip(inode->i_sb, &f.clt, &pagepool, true);
-out:
 	if (f.map.mpage)
 		put_page(f.map.mpage);
 
 	/* clean up the remaining free pages */
 	put_pages_list(&pagepool);
-	return 0;
+	return err;
 }
 
 static bool should_decompress_synchronously(struct erofs_sb_info *sbi,

