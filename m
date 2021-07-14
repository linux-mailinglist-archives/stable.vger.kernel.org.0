Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCA03C8CAD
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhGNTme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234657AbhGNTmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9570761370;
        Wed, 14 Jul 2021 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291557;
        bh=P0Qq2ceI7w7g3OlkqgXU0sTHuhLC6kHZ+SQxzV9wWTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGaGy3TptQwbM75gzUaC/4FEyDDFMtwo3yd1i0DwkAMlt+YVS+Takf2NomGEYxmQf
         QZFvI12E3Zs5F8scvUaEGnoCkgzvO8dN4P9Ky8XN2PDcegk/Mrf5YR7QPgNISvpTbS
         Uwivd8ZIZDftlwwrFnryTMtDoktT6hrclIS4EiZauhVumTThAy2kcFsIeKRT+cj0ra
         ZNRfUSZKPV16Hhx3voCk3J35pWOFpSifw/H3i41VlbtquYUfeTmhXdN3PlAiUsSeYL
         mClU/aUnHfXopwVK2K/O1dlp1v2N68+iW43ogOEwxOdMpMRAw3qoBdnU6QR7bt+RpP
         Kq3XVTiZMhftg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 053/108] arm64: dts: qcom: sm8350: fix the node unit addresses
Date:   Wed, 14 Jul 2021 15:37:05 -0400
Message-Id: <20210714193800.52097-53-sashal@kernel.org>
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 1dee9e3b0997fef7170f7ea2d8eab47d0cd334d8 ]

Some node unit addresses were put wrongly in the dts, resulting in
below warning when run with W=1

arch/arm64/boot/dts/qcom/sm8350.dtsi:693.34-702.5: Warning (simple_bus_reg): /soc@0/thermal-sensor@c222000: simple-bus unit address format error, expected "c263000"
arch/arm64/boot/dts/qcom/sm8350.dtsi:704.34-713.5: Warning (simple_bus_reg): /soc@0/thermal-sensor@c223000: simple-bus unit address format error, expected "c265000"
arch/arm64/boot/dts/qcom/sm8350.dtsi:1180.32-1185.5: Warning (simple_bus_reg): /soc@0/interconnect@90e0000: simple-bus unit address format error, expected "90c0000"

Fix by correcting to the correct address as given in reg node

Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210513060733.382420-1-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index ed0b51bc03ea..a2382eb8619b 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -689,7 +689,7 @@ pdc: interrupt-controller@b220000 {
 			interrupt-controller;
 		};
 
-		tsens0: thermal-sensor@c222000 {
+		tsens0: thermal-sensor@c263000 {
 			compatible = "qcom,sm8350-tsens", "qcom,tsens-v2";
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
@@ -700,7 +700,7 @@ tsens0: thermal-sensor@c222000 {
 			#thermal-sensor-cells = <1>;
 		};
 
-		tsens1: thermal-sensor@c223000 {
+		tsens1: thermal-sensor@c265000 {
 			compatible = "qcom,sm8350-tsens", "qcom,tsens-v2";
 			reg = <0 0x0c265000 0 0x1ff>, /* TM */
 			      <0 0x0c223000 0 0x8>; /* SROT */
@@ -1176,7 +1176,7 @@ usb_2_ssphy: phy@88ebe00 {
 			};
 		};
 
-		dc_noc: interconnect@90e0000 {
+		dc_noc: interconnect@90c0000 {
 			compatible = "qcom,sm8350-dc-noc";
 			reg = <0 0x090c0000 0 0x4200>;
 			#interconnect-cells = <1>;
-- 
2.30.2

