Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB33A846A
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhFOPur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhFOPuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B9E6162A;
        Tue, 15 Jun 2021 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772114;
        bh=adBEG7zv+ENyu9SHmLOWViXi62cNurLlJQCxTzrZxb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5sZ89flkwNesEg/LjcUMguT0YpbTKcE93cvdvDmFHwO5vb+ZvWSmgtT5K4xa5WX/
         dC1iCTAM+S4kaYl95WdNrlegxuZfS8F8SBQwcEsxG94qncLvgsTueaW9OFe5BzlakM
         OCGYfUuHBDeL4MQVzNcySOo+C8kj9JAzoAE+1IieIPRpjWhaft2mgLg3jlyr3lePGD
         OfdXIgoZlcccJt0EhBe2/Z05MOexMy4UcsaMwrRMyVBATjcJhIxyRO+BxUXjkIfwPr
         Pg3QG/IPrxs/UpxvCmaJJaa69kciljSTmiJk+zFG8ep/Dui9GzadU0bznT2fQUUxLR
         0oP6xvRZTf30Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 08/33] regulator: mt6315: Fix function prototype for mt6315_map_mode
Date:   Tue, 15 Jun 2021 11:47:59 -0400
Message-Id: <20210615154824.62044-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 89082179ec5028bcd58c87171e08ada035689542 ]

The .of_map_mode should has below function prototype:
	unsigned int (*of_map_mode)(unsigned int mode);

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210530022109.425054-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6315-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mt6315-regulator.c b/drivers/regulator/mt6315-regulator.c
index 9edc34981ee0..6b8be52c3772 100644
--- a/drivers/regulator/mt6315-regulator.c
+++ b/drivers/regulator/mt6315-regulator.c
@@ -59,7 +59,7 @@ static const struct linear_range mt_volt_range1[] = {
 	REGULATOR_LINEAR_RANGE(0, 0, 0xbf, 6250),
 };
 
-static unsigned int mt6315_map_mode(u32 mode)
+static unsigned int mt6315_map_mode(unsigned int mode)
 {
 	switch (mode) {
 	case MT6315_BUCK_MODE_AUTO:
-- 
2.30.2

