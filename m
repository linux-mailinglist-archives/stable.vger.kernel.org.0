Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7420F5EA45B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiIZLpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiIZLo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE1B564FC;
        Mon, 26 Sep 2022 03:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 940E5B80978;
        Mon, 26 Sep 2022 10:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1772C433D6;
        Mon, 26 Sep 2022 10:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189125;
        bh=qG/GrAL/KC/X3xbqMlKzeMjHeQKBh4vzIdmV29LdBNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9Yy9VWLRXeqkC06eYQGJItjYMEMRUGJvjIli3PPmVmxEI1tiVoLM6lEEjHP0bTKb
         /A0v/HGp/p9qyom3F/JTXmF/3A5lZA/SFiuRFRHb506KCGBIsjyssXup6SPw9Tet73
         oV5NcvPbNb8PnVdtif+2fkVWpO8O95kYMs1mSyPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 082/207] arm64: dts: rockchip: fix property for usb2 phy supply on rock-3a
Date:   Mon, 26 Sep 2022 12:11:11 +0200
Message-Id: <20220926100810.246666091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Riesch <michael.riesch@wolfvision.net>

[ Upstream commit 43e1d6d3b45c4e7e25171ec04a10d09969b0f889 ]

The property "vbus-supply" was copied from the vendor kernel but is not
available in mainstream. Use correct property "phy-supply".

Fixes: 254a1f6a29e7 ("arm64: dts: rockchip: add usb3 support to the radxa rock3 model a")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20220905064335.104650-1-michael.riesch@wolfvision.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 0813c0c5abde..26912f02684c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -543,7 +543,7 @@ &usb2phy0_host {
 };
 
 &usb2phy0_otg {
-	vbus-supply = <&vcc5v0_usb_otg>;
+	phy-supply = <&vcc5v0_usb_otg>;
 	status = "okay";
 };
 
-- 
2.35.1



