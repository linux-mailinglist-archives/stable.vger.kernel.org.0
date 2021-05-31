Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C12396066
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhEaOZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhEaOXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DEE561A06;
        Mon, 31 May 2021 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468752;
        bh=40J/3GWj3gKLWslHKs2Yo2Y6QSbX0dqakuseEQRoHDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h08X/rRvkiPNca1fKZJ/1aqAOiVMEzDBxjcwt5KVw8YaTXGNLrbwNS3IDb7nLsYKs
         xXtmcDklmMqpvNuCHRdBtuR8yLXZ0nZa8mBnSBUegK6pCFodHZT9v/oOBYNr8HkNJx
         7aeXJq47GNHr8RwoovATjQyrh+2ZOV3QKA0CY/sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/177] gpio: cadence: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 31 May 2021 15:14:04 +0200
Message-Id: <20210531130650.898758766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1e948b1752b58c9c570989ab29ceef5b38fdccda ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-cadence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-cadence.c b/drivers/gpio/gpio-cadence.c
index a4d3239d2594..4ab3fcd9b9ba 100644
--- a/drivers/gpio/gpio-cadence.c
+++ b/drivers/gpio/gpio-cadence.c
@@ -278,6 +278,7 @@ static const struct of_device_id cdns_of_ids[] = {
 	{ .compatible = "cdns,gpio-r1p02" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, cdns_of_ids);
 
 static struct platform_driver cdns_gpio_driver = {
 	.driver = {
-- 
2.30.2



