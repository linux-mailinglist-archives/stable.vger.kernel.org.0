Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D209594456
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348363AbiHOWcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349871AbiHOWbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C8D7D3A;
        Mon, 15 Aug 2022 12:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E099F6122B;
        Mon, 15 Aug 2022 19:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2121C433C1;
        Mon, 15 Aug 2022 19:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592902;
        bh=FWuztDuDnYDB/0ONcpObgbBbLxQ/7jXDQ4Ok+EGihWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/CWQNXXolhOo/XCKgP6l1XViNmQB/StG0kONyERhkHxJLYDWcT0Rl7q3pN+614Ah
         4RBuWseC/xM2Yv7CIFxocN/J3Kw5YtDLXE9YwCaidDC2y5sgFGoM9S609xtJrOIK6s
         tlXMI8WqmIZWosXHzVyZMGtC/Grzq9iZNDF3I+cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0184/1157] arm64: dts: qcom: ipq8074: fix NAND node name
Date:   Mon, 15 Aug 2022 19:52:20 +0200
Message-Id: <20220815180447.112190933@linuxfoundation.org>
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
index 4c38b15c6fd4..697f46e17903 100644
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



