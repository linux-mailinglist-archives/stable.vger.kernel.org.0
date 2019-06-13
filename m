Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E743F81
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfFMP6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731495AbfFMIuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28982206BA;
        Thu, 13 Jun 2019 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415814;
        bh=Ot4bg2E/0fMVA9DEsc0sW28rQgLbp+P61MuXrlfKVKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsdvNFccchZm9WPSOaW/bmpQASu3hile0rPBqA+aJnIXBHtSNT34xEYEQsLCJV8oS
         jL5UAK9lXCvxZ8WQtq00jQJ6OY7G8tfG7EgXgXXl1gJ07Xhp3pdwFRO4C8T+Q2QWqk
         LcY511YkZAEjd981GO+XMMBFKEUhnEUVYm0wXSak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 133/155] arm64: dts: qcom: qcs404: Fix regulator supply names
Date:   Thu, 13 Jun 2019 10:34:05 +0200
Message-Id: <20190613075700.194975551@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f95f57e4372207ede83ac28f300aba719b271ed5 ]

The regulator definition got their supply names cleaned up during
upstreaming, so they no longer match the driver defined names. Update
the supply names.

Also fill out the missing voltage of SMPS 5.

Fixes: 0b363f5b871c ("arm64: dts: qcom: qcs404: Add PMS405 RPM regulators")
Reported-by: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi | 28 ++++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
index 50b3589c7f15..536f735243d2 100644
--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -37,18 +37,18 @@
 	pms405-regulators {
 		compatible = "qcom,rpm-pms405-regulators";
 
-		vdd-s1-supply = <&vph_pwr>;
-		vdd-s2-supply = <&vph_pwr>;
-		vdd-s3-supply = <&vph_pwr>;
-		vdd-s4-supply = <&vph_pwr>;
-		vdd-s5-supply = <&vph_pwr>;
-		vdd-l1-l2-supply = <&vreg_s5_1p35>;
-		vdd-l3-l8-supply = <&vreg_s5_1p35>;
-		vdd-l4-supply = <&vreg_s5_1p35>;
-		vdd-l5-l6-supply = <&vreg_s4_1p8>;
-		vdd-l7-supply = <&vph_pwr>;
-		vdd-l9-supply = <&vreg_s5_1p35>;
-		vdd-l10-l11-l12-l13-supply = <&vph_pwr>;
+		vdd_s1-supply = <&vph_pwr>;
+		vdd_s2-supply = <&vph_pwr>;
+		vdd_s3-supply = <&vph_pwr>;
+		vdd_s4-supply = <&vph_pwr>;
+		vdd_s5-supply = <&vph_pwr>;
+		vdd_l1_l2-supply = <&vreg_s5_1p35>;
+		vdd_l3_l8-supply = <&vreg_s5_1p35>;
+		vdd_l4-supply = <&vreg_s5_1p35>;
+		vdd_l5_l6-supply = <&vreg_s4_1p8>;
+		vdd_l7-supply = <&vph_pwr>;
+		vdd_l9-supply = <&vreg_s5_1p35>;
+		vdd_l10_l11_l12_l13-supply = <&vph_pwr>;
 
 		vreg_s4_1p8: s4 {
 			regulator-min-microvolt = <1728000>;
@@ -56,8 +56,8 @@
 		};
 
 		vreg_s5_1p35: s5 {
-			regulator-min-microvolt = <>;
-			regulator-max-microvolt = <>;
+			regulator-min-microvolt = <1352000>;
+			regulator-max-microvolt = <1352000>;
 		};
 
 		vreg_l1_1p3: l1 {
-- 
2.20.1



