Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79BF3A84B8
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhFOPvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232100AbhFOPvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 574F46191E;
        Tue, 15 Jun 2021 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772161;
        bh=pd9R6xgegGcJEdj1nhvStM5JUqlgIvuKqAtpektwa5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDSpK8R3AQQ3MVbaFRWx6Z/UQ74U/+cOQmhHkvRGEELArZHLlOx31+Gl3/VhfSYXc
         pNDMp907z/nmvlJ6PGyRGMEnHEmb8Yh4YmZRyljrtmEW60c+wO87vpdQDYVCAiURug
         ml17VD8UWNQNPvgXxPIrLwRp44qoUJVfLUmWuX2/McLO9OxNxTsRTsmw8kbBOXg5k4
         MC/dHa1Ht6GVkp9cdjMNTUBrAAcCVhs24kj5fYRz2TuJzGxa47GRbyF7pCRgAg7SGD
         3pcMHpJhIAfDKaOgHwBm4kkQZfFCxsThNKUeD+lcpHmbmZMbrcvH3xNVAvMftU5iKK
         foEjAfTxWFGRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Gabriel Craciunescu <nix.or.die@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 10/30] ASoC: AMD Renoir - add DMI entry for Lenovo 2020 AMD platforms
Date:   Tue, 15 Jun 2021 11:48:47 -0400
Message-Id: <20210615154908.62388-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit 19a0aa9b04c5ab9a063b6ceaf7211ee7d9a9d24d ]

More laptops identified where the AMD ACP bridge needs to be blocked
or the microphone will not work when connected to HDMI.

Use DMI to block the microphone PCM device for these platforms.

Suggested-by: Gabriel Craciunescu <nix.or.die@gmail.com>
Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20210531145502.6079-1-markpearson@lenovo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/rn-pci-acp3x.c | 35 +++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/sound/soc/amd/renoir/rn-pci-acp3x.c b/sound/soc/amd/renoir/rn-pci-acp3x.c
index 917536def5f2..6de536b02b57 100644
--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -192,6 +192,41 @@ static const struct dmi_system_id rn_acp_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "20NLCTO1WW"),
 		}
 	},
+	{
+		/* Lenovo ThinkPad P14s Gen 1 (20Y1) */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "20Y1"),
+		}
+	},
+	{
+		/* Lenovo ThinkPad T14s Gen1 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "20UH"),
+		}
+	},
+	{
+		/* Lenovo ThinkPad T14s Gen1 Campus */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "20UJ"),
+		}
+	},
+	{
+		/* Lenovo ThinkPad T14 Gen 1*/
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "20UD"),
+		}
+	},
+	{
+		/* Lenovo ThinkPad X13 Gen 1*/
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "20UF"),
+		}
+	},
 	{}
 };
 
-- 
2.30.2

