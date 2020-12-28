Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84A72E65AD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbgL1N22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389914AbgL1N22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE55F206ED;
        Mon, 28 Dec 2020 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162067;
        bh=Qq8NqnV69LKjk+6kV2hnaCVNForsPOvue5ilGTePJeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avnG0dQnuS/4aYHSKoD8FBX4T9JVZkwUtoHx41KwrSmqngOfd5Nm2Wa/gmbc8w3KP
         +CCvht6xx1CL8h9qzd4Dae0KsyUtB4GWZt0Orm/GXhTf8czJxfZR76TSOWceuOb5Jz
         kLKEhkidgmNOe9b7JPcVGiVCXxdEBhcbpnBfK6BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/346] arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
Date:   Mon, 28 Dec 2020 13:48:15 +0100
Message-Id: <20201228124928.294636416@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 4076a007bd0f6171434bdb119a0b8797749b0502 ]

The board has a standard USB A female port connected to the USB OTG
controller's data pins. Set dr_mode in the OTG controller node to
indicate this usage, instead of having the implementation guess.

Fixes: 2171f4fdac06 ("arm64: dts: rockchip: add roc-rk3328-cc board")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20201126073336.30794-2-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index 91061d9cf78bc..5b1ece4a68d67 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -255,6 +255,7 @@
 };
 
 &usb20_otg {
+	dr_mode = "host";
 	status = "okay";
 };
 
-- 
2.27.0



