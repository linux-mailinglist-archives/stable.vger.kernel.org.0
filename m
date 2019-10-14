Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936EED66EC
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbfJNQLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:11:47 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54073 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731121AbfJNQLr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 14 Oct 2019 12:11:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9902130F;
        Mon, 14 Oct 2019 12:11:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 12:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ym4Lbp
        /iiy04dSAqRPJ3ABI7baU35buy+c5t1XiKGWg=; b=IXY7OMqOVLWRUMLDU5XiFJ
        QRxLPFJhcx3yuBa91oqjC/iZVJO//scqW99cMiFzR0iOIZamySwuHIUVNPC4Kgle
        ozkJYX0AwkaZh6EFCNnGok5Up9dtgYX7+4OIUJr5JXxXOcnSNt9MC+P5RVKyXNuJ
        lMv4buAvSAtOPNnZ6iWJzxG0/DZG8Nz/MofritwBFt5ygrRoELfQBIY9Vz//S/AP
        5un438JWCkOoLoUyi+uX4UxqCpDGxL+lTdgTZKVXeUlc20KSf75ysxkjiofIdI4N
        NNbzHdWxb2rjIaohToFhksRZZVY5pGm7YEPJhasSQQuwQ5PZKkekZCe19rs/963w
        ==
X-ME-Sender: <xms:QJ6kXbxtkHTFXImVaTCQByO7BHKV55zkFBUnI09xKjYCV3FgyDazsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:QJ6kXY8vfkoSahks2Kq3jemXsZlWR1QvzAQQYTnFgqB_L_MGbXVMVA>
    <xmx:QJ6kXWjMoTV70WjZmF_oC7sHCpv7S-kMC-QjokPvO2EpX7GYVyTLsw>
    <xmx:QJ6kXTWy6RrLxJe4NmvOYgDhJOorHFXKcve-tlOf2b9djWpPct7O2Q>
    <xmx:Qp6kXfPQvsaWUvlF7IYQNfswfMA6wXMNKfsipVfFGk7g4YjWC-XZnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75789D60066;
        Mon, 14 Oct 2019 12:11:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: light: fix vcnl4000 devicetree hooks" failed to apply to 5.3-stable tree
To:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 18:11:42 +0200
Message-ID: <1571069502139213@kroah.com>
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

From 1436a78c63495dd94c8d4f84a76d78d5317d481b Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Tue, 17 Sep 2019 16:56:36 +0200
Subject: [PATCH] iio: light: fix vcnl4000 devicetree hooks

Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
the of_match_table is supported but the data shouldn't be a string.
Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
still based on the i2c_device_id no failures did appeared till now.

Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 51421ac32517..f522cb863e8c 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -398,19 +398,19 @@ static int vcnl4000_probe(struct i2c_client *client,
 static const struct of_device_id vcnl_4000_of_match[] = {
 	{
 		.compatible = "vishay,vcnl4000",
-		.data = "VCNL4000",
+		.data = (void *)VCNL4000,
 	},
 	{
 		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4010",
+		.data = (void *)VCNL4010,
 	},
 	{
-		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4020",
+		.compatible = "vishay,vcnl4020",
+		.data = (void *)VCNL4010,
 	},
 	{
 		.compatible = "vishay,vcnl4200",
-		.data = "VCNL4200",
+		.data = (void *)VCNL4200,
 	},
 	{},
 };

