Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B293CD8CC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbhGSOZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242984AbhGSOXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4275B61073;
        Mon, 19 Jul 2021 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707005;
        bh=4rn0DvzLIFcOqynHc6wHvqocZvVdk8ucUZb092b96/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8NfQ9Zkz8QO+K0olWstGi3ZfTr6KGRblcxjvYe3LOwVMf7e51Bqc84zCZ4XLttyR
         DrIlbvWsONX95P1v0+haAO/cPvlS1hoL4qJ3Tt0mWFOlVNlyHhIVUSBkKwDQq0rFF3
         AMuxvkEYdwf3KueIc1/nfe4cxJfZjjuLu2fliBr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 150/188] mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:14 +0200
Message-Id: <20210719144941.397089945@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 2697ffb08009..2992fd94bc0c 100644
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
index c3f4aab53b07..663a6c1c3d0d 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -107,7 +107,7 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, stmpe_id);
+MODULE_DEVICE_TABLE(i2c, stmpe_i2c_id);
 
 static struct i2c_driver stmpe_i2c_driver = {
 	.driver = {
-- 
2.30.2



