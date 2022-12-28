Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAC6578EA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiL1Ozk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiL1Ozd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:55:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD1101FB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16F461540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE5CC433D2;
        Wed, 28 Dec 2022 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239332;
        bh=QEo7o9/FH/ZPMqOOGUU032HEKCPCRR3Ts0Ly4H4xBsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjE736bvcGqvtKfuV8ZTCxKKwiqX3u/UBu7P0nklMLNRbHE5lbhxeQXWvTJj6Cr2a
         AeFDFC8Le0haYvT4eE4u1qpw/eyHwOCx3dE6rhCp6433PxvTzDKa9FSs+DvCvXX0kF
         fejSm347Okog7yqZihyuBrTtvzoEtrNeEJUB8OLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Molly Sophia <mollysophia379@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0011/1073] arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name
Date:   Wed, 28 Dec 2022 15:26:39 +0100
Message-Id: <20221228144328.471638008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 58c4a0b6f4bdf8c3c2b4aad7f980e4019cc0fc83 ]

Fix typo in the codec's pin name to be configured.  Mismatched name
caused the pin configuration to be ignored.

Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Molly Sophia <mollysophia379@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192039.240486-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index dba7c2693ff5..2611a5c40ba3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -628,7 +628,7 @@ sde_dsi_suspend: sde-dsi-suspend {
 	};
 
 	wcd_intr_default: wcd-intr-default {
-		pins = "goui54";
+		pins = "gpio54";
 		function = "gpio";
 		input-enable;
 		bias-pull-down;
-- 
2.35.1



