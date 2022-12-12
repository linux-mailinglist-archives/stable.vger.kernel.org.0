Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1003164A141
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiLLNhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiLLNhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:37:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9169213F84
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ACA4B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE1C433EF;
        Mon, 12 Dec 2022 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852197;
        bh=zACkU0W13o7qFnR/o1IHxmuRGO5fj0rTbw+zLCHYxAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+JpawbnI9kDBITZfWxnRfpTG4VR6mBsktPEmYOUl33NRo3jXnm9UAiJhlan/R2D/
         hHoLq0M/VYTzBknzU1IXg7KO2hn5g/ImCSD2+5hHR81a2vqIxbhILL99X2yQ6NhDih
         dXewLoHU6dRqA89BCHEQb8R5+SXZ3LulR2ibf6u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Furkan Kardame <f.kardame@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 005/157] arm64: dts: rockchip: remove i2c5 from rk3566-roc-pc
Date:   Mon, 12 Dec 2022 14:15:53 +0100
Message-Id: <20221212130934.617576792@linuxfoundation.org>
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
@@ -401,10 +401,6 @@
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



