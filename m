Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6746AE808
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCGRMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCGRMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DD998E96
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B76E3B819AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A117C4339C;
        Tue,  7 Mar 2023 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208811;
        bh=Y/9BpXjoJ4s5XbNirml8FxjBUlBw3mXvKQurQOiKawM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ku4RxhIhNFP6N9ku0IJmTVT7aRxz9JcJ8j1vGVS3SRMMzruaFkQF1kXj7R/PCaqUL
         p0a43eK3bzRPilzDcBfZQJRkerRlVH9hLn0Ca3BlOAG9Jw3JDvC0K1VsgA8uI2sZu7
         UajUikVuUiv2e0zlSFzIgXpKWOgsEfWJ1lb8AOwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dzmitry Sankouski <dsankouski@gmail.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0018/1001] arm64: dts: qcom: Re-enable resin on MSM8998 and SDM845 boards
Date:   Tue,  7 Mar 2023 17:46:30 +0100
Message-Id: <20230307170022.937453529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 4c881ab73a64cdbf8691e258ef17b740d27040a0 ]

resin node declaration was moved to pm8998.dtsi file (in disabled state).
MSM8998 and SDM845 boards defining resin node did not previously have
status="okay" and ended up disabled.
Re-enable it by using resin node link from pm8998.dtsi with status="okay".

Fixes: f86ae6f23a9e ("arm64: dts: qcom: sagit: add initial device tree for sagit")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/linux-arm-msm/20221222115922.jlachctn4lxopp7a@SoMainline.org/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221228115243.201038-1-dsankouski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts       | 11 +++--------
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi    | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts            | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi        | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts     | 11 +++--------
 .../boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts    | 11 +++--------
 7 files changed, 21 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts b/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
index 310f7a2df1e83..510d12c8c5126 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
+++ b/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
@@ -364,14 +364,9 @@ cam_snapshot_pin_a: cam-snapshot-btn-active-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		bias-pull-up;
-		debounce = <15625>;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &qusb2phy {
diff --git a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
index 5da87baa2b23b..3bbd5df196bfc 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
@@ -357,14 +357,9 @@ vib_default: vib-en-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEUP>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEUP>;
+	status = "okay";
 };
 
 &qusb2phy {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index f41c6d600ea8c..878801f540c54 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -615,14 +615,9 @@ vol_up_pin_a: vol-up-active-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pmi8998_lpg {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
index 1eb423e4be24c..943287804e1a6 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
@@ -482,14 +482,9 @@ &mss_pil {
 	status = "okay";
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &sdhc_2 {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
index bb77ccfdc68c0..e6191602c70a8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
@@ -522,14 +522,9 @@ pinconf {
 	};
 };
 
-&pm8998_pon {
-	volume_down_resin: resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pmi8998_lpg {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index eb6b2b676eca4..1b12b1a4dcbc7 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -325,14 +325,9 @@ &pmi8998_wled {
 	qcom,cabc;
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pmi8998_rradc {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 38ba809a95cd6..fba229d0bd108 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -530,14 +530,9 @@ pinconf {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		compatible = "qcom,pm8941-resin";
-		linux,code = <KEY_VOLUMEDOWN>;
-		debounce = <15625>;
-		bias-pull-up;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &q6afedai {
-- 
2.39.2



