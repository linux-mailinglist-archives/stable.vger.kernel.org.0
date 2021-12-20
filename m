Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684FA47AD49
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhLTOvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41060 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhLTOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11F2611A8;
        Mon, 20 Dec 2021 14:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87825C36AE9;
        Mon, 20 Dec 2021 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011725;
        bh=Gl2wCWWkHdITYLhB0TJx10i4mi5FTT6SkicG4VDwGIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peNNh80LwpAm1tych2wyWLajogoH1ZfSjpeIRxvVQ720khk94TdIere8XdLa3cDmP
         tvvw0LWzlFCMN4E/oL2Jt1IpZSeEnN9gNk2O+5IGv3PwGGNoduGzZn7sDcXXllFI9J
         R4YpNWpUExGlIXFvjmj2WME5HdI4Y3qgVyRkMVhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/99] arm64: dts: rockchip: fix rk3308-roc-cc vcc-sd supply
Date:   Mon, 20 Dec 2021 15:33:52 +0100
Message-Id: <20211220143029.999857937@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 772fb46109f635dd75db20c86b7eaf48efa46cef ]

Correct a typo in the vin-supply property.  The input supply is
always-on, so this mistake doesn't affect whether the supply is actually
enabled correctly.

Fixes: 4403e1237be3 ("arm64: dts: rockchip: Add devicetree for board roc-rk3308-cc")
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20211102182908.3409670-2-john@metanate.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index bce6f8b7db436..fbcb9531cc70d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -91,7 +91,7 @@ vcc_sd: vcc-sd {
 		regulator-max-microvolt = <3300000>;
 		regulator-always-on;
 		regulator-boot-on;
-		vim-supply = <&vcc_io>;
+		vin-supply = <&vcc_io>;
 	};
 
 	vdd_core: vdd-core {
-- 
2.33.0



