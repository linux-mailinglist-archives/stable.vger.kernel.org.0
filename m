Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFACD25D791
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgIDLh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:37:56 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38375 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730197AbgIDLhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 07:37:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B74F41941707;
        Fri,  4 Sep 2020 07:37:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 07:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FK5HHU
        f+StRyIu6qj3KUZ1neB6ctZHs7htvwz5indfY=; b=jz+heJLuUxWDNyDvDR4e/4
        n4yk3ggagFm7I5iOs9gsxpo0HXQ9v1QGOpNMRqW63rX670rnCuXD1fn8dWmDxLQ7
        pPEFP5Cw2l/CoL/nGBI/ZEzc3HQK1+SVYEkSLjXoBfq6V8Oo0xaSfTj7+dMHM5CU
        d7rjTa1OHA1yksusXzjjRZ+x6tGmmvPuNNQAExQf0WDDJKgLkFQmtAimPipCIcTx
        KV6fkGWC4m8UDGTv/0hMjGDG8C/x/YOUOEcj6jULQrQeqM0jgw29eI/Z05OU5fV5
        nOwmPJGIeBLY+NnmQsad3KJR7nZq3ybwQKtzYhr9w8FBybBTlllwX7JGQY3l04Zw
        ==
X-ME-Sender: <xms:_yZSXzT1Ujwe1u-1RA5DY7xrubyy-r8TSHGFdbB9WjKnpvvrtCzK6g>
    <xme:_yZSX0w7haOpox2IUxbTy5NdLe0rv5ryqntz4AAfjFfVuA-wlvj8aU9P5rAh9Xju1
    17v3L-cP-fXPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_yZSX43fcNxbDh5MgeaywK1XieNXXcYZow7nT7jfOLm9NB9kX9Grkg>
    <xmx:_yZSXzBJx-U0MjUXPRUhvX2bMAmjS6whuCurNKdI_BVnKPiixb0piw>
    <xmx:_yZSX8gNHzaAWAtOr688Y7Isrd_G-uvcLnwY3U3a7SSEtBjE_eQAAg>
    <xmx:_yZSX4ZKbOQP_7eTxbODmNbyno84hXpm_jdDdSXnkZmdtRvYGWbZtw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C510328005D;
        Fri,  4 Sep 2020 07:37:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later" failed to apply to 4.9-stable tree
To:     skomatineni@nvidia.com, jonathanh@nvidia.com,
        stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 13:37:49 +0200
Message-ID: <1599219469469@kroah.com>
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

From f7f86e8ac0ad7cd6792a80137f5a550924966916 Mon Sep 17 00:00:00 2001
From: Sowjanya Komatineni <skomatineni@nvidia.com>
Date: Thu, 27 Aug 2020 10:20:57 -0700
Subject: [PATCH] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data
timeout.

So, this patch adds "tmclk" to Tegra sdhci clock property in the
device tree binding.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 5.4
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Link: https://lore.kernel.org/r/1598548861-32373-4-git-send-email-skomatineni@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
index 2cf3affa1be7..96c0b1440c9c 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
@@ -15,8 +15,15 @@ Required properties:
   - "nvidia,tegra210-sdhci": for Tegra210
   - "nvidia,tegra186-sdhci": for Tegra186
   - "nvidia,tegra194-sdhci": for Tegra194
-- clocks : Must contain one entry, for the module clock.
-  See ../clocks/clock-bindings.txt for details.
+- clocks: For Tegra210, Tegra186 and Tegra194 must contain two entries.
+	  One for the module clock and one for the timeout clock.
+	  For all other Tegra devices, must contain a single entry for
+	  the module clock. See ../clocks/clock-bindings.txt for details.
+- clock-names: For Tegra210, Tegra186 and Tegra194 must contain the
+	       strings 'sdhci' and 'tmclk' to represent the module and
+	       the timeout clocks, respectively.
+	       For all other Tegra devices must contain the string 'sdhci'
+	       to represent the module clock.
 - resets : Must contain an entry for each entry in reset-names.
   See ../reset/reset.txt for details.
 - reset-names : Must include the following entries:
@@ -99,7 +106,7 @@ Optional properties for Tegra210, Tegra186 and Tegra194:
 
 Example:
 sdhci@700b0000 {
-	compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
+	compatible = "nvidia,tegra124-sdhci";
 	reg = <0x0 0x700b0000 0x0 0x200>;
 	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
@@ -115,3 +122,22 @@ sdhci@700b0000 {
 	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
 	status = "disabled";
 };
+
+sdhci@700b0000 {
+	compatible = "nvidia,tegra210-sdhci";
+	reg = <0x0 0x700b0000 0x0 0x200>;
+	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
+		 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+	clock-names = "sdhci", "tmclk";
+	resets = <&tegra_car 14>;
+	reset-names = "sdhci";
+	pinctrl-names = "sdmmc-3v3", "sdmmc-1v8";
+	pinctrl-0 = <&sdmmc1_3v3>;
+	pinctrl-1 = <&sdmmc1_1v8>;
+	nvidia,pad-autocal-pull-up-offset-3v3 = <0x00>;
+	nvidia,pad-autocal-pull-down-offset-3v3 = <0x7d>;
+	nvidia,pad-autocal-pull-up-offset-1v8 = <0x7b>;
+	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
+	status = "disabled";
+};

