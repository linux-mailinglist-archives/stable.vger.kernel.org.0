Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1847AC9A10
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJCIlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:41:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51287 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfJCIlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:41:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E456621B84;
        Thu,  3 Oct 2019 04:41:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hjl7rb
        NZSlLNsBebAUy7cob6uS3hWmjpMiWokaNddVo=; b=lWo/TU8/WG1Vrp9eXYcX35
        gUB3vARLDDSprIYEoU1TmU9zhdkbGVX24cpZwWu1wjz2uqtCttMN3JOzyjqmvirr
        63LrPqeFn1x5Yx0jUPpVC0EUXASNACrgiogtBk2YzAjo430uA8ag5jB3E76oNwkm
        /YDKoKkXM4t+WxpbijCdJdrjm0Voxx5pAw46J/O4nDFtoDAqrnjHOGmrvj5Xw5xX
        GeVz4ujd9LOKQv2aTj7wBOLO/tR8nm/YwGp5/ZUt+A7qMcwdxeVip7boNloB4yLn
        7s37RZ7iOn/Xoqw3Nd6kwgD6qeTE7s+/9OxzkpRUBZVGhV3Q5D5cT6W5a7cf7FSA
        ==
X-ME-Sender: <xms:MrSVXcajymKR9jl5zapNN3JXml9vRVlJY1VIMPwCwGVFos_oW4wVnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:MrSVXY-b-pY2huAnOpE3rt5_Cu_hgY1uqbqjqHUGJzBOy4VE8PeLew>
    <xmx:MrSVXdScFlLQqxzLGaUnhjwxIDImS2vHg-yEcUg8KI-jP2NzC4BKfg>
    <xmx:MrSVXSd3nSPigCn3-Wv46DrzZjJh1k7tWxIUS87UQDydm5cr11eVjA>
    <xmx:MrSVXY7n-g64An5h45mKAmEkNgS8KjzF5pbFDzGcMAJIz3mFYd8Xrw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D7B5D60057;
        Thu,  3 Oct 2019 04:41:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: erofs: add two missing erofs_workgroup_put for" failed to apply to 5.3-stable tree
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:41:21 +0200
Message-ID: <1570092081139135@kroah.com>
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

From 138e1a0990e80db486ab9f6c06bd5c01f9a97999 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:23 +0800
Subject: [PATCH] staging: erofs: add two missing erofs_workgroup_put for
 corrupted images

As reported by erofs-utils fuzzer, these error handling
path will be entered to handle corrupted images.

Lack of erofs_workgroup_puts will cause unmounting
unsuccessfully.

Fix these return values to EFSCORRUPTED as well.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-4-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 87b0c96caf8f..23283c97fd3b 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -357,14 +357,16 @@ static struct z_erofs_collection *cllookup(struct z_erofs_collector *clt,
 	cl = z_erofs_primarycollection(pcl);
 	if (unlikely(cl->pageofs != (map->m_la & ~PAGE_MASK))) {
 		DBG_BUGON(1);
-		return ERR_PTR(-EIO);
+		erofs_workgroup_put(grp);
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	length = READ_ONCE(pcl->length);
 	if (length & Z_EROFS_PCLUSTER_FULL_LENGTH) {
 		if ((map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT) > length) {
 			DBG_BUGON(1);
-			return ERR_PTR(-EIO);
+			erofs_workgroup_put(grp);
+			return ERR_PTR(-EFSCORRUPTED);
 		}
 	} else {
 		unsigned int llen = map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT;

