Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BE4F3403
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355950AbiDEKWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiDEJ3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4731DC29;
        Tue,  5 Apr 2022 02:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C547E61576;
        Tue,  5 Apr 2022 09:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F7CC385A2;
        Tue,  5 Apr 2022 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150201;
        bh=Fm93SfOtVMca980+6uyVenif6pThe6aO6Z2kp7al95w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtDolMDuOi5ZC2qlPz/hZ/f5FiDFRC0pLyqgwMMZTTR4F7YdmFh/ZLtODWE1ZWv0w
         5gWYdcm2NCLD4KmQ48X4xIPvFcBxUHGaQiip+J+JC0ohw/fIZrPrjvWMkD78fAFTQR
         rIVltZvjUZnprdKYpSjLHYXvD/SgJ/ThbRpVXj6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.16 0989/1017] dt-bindings: pinctrl: pinctrl-microchip-sgpio: Fix example
Date:   Tue,  5 Apr 2022 09:31:42 +0200
Message-Id: <20220405070423.558959987@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit a6ff90f3fbd4d902aad8777f0329cef3a2768bde upstream.

The blamed commit adds support for irq, but the reqisters for irq are
outside of the memory size. They are at address 0x108. Therefore update
the memory size to cover all the registers used by the device.

Fixes: 01a9350bdd49fb ("dt-bindings: pinctrl: pinctrl-microchip-sgpio: Add irq support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220204153535.465827-2-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
@@ -145,7 +145,7 @@ examples:
       clocks = <&sys_clk>;
       pinctrl-0 = <&sgpio2_pins>;
       pinctrl-names = "default";
-      reg = <0x1101059c 0x100>;
+      reg = <0x1101059c 0x118>;
       microchip,sgpio-port-ranges = <0 0>, <16 18>, <28 31>;
       bus-frequency = <25000000>;
       sgpio_in2: gpio@0 {


