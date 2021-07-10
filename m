Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935DA3C2D47
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhGJCWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhGJCVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B92F613B5;
        Sat, 10 Jul 2021 02:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883545;
        bh=8ZbvH99bcq1nyw8SRd4cTB+F8f4pK/NJxDYhzKamEWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O90eLDm0AQIGmcBx9kH9kMBQDgD57BuI32EHP05oK604KPeuYzxLi7QKM6ARK2NIK
         nLju6iq1KM6FDbIgHepq2HL5NFKT2wo/O03aDrpMsfrxMpGEYuSk4qqYExhKoR+xUy
         kGG9AgHbfOKrtJtN8FLU4t/F14S7gxJnjjeOSLE1ZH9r7cuspWSArsMWFsh+0MLyAg
         BjsX+bSgeim3p5iV7xHEW3q5GEDJxmgX0WSVGYuozaA89NivpeGjbW7lbfKKiMcamW
         D0/MhhB7+r6/wcO5VSvKJX+XGP9N1RifMqve4E8APu49A0zHx0DiBqEBJplqeR3X2S
         OgPguM4vhvNCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        linux-fsi@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 056/114] fsi: Add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:16:50 -0400
Message-Id: <20210710021748.3167666-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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

