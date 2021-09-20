Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C304411D26
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbhITRQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347709AbhITROe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6270C6121E;
        Mon, 20 Sep 2021 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157100;
        bh=Ci8KDVpMEADlOHkWurzHkcZelu3nh3AyxqYz6cz8V/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igABBwS50xhzj5Xp408Ii05tAmpcWaVydUBq+h2V+zCxbsx84Dxu1QrV4eiq3nFD2
         3LYN5zb0CLHOmpO3o0nbLTSTofwHgUaHyaZy9NU5XNGZ29+LP5Ff9z7sKhk8K6yKGY
         y4/RadqyB4IevxPifPSf1IVH3KNnQhcGLv45etaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/217] power: supply: max17042_battery: fix typo in MAx17042_TOFF
Date:   Mon, 20 Sep 2021 18:40:57 +0200
Message-Id: <20210920163925.852107955@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit ed0d0a0506025f06061325cedae1bbebd081620a ]

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 2 +-
 include/linux/power/max17042_battery.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 911d42366ef1..e824ab19318a 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -717,7 +717,7 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 	struct max17042_config_data *config = chip->pdata->config_data;
 
 	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_TOFF, config->toff);
 	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
 	max17042_override_por(map, MAX17042_COFF, config->coff);
 
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index a7ed29baf44a..86e5ad8aeee4 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -82,7 +82,7 @@ enum max17042_register {
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
+	MAX17042_TOFF		= 0x2D,
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
-- 
2.30.2



