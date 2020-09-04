Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5312A25D789
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgIDLhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:37:39 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47011 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbgIDLhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 07:37:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6247B194178B;
        Fri,  4 Sep 2020 07:37:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 07:37:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jWVIQl
        IH3ZRcWGlRQtE9aKwaAOAjuV77Tg/hHe2M7e4=; b=nSdgX+VtB2A30eYqEuqqB8
        6CvSxkXH6+cVb8qm6KnVrFq9zokYTCy/5w/bu809eif6XW5cyK+t3p5/Yl6AbHEI
        DHUhd/wIgE0Ueq9F4+CBfio8qCFhcR3ZBglXtl9BleEST9xgTl3K+J/QI5i7JERJ
        dJodhnm5Bjgxre+x64Hxu23NGiECVzDQQ4DH1xnndNIeqnllAHt9cjxDG9kB/swV
        2APD/ZZXsspXu3PB0T6w38NUHW8z+o5XMtvQmC+hi4dwjw4gwfgvlrouprHwyWD+
        Mx9MLdJNPABf03xgE45ETgXbJflU1U5bM14ktH2PqvY1XvYglcStCTC54CV2y9Jg
        ==
X-ME-Sender: <xms:9yZSX-0AP6NukXNaG8phhC2GOt7MOZzDCtEwGfbFIpNN-sTbiLHKpQ>
    <xme:9yZSXxFvGsVE2iLD7Y_ELLyFshsU5oQ51E2XNnseIjlBnfyAAoIb64AQZgTaRwFnE
    9uhyiRzVGV9BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9yZSX27oFsXn9OMBFAXBs7r9aNF4B2VZr04hYHJTnSikIbRGOR-nAA>
    <xmx:9yZSX_02322jSD6aahYJWomHJRE0rLriYDVvcKIHweIT5IrmPscFhg>
    <xmx:9yZSXxF88aa10PBv2kClVMMuOwFSMdZZT67XdeaAW4ECkdMbGB-nEA>
    <xmx:9yZSX_NE1f1eo5ZhBS1J1K3CFcbn9yaShwq4JQmxg1BfNCzH6okYyA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEF3B306005B;
        Fri,  4 Sep 2020 07:37:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later" failed to apply to 4.19-stable tree
To:     skomatineni@nvidia.com, jonathanh@nvidia.com,
        stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 13:37:48 +0200
Message-ID: <1599219468213210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

