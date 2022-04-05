Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE964F376D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352942AbiDELNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349029AbiDEJs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD3A8897;
        Tue,  5 Apr 2022 02:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F46C61368;
        Tue,  5 Apr 2022 09:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D546C385A2;
        Tue,  5 Apr 2022 09:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151550;
        bh=D9I+rGgfR4xsdgyZ9tEUcIy10T7OjvR2xyL8W/yW+GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnKb0mw2MBcBx5oxXsd2XRJdiRnK01METHlLTMZaaUYqN8gSUPgWu5Gc5qg//BG5W
         70R5RBw0ksd6rzdJc59lumiiNpVx8PS5FtUn9/2wUCm7xxr2kqa2QUDLpP/9tou1fd
         l7YAgCvICrbVoJeIh25yL4YO4g1JEzHpqtEzpJLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/913] powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch
Date:   Tue,  5 Apr 2022 09:24:40 +0200
Message-Id: <20220405070352.376273359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



