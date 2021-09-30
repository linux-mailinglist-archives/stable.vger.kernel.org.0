Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6141DE31
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347379AbhI3P6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347341AbhI3P6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 11:58:43 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3D5C06176A;
        Thu, 30 Sep 2021 08:57:01 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 12663BFC3C;
        Thu, 30 Sep 2021 17:56:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633017419; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=alEtzVuLTEICfKOFXlZGbyKnKgKOip/2lnlXzNX7clA=;
        b=pd27ZR7mWJcMy5DoHaXlVvvVLSGMOOPW9rMkbCymCOEU5VFZ+obesIqg09PE5GEihgiAYR
        TApUbCcjUP3bHPodbv9mnuLL/wzH9WoOJvKChOXsrlWzXkwza2n3zD0xoTm1T6GiOEhWJY
        Qh9piO0Avz0LeDCGwVzHO0Knkst+ZoGuSjKGMjzC+dntFgIXn7KSSZqBJ2LsG6e79Dz7io
        jkPmADsk3ai5/UpvDO7Vi/VV8JX3sQ0DGhWqO1NDpSDHF4AvzL1d5/eveLGQOaaNFMIENa
        gvH5YSxiuu2WWTx5DfdoRMxAfcWPo1mLn7dyYsAoj/BE3VOhouFt71Y9O/7j9A==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH 3/8] arm64: dts: imx8mm-kontron: Set VDD_SNVS to 800 mV
Date:   Thu, 30 Sep 2021 17:56:26 +0200
Message-Id: <20210930155633.2745201-4-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-1-frieder@fris.de>
References: <20210930155633.2745201-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

According to the datasheet VDD_SNVS should be 800 mV, so let's
make sure that the voltage won't be different.

Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index b12fb7ce6686..213014f59b46 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -152,8 +152,8 @@ reg_nvcc_snvs: LDO1 {
 
 			reg_vdd_snvs: LDO2 {
 				regulator-name = "ldo2";
-				regulator-min-microvolt = <850000>;
-				regulator-max-microvolt = <900000>;
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <800000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
-- 
2.33.0

