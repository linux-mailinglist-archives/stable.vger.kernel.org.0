Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52641F9B58
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgFOPDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:03:55 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:56963 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730665AbgFOPDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:03:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B0D8B194007D;
        Mon, 15 Jun 2020 11:03:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ws+0cC
        0pF7ldqUsV8lPY2miY4OdDtkA1DwHHglQ2qbs=; b=sR7JKURnsUmL5zWR7Wvw3T
        Hc9SEf89vWwjDDG4px1oemwtr+fmnNAPOEiL+gm/uED6Zs26YdimVIqtUH1p3RU7
        clnddm411W+RI1hqXZYDUUUGxbFzUDA1N9mdCHyvonUq4B/Bo+ln60HUh4/xgOpe
        02HYTaM7GPCUHVQwRBO8SFe9SdVuwsBKjYcLWJv5F/vsDMSs023KD6TcY4OCraAs
        Qj/OWsuN6rPLkVKGXIUFV21DK6y2EnP04UqU7R0uNrKO3LwcTRgu5FK7K9Tgh9fI
        VJEDK7oxP2CdyQseVdWyAwAiqwZcT5ZotBoeMNyGSKhEp/i/watCnsuztafClXfg
        ==
X-ME-Sender: <xms:143nXof60JvQZVi07O3HPJAwyVGbZ1CqVenOH9ZniTW0HBCsw73Vzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:143nXqMRemcEjgDE_rypzw3r1lTGOfT90fq4uPpuNHC0561aFn3Bjg>
    <xmx:143nXphMdk45YiWxBfPKdrrXVxwuTzHzI-qh6SYOEziz7mzNpfxwqA>
    <xmx:143nXt-YMmJ773t8z8bnvDwZKw9ht0LHs2cFYCmgptlSn64zEp0vwQ>
    <xmx:143nXhVBCsoILmuwZYFW2wZVs-R1t8PjDLWVfus_96aBLiQkifFu1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4935D3060FE7;
        Mon, 15 Jun 2020 11:03:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] firmware: imx: scu: Fix corruption of header" failed to apply to 5.7-stable tree
To:     franck.lenormand@nxp.com, aisheng.dong@nxp.com,
        leonard.crestez@nxp.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:03:30 +0200
Message-ID: <15922334107128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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
 

