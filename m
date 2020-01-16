Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B12913E333
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbgAPRAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387865AbgAPRAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A992467C;
        Thu, 16 Jan 2020 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194041;
        bh=BMgFxducrcVlOag3C3yZ/qE15LkMN0Q7yrMo9NxU0wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFwOUWYJc+1/r92V2MhO2Ip3trQVYuETeq3YFVNAqwUleD9qJp1zvJwwIFZCugjqp
         X/pHBPTByENxqWCi/XmM0SjNg3WzcOWcAQf3G6YK1qKFLlKZCRXC4Kie4RkEZW9CVG
         tLvKXj2KfwCVYqiRNjaEkhXabx3iZRDItgSpJCPQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/671] arm64: dts: msm8916: remove bogus argument to the cpu clock
Date:   Thu, 16 Jan 2020 11:51:07 -0500
Message-Id: <20200116165940.10720-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit e4f045ef38e61ba37aa4afc916fce4fc1b37aa19 ]

The apcs node has #clock-cells = <0>, which means that those who
references it should specify 0 arguments.

The apcs reference in the cpu node incorrectly specifies an argument,
remove this bogus argument.

Fixes: 65afdf458360 ("arm64: dts: qcom: msm8916: Add CPU frequency scaling support")
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 7b32b8990d62..8011e564a234 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -114,7 +114,7 @@
 			next-level-cache = <&L2_0>;
 			enable-method = "psci";
 			cpu-idle-states = <&CPU_SPC>;
-			clocks = <&apcs 0>;
+			clocks = <&apcs>;
 			operating-points-v2 = <&cpu_opp_table>;
 			#cooling-cells = <2>;
 		};
@@ -126,7 +126,7 @@
 			next-level-cache = <&L2_0>;
 			enable-method = "psci";
 			cpu-idle-states = <&CPU_SPC>;
-			clocks = <&apcs 0>;
+			clocks = <&apcs>;
 			operating-points-v2 = <&cpu_opp_table>;
 			#cooling-cells = <2>;
 		};
@@ -138,7 +138,7 @@
 			next-level-cache = <&L2_0>;
 			enable-method = "psci";
 			cpu-idle-states = <&CPU_SPC>;
-			clocks = <&apcs 0>;
+			clocks = <&apcs>;
 			operating-points-v2 = <&cpu_opp_table>;
 			#cooling-cells = <2>;
 		};
@@ -150,7 +150,7 @@
 			next-level-cache = <&L2_0>;
 			enable-method = "psci";
 			cpu-idle-states = <&CPU_SPC>;
-			clocks = <&apcs 0>;
+			clocks = <&apcs>;
 			operating-points-v2 = <&cpu_opp_table>;
 			#cooling-cells = <2>;
 		};
-- 
2.20.1

