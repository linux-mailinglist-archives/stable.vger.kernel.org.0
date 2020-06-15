Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1449A1F9B57
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgFOPDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:03:51 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53455 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730665AbgFOPDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:03:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1E3A019401B4;
        Mon, 15 Jun 2020 11:03:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8tWafM
        aXBB3EkdFSnDVm96WChiUDDZvJB+GoO8ab9X8=; b=U+7jiv/fLYVdoAnx71fiwj
        KyyNaV4hcTu0Zj8astWE2rKL3tjvF+zZd7b/yjxV9ynF8OzDKdP4hkD1zaOrL8TX
        8it5BlscWevBHYNfYvzVZiTlZN2xhVuCQRBmhyhKfF0JfG1O3z+/9ne8ZVmADx8j
        CoTAY8MHI7i7nYgz9ZrWjbd3k0bMGz6H7zuSrSyBJvB8xQsBSdWviDwfih2O4GnW
        TxDevvjOlJy2MasHt/VNa/VLBwIT3ysS7O/wWRu/PLw78L2t0ch/HCjIevfOIuID
        iP6m2E1tpwegTRTgWOC8y5DhA47asyCcMAxERDboSRxvw36rvMGXsy6PelFvSsOw
        ==
X-ME-Sender: <xms:1Y3nXv77RipCL3RkOB1KMGAWH87ltfIrhbQwP0NblWJwayYw-Wq1fA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:1o3nXk6bvaBVyVgzWkWrKH_A7SCTaWM8RTTxz-3DeiKunmRW08HOVg>
    <xmx:1o3nXmeMi5Hch76t2aXux5Ah1VC8W-fPIuMUKxwdF_sXLDLeL0ibvw>
    <xmx:1o3nXgK-Zl6__sDz6M2K1m6oYYN2KsYqfibAaK5WiVBcRmX8rnMolw>
    <xmx:1o3nXpjH4sqdrr3huGkthXPqKmNTHtmjlv00mGEkMGuAuuIsXmaCgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F2813060FE7;
        Mon, 15 Jun 2020 11:03:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] firmware: imx: scu: Fix corruption of header" failed to apply to 5.6-stable tree
To:     franck.lenormand@nxp.com, aisheng.dong@nxp.com,
        leonard.crestez@nxp.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:03:29 +0200
Message-ID: <159223340922147@kroah.com>
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
 

