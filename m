Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC074353E22
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhDEJEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhDEJEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:04:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE30E613A9;
        Mon,  5 Apr 2021 09:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613433;
        bh=q6EcpwSFRh4WOSWaHhP+2Nesd5T1O9X6Zyl9XpqIjl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0weH439Rfxmi1r8Fvz1g5iUM7PwziORzluPXgrLPdgHmTz/sdtZNBgieoiaUrXZwt
         Pr4/V1sQE0LC9E27JeaHnQ2lqe27bEc/gJyD/Jwh4EaFOuCp8zeHYu+oLOg7duYzSs
         ZWDhX5ZLPzyuSNYSPLRw9RwBnkt+1Uu/CjEyoHMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/74] can: tcan4x5x: fix max register value
Date:   Mon,  5 Apr 2021 10:53:58 +0200
Message-Id: <20210405085025.843745175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6e1caaf8ed22eb700cc47ec353816eee33186c1c ]

This patch fixes the max register value for the regmap.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-12-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 32cb479fe6ac..0d66582bd356 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -88,7 +88,7 @@
 
 #define TCAN4X5X_MRAM_START 0x8000
 #define TCAN4X5X_MCAN_OFFSET 0x1000
-#define TCAN4X5X_MAX_REGISTER 0x8fff
+#define TCAN4X5X_MAX_REGISTER 0x8ffc
 
 #define TCAN4X5X_CLEAR_ALL_INT 0xffffffff
 #define TCAN4X5X_SET_ALL_INT 0xffffffff
-- 
2.30.1



