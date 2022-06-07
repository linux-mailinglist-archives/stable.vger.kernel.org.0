Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0C354103E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354231AbiFGTVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355270AbiFGTUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:20:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84940198C0F;
        Tue,  7 Jun 2022 11:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF753CE2425;
        Tue,  7 Jun 2022 18:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B19C385A5;
        Tue,  7 Jun 2022 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625311;
        bh=92uU6VQZ8vRHI63+qTv3k7gUUiysfrjpvmX9xY6PYjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9krlvTGWNHnq/Tjeym+gi/cowXe/nUj+5ID8qNq6W4Vy3NIObJeT6ekm4S2HTw/X
         OXVuixKjuoni9dbzekaVfuovD4YHTANWRDRxun1+bO+2yB8BJNiSN7GrScRmm/woE1
         +NaNJZEbrFk/ba9TU+XL1y3LrMKNwhaMMBjSB4/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 640/667] ARM: dts: s5pv210: Remove spi-cs-high on panel in Aries
Date:   Tue,  7 Jun 2022 19:05:05 +0200
Message-Id: <20220607164953.854156747@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

commit 096f58507374e1293a9e9cff8a1ccd5f37780a20 upstream.

Since commit 766c6b63aa04 ("spi: fix client driver breakages when using
GPIO descriptors"), the panel has been blank due to an inverted CS GPIO.
In order to correct this, drop the spi-cs-high from the panel SPI device.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/CY4PR04MB05670C771062570E911AF3B4CB1C9@CY4PR04MB0567.namprd04.prod.outlook.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -564,7 +564,6 @@
 			reset-gpios = <&mp05 5 GPIO_ACTIVE_LOW>;
 			vdd3-supply = <&ldo7_reg>;
 			vci-supply = <&ldo17_reg>;
-			spi-cs-high;
 			spi-max-frequency = <1200000>;
 
 			pinctrl-names = "default";


