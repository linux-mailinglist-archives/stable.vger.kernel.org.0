Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD53C38D8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhGJX40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhGJXz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A2961409;
        Sat, 10 Jul 2021 23:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961109;
        bh=i2xcg7LDNc4FohGMAy1rqLeDVKbCzPkt+EzbS/bbETo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDbyROVZSiSJNcZm/uxIUG5XZfE8Q4WLz0BVfZGsIsM5jE8NUCriCd8Asn489Rwi7
         fBokMXDrnYchpotO2T8FAGCiAx3+zDPJg6JdGEYlf3d7UtaI7Tm1lZA3BsxNa4AOvC
         Kw0sVcpgF89N9gwETAlB1xiHtUvgKOUydcmE3eNKEbr1jynL55h259S9/iE6p9Aedg
         WZx+ZL1Ex5mwc9MKQKEvo4PR3gQYcv5oArrxdeWMdQSiJacBP3SVmq3YjWxYzfO5n7
         4lSwwgQwAFpY4p2zBU8RAkSkQLrcRrygUXNaLCvpwnz9ma0aofCUHtWeYDmQ+0NULv
         vLdslySqnZ03Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/22] power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:51:25 -0400
Message-Id: <20210710235143.3222129-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit ed3443fb4df4e140a22f65144546c8a8e1e27f4e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/gpio-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
index 38206c39b3bf..5f2fa9c0f526 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -88,6 +88,7 @@ static const struct of_device_id of_gpio_poweroff_match[] = {
 	{ .compatible = "gpio-poweroff", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_gpio_poweroff_match);
 
 static struct platform_driver gpio_poweroff_driver = {
 	.probe = gpio_poweroff_probe,
-- 
2.30.2

