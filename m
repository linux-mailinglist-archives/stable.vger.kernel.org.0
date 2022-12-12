Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1DF64A13F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiLLNh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiLLNg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284FB13F68
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B7661025
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F099C433EF;
        Mon, 12 Dec 2022 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852194;
        bh=uWwzdcPbXOVVbq2pf9Tbn7clwTu6D82OsExTrfO00ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXl3MPsj/fYZb+fBj9rCUfntxs+tGfC4MBZkHOUrPVom7wKLywtpDCCkJtMsFQ4b0
         EoXLaCz0QMH/5ZathWNvGZtQ353sJG0vsv9HePA5x+9W4vbzWUw/q4dhO4n5sti0pK
         XH6tDquXn0R+mQNIdV+lfvKwuYJ74sC/vH3SRfiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Furkan Kardame <f.kardame@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 004/157] arm64: dts: rockchip: Fix i2c3 pinctrl on rk3566-roc-pc
Date:   Mon, 12 Dec 2022 14:15:52 +0100
Message-Id: <20221212130934.566948156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Furkan Kardame <f.kardame@manjaro.org>

[ Upstream commit 2440ad0d851e404adcd1b9ad758f28bd59365bae ]

As per device schematic i2c3 pinctrl is connected to m0 instead of m1

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-3-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 8db83088ae4e..b8ed215ab8fb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -397,7 +397,7 @@
 
 &i2c3 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&i2c3m1_xfer>;
+	pinctrl-0 = <&i2c3m0_xfer>;
 	status = "okay";
 };
 
-- 
2.35.1



