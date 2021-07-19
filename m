Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AD83CE36D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbhGSPh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348268AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C15E61625;
        Mon, 19 Jul 2021 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711220;
        bh=ZGTCVaMWRWgDhzNB2GUFnf+Pg1+nHhjQr+lTpUYSymI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbpJvlHyEWH5shlKXg1Qy6Ah0hQ1GmPT11MW5tSxF2f276rxm5FywjTsjNuZ259wF
         lTL90FAJLJ+TC9cpZVF6mSytRG7XDrJcxJ/4A8cr9OMlEdaRzBPmdkMocv7Du1mLBI
         eQd1FgS835QdHS5XogUZl3p/5zMKfF0VtS/hKBvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Tianling Shen <cnsztl@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 271/351] arm64: dts: rockchip: rename LED label for NanoPi R4S
Date:   Mon, 19 Jul 2021 16:53:37 +0200
Message-Id: <20210719144953.903548504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianling Shen <cnsztl@gmail.com>

[ Upstream commit 6a11ffc2cc54d89719d5b2f3ca44244cebd7ed2e ]

However "sys" is not a valid function, and it is always on.
Let's keep existing functions.

Fixes: db792e9adbf85f ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")

Suggested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tianling Shen <cnsztl@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Link: https://lore.kernel.org/r/20210426114652.29542-1-cnsztl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
index fa5809887643..cef4d18b599d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -33,7 +33,7 @@
 
 		sys_led: led-sys {
 			gpios = <&gpio0 RK_PB5 GPIO_ACTIVE_HIGH>;
-			label = "red:sys";
+			label = "red:power";
 			default-state = "on";
 		};
 
-- 
2.30.2



