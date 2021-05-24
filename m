Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EAB38EA07
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhEXOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233485AbhEXOuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D3C61406;
        Mon, 24 May 2021 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867667;
        bh=40J/3GWj3gKLWslHKs2Yo2Y6QSbX0dqakuseEQRoHDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7caE7byj2+1x3fdWDH5d3g7dEMGirPmlc97sQnvgDlb5kr6Y9Xd4p1CG/T3x79Zb
         AkW4radanYpkNb0OGc/In1Smm3cOUDwwJJTbOBmw2ndNgbNDpb42QEfprjMdsPgSCr
         OmEGedOW/W4Wml0a0XHnnHxbAH9O2ElpdkxTfFxaxW9w0/Pm+2GFMDfdh/MPWn+FxL
         igN17Z2HxYHDcBDqHSsXi4LIWBuIqAM7TUV7HWZhf77mdqXXuObVjrXmrBFx4RRY33
         nN02PVCrWuX/R4CkHnYfbi4XxxhzXijMMcgrmr7w7x5C4ZdEtBJbtvihUVFFVHoCAg
         SpwFzWfr7dqAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/62] gpio: cadence: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 24 May 2021 10:46:43 -0400
Message-Id: <20210524144744.2497894-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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

