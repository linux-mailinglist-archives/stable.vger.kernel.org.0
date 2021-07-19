Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649213CE0F9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347307AbhGSPTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347057AbhGSPPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01A58606A5;
        Mon, 19 Jul 2021 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710170;
        bh=JgL551oFfxdmH9y/atJVWQ9IvGlZp0b9DjZZSGo8qz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgzBtjdY51ABYgQFU04fFSClW4OP5PqNku8s4QI8dcjL0RtyVKGO+rcobCok+hSux
         6wg5x7K44QFy+PYLWeoy760/e3yUu1ArMCgQK0WEx60vqwz0+8ggt/WF4Jb0pUYO2v
         1R1aNQIBfUGFIZA0Xgn1Q9Dxl0EPAHE56oO7kQYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/243] leds: turris-omnia: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:13 +0200
Message-Id: <20210719144944.259719781@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 9d0150db97583cfbb6b44cbe02241a1a48f90210 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 880fc8def530..ec87a958f151 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -277,6 +277,7 @@ static const struct i2c_device_id omnia_id[] = {
 	{ "omnia", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, omnia_id);
 
 static struct i2c_driver omnia_leds_driver = {
 	.probe		= omnia_leds_probe,
-- 
2.30.2



