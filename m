Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E3958C128
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbiHHB5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243810AbiHHB4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB841C90A;
        Sun,  7 Aug 2022 18:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C057760DF8;
        Mon,  8 Aug 2022 01:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00568C433D7;
        Mon,  8 Aug 2022 01:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922776;
        bh=RSDlD8Uga25bmtLYdSTBMn3lox5GFYwmoLKXqo5AMGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olZVpdX1siRj/tcvR/WLVfDm5+y4gnTXUtPssiQHgUdVG9ovTlQfKc5xgL2YVem+5
         KYQrbJHzcb+L4D2GJpJRPefZk/brpWkWjS1dZY/P10SytMEfA82HpRWEj5+2ss5RDX
         FSrUe6Se2y/Y4WfqEcGW6tiL9pqu9vfiz/2RZHjMRwC+0El3L3KTCGOPpWIJqMoH2c
         gANMkqA9a9AZdw+z92LhfHbmJ2R+4g8e6Yqy3+8U0urdsLSQUChNVIXCpshGr8t98P
         3eD/tC3PzPZAqOoiDfBYVsAamJHm1pMQn8MiSbehUcKPNv9UZ3BDQlwRXFG+87OG9Z
         Cq6DXMkNVbbQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/16] arm64: dts: qcom: ipq8074: fix NAND node name
Date:   Sun,  7 Aug 2022 21:39:10 -0400
Message-Id: <20220808013914.316709-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013914.316709-1-sashal@kernel.org>
References: <20220808013914.316709-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit b39961659ffc3c3a9e3d0d43b0476547b5f35d49 ]

Per schema it should be nand-controller@79b0000 instead of nand@79b0000.
Fix it to match nand-controller.yaml requirements.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220621120642.518575-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index f48d14cd10a3..bdee07305ce5 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -261,7 +261,7 @@ qpic_bam: dma@7984000 {
 			status = "disabled";
 		};
 
-		qpic_nand: nand@79b0000 {
+		qpic_nand: nand-controller@79b0000 {
 			compatible = "qcom,ipq8074-nand";
 			reg = <0x79b0000 0x10000>;
 			#address-cells = <1>;
-- 
2.35.1

