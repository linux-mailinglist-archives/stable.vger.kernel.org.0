Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25ED1CF3BF
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgELLvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:51:15 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36219 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729761AbgELLvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:51:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id F04186C2;
        Tue, 12 May 2020 07:51:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w4u9vM
        QR9ZFdUXCm1B8M0jWitFISYKkY+HJDRBsvBKg=; b=2Tbb0DLnUQSDo4fUgfS3w3
        kCQW7GyFEW1yupHyQXSctEbOpIrwhxcgte2t1K0cjVHgk+OC7wXuhPAxVy5uY9Zr
        VhEV6NbLYcgdiQKVhnaVQGaCfdoY1QtC0ArvZUMuKTLuAZubP0VuryZrpsCcDslM
        EWXYdTUBJK2bUfJPcmQjOIk8JRneCbwjfkCIwe/gSXNS11t2wcc8tmd5WjAPB4S0
        L3IuoHpOlt1CFRsLsqXPnLyEvaOOV0eA8+r+olhk6pFI2YXrE0RqtZHswscIJ9vs
        AFz0B28MxCs/twKGGtzF/9bQRy5Ek+ztyf0Grrx/aM+g/NLKewXZmTmKyN1anR3A
        ==
X-ME-Sender: <xms:sY26XkJ6qWgi6Qtqk0cfQsB0nP5jTXWZds-2gF8-QzWy8AKW9P556Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:sY26XkJ2zgxShrFlbtU-LSL5GMFLDITTmJhcmqlRBLa6ad89qw-CnA>
    <xmx:sY26Xkv-XyoIzDFSHkVbHwTNy3KYuiJfpkRqxj-OK6Tmkjm2wJfjCA>
    <xmx:sY26XhYUXgWNx8ZodUK4eOZnkfuM-FhTPaatoZrj3fQ4ul5F8_evSg>
    <xmx:sY26Xqnj_Snio-bgpcMfhEErA0-qZsrX5-zX7EKNY51RTrbRCdP-ezn-9uc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3465430662CE;
        Tue, 12 May 2020 07:51:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bdi: add a ->dev_name field to struct backing_dev_info" failed to apply to 5.6-stable tree
To:     hch@lst.de, axboe@kernel.dk, bvanassche@acm.org, jack@suse.cz,
        yuyufen@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 13:51:12 +0200
Message-ID: <158928427224231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6bd87eec23cbc9ed222bed0f5b5b02bf300e9a8d Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 4 May 2020 14:47:56 +0200
Subject: [PATCH] bdi: add a ->dev_name field to struct backing_dev_info

Cache a copy of the name for the life time of the backing_dev_info
structure so that we can reference it even after unregistering.

Fixes: 68f23b89067f ("memcg: fix a crash in wb_workfn when a device disappears")
Reported-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index ee577a83cfe6..7367150f962a 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -219,6 +219,7 @@ struct backing_dev_info {
 	wait_queue_head_t wb_waitq;
 
 	struct device *dev;
+	char dev_name[64];
 	struct device *owner;
 
 	struct timer_list laptop_mode_wb_timer;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c2c44c89ee5d..efc5b83acd2d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -938,7 +938,8 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 	if (bdi->dev)	/* The driver needs to use separate queues per device */
 		return 0;
 
-	dev = device_create_vargs(bdi_class, NULL, MKDEV(0, 0), bdi, fmt, args);
+	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
+	dev = device_create(bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
@@ -1047,7 +1048,7 @@ const char *bdi_dev_name(struct backing_dev_info *bdi)
 {
 	if (!bdi || !bdi->dev)
 		return bdi_unknown_name;
-	return dev_name(bdi->dev);
+	return bdi->dev_name;
 }
 EXPORT_SYMBOL_GPL(bdi_dev_name);
 

