Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8EE404F07
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245295AbhIIMQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351793AbhIIMKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F88D619F7;
        Thu,  9 Sep 2021 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188100;
        bh=FT1WNIhf/t1k+WrTQhN5g0QjMZtSCFbXIR7DRyrzoX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8v2CBir2fLTBTtGqgc81R9VBzs1Ug+VCplHOCwLgn91zbuvasj/i5KFIO0FKshdp
         BkGNqhQNHY6iD+6OKYc/SCd97oXGA5+SvN2dMM1TPlbAYbYvCyK/XoON3K4X8YGaFy
         pXQDeFa/I915ScxAfGNe4HCF6MQ2nGsKl4+MUQJImGnxsh4O/kW/ueJfHaXq33DKg6
         vxRXIVybYkb/QzX5H+45xlbx46TqTmVLMJIOWVfBt171AGN85fHwvlXhLvsY5X7VH6
         0Y3g2JFcxYj/9s3NuK3PPh8AEZeD2XukGRnp5xeMv+G1C50v7FvxcdPUPzQ72ebHST
         Hd8uE8qeeIj8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 081/219] ARM: dts: stm32: Update AV96 adv7513 node per dtbs_check
Date:   Thu,  9 Sep 2021 07:44:17 -0400
Message-Id: <20210909114635.143983-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 1e6bc5987a5252948e3411e5a2dbb434fd1ea107 ]

Swap reg and reg-names order and drop adi,input-justification
and adi,input-style to fix the following dtbs_check warnings:
arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dt.yaml: hdmi-transmitter@3d: adi,input-justification: False schema does not allow ['evenly']
arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dt.yaml: hdmi-transmitter@3d: adi,input-style: False schema does not allow [[1]]
arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dt.yaml: hdmi-transmitter@3d: reg-names:1: 'edid' was expected
arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dt.yaml: hdmi-transmitter@3d: reg-names:2: 'cec' was expected

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 64dca5b7f748..6885948f3024 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -220,8 +220,8 @@ &i2c2 {	/* X6 I2C2 */
 &i2c4 {
 	hdmi-transmitter@3d {
 		compatible = "adi,adv7513";
-		reg = <0x3d>, <0x2d>, <0x4d>, <0x5d>;
-		reg-names = "main", "cec", "edid", "packet";
+		reg = <0x3d>, <0x4d>, <0x2d>, <0x5d>;
+		reg-names = "main", "edid", "cec", "packet";
 		clocks = <&cec_clock>;
 		clock-names = "cec";
 
@@ -239,8 +239,6 @@ hdmi-transmitter@3d {
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
 		adi,input-clock = "1x";
-		adi,input-style = <1>;
-		adi,input-justification = "evenly";
 
 		ports {
 			#address-cells = <1>;
-- 
2.30.2

