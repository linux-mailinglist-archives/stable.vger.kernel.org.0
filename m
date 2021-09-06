Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018C9401479
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240055AbhIFBdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351786AbhIFBbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19824610CC;
        Mon,  6 Sep 2021 01:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891464;
        bh=nup1VEPDadJYUtHHiAk5JlOcP7Bm6E25hV0DQVm78U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H098EKp5wudgM13d/oTAMru6g63WHkFmuUOp46KkXASobTqzxbBk2YSgfww+antin
         gfCBJT9xdoyQcLJB6zNgfcjwKcxqUHxz7Dt2zfKfmsldFbuOGuliLsEv9QSu1v4H0a
         05jErg6ch22+9jI8SdhVYPVVn7lEBZQrU3M0ukuPBUko5O3gKUitSshg+VWtkKme4a
         NdGhps/LAsizo6lzCnBVOjBbtEudY0LsFCEmbQ9Ps16ETqCxFPZOODUdH77GrqVWcl
         dGz+C1AoCDEhT/PyI6co45uBMPm7dkihO1O3U0daLxpj5GWRpAjx3rsPoz+WEFPbSL
         X6lU1ZQgDVXXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/14] power: supply: max17042_battery: fix typo in MAx17042_TOFF
Date:   Sun,  5 Sep 2021 21:24:08 -0400
Message-Id: <20210906012415.931147-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012415.931147-1-sashal@kernel.org>
References: <20210906012415.931147-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index da7a75f82489..249b0758dae6 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -644,7 +644,7 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 	struct max17042_config_data *config = chip->pdata->config_data;
 
 	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_TOFF, config->toff);
 	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
 	max17042_override_por(map, MAX17042_COFF, config->coff);
 
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index 522757ac9cd4..890f53881fad 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -75,7 +75,7 @@ enum max17042_register {
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
+	MAX17042_TOFF		= 0x2D,
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
-- 
2.30.2

