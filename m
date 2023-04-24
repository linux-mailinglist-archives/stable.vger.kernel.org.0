Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800C46ECEA5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjDXNeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjDXNdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824E36EA0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61EBA61E0A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E3FC433D2;
        Mon, 24 Apr 2023 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343211;
        bh=jIbMscRZLDh+swCsTa/7ocPskf9pLOuEc31FuzFxq0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiMB8O3RceWufDanmzOocXgPkZ8k/DtehwctNZveIvYnAIqmuqGr75DUb8/sAuaM1
         7tDiSC7gGtcaGtblYnMpLlAw3MIYbiWgsSYBgDZSVt1yppgyOM+g5BJmO9vv9AQMAt
         XxLo6MvpDRaeyOGMgru7WXBSfYgljtR0yFG9XG08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianqun Xu <jay.xu@rock-chips.com>,
        Sjoerd Simons <sjoerd@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/68] ARM: dts: rockchip: fix a typo error for rk3288 spdif node
Date:   Mon, 24 Apr 2023 15:17:32 +0200
Message-Id: <20230424131127.706028686@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Jianqun Xu <jay.xu@rock-chips.com>

[ Upstream commit 02c84f91adb9a64b75ec97d772675c02a3e65ed7 ]

Fix the address in the spdif node name.

Fixes: 874e568e500a ("ARM: dts: rockchip: Add SPDIF transceiver for RK3288")
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: Sjoerd Simons <sjoerd@collabora.com>
Link: https://lore.kernel.org/r/20230208091411.1603142-1-jay.xu@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index aab28161b9ae9..250a03a066a17 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -959,7 +959,7 @@
 		status = "disabled";
 	};
 
-	spdif: sound@ff88b0000 {
+	spdif: sound@ff8b0000 {
 		compatible = "rockchip,rk3288-spdif", "rockchip,rk3066-spdif";
 		reg = <0x0 0xff8b0000 0x0 0x10000>;
 		#sound-dai-cells = <0>;
-- 
2.39.2



