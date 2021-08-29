Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE83FABFD
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbhH2Nlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:41:37 -0400
Received: from ixit.cz ([94.230.151.217]:44248 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhH2Nlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 09:41:36 -0400
Received: from newone.lan (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 12D4124A25;
        Sun, 29 Aug 2021 15:40:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1630244443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2KajGvqCju+1gvJfaiTG8Fg6T94crQ7Uhr2z6vX74k=;
        b=ym+N4LZi2te6stX8Lt2p6ya8OUvf3xmqj2l4QOPIWxwEe6qreeYB05j49fISdeezHQiMHX
        8Oh/FDkBhOm0T/r5HqzMKA01M1eOzIm4xmMUGBiCRTl1cyQjmfb0CNYqmiSvSl8L8WixHC
        NPJJXsF6hcJPlN9cR9nqrPrzHMTFat0=
From:   David Heidelberg <david@ixit.cz>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        David Heidelberg <david@ixit.cz>, stable@vger.kernel.org
Subject: [PATCH 2/3] ARM: dts: qcom-apq8064: adreno: update clock names
Date:   Sun, 29 Aug 2021 15:39:17 +0200
Message-Id: <20210829133918.57780-2-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210829133918.57780-1-david@ixit.cz>
References: <20210829133918.57780-1-david@ixit.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on Nexus 7 2013, no functional changes.

Cc: <stable@vger.kernel.org>

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 4327f362cb7e..429dd96ade6f 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1154,10 +1154,10 @@ gpu: adreno-3xx@4300000 {
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "kgsl_3d0_irq";
 			clock-names =
-			    "core_clk",
-			    "iface_clk",
-			    "mem_clk",
-			    "mem_iface_clk";
+			    "core",
+			    "iface",
+			    "mem",
+			    "mem_iface";
 			clocks =
 			    <&mmcc GFX3D_CLK>,
 			    <&mmcc GFX3D_AHB_CLK>,
-- 
2.33.0

