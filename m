Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5654360460C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJSM4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiJSM4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1328019012;
        Wed, 19 Oct 2022 05:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AEB7617E7;
        Wed, 19 Oct 2022 08:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7EAC433D7;
        Wed, 19 Oct 2022 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169866;
        bh=rudtTfZlwgBE07+jDbwNDqaJOfzIvla8xFjDraZ2q+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fB0Aj54D3jouhrm0c1nXzZFVR+9TI/4WiE3Uv1i2tBeH87FFnw8HD0jIuqbpJKqcc
         gWNpcu96av3mTEG3nkcGDlD1MLkuv/FxYKe7hcjIzFivooHIvT5j+qYPufFwRWRJQ8
         U/3U1HPVieUNNG0zZvMvlQWxp77WzaLq9ayuq3zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 438/862] arm64: dts: qcom: sc8280xp-pmics: Remove reg entry & use correct node name for pmc8280c_lpg node
Date:   Wed, 19 Oct 2022 10:28:45 +0200
Message-Id: <20221019083309.338035619@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit 7dac7991408f77b0b33ee5e6b729baa683889277 ]

Commit eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")
dropped PWM reg declaration for pm8350c pwm(s), but there is a leftover
'reg' entry inside the lpg/pwm node in sc8280xp dts file. Remove the same.

While at it, also remove the unused unit address in the node
label.

Also, since dt-bindings expect LPG/PWM node name to be "pwm",
use correct node name as well, to fix the following
error reported by 'make dtbs_check':

  'lpg' does not match any of the regexes

Fixes: eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220905070240.1634997-1-bhupesh.sharma@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
index ae90b97aecb8..24836b6b9bbc 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
@@ -60,9 +60,8 @@
 			#interrupt-cells = <2>;
 		};
 
-		pmc8280c_lpg: lpg@e800 {
+		pmc8280c_lpg: pwm {
 			compatible = "qcom,pm8350c-pwm";
-			reg = <0xe800>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.35.1



