Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD26458BFC0
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242827AbiHHBnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbiHHBl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C2A13E13;
        Sun,  7 Aug 2022 18:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01619B80E10;
        Mon,  8 Aug 2022 01:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B9C43470;
        Mon,  8 Aug 2022 01:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922527;
        bh=or9ghtm9eTD9b4MK7ycw9/x0MKycVDa98HnF9GQBIvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLzbWqmqyN5JpQwiSdhKEmDr7E1hBoR0aWo3umVtSWAbMzML5+xFCoeIYW227lCDM
         h5D+0zSfdZ2inw3uHxRHKMkjIPi2/doZi9SVqqofKbuYOZ/2pl6blNFPmf5DSeg7sz
         zFd5ToiJ/N0cK8ZR+J1FiQdwdOQP/v8L5+sjmOYK1mLVI27xk6A/W+j7a01iDAtcFy
         mpTcE4ssGJEqozWcsBJCzzDfygESDmNpzIrLNRtLAjHtLHSqd5IxcwaMP//HVkb2yD
         l5pMi+hxLAPH4JOiFV2FdgjdxHI9sUvDv8OgJMc7i5l+0SOTOiNtxvBknTcOoLJzOb
         Z4bxk0lSILCOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 42/53] arm64: dts: qcom: ipq8074: fix NAND node name
Date:   Sun,  7 Aug 2022 21:33:37 -0400
Message-Id: <20220808013350.314757-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index 8d4e0e193439..664fba3632b1 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -534,7 +534,7 @@ qpic_bam: dma-controller@7984000 {
 			status = "disabled";
 		};
 
-		qpic_nand: nand@79b0000 {
+		qpic_nand: nand-controller@79b0000 {
 			compatible = "qcom,ipq8074-nand";
 			reg = <0x079b0000 0x10000>;
 			#address-cells = <1>;
-- 
2.35.1

