Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6E2E3513
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgL1Iad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:30:33 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44985 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgL1Iad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:30:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5F9966C3;
        Mon, 28 Dec 2020 03:29:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Kb1Qdb
        r2z7tGbF3kHoY56ZclbQhTi6yviOlMco+Vvj4=; b=l9KZXP6bnYkkpsJ1jhx06Y
        Knkxx/k7NNoxY6AHcF18HOad4hO1K4PTG1ooRc3yyaA7QlAXaUk9JYig09mqcdAa
        n89jbdmvU+YIE2szeDD82piMFizYvwSfENZF/+cthcO4wEfhT75voSBbb3sG8IrL
        lEUOaF8KeJcnp9zABt7KJNgYsEbaBl3+x27RPEQC5r8ypW28ntyOZS4I/VyKWBrb
        5Y5+71zsDfo0iKq3SdZDjsH8bCXQvDP9XKsUqKQ0Prb2UL5YEPXt8+57rK8FkiDv
        sCmNDp2vcV0hlIsuTqDbPpbOFT6dh6J/xa4p+JOsObbM9xZWGBo/lSrxHmZv5EdQ
        ==
X-ME-Sender: <xms:ZpfpX3Af_DWV3BOdmKMvVfcYSEv_d0z3H_qNDD0csE4mXsAbDwr9nA>
    <xme:ZpfpX9gezuNal5if9c53FMqmewi21ZqyfjZBac4G9D3hHLEVGP5apxIS9tAqs4l-4
    d_1fYzZdd7chg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZpfpXymK-eRrSql5xzYwdKeNsPw4wXn_1iTPXtWeLv859h5pDVvaBA>
    <xmx:ZpfpX5wVEOGx4f44IGDXe_Q99Vj3SJoS83G4ZaVJEiwxId_q2rbNJg>
    <xmx:ZpfpX8QfV7cT7z665yDShvOaS_myv1G5R9BWwORvPTF2iCGEYhqjzA>
    <xmx:ZpfpX3K4YR_WW8IeBG0couB_e7gMH3Xeytu3v3DJXtcKWInq0v9bSR-G-Bg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 896AE24005C;
        Mon, 28 Dec 2020 03:29:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/dasd: fix hanging device offline processing" failed to apply to 4.4-stable tree
To:     sth@linux.ibm.com, axboe@kernel.dk, hoeppner@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:30:50 +0100
Message-ID: <160914425080196@kroah.com>
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

