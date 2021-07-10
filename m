Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48C13C2F56
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhGJCbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbhGJC30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394DE613F8;
        Sat, 10 Jul 2021 02:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883987;
        bh=PIdH4y8f3X9A2AP25GCCZEy7yKFv7zIOPSRZxeVfm6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5E54xChUnJBwTBaRETOygGavYcgiXNCmro71MsHKm3hwsF4y4SbHhOIzSL9MgdhN
         XF4S8OD5a+c0JYwFd4nlAGwta70cFRHc25A3n1wFdt3rKB/Y+BCNflbw6dxNPYW/ju
         sRQ3DKlCreEVmhBRzW7DDcYxVl1jMtkx0mLcORiwtunn0541l1KLlGC3j1OSTNpU6n
         GyCrKvaNvvrFOt8M+U9L9hRlSPxUgoFC40X1i1hSvXY2clZjchAQDjx4ybKtuPSUuR
         JyvxQwqpz38U/OHhCTDuth5ITgQDgMwE5QfWPZH0NZIYwCRC33qxXT6asmzjQPyVVy
         5/OW4yp2tBQGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 64/93] gpio: pca953x: Add support for the On Semi pca9655
Date:   Fri,  9 Jul 2021 22:23:58 -0400
Message-Id: <20210710022428.3169839-64-sashal@kernel.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 6d49b3a0f351925b5ea5047166c112b7590b918a ]

The On Semi pca9655 is a 16 bit variant of the On Semi pca9654 GPIO
expander, with 16 GPIOs and interrupt functionality.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
[Bartosz: fixed indentation as noted by Andy]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 6898c27f71f8..7cc7d137133a 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1239,6 +1239,7 @@ static const struct of_device_id pca953x_dt_ids[] = {
 
 	{ .compatible = "onnn,cat9554", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "onnn,pca9654", .data = OF_953X( 8, PCA_INT), },
+	{ .compatible = "onnn,pca9655", .data = OF_953X(16, PCA_INT), },
 
 	{ .compatible = "exar,xra1202", .data = OF_953X( 8, 0), },
 	{ }
-- 
2.30.2

