Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739DE3C2E2C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhGJC0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233345AbhGJCZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C90461412;
        Sat, 10 Jul 2021 02:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883784;
        bh=8ZbvH99bcq1nyw8SRd4cTB+F8f4pK/NJxDYhzKamEWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbPT65sKYfFsGEMqVwavgBIIpPad98j1YBBciidu0Dc5wBsmSqZJik8VhhLcsFJWl
         TpCM2YFw6KkpneoR+8jgTzQy2X0AYxd2Lu8fRlFXeXnY12Eh6l79bIfTe2f3spnWsf
         qcl6iRNuwnuulNwDpJT3197PJ9ROim97+uncqza3RQ8/x0fpfENagpT0Z92x6bQU41
         nHRkdXxIZW0C5rUaE2kLdEmExVHZ7HOhtNo91ebOKG1ajWO3b80LJKIhXvRxWKdepd
         k72YxZmSfBCPgkw9wz2aG1prxvdwYjBmxqfWqQ5Mhp4B5gDaL9OUSL6ZvoEMMV1qvG
         KJiR7D/7l6w7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        linux-fsi@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 051/104] fsi: Add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:21:03 -0400
Message-Id: <20210710022156.3168825-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 19a52178125c1e8b84444d85f2ce34c0964b4a91 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620896249-52769-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-aspeed.c | 1 +
 drivers/fsi/fsi-master-ast-cf.c | 1 +
 drivers/fsi/fsi-master-gpio.c   | 1 +
 drivers/fsi/fsi-occ.c           | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/fsi/fsi-master-aspeed.c b/drivers/fsi/fsi-master-aspeed.c
index 90dbe58ca1ed..dbad73162c83 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -645,6 +645,7 @@ static const struct of_device_id fsi_master_aspeed_match[] = {
 	{ .compatible = "aspeed,ast2600-fsi-master" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, fsi_master_aspeed_match);
 
 static struct platform_driver fsi_master_aspeed_driver = {
 	.driver = {
diff --git a/drivers/fsi/fsi-master-ast-cf.c b/drivers/fsi/fsi-master-ast-cf.c
index 57a779a89b07..70c03e304d6c 100644
--- a/drivers/fsi/fsi-master-ast-cf.c
+++ b/drivers/fsi/fsi-master-ast-cf.c
@@ -1427,6 +1427,7 @@ static const struct of_device_id fsi_master_acf_match[] = {
 	{ .compatible = "aspeed,ast2500-cf-fsi-master" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, fsi_master_acf_match);
 
 static struct platform_driver fsi_master_acf = {
 	.driver = {
diff --git a/drivers/fsi/fsi-master-gpio.c b/drivers/fsi/fsi-master-gpio.c
index aa97c4a250cb..7d5f29b4b595 100644
--- a/drivers/fsi/fsi-master-gpio.c
+++ b/drivers/fsi/fsi-master-gpio.c
@@ -882,6 +882,7 @@ static const struct of_device_id fsi_master_gpio_match[] = {
 	{ .compatible = "fsi-master-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, fsi_master_gpio_match);
 
 static struct platform_driver fsi_master_gpio_driver = {
 	.driver = {
diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index 10ca2e290655..f9a88083e5f3 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -635,6 +635,7 @@ static const struct of_device_id occ_match[] = {
 	},
 	{ },
 };
+MODULE_DEVICE_TABLE(of, occ_match);
 
 static struct platform_driver occ_driver = {
 	.driver = {
-- 
2.30.2

