Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DF96AE885
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCGRQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCGRQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AD795BDB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764896150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB1BC433EF;
        Tue,  7 Mar 2023 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209113;
        bh=AQCOh9Yg4J7QMcBBHjDbZC8y9s9HYqvuW7hb76QuGNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whQhpU6SLJV/yQjOwwHbXaDF9EFMJGmbaBO009/taltocgiT+6hWmwVSZTkghlL3s
         nHchyUEx0HMtJ5L5CmlNby31VgUybAbMmL6A6bDXw9sYJgNlwzrvAW7l2wmUuFPqeQ
         72vCwZyAT+Bj9Y5BRti7FM9jjGccJSBB1CSQC3vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0114/1001] arm64: dts: qcom: sm8450: drop incorrect cells from serial
Date:   Tue,  7 Mar 2023 17:48:06 +0100
Message-Id: <20230307170027.060857961@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 60d2da2c916956535cf37b7bf1ae8fefbf432e55 ]

The serial/UART device node does not have children with unit addresses,
so address/size cells are not correct.

Fixes: f5837418479a ("arm64: dts: qcom: sm8450: add uart20 node")
Fixes: 5188049c9b36 ("arm64: dts: qcom: Add base SM8450 DTSI")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230124084951.38195-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index eb3318516243c..f57980a32b433 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -997,8 +997,6 @@ uart20: serial@894000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&qup_uart20_default>;
 				interrupts = <GIC_SPI 587 IRQ_TYPE_LEVEL_HIGH>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 				status = "disabled";
 			};
 
@@ -1391,8 +1389,6 @@ uart7: serial@99c000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&qup_uart7_tx>, <&qup_uart7_rx>;
 				interrupts = <GIC_SPI 608 IRQ_TYPE_LEVEL_HIGH>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 				status = "disabled";
 			};
 		};
-- 
2.39.2



