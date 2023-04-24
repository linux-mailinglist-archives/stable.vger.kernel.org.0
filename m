Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA86ECD07
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjDXNUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjDXNTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6624526F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:19:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BBC4621F3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179FEC433D2;
        Mon, 24 Apr 2023 13:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342372;
        bh=QaD/vAIdzvoCO5n7Ujny70GF86YNke4wKWUXo/+zAx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvLGoFQALQBrDjCHWXlzi1xvINl7YkSBQW9xmG2zbqa75WO8zIs8rA7WWgxGDYKXm
         c+A5hZk32Yb5/L/4uSQOrYJwSo542qhw721ETizvr4CYKfszfLpjQdlqeebTHC3cW9
         QLEwPe0ZvnHaME3ayiJCaA/RiFszntJtdaHC3WFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/73] arm64: dts: imx8mm-evk: correct pmic clock source
Date:   Mon, 24 Apr 2023 15:16:18 +0200
Message-Id: <20230424131129.213096386@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 85af7ffd24da38e416a14bd6bf207154d94faa83 ]

The osc_32k supports #clock-cells as 0, using an id is wrong, drop it.

Fixes: a6a355ede574 ("arm64: dts: imx8mm-evk: Add 32.768 kHz clock to PMIC")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
index e033d0257b5a1..ff5324e94ee82 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
@@ -136,7 +136,7 @@
 		rohm,reset-snvs-powered;
 
 		#clock-cells = <0>;
-		clocks = <&osc_32k 0>;
+		clocks = <&osc_32k>;
 		clock-output-names = "clk-32k-out";
 
 		regulators {
-- 
2.39.2



