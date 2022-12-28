Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09B6584DF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiL1RDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiL1RDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE63DDE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B040261563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DE6C433D2;
        Wed, 28 Dec 2022 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246632;
        bh=DAKJyQ1lT+RCLVmNbvt6+iEHVeuQoYcblZIZSvSS4WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrL+0UiJDjAm2OhNWVl3K77JlEeS4+5MgZAyE78ZMyZNR8Oh7U6wtqT84T5rdhUay
         afix1pHBa7lbk6r2m65PrdRxmT8NpqSPyAIdVmcJB2kIdM77r6Tfm2dCJcnr2q4huJ
         rXNwIVNtS+qlULVmAw4IAXOtdYxO7eLTtAYMtCyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Li Jun <jun.li@nxp.com>, Abel Vesa <abel.vesa@linaro.org>
Subject: [PATCH 6.1 1107/1146] dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
Date:   Wed, 28 Dec 2022 15:44:06 +0100
Message-Id: <20221228144400.226133287@linuxfoundation.org>
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

From: Li Jun <jun.li@nxp.com>

commit 5c1f7f1090947d494c30042123e0ec846f696336 upstream.

usb suspend clock has a gate shared with usb_root_clk.

Fixes: 9c140d9926761 ("clk: imx: Add support for i.MX8MP clock driver")
Cc: stable@vger.kernel.org # v5.19+
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1664549663-20364-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/imx8mp-clock.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -324,8 +324,9 @@
 #define IMX8MP_CLK_CLKOUT2_SEL			317
 #define IMX8MP_CLK_CLKOUT2_DIV			318
 #define IMX8MP_CLK_CLKOUT2			319
+#define IMX8MP_CLK_USB_SUSP			320
 
-#define IMX8MP_CLK_END				320
+#define IMX8MP_CLK_END				321
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1


