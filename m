Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8640E00D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhIPQQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241032AbhIPQPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF2D61263;
        Thu, 16 Sep 2021 16:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808658;
        bh=WO6ADGGSO99avQrDWRk0pqj7iOZKqfl96hWXBYYzfcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJVF1FwnJ4HOZh65zKX6tExyMcsA2DhhhVWbzactKNRXqsJO2xtuMDwg+hCG1IaYI
         dR6Fen9wVepZcHEASABxx6V8Ux+woSy8hs0yG8n0QwpcwJz2zLT1ZWfWuNsfXuTuCz
         6GTZTOBg8QCoM5GM35owRt5ovBF89MxTVbKDnkaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/306] ARM: dts: stm32: Update AV96 adv7513 node per dtbs_check
Date:   Thu, 16 Sep 2021 17:58:38 +0200
Message-Id: <20210916155759.979655191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ec02cee1dd9b..944d38b85eef 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -185,8 +185,8 @@ &i2c2 {	/* X6 I2C2 */
 &i2c4 {
 	hdmi-transmitter@3d {
 		compatible = "adi,adv7513";
-		reg = <0x3d>, <0x2d>, <0x4d>, <0x5d>;
-		reg-names = "main", "cec", "edid", "packet";
+		reg = <0x3d>, <0x4d>, <0x2d>, <0x5d>;
+		reg-names = "main", "edid", "cec", "packet";
 		clocks = <&cec_clock>;
 		clock-names = "cec";
 
@@ -204,8 +204,6 @@ hdmi-transmitter@3d {
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
 		adi,input-clock = "1x";
-		adi,input-style = <1>;
-		adi,input-justification = "evenly";
 
 		ports {
 			#address-cells = <1>;
-- 
2.30.2



