Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CFD3FABFA
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhH2Nla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:41:30 -0400
Received: from ixit.cz ([94.230.151.217]:44240 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhH2Nla (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 09:41:30 -0400
Received: from newone.lan (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id C360A24A25;
        Sun, 29 Aug 2021 15:40:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1630244436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FoA2YS3KMa8UE/1VuabX3g4Ad7vrnmLuVfuvkZVkXz8=;
        b=IbDfo7xpFomAHN8PlDZytXHiNjNyt8LWjRzW1CZ3EYZXm0f9dUrR9XUGzU8ETPkVTrMASJ
        CqUyuuW5EuDDpKS+dgYvjukaKgbD0ckFjMoCa4loHC7rkdkiS2L7duaVdwKJhBuI7EmYFa
        /AVrfTeW79IDjiJHxkGV6z+0hiRqfXU=
From:   David Heidelberg <david@ixit.cz>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        David Heidelberg <david@ixit.cz>, stable@vger.kernel.org
Subject: [PATCH 1/3] ARM: dts: qcom-apq8064: adreno: use compatible which contains chipid
Date:   Sun, 29 Aug 2021 15:39:16 +0200
Message-Id: <20210829133918.57780-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
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
index 22e80c4ba2bb..4327f362cb7e 100644
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
2.33.0

