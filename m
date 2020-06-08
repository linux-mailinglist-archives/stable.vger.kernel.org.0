Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9681F18AF
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgFHMY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:24:28 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54985 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729628AbgFHMY1 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 8 Jun 2020 08:24:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CCF05610;
        Mon,  8 Jun 2020 08:24:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 08 Jun 2020 08:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d1R1wV
        JjbGihAMADMqbfjAfp6zGoZCM730/stJv0Hyk=; b=HZRUdQOqHIibhRO2WQ1t4f
        Qoz8hTefrNKYe0h43zA2RLMo98B4p0Z4u8XId/C5GW0dznNGOaPdkDiZvevLlfRx
        o1r9I7lV4wHYndcSw1yNKfX6FPWBQ6VbQjMR6PUzc0NzsLyWgQTp0GNhc3I2bhDS
        xdwl+7BS8dfDPwZUms0Ng8z3HSwDB8erZej7+2skkqnngjjC8Yl5u3QrJgs4pwuc
        HkmgmIPPyyqf2Z2nI3xVjuiFqOqt0FWeSjWLACZd2HCLpEmPS3mZGYef0G6I44sq
        +3CRROdzx2ZqvbAtzNWhr6r94MYasZEkGX9XZ6y1h1d3aqTJn+REmmPEeQxK+P6w
        ==
X-ME-Sender: <xms:-i3eXoSzD1vjxb15C3gXk8PWO6HSjM5nIKBQKNYACwRMgBO8dkP4OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-i3eXlwjnh5AaoQUoK6PoJKiIyLkwa7PosZOWFWHV3CBIwNWMVryyg>
    <xmx:-i3eXl0OSnU4G58Ohaz28Ni8HLR1VScyELeJRJHA4yCPdh490zNjcg>
    <xmx:-i3eXsAXD6KiFVcVtzX_lsf2wrSEBkeHsBKHXIgGr-TehPvk91oWvA>
    <xmx:-i3eXrflaNoVCxyuiiD0FJmTq9Zs1CUPx60eE5uxjjQrE3cvthHtLqz5Tuw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13D82306218B;
        Mon,  8 Jun 2020 08:24:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: vcnl4000: Fix i2c swapped word reading." failed to apply to 4.4-stable tree
To:     m.othacehe@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jun 2020 14:24:17 +0200
Message-ID: <159161905713153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

