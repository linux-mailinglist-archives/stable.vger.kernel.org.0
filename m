Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F243C2F7F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhGJCbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234676AbhGJC3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C05613DC;
        Sat, 10 Jul 2021 02:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884016;
        bh=JgL551oFfxdmH9y/atJVWQ9IvGlZp0b9DjZZSGo8qz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4c+qDCRau+izxok/F4tByOieO1ygOvosv/W+gHFboDqqzzsyNRMwJXIh/cnHcupc
         ckm7Q0jprlogd1BX+8eOkIIaV+ew6ElboWKofAkCEoYxxPh+fgK/AikXNSF+t/UVhm
         VbYz/mU90IRrgGG7eyGM7eJm5YXnxV0XCNElbi3wWgawg9jsyY9xiJjImXkGQXePuo
         vCFxepZE+r+x/3oO37Ep9iQaRoHE70NY+VqqD8XZZiF7v1D9MepC27SlNOgczum7ek
         Yt1Lxlr/LNcsPH21jKYaCPOEs9TPM3fN4vtKvZxMO8Am28gduo6/Gw3fvergL7o1yM
         vb0YviROqD4kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 87/93] leds: turris-omnia: add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:24:21 -0400
Message-Id: <20210710022428.3169839-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index 880fc8def530..ec87a958f151 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -277,6 +277,7 @@ static const struct i2c_device_id omnia_id[] = {
 	{ "omnia", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, omnia_id);
 
 static struct i2c_driver omnia_leds_driver = {
 	.probe		= omnia_leds_probe,
-- 
2.30.2

