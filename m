Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ED447ACE4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhLTOrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbhLTOpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAAFC0698C7;
        Mon, 20 Dec 2021 06:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DD91611A1;
        Mon, 20 Dec 2021 14:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6067CC36AE7;
        Mon, 20 Dec 2021 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011411;
        bh=nXnozlLQWBPc89whmIEadufYY566wXSmHYwUhWsIpV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3ggzZe9kZ7Ij6bHwB3eMrcMolzSD83xV7iPdcjl+uR9BuEmTcWh+C+FP3vpOLElu
         RNtS7qy9kA7ZSF3hsdFsEWOqepfFgXMUwnbp7Q+dK2wNfsQeAkFueVKir9SseBnY4j
         Nvcw6tMoM0mHCr6xpzFhVHCqcUF1Q3+MrqP91+/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/71] arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply
Date:   Mon, 20 Dec 2021 15:34:01 +0100
Message-Id: <20211220143026.110271178@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 2b454a90e2ccdd6e03f88f930036da4df577be76 ]

Correct a typo in the vin-supply property.  The input supply is
always-on, so this mistake doesn't affect whether the supply is actually
enabled correctly.

Fixes: fc702ed49a86 ("arm64: dts: rockchip: Add dts for Leez RK3399 P710 SBC")
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20211102182908.3409670-3-john@metanate.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts b/arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts
index 73be38a537960..a72e77c261ef3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts
@@ -49,7 +49,7 @@ vcc3v3_lan: vcc3v3-lan {
 		regulator-boot-on;
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
-		vim-supply = <&vcc3v3_sys>;
+		vin-supply = <&vcc3v3_sys>;
 	};
 
 	vcc3v3_sys: vcc3v3-sys {
-- 
2.33.0



