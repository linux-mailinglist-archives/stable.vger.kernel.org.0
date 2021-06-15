Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664A73A8478
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhFOPvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231861AbhFOPuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CCD86142E;
        Tue, 15 Jun 2021 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772122;
        bh=r6aVGaHXr6OT7yCuvc3B2Gy4u2zDuO7MZmKBYuzwQg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6GKW8ZfBOQHkE8QMtQLsW+4mSZ3rFoJfjNUexXN2AZ3V5RyXU3mWscA+ZbOKuMvE
         0p5WxWZ/nwHWOyCca+oSupr5K3H9GUqEFFZZhdczj1qE6UNMhfy++hXSOWPxwGng9y
         mN735w7yGQ0JHebNm1kvZVAO+VOsLvRZQkAeTpDn7vkusvras5bGEbGhc47ZgQgQ8E
         d5H9td7A/d9yZgC8nf8/TxHqq03APzzrjvlhQyobqbaM8jmN1SjqznqY+sQE+A9V8k
         4EvpT4o+sge0BZe/n+ZuO2RCNxQos9n7rgCoG+w7kAhq2PVQ+3DZMIh0xTSpxcSRaa
         yrdpQLDTsI7MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Gabriel Craciunescu <unix.or.die@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 14/33] ASoC: AMD Renoir: Remove fix for DMI entry on Lenovo 2020 platforms
Date:   Tue, 15 Jun 2021 11:48:05 -0400
Message-Id: <20210615154824.62044-14-sashal@kernel.org>
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

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit 320232caf1d8febea17312dab4b2dfe02e033520 ]

Unfortunately the previous patch to fix issues using the AMD ACP bridge
has the side effect of breaking the dmic in other cases and needs to be
reverted.

Removing the changes while we revisit the fix and find something better.
Apologies for the churn.

Suggested-by: Gabriel Craciunescu <unix.or.die@gmail.com>
Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20210602171251.3243-1-markpearson@lenovo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/rn-pci-acp3x.c | 35 -----------------------------
 1 file changed, 35 deletions(-)

diff --git a/sound/soc/amd/renoir/rn-pci-acp3x.c b/sound/soc/amd/renoir/rn-pci-acp3x.c
index 47a4dfd81a46..050a61fe9693 100644
--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -199,41 +199,6 @@ static const struct dmi_system_id rn_acp_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "20NLCTO1WW"),
 		}
 	},
-	{
-		/* Lenovo ThinkPad P14s Gen 1 (20Y1) */
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_BOARD_NAME, "20Y1"),
-		}
-	},
-	{
-		/* Lenovo ThinkPad T14s Gen1 */
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_BOARD_NAME, "20UH"),
-		}
-	},
-	{
-		/* Lenovo ThinkPad T14s Gen1 Campus */
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_BOARD_NAME, "20UJ"),
-		}
-	},
-	{
-		/* Lenovo ThinkPad T14 Gen 1*/
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_BOARD_NAME, "20UD"),
-		}
-	},
-	{
-		/* Lenovo ThinkPad X13 Gen 1*/
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_BOARD_NAME, "20UF"),
-		}
-	},
 	{}
 };
 
-- 
2.30.2

