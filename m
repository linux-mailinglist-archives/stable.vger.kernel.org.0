Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31E93C2EA1
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhGJC1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232146AbhGJC1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2681861418;
        Sat, 10 Jul 2021 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883855;
        bh=jMFI/X6JpYIAKQaFGTECmFNli5C5t3TD6BOf/RpICe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oog9YDaIGHA2H4+E/1/Un6h9JyVg3dW+EhXrJ/eDHRLAXIiZtKmPcw4LPjZec9fvY
         iTLpE247nywyCeZOb1++nPiq76vogSIztlwJJRJLwI4mNuf8NynYXHnsUXpXJ8UPMG
         lZHpRzzUodOe05emyZu4QNcWyYsAcyI/18SQVXcAsXtFmyk6j+UxdaLC9q2fzghCKR
         99HHFblXnX3zLCE9tr9TDuq15PSyHrysu9gNR6ZbkOG9/0cXf71gBl311DTcU3HfRn
         cC4hGNBmEDrGXwhA1oVe5hLUkvC94uJhDz6RWDKAUratq41hEjmLLS8HDWr8xNuhgw
         InbUoFLFWINzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 098/104] leds: turris-omnia: add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:21:50 -0400
Message-Id: <20210710022156.3168825-98-sashal@kernel.org>
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

[ Upstream commit 9d0150db97583cfbb6b44cbe02241a1a48f90210 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 2f9a289ab245..1adfed1c0619 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -274,6 +274,7 @@ static const struct i2c_device_id omnia_id[] = {
 	{ "omnia", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, omnia_id);
 
 static struct i2c_driver omnia_leds_driver = {
 	.probe		= omnia_leds_probe,
-- 
2.30.2

