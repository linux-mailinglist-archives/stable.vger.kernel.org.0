Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DB43032E0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbhAZEjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:39:33 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53791 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729494AbhAYOun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:50:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F218DF73;
        Mon, 25 Jan 2021 09:49:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Rjfp0o
        gaCqxnwNC5JG6rYo/AsVB+KMfzprPFxPDvvjQ=; b=HgRS3ZKH3O5N2gByZs+PJL
        /1KP4yD5WEJfQ/9SitmYIP+HOxwJlgpUau5iPhxvY1JqSlkdr+P0fyZxB1xgY9NF
        w85natmRXJnujgodQupbh4+4iUfYASaL7UzVANSjO3LujI5aFWiUH+hy2h2xEqo5
        Rvk3TCDigg7uZKWDYw3G5R7S4zazNpzvPaDbtgLNdYxO8n5Ra7Jn4TBljRBufFh6
        6xWlehyBNOc7WJGWH7jkDJWBXNMlUHas0cevxZkwB7QAXLcyVZXdI9hnm4R4o2Tk
        nDowyI55N0OaiRO9qg9PY+xIhmlBCVX9TcLyUvUNebmfel7MksuULLsZU/PNdGhg
        ==
X-ME-Sender: <xms:atoOYEZe8Pzyoh3Gl4o_ysPSjEU33kBlSilUdcjBAbtbEOYcI9WSsg>
    <xme:atoOYPYjiYth0-hO-5HtnDXulCk8-hQuOLq2oaA3EUlGQQSY_91ktVyoTXFW9JR_8
    pfOtYZsCHhtfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:atoOYO-r2xF8lGUESEalJFJ3dXFOPMH7QEwkUcAjUeIcRw4MyeBlnA>
    <xmx:atoOYOpaOP4jvjZLnZVugGM-Uy_z-a-0Az_NTQTWW53pRzrzE0CDXw>
    <xmx:atoOYPq1qNfyqLznyKv2TcIkxa3ljuSSUw9NY6d533F6Qy27MuIr1Q>
    <xmx:atoOYIAZ5Fo_kimYrbe6GhAQ5tb09wHQUK7faUuXArvl-5WPZsRjybOjR_g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F37BE1080063;
        Mon, 25 Jan 2021 09:49:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] octeontx2-af: Fix missing check bugs in rvu_cgx.c" failed to apply to 5.4-stable tree
To:     wangyingjie55@126.com, gakula@marvell.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:49:12 +0100
Message-ID: <1611586152165188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From b7ba6cfabc42fc846eb96e33f1edcd3ea6290a27 Mon Sep 17 00:00:00 2001
From: Yingjie Wang <wangyingjie55@126.com>
Date: Fri, 15 Jan 2021 06:10:04 -0800
Subject: [PATCH] octeontx2-af: Fix missing check bugs in rvu_cgx.c

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 96be2e0da85e ("octeontx2-af: Support for MAC address filters in CGX")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Reviewed-by: Geetha sowjanya<gakula@marvell.com>
Link: https://lore.kernel.org/r/1610719804-35230-1-git-send-email-wangyingjie55@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index d298b9357177..6c6b411e78fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -469,6 +469,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -485,6 +488,9 @@ int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
 	int rc = 0, i;
 	u64 cfg;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	rsp->hdr.rc = rc;

