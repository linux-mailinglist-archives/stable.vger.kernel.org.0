Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97ECA13E1B9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgAPQvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgAPQve (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C8F205F4;
        Thu, 16 Jan 2020 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193493;
        bh=riCbW41Z9jUVS5yqALMdPXD9X7VSAfqTmqdQlmEHQ0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBvwnYhWgEHv+AoHZHVTb1TgSccROuHUaA9GaIeMt0cEaetRnrg137eAVAvtkU2ls
         bv4cyEliBqwYXoG6v2QTSMdZH8Bj1j2uj5wegWacSoHratAblWTyZIpQGUyZ4Tdjio
         Q76RxGVFOcnK5zJcwHwDbNfUOZw66/MfmiKYYqWI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 090/205] arm64: dts: qcom: msm8998: Disable coresight by default
Date:   Thu, 16 Jan 2020 11:41:05 -0500
Message-Id: <20200116164300.6705-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit a636f93fcdb4a516e7cba6a365645ee8429602b2 ]

Boot failure has been reported on MSM8998 based laptop when
coresight is enabled. This is most likely due to lack of
firmware support for coresight on production device when
compared to debug device like MTP where this issue is not
observed. So disable coresight by default for MSM8998 and
enable it only for MSM8998 MTP.

Reported-and-tested-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Fixes: 783abfa2249a ("arm64: dts: qcom: msm8998: Add Coresight support")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi | 68 +++++++++++++++++++++++
 arch/arm64/boot/dts/qcom/msm8998.dtsi     | 51 +++++++++++------
 2 files changed, 102 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
index 108667ce4f31..8d15572d18e6 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
@@ -27,6 +27,66 @@
 	status = "okay";
 };
 
+&etf {
+	status = "okay";
+};
+
+&etm1 {
+	status = "okay";
+};
+
+&etm2 {
+	status = "okay";
+};
+
+&etm3 {
+	status = "okay";
+};
+
+&etm4 {
+	status = "okay";
+};
+
+&etm5 {
+	status = "okay";
+};
+
+&etm6 {
+	status = "okay";
+};
+
+&etm7 {
+	status = "okay";
+};
+
+&etm8 {
+	status = "okay";
+};
+
+&etr {
+	status = "okay";
+};
+
+&funnel1 {
+	status = "okay";
+};
+
+&funnel2 {
+	status = "okay";
+};
+
+&funnel3 {
+	status = "okay";
+};
+
+&funnel4 {
+	status = "okay";
+};
+
+&funnel5 {
+	status = "okay";
+};
+
 &pm8005_lsid1 {
 	pm8005-regulators {
 		compatible = "qcom,pm8005-regulators";
@@ -51,6 +111,10 @@
 	vdda-phy-dpdm-supply = <&vreg_l24a_3p075>;
 };
 
+&replicator1 {
+	status = "okay";
+};
+
 &rpm_requests {
 	pm8998-regulators {
 		compatible = "qcom,rpm-pm8998-regulators";
@@ -249,6 +313,10 @@
 	pinctrl-1 = <&sdc2_clk_off &sdc2_cmd_off &sdc2_data_off &sdc2_cd_off>;
 };
 
+&stm {
+	status = "okay";
+};
+
 &ufshc {
 	vcc-supply = <&vreg_l20a_2p95>;
 	vccq-supply = <&vreg_l26a_1p2>;
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index c6f81431983e..ffb64fc239ee 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -998,11 +998,12 @@
 			#interrupt-cells = <0x2>;
 		};
 
-		stm@6002000 {
+		stm: stm@6002000 {
 			compatible = "arm,coresight-stm", "arm,primecell";
 			reg = <0x06002000 0x1000>,
 			      <0x16280000 0x180000>;
 			reg-names = "stm-base", "stm-data-base";
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1016,9 +1017,10 @@
 			};
 		};
 
-		funnel@6041000 {
+		funnel1: funnel@6041000 {
 			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
 			reg = <0x06041000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1045,9 +1047,10 @@
 			};
 		};
 
-		funnel@6042000 {
+		funnel2: funnel@6042000 {
 			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
 			reg = <0x06042000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1075,9 +1078,10 @@
 			};
 		};
 
-		funnel@6045000 {
+		funnel3: funnel@6045000 {
 			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
 			reg = <0x06045000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1113,9 +1117,10 @@
 			};
 		};
 
-		replicator@6046000 {
+		replicator1: replicator@6046000 {
 			compatible = "arm,coresight-dynamic-replicator", "arm,primecell";
 			reg = <0x06046000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1137,9 +1142,10 @@
 			};
 		};
 
-		etf@6047000 {
+		etf: etf@6047000 {
 			compatible = "arm,coresight-tmc", "arm,primecell";
 			reg = <0x06047000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1163,9 +1169,10 @@
 			};
 		};
 
-		etr@6048000 {
+		etr: etr@6048000 {
 			compatible = "arm,coresight-tmc", "arm,primecell";
 			reg = <0x06048000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1181,9 +1188,10 @@
 			};
 		};
 
-		etm@7840000 {
+		etm1: etm@7840000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07840000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1200,9 +1208,10 @@
 			};
 		};
 
-		etm@7940000 {
+		etm2: etm@7940000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07940000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1219,9 +1228,10 @@
 			};
 		};
 
-		etm@7a40000 {
+		etm3: etm@7a40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07a40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1238,9 +1248,10 @@
 			};
 		};
 
-		etm@7b40000 {
+		etm4: etm@7b40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07b40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1257,9 +1268,10 @@
 			};
 		};
 
-		funnel@7b60000 { /* APSS Funnel */
+		funnel4: funnel@7b60000 { /* APSS Funnel */
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07b60000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1343,9 +1355,10 @@
 			};
 		};
 
-		funnel@7b70000 {
+		funnel5: funnel@7b70000 {
 			compatible = "arm,coresight-dynamic-funnel", "arm,primecell";
 			reg = <0x07b70000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1369,9 +1382,10 @@
 			};
 		};
 
-		etm@7c40000 {
+		etm5: etm@7c40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07c40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1385,9 +1399,10 @@
 			};
 		};
 
-		etm@7d40000 {
+		etm6: etm@7d40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07d40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1401,9 +1416,10 @@
 			};
 		};
 
-		etm@7e40000 {
+		etm7: etm@7e40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07e40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
@@ -1417,9 +1433,10 @@
 			};
 		};
 
-		etm@7f40000 {
+		etm8: etm@7f40000 {
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0x07f40000 0x1000>;
+			status = "disabled";
 
 			clocks = <&rpmcc RPM_SMD_QDSS_CLK>, <&rpmcc RPM_SMD_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
-- 
2.20.1

