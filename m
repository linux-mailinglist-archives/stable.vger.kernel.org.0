Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C18649F95
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbiLLNMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiLLNL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:11:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7687612ABB
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 102266104A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F35C433D2;
        Mon, 12 Dec 2022 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850713;
        bh=kuMPUkubI3lgAaCiXGGGR2/9HtVVVMM/J328jfyGQRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGFINTepthv7pR0W5576PRC/cJ3st8/ot9TXKC+2O80VpWbcZ+5G3YuKR+VeBrcR7
         gv87etU7KO1IUxE4DT02yY0cNbzeXBF8rMHggxBs43P54CczLF1KvZVJwkOBb5xw7z
         kVOxTcmXGBGRCGk6AyxzwMWIbpP0q5ywzDtm7sjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/106] arm64: dts: rockchip: fix ir-receiver node names
Date:   Mon, 12 Dec 2022 14:09:14 +0100
Message-Id: <20221212130925.368395182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit de0d04b9780a23eb928aedfb6f981285f78d58e5 ]

Fix ir-receiver node names on Rockchip boards,
so that they match with regex: '^ir(-receiver)?(@[a-f0-9]+)?$'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/e9764253-8ce8-150b-4820-41f03f845469@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index fbcb9531cc70..213c0759c4b8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -13,7 +13,7 @@
 		stdout-path = "serial2:1500000n8";
 	};
 
-	ir_rx {
+	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PC0 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
-- 
2.35.1



