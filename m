Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00521F18AE
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgFHMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:24:20 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56007 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729628AbgFHMYU (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 8 Jun 2020 08:24:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3AA725FD;
        Mon,  8 Jun 2020 08:24:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 08 Jun 2020 08:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hmkOqN
        cZlkM2XTX4O6CZh4Aia+qXzsoQ4L+KF31QVs0=; b=CbCKEXKwAljK13KFr32EAW
        SVxY64G1eCVYJKsa6bktYCdmD2sVGVbD5yN2slwJyEDOprMnTkaw5uUrx5EQezQB
        qB2siuBUek7ZoHpckyF3DHZS/gWpIuceWWwhQmcM/8Uh+7MWrf6lFtdDVqPrIChd
        o2pcBJ/qmdAs84HwQpjNcU9beYRImCdUebS461dodePiJxS2aN3Yg3bdlBA1jHVd
        BOUXbwht7p+lIeOmfKJytjZfFf00VDS3KQI+toWETCHbc1on8qtMFbMRuLIl/YT2
        FQIj5MWQVzwO0PRugezMjopUfzbzBVKqZpQctkhQHwP/bCjDZnzWIKYcHBKquKxw
        ==
X-ME-Sender: <xms:8i3eXo7ZlNdFQs53zdCwmmfZD41qVvNyMmh9mZxio4gxkGKfwGu76w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:8i3eXp5RtIDBpSOchJdLob0_BDUy1uIMNmwcTwee-YA4VpTNDlaLaw>
    <xmx:8i3eXncMIwe_HZ49EvFkYvB6kWFhSYhjx3L8hGAz1cdTpqp6pTn0pA>
    <xmx:8i3eXtKktnsGgseOOYzXQTFT29-F7oAoawU5mltRfl5O-6MVj0UD8w>
    <xmx:8i3eXjnaifNhbHzmZ41YKn-d7jt0q7xUlaMqP2z5H7r76lnK45bR2Zm2Mwg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16EB63060F09;
        Mon,  8 Jun 2020 08:24:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: vcnl4000: Fix i2c swapped word reading." failed to apply to 4.14-stable tree
To:     m.othacehe@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jun 2020 14:24:16 +0200
Message-ID: <1591619056246224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 Mon Sep 17 00:00:00 2001
From: Mathieu Othacehe <m.othacehe@gmail.com>
Date: Sun, 3 May 2020 11:29:55 +0200
Subject: [PATCH] iio: vcnl4000: Fix i2c swapped word reading.

The bytes returned by the i2c reading need to be swapped
unconditionally. Otherwise, on be16 platforms, an incorrect value will be
returned.

Taking the slow path via next merge window as its been around a while
and we have a patch set dependent on this which would be held up.

Fixes: 62a1efb9f868 ("iio: add vcnl4000 combined ALS and proximity sensor")
Signed-off-by: Mathieu Othacehe <m.othacehe@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 985cc39ede8e..979746a7d411 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -220,7 +220,6 @@ static int vcnl4000_measure(struct vcnl4000_data *data, u8 req_mask,
 				u8 rdy_mask, u8 data_reg, int *val)
 {
 	int tries = 20;
-	__be16 buf;
 	int ret;
 
 	mutex_lock(&data->vcnl4000_lock);
@@ -247,13 +246,12 @@ static int vcnl4000_measure(struct vcnl4000_data *data, u8 req_mask,
 		goto fail;
 	}
 
-	ret = i2c_smbus_read_i2c_block_data(data->client,
-		data_reg, sizeof(buf), (u8 *) &buf);
+	ret = i2c_smbus_read_word_swapped(data->client, data_reg);
 	if (ret < 0)
 		goto fail;
 
 	mutex_unlock(&data->vcnl4000_lock);
-	*val = be16_to_cpu(buf);
+	*val = ret;
 
 	return 0;
 

