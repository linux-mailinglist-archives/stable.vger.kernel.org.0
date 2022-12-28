Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6962657971
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiL1PBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbiL1PBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:01:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E8F12ACC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D78CB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23F8C433EF;
        Wed, 28 Dec 2022 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239659;
        bh=raxkw2wamku2v4JAuD+ljfYdEpbt0IgKx2kRi+4nCGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iavs6Mc5N0AgtXeC747/KDusb2QA/eo7BXxHFnPoylHp1X8VLu/nUg8PzpF1Pr/ev
         bIaPVxxXyWxJLlEAvmYlpvxVUN2skLK/DxVB1LZVtj5LH8PV0qm9CilcRDda2C99Lt
         r122yANA/Kh840ldZN9PVpkn5ZtUy1YVG7fbPros=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0024/1146] arm64: dts: qcom: sm8250: correct LPASS pin pull down
Date:   Wed, 28 Dec 2022 15:26:03 +0100
Message-Id: <20221228144330.827728723@linuxfoundation.org>
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

[ Upstream commit 195a0a11d66d6c696cbcf398d6bc3f3a3a462f7c ]

The pull-down property is actually bias-pull-down.

Fixes: 3160c1b894d9 ("arm64: dts: qcom: sm8250: add lpass lpi pin controller node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220927153429.55365-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index e276eed1f8e2..334be39ccaf5 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2455,7 +2455,7 @@ data {
 					pins = "gpio7";
 					function = "dmic1_data";
 					drive-strength = <2>;
-					pull-down;
+					bias-pull-down;
 					input-enable;
 				};
 			};
-- 
2.35.1



