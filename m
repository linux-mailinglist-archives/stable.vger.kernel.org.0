Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684364F2833
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiDEILS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiDEIFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:05:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A372C574A3;
        Tue,  5 Apr 2022 01:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41264617B4;
        Tue,  5 Apr 2022 08:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DD5C340EE;
        Tue,  5 Apr 2022 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145675;
        bh=D9I+rGgfR4xsdgyZ9tEUcIy10T7OjvR2xyL8W/yW+GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaEgYJn1rsCvDLnRz3Jcrz0WteeYFQ64CpIMnqjKv+i4AE7/c4D8YVYPk50zNd4I8
         OOY/xcE5NZLIn5W3BVSGT/BL8oHpL7dFFaLPp6elAtGdQ6ZOgI7WU8jpm/SZzU6x5f
         zCUT4ahcgGiKSoXpigFCYqE8AH/0tLJYrfE1KyTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0489/1126] powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch
Date:   Tue,  5 Apr 2022 09:20:36 +0200
Message-Id: <20220405070421.981167090@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kiselev <bigunclemax@gmail.com>

[ Upstream commit 5ebb74749202a25da4b3cc2eb15470225a05527c ]

On board rev A, the network interface labels for the switch ports
written on the front panel are different than on rev B and later.

This patch fixes network interface names for the switch ports according
to labels that are written on the front panel of the board rev B.
They start from ETH3 and end at ETH10.

This patch also introduces a separate device tree for rev A.
The main device tree is supposed to cover rev B and later.

Fixes: e69eb0824d8c ("powerpc: dts: t1040rdb: add ports for Seville Ethernet switch")
Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220121091447.3412907-1-bigunclemax@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts | 30 ++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t1040rdb.dts       |  8 +++---
 2 files changed, 34 insertions(+), 4 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
new file mode 100644
index 000000000000..73f8c998c64d
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * T1040RDB-REV-A Device Tree Source
+ *
+ * Copyright 2014 - 2015 Freescale Semiconductor Inc.
+ *
+ */
+
+#include "t1040rdb.dts"
+
+/ {
+	model = "fsl,T1040RDB-REV-A";
+	compatible = "fsl,T1040RDB-REV-A";
+};
+
+&seville_port0 {
+	label = "ETH5";
+};
+
+&seville_port2 {
+	label = "ETH7";
+};
+
+&seville_port4 {
+	label = "ETH9";
+};
+
+&seville_port6 {
+	label = "ETH11";
+};
diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index af0c8a6f5613..b6733e7e6580 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
@@ -119,7 +119,7 @@
 	managed = "in-band-status";
 	phy-handle = <&phy_qsgmii_0>;
 	phy-mode = "qsgmii";
-	label = "ETH5";
+	label = "ETH3";
 	status = "okay";
 };
 
@@ -135,7 +135,7 @@
 	managed = "in-band-status";
 	phy-handle = <&phy_qsgmii_2>;
 	phy-mode = "qsgmii";
-	label = "ETH7";
+	label = "ETH5";
 	status = "okay";
 };
 
@@ -151,7 +151,7 @@
 	managed = "in-band-status";
 	phy-handle = <&phy_qsgmii_4>;
 	phy-mode = "qsgmii";
-	label = "ETH9";
+	label = "ETH7";
 	status = "okay";
 };
 
@@ -167,7 +167,7 @@
 	managed = "in-band-status";
 	phy-handle = <&phy_qsgmii_6>;
 	phy-mode = "qsgmii";
-	label = "ETH11";
+	label = "ETH9";
 	status = "okay";
 };
 
-- 
2.34.1



