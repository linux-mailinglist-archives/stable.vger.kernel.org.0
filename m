Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2E039A743
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhFCRKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231986AbhFCRKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FFC1613DE;
        Thu,  3 Jun 2021 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740127;
        bh=f7+IsVAiTuk2fsnsSTO13i3VZaVGlWGF9fNo05lFuyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cqe6jllRjFVZ3AEa6EeVNH+NjXep0ClU4zFPtxUi13pwKXKmJerdZQ3sK3BoaCKkW
         r3MVEY7UHjkXQWA2S1116EwohrrMnaOi0Av/miPEUq2RQq5IhNLjngWwo3YWW8dXN9
         XLopuO1Dct+2trjYTi1mb1xzfjXreJRA4TwsIei3FV58qte0t8KE+U2nAJ5qowfHCv
         wJSz0ZByP9OgJVNKgLkFdlu84Jfa+8CRFfXq8y/KCoTxOfD5DCTtXy7Tx4yLesuuWG
         tcddDnokbWijU/ocBqEJl7OIc5vv5C1U1m29wr9xKOAadf7kC3KZjnJRORnV5YZQ2+
         CtamOwO7HfFWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/39] spi: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:08:04 -0400
Message-Id: <20210603170829.3168708-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 7907cad7d07e0055789ec0c534452f19dfe1fc80 ]

MODULE_DEVICE_TABLE is used to extract the device information out of the
driver and builds a table when being compiled. If using this macro,
kernel can find the driver if available when the device is plugged in,
and then loads that driver and initializes the device.

Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20210512093534.243040-1-zhang.lyra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-sprd.c b/drivers/spi/spi-sprd.c
index b41a75749b49..28e70db9bbba 100644
--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -1068,6 +1068,7 @@ static const struct of_device_id sprd_spi_of_match[] = {
 	{ .compatible = "sprd,sc9860-spi", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, sprd_spi_of_match);
 
 static struct platform_driver sprd_spi_driver = {
 	.driver = {
-- 
2.30.2

