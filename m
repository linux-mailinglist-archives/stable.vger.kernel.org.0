Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D64838E915
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhEXOrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhEXOrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:47:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34505613BC;
        Mon, 24 May 2021 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867583;
        bh=40J/3GWj3gKLWslHKs2Yo2Y6QSbX0dqakuseEQRoHDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKPowABQVh0p23EoysxJmQN6vbdO1y34s8iGJnOU9vknZjkeJU/+uKE3oe6Jlhp+s
         aoWwIWUjA/5R1ZNN2M2c1D1oMYZkXzRxIiiost+gU+Y+Gi+zqStBa5Z4YZHqfiMFAO
         WPjkXOTG6t+Fxw6PNnHlEAjFFA3hBUyoDvctNiJfZZ5a8sKaO0MuwZ/B4JD1tsX0sy
         RdIdPLdjxlqbO0qyWcfyRNSiIg//D3DR7xAbtX5MBThE1kQPqXx96GzKSMg59/x1N4
         uYoanPYeiP4pn7W/HzxRi3yN8l8Guw5KmKBlcRGiQ8gkNeGxFj80fqW3FLWEGPJHvM
         Y9+WMpTBvLe6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 02/63] gpio: cadence: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 24 May 2021 10:45:19 -0400
Message-Id: <20210524144620.2497249-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

