Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14D31FDAF8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgFRBJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbgFRBJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31D5321BE5;
        Thu, 18 Jun 2020 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442567;
        bh=BCck0kQnMhAfG7wmIdj+cka0AdBZOnZe4nLqeQw3x8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfFhefDlkiYbAMIMTLE2SROWppImYqa0AevDdoZFlJZvnVfh/GqBoMmLG4mmLtdJm
         nEVRjA+NTJ/MW8V5YaCwv0JDWS18ATdIxpa8/dI856W5KqYQuswG54DlxXNtLOAKHm
         VzXU/NqNygKWNVoZqKEXQu5B8iReZTzRB6ZB8Rk0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maulik Shah <mkshah@codeaurora.org>, devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 061/388] arm64: dts: qcom: sc7180: Correct the pdc interrupt ranges
Date:   Wed, 17 Jun 2020 21:02:38 -0400
Message-Id: <20200618010805.600873-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maulik Shah <mkshah@codeaurora.org>

[ Upstream commit 7d2f29e49477aa51339e719cf73f0945c39c8a9e ]

Few PDC interrupts do not map to respective parent GIC interrupt.
Fix this by correcting the pdc interrupt map.

Fixes: 22f185ee81d2 ("arm64: dts: qcom: sc7180: Add pdc interrupt controller")
Cc: devicetree@vger.kernel.org
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Link: https://lore.kernel.org/r/1589804402-27130-1-git-send-email-mkshah@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 998f101ad623..eea92b314fc6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1657,8 +1657,7 @@ dispcc: clock-controller@af00000 {
 		pdc: interrupt-controller@b220000 {
 			compatible = "qcom,sc7180-pdc", "qcom,pdc";
 			reg = <0 0x0b220000 0 0x30000>;
-			qcom,pdc-ranges = <0 480 15>, <17 497 98>,
-					  <119 634 4>, <124 639 1>;
+			qcom,pdc-ranges = <0 480 94>, <94 609 31>, <125 63 1>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
-- 
2.25.1

