Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93A254154A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378215AbiFGUe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377018AbiFGU2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6861D9EDA;
        Tue,  7 Jun 2022 11:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C44F61507;
        Tue,  7 Jun 2022 18:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0B1C385A2;
        Tue,  7 Jun 2022 18:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626821;
        bh=z6gv72hpwSptSCQ7xX3FHP+uyddk98Y6OKh8o9Pf8MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUCiYC+1oGJFuGjJwqWQZlR+Y1Wry1zA1FoaRCMrEeCxdmc+fWDKwfz64eUA6XBLr
         htfZQPngGF/Pb5+WzGKBGVjwA9trV/WPIJOdlpJq38KIpwpg7VK5XVXBjysYWZ7O+8
         HbSWHVWXUrMqvyIYeJaRkCRow87Cr4TJlkxPFGG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 475/772] ARM: dts: qcom: sdx55: remove wrong unit address from RPMH RSC clocks
Date:   Tue,  7 Jun 2022 19:01:07 +0200
Message-Id: <20220607165002.991491332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



