Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D49395E8E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEaOAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhEaN6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53FB96193B;
        Mon, 31 May 2021 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468137;
        bh=40J/3GWj3gKLWslHKs2Yo2Y6QSbX0dqakuseEQRoHDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wk1aW+FJdvlX+S3Cfkk6lj5vkSiM9Z8l0ARatRytblvROUQ+f+PS5oLI9eIYvBiFl
         oPg6wvrOVJGe8L8y7ty+Ta77ZX6EUraO4UvZ2jI1OJVgryVMXH9iwmFL7z35JQ0usT
         HQvT4KIcf5onxAr0WvjAHeU7Z670se1w0HvMtQK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/252] gpio: cadence: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 31 May 2021 15:13:16 +0200
Message-Id: <20210531130702.460158818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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



