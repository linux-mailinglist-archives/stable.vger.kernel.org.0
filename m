Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621CC5B7113
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiIMOgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiIMOfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377F3647DF;
        Tue, 13 Sep 2022 07:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 025826148A;
        Tue, 13 Sep 2022 14:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF1C433D6;
        Tue, 13 Sep 2022 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078761;
        bh=KZQ+u5u1w5wfBI8kc8XsKC4wm0yPOaDU3mOXcY8OnCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iny2wxUb7tlnGLzYmgv+rMmvxO5gzeK/IAgKm4r0ZbA0Ydzl+mxJqnrwoStUVV/YE
         XHG30bPszPpzKNXnf0F7bD+Rm7F/S1KmgwUnuyC18zJPbO5t3wC3XDnP0odhOp73rq
         XfnPqUB/7G2W9Itai7KLs0bwR/2aJ1Xx7SxzjSQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/121] ARM: dts: at91: sama5d27_wlsom1: dont keep ldo2 enabled all the time
Date:   Tue, 13 Sep 2022 16:04:16 +0200
Message-Id: <20220913140400.158162339@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 617a0d9fe6867bf5b3b7272629cd780c27c877d9 ]

ldo2 is not used by any consumer on sama5d27_wlsom1 board, thus
don't keep it enabled all the time.

Fixes: 5d4c3cfb63fe ("ARM: dts: at91: sama5d27_wlsom1: add SAMA5D27 wlsom1 and wlsom1-ek")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-8-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
index 70513caf3e8d0..a818e8ebd638f 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
@@ -169,7 +169,6 @@
 				regulator-name = "LDO2";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
-				regulator-always-on;
 
 				regulator-state-standby {
 					regulator-on-in-suspend;
-- 
2.35.1



