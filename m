Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6138F29B8DA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802048AbgJ0Pp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799524AbgJ0Pbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34BF722284;
        Tue, 27 Oct 2020 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812714;
        bh=MSR8+hBBmwzzLfkA+yXP4tLBqp//Lam2NCpEv1oPmWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0EF7kKkbh2YfZJ49S6NoHSVOIPGozyAm62JREkKrcUsWvUEJD7vCEQkRcLkNCO/s
         jaQ6OLqhIaPZ5Jcb8GeuFp/LbKU+jLbnjb4sCmpwBPWb6nS/pBMmYu52LEaocY89wE
         OCPBgMCM5l194ZD2ufHA/SaTgyQBSZUnnoo32lDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 304/757] phy: rockchip-dphy-rx0: Include linux/delay.h
Date:   Tue, 27 Oct 2020 14:49:14 +0100
Message-Id: <20201027135504.819412932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Figa <tfiga@chromium.org>

[ Upstream commit 488e3f52a82775bf9a4826a9eb59f10336c3f012 ]

Fix an implicit declaration of usleep_range():

drivers/phy/rockchip/phy-rockchip-dphy-rx0.c: In function 'rk_dphy_enable':
drivers/phy/rockchip/phy-rockchip-dphy-rx0.c:203:2: error: implicit declaration of function 'usleep_range' [-Werror=implicit-function-declaration]

Fixes: 32abcc4491c62 ("media: staging: phy-rockchip-dphy-rx0: add Rockchip MIPI Synopsys DPHY RX0 driver")
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20200921225618.52529-1-tfiga@chromium.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c b/drivers/staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c
index 7c4df6d48c43d..4df9476ef2a9b 100644
--- a/drivers/staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c
+++ b/drivers/staging/media/phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
-- 
2.25.1



