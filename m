Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BBE5B720D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiIMOuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiIMOtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DEB6FA10;
        Tue, 13 Sep 2022 07:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08827B80F91;
        Tue, 13 Sep 2022 14:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6581AC433C1;
        Tue, 13 Sep 2022 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079007;
        bh=+HVORsy337V9mir6s9za8/AEFMn638feo84QoH02W9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dM+uXAhAKsF8ZhWfRqGxvUv5r9O4c/yFgetXAZcxGRGg6pPN9vLyER/49QKqfswog
         YxNZkXTG9i4zKy4eNv4Qb6VAfSO9Uqb9K0W7oL6xJttV76GU426wOd7Wji/RETmnRF
         bKc404MYuCNT40UEcSn8EBW6IIVzDg4jO48Tk+XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/79] ARM: dts: at91: sama5d27_wlsom1: dont keep ldo2 enabled all the time
Date:   Tue, 13 Sep 2022 16:04:51 +0200
Message-Id: <20220913140352.495071729@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
index 7f16d62bb1a1a..9c8b3eb49ea30 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
@@ -163,7 +163,6 @@
 				regulator-name = "LDO2";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
-				regulator-always-on;
 
 				regulator-state-standby {
 					regulator-on-in-suspend;
-- 
2.35.1



