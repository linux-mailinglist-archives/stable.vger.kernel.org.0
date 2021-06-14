Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6C3A61A3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhFNKt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233018AbhFNKr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:47:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A936E61455;
        Mon, 14 Jun 2021 10:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667051;
        bh=/9WVnmVhkc1548IAmxcFZC35G4LhBlbFzeB7ta9aaqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWk4CD+6AiORjlsCKaCf5IaTeCd0ONUF4hrthXl4Y3VqwtoenyK29IgA6WkP8LW3Q
         wWSfbj+POg1ZTqmSNawGnhORfrZZhRVOeBpB5Qu0CNHIhYZXiGHr/UeondGipOVLP4
         KK1oaKmzRpby1ZlTJCLym2bO/KPtvzdQVoJ1y/o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/84] spi: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:26:48 +0200
Message-Id: <20210614102646.702529137@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



