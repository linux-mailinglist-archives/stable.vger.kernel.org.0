Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A37B3A626C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhFNLAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhFNK53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9C46613D0;
        Mon, 14 Jun 2021 10:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667291;
        bh=f7+IsVAiTuk2fsnsSTO13i3VZaVGlWGF9fNo05lFuyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAn8lggHQXU1tScNQsjDBxKqh0LkQQMRi3CiRM1OGo/hJGd0iBolZdRHrRuyvu0Xe
         YUcmEiylTZQ625CkADxxqDHd3Z5c1hRDDXOR6dg5D6Q6xikxsKrpOnORiPSJTx1RIq
         yyS9fBhsxvyQMThKJVPVbbd1Jfve6IN0cSRs6/w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/131] spi: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:26:16 +0200
Message-Id: <20210614102653.514399369@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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



