Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E4338EC2F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhEXPMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235006AbhEXPFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3E2361584;
        Mon, 24 May 2021 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867863;
        bh=GvlQdk9QCCLzZXEPL977abyqEv1/ZvCdrDypFc/1g1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuydetMmhvVRo3sxS+Z98kB9wqlV/0U7g/N5ExmaHgJPVDxRM2MIkSZ7uRhBw1lL7
         8UtYwgdS8tTficgAEFevxIwcb08HTwRY7wgw50ars/r9faCpiPo19caucbzqbjtIIY
         0W7SssD5CYMi5A8PmFpG8Genb7VP7iIa8wG6U/8ZaeFlEILYOwKqptXhPy3EjR05/a
         5nsI2S4qdD3jpI7bPThpcTtmCJnT5ptlNGKf+/CJTzHcFaQSJP8xd3YC92GI+b9Iy2
         NFCL0ziykRM+PTeMG1/AbPPPWsdnSiXH5pg4tpdF01Pxddj3BQAr55mIaoQhh0GBrl
         ZRT8ZxfEqba9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/21] platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI
Date:   Mon, 24 May 2021 10:50:38 -0400
Message-Id: <20210524145040.2499322-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index b7dfe06261f1..9865d11eda75 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -330,6 +330,7 @@ static const struct acpi_device_id punit_ipc_acpi_ids[] = {
 	{ "INT34D4", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, punit_ipc_acpi_ids);
 
 static struct platform_driver intel_punit_ipc_driver = {
 	.probe = intel_punit_ipc_probe,
-- 
2.30.2

