Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BA13EFD2C
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 08:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbhHRGzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 02:55:08 -0400
Received: from ixit.cz ([94.230.151.217]:57516 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238539AbhHRGzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 02:55:06 -0400
Received: from newone.lan (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 159A124A25;
        Wed, 18 Aug 2021 08:54:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1629269664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mob8tdsRudWWnyeYi9/HzMgoqWt4HZbOD2Vwam7fWNo=;
        b=qrVODYofm+3vv+rLkCwkYLHeZmHl4J2ZL+XJUe1c6ppdiv7U9RrwKxHZbYCOxmI+a149gS
        4vA9DTxYCDNF1/TPwZs9Gerg1SvXNmUsKGhtCmBH3Fet6AFqBOjv9ozCN7zjxr7XWF5Who
        G0tjSyQAe3f6Fy1lSVR+T2pNq7ylBHg=
From:   David Heidelberg <david@ixit.cz>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        David Heidelberg <david@ixit.cz>, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: qcom-apq8064: use compatible which contains chipid
Date:   Wed, 18 Aug 2021 08:53:17 +0200
Message-Id: <20210818065317.19822-1-david@ixit.cz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Also resolves these kernel warnings for APQ8064:
adreno 4300000.adreno-3xx: Using legacy qcom,chipid binding!
adreno 4300000.adreno-3xx: Use compatible qcom,adreno-320.2 instead.

Tested on Nexus 7 2013, no functional changes.

Cc: <stable@vger.kernel.org>

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 96b7755afabf..7e5e394ff16c 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1148,7 +1148,7 @@ tcsr: syscon@1a400000 {
 		};
 
 		gpu: adreno-3xx@4300000 {
-			compatible = "qcom,adreno-3xx";
+			compatible = "qcom,adreno-320.2", "qcom,adreno";
 			reg = <0x04300000 0x20000>;
 			reg-names = "kgsl_3d0_reg_memory";
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
@@ -1163,7 +1163,6 @@ gpu: adreno-3xx@4300000 {
 			    <&mmcc GFX3D_AHB_CLK>,
 			    <&mmcc GFX3D_AXI_CLK>,
 			    <&mmcc MMSS_IMEM_AHB_CLK>;
-			qcom,chipid = <0x03020002>;
 
 			iommus = <&gfx3d 0
 				  &gfx3d 1
-- 
2.32.0

