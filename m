Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9110B59D5F1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbiHWIc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346222AbiHWIbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19F6DAE6;
        Tue, 23 Aug 2022 01:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F5156131B;
        Tue, 23 Aug 2022 08:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF5CC433D7;
        Tue, 23 Aug 2022 08:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242542;
        bh=gZYsygsulZRaUQQNEd00HqGuo0mFJXCegFja3ncqvFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/gk+O7OZnAaPfQkWaflVw2D19xkpj8RYMw+7VfzjYNF7OzenTFNsWhsnpd3vn1dq
         W5PwTBxECRfZ00/k6eA53DQMTs5d/+R7hA+5rFcUXzfFAmcWgxsCx2LsVEFuA2DwDV
         hHYcR140WsY1h0ap26qT8eTKUWkQLFl7UgzmFtQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michal Simek <michal.simek@amd.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 134/365] spi: dt-bindings: zynqmp-qspi: add missing required
Date:   Tue, 23 Aug 2022 10:00:35 +0200
Message-Id: <20220823080123.797522157@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit acfc34f008c3e66bbcb7b9162c80c8327b6e800f upstream.

During the conversion the bindings lost list of required properties.

Fixes: c58db2abb19f ("spi: convert Xilinx Zynq UltraScale+ MPSoC GQSPI bindings to YAML")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20220704130618.199231-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml
@@ -30,6 +30,13 @@ properties:
   clocks:
     maxItems: 2
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clock-names
+  - clocks
+
 unevaluatedProperties: false
 
 examples:


