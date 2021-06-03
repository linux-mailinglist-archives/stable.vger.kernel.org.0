Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B439A79A
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFCRL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232428AbhFCRLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C91F613FF;
        Thu,  3 Jun 2021 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740170;
        bh=/9WVnmVhkc1548IAmxcFZC35G4LhBlbFzeB7ta9aaqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVPyxYsrKbz8NBobATZuGtVuUITl92nBFZp0cyQ/fmVTpDDAWrKEGPhUbMrU2zqd2
         ZRwdh3N9n629TieTi9Y2kIqNzlYTqny5n/TGMKuIBl5SzDkYsAzsSRjI8BUBWP434w
         1Rlt/EbpLkz+VrtnH52PBxdwGsITQUeg59nJcsV8Vh/nkTcYpBpJTshR3UVn2byrtf
         SOTabpFKNULj1siYk+77IBYv8MKOsEXdmZViW79p0K/BiwYnLfsgxyJPKoccDNqCJF
         A6QkurbHLfGXdC06IKEVJgSq7xIF6QgNI5clVofjz/k1OwQ8lF+tgyWkQbo2N86Hmv
         /gpQT4x3IKzxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/31] spi: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:08:57 -0400
Message-Id: <20210603170919.3169112-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index c2bdf19ccdd2..44dc7b5b45ad 100644
--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -1066,6 +1066,7 @@ static const struct of_device_id sprd_spi_of_match[] = {
 	{ .compatible = "sprd,sc9860-spi", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, sprd_spi_of_match);
 
 static struct platform_driver sprd_spi_driver = {
 	.driver = {
-- 
2.30.2

