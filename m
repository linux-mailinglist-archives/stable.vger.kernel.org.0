Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B117404B1B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbhIILuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241332AbhIILq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 110D2611BF;
        Thu,  9 Sep 2021 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187787;
        bh=FT1WNIhf/t1k+WrTQhN5g0QjMZtSCFbXIR7DRyrzoX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QreT/9nmsWdSJhPythTBz/557ImcHVydqjdLHRspHKOFRA4xOo/SZhNu3CwvEuPxF
         IF6uFDWRhX0f0/Ge5bkOuUgizExS1qe5Ho01lQZXHeSL1FkjYUCjYP1VPN4wI7RcOO
         Z4QI4OpZDcksl7nzobnD66c+a3E31KQtgYmD4s6njcrhyhfvjzRxKiCrdoe8XhGz+y
         NzunKL8T301VsjNUdHEZVattdl+jWT78KOAVEzeBXiBOaqzouc21e8a3i/mPVgrgJY
         aSHU3pZHo8XL7x3arLI7qRQzS4HpE9HAQsZFBBDTjKuiZUbV5YoRfZEIu98bOKUSgt
         eHr7AJ+D4w7zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 094/252] ARM: dts: stm32: Update AV96 adv7513 node per dtbs_check
Date:   Thu,  9 Sep 2021 07:38:28 -0400
Message-Id: <20210909114106.141462-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

