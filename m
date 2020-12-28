Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427942E3514
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgL1Ia5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:30:57 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57077 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgL1Ia4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:30:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E5E6F731;
        Mon, 28 Dec 2020 03:29:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/ZPRIv
        upT0akOQVBYIdt8jGT7pmJF4DT3DqkuHwhTaE=; b=LVu7K7AmkS1cxN8tPBTuA5
        x8r1tKoS0tsV4NL8Fg9qqI+Vqj8HbLxwrRcadMAst/Gu2VfV5N39CahPL5e9lSBn
        LAUt9N23PZzlldTs+Se/z2K8WqB+YcmzkzB6EHRmdHbnX7RwOGarjkXl3cIwl7aq
        JBGF/09iaddF++fa5szCdCVtYbwEbkPSWEKQ/qpv7UChuNWmG8HQEI+w/IBc34Yx
        eOeukiT0Rnu/oFP+8kqhLxzcg0ZS192xDKDtrV4Pp7PZCfQnNHhynfTIBbxPzf7D
        9mI2oUJMZ9jyaMOBYz0vIJGjS8epCE5DNJyzBtn7Os6Qn7OrVUhZsrn+3OPS7hug
        ==
X-ME-Sender: <xms:fpfpX3NGzBZtg790FdPMiNnbDHXuA4rn0RzrMTVDYD-C2wBWxK7ZBQ>
    <xme:fpfpXx9tPzDTL9C6uBU5rDfwMXUH2LdiT49iew-yFtyyPWV_QH8mMlzqd5hUHsFEN
    DcEbGE8KT9C3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:fpfpX2So__hPMwschIYH2EBSuFZsIsaFdBQGYA5Zcy0yGP8sjutjiQ>
    <xmx:fpfpX7v2N-8BfqgEsrZEtuB6kJVtmqfEHW9d25vYZN0i-C-OV_sq9g>
    <xmx:fpfpX_fTJ_1VX15twE4YUgHAewsget_PBdNaLIphlCiTy3TX2rIryw>
    <xmx:fpfpX3H-0oHwIFXGFC6it_3OMgHZRPbzdX_6aDWuWe2dzS33kXejbQlrFks>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1FF0B108005B;
        Mon, 28 Dec 2020 03:29:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/dasd: prevent inconsistent LCU device data" failed to apply to 4.4-stable tree
To:     sth@linux.ibm.com, axboe@kernel.dk, hoeppner@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:31:13 +0100
Message-ID: <1609144273061@kroah.com>
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

From a29ea01653493b94ea12bb2b89d1564a265081b6 Mon Sep 17 00:00:00 2001
From: Stefan Haberland <sth@linux.ibm.com>
Date: Thu, 17 Dec 2020 16:59:05 +0100
Subject: [PATCH] s390/dasd: prevent inconsistent LCU device data

Prevent _lcu_update from adding a device to a pavgroup if the LCU still
requires an update. The data is not reliable any longer and in parallel
devices might have been moved on the lists already.
This might lead to list corruptions or invalid PAV grouping.
Only add devices to a pavgroup if the LCU is up to date. Additional steps
are taken by the scheduled lcu update.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 31e8b5d48e86..f841518de6c5 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -511,6 +511,14 @@ static int _lcu_update(struct dasd_device *refdev, struct alias_lcu *lcu)
 		return rc;
 
 	spin_lock_irqsave(&lcu->lock, flags);
+	/*
+	 * there is another update needed skip the remaining handling
+	 * the data might already be outdated
+	 * but especially do not add the device to an LCU with pending
+	 * update
+	 */
+	if (lcu->flags & NEED_UAC_UPDATE)
+		goto out;
 	lcu->pav = NO_PAV;
 	for (i = 0; i < MAX_DEVICES_PER_LCU; ++i) {
 		switch (lcu->uac->unit[i].ua_type) {
@@ -529,6 +537,7 @@ static int _lcu_update(struct dasd_device *refdev, struct alias_lcu *lcu)
 				 alias_list) {
 		_add_device_to_lcu(lcu, device, refdev);
 	}
+out:
 	spin_unlock_irqrestore(&lcu->lock, flags);
 	return 0;
 }

