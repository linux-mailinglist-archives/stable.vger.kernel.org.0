Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA793C30B4
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhGJCga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233612AbhGJCfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BEE61412;
        Sat, 10 Jul 2021 02:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884346;
        bh=hW8Q2O61AkaJlvZF1qqBNpySKBd2DXLScMrgUKomg9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n18PzvavgoBnjQJ8bfaNOjmkCchzqgUu3BQA4IhFSgDCiKNWFuBVmySMBohYnb9AX
         Zdt7agR5GwcJDJmQGJj/l6PRXsr1gH2FzeXlfcSgQI+9OTN9WagHcdYOONxIlGavI9
         T1IPsBre7LgYc0f8Rea52P624ozW9Bb7N+6XzYbgSMPg8vy2RG1ju2BB+wZEHSRl8k
         n0nu9rB4L3V27c6x42kDMHjVx706TSTLhkq6P+YXhV6B6uP5azienqRyh0uKbqzJRy
         9WEHVN7V7LbgiP4R/BRHuq+SQvzRJJRn5g8GPORz2XCqCyYdm7YyVsrVpTaxhpN2XO
         l5zrmJkq6zWwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 17/39] mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:31:42 -0400
Message-Id: <20210710023204.3171428-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 4700ef326556ed74aba188f12396740a8c1c21dd ]

This patch adds/modifies MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-i2c.c | 1 +
 drivers/mfd/stmpe-i2c.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 578e881067a5..4094f97ec7dc 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -118,6 +118,7 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 	{"da9053-bc", DA9053_BC},
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, da9052_i2c_id);
 
 #ifdef CONFIG_OF
 static const struct of_device_id dialog_dt_ids[] = {
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 863c39a3353c..d284df25c76b 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -109,7 +109,7 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, stmpe_id);
+MODULE_DEVICE_TABLE(i2c, stmpe_i2c_id);
 
 static struct i2c_driver stmpe_i2c_driver = {
 	.driver = {
-- 
2.30.2

