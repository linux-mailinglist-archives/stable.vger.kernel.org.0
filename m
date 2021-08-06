Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27EA3E259B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244330AbhHFIVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244099AbhHFIUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC5C861216;
        Fri,  6 Aug 2021 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238001;
        bh=42+BG0ycbiLTUvyAYa9xiB8SuDPYDhHiL+BYxOjqBXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTUdAW99AbUeaOTqaTHg/OcPPzMGZNHEy4BFYoIRakpsyclhD0pyiNznzZVixz6XO
         h1/4cft1Haq9fN6thBCgueDvg7VcXBjTO6iVSZgPR8DeX/OIU+MWLwAlabFVqeKR/b
         zlOTSFVYtscgf4ub21168fBN2dVAe/Wr16y/bBZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChiYuan Huang <cy_huang@richtek.com>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 14/35] regulator: rtmv20: Fix wrong mask for strobe-polarity-high
Date:   Fri,  6 Aug 2021 10:16:57 +0200
Message-Id: <20210806081114.184129482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
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



