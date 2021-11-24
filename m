Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D245C489
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351503AbhKXNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354024AbhKXNsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6E1619FA;
        Wed, 24 Nov 2021 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758919;
        bh=4DyyEtNrK2l1kT1TJVpafuPHJpxdwGkvrvskdSft5cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUu/LiieKt6+Tcfjmr5zzx+ryuI8xKSDk4LftHi6Bg374lDBj2yCEsX9q11nLRNlg
         JBpgzTrLakcB6ltfNlWtwsUoz4WpEuAMC60SeY5Pt9P9pIT1tEhiXkjy6FUiqpmYps
         N5RrWN/li86gI0HoZTz0EkmR8omzJQ+/dYhJtDGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/279] arm64: dts: qcom: Fix node name of rpm-msg-ram device nodes
Date:   Wed, 24 Nov 2021 12:56:00 +0100
Message-Id: <20211124115721.231517400@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 179811bebc7b91e0f9d0adee9bfa3d2af9c43869 ]

According to the new DT schema for qcom,rpm-msg-ram the node name
should be sram@. memory@ is reserved for definition of physical RAM
(usable by Linux).

This fixes the following dtbs_check error on various device trees:
memory@60000: 'device_type' is a required property
        From schema: dtschema/schemas/memory.yaml

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211018110009.30837-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi |    2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi |    2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi |    2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi |    2 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi  |    2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi  |    2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -445,7 +445,7 @@
 			};
 		};
 
-		rpm_msg_ram: memory@60000 {
+		rpm_msg_ram: sram@60000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00060000 0x8000>;
 		};
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -715,7 +715,7 @@
 			reg = <0xfc400000 0x2000>;
 		};
 
-		rpm_msg_ram: memory@fc428000 {
+		rpm_msg_ram: sram@fc428000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0xfc428000 0x4000>;
 		};
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -638,7 +638,7 @@
 			};
 		};
 
-		rpm_msg_ram: memory@68000 {
+		rpm_msg_ram: sram@68000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00068000 0x6000>;
 		};
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -861,7 +861,7 @@
 			reg = <0x00100000 0xb0000>;
 		};
 
-		rpm_msg_ram: memory@778000 {
+		rpm_msg_ram: sram@778000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00778000 0x7000>;
 		};
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -318,7 +318,7 @@
 			status = "disabled";
 		};
 
-		rpm_msg_ram: memory@60000 {
+		rpm_msg_ram: sram@60000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00060000 0x6000>;
 		};
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -541,7 +541,7 @@
 					<&sleep_clk>;
 		};
 
-		rpm_msg_ram: memory@778000 {
+		rpm_msg_ram: sram@778000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00778000 0x7000>;
 		};
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -380,7 +380,7 @@
 			status = "disabled";
 		};
 
-		rpm_msg_ram: memory@45f0000 {
+		rpm_msg_ram: sram@45f0000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x045f0000 0x7000>;
 		};


