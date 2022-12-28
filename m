Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259AA657944
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiL1O70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiL1O7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBD10053
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E6761540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BCFC433EF;
        Wed, 28 Dec 2022 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239556;
        bh=n5yV5tTFWa2mM5JRZ3IxA7qXWWr2cfGUdwUwoG2a2Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iplHvQCGUAjJzKlEwMsSmKDk0AIuIxNvnZ+QKEBeeskC6Km93JZ1DphGT2rjAjGqy
         5EqrTcTr3Zn0BNcAhKkDe1ZWxfbNIpXaLFRm0SXiT6XCfVeozeZeJizUEsUvMXDnV3
         mIt+wIZfRwRIfI58HPQtT90XkqxDXhA2OiXkYxL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0012/1146] arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
Date:   Wed, 28 Dec 2022 15:25:51 +0100
Message-Id: <20221228144330.510988264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 9bce41fab14da8f21027dc9847535ef5e22cbe8b ]

There is no "bias-no-pull" property.  Assume intentions were disabling
bias.

Fixes: 79e7739f7b87 ("arm64: dts: qcom: sdm845-cheza: add initial cheza dt")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010114417.29859-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index b5eb8f7eca1d..b5f11fbcc300 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -1436,7 +1436,7 @@ ap_suspend_l_assert: ap_suspend_l_assert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-low;
 		};
@@ -1446,7 +1446,7 @@ ap_suspend_l_deassert: ap_suspend_l_deassert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-high;
 		};
-- 
2.35.1



