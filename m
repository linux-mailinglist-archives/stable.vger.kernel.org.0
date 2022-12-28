Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062E65797C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiL1PCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiL1PBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:01:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41E912D2A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D917861540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA565C433D2;
        Wed, 28 Dec 2022 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239688;
        bh=+8C5TD0uVy2aZN8sHo/7+k0ZY9KAbPu+uh9uqy9bU4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWQgpLBrbWxilEqTTm/Gp+lXB4QYq9fKMgfVHW4nO0Qq16rZ/mGcOCGPTNpDapfNc
         LtUMrWrz6pETzh/KvmU/2Z8qeF7/m9+Anir1s+1s+ZKbvqkMeLEUAOuZhYRnD9MO3E
         W72BZ/V8XpSXlo03skBcLjqn/cw6ETJ/rMnUEwbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0064/1073] arm64: dts: mt2712e: Fix unit address for pinctrl node
Date:   Wed, 28 Dec 2022 15:27:32 +0100
Message-Id: <20221228144329.831314681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d4516f53a611b362db7ba7a8889923d469f57e1 ]

The unit address for the pinctrl node is (0x)1000b000 and not
(0x)10005000, which is the syscfg_pctl_a address instead.

This fixes the following warning:
arch/arm64/boot/dts/mediatek/mt2712e.dtsi:264.40-267.4: Warning
(unique_unit_address): /syscfg_pctl_a@10005000: duplicate
unit-address (also used in node /pinctrl@10005000)

Fixes: f0c64340b748 ("arm64: dts: mt2712: add pintcrl device node.")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-5-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index dcd3df8eb4da..2ebefd144d6f 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -266,7 +266,7 @@ syscfg_pctl_a: syscfg_pctl_a@10005000 {
 		reg = <0 0x10005000 0 0x1000>;
 	};
 
-	pio: pinctrl@10005000 {
+	pio: pinctrl@1000b000 {
 		compatible = "mediatek,mt2712-pinctrl";
 		reg = <0 0x1000b000 0 0x1000>;
 		mediatek,pctl-regmap = <&syscfg_pctl_a>;
-- 
2.35.1



