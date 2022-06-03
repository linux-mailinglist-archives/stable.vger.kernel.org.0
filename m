Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D9453CF86
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbiFCRyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347274AbiFCRwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B1F15703;
        Fri,  3 Jun 2022 10:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92C1DCE247C;
        Fri,  3 Jun 2022 17:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E13DC385A9;
        Fri,  3 Jun 2022 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278719;
        bh=/EyG57P4jtW4RHdb3WPUV5f8lPpG5g2cOM8KMHmq+5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyvNMzbqsFmvp6q52Sk5FBIWuMIT3pcOiVwtaUdBPM25EfEF4eYA0aGj0DD3vlzBU
         eCbgKkhsNCzAThg6kr+GWrLFWTz35Fw6CPotwq3qHbrV3wDVDNfiDfx/SrNUrVJqrb
         QIaqLgsWZXMApUk4zw6Ns2B+Oj5+g1IM6K1Pm+2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 41/66] ARM: dts: s5pv210: Correct interrupt name for bluetooth in Aries
Date:   Fri,  3 Jun 2022 19:43:21 +0200
Message-Id: <20220603173821.858530708@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jonathan Bakker <xc-racer2@live.ca>

commit 3f5e3d3a8b895c8a11da8b0063ba2022dd9e2045 upstream.

Correct the name of the bluetooth interrupt from host-wake to
host-wakeup.

Fixes: 1c65b6184441b ("ARM: dts: s5pv210: Correct BCM4329 bluetooth node")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/CY4PR04MB0567495CFCBDC8D408D44199CB1C9@CY4PR04MB0567.namprd04.prod.outlook.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -895,7 +895,7 @@
 		device-wakeup-gpios = <&gpg3 4 GPIO_ACTIVE_HIGH>;
 		interrupt-parent = <&gph2>;
 		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "host-wake";
+		interrupt-names = "host-wakeup";
 	};
 };
 


