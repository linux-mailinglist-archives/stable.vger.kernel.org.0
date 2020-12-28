Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA022E350E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgL1IaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:30:17 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:33319 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgL1IaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:30:16 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BD448772;
        Mon, 28 Dec 2020 03:29:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Dec 2020 03:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Kz/oml
        S/SZmoyjWMklspAfwsdk2hFGUpPr3wQ5uEfpE=; b=Q+fRgqELuUL+Z1O+eyjY07
        OrHLIFwMnQGxYNlCfS9mtrx8+QVj1wfaMmvc2OnFdtF2jaB6xvIOgaYAnt1TSudG
        BbmGq3XjvpP4kAx0R/SWJCkxYUx7tmgpTKIB//d0pIdow5z6m2BF27BaNl1iZAXW
        ZZjEgq/Ksh6+IsdM6LsQJz5GgkckyVE2A3/XZQIO5FmGqImDUuQZQ/FMLQXGa4we
        ACTpoqK+R/C2fbsqsJlrmNgf3R+JUdvjIpIeKWuv2PtLgcH0Lx5coNl3Iuq863Vl
        WNCj+ES2Z3ImB+2F8t337+S+U7/lVz/u/CfO6mB4PLGWd6umVal6vtKDhnGEWVmA
        ==
X-ME-Sender: <xms:apfpX31a-2k1X-cfwem3VNqzB2h0rZCQdu7DUxSAlI4coIf2g5z1cA>
    <xme:apfpX_uHIqCDyddJoMRA8T4ch6whEEvTlx7zWnSfgX_RmJzbLURmyBSObgsVJy3Ko
    iTKmUUQORMjig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:apfpX35fFezjjF_n0lUC0rNoHYFkKOB5hIInIMMh5TZPVQ01rVct-A>
    <xmx:apfpXwLlijldwpFgtTn_cb-453DPXtQ0n6FE5HcpgFCP-ZlGWjlSBA>
    <xmx:apfpX37RhQxXWMW8Tf-3IMYol74caoyMM0qC2wnTlt-XMOm3jDGuXA>
    <xmx:apfpX6WUxhUKEvv-5IjudvX2mb2ra4escTKCkbB2SM6EPnW1ghl-lzMjqqg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D12D324005B;
        Mon, 28 Dec 2020 03:29:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/dasd: fix hanging device offline processing" failed to apply to 4.14-stable tree
To:     sth@linux.ibm.com, axboe@kernel.dk, hoeppner@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:30:52 +0100
Message-ID: <160914425231104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 658a337a606f48b7ebe451591f7681d383fa115e Mon Sep 17 00:00:00 2001
From: Stefan Haberland <sth@linux.ibm.com>
Date: Thu, 17 Dec 2020 16:59:04 +0100
Subject: [PATCH] s390/dasd: fix hanging device offline processing

For an LCU update a read unit address configuration IO is required.
This is started using sleep_on(), which has early exit paths in case the
device is not usable for IO. For example when it is in offline processing.

In those cases the LCU update should fail and not be retried.
Therefore lcu_update_work checks if EOPNOTSUPP is returned or not.

Commit 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
accidentally removed the EOPNOTSUPP return code from
read_unit_address_configuration(), which in turn might lead to an endless
loop of the LCU update in offline processing.

Fix by returning EOPNOTSUPP again if the device is not able to perform the
request.

Fixes: 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
Cc: stable@vger.kernel.org #5.3
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 99f86612f775..31e8b5d48e86 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -462,11 +462,19 @@ static int read_unit_address_configuration(struct dasd_device *device,
 	spin_unlock_irqrestore(&lcu->lock, flags);
 
 	rc = dasd_sleep_on(cqr);
-	if (rc && !suborder_not_supported(cqr)) {
+	if (!rc)
+		goto out;
+
+	if (suborder_not_supported(cqr)) {
+		/* suborder not supported or device unusable for IO */
+		rc = -EOPNOTSUPP;
+	} else {
+		/* IO failed but should be retried */
 		spin_lock_irqsave(&lcu->lock, flags);
 		lcu->flags |= NEED_UAC_UPDATE;
 		spin_unlock_irqrestore(&lcu->lock, flags);
 	}
+out:
 	dasd_sfree_request(cqr, cqr->memdev);
 	return rc;
 }

