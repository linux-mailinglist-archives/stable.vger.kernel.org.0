Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431BF49975A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448536AbiAXVNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59474 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377237AbiAXVHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C37BB81142;
        Mon, 24 Jan 2022 21:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9C6C340E5;
        Mon, 24 Jan 2022 21:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058457;
        bh=ar8hptmGNbDlKZ4ZidwdBp6iuwtu7qWVz0456y+JxaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPT+G7vTFHZVX3Cpxc0Vmky8hSYjjZ/HPbjGn2oLNc9tJSnxXSEzNMNxsUu1sR01/
         rn8EJRLLis4SRfwjiRpB2jiEOwGrnt0AoUD3u+yuT8lmpYor/qpqxbWkt9z9h5V7Td
         OIAn0LYSKlVaIrirgsGIQLO7v/WTovtAOo73/aco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sricharan R <sricharan@codeaurora.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0294/1039] arm64: dts: qcom: ipq6018: Fix gpio-ranges property
Date:   Mon, 24 Jan 2022 19:34:43 +0100
Message-Id: <20220124184135.165730543@linuxfoundation.org>
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

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 72cb4c48a46a7cfa58eb5842c0d3672ddd5bd9ad ]

There must be three parameters in gpio-ranges property. Fixes this not
very helpful error message:

  OF: /soc/pinctrl@1000000: (null) = 3 found 3

Fixes: 1e8277854b49 ("arm64: dts: Add ipq6018 SoC and CP01 board support")
Cc: Sricharan R <sricharan@codeaurora.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/8a744cfd96aff5754bfdcf7298d208ddca5b319a.1638862030.git.baruch@tkos.co.il
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 933b56103a464..66ec5615651d4 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -220,7 +220,7 @@
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&tlmm 0 80>;
+			gpio-ranges = <&tlmm 0 0 80>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
 
-- 
2.34.1



