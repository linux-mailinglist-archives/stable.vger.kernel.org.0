Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC00C63AF03
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiK1Rhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiK1Rhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB4BBBF;
        Mon, 28 Nov 2022 09:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C29BB80E81;
        Mon, 28 Nov 2022 17:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DAAC433C1;
        Mon, 28 Nov 2022 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657050;
        bh=H2oHa8QR3fMnJ/60rPPFl//0EEV8mINvvNg5ljevOTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUZA1V3ZzJZLP6nnqoElvJdFb20TCbg5CiN31QHUkK+vvIBRHV8fsU18MERdgI2p2
         PqeC+Fum6etUkYsFU0Es//sEs84FAxaHrowZcrHNGD84NczeWyawxVs9i19G9lxLIX
         WvOZRpoZL0lyioZl5d7LIGYlwWtqfxdLlyhozZm08QNy7vQTqkmg+2qId/bWgElJjw
         MoYxHImmD91QCWpdNZmf5TH+2z54NPy2lXWt+7OztrIIG58Sr2b3C/K3MbL8kmemI9
         Dax1c/vZJJqc6nut7kIm0CBr0zAPmt6PVnFNXnVIuhpcr5Yz2mfjQgeAZ3SokLyqDZ
         hmcUal86fzhLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Furkan Kardame <f.kardame@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael.riesch@wolfvision.net,
        pgwipeout@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 03/39] arm64: dts: rockchip: remove i2c5 from rk3566-roc-pc
Date:   Mon, 28 Nov 2022 12:35:43 -0500
Message-Id: <20221128173642.1441232-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit b44bc59d0d279fa4f3dc11b895f2c8f77719885d ]

i2c5 is owned by hdmi port

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-4-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index b8ed215ab8fb..ab1abf0bb749 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -401,10 +401,6 @@ &i2c3 {
 	status = "okay";
 };
 
-&i2c5 {
-	status = "okay";
-};
-
 &mdio1 {
 	rgmii_phy1: ethernet-phy@0 {
 		compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.35.1

