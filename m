Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9D64917D7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346133AbiARCnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346388AbiARChw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:37:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A7C0619CF;
        Mon, 17 Jan 2022 18:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 677B3B81250;
        Tue, 18 Jan 2022 02:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA6C36AF3;
        Tue, 18 Jan 2022 02:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473270;
        bh=XrBtpbQQg2+sfM7cICEy7nMbP1plJPQ1S7N6hm2CyGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCA+MpaIdwqFgXo5wAM2tQQSUvGmIa7fyMKkLOeRIduLEOc1Op/qQrZggduRq5rYT
         Q9Aj6CfLAkkcHeWfPPaMl4sj8uv1b+7LCJJ2mZVUqLiKLlzF4orkCzABjYnk0QkExV
         i9Avsfg4yVHM3qKlPKMD47WnTlhuiL1p2QlLjmiw7rrij21MGgzeowfB+Jm5Va5tJJ
         PaLVbUiHh3KOFZaJChwMIRcBx0sNYJsjQMNYlLUaPkRI9OlZN4dYrE3b/MUMlANua1
         Bhhn6Z0dTxf2BJzUUiLBqp2EgvX2ITZoDXnL7s4KXWMOiXedHTqiunivs65em4/Vev
         zgjduy9x/zjOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 049/188] arm64: dts: qcom: sm8350: Shorten camera-thermal-bottom name
Date:   Mon, 17 Jan 2022 21:29:33 -0500
Message-Id: <20220118023152.1948105-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit f52dd33943ca5f84ae76890f352f6d9e12512c3f ]

Thermal zone names should not be longer than 20 names, which is indicated by
a message at boot. Change "camera-thermal-bottom" to "cam-thermal-bottom" to
fix it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211114012755.112226-6-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index e91cd8a5e5356..296ffb0e9888c 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2185,7 +2185,7 @@ camera1_alert0: trip-point0 {
 			};
 		};
 
-		camera-thermal-bottom {
+		cam-thermal-bottom {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 
-- 
2.34.1

