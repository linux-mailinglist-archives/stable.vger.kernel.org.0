Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5FC11F803
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfLONdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:33:09 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59981 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:33:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E829F22233;
        Sun, 15 Dec 2019 08:33:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=K6mydZ
        WXXKkZz8cz6sku2H8/3DBG7o4O5J0FDo/bfVk=; b=Kkrdioo5+yK7g3450nEkWL
        S6xHA2dmSjlSUVoQcBTzdTtsJ7bhrODf2YA+ahmzm/SYduBH8K7zOEZDwFO0+7zm
        aESbhz+HlzLUOUK6MMAEv8yDt0DbWsGdlVLnfDR/Xjr5tzhR4sStk8U2BcvWHVTE
        6NIGfK2PHDZoURZV7x/LC1PC8B0Rr/dAqaPPhdSBq+qHOmpMjE6+Mbn9R+/qHL2G
        QjXGR7BMEDPWKrFe1nw50uD8zNS9ijFau3KwlwzzVjXzechzFlfd5yr19408Bf+a
        6Lvsvwhb1iBug0kV4QWmOCBYp1x37eHrzeTfkJK939XznVtnh68cZstHXK4CNPRQ
        ==
X-ME-Sender: <xms:Ezb2XR5DmC1-VYa70KFTUyclH6p_0v_yKh_P2a8GEoWimULelBQ0HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Ezb2XYmVGxAtlYp3YC7yQL8ajManebT8ZRt73BnMg3IqJemIyQHGJg>
    <xmx:Ezb2Xfag3AeQTJeqjt9CG3LI7T1-h_qjlb_-eiqO3buuVJs7kpzQ_g>
    <xmx:Ezb2XeOpjex4CV63Tpe6jE6NEh8yBbTpz1lDlYkYydPDTKVDvIrWKw>
    <xmx:Ezb2XTaaOPNElapXMmVhKbv-8tZPdXqNSxxE9tWqVFuO-3TePbOP9w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A5A130600D4;
        Sun, 15 Dec 2019 08:33:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and" failed to apply to 4.3-stable tree
To:     hns@goldelico.com, stable@vger.kernel.org, tony@atomide.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:32:58 +0100
Message-ID: <1576416778218226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2398c41d64321e62af54424fd399964f3d48cdc2 Mon Sep 17 00:00:00 2001
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 7 Nov 2019 11:30:39 +0100
Subject: [PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and
 wl1251

With a wl1251 child node of mmc3 in the device tree decoded
in omap_hsmmc.c to handle special wl1251 initialization, we do
no longer need to instantiate the mmc3 through pdata quirks.

We also can remove the wlan regulator and reset/interrupt definitions
and do them through device tree.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.7+
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 800a602c06ec..1b7cf81ff035 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -310,108 +310,15 @@ static void __init omap3_logicpd_torpedo_init(void)
 }
 
 /* omap3pandora legacy devices */
-#define PANDORA_WIFI_IRQ_GPIO		21
-#define PANDORA_WIFI_NRESET_GPIO	23
 
 static struct platform_device pandora_backlight = {
 	.name	= "pandora-backlight",
 	.id	= -1,
 };
 
-static struct regulator_consumer_supply pandora_vmmc3_supply[] = {
-	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2"),
-};
-
-static struct regulator_init_data pandora_vmmc3 = {
-	.constraints = {
-		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(pandora_vmmc3_supply),
-	.consumer_supplies	= pandora_vmmc3_supply,
-};
-
-static struct fixed_voltage_config pandora_vwlan = {
-	.supply_name		= "vwlan",
-	.microvolts		= 1800000, /* 1.8V */
-	.gpio			= PANDORA_WIFI_NRESET_GPIO,
-	.startup_delay		= 50000, /* 50ms */
-	.enable_high		= 1,
-	.init_data		= &pandora_vmmc3,
-};
-
-static struct platform_device pandora_vwlan_device = {
-	.name		= "reg-fixed-voltage",
-	.id		= 1,
-	.dev = {
-		.platform_data = &pandora_vwlan,
-	},
-};
-
-static void pandora_wl1251_init_card(struct mmc_card *card)
-{
-	/*
-	 * We have TI wl1251 attached to MMC3. Pass this information to
-	 * SDIO core because it can't be probed by normal methods.
-	 */
-	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
-		card->quirks |= MMC_QUIRK_NONSTD_SDIO;
-		card->cccr.wide_bus = 1;
-		card->cis.vendor = 0x104c;
-		card->cis.device = 0x9066;
-		card->cis.blksize = 512;
-		card->cis.max_dtr = 24000000;
-		card->ocr = 0x80;
-	}
-}
-
-static struct omap2_hsmmc_info pandora_mmc3[] = {
-	{
-		.mmc		= 3,
-		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
-		.gpio_cd	= -EINVAL,
-		.gpio_wp	= -EINVAL,
-		.init_card	= pandora_wl1251_init_card,
-	},
-	{}	/* Terminator */
-};
-
-static void __init pandora_wl1251_init(void)
-{
-	struct wl1251_platform_data pandora_wl1251_pdata;
-	int ret;
-
-	memset(&pandora_wl1251_pdata, 0, sizeof(pandora_wl1251_pdata));
-
-	pandora_wl1251_pdata.power_gpio = -1;
-
-	ret = gpio_request_one(PANDORA_WIFI_IRQ_GPIO, GPIOF_IN, "wl1251 irq");
-	if (ret < 0)
-		goto fail;
-
-	pandora_wl1251_pdata.irq = gpio_to_irq(PANDORA_WIFI_IRQ_GPIO);
-	if (pandora_wl1251_pdata.irq < 0)
-		goto fail_irq;
-
-	pandora_wl1251_pdata.use_eeprom = true;
-	ret = wl1251_set_platform_data(&pandora_wl1251_pdata);
-	if (ret < 0)
-		goto fail_irq;
-
-	return;
-
-fail_irq:
-	gpio_free(PANDORA_WIFI_IRQ_GPIO);
-fail:
-	pr_err("wl1251 board initialisation failed\n");
-}
-
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	platform_device_register(&pandora_vwlan_device);
-	omap_hsmmc_init(pandora_mmc3);
-	omap_hsmmc_late_init(pandora_mmc3);
-	pandora_wl1251_init();
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 

