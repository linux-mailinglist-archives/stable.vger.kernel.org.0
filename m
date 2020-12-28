Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF9E2E3511
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgL1Iaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:30:35 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36079 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgL1Iaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:30:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F13E876F;
        Mon, 28 Dec 2020 03:29:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:29:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=leQrwQ
        fseChiLaQROGETPxge3yVX3qEmAJ/NyUsJ0kM=; b=cB69orxoJUBImKMNz/eEFt
        qlfG2Gf60tVKQ5thng3ozIE5JVl91V6sIspmbaDRJ7H+PfLot/r2XP6wW0iE8pKh
        T9T3UXn/di7kh37VoUnBXi0FHZiuMWzQ/z27fPXRI8EweW6vbU47ZnASF79DJo45
        I8N8petvCixezKZhN5ZZRk/LIi5XOmVCksXk/5qtp65/fiastI1XwqxIbvXpkANV
        v+rSfF9E0lp8kNZ+/LqQYsGdvYkKqMg1HXDoWOk2hStjenn/MVflD6TzZFRGiFLa
        gSXgPxp5dbodpIYkbA7zN6pDJuZfIMzr9rGmiHXia50UyeyPKRsMfqZ9lZkXVSMQ
        ==
X-ME-Sender: <xms:aJfpX8dY1xwvfbGvDNYf68W1G-I0NSvAunEx1sobzQ3sWbmeWpt4zA>
    <xme:aJfpX-Oy3XIqnucJ0y6-1hghWZadigc4jPQRNdXv6WmktBHWn7GKs0LdMDqamrCHS
    zW98mzNBMMVfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:aJfpX9h0wdGOeKBy5NRMNCUqXEj3ZfL9by8SZYZcnea5spp2P41fqw>
    <xmx:aJfpXx88XGocUN4i-Ucdf7711UmdZxmSJ4r__ZDzfVKStVu1yqIcvg>
    <xmx:aJfpX4s3IbLRzADMSX5qYcS9MaBaMoKI1q5hxz4bEkiYKwHFcuPUeg>
    <xmx:aJfpX1UMDQxP6bR5qmULC9Pl3RV4Ts8LJeJlJfHOdpeAIXSV0j-gZF9ynuM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 164DC1080057;
        Mon, 28 Dec 2020 03:29:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/dasd: fix hanging device offline processing" failed to apply to 4.9-stable tree
To:     sth@linux.ibm.com, axboe@kernel.dk, hoeppner@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:30:51 +0100
Message-ID: <1609144251244147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

