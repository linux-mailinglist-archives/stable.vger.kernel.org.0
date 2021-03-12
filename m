Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB9338E05
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCLM6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:58:45 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57585 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231625AbhCLM6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:58:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6CC5A1940CE0;
        Fri, 12 Mar 2021 07:58:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=N7LzSd
        p2/wvSbSFNNF/huvj9AF51gt4LJ+ZaRCGJzcs=; b=mTdR1CjlA7ggmvDNQVLHHx
        OyquY60elrHcMpoxbFtiC9ricp+Y/oM7BuRRQi3ynMO/WgtDP3QHszH5TNas+B3g
        uyi1/eCWk5Z65Npo3b0N1CvJvjbBb90OhPmOX/QelijHqXypWfrc6VXFG5cD0GwJ
        +nKBdyewW94rtS9/XR9pyQtkZR5Tpe2p9rnux+Pj7wOR37fff9jcb+89reTuqSZk
        URQPEQrJgH0AKllm+ebgykHcgQzmHnlZd84/uLTkwhRPt+i8Ak8cFRaa99pR10Q6
        lxl2pjUpKGcMF1bOBJXEHDne+WwND6A17XYdMiwHMlciuacuy+QOxgZ5ZvNXWp6g
        ==
X-ME-Sender: <xms:cWVLYNMxurZo-s12eLQU_BV-3lDK6NOlD449xsKcClUIWPtPlKBKKQ>
    <xme:cWVLYP_khEYtcfXbJ0PkQE0M6dV476G9LVv9TAeth3jARfBV-k4SstxxODnFoz6Vc
    DFIOOwwFOa8JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:cWVLYMTyxqApG6rQX-frBzfIIj2MMuezu0oFj56qtAAe88lyXt7Vig>
    <xmx:cWVLYJvhZDw-aanCQsNcWGsGqkeifYW-Fn6p0-A_JwjbYSEdcER0XA>
    <xmx:cWVLYFcVzfo0NissPf7OFt-Ekwave-hqSGQ3ECms_3vWwqyZeXLZfg>
    <xmx:cWVLYFkkDkVRVbGKUpLow9t-u7WmTJNsw82oCz0e4YnG84KMyH_U9A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19F32240065;
        Fri, 12 Mar 2021 07:58:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: stmmac: fix wrongly set buffer2 valid when sph unsupport" failed to apply to 5.4-stable tree
To:     qiangqing.zhang@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:58:23 +0100
Message-ID: <1615553903184182@kroah.com>
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

From 396e13e11577b614db77db0bbb6fca935b94eb1b Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Thu, 25 Feb 2021 17:01:13 +0800
Subject: [PATCH] net: stmmac: fix wrongly set buffer2 valid when sph unsupport

In current driver, buffer2 available only when hardware supports split
header. Wrongly set buffer2 valid in stmmac_rx_refill when refill buffer
address. You can see that desc3 is 0x81000000 after initialization, but
turn out to be 0x83000000 after refill.

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index ee87811b0ca5..cbf4429fb1d2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -533,10 +533,15 @@ static void dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 	*len = le32_to_cpu(p->des2) & RDES2_HL;
 }
 
-static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
+static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr, bool buf2_valid)
 {
 	p->des2 = cpu_to_le32(lower_32_bits(addr));
-	p->des3 = cpu_to_le32(upper_32_bits(addr) | RDES3_BUFFER2_VALID_ADDR);
+	p->des3 = cpu_to_le32(upper_32_bits(addr));
+
+	if (buf2_valid)
+		p->des3 |= cpu_to_le32(RDES3_BUFFER2_VALID_ADDR);
+	else
+		p->des3 &= cpu_to_le32(~RDES3_BUFFER2_VALID_ADDR);
 }
 
 static void dwmac4_set_tbs(struct dma_edesc *p, u32 sec, u32 nsec)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 0aaf19ab5672..ccfb0102dde4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -292,7 +292,7 @@ static void dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 		*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
 }
 
-static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
+static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr, bool is_valid)
 {
 	p->des2 = cpu_to_le32(lower_32_bits(addr));
 	p->des3 = cpu_to_le32(upper_32_bits(addr));
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 7417db31402f..979ac9fca23c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -92,7 +92,7 @@ struct stmmac_desc_ops {
 	int (*get_rx_hash)(struct dma_desc *p, u32 *hash,
 			   enum pkt_hash_types *type);
 	void (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
-	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
+	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr, bool buf2_valid);
 	void (*set_sarc)(struct dma_desc *p, u32 sarc_type);
 	void (*set_vlan_tag)(struct dma_desc *p, u16 tag, u16 inner_tag,
 			     u32 inner_type);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 730f2d71578c..cd7709da0969 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1314,9 +1314,10 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 			return -ENOMEM;
 
 		buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
-		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
 	} else {
 		buf->sec_page = NULL;
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 	}
 
 	buf->addr = page_pool_get_dma_addr(buf->page);
@@ -3659,7 +3660,10 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 					   DMA_FROM_DEVICE);
 
 		stmmac_set_desc_addr(priv, p, buf->addr);
-		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
+		if (priv->sph)
+			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
+		else
+			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;

