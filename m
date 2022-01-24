Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5612549A364
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368022AbiAXX5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846014AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897FFC06127D;
        Mon, 24 Jan 2022 13:22:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50FB0B80FA1;
        Mon, 24 Jan 2022 21:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A116C340E5;
        Mon, 24 Jan 2022 21:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059325;
        bh=Yraa2Ik+sFawregwHtzg1NwMU7yrmYsObsjSXF+bWPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4EdJbsZ76xEAy6nRAaU3YIVpWw63KJLH4kEtSNkB2YQvTMnZmF/PLu27hYseLA4j
         DJMbczVJq1j4zm5BmXCCyWsQKyx5Ckg2aWA8jrV6Sj6JG8LJkZuU9RXGz2T/Ef8WQt
         Z8pmNykXzxs28jLZb5QJ6iAiCm8tlFEcRAAxaMy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0577/1039] arm64: dts: qcom: sm[68]350: Use interrupts-extended with pdc interrupts
Date:   Mon, 24 Jan 2022 19:39:26 +0100
Message-Id: <20220124184144.735147743@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -631,7 +631,7 @@
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
 			#qcom,sensors = <16>;
-			interrupts = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 28 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
@@ -642,7 +642,7 @@
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
@@ -910,7 +910,7 @@
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
 			#qcom,sensors = <15>;
-			interrupts = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 26 IRQ_TYPE_LEVEL_HIGH>,
 				     <&pdc 28 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "uplow", "critical";
 			#thermal-sensor-cells = <1>;
@@ -921,7 +921,7 @@
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



