Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A5D3BB30D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhGDXRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhGDXOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E437B61954;
        Sun,  4 Jul 2021 23:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440253;
        bh=+J6ow8Q1wEWMZN6vZWYnPmbsRapmBlShLSR5g5qhNXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUNmZoDwgBbCDwz7SoeBMqJTCg49pyzSYWJcZ8E2a+niAixCec10QnfzPePvcP/11
         YxaSvTm34hVqbFwKrmQfORIqjQ0R6oiJ/5+bNtxYqc9CGvXxxso3w4oaKeK9O9CEqS
         d52oXdgfVY3Q+v2/8GGU06QA8fKyJx/w7VoNRqL2QIKz4sF42p4sr8uou56P/kaYJ2
         pVUcaM4AqnQNRQFviMqfeh3budsFSo8j632ESLNnGO0TNrZj0s1dwlUyTknO/a6FAB
         mO/4/py0hdzmHzPnI5bDpElB7StHS2nl2UQcm6vk2NXxngcZrnq9zE+gCQob/Q04YT
         L+zE08h9VCXwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 08/31] regulator: uniphier: Add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:10:20 -0400
Message-Id: <20210704231043.1491209-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index abf22acbd13e..a2e3654b6332 100644
--- a/drivers/regulator/uniphier-regulator.c
+++ b/drivers/regulator/uniphier-regulator.c
@@ -197,6 +197,7 @@ static const struct of_device_id uniphier_regulator_match[] = {
 	},
 	{ /* Sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, uniphier_regulator_match);
 
 static struct platform_driver uniphier_regulator_driver = {
 	.probe = uniphier_regulator_probe,
-- 
2.30.2

