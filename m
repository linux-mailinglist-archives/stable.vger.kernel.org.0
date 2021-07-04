Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74173BB2F3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhGDXQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhGDXO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4831661966;
        Sun,  4 Jul 2021 23:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440194;
        bh=JJ1V97vq16aNg1y9OaEdVi3sKSD3+ZhWA7kaZn4/U6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZ8hX+YWxVzeU5kooXrR3n6VVU5YB7uwMZj88yjC8PPv6rCdSv2OhzpmuUXjlm6ar
         xESxQqFk8zNODiED1JnK2IWV2kJFMDhx9/1fYemJdi3KHKxW/zFmNiKq8yKj62iGo0
         6Hsz+j8nAyyk/2ik6h5wDdL3OjeN18xbe/IsjwonITdL+8ZFwEKJZNoe3O7yixxbEB
         Oms9qTE+pg69ehuzNdHiipXvQBoa/ognaYqzgIdArd0hh6+cRH+PSh+KLezoNT3X8r
         GvzWS4NHDAwIxRd2ob0Oq1dq/sFVXVZd0fBKY3yPCXcNke7dQjlaI+xFVZ2Q6DEf5S
         rJbXb4VH0V6Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 12/50] regulator: uniphier: Add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:09:00 -0400
Message-Id: <20210704230938.1490742-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index 2311924c3103..2904c7bb4767 100644
--- a/drivers/regulator/uniphier-regulator.c
+++ b/drivers/regulator/uniphier-regulator.c
@@ -203,6 +203,7 @@ static const struct of_device_id uniphier_regulator_match[] = {
 	},
 	{ /* Sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, uniphier_regulator_match);
 
 static struct platform_driver uniphier_regulator_driver = {
 	.probe = uniphier_regulator_probe,
-- 
2.30.2

