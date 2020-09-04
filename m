Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7025D78C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgIDLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:37:55 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42359 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730200AbgIDLhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 07:37:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 102341941759;
        Fri,  4 Sep 2020 07:37:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 07:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Bm7VMN
        9OTc7ZbCNGppU7AH0aTlxKuipnJu398lpN2sA=; b=hDPvOtclIeI4aM2k2pLnCD
        Rscim/g4j7NhEpOpQB3I5etPFPGXwkFkOZUPDtDAxQ/4V27m41fTAzHY5+Uu2U9V
        j+F3o10gXRaststTFyGKtoxRm8vm8VCotJY+BqQdU/SIoD4Git0zJO1Q1Ge6Jok6
        MT5AJIq27a0K4d6it8exAVRmawJUlsXCx1+d0jG+7QR0OncbBD2hsptkiqYcYqUA
        vAP44B6B5l0pg1w4dt2zWWgdCBTJrfiaTq+lh5uemfn3KL9CBk6gnWYW8SuwKeui
        HTNNHcFGQPW+74xD49e0ZNeJMah7XnrOv8PxTcRE+Ubm8XioYm27GwXimNzV05ig
        ==
X-ME-Sender: <xms:ACdSX3IUnSePz9BPMaNmK2gz6tl0NaMkn_7c39pJ61ko3Dm1e8_X8g>
    <xme:ACdSX7I8TvuKh9vQ2v6LmvxFv0z0LfPJMRSsWFyta-RlMSJmOokew-6zVjb-OsXqi
    gtcbUf1Aq3XBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ACdSX_sbUJLa9qGJBnE_B4n1d4T2jWGdV-UdiwZTedxEw5BqhKQ_eg>
    <xmx:ACdSXwbYhv9ttRsKywzzHrfOCsGO0vhU4XXOO9z9Vr2pLnJ-XjovQw>
    <xmx:ACdSX-YiS4i--m0f0DsbyhKQQ5xGctmrTGz-gkHXN_0HOVbe22UUZw>
    <xmx:ASdSXxyewr52mi8bHQtTA2HBwnKgRNg-hJygYcmx0rQUkEWSDzBmDQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3401306005C;
        Fri,  4 Sep 2020 07:37:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later" failed to apply to 4.14-stable tree
To:     skomatineni@nvidia.com, jonathanh@nvidia.com,
        stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 13:37:50 +0200
Message-ID: <159921947078135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

