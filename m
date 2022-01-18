Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E684914B7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbiARCXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244809AbiARCWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:22:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A63C06176F;
        Mon, 17 Jan 2022 18:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8559A60010;
        Tue, 18 Jan 2022 02:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2961C36AEB;
        Tue, 18 Jan 2022 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472564;
        bh=Uy3muUzRramXrgI3qDW47luLxlFoyW/MzQLWzbhDiyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK64x3MRbrOcZFbH11pycydLRnPg+hcbZPJAe/phqdYVJBZLu3JGr6EHM9wvOZvch
         F2YPpdRhrNPWZ26P5Jtgwhlf1rQFk9SpETiyj/Wl2MDeHtMXmTeUK3UO66zUTzhg5o
         KRHewCrvaSE/0tIgO6PaP0SWUx5ph6zojS/yNI8HuuOMslVujIheYv5ap805Urg5tE
         eVA1c3uPAdKdkPWdOW29501ZcrF5ZdzXtyl+Fq0KO/bWGyaxfTvmcjT6UpR6+JmPij
         q5/P6uEWuBtqnCfkl5j0oJCqxa0OcNAo8RTaQ2DL8zCI0Ru5ihuWUTuKE6bUhGItCo
         s7YjMI3flbMqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 055/217] arm64: dts: qcom: sm[68]350: Use interrupts-extended with pdc interrupts
Date:   Mon, 17 Jan 2022 21:16:58 -0500
Message-Id: <20220118021940.1942199-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 9e7f7b65c7f04c5cfda97d6bd0d452a49e60f24e ]

Using interrupts = <&pdc X Y> makes the interrupt framework interpret this as
the &pdc-nth range of the main interrupt controller (GIC). Fix it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211114012755.112226-5-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 4 ++--
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 973e18fe3b674..cd55797facf69 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -631,7 +631,7 @@ tsens0: thermal-sensor@c263000 {
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
 			#qcom,sensors = <16>;
-			interrupts = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 28 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
@@ -642,7 +642,7 @@ tsens1: thermal-sensor@c265000 {
 			reg = <0 0x0c265000 0 0x1ff>, /* TM */
 			      <0 0x0c223000 0 0x8>; /* SROT */
 			#qcom,sensors = <16>;
-			interrupts = <&pdc 27 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 27 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 29 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index d134280e29390..a8c040c564096 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -910,7 +910,7 @@ tsens0: thermal-sensor@c263000 {
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
 			#qcom,sensors = <15>;
-			interrupts = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 28 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
@@ -921,7 +921,7 @@ tsens1: thermal-sensor@c265000 {
 			reg = <0 0x0c265000 0 0x1ff>, /* TM */
 			      <0 0x0c223000 0 0x8>; /* SROT */
 			#qcom,sensors = <14>;
-			interrupts = <&pdc 27 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 27 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 29 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
-- 
2.34.1

