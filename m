Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8120AC9A0C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfJCIlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44729 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D69921B84;
        Thu,  3 Oct 2019 04:41:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zMyH2I
        JCCKp59CcVaXrSbL6s2wq7IJS6dUdTOl0Q4Bk=; b=rehkHEDMLP78HhTmIf1gdB
        Fjh+I1J2NXgWzQppYvdpQZvvLh+Un3YhkvW9Dw26aCamzIYN67PD0IbQ6XsAHVzG
        I+64gyn0ma5tM3NR9VrJTqEmIAM1HbntlhF9wTyxJ5Vsq1SDW6LtIJIKl2JkntAO
        W9zIUbhpHHGuapZ6IM4Kzq32aLSKc/+3qDlZQw8Q5mBwK+eYgdkPFtQpaZZlb6Gw
        TsmHiB9+eL8KhBSQrrM1rmH411l21kvW4dDm4pK19DyZVsKAI1XacGvItDL6yoVX
        tIM5NT4an2rTwiKoycHXp+6sTuRRFILyFCOkEccypiI5SpSftQOuddIe4xEQpr4w
        ==
X-ME-Sender: <xms:H7SVXYuX4CV1pMLdTp7CHxLKmbz6-Lci4QplNR2RGOstv8byDpSIlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:H7SVXXRTlCzl6mSmHMqiLr_mtAU9y6g0VlQbHK3lg1MF2Q2dVV0KMg>
    <xmx:H7SVXVjqdmMYSy2SsoLraadTv6ADKBHzVKNkXZZDl3qehIrNbzWVew>
    <xmx:H7SVXcahblH0tcvnD46XMb7t1dFEEMIF8DDfhpAYrLBftUSL_E6Qzg>
    <xmx:ILSVXfx1F4F-gY1IdaPYZeQCCxAxtMdgPnDlo1XsfFBakOzfe8EnIg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96F71D60057;
        Thu,  3 Oct 2019 04:41:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: some compressed cluster should be submitted" failed to apply to 5.3-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:02 +0200
Message-ID: <1570092062177157@kroah.com>
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

