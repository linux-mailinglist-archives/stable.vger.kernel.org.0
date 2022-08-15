Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5183594679
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352196AbiHOW5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352639AbiHOW4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E64F45F65;
        Mon, 15 Aug 2022 12:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDB3B81136;
        Mon, 15 Aug 2022 19:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B71C433C1;
        Mon, 15 Aug 2022 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593340;
        bh=gpfEd0DEpMYvC47OF/ZHghExQA0IRRvZ33c8l3jT4wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D53Sway6eXDajbHFJ6SUqk9eKsa2IomERAYkYswidsseZuLjpx90Z3zA5vCpwSqTk
         NkPYpVHJW9DJmAY+5jMWyas53Plg3ooNq8sIdzM5wmZKo97dOvw2mjOopZfEq++TMV
         ndhyrOtNZYh4jM4ZdgIvXxpc7KMORVLspCxJq2aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0244/1157] ARM: dts: qcom: pm8841: add required thermal-sensor-cells
Date:   Mon, 15 Aug 2022 19:53:20 +0200
Message-Id: <20220815180449.329029479@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e2759fa0676c9a32bbddb9aff955b54bb35066ad ]

The PM8841 temperature sensor has to define thermal-sensor-cells.

Fixes: dab8134ca072 ("ARM: dts: qcom: Add PM8841 functions device nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220608112702.80873-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-pm8841.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/qcom-pm8841.dtsi b/arch/arm/boot/dts/qcom-pm8841.dtsi
index 2caf71eacb52..b5cdde034d18 100644
--- a/arch/arm/boot/dts/qcom-pm8841.dtsi
+++ b/arch/arm/boot/dts/qcom-pm8841.dtsi
@@ -24,6 +24,7 @@ temp-alarm@2400 {
 			compatible = "qcom,spmi-temp-alarm";
 			reg = <0x2400>;
 			interrupts = <4 0x24 0 IRQ_TYPE_EDGE_RISING>;
+			#thermal-sensor-cells = <0>;
 		};
 	};
 
-- 
2.35.1



