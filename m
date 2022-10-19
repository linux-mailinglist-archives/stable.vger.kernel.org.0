Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A204060480E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiJSNsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiJSNrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C8EC3564;
        Wed, 19 Oct 2022 06:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D35B82424;
        Wed, 19 Oct 2022 08:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25DEC433D6;
        Wed, 19 Oct 2022 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169850;
        bh=byYn4hlexYU9ll25yQ+O1Xv+YNlrWSdQs/8nM/fstBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bySEsqoOa2IbopnsF5PB5PPZ+ttU55VOg8GnoaDfruY3ydDRUB/IDHtVbM6Y7FiS4
         TK6512y5CDf+qsdikWVtuvkWaB3A2nXlvZb+/FH2C1VnUo0acWOBwEwKP3FoFyRGJv
         /KRcSvBngnI71jwBS1B4jWMwIxNlxs5DQRx4hIg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 432/862] arm64: dts: qcom: pm8350c: Drop PWM reg declaration
Date:   Wed, 19 Oct 2022 10:28:39 +0200
Message-Id: <20221019083309.063570347@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit eeca7d46217ccfe9289530e959c0fb29190af0d6 ]

The PWM is a part of the SPMI PMIC block and maps several different
addresses within the SPMI block. It is not accurate to describe as pwm@reg
as a result.

Fixes: 5be66d2dc887 ("arm64: dts: qcom: pm8350c: Add pwm support")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220828132648.3624126-3-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8350c.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8350c.dtsi b/arch/arm64/boot/dts/qcom/pm8350c.dtsi
index e0bbb67717fe..f28e71487d5c 100644
--- a/arch/arm64/boot/dts/qcom/pm8350c.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8350c.dtsi
@@ -30,9 +30,8 @@
 			#interrupt-cells = <2>;
 		};
 
-		pm8350c_pwm: pwm@e800 {
+		pm8350c_pwm: pwm {
 			compatible = "qcom,pm8350c-pwm";
-			reg = <0xe800>;
 			#pwm-cells = <2>;
 			status = "disabled";
 		};
-- 
2.35.1



