Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D3C59D9EE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351954AbiHWKDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352410AbiHWKBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BE77C197;
        Tue, 23 Aug 2022 01:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A45B8105C;
        Tue, 23 Aug 2022 08:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9563EC433C1;
        Tue, 23 Aug 2022 08:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244578;
        bh=/8UyoVEL/6prq7euy3iXui/QYxwtGVXrnVvgQbV3Lk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxB/875abvlubRq1mqJHzHupD3Zl97qrD4fH61ZpqEp5JmKKDCzlkzh4jo2dUVm7Q
         ZHoesvKl2Cixyt8eX7dlcVAbX70MlFZG64ESecnCHE7x1BzQ9xcu7G/U95reeKhcGW
         n2DMmjTn6dDvkew8iY2ZnudDFBqQTSbThOWVKS6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 086/244] dt-bindings: clock: qcom,gcc-msm8996: add more GCC clock sources
Date:   Tue, 23 Aug 2022 10:24:05 +0200
Message-Id: <20220823080101.904782940@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 2b4e75a7a7c8d3531a40ebb103b92f88ff693f79 upstream.

Add additional GCC clock sources. This includes PCIe and USB PIPE and
UFS symbol clocks.

Fixes: 2a8aa18c1131 ("dt-bindings: clk: qcom: Fix self-validation, split, and clean cruft")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220620071936.1558906-2-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml |   16 ++++++++++
 1 file changed, 16 insertions(+)

--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
@@ -22,16 +22,32 @@ properties:
     const: qcom,gcc-msm8996
 
   clocks:
+    minItems: 3
     items:
       - description: XO source
       - description: Second XO source
       - description: Sleep clock source
+      - description: PCIe 0 PIPE clock (optional)
+      - description: PCIe 1 PIPE clock (optional)
+      - description: PCIe 2 PIPE clock (optional)
+      - description: USB3 PIPE clock (optional)
+      - description: UFS RX symbol 0 clock (optional)
+      - description: UFS RX symbol 1 clock (optional)
+      - description: UFS TX symbol 0 clock (optional)
 
   clock-names:
+    minItems: 3
     items:
       - const: cxo
       - const: cxo2
       - const: sleep_clk
+      - const: pcie_0_pipe_clk_src
+      - const: pcie_1_pipe_clk_src
+      - const: pcie_2_pipe_clk_src
+      - const: usb3_phy_pipe_clk_src
+      - const: ufs_rx_symbol_0_clk_src
+      - const: ufs_rx_symbol_1_clk_src
+      - const: ufs_tx_symbol_0_clk_src
 
   '#clock-cells':
     const: 1


