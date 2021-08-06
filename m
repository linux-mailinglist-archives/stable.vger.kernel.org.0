Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9935A3E256A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbhHFITx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244193AbhHFIT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9678B611EF;
        Fri,  6 Aug 2021 08:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237943;
        bh=42+BG0ycbiLTUvyAYa9xiB8SuDPYDhHiL+BYxOjqBXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAoX3Ho2TREl2h13HqLyxExpFC81hf4s9yxLwgFaadKZu0WVgmnaGTGMTIZ78Jj1s
         47IWsmI45BZiyzdw1Vaeg7byPWo+AO6xLu3wzEFCKc5fXOizzMqRaWHKIdwtNDwzJI
         qrrw2D+ItDL3GixQ2kOxECrnn11LaAdbqSTcfOFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChiYuan Huang <cy_huang@richtek.com>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/30] regulator: rtmv20: Fix wrong mask for strobe-polarity-high
Date:   Fri,  6 Aug 2021 10:16:43 +0200
Message-Id: <20210806081113.309253681@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 2b6a761be079f9fa8abf3157b5679a6f38885db4 ]

Fix wrong mask for strobe-polarity-high.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
In-reply-to: <CAFRkauB=0KwrJW19nJTTagdHhBR=V2R8YFWG3R3oVXt=rBRsqw@mail.gmail.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/1624723112-26653-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtmv20-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rtmv20-regulator.c b/drivers/regulator/rtmv20-regulator.c
index 4bca64de0f67..2ee334174e2b 100644
--- a/drivers/regulator/rtmv20-regulator.c
+++ b/drivers/regulator/rtmv20-regulator.c
@@ -37,7 +37,7 @@
 #define RTMV20_WIDTH2_MASK	GENMASK(7, 0)
 #define RTMV20_LBPLVL_MASK	GENMASK(3, 0)
 #define RTMV20_LBPEN_MASK	BIT(7)
-#define RTMV20_STROBEPOL_MASK	BIT(1)
+#define RTMV20_STROBEPOL_MASK	BIT(0)
 #define RTMV20_VSYNPOL_MASK	BIT(1)
 #define RTMV20_FSINEN_MASK	BIT(7)
 #define RTMV20_ESEN_MASK	BIT(6)
-- 
2.30.2



