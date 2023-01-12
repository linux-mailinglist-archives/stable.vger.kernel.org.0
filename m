Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48316673D8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjALOAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbjALN7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:59:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FC151320
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35D10CE1E6E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F1AC433D2;
        Thu, 12 Jan 2023 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531982;
        bh=zzLuUU4rG14XyxJiFO/vJJ7P5Nwc3Mzom4Mh5RRjFyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlxdKRSEotaToY7LZMV4LPePaICd+DomFb3UNAKnwuzjJWRKTgmJEiXEZl8cfxfrN
         30unYd9vnXG5zntdDAu2/j7JvNOM5UKVmEYqyeqt5WqlIHmuMXbEb/6UQrk7s8C8rf
         pxSzWaJWT2GPTUQxB8X+fcrcxXTQEPmfMneAE51I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kory Maincent <kory.maincent@bootlin.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/783] arm: dts: spear600: Fix clcd interrupt
Date:   Thu, 12 Jan 2023 14:45:31 +0100
Message-Id: <20230112135524.877353520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 0336e2ce34e7a89832b6c214f924eb7bc58940be ]

Interrupt 12 of the Interrupt controller belongs to the SMI controller,
the right one for the display controller is the interrupt 13.

Fixes: 8113ba917dfa ("ARM: SPEAr: DT: Update device nodes")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/spear600.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear600.dtsi b/arch/arm/boot/dts/spear600.dtsi
index fd41243a0b2c..9d5a04a46b14 100644
--- a/arch/arm/boot/dts/spear600.dtsi
+++ b/arch/arm/boot/dts/spear600.dtsi
@@ -47,7 +47,7 @@ clcd: clcd@fc200000 {
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0xfc200000 0x1000>;
 			interrupt-parent = <&vic1>;
-			interrupts = <12>;
+			interrupts = <13>;
 			status = "disabled";
 		};
 
-- 
2.35.1



