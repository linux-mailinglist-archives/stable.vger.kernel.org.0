Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A635AE05
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJOOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:14:06 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38837 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhDJOOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:14:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id DBB871940A35;
        Sat, 10 Apr 2021 10:13:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hCdGpm
        YadjttiWOhxAR4guqsFMxvLyNYHagaVmVzl4w=; b=fJOZcgr9dLgTHKxRctYnfj
        Zo4LQW8un8YIAGz12SEctggi5yyYlHW8sd8FJGSI/XA//4SKUtJuFFH5GD1es+CY
        lTdN+F1vhQuKzQmhfUcmnmvP46YKxBBF03miYYABJfVgnR8RAQ8TT4DUalBCxbiF
        DhUVkb83oaUNhZMfw7WWVSJvAYTbWd/borDWpoKJYt+eo7bESySbLdKnOYMbEYXI
        UCL24Z+AcRmmSiuL6UiMR1zc6y+TSQXSpKwVqYF/NDz4vjh6e/xLQpPcsWPDxumt
        idqFcAfXjKIdRMijP/1L6lak46CevDr8pkyrOPVYi6kJIDHRKX3t0zflqUOj77pg
        ==
X-ME-Sender: <xms:nrJxYJIArAY2DV8IxFqHbh247JSJ-YtmtQ1N2DV7I8buCZDGbSIDgA>
    <xme:nrJxYFKGTcrte-JJIQlVMoXx_Jzrqvo2hOMra4gosnx4SQZyMMw2soc1zwCN9Xx1J
    9sdL_WmmDLlJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:nrJxYBs1qLCIMuX6caxC4Ytz8LNDPaK-Fk5eEH8N3Ht6fE46qk9C4Q>
    <xmx:nrJxYKZKHPvuxn1wwb7ocFAb-vbl2MiQ33cnymW1mvcnj5DeZzPBhg>
    <xmx:nrJxYAaxaFc6r1brxiCuJjM_NEt0c101aDpgGq7fBPGzNSo6DTEVHw>
    <xmx:nrJxYPmYGle5oX9ENa_9fpMRqk1JU4FYE5wIH9lFnRo6q1X2MAN0_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F5B5240054;
        Sat, 10 Apr 2021 10:13:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG" failed to apply to 5.4-stable tree
To:     martin.blumenstingl@googlemail.com, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:13:48 +0200
Message-ID: <161806402817433@kroah.com>
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

From 4b5923249b8fa427943b50b8f35265176472be38 Mon Sep 17 00:00:00 2001
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 8 Apr 2021 20:38:28 +0200
Subject: [PATCH] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG
 bits

There are a few more bits in the GSWIP_MII_CFG register for which we
did rely on the boot-loader (or the hardware defaults) to set them up
properly.

For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
bit and also we should un-set it for non-RMII PHYs. The
GSWIP_MII_CFG_RMII_CLK bit is ignored for other PHY connection modes.

The GSWIP IP also supports in-band auto-negotiation for RGMII PHYs when
the GSWIP_MII_CFG_RGMII_IBS bit is set. Clear this bit always as there's
no known hardware which uses this (so it is not tested yet).

Clear the xMII isolation bit when set at initialization time if it was
previously set by the bootloader. Not doing so could lead to no traffic
(neither RX nor TX) on a port with this bit set.

While here, also add the GSWIP_MII_CFG_RESET bit. We don't need to
manage it because this bit is self-clearning when set. We still add it
here to get a better overview of the GSWIP_MII_CFG register.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 126d4ea868ba..bf5c62e5c0b0 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -93,8 +93,12 @@
 
 /* GSWIP MII Registers */
 #define GSWIP_MII_CFGp(p)		(0x2 * (p))
+#define  GSWIP_MII_CFG_RESET		BIT(15)
 #define  GSWIP_MII_CFG_EN		BIT(14)
+#define  GSWIP_MII_CFG_ISOLATE		BIT(13)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
+#define  GSWIP_MII_CFG_RGMII_IBS	BIT(8)
+#define  GSWIP_MII_CFG_RMII_CLK		BIT(7)
 #define  GSWIP_MII_CFG_MODE_MIIP	0x0
 #define  GSWIP_MII_CFG_MODE_MIIM	0x1
 #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
@@ -821,9 +825,11 @@ static int gswip_setup(struct dsa_switch *ds)
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	/* Disable the xMII link */
+	/* Disable the xMII interface and clear it's isolation bit */
 	for (i = 0; i < priv->hw_info->max_ports; i++)
-		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
+		gswip_mii_mask_cfg(priv,
+				   GSWIP_MII_CFG_EN | GSWIP_MII_CFG_ISOLATE,
+				   0, i);
 
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
@@ -1597,6 +1603,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -1609,7 +1618,11 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII_ID:

