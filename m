Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78CC55C664
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiF1CTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243306AbiF1CS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:18:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8BB23BE6;
        Mon, 27 Jun 2022 19:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B90B81C0A;
        Tue, 28 Jun 2022 02:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E93C341D0;
        Tue, 28 Jun 2022 02:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382726;
        bh=Ys0RJPZ4GxYz/5tskLY3MZu3a5KGfyWFRcYRdYGjEjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtQE6WNxOpA89ZzVTtCjNDk/lrjftwTqTY/uEe5nw23o5Rx2QtRhtrkik/xXyVZEW
         jfYyJeILjEvt+CX6x+MMGwzMeuKzOploGAPrCmFjdowgD88k1hTbG0qP/VHm1myG6/
         f1AITnyit+34pIGvTZMV0Cq5RuxboU0bxRitH2TZoz9lg0dp5dbtFnBhOIjSTSXC0M
         dbkXYkv8d0cAWDfNCLgx6wmVG5hckRA1quwM0YCoVtsrcHwJnP0hUbN5rdThLS7ToF
         cDUCkaGqxOobHwKCcw0asoA7CIMn9+EGGPxOgljONdrHDYzn4V6ylChHvUuCIjZfcW
         ZiGaX5rB/1MvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <festevam@denx.de>, Chester Lin <clin@suse.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 04/53] arm64: s32g2: Pass unit name to soc node
Date:   Mon, 27 Jun 2022 22:17:50 -0400
Message-Id: <20220628021839.594423-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 4266e2f70d4388b8c6a95056169954ff049ced94 ]

Pass unit name to soc node to fix the following W=1 build warning:

arch/arm64/boot/dts/freescale/s32g2.dtsi:82.6-123.4: Warning (unit_address_vs_reg): /soc: node has a reg or ranges property, but no unit name

Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Chester Lin <clin@suse.com>
Signed-off-by: Chester Lin <clin@suse.com>
Link: https://lore.kernel.org/r/20220514143505.1554813-1-festevam@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/s32g2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/s32g2.dtsi b/arch/arm64/boot/dts/freescale/s32g2.dtsi
index 59ea8a25aa4c..824d401e7a2c 100644
--- a/arch/arm64/boot/dts/freescale/s32g2.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32g2.dtsi
@@ -79,7 +79,7 @@ psci {
 		};
 	};
 
-	soc {
+	soc@0 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.35.1

