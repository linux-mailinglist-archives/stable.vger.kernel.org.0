Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFE33C37CA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhGJXxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232775AbhGJXwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4703E61356;
        Sat, 10 Jul 2021 23:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960995;
        bh=svTgcOKOptpczp/inFy4NH/j4eGSbCUjzJZ0vIcHdqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTsd2yRWkX96st0dcsO2bqaNRxnhguXPStqHKg4YUqfdzHSuoCyBzFZYfgJvctgFO
         7hkQ/miQCm/JiDTRDwNLl1avyuCXz2brRfrXQVx3CzvtkglmTaEn3IhRzN+iYPTMgu
         8DNepNhUrCZi0QbIBIPsly//RXuBFioyN4Z5wtrCtlF3gdT/aPYwYwQFqrq02eGjkm
         T9m7B0uGd7dsBRLEEuZLjYnlOVOpEVAkFn7PhySxytQ1M4bfXfU8lpjxmK7/a5+/y+
         SHWmUih4xQeCVwXPcMOSyvS901wwSO3zdK1/qvchX/h9mCIbXX0KoawjdU2P9ictS+
         9WKNLcR8igVsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 27/43] power: reset: regulator-poweroff: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:48:59 -0400
Message-Id: <20210710234915.3220342-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 4465b3a621e761d82d1a92e3fda88c5d33c804b8 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/regulator-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/regulator-poweroff.c b/drivers/power/reset/regulator-poweroff.c
index f697088e0ad1..20701203935f 100644
--- a/drivers/power/reset/regulator-poweroff.c
+++ b/drivers/power/reset/regulator-poweroff.c
@@ -64,6 +64,7 @@ static const struct of_device_id of_regulator_poweroff_match[] = {
 	{ .compatible = "regulator-poweroff", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_regulator_poweroff_match);
 
 static struct platform_driver regulator_poweroff_driver = {
 	.probe = regulator_poweroff_probe,
-- 
2.30.2

