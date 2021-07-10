Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032073C31DF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhGJCpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235356AbhGJCnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DC8613F3;
        Sat, 10 Jul 2021 02:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884762;
        bh=4rn0DvzLIFcOqynHc6wHvqocZvVdk8ucUZb092b96/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPDnnm/fq9sUoFIAfiRUbn8rCKnY31tVFSGWZ5fSeWE6Vk3tttOLDp97syoV3M3c2
         OTHPLvJbDcbpc8N+V2hwsdrzBolW4InpMXemFYxX9fh57zG/8TG9V3WTKDd4hlSJQ+
         4T/OibkoAoZfGMGLhD2UawUK70mmKCQPNEuRAjC6S/yomwPdjXjk3gXnd+EkVC9HZO
         mGdWL11VToAUSMlnjjZvsovJfpCxIZGKGYYxKuwYSY8HQDk1c+b1SGaansstSbHBjf
         GR3cdygTcNTyXfBW4lq8l3KwhzWJ2rS0JYUSMZDSb+o1JRNc4/YvHTiss3NW1t540r
         zUWNpo02+s7Jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 08/23] mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:38:57 -0400
Message-Id: <20210710023912.3172972-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023912.3172972-1-sashal@kernel.org>
References: <20210710023912.3172972-1-sashal@kernel.org>
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

