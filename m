Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3A579BFB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiGSMfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiGSMeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC02974E34;
        Tue, 19 Jul 2022 05:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B9F9617B2;
        Tue, 19 Jul 2022 12:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C7BC341CB;
        Tue, 19 Jul 2022 12:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232782;
        bh=nyiV2tkPIYSQkq0L9P1Xt/heiH1x0GRXjbah9mBkCv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tajLjjGX66oUVwcFSoTQE/uyWPVZRBmj0wRfRpZ1xY7OwRQX0c8tbe3l+l1ZfS6sv
         ehtMoI/QtQnhTzCZjhFGXEpin8U5KCsnTzBfDNfalPr2dWsHAE7synZW8EzZIc2VdE
         VNWNbrLhSpEExMAAIHOF+qZB2yRj17x7jdTBZ06I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Wanner <Ryan.Wanner@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/167] ARM: dts: at91: sama5d2: Fix typo in i2s1 node
Date:   Tue, 19 Jul 2022 13:53:15 +0200
Message-Id: <20220719114702.643602659@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit 2fdf15b50a46e366740df4cccbe2343269b4ff55 ]

Fix typo in i2s1 causing errors in dt binding validation.
Change assigned-parrents to assigned-clock-parents
to match i2s0 node formatting.

Fixes: 1ca81883c557 ("ARM: dts: at91: sama5d2: add nodes for I2S controllers")
Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
[claudiu.beznea: use imperative addressing in commit description, remove
 blank line after fixes tag, fix typo in commit message]
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220707215812.193008-1-Ryan.Wanner@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama5d2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index de88eb484718..4c87c2aa8fc8 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -1125,7 +1125,7 @@ AT91_XDMAC_DT_PERID(33))>,
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 55>, <&pmc PMC_TYPE_GCK 55>;
 				clock-names = "pclk", "gclk";
 				assigned-clocks = <&pmc PMC_TYPE_CORE PMC_I2S1_MUX>;
-				assigned-parrents = <&pmc PMC_TYPE_GCK 55>;
+				assigned-clock-parents = <&pmc PMC_TYPE_GCK 55>;
 				status = "disabled";
 			};
 
-- 
2.35.1



