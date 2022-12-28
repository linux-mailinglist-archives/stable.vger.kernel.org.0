Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185BD657995
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiL1PDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiL1PCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050BA12ADD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964EAB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA154C433D2;
        Wed, 28 Dec 2022 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239754;
        bh=KDlqBIQ6+eHV4ipR1bxlAghokyYIue9Jm0Y24O/IY5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euk5Pz3oUf72FB2/di8tbXAaLxopZqhIYXMLbNC/74GK+3F6zhUQq5Cpwa60gswWy
         SzJAZ+/LRbXzsTZ9t1JR14YddfnlItGZPNwgW/cSmsU3T5tpu01p3fMSZdNxxgCqT8
         Ju80nM2/TG20v///30aCyM1gb1fb/QDYi+c1rAeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0039/1146] arm64: dts: qcom: sm6125: fix SDHCI CQE reg names
Date:   Wed, 28 Dec 2022 15:26:18 +0100
Message-Id: <20221228144331.225383729@linuxfoundation.org>
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

[ Upstream commit 3de1172624b3c4ca65730bc34333ab493510b3e1 ]

SM6125 comes with SDCC (SDHCI controller) v5, so the second range of
registers is cqhci, not core.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Tested-by: Marijn Suijten <marijn.suijten@somainline.org> # Sony Xperia 10 II
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221026163646.37433-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 1fe3fa3ad877..7818fb6c5a10 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -458,7 +458,7 @@ rpm_msg_ram: sram@45f0000 {
 		sdhc_1: mmc@4744000 {
 			compatible = "qcom,sm6125-sdhci", "qcom,sdhci-msm-v5";
 			reg = <0x04744000 0x1000>, <0x04745000 0x1000>;
-			reg-names = "hc", "core";
+			reg-names = "hc", "cqhci";
 
 			interrupts = <GIC_SPI 348 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1



