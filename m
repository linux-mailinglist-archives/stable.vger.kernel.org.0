Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7A38EBBE
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhEXPHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234185AbhEXPDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749E061468;
        Mon, 24 May 2021 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867834;
        bh=JLDGTu68OpqtermzXDKlM9QcZM45cG7aT6hEH5ocqvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxAKpKvcm+p3QiIEbblTEOKLW02MQdvR7npRNt792x4ifcXfHNfyjro9Qh8aXJTUh
         c0i8JYGQQfyLtTBhGWbsS13InnM74XFQcrTSoPX4ngZdSthGPM17FR92nWH2yyZlzV
         Jt4bmrs+TJMRorp4fyT9sTnkfsimdd+/7fZyiRQpLwQUZ5sjrZLD7iCQf2qBtJ13Uq
         tQZBeWsD0L/Jsk69Djs2JgMorhkQwfjXbHh/h27Z4DX7ELSljfTTEOHCIDvfgsfxLs
         riImN0IR30ufrNKU1U32naGPeba/U40jF00qJ7Ce4XFlryb+KrhqPtl7c7OZJqH39m
         k5P5tQ+1ivVDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/25] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 24 May 2021 10:50:04 -0400
Message-Id: <20210524145008.2499049-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bc1eca606d8084465e6f89fd646cc71defbad490 ]

The intel_punit_ipc driver might be compiled as a module.
When udev handles the event of the devices appearing
the intel_punit_ipc module is missing.

Append MODULE_DEVICE_TABLE for ACPI case to fix the loading issue.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210519101521.79338-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_punit_ipc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_punit_ipc.c b/drivers/platform/x86/intel_punit_ipc.c
index 2efeab650345..d6a7039a0591 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -331,6 +331,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2

