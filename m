Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB538E9D2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhEXOvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233671AbhEXOt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8040613F6;
        Mon, 24 May 2021 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867649;
        bh=EQuL5AWD/fApjp0/wL1bMQy/0dIiryBUxf0x/fpQz9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyeqcAc+TGxiNoM4dL6AZoUnEfiiLi/01rwCEA+9LClUll4Er4TVfYKBmPF+Ig2Oa
         TEMzrLd3u7bOt0mjWTuMQHHMeYVCioga8xqTg8e83qXNXdjxSeb5DveM9d+xgCzGpN
         6vQo16u4E5/kF/hxZ/HKq8V1fl7yUn9MUpnC5Hj/+xYdDAyiHdXGQ7Rw93bMz0HjPl
         IQ2Gd+sFHO5tPkAY5yimM9w51RizFThavI26bHT5gGH7QHTQ7q7dAOqVTALWEqoGJA
         /bL4YBuI5A3cnz8BKlLcM1kpTmseXshygddJSbw5yX5KLNidxcAlUwOwdUh5FFHUGX
         3ojACYaR1ChKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 53/63] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 24 May 2021 10:46:10 -0400
Message-Id: <20210524144620.2497249-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 05cced59e251..f58b8543f6ac 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -312,6 +312,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2

