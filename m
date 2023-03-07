Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B26AE859
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCGRPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjCGROt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5896292BE5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB42A61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E42C4339B;
        Tue,  7 Mar 2023 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209006;
        bh=lhRyszxxxRvvZhpTL2woDqoWb+vfLMFo4sqnUs/T6xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nks8Ck+dJhDuneYSZysSieskyKw5e9qziZeNDogPNcjddHGmuICn7Ni2xfkLG8d9
         K5YOgEjZySBuhG7NBfoUKWhdfBsMFXFswcdoN9Gw9iKu2RY0TrQ85EqvThnz+tVq9K
         krGbLglMHxoDeIvmaRWYURCOXHd4gIWqfDMza7xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0080/1001] arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name
Date:   Tue,  7 Mar 2023 17:47:32 +0100
Message-Id: <20230307170025.580136060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit eee64d8fbbdaab72bbab3e462f3a7b742d20c8c2 ]

Fixes:
leds: status: {...} is not of type 'array'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-12-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
index 9ef210f17b4aa..393d3cb33b9ee 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
@@ -18,7 +18,7 @@ cvbs-connector {
 	leds {
 		compatible = "gpio-leds";
 
-		status {
+		led {
 			label = "n1:white:status";
 			gpios = <&gpio_ao GPIOAO_9 GPIO_ACTIVE_HIGH>;
 			default-state = "on";
-- 
2.39.2



