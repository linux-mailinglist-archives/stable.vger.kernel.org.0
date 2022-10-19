Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44910603C0E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiJSInA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJSIlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935B01837A;
        Wed, 19 Oct 2022 01:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99897617E8;
        Wed, 19 Oct 2022 08:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88467C433C1;
        Wed, 19 Oct 2022 08:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168775;
        bh=TJwrFLLzUDARRz227XFqeD/qM+dImWjLpczpwfOOLTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmWS28khvOy59Vr52AjKFO5HoSXAMZuO7nAgdJr3Gx4aRP0QghzC3lnfZR6JZZHFM
         LPWcBY1RHk8syCBb7UImK53YyhRy7OrokbTtcmGgV3EJt+6adDdkE+Uc1yUHVwdgXr
         Ym3htPMQQyIe0t8/JZIUe5s1lEcYGeGHDJ/u8RWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 049/862] arm64: dts: qcom: sdm845-mtp: correct ADC settle time
Date:   Wed, 19 Oct 2022 10:22:16 +0200
Message-Id: <20221019083252.168645073@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 209a04885ab5f76722a1671d0fbf0a5b4bccacec upstream.

The PMIC's VADC property for settle time is qcom,hw-settle-time, not
qcom,hw-settle-time-us.  The latter is used in PMIC's TM ADC.

  qcom/sdm845-mtp.dtb: pmic@0: adc@3100:adc-chan@4c: 'qcom,hw-settle-time-us' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: d5e12f3823ae ("arm64: dts: qcom: sdm845: mtp: Add vadc channels and thermal zones")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220828084341.112146-13-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -536,42 +536,42 @@
 		reg = <ADC5_XO_THERM_100K_PU>;
 		label = "xo_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4d {
 		reg = <ADC5_AMUX_THM1_100K_PU>;
 		label = "msm_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4f {
 		reg = <ADC5_AMUX_THM3_100K_PU>;
 		label = "pa_therm1";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@51 {
 		reg = <ADC5_AMUX_THM5_100K_PU>;
 		label = "quiet_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@83 {
 		reg = <ADC5_VPH_PWR>;
 		label = "vph_pwr";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@85 {
 		reg = <ADC5_VCOIN>;
 		label = "vcoin";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 };
 


