Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B33BB1C7
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhGDXNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGDXMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFEFA613D2;
        Sun,  4 Jul 2021 23:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440107;
        bh=L84IKwINJa6zxkGcFITCnz9nOjuWJ1IN5joGhHT235s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ15Koz4Vu0PSqlWgvIi1UL2qdhVWm7rEzb2fsF2UsF4tn5nbcxOLbSK513Y4v2IM
         LCQPkfg5oL9iV0TMQx+EpwGoNokYxFXQLtJpaBgsNRwnyCzlmVJFJigxQp27st+0bL
         W0RkxfZU4t8p6IWvjV2BnCLgxpaqfjIs0qRHVjfvVM+K8rHoY31VE3KzO4lNwetj9J
         ZGVj1oyQGQc1/GZyqFlw+DsK+OAauUFlAi2qjKgKIUS6yTfnG7X+eiIuOnZFX64Q2/
         Qp2Vb/2+KKF8QJYtv3vJJ3u4dQhO6ZtOa5vlIp4+HrgyqzOiXkfQc176jOwW6fj86I
         dtoQ6Wsqalcnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 18/70] regulator: uniphier: Add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:07:11 -0400
Message-Id: <20210704230804.1490078-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit d019f38a1af3c6015cde6a47951a3ec43beeed80 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620705198-104566-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/uniphier-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/uniphier-regulator.c b/drivers/regulator/uniphier-regulator.c
index 2e02e26b516c..e75b0973e325 100644
--- a/drivers/regulator/uniphier-regulator.c
+++ b/drivers/regulator/uniphier-regulator.c
@@ -201,6 +201,7 @@ static const struct of_device_id uniphier_regulator_match[] = {
 	},
 	{ /* Sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, uniphier_regulator_match);
 
 static struct platform_driver uniphier_regulator_driver = {
 	.probe = uniphier_regulator_probe,
-- 
2.30.2

