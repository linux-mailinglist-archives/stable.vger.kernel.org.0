Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1043CDE7B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbhGSPDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343871AbhGSPBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5F36124B;
        Mon, 19 Jul 2021 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709323;
        bh=hW8Q2O61AkaJlvZF1qqBNpySKBd2DXLScMrgUKomg9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvplLLdAAG/oW9h3GqoS2eHD2cZesrwBC+vZoQg6Z+WAUyMvjfPvY6Y12X5cRDeuN
         Wfv+WrBBFV0rXB80+oD7A+TFyPYKNjMXTAsvkDHq5RWn/w9RWc6ChEWthlYjjjmNUE
         Gf4s1Tw2BOMT2iPMis83co/NR6efpnU94C8onUEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 338/421] mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:29 +0200
Message-Id: <20210719144958.011316239@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



