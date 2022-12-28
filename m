Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01F6578E8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiL1Ozi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbiL1Oza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:55:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E112626
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:55:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D8D8B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C578C433D2;
        Wed, 28 Dec 2022 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239326;
        bh=LePJ2vt1YjtHwGGSiscpXiJIZjF6rgIfetJV+DGwa8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRlMboKD8H4f+nutRNaM+KDveBfLTG/EnI5r2YLI2Wz4o/e1eEBvOPe55SqnYiwGy
         lHKqgzYBkUg+RzG6yk1XX1U7RXI7mZ7ck/xxVSp7BRh6i9zXPgtGuBcp6uQqJwN7zh
         OyU5dylie+ve7nHHKgjZKiBQQq9VxgJUdZk3Rz4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0010/1073] arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable
Date:   Wed, 28 Dec 2022 15:26:38 +0100
Message-Id: <20221228144328.446238791@linuxfoundation.org>
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

[ Upstream commit 7ff4a646fae3697b039c6b684786a1e309e8445c ]

The property to disable bias is "bias-disable".

Fixes: e76c7e1f15fe ("arm64: dts: qcom: sm8250-edo: Add Samsung touchscreen")
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192954.242546-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index 5428aab3058d..e4769dcfaad7 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -619,7 +619,7 @@ ts_int_default: ts-int-default {
 		pins = "gpio39";
 		function = "gpio";
 		drive-strength = <2>;
-		bias-disabled;
+		bias-disable;
 		input-enable;
 	};
 
-- 
2.35.1



