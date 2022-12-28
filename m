Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779B4657942
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiL1O7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiL1O7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D366610054
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EDE7B8171A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB973C433EF;
        Wed, 28 Dec 2022 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239548;
        bh=eM1vUOOB9D/mHF6oH+HM/vO8jjfQ3NFw7teRhELzvxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV0FQwuE8XOqlktcrVNywfvlkgtBfxZNHr5pwQYm1iaxaLN68FAaMxVYAcNmF48yz
         97R79yqHbY8KJatcrd0LAbnkENiDi1jROT+acwqQkapiML7gkuQ2T8+36d1wMv32Te
         wajYvywFwMq0I8L8ag7CG3I41wUDs4ZmRZ/52qt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0011/1146] arm64: dts: qcom: sdm630: fix UART1 pin bias
Date:   Wed, 28 Dec 2022 15:25:50 +0100
Message-Id: <20221228144330.485877759@linuxfoundation.org>
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

[ Upstream commit 780f836fe071a9e8703fe6a05ae00129acf83391 ]

There is no "bias-no-pull" property.  Assume intentions were disabling
bias.

Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010114417.29859-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index b51b85f583e5..e119060ac56c 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -779,7 +779,7 @@ rx-cts-rts {
 					pins = "gpio17", "gpio18", "gpio19";
 					function = "gpio";
 					drive-strength = <2>;
-					bias-no-pull;
+					bias-disable;
 				};
 			};
 
-- 
2.35.1



