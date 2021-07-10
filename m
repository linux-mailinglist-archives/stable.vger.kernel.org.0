Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC97B3C2D3A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhGJCWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhGJCVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794DF613C7;
        Sat, 10 Jul 2021 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883539;
        bh=4cmWkVFhdTzQWY9usqWWMyf40gKiTVqMUh3jZzfwEhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQgWdBvLNnhVazkacDLNMobzPiBxk/PL28DAwCpqlTzJ1zYRU33trHXS28jBvE6tS
         NLP/r2Np31JVTzpAg2xH2cyFiPD9O890JmBccVxDDAeRxMsKY2lmSwnz4zHzTV0fk2
         vEhEO4knrm3p36kxxJw9NKTlryP+XZu60Ivawhei5gTyVq465LlQaIn596reekghMY
         /eW8Azp+gQvn3BXHR+Glr2G6zNTpkIeA+0jtBMxocTW1ZX2lf4MySlg4w/fFkJTyFk
         MISEgIV/hjNWWoFAFLRWXz3Uh5EY+x7BYK7EwVBKkFLLELpFfPvDuhsMKn3dR1Md8T
         z3jbu5ENb1z0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 051/114] mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:16:45 -0400
Message-Id: <20210710021748.3167666-51-sashal@kernel.org>
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
index 47556d2d9abe..8ebfc7bbe4e0 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -113,6 +113,7 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 	{"da9053-bc", DA9053_BC},
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, da9052_i2c_id);
 
 #ifdef CONFIG_OF
 static const struct of_device_id dialog_dt_ids[] = {
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 61aa020199f5..cd2f45257dc1 100644
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

