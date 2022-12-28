Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C8657BC8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiL1PZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiL1PZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1E1408F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C85BACE076E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7809C433D2;
        Wed, 28 Dec 2022 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241109;
        bh=S4MofCqekZZLQeDNlqqTmspwwgyyYMA449UzYiU88zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TODeH6pM3EpoRa2v62Y9PFJnel4Vvl0w/1uV/YYNA3Vr8Vq3uUDac7gIRJnc8Rd8X
         YAuDcDNxqEp3mNB01ih9vdvg/dBsON8loRrsmEOKDtl+QtEPRRslHLmdpKcSPwL5O6
         pi/o/NE6MZiZQGAJZP0+CFd6yoOCKBzfZVOlfX6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0217/1073] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date:   Wed, 28 Dec 2022 15:30:05 +0100
Message-Id: <20221228144333.909761804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 36926a7d70c2d462fca1ed85bfee000d17fd8662 ]

On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
fragments, and mark the QMAN ports as 10G.

Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
 3 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..74e17e134387 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
-- 
2.35.1



