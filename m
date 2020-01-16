Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368F113E143
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgAPQsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgAPQsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C1220663;
        Thu, 16 Jan 2020 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193304;
        bh=AmWo+liNG81NoGv2cQFWagdPVrvxxbqAsN7zg28/WJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPofgXN6Ku9HHlw8K1MxchZVgJnUycv3uw60vmmpvHbIpLjo4BNfNoQw8oK1ByPxr
         ZiIpkueyBpzHnhstgDVlVsRNt/8m4A3/qf+qXDcCH6hzQeqg/XkmMh3DeFjDSlwu2F
         pqy0I+D4W/bB8DYd+gC2I25GhZirbvomwI+kIelk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 070/205] power: supply: bd70528: Add MODULE_ALIAS to allow module auto loading
Date:   Thu, 16 Jan 2020 11:40:45 -0500
Message-Id: <20200116164300.6705-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 9480029fe5c24d482efad38dc631bd555fc7afe2 ]

The bd70528 charger driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell for
charger is added.

Fixes: f8c7f7ddd8ef0 ("power: supply: Initial support for ROHM BD70528 PMIC charger block")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd70528-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/bd70528-charger.c b/drivers/power/supply/bd70528-charger.c
index 1bb32b7226d7..b8e1ec106627 100644
--- a/drivers/power/supply/bd70528-charger.c
+++ b/drivers/power/supply/bd70528-charger.c
@@ -741,3 +741,4 @@ module_platform_driver(bd70528_power);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 power-supply driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bd70528-power");
-- 
2.20.1

