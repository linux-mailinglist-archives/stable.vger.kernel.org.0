Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60849943F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388843AbiAXUkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386944AbiAXUgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E3FC02B8C9;
        Mon, 24 Jan 2022 11:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C70FB8121A;
        Mon, 24 Jan 2022 19:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE39C340E5;
        Mon, 24 Jan 2022 19:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053760;
        bh=uWJ6f9HmEck56EkrCU4g63WGKcQ3HJigV9j5BtctmOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjCX4VWuZ2I5RUzlywxDY5KCTAUdB5Re6SLfUWYHokECb/X07rVCP7a09hRLgMJww
         8a2DmR848f0vWRZf8pM9WLp6kAvq2hjvbc2AenP9wB5cP14KzGdqUivA2/ctjll0O3
         EiYPu4lvbcraHUNmDcIIUDTx315/lf6wzsuNftDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sricharan R <sricharan@codeaurora.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/563] arm64: dts: qcom: ipq6018: Fix gpio-ranges property
Date:   Mon, 24 Jan 2022 19:38:53 +0100
Message-Id: <20220124184030.219942235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 9cb8f7a052df9..2a1f03cdb52c7 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -221,7 +221,7 @@
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&tlmm 0 80>;
+			gpio-ranges = <&tlmm 0 0 80>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
 
-- 
2.34.1



