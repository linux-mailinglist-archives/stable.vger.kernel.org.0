Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5665B3CDA34
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbhGSOfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244014AbhGSOcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:32:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 943126121E;
        Mon, 19 Jul 2021 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707571;
        bh=vGFioSWvtRgICLzoYPoDXxpPQu2d3N5bConmOJySD3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfWigAsIFOrTl500CZnH3ZFu+uGSgcePumXzaoTx3aqtBRl883FpTLWPAHrOnnIr+
         u4TYwxI2pCeeYZOlzKDE6BESH2dg0gLaEr4Zx4oQHxFXbZRSSeJfwwOf00ImA4bO8J
         4mXl/IJ5K02ouC1M2gNnsgLAUeaFp9HcVx3kB/2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 210/245] power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:32 +0200
Message-Id: <20210719144947.189085340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



