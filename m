Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899A13C8D08
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhGNTna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhGNTmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6E260FF2;
        Wed, 14 Jul 2021 19:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291594;
        bh=7hmF5aU5Ljr+2rIxPSbrVHU+IPJG3+GGTORGvp4bE6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl3UB8xWZDzVlcXmmGK8jF0JfP02Etke9nRyKjqco/FZ+TtTDM3EOmc1PJGG0XWrK
         /TUr8EzkwGt26zeqo7JIyN+7BtWODVmdvopwkxkQKM11LQm+iR4YKLT7yI0JnCIuWn
         aBo3ZppMTI73Jf0KI39GaKN/Fm2y//UuUbKMDA7Sih/OubcIodL4lldUY4ptuMIAaV
         AIO6biJpelAbnIZQMTu/cjsVbeohzcGGjjZj1aJ5gs6aVaUCk6dVQcx2ZsSgI/uW7r
         M8Yy3pvInpBUJqzp0J3IlFRym8xDcG6hlaCa5nsLLQuhJYVzY5BqQke6LUjUaTh12v
         qY0Lf2cMP/XFw==
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
Subject: [PATCH AUTOSEL 5.13 078/108] ARM: dts: stm32: Rename spi-flash/mx66l51235l@N to flash@N on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:37:30 -0400
Message-Id: <20210714193800.52097-78-sashal@kernel.org>
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
index ae58f3b4d9d4..260ef8965e08 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -431,7 +431,7 @@ &qspi {
 	#size-cells = <0>;
 	status = "okay";
 
-	flash0: mx66l51235l@0 {
+	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index 013ae369791d..2b0ac605549d 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -198,7 +198,7 @@ &qspi {
 	#size-cells = <0>;
 	status = "okay";
 
-	flash0: spi-flash@0 {
+	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
-- 
2.30.2

