Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ADC621497
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiKHOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbiKHOCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CC668684
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:02:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40826611B7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA9C433C1;
        Tue,  8 Nov 2022 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916172;
        bh=MPQiUJuGh3Mkt+2KtvbwhRfouXtdios22qeyaqeMAHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLSmub2BXnO7FXpBO0J2m1d8Et7wRbp893Zw/0veJFILLbp5B1V8BsumTDihIZe53
         H2R2t+DVfY4zpmcGp7a6bHfwpnZ0JZqPhTwJJZgLoNpQSARkuXvUxnNKHHvmKA0Hxw
         1Afo+qG8WvlDxdK9xQ2J39JzVUOGsPvawukJVdPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/144] ARM: dts: imx6qdl-gw59{10,13}: fix user pushbutton GPIO offset
Date:   Tue,  8 Nov 2022 14:39:22 +0100
Message-Id: <20221108133348.865496227@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit bb5ad73941dc3f4e3c2241348f385da6501d50ea ]

The GW5910 and GW5913 have a user pushbutton that is tied to the
Gateworks System Controller GPIO offset 2. Fix the invalid offset of 0.

Fixes: 64bf0a0af18d ("ARM: dts: imx6qdl-gw: add Gateworks System Controller support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-gw5910.dtsi | 2 +-
 arch/arm/boot/dts/imx6qdl-gw5913.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw5910.dtsi b/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
index 68e5ab2e27e2..6bb4855d13ce 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
@@ -29,7 +29,7 @@ gpio-keys {
 
 		user-pb {
 			label = "user_pb";
-			gpios = <&gsc_gpio 0 GPIO_ACTIVE_LOW>;
+			gpios = <&gsc_gpio 2 GPIO_ACTIVE_LOW>;
 			linux,code = <BTN_0>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6qdl-gw5913.dtsi b/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
index 8e23cec7149e..696427b487f0 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
@@ -26,7 +26,7 @@ gpio-keys {
 
 		user-pb {
 			label = "user_pb";
-			gpios = <&gsc_gpio 0 GPIO_ACTIVE_LOW>;
+			gpios = <&gsc_gpio 2 GPIO_ACTIVE_LOW>;
 			linux,code = <BTN_0>;
 		};
 
-- 
2.35.1



