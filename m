Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F24261B6D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbgIHTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:03:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56591 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731279AbgIHQHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:07:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B3908F8D;
        Tue,  8 Sep 2020 10:47:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 10:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=asCX3A
        WWL173VyhHHkpcTWA0db1GSpgeahXq6//P5aQ=; b=PYFxIikgooC0akuC34GdXq
        8raz4Esn3qxIJdMGlypIuYXIxjzFWhRp+FLylttj7RXejgnytJL2XXfLzUJ6pTYl
        NygcgSsqkbYqbHi2S+OJkEXYYo4s6dIsaUju7eNmblleZacykDWV9o9zXjR9zLmF
        xcfQOjkvERw5Z0IrsB2xFwUFhXJq4jWj1R0z6Ohhr3qV7IljC3+IpTfJwOAyrZlU
        NK6niwAV1ejG74U5l/aPh1u2drPN1uEE1b0R4o2UZxlKfmzwaZYOyD45LN7w05tI
        NJOF3Dv7H9a+u7zLfVy/TIrNs6LlpmMhB/lX9zGMBim8iXJNoy77do4bapaGy/qg
        ==
X-ME-Sender: <xms:fplXX3Au9Lsqn_GfhCCEfBjIY04YoHGQAdoG53WUFkcmGYmkgHCOEA>
    <xme:fplXX9iB5p9KJaEUtr8bWyr3fwmD2mg1Noi_ha8zMfi5sq8TAiJYV4Cb1eWYBztos
    p6NhMjpZzidhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fplXXymxTSgok0yiRyHwxQi_3Fycsof-blsGMZkleWQoDxfzWkUmfw>
    <xmx:fplXX5yw7hq0qA5QoEX4APl3olDIsBHdAmABKmfWeKo5b55ZcZmh4w>
    <xmx:fplXX8QeYT6JAWiBFs52Ex8XkilePbWoNuIcvAgTOau9Nfe3nAF1HA>
    <xmx:fplXX3fAv0cY9lKiJzMf31_B2VEKzsmmuXuL5SfAtnPzUV1VIX_gaHFG3Dw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3AF63280065;
        Tue,  8 Sep 2020 10:47:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sdhci: tegra: Add missing TMCLK for data timeout" failed to apply to 4.9-stable tree
To:     skomatineni@nvidia.com, adrian.hunter@intel.com,
        jonathanh@nvidia.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 16:47:37 +0200
Message-ID: <1599576457252228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8048822bac01936fda2c7b924a52131da81e6198 Mon Sep 17 00:00:00 2001
From: Sowjanya Komatineni <skomatineni@nvidia.com>
Date: Thu, 27 Aug 2020 10:21:01 -0700
Subject: [PATCH] sdhci: tegra: Add missing TMCLK for data timeout

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

Tegra210 and later has a separate sdmmc_legacy_tm (TMCLK) used by Tegra
SDMMC hawdware for data timeout to achive better timeout than using
SDCLK and using TMCLK is recommended.

USE_TMCLK_FOR_DATA_TIMEOUT bit in Tegra SDMMC register
SDHCI_TEGRA_VENDOR_SYS_SW_CTRL can be used to choose either TMCLK or
SDCLK for data timeout.

Default USE_TMCLK_FOR_DATA_TIMEOUT bit is set to 1 and TMCLK is used
for data timeout by Tegra SDMMC hardware and having TMCLK not enabled
is not recommended.

So, this patch adds quirk NVQUIRK_HAS_TMCLK for SoC having separate
timeout clock and keeps TMCLK enabled all the time.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Link: https://lore.kernel.org/r/1598548861-32373-8-git-send-email-skomatineni@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 31ed32101055..13fbf70b5fde 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -110,6 +110,12 @@
 #define NVQUIRK_DIS_CARD_CLK_CONFIG_TAP			BIT(8)
 #define NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING		BIT(9)
 
+/*
+ * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for Tegra
+ * SDMMC hardware data timeout.
+ */
+#define NVQUIRK_HAS_TMCLK				BIT(10)
+
 /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Higher */
 #define SDHCI_TEGRA_CQE_BASE_ADDR			0xF000
 
@@ -140,6 +146,7 @@ struct sdhci_tegra_autocal_offsets {
 struct sdhci_tegra {
 	const struct sdhci_tegra_soc_data *soc_data;
 	struct gpio_desc *power_gpio;
+	struct clk *tmclk;
 	bool ddr_signaling;
 	bool pad_calib_required;
 	bool pad_control_available;
@@ -1433,7 +1440,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK,
 	.min_tap_delay = 106,
 	.max_tap_delay = 185,
 };
@@ -1471,6 +1479,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
 		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK |
 		    NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
 	.min_tap_delay = 84,
 	.max_tap_delay = 136,
@@ -1483,7 +1492,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK,
 	.min_tap_delay = 96,
 	.max_tap_delay = 139,
 };
@@ -1611,6 +1621,43 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 		goto err_power_req;
 	}
 
+	/*
+	 * Tegra210 has a separate SDMMC_LEGACY_TM clock used for host
+	 * timeout clock and SW can choose TMCLK or SDCLK for hardware
+	 * data timeout through the bit USE_TMCLK_FOR_DATA_TIMEOUT of
+	 * the register SDHCI_TEGRA_VENDOR_SYS_SW_CTRL.
+	 *
+	 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is set to 1 and SDMMC uses
+	 * 12Mhz TMCLK which is advertised in host capability register.
+	 * With TMCLK of 12Mhz provides maximum data timeout period that can
+	 * be achieved is 11s better than using SDCLK for data timeout.
+	 *
+	 * So, TMCLK is set to 12Mhz and kept enabled all the time on SoC's
+	 * supporting separate TMCLK.
+	 */
+
+	if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK) {
+		clk = devm_clk_get(&pdev->dev, "tmclk");
+		if (IS_ERR(clk)) {
+			rc = PTR_ERR(clk);
+			if (rc == -EPROBE_DEFER)
+				goto err_power_req;
+
+			dev_warn(&pdev->dev, "failed to get tmclk: %d\n", rc);
+			clk = NULL;
+		}
+
+		clk_set_rate(clk, 12000000);
+		rc = clk_prepare_enable(clk);
+		if (rc) {
+			dev_err(&pdev->dev,
+				"failed to enable tmclk: %d\n", rc);
+			goto err_power_req;
+		}
+
+		tegra_host->tmclk = clk;
+	}
+
 	clk = devm_clk_get(mmc_dev(host->mmc), NULL);
 	if (IS_ERR(clk)) {
 		rc = PTR_ERR(clk);
@@ -1654,6 +1701,7 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 err_rst_get:
 	clk_disable_unprepare(pltfm_host->clk);
 err_clk_get:
+	clk_disable_unprepare(tegra_host->tmclk);
 err_power_req:
 err_parse_dt:
 	sdhci_pltfm_free(pdev);
@@ -1671,6 +1719,7 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 	reset_control_assert(tegra_host->rst);
 	usleep_range(2000, 4000);
 	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(tegra_host->tmclk);
 
 	sdhci_pltfm_free(pdev);
 

