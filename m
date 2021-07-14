Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5909A3C8CBE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhGNTmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhGNTmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72610613DB;
        Wed, 14 Jul 2021 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291563;
        bh=p+wNoOiuqs77QcyOSnIP1KjMVQOZR1kH1qy9F2dDoL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LACWcHRaCfRWRdzB4LnlUoIGyMuC3Hs3UWVuUtIZoLTVCEHU1N2SvADtDrS2cc9aI
         3zZtqsnG3gCzWZ/6U9gwM01xWOXa9VJmp0kO16lH3M4Ue7QNfebJFMVbO44PVbL9a4
         mZ3kWDsHIbX04vQLGGjE2qYdVCZj7T+k1mRpzDK7HChRTNUW4AotUN4TgIyyuA0Iyj
         6oYE9MQ0SCyRNg4nZfn0WroB2gqGNoI3ZPkf4jTai8kYI25eApIK+sAdsRaurCyZtm
         x0k54Iqrv7ysekjTnLQJKOfa4cotUT6tJMWGsYzsHK7XUBPfdH3TATICF2Alnuli9Y
         2BZRKVsHpYT0w==
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
Subject: [PATCH AUTOSEL 5.13 057/108] ARM: dts: stm32: Remove extra size-cells on dhcom-pdk2
Date:   Wed, 14 Jul 2021 15:37:09 -0400
Message-Id: <20210714193800.52097-57-sashal@kernel.org>
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

