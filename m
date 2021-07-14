Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A23C8CE8
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbhGNTnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235267AbhGNTmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2361E613EB;
        Wed, 14 Jul 2021 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291591;
        bh=fP7fCZMwaijQI8r2+ZPDPxAVoNP7Q+G8DH1ivMJ2CJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEcXiWxGyxuERbxh+TQOsH8I1ql3y4vasBYHCL1oZwSxFohiVCpw4i0idsq3r3eGO
         RcCpAgXn70vL6xOdyVKjmaxXJI1N5oFOS8mJNpYT72D/tHF77onnPvfjwUfyF1h+NK
         PULFH1szQDwvotHFHKPFwLewg9s5kRpPDTPnm1bP52FwwP2Q4SNx9Sjqjpib/qVMog
         QHUQJ6QGAkekKyGbR7z4ZWSXriMQaA5jVJWw77jkF6gysInFVLWnqOas/iJgzGt9RG
         ELzKGqlMIIiT0UEc1+80e6aqmqyI3pbw4WrzzJjQIYH6yxa0ylnwbzXYERK3iMVNs+
         UtgAXZexfvzXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 076/108] ARM: dts: stm32: Drop unused linux,wakeup from touchscreen node on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:37:28 -0400
Message-Id: <20210714193800.52097-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5247a50c8b53ca214a488da648e1bb35c35c2597 ]

Fix the following dtbs_check warning:
touchscreen@38: 'linux,wakeup' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: kernel@dh-electronics.com
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index b8c8f0b284c3..c5ea08fec535 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -187,7 +187,6 @@ touchscreen@38 {
 		reg = <0x38>;
 		interrupt-parent = <&gpiog>;
 		interrupts = <2 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
-		linux,wakeup;
 	};
 };
 
-- 
2.30.2

