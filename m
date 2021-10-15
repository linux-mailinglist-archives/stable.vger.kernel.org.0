Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B813242F158
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhJOMva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 08:51:30 -0400
Received: from mail.fris.de ([116.203.77.234]:38738 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239055AbhJOMv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 08:51:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 41977BFBC1;
        Fri, 15 Oct 2021 14:49:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1634302160; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=ASU5798wbjyfntomXYBm/w7Sw55/N1d+AALWtX/tmJU=;
        b=l9mW+XFqQb9EmkCJeaZAzRqKQ4rMt/oDW+UOibKjwZafpgV6EvSebUcSo1qJOS4mOBraW/
        EEJ/GrTZqh16gDMB1NO4tGgX9xe9vR4dIUnuGlLe3t7ZiJQEMGnn0mfzulQAYHAKoOMrnD
        nMRzUFpewV2qUJb2HQdLRIKk18DjKvM7EQUJ15qYPm3t1mFhOoE2tg2KAIL61TnhnBNi0u
        MRyvdXxtrfVon0tyj2tegNmo9pWf4+cBjDfMAF+gTWeX1ngZWPQVxIHSghuSxmzYIoyF4q
        NZmkcZntxK9o8UvK63zcax6N0J7dIKEpKHcihATzg7/EnluLD3apqSyWokuYZg==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH v2 3/6] arm64: dts: imx8mm-kontron: Set lower limit of VDD_SNVS to 800 mV
Date:   Fri, 15 Oct 2021 14:48:37 +0200
Message-Id: <20211015124841.28226-4-frieder@fris.de>
In-Reply-To: <20211015124841.28226-1-frieder@fris.de>
References: <20211015124841.28226-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

According to the datasheet the typical value for VDD_SNVS should be
800 mV, so let's make sure that this is within the range of the
regulator.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Fix the commit ref in the Fixes tag
  * Only set lower limit of regulator as upper limit matches range
    im datasheet.
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index 4df45b5e5f6e..1a2a9110e3d1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -153,7 +153,7 @@ reg_nvcc_snvs: LDO1 {
 
 			reg_vdd_snvs: LDO2 {
 				regulator-name = "ldo2";
-				regulator-min-microvolt = <850000>;
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
 				regulator-boot-on;
 				regulator-always-on;
-- 
2.33.0

