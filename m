Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F21F9B54
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgFOPDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:03:42 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58169 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730665AbgFOPDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:03:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9469C19404A0;
        Mon, 15 Jun 2020 11:03:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TgoyZs
        AmYYg1EZCglQKxnZLeiS+dLqPPCXQ0cyxYCbw=; b=q7IoJt5z1xkaAyXQZCF3nI
        ewoWA+k7Xzgija2uqcraNi6nZShxQuE+onm2cfa0LTJYqMX8vgetARU0AvXYnBbN
        EYI//phODonJJrsL3F2U/hxja1NBYqU/eU6dObXAg5G8v7941ZrMqER4ZbHWxnQj
        XW1fl6vPnlVCWXUUaDHFpGpUpPlKomDX7MqzTl9AQ8Oglq2ONUtvdM4h6k408EAW
        6L5HtpXWCqZFSIW+fKa4Wb6hTqSJO0xB3qb5mAnT4AeSv42F0IO2mK6FuZJYoLkE
        +6muPdLCU2Nd0T/bAnE43UBJSqyJn2us0BQPMRq7w1tddrE06uu4QxAyAuizJ4dg
        ==
X-ME-Sender: <xms:zY3nXhqSrhBYcqeR7-J3aI0GSXz0g1mc0zJnjUkbO56C8agtYO0LuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:zY3nXjqthXW2G9_nQ2RAmGlhkBEASKspAAdyw2XU0RJz4Y9VwiEUoA>
    <xmx:zY3nXuM1ZRiISd-4oy4Awlvq--Dv97tUwgXsnL9jwBEhpNMGqzL9Cw>
    <xmx:zY3nXs5PqR2-R8NnQtJ8VGLGo6KIooVs5yWtf5ZzMqMBMAUbLwfiVg>
    <xmx:zY3nXuRGgZHQUVBA5QlcsxW6pKd_BkXk0UWfN3VntTudPZcDCjXhhw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4E7F3061856;
        Mon, 15 Jun 2020 11:03:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] firmware: imx: scu: Fix corruption of header" failed to apply to 5.4-stable tree
To:     franck.lenormand@nxp.com, aisheng.dong@nxp.com,
        leonard.crestez@nxp.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:03:29 +0200
Message-ID: <1592233409240152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5f27b79eab80de0287c243a22169e4876b08d5e Mon Sep 17 00:00:00 2001
From: Franck LENORMAND <franck.lenormand@nxp.com>
Date: Thu, 26 Mar 2020 00:00:05 +0200
Subject: [PATCH] firmware: imx: scu: Fix corruption of header

The header of the message to send can be changed if the
response is longer than the request:
 - 1st word, the header is sent
 - the remaining words of the message are sent
 - the response is received asynchronously during the
   execution of the loop, changing the size field in
   the header
 - the for loop test the termination condition using
   the corrupted header

It is the case for the API build_info which has just a
header as request but 3 words in response.

This issue is fixed storing the header locally instead of
using a pointer on it.

Fixes: edbee095fafb (firmware: imx: add SCU firmware driver support)

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index e94a5585b698..b3da2e193ad2 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -158,7 +158,7 @@ static void imx_scu_rx_callback(struct mbox_client *c, void *msg)
 
 static int imx_scu_ipc_write(struct imx_sc_ipc *sc_ipc, void *msg)
 {
-	struct imx_sc_rpc_msg *hdr = msg;
+	struct imx_sc_rpc_msg hdr = *(struct imx_sc_rpc_msg *)msg;
 	struct imx_sc_chan *sc_chan;
 	u32 *data = msg;
 	int ret;
@@ -166,13 +166,13 @@ static int imx_scu_ipc_write(struct imx_sc_ipc *sc_ipc, void *msg)
 	int i;
 
 	/* Check size */
-	if (hdr->size > IMX_SC_RPC_MAX_MSG)
+	if (hdr.size > IMX_SC_RPC_MAX_MSG)
 		return -EINVAL;
 
-	dev_dbg(sc_ipc->dev, "RPC SVC %u FUNC %u SIZE %u\n", hdr->svc,
-		hdr->func, hdr->size);
+	dev_dbg(sc_ipc->dev, "RPC SVC %u FUNC %u SIZE %u\n", hdr.svc,
+		hdr.func, hdr.size);
 
-	size = sc_ipc->fast_ipc ? 1 : hdr->size;
+	size = sc_ipc->fast_ipc ? 1 : hdr.size;
 	for (i = 0; i < size; i++) {
 		sc_chan = &sc_ipc->chans[i % 4];
 

