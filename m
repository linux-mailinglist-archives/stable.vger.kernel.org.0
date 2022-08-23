Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158259D9F7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiHWKEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352466AbiHWKB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BA97C302;
        Tue, 23 Aug 2022 01:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D823B81B90;
        Tue, 23 Aug 2022 08:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0A2C433C1;
        Tue, 23 Aug 2022 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244584;
        bh=JqeXyUSafTDR1CCZmv9/KUNztoOdz6JdHP9rzp7oSk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXUGWO9Y/fqU7N6Lm60+bwUu++8xTausspGNcsdqraUOP6M8L1/NOvbM2pZEc0wj5
         5+KiFOKqAqyKUEGdIv1RmyFMiwfAnf0r6Q2zl3ZOu8ZlPdEZ36NVLJHGUW5nEgEJgV
         Iy+CRsJYfiP7+FsnkzMsm/YsOssWIsW5MzvI3qFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michal Simek <michal.simek@amd.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 087/244] spi: dt-bindings: cadence: add missing required
Date:   Tue, 23 Aug 2022 10:24:06 +0200
Message-Id: <20220823080101.934302261@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 6eee27c598fde65988723b785a9c9192d5ffb93a upstream.

During the conversion the bindings lost list of required properties.

Fixes: aa7968682a2b ("spi: convert Cadence SPI bindings to YAML")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20220704130618.199231-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/spi-cadence.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/spi/spi-cadence.yaml b/Documentation/devicetree/bindings/spi/spi-cadence.yaml
index 9787be21318e..82d0ca5c00f3 100644
--- a/Documentation/devicetree/bindings/spi/spi-cadence.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-cadence.yaml
@@ -49,6 +49,13 @@ properties:
     enum: [ 0, 1 ]
     default: 0
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clock-names
+  - clocks
+
 unevaluatedProperties: false
 
 examples:
-- 
2.37.2



