Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555663C8F62
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhGNTwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239440AbhGNTtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E623613E3;
        Wed, 14 Jul 2021 19:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291856;
        bh=Ed0Pg0OWGIFlFZrx0tiPa85Dhwh9kL6vU+lJKFjwC0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GO4vjwFErIr1RObemCrFfdEoX1rWpsxbq6s9YUCtMrWfIRf/wXpghMd4W1Yc2Q8ys
         fabUZluVmS21x/55u3X0grBkilLtq1H0kFPu+pxsoqv6z0PVXVOfkkxDpGhxipBfl6
         dJkC72W/zF0rrV5+xlI7hkx+42U2ViBXrQUGgJ4Hqbs/moW+flhSCQaw6dbgCn0dNc
         4lCB5BIz5ZXaaWkorpMQQDRh0u3/aeS4GKnJpCidqsO+ycRTawgl9OGwgYHAFlT2T6
         AwhiepSXwAZ6Ztiv8dduc5lgKgfl0sYsR/WUMvtop9DEfIPT82gID5S4F82Dh29pUI
         IU+UHvLalKTpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 48/88] ARM: dts: stm32: Fix touchscreen node on dhcom-pdk2
Date:   Wed, 14 Jul 2021 15:42:23 -0400
Message-Id: <20210714194303.54028-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 4b5fadef3fc2ab8863ffdf31eed6a745b1bf6e61 ]

Fix make dtbs_check warning:
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml:0:0: /soc/i2c@40015000/polytouch@38: failed to match any schema with compatible: ['edt,edt-ft5x06']

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 180a0187a956..a2d903c0d57f 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -182,8 +182,8 @@ sgtl5000_rx_endpoint: endpoint@1 {
 
 	};
 
-	polytouch@38 {
-		compatible = "edt,edt-ft5x06";
+	touchscreen@38 {
+		compatible = "edt,edt-ft5406";
 		reg = <0x38>;
 		interrupt-parent = <&gpiog>;
 		interrupts = <2 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
-- 
2.30.2

