Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0190E3C8E07
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbhGNTqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235965AbhGNTpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E312D600D4;
        Wed, 14 Jul 2021 19:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291714;
        bh=p+wNoOiuqs77QcyOSnIP1KjMVQOZR1kH1qy9F2dDoL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLB4xYZTtjFNg3JDl3AN3zH6/OBkjl0ZLjAlc6O5dlrwq+LFUG9vnYZUdGaNBoI0e
         pEp8Ln1ueluIgr6iQWP60NWGS3DGWJJZgWdYfjJsiIckEjuDfVrpTVxeG/GFvbfKXz
         ckKshH/GCK3XHWfiZ/ULCh1JAlKRrqUXGYQFBX1v6b/zUMgJo/ZHTc4Wn8Lhbi+1zN
         yI1790Y13teYw6E2rmRuoPV5x1HxLXlsMyy/zcPYNuJJPbErY5WYuW++5oBfSKG0V/
         8WvAZdWnsUtETmnn7c7tNGFj3+9Q2DWOECBvFMvc8gnqramYcq9wA1qVu6Z0RgOEPd
         7+XlRIscPUv6A==
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
Subject: [PATCH AUTOSEL 5.12 055/102] ARM: dts: stm32: Remove extra size-cells on dhcom-pdk2
Date:   Wed, 14 Jul 2021 15:39:48 -0400
Message-Id: <20210714194036.53141-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 28b9a4679d8074512f12967497c161b992eb3b75 ]

Fix make dtbs_check warning:
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: gpio-keys-polled: '#address-cells' is a dependency of '#size-cells'
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: gpio-keys: '#address-cells' is a dependency of '#size-cells'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 5523f4138fd6..0fbf9913e8df 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -34,7 +34,6 @@ display_bl: display-bl {
 
 	gpio-keys-polled {
 		compatible = "gpio-keys-polled";
-		#size-cells = <0>;
 		poll-interval = <20>;
 
 		/*
@@ -60,7 +59,6 @@ button-2 {
 
 	gpio-keys {
 		compatible = "gpio-keys";
-		#size-cells = <0>;
 
 		button-1 {
 			label = "TA2-GPIO-B";
-- 
2.30.2

