Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0A3C398B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGKAA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhGJX6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 321B76142D;
        Sat, 10 Jul 2021 23:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961186;
        bh=vGFioSWvtRgICLzoYPoDXxpPQu2d3N5bConmOJySD3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htN2q+ETW4NojaNIq1URjQzQfw/QofVbmxLN4Gyt7XNRKHVGWoafQUbGEvCRfQW/d
         ctE+Vs04QaJojaMUSft5KZIYGoAawwF14vXh54gCF5CQz6ZThtvZKtUhL3sMgCxwpT
         +eEpAqsCXWfAOFO6Hhgq5pHFsNjnMSvmEGGKj1BkvSNYW0xSKEBns/Dng/zB0CXa0a
         W7tLKx139HVhxSKA+gGn6u33tcoFpMjsLQtA+xeCITELYUuYfWRfSaWRouVS1kch7p
         14y2JejWS8/Vd7hBmT3V1kXBUw80Z6mmtsrjGvS2riLQ6kSkIVDlBs196ZIEBz7A02
         aDkAnv4U82fvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/12] power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:52:53 -0400
Message-Id: <20210710235302.3222809-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
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
index be3d81ff51cc..a44e3427fdeb 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -84,6 +84,7 @@ static const struct of_device_id of_gpio_poweroff_match[] = {
 	{ .compatible = "gpio-poweroff", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_gpio_poweroff_match);
 
 static struct platform_driver gpio_poweroff_driver = {
 	.probe = gpio_poweroff_probe,
-- 
2.30.2

