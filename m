Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEF62F0E3F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbhAKIgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:36:10 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:48085 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbhAKIgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:36:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4A01A24CC;
        Mon, 11 Jan 2021 03:35:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:35:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wG/76N
        PrmGpgpigXFNJT61EYEyGof8xOtuaMDEuhpyY=; b=ZEkX165CnYKcavGLUNByT2
        9Bl3HgfG2o4AJVs7K27ohKFg8sJ9SeX7xwwNlBmbRHCrGqAi5WxpmuEB5gr1J5Um
        nTVrVXd4rGEoskDxYe9VQP7o/nLmLWNj287nhDQFvvzUVywEgXACVzwmPkeXEAH3
        COYchiKO/Rpz9vuezB6Lv0vAU+kVorx99+Qrz4PPmiXCYAPBQXokehdU5B8S2Pc4
        sgyypjWui+Y5NPX0DF9DO9SVWYHUkM4OWHA43qEa42jLkYXRaZfC+z+OahFBRNxx
        uPBELjwxjMIHwFMSCb1jdSH8ghuZqJIhAEjVfSpY8UNB2HNesIgbFLXpJMpK60/Q
        ==
X-ME-Sender: <xms:tg38X71mMyFUCQkCpl5FaoKnLSViIVv4MSw-cxZYJCOXcFAvMSrnJQ>
    <xme:tg38X6GoYjVtUAmdk-zEdyTQdFt5AEl5gi5KhQP1xPOc2UkvTb_unpPHU0hZChtCu
    vxXRnGZI4v2VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tg38X77KTmhtbMfvosHlIIK3bvrmaPzOBR_W7Tso5N_ck5cJACaa3A>
    <xmx:tg38Xw1zviORWDYVpzX7Uvm4GONyTpq8yMV6nEhfNRR_2cmlYlYLAQ>
    <xmx:tg38X-FutOUqUCktfTdtCTvHEfni8-rhVx_Vo89cfpgGuqc3CZC4sQ>
    <xmx:tw38XwPzObQT5CwTw5QGuQSnibAGx0jqZrnH5nu7WZVu6f7V-jTHPLDl1U0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2230240066;
        Mon, 11 Jan 2021 03:35:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: ulpi: Use VStsDone to detect PHY regs access" failed to apply to 4.4-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:36:14 +0100
Message-ID: <16103541747717@kroah.com>
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

From ce722da66d3e9384aa2de9d33d584ee154e5e157 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:06 +0300
Subject: [PATCH] usb: dwc3: ulpi: Use VStsDone to detect PHY regs access
 completion

In accordance with [1] the DWC_usb3 core sets the GUSB2PHYACCn.VStsDone
bit when the PHY vendor control access is done and clears it when the
application initiates a new transaction. The doc doesn't say anything
about the GUSB2PHYACCn.VStsBsy flag serving for the same purpose. Moreover
we've discovered that the VStsBsy flag can be cleared before the VStsDone
bit. So using the former as a signal of the PHY control registers
completion might be dangerous. Let's have the VStsDone flag utilized
instead then.

[1] Synopsys DesignWare Cores SuperSpeed USB 3.0 xHCI Host Controller
    Databook, 2.70a, December 2013, p.388

Fixes: 88bc9d194ff6 ("usb: dwc3: add ULPI interface support")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-2-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 2f95f08ca511..1b241f937d8f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -285,6 +285,7 @@
 
 /* Global USB2 PHY Vendor Control Register */
 #define DWC3_GUSB2PHYACC_NEWREGREQ	BIT(25)
+#define DWC3_GUSB2PHYACC_DONE		BIT(24)
 #define DWC3_GUSB2PHYACC_BUSY		BIT(23)
 #define DWC3_GUSB2PHYACC_WRITE		BIT(22)
 #define DWC3_GUSB2PHYACC_ADDR(n)	(n << 16)
diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index aa213c9815f6..3cc4f4970c05 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -24,7 +24,7 @@ static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 
 	while (count--) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
-		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
+		if (reg & DWC3_GUSB2PHYACC_DONE)
 			return 0;
 		cpu_relax();
 	}

