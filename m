Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6C93D2879
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhGVP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhGVP5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FFB36135F;
        Thu, 22 Jul 2021 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971868;
        bh=E9pkm4zkkFHOL1rV9ln9ewQPHrGOU2PTd4JreUHm5dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUgHL2vOSS1Jg7/jxgWweUdAVu+BMq4jcq2zQ0NR1RoC+WaqC7UHBERIRPIfHZCb+
         hO24ZQ3D7OAk3GzTMXoaZispeZ/pY3z8QL+J9dx4OFs92KxUpl4lSEyI8cu6gco28T
         BbEFl/J4s/WDxrYPdd9XGTsF7ZLSYQeOrFdTioxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/125] ARM: dts: stm32: Rename spi-flash/mx66l51235l@N to flash@N on DHCOM SoM
Date:   Thu, 22 Jul 2021 18:30:48 +0200
Message-Id: <20210722155626.596278452@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 27f19575fada..c43c5c93f8eb 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -338,7 +338,7 @@
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
@@ -194,7 +194,7 @@
 	#size-cells = <0>;
 	status = "okay";
 
-	flash0: spi-flash@0 {
+	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
-- 
2.30.2



