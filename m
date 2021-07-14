Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5150E3C8E22
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhGNTqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237343AbhGNTp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A102613D6;
        Wed, 14 Jul 2021 19:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291742;
        bh=zQwGF7FYOzS9A3/b35r9uSjCfXpspF/d10Zu18b6t5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsmeEp9DN2TsyduEBTAAJOHLTGB21P4PYiZ3tThC532KKi0DMIkzLm20/JW/Pc4da
         hzqxIJd5JzHvE9X0jDvbzxauHHkrsUO5zXBPnj+HBaxNZibaDuIsKKpGLfcHRj8nRj
         ojc5QdYH6yzEB+C8AzL5dIsA1mlGFhr5fVFnpPMAtcxOz2XFRLypfQftdzIH0niciW
         PcI36H2Hp5SYn9pfwC8iwPOe/an/ay5hCFS7FSxO02LtCr7Vq7EKSy9M5/x8dh0/o2
         dZpSresH7wsz4hvwSPBHf6/NQMjKY1bVcMtzQNWXjLFz0ShJGOiJfRoIeQDmKWVYVE
         6NlOFmVb/bDTQ==
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
Subject: [PATCH AUTOSEL 5.12 074/102] ARM: dts: stm32: Rename spi-flash/mx66l51235l@N to flash@N on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:40:07 -0400
Message-Id: <20210714194036.53141-74-sashal@kernel.org>
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

[ Upstream commit 9b8a9b389d8464e1ca5a4e92c6a4422844ad4ef3 ]

Fix the following dtbs_check warning:
spi-flash@0: $nodename:0: 'spi-flash@0' does not match '^flash(@.*)?$'

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
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 1c1c4198f2c1..6c8930fc1632 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -367,7 +367,7 @@ &qspi {
 	#size-cells = <0>;
 	status = "okay";
 
-	flash0: mx66l51235l@0 {
+	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index 803eb8bc9c85..a9eb82b2f170 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -194,7 +194,7 @@ &qspi {
 	#size-cells = <0>;
 	status = "okay";
 
-	flash0: spi-flash@0 {
+	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
-- 
2.30.2

