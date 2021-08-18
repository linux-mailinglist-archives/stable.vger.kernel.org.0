Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64BC3EFD52
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbhHRHHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:07:16 -0400
Received: from ixit.cz ([94.230.151.217]:57550 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237071AbhHRHHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:07:16 -0400
Received: from newone.lan (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 880B224A25;
        Wed, 18 Aug 2021 09:06:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1629270400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WgG9ikwnq/iSv9vXxg8WvGTiEr+XcXyKH5UkHvML3gY=;
        b=eGuwGije7HaXmKIIynRhIBfej9xfY8zbJXaSQ5aw6ptB867EmBrzxeUkSE4u9aVL1EaQqm
        6ZbjlIY46/TdnziiGHKgJJOVUHWItlqAIhl8fkqHwiBrdls/o8etgAn3M2wx6e7MWFjvLO
        7fhgV9ixITRziFEbBLzcu8eXMLMpMTE=
From:   David Heidelberg <david@ixit.cz>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        David Heidelberg <david@ixit.cz>, stable@vger.kernel.org
Subject: [PATCH RESEND] ARM: dts: qcom: nexus7: define touchscreen properties
Date:   Wed, 18 Aug 2021 09:04:41 +0200
Message-Id: <20210818070440.21589-1-david@ixit.cz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This change makes touchscreen work as expected on Nexus 7 2013 (tested).

Cc: <stable@vger.kernel.org>

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dts | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dts b/arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dts
index 197494ef887b..800e79e97d28 100644
--- a/arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dts
@@ -299,11 +299,17 @@ i2c@16280000 {
 				pinctrl-0 = <&i2c3_pins>;
 				pinctrl-names = "default";
 
-				trackpad@10 {
+				touchscreen@10 {
 					compatible = "elan,ekth3500";
 					reg = <0x10>;
+
 					interrupt-parent = <&tlmm_pinmux>;
 					interrupts = <6 IRQ_TYPE_EDGE_FALLING>;
+
+					touchscreen-size-x = <2240>;
+					touchscreen-size-y = <1350>;
+					touchscreen-swapped-x-y;
+					touchscreen-inverted-x;
 				};
 			};
 		};
-- 
2.32.0

