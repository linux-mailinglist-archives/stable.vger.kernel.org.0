Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CCD1F2E13
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgFHXNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbgFHXNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB2920B80;
        Mon,  8 Jun 2020 23:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658001;
        bh=2tfyawIOeBBGpVSvjt7DJKriTpeiTWyLW3csCNfR08k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+eDDXahsUbeWkAN1O7Ky/ww+WY94VvjJZUw2nZOSIjDFe7bKGjS1o2XwzbBBBXNv
         XDpPSzuRzEqpjGMfDK58mvjNJB43w5TM+B1yel0cSJRKpI/GY6W2RCmyRMkxwBw/Q2
         adXHvdqBW8QzEUihlyT9o3fDCzKzVQOyP8dfDI+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 058/606] arm64: dts: qcom: msm8996: Reduce vdd_apc voltage
Date:   Mon,  8 Jun 2020 19:03:03 -0400
Message-Id: <20200608231211.3363633-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 28810eecae08f9458a44831978e36f14ed182c80 upstream.

Some msm8996 based devices are unstable when run with VDD_APC of 1.23V,
which is listed as the maximum voltage in "Turbo" mode. Given that the
CPU cluster is not run in "Turbo" mode, reduce this to 0.98V - the
maximum voltage for nominal operation.

Tested-by: Loic Poulain <loic.poulain@linaro.org>
Fixes: 7a2a2231ef22 ("arm64: dts: apq8096-db820c: Fix VDD core voltage")
Cc: Loic Poulain <loic.poulain@linaro.org>
Link: https://lore.kernel.org/r/20200318054442.3066726-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
index fff6115f2670..a85b85d85a5f 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
@@ -658,8 +658,8 @@ s10 {
 	s11 {
 		qcom,saw-leader;
 		regulator-always-on;
-		regulator-min-microvolt = <1230000>;
-		regulator-max-microvolt = <1230000>;
+		regulator-min-microvolt = <980000>;
+		regulator-max-microvolt = <980000>;
 	};
 };
 
-- 
2.25.1

