Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54641541C1C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353807AbiFGV4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383315AbiFGVxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4061243B97;
        Tue,  7 Jun 2022 12:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15BE0612EC;
        Tue,  7 Jun 2022 19:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA0C385A2;
        Tue,  7 Jun 2022 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629083;
        bh=z6gv72hpwSptSCQ7xX3FHP+uyddk98Y6OKh8o9Pf8MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI620aFVGE/MjpmKX2l62GXJMv1i73pjtYeRr6Si5vT0O1cuzRqLWcz5bM7nLIQJB
         rwr8kTBjlusyNqfsCKyzjBPFiYZ+lZEoU5WLzm+6DvfK2igm3cRzW+JXn2ICaq/eem
         GWjDNFA2ERuqOBQWj90Zpc5J0OOmmV9QcQeCYE+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 563/879] ARM: dts: qcom: sdx55: remove wrong unit address from RPMH RSC clocks
Date:   Tue,  7 Jun 2022 19:01:21 +0200
Message-Id: <20220607165019.203957963@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 97c246c825f73a018169834e56ffa9a89dea37a9 ]

The clock controller of RPMH RSC does not have 'reg' property, so should
not have unit address.

Fixes: bae2f5979c6e ("ARM: dts: qcom: Add SDX65 platform and MTP board support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220411085935.130072-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom-sdx65.dtsi
index 796641d30e06..0c3f93603adc 100644
--- a/arch/arm/boot/dts/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx65.dtsi
@@ -202,7 +202,7 @@
 				<WAKE_TCS    2>,
 				<CONTROL_TCS 1>;
 
-			rpmhcc: clock-controller@1 {
+			rpmhcc: clock-controller {
 				compatible = "qcom,sdx65-rpmh-clk";
 				#clock-cells = <1>;
 				clock-names = "xo";
-- 
2.35.1



